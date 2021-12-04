Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A504685D3
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 16:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243774AbhLDPFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 10:05:19 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38756 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242924AbhLDPFS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 10:05:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KgcZSQrkUOjOdOqkhz9mxDbnBWTSOn3SBXI3R+M2YMU=; b=N3vpFzNcWBfXhw9IXnWMCkGotC
        hqHTwsAkWW9bcy4okbbRKlKdq7eovq1VZxlE0uI+g5hTih3D7hsHuTRkMR1ZlO3Grt5DtvXziZb3A
        qSr0pZQI+TO60Joys8lBWqfw2LpM3ZixGwoXRrlOaBGh80hQq5JG7bNAwSj4q6S/e+X4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mtWXc-00FVgM-SP; Sat, 04 Dec 2021 16:01:32 +0100
Date:   Sat, 4 Dec 2021 16:01:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
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
Message-ID: <YauCzEZPGMaRMKf6@lunn.ch>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRs-00D8LK-N3@rmk-PC.armlinux.org.uk>
 <6ef4f764-cd91-91bd-e921-407e9d198179@gmail.com>
 <3b3fed98-0c82-99e9-dc72-09fe01c2bcf3@gmail.com>
 <Yast4PrQGGLxDrCy@shell.armlinux.org.uk>
 <YauArR7bd6Xh4ISt@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YauArR7bd6Xh4ISt@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The order of 1000baseKX/Full and 1000baseT/Full is such that we
> prefer 1000baseKX/Full over 1000baseT/Full, but 1000baseKX/Full is
> a lot rarer than 1000baseT/Full, and thus is much less likely to
> be preferred.
> 
> This causes phylink problems - it means a fixed link specifying a
> speed of 1G and full duplex gets an ethtool linkmode of 1000baseKX/Full
> rather than 1000baseT/Full as would be expected - and since we offer
> userspace a software emulation of a conventional copper PHY, we want
> to offer copper modes in preference to anything else. However, we do
> still want to allow the rarer modes as well.

2.5G already places T before X, so it makes it more uniform with that.

For 10G, T comes last. Maybe we should also consider this case?  Do we
see more 10G copper than fibre/backplane?

    Andrew
