Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD5D1A6AC6
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 19:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732283AbgDMRBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 13:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732277AbgDMRBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 13:01:20 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C190C0A3BE2
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 10:01:20 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id v5so10844959wrp.12
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 10:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ifz7eEgQDkI/yAEt03RoeGqs19nYSssxU5j/gJ4Dim0=;
        b=Kpa31S9WV4DB2epJ0brmlqCYF1LhiH7z0L6PGh4Wbzcd03Fn0R+4GpBmxvFEB7UwNs
         tfXfQdPF8/Hp/4af5lAokIt68Wyxat3WatIWk7ZEitiTrGuHw2acegBAEv0i/7Hn0iuy
         ZSPISg9Pl1NZZW2DtFYy5nSyOoczsqC5qAUIGoV9LT7y7SwQGQZ5a4RcFT1bcdGDEYKv
         7CH50QYVjnEq1z3Mvr4EV4bIV4wAY6Btp5ypPFZETulZ0qzAG6e0LAgVC6tKR3VCE58z
         Y9E0wIaZm1/uVvZIw3Nc8wtYDlya9c8AWTu7VRTCXRgJRDBptbDHNrPZtl608d5u+QJY
         2vwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ifz7eEgQDkI/yAEt03RoeGqs19nYSssxU5j/gJ4Dim0=;
        b=PkupnuA8GO5Oko4mhHrhjoM5Jatw2t3974qAG87yShLgGlAlZlddg3uVbz1Dtb+1FE
         fcQHOFeVxgxJMgpOOeMGuoKRIYuU58az4qE1QOFJaWaLL8zYugV7NDt0Uvxjr98ihe15
         bRdQFx5p94QEjdPUpp/R3bjUcT9FfDeRfZFyCmeFwyhb2bLT6K9nMetlY964xLgWQMQd
         iWGwdktjU3Eo+9YwWrqE0AjbPEeblF1Skhdl7ue3F18rC865+hDxfsncIm56wcd98UpC
         w1ifaUpXJ85yMiuzVOVT1KpVHd60ZjhMrMcVH6N4dhUZ9qgyuuzgZb5b5PcG7GXD/1MJ
         ySJQ==
X-Gm-Message-State: AGi0Pub1aNgEDD+zPDInZ4qJF/WraRl7RYEkROJku2MfuZZ8+h1Cam4U
        aZI0IPcNDUjHzAQGAojY6B2/IA==
X-Google-Smtp-Source: APiQypI5L7HxfafpOR4GRvpAW8MC8kqY/R8iWGtx4F0odEFkYwngaQANZQgPqx5hNnsILB/TjEYY0w==
X-Received: by 2002:adf:e3ca:: with SMTP id k10mr2020584wrm.53.1586797278826;
        Mon, 13 Apr 2020 10:01:18 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:1f1b:192:29fe:7bf:41fe:904d])
        by smtp.googlemail.com with ESMTPSA id q187sm15443268wma.41.2020.04.13.10.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 10:01:18 -0700 (PDT)
From:   Robert Marko <robert.marko@sartura.hr>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Robert Marko <robert.marko@sartura.hr>,
        Christian Lamparter <chunkeey@gmail.com>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: [PATCH 1/3] net: phy: mdio: add IPQ40xx MDIO driver
Date:   Mon, 13 Apr 2020 19:01:05 +0200
Message-Id: <20200413170107.246509-1-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the driver for the MDIO interface
inside of Qualcomm IPQ40xx series SoC-s.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Cc: Luka Perkov <luka.perkov@sartura.hr>
---
 drivers/net/phy/Kconfig        |   7 ++
 drivers/net/phy/Makefile       |   1 +
 drivers/net/phy/mdio-ipq40xx.c | 180 +++++++++++++++++++++++++++++++++
 3 files changed, 188 insertions(+)
 create mode 100644 drivers/net/phy/mdio-ipq40xx.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 9dabe03a668c..614d08635012 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -157,6 +157,13 @@ config MDIO_I2C
 
 	  This is library mode.
 
+config MDIO_IPQ40XX
+	tristate "Qualcomm IPQ40xx MDIO interface"
+	depends on HAS_IOMEM && OF
+	help
+	  This driver supports the MDIO interface found in Qualcomm
+	  IPQ40xx series Soc-s.
+
 config MDIO_MOXART
 	tristate "MOXA ART MDIO interface support"
 	depends on ARCH_MOXART || COMPILE_TEST
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index fe5badf13b65..c89fc187fd74 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_MDIO_CAVIUM)	+= mdio-cavium.o
 obj-$(CONFIG_MDIO_GPIO)		+= mdio-gpio.o
 obj-$(CONFIG_MDIO_HISI_FEMAC)	+= mdio-hisi-femac.o
 obj-$(CONFIG_MDIO_I2C)		+= mdio-i2c.o
+obj-$(CONFIG_MDIO_IPQ40XX)	+= mdio-ipq40xx.o
 obj-$(CONFIG_MDIO_MOXART)	+= mdio-moxart.o
 obj-$(CONFIG_MDIO_MSCC_MIIM)	+= mdio-mscc-miim.o
 obj-$(CONFIG_MDIO_OCTEON)	+= mdio-octeon.o
diff --git a/drivers/net/phy/mdio-ipq40xx.c b/drivers/net/phy/mdio-ipq40xx.c
new file mode 100644
index 000000000000..8068f1e6a077
--- /dev/null
+++ b/drivers/net/phy/mdio-ipq40xx.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright (c) 2015, The Linux Foundation. All rights reserved. */
+
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/io.h>
+#include <linux/of_address.h>
+#include <linux/of_mdio.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+
+#define MDIO_CTRL_0_REG		0x40
+#define MDIO_CTRL_1_REG		0x44
+#define MDIO_CTRL_2_REG		0x48
+#define MDIO_CTRL_3_REG		0x4c
+#define MDIO_CTRL_4_REG		0x50
+#define MDIO_CTRL_4_ACCESS_BUSY		BIT(16)
+#define MDIO_CTRL_4_ACCESS_START		BIT(8)
+#define MDIO_CTRL_4_ACCESS_CODE_READ		0
+#define MDIO_CTRL_4_ACCESS_CODE_WRITE	1
+#define CTRL_0_REG_DEFAULT_VALUE	0x150FF
+
+#define IPQ40XX_MDIO_RETRY	1000
+#define IPQ40XX_MDIO_DELAY	10
+
+struct ipq40xx_mdio_data {
+	struct mii_bus	*mii_bus;
+	void __iomem	*membase;
+	struct device	*dev;
+};
+
+static int ipq40xx_mdio_wait_busy(struct ipq40xx_mdio_data *am)
+{
+	int i;
+
+	for (i = 0; i < IPQ40XX_MDIO_RETRY; i++) {
+		unsigned int busy;
+
+		busy = readl(am->membase + MDIO_CTRL_4_REG) &
+			MDIO_CTRL_4_ACCESS_BUSY;
+		if (!busy)
+			return 0;
+
+		/* BUSY might take to be cleard by 15~20 times of loop */
+		udelay(IPQ40XX_MDIO_DELAY);
+	}
+
+	dev_err(am->dev, "%s: MDIO operation timed out\n", am->mii_bus->name);
+
+	return -ETIMEDOUT;
+}
+
+static int ipq40xx_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
+{
+	struct ipq40xx_mdio_data *am = bus->priv;
+	int value = 0;
+	unsigned int cmd = 0;
+
+	lockdep_assert_held(&bus->mdio_lock);
+
+	if (ipq40xx_mdio_wait_busy(am))
+		return -ETIMEDOUT;
+
+	/* issue the phy address and reg */
+	writel((mii_id << 8) | regnum, am->membase + MDIO_CTRL_1_REG);
+
+	cmd = MDIO_CTRL_4_ACCESS_START | MDIO_CTRL_4_ACCESS_CODE_READ;
+
+	/* issue read command */
+	writel(cmd, am->membase + MDIO_CTRL_4_REG);
+
+	/* Wait read complete */
+	if (ipq40xx_mdio_wait_busy(am))
+		return -ETIMEDOUT;
+
+	/* Read data */
+	value = readl(am->membase + MDIO_CTRL_3_REG);
+
+	return value;
+}
+
+static int ipq40xx_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
+							 u16 value)
+{
+	struct ipq40xx_mdio_data *am = bus->priv;
+	unsigned int cmd = 0;
+
+	lockdep_assert_held(&bus->mdio_lock);
+
+	if (ipq40xx_mdio_wait_busy(am))
+		return -ETIMEDOUT;
+
+	/* issue the phy address and reg */
+	writel((mii_id << 8) | regnum, am->membase + MDIO_CTRL_1_REG);
+
+	/* issue write data */
+	writel(value, am->membase + MDIO_CTRL_2_REG);
+
+	cmd = MDIO_CTRL_4_ACCESS_START | MDIO_CTRL_4_ACCESS_CODE_WRITE;
+	/* issue write command */
+	writel(cmd, am->membase + MDIO_CTRL_4_REG);
+
+	/* Wait write complete */
+	if (ipq40xx_mdio_wait_busy(am))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int ipq40xx_mdio_probe(struct platform_device *pdev)
+{
+	struct ipq40xx_mdio_data *am;
+	struct resource *res;
+
+	am = devm_kzalloc(&pdev->dev, sizeof(*am), GFP_KERNEL);
+	if (!am)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "no iomem resource found\n");
+		return -ENXIO;
+	}
+
+	am->membase = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(am->membase)) {
+		dev_err(&pdev->dev, "unable to ioremap registers\n");
+		return PTR_ERR(am->membase);
+	}
+
+	am->mii_bus = devm_mdiobus_alloc(&pdev->dev);
+	if (!am->mii_bus)
+		return  -ENOMEM;
+
+	writel(CTRL_0_REG_DEFAULT_VALUE, am->membase + MDIO_CTRL_0_REG);
+
+	am->mii_bus->name = "ipq40xx_mdio";
+	am->mii_bus->read = ipq40xx_mdio_read;
+	am->mii_bus->write = ipq40xx_mdio_write;
+	am->mii_bus->priv = am;
+	am->mii_bus->parent = &pdev->dev;
+	snprintf(am->mii_bus->id, MII_BUS_ID_SIZE, "%s", dev_name(&pdev->dev));
+
+	am->dev = &pdev->dev;
+	platform_set_drvdata(pdev, am);
+
+	return of_mdiobus_register(am->mii_bus, pdev->dev.of_node);
+}
+
+static int ipq40xx_mdio_remove(struct platform_device *pdev)
+{
+	struct ipq40xx_mdio_data *am = platform_get_drvdata(pdev);
+
+	mdiobus_unregister(am->mii_bus);
+
+	return 0;
+}
+
+static const struct of_device_id ipq40xx_mdio_dt_ids[] = {
+	{ .compatible = "qcom,ipq40xx-mdio" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ipq40xx_mdio_dt_ids);
+
+static struct platform_driver ipq40xx_mdio_driver = {
+	.probe = ipq40xx_mdio_probe,
+	.remove = ipq40xx_mdio_remove,
+	.driver = {
+		.name = "ipq40xx-mdio",
+		.of_match_table = ipq40xx_mdio_dt_ids,
+	},
+};
+
+module_platform_driver(ipq40xx_mdio_driver);
+
+MODULE_DESCRIPTION("IPQ40XX MDIO interface driver");
+MODULE_AUTHOR("Qualcomm Atheros");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.26.0

