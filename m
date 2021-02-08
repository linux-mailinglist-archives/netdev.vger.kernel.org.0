Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAA6313556
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbhBHOh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbhBHOgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:36:54 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36EBC061786;
        Mon,  8 Feb 2021 06:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PpJHE1jhhcZJ5XSixE7dqR0H/LdzaFtWtbMNUpSjYyI=; b=d/q/AV2/ZOstIsnIKGshZup5T
        WYMEXB69o9g4nyrY7XzyckkSDJUkmuahEY1R658pffr8zLzaDog7a0ds0JS9d5sSJutOKxLFytdUZ
        8GS4K8f138sO3i1A62YkursMf0n4Dkb2fdPVJbX8KeYiZb8lvz1ht4FhF2l6lm3OHM1ax/dJ7Jvsm
        TPGODMjOZx1+EJU8obQg4BJN/qlhMc+10fc3ZQCa+yjX40F3znJxUvcA8hBgY0znObDAlObI2LNgN
        7sPOzBxJG4kk4hTciED4AhGpXagli02AFZLmNGWG4hhGlYtaglPzqPg3nKo7Q8wNTwuziFkgL1I6n
        fmiJC2sRw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40794)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l97Pa-00023v-Jb; Mon, 08 Feb 2021 14:21:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l97PZ-00037D-7x; Mon, 08 Feb 2021 14:21:09 +0000
Date:   Mon, 8 Feb 2021 14:21:09 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>,
        linux-imx@nxp.com, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v1 5/7] ARM i.MX6q: remove Atheros AR8035 SmartEEE fixup
Message-ID: <20210208142107.GJ1463@shell.armlinux.org.uk>
References: <20210203091857.16936-1-o.rempel@pengutronix.de>
 <20210203091857.16936-6-o.rempel@pengutronix.de>
 <20210203095628.GP1463@shell.armlinux.org.uk>
 <20210208092038.cjmnycyctsapgy7w@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208092038.cjmnycyctsapgy7w@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 10:20:38AM +0100, Oleksij Rempel wrote:
> On Wed, Feb 03, 2021 at 09:56:28AM +0000, Russell King - ARM Linux admin wrote:
> > That is the historical fix for this problem, but there is a better
> > solution now in net-next - configuring the Tw parameter for gigabit
> > connections. That solves the random link drop issue when EEE is
> > enabled.
> 
> Do you mean this properties?
>   qca,smarteee-tw-us-1g
>   qca,smarteee-tw-us-100m
> 
> Do you have some recommendations, which values can be here used? Are
> they same for all MACs? Or, can we calculate this values automatically?

I don't think there's a way to "calculate" them.

The AR8035 default is 17us for 1G and 23us for 100M. Increasing the
1G Tw to 26us or 27us fixes it on several different Solidrun platforms
(iMX6 Hummingboards and Cubox-i, and LX2160A based). The boards all
have differing layouts, so I don't think it's layout or SoC specific
(which is good news.)

These figures have been arrived at by repetitive long-term testing and
observing whether there are sporadic link drops over these platforms.

> Beside, I have seen this patch: "ARM: dts: imx6qdl-sr-som: fix some
> cubox-i platforms"

That's for a different problem: moving these settings to DT broke
some Cubox-i platforms because of the weird ways that the AR8035
configures the address bits, using the LED pin. Tying a LED to the
LED pin is not sufficient to guarantee that a board always configures
the PHY to a particular address, so it can appear on address 0 or 4
depending on noise, temperature, supply voltage, and PHY chip
thresholds.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
