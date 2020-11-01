Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D100D2A1E1C
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgKAMw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgKAMwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:25 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E894C0617A6;
        Sun,  1 Nov 2020 04:52:23 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id w25so11396661edx.2;
        Sun, 01 Nov 2020 04:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9GApglWVha/Wm6ZpEPj/3soIrOPKEJEBr7djBJ0S7Zc=;
        b=lXMiEldW7rgzDtLCQps8xDZ8V3/IUgPnOpcIX9vnQuZk05RQFZmhfMATZJAN+SH6Ag
         iTBzjB6PiiaW2lFDqG84O7ZFSkss58Uzv8RGCBg+J6mc1Baq0hsg4iph5p7jmzPE30q9
         mJouEUfcjA1j31k3MC7DgL3jhrzpuLRjVbCFwcDDk4SczwT+4RlrO23OOe2GNOblmibX
         y7aLTe+a4kpGi/Hc+/RIX8l8YRH/MQuyR+F4RMaykcC8jC4nL+Ze4YD5gwt0CHH3pnxH
         l2sqrvn6yMwITWzi87OZGMLW1QcCQnJvyjuNUl2sZz5w/UPazI0yNJi62rD9jN6eswfw
         FhTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9GApglWVha/Wm6ZpEPj/3soIrOPKEJEBr7djBJ0S7Zc=;
        b=ReDyl4qnAGZ+yYCZrRo954pl0i4bcPjl6YaHEWWiY4jK9t/I7iHZlz7O+OryLDpE8Y
         hBwGtrB7wxDqaHZ9AUJkYPn0wIyEkUnsYktk6AWOmnsc0vuzm5xDwsOuq1W0G0CkZ7CI
         Nl2oO7BAKOEViFG+v03v7pZezKx1cT3OkgqLrQpWTeRLLCpMWVWhe03H4UOZP58TlALM
         E0i9urebtn5a1uUn0Hlm2NZB+cnYrD9E2Yun15zvHuuorPvBx1283McQ7ySLaSanZJUt
         jeXQ/YO+woTohMc7dQb7CKIvc0S6Vu5iFTyePmB0YS0goMw3HfFCQAnMklVBwcDi7qyj
         j7gw==
X-Gm-Message-State: AOAM530jAmmVOsxCpL+fvN2wi0LeBltxKppS7IvqdeZdAyzoNxkKq12z
        YBh9XoprX0ZI5IIIRMw5Mo8=
X-Google-Smtp-Source: ABdhPJz/pCpsWrsyO2fhSFmCi48xw34OkxhYxZ/bv7m/tfwSOzlmBh8b3HYZyzXH0dmXTT0NkNdMFg==
X-Received: by 2002:a50:fd99:: with SMTP id o25mr11355025edt.6.1604235142065;
        Sun, 01 Nov 2020 04:52:22 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:21 -0800 (PST)
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
Subject: [PATCH net-next v2 02/19] net: phy: add a shutdown procedure
Date:   Sun,  1 Nov 2020 14:50:57 +0200
Message-Id: <20201101125114.1316879-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201101125114.1316879-1-ciorneiioana@gmail.com>
References: <20201101125114.1316879-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

In case of a board which uses a shared IRQ we can easily end up with an
IRQ storm after a forced reboot.

For example, a 'reboot -f' will trigger a call to the .shutdown()
callbacks of all devices. Because phylib does not implement that hook,
the PHY is not quiesced, thus it can very well leave its IRQ enabled.

At the next boot, if that IRQ line is found asserted by the first PHY
driver that uses it, but _before_ the driver that is _actually_ keeping
the shared IRQ asserted is probed, the IRQ is not going to be
acknowledged, thus it will keep being fired preventing the boot process
of the kernel to continue. This is even worse when the second PHY driver
is a module.

To fix this, implement the .shutdown() callback and disable the
interrupts if these are used.

Note that we are still susceptible to IRQ storms if the previous kernel
exited with a panic or if the bootloader left the shared IRQ active, but
there is absolutely nothing we can do about these cases.

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

 drivers/net/phy/phy_device.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5dab6be6fc38..413a0a2c5d51 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2947,6 +2947,13 @@ static int phy_remove(struct device *dev)
 	return 0;
 }
 
+static void phy_shutdown(struct device *dev)
+{
+	struct phy_device *phydev = to_phy_device(dev);
+
+	phy_disable_interrupts(phydev);
+}
+
 /**
  * phy_driver_register - register a phy_driver with the PHY layer
  * @new_driver: new phy_driver to register
@@ -2970,6 +2977,7 @@ int phy_driver_register(struct phy_driver *new_driver, struct module *owner)
 	new_driver->mdiodrv.driver.bus = &mdio_bus_type;
 	new_driver->mdiodrv.driver.probe = phy_probe;
 	new_driver->mdiodrv.driver.remove = phy_remove;
+	new_driver->mdiodrv.driver.shutdown = phy_shutdown;
 	new_driver->mdiodrv.driver.owner = owner;
 	new_driver->mdiodrv.driver.probe_type = PROBE_FORCE_SYNCHRONOUS;
 
-- 
2.28.0

