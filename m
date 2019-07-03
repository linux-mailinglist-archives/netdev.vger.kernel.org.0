Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 914845EA4D
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 19:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfGCRVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 13:21:25 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44946 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGCRVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 13:21:25 -0400
Received: by mail-lj1-f194.google.com with SMTP id k18so3281434ljc.11;
        Wed, 03 Jul 2019 10:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K93pzmrfuevZjCSrr23fytUGVAdL97IMRxsTpk1D0Z0=;
        b=KQxWkQd1b3wyYkJwe2VQetMZmZKhzIb/fn7WZOjOJFO8wLbgODnauMlpKhmpnepb37
         hIAuEHdI52G0qFsrBWjWbHlGegY2vlShFt0mifecp87BHMA+UUM234GnP3/9ZjZhIHY5
         ssMA9EyfGJToq6WB0Z2rqaJSb+YtXa4ME7P5mdDUQBw2dIceiWDZPFjW7YgYCQIElttU
         oBhlZqhadTERQ9eBX8a/hq00fBcl8MrKyzUYEm7vgoyu/Lx+flL6T43ebLcJPGZes2Z1
         pxTxEB+GIpVYuh5KJVRq6bXSlZK5EBQvPF5o4yk0GAh2zKf6h6YV/6kpaRW3MT/Ew3Jw
         S7SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K93pzmrfuevZjCSrr23fytUGVAdL97IMRxsTpk1D0Z0=;
        b=Falc1dGTIklx1he7Ao0eUU5DKxVDiGDUssttogu/v+o/QYmZBzRGWwFZ7MP5aX0OfH
         pBEIllCSu0tHFq/5L9kfCarXfD3lGAS06aKeY5trvFS8q8PHqHXDkTKgA9zZvlSCXon3
         gCdZs2T1xeT8Kg8hDpOa9OTuF0FpYpmyWtNQeh0b25grZayhoz5CoOWWbL3aBI5SsUej
         zdX41XMtgmyUYi6J0wZSc5SRxx2y0SrUunGZev4RpoD21BD90Qbq2cHKowWeo+56lFep
         wDq+lRt1DEescMXKgmRcyQJdZJEnchcOn4RH27rpvsNx/dO9Bq5x289Rt9YqPCKQKQqJ
         wpUg==
X-Gm-Message-State: APjAAAXjH0SRkU0SPRgzBhDEo78e476Ch9RY7t91vbXzqaFXu3JyueWK
        x51OvOPt6f1zwAZd/vv57iiNMQ31kmQ=
X-Google-Smtp-Source: APXvYqy5yN3pSMo06XuL+8Hcs9UcTvvViKwAn95XbLnw+KZ32TcaSvrz3z73RX21TNtuDSQ8DT//tA==
X-Received: by 2002:a2e:8ecb:: with SMTP id e11mr21908964ljl.218.1562174482057;
        Wed, 03 Jul 2019 10:21:22 -0700 (PDT)
Received: from krolik-desktop.lan ([91.238.216.6])
        by smtp.gmail.com with ESMTPSA id 11sm581165ljc.66.2019.07.03.10.21.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 10:21:21 -0700 (PDT)
From:   Pawel Dembicki <paweldembicki@gmail.com>
Cc:     Pawel Dembicki <paweldembicki@gmail.com>, linus.walleij@linaro.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] net: dsa: vsc73xx: Split vsc73xx driver
Date:   Wed,  3 Jul 2019 19:19:22 +0200
Message-Id: <20190703171924.31801-3-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703171924.31801-1-paweldembicki@gmail.com>
References: <20190703171924.31801-1-paweldembicki@gmail.com>
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
 drivers/net/dsa/Kconfig                       |  11 +-
 drivers/net/dsa/Makefile                      |   3 +-
 ...tesse-vsc73xx.c => vitesse-vsc73xx-core.c} | 170 +--------------
 drivers/net/dsa/vitesse-vsc73xx-spi.c         | 203 ++++++++++++++++++
 drivers/net/dsa/vitesse-vsc73xx.h             |  29 +++
 5 files changed, 254 insertions(+), 162 deletions(-)
 rename drivers/net/dsa/{vitesse-vsc73xx.c => vitesse-vsc73xx-core.c} (91%)
 create mode 100644 drivers/net/dsa/vitesse-vsc73xx-spi.c
 create mode 100644 drivers/net/dsa/vitesse-vsc73xx.h

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
similarity index 91%
rename from drivers/net/dsa/vitesse-vsc73xx.c
rename to drivers/net/dsa/vitesse-vsc73xx-core.c
index d4780610ea8a..10063f31d9a3 100644
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
@@ -396,96 +371,18 @@ static int vsc73xx_is_addr_valid(u8 block, u8 subblock)
 
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
+EXPORT_SYMBOL(vsc73xx_is_addr_valid);
 
 static int vsc73xx_read(struct vsc73xx *vsc, u8 block, u8 subblock, u8 reg,
 			u32 *val)
 {
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
+	return vsc->ops->read(vsc, block, subblock, reg, val);
 }
 
 static int vsc73xx_write(struct vsc73xx *vsc, u8 block, u8 subblock, u8 reg,
 			 u32 val)
 {
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
+	return vsc->ops->write(vsc, block, subblock, reg, val);
 }
 
 static int vsc73xx_update_bits(struct vsc73xx *vsc, u8 block, u8 subblock,
@@ -1245,21 +1142,11 @@ static int vsc73xx_gpio_probe(struct vsc73xx *vsc)
 	return 0;
 }
 
-static int vsc73xx_probe(struct spi_device *spi)
+int vsc73xx_probe(struct vsc73xx *vsc)
 {
-	struct device *dev = &spi->dev;
-	struct vsc73xx *vsc;
+	struct device *dev = vsc->dev;
 	int ret;
 
-	vsc = devm_kzalloc(dev, sizeof(*vsc), GFP_KERNEL);
-	if (!vsc)
-		return -ENOMEM;
-
-	spi_set_drvdata(spi, vsc);
-	vsc->spi = spi_dev_get(spi);
-	vsc->dev = dev;
-	mutex_init(&vsc->lock);
-
 	/* Release reset, if any */
 	vsc->reset = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(vsc->reset)) {
@@ -1270,14 +1157,6 @@ static int vsc73xx_probe(struct spi_device *spi)
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
 		dev_err(dev, "no chip found (%d)\n", ret);
@@ -1321,43 +1200,16 @@ static int vsc73xx_probe(struct spi_device *spi)
 
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
index 000000000000..e73c8fcddc9f
--- /dev/null
+++ b/drivers/net/dsa/vitesse-vsc73xx-spi.c
@@ -0,0 +1,203 @@
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
+#define VSC73XX_CMD_SPI_SUBBLOCK_MASK		0xf
+
+/**
+ * struct vsc73xx_spi - VSC73xx SPI state container
+ */
+struct vsc73xx_spi {
+	struct spi_device	*spi;
+	struct mutex		lock; /* Protects SPI traffic */
+	struct vsc73xx		vsc;
+};
+
+static const struct vsc73xx_ops vsc73xx_spi_ops;
+
+static u8 vsc73xx_make_addr(u8 mode, u8 block, u8 subblock)
+{
+	u8 ret;
+
+	ret =
+	    (block & VSC73XX_CMD_SPI_BLOCK_MASK) << VSC73XX_CMD_SPI_BLOCK_SHIFT;
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
+	mutex_lock(&vsc_spi->lock);
+	ret = spi_sync(vsc_spi->spi, &m);
+	mutex_unlock(&vsc_spi->lock);
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
+	mutex_lock(&vsc_spi->lock);
+	ret = spi_sync(vsc_spi->spi, &m);
+	mutex_unlock(&vsc_spi->lock);
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
+	mutex_init(&vsc_spi->lock);
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
+static const struct of_device_id vsc73xx_of_match[] = {
+	{
+		.compatible = "vitesse,vsc7385",
+	},
+	{
+		.compatible = "vitesse,vsc7388",
+	},
+	{
+		.compatible = "vitesse,vsc7395",
+	},
+	{
+		.compatible = "vitesse,vsc7398",
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, vsc73xx_of_match);
+
+static struct spi_driver vsc73xx_spi_driver = {
+	.probe = vsc73xx_spi_probe,
+	.remove = vsc73xx_spi_remove,
+	.driver = {
+		.name = "vsc73xx-spi",
+		.of_match_table = vsc73xx_of_match,
+	},
+};
+module_spi_driver(vsc73xx_spi_driver);
+
+MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
+MODULE_DESCRIPTION("Vitesse VSC7385/7388/7395/7398 SPI driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/vitesse-vsc73xx.h b/drivers/net/dsa/vitesse-vsc73xx.h
new file mode 100644
index 000000000000..7478f8d4e0a9
--- /dev/null
+++ b/drivers/net/dsa/vitesse-vsc73xx.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/device.h>
+#include <linux/etherdevice.h>
+#include <linux/gpio/driver.h>
+
+/**
+ * struct vsc73xx - VSC73xx state container
+ */
+struct vsc73xx {
+	struct device			*dev;
+	struct gpio_desc		*reset;
+	struct dsa_switch		*ds;
+	struct gpio_chip		gc;
+	u16				chipid;
+	u8				addr[ETH_ALEN];
+	const struct vsc73xx_ops	*ops;
+	void				*priv;
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

