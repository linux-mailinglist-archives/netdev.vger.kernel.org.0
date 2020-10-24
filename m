Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C6B297C47
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 14:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761322AbgJXMP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 08:15:26 -0400
Received: from inva020.nxp.com ([92.121.34.13]:35194 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761240AbgJXMOl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Oct 2020 08:14:41 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 56A531A0BF9;
        Sat, 24 Oct 2020 14:14:39 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 3DF2D1A0BF8;
        Sat, 24 Oct 2020 14:14:39 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 259C2202EC;
        Sat, 24 Oct 2020 14:14:38 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
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
Subject: [RFC net-next 3/5] net: phy: make .ack_interrupt() optional
Date:   Sat, 24 Oct 2020 15:14:10 +0300
Message-Id: <20201024121412.10070-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201024121412.10070-1-ioana.ciornei@nxp.com>
References: <20201024121412.10070-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a first step into making phylib and all PHY drivers to actually
have support for shared IRQs, make the .ack_interrupt() callback
optional.

After all drivers have been moved to implement the generic
interrupt handle, the phy_drv_supports_irq() check will be
changed again to only require the .handle_interrupts() callback.

Cc: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Andre Edich <andre.edich@microchip.com>
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Dan Murphy <dmurphy@ti.com>
Cc: Divya Koppera <Divya.Koppera@microchip.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jerome Brunet <jbrunet@baylibre.com>
Cc: Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Cc: Marek Vasut <marex@denx.de>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Mathias Kresin <dev@kresin.me>
Cc: Maxim Kochetkov <fido_max@inbox.ru>
Cc: Michael Walle <michael@walle.cc>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Nisar Sayed <Nisar.Sayed@microchip.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Philippe Schenker <philippe.schenker@toradex.com>
Cc: Willy Liu <willy.liu@realtek.com>
Cc: Yuiko Oshino <yuiko.oshino@microchip.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/phy_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 413a0a2c5d51..f54f483d7fd6 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2815,7 +2815,7 @@ EXPORT_SYMBOL(phy_get_internal_delay);
 
 static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 {
-	return phydrv->config_intr && phydrv->ack_interrupt;
+	return phydrv->config_intr && (phydrv->ack_interrupt || phydrv->handle_interrupt);
 }
 
 /**
-- 
2.28.0

