Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84D21F05D0
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 10:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgFFIiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 04:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728638AbgFFIiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 04:38:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7438BC08C5C2;
        Sat,  6 Jun 2020 01:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bBoDKAW2lJXm+wJrPYbdtaUURKFNhWDjub7YetELq/E=; b=VaXQHtQJNnpoh3zej1C4DS0E7
        qJDThrbbJFYV3m5qt2lKjJLkJMO63RDmX2RtzvLH+oT9bDQ4sOe/I6KLb2/1EXM1rCNwKM31vo7ga
        G+6aefq8zOUjfJFj3WT+PRhEumhRr81+lMGhaMclKJykWTLZhhip/2nDfzyCVUYsaQ97rkIgtDRRo
        LHHfTRtQKDOmlJICM1W6oN7b7M1D/AzoqNXcauL93EXo7OKosBU+x+1O7rBH/2ntesyrR6jk81lwk
        TzBskNeZ7XfT6oCRhLOTV72dKy8GX0NER4x26+zcHOQyCKZ4Lg1qMGZHzyn5OZvta6bqj+ZBm6xVT
        rVKcVzxgA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:39538)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jhUKp-00046J-G6; Sat, 06 Jun 2020 09:37:47 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jhUKj-0008Kk-A2; Sat, 06 Jun 2020 09:37:41 +0100
Date:   Sat, 6 Jun 2020 09:37:41 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: qca8k: introduce SGMII configuration
 options
Message-ID: <20200606083741.GK1551@shell.armlinux.org.uk>
References: <cover.1591380105.git.noodles@earth.li>
 <8ddd76e484e1bedd12c87ea0810826b60e004a65.1591380105.git.noodles@earth.li>
 <20200605183843.GB1006885@lunn.ch>
 <20200606074916.GM311@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606074916.GM311@earth.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 06, 2020 at 08:49:16AM +0100, Jonathan McDowell wrote:
> On Fri, Jun 05, 2020 at 08:38:43PM +0200, Andrew Lunn wrote:
> > On Fri, Jun 05, 2020 at 07:10:58PM +0100, Jonathan McDowell wrote:
> > > The QCA8337(N) has an SGMII port which can operate in MAC, PHY or BASE-X
> > > mode depending on what it's connected to (e.g. CPU vs external PHY or
> > > SFP). At present the driver does no configuration of this port even if
> > > it is selected.
> > > 
> > > Add support for making sure the SGMII is enabled if it's in use, and
> > > device tree support for configuring the connection details.
> > 
> > It is good to include Russell King in Cc: for patches like this.
> 
> No problem, I can keep him in the thread; I used get_maintainer for the
> initial set of people/lists to copy.

get_maintainer is not always "good" at selecting the right people,
especially when your patches don't match the criteria; MAINTAINERS
contains everything that is sensible, but Andrew is suggesting that
you copy me because in his opinion, you should be using phylink -
and that's something that you can't encode into a program.

Note that I haven't seen your patches.

> > Also, netdev is closed at the moment, so please post patches as RFC.
> 
> "closed"? If you mean this won't get into 5.8 then I wasn't expecting it
> to, I'm aware the merge window for that is already open.

See https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt
"How often do changes from these trees make it to the mainline Linus
tree?"

> > It sounds like the hardware has a PCS which can support SGMII or
> > 1000BaseX. phylink will tell you what mode to configure it to. e.g. A
> > fibre SFP module will want 1000BaseX. A copper SFP module will want
> > SGMII. A switch is likely to want 1000BaseX. A PHY is likely to want
> > SGMII. So remove the "sgmii-mode" property and configure it as phylink
> > is requesting.
> 
> It's more than SGMII or 1000BaseX as I read it. The port can act as if
> it's talking to an SGMII MAC, i.e. a CPU, or an SGMII PHY, i.e. an
> external PHY, or in BaseX mode for an SFP. I couldn't figure out a way
> in the current framework to automatically work out if I wanted PHY or
> MAC mode. For the port tagged CPU I can assume MAC mode, but a port that
> doesn't have that might still be attached to the CPU rather than an
> external PHY.

That depends what you're connected to. Some people call the two sides
of SGMII "System side" and "Media side". System side is where you're
receiving the results of AN from a PHY. Media side is where you're
telling the partner what you want it to do.

Media side is only useful if you're connected to another MAC, and
unless you have a requirement for it, I would suggest not implementing
that - you could come up with something using fixed-link, or it may
need some other model if the settings need to change.  That depends on
the application.

> > What exactly does sgmii-delay do?
> 
> As per the device tree documentation update I sent it delays the SGMII
> clock by 2ns. From the data sheet:
> 
> SGMII_SEL_CLK125M	sgmii_clk125m_rx_delay is delayed by 2ns

This sounds like a new world of RGMII delay pain but for SGMII. There
is no mention of "delay" in the SGMII v1.8 specification, so I guess
it's something the vendor is doing. Is this device capable of
recovering the clock from a single serdes pair carrying the data,
or does it always require the separate clock?

> > > +#define QCA8K_REG_SGMII_CTRL				0x0e0
> > > +#define   QCA8K_SGMII_EN_PLL				BIT(1)
> > > +#define   QCA8K_SGMII_EN_RX				BIT(2)
> > > +#define   QCA8K_SGMII_EN_TX				BIT(3)
> > > +#define   QCA8K_SGMII_EN_SD				BIT(4)
> > > +#define   QCA8K_SGMII_CLK125M_DELAY			BIT(7)
> > > +#define   QCA8K_SGMII_MODE_CTRL_MASK			(BIT(22) | BIT(23))
> > > +#define   QCA8K_SGMII_MODE_CTRL_BASEX			0
> > > +#define   QCA8K_SGMII_MODE_CTRL_PHY			BIT(22)
> > > +#define   QCA8K_SGMII_MODE_CTRL_MAC			BIT(23)
> > 
> > I guess these are not really bits. You cannot combine
> > QCA8K_SGMII_MODE_CTRL_MAC and QCA8K_SGMII_MODE_CTRL_PHY. So it makes
> > more sense to have:
> > 
> > #define   QCA8K_SGMII_MODE_CTRL_BASEX			(0x0 << 22)
> > #define   QCA8K_SGMII_MODE_CTRL_PHY			(0x1 << 22)
> > #define   QCA8K_SGMII_MODE_CTRL_MAC			(0x2 << 22)
> 
> Sure; given there's no 0x3 choice I just went for the bits that need
> set, but that works too.

I also prefer Andrew's suggestion, as it makes it clear that it's a two
bit field.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
