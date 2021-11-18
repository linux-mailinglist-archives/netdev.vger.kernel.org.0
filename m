Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15BD455E81
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhKROut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbhKROut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 09:50:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57C4C061574;
        Thu, 18 Nov 2021 06:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=07D8x7vN3jfeD5XZN/qBASoHka2f8cD6epkAB8Yg9n0=; b=g/U07M+Ojx045ex3Fy2cbzTLI6
        iOzF6b8PrS0NDh5MUhlYGtRIGexNy49uERysAG1Wmngl2vQ/tRI5B5sRSxq2uEmx6rDEOtLxLWqYe
        fCStcl1STekwfsOfLEmyULYjde0S9jPplV14VAjkWpY6sK3D/5K8NOLSt2f6r+3uANm5o/otcfTVi
        /lc8p7GI0w24DX5af6m02eP1hDlnzD0VQCEo/Fxdxe6HLzg8ACKWCVZJp4IYfIbOfSfVcvXu2+k/l
        uQHYYzgab7dkspa2vD/ODzqHCsFEwcfGU3dgEplUXZ7tgKWre/vKFvl6RdU95omruT7AWeRJZgo5H
        ZYpKZ7Pg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55722)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mnihV-000337-RQ; Thu, 18 Nov 2021 14:47:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mnihU-00040Z-Qc; Thu, 18 Nov 2021 14:47:44 +0000
Date:   Thu, 18 Nov 2021 14:47:44 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 8/8] net: phy: marvell10g: select host interface
 configuration
Message-ID: <YZZnkEn76a3Q0hAY@shell.armlinux.org.uk>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-9-kabel@kernel.org>
 <20211118120334.jjujutp5cnjgwjq2@skbuf>
 <YZZTinTgX3SPWIZM@shell.armlinux.org.uk>
 <20211118142039.uocgddbpplwwsfdk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211118142039.uocgddbpplwwsfdk@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 04:20:39PM +0200, Vladimir Oltean wrote:
> On Thu, Nov 18, 2021 at 01:22:18PM +0000, Russell King (Oracle) wrote:
> > On Thu, Nov 18, 2021 at 02:03:34PM +0200, Vladimir Oltean wrote:
> > > On Wed, Nov 17, 2021 at 11:50:50PM +0100, Marek Behún wrote:
> > > > +static int mv3310_select_mactype(unsigned long *interfaces)
> > > > +{
> > > > +	if (test_bit(PHY_INTERFACE_MODE_USXGMII, interfaces))
> > > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_USXGMII;
> > > > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > > > +		 test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> > > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
> > > > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > > > +		 test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> > > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI;
> > > > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > > > +		 test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> > > > +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI;
> > > > +	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> > > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH;
> > > > +	else if (test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> > > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH;
> > > > +	else if (test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> > > > +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH;
> > > > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces))
> > > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
> > > > +	else
> > > > +		return -1;
> > > > +}
> > > > +
> > > 
> > > I would like to understand this heuristic better. Both its purpose and
> > > its implementation.
> > > 
> > > It says:
> > > (a) If the intersection between interface modes supported by the MAC and
> > >     the PHY contains USXGMII, then use USXGMII as a MACTYPE
> > > (b) Otherwise, if the intersection contains both 10GBaseR and SGMII, then
> > >     use 10GBaseR as MACTYPE
> > > (...)
> > > (c) Otherwise, if the intersection contains just 10GBaseR (no SGMII), then
> > >     use 10GBaseR with rate matching as MACTYPE
> > > (...)
> > > (d) Otherwise, if the intersection contains just SGMII (no 10GBaseR), then
> > >     use 10GBaseR as MACTYPE (no rate matching).
> > 
> > What is likely confusing you is a misinterpretation of the constant.
> > MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER actually means the PHY will
> > choose between 10GBASE-R, 5GBASE-R, 2500BASE-X, and SGMII depending
> > on the speed negotiated by the media. In this setting, the PHY
> > dictates which interface mode will be used.
> > 
> > I could have named "MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER" as
> > "MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_5GBASER_2500BASEX_SGMII_AUTONEG_ON".
> > Similar with "MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_NO_SGMII_AN", which
> > would be
> > "MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_5GBASER_2500BASEX_SGMII_AUTONEG_OFF".
> > And "MV_V2_3310_PORT_CTRL_MACTYPE_XAUI" would be
> > "MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_5GBASER_2500BASEX_SGMII_AUTONEG_ON".
> > 
> > Clearly using such long identifiers would have been rediculous,
> > especially the second one at 74 characters.
> 
> True, but at least there could be a comment above each definition.
> There's no size limit to that.
> 
> > > First of all, what is MACTYPE exactly? And what is the purpose of
> > > changing it? What would happen if this configuration remained fixed, as
> > > it were?
> > 
> > The PHY defines the MAC interface mode depending on the MACTYPE
> > setting selected and the results of the media side negotiation.
> > 
> > I think the above answers your remaining questions.
> 
> Ok, so going back to case (d). You said that the full name would be
> MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_5GBASER_2500BASEX_SGMII_AUTONEG_ON.
> This means that when the only interface mode supported by the host would
> be SGMII, the PHY's MACTYPE is still configured to use 2500basex,
> 5gbaser, 10gbaser for the higher link speeds. Clearly this won't work.
> But on the other hand, the phylink validate method will remove
> 2500baseT, 5000baseT, 1000baseT from the advertising mask of the PHY, so
> the system will never end up operating at those speeds, so it should be fine.

I think you mean 10000baseT rather than 1000baseT. With that correction,
you are then correct - with the media restricted to 1G or slower speeds,
and the phy in MACTYPE mode 4 (aka 10GBASE-R as the fastest interface
mode) it will permanently be talking SGMII to the host.

> The reason why I'm looking at these patches is to see whether they would
> bring something useful to Aquantia PHYs. These come with firmware on a
> flash that is customized by Aquantia themselves based on the specifications
> of a single board. These PHYs have an ability which is very similar to
> what I'm seeing here, which is to select, for each negotiated link speed
> on the media side, the SERDES protocol to use on the system side. This
> is pre-programmed by the firmware, but could be fixed up by the
> operating system if done carefully.
> 
> The way Layerscape boards use Aquantia PHYs is to always select the
> "rate matching" option and keep the SERDES protocol fixed, just
> configure the mini MAC inside the PHY to emit PAUSE frames towards the
> system to keep the data rate under control. We would be using these PHYs
> with the generic C45 driver, which would be mostly enough except for
> lack of PHY interrupts, because the firmware already configures
> everything.
> 
> But on the other hand it gets a bit tiring, especially for PHYs on riser
> cards, to have to change firmware in order to test a different SERDES
> protocol, so we were experimenting with some changes in the PHY driver
> that would basically keep the firmware image fixed, and just fix up the
> configuration it made, and do things like "use 2500base-x for the
> 2500base-T speed, and sgmii for 1000base-T/100base-TX". The ability for
> a PHY to work on a board where its firmware image wasn't specifically
> designed for it comes in handy sometimes.

You're going to get into problems with this on Layerscape, because
reconfiguring the Serdes etc is something I've tried to highlight
as being necessary to NXP since SolidRun started using LX2160A. I
think there's some slow progress towards that, but it's so slow that
I've basically given up caring about it on the Honeycomb/Clearfog CX
boards now.

All the SFP cages on my Honeycomb have been configured for the most
useful mode to me - 1000BASE-X/SGMII, and I've given up caring about
USXGMII/10GBASE-R on those ports.

> I see that this patch set basically introduces the phydev->host_interfaces
> bitmap which is an attempt to find the answer to that question. But when
> will we know enough about phydev->host_interfaces in order to safely
> make decisions in the PHY driver based on it? phylink sets it, phylib
> does not.

It won't be something phylib could set because phylib doesn't know
the capabilities of its user - it's information that would need to be
provided to phylib.

> And many Aquantia systems use the generic PHY driver, as mentioned.
> Additionally, there are old device trees at play here, which only define
> the initial SERDES protocol. Would we be changing the behavior for those,
> in that we would be configuring the PHY to keep the SERDES protocol
> fixed whereas it would have dynamically changed before?

We have the same situation on Macchiatobin. The 88X3310 there defaults
to MACTYPE mode 4, and we've supported this for years with DT describing
the interface as 10GBASE-R - because we haven't actually cared very much
what DT says up to this point for the 88X3310. As I said in my previous
reply, the 88X3310 effectively dictates what the PHY interface mode will
be, and that is communicated back through phylib to whoever is using
phylib.

> Another question is what to do if there are multiple ways of
> establishing a system-side link. For example 1000 Mbps can be achieved
> either through SGMII, or USXGMII with symbol replication, or 2500base-x
> with flow control, or 10GBaseR with flow control. And I want to test
> them all. What would I need to do to change the SERDES protocol from one
> value to the other? Changing the phy-mode array in the device tree would
> be one option, but that may not always be possible.

First point to make here is that rate adaption at the PHY is really
not well supported in Linux, and there is no way to know via phylib if
a PHY is capable or not of rate adaption.

Today, if you have a 10GBASE-R link between a PHY doing rate adaption
and the "MAC", then what you will get from phylib is:

	phydev->interface = PHY_INTERFACE_MODE_10GBASER;
	phydev->speed = SPEED_1000;	// result of media negotiation
	phydev->duplex = DUPLEX_FULL;	// result of media negotiation
	phydev->pause = ...;		// result of media negotiation
	phydev->asym_pause = ...;	// result of media negotiation

which will, for the majority of implementations, result in the MAC being
forced to a 1G speed, possibly with or without pause enabled.

Due to this, if phylink is being used, the parameters given to
mac_link_up/pcs_link_up will be the result of the media negotiation, not
what is required on the actual link.

You mention "10GBaseR with flow control" but there is another
possibility that exists in real hardware out there. "10GBaseR without
flow control" and in that case, the MAC needs to pace its transmission
for the media speed (which is a good reason why mac_link_up should be
given the result of the media negotiation so it can do transmission
pacing.)

I have a follow-up to the response I gave to Sean Anderson on rate-
adapting PHYs that I need to finish and send, and it would be better
to have any discussion on this topic after I've sent that reply and
follow-up to that reply.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
