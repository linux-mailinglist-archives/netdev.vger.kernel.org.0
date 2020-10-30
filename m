Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFAB2A11AE
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 00:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbgJ3Xgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 19:36:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55664 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJ3Xgl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 19:36:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYdwZ-004RBd-P3; Sat, 31 Oct 2020 00:36:27 +0100
Date:   Sat, 31 Oct 2020 00:36:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
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
Subject: Re: [PATCH net-next 00/19] net: phy: add support for shared
 interrupts (part 1)
Message-ID: <20201030233627.GA1054829@lunn.ch>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
 <d05587fc-0cec-59fb-4e84-65386d0b3d6b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d05587fc-0cec-59fb-4e84-65386d0b3d6b@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > - Every PHY driver gains a .handle_interrupt() implementation that, for
> >   the most part, would look like below:
> > 
> > 	irq_status = phy_read(phydev, INTR_STATUS);
> > 	if (irq_status < 0) {
> > 		phy_error(phydev);
> > 		return IRQ_NONE;
> > 	}
> > 
> > 	if (irq_status == 0)
> 
> Here I have a concern, bits may be set even if the respective interrupt
> source isn't enabled. Therefore we may falsely blame a device to have
> triggered the interrupt. irq_status should be masked with the actually
> enabled irq source bits.

Hi Heiner

I would say that is a driver implementation detail, for each driver to
handle how it needs to handle it. I've seen some hardware where the
interrupt status is already masked with the interrupt enabled
bits. I've soon other hardware where it is not.

For example code, what is listed above is O.K. The real implementation
in a driver need knowledge of the hardware.

      Andrew
