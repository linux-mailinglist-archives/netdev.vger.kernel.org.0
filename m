Return-Path: <netdev+bounces-6152-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 06EAF714E91
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:38:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0083280FA9
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 694921118E;
	Mon, 29 May 2023 16:34:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BAD1118C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 16:34:59 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABEDDC;
	Mon, 29 May 2023 09:34:56 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f6ffc2b314so9186395e9.0;
        Mon, 29 May 2023 09:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685378095; x=1687970095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I5iBEigDDB2ulS45WuE7DITMi8SCugzHw1a9vqnyc1o=;
        b=FZYHv7Exy1MX6pppkpTEcoFCQEN2UctNc7I1aVUjGuWekSOAeWprVWMatUys1Yhxbm
         /TtmaY3Mb67/MbYmm+lqu0Tj1OOI2aUEy6gnvBNGwG+XEaQVzMv0yUGliGPVfeRKDDH2
         7wJwRc7hIRH377mPduNZVw5EI1BT4Q0nQOopWFNQ6A3IBHKB1UfNOJOms70I8T+ypbke
         JqtFtFyHYDqqsTnxtgaIiiO57s5cv5B6gx5fA9pRr+Dmwga66AVHPMDYtaYVJz3s+N4B
         UUmuI2irTCDnUB9nQWY6hFQIS8Z3jGJll3l8JTmiow7KpcM27T2p6EfEPB8EruGRoOVz
         bjbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685378095; x=1687970095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I5iBEigDDB2ulS45WuE7DITMi8SCugzHw1a9vqnyc1o=;
        b=G0/OKG9U10nFlYO9lbOLuhNjNPV2UCCWlIMd9Osom610JEZrlCasaG+476Eq29ajx9
         3e8bFs8kAjOWr7u2JRU6AqWlkEuFxr4p4zk1PIwmWbTJRepmZxDhQ2TolKNDJXSF6FFa
         WzM76idGqOPaPwESpIV3UTNVXZRmhh6gF9D5AYiO3nYID/zF9yToBauHHrpqTBVDE2RD
         vNK86gAHXlhNZ32l7iNFrK98wSCqULNCnWPm5rWnhD3kpyp71RusBrcTM8QzMs0ke3Io
         eqPGW35j/SspJBx+S9vsQbq5Po3noM9/AL9dM5e7sRV+TCmaVWo7EbLGeRLNXwLo7KFO
         SEdw==
X-Gm-Message-State: AC+VfDzl6kpomwzFTU1LNDC13KQxRlBkg34xPg227omWE01B/ycFREUq
	hiizAjEPRealCr7Y6++3EWM=
X-Google-Smtp-Source: ACHHUZ5sVrwaqI1JIJvaGZpaYuR2sG0MppecZ+yiXUqHKOSgPHFT7MWAIQihj0G3yH1wwSOsAjMLhA==
X-Received: by 2002:a5d:494f:0:b0:30a:d944:b765 with SMTP id r15-20020a5d494f000000b0030ad944b765mr2544200wrs.15.1685378095045;
        Mon, 29 May 2023 09:34:55 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id h14-20020a5d6e0e000000b002ff2c39d072sm417513wrz.104.2023.05.29.09.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:34:54 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	linux-leds@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [net-next PATCH v4 12/13] net: dsa: qca8k: implement hw_control ops
Date: Mon, 29 May 2023 18:32:42 +0200
Message-Id: <20230529163243.9555-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230529163243.9555-1-ansuelsmth@gmail.com>
References: <20230529163243.9555-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement hw_control ops to drive Switch LEDs based on hardware events.

Netdev trigger is the declared supported trigger for hw control
operation and supports the following mode:
- tx
- rx

When hw_control_set is called, LEDs are set to follow the requested
mode.
Each LEDs will blink at 4Hz by default.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca/qca8k-leds.c | 154 +++++++++++++++++++++++++++++++
 1 file changed, 154 insertions(+)

diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
index b883692b7d86..1e0c61726487 100644
--- a/drivers/net/dsa/qca/qca8k-leds.c
+++ b/drivers/net/dsa/qca/qca8k-leds.c
@@ -31,6 +31,43 @@ qca8k_get_enable_led_reg(int port_num, int led_num, struct qca8k_led_pattern_en
 	return 0;
 }
 
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
+		reg_info->shift = QCA8K_LED_PHY4_CONTROL_RULE_SHIFT;
+	else
+		reg_info->shift = QCA8K_LED_PHY0123_CONTROL_RULE_SHIFT;
+
+	return 0;
+}
+
+static int
+qca8k_parse_netdev(unsigned long rules, u32 *offload_trigger)
+{
+	/* Parsing specific to netdev trigger */
+	if (test_bit(TRIGGER_NETDEV_TX, &rules))
+		*offload_trigger |= QCA8K_LED_TX_BLINK_MASK;
+	if (test_bit(TRIGGER_NETDEV_RX, &rules))
+		*offload_trigger |= QCA8K_LED_RX_BLINK_MASK;
+
+	if (rules && !*offload_trigger)
+		return -EOPNOTSUPP;
+
+	/* Enable some default rule by default to the requested mode:
+	 * - Blink at 4Hz by default
+	 */
+	*offload_trigger |= QCA8K_LED_BLINK_4HZ;
+
+	return 0;
+}
+
 static int
 qca8k_led_brightness_set(struct qca8k_led *led,
 			 enum led_brightness brightness)
@@ -164,6 +201,119 @@ qca8k_cled_blink_set(struct led_classdev *ldev,
 	return 0;
 }
 
+static int
+qca8k_cled_trigger_offload(struct led_classdev *ldev, bool enable)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+
+	struct qca8k_led_pattern_en reg_info;
+	struct qca8k_priv *priv = led->priv;
+	u32 mask, val = QCA8K_LED_ALWAYS_OFF;
+
+	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
+
+	if (enable)
+		val = QCA8K_LED_RULE_CONTROLLED;
+
+	if (led->port_num == 0 || led->port_num == 4) {
+		mask = QCA8K_LED_PATTERN_EN_MASK;
+		val <<= QCA8K_LED_PATTERN_EN_SHIFT;
+	} else {
+		mask = QCA8K_LED_PHY123_PATTERN_EN_MASK;
+	}
+
+	return regmap_update_bits(priv->regmap, reg_info.reg, mask << reg_info.shift,
+				  val << reg_info.shift);
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
+
+	if (led->port_num == 0 || led->port_num == 4) {
+		val &= QCA8K_LED_PATTERN_EN_MASK;
+		val >>= QCA8K_LED_PATTERN_EN_SHIFT;
+	} else {
+		val &= QCA8K_LED_PHY123_PATTERN_EN_MASK;
+	}
+
+	return val == QCA8K_LED_RULE_CONTROLLED;
+}
+
+static int
+qca8k_cled_hw_control_is_supported(struct led_classdev *ldev, unsigned long rules)
+{
+	u32 offload_trigger = 0;
+
+	return qca8k_parse_netdev(rules, &offload_trigger);
+}
+
+static int
+qca8k_cled_hw_control_set(struct led_classdev *ldev, unsigned long rules)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+	struct qca8k_led_pattern_en reg_info;
+	struct qca8k_priv *priv = led->priv;
+	u32 offload_trigger = 0;
+	int ret;
+
+	ret = qca8k_parse_netdev(rules, &offload_trigger);
+	if (ret)
+		return ret;
+
+	ret = qca8k_cled_trigger_offload(ldev, true);
+	if (ret)
+		return ret;
+
+	qca8k_get_control_led_reg(led->port_num, led->led_num, &reg_info);
+
+	return regmap_update_bits(priv->regmap, reg_info.reg,
+				  QCA8K_LED_RULE_MASK << reg_info.shift,
+				  offload_trigger << reg_info.shift);
+}
+
+static int
+qca8k_cled_hw_control_get(struct led_classdev *ldev, unsigned long *rules)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+	struct qca8k_led_pattern_en reg_info;
+	struct qca8k_priv *priv = led->priv;
+	u32 val;
+	int ret;
+
+	/* With hw control not active return err */
+	if (!qca8k_cled_hw_control_status(ldev))
+		return -EINVAL;
+
+	qca8k_get_control_led_reg(led->port_num, led->led_num, &reg_info);
+
+	ret = regmap_read(priv->regmap, reg_info.reg, &val);
+	if (ret)
+		return ret;
+
+	val >>= reg_info.shift;
+	val &= QCA8K_LED_RULE_MASK;
+
+	/* Parsing specific to netdev trigger */
+	if (val & QCA8K_LED_TX_BLINK_MASK)
+		set_bit(TRIGGER_NETDEV_TX, rules);
+	if (val & QCA8K_LED_RX_BLINK_MASK)
+		set_bit(TRIGGER_NETDEV_RX, rules);
+
+	return 0;
+}
+
 static int
 qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int port_num)
 {
@@ -224,6 +374,10 @@ qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int p
 		port_led->cdev.max_brightness = 1;
 		port_led->cdev.brightness_set_blocking = qca8k_cled_brightness_set_blocking;
 		port_led->cdev.blink_set = qca8k_cled_blink_set;
+		port_led->cdev.hw_control_is_supported = qca8k_cled_hw_control_is_supported;
+		port_led->cdev.hw_control_set = qca8k_cled_hw_control_set;
+		port_led->cdev.hw_control_get = qca8k_cled_hw_control_get;
+		port_led->cdev.hw_control_trigger = "netdev";
 		init_data.default_label = ":port";
 		init_data.fwnode = led;
 		init_data.devname_mandatory = true;
-- 
2.39.2


