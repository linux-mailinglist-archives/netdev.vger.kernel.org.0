Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADCB016902A
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 17:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbgBVQQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 11:16:45 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34525 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727339AbgBVQQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 11:16:44 -0500
Received: by mail-wr1-f65.google.com with SMTP id n10so5462731wrm.1;
        Sat, 22 Feb 2020 08:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ap8QsmRAabEWr23sTHvV+RbUWNEzGkqvYmVi6hlKNZc=;
        b=c9e2qo9sNEKLViHpBQnasS5W19GbKfne+q7pWQ3eNVc2eWucUWo6TfjHh8v62Ogavc
         Kb+swkv/1HmteYdBL7BI6W99QVheoDc6PhTpvAMXXXKEGF87Cm6UCXhkDvgcM3G+3YNt
         iP4VaQnoq45wj3gNu5Dyqk+nJCJwxri31VPY8JOSVtdArmo8Oxz/lEnKeR/vJCaUEhSF
         LhVuXMnZkrnRI/d2YZwCSGP4aoJNuU9bhwXd9/mtTJtWn5GJKoXujceM/DxtjoyMJaqE
         fk75E7cDFpn0NsBxqMGuGDmJlTqN7g37MzPQxvZUduBXc1hB4+8NIGosaxLfHVY50Tsh
         euKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ap8QsmRAabEWr23sTHvV+RbUWNEzGkqvYmVi6hlKNZc=;
        b=XHw2rYJZINxulOC23COFwC6PXc+D7rGK5d2ywVaqYHYt2nfHufozr6X81BR4AQM/fo
         KMjVi+iG/QK1zur/VJFwI7FNrHG6EikGcb+fDSBUaXEKzApXc3AihfGYEU2sTxhxFiuG
         MAqJ9u3v4yeKKSDrh6CN/oU/+aW6QktqBPtKVZkwVk/p7t2Lfj1lDAfQfsS9noUoJsVv
         V28ZbItmjFOZ/v5ZNNCr10W6Zzr7P6OlLnbR9TsC8OMoaeYhv77vUgMt1BoJjOBezP5c
         8Xu7sIpZiUvKDjg2hcIFovq59xt+6knBuPC6OntsC/6/7WjHxX3dpGpuQ+FG4HkpHMQQ
         DOqQ==
X-Gm-Message-State: APjAAAWvgPkFfdzAe+sHy5sbrDiqieYfwaWSWjtqJzS3vhgM3yyANAOH
        MjhympVzqu5NieELbPlNy/s=
X-Google-Smtp-Source: APXvYqzfYQoaP3NA4bZsR7qsvAbWgxpl+LscpV0ejOtcKkdSptqP/w8olYN8E6jp2wro5Gwq6VhlBA==
X-Received: by 2002:a5d:66cc:: with SMTP id k12mr54094406wrw.72.1582388202107;
        Sat, 22 Feb 2020 08:16:42 -0800 (PST)
Received: from Ansuel-XPS.localdomain (host110-18-dynamic.45-213-r.retail.telecomitalia.it. [213.45.18.110])
        by smtp.googlemail.com with ESMTPSA id a198sm8906855wme.12.2020.02.22.08.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 08:16:41 -0800 (PST)
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
Subject: [PATCH v6 1/2] net: mdio: add ipq8064 mdio driver
Date:   Sat, 22 Feb 2020 17:16:26 +0100
Message-Id: <20200222161629.1862-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.0
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
index 000000000000..74d6b92a6f48
--- /dev/null
+++ b/drivers/net/phy/mdio-ipq8064.c
@@ -0,0 +1,166 @@
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
+	if (IS_ERR(priv->base) && priv->base != ERR_PTR(-EPROBE_DEFER))
+		priv->base = syscon_regmap_lookup_by_phandle(np, "master");
+
+	if (priv->base == ERR_PTR(-EPROBE_DEFER)) {
+		return -EPROBE_DEFER;
+	} else if (IS_ERR(priv->base)) {
+		dev_err(&pdev->dev, "error getting syscon regmap, error=%pe\n",
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
+MODULE_LICENSE("GPL");
-- 
2.25.0

