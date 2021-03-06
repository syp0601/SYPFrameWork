//
//  YPTableViewLoadMoreCell.m
//  SYPFrameWork
//
//  Created by sunyuping on 13-1-8.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#define TT_ROW_HEIGHT                 44.0f

#import "YPTableViewLoadMoreCell.h"
#import "YPTableViewLoadMoreItem.h"

static const CGFloat kMoreButtonMargin = 40;

@interface YPTableViewLoadMoreCell()

- (void)buildLoadingAnimationView;
- (void)buildTitleLabel;

@end

@implementation YPTableViewLoadMoreCell

@synthesize animating = _animating;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
  return  TT_ROW_HEIGHT * 1.5;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _animating = NO;

        [self buildTitleLabel];        
        [self buildLoadingAnimationView];
        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.accessoryType = UITableViewCellAccessoryNone;

    }
	return self;
}

- (void)dealloc
{
    YPRelease(_titleLabel);
    YPRelease(_loadingAnimationView);
    [super dealloc];
}

- (void)setAnimating:(BOOL)animating {
	_animating = animating;
	if (animating) {
		[_loadingAnimationView startAnimating];
	} else {
		[_loadingAnimationView stopAnimating];
	}
}

- (void)objectPropertyChanged:(NSString *)property {
   if([property isEqualToString:@"isLoading"]){
       YPTableViewLoadMoreItem *item = self.object;
       self.animating		= item.isLoading;
   }
}

- (void)startObserveObjectProperty {
    [self addObservedProperty:@"isLoading"];
}

- (void)finishObserveObjectProperty {
    [self removeObservedProperty:@"isLoading"];
}


#pragma mark- Override
- (void)layoutSubviews {
	[super layoutSubviews];

	_loadingAnimationView.left	= kMoreButtonMargin - (_loadingAnimationView.width + 6);
	_loadingAnimationView.top	= floor(self.contentView.height / 2 - _loadingAnimationView.height / 2);

	_titleLabel.frame = CGRectMake(kMoreButtonMargin,
			_titleLabel.top,
			self.contentView.width - (kMoreButtonMargin + 6),
			_titleLabel.height);
    
}

- (void)setObject:(id)object
{
	if (_object != object) {
		[super setObject:object];

		if (_object) {
			YPTableViewLoadMoreItem *item = _object;
			_titleLabel.text	= item.title;
			self.animating		= item.isLoading;
            [self.contentView setBackgroundColor:[UIColor clearColor]];

		}
	}
}

#pragma mark- UI
- (void)buildLoadingAnimationView
{
	_loadingAnimationView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[self.contentView addSubview:_loadingAnimationView];
}

- (void)resetLoadingAnimationView:(UIActivityIndicatorView*)loadingView
{
    if (_loadingAnimationView != nil) {
        [_loadingAnimationView removeFromSuperview];
        [_loadingAnimationView release];
    }
    _loadingAnimationView = [loadingView retain];
	[self.contentView addSubview:_loadingAnimationView];
}

- (void)buildTitleLabel
{
	_titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    _titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.autoresizingMask			= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_titleLabel.font						= [UIFont boldSystemFontOfSize:15];
	_titleLabel.textColor					= [UIColor blackColor];
	_titleLabel.highlightedTextColor		= [UIColor whiteColor];
	_titleLabel.textAlignment				= UITextAlignmentLeft;
	_titleLabel.lineBreakMode				= UILineBreakModeTailTruncation;
	_titleLabel.adjustsFontSizeToFitWidth	= YES;
//    [_titleLabel setTextColor:[UIColor colorForKey:@"colorOfRefreshHeaderLabel"]];
//    [_titleLabel setShadowColor:[UIColor colorForKey:@"colorOfRefreshHeaderLabelShadow"]];
    
    [self.contentView addSubview:_titleLabel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
}
- (void)drawRect:(CGRect)rect {
    
    //分割线
    UIColor *lineColor = [[UIColor colorForKey:@"CommonModule-colorTypeC"] colorWithAlphaComponent:0.3];
    [lineColor setFill];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, CGRectMake(10, self.height - 1, self.width-20, 1));
}
@end
