Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7502F0CA2
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbhAKFqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbhAKFqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 00:46:04 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03578C061795;
        Sun, 10 Jan 2021 21:45:24 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id g15so11858107pgu.9;
        Sun, 10 Jan 2021 21:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/IG9QX0IHrdPUT/Mg6rywGJ37NO8HyXBbRa3ZgeBS9M=;
        b=oJ0fM+AcEpK6rJSSsNW6UOxHZphHa70yHtXPHyWvdLY1XXSpbAkPyFMvk/cDQE8A+2
         tZt3vxZ9ZPheMXFV1IabJFSHVsVWxv3q5TEj1TrdSzVUbZ11Su6ZKSg7p9TFn+GZlTa2
         6FsaH8vfNbNuyyJ+0d90UNxhAYzLhnBxXkaRV9dIfDUCm7/qlxembEgvx8VOd003H7xI
         FyUkugu7jh5NGYnfIqYRveGPj94wZ9HF00o5zfihBNFIl2Z9QzO9CPzFwXCUQkiXSzk9
         Sfh9vxSXeheOrl0o/lg5gY6BdyT64G59tDdeZHO3YyM9s1ds1kvvfuqnFmij5vuHb90A
         eu0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/IG9QX0IHrdPUT/Mg6rywGJ37NO8HyXBbRa3ZgeBS9M=;
        b=l//WvilKnIpwbiodWE1SUwj22qEXnl9thB1F4t2Ewl/HP9yGcG/y1uNu7wFVTHXAKO
         C4X67ML0xyvI5m/NFjnq8ObRDvwnST55U3yBGFGcbjQpZbLDn/e0cfYXLKaSDHiYDmOu
         UpKygY+CzG4XYjcjD4p8s6b/4oYQSh/a1qzTX5xAq6tdF6t3TjHYQaJXjy1KL08g52fZ
         FLjmfmu43tHL2ZaXAHh6BGbbDoyOD0iz6avT722Xp37aLarTIAaGTA+H++AA6cqyKfT4
         y4RI28JMk03zva7YzKl10+cwtj0iQZ5COWxy+LkW3vNDq5bKjdh6iMM/kCX47+Bk4SOW
         NcNQ==
X-Gm-Message-State: AOAM531CZAuzFUP0uGeWRMabtLwwpWGlV/w80PWXZQpYnHQ+D9tmiIp9
        RVGxqRehWnwOMehvG+n4T1E=
X-Google-Smtp-Source: ABdhPJy/ZferhM6b1DXi1APDWQlpyda2XCQFyyhZemiRFgF70lMgurxMK2f9nMPlEU6bLiCTBi5X+w==
X-Received: by 2002:a65:50c8:: with SMTP id s8mr18467136pgp.68.1610343923559;
        Sun, 10 Jan 2021 21:45:23 -0800 (PST)
Received: from container-ubuntu.lan ([218.89.163.70])
        by smtp.gmail.com with ESMTPSA id q16sm17548005pfg.139.2021.01.10.21.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 21:45:23 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next 2/2] drivers: net: dsa: mt7530: MT7530 optional GPIO support
Date:   Mon, 11 Jan 2021 13:44:28 +0800
Message-Id: <20210111054428.3273-3-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210111054428.3273-1-dqfext@gmail.com>
References: <20210111054428.3273-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MT7530's LED controller can drive up to 15 LED/GPIOs.

Add support for GPIO control and allow users to use its GPIOs by
setting gpio-controller property in device tree.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 96 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/mt7530.h | 20 +++++++++
 2 files changed, 116 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index a67cac15a724..0686d8cbd086 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -18,6 +18,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/reset.h>
 #include <linux/gpio/consumer.h>
+#include <linux/gpio/driver.h>
 #include <net/dsa.h>
 
 #include "mt7530.h"
@@ -1639,6 +1640,95 @@ mtk_get_tag_protocol(struct dsa_switch *ds, int port,
 	}
 }
 
+static u32
+mt7530_gpio_to_bit(unsigned int offset)
+{
+	return BIT(offset + offset / 3);
+}
+
+static int
+mt7530_gpio_get(struct gpio_chip *gc, unsigned int offset)
+{
+	struct mt7530_priv *priv = gpiochip_get_data(gc);
+	u32 bit = mt7530_gpio_to_bit(offset);
+
+	return !!(mt7530_read(priv, MT7530_LED_GPIO_DATA) & bit);
+}
+
+static void
+mt7530_gpio_set(struct gpio_chip *gc, unsigned int offset, int value)
+{
+	struct mt7530_priv *priv = gpiochip_get_data(gc);
+	u32 bit = mt7530_gpio_to_bit(offset);
+
+	if (value)
+		mt7530_set(priv, MT7530_LED_GPIO_DATA, bit);
+	else
+		mt7530_clear(priv, MT7530_LED_GPIO_DATA, bit);
+}
+
+static int
+mt7530_gpio_get_direction(struct gpio_chip *gc, unsigned int offset)
+{
+	struct mt7530_priv *priv = gpiochip_get_data(gc);
+	u32 bit = mt7530_gpio_to_bit(offset);
+
+	return (mt7530_read(priv, MT7530_LED_GPIO_DIR) & bit) ?
+		GPIO_LINE_DIRECTION_OUT : GPIO_LINE_DIRECTION_IN;
+}
+
+static int
+mt7530_gpio_direction_input(struct gpio_chip *gc, unsigned int offset)
+{
+	struct mt7530_priv *priv = gpiochip_get_data(gc);
+	u32 bit = mt7530_gpio_to_bit(offset);
+
+	mt7530_clear(priv, MT7530_LED_GPIO_DIR, bit);
+	mt7530_clear(priv, MT7530_LED_GPIO_OE, bit);
+
+	return 0;
+}
+
+static int
+mt7530_gpio_direction_output(struct gpio_chip *gc, unsigned int offset, int value)
+{
+	struct mt7530_priv *priv = gpiochip_get_data(gc);
+	u32 bit = mt7530_gpio_to_bit(offset);
+
+	mt7530_set(priv, MT7530_LED_GPIO_DIR, bit);
+	mt7530_set(priv, MT7530_LED_GPIO_OE, bit);
+	mt7530_gpio_set(gc, offset, value);
+
+	return 0;
+}
+
+static int
+mt7530_setup_gpio(struct mt7530_priv *priv)
+{
+	struct device *dev = priv->dev;
+	struct gpio_chip *gc;
+
+	gc = devm_kzalloc(dev, sizeof(*gc), GFP_KERNEL);
+	if (!gc)
+		return -ENOMEM;
+
+	mt7530_write(priv, MT7530_LED_IO_MODE, 0);
+
+	gc->label = "mt7530";
+	gc->parent = dev;
+	gc->owner = THIS_MODULE;
+	gc->get_direction = mt7530_gpio_get_direction;
+	gc->direction_input = mt7530_gpio_direction_input;
+	gc->direction_output = mt7530_gpio_direction_output;
+	gc->get = mt7530_gpio_get;
+	gc->set = mt7530_gpio_set;
+	gc->base = -1;
+	gc->ngpio = 15;
+	gc->can_sleep = true;
+
+	return devm_gpiochip_add_data(dev, gc, priv);
+}
+
 static int
 mt7530_setup(struct dsa_switch *ds)
 {
@@ -1781,6 +1871,12 @@ mt7530_setup(struct dsa_switch *ds)
 		}
 	}
 
+	if (of_property_read_bool(priv->dev->of_node, "gpio-controller")) {
+		ret = mt7530_setup_gpio(priv);
+		if (ret)
+			return ret;
+	}
+
 	mt7530_setup_port5(ds, interface);
 
 	/* Flush the FDB table */
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 32d8969b3ace..e7903ecc6a7c 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -554,6 +554,26 @@ enum mt7531_clk_skew {
 #define  MT7531_GPIO12_RG_RXD3_MASK	GENMASK(19, 16)
 #define  MT7531_EXT_P_MDIO_12		(2 << 16)
 
+/* Registers for LED GPIO control (MT7530 only)
+ * All registers follow this pattern:
+ * [2:0]    port 0
+ * [6:4]    port 1
+ * [10:8]   port 2
+ * [14:12]  port 3
+ * [18:16]  port 4
+ */
+
+/* LED enable, 0: Disable, 1: Enable (Default) */
+#define MT7530_LED_EN			0x7d00
+/* LED mode, 0: GPIO mode, 1: PHY mode (Default) */
+#define MT7530_LED_IO_MODE		0x7d04
+/* GPIO direction, 0: Input, 1: Output */
+#define MT7530_LED_GPIO_DIR		0x7d10
+/* GPIO output enable, 0: Disable, 1: Enable */
+#define MT7530_LED_GPIO_OE		0x7d14
+/* GPIO value, 0: Low, 1: High */
+#define MT7530_LED_GPIO_DATA		0x7d18
+
 #define MT7530_CREV			0x7ffc
 #define  CHIP_NAME_SHIFT		16
 #define  MT7530_ID			0x7530
-- 
2.25.1

