Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8569F518846
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238310AbiECPW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238126AbiECPWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:22:11 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C823B037;
        Tue,  3 May 2022 08:18:29 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id y21so20257606edo.2;
        Tue, 03 May 2022 08:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qWeRBSAuPZGLs4sbYjchUhwhQ1cr8p5mhxScwOV6V9s=;
        b=F3O3swQokHF7rJy+uTUEWaWRNp+sI3ifyExXf+T9jaoRnb9sM8qZ43oj+z1IQO3VN5
         cdggIPkTraaZP8+XluiVTLra2bY8zCGBubz3ykZW+SzCEw62tE4CVxBo7kVmwjyAqwLN
         9OIziKGOdlNVqDpH4bkoxe5iRG687wR+IsnpSNNS05xfvluPv8kk1c6rbP+BGxG+Ng5e
         YAj+kM+cyCJSixUCossGz2VO8goVq01idpOaw+5UYGSbzjv39GhNaMYZeQulyraBt85F
         KNJYajymnUQXRMAOKtUZTIyCNGE3g0XXoz4cNBrpt0zp5uWZGZU7JixeDwj95j9nD6cU
         Y+Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qWeRBSAuPZGLs4sbYjchUhwhQ1cr8p5mhxScwOV6V9s=;
        b=PnYVd43a8nU29DiQvxLxRx/YCIVy4eRkj9JsrZ8fWhDr0nFrCfDrphc44oh4ZwDE8a
         NLTyTgDJUkxwt/OeUa15Jt/1LxjOF1zEOaZ/fCswjsVNHt64XTTnE+Que170fLyhlO/G
         qKZC/RbO8M0YCCzkVsYfinJedmG3jPQa21rDt78LZvGAiO64TdFdGp+EzNiCLyBl0WvX
         tAlR05fUC/NihVXJfZwHe47ZmxLwsQTAB2FnpaHfFj32C+ZQWl15J6te46aij7jHPCwF
         kjZidK3PsHj25mhdj/85kgn4quuRZzak+IlgKv50uCX31XVoUJuJXsfB03DbRIugxbFz
         HXwg==
X-Gm-Message-State: AOAM530dlEEIIwQUlasaBiCOTfSw/Vgi7ehtNxkqb871dDsLljFLsid8
        ggj6d/KMCwH2cujpalZF3K0=
X-Google-Smtp-Source: ABdhPJwbOzuFAAUEYviqJb0KYowRVRMSPG+4iFmhWDY+SZItoq+dxEThm0+GEedrm5OzFf/+PlYXDQ==
X-Received: by 2002:a05:6402:492:b0:404:c4bf:8b7e with SMTP id k18-20020a056402049200b00404c4bf8b7emr18247260edv.318.1651591107912;
        Tue, 03 May 2022 08:18:27 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id v3-20020aa7d9c3000000b0042617ba63cesm7947507eds.88.2022.05.03.08.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 08:18:27 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [RFC PATCH v6 10/11] net: dsa: qca8k: add LEDs support
Date:   Tue,  3 May 2022 17:16:32 +0200
Message-Id: <20220503151633.18760-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220503151633.18760-1-ansuelsmth@gmail.com>
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 drivers/net/dsa/qca8k-leds.c | 408 +++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.c      |   4 +
 drivers/net/dsa/qca8k.h      |  61 ++++++
 5 files changed, 483 insertions(+)
 create mode 100644 drivers/net/dsa/qca8k-leds.c

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 37a3dabdce31..6e9d730c5e00 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -68,6 +68,15 @@ config NET_DSA_QCA8K
 	  This enables support for the Qualcomm Atheros QCA8K Ethernet
 	  switch chips.
 
+config NET_DSA_QCA8K_LEDS_SUPPORT
+	tristate "Qualcomm Atheros QCA8K Ethernet switch family LEDs support"
+	select NET_DSA_QCA8K
+	select LEDS_OFFLOAD_TRIGGERS
+	help
+	  This enabled support for LEDs present on the Qualcomm Atheros
+	  QCA8K Ethernet switch chips. This require the LEDs offload
+	  triggers support as it can run in offload mode.
+
 source "drivers/net/dsa/realtek/Kconfig"
 
 config NET_DSA_SMSC_LAN9303
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index e73838c12256..5965b59e1ff7 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
 obj-$(CONFIG_NET_DSA_MT7530)	+= mt7530.o
 obj-$(CONFIG_NET_DSA_MV88E6060) += mv88e6060.o
 obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
+obj-$(CONFIG_NET_DSA_QCA8K_LEDS_SUPPORT) += qca8k-leds.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_I2C) += lan9303_i2c.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_MDIO) += lan9303_mdio.o
diff --git a/drivers/net/dsa/qca8k-leds.c b/drivers/net/dsa/qca8k-leds.c
new file mode 100644
index 000000000000..261888ad95a9
--- /dev/null
+++ b/drivers/net/dsa/qca8k-leds.c
@@ -0,0 +1,408 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <net/dsa.h>
+#include <linux/regmap.h>
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
+qca8k_parse_netdev(unsigned long rules, u32 *offload_trigger, u32 *mask)
+{
+	/* Parsing specific to netdev trigger */
+	if (test_bit(TRIGGER_NETDEV_LINK, &rules))
+		*offload_trigger = QCA8K_LED_LINK_10M_EN_MASK |
+				   QCA8K_LED_LINK_100M_EN_MASK |
+				   QCA8K_LED_LINK_1000M_EN_MASK;
+	if (test_bit(TRIGGER_NETDEV_LINK_10, &rules))
+		*offload_trigger = QCA8K_LED_LINK_10M_EN_MASK;
+	if (test_bit(TRIGGER_NETDEV_LINK_100, &rules))
+		*offload_trigger = QCA8K_LED_LINK_100M_EN_MASK;
+	if (test_bit(TRIGGER_NETDEV_LINK_1000, &rules))
+		*offload_trigger = QCA8K_LED_LINK_1000M_EN_MASK;
+	if (test_bit(TRIGGER_NETDEV_HALF_DUPLEX, &rules))
+		*offload_trigger = QCA8K_LED_HALF_DUPLEX_MASK;
+	if (test_bit(TRIGGER_NETDEV_FULL_DUPLEX, &rules))
+		*offload_trigger = QCA8K_LED_FULL_DUPLEX_MASK;
+	if (test_bit(TRIGGER_NETDEV_TX, &rules))
+		*offload_trigger = QCA8K_LED_TX_BLINK_MASK;
+	if (test_bit(TRIGGER_NETDEV_RX, &rules))
+		*offload_trigger = QCA8K_LED_RX_BLINK_MASK;
+	if (test_bit(TRIGGER_NETDEV_BLINK_2HZ, &rules))
+		*offload_trigger = QCA8K_LED_BLINK_2HZ;
+	if (test_bit(TRIGGER_NETDEV_BLINK_4HZ, &rules))
+		*offload_trigger = QCA8K_LED_BLINK_4HZ;
+	if (test_bit(TRIGGER_NETDEV_BLINK_8HZ, &rules))
+		*offload_trigger = QCA8K_LED_BLINK_8HZ;
+
+	pr_info("OFFLOAD TRIGGER %x\n", *offload_trigger);
+
+	if (!*offload_trigger)
+		return -EOPNOTSUPP;
+
+	if (test_bit(TRIGGER_NETDEV_BLINK_2HZ, &rules) ||
+	    test_bit(TRIGGER_NETDEV_BLINK_4HZ, &rules) ||
+	    test_bit(TRIGGER_NETDEV_BLINK_8HZ, &rules)) {
+		*mask = QCA8K_LED_BLINK_FREQ_MASK;
+	} else {
+		*mask = *offload_trigger;
+	}
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
+	if (strcmp(trigger->name, "netdev"))
+		return -EOPNOTSUPP;
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
+		/* We reach this point, we are sure the trigger is supported */
+		return 1;
+	case BLINK_MODE_ZERO:
+		/* We set 4hz by default */
+		u32 default_reg = QCA8K_LED_BLINK_4HZ;
+
+		ret = regmap_update_bits(priv->regmap, reg_info.reg,
+					 QCA8K_LED_RULE_MASK << reg_info.shift,
+					 default_reg << reg_info.shift);
+		break;
+	case BLINK_MODE_ENABLE:
+		ret = regmap_update_bits(priv->regmap, reg_info.reg,
+					 mask << reg_info.shift,
+					 offload_trigger << reg_info.shift);
+		break;
+	case BLINK_MODE_DISABLE:
+		ret = regmap_update_bits(priv->regmap, reg_info.reg,
+					 mask << reg_info.shift,
+					 0);
+		break;
+	case BLINK_MODE_READ:
+		ret = regmap_read(priv->regmap, reg_info.reg, &val);
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
+	regmap_update_bits(priv->regmap, reg_info.reg,
+			   GENMASK(1, 0) << reg_info.shift,
+			   val << reg_info.shift);
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
+	ret = regmap_read(priv->regmap, reg_info.reg, &val);
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
+	regmap_update_bits(priv->regmap, reg_info.reg,
+			   GENMASK(1, 0) << reg_info.shift,
+			   QCA8K_LED_ALWAYS_BLINK_4HZ << reg_info.shift);
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
+	return regmap_update_bits(priv->regmap, reg_info.reg,
+				  GENMASK(1, 0) << reg_info.shift,
+				  val << reg_info.shift);
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
+	regmap_read(priv->regmap, reg_info.reg, &val);
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
+		/* Reg represent the led number of the port.
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
index d3ed0a7f8077..ea658f1c586a 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2889,6 +2889,10 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	ret = qca8k_setup_led_ctrl(priv);
+	if (ret)
+		return ret;
+
 	qca8k_setup_pcs(priv, &priv->pcs_port_0, 0);
 	qca8k_setup_pcs(priv, &priv->pcs_port_6, 6);
 
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index f375627174c8..92c5ae12e4b0 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/regmap.h>
 #include <linux/gpio.h>
+#include <linux/leds.h>
 #include <linux/dsa/tag_qca.h>
 
 #define QCA8K_ETHERNET_MDIO_PRIORITY			7
@@ -85,6 +86,43 @@
 #define   QCA8K_MDIO_MASTER_DATA(x)			FIELD_PREP(QCA8K_MDIO_MASTER_DATA_MASK, x)
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
@@ -382,6 +420,19 @@ struct qca8k_pcs {
 	int port;
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
@@ -405,6 +456,7 @@ struct qca8k_priv {
 	struct qca8k_mdio_cache mdio_cache;
 	struct qca8k_pcs pcs_port_0;
 	struct qca8k_pcs pcs_port_6;
+	struct qca8k_led ports_led[QCA8K_LED_COUNT];
 };
 
 struct qca8k_mib_desc {
@@ -420,4 +472,13 @@ struct qca8k_fdb {
 	u8 mac[6];
 };
 
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
2.34.1

