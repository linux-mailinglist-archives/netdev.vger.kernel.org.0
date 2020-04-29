Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F291BDA4D
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 13:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgD2LHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 07:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726669AbgD2LHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 07:07:48 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA77C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 04:07:48 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g12so1549004wmh.3
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 04:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4IFZd1qXcd87Y4Kb8dlFeUJd/ZFzdcOLb7Q8itu4OPU=;
        b=D3L8bEZq35GXiY+CGCTabQG5WVKNnR/jHfXq4xPmKv4nEIe+nGiXOADk1co/R8dC3/
         1tj/zykIp2MJCGcYVTAed456XuNqBAVxEArZ6aEp/e3VtTgH0+0URkafCXq9pnSSs9Kx
         xHE8U8dGhSvF78hbZYmROaAq8ZArXBtHq1mcZuupyw0WaNfKiIa9+uAZVS/czB/yOxaR
         osrhfUw2mgtWfisVNmaq6FTOrNBTejATqgXp4IUgOrXiqjOs/NYZEns3lj988pmcA8iT
         LlQlq2+5S4caH8046OXHma8VPF45ce3JhXGeY3XJf4lUVds2qB+oK5ZGu7Fe4dZio6lM
         s9aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4IFZd1qXcd87Y4Kb8dlFeUJd/ZFzdcOLb7Q8itu4OPU=;
        b=A5u2gjTfLxS3XNpTucochWT8wzHeUve89II2YJlsZxQJZHAWPq1pOWqJjZi0aPY5bx
         QEr+VFETiDo8KYPeer9zjEdl3IrRquy/tbsmzlaY/VqgD18PrNX8YIKDUOJ8o+XYANM9
         Dtc/lB4+09PtQrDFeSS3ADV4Ig54Ns5iRr9MaP/S4cBYmAYsPg8FTHmM1XyXgBMMQBNW
         5eBzwUHm4tAgkPklX6In3i4AmKsrMZfdLD2PG+5ILW3ExX9LI4W9J2SGtjs4OHYFc7s8
         7gqBVPFJ4Up/FsxKl3mI/+iJ+Uxr18mIPXMAmQm0YEhNhAqQVQOAPXyvefhDJfnHmyP9
         rvlw==
X-Gm-Message-State: AGi0PuaDH4pQBFrnrgUkEkkhwhWLUVjyn/6GTip/VMqYP4jQ1GeHkeVM
        ueqYJXoRj/9WA1I35TH1VW34EQ==
X-Google-Smtp-Source: APiQypKT56YTOn878157tmKnVePrI/0BlCP6Nd2HCXAppKtDJ02Ytcb6hEBQzRtPbqngTRGbd6qi6w==
X-Received: by 2002:a1c:7c13:: with SMTP id x19mr2629862wmc.124.1588158467160;
        Wed, 29 Apr 2020 04:07:47 -0700 (PDT)
Received: from localhost.localdomain ([2a0e:b107:830:0:47e5:c676:4796:5818])
        by smtp.googlemail.com with ESMTPSA id u7sm7679963wmg.41.2020.04.29.04.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 04:07:46 -0700 (PDT)
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
Subject: [PATCH net-next v4 1/3] net: phy: mdio: add IPQ4019 MDIO driver
Date:   Wed, 29 Apr 2020 13:07:25 +0200
Message-Id: <20200429110726.448625-2-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429110726.448625-1-robert.marko@sartura.hr>
References: <20200429110726.448625-1-robert.marko@sartura.hr>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Luka Perkov <luka.perkov@sartura.hr>
---
Changes from v3 to v4:
* Change compatible	and references to IPQ4019
  per Rob Herrings suggestion

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
 drivers/net/phy/mdio-ipq4019.c | 160 +++++++++++++++++++++++++++++++++
 3 files changed, 168 insertions(+)
 create mode 100644 drivers/net/phy/mdio-ipq4019.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 3fa33d27eeba..6693df126861 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -157,6 +157,13 @@ config MDIO_I2C
 
 	  This is library mode.
 
+config MDIO_IPQ4019
+	tristate "Qualcomm IPQ4019 MDIO interface support"
+	depends on HAS_IOMEM && OF_MDIO
+	help
+	  This driver supports the MDIO interface found in Qualcomm
+	  IPQ40xx series Soc-s.
+
 config MDIO_IPQ8064
 	tristate "Qualcomm IPQ8064 MDIO interface support"
 	depends on HAS_IOMEM && OF_MDIO
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 2f5c7093a65b..12e0d0b137b9 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_MDIO_CAVIUM)	+= mdio-cavium.o
 obj-$(CONFIG_MDIO_GPIO)		+= mdio-gpio.o
 obj-$(CONFIG_MDIO_HISI_FEMAC)	+= mdio-hisi-femac.o
 obj-$(CONFIG_MDIO_I2C)		+= mdio-i2c.o
+obj-$(CONFIG_MDIO_IPQ4019)	+= mdio-ipq4019.o
 obj-$(CONFIG_MDIO_IPQ8064)	+= mdio-ipq8064.o
 obj-$(CONFIG_MDIO_MOXART)	+= mdio-moxart.o
 obj-$(CONFIG_MDIO_MSCC_MIIM)	+= mdio-mscc-miim.o
diff --git a/drivers/net/phy/mdio-ipq4019.c b/drivers/net/phy/mdio-ipq4019.c
new file mode 100644
index 000000000000..f1f25489e134
--- /dev/null
+++ b/drivers/net/phy/mdio-ipq4019.c
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
+#define ipq4019_MDIO_TIMEOUT	10000
+#define ipq4019_MDIO_SLEEP		10
+
+struct ipq4019_mdio_data {
+	void __iomem	*membase;
+};
+
+static int ipq4019_mdio_wait_busy(struct mii_bus *bus)
+{
+	struct ipq4019_mdio_data *priv = bus->priv;
+	unsigned int busy;
+
+	return readl_poll_timeout(priv->membase + MDIO_CMD_REG, busy,
+				  (busy & MDIO_CMD_ACCESS_BUSY) == 0, 
+				  ipq4019_MDIO_SLEEP, ipq4019_MDIO_TIMEOUT);
+}
+
+static int ipq4019_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
+{
+	struct ipq4019_mdio_data *priv = bus->priv;
+	unsigned int cmd;
+
+	/* Reject clause 45 */
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	if (ipq4019_mdio_wait_busy(bus))
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
+	if (ipq4019_mdio_wait_busy(bus))
+		return -ETIMEDOUT;
+
+	/* Read and return data */
+	return readl(priv->membase + MDIO_DATA_READ_REG);
+}
+
+static int ipq4019_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
+							 u16 value)
+{
+	struct ipq4019_mdio_data *priv = bus->priv;
+	unsigned int cmd;
+
+	/* Reject clause 45 */
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	if (ipq4019_mdio_wait_busy(bus))
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
+	if (ipq4019_mdio_wait_busy(bus))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int ipq4019_mdio_probe(struct platform_device *pdev)
+{
+	struct ipq4019_mdio_data *priv;
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
+	bus->name = "ipq4019_mdio";
+	bus->read = ipq4019_mdio_read;
+	bus->write = ipq4019_mdio_write;
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
+static int ipq4019_mdio_remove(struct platform_device *pdev)
+{
+	struct mii_bus *bus = platform_get_drvdata(pdev);
+
+	mdiobus_unregister(bus);
+
+	return 0;
+}
+
+static const struct of_device_id ipq4019_mdio_dt_ids[] = {
+	{ .compatible = "qcom,ipq4019-mdio" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ipq4019_mdio_dt_ids);
+
+static struct platform_driver ipq4019_mdio_driver = {
+	.probe = ipq4019_mdio_probe,
+	.remove = ipq4019_mdio_remove,
+	.driver = {
+		.name = "ipq4019-mdio",
+		.of_match_table = ipq4019_mdio_dt_ids,
+	},
+};
+
+module_platform_driver(ipq4019_mdio_driver);
+
+MODULE_DESCRIPTION("ipq4019 MDIO interface driver");
+MODULE_AUTHOR("Qualcomm Atheros");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.26.2

