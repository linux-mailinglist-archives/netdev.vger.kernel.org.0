Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7463B3F8001
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 03:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbhHZBpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 21:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229514AbhHZBpj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 21:45:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88DA8610A4;
        Thu, 26 Aug 2021 01:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629942292;
        bh=1yb1Nwgv/CdKYJlvLotRx+OYpcXARKHuioPAqkzTubA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IGUoWPET7PG9yZ7uZsjyqihYCTW1hbT7QyF3ZbpuP+XAYxaTdbAVk/G3teBV6qS1E
         DJaEPWlh0xBiYIAVhBrzUigSr2FXCx6yUdpgTIXqb9PrbL/o3W4lEGEwZe4AEQN2HA
         e7ijrky76nMUWju3RDMDPw1oX4E+V5luwAGb6cU1cV2eRRfWXZ8lQGR/fY43VlinHk
         bRs6VXwYBjLe0o/t8M0Zgi5OmuzVBcv/rvPxt4te6QqgmEU/klrSOA9WFg0uTn1nt8
         IrCx9FnOyxMk2nECbLwfJqSl2aHxQYA4WctZOj6G5bFJBsqrvHJnCims/j5Ma/EaBo
         AGceoLFeRRoIg==
Date:   Wed, 25 Aug 2021 18:44:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     michael.chan@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] bnxt: count discards due to memory
 allocation errors
Message-ID: <20210825184451.2cf343c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210826004208.porufhkzwtc3zgny@skbuf>
References: <20210825231830.2748915-1-kuba@kernel.org>
        <20210825231830.2748915-4-kuba@kernel.org>
        <20210826002257.yffn4cf2dtyr23q3@skbuf>
        <20210825173537.19351263@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210826004208.porufhkzwtc3zgny@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Aug 2021 03:42:08 +0300 Vladimir Oltean wrote:
> On Wed, Aug 25, 2021 at 05:35:37PM -0700, Jakub Kicinski wrote:
> > On Thu, 26 Aug 2021 03:22:57 +0300 Vladimir Oltean wrote:  
> > > 'Could you consider adding "driver" stats under RTM_GETSTATS,
> > > or a similar new structured interface over ethtool?
> > >
> > > Looks like the statistic in question has pretty clear semantics,
> > > and may be more broadly useful.'  
> >
> > It's commonly reported per ring, I need for make a home for these
> > first by adding that damn netlink queue API. It's my next project.
> >
> > I can drop the ethtool stat from this patch if you have a strong
> > preference.  
> 
> I don't have any strong preference, far from it. What would you do if
> you were reviewing somebody else's patch which made the same change?

If someone else posted this patch I'd probably not complain, as I said
there is no well suited API, and my knee jerk expectation was it should
be reported in the per-queue API which doesn't exist.

When you'd seem me complain is when drivers expose in -S stats which
have proper APIs or when higher layer/common code is trying to piggy
back on -S instead of creating its own structured interface.

I don't see value in tracking this particular statistic in production
settings, maybe that's also affecting my judgment here. But since
that's the case I'll just drop it.


If you have any feedback on my suggestions, reviews, comments etc.
please do share on- or off-list at any time. No need to wait a year
until I post a vaguely similar patch ;)
