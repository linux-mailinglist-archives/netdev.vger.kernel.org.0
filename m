Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4EB46A5A7
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348495AbhLFTag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348487AbhLFTag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:30:36 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF585C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 11:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=puydKUcpifDTYBaZ1So4VnYro/+IaXsS0BdWS3Ohqyg=; b=KJHDoKyOM3MVqECjcfwS06pX+d
        fZOT1hIIfXbatSRiPUMQT3a1Uuawr3GIneKgqCl9TtcaNQHSmyJrItMZWJE/j5C22TsRGAfpaTUT5
        sut/M3y4g8it5ANpErUOidg1xfr+3pbfk8v6Es6GWd4O+CgBoOPOkofOcA5CL+rb1dtgcZPfqGb4I
        liYzgGHjdqKDpYQUcPHVru31ZBIrOjOGyR6SQggtq8mRIl9RmgOej7CASmdS/MK2lzminw50r6cxX
        JbK0/4T7Mea+iF+vvS/9izSdl6bz/9bhrLkupTUGwtPOevIHjmmg+dBAsl+/4SZyc74f0+uva6Sws
        YyIjD1hg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56108)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1muJdU-0005DM-Jp; Mon, 06 Dec 2021 19:26:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1muJdQ-0004aA-DL; Mon, 06 Dec 2021 19:26:48 +0000
Date:   Mon, 6 Dec 2021 19:26:48 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH RFC net-next 05/12] net: dsa: bcm_sf2: convert to
 phylink_generic_validate()
Message-ID: <Ya5j+BtrNyTshf+s@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRs-00D8LK-N3@rmk-PC.armlinux.org.uk>
 <6ef4f764-cd91-91bd-e921-407e9d198179@gmail.com>
 <3b3fed98-0c82-99e9-dc72-09fe01c2bcf3@gmail.com>
 <Yast4PrQGGLxDrCy@shell.armlinux.org.uk>
 <YauArR7bd6Xh4ISt@shell.armlinux.org.uk>
 <bbe1c983-788f-0561-a897-53f2ab4508df@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbe1c983-788f-0561-a897-53f2ab4508df@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 09:06:53AM -0800, Florian Fainelli wrote:
> On 12/4/21 6:52 AM, Russell King (Oracle) wrote:
> > On Sat, Dec 04, 2021 at 08:59:12AM +0000, Russell King (Oracle) wrote:
> >> It will be:
> >>
> >>         s = phy_lookup_setting(pl->link_config.speed, pl->link_config.duplex,
> >>                                pl->supported, true);
> >>         linkmode_zero(pl->supported);
> >>         phylink_set(pl->supported, MII);
> >>         phylink_set(pl->supported, Pause);
> >>         phylink_set(pl->supported, Asym_Pause);
> >>         phylink_set(pl->supported, Autoneg);
> >>         if (s) {
> >>                 __set_bit(s->bit, pl->supported);
> >>                 __set_bit(s->bit, pl->link_config.lp_advertising);
> >>
> >> Since 1000baseKX_Full is set in the supported mask, phy_lookup_setting()
> >> returns the first entry it finds in the supported table:
> >>
> >>         /* 1G */
> >>         PHY_SETTING(   1000, FULL,   1000baseKX_Full            ),
> >>         PHY_SETTING(   1000, FULL,   1000baseT_Full             ),
> >>         PHY_SETTING(   1000, HALF,   1000baseT_Half             ),
> >>         PHY_SETTING(   1000, FULL,   1000baseT1_Full            ),
> >>         PHY_SETTING(   1000, FULL,   1000baseX_Full             ),
> >>
> >> Consequently, 1000baseKX_Full is preferred over 1000baseT_Full.
> >>
> >> Fixed links don't specify their underlying technology, only the speed
> >> and duplex, so going from speed and duplex to an ethtool link mode is
> >> not easy. I suppose we could drop 1000baseKX_Full from the supported
> >> bitmap in phylink_parse_fixedlink() before the first phylink_validate()
> >> call. Alternatively, the table could be re-ordered. It was supposed to
> >> be grouped by speed and sorted in descending match priority as specified
> >> by the comment above the table. Does it really make sense that
> >> 1000baseKX_Full is supposed to be preferred over all the other 1G
> >> speeds? I suppose that's a question for Tom Lendacky
> >> <thomas.lendacky@amd.com>, who introduced this in 3e7077067e80
> >> ("phy: Expand phy speed/duplex settings array") back in 2014.
> > 
> > Here's a patch for one of my suggestions above. Tom, I'd appreciate
> > if you could look at this please. Thanks.
> 
> I don't have objections on the patch per-se, but I am still wary that
> this is going to break another driver in terms of what its fixed link
> ports are supposed to report, so maybe the generic validation approach
> needs to be provided some additional hints as to what port link modes
> are supported, or rather, not supported.

Honestly, I'm not sure I'd call this a breakage, when we haven't really
cared that the link modes for fixed links reflect the underlying link
in the past.

Fixed-links started out (and still are for the vast majority of
drivers that use phylib for their fixed links) as being an emulation of
a copper PHY. Thus, they end up with baseT linkmodes no matter what the
actual underlying link is.

Phylink provides a fixed-link implementation that is supposed to be
broadly similar to the original phylib based implementation without
using the emulation of a PHY directly, allowing it greater flexibility
in the link speeds that it can support.

It was never intended for a MAC driver to restrict the linkmode
technologies - and doing so goes completely against the phylink design
principle and also the phylink documentation. Restricting the linkmodes
based on technologoy encodes information about the setup of the world
outside of the MAC block into the MAC driver. This is actually a
problem that needs to be sorted.

Consider a driver which decides to restrict linkmodes based on
technology, such as the Marvell DSA which presently allows only
1000baseX and 1000baseT linkmodes (at the time, there was no 1000baseKX
ethtool linkmode.) Now someone comes along with a board design that
interfaces one of the Marvell DSA ports to a PHY that supports
1000baseKX. They add 1000baseKX to the linkmodes that Marvell DSA now
lets through.

Any fixed link on Marvell DSA now ends up reporting 1000baseKX instead
of 1000baseT as it used to before, even if the underlying link was
actually 1000baseX. (This is why I say, we don't actually care what
technology has historically been reported - it demonstrably is very
much the case.)

Now, going on further, there is the argument that we should be
reporting baseT link modes for fixed links up to 1G speeds, since fixed
links provide emulation of a copper PHY. For non-phylink, that copper
PHY emulation was to allow phylib to be re-used for fixed-links, and
thus you only ever get baseT linkmodes reported (and phylib-based fixed
links only go up to 1G speeds.) If we don't fix this, then converting
to phylink results in 1000baseKX being selected if one is compliant
with the above.

Then there's the argument that we have never really cared for the
actual technology of a fixed link. For example, on the VF610 ZII rev B
board, which uses the Freescale FEC driver (using phylib, not phylink),
the port used to talk to the DSA switches reports:

Settings for eth1:
        Supported ports: [ TP MII ]
        Supported link modes:   100baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  100baseT/Full
...

Even though there is no twisted-pair copper link in sight - it's
actually a RMII link, but we don't have any ethtool link modes to
describe that.

This was also true for Clearfog with its DSA switch connected via
1000BASE-X, except there we used to get 1000baseT/Full with the phylib-
based fixed link prior to phylink.

Then there's fixed links that use 10000/Full - these will end up being
10000baseCR/Full... even though they are not 10000baseCR - and again,
we don't actually have an ethtool linkmode that reports what they are.

So, really, the whole "technology" thing for fixed links is very vague
and we have never actually cared if it actually reports the link.

If MAC drivers restrict the technology to make fixed links "work" as
they expect, they are restricting the technologies that the connection
as a whole can support when not operating in fixed-link mode, and that
is plain wrong.

> So I would suggest we have bcm_sf2 continue to implement
> ds->ops->validate which does call phylink_generic_validate() but also
> prunes unsupported link modes for its fixed link ports, what do you
> think?

I'm not keen as I want to kill off .validate entirely, and not have its
legacy hanging around making future development (e.g. to properly
support rate-adaption) more difficult. I've been looking at this
recently and I just can't come up with a clean way to have a MAC and
PCS split where either the PCS or PHY do rate adaption without the MAC
being fully aware that is going on in its validate() method.

So, rather than keeping this around, if there is a need to specify the
technology, I would rather introduce another field into phylink_config,
misnamed, as "mac_techologies" which indicates whether we wish to
restrict to baseT/baseX/baseKX etc and this _only_ gets used for
fixed-links. It's misnamed because the MAC should have nothing to do
with this, and it's a hack to allow people to have their preferred
ethtool linkmodes.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
