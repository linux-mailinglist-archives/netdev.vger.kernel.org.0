Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05B146A68D
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 21:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349099AbhLFULS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 15:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbhLFULR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 15:11:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74D2C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 12:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=on4gnJrSF/qEEDL0kBcV57ILDOzTJjUgyL+PdckkYDg=; b=gi0Mds1s0Bq4OBD9729UPvxULY
        iBMAC7dqpfzcnkvTe1Qg6qlQLRnkiSpf0NQBp++qvpejkmRW5e7hMtk0rHR9H50JJHhVZZ1df//vw
        OL1j1Ielp7XQTRUAfXMqteoNSOaXRiQNI2uAyVKgKjoQNsfLLb1GxaWDkBBCTTw00s8jUuLEEXCzG
        q/v3G06OChsSpg3rJxKjq1M70VCwkRqHDxiERFMi2mfvztiU8kyve2OvAtSjO5fWsWuhlM2c0n51Q
        YhQwrC9nBgYl7ilu1adehXaNSrDiSjaw0rt7BQyP7NifsIXJWsi1t+ngkRkRACL+rC6jmERHWuVAM
        77A0A/rA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56110)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1muKH4-0005G8-96; Mon, 06 Dec 2021 20:07:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1muKH3-0004bG-B9; Mon, 06 Dec 2021 20:07:45 +0000
Date:   Mon, 6 Dec 2021 20:07:45 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
References: <b98043f66e8c6f1fd75d11af7b28c55018c58d79.camel@collabora.com>
 <YapE3I0K4s1Vzs3w@lunn.ch>
 <b0643124f372db5e579b11237b65336430a71474.camel@collabora.com>
 <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
 <20211206183147.km7nxcsadtdenfnp@skbuf>
 <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206193730.oubyveywniyvptfk@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 09:37:30PM +0200, Vladimir Oltean wrote:
> On Mon, Dec 06, 2021 at 07:24:56PM +0000, Martyn Welch wrote:
> > Yes, that appears to also make it work.
> > 
> > Martyn
> 
> Well, I just pointed out what the problem is, I don't know how to solve
> it, honest! :)
> 
> It's clear that the code is wrong, because it's in an "if" block that
> checks for "of_phy_is_fixed_link(dp->dn) || phy_np" but then it omits
> the "phy_np" part of it. On the other hand we can't just go ahead and
> say "if (phy_np) mode = MLO_AN_PHY; else mode = MLO_AN_FIXED;" because
> MLO_AN_INBAND is also a valid option that we may be omitting. So we'd
> have to duplicate part of the logic from phylink_parse_mode(), which
> does not appear ideal at all. What would be ideal is if this fabricated
> phylink call would not be done at all, but I don't know enough about the
> systems that need it, I expect Andrew knows more.

It's needed because otherwise we end up reconfiguring a CPU link while
it is still "up". Phylink's initial mode is "link down" and the phylink
design is such that it guarantees that we will not call mac_link_down()
unless the link was previously up. This is true of all network drivers,
but was found to be false for some DSA drivers, and some DSA broke as
a result.

My conclusion from having read this thread is the CPU port is using PPU
polling, meaning that in mac_link_up():

        if ((!mv88e6xxx_phy_is_internal(ds, port) &&
             !mv88e6xxx_port_ppu_updates(chip, port)) ||
            mode == MLO_AN_FIXED) {

is false - because mv88e6xxx_port_ppu_updates() returns true, and
consequently we never undo this force-down. On Marvell hardware, the
PPU updating effectively makes it appear as an in-band link as the
hardware fetches the PHY status to the MAC by polling the PHY.

What we do elsewhere is we handle the link-up-down-forcing in
mac_config appropriate to the mode, and we already do that in Marvell
DSA:

        /* Undo the forced down state above after completing configuration
         * irrespective of its state on entry, which allows the link to come up.         */
        if (mode == MLO_AN_INBAND && p->interface != state->interface &&
            chip->info->ops->port_set_link)
                chip->info->ops->port_set_link(chip, port, LINK_UNFORCED);

I'm thinking this needs set LINK_UNFORCED here if the PPU is polling
and we're in MLO_AN_PHY mode:

	if (((mode == MLO_AN_INBAND && p->interface != state->interface) ||
	     (mode == MLO_AN_PHY && mv88e6xxx_port_ppu_updates(chip, port))) &&
	    chip->info->ops->port_set_link)
		chip->info->ops->port_set_link(chip, port, LINK_UNFORCED);

What I don't know is whether that mv88e6xxx_port_ppu_updates() 
should be mv88e6xxx_phy_is_internal() || mv88e6xxx_port_ppu_updates(),
at which point introducing a helper for that would probably be a good
idea, or it might be simpler to use the new phylink_get_caps() ability
to set phylink_config.ovr_an_inband for the internal/ppu polled ports
if they're not operating in fixed link mode. This is essentially what
is going on here - the PPU polling is just a way of replicating SGMII's
propagation of the PHY status to the MAC.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
