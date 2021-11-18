Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27529456004
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 16:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhKRQCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbhKRQCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 11:02:39 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1C3C061574;
        Thu, 18 Nov 2021 07:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8A1MJPuo895PBsWQos2epx3+B0G9BRoXvoJvp5YqbSY=; b=HsaDHSAtb5YYUUVXnba1rZbWx4
        n14yhD55Ejim45InB65Cf3ku+vY+HToiP+JdFvq+mCFgg3TkO5ifkCmmZnbsaLB5IJvHP1n373Ziw
        pOK9bztu36emq1vcBpO0NAN4XFTpXWnm0wl96pwdo/0Trd2plxuJjqCs44e/oDdUYFEGRq54H/x9j
        J/0/O+C9hTdVJNyMbvttVPF03zWJ7V2upJALrS4yeAZVQk4bWNlvig3C4o2vNr8y6hbHtg4N/UZh/
        Owkmse2yYLtoinofOPMkjvAyTgW06iLeNLYhy2knZ4Gispsy2ApXGBUl6XcGMZbrFp5sUDyfALT9f
        di+rwMLg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55726)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mnjp2-00037Y-NS; Thu, 18 Nov 2021 15:59:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mnjp1-000437-8I; Thu, 18 Nov 2021 15:59:35 +0000
Date:   Thu, 18 Nov 2021 15:59:35 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 8/8] net: phy: marvell10g: select host interface
 configuration
Message-ID: <YZZ4Zy6Y8p/fGj5b@shell.armlinux.org.uk>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-9-kabel@kernel.org>
 <20211118120334.jjujutp5cnjgwjq2@skbuf>
 <YZZTinTgX3SPWIZM@shell.armlinux.org.uk>
 <20211118142039.uocgddbpplwwsfdk@skbuf>
 <YZZnkEn76a3Q0hAY@shell.armlinux.org.uk>
 <20211118150951.jzwl5jickilxbfhy@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118150951.jzwl5jickilxbfhy@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 05:09:51PM +0200, Vladimir Oltean wrote:
> On Thu, Nov 18, 2021 at 02:47:44PM +0000, Russell King (Oracle) wrote:
> > You're going to get into problems with this on Layerscape, because
> > reconfiguring the Serdes etc is something I've tried to highlight
> > as being necessary to NXP since SolidRun started using LX2160A. I
> > think there's some slow progress towards that, but it's so slow that
> > I've basically given up caring about it on the Honeycomb/Clearfog CX
> > boards now.
> > 
> > All the SFP cages on my Honeycomb have been configured for the most
> > useful mode to me - 1000BASE-X/SGMII, and I've given up caring about
> > USXGMII/10GBASE-R on those ports.
> 
> Speaking of that, do you know of any SFP modules that would use USXGMII?
> It doesn't appear to be listed in the spec sheet when looking for that.

I only know of one possibility, which is the DM7052 which uses a
Broadcom BCM84881 PHY. I believe the PHY is capable of USXGMII (there's
various references to it on the 'net) to some extent. By that, I mean
it probably does not provide the 16-bit configuration word in USXGMII
mode - just like it doesn't provide it in SGMII mode.

On the DM7052 module, the PHY is not in USXGMII mode, it will switch
interface modes according to the media speed just like the Marvell
88X3310 does. So, it's vital to use the PHY specific driver for this
PHY, and not the generic driver.

Since the datasheet for the PHY is unavailable, it is not known how to
switch it to USXGMII mode, so it may not be possible to do so except
by modifying the pin strapping on the PHY. It may be possible to do it
through vendor registers.

> > > I see that this patch set basically introduces the phydev->host_interfaces
> > > bitmap which is an attempt to find the answer to that question. But when
> > > will we know enough about phydev->host_interfaces in order to safely
> > > make decisions in the PHY driver based on it? phylink sets it, phylib
> > > does not.
> > 
> > It won't be something phylib could set because phylib doesn't know
> > the capabilities of its user - it's information that would need to be
> > provided to phylib.
> 
> So you're saying it would be in phylib's best interest to not set it at
> all, not even to a single bit corresponding to phydev->interface. So PHY
> drivers could work out this way whether they should operate in backwards
> compatibility mode or they could change MACTYPE at will.

That's what I'm thinking - if we end up with a single bit set in the
host interface, does that mean "the host only supports a single
interface type" or does it mean "DT only specified one interface type
and we need to operate in backwards compatibility mode".

If we provide an empty host_interfaces bitmap, then we can easily
detect that it's not set and fallback to compatibility mode - in the
case of 88x3310, that would basically mean not attempting to set
MACTYPE.

> > > And many Aquantia systems use the generic PHY driver, as mentioned.
> > > Additionally, there are old device trees at play here, which only define
> > > the initial SERDES protocol. Would we be changing the behavior for those,
> > > in that we would be configuring the PHY to keep the SERDES protocol
> > > fixed whereas it would have dynamically changed before?
> > 
> > We have the same situation on Macchiatobin. The 88X3310 there defaults
> > to MACTYPE mode 4, and we've supported this for years with DT describing
> > the interface as 10GBASE-R - because we haven't actually cared very much
> > what DT says up to this point for the 88X3310. As I said in my previous
> > reply, the 88X3310 effectively dictates what the PHY interface mode will
> > be, and that is communicated back through phylib to whoever is using
> > phylib.
> 
> So what is the full backwards compatibility strategy with old DT blobs?
> Is it in this patch set? I didn't notice it.

Marek has attempted to create a backwards compatibility in phylink for
this. See phylink_update_phy_modes().

> > > Another question is what to do if there are multiple ways of
> > > establishing a system-side link. For example 1000 Mbps can be achieved
> > > either through SGMII, or USXGMII with symbol replication, or 2500base-x
> > > with flow control, or 10GBaseR with flow control. And I want to test
> > > them all. What would I need to do to change the SERDES protocol from one
> > > value to the other? Changing the phy-mode array in the device tree would
> > > be one option, but that may not always be possible.
> > 
> > First point to make here is that rate adaption at the PHY is really
> > not well supported in Linux, and there is no way to know via phylib if
> > a PHY is capable or not of rate adaption.
> > 
> > Today, if you have a 10GBASE-R link between a PHY doing rate adaption
> > and the "MAC", then what you will get from phylib is:
> > 
> > 	phydev->interface = PHY_INTERFACE_MODE_10GBASER;
> > 	phydev->speed = SPEED_1000;	// result of media negotiation
> > 	phydev->duplex = DUPLEX_FULL;	// result of media negotiation
> > 	phydev->pause = ...;		// result of media negotiation
> > 	phydev->asym_pause = ...;	// result of media negotiation
> > 
> > which will, for the majority of implementations, result in the MAC being
> > forced to a 1G speed, possibly with or without pause enabled.
> > 
> > Due to this, if phylink is being used, the parameters given to
> > mac_link_up/pcs_link_up will be the result of the media negotiation, not
> > what is required on the actual link.
> > 
> > You mention "10GBaseR with flow control" but there is another
> > possibility that exists in real hardware out there. "10GBaseR without
> > flow control" and in that case, the MAC needs to pace its transmission
> > for the media speed (which is a good reason why mac_link_up should be
> > given the result of the media negotiation so it can do transmission
> > pacing.)
> > 
> > I have a follow-up to the response I gave to Sean Anderson on rate-
> > adapting PHYs that I need to finish and send, and it would be better
> > to have any discussion on this topic after I've sent that reply and
> > follow-up to that reply.
> 
> Ok, how would the MAC pace itself to send at a lower data rate, if the
> SERDES protocol is 10G and the PHY doesn't send it PAUSE frames back?
> At least Layerscape systems can't do this AFAIK.

I'm afraid that is an exercise for the reader/MAC driver author since
it's dependent on the hardware.

One would hope that no one would create a system where the PHY needs to
use rate adaption and requires the MAC to pace itself, but the MAC has
no way to achieve that. If such a hardware combination exists, I don't
see how it could work reliably.

However, bear in mind that the 88X3310 on Macchiatobin boards is the
one without MACSEC, so if it is configured to only operate at 10GBASE-R
with rate adaption, then it will not be generating pause frames and it
will expect the MAC to pace. This is about the only platform I have
which I could experiment with a PHY performing rate adaption. However,
I'm not currently sure how useful that would be - it would be nothing
more than an experimentation exercise, and would require MAC pacing
to be implemented in the mvpp2 driver.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
