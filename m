Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CF3427491
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 02:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243961AbhJIAPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 20:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243818AbhJIAPw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 20:15:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 678AF60FC2;
        Sat,  9 Oct 2021 00:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633738436;
        bh=eViGypOI8z4Rs+nCf3qR3T0LRi3rotOz+hzh5xGDRe8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XXeiNhycylzGlcpdUnnGjGWCvoUOJGKgSNM7ROBiAA+ei2jMklX8+YXxoNWf7/j3k
         0kiOZdWBq5dzMZEy8NIZ+YwecT4MV0iSAIeor/KYHdpGbwqyBu/Rr++1SV0eOn5jgF
         NIl/YDbhB2DSgr5M+4zVGdW3rBLyPnqZ3gWyMXrnnp0cZXVZsbkMGiwl/34KovfZ0y
         /9thPDB8nPD+veXipm2tq5MjQCmNwYknZeVhFMNKnRVT4mMbESq+2PetsV7l/MoMZs
         3fKvBK+4uTpls1R3tbeWGupr7PizBWqDa5nalM043Tbbm+eMRgbT83QgxrPF2KXoqR
         d2hXYNwWf24bw==
Date:   Fri, 8 Oct 2021 17:13:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net PATCH 1/2] drivers: net: phy: at803x: fix resume for
 QCA8327 phy
Message-ID: <20211008171355.74ea6295@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YWDZPfWOe+C2abWz@Ansuel-xps.localdomain>
References: <20211008233426.1088-1-ansuelsmth@gmail.com>
        <20211008164750.4007f2d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YWDZPfWOe+C2abWz@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Oct 2021 01:50:21 +0200 Ansuel Smith wrote:
> On Fri, Oct 08, 2021 at 04:47:50PM -0700, Jakub Kicinski wrote:
> > On Sat,  9 Oct 2021 01:34:25 +0200 Ansuel Smith wrote:  
> > > From Documentation phy resume triggers phy reset and restart
> > > auto-negotiation. Add a dedicated function to wait reset to finish as
> > > it was notice a regression where port sometime are not reliable after a
> > > suspend/resume session. The reset wait logic is copied from phy_poll_reset.
> > > Add dedicated suspend function to use genphy_suspend only with QCA8337
> > > phy and set only additional debug settings for QCA8327. With more test
> > > it was reported that QCA8327 doesn't proprely support this mode and
> > > using this cause the unreliability of the switch ports, especially the
> > > malfunction of the port0.
> > > 
> > > Fixes: 15b9df4ece17 ("net: phy: at803x: add resume/suspend function to qca83xx phy")  
> > 
> > Hm, there's some confusion here. This commit does not exist in net,
> > and neither does the one from patch 2.
> > 
> > We should be fine with these going into net-next, right Andrew?  
> 
> Took the hash from linux-next. Think this is the reason they are not in
> net?

Yup, just to be sure you understand the process please take a look at

 - How do the changes posted to netdev make their way into Linux?
 - How often do changes from these trees make it to the mainline Linus
   tree?

here:

https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html#how-do-the-changes-posted-to-netdev-make-their-way-into-linux

But yeah, I think we can go back to posting all 15 patches as one
series. Let's see if Andrew has any feedback on the v2.

Sorry for the confusion!
