Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20E88179B16
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 22:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388400AbgCDVjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 16:39:12 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55415 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729836AbgCDVjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 16:39:12 -0500
Received: by mail-wm1-f66.google.com with SMTP id 6so3914407wmi.5;
        Wed, 04 Mar 2020 13:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MpPoaXr3W0IwRhIelXL6xFW40lDRrEz+pqRqN1hm+CQ=;
        b=iiVCzqiJvyynh9w+F0jZOAqpmHchZkLHy1yyHvP4Mp+m1AXqNg4Q6To/W/sGugsMV4
         juV3ILjgHSjHJDPj9gOJxbHEre3VwS4JPJOsNkgQPt5IwdFkxubUTujBcrXohMFF7t2p
         6eiIq+YUaE/zUhQ/ycLInlOoc8TrKXo3ladTBAzxHhzNl6t5DMUO6NId+rAEE1DB3BYv
         84RnAfmO+mVfSHpp0o5qcBJ4GlXU6zKO6Yu1yl9yGtf9Sf/UXsTDIgLqMkiNvsi3VqHQ
         PWbZlAOpTdAGsFG7P3tjRCSPFnCpmuNjj+7XHmrgEInS/ItyRp22TfFK3eEH1t/nC7k/
         HNTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MpPoaXr3W0IwRhIelXL6xFW40lDRrEz+pqRqN1hm+CQ=;
        b=W3Kjm2vX4Za9Ayp4w7fbySwuZjwIIz2KZem5qaPk5z4vIIOkFMaTVPL0w/X8hvuuML
         0hj2qlTEYJRlKKEA/JkrGOJ0CCmhrW/cQz6GxYS1Woui/N6qt/qVgRvrdNE6qq400uoW
         3SNZ1Ms53Mu2wkj+i32sTOLLwm0bodCP7uJbwCeDdv2wwl3DQzDAuPVFLB89JZu7wcmy
         ya0DjYL4K6udSHNnyK67Dio8yr8j0INyMMo72WB/mdAYRR4sKqLBZoR06hWHAQxrFK8q
         zrOF68BdurdB5x9xxCoYomSft+pEQn1ZDagzC5lP7rL1IwG5wYd67cF9bNNAtzaObBSE
         0DDQ==
X-Gm-Message-State: ANhLgQ2d1hOxaV5OTESu9LehuTdxrW3mGtM3dDt4frTZ/38tKHidioIo
        aDMBbx4KvRbY9VmKdpK+sjE=
X-Google-Smtp-Source: ADFU+vuuu9NCukKmjOLZhtXks+7En2wKz4uEh/9nT4gN9ahYuiqX6Yyeqms4K44REnIdNlFSDaMSpA==
X-Received: by 2002:a1c:4d05:: with SMTP id o5mr854957wmh.167.1583357949181;
        Wed, 04 Mar 2020 13:39:09 -0800 (PST)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id e8sm42453280wrr.69.2020.03.04.13.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 13:39:08 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
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
Subject: [PATCH v9 1/2] net: mdio: add ipq8064 mdio driver
Date:   Wed,  4 Mar 2020 22:38:32 +0100
Message-Id: <20200304213841.5745-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <robh@kernel.org>
References: <robh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently ipq806x soc use generic bitbang driver to
comunicate with the gmac ethernet interface.
Add a dedicated driver created by chunkeey to fix this.

Co-developed-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
Changes in v9:
- Use device_node_to_regmap instead of 
  syscon_node_to_regmap

Changes in v8:
- Drop syscon_regmap_lookup_by_phandle and make
  clock definition in dts mandatory

Changes in v7:
- Add myself as module author and copyright
- Reduced usleep_range to 8-10 as suggested by chunkeey

Changes in v6:
- Fix error in commit description
- Add co-developed tag

Changes in v5:
- Rename define to more rappresentative name

Changes in v4:
- Fix wrong print value in dev_err

Changes in v3:
- Fix wrong return logic on error

Changes in v2:
- Use regmap_read_poll_timeout
- Reject clause 45

 drivers/net/phy/Kconfig        |   8 ++
 drivers/net/phy/Makefile       |   1 +
 drivers/net/phy/mdio-ipq8064.c | 166 +++++++++++++++++++++++++++++++++
 3 files changed, 175 insertions(+)
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
index 000000000000..1bd18857e1c5
--- /dev/null
+++ b/drivers/net/phy/mdio-ipq8064.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Qualcomm IPQ8064 MDIO interface driver
+ *
+ * Copyright (C) 2019 Christian Lamparter <chunkeey@gmail.com>
+ * Copyright (C) 2020 Ansuel Smith <ansuelsmth@gmail.com>
+ */
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
+#define MII_MDIO_DELAY_USEC                     (1000)
+#define MII_MDIO_RETRY_MSEC                     (10)
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
+					!(busy & MII_BUSY), MII_MDIO_DELAY_USEC,
+					MII_MDIO_RETRY_MSEC * USEC_PER_MSEC);
+}
+
+static int
+ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
+{
+	u32 miiaddr = MII_BUSY | MII_CLKRANGE_250_300M;
+	struct ipq8064_mdio *priv = bus->priv;
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
+	usleep_range(8, 10);
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
+	u32 miiaddr = MII_WRITE | MII_BUSY | MII_CLKRANGE_250_300M;
+	struct ipq8064_mdio *priv = bus->priv;
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
+	usleep_range(8, 10);
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
+	priv->base = device_node_to_regmap(np);
+	if (IS_ERR(priv->base)) {
+		if (priv->base == ERR_PTR(-EPROBE_DEFER))
+			return -EPROBE_DEFER;
+
+		dev_err(&pdev->dev, "error getting device regmap, error=%pe\n",
+			priv->base);
+		return PTR_ERR(priv->base);
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
+MODULE_AUTHOR("Ansuel Smith <ansuelsmth@gmail.com>");
+MODULE_LICENSE("GPL");
-- 
2.25.0

