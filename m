Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63D043BAD3
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238749AbhJZTcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:32:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237035AbhJZTcv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 15:32:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C393860F39;
        Tue, 26 Oct 2021 19:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635276627;
        bh=bOwO8Sa/kL0hdYVpHz8UOKXMdhBoAOuuSMYGNOyio1c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V2B0g/1dzYST1mP0xRlEqaXKXTZ7GkmF7qRPX1PV77JseNDaSBY/yqY6lRtZDW2s7
         aHhKxthZe1qqZFvHF5AFTQp2POu15Jvm4yiE3wYwK2w8Sc1vXejUUwQh10dguzSZ0P
         +Fn4mtJVbUobP228GKJttmijdELfktKlPW9cTVH7CkwjNQSGicXnCLEjfHy27JfV82
         tlurBo1IInWrCf1Ceh7WbUXkwb7D+RsdI2rl6d+EwbaWdqCunLgGophcq48NCeEiXb
         kkZb1blghDOMwZbN+ASGJTtdc8ap5/XMpPEUpKqwuGFaWOeuuq+/0wqh8vXQDixd7f
         oHsjSn7EjkWCg==
Date:   Tue, 26 Oct 2021 22:30:23 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink
 traps on probe/remove device
Message-ID: <YXhXT/u9bFADwEIo@unreal>
References: <YXUtbOpjmmWr71dU@unreal>
 <YXU5+XLhQ9zkBGNY@shredder>
 <YXZB/3+IR6I0b2xE@unreal>
 <YXZl4Gmq6DYSdDM3@shredder>
 <YXaNUQv8RwDc0lif@unreal>
 <YXelYVqeqyVJ5HLc@shredder>
 <YXertDP8ouVbdnUt@unreal>
 <YXgMK2NKiiVYJhLl@shredder>
 <YXgpgr/BFpbdMLJp@unreal>
 <20211026120234.3408fbcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026120234.3408fbcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 12:02:34PM -0700, Jakub Kicinski wrote:
> On Tue, 26 Oct 2021 19:14:58 +0300 Leon Romanovsky wrote:
> > > By now I have spent more time arguing with you than you spent testing
> > > your patches and it's clear this discussion is not going anywhere.
> > > 
> > > Are you going to send a revert or I will? This is the fourth time I'm
> > > asking you.  
> > 
> > I understand your temptation to send revert, at the end it is the
> > easiest solution. However, I prefer to finish this discussion with
> > decision on how the end result in mlxsw will look like.
> > 
> > Let's hear Jiri and Jakub before we are rushing to revert something that
> > is correct in my opinion. We have whole week till merge window, and
> > revert takes less than 5 minutes, so no need to rush and do it before
> > direction is clear.
> 
> Having drivers in a broken state will not be conducive to calm discussions.
> Let's do a quick revert and unbreak the selftests.

No problem, I'll send a revert now, but what is your take on the direction?
IMHO, the mlxsw layering should be fixed. All this recursive devlink re-entry
looks horrible and adds unneeded complexity.

> 
> Speaking under correction, but the model of operation where we merge
> patches rather quickly necessarily must also mean we are quick to
> revert changes which broke stuff if the fix is not immediately obvious
> or disputed.
