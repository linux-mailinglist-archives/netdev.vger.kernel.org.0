Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E175D2A1DFF
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgKAMwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgKAMwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:21 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79DBC0617A6;
        Sun,  1 Nov 2020 04:52:20 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id p93so11345018edd.7;
        Sun, 01 Nov 2020 04:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ITnQoREiD0R8hOb4gJjCxvyKcXTKP7bB6oFRcdeycc0=;
        b=ET9UHHLDha/cqMvEKHzV/K07aL4AX0NqK+hY7e9676uF9nW+/9zvQB3U7gW7/XXj1J
         zBAJ4stwnt0X6Auj7HfpGFfO30LalUJwxQ7Dd8KeAbqNjwKF7dFlAA2aYsC28VwnkhfU
         TuKajePEN47Kpcmpy0Rq+nV9/li8Xnxaussx74TtDR8yZICHi7h+DM79bkCruecK+ba1
         IZNX/nHvRubeUoM9zm7QN4frBtcHn0IvSm6par4o91HVy+qJFQB8hKrMGl4J6TlqpFs9
         46RWHAsZKt5yhTBxB9mGlIH2bH4UXcwwEO4av2XPRwWtdzrAfA61stbQk9SbG9kLw6qT
         bY8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ITnQoREiD0R8hOb4gJjCxvyKcXTKP7bB6oFRcdeycc0=;
        b=QeGoh0nrz14IK2PhNlZSJCb49cDOofv6yfUgfWQnUImb56lobJY3Yyy1Me8j/a2Ggn
         nRGi8d055Blm1Lfz/Bvx1/gm6sT1WKI+koKJ5tr2McuLlIJ4ttSy3SqfNqrqgyZt2/10
         FHvIB2X2kfHESLlc/cTR0xWCJ2qieq8RFf4Z0zxijGSDSm8TANX1fk2jH39X1f5DL6Zn
         W+qNGVVEixtj6xXRiwLfOHISfPl2At9uezSo1Emg9/ANuEwMzk06uIvzvlfY6Bht0ziO
         tuhpwYwGVh5Iq7CFPk2erM7+MAa8xlBm7xKvrzHg4G/G5x77ilOAU9DTQFvfu0xtI2s5
         lDLA==
X-Gm-Message-State: AOAM530GnxOaFawuiHjtmYR0LP0Klw6eGn7Ha/WH4RpfqfMJUnw5Ftv9
        i1oyirsJaHuiQWLFxSJrmU0=
X-Google-Smtp-Source: ABdhPJxNVwjkameOvNKYxN7cZ5wwCM5rQd6pEgz/4WXk12m7mBmxj6CT764N0tKbBgg8E3z0DEPBxw==
X-Received: by 2002:a50:e149:: with SMTP id i9mr12171491edl.56.1604235139679;
        Sun, 01 Nov 2020 04:52:19 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:19 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: [PATCH net-next v2 01/19] net: phy: export phy_error and phy_trigger_machine
Date:   Sun,  1 Nov 2020 14:50:56 +0200
Message-Id: <20201101125114.1316879-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201101125114.1316879-1-ciorneiioana@gmail.com>
References: <20201101125114.1316879-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

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
Changes in v2:
 - none

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

