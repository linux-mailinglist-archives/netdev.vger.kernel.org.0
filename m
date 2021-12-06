Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB02146AB5B
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 23:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356490AbhLFWZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 17:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350032AbhLFWZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 17:25:47 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C72CC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 14:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KXI7ERi7PuvQHGIOrxcKICw61QCjNFqUxYI61Z/1VWw=; b=fgKYsztJtMbgNglN19c96q3x4e
        hgBAfqtp79SO+9Ti/bGN0BFBydhrQYxI1wb1mUdCEjoKwm0l+pylZT+yN6hARQedac7I0roQCscgj
        20flbBa3OzzaFBP679r5ii7s+58H5hjk6L4IunAdYdOCbz6dj6qgS5QSLITG6YRJ2UIeFsDo1t454
        A/IdkchltjajSm21CRobXJ80AonoRWxf8Qq+crqhfP93LkA7O9rTp7nbQnlbLmf2OVVQAcCfVP7+M
        8R/veBHsqcdlNEqbsKImhd4xpSA4rBlIMOmWBedjYOfH6JmfdG7tO1Hcdhlpvt8jhroVLWEiCswVD
        ZNYq609g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56126)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1muMND-0005Su-Vn; Mon, 06 Dec 2021 22:22:16 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1muMND-0004i3-4Z; Mon, 06 Dec 2021 22:22:15 +0000
Date:   Mon, 6 Dec 2021 22:22:15 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <Ya6NF9OxSmLO9hv+@shell.armlinux.org.uk>
References: <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
 <20211206202308.xoutfymjozfyhhkl@skbuf>
 <Ya53vXp7Wz5YPf7Y@shell.armlinux.org.uk>
 <20211206211341.ppllxa7ve2jdyzt4@skbuf>
 <Ya6ARQBGl2C4Z3il@shell.armlinux.org.uk>
 <20211206215139.fv7xzqbnupk7pxfx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206215139.fv7xzqbnupk7pxfx@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 11:51:39PM +0200, Vladimir Oltean wrote:
> On Mon, Dec 06, 2021 at 09:27:33PM +0000, Russell King (Oracle) wrote:
> > On Mon, Dec 06, 2021 at 11:13:41PM +0200, Vladimir Oltean wrote:
> > > On Mon, Dec 06, 2021 at 08:51:09PM +0000, Russell King (Oracle) wrote:
> > > > With a bit of knowledge of how Marvell DSA switches work...
> > > > 
> > > > The "ppu" is the PHY polling unit. When the switch comes out of reset,
> > > > the PPU probes the MDIO bus, and sets the bit in the port status
> > > > register depending on whether it detects a PHY at the port address by
> > > > way of the PHY ID values. This bit is used to enable polling of the
> > > > PHY and is what mv88e6xxx_port_ppu_updates() reports. This bit will be
> > > > set for all internal PHYs unless we explicitly turn it off (we don't.)
> > > > Therefore, this is a reasonable assumption to make.
> > > > 
> > > > So, given that mv88e6xxx_port_ppu_updates() is most likely true as
> > > > I stated, it is also true that mv88e6xxx_phy_is_internal() is
> > > > "don't care".
> > > 
> > > And the reason why you bring the PPU into the discussion is because?
> > > If the issue manifests itself with or without it, and you come up with a
> > > proposal to set LINK_UNFORCED in mv88e6xxx_mac_config if the PPU is
> > > used, doesn't that, logically speaking, still leave the issue unsolved
> > > if the PPU is _not_ used for whatever reason?
> > > The bug has nothing to do with the PPU. It can be solved by checking for
> > > PPU in-band status as you say. Maybe. But I've got no idea why we don't
> > > address the elephant in the room, which is in dsa_port_link_register_of()?
> > 
> > I think I've covered that in the other sub-thread.
> > 
> > It could be that a previous configuration left the port forced down.
> > For example, if one were to kexec from one kernel that uses a
> > fixed-link that forced the link down, into the same kernel with a
> > different DT that uses PHY mode.
> > 
> > The old kernel may have called mac_link_down(MLO_AN_FIXED), and the
> > new kernel wouldn't know that. It comes along, and goes through the
> > configuration process and calls mac_link_up(MLO_AN_PHY)... and from
> > what you're suggesting, because these two calls use different MLO_AN_xxx
> > constants that's a bug.
> 
> Indeed I don't have detailed knowledge of Marvell hardware, but I'm
> surprised to see kexec being mentioned here as a potential source of
> configurations which the driver does not expect to handle. My belief was
> that kexec's requirements would be just to silence the device
> sufficiently such that it doesn't cause any surprises when things such
> interrupts are enabled (DMA isn't relevant for DSA switches).
> It wouldn't be responsible for leaving the hardware in any other state
> otherwise.
> 
> I see this logic in the driver, does it not take care of bringing the
> ports to a known state, regardless of what a previous boot stage may
> have done?
> 
> static int mv88e6xxx_switch_reset(struct mv88e6xxx_chip *chip)
> {
> 	int err;
> 
> 	err = mv88e6xxx_disable_ports(chip);
> 	if (err)
> 		return err;
> 
> 	mv88e6xxx_hardware_reset(chip);
> 
> 	return mv88e6xxx_software_reset(chip);
> }
> 
> So unless I'm fooled by mentally putting an equality sign between
> mv88e6xxx_switch_reset() and getting rid of whatever a previous kernel
> may have done, I don't think at all that the two cases are comparable:
> kexec and a previous call to mv88e6xxx_mac_link_down() initiated by
> dsa_port_link_register_of() from this kernel.

If the hardware reset is not wired to be under software control or is
not specified, then mv88e6xxx_hardware_reset() is a no-op.

mv88e6xxx_software_reset() does not fully reinitialise the switch.
To quote one switch manual for the SWReset bit "Register values are not
modified." That means if the link was forced down previously by writing
to the port control register, the port remains forced down until
software changes that register to unforce the link, or to force the
link up.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
