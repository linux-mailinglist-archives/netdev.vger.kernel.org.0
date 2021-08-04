Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BDA3E008B
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 13:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237904AbhHDLxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 07:53:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233537AbhHDLxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 07:53:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E55A060F10;
        Wed,  4 Aug 2021 11:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628077968;
        bh=7zpb+pibAMZH+4nQIHSW9yf8pVm965xNj1RwFSz2U78=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=igMDF0C+FglLKfVoUR2RP89cc0RE/iHqpZIL2ptOQiqBJwS0cUOzjQNGn0myCy2Qh
         CGG3hqWQ+H2IWey1y+ySzvjQW0LySp2GRZoOGrH2TZ1jwHLoxnkgrbsdXPbS93BdVd
         6Qk3X8Wr9E8bJUiyqDlzrnt1Hj1Dj4v2HM6wyL1j1JpJxuD5kaG2/nbEedfcX61dtW
         ZywI5102pdQwh+tWqI3DOfT4nApVB4w78/oeY+4TKJtte52TdZT2zx/rLSFWJhi24Y
         ELtIUPa7x/Mp87aKkVVbDvweXZjJYpYwR+ude+PLCrRf/D6jTNzbRVoh9mlrB+27kj
         SrK+msWdDRXCQ==
Date:   Wed, 4 Aug 2021 04:52:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next] Revert "netdevsim: Add multi-queue support"
Message-ID: <20210804045247.057c5e9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YQo+XJQNAP7jnGw0@unreal>
References: <20210803123921.2374485-1-kuba@kernel.org>
        <CAM_iQpUS_hNAb_-NmbcywyERwYp06ebJqv5Ve__okY6755-F=w@mail.gmail.com>
        <20210803141839.79e99e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAM_iQpV07aWSt5Jf-zSv6Qh4ydrJMYw54X3Seb8-eKGOpBYX7A@mail.gmail.com>
        <20210803145124.71a8aab4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YQo+XJQNAP7jnGw0@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Aug 2021 10:14:36 +0300 Leon Romanovsky wrote:
> On Tue, Aug 03, 2021 at 02:51:24PM -0700, Jakub Kicinski wrote:
> > On Tue, 3 Aug 2021 14:32:19 -0700 Cong Wang wrote:  
> > > On Tue, Aug 3, 2021 at 2:18 PM Jakub Kicinski <kuba@kernel.org> wrote:  
> 
> <...>
> 
> > > Please remove all those not covered by upstream tests just to be fair??  
> > 
> > I'd love to remove all test harnesses upstream which are not used by
> > upstream tests, sure :)  
> 
> Jakub,
> 
> Something related and unrelated at the same time.
> 
> I need to get rid of devlink_reload_enable()/_disable() to fix some
> panics in the devlink reload flow.
> 
> Such change is relatively easy for the HW drivers, but not so for the
> netdevism due to attempt to synchronize sysfs with devlink.
> 
>   200         mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
>   201         devlink_reload_disable(devlink);
>   202         ret = nsim_dev_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
>   203         devlink_reload_enable(devlink);
>   204         mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
> 
> Are these sysfs files declared as UAPI? Or can I update upstream test
> suite and delete them safely?

You can change netdevsim in whatever way is appropriate.

What's your plan, tho? Jiri changed the spawning from rtnetlink 
to sysfs - may be good to consult with him before typing too much 
code.
