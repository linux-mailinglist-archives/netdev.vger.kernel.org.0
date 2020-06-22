Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D021F2033B3
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgFVJmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbgFVJlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:41:47 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFBBC061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:46 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id j18so659794wmi.3
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0paM6XhitgV7f9qC2QMsgtm0qUC+Vh9Zw/7wnTkRdCU=;
        b=p3puFYEON7LkHbRRFDYqexUJADfzkEU/dUHjBAt/PbcDJGO0LiqnjjeqsIrnr/DVi8
         TrFkDpUdHsOTJT23y3iLd0/FPbAVUhoTCnRBnGU2vTS0/89DVGkpzmy+t4hbbzqoDU3B
         KNlg5bNbRUucNBZgy88A9ZU09qNs5k/J6vh5JqNU5yWXSVkkc9yOsVgS02mQpY90/8V6
         0oOVcA0uD5HC67mpqZzgj7Sw1oNu0MzvwMK7PgFS2M7LqNfuY/VGRHUtM65hVZ7AfhGx
         9iE+ygyaLVwY/ZH++VpS+UD/5Poz5Tu6HHyjGXcqFdVGwfKkqG/ZHgm0AIs5WEiNvL2j
         Bv5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0paM6XhitgV7f9qC2QMsgtm0qUC+Vh9Zw/7wnTkRdCU=;
        b=EXAaJ8LWrvuteAUjc6rm2CK4T0UzhWLbMbDYR7LPyEa/UZWZUHk8JlEYCkvZicrvnX
         SDPfICDNDgp5QGQWZkjsGsyYj8AdkCb4r0sHobXrAkE0QdyY0eeXwWKXz2Mkb0S+3mi8
         USLRQEj4JZ/Jc3nzcx6NOdLM/l0T2gQeQsYWhgJYnsHh9BLDXZPkN6rOIyjO7i0gEvl3
         Dc0NXmHficzXH2Jsc0WcdeUQQnsGdTRVMzapE8k0yrfT9+rgR+7gkAveUFXTRoOGF0Va
         6bBqBxzj0sWPCggNinZ787mLYOF0d2YiMjrGdAmyFhBoy+RENot0whDPhVDgl6g/epAh
         ybKA==
X-Gm-Message-State: AOAM531N9wn/ATQ+CAKsscNtQtmL3MbtwMxn15LElUF8rlzJQPIkUcHh
        XeTpuEbeV8MtrnK79UMbIMqW3w==
X-Google-Smtp-Source: ABdhPJzv5Re1aj4/hOY+M8/oLHAxe0wxNqcRaQ+JBsEotMr3fSKVkarmVoP6v3N5vfsL/r8R8lxAzQ==
X-Received: by 2002:a1c:a3c5:: with SMTP id m188mr17122520wme.152.1592818905480;
        Mon, 22 Jun 2020 02:41:45 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id j24sm14392652wrd.43.2020.06.22.02.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 02:41:44 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 13/15] net: phy: mdio: add support for PHY supply regulator
Date:   Mon, 22 Jun 2020 11:37:42 +0200
Message-Id: <20200622093744.13685-14-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200622093744.13685-1-brgl@bgdev.pl>
References: <20200622093744.13685-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Currently many MAC drivers control the regulator supplying the PHY but
this is conceptually wrong. The regulator should be defined as a property
of the PHY node on the MDIO bus and controlled by the MDIO sub-system.

Add support for an optional PHY regulator which will be enabled before
optional deasserting of the reset signal.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/phy/mdio_bus.c    | 21 ++++++++++++++++++++
 drivers/net/phy/mdio_device.c | 36 +++++++++++++++++++++++++++++++++++
 include/linux/mdio.h          |  3 +++
 3 files changed, 60 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 53e2fb0be7b9..19f0b9664fe3 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -27,6 +27,7 @@
 #include <linux/of_gpio.h>
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
+#include <linux/regulator/consumer.h>
 #include <linux/reset.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
@@ -67,6 +68,22 @@ static int mdiobus_register_reset(struct mdio_device *mdiodev)
 	return 0;
 }
 
+static int mdiobus_register_regulator(struct mdio_device *mdiodev)
+{
+	struct regulator *phy_supply;
+
+	phy_supply = regulator_get_optional(&mdiodev->dev, "phy");
+	if (IS_ERR(phy_supply)) {
+		if (PTR_ERR(phy_supply) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		phy_supply = NULL;
+	}
+
+	mdiodev->phy_supply = phy_supply;
+
+	return 0;
+}
+
 int mdiobus_register_device(struct mdio_device *mdiodev)
 {
 	int err;
@@ -83,6 +100,10 @@ int mdiobus_register_device(struct mdio_device *mdiodev)
 		if (err)
 			return err;
 
+		err = mdiobus_register_regulator(mdiodev);
+		if (err)
+			return err;
+
 		/* Assert the reset signal */
 		mdio_device_reset(mdiodev, 1);
 	}
diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index be615504b829..0f698d7a770b 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -17,6 +17,7 @@
 #include <linux/mii.h>
 #include <linux/module.h>
 #include <linux/phy.h>
+#include <linux/regulator/consumer.h>
 #include <linux/reset.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -136,6 +137,32 @@ void mdio_device_reset(struct mdio_device *mdiodev, int value)
 }
 EXPORT_SYMBOL(mdio_device_reset);
 
+int mdio_device_power_on(struct mdio_device *mdiodev)
+{
+	int ret = 0;
+
+	if (mdiodev->phy_supply)
+		/* TODO We may need a delay here just like reset_assert_delay
+		 * but since no user currently needs it, I'm not adding it just
+		 * yet.
+		 */
+		ret = regulator_enable(mdiodev->phy_supply);
+
+	return ret;
+}
+EXPORT_SYMBOL(mdio_device_power_on);
+
+int mdio_device_power_off(struct mdio_device *mdiodev)
+{
+	int ret = 0;
+
+	if (mdiodev->phy_supply)
+		ret = regulator_disable(mdiodev->phy_supply);
+
+	return ret;
+}
+EXPORT_SYMBOL(mdio_device_power_off);
+
 /**
  * mdio_probe - probe an MDIO device
  * @dev: device to probe
@@ -150,6 +177,11 @@ static int mdio_probe(struct device *dev)
 	struct mdio_driver *mdiodrv = to_mdio_driver(drv);
 	int err = 0;
 
+	/* Enable the power supply */
+	err = mdio_device_power_on(mdiodev);
+	if (err)
+		return err;
+
 	/* Deassert the reset signal */
 	mdio_device_reset(mdiodev, 0);
 
@@ -158,6 +190,8 @@ static int mdio_probe(struct device *dev)
 		if (err) {
 			/* Assert the reset signal */
 			mdio_device_reset(mdiodev, 1);
+			/* Disable the power supply */
+			mdio_device_power_off(mdiodev);
 		}
 	}
 
@@ -175,6 +209,8 @@ static int mdio_remove(struct device *dev)
 
 	/* Assert the reset signal */
 	mdio_device_reset(mdiodev, 1);
+	/* Disable the power supply */
+	mdio_device_power_off(mdiodev);
 
 	return 0;
 }
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 9ac5e7ff6156..0ae07365a6ca 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -46,6 +46,7 @@ struct mdio_device {
 	int flags;
 	struct gpio_desc *reset_gpio;
 	struct reset_control *reset_ctrl;
+	struct regulator *phy_supply;
 	unsigned int reset_assert_delay;
 	unsigned int reset_deassert_delay;
 };
@@ -92,6 +93,8 @@ struct mdio_device *mdio_device_create(struct mii_bus *bus, int addr);
 int mdio_device_register(struct mdio_device *mdiodev);
 void mdio_device_remove(struct mdio_device *mdiodev);
 void mdio_device_reset(struct mdio_device *mdiodev, int value);
+int mdio_device_power_on(struct mdio_device *mdiodev);
+int mdio_device_power_off(struct mdio_device *mdiodev);
 int mdio_driver_register(struct mdio_driver *drv);
 void mdio_driver_unregister(struct mdio_driver *drv);
 int mdio_device_bus_match(struct device *dev, struct device_driver *drv);
-- 
2.26.1

