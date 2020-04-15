Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A311AAB4D
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 17:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393030AbgDOPFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 11:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729650AbgDOPFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 11:05:25 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F96C061A0F
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 08:05:24 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id y24so19548140wma.4
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 08:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6bV2HeTGcv3f8Xferv4EwXy1zjagyBPQhQsUXxVtj/g=;
        b=OL/jBsrXRy5ytGaQCDi4+6IM9BUvDGHy2ELXICEX4Yy+dY7vAUZHp7dQJ0AduSZuPz
         gycamtyj34k72fmdHXZnhDG6Zt5JxVlkOHPrNRhhJNSmngDH9F/jmU5MXCWHigk745Jr
         VSDyigkelhifFNoQkO4giJxkeSSmr3bGyAWz16RsaHPig1idAbTSIP/+CvlsGzTpdBdk
         7jRcLfwyc6sLOXQzuvi3L/sMDzMwVwvvYHPFPad1CA1DXsuLlcMXxAQVgYibzGIUYKUA
         2nX9xKP++2GM8vOY6uNif8EpoMo0ccUZdkDmy2GJlGHvzj1TrEqyRZnggy9EpjeFRbwJ
         dzfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6bV2HeTGcv3f8Xferv4EwXy1zjagyBPQhQsUXxVtj/g=;
        b=n58I2ekVnnEK/VNOZiKTKpzh/r10lkqvw8zrZ7IMk+kBOzNqBQrB5Jfy3AJ4VhVJgO
         WgCXv3Db3FzHhPGkJ8O8A4MVzuX5Vl6b2idOryNmRR55XP+t5E8Z/T0tAyT2BU9xdrlT
         rqLCEsyjKF1oxiEQVclP9wSz7Ynal/3bc4wvzCIVSpPBvJ0717KcveGuq9rHBa0Rf1yf
         pfFmLHYOmEEemE8AJVCwyLB9/ATDbyaI6P+AiBObreTvYnC+LrW+EhUeu1cPhK6PCalJ
         roTXkl+yHd7v3eCS5s2Oka5ROBfIibnjaVM9uaDztq1zt/OWiVLnQldNrOzPXLljxJSU
         8cdA==
X-Gm-Message-State: AGi0PubmL0g8tyquFLAdneJfTQsNnp2iP3gGVzZQqV6t72ZNMA0q2skb
        a63pb1Dpg1+N7kJqOKkhGEth5g==
X-Google-Smtp-Source: APiQypJnQ5otk3NwxV5qIlY7yA0/9eShYdbAJA9XUjJKvutu8USsGNScoT38es1QIC9NaMsIDSDmGw==
X-Received: by 2002:a1c:6787:: with SMTP id b129mr5955168wmc.165.1586963122898;
        Wed, 15 Apr 2020 08:05:22 -0700 (PDT)
Received: from localhost.localdomain (dh207-96-108.xnet.hr. [88.207.96.108])
        by smtp.googlemail.com with ESMTPSA id s6sm22729988wmh.17.2020.04.15.08.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 08:05:20 -0700 (PDT)
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
Subject: [PATCH v3 1/3] net: phy: mdio: add IPQ40xx MDIO driver
Date:   Wed, 15 Apr 2020 17:02:43 +0200
Message-Id: <20200415150244.2737206-1-robert.marko@sartura.hr>
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
Changes from v2 to v3:
* Rename registers
* Remove unnecessary variable initialisations
* Switch to readl_poll_timeout() instead of custom solution
* Drop unused header

Changes from v1 to v2:
* Remove magic default value
* Remove lockdep_assert_held
* Add C45 check
* Simplify the driver
* Drop device and mii_bus structs from private struct
* Use devm_mdiobus_alloc_size()

 drivers/net/phy/Kconfig        |   7 ++
 drivers/net/phy/Makefile       |   1 +
 drivers/net/phy/mdio-ipq40xx.c | 160 +++++++++++++++++++++++++++++++++
 3 files changed, 168 insertions(+)
 create mode 100644 drivers/net/phy/mdio-ipq40xx.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 3fa33d27eeba..23bb5db033e3 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -157,6 +157,13 @@ config MDIO_I2C
 
 	  This is library mode.
 
+config MDIO_IPQ40XX
+	tristate "Qualcomm IPQ40xx MDIO interface"
+	depends on HAS_IOMEM && OF_MDIO
+	help
+	  This driver supports the MDIO interface found in Qualcomm
+	  IPQ40xx series Soc-s.
+
 config MDIO_IPQ8064
 	tristate "Qualcomm IPQ8064 MDIO interface support"
 	depends on HAS_IOMEM && OF_MDIO
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 2f5c7093a65b..36aafc6128c4 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_MDIO_CAVIUM)	+= mdio-cavium.o
 obj-$(CONFIG_MDIO_GPIO)		+= mdio-gpio.o
 obj-$(CONFIG_MDIO_HISI_FEMAC)	+= mdio-hisi-femac.o
 obj-$(CONFIG_MDIO_I2C)		+= mdio-i2c.o
+obj-$(CONFIG_MDIO_IPQ40XX)	+= mdio-ipq40xx.o
 obj-$(CONFIG_MDIO_IPQ8064)	+= mdio-ipq8064.o
 obj-$(CONFIG_MDIO_MOXART)	+= mdio-moxart.o
 obj-$(CONFIG_MDIO_MSCC_MIIM)	+= mdio-mscc-miim.o
diff --git a/drivers/net/phy/mdio-ipq40xx.c b/drivers/net/phy/mdio-ipq40xx.c
new file mode 100644
index 000000000000..acf1230341bd
--- /dev/null
+++ b/drivers/net/phy/mdio-ipq40xx.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright (c) 2015, The Linux Foundation. All rights reserved. */
+/* Copyright (c) 2020 Sartura Ltd. */
+
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/of_address.h>
+#include <linux/of_mdio.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+
+#define MDIO_ADDR_REG				0x44
+#define MDIO_DATA_WRITE_REG			0x48
+#define MDIO_DATA_READ_REG			0x4c
+#define MDIO_CMD_REG				0x50
+#define MDIO_CMD_ACCESS_BUSY		BIT(16)
+#define MDIO_CMD_ACCESS_START		BIT(8)
+#define MDIO_CMD_ACCESS_CODE_READ	0
+#define MDIO_CMD_ACCESS_CODE_WRITE	1
+
+#define IPQ40XX_MDIO_TIMEOUT	10000
+#define IPQ40XX_MDIO_SLEEP		10
+
+struct ipq40xx_mdio_data {
+	void __iomem	*membase;
+};
+
+static int ipq40xx_mdio_wait_busy(struct mii_bus *bus)
+{
+	struct ipq40xx_mdio_data *priv = bus->priv;
+	unsigned int busy;
+
+	return readl_poll_timeout(priv->membase + MDIO_CMD_REG, busy,
+				  (busy & MDIO_CMD_ACCESS_BUSY) == 0, 
+				  IPQ40XX_MDIO_SLEEP, IPQ40XX_MDIO_TIMEOUT);
+}
+
+static int ipq40xx_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
+{
+	struct ipq40xx_mdio_data *priv = bus->priv;
+	unsigned int cmd;
+
+	/* Reject clause 45 */
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	if (ipq40xx_mdio_wait_busy(bus))
+		return -ETIMEDOUT;
+
+	/* issue the phy address and reg */
+	writel((mii_id << 8) | regnum, priv->membase + MDIO_ADDR_REG);
+
+	cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_READ;
+
+	/* issue read command */
+	writel(cmd, priv->membase + MDIO_CMD_REG);
+
+	/* Wait read complete */
+	if (ipq40xx_mdio_wait_busy(bus))
+		return -ETIMEDOUT;
+
+	/* Read and return data */
+	return readl(priv->membase + MDIO_DATA_READ_REG);
+}
+
+static int ipq40xx_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
+							 u16 value)
+{
+	struct ipq40xx_mdio_data *priv = bus->priv;
+	unsigned int cmd;
+
+	/* Reject clause 45 */
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	if (ipq40xx_mdio_wait_busy(bus))
+		return -ETIMEDOUT;
+
+	/* issue the phy address and reg */
+	writel((mii_id << 8) | regnum, priv->membase + MDIO_ADDR_REG);
+
+	/* issue write data */
+	writel(value, priv->membase + MDIO_DATA_WRITE_REG);
+
+	cmd = MDIO_CMD_ACCESS_START | MDIO_CMD_ACCESS_CODE_WRITE;
+	/* issue write command */
+	writel(cmd, priv->membase + MDIO_CMD_REG);
+
+	/* Wait write complete */
+	if (ipq40xx_mdio_wait_busy(bus))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int ipq40xx_mdio_probe(struct platform_device *pdev)
+{
+	struct ipq40xx_mdio_data *priv;
+	struct mii_bus *bus;
+	int ret;
+
+	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
+	if (!bus)
+		return -ENOMEM;
+
+	priv = bus->priv;
+
+	priv->membase = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(priv->membase))
+		return PTR_ERR(priv->membase);
+
+	bus->name = "ipq40xx_mdio";
+	bus->read = ipq40xx_mdio_read;
+	bus->write = ipq40xx_mdio_write;
+	bus->parent = &pdev->dev;
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s%d", pdev->name, pdev->id);
+
+	ret = of_mdiobus_register(bus, pdev->dev.of_node);
+	if (ret) {
+		dev_err(&pdev->dev, "Cannot register MDIO bus!\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, bus);
+
+	return 0;
+}
+
+static int ipq40xx_mdio_remove(struct platform_device *pdev)
+{
+	struct mii_bus *bus = platform_get_drvdata(pdev);
+
+	mdiobus_unregister(bus);
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

