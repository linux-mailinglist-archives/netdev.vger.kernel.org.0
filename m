Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A6944A4BE
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 03:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242130AbhKIC3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 21:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241574AbhKIC3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 21:29:10 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1029C06120F;
        Mon,  8 Nov 2021 18:26:23 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id ee33so70829319edb.8;
        Mon, 08 Nov 2021 18:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=lAKQTdt9yFo8KVPnQhWGK1kgv9B6iwKqO8dsaKGZVxg=;
        b=nsT+Yk/rhtDSbcXGaNur42bSMOIkodjH+aF79QAlMO8zAhCxUPjKgvEuZHczgo618r
         jQ5Qs6hcN1AKIkgZRSuKq/DoqHBFyEyeClYH03pSfOfm3Ut2S8QMDFOxasEqGIfhcwrg
         mLjhtoIIj+xXnFMeh1GKLA9riuxZWZRgPT9CnBF1icCzsgS0EUhPW0egmAmF0Hl6Zjma
         oz3rjIurc7oXZxJXhPH2eAI5CC6IhQ1yMcZ0g08IuYusqSffLg3IbShBieUFOo8v9QLc
         ouWp86kkx/eu1c52bGCxofQpsgGewxSe2kdICQbBpTFBUqEnQXxRdAjnNldL2E2vpMIb
         cB4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lAKQTdt9yFo8KVPnQhWGK1kgv9B6iwKqO8dsaKGZVxg=;
        b=hhVt2Zt6kl5ZlqoVsEfCy23i6FJEbftj1EHJq5cksIVrWX0+bUT3REPfqOYGJux3C2
         5WhWlzuma7ZB7CvLrwxQj556f3mDX/h1ay7Oh5G7sFN36vnCDM7UNyZym+tBTzSk3xcd
         ezNYci3cT5ZTqbGePY0RgHRKpq9SzpQf7h7wmsCFVA3so2tbc8KPmVOjHDzwlxDQprmi
         xQKUpKKpYcKrWaWBbcxgAJTsqxFGdywTUxoXYaQKylFa39TUtgyk1eu/C+xd2WqHcLtE
         rPo3XIvQ8xLXOvu3QZ2wvkNtQ1O3GjYtVCN7PAFGgVIVZElr9iyUv22WfoIpvzT1NWaN
         n4UQ==
X-Gm-Message-State: AOAM530nKAkkqZIU12ybDU3ZW+DyEdztpULCUXXBmqEthr/1Mr+DRpMa
        RTv5yiuGnQrCtVq9qWUTAulye8fwloY=
X-Google-Smtp-Source: ABdhPJx9qyIfulcHyWYortXhHlhfPHfkic/DUYFY02fSjGQvSqh+3+MkqHHtY/ITq0fUPTxWeafiDw==
X-Received: by 2002:aa7:c158:: with SMTP id r24mr5298841edp.65.1636424782260;
        Mon, 08 Nov 2021 18:26:22 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m5sm8760900ejc.62.2021.11.08.18.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 18:26:21 -0800 (PST)
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
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [RFC PATCH v3 7/8] net: dsa: qca8k: add LEDs support
Date:   Tue,  9 Nov 2021 03:26:07 +0100
Message-Id: <20211109022608.11109-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211109022608.11109-1-ansuelsmth@gmail.com>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add LEDs support for qca8k Switch Family. This will provide the LEDs
hardware API to permit the PHY LED to support hardware mode.
Each port have at least 3 LEDs and they can HW blink, set on/off or
follow blink modes configured with the LED in hardware mode..
This adds support for 2 hardware trigger netdev and
hardware-phy-activity.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/Kconfig      |   9 +
 drivers/net/dsa/Makefile     |   1 +
 drivers/net/dsa/qca8k-leds.c | 429 +++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.c      |   8 +-
 drivers/net/dsa/qca8k.h      |  65 ++++++
 5 files changed, 510 insertions(+), 2 deletions(-)
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
index 000000000000..0ca4e4c88f2f
--- /dev/null
+++ b/drivers/net/dsa/qca8k-leds.c
@@ -0,0 +1,429 @@
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
+qca8k_parse_hardware_phy_activity(unsigned long rules, u32 *offload_trigger,
+				  u32 *mask)
+{
+	/* Parsing specific to hardware-phy-activity trigger */
+	if (test_bit(BLINK_TX, &rules))
+		*offload_trigger = QCA8K_LED_TX_BLINK_MASK;
+	if (test_bit(BLINK_RX, &rules))
+		*offload_trigger = QCA8K_LED_RX_BLINK_MASK;
+	if (test_bit(KEEP_LINK_10M, &rules))
+		*offload_trigger = QCA8K_LED_LINK_10M_EN_MASK;
+	if (test_bit(KEEP_LINK_100M, &rules))
+		*offload_trigger = QCA8K_LED_LINK_100M_EN_MASK;
+	if (test_bit(KEEP_LINK_1000M, &rules))
+		*offload_trigger = QCA8K_LED_LINK_1000M_EN_MASK;
+	if (test_bit(KEEP_HALF_DUPLEX, &rules))
+		*offload_trigger = QCA8K_LED_HALF_DUPLEX_MASK;
+	if (test_bit(KEEP_FULL_DUPLEX, &rules))
+		*offload_trigger = QCA8K_LED_FULL_DUPLEX_MASK;
+	if (test_bit(OPTION_LINKUP_OVER, &rules))
+		*offload_trigger = QCA8K_LED_LINKUP_OVER_MASK;
+	if (test_bit(OPTION_BLINK_2HZ, &rules))
+		*offload_trigger = QCA8K_LED_BLINK_2HZ;
+	if (test_bit(OPTION_BLINK_4HZ, &rules))
+		*offload_trigger = QCA8K_LED_BLINK_4HZ;
+	if (test_bit(OPTION_BLINK_8HZ, &rules))
+		*offload_trigger = QCA8K_LED_BLINK_8HZ;
+
+	if (!*offload_trigger)
+		return -EOPNOTSUPP;
+
+	if (test_bit(OPTION_BLINK_2HZ, &rules) ||
+	    test_bit(OPTION_BLINK_4HZ, &rules) ||
+	    test_bit(OPTION_BLINK_8HZ, &rules)) {
+		*mask = QCA8K_LED_BLINK_FREQ_MASK;
+	} else {
+		*mask = *offload_trigger;
+	}
+
+	return 0;
+}
+
+static int
+qca8k_parse_netdev(unsigned long rules, u32 *offload_trigger, u32 *mask)
+{
+	/* Parsing specific to netdev trigger */
+	if (test_bit(TRIGGER_NETDEV_LINK, &rules))
+		*offload_trigger = QCA8K_LED_LINK_10M_EN_MASK |
+				   QCA8K_LED_LINK_100M_EN_MASK |
+				   QCA8K_LED_LINK_1000M_EN_MASK;
+	if (test_bit(TRIGGER_NETDEV_TX, &rules))
+		*offload_trigger = QCA8K_LED_TX_BLINK_MASK;
+	if (test_bit(TRIGGER_NETDEV_RX, &rules))
+		*offload_trigger = QCA8K_LED_RX_BLINK_MASK;
+
+	if (!*offload_trigger)
+		return -EOPNOTSUPP;
+
+	*mask = *offload_trigger;
+
+	return 0;
+}
+
+static int
+qca8k_cled_hw_control_configure(struct led_classdev *ldev, unsigned long rules,
+				enum blink_mode_cmd cmd)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+	struct led_trigger *trigger = ldev->trigger;
+	struct qca8k_led_pattern_en reg_info;
+	struct qca8k_priv *priv = led->priv;
+	u32 offload_trigger = 0, mask, val;
+	int ret;
+
+	/* Check trigger compatibility */
+	if (strcmp(trigger->name, "hardware-phy-activity") &&
+	    strcmp(trigger->name, "netdev"))
+		return -EOPNOTSUPP;
+
+	if (!strcmp(trigger->name, "hardware-phy-activity"))
+		ret = qca8k_parse_hardware_phy_activity(rules, &offload_trigger, &mask);
+
+	if (!strcmp(trigger->name, "netdev"))
+		ret = qca8k_parse_netdev(rules, &offload_trigger, &mask);
+
+	if (ret)
+		return ret;
+
+	qca8k_get_control_led_reg(led->port_num, led->led_num, &reg_info);
+
+	switch (cmd) {
+	case BLINK_MODE_SUPPORTED:
+		/* We reache this point, we are sure the trigger is supported */
+		return 1;
+	case BLINK_MODE_ZERO:
+		/* We set 4hz by default */
+		u32 default_reg = QCA8K_LED_BLINK_4HZ;
+
+		ret = qca8k_rmw(priv, reg_info.reg,
+				QCA8K_LED_RULE_MASK << reg_info.shift,
+				default_reg << reg_info.shift);
+		break;
+	case BLINK_MODE_ENABLE:
+		ret = qca8k_rmw(priv, reg_info.reg,
+				mask << reg_info.shift,
+				offload_trigger << reg_info.shift);
+		break;
+	case BLINK_MODE_DISABLE:
+		ret = qca8k_rmw(priv, reg_info.reg,
+				mask << reg_info.shift,
+				0);
+		break;
+	case BLINK_MODE_READ:
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
+qca8k_cled_hw_control_start(struct led_classdev *led_cdev)
+{
+	return qca8k_cled_trigger_offload(led_cdev, true);
+}
+
+static int
+qca8k_cled_hw_control_stop(struct led_classdev *led_cdev)
+{
+	return qca8k_cled_trigger_offload(led_cdev, false);
+}
+
+static bool
+qca8k_cled_hw_control_status(struct led_classdev *ldev)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+
+	struct qca8k_led_pattern_en reg_info;
+	struct qca8k_priv *priv = led->priv;
+	u32 val;
+
+	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
+
+	qca8k_read(priv, reg_info.reg, &val);
+
+	val >>= reg_info.shift;
+	val &= GENMASK(1, 0);
+
+	return val == QCA8K_LED_RULE_CONTROLLED;
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
+		dev_dbg(priv->dev, "No Leds node specified in device tree for port %d!\n",
+			port_num);
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
+		port_led->cdev.blink_mode = SOFTWARE_HARDWARE_CONTROLLED;
+		port_led->cdev.max_brightness = 1;
+		port_led->cdev.brightness_set = qca8k_cled_brightness_set;
+		port_led->cdev.brightness_get = qca8k_cled_brightness_get;
+		port_led->cdev.blink_set = qca8k_cled_blink_set;
+		port_led->cdev.hw_control_start = qca8k_cled_hw_control_start;
+		port_led->cdev.hw_control_stop = qca8k_cled_hw_control_stop;
+		port_led->cdev.hw_control_status = qca8k_cled_hw_control_status;
+		port_led->cdev.hw_control_configure = qca8k_cled_hw_control_configure;
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
index a429c9750add..10b2b47b2156 100644
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
@@ -1109,6 +1109,10 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	ret = qca8k_setup_led_ctrl(priv);
+	if (ret)
+		return ret;
+
 	/* Make sure MAC06 is disabled */
 	ret = qca8k_reg_clear(priv, QCA8K_REG_PORT0_PAD_CTRL,
 			      QCA8K_PORT0_PAD_MAC06_EXCHANGE_EN);
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 128b8cf85e08..f68f037fe909 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/regmap.h>
 #include <linux/gpio.h>
+#include <linux/leds.h>
 
 #define QCA8K_NUM_PORTS					7
 #define QCA8K_NUM_CPU_PORTS				2
@@ -74,6 +75,43 @@
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
+#define QCA8K_LED_RULE_MASK				GENMASK(13, 0)
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
@@ -279,6 +317,19 @@ struct qca8k_ports_config {
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
@@ -293,6 +344,7 @@ struct qca8k_priv {
 	struct dsa_switch_ops ops;
 	struct gpio_desc *reset_gpio;
 	unsigned int port_mtu[QCA8K_NUM_PORTS];
+	struct qca8k_led ports_led[QCA8K_LED_COUNT];
 };
 
 struct qca8k_mib_desc {
@@ -308,4 +360,17 @@ struct qca8k_fdb {
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

