Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F33331663
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 19:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhCHSlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 13:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbhCHSlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 13:41:07 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D22C06174A;
        Mon,  8 Mar 2021 10:41:06 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id y124-20020a1c32820000b029010c93864955so4425607wmy.5;
        Mon, 08 Mar 2021 10:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=18bvLgC3vGglPBeXLuJAcZyGjW47MgJO0imamGWsbio=;
        b=jQTQBvmV/eUlWXxCxp0zW8SXB9O0M8yYDRVZqVMU9xheZWPpLcOTVybtr1NdW3/RmU
         nfLK6HmYth5p2Uo7nSn6Tazi3NaEIBSbS1XXe49W4xczVD6+326uzYFFvnYxwtx8w9uI
         usJiMtyA4zhevxtqr7NxhU8sxcPZRkfgAYAf5Af+tiF+KQjn1kFfRhBrw2FT3AhJKnf1
         3lpk6JWhSJSbNi1XFB2OtC8OZig2tb5wWHWvH9G6l5zEDzH9O1HfB2SREaYj/YIwYSX+
         qiDGKUfMNd+cfjMAtxevtG8aqxvC+7NY9zIFCVz3PWKf87fBLMQsvNakEph2Jx/ySKYF
         R8qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=18bvLgC3vGglPBeXLuJAcZyGjW47MgJO0imamGWsbio=;
        b=OnL3rk6ZwARiwOXol/gYRahv7q/e1tIj/MqNDXS8FUNr45SA0Pp9822ToT6tAaIErP
         jtDL3Tl3HK+JESiEQD3Vk9V2wKImgN+w52GzjR9jzqJYOARqF3N5u0M7s9nN3drnKN2t
         Mw3j3KDzNcfRsYT6hYGAi+/vcq82YBw0RWiov7HTIQ6JJJSYa/iw16TwuLhpz0Wda4fa
         CHI/93na1FJT+jMymhndHtHuj71zeClAKscAu6QR1feJNiku3LMpfHh8cZhNwTAMk9Al
         yy4R+IkMM3nF/SSDVI5gTiNtFaw1pAyuxHvQTeIxPR7sK+kLFAfbdywV1FrYZjUTQH7Z
         JWeQ==
X-Gm-Message-State: AOAM530+n3Um0KOkRy/sdLWZxyTXuGuv1tR0LtAQGChtHA931yegjYKA
        mFr8EUwQojzc+lduV3W7hDY=
X-Google-Smtp-Source: ABdhPJziCYkVCCofJ3JcT+/EA3Vq/HbkcRUPk+Ba330vdQSNTmLez2VrfahtNT4DqsJLFqoyZqupGQ==
X-Received: by 2002:a05:600c:608:: with SMTP id o8mr187927wmm.42.1615228865647;
        Mon, 08 Mar 2021 10:41:05 -0800 (PST)
Received: from skynet.lan (224.red-2-138-103.dynamicip.rima-tde.net. [2.138.103.224])
        by smtp.gmail.com with ESMTPSA id d29sm20146067wra.51.2021.03.08.10.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 10:41:05 -0800 (PST)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     jonas.gorski@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: mdio: Add BCM6368 MDIO mux bus controller
Date:   Mon,  8 Mar 2021 19:41:02 +0100
Message-Id: <20210308184102.3921-3-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210308184102.3921-1-noltari@gmail.com>
References: <20210308184102.3921-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This controller is present on BCM6318, BCM6328, BCM6362, BCM6368 and BCM63268
SoCs.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/net/mdio/Kconfig            |  11 ++
 drivers/net/mdio/Makefile           |   1 +
 drivers/net/mdio/mdio-mux-bcm6368.c | 179 ++++++++++++++++++++++++++++
 3 files changed, 191 insertions(+)
 create mode 100644 drivers/net/mdio/mdio-mux-bcm6368.c

diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index a10cc460d7cf..d06e06f5e31a 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -200,6 +200,17 @@ config MDIO_BUS_MUX_MESON_G12A
 	  the amlogic g12a SoC. The multiplexers connects either the external
 	  or the internal MDIO bus to the parent bus.
 
+config MDIO_BUS_MUX_BCM6368
+	tristate "Broadcom BCM6368 MDIO bus multiplexers"
+	depends on OF && OF_MDIO && (BMIPS_GENERIC || COMPILE_TEST)
+	select MDIO_BUS_MUX
+	default BMIPS_GENERIC
+	help
+	  This module provides a driver for MDIO bus multiplexers found in
+	  BCM6368 based Broadcom SoCs. This multiplexer connects one of several
+	  child MDIO bus to a parent bus. Buses could be internal as well as
+	  external and selection logic lies inside the same multiplexer.
+
 config MDIO_BUS_MUX_BCM_IPROC
 	tristate "Broadcom iProc based MDIO bus multiplexers"
 	depends on OF && OF_MDIO && (ARCH_BCM_IPROC || COMPILE_TEST)
diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
index 5c498dde463f..c3ec0ef989df 100644
--- a/drivers/net/mdio/Makefile
+++ b/drivers/net/mdio/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_MDIO_THUNDER)		+= mdio-thunder.o
 obj-$(CONFIG_MDIO_XGENE)		+= mdio-xgene.o
 
 obj-$(CONFIG_MDIO_BUS_MUX)		+= mdio-mux.o
+obj-$(CONFIG_MDIO_BUS_MUX_BCM6368)	+= mdio-mux-bcm6368.o
 obj-$(CONFIG_MDIO_BUS_MUX_BCM_IPROC)	+= mdio-mux-bcm-iproc.o
 obj-$(CONFIG_MDIO_BUS_MUX_GPIO)		+= mdio-mux-gpio.o
 obj-$(CONFIG_MDIO_BUS_MUX_MESON_G12A)	+= mdio-mux-meson-g12a.o
diff --git a/drivers/net/mdio/mdio-mux-bcm6368.c b/drivers/net/mdio/mdio-mux-bcm6368.c
new file mode 100644
index 000000000000..79ab2e2af5b9
--- /dev/null
+++ b/drivers/net/mdio/mdio-mux-bcm6368.c
@@ -0,0 +1,179 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Broadcom BCM6368 mdiomux bus controller driver
+ *
+ * Copyright (C) 2021 Álvaro Fernández Rojas <noltari@gmail.com>
+ */
+
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/mdio-mux.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/of_mdio.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+
+#define MDIOC_REG		0x0
+#define MDIOC_EXT_MASK		BIT(16)
+#define MDIOC_REG_SHIFT		20
+#define MDIOC_PHYID_SHIFT	25
+#define MDIOC_RD_MASK		BIT(30)
+#define MDIOC_WR_MASK		BIT(31)
+
+#define MDIOD_REG		0x4
+
+struct bcm6368_mdiomux_desc {
+	void *mux_handle;
+	void __iomem *base;
+	struct device *dev;
+	struct mii_bus *mii_bus;
+	int ext_phy;
+};
+
+static int bcm6368_mdiomux_read(struct mii_bus *bus, int phy_id, int loc)
+{
+	struct bcm6368_mdiomux_desc *md = bus->priv;
+	uint32_t reg;
+	int ret;
+
+	__raw_writel(0, md->base + MDIOC_REG);
+
+	reg = MDIOC_RD_MASK |
+	      (phy_id << MDIOC_PHYID_SHIFT) |
+	      (loc << MDIOC_REG_SHIFT);
+	if (md->ext_phy)
+		reg |= MDIOC_EXT_MASK;
+
+	__raw_writel(reg, md->base + MDIOC_REG);
+	udelay(50);
+	ret = __raw_readw(md->base + MDIOD_REG);
+
+	return ret;
+}
+
+static int bcm6368_mdiomux_write(struct mii_bus *bus, int phy_id, int loc,
+				 uint16_t val)
+{
+	struct bcm6368_mdiomux_desc *md = bus->priv;
+	uint32_t reg;
+
+	__raw_writel(0, md->base + MDIOC_REG);
+
+	reg = MDIOC_WR_MASK |
+	      (phy_id << MDIOC_PHYID_SHIFT) |
+	      (loc << MDIOC_REG_SHIFT);
+	if (md->ext_phy)
+		reg |= MDIOC_EXT_MASK;
+	reg |= val;
+
+	__raw_writel(reg, md->base + MDIOC_REG);
+	udelay(50);
+
+	return 0;
+}
+
+static int bcm6368_mdiomux_switch_fn(int current_child, int desired_child,
+				     void *data)
+{
+	struct bcm6368_mdiomux_desc *md = data;
+
+	md->ext_phy = desired_child;
+
+	return 0;
+}
+
+static int bcm6368_mdiomux_probe(struct platform_device *pdev)
+{
+	struct bcm6368_mdiomux_desc *md;
+	struct mii_bus *bus;
+	struct resource *res;
+	int rc;
+
+	md = devm_kzalloc(&pdev->dev, sizeof(*md), GFP_KERNEL);
+	if (!md)
+		return -ENOMEM;
+	md->dev = &pdev->dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
+
+	/* Just ioremap, as this MDIO block is usually integrated into an
+	 * Ethernet MAC controller register range
+	 */
+	md->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!md->base) {
+		dev_err(&pdev->dev, "failed to ioremap register\n");
+		return -ENOMEM;
+	}
+
+	md->mii_bus = devm_mdiobus_alloc(&pdev->dev);
+	if (!md->mii_bus) {
+		dev_err(&pdev->dev, "mdiomux bus alloc failed\n");
+		return ENOMEM;
+	}
+
+	bus = md->mii_bus;
+	bus->priv = md;
+	bus->name = "BCM6368 MDIO mux bus";
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-%d", pdev->name, pdev->id);
+	bus->parent = &pdev->dev;
+	bus->read = bcm6368_mdiomux_read;
+	bus->write = bcm6368_mdiomux_write;
+	bus->phy_mask = 0x3f;
+	bus->dev.of_node = pdev->dev.of_node;
+
+	rc = mdiobus_register(bus);
+	if (rc) {
+		dev_err(&pdev->dev, "mdiomux registration failed\n");
+		return rc;
+	}
+
+	platform_set_drvdata(pdev, md);
+
+	rc = mdio_mux_init(md->dev, md->dev->of_node,
+			   bcm6368_mdiomux_switch_fn, &md->mux_handle, md,
+			   md->mii_bus);
+	if (rc) {
+		dev_info(md->dev, "mdiomux initialization failed\n");
+		goto out_register;
+	}
+
+	dev_info(&pdev->dev, "Broadcom BCM6368 MDIO mux bus\n");
+
+	return 0;
+
+out_register:
+	mdiobus_unregister(bus);
+	return rc;
+}
+
+static int bcm6368_mdiomux_remove(struct platform_device *pdev)
+{
+	struct bcm6368_mdiomux_desc *md = platform_get_drvdata(pdev);
+
+	mdio_mux_uninit(md->mux_handle);
+	mdiobus_unregister(md->mii_bus);
+
+	return 0;
+}
+
+static const struct of_device_id bcm6368_mdiomux_ids[] = {
+	{ .compatible = "brcm,bcm6368-mdio-mux", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, bcm6368_mdiomux_ids);
+
+static struct platform_driver bcm6368_mdiomux_driver = {
+	.driver = {
+		.name = "bcm6368-mdio-mux",
+		.of_match_table = bcm6368_mdiomux_ids,
+	},
+	.probe	= bcm6368_mdiomux_probe,
+	.remove	= bcm6368_mdiomux_remove,
+};
+module_platform_driver(bcm6368_mdiomux_driver);
-- 
2.20.1

