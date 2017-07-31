//
//  UITabBarController+HideTabBar.m
//
//  Created by Joshua Greene on 9/26/13.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UITabBarController+HideTabBar.h"

@implementation UITabBarController (HideTabBar)

- (void)setTabBarHidden:(BOOL)hidden
{
    [self setTabBarHidden:hidden animated:YES];
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (self.tabBar.hidden == hidden)
        return;
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    BOOL isLandscape = UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    float height =  isLandscape ? screenSize.width : screenSize.height;
    
    if (!hidden)
        height -= CGRectGetHeight(self.tabBar.frame);
    
    void (^animations)();
    
    // Check if running iOS 7
        if ([self.tabBar respondsToSelector:@selector(barTintColor)])
    {
        UIView *view = self.selectedViewController.view;
        
        animations = ^{
          
            CGRect frame = self.tabBar.frame;
            frame.origin.y = height;
            self.tabBar.frame = frame;
            
            frame = view.frame;
            frame.size.height += (hidden ? 1.0f : -1.0f) * CGRectGetHeight(self.tabBar.frame);
            view.frame = frame;
        };
    }
    else
    {
        animations = ^{
            for (UIView *subview in self.view.subviews)
            {
                CGRect frame = subview.frame;
                
                if (subview == self.tabBar)
                {
                    frame.origin.y = height;
                }
                else
                {
                    frame.size.height = height;
                }
                
                subview.frame = frame;
            }
        };
    }
    
    [UIView animateWithDuration:(animated ? 0.25f : 0) animations:animations completion:^(BOOL finished) {
        self.tabBar.hidden = hidden;
    }];
}

@end