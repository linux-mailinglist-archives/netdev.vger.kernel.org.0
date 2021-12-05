Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35439468AE4
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 13:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbhLENCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 08:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhLENCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 08:02:34 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45F7C061714
        for <netdev@vger.kernel.org>; Sun,  5 Dec 2021 04:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jjeQbDVlWgeFj6Dl+5p5YYPVI5Djo6Fw7UQSE4wmEvo=; b=rSWXWmSKmo/n1qjFrQa+RMt6At
        yf2JzMZGkPXXnfYCO0IG1TnaUzhDAnctngNMHYyIU1ogW+LiRXlZNF9q+5pqR/KlIMVth97HgKY43
        9j4mREacJmp79BRiU9eid6fWC5AQ0F1OmMwL74erw0dhrGHMdYJO0PNGq0D6grmkioDekA+EvhUX1
        eapWaicukR2s0bXzNfDVf33lC6hef66cQ4IAfqBWM4j8kH7QRuhjmHUqJlvltcGAuztnKHMUxXQL0
        daWrD3mcynjY/y5aCTihTADNxiMRHwnsIdYccW0DXUCpS/SHeT4lsdgdQ/1LkOc3BF5LVZrXYQOKH
        U7PCr3Tg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56078)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mtr6K-0003vO-6n; Sun, 05 Dec 2021 12:58:44 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mtr6G-0003Oy-VR; Sun, 05 Dec 2021 12:58:40 +0000
Date:   Sun, 5 Dec 2021 12:58:40 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
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
Message-ID: <Yay3gF32Nb3Y3pd3@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRs-00D8LK-N3@rmk-PC.armlinux.org.uk>
 <6ef4f764-cd91-91bd-e921-407e9d198179@gmail.com>
 <3b3fed98-0c82-99e9-dc72-09fe01c2bcf3@gmail.com>
 <Yast4PrQGGLxDrCy@shell.armlinux.org.uk>
 <YauArR7bd6Xh4ISt@shell.armlinux.org.uk>
 <YauCzEZPGMaRMKf6@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YauCzEZPGMaRMKf6@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 04, 2021 at 04:01:32PM +0100, Andrew Lunn wrote:
> > The order of 1000baseKX/Full and 1000baseT/Full is such that we
> > prefer 1000baseKX/Full over 1000baseT/Full, but 1000baseKX/Full is
> > a lot rarer than 1000baseT/Full, and thus is much less likely to
> > be preferred.
> > 
> > This causes phylink problems - it means a fixed link specifying a
> > speed of 1G and full duplex gets an ethtool linkmode of 1000baseKX/Full
> > rather than 1000baseT/Full as would be expected - and since we offer
> > userspace a software emulation of a conventional copper PHY, we want
> > to offer copper modes in preference to anything else. However, we do
> > still want to allow the rarer modes as well.
> 
> 2.5G already places T before X, so it makes it more uniform with that.
> 
> For 10G, T comes last. Maybe we should also consider this case?  Do we
> see more 10G copper than fibre/backplane?

For a fixed link, I'm not sure - but given that speeds higher than 1G
can't be emulated by the C22 PHY emulation, does it really matter?

Looking through the DTs that we have in the kernel tree, we have some
fixed-links at 10G speed, and no one has complained, so I'd suggest
leaving sleeping dogs and all that.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
