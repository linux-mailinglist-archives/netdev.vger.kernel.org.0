Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B251A747B
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 09:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406492AbgDNHQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 03:16:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406487AbgDNHQ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 03:16:27 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81EE420575;
        Tue, 14 Apr 2020 07:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586848586;
        bh=r7bEPKJJdbev5LU/fgYxUjg1WQaPaPHzf7ULe0z7Nr4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2rINJUGb7ilCBKfeCJdRFdMRrv7OIAWdkwwde0lrE9Mzp6SHDfaXWapHi/n+8hxV7
         HMjb/fuWVh+YNBbWwN3aWaOjaxTLk+R7Q4jb8ByTBjWyyQSKM+fvpoJg4Mwj94jZXU
         fvysPqwEGg9TkDAwrUxTn3M7etrcdRTChxKBhLXA=
Date:   Tue, 14 Apr 2020 10:16:22 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200414071622.GT334007@unreal>
References: <20200411231413.26911-1-sashal@kernel.org>
 <20200411231413.26911-9-sashal@kernel.org>
 <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
 <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200414015627.GA1068@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414015627.GA1068@sasha-vm>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 09:56:28PM -0400, Sasha Levin wrote:
> On Sun, Apr 12, 2020 at 10:59:35AM -0700, Jakub Kicinski wrote:
> > On Sun, 12 Apr 2020 10:10:22 +0300 Or Gerlitz wrote:
> > > On Sun, Apr 12, 2020 at 2:16 AM Sasha Levin <sashal@kernel.org> wrote:
> > >
> > > > [ Upstream commit 6783e8b29f636383af293a55336f036bc7ad5619 ]
> > >
> > > Sasha,
> > >
> > > This was pushed to net-next without a fixes tag, and there're probably
> > > reasons for that.
> > > As you can see the possible null deref is not even reproducible without another
> > > patch which for itself was also net-next and not net one.
> > >
> > > If a team is not pushing patch to net nor putting a fixes that, I
> > > don't think it's correct
>
> While it's great that you're putting the effort into adding a fixes tag
> to your commits, I'm not sure what a fixes tag has to do with inclusion
> in a stable tree.
>
> It's a great help when we look into queueing something up, but on it's
> own it doesn't imply anything.
>
> > > to go and pick that into stable and from there to customer production kernels.
>
> This mail is your two week warning that this patch might get queued to
> stable, nothing was actually queued just yet.
>
> > > Alsom, I am not sure what's the idea behind the auto-selection concept, e.g for
> > > mlx5 the maintainer is specifically pointing which patches should go
> > > to stable and
>
> I'm curious, how does this process work? Is it on a mailing list
> somewhere?

Saeed asks from Dave explicitly to pick commits to stable@.
https://lore.kernel.org/netdev/20200408225124.883292-1-saeedm@mellanox.com/

>
> > > to what releases there and this is done with care and thinking ahead, why do we
> > > want to add on that? and why this can be something which is just
> > > automatic selection?
> > >
> > > We have customers running production system with LTS 4.4.x and 4.9.y (along with
> > > 4.14.z and 4.19.w) kernels, we put lots of care thinking if/what
> > > should go there, I don't
> > > see a benefit from adding auto-selection, the converse.
> >
> > FWIW I had the same thoughts about the nfp driver, and I indicated to
> > Sasha to skip it in the auto selection, which AFAICT worked nicely.
> >
> > Maybe we should communicate more clearly that maintainers who carefully
> > select patches for stable should opt out of auto-selection?
>
> I've added drivers/net/ethernet/mellanox/ to my blacklist for auto
> selection. It's very easy to opt out, just ask... I've never argued with
> anyone around this - the maintainers of any given subsystem know about
> it way better than me.

I was under impression that all netdev commits are excluded.

Thanks

>
> --
> Thanks,
> Sasha
