Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5793220BB2
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 13:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbgGOLVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 07:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgGOLVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 07:21:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A028CC061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 04:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BY60+oXgF4oVNYMh4/TrJr2FmcE/MQOKGCpeIK5xnHc=; b=MIVkkbgiR8aDwddrpxfETk8Fw
        kgzfjlqthvPyt+Wot21Mx80hIv8RGfgLy4MVrWQhW8oRZhXpQ6tofsDo9oFwYVzbU7pvff/dAyalR
        CA0+w7rLpwP8yjEAtl5ybt5PqXap0sN+/xo2mja9NMbhMrdwtx0jiFlq74VglpZd5u+iUZfLDErY/
        Bg/nysXFpOyI5kIJBZdoziVAln89eeDJBmj724oShUp0yZnmDHxGyJtio3ciS5yjLTzqQkxUiGtLG
        h3BtwydpqnNzWM74S93/X/W1NF1yWXdalLtRfXLV2XDyCK3Q2DSnGoxDOKi49RuJKVVtQp+FVxB4C
        dabvUDUsw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39788)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jvfTH-0006W7-HJ; Wed, 15 Jul 2020 12:21:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jvfTB-0008GY-41; Wed, 15 Jul 2020 12:21:01 +0100
Date:   Wed, 15 Jul 2020 12:21:01 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "michael@walle.cc" <michael@walle.cc>, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC net-next 00/13] Phylink PCS updates
Message-ID: <20200715112100.GG1551@shell.armlinux.org.uk>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <20200714084958.to4n52cnk32prn4v@skbuf>
 <20200714131832.GC1551@shell.armlinux.org.uk>
 <20200714234652.w2pw3osynbuqw3m4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714234652.w2pw3osynbuqw3m4@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 02:46:52AM +0300, Vladimir Oltean wrote:
> On Tue, Jul 14, 2020 at 02:18:32PM +0100, Russell King - ARM Linux admin wrote:
> > I'd actually given up pushing this further; I've seen patches go by that
> > purpetuate the idea that the PCS is handled by phylib.  I feel like I'm
> > wasting my time with this.
> 
> By this I think you are aiming squarely at "[PATCH net-next v3 0/9] net:
> ethernet backplane support on DPAA1". If I understand you correctly, you
> are saying that because of the non-phylink models used to represent that
> system comprised of a clause 49 PCS + clause 72 PMD + clause 73 AN/LT,
> it is not worth pursuing this phylink-based representation of a clause
> 37 PCS.

Actually, that is not what I was aiming that comment at - that is not
something that has been posted recently.  I'm not going to explicitly
point at a patch set.

> > > Where I have some doubts is a
> > > clause 49 PCS which uses a clause 73 auto-negotiation system, I would
> > > like to understand your vision of how deep phylink is going to go into
> > > the PMD layer, especially where it is not obvious that said layer is
> > > integrated with the MAC.
> > 
> > I have only considered up to 10GBASE-R based systems as that is the
> > limit of what I can practically test here.  I have one system that
> > offers a QSFP+ cage, and I have a QSFP+ to 4x SFP+ (10G) splitter
> > cable - so that's basically 4x 10GBASE-CR rather than 40GBASE-CR.
> 
> Ok, no problem here, we can keep this discussion at principle level.
> 
> > I am anticipating that clause 73 will be handled in a very similar way
> > to clause 37.
> 
> This is "Figure 37-1-Location of the Auto-Negotiation function" (clause
> 37 is "Auto-Negotiation function, type 1000BASE-X").
> 
>   OSI
>   REFERENCE
>   MODEL
>   LAYERS
> 
>  +--------------+
>  | APPLICATION  |
>  +--------------+
>  | PRESENTATION |
>  +--------------+
>  | SESSION      |
>  +--------------+
>  | TRANSPORT    |
>  +--------------+
>  | NETWORK      |
>  +--------------+   +----------------------------------------------------+
>  | DATA LINK    |   |    LLC (LOGICAL LINK CONTROL) OR OTHER MAC CLIENT  |
>  |              |   +----------------------------------------------------+
>  |              |   |              MAC CONTROL (OPTIONAL)                |
>  |              |   +----------------------------------------------------+
>  |              |   |            MAC - MEDIA ACCESS CONTROL              |
>  +--------------+   +----------------------------------------------------+
>  | PHYSICAL     |   |                  RECONCILIATION                    |
>  |              |   +----------------------------------------------------+
>  |              |                         |       |
>  |              |                   GMII  |       |
>  |              |   +----------------------------------------------------+\
>  |              |   |          PCS, INCLUDING AUTO-NEGOTIATION           | \
>  |              |   +----------------------------------------------------+ |
>  |              |   |                        PMA                         | |
>  |              |   +----------------------------------------------------+ /
>  |              |    |   LX-PMD   |     |   SX-PMD   |    |   CX-PMD   |  / PHY
>  |              |    +------------+     +------------+    +------------+ /
>  |              |        |    | LX MDI      |    | SX MDI     |    | CX MDI
>  +--------------+      +---------+        +---------+       +---------+
>                        | MEDIUM  |        | MEDIUM  |       | MEDIUM  |
> 
> This is "Figure 28-2-Location of Auto-Negotiation function within the
> ISO/IEC OSI reference model" (clause 28 is "Physical Layer link
> signaling for Auto-Negotiation on twisted pair", aka BASE-T).
> 
>   OSI
>   REFERENCE
>   MODEL
>   LAYERS
> 
>  +--------------+
>  | APPLICATION  |
>  +--------------+
>  | PRESENTATION |
>  +--------------+
>  | SESSION      |
>  +--------------+
>  | TRANSPORT    |
>  +--------------+
>  | NETWORK      |
>  +--------------+   +------------------------------------------------------+
>  | DATA LINK    |   |               LLC (LOGICAL LINK CONTROL)             |
>  |              |   +------------------------------------------------------+
>  |              |   |               MAC - MEDIA ACCESS CONTROL             |
>  +--------------+   +------------------------------------------------------+
>  | PHYSICAL     |           |            RECONCILIATION            |
>  |              |           +--------------------------------------+
>  |              |                          |       |
>  |              |                     MII  |       |
>  |              |          /+--------------------------------------+
>  |              |         / |                 PCS                  |
>  |              |         | +--------------------------------------+
>  |              |         | |                 PMA                  |
>  |              |     PHY | +--------------------------------------+
>  |              |         | |                 PMD                  |
>  |              |         \ +--------------------------------------+
>  |              |          \|               AUTONEG                |
>  |              |           +--------------------------------------+
>  |              |                           |    | MDI
>  +--------------+                         +---------+
>                                           | MEDIUM  |
> 
> This is "Figure 73-1-Location of Auto-Negotiation function within the
> ISO/IEC OSI reference model" (clause 73 is "Auto-Negotiation for
> backplane and copper cable assembly").
> 
>   OSI
>   REFERENCE
>   MODEL
>   LAYERS
> 
>  +--------------+
>  | APPLICATION  |
>  +--------------+
>  | PRESENTATION |
>  +--------------+
>  | SESSION      |
>  +--------------+
>  | TRANSPORT    |
>  +--------------+
>  | NETWORK      |
>  +--------------+   +------------------------------------------------------+
>  | DATA LINK    |   |  LLC (LOGICAL LINK CONTROL) OR ANY OTHER MAC CLIENT  |
>  |              |   +------------------------------------------------------+
>  |              |   |               MAC - MEDIA ACCESS CONTROL             |
>  +--------------+   +------------------------------------------------------+
>  | PHYSICAL     |           |            RECONCILIATION            |
>  |              |           +--------------------------------------+
>  |              |                          |       | GMII, XGMII, 25GMII,
>  |              |                          |       | XLGMII or CGMII
>  |              |          /+--------------------------------------+
>  |              |         / |                 PCS                  |
>  |              |         | +--------------------------------------+
>  |              |         | |                 PMA                  |
>  |              |     PHY | +--------------------------------------+
>  |              |         | |                 PMD                  |
>  |              |         \ +--------------------------------------+
>  |              |          \|               AUTONEG                |
>  |              |           +--------------------------------------+
>  |              |                           |    | MDI
>  +--------------+                         +---------+
>                                           | MEDIUM  |
> 
> Identify the position of the auto-negotiation function in these 3
> diagrams.
> 
> To me, the backplane auto-negotiation look closer to BASE-T than it does
> to BASE-X. This auto-negotiation is performed by the PMD, not by the
> PCS.
> 
> But you are right that clause 28 AN is treated very similarly to clause
> 37 AN... in phylib.
> 
> > The clause 73 "technology ability" field defines the
> > capabilities of the link,
> 
> Yes.
> 
> > but as we are finding with 10GBASE-R based
> > setups with copper PHYs, the capabilities of the link may not be what
> > we want to report to the user, especially if the copper PHY is capable
> > of rate adaption.
> 
> Explain?
> By "copper PHY" I think you mean "compliant to 10GBASE-T". 10GBASE-KR
> serves the same purpose, in the OSI model, as that. Do we not report the
> capabilities of the 10GBASE-T link to the user?

The IEEE diagrams are good for describing the expected layers down to
the "media" but what IEEE calls the "media" may not be what the user
expects.

As an example, take a system where you have a backplane which causes
backplane ethernet, and a series of line cards that have PHYs on them
giving you a range of different connectivity options.  As I illustrated
below, one option would be to turn the backplane ethernet into
conventional twisted-pair ethernet - and there are PHYs on the market
that will do this.

So, in that case, the IEEE diagrams no longer represent the system as
far as the user is concerned - yes, we have figure 73-1 up to the
point of the backplane, and then we have a PHY converting the backplane
ethernet back to (conceptually) MII, and then everything from MII
downards in figure 28-2.

It believe it would be possible to setup such a test scenario on
Macchiatobin hardware if the firmware for training the COMPHY (the
serdes PHY) for a 10GBASE-KR link has not been withdrawn, and the
88x3310 PHY was switched to 10GBASE-KR mode on its host side.

> Also, on a separate note, is rate adaptation supported by mainline
> Linux? Last time I looked, for 2500BASE-X plus the Aquantia PHYs, it
> wasn't.

It depends - and I think I've mentioned this point before in response
to the Aquantia situation.  The 88x3310 PHY supports rate adaption when
in certain host-interface modes.  However, depending on what features
are available on the PHY (such as MACsec, and whether that is enabled)
controls whether pause frames are used, or whether the PHY expects the
egress rate from the upstream MAC to be adapted to the media speed.

In the case of a 88x3310 without MACsec, there are no support in the
PHY to send/receive and act on pause frames while it is performing
rate adaption, so force-enabling pause mode at the MAC is not useful
and is potentially harmful.

The 88x3310 driver used to assume that its host-side interface always
dynamically changed between 10GBASE-R, 5GBASE-R, 2500BASE-X, and SGMII,
but that is not the full story.  One configuration places the host side
in 10GBASE-R mode with rate adaption.  We now have a patch merged that
effectively disables the dynamic changing of the host-side interface
if the PHY is in this mode.  (It also does this for RXAUI mode, fwiw.)

phylib will provide the results of link negotiation as (for example):
	interface = 10GBASE-R (or RXAUI)
	speed = 100M
	duplex = full
	pause = tx | rx

where "speed", "duplex" and "pause" in this instance are the media side
results.  "interface" remains the operational interface between the
PHY and MAC.

I did attempt to start a discussion about how we should approach
rate adaption in this scenario, specifically because I have one board
where the 88x3310 is in RXAUI mode with rate adaption connected to a
DSA switch.  In that case, if we program the speed and duplex into the
MAC, despite the link being in RXAUI mode, the link between the PHY
and DSA switch fails to pass data.  Other MAC drivers don't bother
looking at "speed" and "duplex" when in RXAUI or 10GBASE-R mode,
because they know that the link can only operate at 10G speeds.  Of
course, what ends up being missed is spacing the transmitted packets
out to the media speed - but that is a per-MAC issue.

However, it still leaves the open question I've had for some time (in
fact, since your Aquantia PHY issue) about how we should be dealing
with rate adaption overall, which remains unaddressed - and the
question about how we should enable pause modes at the host MAC when
the PHY requires it is still unresolved.

But... I feel we're getting bogged down in another issue here.

> > Hence, it may be possible to have a backplane link
> > that connects to a copper PHY that does rate adaption:
> > 
> > MAC <--> Clause 73 PCS <--backplane--> PHY <--base-T--> remote system
> > 
> > This is entirely possible from what I've seen in one NBASE-T PHY
> > datasheet.  The PHY is documented as being capable of negotiating a
> > 10GBASE-KR link with the host system, while offering 10GBASE-R,
> > 1000BASE-X, 10GBASE-T, 5GBASE-T, 2.5GBASE-T, 1GBASE-T, 100BASE-T, and
> > 10BASE-T on the media side.  The follow-on question is whether that
> > PHY is likely to be accessible to the system on the other end of the
> > backplane link somehow - either through some kind of firmware link
> > or direct access.  That is not possible to know without having
> > experience with such systems.
> > 
> 
> I have not seen said datasheet. That being said, I don't question the
> existence of such a device. Because NGBASE-T and 10GBASE-KR are both
> media-side protocols, such device would be called a "media converter".
> To me this is no different than a 1000BASE-T to 1000BASE-X media
> converter. How is that modeled in Linux? Is it?

Why is it a "media converter" ?  What about:

MAC <--SGMII/RGMII/...--> PHY <--1000BASE-X-->

which is actually very common.

The difference I see with 10GBASE-KR is that it is intended in part to
for "backplanes".  Putting my electronic engineer hat on, a backplane
is a board that links several pluggable cards together inside a
chassis.  This is actually described at the beginning of clause 69.
Hence, the "media" that is referred to is the internal media to a
piece of equipment, rather than the media that is presented to a user
accessible socket.

At some point, that internal media will be connected either to another
MAC (e.g. another SoC on a different card) or to the external world,
where it will have to be converted to something more suitable for
transmission in the external world, such as 10GBASE-T.

So, merely focusing on what is in IEEE 802.3 misses out on the bigger
picture, which IMHO it is the bigger picture that matters for operating
systems that provide interfaces to users.

> > That said, with the splitting of the PCS from the MAC in phylink, there
> > is the possibility for the PCS to be implemented as an entirely
> > separate driver to the MAC driver, although there needs to be some
> > infrastructure to make that work sanely.  Right now, it is the MAC
> > responsibility to attach the PCS to phylink, which is the right way
> > to handle it for setups where the PCS is closely tied to the MAC, such
> > as Marvell NETA and PP2 where the PCS is indistinguishable from the
> > MAC, and will likely remain so for such setups.  However, if we need
> > to also support entirely separate PCS, I don't see any big issues
> > with that now that we have this split.
> 
> Absolutely.
> 
> There is code in phylink for managing a "MAC-side PCS", a concept
> introduced by Cisco for SGMII and USXGMII. Because of the implementation
> details of this "MAC-side PCS", support for 1000BASE-X comes basically
> for free, because hardware speaking, the same state machines are
> required for both, just different advertisement parsing logic.

You make it sound like phylink happened because of SGMII, and
1000BASE-X was an "accidental side effect".

The truth of the matter is that phylink came about due to the need to
support SFP modules on the SolidRun Clearfog platform (which supports
up to 2.5G on the serdes lane.)  At the time, network drivers that
supported SFP cages had that support tightly integrated into their
network drivers, which meant we were looking at having to implement
SFP support in the Marvell NETA driver and who knows how many other
drivers - which includes parsing the module EEPROMs, detecting the
insertion/removal and so on and so forth.

The problem was split up between a SFP socket driver, handling the
specifics of the socket, and phylink, handling the protocol side and
dealing with the connectivity issues between a MAC and whatever was
external to the MAC.

Due to the wide range of SFPs out there with their diverse
capabilities, some of which have a PHY on, we needed to support
hot-plugging PHYs - which phylink deals with, and when you have a
PHY, SGMII becomes necessary.

> But nonetheless, the exact same hardware state machine, i.e. the one
> described in "Figure 37-6-Auto-Negotiation state diagram", is managed
> twice in the Linux kernel: once in phylib, for any fiber PHY, and once
> in phylink. This is fine to me.

When you have a PHY in SGMII mode, then you have _two_ hardware state
machines in the link between the media and the MAC, both of which need
to indicate "link up" for the overall connection to pass data.  It so
happens that with SGMII mode, we can mostly ignore the PHY side of
things as the PHY conveys the results of the media side negotiation
back to the MAC, with the exception of pause modes - we still need to
query the PHY for that.

Now, in Marvell NETA and PP2, the quirks of hardware state machine is
not visible - all we have are the reported link parameters from the
buried PCS, and an indication whether the link is up or not (it's not
even latched-low.)  So, no, we are not "handling a state machine"
in phylink (and actually that slightly concerns me if polling mode is
not used for the PCS.)

> Yet, in another thread, you are bringing
> the argument that:
> 
> 	If we're not careful, we're going to end up with the Lynx PCS
> 	being implemented one way, and backplane PCS being implemented
> 	completely differently and preventing any hope of having a
> 	backplane PCS connected to a conventional copper PHY.

I see absolutely no conflict between these statements.

> But back to your argument: a backplane PHY could be described as a
> phylink MAC-side PCS, and this would have the benefit that the phylib
> slot would be free for a 10GBASE-T PHY, were that ever necessary.
> That is true, but that is akin to saying that any media converter should
> be modeled as a MAC-side phylink PCS and another, singular, phylib PHY
> (the converter itself). Why is this the best solution? Because it works?

It gives the greatest flexibility and gives options.

> Sure it does, but is that not a layering violation of sorts? What are
> the boundaries of phylink? I am asking because I genuinely don't know.
> Is it supposed to manage a SERDES data eye?

No.  Phylink only cares about the _protocol_ between the phylib PHY or
SFP cage and the MAC.  It doesn't care about the electrical properties
of that link - that is the domain of other parts of the code, and
already _is_ via use (in Marvell based systems) with the use of the
drivers/phy layer to control the COMPHY (serdes PHY).

As for "a layering violation of sorts" is that not what SGMII and
USXGMII fundamentally is?  You have the full OSI 1000BASE-X stack,
modified by some custom modifications, followed by something that
converts the 1000BASE-X modified stack back to MII and then a
BASE-T OSI stack.  Is the PHY in that case a "media converter" ?

> To me, it is not obvious at all that a backplane PHY (an integrated one,
> at that, but there are integrated BASE-T PHYs as well) shouldn't be
> modeled using phylib. If you read carefully through the standard, you'll
> notice that the most significant portion of backplane Ethernet is in
> "72.6.10.4 State diagrams", for link training. My fear is that phylink
> will need to acquire a lot of junk in order to support one
> software-driven implementation of 10GBASE-KR AN/LT, just to prove a
> point. We have zero other implementations to compare with, but we can
> just imagine that others might either do it software-driven, like NXP,
> or software-driven but hidden in firmware, or completely in hardware.
> Either way, phylib provides just the necessary abstractions for this to
> be hidden away. Whereas phylink might need some extra timers apart from
> the existing .pcs_get_state() to get this link training job done.

I don't get it.  The phylink interface is quite simple - if we are
using in-band mode, then we are asking the PCS block for its state.
We are also telling the PCS block what configuration we want it to
be in, and we also inform it when the link overall comes up.
What the PCS does internally is of no concern to phylink.  If it needs
to do some link training, that is a matter internal to the PCS driver.
If a PCS driver wants to use a library that implements the link
training, or call firmware to do link training, that is up to the PCS
driver and of no concern to phylink.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
