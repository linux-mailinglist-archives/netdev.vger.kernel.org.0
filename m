Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20AA57B921
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 07:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfGaFkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 01:40:03 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:43495 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726876AbfGaFkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 01:40:02 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2B0362D07;
        Wed, 31 Jul 2019 01:40:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 31 Jul 2019 01:40:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=from
        :to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=Qmxrx9I3s08Sg
        qNcjd0SkUJswTD2Lefpra2U+A1jdsg=; b=d0P6TbNybfGs2TavFGgrXzFBg9loY
        mfC/1olIPD5+3TzOKx5l+fa9fASoaCHU0ErAh2dtIzt3+JaitKTD//5pcE3mHMSJ
        j1H7fcFoZjSLWynwFsnfl2aTF2lPH+ZSG/OXNl4rqt5vH37SwLsykbvTNNCLMOab
        Dt5HsFJIgYRhCdCGgAMUW2s3mjeE64Ob2f22/OApahZ8XKjpcCbxsHjF0QSTtQtr
        EN6oUz6/vfdiK+Gx/W0Vzbngzi9/7SvlSv2+80/kduy6cIYBJGpcoFao/scfrm6c
        Co9gdbdYLIiQceJo1gav9vdDo5j15ivsKjO0XArrVOB1MCobYiJftOjsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Qmxrx9I3s08SgqNcjd0SkUJswTD2Lefpra2U+A1jdsg=; b=S4/imeWE
        YdcGj057oscRNYDD1p+66PfFRXHMIVqmYsZ6pODfyWN6ogv7tlwpJNHjC0k5oI4r
        mE48mqzUV9Tq4yclHHi28QN78Rq/yguFP9YM646psG8kfgiPD6tTvZeQV5DSDwwt
        SAOb2aeP118iEWivj8BttA7U9Eyigm9E6axPH13TSHPLezp/aneaIn3Scq6Uk37R
        SCTpXpAIvZvMARJgkCWXhgrbexVwnPGn2nNusLul8T9P5MJ2abzcZWYyIsVysdri
        oK2iymtRiAYGI1L1gxhOMAMhPxjEPGGsX94QZ1KvHtmvDNZ4/eJOhGx9D0hChO9x
        lleVksampVa0eA==
X-ME-Sender: <xms:sClBXRRruZqVWLsv7gNKv7rxOVsAXlyIEPqMhI0tKN4ySMXHKbHkdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleeggdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeetnhgurhgvficulfgvfhhfvghrhicuoegrnhgurhgvfiesrghj
    rdhiugdrrghuqeenucfkphepvddtvddrkedurddukedrfedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegrnhgurhgvfiesrghjrdhiugdrrghunecuvehluhhsthgvrhfuihiivgep
    td
X-ME-Proxy: <xmx:sClBXfCEuyY3OHQJOyK7ztGx7blWW5PiicojJ2QLDZfnWHT-Avt_Yw>
    <xmx:sClBXR0nMmY9xHkbVEQF5-QP72EBNn1kGXnyfpaRgvlsNg56dSIcqg>
    <xmx:sClBXdW-OdbtTC_KsOzZPxQppNW_9-cOc9rodwGgI8bPqX5arq6pBQ>
    <xmx:sSlBXVeKQG-87OLqa3MSB3NNj4vi094vtyxnzQZIyGDNZFuqlBcYaA>
Received: from mistburn.au.ibm.com (bh02i525f01.au.ibm.com [202.81.18.30])
        by mail.messagingengine.com (Postfix) with ESMTPA id E165E80059;
        Wed, 31 Jul 2019 01:39:56 -0400 (EDT)
From:   Andrew Jeffery <andrew@aj.id.au>
To:     netdev@vger.kernel.org
Cc:     Andrew Jeffery <andrew@aj.id.au>, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, joel@jms.id.au,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/4] net: phy: Add mdio-aspeed
Date:   Wed, 31 Jul 2019 15:09:57 +0930
Message-Id: <20190731053959.16293-3-andrew@aj.id.au>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190731053959.16293-1-andrew@aj.id.au>
References: <20190731053959.16293-1-andrew@aj.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AST2600 design separates the MDIO controllers from the MAC, which is
where they were placed in the AST2400 and AST2500. Further, the register
interface is reworked again, so now we have three possible different
interface implementations, however this driver only supports the
interface provided by the AST2600. The AST2400 and AST2500 will continue
to be supported by the MDIO support embedded in the FTGMAC100 driver.

The hardware supports both C22 and C45 mode, but for the moment only C22
support is implemented.

Signed-off-by: Andrew Jeffery <andrew@aj.id.au>

---
v2:
* Use readl_poll_timeout() instead of open-coded loop
* Error on C45 accesses
---
 drivers/net/phy/Kconfig       |  13 +++
 drivers/net/phy/Makefile      |   1 +
 drivers/net/phy/mdio-aspeed.c | 157 ++++++++++++++++++++++++++++++++++
 3 files changed, 171 insertions(+)
 create mode 100644 drivers/net/phy/mdio-aspeed.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 20f14c5fbb7e..206d8650ee7f 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -21,6 +21,19 @@ config MDIO_BUS
 
 if MDIO_BUS
 
+config MDIO_ASPEED
+	tristate "ASPEED MDIO bus controller"
+	depends on ARCH_ASPEED || COMPILE_TEST
+	depends on OF_MDIO && HAS_IOMEM
+	help
+	  This module provides a driver for the independent MDIO bus
+	  controllers found in the ASPEED AST2600 SoC. This is a driver for the
+	  third revision of the ASPEED MDIO register interface - the first two
+	  revisions are the "old" and "new" interfaces found in the AST2400 and
+	  AST2500, embedded in the MAC. For legacy reasons, FTGMAC100 driver
+	  continues to drive the embedded MDIO controller for the AST2400 and
+	  AST2500 SoCs, so say N if AST2600 support is not required.
+
 config MDIO_BCM_IPROC
 	tristate "Broadcom iProc MDIO bus controller"
 	depends on ARCH_BCM_IPROC || COMPILE_TEST
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 839acb292c38..ba07c27e4208 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -22,6 +22,7 @@ libphy-$(CONFIG_LED_TRIGGER_PHY)	+= phy_led_triggers.o
 obj-$(CONFIG_PHYLINK)		+= phylink.o
 obj-$(CONFIG_PHYLIB)		+= libphy.o
 
+obj-$(CONFIG_MDIO_ASPEED)	+= mdio-aspeed.o
 obj-$(CONFIG_MDIO_BCM_IPROC)	+= mdio-bcm-iproc.o
 obj-$(CONFIG_MDIO_BCM_UNIMAC)	+= mdio-bcm-unimac.o
 obj-$(CONFIG_MDIO_BITBANG)	+= mdio-bitbang.o
diff --git a/drivers/net/phy/mdio-aspeed.c b/drivers/net/phy/mdio-aspeed.c
new file mode 100644
index 000000000000..cad820568f75
--- /dev/null
+++ b/drivers/net/phy/mdio-aspeed.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Copyright (C) 2019 IBM Corp. */
+
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/iopoll.h>
+#include <linux/mdio.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_mdio.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+
+#define DRV_NAME "mdio-aspeed"
+
+#define ASPEED_MDIO_CTRL		0x0
+#define   ASPEED_MDIO_CTRL_FIRE		BIT(31)
+#define   ASPEED_MDIO_CTRL_ST		BIT(28)
+#define     ASPEED_MDIO_CTRL_ST_C45	0
+#define     ASPEED_MDIO_CTRL_ST_C22	1
+#define   ASPEED_MDIO_CTRL_OP		GENMASK(27, 26)
+#define     MDIO_C22_OP_WRITE		0b01
+#define     MDIO_C22_OP_READ		0b10
+#define   ASPEED_MDIO_CTRL_PHYAD	GENMASK(25, 21)
+#define   ASPEED_MDIO_CTRL_REGAD	GENMASK(20, 16)
+#define   ASPEED_MDIO_CTRL_MIIWDATA	GENMASK(15, 0)
+
+#define ASPEED_MDIO_DATA		0x4
+#define   ASPEED_MDIO_DATA_MDC_THRES	GENMASK(31, 24)
+#define   ASPEED_MDIO_DATA_MDIO_EDGE	BIT(23)
+#define   ASPEED_MDIO_DATA_MDIO_LATCH	GENMASK(22, 20)
+#define   ASPEED_MDIO_DATA_IDLE		BIT(16)
+#define   ASPEED_MDIO_DATA_MIIRDATA	GENMASK(15, 0)
+
+#define ASPEED_MDIO_INTERVAL_US		100
+#define ASPEED_MDIO_TIMEOUT_US		(ASPEED_MDIO_INTERVAL_US * 10)
+
+struct aspeed_mdio {
+	void __iomem *base;
+};
+
+static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
+{
+	struct aspeed_mdio *ctx = bus->priv;
+	u32 ctrl;
+	u32 data;
+	int rc;
+
+	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d\n", __func__, addr,
+		regnum);
+
+	/* Just clause 22 for the moment */
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	ctrl = ASPEED_MDIO_CTRL_FIRE
+		| FIELD_PREP(ASPEED_MDIO_CTRL_ST, ASPEED_MDIO_CTRL_ST_C22)
+		| FIELD_PREP(ASPEED_MDIO_CTRL_OP, MDIO_C22_OP_READ)
+		| FIELD_PREP(ASPEED_MDIO_CTRL_PHYAD, addr)
+		| FIELD_PREP(ASPEED_MDIO_CTRL_REGAD, regnum);
+
+	iowrite32(ctrl, ctx->base + ASPEED_MDIO_CTRL);
+
+	rc = readl_poll_timeout(ctx->base + ASPEED_MDIO_DATA, data,
+				data & ASPEED_MDIO_DATA_IDLE,
+				ASPEED_MDIO_INTERVAL_US,
+				ASPEED_MDIO_TIMEOUT_US);
+	if (rc < 0)
+		return rc;
+
+	return FIELD_GET(ASPEED_MDIO_DATA_MIIRDATA, data);
+}
+
+static int aspeed_mdio_write(struct mii_bus *bus, int addr, int regnum, u16 val)
+{
+	struct aspeed_mdio *ctx = bus->priv;
+	u32 ctrl;
+
+	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d, val: 0x%x\n",
+		__func__, addr, regnum, val);
+
+	/* Just clause 22 for the moment */
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	ctrl = ASPEED_MDIO_CTRL_FIRE
+		| FIELD_PREP(ASPEED_MDIO_CTRL_ST, ASPEED_MDIO_CTRL_ST_C22)
+		| FIELD_PREP(ASPEED_MDIO_CTRL_OP, MDIO_C22_OP_WRITE)
+		| FIELD_PREP(ASPEED_MDIO_CTRL_PHYAD, addr)
+		| FIELD_PREP(ASPEED_MDIO_CTRL_REGAD, regnum)
+		| FIELD_PREP(ASPEED_MDIO_CTRL_MIIWDATA, val);
+
+	iowrite32(ctrl, ctx->base + ASPEED_MDIO_CTRL);
+
+	return readl_poll_timeout(ctx->base + ASPEED_MDIO_CTRL, ctrl,
+				  !(ctrl & ASPEED_MDIO_CTRL_FIRE),
+				  ASPEED_MDIO_INTERVAL_US,
+				  ASPEED_MDIO_TIMEOUT_US);
+}
+
+static int aspeed_mdio_probe(struct platform_device *pdev)
+{
+	struct aspeed_mdio *ctx;
+	struct mii_bus *bus;
+	int rc;
+
+	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*ctx));
+	if (!bus)
+		return -ENOMEM;
+
+	ctx = bus->priv;
+	ctx->base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(ctx->base))
+		return PTR_ERR(ctx->base);
+
+	bus->name = DRV_NAME;
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s%d", pdev->name, pdev->id);
+	bus->parent = &pdev->dev;
+	bus->read = aspeed_mdio_read;
+	bus->write = aspeed_mdio_write;
+
+	rc = of_mdiobus_register(bus, pdev->dev.of_node);
+	if (rc) {
+		dev_err(&pdev->dev, "Cannot register MDIO bus!\n");
+		return rc;
+	}
+
+	platform_set_drvdata(pdev, bus);
+
+	return 0;
+}
+
+static int aspeed_mdio_remove(struct platform_device *pdev)
+{
+	mdiobus_unregister(platform_get_drvdata(pdev));
+
+	return 0;
+}
+
+static const struct of_device_id aspeed_mdio_of_match[] = {
+	{ .compatible = "aspeed,ast2600-mdio", },
+	{ },
+};
+
+static struct platform_driver aspeed_mdio_driver = {
+	.driver = {
+		.name = DRV_NAME,
+		.of_match_table = aspeed_mdio_of_match,
+	},
+	.probe = aspeed_mdio_probe,
+	.remove = aspeed_mdio_remove,
+};
+
+module_platform_driver(aspeed_mdio_driver);
+
+MODULE_AUTHOR("Andrew Jeffery <andrew@aj.id.au>");
+MODULE_LICENSE("GPL");
-- 
2.20.1

