Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F16402A03
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 15:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344797AbhIGNps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 09:45:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59372 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344269AbhIGNpr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 09:45:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=B7Z2Hp4psPJjkAd1T3DsxGWaTveEV56D2pW82c6wQ5w=; b=u+BY5UwVJZoBV+EtekNUnwjL4W
        6Cis7LsEXBmzBVfDSiNlIO9SPBp00jDwlvtQ+cUoJYokCqPf2B/Zel1PP1czkZBP28YtmypaNjMC2
        TUStTTXNhxndlxk1v4JzlVqE1+IWcAyJhrsBrFpY5T6SzUOOuTlc/xkG5HY2fsQK33Nk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mNbOq-005eE4-DY; Tue, 07 Sep 2021 15:44:32 +0200
Date:   Tue, 7 Sep 2021 15:44:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        patchwork-bot+netdevbpf@kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, rafal@milecki.pl
Subject: Re: [PATCH] net: dsa: b53: Fix IMP port setup on BCM5301x
Message-ID: <YTdswC0SvBWExoVk@lunn.ch>
References: <20210905172328.26281-1-zajec5@gmail.com>
 <163086540526.12372.2831878860317230975.git-patchwork-notify@kernel.org>
 <5de7487c-4ffe-bca4-f9a3-e437fc63926b@gmail.com>
 <YTVlYqzeKckGfqu0@lunn.ch>
 <20210906184838.2ebf3dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906184838.2ebf3dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 06, 2021 at 06:48:38PM -0700, Jakub Kicinski wrote:
> On Mon, 6 Sep 2021 02:48:34 +0200 Andrew Lunn wrote:
> > > not allowing a proper review to happen. So please, I am begging you, wait at
> > > least 12h, ideally 24h before applying a patch.  
> 
> The fixed wait time before applying would likely require more nuance.
> For example something like 0h for build fixed; 12h if reviewed by all
> area experts; 24h+ for the rest? Not counting weekends?
> 
> > 24 hours is too short. We all have lives outside of the kernel. I
> > found the older policy of 3 days worked well. Enough time for those
> > who had interest to do a review, but short enough to not really slow
> > down development. And 3 days is still probably faster than any other
> > subsystem.
> 
> It is deeply unsatisfying tho to be waiting for reviews 3 days, ping
> people and then have to apply the patch anyway based on one's own
> judgment.

I would skip the ping bit and just apply it. Unless you really think
it needs a deep review.

> Right now we make some attempts to delegate to "Needs ACK" state but
> with mixed result (see the two patches hanging in that state now).
> 
> Perhaps the "Plan to review" marking in pw is also putting the cart
> before the horse.

For me personally, the reason i like three days is that sometimes i'm
away in the wilderness, visiting friends, away on business, etc. I'm
not checking emails. So having to take some sort of action to say i'm
not going to take any action until later, just defeaters the point.

> Either way if we're expending brain cycles on process changes it would
> be cool to think more broadly than just "how long to set a timer for".

One observation is that netdev drivers are very siloed. A vendor
driver rarely gets reviewed by another vendor. I think reviews are
mostly made by vendor neutral people, and they look for specific
things. I'm interested in phy, ethtool, and anything which looks like
it could be adding a new KAPI of some sort. There are people who
trigger on the keyword XDP, or BPF, devlink etc. Some areas of netdev
do tend to get more reviews than others. Again, my areas of interest,
phys, DSA, ethtool. The core stack gets reviewed by Eric, routing by
David, and i'm sure there are others in parts i don't take an interest
and i've not noticed.

If a patch is from somebody who is not the maintainer of a siloed
driver, and the maintainer is active, then a review is more likely to
happen.

So some sort of model could be made of this, to predict if a patchset
is likely to get reviewed, if time is allowed for the reviewer to
actually do the review. I don't know if a mental model is sufficient,
for the two people who are merging patches, or some tools could be
produced to help a little. Maybe just simple things like, is the
poster of the patch series the maintain of the driver it applies
to. Maybe some keyword matching? Maybe Sasha Levin can run a machine
learning system over the last few years of the netdev archive to train
a model which will product if a patchset will get reviewed? That would
be applicable outside of netdev, it could be a useful feature in
general. Maybe it is a research project Julia Lawall at Inria could
give to a PhD student?

  Andrew
