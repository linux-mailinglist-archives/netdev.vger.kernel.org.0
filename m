Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C413A49F342
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 07:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346277AbiA1GGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 01:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346279AbiA1GGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 01:06:00 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6A8C06173B
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:05:59 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id g205so10514074oif.5
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=htlmI9vZvIUV2aNms/lzBX+TbFtdIaLYr5vZiEUD9Ww=;
        b=gke2MlFI6oVRGJOpEvIVWMC/F3bXhNENUrNi8jcWykvxdzQT8ud0w4EvbH40F4oUNL
         C3N8FvDju7zX9vNfpNDY2gLJXYk1ujJXlwFAiNObeW8ZVTwVEB4igJotKw1lFkq3S56v
         WYmSzzSUIdZuNrqb9tiz0g9NZ7GQwSB2R1lyIsM3HqK1PKbnDG4C6HteRBC0hwx+SN8Q
         Oy1AxCTLfXqYESEADXoV43C6eCszTZtTJGyo1bV03mmZx9goZdCD78OsYT5mOeIdw6Wj
         WUk8c1XdaF69O/NWDYNFs2Y+YpCZG7N8JfK3lff1NHTEhOwvvVyjNmRZsfZ2CcfYqES1
         zB+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=htlmI9vZvIUV2aNms/lzBX+TbFtdIaLYr5vZiEUD9Ww=;
        b=aUpp67HIA5S5FzGuh6I4YoONV7ZJYyvJyWWgR5tgX+ASGn9A88fYznWO1chzs6+kao
         KR9kPkbseIn1um0LpwATcdHnYOF6lIfqT/TinhEdQd7QApGjXLSHqe+qYJ51a0ZzUsC4
         gqUjeqwnLmI0YovlAXQS+P+B1MXCqgJLNmVfFxkWs998+3yn0yyqCZR+HSsbKGhQwFc0
         wVJecJap8jJQBV8mDDEhu+Bz6/0JQ4Od+dRFWWaHtSCxIB8/Zyt03JGJw+wckZDUg9jB
         M1rPNJ8rQGOQHla+0d/6KJjJM0dWn5YOSdoFMM0DFHGeKex+J1f3etr3eWd0OiJdvl9C
         FiJw==
X-Gm-Message-State: AOAM531Bd5HVjuXMqW/Jc136hv3ms9l0V4wpCGani+zXS7435TsiV6LN
        p7Q6bx/ywts+npc4tO9SBL3WhmXL9ETyhQ==
X-Google-Smtp-Source: ABdhPJyaca25zAb4dzcKdFCwRLT7PvONOG/MvQi7nrzYZeO4ZVJYvA0zgZ4dDBkLepg6C3/1Mcheaw==
X-Received: by 2002:a54:4018:: with SMTP id x24mr4458204oie.222.1643349958799;
        Thu, 27 Jan 2022 22:05:58 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id m23sm9790229oos.6.2022.01.27.22.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 22:05:58 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        davem@davemloft.net, kuba@kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v6 06/13] net: dsa: realtek: add new mdio interface for drivers
Date:   Fri, 28 Jan 2022 03:05:02 -0300
Message-Id: <20220128060509.13800-7-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128060509.13800-1-luizluca@gmail.com>
References: <20220128060509.13800-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver is a mdio_driver instead of a platform driver (like
realtek-smi).

ds_ops was duplicated for smi and mdio usage as mdio interfaces uses
phy_{read,write} in ds_ops and the presence of phy_read is incompatible
with external slave_mii_bus allocation.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/realtek/Kconfig        |  12 +-
 drivers/net/dsa/realtek/Makefile       |   1 +
 drivers/net/dsa/realtek/realtek-mdio.c | 228 +++++++++++++++++++++++++
 drivers/net/dsa/realtek/realtek-smi.c  |   2 +-
 drivers/net/dsa/realtek/realtek.h      |   5 +-
 drivers/net/dsa/realtek/rtl8365mb.c    |  36 +++-
 drivers/net/dsa/realtek/rtl8366rb.c    |  41 ++++-
 7 files changed, 317 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/dsa/realtek/realtek-mdio.c

diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
index cd1aa95b7bf0..553f696e7435 100644
--- a/drivers/net/dsa/realtek/Kconfig
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -9,6 +9,14 @@ menuconfig NET_DSA_REALTEK
 	help
 	  Select to enable support for Realtek Ethernet switch chips.
 
+config NET_DSA_REALTEK_MDIO
+	tristate "Realtek MDIO connected switch driver"
+	depends on NET_DSA_REALTEK
+	default y
+	help
+	  Select to enable support for registering switches configured
+	  through MDIO.
+
 config NET_DSA_REALTEK_SMI
 	tristate "Realtek SMI connected switch driver"
 	depends on NET_DSA_REALTEK
@@ -21,7 +29,7 @@ config NET_DSA_REALTEK_RTL8365MB
 	tristate "Realtek RTL8365MB switch subdriver"
 	default y
 	depends on NET_DSA_REALTEK
-	depends on NET_DSA_REALTEK_SMI
+	depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
 	select NET_DSA_TAG_RTL8_4
 	help
 	  Select to enable support for Realtek RTL8365MB
@@ -30,7 +38,7 @@ config NET_DSA_REALTEK_RTL8366RB
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
index 000000000000..b82f96668218
--- /dev/null
+++ b/drivers/net/dsa/realtek/realtek-mdio.c
@@ -0,0 +1,228 @@
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
+static int realtek_mdio_write(void *ctx, u32 reg, u32 val)
+{
+	struct realtek_priv *priv = ctx;
+	struct mii_bus *bus = priv->bus;
+	int ret;
+
+	mutex_lock(&bus->mdio_lock);
+
+	ret = bus->write(bus, priv->mdio_addr, REALTEK_MDIO_CTRL0_REG, REALTEK_MDIO_ADDR_OP);
+	if (ret)
+		goto out_unlock;
+
+	ret = bus->write(bus, priv->mdio_addr, REALTEK_MDIO_ADDRESS_REG, reg);
+	if (ret)
+		goto out_unlock;
+
+	ret = bus->write(bus, priv->mdio_addr, REALTEK_MDIO_DATA_WRITE_REG, val);
+	if (ret)
+		goto out_unlock;
+
+	ret = bus->write(bus, priv->mdio_addr, REALTEK_MDIO_CTRL1_REG, REALTEK_MDIO_WRITE_OP);
+
+out_unlock:
+	mutex_unlock(&bus->mdio_lock);
+
+	return ret;
+}
+
+static int realtek_mdio_read(void *ctx, u32 reg, u32 *val)
+{
+	struct realtek_priv *priv = ctx;
+	struct mii_bus *bus = priv->bus;
+	int ret;
+
+	mutex_lock(&bus->mdio_lock);
+
+	ret = bus->write(bus, priv->mdio_addr, REALTEK_MDIO_CTRL0_REG, REALTEK_MDIO_ADDR_OP);
+	if (ret)
+		goto out_unlock;
+
+	ret = bus->write(bus, priv->mdio_addr, REALTEK_MDIO_ADDRESS_REG, reg);
+	if (ret)
+		goto out_unlock;
+
+	ret = bus->write(bus, priv->mdio_addr, REALTEK_MDIO_CTRL1_REG, REALTEK_MDIO_READ_OP);
+	if (ret)
+		goto out_unlock;
+
+	ret = bus->read(bus, priv->mdio_addr, REALTEK_MDIO_DATA_READ_REG);
+	if (ret >= 0) {
+		*val = ret;
+		ret = 0;
+	}
+
+out_unlock:
+	mutex_unlock(&bus->mdio_lock);
+
+	return ret;
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
+	if (!var)
+		return -EINVAL;
+
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
+	priv->mdio_addr = mdiodev->addr;
+	priv->bus = mdiodev->bus;
+	priv->dev = &mdiodev->dev;
+	priv->chip_data = (void *)priv + sizeof(*priv);
+
+	priv->clk_delay = var->clk_delay;
+	priv->cmd_read = var->cmd_read;
+	priv->cmd_write = var->cmd_write;
+	priv->ops = var->ops;
+
+	priv->write_reg_noack = realtek_mdio_write;
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
+	priv->ds->ops = var->ds_ops_mdio;
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
diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index 04df06e352d3..1ef147e55a4c 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -455,7 +455,7 @@ static int realtek_smi_probe(struct platform_device *pdev)
 	priv->ds->num_ports = priv->num_ports;
 	priv->ds->priv = priv;
 
-	priv->ds->ops = var->ds_ops;
+	priv->ds->ops = var->ds_ops_smi;
 	ret = dsa_register_switch(priv->ds);
 	if (ret) {
 		dev_err_probe(dev, ret, "unable to register switch\n");
diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realtek/realtek.h
index 4152eba851be..ed5abf6cb3d6 100644
--- a/drivers/net/dsa/realtek/realtek.h
+++ b/drivers/net/dsa/realtek/realtek.h
@@ -50,6 +50,8 @@ struct realtek_priv {
 	struct gpio_desc	*mdio;
 	struct regmap		*map;
 	struct mii_bus		*slave_mii_bus;
+	struct mii_bus		*bus;
+	int			mdio_addr;
 
 	unsigned int		clk_delay;
 	u8			cmd_read;
@@ -109,7 +111,8 @@ struct realtek_ops {
 };
 
 struct realtek_variant {
-	const struct dsa_switch_ops *ds_ops;
+	const struct dsa_switch_ops *ds_ops_smi;
+	const struct dsa_switch_ops *ds_ops_mdio;
 	const struct realtek_ops *ops;
 	unsigned int clk_delay;
 	u8 cmd_read;
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index f91763029dd4..b411b620fec1 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -730,6 +730,17 @@ static int rtl8365mb_phy_write(struct realtek_priv *priv, int phy, int regnum,
 	return 0;
 }
 
+static int rtl8365mb_dsa_phy_read(struct dsa_switch *ds, int phy, int regnum)
+{
+	return rtl8365mb_phy_read(ds->priv, phy, regnum);
+}
+
+static int rtl8365mb_dsa_phy_write(struct dsa_switch *ds, int phy, int regnum,
+				   u16 val)
+{
+	return rtl8365mb_phy_write(ds->priv, phy, regnum, val);
+}
+
 static enum dsa_tag_protocol
 rtl8365mb_get_tag_protocol(struct dsa_switch *ds, int port,
 			   enum dsa_tag_protocol mp)
@@ -1953,7 +1964,25 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 	return 0;
 }
 
-static const struct dsa_switch_ops rtl8365mb_switch_ops = {
+static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
+	.get_tag_protocol = rtl8365mb_get_tag_protocol,
+	.setup = rtl8365mb_setup,
+	.teardown = rtl8365mb_teardown,
+	.phylink_validate = rtl8365mb_phylink_validate,
+	.phylink_mac_config = rtl8365mb_phylink_mac_config,
+	.phylink_mac_link_down = rtl8365mb_phylink_mac_link_down,
+	.phylink_mac_link_up = rtl8365mb_phylink_mac_link_up,
+	.port_stp_state_set = rtl8365mb_port_stp_state_set,
+	.get_strings = rtl8365mb_get_strings,
+	.get_ethtool_stats = rtl8365mb_get_ethtool_stats,
+	.get_sset_count = rtl8365mb_get_sset_count,
+	.get_eth_phy_stats = rtl8365mb_get_phy_stats,
+	.get_eth_mac_stats = rtl8365mb_get_mac_stats,
+	.get_eth_ctrl_stats = rtl8365mb_get_ctrl_stats,
+	.get_stats64 = rtl8365mb_get_stats64,
+};
+
+static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
 	.get_tag_protocol = rtl8365mb_get_tag_protocol,
 	.setup = rtl8365mb_setup,
 	.teardown = rtl8365mb_teardown,
@@ -1961,6 +1990,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops = {
 	.phylink_mac_config = rtl8365mb_phylink_mac_config,
 	.phylink_mac_link_down = rtl8365mb_phylink_mac_link_down,
 	.phylink_mac_link_up = rtl8365mb_phylink_mac_link_up,
+	.phy_read = rtl8365mb_dsa_phy_read,
+	.phy_write = rtl8365mb_dsa_phy_write,
 	.port_stp_state_set = rtl8365mb_port_stp_state_set,
 	.get_strings = rtl8365mb_get_strings,
 	.get_ethtool_stats = rtl8365mb_get_ethtool_stats,
@@ -1978,7 +2009,8 @@ static const struct realtek_ops rtl8365mb_ops = {
 };
 
 const struct realtek_variant rtl8365mb_variant = {
-	.ds_ops = &rtl8365mb_switch_ops,
+	.ds_ops_smi = &rtl8365mb_switch_ops_smi,
+	.ds_ops_mdio = &rtl8365mb_switch_ops_mdio,
 	.ops = &rtl8365mb_ops,
 	.clk_delay = 10,
 	.cmd_read = 0xb9,
diff --git a/drivers/net/dsa/realtek/rtl8366rb.c b/drivers/net/dsa/realtek/rtl8366rb.c
index 7dea8db56b6c..fb6565e68401 100644
--- a/drivers/net/dsa/realtek/rtl8366rb.c
+++ b/drivers/net/dsa/realtek/rtl8366rb.c
@@ -1703,6 +1703,17 @@ static int rtl8366rb_phy_write(struct realtek_priv *priv, int phy, int regnum,
 	return 0;
 }
 
+static int rtl8366rb_dsa_phy_read(struct dsa_switch *ds, int phy, int regnum)
+{
+	return rtl8366rb_phy_read(ds->priv, phy, regnum);
+}
+
+static int rtl8366rb_dsa_phy_write(struct dsa_switch *ds, int phy, int regnum,
+				   u16 val)
+{
+	return rtl8366rb_phy_write(ds->priv, phy, regnum, val);
+}
+
 static int rtl8366rb_reset_chip(struct realtek_priv *priv)
 {
 	int timeout = 10;
@@ -1768,9 +1779,34 @@ static int rtl8366rb_detect(struct realtek_priv *priv)
 	return 0;
 }
 
-static const struct dsa_switch_ops rtl8366rb_switch_ops = {
+static const struct dsa_switch_ops rtl8366rb_switch_ops_smi = {
+	.get_tag_protocol = rtl8366_get_tag_protocol,
+	.setup = rtl8366rb_setup,
+	.phylink_mac_link_up = rtl8366rb_mac_link_up,
+	.phylink_mac_link_down = rtl8366rb_mac_link_down,
+	.get_strings = rtl8366_get_strings,
+	.get_ethtool_stats = rtl8366_get_ethtool_stats,
+	.get_sset_count = rtl8366_get_sset_count,
+	.port_bridge_join = rtl8366rb_port_bridge_join,
+	.port_bridge_leave = rtl8366rb_port_bridge_leave,
+	.port_vlan_filtering = rtl8366rb_vlan_filtering,
+	.port_vlan_add = rtl8366_vlan_add,
+	.port_vlan_del = rtl8366_vlan_del,
+	.port_enable = rtl8366rb_port_enable,
+	.port_disable = rtl8366rb_port_disable,
+	.port_pre_bridge_flags = rtl8366rb_port_pre_bridge_flags,
+	.port_bridge_flags = rtl8366rb_port_bridge_flags,
+	.port_stp_state_set = rtl8366rb_port_stp_state_set,
+	.port_fast_age = rtl8366rb_port_fast_age,
+	.port_change_mtu = rtl8366rb_change_mtu,
+	.port_max_mtu = rtl8366rb_max_mtu,
+};
+
+static const struct dsa_switch_ops rtl8366rb_switch_ops_mdio = {
 	.get_tag_protocol = rtl8366_get_tag_protocol,
 	.setup = rtl8366rb_setup,
+	.phy_read = rtl8366rb_dsa_phy_read,
+	.phy_write = rtl8366rb_dsa_phy_write,
 	.phylink_mac_link_up = rtl8366rb_mac_link_up,
 	.phylink_mac_link_down = rtl8366rb_mac_link_down,
 	.get_strings = rtl8366_get_strings,
@@ -1808,7 +1844,8 @@ static const struct realtek_ops rtl8366rb_ops = {
 };
 
 const struct realtek_variant rtl8366rb_variant = {
-	.ds_ops = &rtl8366rb_switch_ops,
+	.ds_ops_smi = &rtl8366rb_switch_ops_smi,
+	.ds_ops_mdio = &rtl8366rb_switch_ops_mdio,
 	.ops = &rtl8366rb_ops,
 	.clk_delay = 10,
 	.cmd_read = 0xa9,
-- 
2.34.1

