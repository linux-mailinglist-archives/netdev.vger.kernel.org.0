Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4A06BDEAD
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjCQCde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCQCd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:33:27 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28E32E0C0;
        Thu, 16 Mar 2023 19:33:25 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id m2so3186805wrh.6;
        Thu, 16 Mar 2023 19:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679020404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=afDlpxoJaGOlge6oF8HK8w7bmxxAcRYUXmg7BTlAgHY=;
        b=FKAuylYM2ILHFDRqDE7mBB8P8EzedX9Ga+jNpeK44hfNSKZUjsOqRsShUjLMHTJi1C
         tfHNagocmUOHYAq22hcqMXbJOM+MNzCn0T07uZWFKVhEWBNBmzpaeUHKYJZeOQet+XqP
         pUFC1pjHzLjBoPs6SJ9plyBgOu0va1ObyPpfkSwAus+cXoJjJUfilUJq4eBEfd41sRDu
         nMQEZibL8MipUEeU1igSeqx8uIEk864xehzTp9paNjBPTRIZWh8VdH/kE5WecR7cv7ti
         4O+QtNtXRoD+P+qwiemcebIaASbVDVMXncGibDYJyPQ9P6BCr3JPgFAy1KM8BP11I6eL
         iytQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679020404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=afDlpxoJaGOlge6oF8HK8w7bmxxAcRYUXmg7BTlAgHY=;
        b=gY5TIFpwVW0+zLM+DmVUffnA8VP28OvPQWTHczPMyaVkYHl0ysTFRijzu/9GneAXqv
         vEN4ZlODarCSHe1aQHawW6CBHdeV7GP8qkj+TIyEzvV8zI8OueG2K36cRD9pQG/h1Ast
         BjnraeUoL85rVxqDUu3h12AeYy2QqWstf2zqjkMYKcFhhCjnbq1DOl0H89KOFJ9/vJP8
         nTsA6Doh50fRY4tB5K/0oH5WJL5YGGDqIN9o60rnM/Fhmg9srxCOWp1E0E9IxMhn+O/x
         ViLZVIN8F+XlNGUh/Ia2jeR0tUh4thWe5XH6WUStQ+Pb7eXSkgYIW6uUUbye3RqRk9lc
         EMPQ==
X-Gm-Message-State: AO0yUKU1tDQ5ZecNU2SjTaHGYziOFFM+6I4VcXPVC0ePHjrarU/NWFea
        GU5pG5BUZLT14l96C5SWcvs=
X-Google-Smtp-Source: AK7set9mFPMbMd5WaGmqDANXaolgXA1OYSJ3oPPBsUn8RnG51iWyXsK58GjgEWxKEdrMi/cJTSLDfA==
X-Received: by 2002:a5d:5003:0:b0:2cf:3396:9126 with SMTP id e3-20020a5d5003000000b002cf33969126mr6507894wrt.10.1679020403968;
        Thu, 16 Mar 2023 19:33:23 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id z15-20020a5d44cf000000b002ce9f0e4a8fsm782313wrr.84.2023.03.16.19.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 19:33:23 -0700 (PDT)
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
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH v4 03/14] net: dsa: qca8k: add LEDs blink_set() support
Date:   Fri, 17 Mar 2023 03:31:14 +0100
Message-Id: <20230317023125.486-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230317023125.486-1-ansuelsmth@gmail.com>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add LEDs blink_set() support to qca8k Switch Family.
These LEDs support hw accellerated blinking at a fixed rate
of 4Hz.

Reject any other value since not supported by the LEDs switch.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca/qca8k-leds.c | 38 ++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
index adbe7f6e2994..c229575c7e8c 100644
--- a/drivers/net/dsa/qca/qca8k-leds.c
+++ b/drivers/net/dsa/qca/qca8k-leds.c
@@ -92,6 +92,43 @@ qca8k_led_brightness_get(struct qca8k_led *led)
 	return val == QCA8K_LED_ALWAYS_ON;
 }
 
+static int
+qca8k_cled_blink_set(struct led_classdev *ldev,
+		     unsigned long *delay_on,
+		     unsigned long *delay_off)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+	u32 mask, val = QCA8K_LED_ALWAYS_BLINK_4HZ;
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
+	if (led->port_num == 0 || led->port_num == 4) {
+		mask = QCA8K_LED_PATTERN_EN_MASK;
+		val <<= QCA8K_LED_PATTERN_EN_SHIFT;
+	} else {
+		mask = QCA8K_LED_PHY123_PATTERN_EN_MASK;
+	}
+
+	regmap_update_bits(priv->regmap, reg_info.reg, mask << reg_info.shift,
+			   val << reg_info.shift);
+
+	return 0;
+}
+
 static int
 qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int port_num)
 {
@@ -149,6 +186,7 @@ qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int p
 
 		port_led->cdev.max_brightness = 1;
 		port_led->cdev.brightness_set_blocking = qca8k_cled_brightness_set_blocking;
+		port_led->cdev.blink_set = qca8k_cled_blink_set;
 		init_data.default_label = ":port";
 		init_data.devicename = "qca8k";
 		init_data.fwnode = led;
-- 
2.39.2

