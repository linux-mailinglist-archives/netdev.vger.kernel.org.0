Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98E7484CC8
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 04:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237196AbiAEDQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 22:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237213AbiAEDQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 22:16:04 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA5AC061792
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 19:16:04 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id q3so36324494qvc.7
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 19:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fRkCV38Eh2p+amh7ixSF3SllPZ3OsSpSGgJkG/gHiQo=;
        b=JdZNK+/6fMQQ+d7c4LnJLOpNqxlrBQV+OvOxmwtd75liYKcPZIjxfH2tbJ0EbntuA8
         pnpJnz9jCptFe9lNBswxLnvV6vRzEhtUA6/pDNf6/N13G7TNPjjQTVk0aAiPKnMWLB4h
         r++9gtIYJY46Mj9QhLEmJB/n2d4PMjbGOKvBKvczLX3BOxBz3ccndczwndWqnV8nfpNg
         dC0EbdSHcTyN9v3yi/nxlCSMDTHOTzeZjqMR9AydXtM0ZT/iHEPjlWLbJH6wK6yd3wT9
         PRW7ZEsI55rTJjWG2voUSZllmtSbwcDg8PYMDd6i/6LQRXRU+7no27TQAzAWM04+Iv+u
         Df/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fRkCV38Eh2p+amh7ixSF3SllPZ3OsSpSGgJkG/gHiQo=;
        b=rfbVGbkR3qBuhvx9lWnmLjMnooq/kHOWXpMJkDImGWvkdO/H1HD04GGLTu7aWmzoNT
         JYs0pwY1dMoLHgEtTd0Pn4DVwW4KePx+8Z2/18XEJrT8CibP3zyLhKyUrJlikoYfjZby
         YrfPR0gbW7C9U+7qhWT01Q/pCnkGeslQJCstMzdRNVhzbhhYReGXgLnZtszCI3Jy5PW/
         Yk8u63mSuy1U7yZIGlqg4ZsFk2DItoLODN1fLjW0CpQgg738cePWhIrS1p2DYH351Y4P
         Mj39MU1eXAtgOWQ1kTv2VuOGlns1CGBXhg9pROr1nynWSZX1OIHAwxJxM9R78Ra1rT2t
         l7jg==
X-Gm-Message-State: AOAM533Sa76d01MtuSqwzoakTtHV8wZEvmn3hWNeKnmiDY6ORsMqgiJK
        EaWWrMLqRR0kJYg4uSwLuPtO7hsBePC39FOk
X-Google-Smtp-Source: ABdhPJxsPoyfmOKf95ZwZY7vX4+flSYtY8l3/CRwPVKcytcgG8p+ZfxBPwXZg4BhEZel6+DbLUnjZA==
X-Received: by 2002:ad4:4dca:: with SMTP id cw10mr48955776qvb.22.1641352562966;
        Tue, 04 Jan 2022 19:16:02 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id t11sm32607629qkp.56.2022.01.04.19.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 19:16:02 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v4 06/11] net: dsa: realtek: add new mdio interface for drivers
Date:   Wed,  5 Jan 2022 00:15:10 -0300
Message-Id: <20220105031515.29276-7-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20220105031515.29276-1-luizluca@gmail.com>
References: <20220105031515.29276-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver is a mdio_driver instead of a platform driver (like
realtek-smi).

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/realtek/Kconfig        |  11 +-
 drivers/net/dsa/realtek/Makefile       |   1 +
 drivers/net/dsa/realtek/realtek-mdio.c | 221 +++++++++++++++++++++++++
 drivers/net/dsa/realtek/realtek.h      |   2 +
 4 files changed, 233 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/dsa/realtek/realtek-mdio.c

diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
index cd1aa95b7bf0..73b26171fade 100644
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
+	  Select to enable support for registering switches configured
+	  through MDIO.
 config NET_DSA_REALTEK_SMI
 	tristate "Realtek SMI connected switch driver"
 	depends on NET_DSA_REALTEK
@@ -21,7 +28,7 @@ config NET_DSA_REALTEK_RTL8365MB
 	tristate "Realtek RTL8365MB switch subdriver"
 	default y
 	depends on NET_DSA_REALTEK
-	depends on NET_DSA_REALTEK_SMI
+	depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
 	select NET_DSA_TAG_RTL8_4
 	help
 	  Select to enable support for Realtek RTL8365MB
@@ -30,7 +37,7 @@ config NET_DSA_REALTEK_RTL8366RB
 	tristate "Realtek RTL8366RB switch subdriver"
 	default y
 	depends on NET_DSA_REALTEK
-	depends on NET_DSA_REALTEK_SMI
+	depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
 	select NET_DSA_TAG_RTL4_A
 	help
 	  Select to enable support for Realtek RTL8366RB
diff --git a/drivers/net/dsa/realtek/Makefile b/drivers/net/dsa/realtek/Makefile
index 8b5a4abcedd3..0aab57252a7c 100644
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
index 000000000000..b505f4d3c5f0
--- /dev/null
+++ b/drivers/net/dsa/realtek/realtek-mdio.c
@@ -0,0 +1,221 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Realtek MDIO interface driver
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
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/regmap.h>
+
+#include "realtek.h"
+
+/* Read/write via mdiobus */
+#define REALTEK_MDIO_CTRL0_REG		31
+#define REALTEK_MDIO_START_REG		29
+#define REALTEK_MDIO_CTRL1_REG		21
+#define REALTEK_MDIO_ADDRESS_REG	23
+#define REALTEK_MDIO_DATA_WRITE_REG	24
+#define REALTEK_MDIO_DATA_READ_REG	25
+
+#define REALTEK_MDIO_START_OP		0xFFFF
+#define REALTEK_MDIO_ADDR_OP		0x000E
+#define REALTEK_MDIO_READ_OP		0x0001
+#define REALTEK_MDIO_WRITE_OP		0x0003
+
+static int realtek_mdio_read_reg(struct realtek_priv *priv, u32 addr, u32 *data)
+{
+	u32 phy_id = priv->phy_id;
+	struct mii_bus *bus = priv->bus;
+
+	mutex_lock(&bus->mdio_lock);
+
+	bus->write(bus, phy_id, REALTEK_MDIO_CTRL0_REG, REALTEK_MDIO_ADDR_OP);
+	bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
+	bus->write(bus, phy_id, REALTEK_MDIO_ADDRESS_REG, addr);
+	bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
+	bus->write(bus, phy_id, REALTEK_MDIO_CTRL1_REG, REALTEK_MDIO_READ_OP);
+	bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
+	*data = bus->read(bus, phy_id, REALTEK_MDIO_DATA_READ_REG);
+
+	mutex_unlock(&bus->mdio_lock);
+
+	return 0;
+}
+
+static int realtek_mdio_write_reg(struct realtek_priv *priv, u32 addr, u32 data)
+{
+	u32 phy_id = priv->phy_id;
+	struct mii_bus *bus = priv->bus;
+
+	mutex_lock(&bus->mdio_lock);
+
+	bus->write(bus, phy_id, REALTEK_MDIO_CTRL0_REG, REALTEK_MDIO_ADDR_OP);
+	bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
+	bus->write(bus, phy_id, REALTEK_MDIO_ADDRESS_REG, addr);
+	bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
+	bus->write(bus, phy_id, REALTEK_MDIO_DATA_WRITE_REG, data);
+	bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
+	bus->write(bus, phy_id, REALTEK_MDIO_CTRL1_REG, REALTEK_MDIO_WRITE_OP);
+
+	mutex_unlock(&bus->mdio_lock);
+
+	return 0;
+}
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
+	priv->map = devm_regmap_init(dev, NULL, priv, &realtek_mdio_regmap_config);
+	if (IS_ERR(priv->map)) {
+		ret = PTR_ERR(priv->map);
+		dev_err(dev, "regmap init failed: %d\n", ret);
+		return ret;
+	}
+
+	priv->phy_id = mdiodev->addr;
+	priv->bus = mdiodev->bus;
+	priv->dev = &mdiodev->dev;
+	priv->chip_data = (void *)priv + sizeof(*priv);
+
+	priv->clk_delay = var->clk_delay;
+	priv->cmd_read = var->cmd_read;
+	priv->cmd_write = var->cmd_write;
+	priv->ops = var->ops;
+
+	priv->write_reg_noack = realtek_mdio_write_reg;
+
+	np = dev->of_node;
+
+	dev_set_drvdata(dev, priv);
+
+	/* TODO: if power is software controlled, set up any regulators here */
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
+
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
+	dsa_switch_shutdown(priv->ds);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
+}
+
+static const struct of_device_id realtek_mdio_of_match[] = {
+#if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8366RB)
+	{ .compatible = "realtek,rtl8366rb", .data = &rtl8366rb_variant, },
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8365MB)
+	{ .compatible = "realtek,rtl8365mb", .data = &rtl8365mb_variant, },
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
+
+mdio_module_driver(realtek_mdio_driver);
+
+MODULE_AUTHOR("Luiz Angelo Daros de Luca <luizluca@gmail.com>");
+MODULE_DESCRIPTION("Driver for Realtek ethernet switch connected via MDIO interface");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realtek/realtek.h
index a03de15c4a94..97274273cb3b 100644
--- a/drivers/net/dsa/realtek/realtek.h
+++ b/drivers/net/dsa/realtek/realtek.h
@@ -50,6 +50,8 @@ struct realtek_priv {
 	struct gpio_desc	*mdio;
 	struct regmap		*map;
 	struct mii_bus		*slave_mii_bus;
+	struct mii_bus		*bus;
+	int			phy_id;
 
 	unsigned int		clk_delay;
 	u8			cmd_read;
-- 
2.34.0

