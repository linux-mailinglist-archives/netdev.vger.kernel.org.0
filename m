Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A546BE853
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 12:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCQLgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 07:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjCQLgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 07:36:38 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200C3B04B0;
        Fri, 17 Mar 2023 04:35:53 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id q16so4136229wrw.2;
        Fri, 17 Mar 2023 04:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679052908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lRrrLMuDDvCGPcYTYlI30pl6wAJAhxm8BbBTgcL5hsE=;
        b=V7lW/rvmIy+pqTtLJzA4ccI0G81PY46/fxYcFDWSXIrClRhX2u6Ya+RZvp4f8g+hE0
         aYVlskismzkwBlePA/EzCBM6Wr/f5S3zKb4vcvmUUtsxosixX2VjU/9Bgu3ht1HhQG9z
         Qb4g+6vB+JM1sY04em34OQYtZVInmEYFU7bayf93Oz64Ru2En5lLhVKw8RmQ/BCfMcsa
         vBHraRa51Z7AnD1epUdq0X1eKRmfyZvrnaq7zBClz5T3br8Tm8ryTHpQ4WKbGK7vVFy0
         Cw7xrNHQ1caLeYrMHxh2S/zt38V0JGkvqNuW6bVjWtSIpUVWSmf7LnZqL4hW/VhEZyID
         1HQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679052908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lRrrLMuDDvCGPcYTYlI30pl6wAJAhxm8BbBTgcL5hsE=;
        b=BnevC6w/R02zmGw3fIzHdXFXYfW6UXfmYyQPBQT7ke5Oxm6+MhvLTDVMlxn7DwM9Cc
         /M1KSxE8wLoUhRG5GXHGdnV5TIoscF41+U7gO5qI4lj4f4mPb/FNQQMHgwQ0BdoiHsiS
         ZorncXzRqJBL/Aw5Xc0vcEMlpwmDb+ks3NZYsS+zdy3ScfvskpmgThkstxtbphsZ1Osl
         F9agrOHWyBDYfwGJMHaTJ7QlBtBD7xr/Z+O3tZWIO3DPjBHWmrlef18i+O6/uSov6CEi
         Ox8uI4UUlS0j60A3iGoHlXjRoihVdS/WdbySRYJAzrdOjfSXlVDDsKzB0+fKdYWw6cW9
         a5xw==
X-Gm-Message-State: AO0yUKUZbmm5M0aWCTZl101EvCVITNXO8SVn8ifHN+uqnlNwvXASMTdD
        F5agZeIoD8v2FmPf39e9VBg=
X-Google-Smtp-Source: AK7set/s4TAhqQh1INysS5yjnWZ4Oz04Jz68NJUBqyl7v6CmOQlG6L/r1lfyKpilgR/nxZFG5MblLg==
X-Received: by 2002:adf:f84b:0:b0:2ce:9f35:59c7 with SMTP id d11-20020adff84b000000b002ce9f3559c7mr6511459wrq.45.1679052908277;
        Fri, 17 Mar 2023 04:35:08 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm1763505wrj.47.2023.03.17.04.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:35:07 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH 3/3] net: mdio: remove BCM6368 MDIO mux bus driver
Date:   Fri, 17 Mar 2023 12:34:27 +0100
Message-Id: <20230317113427.302162-4-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230317113427.302162-1-noltari@gmail.com>
References: <20230317113427.302162-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver is now registered from DSA B53 MMAP switches.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/net/mdio/Kconfig            |  11 --
 drivers/net/mdio/Makefile           |   1 -
 drivers/net/mdio/mdio-mux-bcm6368.c | 184 ----------------------------
 3 files changed, 196 deletions(-)
 delete mode 100644 drivers/net/mdio/mdio-mux-bcm6368.c

diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index 90309980686e..2891d63a942f 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -226,17 +226,6 @@ config MDIO_BUS_MUX_MESON_GXL
 	  the amlogic GXL SoC. The multiplexer connects either the external
 	  or the internal MDIO bus to the parent bus.
 
-config MDIO_BUS_MUX_BCM6368
-	tristate "Broadcom BCM6368 MDIO bus multiplexers"
-	depends on OF && OF_MDIO && (BMIPS_GENERIC || COMPILE_TEST)
-	select MDIO_BUS_MUX
-	default BMIPS_GENERIC
-	help
-	  This module provides a driver for MDIO bus multiplexers found in
-	  BCM6368 based Broadcom SoCs. This multiplexer connects one of several
-	  child MDIO bus to a parent bus. Buses could be internal as well as
-	  external and selection logic lies inside the same multiplexer.
-
 config MDIO_BUS_MUX_BCM_IPROC
 	tristate "Broadcom iProc based MDIO bus multiplexers"
 	depends on OF && OF_MDIO && (ARCH_BCM_IPROC || COMPILE_TEST)
diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
index 7d4cb4c11e4e..06cbb64b88fc 100644
--- a/drivers/net/mdio/Makefile
+++ b/drivers/net/mdio/Makefile
@@ -24,7 +24,6 @@ obj-$(CONFIG_MDIO_THUNDER)		+= mdio-thunder.o
 obj-$(CONFIG_MDIO_XGENE)		+= mdio-xgene.o
 
 obj-$(CONFIG_MDIO_BUS_MUX)		+= mdio-mux.o
-obj-$(CONFIG_MDIO_BUS_MUX_BCM6368)	+= mdio-mux-bcm6368.o
 obj-$(CONFIG_MDIO_BUS_MUX_BCM_IPROC)	+= mdio-mux-bcm-iproc.o
 obj-$(CONFIG_MDIO_BUS_MUX_GPIO)		+= mdio-mux-gpio.o
 obj-$(CONFIG_MDIO_BUS_MUX_MESON_G12A)	+= mdio-mux-meson-g12a.o
diff --git a/drivers/net/mdio/mdio-mux-bcm6368.c b/drivers/net/mdio/mdio-mux-bcm6368.c
deleted file mode 100644
index 8b444a8eb6b5..000000000000
--- a/drivers/net/mdio/mdio-mux-bcm6368.c
+++ /dev/null
@@ -1,184 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * Broadcom BCM6368 mdiomux bus controller driver
- *
- * Copyright (C) 2021 Álvaro Fernández Rojas <noltari@gmail.com>
- */
-
-#include <linux/delay.h>
-#include <linux/io.h>
-#include <linux/kernel.h>
-#include <linux/mdio-mux.h>
-#include <linux/module.h>
-#include <linux/of.h>
-#include <linux/of_platform.h>
-#include <linux/of_mdio.h>
-#include <linux/phy.h>
-#include <linux/platform_device.h>
-#include <linux/sched.h>
-
-#define MDIOC_REG		0x0
-#define MDIOC_EXT_MASK		BIT(16)
-#define MDIOC_REG_SHIFT		20
-#define MDIOC_PHYID_SHIFT	25
-#define MDIOC_RD_MASK		BIT(30)
-#define MDIOC_WR_MASK		BIT(31)
-
-#define MDIOD_REG		0x4
-
-struct bcm6368_mdiomux_desc {
-	void *mux_handle;
-	void __iomem *base;
-	struct device *dev;
-	struct mii_bus *mii_bus;
-	int ext_phy;
-};
-
-static int bcm6368_mdiomux_read(struct mii_bus *bus, int phy_id, int loc)
-{
-	struct bcm6368_mdiomux_desc *md = bus->priv;
-	uint32_t reg;
-	int ret;
-
-	__raw_writel(0, md->base + MDIOC_REG);
-
-	reg = MDIOC_RD_MASK |
-	      (phy_id << MDIOC_PHYID_SHIFT) |
-	      (loc << MDIOC_REG_SHIFT);
-	if (md->ext_phy)
-		reg |= MDIOC_EXT_MASK;
-
-	__raw_writel(reg, md->base + MDIOC_REG);
-	udelay(50);
-	ret = __raw_readw(md->base + MDIOD_REG);
-
-	return ret;
-}
-
-static int bcm6368_mdiomux_write(struct mii_bus *bus, int phy_id, int loc,
-				 uint16_t val)
-{
-	struct bcm6368_mdiomux_desc *md = bus->priv;
-	uint32_t reg;
-
-	__raw_writel(0, md->base + MDIOC_REG);
-
-	reg = MDIOC_WR_MASK |
-	      (phy_id << MDIOC_PHYID_SHIFT) |
-	      (loc << MDIOC_REG_SHIFT);
-	if (md->ext_phy)
-		reg |= MDIOC_EXT_MASK;
-	reg |= val;
-
-	__raw_writel(reg, md->base + MDIOC_REG);
-	udelay(50);
-
-	return 0;
-}
-
-static int bcm6368_mdiomux_switch_fn(int current_child, int desired_child,
-				     void *data)
-{
-	struct bcm6368_mdiomux_desc *md = data;
-
-	md->ext_phy = desired_child;
-
-	return 0;
-}
-
-static int bcm6368_mdiomux_probe(struct platform_device *pdev)
-{
-	struct bcm6368_mdiomux_desc *md;
-	struct mii_bus *bus;
-	struct resource *res;
-	int rc;
-
-	md = devm_kzalloc(&pdev->dev, sizeof(*md), GFP_KERNEL);
-	if (!md)
-		return -ENOMEM;
-	md->dev = &pdev->dev;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -EINVAL;
-
-	/*
-	 * Just ioremap, as this MDIO block is usually integrated into an
-	 * Ethernet MAC controller register range
-	 */
-	md->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
-	if (!md->base) {
-		dev_err(&pdev->dev, "failed to ioremap register\n");
-		return -ENOMEM;
-	}
-
-	md->mii_bus = devm_mdiobus_alloc(&pdev->dev);
-	if (!md->mii_bus) {
-		dev_err(&pdev->dev, "mdiomux bus alloc failed\n");
-		return -ENOMEM;
-	}
-
-	bus = md->mii_bus;
-	bus->priv = md;
-	bus->name = "BCM6368 MDIO mux bus";
-	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-%d", pdev->name, pdev->id);
-	bus->parent = &pdev->dev;
-	bus->read = bcm6368_mdiomux_read;
-	bus->write = bcm6368_mdiomux_write;
-	bus->phy_mask = 0x3f;
-	bus->dev.of_node = pdev->dev.of_node;
-
-	rc = mdiobus_register(bus);
-	if (rc) {
-		dev_err(&pdev->dev, "mdiomux registration failed\n");
-		return rc;
-	}
-
-	platform_set_drvdata(pdev, md);
-
-	rc = mdio_mux_init(md->dev, md->dev->of_node,
-			   bcm6368_mdiomux_switch_fn, &md->mux_handle, md,
-			   md->mii_bus);
-	if (rc) {
-		dev_info(md->dev, "mdiomux initialization failed\n");
-		goto out_register;
-	}
-
-	dev_info(&pdev->dev, "Broadcom BCM6368 MDIO mux bus\n");
-
-	return 0;
-
-out_register:
-	mdiobus_unregister(bus);
-	return rc;
-}
-
-static int bcm6368_mdiomux_remove(struct platform_device *pdev)
-{
-	struct bcm6368_mdiomux_desc *md = platform_get_drvdata(pdev);
-
-	mdio_mux_uninit(md->mux_handle);
-	mdiobus_unregister(md->mii_bus);
-
-	return 0;
-}
-
-static const struct of_device_id bcm6368_mdiomux_ids[] = {
-	{ .compatible = "brcm,bcm6368-mdio-mux", },
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, bcm6368_mdiomux_ids);
-
-static struct platform_driver bcm6368_mdiomux_driver = {
-	.driver = {
-		.name = "bcm6368-mdio-mux",
-		.of_match_table = bcm6368_mdiomux_ids,
-	},
-	.probe	= bcm6368_mdiomux_probe,
-	.remove	= bcm6368_mdiomux_remove,
-};
-module_platform_driver(bcm6368_mdiomux_driver);
-
-MODULE_AUTHOR("Álvaro Fernández Rojas <noltari@gmail.com>");
-MODULE_DESCRIPTION("BCM6368 mdiomux bus controller driver");
-MODULE_LICENSE("GPL v2");
-- 
2.30.2

