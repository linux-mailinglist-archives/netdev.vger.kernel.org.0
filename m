Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69DE297DB7
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 19:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762543AbgJXRRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 13:17:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42946 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760482AbgJXRRU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Oct 2020 13:17:20 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kWNA9-003IWW-CW; Sat, 24 Oct 2020 19:17:05 +0200
Date:   Sat, 24 Oct 2020 19:17:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Andre Edich <andre.edich@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Dan Murphy <dmurphy@ti.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Mathias Kresin <dev@kresin.me>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Michael Walle <michael@walle.cc>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Willy Liu <willy.liu@realtek.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: Re: [RFC net-next 0/5] net: phy: add support for shared interrupts
Message-ID: <20201024171705.GK745568@lunn.ch>
References: <20201024121412.10070-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201024121412.10070-1-ioana.ciornei@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> - Every PHY driver gains a .handle_interrupt() implementation that, for
>   the most part, would look like below:
> 
> 	irq_status = phy_read(phydev, INTR_STATUS);
> 	if (irq_status < 0) {
> 		phy_error(phydev);
> 		return IRQ_NONE;
> 	}
> 
> 	if (irq_status == 0)
> 		return IRQ_NONE;
> 
> 	phy_trigger_machine(phydev);
> 
> 	return IRQ_HANDLED;

Hi Ioana

It looks like phy_trigger_machine(phydev) could be left in the core,
phy_interrupt(). It just needs to look at the return code, IRQ_HANDLED
means trigger the state machine.

      Andrew
