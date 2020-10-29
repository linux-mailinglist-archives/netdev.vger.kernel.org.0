Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DABB29E89B
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgJ2KIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgJ2KIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:08:43 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BA1C0613CF;
        Thu, 29 Oct 2020 03:08:42 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id v19so2412051edx.9;
        Thu, 29 Oct 2020 03:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1NVHrKVUzYrEX8zo6KX71XgjcTijKs3LoNtSkoA5/9Q=;
        b=kAZXdectd+O7+Gb0/8YCeaGC6D7DTDHvy3ZNs8BbfqZ9y8x1Hv2CARvTvP/idJo6dR
         WE2s2PM4qlqv4G+GCsJKvw0cwm3ZelWQqp8Lt79xYxqMXVY56ss80F8aakEBw2QK5y8f
         dstgOvGkhkzWZHe8ZthgSGd24OA+V4M6nd0+Sn+VbAMtYGGM/e2InwzSL5QiSFRTfGl3
         bHS+N44SAEjVRU8h6koOVoO8looC93064gf26B7YubNq5EFJ1sXIEmGJXjjhokrJbpR8
         sux9C4UthG05cGMEqUVm5oCMlTR0Xeon7k+caZ1D9HaGcCc2uHF2dNeDDs9PKSNJUgEP
         bJcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1NVHrKVUzYrEX8zo6KX71XgjcTijKs3LoNtSkoA5/9Q=;
        b=e4fXwuJH4qLKuuIzxVSx3vgeTCMUzhVMHNESl1UvQZeEsyLD8UGwM+mKTtczgsDUvx
         IOK7MH9OoHDUiy2p54uVOg1ig/amW5Xl+dPkvSAXuI/MFQR8RD/j4Vx1CJwD/LCCma1A
         kptxr9RlcozBK/JCh8Gajh5R+KWwmCJxjnSwJUoBMvwC8jW/2gY9IcvN7PujPmA2vxZu
         if7IALpGmmGquT1+1yJFSQVzYBq4HeWzm/Y91AJaPsH5hpjeaTZB5LS4pvw5V6Yc4Zza
         rDx1TKnHGULTL9WKrTxSKnhsoqIdXZMp5l5nzuYrpYyrQSDqB3oFL5LqwOSWVobQr2Ki
         MA7Q==
X-Gm-Message-State: AOAM5316mTQ60+kwROjioEdGfGOcK43uveYBC/RPxJ2d3m19Z2vtSC7R
        5LJlTyrRJFHT4sTzljWUKebhEdV5vva3HZ0x
X-Google-Smtp-Source: ABdhPJy/19857U64wTE1GZnXmRpjcnixLINUcbf01GJtyy/YuiJCh4yC50HbePWYuCUKIaJRtqh48A==
X-Received: by 2002:a50:d751:: with SMTP id i17mr3153897edj.337.1603966121342;
        Thu, 29 Oct 2020 03:08:41 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm1198650ejj.117.2020.10.29.03.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:08:40 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
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
Subject: [PATCH net-next 02/19] net: phy: add a shutdown procedure
Date:   Thu, 29 Oct 2020 12:07:24 +0200
Message-Id: <20201029100741.462818-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029100741.462818-1-ciorneiioana@gmail.com>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
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

