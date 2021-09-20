Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3285412BC8
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 04:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350739AbhIUChi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 22:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241009AbhIUCBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:01:16 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF173C02FF51;
        Mon, 20 Sep 2021 11:09:15 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id q26so32180485wrc.7;
        Mon, 20 Sep 2021 11:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XcFuxVXPh2s1ALb74BpYY2k4VkT5gpurCWkWtBWtDg0=;
        b=TB8rkIDvsHoXx5Gz7VNloYpiTyctbOy5cf+X6WlfRu5Z0pGRnBp/pFYkXBINH1vRCz
         prQbbVTx8PT2QU96kIDg93DhzHFQRzNKN3Jlqf3vYk6gZknevGlRl6AM8W+BuY23cN1y
         HGNMeChVzGPLiGNUHdlBeUvmgSFSBLJbxUbQA+urOBbibse8SxXl6JxBMwD3HH70P8jI
         bzFpsoQ9t6AbmQHSEIwq56++dFFjrcDeFagaJeMJJd5Jz7rGrf6pJfnQHddYA8lsf/XG
         zQSUnTmD3JxJsNR6Q7BePK+vC/ZoS14g4LNDNYK3S7G/HClmSn1ep4IKEnC+eU2ymz0q
         O1Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XcFuxVXPh2s1ALb74BpYY2k4VkT5gpurCWkWtBWtDg0=;
        b=ICz2GNbFlE/0udoFqIf3ZjG8qMe+QoUWFtbRDfgd2TRC5k7VneQaslYaoNFX7hcG/i
         /uXV/H31POusjYNkgRssIj+fOUFQTxgnqpHU9+k87oar6zSHIwglzNSwHv0ciH2JbOgg
         AJygGyM8P9MNTx9hR8WaCCL+Dra8ZaeNtWH62Ue4xSE3qVSJ/djkrvUgD2nPW8af1bZH
         OT4UHJ7X8U8lj5p6wqeAUPFfsmyupfsShglanRou5JeVn1w/4gL7gZXgTivaEH85V9xx
         0O7YNXNTHdEuUvH18X6CR9RC0JEP8Lx6e/MMLgS9J230zI0AlkBjTRU53yU+MfF9012R
         0egQ==
X-Gm-Message-State: AOAM531MufoP99Lbt51tyLzbpX3CoV/kdRyUWN/WhDzai8XdH+4zHSYp
        3IAy9PJwTA6Sa7VwmSJAwCk=
X-Google-Smtp-Source: ABdhPJx/h4i3Y+OzzlPRG6VDATwp1DTlTx5BpOCJmc1CgwDfGvOC0CMUx0X1sR1RNVUppcaF4LLO7Q==
X-Received: by 2002:a05:6000:1866:: with SMTP id d6mr22065367wri.141.1632161354274;
        Mon, 20 Sep 2021 11:09:14 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-67-254.ip85.fastwebnet.it. [93.42.67.254])
        by smtp.googlemail.com with ESMTPSA id w14sm16618646wro.8.2021.09.20.11.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 11:09:13 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH 1/2] drivers: net: dsa: qca8k: add support for led config
Date:   Mon, 20 Sep 2021 20:08:50 +0200
Message-Id: <20210920180851.30762-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for led control and led toggle.
qca8337 and qca8327 switch have various reg to control port leds.
The current implementation permit to toggle them on/off and to declare
their blink rules based on the entry in the dts.
They can also be declared in userspace by the "control_rule" entry in
the led sysfs. When hw_mode is active (set by default) the leds blink
based on the control_rule. There are 6 total control rule.
Control rule that applies to phy0-3 commonly used for lan port.
Control rule that applies to phy4 commonly used for wan port.
Each phy port (5 in total) can have a maximum of 3 different leds
attached. Each led can be turned off, blink at 4hz, off or set to
hw_mode and follow their respecitve control rule. The hw_mode can be
toggled using the sysfs entry and will be disabled on brightness or
blink set.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 490 +++++++++++++++++++++++++++++++++++++++-
 drivers/net/dsa/qca8k.h |  50 ++++
 2 files changed, 536 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index bda5a9bf4f52..56385a80987f 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -18,6 +18,7 @@
 #include <linux/phylink.h>
 #include <linux/gpio/consumer.h>
 #include <linux/etherdevice.h>
+#include <linux/leds.h>
 
 #include "qca8k.h"
 
@@ -950,6 +951,467 @@ qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
 	return 0;
 }
 
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
+qca8k_setup_led_rules(struct qca8k_led *led, struct fwnode_handle *node)
+{
+	struct qca8k_led_pattern_en reg_info;
+	const char **rules;
+	int i, count, ret;
+	const char *rule;
+	u32 val = 0;
+
+	if (!fwnode_property_present(node, "qca,led_rules"))
+		return 0;
+
+	rules = kcalloc(QCA8K_LED_RULE_MAX, sizeof(*rules), GFP_KERNEL);
+	if (!rules)
+		return -ENOMEM;
+
+	ret = fwnode_property_read_string_array(node, "qca,led_rules", rules, QCA8K_LED_RULE_MAX);
+	if (ret < 0)
+		return ret;
+
+	count = (unsigned int)ret;
+
+	for (i = 0; i < count; i++) {
+		rule = rules[i];
+
+		if (!strcmp(rule, "tx-blink"))
+			val |= QCA8K_LED_TX_BLINK_MASK;
+
+		if (!strcmp(rule, "rx-blink"))
+			val |= QCA8K_LED_RX_BLINK_MASK;
+
+		if (!strcmp(rule, "collision-blink"))
+			val |= QCA8K_LED_COL_BLINK_MASK;
+
+		if (!strcmp(rule, "link-10M"))
+			val |= QCA8K_LED_LINK_10M_EN_MASK;
+
+		if (!strcmp(rule, "link-100M"))
+			val |= QCA8K_LED_LINK_100M_EN_MASK;
+
+		if (!strcmp(rule, "link-1000M"))
+			val |= QCA8K_LED_LINK_1000M_EN_MASK;
+
+		if (!strcmp(rule, "half-duplex"))
+			val |= QCA8K_LED_HALF_DUPLEX_MASK;
+
+		if (!strcmp(rule, "full-duplex"))
+			val |= QCA8K_LED_FULL_DUPLEX_MASK;
+
+		if (!strcmp(rule, "linkup-over"))
+			val |= QCA8K_LED_LINKUP_OVER_MASK;
+
+		if (!strcmp(rule, "power-on-reset"))
+			val |= QCA8K_LED_POWER_ON_LIGHT_MASK;
+
+		if (!(val & QCA8K_LED_BLINK_FREQ_MASK)) {
+			if (!strcmp(rule, "blink-2hz"))
+				val |= QCA8K_LED_BLINK_2HZ << QCA8K_LED_BLINK_FREQ_SHITF;
+			else if (!strcmp(rule, "blink-4hz"))
+				val |= QCA8K_LED_BLINK_4HZ << QCA8K_LED_BLINK_FREQ_SHITF;
+			else if (!strcmp(rule, "blink-8hz"))
+				val |= QCA8K_LED_BLINK_8HZ << QCA8K_LED_BLINK_FREQ_SHITF;
+			else if (!strcmp(rule, "blink-auto"))
+				val |= QCA8K_LED_BLINK_AUTO << QCA8K_LED_BLINK_FREQ_SHITF;
+		}
+	}
+
+	kfree(rules);
+
+	qca8k_get_control_led_reg(led->port_num, led->led_num, &reg_info);
+
+	ret = qca8k_rmw(led->priv, reg_info.reg,
+			QCA8K_LED_CTRL_MASK << reg_info.shift,
+			val << reg_info.shift);
+
+	return ret;
+}
+
+static ssize_t
+control_rule_show(struct device *dev, struct device_attribute *attr,
+		  char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct qca8k_led *led = container_of(led_cdev, struct qca8k_led, cdev);
+	struct qca8k_led_pattern_en reg_info;
+	u32 value;
+	int ret;
+
+	qca8k_get_control_led_reg(led->port_num, led->led_num, &reg_info);
+
+	ret = qca8k_read(led->priv, reg_info.reg, &value);
+	if (ret)
+		return sprintf(buf, "Error reading control rule\n");
+
+	value >>= reg_info.shift;
+	value &= QCA8K_LED_CTRL_MASK;
+
+	return sprintf(buf, "%x\n", value);
+}
+
+static ssize_t
+control_rule_store(struct device *dev,
+		   struct device_attribute *attr, const char *buf,
+		   size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct qca8k_led *led = container_of(led_cdev, struct qca8k_led, cdev);
+	struct qca8k_led_pattern_en reg_info;
+	ssize_t status;
+	long value;
+	int ret;
+
+	status = kstrtol(buf, 0, &value);
+	if (status)
+		return status;
+
+	if (value < 0)
+		return -EINVAL;
+
+	qca8k_get_control_led_reg(led->port_num, led->led_num, &reg_info);
+
+	value &= QCA8K_LED_CTRL_MASK;
+
+	ret = qca8k_rmw(led->priv, reg_info.reg,
+			QCA8K_LED_CTRL_MASK << reg_info.shift,
+			value << reg_info.shift);
+	if (ret)
+		return ret;
+
+	return size;
+}
+
+static ssize_t
+hw_mode_show(struct device *dev, struct device_attribute *attr,
+	     char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct qca8k_led *led = container_of(led_cdev, struct qca8k_led, cdev);
+	struct qca8k_led_pattern_en reg_info;
+	u32 value;
+	int ret;
+
+	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
+
+	ret = qca8k_read(led->priv, reg_info.reg, &value);
+	if (ret)
+		return sprintf(buf, "Error reading hw mode\n");
+
+	value >>= reg_info.shift;
+	value &= GENMASK(1, 0);
+
+	return sprintf(buf, "%x\n", value == QCA8K_LED_RULE_CONTROLLED ? 1 : 0);
+}
+
+static ssize_t
+hw_mode_store(struct device *dev,
+	      struct device_attribute *attr, const char *buf,
+	      size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct qca8k_led *led = container_of(led_cdev, struct qca8k_led, cdev);
+	struct qca8k_led_pattern_en reg_info;
+	ssize_t status;
+	long value;
+	int ret;
+
+	status = kstrtol(buf, 0, &value);
+	if (status)
+		return status;
+
+	if (value < 0)
+		return -EINVAL;
+
+	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
+
+	if (value)
+		value = QCA8K_LED_RULE_CONTROLLED;
+
+	value &= GENMASK(1, 0);
+
+	ret = qca8k_rmw(led->priv, reg_info.reg,
+			GENMASK(1, 0) << reg_info.shift,
+			value << reg_info.shift);
+	if (ret)
+		return ret;
+
+	return size;
+}
+
+static DEVICE_ATTR_RW(control_rule);
+static DEVICE_ATTR_RW(hw_mode);
+
+/* Each led have a enable hw_mode and optionally a way to set control rule */
+static struct attribute *qca8k_leds_attrs[] = {
+	&dev_attr_hw_mode.attr,
+	&dev_attr_control_rule.attr,
+	NULL,
+};
+
+static struct attribute_group qca8k_leds_rule_group = {
+	.attrs = qca8k_leds_attrs,
+};
+
+static const struct attribute_group *qca8k_leds_groups[] = {
+	&qca8k_leds_rule_group,
+	NULL,
+};
+
+static void
+qca8k_led_brightness_set(struct qca8k_led *led,
+			 enum led_brightness b)
+{
+	struct qca8k_led_pattern_en reg_info;
+	u32 val = QCA8K_LED_ALWAYS_OFF;
+
+	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
+
+	if (b)
+		val = QCA8K_LED_ALWAYS_ON;
+
+	qca8k_rmw(led->priv, reg_info.reg,
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
+	u32 val;
+	int ret;
+
+	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
+
+	ret = qca8k_read(led->priv, reg_info.reg, &val);
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
+	qca8k_rmw(led->priv, reg_info.reg,
+		  GENMASK(1, 0) << reg_info.shift,
+		  QCA8K_LED_ALWAYS_BLINK_4HZ << reg_info.shift);
+
+	return 0;
+}
+
+static void
+qca8k_cled_flash_resume(struct led_classdev *ldev)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+	struct qca8k_led_pattern_en reg_info;
+
+	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
+	qca8k_rmw(led->priv, reg_info.reg,
+		  GENMASK(1, 0) << reg_info.shift,
+		  led->old_pattern << reg_info.shift);
+}
+
+static int
+qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int port_num)
+{
+	struct led_init_data init_data = { };
+	struct fwnode_handle *led = NULL;
+	struct qca8k_led *port_led;
+	int led_num, port_index;
+	const char *state;
+	int ret;
+
+	fwnode_for_each_child_node(port, led) {
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
+		port_led->cdev.flash_resume = qca8k_cled_flash_resume;
+		port_led->cdev.groups = qca8k_leds_groups;
+		port_led->cdev.flags |= LED_CORE_SUSPENDRESUME;
+		init_data.default_label = ":port";
+		init_data.devicename = "qca8k";
+		init_data.fwnode = led;
+
+		/* Provide control rule first lan port and wan port.
+		 * Lan port 2-3-4 follow first lan port control rule if the hw mode
+		 * is active.
+		 * The control_rule sysfs refer to the same reg for lan port (phy0-3)
+		 */
+		ret = qca8k_setup_led_rules(port_led, led);
+		if (ret)
+			dev_warn(priv->dev, "Failed to apply led control rules for %s",
+				 port_led->cdev.name);
+
+		ret = devm_led_classdev_register_ext(priv->dev, &port_led->cdev, &init_data);
+		if (ret)
+			dev_warn(priv->dev, "Failed to int led");
+	}
+
+	return 0;
+}
+
+static int
+qca8k_setup_led_ctrl(struct qca8k_priv *priv)
+{
+	struct fwnode_handle *leds, *port;
+	int port_num;
+	int ret;
+
+	leds = device_get_named_child_node(priv->dev, "leds");
+	if (!leds) {
+		dev_info(priv->dev, "No LEDs specified in device tree!\n");
+		return 0;
+	}
+
+	fwnode_for_each_child_node(leds, port) {
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
+
 static int
 qca8k_setup(struct dsa_switch *ds)
 {
@@ -979,6 +1441,10 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	ret = qca8k_setup_led_ctrl(priv);
+	if (ret)
+		return ret;
+
 	/* Enable CPU Port */
 	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
 			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
@@ -1890,13 +2356,29 @@ qca8k_sw_remove(struct mdio_device *mdiodev)
 static void
 qca8k_set_pm(struct qca8k_priv *priv, int enable)
 {
-	int i;
+	struct qca8k_led_pattern_en reg_info;
+	int port, led, port_index;
+	u32 val;
 
-	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
-		if (!priv->port_sts[i].enabled)
+	for (port = 0; port < QCA8K_NUM_PORTS; port++) {
+		/* Save leds state for current port */
+		for (led = 0; led < 3; led++) {
+			port_index = 3 * port + led;
+			qca8k_get_enable_led_reg(port, led, &reg_info);
+
+			if (!enable) {
+				qca8k_read(priv, reg_info.reg, &val);
+				val >>= reg_info.shift;
+				val &= GENMASK(1, 0);
+
+				priv->ports_led[port_index].old_pattern = val;
+			}
+		}
+
+		if (!priv->port_sts[port].enabled)
 			continue;
 
-		qca8k_port_set_status(priv, i, enable);
+		qca8k_port_set_status(priv, port, enable);
 	}
 }
 
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index ed3b05ad6745..6c2c85a1d610 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -64,6 +64,42 @@
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
+#define   QCA8K_LED_CTRL_MASK				GENMASK(13, 0)
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
@@ -250,6 +286,19 @@ struct qca8k_match_data {
 	u8 id;
 };
 
+struct qca8k_led_pattern_en {
+	u32 reg;
+	u8 shift;
+};
+
+struct qca8k_led {
+	u8 port_num;
+	u8 led_num;
+	u8 old_pattern;
+	struct qca8k_priv *priv;
+	struct led_classdev cdev;
+};
+
 struct qca8k_priv {
 	u8 switch_id;
 	u8 switch_revision;
@@ -265,6 +314,7 @@ struct qca8k_priv {
 	struct dsa_switch_ops ops;
 	struct gpio_desc *reset_gpio;
 	unsigned int port_mtu[QCA8K_NUM_PORTS];
+	struct qca8k_led ports_led[QCA8K_LED_COUNT];
 };
 
 struct qca8k_mib_desc {
-- 
2.32.0

