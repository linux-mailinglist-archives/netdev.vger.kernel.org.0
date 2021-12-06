Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5971E46AAF8
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 22:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhLFVzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 16:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356393AbhLFVzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 16:55:11 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE21C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 13:51:42 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id y12so48458363eda.12
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 13:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xN6o9uhiwgXcT+KtV7n/ehlkfyYl78rbr/f6pO54zZI=;
        b=AECl9+vfb8mjypG6Z9jmYswBJ74CXJXXoRnGgI2d3B/JaUxkR2kk3j4JvhdaA2TjvA
         vzSTLIqem/OY6fCFov7f7PBnJtmfFTognzoseHyG7dQ0SuGGFIu++Z5cX3H+J88mxeSJ
         ktPKwsVKOrrdN7xT79CoFcsUPeKJ8kjCqlkWyCq2i+WIGlGGzX+AsEZweaYO+a1bn6+d
         z0Cl2o/3Cxxm2Dngxcgx3kyjoKH4LyHB+GppnUDeOlfslaF49LGizOHQaMJdhuFVrSe+
         00nC1PUIXz2MxPT7NCQfBGG0ykJzCMj+GDqkbRNYvwjD0N78xedBhl+PQnfa9x0rZKR4
         vo+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xN6o9uhiwgXcT+KtV7n/ehlkfyYl78rbr/f6pO54zZI=;
        b=AV3ilQeMrAvKx0Yjsb+xPvsSMsVoWWIXQeORaQCTIP9RscicDvs87MJ5gcBqaXRLd3
         fFPpfaoAUDWoJwhbStoDFpr9s1207s44ecXboaREHVmeeagLRYdMYc8IkrnAKGt9jLf7
         w8mG1r4DcYE+Dmx+b6jx4uOeylgBO5e0Sqv7nsPwo7YSzQRhtoA1f/5GDBt429LvZAfT
         bmsAgGaWs8Z8c2NvcTdwewwuq3HgIcZGXXbgCyQL0idBVDT898ceNaUegq04QhMBT7V1
         7xGEeiNi64pfxQCtiJDb7CQhNgnkUb3BdNU1OvD5EEHV4oc/I97YvlKPHYJs84cXlAEP
         l0tA==
X-Gm-Message-State: AOAM530BDRqjnBWYN7qouwkRLFv2adFOeIwWsn9MXSUU0vYBX1FC43lb
        fEU8plVru4h/c4qk8zyh1N4=
X-Google-Smtp-Source: ABdhPJweyaaPxvQEquFR/Z+y/uJ0q6sX5Dg0qLALjom0FlF4o4WzzatIF6qMaGWLYYBTCQrwNHahjA==
X-Received: by 2002:a17:906:3b18:: with SMTP id g24mr48711201ejf.27.1638827500944;
        Mon, 06 Dec 2021 13:51:40 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id de15sm7140117ejc.70.2021.12.06.13.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 13:51:40 -0800 (PST)
Date:   Mon, 6 Dec 2021 23:51:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <20211206215139.fv7xzqbnupk7pxfx@skbuf>
References: <20211206183147.km7nxcsadtdenfnp@skbuf>
 <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
 <20211206202308.xoutfymjozfyhhkl@skbuf>
 <Ya53vXp7Wz5YPf7Y@shell.armlinux.org.uk>
 <20211206211341.ppllxa7ve2jdyzt4@skbuf>
 <Ya6ARQBGl2C4Z3il@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya6ARQBGl2C4Z3il@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 09:27:33PM +0000, Russell King (Oracle) wrote:
> On Mon, Dec 06, 2021 at 11:13:41PM +0200, Vladimir Oltean wrote:
> > On Mon, Dec 06, 2021 at 08:51:09PM +0000, Russell King (Oracle) wrote:
> > > With a bit of knowledge of how Marvell DSA switches work...
> > > 
> > > The "ppu" is the PHY polling unit. When the switch comes out of reset,
> > > the PPU probes the MDIO bus, and sets the bit in the port status
> > > register depending on whether it detects a PHY at the port address by
> > > way of the PHY ID values. This bit is used to enable polling of the
> > > PHY and is what mv88e6xxx_port_ppu_updates() reports. This bit will be
> > > set for all internal PHYs unless we explicitly turn it off (we don't.)
> > > Therefore, this is a reasonable assumption to make.
> > > 
> > > So, given that mv88e6xxx_port_ppu_updates() is most likely true as
> > > I stated, it is also true that mv88e6xxx_phy_is_internal() is
> > > "don't care".
> > 
> > And the reason why you bring the PPU into the discussion is because?
> > If the issue manifests itself with or without it, and you come up with a
> > proposal to set LINK_UNFORCED in mv88e6xxx_mac_config if the PPU is
> > used, doesn't that, logically speaking, still leave the issue unsolved
> > if the PPU is _not_ used for whatever reason?
> > The bug has nothing to do with the PPU. It can be solved by checking for
> > PPU in-band status as you say. Maybe. But I've got no idea why we don't
> > address the elephant in the room, which is in dsa_port_link_register_of()?
> 
> I think I've covered that in the other sub-thread.
> 
> It could be that a previous configuration left the port forced down.
> For example, if one were to kexec from one kernel that uses a
> fixed-link that forced the link down, into the same kernel with a
> different DT that uses PHY mode.
> 
> The old kernel may have called mac_link_down(MLO_AN_FIXED), and the
> new kernel wouldn't know that. It comes along, and goes through the
> configuration process and calls mac_link_up(MLO_AN_PHY)... and from
> what you're suggesting, because these two calls use different MLO_AN_xxx
> constants that's a bug.

Indeed I don't have detailed knowledge of Marvell hardware, but I'm
surprised to see kexec being mentioned here as a potential source of
configurations which the driver does not expect to handle. My belief was
that kexec's requirements would be just to silence the device
sufficiently such that it doesn't cause any surprises when things such
interrupts are enabled (DMA isn't relevant for DSA switches).
It wouldn't be responsible for leaving the hardware in any other state
otherwise.

I see this logic in the driver, does it not take care of bringing the
ports to a known state, regardless of what a previous boot stage may
have done?

static int mv88e6xxx_switch_reset(struct mv88e6xxx_chip *chip)
{
	int err;

	err = mv88e6xxx_disable_ports(chip);
	if (err)
		return err;

	mv88e6xxx_hardware_reset(chip);

	return mv88e6xxx_software_reset(chip);
}

So unless I'm fooled by mentally putting an equality sign between
mv88e6xxx_switch_reset() and getting rid of whatever a previous kernel
may have done, I don't think at all that the two cases are comparable:
kexec and a previous call to mv88e6xxx_mac_link_down() initiated by
dsa_port_link_register_of() from this kernel.

> 
> An alternative: the hardware boots up with the link forced down. The
> boot loader doesn't touch it. The kernel boots and calls
> mac_link_up(MLO_AN_PHY).

Again, in my simplistic view, the switch reset deals with this too.
Maybe I'm wrong.

> This all works as expected with e.g. mvneta. It doesn't work with
> Marvell DSA because we have all these additional extra exceptional
> cases to deal with the PPU (which is what _actually_ transfers the
> PHY status to the port registers for all PHYs.)
> 
> We used to just rely on the PPU bit for making the decision, but when
> I introduced that helper, I forgot that the PPU bit doesn't exist on
> the 6250 family, which resulted in commit 4a3e0aeddf09. Looking at
> 4a3e0aeddf09, I now believe the fix there to be wrong. It should
> have made mv88e6xxx_port_ppu_updates() follow
> mv88e6xxx_phy_is_internal() for internal ports only for the 6250 family
> that has the link status bit in that position, especially as one can
> disable the PPU bit in DSA switches such as 6390, which for some ports
> stops the PHY being used and switches the port to serdes mode.
> "Internal" ports aren't always internal on these switches.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
