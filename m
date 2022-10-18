Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE5F602689
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 10:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiJRINZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 04:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJRINU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 04:13:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4330C8F963
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 01:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7bVeN7+pe/RIEYAp7JpgfbMXvdu+vagYcXzdo0iH9uw=; b=Pb5GMMgh+IfmzVVZ/zHFoS6Evb
        q8o0aHkU6xsQY50MpfzETuhe2WYn/xB944r4NxtSriC/OhQ0jzs7Q9X0VThI7rOqA9Gf6FWOgM9jz
        2fmus44AXB2zgsD7IO1E1etAPAElH4Z3g99vzLem7PHlo9/fPpixXh7a9Gnmc/aY4G8C9wBosWftv
        +NdTRZZ+9gUH1dyPjlL/mvJlK4YoadOi9AJmvcn3jhgfGJ6T1cbrgSfrDwGM69eK36/ddw8i7RGyd
        jI9tT0U8kMaBnv+oS5BDZG8JqWlxCBwD3yx88Yc40nuEw5ixyQcmGZNDZLWzP6JQijN5H6SMUb2b0
        hq1lLmyA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34768)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1okhiu-0004Cc-AV; Tue, 18 Oct 2022 09:13:16 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1okhis-0000wW-Ec; Tue, 18 Oct 2022 09:13:14 +0100
Date:   Tue, 18 Oct 2022 09:13:14 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: Multi-PHYs and multiple-ports bonding support
Message-ID: <Y05gGvh1nacoz0YL@shell.armlinux.org.uk>
References: <20221017105100.0cb33490@pc-8.home>
 <Y00fYeZEcG/E3FPV@shell.armlinux.org.uk>
 <20221018100205.000ac57d@pc-8.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018100205.000ac57d@pc-8.home>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 10:02:05AM +0200, Maxime Chevallier wrote:
> Hello Russell,
> 
> On Mon, 17 Oct 2022 10:24:49 +0100
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> 
> > On Mon, Oct 17, 2022 at 10:51:00AM +0200, Maxime Chevallier wrote:
> > > 2) Changes in Phylink
> > > 
> > > This might be the tricky part, as we need to track several ports,
> > > possibly connected to different PHYs, to get their state. For now, I
> > > haven't prototyped any of this yet.  
> > 
> > The problem is _way_ larger than phylink. It's a fundamental
> > throughout the net layer that there is one-PHY to one-MAC
> > relationship. Phylink just adopts this because it is the established
> > norm, and trying to fix it is rather rediculous without a use case.
> > 
> > See code such as the ethtool code, where the MAC and associated layers
> > are# entirely bypassed with all the PHY-accessing ethtool commands and
> > the commands are passed directly to phylib for the PHY registered
> > against the netdev.
> > 
> > We do have use cases though - consider a setup such as the mcbin with
> > the 3310 in SGMII mode on the fibre link and a copper PHY plugged in
> > with its own PHY - a stacked PHY situation (we don't support this
> > right now.) Which PHY should the MII ioctls, ethtool, and possibly the
> > PTP timestamp code be accessing with a copper SFP module plugged in?
> > 
> > This needs to be solved for your multi-PHY case, because you need to
> > deal with programming e.g. the link advertisement in both PHYs, not
> > just one - and with the above model, you have no choice which PHY gets
> > the call, it's always going to be the one registered with the netdev.
> > 
> > The point I'm making is that you're suggesting this is a phylink
> > issue, but it isn't, it's a generic networking layering bypass issue.
> > If the net code always forwarded the ethtool etc stuff to the MAC and
> > let the MAC make appropriate decisions about how these were handled,
> > then we would have a properly layered approach where each layer can
> > decide how a particular interface is implemented - to cope with
> > situations such as the one you describe.
> 
> I agree with all you say, and indeed this problem is a good opportunity
> IMO to consider the other use-cases like the one you mention and come
> up with a nice solution.

However, this isn't really "other use-cases" that I'm talking about
above, but a problem that needs solving for your case.

> When you mention that ethtool bypasses the MAC layer and talks to
> phylib, since phylink has the overall view of the link, and abstracts
> the phy away from the MAC, I would think this is a good place to
> manage this tree of PHYs/ports, but on the other hand that's adding
> quite a lot of complexity to phylink.

phylink doesn't abstract the PHY from the networking layer. What we
have are these call paths through the layers:

net --> mac --> phylink --> phy
 |                           ^
 `---------------------------'
      (bypass call path)

That bypass call path will be a problem as soon as you start talking
about having more than one PHY for a MAC.

Yes, changing phylink fixes some of the issues, but doesn't get away
from the fundamental issue that both the MAC and phylink are bypassed
for certain paths.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
