Return-Path: <netdev+bounces-5363-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71724710EDF
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:58:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 262192815C3
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9C031D2D5;
	Thu, 25 May 2023 14:55:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC7A1D2A6
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:55:15 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1B2E56;
	Thu, 25 May 2023 07:55:06 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f6cbdf16d2so5450095e9.2;
        Thu, 25 May 2023 07:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685026504; x=1687618504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GnV/8Q85nSdt4bY7Mc+wPerU54KxDdRii/0bQKKOJsU=;
        b=CJJdkLdEFc3sFcCBBP5eXRD3ko53nizmQAFNbRTh6kR2lADzlBuH1TkoAuM7dFYGO4
         xRdntZkgPOyisaJ5A8celJXUWPeHOJzDr3bfxqHG1+uxtxgxfSQ367ZHparNkg3Fm6Ft
         op1mbDUBhMqy6hLdjHjRxGgK8kwul+BKkegJQeJ7yVAnXDjQOyCaKTxdqtfok1LIPmYS
         8KaXA6wD2kzxmN3YNK+SZXzVuxpl8oUgaoHAyRdcWcfA5eZhDkq8CcDRHaX8qO8dX5zb
         xNB3aHRkH+wjzXVqWZPsSaXYZB29LECXh0Cmaj9tRXrFydb4epoYPEV1c2moDaqMdmKW
         IXOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685026504; x=1687618504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GnV/8Q85nSdt4bY7Mc+wPerU54KxDdRii/0bQKKOJsU=;
        b=CDacvTULdpa0/7aYXEx09xKoN3B0pEBcrQghRjCNgt7HV7wmJhM7Hm0Jg/1EY3wSRl
         Q8EO80/kLlryRRf/BfPIljRyXw9nW7TKSKcYukGq6jqgPu/KEWrQQYedjvsV/F/np7US
         40+aaKgMW9EwZRVJFFcB/lrwoOP08wgG3kdBVGP0TickhUGQTUN4qhQ0BWSd005pn+9I
         +py7HNFsDt2KcAfLyAi0LtwS8nWy7oK/kSFETo72newjJMKKm2/4kTihJ6QNagS0hvxy
         4s960YRZhhVnFZRt1FE5rj9GL9/XKCOWuYkrMEELuBfbld80Gtg01dQpZVtkEH61yHic
         UqBg==
X-Gm-Message-State: AC+VfDzgCNJ79EBgshoMpQ/wfews8jHwQluGl7DlimbDGLj6oWZZirkw
	RUaz7cod4YRmcas9CAqRM+8=
X-Google-Smtp-Source: ACHHUZ4Ir5r2GwXXw9BaAK5dGsqpB8TzEMc3VcyElXhA6TrqcHCLFr4J8+NJEORTC6sWxyYSC+ebSw==
X-Received: by 2002:a7b:ca4e:0:b0:3f4:2452:966a with SMTP id m14-20020a7bca4e000000b003f42452966amr2590742wml.27.1685026504461;
        Thu, 25 May 2023 07:55:04 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id t11-20020a5d49cb000000b0030732d6e104sm2048043wrs.105.2023.05.25.07.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 07:55:04 -0700 (PDT)
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
Subject: [net-next PATCH v2 12/13] net: dsa: qca8k: implement hw_control ops
Date: Thu, 25 May 2023 16:54:00 +0200
Message-Id: <20230525145401.27007-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525145401.27007-1-ansuelsmth@gmail.com>
References: <20230525145401.27007-1-ansuelsmth@gmail.com>
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


