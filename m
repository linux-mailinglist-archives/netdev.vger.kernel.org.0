Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED782166AEC
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 00:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbgBTX0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 18:26:35 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36842 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgBTX0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 18:26:35 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so351661wma.1;
        Thu, 20 Feb 2020 15:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Di1qslRPbTpLpq+RzibDLTYgsINPkOU2t7v0O3JomH8=;
        b=Fx34DlnLGoVm0X3/BbyODqd94691Jp5RZd/JQFAGlbLlPbfN8OUDF/QeeOqf16rtSj
         ZoH4lb8IL9pmEC0NHIqiLjDR3gQPfCE0xD67dXyqQofrk1SGga+P57hiwz151IPYnusG
         LsgZUrTfP5aZpoV1cTVco7bW2a/W/Q1apbTlShWxVP5JPME+P0MWWibfSuFVelknEoLq
         fQwsx8XaZcCo0AI7BB2VaIARsEKESHvrBSAAAJpDSTXZZB7O/kDy4Q925Xkg6x/EuVp3
         aFupf+zDTd9fPRwKFSUZvYe0d+FVvgZSVuwusXEsDMpPxmsx5oH9mHO3KqIUR0M2O+ZR
         pIFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Di1qslRPbTpLpq+RzibDLTYgsINPkOU2t7v0O3JomH8=;
        b=Yq4wxbrRwu2CU64gdSZW3EjeijDaTBZrhL8Hm1l9Z83bqj0Lu19TKXBqpYhiaJgBIa
         AwiVOhzeqYcoPhFWK0762kDzsHo7fwYAUybY3sCjmesWcy29hVYmLIsdat3MHg0S1F7C
         rmiOz/Vgv0Me4NcQ4l2CUA2RwiTbG3oeFm8LHnRgSQG6YczCuwKZyOiTjYFR3XA1WgCb
         yTnGUxfR4ITo0ybt5+P0TYSR0ZPkevwBN8NmtvAdVVL4hA3I3olpAOVNn3A2I/GTuodN
         5fa+FtlkXZRHzSlKN3HrKPg5CWVtMryGkSv9/F9X3q1E82L5QfNFwXLz7nINUNn3SLsG
         Ke+g==
X-Gm-Message-State: APjAAAW8i7jpobq8u0zFlfxRrzSI84cUz4Qq0PhUKHAnD3FYU7Etoa5g
        qVz9Y9PWRgOwnuBzPwhz1XFgj6WjDO4=
X-Google-Smtp-Source: APXvYqzcPuox4GKUuu553WORBOrXIwayqJTE8kc1Znk1nXaGNOSlFGzS//GNIR8GOwVkc6s65D/84Q==
X-Received: by 2002:a7b:c651:: with SMTP id q17mr7138818wmk.5.1582241192025;
        Thu, 20 Feb 2020 15:26:32 -0800 (PST)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id h18sm1498064wrv.78.2020.02.20.15.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 15:26:31 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] net: mdio: add ipq8064 mdio driver
Date:   Fri, 21 Feb 2020 00:26:21 +0100
Message-Id: <20200220232624.7001-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently ipq806x soc use generi bitbang driver to
comunicate with the gmac ethernet interface.
Add a dedicated driver created by chunkeey to fix this.

Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/phy/Kconfig        |   8 ++
 drivers/net/phy/Makefile       |   1 +
 drivers/net/phy/mdio-ipq8064.c | 163 +++++++++++++++++++++++++++++++++
 3 files changed, 172 insertions(+)
 create mode 100644 drivers/net/phy/mdio-ipq8064.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 9dabe03a668c..ec2a5493a7e8 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -157,6 +157,14 @@ config MDIO_I2C
 
 	  This is library mode.
 
+config MDIO_IPQ8064
+	tristate "Qualcomm IPQ8064 MDIO interface support"
+	depends on HAS_IOMEM && OF_MDIO
+	depends on MFD_SYSCON
+	help
+	  This driver supports the MDIO interface found in the network
+	  interface units of the IPQ8064 SoC
+
 config MDIO_MOXART
 	tristate "MOXA ART MDIO interface support"
 	depends on ARCH_MOXART || COMPILE_TEST
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index fe5badf13b65..8f02bd2089f3 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_MDIO_CAVIUM)	+= mdio-cavium.o
 obj-$(CONFIG_MDIO_GPIO)		+= mdio-gpio.o
 obj-$(CONFIG_MDIO_HISI_FEMAC)	+= mdio-hisi-femac.o
 obj-$(CONFIG_MDIO_I2C)		+= mdio-i2c.o
+obj-$(CONFIG_MDIO_IPQ8064)	+= mdio-ipq8064.o
 obj-$(CONFIG_MDIO_MOXART)	+= mdio-moxart.o
 obj-$(CONFIG_MDIO_MSCC_MIIM)	+= mdio-mscc-miim.o
 obj-$(CONFIG_MDIO_OCTEON)	+= mdio-octeon.o
diff --git a/drivers/net/phy/mdio-ipq8064.c b/drivers/net/phy/mdio-ipq8064.c
new file mode 100644
index 000000000000..e974a6f5d5ef
--- /dev/null
+++ b/drivers/net/phy/mdio-ipq8064.c
@@ -0,0 +1,163 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Qualcomm IPQ8064 MDIO interface driver
+//
+// Copyright (C) 2019 Christian Lamparter <chunkeey@gmail.com>
+
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/of_mdio.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/syscon.h>
+
+/* MII address register definitions */
+#define MII_ADDR_REG_ADDR                       0x10
+#define MII_BUSY                                BIT(0)
+#define MII_WRITE                               BIT(1)
+#define MII_CLKRANGE_60_100M                    (0 << 2)
+#define MII_CLKRANGE_100_150M                   (1 << 2)
+#define MII_CLKRANGE_20_35M                     (2 << 2)
+#define MII_CLKRANGE_35_60M                     (3 << 2)
+#define MII_CLKRANGE_150_250M                   (4 << 2)
+#define MII_CLKRANGE_250_300M                   (5 << 2)
+#define MII_CLKRANGE_MASK			GENMASK(4, 2)
+#define MII_REG_SHIFT				6
+#define MII_REG_MASK				GENMASK(10, 6)
+#define MII_ADDR_SHIFT				11
+#define MII_ADDR_MASK				GENMASK(15, 11)
+
+#define MII_DATA_REG_ADDR                       0x14
+
+#define MII_MDIO_DELAY                          (1000)
+#define MII_MDIO_RETRY                          (10)
+
+struct ipq8064_mdio {
+	struct regmap *base; /* NSS_GMAC0_BASE */
+};
+
+static int
+ipq8064_mdio_wait_busy(struct ipq8064_mdio *priv)
+{
+	u32 busy;
+
+	return regmap_read_poll_timeout(priv->base, MII_ADDR_REG_ADDR, busy,
+				   !(busy & MII_BUSY), MII_MDIO_DELAY,
+				   MII_MDIO_RETRY * USEC_PER_MSEC);
+}
+
+static int
+ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
+{
+	struct ipq8064_mdio *priv = bus->priv;
+	u32 miiaddr = MII_BUSY | MII_CLKRANGE_250_300M;
+	u32 ret_val;
+	int err;
+
+	/* Reject clause 45 */
+	if (reg_offset & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	miiaddr |= ((phy_addr << MII_ADDR_SHIFT) & MII_ADDR_MASK) |
+		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
+
+	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
+	usleep_range(10, 20);
+
+	err = ipq8064_mdio_wait_busy(priv);
+	if (err)
+		return err;
+
+	regmap_read(priv->base, MII_DATA_REG_ADDR, &ret_val);
+	return (int)ret_val;
+}
+
+static int
+ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int reg_offset, u16 data)
+{
+	struct ipq8064_mdio *priv = bus->priv;
+	u32 miiaddr = MII_WRITE | MII_BUSY | MII_CLKRANGE_250_300M;
+
+	/* Reject clause 45 */
+	if (reg_offset & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	regmap_write(priv->base, MII_DATA_REG_ADDR, data);
+
+	miiaddr |= ((phy_addr << MII_ADDR_SHIFT) & MII_ADDR_MASK) |
+		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
+
+	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
+	usleep_range(10, 20);
+
+	return ipq8064_mdio_wait_busy(priv);
+}
+
+static int
+ipq8064_mdio_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct ipq8064_mdio *priv;
+	struct mii_bus *bus;
+	int ret;
+
+	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
+	if (!bus)
+		return -ENOMEM;
+
+	bus->name = "ipq8064_mdio_bus";
+	bus->read = ipq8064_mdio_read;
+	bus->write = ipq8064_mdio_write;
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(&pdev->dev));
+	bus->parent = &pdev->dev;
+
+	priv = bus->priv;
+	priv->base = syscon_node_to_regmap(np);
+	if (IS_ERR_OR_NULL(priv->base)) {
+		priv->base = syscon_regmap_lookup_by_phandle(np, "master");
+		if (IS_ERR_OR_NULL(priv->base)) {
+			dev_err(&pdev->dev, "master phandle not found\n");
+			return -EINVAL;
+		}
+	}
+
+	ret = of_mdiobus_register(bus, np);
+	if (ret)
+		return ret;
+
+	platform_set_drvdata(pdev, bus);
+	return 0;
+}
+
+static int
+ipq8064_mdio_remove(struct platform_device *pdev)
+{
+	struct mii_bus *bus = platform_get_drvdata(pdev);
+
+	mdiobus_unregister(bus);
+
+	return 0;
+}
+
+static const struct of_device_id ipq8064_mdio_dt_ids[] = {
+	{ .compatible = "qcom,ipq8064-mdio" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ipq8064_mdio_dt_ids);
+
+static struct platform_driver ipq8064_mdio_driver = {
+	.probe = ipq8064_mdio_probe,
+	.remove = ipq8064_mdio_remove,
+	.driver = {
+		.name = "ipq8064-mdio",
+		.of_match_table = ipq8064_mdio_dt_ids,
+	},
+};
+
+module_platform_driver(ipq8064_mdio_driver);
+
+MODULE_DESCRIPTION("Qualcomm IPQ8064 MDIO interface driver");
+MODULE_AUTHOR("Christian Lamparter <chunkeey@gmail.com>");
+MODULE_LICENSE("GPL");
-- 
2.25.0

