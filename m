Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B40297C42
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 14:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761262AbgJXMOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 08:14:42 -0400
Received: from inva020.nxp.com ([92.121.34.13]:35090 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761237AbgJXMOj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Oct 2020 08:14:39 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id EF14F1A0C0A;
        Sat, 24 Oct 2020 14:14:36 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DF0301A0BB1;
        Sat, 24 Oct 2020 14:14:36 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C67F8202EC;
        Sat, 24 Oct 2020 14:14:35 +0200 (CEST)
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
Subject: [RFC net-next 1/5] net: phy: export phy_error and phy_trigger_machine
Date:   Sat, 24 Oct 2020 15:14:08 +0300
Message-Id: <20201024121412.10070-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201024121412.10070-1-ioana.ciornei@nxp.com>
References: <20201024121412.10070-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These functions are currently used by phy_interrupt() to either signal
an error condition or to trigger the link state machine. In an attempt
to actually support shared PHY IRQs, export these two functions so that
the actual PHY drivers can use them.

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
 drivers/net/phy/phy.c | 6 ++++--
 include/linux/phy.h   | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 35525a671400..477bdf2f94df 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -493,10 +493,11 @@ EXPORT_SYMBOL(phy_queue_state_machine);
  *
  * @phydev: the phy_device struct
  */
-static void phy_trigger_machine(struct phy_device *phydev)
+void phy_trigger_machine(struct phy_device *phydev)
 {
 	phy_queue_state_machine(phydev, 0);
 }
+EXPORT_SYMBOL(phy_trigger_machine);
 
 static void phy_abort_cable_test(struct phy_device *phydev)
 {
@@ -924,7 +925,7 @@ void phy_stop_machine(struct phy_device *phydev)
  * Must not be called from interrupt context, or while the
  * phydev->lock is held.
  */
-static void phy_error(struct phy_device *phydev)
+void phy_error(struct phy_device *phydev)
 {
 	WARN_ON(1);
 
@@ -934,6 +935,7 @@ static void phy_error(struct phy_device *phydev)
 
 	phy_trigger_machine(phydev);
 }
+EXPORT_SYMBOL(phy_error);
 
 /**
  * phy_disable_interrupts - Disable the PHY interrupts from the PHY side
diff --git a/include/linux/phy.h b/include/linux/phy.h
index eb3cb1a98b45..566b39f6cd64 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1570,8 +1570,10 @@ void phy_drivers_unregister(struct phy_driver *drv, int n);
 int phy_driver_register(struct phy_driver *new_driver, struct module *owner);
 int phy_drivers_register(struct phy_driver *new_driver, int n,
 			 struct module *owner);
+void phy_error(struct phy_device *phydev);
 void phy_state_machine(struct work_struct *work);
 void phy_queue_state_machine(struct phy_device *phydev, unsigned long jiffies);
+void phy_trigger_machine(struct phy_device *phydev);
 void phy_mac_interrupt(struct phy_device *phydev);
 void phy_start_machine(struct phy_device *phydev);
 void phy_stop_machine(struct phy_device *phydev);
-- 
2.28.0

