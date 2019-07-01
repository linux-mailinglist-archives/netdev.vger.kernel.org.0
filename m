Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7AC5BFCE
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 17:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbfGAP3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 11:29:06 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39916 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGAP2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 11:28:54 -0400
Received: by mail-lf1-f68.google.com with SMTP id p24so9097725lfo.6;
        Mon, 01 Jul 2019 08:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NbwdW1fLrAEbUvXg6oj2GvQuyfmymHGsuSMweYSUJQU=;
        b=dzwPUnMu88tCEvwFwH8LSIdWy8Vg2AZweoMY4F/G1YsIXCazx5Pck7I2943/gtCOsP
         2/k6OcTcSMcKguN6SHcJw7yU1scKutGUtMSWzkS9ki3I5yxhnnk82zStDDeEBDHMsK5n
         jtaAvYoglRnOAc/YM09UvmHjc01kW75gWvozfLLTT0lnStdKWpqEJybN5XGQMUod/TQi
         hEV1zdNwFu/poctg/+j35uk3Fh8SdR0lX0Zh1etlhfT2ad7edv0chYkBRSmfdJo20nZJ
         0YnkDH5O5FknKcW1yd3Kc/d11ucrWvpaBHQjwB7uezVkAZeamDNhefeNzgHlbtVqBu+J
         jexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NbwdW1fLrAEbUvXg6oj2GvQuyfmymHGsuSMweYSUJQU=;
        b=qrdP491NzRGQ6pt5Hr7RhTS3/GKGL4W/WfyHplda5znQlSue6y4T1uwBWaKPC4911H
         mNO9OesLSclGGxXneW7wv3EBcSC49yR6mnNcRKJdIbB10BFxgnYOanuuMbM5aoG+85+O
         JCbiE7hWg/s1ZWYNLCmLck2VoUop5+Ph+OYfyAw9Kk+pYLf8xgE6SD2EY/pwKlHllJZa
         1POw6uFQnFF9reHmKHYQs11lt3wjnUt+X5mT7mZt1ESFEH1GCkVHsdaD5g/9HonQ5/tD
         f7H3X9clj97vEIKUV33FuFiWDSE8Zd0FnwARJ8rAonotmgZBscTuOTTDfNptfG7SBAP1
         Ze3g==
X-Gm-Message-State: APjAAAVYsOjoU8qsXDDmgtlNSahQBxJW3stvpY5QW1e7kZ7igADe1/37
        I7Y/Gzb8ePHSqSdRLOsHJZk=
X-Google-Smtp-Source: APXvYqyqqQly7By4+DISy2OAR20YpImCv9EdU6Oh1PekDj0aZgrjpqnSQKvs4qFRi77NKLaftKgkdw==
X-Received: by 2002:ac2:414d:: with SMTP id c13mr940577lfi.47.1561994928581;
        Mon, 01 Jul 2019 08:28:48 -0700 (PDT)
Received: from localhost.localdomain ([91.238.216.6])
        by smtp.gmail.com with ESMTPSA id e12sm2561626lfb.66.2019.07.01.08.28.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 08:28:47 -0700 (PDT)
From:   Pawel Dembicki <paweldembicki@gmail.com>
Cc:     linus.walleij@linaro.org, paweldembicki@gmail.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] net: dsa: vsc73xx: Split vsc73xx driver
Date:   Mon,  1 Jul 2019 17:27:21 +0200
Message-Id: <20190701152723.624-2-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190701152723.624-1-paweldembicki@gmail.com>
References: <20190701152723.624-1-paweldembicki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver (currently) only takes control of the switch chip over
SPI and configures it to route packages around when connected to a
CPU port. But Vitesse chip support also parallel interface.

This patch split driver into two parts: core and spi. It is required
for add support to another managing interface.

Tested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
---
 arch/arm/boot/dts/gemini-sl93512r.dts         |   2 +-
 arch/arm/boot/dts/gemini-sq201.dts            |   2 +-
 drivers/net/dsa/Kconfig                       |  11 +-
 drivers/net/dsa/Makefile                      |   3 +-
 ...tesse-vsc73xx.c => vitesse-vsc73xx-core.c} | 265 ++++--------------
 drivers/net/dsa/vitesse-vsc73xx-spi.c         | 201 +++++++++++++
 drivers/net/dsa/vitesse-vsc73xx.h             |  30 ++
 7 files changed, 297 insertions(+), 217 deletions(-)
 rename drivers/net/dsa/{vitesse-vsc73xx.c => vitesse-vsc73xx-core.c} (85%)
 create mode 100644 drivers/net/dsa/vitesse-vsc73xx-spi.c
 create mode 100644 drivers/net/dsa/vitesse-vsc73xx.h

diff --git a/arch/arm/boot/dts/gemini-sl93512r.dts b/arch/arm/boot/dts/gemini-sl93512r.dts
index 2bb953440793..87f5340387a4 100644
--- a/arch/arm/boot/dts/gemini-sl93512r.dts
+++ b/arch/arm/boot/dts/gemini-sl93512r.dts
@@ -94,7 +94,7 @@
 		num-chipselects = <1>;
 
 		switch@0 {
-			compatible = "vitesse,vsc7385";
+			compatible = "vitesse,vsc7385-spi";
 			reg = <0>;
 			/* Specified for 2.5 MHz or below */
 			spi-max-frequency = <2500000>;
diff --git a/arch/arm/boot/dts/gemini-sq201.dts b/arch/arm/boot/dts/gemini-sq201.dts
index 239dfacaae4d..4fcb20f87ba0 100644
--- a/arch/arm/boot/dts/gemini-sq201.dts
+++ b/arch/arm/boot/dts/gemini-sq201.dts
@@ -79,7 +79,7 @@
 		num-chipselects = <1>;
 
 		switch@0 {
-			compatible = "vitesse,vsc7395";
+			compatible = "vitesse,vsc7395-spi";
 			reg = <0>;
 			/* Specified for 2.5 MHz or below */
 			spi-max-frequency = <2500000>;
diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index b91e78e3598f..4ab2aa09e2e4 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -99,8 +99,8 @@ config NET_DSA_SMSC_LAN9303_MDIO
 	  for MDIO managed mode.
 
 config NET_DSA_VITESSE_VSC73XX
-	tristate "Vitesse VSC7385/7388/7395/7398 support"
-	depends on OF && SPI
+	tristate
+	depends on OF
 	depends on NET_DSA
 	select FIXED_PHY
 	select VITESSE_PHY
@@ -109,4 +109,11 @@ config NET_DSA_VITESSE_VSC73XX
 	  This enables support for the Vitesse VSC7385, VSC7388,
 	  VSC7395 and VSC7398 SparX integrated ethernet switches.
 
+config NET_DSA_VITESSE_VSC73XX_SPI
+	tristate "Vitesse VSC7385/7388/7395/7398 SPI mode support"
+	depends on SPI
+	select NET_DSA_VITESSE_VSC73XX
+	---help---
+	  This enables support for the Vitesse VSC7385, VSC7388, VSC7395
+	  and VSC7398 SparX integrated ethernet switches in SPI managed mode.
 endmenu
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index fefb6aaa82ba..117bf78be211 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -14,7 +14,8 @@ realtek-objs			:= realtek-smi.o rtl8366.o rtl8366rb.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_I2C) += lan9303_i2c.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_MDIO) += lan9303_mdio.o
-obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX) += vitesse-vsc73xx.o
+obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX) += vitesse-vsc73xx-core.o
+obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_SPI) += vitesse-vsc73xx-spi.o
 obj-y				+= b53/
 obj-y				+= microchip/
 obj-y				+= mv88e6xxx/
diff --git a/drivers/net/dsa/vitesse-vsc73xx.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
similarity index 85%
rename from drivers/net/dsa/vitesse-vsc73xx.c
rename to drivers/net/dsa/vitesse-vsc73xx-core.c
index d4780610ea8a..9975446cdc66 100644
--- a/drivers/net/dsa/vitesse-vsc73xx.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -10,10 +10,6 @@
  * handling the switch in a memory-mapped manner by connecting to that external
  * CPU's memory bus.
  *
- * This driver (currently) only takes control of the switch chip over SPI and
- * configures it to route packages around when connected to a CPU port. The
- * chip has embedded PHYs and VLAN support so we model it using DSA.
- *
  * Copyright (C) 2018 Linus Wallej <linus.walleij@linaro.org>
  * Includes portions of code from the firmware uploader by:
  * Copyright (C) 2009 Gabor Juhos <juhosg@openwrt.org>
@@ -24,8 +20,6 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_mdio.h>
-#include <linux/platform_device.h>
-#include <linux/spi/spi.h>
 #include <linux/bitops.h>
 #include <linux/if_bridge.h>
 #include <linux/etherdevice.h>
@@ -34,6 +28,8 @@
 #include <linux/random.h>
 #include <net/dsa.h>
 
+#include "vitesse-vsc73xx.h"
+
 #define VSC73XX_BLOCK_MAC	0x1 /* Subblocks 0-4, 6 (CPU port) */
 #define VSC73XX_BLOCK_ANALYZER	0x2 /* Only subblock 0 */
 #define VSC73XX_BLOCK_MII	0x3 /* Subblocks 0 and 1 */
@@ -255,13 +251,6 @@
 #define VSC73XX_GLORESET_PHY_RESET	BIT(1)
 #define VSC73XX_GLORESET_MASTER_RESET	BIT(0)
 
-#define VSC73XX_CMD_MODE_READ		0
-#define VSC73XX_CMD_MODE_WRITE		1
-#define VSC73XX_CMD_MODE_SHIFT		4
-#define VSC73XX_CMD_BLOCK_SHIFT		5
-#define VSC73XX_CMD_BLOCK_MASK		0x7
-#define VSC73XX_CMD_SUBBLOCK_MASK	0xf
-
 #define VSC7385_CLOCK_DELAY		((3 << 4) | 3)
 #define VSC7385_CLOCK_DELAY_MASK	((3 << 4) | 3)
 
@@ -274,20 +263,6 @@
 				 VSC73XX_ICPU_CTRL_CLK_EN | \
 				 VSC73XX_ICPU_CTRL_SRST)
 
-/**
- * struct vsc73xx - VSC73xx state container
- */
-struct vsc73xx {
-	struct device		*dev;
-	struct gpio_desc	*reset;
-	struct spi_device	*spi;
-	struct dsa_switch	*ds;
-	struct gpio_chip	gc;
-	u16			chipid;
-	u8			addr[ETH_ALEN];
-	struct mutex		lock; /* Protects SPI traffic */
-};
-
 #define IS_7385(a) ((a)->chipid == VSC73XX_CHIPID_ID_7385)
 #define IS_7388(a) ((a)->chipid == VSC73XX_CHIPID_ID_7388)
 #define IS_7395(a) ((a)->chipid == VSC73XX_CHIPID_ID_7395)
@@ -365,7 +340,7 @@ static const struct vsc73xx_counter vsc73xx_tx_counters[] = {
 	{ 29, "TxQoSClass3" }, /* non-standard counter */
 };
 
-static int vsc73xx_is_addr_valid(u8 block, u8 subblock)
+int vsc73xx_is_addr_valid(u8 block, u8 subblock)
 {
 	switch (block) {
 	case VSC73XX_BLOCK_MAC:
@@ -396,97 +371,7 @@ static int vsc73xx_is_addr_valid(u8 block, u8 subblock)
 
 	return 0;
 }
-
-static u8 vsc73xx_make_addr(u8 mode, u8 block, u8 subblock)
-{
-	u8 ret;
-
-	ret = (block & VSC73XX_CMD_BLOCK_MASK) << VSC73XX_CMD_BLOCK_SHIFT;
-	ret |= (mode & 1) << VSC73XX_CMD_MODE_SHIFT;
-	ret |= subblock & VSC73XX_CMD_SUBBLOCK_MASK;
-
-	return ret;
-}
-
-static int vsc73xx_read(struct vsc73xx *vsc, u8 block, u8 subblock, u8 reg,
-			u32 *val)
-{
-	struct spi_transfer t[2];
-	struct spi_message m;
-	u8 cmd[4];
-	u8 buf[4];
-	int ret;
-
-	if (!vsc73xx_is_addr_valid(block, subblock))
-		return -EINVAL;
-
-	spi_message_init(&m);
-
-	memset(&t, 0, sizeof(t));
-
-	t[0].tx_buf = cmd;
-	t[0].len = sizeof(cmd);
-	spi_message_add_tail(&t[0], &m);
-
-	t[1].rx_buf = buf;
-	t[1].len = sizeof(buf);
-	spi_message_add_tail(&t[1], &m);
-
-	cmd[0] = vsc73xx_make_addr(VSC73XX_CMD_MODE_READ, block, subblock);
-	cmd[1] = reg;
-	cmd[2] = 0;
-	cmd[3] = 0;
-
-	mutex_lock(&vsc->lock);
-	ret = spi_sync(vsc->spi, &m);
-	mutex_unlock(&vsc->lock);
-
-	if (ret)
-		return ret;
-
-	*val = (buf[0] << 24) | (buf[1] << 16) | (buf[2] << 8) | buf[3];
-
-	return 0;
-}
-
-static int vsc73xx_write(struct vsc73xx *vsc, u8 block, u8 subblock, u8 reg,
-			 u32 val)
-{
-	struct spi_transfer t[2];
-	struct spi_message m;
-	u8 cmd[2];
-	u8 buf[4];
-	int ret;
-
-	if (!vsc73xx_is_addr_valid(block, subblock))
-		return -EINVAL;
-
-	spi_message_init(&m);
-
-	memset(&t, 0, sizeof(t));
-
-	t[0].tx_buf = cmd;
-	t[0].len = sizeof(cmd);
-	spi_message_add_tail(&t[0], &m);
-
-	t[1].tx_buf = buf;
-	t[1].len = sizeof(buf);
-	spi_message_add_tail(&t[1], &m);
-
-	cmd[0] = vsc73xx_make_addr(VSC73XX_CMD_MODE_WRITE, block, subblock);
-	cmd[1] = reg;
-
-	buf[0] = (val >> 24) & 0xff;
-	buf[1] = (val >> 16) & 0xff;
-	buf[2] = (val >> 8) & 0xff;
-	buf[3] = val & 0xff;
-
-	mutex_lock(&vsc->lock);
-	ret = spi_sync(vsc->spi, &m);
-	mutex_unlock(&vsc->lock);
-
-	return ret;
-}
+EXPORT_SYMBOL(vsc73xx_is_addr_valid);
 
 static int vsc73xx_update_bits(struct vsc73xx *vsc, u8 block, u8 subblock,
 			       u8 reg, u32 mask, u32 val)
@@ -495,12 +380,12 @@ static int vsc73xx_update_bits(struct vsc73xx *vsc, u8 block, u8 subblock,
 	int ret;
 
 	/* Same read-modify-write algorithm as e.g. regmap */
-	ret = vsc73xx_read(vsc, block, subblock, reg, &orig);
+	ret = vsc->ops->read(vsc, block, subblock, reg, &orig);
 	if (ret)
 		return ret;
 	tmp = orig & ~mask;
 	tmp |= val & mask;
-	return vsc73xx_write(vsc, block, subblock, reg, tmp);
+	return vsc->ops->write(vsc, block, subblock, reg, tmp);
 }
 
 static int vsc73xx_detect(struct vsc73xx *vsc)
@@ -512,7 +397,7 @@ static int vsc73xx_detect(struct vsc73xx *vsc)
 	int ret;
 	u32 id;
 
-	ret = vsc73xx_read(vsc, VSC73XX_BLOCK_SYSTEM, 0,
+	ret = vsc->ops->read(vsc, VSC73XX_BLOCK_SYSTEM, 0,
 			   VSC73XX_ICPU_MBOX_VAL, &val);
 	if (ret) {
 		dev_err(vsc->dev, "unable to read mailbox (%d)\n", ret);
@@ -530,7 +415,7 @@ static int vsc73xx_detect(struct vsc73xx *vsc)
 		/* Wait 20ms according to datasheet table 245 */
 		msleep(20);
 
-		ret = vsc73xx_read(vsc, VSC73XX_BLOCK_SYSTEM, 0,
+		ret = vsc->ops->read(vsc, VSC73XX_BLOCK_SYSTEM, 0,
 				   VSC73XX_ICPU_MBOX_VAL, &val);
 		if (val == 0xffffffff) {
 			dev_err(vsc->dev, "seems not to help, giving up\n");
@@ -538,7 +423,7 @@ static int vsc73xx_detect(struct vsc73xx *vsc)
 		}
 	}
 
-	ret = vsc73xx_read(vsc, VSC73XX_BLOCK_SYSTEM, 0,
+	ret = vsc->ops->read(vsc, VSC73XX_BLOCK_SYSTEM, 0,
 			   VSC73XX_CHIPID, &val);
 	if (ret) {
 		dev_err(vsc->dev, "unable to read chip id (%d)\n", ret);
@@ -563,7 +448,7 @@ static int vsc73xx_detect(struct vsc73xx *vsc)
 		VSC73XX_CHIPID_REV_MASK;
 	dev_info(vsc->dev, "VSC%04X (rev: %d) switch found\n", id, rev);
 
-	ret = vsc73xx_read(vsc, VSC73XX_BLOCK_SYSTEM, 0,
+	ret = vsc->ops->read(vsc, VSC73XX_BLOCK_SYSTEM, 0,
 			   VSC73XX_ICPU_CTRL, &val);
 	if (ret) {
 		dev_err(vsc->dev, "unable to read iCPU control\n");
@@ -611,11 +496,11 @@ static int vsc73xx_phy_read(struct dsa_switch *ds, int phy, int regnum)
 
 	/* Setting bit 26 means "read" */
 	cmd = BIT(26) | (phy << 21) | (regnum << 16);
-	ret = vsc73xx_write(vsc, VSC73XX_BLOCK_MII, 0, 1, cmd);
+	ret = vsc->ops->write(vsc, VSC73XX_BLOCK_MII, 0, 1, cmd);
 	if (ret)
 		return ret;
 	msleep(2);
-	ret = vsc73xx_read(vsc, VSC73XX_BLOCK_MII, 0, 2, &val);
+	ret = vsc->ops->read(vsc, VSC73XX_BLOCK_MII, 0, 2, &val);
 	if (ret)
 		return ret;
 	if (val & BIT(16)) {
@@ -650,7 +535,7 @@ static int vsc73xx_phy_write(struct dsa_switch *ds, int phy, int regnum,
 	}
 
 	cmd = (phy << 21) | (regnum << 16);
-	ret = vsc73xx_write(vsc, VSC73XX_BLOCK_MII, 0, 1, cmd);
+	ret = vsc->ops->write(vsc, VSC73XX_BLOCK_MII, 0, 1, cmd);
 	if (ret)
 		return ret;
 
@@ -682,7 +567,7 @@ static int vsc73xx_setup(struct dsa_switch *ds)
 	dev_info(vsc->dev, "set up the switch\n");
 
 	/* Issue RESET */
-	vsc73xx_write(vsc, VSC73XX_BLOCK_SYSTEM, 0, VSC73XX_GLORESET,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_SYSTEM, 0, VSC73XX_GLORESET,
 		      VSC73XX_GLORESET_MASTER_RESET);
 	usleep_range(125, 200);
 
@@ -695,7 +580,7 @@ static int vsc73xx_setup(struct dsa_switch *ds)
 	 */
 	for (i = 0; i <= 15; i++) {
 		if (i != 6 && i != 7) {
-			vsc73xx_write(vsc, VSC73XX_BLOCK_MEMINIT,
+			vsc->ops->write(vsc, VSC73XX_BLOCK_MEMINIT,
 				      2,
 				      0, 0x1010400 + i);
 			mdelay(1);
@@ -704,12 +589,12 @@ static int vsc73xx_setup(struct dsa_switch *ds)
 	mdelay(30);
 
 	/* Clear MAC table */
-	vsc73xx_write(vsc, VSC73XX_BLOCK_ANALYZER, 0,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_ANALYZER, 0,
 		      VSC73XX_MACACCESS,
 		      VSC73XX_MACACCESS_CMD_CLEAR_TABLE);
 
 	/* Clear VLAN table */
-	vsc73xx_write(vsc, VSC73XX_BLOCK_ANALYZER, 0,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_ANALYZER, 0,
 		      VSC73XX_VLANACCESS,
 		      VSC73XX_VLANACCESS_VLAN_TBL_CMD_CLEAR_TABLE);
 
@@ -721,7 +606,7 @@ static int vsc73xx_setup(struct dsa_switch *ds)
 	 * Port "31" is "all ports".
 	 */
 	if (IS_739X(vsc))
-		vsc73xx_write(vsc, VSC73XX_BLOCK_MAC, 0x1f,
+		vsc->ops->write(vsc, VSC73XX_BLOCK_MAC, 0x1f,
 			      VSC73XX_Q_MISC_CONF,
 			      VSC73XX_Q_MISC_CONF_EXTENT_MEM);
 
@@ -729,25 +614,25 @@ static int vsc73xx_setup(struct dsa_switch *ds)
 	for (i = 0; i < 7; i++) {
 		if (i == 5)
 			continue;
-		vsc73xx_write(vsc, VSC73XX_BLOCK_MAC, 4,
+		vsc->ops->write(vsc, VSC73XX_BLOCK_MAC, 4,
 			      VSC73XX_MAC_CFG, VSC73XX_MAC_CFG_RESET);
 	}
 
 	/* MII delay, set both GTX and RX delay to 2 ns */
-	vsc73xx_write(vsc, VSC73XX_BLOCK_SYSTEM, 0, VSC73XX_GMIIDELAY,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_SYSTEM, 0, VSC73XX_GMIIDELAY,
 		      VSC73XX_GMIIDELAY_GMII0_GTXDELAY_2_0_NS |
 		      VSC73XX_GMIIDELAY_GMII0_RXDELAY_2_0_NS);
 	/* Enable reception of frames on all ports */
-	vsc73xx_write(vsc, VSC73XX_BLOCK_ANALYZER, 0, VSC73XX_RECVMASK,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_ANALYZER, 0, VSC73XX_RECVMASK,
 		      0x5f);
 	/* IP multicast flood mask (table 144) */
-	vsc73xx_write(vsc, VSC73XX_BLOCK_ANALYZER, 0, VSC73XX_IFLODMSK,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_ANALYZER, 0, VSC73XX_IFLODMSK,
 		      0xff);
 
 	mdelay(50);
 
 	/* Release reset from the internal PHYs */
-	vsc73xx_write(vsc, VSC73XX_BLOCK_SYSTEM, 0, VSC73XX_GLORESET,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_SYSTEM, 0, VSC73XX_GLORESET,
 		      VSC73XX_GLORESET_PHY_RESET);
 
 	udelay(4);
@@ -760,7 +645,7 @@ static void vsc73xx_init_port(struct vsc73xx *vsc, int port)
 	u32 val;
 
 	/* MAC configure, first reset the port and then write defaults */
-	vsc73xx_write(vsc, VSC73XX_BLOCK_MAC,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_MAC,
 		      port,
 		      VSC73XX_MAC_CFG,
 		      VSC73XX_MAC_CFG_RESET);
@@ -774,7 +659,7 @@ static void vsc73xx_init_port(struct vsc73xx *vsc, int port)
 	else
 		val = VSC73XX_MAC_CFG_1000M_F_PHY;
 
-	vsc73xx_write(vsc, VSC73XX_BLOCK_MAC,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_MAC,
 		      port,
 		      VSC73XX_MAC_CFG,
 		      val |
@@ -787,7 +672,7 @@ static void vsc73xx_init_port(struct vsc73xx *vsc, int port)
 	 * frames, so just enable it. It is clear from the application note
 	 * that "9.6 kilobytes" == 9600 bytes.
 	 */
-	vsc73xx_write(vsc, VSC73XX_BLOCK_MAC,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_MAC,
 		      port,
 		      VSC73XX_MAXLEN, 9600);
 
@@ -795,7 +680,7 @@ static void vsc73xx_init_port(struct vsc73xx *vsc, int port)
 	 * Use a zero delay pause frame when pause condition is left
 	 * Obey pause control frames
 	 */
-	vsc73xx_write(vsc, VSC73XX_BLOCK_MAC,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_MAC,
 		      port,
 		      VSC73XX_FCCONF,
 		      VSC73XX_FCCONF_ZERO_PAUSE_EN |
@@ -811,19 +696,19 @@ static void vsc73xx_init_port(struct vsc73xx *vsc, int port)
 	else
 		val = VSC73XX_Q_MISC_CONF_MAC_PAUSE_MODE;
 	val |= VSC73XX_Q_MISC_CONF_EXTENT_MEM;
-	vsc73xx_write(vsc, VSC73XX_BLOCK_MAC,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_MAC,
 		      port,
 		      VSC73XX_Q_MISC_CONF,
 		      val);
 
 	/* Flow control MAC: a MAC address used in flow control frames */
 	val = (vsc->addr[5] << 16) | (vsc->addr[4] << 8) | (vsc->addr[3]);
-	vsc73xx_write(vsc, VSC73XX_BLOCK_MAC,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_MAC,
 		      port,
 		      VSC73XX_FCMACHI,
 		      val);
 	val = (vsc->addr[2] << 16) | (vsc->addr[1] << 8) | (vsc->addr[0]);
-	vsc73xx_write(vsc, VSC73XX_BLOCK_MAC,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_MAC,
 		      port,
 		      VSC73XX_FCMACLO,
 		      val);
@@ -831,13 +716,13 @@ static void vsc73xx_init_port(struct vsc73xx *vsc, int port)
 	/* Tell the categorizer to forward pause frames, not control
 	 * frame. Do not drop anything.
 	 */
-	vsc73xx_write(vsc, VSC73XX_BLOCK_MAC,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_MAC,
 		      port,
 		      VSC73XX_CAT_DROP,
 		      VSC73XX_CAT_DROP_FWD_PAUSE_ENA);
 
 	/* Clear all counters */
-	vsc73xx_write(vsc, VSC73XX_BLOCK_MAC,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_MAC,
 		      port, VSC73XX_C_RX0, 0);
 }
 
@@ -850,21 +735,21 @@ static void vsc73xx_adjust_enable_port(struct vsc73xx *vsc,
 
 	/* Reset this port FIXME: break out subroutine */
 	val |= VSC73XX_MAC_CFG_RESET;
-	vsc73xx_write(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_MAC_CFG, val);
+	vsc->ops->write(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_MAC_CFG, val);
 
 	/* Seed the port randomness with randomness */
 	get_random_bytes(&seed, 1);
 	val |= seed << VSC73XX_MAC_CFG_SEED_OFFSET;
 	val |= VSC73XX_MAC_CFG_SEED_LOAD;
 	val |= VSC73XX_MAC_CFG_WEXC_DIS;
-	vsc73xx_write(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_MAC_CFG, val);
+	vsc->ops->write(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_MAC_CFG, val);
 
 	/* Flow control for the PHY facing ports:
 	 * Use a zero delay pause frame when pause condition is left
 	 * Obey pause control frames
 	 * When generating pause frames, use 0xff as pause value
 	 */
-	vsc73xx_write(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_FCCONF,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_FCCONF,
 		      VSC73XX_FCCONF_ZERO_PAUSE_EN |
 		      VSC73XX_FCCONF_FLOW_CTRL_OBEY |
 		      0xff);
@@ -895,7 +780,7 @@ static void vsc73xx_adjust_link(struct dsa_switch *ds, int port,
 		 * Enable the GMII GTX external clock
 		 * Use double data rate (DDR mode)
 		 */
-		vsc73xx_write(vsc, VSC73XX_BLOCK_MAC,
+		vsc->ops->write(vsc, VSC73XX_BLOCK_MAC,
 			      CPU_PORT,
 			      VSC73XX_ADVPORTM,
 			      VSC73XX_ADVPORTM_EXT_PORT |
@@ -922,11 +807,11 @@ static void vsc73xx_adjust_link(struct dsa_switch *ds, int port,
 				    VSC73XX_ARBDISC, BIT(port), BIT(port));
 
 		/* Wait until queue is empty */
-		vsc73xx_read(vsc, VSC73XX_BLOCK_ARBITER, 0,
+		vsc->ops->read(vsc, VSC73XX_BLOCK_ARBITER, 0,
 			     VSC73XX_ARBEMPTY, &val);
 		while (!(val & BIT(port))) {
 			msleep(1);
-			vsc73xx_read(vsc, VSC73XX_BLOCK_ARBITER, 0,
+			vsc->ops->read(vsc, VSC73XX_BLOCK_ARBITER, 0,
 				     VSC73XX_ARBEMPTY, &val);
 			if (--maxloop == 0) {
 				dev_err(vsc->dev,
@@ -937,7 +822,7 @@ static void vsc73xx_adjust_link(struct dsa_switch *ds, int port,
 		}
 
 		/* Put this port into reset */
-		vsc73xx_write(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_MAC_CFG,
+		vsc->ops->write(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_MAC_CFG,
 			      VSC73XX_MAC_CFG_RESET);
 
 		/* Accept packets again */
@@ -1018,7 +903,7 @@ static void vsc73xx_port_disable(struct dsa_switch *ds, int port)
 	struct vsc73xx *vsc = ds->priv;
 
 	/* Just put the port into reset */
-	vsc73xx_write(vsc, VSC73XX_BLOCK_MAC, port,
+	vsc->ops->write(vsc, VSC73XX_BLOCK_MAC, port,
 		      VSC73XX_MAC_CFG, VSC73XX_MAC_CFG_RESET);
 }
 
@@ -1063,7 +948,7 @@ static void vsc73xx_get_strings(struct dsa_switch *ds, int port, u32 stringset,
 	if (stringset != ETH_SS_STATS)
 		return;
 
-	ret = vsc73xx_read(vsc, VSC73XX_BLOCK_MAC, port,
+	ret = vsc->ops->read(vsc, VSC73XX_BLOCK_MAC, port,
 			   VSC73XX_C_CFG, &val);
 	if (ret)
 		return;
@@ -1137,7 +1022,7 @@ static void vsc73xx_get_ethtool_stats(struct dsa_switch *ds, int port,
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++) {
-		ret = vsc73xx_read(vsc, VSC73XX_BLOCK_MAC, port,
+		ret = vsc->ops->read(vsc, VSC73XX_BLOCK_MAC, port,
 				   regs[i], &val);
 		if (ret) {
 			dev_err(vsc->dev, "error reading counter %d\n", i);
@@ -1166,7 +1051,7 @@ static int vsc73xx_gpio_get(struct gpio_chip *chip, unsigned int offset)
 	u32 val;
 	int ret;
 
-	ret = vsc73xx_read(vsc, VSC73XX_BLOCK_SYSTEM, 0,
+	ret = vsc->ops->read(vsc, VSC73XX_BLOCK_SYSTEM, 0,
 			   VSC73XX_GPIO, &val);
 	if (ret)
 		return ret;
@@ -1212,7 +1097,7 @@ static int vsc73xx_gpio_get_direction(struct gpio_chip *chip,
 	u32 val;
 	int ret;
 
-	ret = vsc73xx_read(vsc, VSC73XX_BLOCK_SYSTEM, 0,
+	ret = vsc->ops->read(vsc, VSC73XX_BLOCK_SYSTEM, 0,
 			   VSC73XX_GPIO, &val);
 	if (ret)
 		return ret;
@@ -1245,42 +1130,25 @@ static int vsc73xx_gpio_probe(struct vsc73xx *vsc)
 	return 0;
 }
 
-static int vsc73xx_probe(struct spi_device *spi)
+int vsc73xx_probe(struct vsc73xx *vsc)
 {
-	struct device *dev = &spi->dev;
-	struct vsc73xx *vsc;
 	int ret;
 
-	vsc = devm_kzalloc(dev, sizeof(*vsc), GFP_KERNEL);
-	if (!vsc)
-		return -ENOMEM;
-
-	spi_set_drvdata(spi, vsc);
-	vsc->spi = spi_dev_get(spi);
-	vsc->dev = dev;
 	mutex_init(&vsc->lock);
 
 	/* Release reset, if any */
-	vsc->reset = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);
+	vsc->reset = devm_gpiod_get_optional(vsc->dev, "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(vsc->reset)) {
-		dev_err(dev, "failed to get RESET GPIO\n");
+		dev_err(vsc->dev, "failed to get RESET GPIO\n");
 		return PTR_ERR(vsc->reset);
 	}
 	if (vsc->reset)
 		/* Wait 20ms according to datasheet table 245 */
 		msleep(20);
 
-	spi->mode = SPI_MODE_0;
-	spi->bits_per_word = 8;
-	ret = spi_setup(spi);
-	if (ret < 0) {
-		dev_err(dev, "spi setup failed.\n");
-		return ret;
-	}
-
 	ret = vsc73xx_detect(vsc);
 	if (ret) {
-		dev_err(dev, "no chip found (%d)\n", ret);
+		dev_err(vsc->dev, "no chip found (%d)\n", ret);
 		return -ENODEV;
 	}
 
@@ -1301,7 +1169,7 @@ static int vsc73xx_probe(struct spi_device *spi)
 	 * We allocate 8 ports and avoid access to the nonexistant
 	 * ports.
 	 */
-	vsc->ds = dsa_switch_alloc(dev, 8);
+	vsc->ds = dsa_switch_alloc(vsc->dev, 8);
 	if (!vsc->ds)
 		return -ENOMEM;
 	vsc->ds->priv = vsc;
@@ -1309,7 +1177,7 @@ static int vsc73xx_probe(struct spi_device *spi)
 	vsc->ds->ops = &vsc73xx_ds_ops;
 	ret = dsa_register_switch(vsc->ds);
 	if (ret) {
-		dev_err(dev, "unable to register switch (%d)\n", ret);
+		dev_err(vsc->dev, "unable to register switch (%d)\n", ret);
 		return ret;
 	}
 
@@ -1321,43 +1189,16 @@ static int vsc73xx_probe(struct spi_device *spi)
 
 	return 0;
 }
+EXPORT_SYMBOL(vsc73xx_probe);
 
-static int vsc73xx_remove(struct spi_device *spi)
+int vsc73xx_remove(struct vsc73xx *vsc)
 {
-	struct vsc73xx *vsc = spi_get_drvdata(spi);
-
 	dsa_unregister_switch(vsc->ds);
 	gpiod_set_value(vsc->reset, 1);
 
 	return 0;
 }
-
-static const struct of_device_id vsc73xx_of_match[] = {
-	{
-		.compatible = "vitesse,vsc7385",
-	},
-	{
-		.compatible = "vitesse,vsc7388",
-	},
-	{
-		.compatible = "vitesse,vsc7395",
-	},
-	{
-		.compatible = "vitesse,vsc7398",
-	},
-	{ },
-};
-MODULE_DEVICE_TABLE(of, vsc73xx_of_match);
-
-static struct spi_driver vsc73xx_driver = {
-	.probe = vsc73xx_probe,
-	.remove = vsc73xx_remove,
-	.driver = {
-		.name = "vsc73xx",
-		.of_match_table = vsc73xx_of_match,
-	},
-};
-module_spi_driver(vsc73xx_driver);
+EXPORT_SYMBOL(vsc73xx_remove);
 
 MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
 MODULE_DESCRIPTION("Vitesse VSC7385/7388/7395/7398 driver");
diff --git a/drivers/net/dsa/vitesse-vsc73xx-spi.c b/drivers/net/dsa/vitesse-vsc73xx-spi.c
new file mode 100644
index 000000000000..dab8c0e69cf9
--- /dev/null
+++ b/drivers/net/dsa/vitesse-vsc73xx-spi.c
@@ -0,0 +1,201 @@
+// SPDX-License-Identifier: GPL-2.0
+/* DSA driver for:
+ * Vitesse VSC7385 SparX-G5 5+1-port Integrated Gigabit Ethernet Switch
+ * Vitesse VSC7388 SparX-G8 8-port Integrated Gigabit Ethernet Switch
+ * Vitesse VSC7395 SparX-G5e 5+1-port Integrated Gigabit Ethernet Switch
+ * Vitesse VSC7398 SparX-G8e 8-port Integrated Gigabit Ethernet Switch
+ *
+ * This driver takes control of the switch chip over SPI and
+ * configures it to route packages around when connected to a CPU port.
+ *
+ * Copyright (C) 2018 Linus Wallej <linus.walleij@linaro.org>
+ * Includes portions of code from the firmware uploader by:
+ * Copyright (C) 2009 Gabor Juhos <juhosg@openwrt.org>
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/spi/spi.h>
+
+#include "vitesse-vsc73xx.h"
+
+#define VSC73XX_CMD_SPI_MODE_READ		0
+#define VSC73XX_CMD_SPI_MODE_WRITE		1
+#define VSC73XX_CMD_SPI_MODE_SHIFT		4
+#define VSC73XX_CMD_SPI_BLOCK_SHIFT		5
+#define VSC73XX_CMD_SPI_BLOCK_MASK		0x7
+#define VSC73XX_CMD_SPI_SUBBLOCK_MASK	0xf
+
+/**
+ * struct vsc73xx_spi - VSC73xx SPI state container
+ */
+struct vsc73xx_spi {
+	struct spi_device	*spi;
+	struct vsc73xx vsc;
+};
+
+static const struct vsc73xx_ops vsc73xx_spi_ops;
+
+static u8 vsc73xx_make_addr(u8 mode, u8 block, u8 subblock)
+{
+	u8 ret;
+
+	ret = (block & VSC73XX_CMD_SPI_BLOCK_MASK)
+					<< VSC73XX_CMD_SPI_BLOCK_SHIFT;
+	ret |= (mode & 1) << VSC73XX_CMD_SPI_MODE_SHIFT;
+	ret |= subblock & VSC73XX_CMD_SPI_SUBBLOCK_MASK;
+
+	return ret;
+}
+
+static int vsc73xx_spi_read(struct vsc73xx *vsc, u8 block, u8 subblock, u8 reg,
+			    u32 *val)
+{
+	struct vsc73xx_spi *vsc_spi = vsc->priv;
+	struct spi_transfer t[2];
+	struct spi_message m;
+	u8 cmd[4];
+	u8 buf[4];
+	int ret;
+
+	if (!vsc73xx_is_addr_valid(block, subblock))
+		return -EINVAL;
+
+	spi_message_init(&m);
+
+	memset(&t, 0, sizeof(t));
+
+	t[0].tx_buf = cmd;
+	t[0].len = sizeof(cmd);
+	spi_message_add_tail(&t[0], &m);
+
+	t[1].rx_buf = buf;
+	t[1].len = sizeof(buf);
+	spi_message_add_tail(&t[1], &m);
+
+	cmd[0] = vsc73xx_make_addr(VSC73XX_CMD_SPI_MODE_READ, block, subblock);
+	cmd[1] = reg;
+	cmd[2] = 0;
+	cmd[3] = 0;
+
+	mutex_lock(&vsc->lock);
+	ret = spi_sync(vsc_spi->spi, &m);
+	mutex_unlock(&vsc->lock);
+
+	if (ret)
+		return ret;
+
+	*val = (buf[0] << 24) | (buf[1] << 16) | (buf[2] << 8) | buf[3];
+
+	return 0;
+}
+
+static int vsc73xx_spi_write(struct vsc73xx *vsc, u8 block, u8 subblock, u8 reg,
+			     u32 val)
+{
+	struct vsc73xx_spi *vsc_spi = vsc->priv;
+	struct spi_transfer t[2];
+	struct spi_message m;
+	u8 cmd[2];
+	u8 buf[4];
+	int ret;
+
+	if (!vsc73xx_is_addr_valid(block, subblock))
+		return -EINVAL;
+
+	spi_message_init(&m);
+
+	memset(&t, 0, sizeof(t));
+
+	t[0].tx_buf = cmd;
+	t[0].len = sizeof(cmd);
+	spi_message_add_tail(&t[0], &m);
+
+	t[1].tx_buf = buf;
+	t[1].len = sizeof(buf);
+	spi_message_add_tail(&t[1], &m);
+
+	cmd[0] = vsc73xx_make_addr(VSC73XX_CMD_SPI_MODE_WRITE, block, subblock);
+	cmd[1] = reg;
+
+	buf[0] = (val >> 24) & 0xff;
+	buf[1] = (val >> 16) & 0xff;
+	buf[2] = (val >> 8) & 0xff;
+	buf[3] = val & 0xff;
+
+	mutex_lock(&vsc->lock);
+	ret = spi_sync(vsc_spi->spi, &m);
+	mutex_unlock(&vsc->lock);
+
+	return ret;
+}
+
+static int vsc73xx_spi_probe(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct vsc73xx_spi *vsc_spi;
+	int ret;
+
+	vsc_spi = devm_kzalloc(dev, sizeof(*vsc_spi), GFP_KERNEL);
+	if (!vsc_spi)
+		return -ENOMEM;
+
+	spi_set_drvdata(spi, vsc_spi);
+	vsc_spi->spi = spi_dev_get(spi);
+	vsc_spi->vsc.dev = dev;
+	vsc_spi->vsc.priv = vsc_spi;
+	vsc_spi->vsc.ops = &vsc73xx_spi_ops;
+
+	spi->mode = SPI_MODE_0;
+	spi->bits_per_word = 8;
+	ret = spi_setup(spi);
+	if (ret < 0) {
+		dev_err(dev, "spi setup failed.\n");
+		return ret;
+	}
+
+	return vsc73xx_probe(&vsc_spi->vsc);
+}
+
+static int vsc73xx_spi_remove(struct spi_device *spi)
+{
+	struct vsc73xx_spi *vsc_spi = spi_get_drvdata(spi);
+
+	return vsc73xx_remove(&vsc_spi->vsc);
+}
+
+static const struct vsc73xx_ops vsc73xx_spi_ops = {
+	.read = vsc73xx_spi_read,
+	.write = vsc73xx_spi_write,
+};
+
+static const struct of_device_id vsc73xx_spi_of_match[] = {
+	{
+		.compatible = "vitesse,vsc7385-spi",
+	},
+	{
+		.compatible = "vitesse,vsc7388-spi",
+	},
+	{
+		.compatible = "vitesse,vsc7395-spi",
+	},
+	{
+		.compatible = "vitesse,vsc7398-spi",
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, vsc73xx_spi_of_match);
+
+static struct spi_driver vsc73xx_spi_driver = {
+	.probe = vsc73xx_spi_probe,
+	.remove = vsc73xx_spi_remove,
+	.driver = {
+		.name = "vsc73xx-spi",
+		.of_match_table = vsc73xx_spi_of_match,
+	},
+};
+module_spi_driver(vsc73xx_spi_driver);
+
+MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
+MODULE_DESCRIPTION("Vitesse VSC7385/7388/7395/7398 SPI driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/vitesse-vsc73xx.h b/drivers/net/dsa/vitesse-vsc73xx.h
new file mode 100644
index 000000000000..a0e2e5b8f0ce
--- /dev/null
+++ b/drivers/net/dsa/vitesse-vsc73xx.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/device.h>
+#include <linux/etherdevice.h>
+#include <linux/gpio/driver.h>
+
+/**
+ * struct vsc73xx - VSC73xx state container
+ */
+struct vsc73xx {
+	struct device		*dev;
+	struct gpio_desc	*reset;
+	struct dsa_switch	*ds;
+	struct gpio_chip	gc;
+	u16			chipid;
+	u8			addr[ETH_ALEN];
+	struct mutex		lock; /* Protects SPI traffic */
+	const struct vsc73xx_ops *ops;
+	void *priv;
+};
+
+struct vsc73xx_ops {
+	int (*read)(struct vsc73xx *vsc, u8 block, u8 subblock, u8 reg,
+		    u32 *val);
+	int (*write)(struct vsc73xx *vsc, u8 block, u8 subblock, u8 reg,
+		     u32 val);
+};
+
+int vsc73xx_is_addr_valid(u8 block, u8 subblock);
+int vsc73xx_probe(struct vsc73xx *vsc);
+int vsc73xx_remove(struct vsc73xx *vsc);
-- 
2.20.1

