Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391311ED2D8
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 16:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgFCO7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 10:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgFCO7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 10:59:09 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE17EC08C5C0;
        Wed,  3 Jun 2020 07:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MtuKNw2pgwAhO9cB5wELdMt4OQ9HRQi1RszYbDAANfo=; b=CFQxCtsdhBH+Gn+g/+1aQuw+w
        /1Q060iK8zSrMm0PISy8jCuZjeSbRuC3qWJ4sS5Btp1z+cJuqMx3+qJk40ZiPglHtdCNv0WBJpGP3
        dA7F8U9Dj+q9zQ8vtBUOr5O830OZ1bp00XiX6nkvlb4n5AVSU9dcjbxdeDRoBcHNYXAdCobz9Yp5S
        8EEqSieVbAl1zx8x3m1Wl4uNco7Tc4uG4SfPP/XCWlKqgwKA6qazc4/7UIAZV3shJeJSQDexgPfDM
        y0uD5nqYNFHlwIVQIaiAUnbO1SWQ2EAB3rdi/GNSpmGEwy4eHjihoTHt7uyun2pi4jCWVHDu6vZM0
        +T92XR1XQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38388)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jgUr6-0005gy-0Q; Wed, 03 Jun 2020 15:59:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jgUr2-0005TW-NB; Wed, 03 Jun 2020 15:58:56 +0100
Date:   Wed, 3 Jun 2020 15:58:56 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-ID: <20200603145856.GA1551@shell.armlinux.org.uk>
References: <20200528163335.8f730b5a3ddc8cd9beab367f@suse.de>
 <20200528144805.GW1551@shell.armlinux.org.uk>
 <20200528204312.df9089425162a22e89669cf1@suse.de>
 <20200528220420.GY1551@shell.armlinux.org.uk>
 <20200529130539.3fe944fed7228e2b061a1e46@suse.de>
 <20200529145928.GF869823@lunn.ch>
 <20200529175225.a3be1b4faaa0408e165435ad@suse.de>
 <20200529163340.GI869823@lunn.ch>
 <20200602225016.GX1551@shell.armlinux.org.uk>
 <20200603132147.GW869823@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603132147.GW869823@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 03:21:47PM +0200, Andrew Lunn wrote:
> On Tue, Jun 02, 2020 at 11:50:17PM +0100, Russell King - ARM Linux admin wrote:
> > On Fri, May 29, 2020 at 06:33:40PM +0200, Andrew Lunn wrote:
> > > Given the current code, you cannot. Now we understand the
> > > requirements, we can come up with some ideas how to do this properly.
> > 
> > Okay, I've been a little quiet because of sorting out the ARM tree
> > for merging with Linus (now done) and I've been working on a solution
> > to this problem.
> > 
> > The good news is, I have an implementation in phylink to use the sync
> > status reported from a PCS, and to appropriately enable sync status
> > reporting.  I'm quite nervous about having that enabled as a matter of
> > routine as I've seen some Marvell hardware end up with interrupt storms
> > from it - presumably due to noise pickup on the serdes lines being
> > interpreted as an intermittently valid signal.
> 
> Hi Russell
> 
> I have seen similar with an SFP without link. I think squelch is
> optional, so noise gets passed through, which is enough to get and
> loose sync.
> 
> I think we probably need to only enable the interrupt when the LOS
> signal indicates there is at least some power coming into the SFP.

This doesn't help in Thomas' case, there is no LOS signal.  I was
proposing that Thomas uses fixed-link to describe the setup (because
that's exactly what it is) but use the serdes sync status as an
additional gate for "link up".

Given that we have platforms that hammer the CPU with interrupts
when AN bypass is enabled, I think that setup is also a non-starter
for the mainline kernel without some way for firmware to tell the
kernel that it's okay to use it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
