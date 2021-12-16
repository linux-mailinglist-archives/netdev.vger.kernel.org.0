Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CB9477D2C
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241258AbhLPUOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241255AbhLPUOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:14:36 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C848C06173E
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:36 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id d21so108617qkl.3
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VCgBh67zZ41fWJ3g8Xv+4p0gW/ow/SI9hyPq6qr3Qec=;
        b=muCeJbbzuBrSjNusHimGa29Y1e+/iyvpBreFw/DUcNYcqwIVFnd7rJYJ4QTr1BhiR+
         mUFGJrxCvjUD/FnaR3UhSHniy5qWdC2++T2MHeD+50fJWyfs2UI+IfBiOBSHj/Pud8OA
         X61RaiRNp10EDpXWC4XQemM/DKZbKQRxVzeDGUKWbIxmOp3g88iTQ3i8ikCWD0FN9No7
         vvujYzYK32QsYeP279KkwNo/Wte05BNHwGHZ5Qj4VFIoE5pW4Ap7jdUmb+SaE/FTB+Rb
         fRjZJNOB+fVRxTwRrO6yz6x8ZYyX/wl1iQgt3xQi5OlhbX42+l9rXnNc+1QulqLSB4TH
         RlCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VCgBh67zZ41fWJ3g8Xv+4p0gW/ow/SI9hyPq6qr3Qec=;
        b=dE10lEWIx9/wO9aRhywBn+cenkuKtEVz+G4uahOVowfT9hkeSHnv+GUA7wGfrxIM2q
         YWqejp/eA1u3RJtZK34E1JdR5sjf88S+Wld2492BkzlwYGvcMfeV9De4bIQk+8OejcPT
         LXQSAFv/wy/HAZvnj5fdf6sg3z0CJ8HDH6i+1n1EOPngAEX2YrHByrvatXX4+2XCNJE0
         JzDjWgadYkNJ38tZOQ/Z/gbVze236Jq6hOUOlXuWzNpiDUm0a1xNMMq3ZYiVHxdUlX7r
         T0Q68lbcjbiqa7jXlUqFMJwSUwGMmSLJwvDS1xFXDubhOFf3DYx2v80UX6fUtvptI9lj
         OxTA==
X-Gm-Message-State: AOAM530mQnkqo82iJoI6wutZWNZL0qnJ53nEMDyf+Qsp2XaNEvrM0kQS
        +DSnY5uaJ3rxcfNuOGHOs+uPV9xeyCYqwQ==
X-Google-Smtp-Source: ABdhPJwZ26z29JgS41BkMBOAbNub0pVpoioqh9Eb2oujGCoZWZ5X/OfpcFEyn1CsGDfq9YsBFB+ovw==
X-Received: by 2002:a05:620a:754:: with SMTP id i20mr13266566qki.312.1639685675432;
        Thu, 16 Dec 2021 12:14:35 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id a15sm5110266qtb.5.2021.12.16.12.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 12:14:35 -0800 (PST)
From:   luizluca@gmail.com
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next 08/13] net: dsa: realtek: add new mdio interface for drivers
Date:   Thu, 16 Dec 2021 17:13:37 -0300
Message-Id: <20211216201342.25587-9-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211216201342.25587-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

This driver is a mdio_driver instead of a platform driver (like
realtek-smi).

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/Kconfig        |  11 +-
 drivers/net/dsa/realtek/Makefile       |   1 +
 drivers/net/dsa/realtek/realtek-mdio.c | 284 +++++++++++++++++++++++++
 drivers/net/dsa/realtek/realtek.h      |   3 +
 4 files changed, 297 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/dsa/realtek/realtek-mdio.c

diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
index 874574db9177..48194d0dd51f 100644
--- a/drivers/net/dsa/realtek/Kconfig
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -9,6 +9,13 @@ menuconfig NET_DSA_REALTEK
 	help
 	  Select to enable support for Realtek Ethernet switch chips.
 
+config NET_DSA_REALTEK_MDIO
+	tristate "Realtek MDIO connected switch driver"
+	depends on NET_DSA_REALTEK
+	default y
+	help
+	  Select to enable support for registering switches configured through MDIO.
+
 config NET_DSA_REALTEK_SMI
 	tristate "Realtek SMI connected switch driver"
 	depends on NET_DSA_REALTEK
@@ -20,7 +27,7 @@ config NET_DSA_REALTEK_RTL8367C
 	tristate "Realtek RTL8367C switch subdriver"
 	default y
 	depends on NET_DSA_REALTEK
-	depends on NET_DSA_REALTEK_SMI
+	depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
 	select NET_DSA_TAG_RTL8_4
 	help
 	  Select to enable support for Realtek RTL8365MB-VC. This subdriver
@@ -32,7 +39,7 @@ config NET_DSA_REALTEK_RTL8366RB
 	tristate "Realtek RTL8366RB switch subdriver"
 	default y
 	depends on NET_DSA_REALTEK
-	depends on NET_DSA_REALTEK_SMI
+	depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
 	select NET_DSA_TAG_RTL4_A
 	help
 	  Select to enable support for Realtek RTL8366RB
diff --git a/drivers/net/dsa/realtek/Makefile b/drivers/net/dsa/realtek/Makefile
index 84d5ab062c89..01df2ccbb77f 100644
--- a/drivers/net/dsa/realtek/Makefile
+++ b/drivers/net/dsa/realtek/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_NET_DSA_REALTEK_MDIO) 	+= realtek-mdio.o
 obj-$(CONFIG_NET_DSA_REALTEK_SMI) 	+= realtek-smi.o
 obj-$(CONFIG_NET_DSA_REALTEK_RTL8366RB) += rtl8366.o
 rtl8366-objs 				:= rtl8366-core.o rtl8366rb.o
diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/realtek/realtek-mdio.c
new file mode 100644
index 000000000000..b7febd63e04f
--- /dev/null
+++ b/drivers/net/dsa/realtek/realtek-mdio.c
@@ -0,0 +1,284 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Realtek MDIO interface driver
+ *
+ *
+ * ASICs we intend to support with this driver:
+ *
+ * RTL8366   - The original version, apparently
+ * RTL8369   - Similar enough to have the same datsheet as RTL8366
+ * RTL8366RB - Probably reads out "RTL8366 revision B", has a quite
+ *             different register layout from the other two
+ * RTL8366S  - Is this "RTL8366 super"?
+ * RTL8367   - Has an OpenWRT driver as well
+ * RTL8368S  - Seems to be an alternative name for RTL8366RB
+ * RTL8370   - Also uses SMI
+ *
+ * Copyright (C) 2017 Linus Walleij <linus.walleij@linaro.org>
+ * Copyright (C) 2010 Antti Seppälä <a.seppala@gmail.com>
+ * Copyright (C) 2010 Roman Yeryomin <roman@advem.lv>
+ * Copyright (C) 2011 Colin Leitner <colin.leitner@googlemail.com>
+ * Copyright (C) 2009-2010 Gabor Juhos <juhosg@openwrt.org>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/spinlock.h>
+#include <linux/skbuff.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_mdio.h>
+#include <linux/delay.h>
+#include <linux/gpio/consumer.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/bitops.h>
+#include <linux/if_bridge.h>
+
+#include "realtek.h"
+
+/* Read/write via mdiobus */
+#define MDC_MDIO_CTRL0_REG              31
+#define MDC_MDIO_START_REG              29
+#define MDC_MDIO_CTRL1_REG              21
+#define MDC_MDIO_ADDRESS_REG            23
+#define MDC_MDIO_DATA_WRITE_REG         24
+#define MDC_MDIO_DATA_READ_REG          25
+
+#define MDC_MDIO_START_OP               0xFFFF
+#define MDC_MDIO_ADDR_OP                0x000E
+#define MDC_MDIO_READ_OP                0x0001
+#define MDC_MDIO_WRITE_OP               0x0003
+#define MDC_REALTEK_DEFAULT_PHY_ADDR    0x0
+
+int realtek_mdio_read_reg(struct realtek_priv *priv, u32 addr, u32 *data)
+{
+        u32 phy_id = priv->phy_id;
+	struct mii_bus *bus = priv->bus;
+
+        BUG_ON(in_interrupt());
+
+        mutex_lock(&bus->mdio_lock);
+        /* Write Start command to register 29 */
+        bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
+
+        /* Write address control code to register 31 */
+        bus->write(bus, phy_id, MDC_MDIO_CTRL0_REG, MDC_MDIO_ADDR_OP);
+
+        /* Write Start command to register 29 */
+        bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
+
+        /* Write address to register 23 */
+        bus->write(bus, phy_id, MDC_MDIO_ADDRESS_REG, addr);
+
+        /* Write Start command to register 29 */
+        bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
+
+        /* Write read control code to register 21 */
+        bus->write(bus, phy_id, MDC_MDIO_CTRL1_REG, MDC_MDIO_READ_OP);
+
+        /* Write Start command to register 29 */
+        bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
+
+        /* Read data from register 25 */
+        *data = bus->read(bus, phy_id, MDC_MDIO_DATA_READ_REG);
+
+        mutex_unlock(&bus->mdio_lock);
+
+        return 0;
+}
+
+static int realtek_mdio_write_reg(struct realtek_priv *priv, u32 addr, u32 data)
+{
+        u32 phy_id = priv->phy_id;
+        struct mii_bus *bus = priv->bus;
+
+        BUG_ON(in_interrupt());
+
+        mutex_lock(&bus->mdio_lock);
+
+        /* Write Start command to register 29 */
+        bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
+
+        /* Write address control code to register 31 */
+        bus->write(bus, phy_id, MDC_MDIO_CTRL0_REG, MDC_MDIO_ADDR_OP);
+
+        /* Write Start command to register 29 */
+        bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
+
+        /* Write address to register 23 */
+        bus->write(bus, phy_id, MDC_MDIO_ADDRESS_REG, addr);
+
+        /* Write Start command to register 29 */
+        bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
+
+        /* Write data to register 24 */
+        bus->write(bus, phy_id, MDC_MDIO_DATA_WRITE_REG, data);
+
+        /* Write Start command to register 29 */
+        bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
+
+        /* Write data control code to register 21 */
+        bus->write(bus, phy_id, MDC_MDIO_CTRL1_REG, MDC_MDIO_WRITE_OP);
+
+        mutex_unlock(&bus->mdio_lock);
+        return 0;
+}
+
+
+/* Regmap accessors */
+
+static int realtek_mdio_write(void *ctx, u32 reg, u32 val)
+{
+	struct realtek_priv *priv = ctx;
+
+	return realtek_mdio_write_reg(priv, reg, val);
+}
+
+static int realtek_mdio_read(void *ctx, u32 reg, u32 *val)
+{
+	struct realtek_priv *priv = ctx;
+
+	return realtek_mdio_read_reg(priv, reg, val);
+}
+
+static const struct regmap_config realtek_mdio_regmap_config = {
+	.reg_bits = 10, /* A4..A0 R4..R0 */
+	.val_bits = 16,
+	.reg_stride = 1,
+	/* PHY regs are at 0x8000 */
+	.max_register = 0xffff,
+	.reg_format_endian = REGMAP_ENDIAN_BIG,
+	.reg_read = realtek_mdio_read,
+	.reg_write = realtek_mdio_write,
+	.cache_type = REGCACHE_NONE,
+};
+
+static int realtek_mdio_probe(struct mdio_device *mdiodev)
+{
+	struct realtek_priv *priv;
+	struct device *dev = &mdiodev->dev;
+	const struct realtek_variant *var;
+	int ret;
+	struct device_node *np;
+
+	var = of_device_get_match_data(dev);
+	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->phy_id = mdiodev->addr;
+
+	// Start by setting up the register mapping
+	priv->map = devm_regmap_init(dev, NULL, priv, &realtek_mdio_regmap_config);
+
+	priv->bus = mdiodev->bus;
+	priv->dev = &mdiodev->dev;
+	priv->chip_data = (void *)priv + sizeof(*priv);
+
+	priv->clk_delay = var->clk_delay;
+	priv->cmd_read = var->cmd_read;
+	priv->cmd_write = var->cmd_write;
+	priv->ops = var->ops;
+
+	if (IS_ERR(priv->map))
+		dev_warn(dev, "regmap initialization failed");
+
+	priv->write_reg_noack=realtek_mdio_write_reg;
+
+	np = dev->of_node;
+
+	dev_set_drvdata(dev, priv);
+	spin_lock_init(&priv->lock);
+
+	/* TODO: if power is software controlled, set up any regulators here */
+
+	/* FIXME: maybe skip if no gpio but reset after the switch was detected */
+	/* Assert then deassert RESET */
+	/*
+	priv->reset = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
+	if (IS_ERR(priv->reset)) {
+		dev_err(dev, "failed to get RESET GPIO\n");
+		return PTR_ERR(priv->reset);
+	}
+	msleep(REALTEK_SMI_HW_STOP_DELAY);
+	gpiod_set_value(priv->reset, 0);
+	msleep(REALTEK_SMI_HW_START_DELAY);
+	dev_info(dev, "deasserted RESET\n");
+	*/
+
+	priv->leds_disabled = of_property_read_bool(np, "realtek,disable-leds");
+
+	ret = priv->ops->detect(priv);
+	if (ret) {
+		dev_err(dev, "unable to detect switch\n");
+		return ret;
+	}
+
+	priv->ds = devm_kzalloc(dev, sizeof(*priv->ds), GFP_KERNEL);
+	if (!priv->ds)
+		return -ENOMEM;
+
+	priv->ds->dev = dev;
+	priv->ds->num_ports = priv->num_ports;
+	priv->ds->priv = priv;
+	priv->ds->ops = var->ds_ops;
+
+	ret = dsa_register_switch(priv->ds);
+	if (ret) {
+		dev_err(priv->dev, "unable to register switch ret = %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void realtek_mdio_remove(struct mdio_device *mdiodev)
+{
+	struct realtek_priv *priv = dev_get_drvdata(&mdiodev->dev);
+
+	if (!priv)
+		return;
+
+	dsa_unregister_switch(priv->ds);
+	//gpiod_set_value(smi->reset, 1);
+	dev_set_drvdata(&mdiodev->dev, NULL);
+}
+
+static void realtek_mdio_shutdown(struct mdio_device *mdiodev)
+{
+	struct realtek_priv *priv = dev_get_drvdata(&mdiodev->dev);
+
+	if (!priv)
+		return;
+
+        dsa_switch_shutdown(priv->ds);
+
+        dev_set_drvdata(&mdiodev->dev, NULL);
+}
+
+static const struct of_device_id realtek_mdio_of_match[] = {
+#if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8366RB)
+	{ .compatible = "realtek,rtl8366rb", .data = &rtl8366rb_variant, },
+#endif
+	/* FIXME: add support for RTL8366S and more */
+	{ .compatible = "realtek,rtl8366s", .data = NULL, },
+#if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8367C)
+	{ .compatible = "realtek,rtl8365mb", .data = &rtl8367c_variant, },
+#endif
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, realtek_mdio_of_match);
+
+static struct mdio_driver realtek_mdio_driver = {
+	.mdiodrv.driver = {
+		.name = "realtek-mdio",
+		.of_match_table = of_match_ptr(realtek_mdio_of_match),
+	},
+	.probe  = realtek_mdio_probe,
+	.remove = realtek_mdio_remove,
+	.shutdown = realtek_mdio_shutdown,
+};
+mdio_module_driver(realtek_mdio_driver);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realtek/realtek.h
index 976cb7823c92..c1f20a23ab9e 100644
--- a/drivers/net/dsa/realtek/realtek.h
+++ b/drivers/net/dsa/realtek/realtek.h
@@ -50,6 +50,8 @@ struct realtek_priv {
 	struct gpio_desc	*mdio;
 	struct regmap		*map;
 	struct mii_bus		*slave_mii_bus;
+	struct mii_bus		*bus;
+	int                     phy_id;
 
 	unsigned int		clk_delay;
 	u8			cmd_read;
@@ -66,6 +68,7 @@ struct realtek_priv {
 	struct rtl8366_mib_counter *mib_counters;
 
 	const struct realtek_ops *ops;
+	int 		 	(*setup)(struct dsa_switch *ds);
 	int 		 	(*setup_interface)(struct dsa_switch *ds);
 	int 			(*write_reg_noack)(struct realtek_priv *priv, u32 addr, u32 data);
 
-- 
2.34.0

