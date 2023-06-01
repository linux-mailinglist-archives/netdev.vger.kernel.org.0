Return-Path: <netdev+bounces-7101-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D785B719F72
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:15:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CE061C2104A
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 14:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531EB21CE9;
	Thu,  1 Jun 2023 14:15:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4249C21063
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 14:15:12 +0000 (UTC)
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE051A7;
	Thu,  1 Jun 2023 07:15:08 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685628906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CGAXWRYvf80zHfIhDzB2tu6kKP2+wfCv2aHqFygA5hI=;
	b=FXoW95C+Tqzworwca9UAfYyxbxSAmRkvLWDCrxm8wYO9MfFoZC4O9CwRasskE3dFXlNpX6
	gF3ziMoisDW/3XRZpRu4670JSP3718amRQoR8Z3k3jiGvw17cUARrjWxG2LdLUdNCIkAgf
	8+X3BLstbgLyhPmF/JIgBepnCdUdykAo78/2dSRErGwAKJENSzpq5F2UldShtGjOftR1II
	RZ+aKqUfoqpJcAI4oCM4NdYJvRaJCTd6sWh4mWuQMP8I4qs1oZeKFRULTD8is11syPVUEa
	Sd9Z2V//BVAkPsajLtUY5g3yei7YjXQHo8r8SprtTiyFMduTFdDKVrgzMM7D4Q==
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 57CB320008;
	Thu,  1 Jun 2023 14:15:02 +0000 (UTC)
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: Mark Brown <broonie@kernel.org>,
	davem@davemloft.net
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	alexis.lothore@bootlin.com,
	thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v4 1/4] net: mdio: Introduce a regmap-based mdio driver
Date: Thu,  1 Jun 2023 16:14:51 +0200
Message-Id: <20230601141454.67858-2-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601141454.67858-1-maxime.chevallier@bootlin.com>
References: <20230601141454.67858-1-maxime.chevallier@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There exists several examples today of devices that embed an ethernet
PHY or PCS directly inside an SoC. In this situation, either the device
is controlled through a vendor-specific register set, or sometimes
exposes the standard 802.3 registers that are typically accessed over
MDIO.

As phylib and phylink are designed to use mdiodevices, this driver
allows creating a virtual MDIO bus, that translates mdiodev register
accesses to regmap accesses.

The reason we use regmap is because there are at least 3 such devices
known today, 2 of them are Altera TSE PCS's, memory-mapped, exposed
with a 4-byte stride in stmmac's dwmac-socfpga variant, and a 2-byte
stride in altera-tse. The other one (nxp,sja1110-base-tx-mdio) is
exposed over SPI.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V3->V4 :
 - Clarify the KConfig description with the need for REGMAP
 - Put the correct #include in the new header, as per Vlad's review
V2->V3 :
 - Introduce struct mdio_regmap_priv for priv elements instead of plain
   reuse of the config struct
 - Use ~O instead of ~0UL
V1->V2 :
 - Use phy_mask to avoid unnecessary scanning, suggested by Andrew
 - Allow entirely disabling scanning, suggested by Vlad

 MAINTAINERS                      |  7 +++
 drivers/net/mdio/Kconfig         | 11 ++++
 drivers/net/mdio/Makefile        |  1 +
 drivers/net/mdio/mdio-regmap.c   | 93 ++++++++++++++++++++++++++++++++
 include/linux/mdio/mdio-regmap.h | 26 +++++++++
 5 files changed, 138 insertions(+)
 create mode 100644 drivers/net/mdio/mdio-regmap.c
 create mode 100644 include/linux/mdio/mdio-regmap.h

diff --git a/MAINTAINERS b/MAINTAINERS
index c904dba1733b..f68269b39e09 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12835,6 +12835,13 @@ F:	Documentation/devicetree/bindings/net/ieee802154/mcr20a.txt
 F:	drivers/net/ieee802154/mcr20a.c
 F:	drivers/net/ieee802154/mcr20a.h
 
+MDIO REGMAP DRIVER
+M:	Maxime Chevallier <maxime.chevallier@bootlin.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/mdio/mdio-regmap.c
+F:	include/linux/mdio/mdio-regmap.h
+
 MEASUREMENT COMPUTING CIO-DAC IIO DRIVER
 M:	William Breathitt Gray <william.gray@linaro.org>
 L:	linux-iio@vger.kernel.org
diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index 9ff2e6f22f3f..4a7a303be2f7 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -185,6 +185,17 @@ config MDIO_IPQ8064
 	  This driver supports the MDIO interface found in the network
 	  interface units of the IPQ8064 SoC
 
+config MDIO_REGMAP
+	tristate
+	help
+	  This driver allows using MDIO devices that are not sitting on a
+	  regular MDIO bus, but still exposes the standard 802.3 register
+	  layout. It's regmap-based so that it can be used on integrated,
+	  memory-mapped PHYs, SPI PHYs and so on. A new virtual MDIO bus is
+	  created, and its read/write operations are mapped to the underlying
+	  regmap. Users willing to use this driver must explicitly select
+	  REGMAP.
+
 config MDIO_THUNDER
 	tristate "ThunderX SOCs MDIO buses"
 	depends on 64BIT
diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
index 7d4cb4c11e4e..1015f0db4531 100644
--- a/drivers/net/mdio/Makefile
+++ b/drivers/net/mdio/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_MDIO_MOXART)		+= mdio-moxart.o
 obj-$(CONFIG_MDIO_MSCC_MIIM)		+= mdio-mscc-miim.o
 obj-$(CONFIG_MDIO_MVUSB)		+= mdio-mvusb.o
 obj-$(CONFIG_MDIO_OCTEON)		+= mdio-octeon.o
+obj-$(CONFIG_MDIO_REGMAP)		+= mdio-regmap.o
 obj-$(CONFIG_MDIO_SUN4I)		+= mdio-sun4i.o
 obj-$(CONFIG_MDIO_THUNDER)		+= mdio-thunder.o
 obj-$(CONFIG_MDIO_XGENE)		+= mdio-xgene.o
diff --git a/drivers/net/mdio/mdio-regmap.c b/drivers/net/mdio/mdio-regmap.c
new file mode 100644
index 000000000000..8a742a8d6387
--- /dev/null
+++ b/drivers/net/mdio/mdio-regmap.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Driver for MMIO-Mapped MDIO devices. Some IPs expose internal PHYs or PCS
+ * within the MMIO-mapped area
+ *
+ * Copyright (C) 2023 Maxime Chevallier <maxime.chevallier@bootlin.com>
+ */
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/mdio.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_mdio.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/mdio/mdio-regmap.h>
+
+#define DRV_NAME "mdio-regmap"
+
+struct mdio_regmap_priv {
+	struct regmap *regmap;
+	u8 valid_addr;
+};
+
+static int mdio_regmap_read_c22(struct mii_bus *bus, int addr, int regnum)
+{
+	struct mdio_regmap_priv *ctx = bus->priv;
+	unsigned int val;
+	int ret;
+
+	if (ctx->valid_addr != addr)
+		return -ENODEV;
+
+	ret = regmap_read(ctx->regmap, regnum, &val);
+	if (ret < 0)
+		return ret;
+
+	return val;
+}
+
+static int mdio_regmap_write_c22(struct mii_bus *bus, int addr, int regnum,
+				 u16 val)
+{
+	struct mdio_regmap_priv *ctx = bus->priv;
+
+	if (ctx->valid_addr != addr)
+		return -ENODEV;
+
+	return regmap_write(ctx->regmap, regnum, val);
+}
+
+struct mii_bus *devm_mdio_regmap_register(struct device *dev,
+					  const struct mdio_regmap_config *config)
+{
+	struct mdio_regmap_priv *mr;
+	struct mii_bus *mii;
+	int rc;
+
+	if (!config->parent)
+		return ERR_PTR(-EINVAL);
+
+	mii = devm_mdiobus_alloc_size(config->parent, sizeof(*mr));
+	if (!mii)
+		return ERR_PTR(-ENOMEM);
+
+	mr = mii->priv;
+	mr->regmap = config->regmap;
+	mr->valid_addr = config->valid_addr;
+
+	mii->name = DRV_NAME;
+	strscpy(mii->id, config->name, MII_BUS_ID_SIZE);
+	mii->parent = config->parent;
+	mii->read = mdio_regmap_read_c22;
+	mii->write = mdio_regmap_write_c22;
+
+	if (config->autoscan)
+		mii->phy_mask = ~BIT(config->valid_addr);
+	else
+		mii->phy_mask = ~0;
+
+	rc = devm_mdiobus_register(dev, mii);
+	if (rc) {
+		dev_err(config->parent, "Cannot register MDIO bus![%s] (%d)\n", mii->id, rc);
+		return ERR_PTR(rc);
+	}
+
+	return mii;
+}
+EXPORT_SYMBOL_GPL(devm_mdio_regmap_register);
+
+MODULE_DESCRIPTION("MDIO API over regmap");
+MODULE_AUTHOR("Maxime Chevallier <maxime.chevallier@bootlin.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mdio/mdio-regmap.h b/include/linux/mdio/mdio-regmap.h
new file mode 100644
index 000000000000..679d9069846b
--- /dev/null
+++ b/include/linux/mdio/mdio-regmap.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Driver for MMIO-Mapped MDIO devices. Some IPs expose internal PHYs or PCS
+ * within the MMIO-mapped area
+ *
+ * Copyright (C) 2023 Maxime Chevallier <maxime.chevallier@bootlin.com>
+ */
+#ifndef MDIO_REGMAP_H
+#define MDIO_REGMAP_H
+
+#include <linux/phy.h>
+
+struct device;
+struct regmap;
+
+struct mdio_regmap_config {
+	struct device *parent;
+	struct regmap *regmap;
+	char name[MII_BUS_ID_SIZE];
+	u8 valid_addr;
+	bool autoscan;
+};
+
+struct mii_bus *devm_mdio_regmap_register(struct device *dev,
+					  const struct mdio_regmap_config *config);
+
+#endif
-- 
2.40.1


