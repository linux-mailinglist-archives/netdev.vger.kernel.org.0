Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C3E6E4CAC
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjDQPTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjDQPTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:19:25 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65315B74D;
        Mon, 17 Apr 2023 08:19:15 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id gw13so13986577wmb.3;
        Mon, 17 Apr 2023 08:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744754; x=1684336754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z3lHJDqF6OP6TWvuWg3fPupOz/b881z+2tbQHKKhm9I=;
        b=Snk3g2gXry6wKQ7leskdLgLc7TDJCzldENsjA1FlB8dykAELy3HkWQYnXvdK9Jnvgf
         6iTDw5PFH4nmbaYrI0dXPEs9aNGLOTzp/RQg2me4UKsbBCJyRJIM2bOxPu1x2bSKFv7y
         I2Kcx3MhvHdkuHPmMX/Ti6c6oHjtlSD+smyiJN6/R4tux+fq4mo9kIJZz5k4mYkAV1qO
         a6P4aJLrVrie9lbifc9PGeGdfoPQodo92qn0keap0/V3HqRpywW2yhrY3qXnM3ul6ti7
         JG0GVLT+2YjxvL/8oVRIYCqCFSwxwCdSeUVpzdIPBJnDW7FZtGcObKYm7ObUD2YdXwwk
         in3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744754; x=1684336754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z3lHJDqF6OP6TWvuWg3fPupOz/b881z+2tbQHKKhm9I=;
        b=NYSO1kpU1+5jOPVRDPHUp9l7HVOg2f37RPfWhuJBf/6/zFVP33nzjPElFJtHI2nTIu
         oND94xw5809gSjSV4sVUhjasSCozPmf03R4ByXwONIfzoKkhTueRN5QFLOq67GOEi5Ot
         VIBF9VaF/GxaJ3N5c1K94tR8G51Q8Sb98rO6w0M531D4s4BbDEAVe+oTui6MloPiZvji
         rG5ChsXLB8ZiZTGOvLXJVzyuz+6zeFLbEG5kyjQDhu6Ln5WBd+CzfVhc699Or07/tQ8b
         /AoJno3mT1eVdYvhfYTdNKwmcrUMKobo+ukZY6iRlbK6ghs35m7Djn0Yf9Pe7BUETZ/j
         T2Cg==
X-Gm-Message-State: AAQBX9d9E0wTKPv4iom/MkRZDTrqG9pLXdg/HzKAngMbyYmTeqGWk7CN
        MtVAL2OTQNDEpOf8GsA5CZQ=
X-Google-Smtp-Source: AKy350bdnF/lcUBujtCuP7tVrUqqPiZJRK73sGppsCEIxLKiDrswr9DqQDlvrEoLy72/hSv08pcTaw==
X-Received: by 2002:a05:600c:1c20:b0:3f1:6fb4:5645 with SMTP id j32-20020a05600c1c2000b003f16fb45645mr5413253wms.1.1681744753548;
        Mon, 17 Apr 2023 08:19:13 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c1c0f00b003f173be2ccfsm3501354wms.2.2023.04.17.08.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:18:51 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [net-next PATCH v7 02/16] net: dsa: qca8k: add LEDs basic support
Date:   Mon, 17 Apr 2023 17:17:24 +0200
Message-Id: <20230417151738.19426-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417151738.19426-1-ansuelsmth@gmail.com>
References: <20230417151738.19426-1-ansuelsmth@gmail.com>
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

Add LEDs basic support for qca8k Switch Family by adding basic
brightness_set() support.

Since these LEDs refelect port status, the default label is set to
":port". DT binding should describe the color and function of the
LEDs using standard LEDs api.
Each LED always have the device name as prefix. The device name is
composed from the mii bus id and the PHY addr resulting in example
names like:
- qca8k-0.0:00:amber:lan
- qca8k-0.0:00:white:lan
- qca8k-0.0:01:amber:lan
- qca8k-0.0:01:white:lan

These LEDs supports only blocking variant of the brightness_set()
function since they can sleep during access of the switch leds to set
the brightness.

While at it add to the qca8k header file each mode defined by the Switch
Documentation for future use.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/Kconfig      |   8 ++
 drivers/net/dsa/qca/Makefile     |   3 +
 drivers/net/dsa/qca/qca8k-8xxx.c |   5 +
 drivers/net/dsa/qca/qca8k-leds.c | 239 +++++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h      |  60 ++++++++
 drivers/net/dsa/qca/qca8k_leds.h |  16 +++
 6 files changed, 331 insertions(+)
 create mode 100644 drivers/net/dsa/qca/qca8k-leds.c
 create mode 100644 drivers/net/dsa/qca/qca8k_leds.h

diff --git a/drivers/net/dsa/qca/Kconfig b/drivers/net/dsa/qca/Kconfig
index ba339747362c..7a86d6d6a246 100644
--- a/drivers/net/dsa/qca/Kconfig
+++ b/drivers/net/dsa/qca/Kconfig
@@ -15,3 +15,11 @@ config NET_DSA_QCA8K
 	help
 	  This enables support for the Qualcomm Atheros QCA8K Ethernet
 	  switch chips.
+
+config NET_DSA_QCA8K_LEDS_SUPPORT
+	bool "Qualcomm Atheros QCA8K Ethernet switch family LEDs support"
+	depends on NET_DSA_QCA8K
+	depends on LEDS_CLASS
+	help
+	  This enabled support for LEDs present on the Qualcomm Atheros
+	  QCA8K Ethernet switch chips.
diff --git a/drivers/net/dsa/qca/Makefile b/drivers/net/dsa/qca/Makefile
index 701f1d199e93..ce66b1984e5f 100644
--- a/drivers/net/dsa/qca/Makefile
+++ b/drivers/net/dsa/qca/Makefile
@@ -2,3 +2,6 @@
 obj-$(CONFIG_NET_DSA_AR9331)	+= ar9331.o
 obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
 qca8k-y 			+= qca8k-common.o qca8k-8xxx.o
+ifdef CONFIG_NET_DSA_QCA8K_LEDS_SUPPORT
+qca8k-y				+= qca8k-leds.o
+endif
diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 20acbd0292f1..6d5ac7588a69 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -22,6 +22,7 @@
 #include <linux/dsa/tag_qca.h>
 
 #include "qca8k.h"
+#include "qca8k_leds.h"
 
 static void
 qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
@@ -1782,6 +1783,10 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	ret = qca8k_setup_led_ctrl(priv);
+	if (ret)
+		return ret;
+
 	qca8k_setup_pcs(priv, &priv->pcs_port_0, 0);
 	qca8k_setup_pcs(priv, &priv->pcs_port_6, 6);
 
diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
new file mode 100644
index 000000000000..0146ee12d34c
--- /dev/null
+++ b/drivers/net/dsa/qca/qca8k-leds.c
@@ -0,0 +1,239 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/regmap.h>
+#include <net/dsa.h>
+
+#include "qca8k.h"
+#include "qca8k_leds.h"
+
+static int
+qca8k_get_enable_led_reg(int port_num, int led_num, struct qca8k_led_pattern_en *reg_info)
+{
+	switch (port_num) {
+	case 0:
+		reg_info->reg = QCA8K_LED_CTRL_REG(led_num);
+		reg_info->shift = QCA8K_LED_PHY0123_CONTROL_RULE_SHIFT;
+		break;
+	case 1:
+	case 2:
+	case 3:
+		/* Port 123 are controlled on a different reg */
+		reg_info->reg = QCA8K_LED_CTRL3_REG;
+		reg_info->shift = QCA8K_LED_PHY123_PATTERN_EN_SHIFT(port_num, led_num);
+		break;
+	case 4:
+		reg_info->reg = QCA8K_LED_CTRL_REG(led_num);
+		reg_info->shift = QCA8K_LED_PHY4_CONTROL_RULE_SHIFT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+qca8k_led_brightness_set(struct qca8k_led *led,
+			 enum led_brightness brightness)
+{
+	struct qca8k_led_pattern_en reg_info;
+	struct qca8k_priv *priv = led->priv;
+	u32 mask, val;
+
+	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
+
+	val = QCA8K_LED_ALWAYS_OFF;
+	if (brightness)
+		val = QCA8K_LED_ALWAYS_ON;
+
+	/* HW regs to control brightness is special and port 1-2-3
+	 * are placed in a different reg.
+	 *
+	 * To control port 0 brightness:
+	 * - the 2 bit (15, 14) of:
+	 *   - QCA8K_LED_CTRL0_REG for led1
+	 *   - QCA8K_LED_CTRL1_REG for led2
+	 *   - QCA8K_LED_CTRL2_REG for led3
+	 *
+	 * To control port 4:
+	 * - the 2 bit (31, 30) of:
+	 *   - QCA8K_LED_CTRL0_REG for led1
+	 *   - QCA8K_LED_CTRL1_REG for led2
+	 *   - QCA8K_LED_CTRL2_REG for led3
+	 *
+	 * To control port 1:
+	 *   - the 2 bit at (9, 8) of QCA8K_LED_CTRL3_REG are used for led1
+	 *   - the 2 bit at (11, 10) of QCA8K_LED_CTRL3_REG are used for led2
+	 *   - the 2 bit at (13, 12) of QCA8K_LED_CTRL3_REG are used for led3
+	 *
+	 * To control port 2:
+	 *   - the 2 bit at (15, 14) of QCA8K_LED_CTRL3_REG are used for led1
+	 *   - the 2 bit at (17, 16) of QCA8K_LED_CTRL3_REG are used for led2
+	 *   - the 2 bit at (19, 18) of QCA8K_LED_CTRL3_REG are used for led3
+	 *
+	 * To control port 3:
+	 *   - the 2 bit at (21, 20) of QCA8K_LED_CTRL3_REG are used for led1
+	 *   - the 2 bit at (23, 22) of QCA8K_LED_CTRL3_REG are used for led2
+	 *   - the 2 bit at (25, 24) of QCA8K_LED_CTRL3_REG are used for led3
+	 *
+	 * To abstract this and have less code, we use the port and led numm
+	 * to calculate the shift and the correct reg due to this problem of
+	 * not having a 1:1 map of LED with the regs.
+	 */
+	if (led->port_num == 0 || led->port_num == 4) {
+		mask = QCA8K_LED_PATTERN_EN_MASK;
+		val <<= QCA8K_LED_PATTERN_EN_SHIFT;
+	} else {
+		mask = QCA8K_LED_PHY123_PATTERN_EN_MASK;
+	}
+
+	return regmap_update_bits(priv->regmap, reg_info.reg,
+				  mask << reg_info.shift,
+				  val << reg_info.shift);
+}
+
+static int
+qca8k_cled_brightness_set_blocking(struct led_classdev *ldev,
+				   enum led_brightness brightness)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+
+	return qca8k_led_brightness_set(led, brightness);
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
+
+	if (led->port_num == 0 || led->port_num == 4) {
+		val &= QCA8K_LED_PATTERN_EN_MASK;
+		val >>= QCA8K_LED_PATTERN_EN_SHIFT;
+	} else {
+		val &= QCA8K_LED_PHY123_PATTERN_EN_MASK;
+	}
+
+	/* Assume brightness ON only when the LED is set to always ON */
+	return val == QCA8K_LED_ALWAYS_ON;
+}
+
+static int
+qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int port_num)
+{
+	struct fwnode_handle *led = NULL, *leds = NULL;
+	struct led_init_data init_data = { };
+	struct dsa_switch *ds = priv->ds;
+	enum led_default_state state;
+	struct qca8k_led *port_led;
+	int led_num, led_index;
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
+		 * Each port can have at most 3 leds attached
+		 * Commonly:
+		 * 1. is gigabit led
+		 * 2. is mbit led
+		 * 3. additional status led
+		 */
+		if (fwnode_property_read_u32(led, "reg", &led_num))
+			continue;
+
+		if (led_num >= QCA8K_LED_PORT_COUNT) {
+			dev_warn(priv->dev, "Invalid LED reg %d defined for port %d",
+				 led_num, port_num);
+			continue;
+		}
+
+		led_index = QCA8K_LED_PORT_INDEX(port_num, led_num);
+
+		port_led = &priv->ports_led[led_index];
+		port_led->port_num = port_num;
+		port_led->led_num = led_num;
+		port_led->priv = priv;
+
+		state = led_init_default_state_get(led);
+		switch (state) {
+		case LEDS_DEFSTATE_ON:
+			port_led->cdev.brightness = 1;
+			qca8k_led_brightness_set(port_led, 1);
+			break;
+		case LEDS_DEFSTATE_KEEP:
+			port_led->cdev.brightness =
+					qca8k_led_brightness_get(port_led);
+			break;
+		default:
+			port_led->cdev.brightness = 0;
+			qca8k_led_brightness_set(port_led, 0);
+		}
+
+		port_led->cdev.max_brightness = 1;
+		port_led->cdev.brightness_set_blocking = qca8k_cled_brightness_set_blocking;
+		init_data.default_label = ":port";
+		init_data.fwnode = led;
+		init_data.devname_mandatory = true;
+		init_data.devicename = kasprintf(GFP_KERNEL, "%s:0%d", ds->slave_mii_bus->id,
+						 port_num);
+		if (!init_data.devicename)
+			return -ENOMEM;
+
+		ret = devm_led_classdev_register_ext(priv->dev, &port_led->cdev, &init_data);
+		if (ret)
+			dev_warn(priv->dev, "Failed to init LED %d for port %d", led_num, port_num);
+
+		kfree(init_data.devicename);
+	}
+
+	return 0;
+}
+
+int
+qca8k_setup_led_ctrl(struct qca8k_priv *priv)
+{
+	struct fwnode_handle *ports, *port;
+	int port_num;
+	int ret;
+
+	ports = device_get_named_child_node(priv->dev, "ports");
+	if (!ports) {
+		dev_info(priv->dev, "No ports node specified in device tree!");
+		return 0;
+	}
+
+	fwnode_for_each_child_node(ports, port) {
+		if (fwnode_property_read_u32(port, "reg", &port_num))
+			continue;
+
+		/* Skip checking for CPU port 0 and CPU port 6 as not supported */
+		if (port_num == 0 || port_num == 6)
+			continue;
+
+		/* Each port can have at most 3 different leds attached.
+		 * Switch port starts from 0 to 6, but port 0 and 6 are CPU
+		 * port. The port index needs to be decreased by one to identify
+		 * the correct port for LED setup.
+		 */
+		ret = qca8k_parse_port_leds(priv, port, qca8k_port_to_phy(port_num));
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index dd7deb9095d3..c5cc8a172d65 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/regmap.h>
 #include <linux/gpio.h>
+#include <linux/leds.h>
 #include <linux/dsa/tag_qca.h>
 
 #define QCA8K_ETHERNET_MDIO_PRIORITY			7
@@ -85,6 +86,51 @@
 #define   QCA8K_MDIO_MASTER_DATA(x)			FIELD_PREP(QCA8K_MDIO_MASTER_DATA_MASK, x)
 #define   QCA8K_MDIO_MASTER_MAX_PORTS			5
 #define   QCA8K_MDIO_MASTER_MAX_REG			32
+
+/* LED control register */
+#define QCA8K_LED_PORT_COUNT				3
+#define QCA8K_LED_COUNT					((QCA8K_NUM_PORTS - QCA8K_NUM_CPU_PORTS) * QCA8K_LED_PORT_COUNT)
+#define QCA8K_LED_RULE_COUNT				6
+#define QCA8K_LED_RULE_MAX				11
+#define QCA8K_LED_PORT_INDEX(_phy, _led)		(((_phy) * QCA8K_LED_PORT_COUNT) + (_led))
+
+#define QCA8K_LED_PHY123_PATTERN_EN_SHIFT(_phy, _led)	((((_phy) - 1) * 6) + 8 + (2 * (_led)))
+#define QCA8K_LED_PHY123_PATTERN_EN_MASK		GENMASK(1, 0)
+
+#define QCA8K_LED_PHY0123_CONTROL_RULE_SHIFT		0
+#define QCA8K_LED_PHY4_CONTROL_RULE_SHIFT		16
+
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
@@ -382,6 +428,19 @@ struct qca8k_pcs {
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
@@ -406,6 +465,7 @@ struct qca8k_priv {
 	struct qca8k_pcs pcs_port_0;
 	struct qca8k_pcs pcs_port_6;
 	const struct qca8k_match_data *info;
+	struct qca8k_led ports_led[QCA8K_LED_COUNT];
 };
 
 struct qca8k_mib_desc {
diff --git a/drivers/net/dsa/qca/qca8k_leds.h b/drivers/net/dsa/qca/qca8k_leds.h
new file mode 100644
index 000000000000..ab367f05b173
--- /dev/null
+++ b/drivers/net/dsa/qca/qca8k_leds.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __QCA8K_LEDS_H
+#define __QCA8K_LEDS_H
+
+/* Leds Support function */
+#ifdef CONFIG_NET_DSA_QCA8K_LEDS_SUPPORT
+int qca8k_setup_led_ctrl(struct qca8k_priv *priv);
+#else
+static inline int qca8k_setup_led_ctrl(struct qca8k_priv *priv)
+{
+	return 0;
+}
+#endif
+
+#endif /* __QCA8K_LEDS_H */
-- 
2.39.2

