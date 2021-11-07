Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE714474D2
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 18:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236093AbhKGSAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 13:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236049AbhKGSAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 13:00:44 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50A7C061764;
        Sun,  7 Nov 2021 09:58:01 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id x15so22145551edv.1;
        Sun, 07 Nov 2021 09:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1HRY8stwRH/p86K1ZhptplHFYzmy8BaDZNoXh+cWch0=;
        b=RV8zWHSZce/KZgba9gI0SzukAH1z4HwHV6KrUOpz/9tnJfcweF3uRYx84znzG2eLTd
         LKkn4PFq8D24rWOHPMRfuV9dcRkdlfnhGwhCR9iCm6DJC0Lwq68um2HDBuV9KLB5mSgP
         P3ySf5T5wmKfG4k4Qb32MoNSWB6Xo0sFJy9HN3xbNWcAZ7aS8ZrdmAn47W3xFHbyrMtt
         84IuxQS2bjhZW5WpP12H0mClHiVKgSwyMFpDWMF4yCJNVgyGDDcINmGRgwMNX7EQO2Rc
         YHQKDbNIauyvNZpt9T6APRPS0+iacEkq0usispT/lo+NsrCwtj1iePJAm2YmAmmmnk/u
         B0Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1HRY8stwRH/p86K1ZhptplHFYzmy8BaDZNoXh+cWch0=;
        b=lUB79wgkKb2PpWQeMYKUfNzOKeAcidj/qBbdEZVKvadai+hCwo2fD7qqnLqZDRrkP5
         VuZTEVm5CnR8b3uTtcKMmNinZqbUFeIrGHeod3BCKeWGkQ55Px3yBx4l+JF6Oyb4jLzh
         Ete0o10y2wjGs7W6v5h7J71JpMH9keLi3wbNZnbdmB8r6L0aqkjFW9iouSP8i/ZeUsv5
         7NWBiP/wgOIqjnNI3OZICet+Xa2iEUDKzTIMeqtIumrC4PrUh7pu333TYbVV3HWtknzu
         Mvvs64LcGOOlN93D+yRd5/+6bK/fyV1aLbhh7brw7VTol4KlES3jEt23Iygsv29hoP1u
         s0mw==
X-Gm-Message-State: AOAM530D7givU9Oe7t5xA2N45VQ8gjyfV7BnYQxttpC6T3juEBj7mJnW
        cwF59YCs5F+WRbOQZOY4yZ5M92nThIo=
X-Google-Smtp-Source: ABdhPJz5RuReeI//LuPfXlL/htilOMNkeyRSpPiXo9wYe+3hgEysJI3X7zxld/xatXoBD3Kz6drZCg==
X-Received: by 2002:a17:906:2757:: with SMTP id a23mr91141387ejd.230.1636307880177;
        Sun, 07 Nov 2021 09:58:00 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m11sm4251182edd.58.2021.11.07.09.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 09:57:59 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [RFC PATCH 5/6] net: dsa: qca8k: add LEDs support
Date:   Sun,  7 Nov 2021 18:57:17 +0100
Message-Id: <20211107175718.9151-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211107175718.9151-1-ansuelsmth@gmail.com>
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add LEDs support for qca8k Switch Family. This will provide the LEDs
offload API to permit the PHY LED to be driven offloaded.
Each port have at least 3 LEDs and they can HW blink, set on/off or
set to be driven by some rules applied by the offload trigger.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/Kconfig      |   9 +
 drivers/net/dsa/Makefile     |   1 +
 drivers/net/dsa/qca8k-leds.c | 361 +++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.c      |   4 +-
 drivers/net/dsa/qca8k.h      |  64 +++++++
 5 files changed, 437 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/dsa/qca8k-leds.c

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 7b1457a6e327..89e36f3a8195 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -67,6 +67,15 @@ config NET_DSA_QCA8K
 	  This enables support for the Qualcomm Atheros QCA8K Ethernet
 	  switch chips.
 
+config NET_DSA_QCA8K_LEDS_SUPPORT
+	tristate "Qualcomm Atheros QCA8K Ethernet switch family LEDs support"
+	select NET_DSA_QCA8K
+	select LEDS_OFFLOAD_TRIGGERS
+	help
+	  Thsi enabled support for LEDs present on the Qualcomm Atheros
+	  QCA8K Ethernet switch chips. This require the LEDs offload
+	  triggers support as it can run in offload mode.
+
 config NET_DSA_REALTEK_SMI
 	tristate "Realtek SMI Ethernet switch family support"
 	select NET_DSA_TAG_RTL4_A
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index 8da1569a34e6..fb1e7d0cf126 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
 obj-$(CONFIG_NET_DSA_MT7530)	+= mt7530.o
 obj-$(CONFIG_NET_DSA_MV88E6060) += mv88e6060.o
 obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
+obj-$(CONFIG_NET_DSA_QCA8K_LEDS_SUPPORT) += qca8k-leds.o
 obj-$(CONFIG_NET_DSA_REALTEK_SMI) += realtek-smi.o
 realtek-smi-objs		:= realtek-smi-core.o rtl8366.o rtl8366rb.o rtl8365mb.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
diff --git a/drivers/net/dsa/qca8k-leds.c b/drivers/net/dsa/qca8k-leds.c
new file mode 100644
index 000000000000..0f86a30c7440
--- /dev/null
+++ b/drivers/net/dsa/qca8k-leds.c
@@ -0,0 +1,361 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <net/dsa.h>
+
+#include "qca8k.h"
+
+static int
+qca8k_get_enable_led_reg(int port_num, int led_num, struct qca8k_led_pattern_en *reg_info)
+{
+	int shift;
+
+	switch (port_num) {
+	case 0:
+		reg_info->reg = QCA8K_LED_CTRL_REG(led_num);
+		reg_info->shift = 14;
+		break;
+	case 1:
+	case 2:
+	case 3:
+		reg_info->reg = QCA8K_LED_CTRL_REG(3);
+		shift = 2 * led_num + (6 * (port_num - 1));
+
+		reg_info->shift = 8 + shift;
+
+		break;
+	case 4:
+		reg_info->reg = QCA8K_LED_CTRL_REG(led_num);
+		reg_info->shift = 30;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+qca8k_get_control_led_reg(int port_num, int led_num, struct qca8k_led_pattern_en *reg_info)
+{
+	reg_info->reg = QCA8K_LED_CTRL_REG(led_num);
+
+	/* 6 total control rule:
+	 * 3 control rules for phy0-3 that applies to all their leds
+	 * 3 control rules for phy4
+	 */
+	if (port_num == 4)
+		reg_info->shift = 16;
+	else
+		reg_info->shift = 0;
+
+	return 0;
+}
+
+static int
+qca8k_cled_configure_offload(struct led_classdev *ldev, u32 rules, enum offload_trigger_cmd cmd)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+	struct led_trigger *trigger = ldev->trigger;
+	struct qca8k_led_pattern_en reg_info;
+	struct qca8k_priv *priv = led->priv;
+	u32 offload_trigger = 0, mask, val;
+	int ret;
+
+	/* Check trigger compatibility */
+	if (strcmp(trigger->name, "offload-phy-activity"))
+		return -EOPNOTSUPP;
+
+	switch (rules) {
+	case BLINK_TX:
+		offload_trigger = QCA8K_LED_TX_BLINK_MASK;
+		break;
+	case BLINK_RX:
+		offload_trigger = QCA8K_LED_RX_BLINK_MASK;
+		break;
+	case BLINK_COLLISION:
+		offload_trigger = QCA8K_LED_COL_BLINK_MASK;
+		break;
+	case KEEP_LINK_10M:
+		offload_trigger = QCA8K_LED_LINK_10M_EN_MASK;
+		break;
+	case KEEP_LINK_100M:
+		offload_trigger = QCA8K_LED_LINK_100M_EN_MASK;
+		break;
+	case KEEP_LINK_1000M:
+		offload_trigger = QCA8K_LED_LINK_1000M_EN_MASK;
+		break;
+	case KEEP_HALF_DUPLEX:
+		offload_trigger = QCA8K_LED_HALF_DUPLEX_MASK;
+		break;
+	case KEEP_FULL_DUPLEX:
+		offload_trigger = QCA8K_LED_FULL_DUPLEX_MASK;
+		break;
+	case OPTION_LINKUP_OVER:
+		offload_trigger = QCA8K_LED_LINKUP_OVER_MASK;
+		break;
+	case OPTION_BLINK_2HZ:
+			offload_trigger = QCA8K_LED_BLINK_2HZ;
+		break;
+	case OPTION_BLINK_4HZ:
+			offload_trigger = QCA8K_LED_BLINK_4HZ;
+		break;
+	case OPTION_BLINK_8HZ:
+			offload_trigger = QCA8K_LED_BLINK_8HZ;
+		break;
+	case OPTION_BLINK_AUTO:
+			offload_trigger = QCA8K_LED_BLINK_AUTO;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (rules == OPTION_BLINK_2HZ || rules == OPTION_BLINK_4HZ ||
+	    rules == OPTION_BLINK_8HZ || rules == OPTION_BLINK_AUTO) {
+		mask = QCA8K_LED_BLINK_FREQ_MASK;
+	} else {
+		mask = offload_trigger;
+	}
+
+	qca8k_get_control_led_reg(led->port_num, led->led_num, &reg_info);
+
+	switch (cmd) {
+	case TRIGGER_ENABLE:
+		ret = qca8k_rmw(priv, reg_info.reg,
+				mask << reg_info.shift,
+				offload_trigger << reg_info.shift);
+		break;
+	case TRIGGER_DISABLE:
+		ret = qca8k_rmw(priv, reg_info.reg,
+				mask << reg_info.shift,
+				0);
+		break;
+	case TRIGGER_READ:
+		ret = qca8k_read(priv, reg_info.reg, &val);
+		if (ret)
+			return ret;
+
+		val >>= reg_info.shift;
+		val &= offload_trigger;
+
+		/* Special handling for LED_BLINK_2HZ */
+		if (!val && offload_trigger == QCA8K_LED_BLINK_2HZ)
+			val = 1;
+
+		return val;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return ret;
+}
+
+static void
+qca8k_led_brightness_set(struct qca8k_led *led,
+			 enum led_brightness b)
+{
+	struct qca8k_led_pattern_en reg_info;
+	struct qca8k_priv *priv = led->priv;
+	u32 val = QCA8K_LED_ALWAYS_OFF;
+
+	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
+
+	if (b)
+		val = QCA8K_LED_ALWAYS_ON;
+
+	qca8k_rmw(priv, reg_info.reg,
+		  GENMASK(1, 0) << reg_info.shift,
+		  val << reg_info.shift);
+}
+
+static void
+qca8k_cled_brightness_set(struct led_classdev *ldev,
+			  enum led_brightness b)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+
+	return qca8k_led_brightness_set(led, b);
+}
+
+static enum led_brightness
+qca8k_led_brightness_get(struct qca8k_led *led)
+{
+	struct qca8k_led_pattern_en reg_info;
+	struct qca8k_priv *priv = led->priv;
+	u32 val;
+	int ret;
+
+	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
+
+	ret = qca8k_read(priv, reg_info.reg, &val);
+	if (ret)
+		return 0;
+
+	val >>= reg_info.shift;
+	val &= GENMASK(1, 0);
+
+	return val > 0 ? 1 : 0;
+}
+
+static enum led_brightness
+qca8k_cled_brightness_get(struct led_classdev *ldev)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+
+	return qca8k_led_brightness_get(led);
+}
+
+static int
+qca8k_cled_blink_set(struct led_classdev *ldev,
+		     unsigned long *delay_on,
+		     unsigned long *delay_off)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+	struct qca8k_led_pattern_en reg_info;
+	struct qca8k_priv *priv = led->priv;
+
+	if (*delay_on == 0 && *delay_off == 0) {
+		*delay_on = 125;
+		*delay_off = 125;
+	}
+
+	if (*delay_on != 125 || *delay_off != 125) {
+		/* The hardware only supports blinking at 4Hz. Fall back
+		 * to software implementation in other cases.
+		 */
+		return -EINVAL;
+	}
+
+	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
+
+	qca8k_rmw(priv, reg_info.reg,
+		  GENMASK(1, 0) << reg_info.shift,
+		  QCA8K_LED_ALWAYS_BLINK_4HZ << reg_info.shift);
+
+	return 0;
+}
+
+static int
+qca8k_cled_trigger_offload(struct led_classdev *ldev, bool enable)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+
+	struct qca8k_led_pattern_en reg_info;
+	struct qca8k_priv *priv = led->priv;
+	u32 val = QCA8K_LED_ALWAYS_OFF;
+
+	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
+
+	if (enable)
+		val = QCA8K_LED_RULE_CONTROLLED;
+
+	return qca8k_rmw(priv, reg_info.reg,
+			 GENMASK(1, 0) << reg_info.shift,
+			 val << reg_info.shift);
+}
+
+static int
+qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int port_num)
+{
+	struct fwnode_handle *led = NULL, *leds = NULL;
+	struct led_init_data init_data = { };
+	struct qca8k_led *port_led;
+	int led_num, port_index;
+	const char *state;
+	int ret;
+
+	leds = fwnode_get_named_child_node(port, "leds");
+	if (!leds) {
+		dev_info(priv->dev, "No Leds node specified in device tree for port %d!\n",
+			 port_num);
+		return 0;
+	}
+
+	fwnode_for_each_child_node(leds, led) {
+		/* Reg rapresent the led number of the port.
+		 * Each port can have at least 3 leds attached
+		 * Commonly:
+		 * 1. is gigabit led
+		 * 2. is mbit led
+		 * 3. additional status led
+		 */
+		if (fwnode_property_read_u32(led, "reg", &led_num))
+			continue;
+
+		if (led_num >= QCA8K_LED_PORT_COUNT) {
+			dev_warn(priv->dev, "Invalid LED reg defined %d", port_num);
+			continue;
+		}
+
+		port_index = 3 * port_num + led_num;
+
+		port_led = &priv->ports_led[port_index];
+		port_led->port_num = port_num;
+		port_led->led_num = led_num;
+		port_led->priv = priv;
+
+		ret = fwnode_property_read_string(led, "default-state", &state);
+		if (!ret) {
+			if (!strcmp(state, "on")) {
+				port_led->cdev.brightness = 1;
+				qca8k_led_brightness_set(port_led, 1);
+			} else if (!strcmp(state, "off")) {
+				port_led->cdev.brightness = 0;
+				qca8k_led_brightness_set(port_led, 0);
+			} else if (!strcmp(state, "keep")) {
+				port_led->cdev.brightness =
+					qca8k_led_brightness_get(port_led);
+			}
+		}
+
+		/* 3 brightness settings can be applied from Documentation:
+		 * 0 always off
+		 * 1 blink at 4Hz
+		 * 2 always on
+		 * 3 rule controlled
+		 * Suppots only 2 mode: (pcb limitation, with always on and blink
+		 * only the last led is set to this mode)
+		 * 0 always off (sets all leds off)
+		 * 3 rule controlled
+		 */
+		port_led->cdev.max_brightness = 1;
+		port_led->cdev.brightness_set = qca8k_cled_brightness_set;
+		port_led->cdev.brightness_get = qca8k_cled_brightness_get;
+		port_led->cdev.blink_set = qca8k_cled_blink_set;
+		port_led->cdev.configure_offload = qca8k_cled_configure_offload;
+		port_led->cdev.trigger_offload = qca8k_cled_trigger_offload;
+		init_data.default_label = ":port";
+		init_data.devicename = "qca8k";
+		init_data.fwnode = led;
+
+		ret = devm_led_classdev_register_ext(priv->dev, &port_led->cdev, &init_data);
+		if (ret)
+			dev_warn(priv->dev, "Failed to int led");
+	}
+
+	return 0;
+}
+
+int
+qca8k_setup_led_ctrl(struct qca8k_priv *priv)
+{
+	struct fwnode_handle *mdio, *port;
+	int port_num;
+	int ret;
+
+	mdio = device_get_named_child_node(priv->dev, "mdio");
+	if (!mdio) {
+		dev_info(priv->dev, "No MDIO node specified in device tree!\n");
+		return 0;
+	}
+
+	fwnode_for_each_child_node(mdio, port) {
+		if (fwnode_property_read_u32(port, "reg", &port_num))
+			continue;
+
+		/* Each port can have at least 3 different leds attached */
+		ret = qca8k_parse_port_leds(priv, port, port_num);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a429c9750add..b5c81e2d9f8a 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -148,7 +148,7 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
 	return 0;
 }
 
-static int
+int
 qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val)
 {
 	struct mii_bus *bus = priv->bus;
@@ -192,7 +192,7 @@ qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 	return ret;
 }
 
-static int
+int
 qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
 {
 	struct mii_bus *bus = priv->bus;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 128b8cf85e08..b11385ff9bce 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/regmap.h>
 #include <linux/gpio.h>
+#include <linux/leds.h>
 
 #define QCA8K_NUM_PORTS					7
 #define QCA8K_NUM_CPU_PORTS				2
@@ -74,6 +75,42 @@
 #define   QCA8K_MDIO_MASTER_DATA_MASK			GENMASK(15, 0)
 #define   QCA8K_MDIO_MASTER_MAX_PORTS			5
 #define   QCA8K_MDIO_MASTER_MAX_REG			32
+
+/* LED control register */
+#define QCA8K_LED_COUNT					15
+#define QCA8K_LED_PORT_COUNT				3
+#define QCA8K_LED_RULE_COUNT				6
+#define QCA8K_LED_RULE_MAX				11
+#define QCA8K_LED_CTRL_REG(_i)				(0x050 + (_i) * 4)
+#define QCA8K_LED_CTRL0_REG				0x50
+#define QCA8K_LED_CTRL1_REG				0x54
+#define QCA8K_LED_CTRL2_REG				0x58
+#define QCA8K_LED_CTRL3_REG				0x5C
+#define   QCA8K_LED_CTRL_SHIFT(_i)			(((_i) % 2) * 16)
+#define   QCA8K_LED_CTRL_MASK				GENMASK(15, 0)
+#define QCA8K_LED_BLINK_FREQ_MASK			GENMASK(1, 0)
+#define QCA8K_LED_BLINK_FREQ_SHITF			0
+#define   QCA8K_LED_BLINK_2HZ				0
+#define   QCA8K_LED_BLINK_4HZ				1
+#define   QCA8K_LED_BLINK_8HZ				2
+#define   QCA8K_LED_BLINK_AUTO				3
+#define QCA8K_LED_LINKUP_OVER_MASK			BIT(2)
+#define QCA8K_LED_TX_BLINK_MASK				BIT(4)
+#define QCA8K_LED_RX_BLINK_MASK				BIT(5)
+#define QCA8K_LED_COL_BLINK_MASK			BIT(7)
+#define QCA8K_LED_LINK_10M_EN_MASK			BIT(8)
+#define QCA8K_LED_LINK_100M_EN_MASK			BIT(9)
+#define QCA8K_LED_LINK_1000M_EN_MASK			BIT(10)
+#define QCA8K_LED_POWER_ON_LIGHT_MASK			BIT(11)
+#define QCA8K_LED_HALF_DUPLEX_MASK			BIT(12)
+#define QCA8K_LED_FULL_DUPLEX_MASK			BIT(13)
+#define QCA8K_LED_PATTERN_EN_MASK			GENMASK(15, 14)
+#define QCA8K_LED_PATTERN_EN_SHIFT			14
+#define   QCA8K_LED_ALWAYS_OFF				0
+#define   QCA8K_LED_ALWAYS_BLINK_4HZ			1
+#define   QCA8K_LED_ALWAYS_ON				2
+#define   QCA8K_LED_RULE_CONTROLLED			3
+
 #define QCA8K_GOL_MAC_ADDR0				0x60
 #define QCA8K_GOL_MAC_ADDR1				0x64
 #define QCA8K_MAX_FRAME_SIZE				0x78
@@ -279,6 +316,19 @@ struct qca8k_ports_config {
 	u8 rgmii_tx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
 };
 
+struct qca8k_led_pattern_en {
+	u32 reg;
+	u8 shift;
+};
+
+struct qca8k_led {
+	u8 port_num;
+	u8 led_num;
+	u16 old_rule;
+	struct qca8k_priv *priv;
+	struct led_classdev cdev;
+};
+
 struct qca8k_priv {
 	u8 switch_id;
 	u8 switch_revision;
@@ -293,6 +343,7 @@ struct qca8k_priv {
 	struct dsa_switch_ops ops;
 	struct gpio_desc *reset_gpio;
 	unsigned int port_mtu[QCA8K_NUM_PORTS];
+	struct qca8k_led ports_led[QCA8K_LED_COUNT];
 };
 
 struct qca8k_mib_desc {
@@ -308,4 +359,17 @@ struct qca8k_fdb {
 	u8 mac[6];
 };
 
+/* Common function used by the LEDs module */
+int qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val);
+int qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val);
+
+#ifdef CONFIG_NET_DSA_QCA8K_LEDS_SUPPORT
+int qca8k_setup_led_ctrl(struct qca8k_priv *priv);
+#else
+static inline int qca8k_setup_led_ctrl(struct qca8k_priv *priv)
+{
+	return 0;
+}
+#endif
+
 #endif /* __QCA8K_H */
-- 
2.32.0

