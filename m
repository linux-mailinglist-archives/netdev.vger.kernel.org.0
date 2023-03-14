Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC4B6B9AFA
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjCNQSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbjCNQRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:17:45 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5EDB4228;
        Tue, 14 Mar 2023 09:17:27 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id l12so6601220wrm.10;
        Tue, 14 Mar 2023 09:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678810645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vBkEcvNWhfAeeyo/X+X9rMIXx/nIzS4f74zU0rzzLQA=;
        b=XwtBhJd3if9M6A2OTMozEfIevA56cKlK/3J24Es8Wx8pn21l24IRpLcZov5eApGPXg
         B6aaMDVCwSCITNdbxG9CU8hkYZDmt+h3wTx7CoR7yG4Rkl/JR2KvlX7ZJWfNl9NGU3YB
         sylASw/zC9HiwlC+o1r4dCh53uwHMXgqZTIfgcp0+WRNO31uj1bghz2S7HqM2jjod5fN
         +SZ+DDS7+aMIhgqOGb+RF8Rc0X49G8p8b1cCuywQtRQwcW0u9YGn7POMKlAhF9MwYqOr
         spgSLUkwkVu5xRh8774GBxaseYSVIszcwNar7/w2zkeOCbNE4EeRBhQibwgd4OS9On/p
         TM8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vBkEcvNWhfAeeyo/X+X9rMIXx/nIzS4f74zU0rzzLQA=;
        b=n3DA7wdzqKvEUxk62xCWu/KxIp5OwfRuS3Naq4np/5sO29vycodG2ZnfAeemaQQahA
         LV6pBr4lcIL5BgZ3nfYyl8OrudJ/x7iRHbHWlRbcUiVbjjrfMdzozSjMi1CC3/NrFUAX
         ++0FcnptC9EQ464EGT5iCjZcS/PBKTqzqh9DMvBDHWivvCzPe73yENCsbOMFe3Uh7n26
         CZZH7X/N4Ppi2+ZDqpz7IQPFkJm8cDKCvv8dI4ToZsUY/90zC74HNki5gP1r8fd1Nw1F
         XMs9m0QqNV+91IY8SMBLoyy3AN6WARBZm42wJFmmF/iG9/0yydnsJC6JSgyXb42RTH0h
         ScUQ==
X-Gm-Message-State: AO0yUKX8G9CYvRxq7In3eqd1AvNzjKF7o8f8aEZi+Lsqev3WOcU/pL/c
        6NdwWaP0AAzdL1VWMPy3NoWA02vsj7I=
X-Google-Smtp-Source: AK7set91N6D+TbS1Q6evWps/LGSkChlhlymj34KF/r9uNA41U7SiRaE+dc/9RhX2lqOGgcbMOWzKpw==
X-Received: by 2002:a5d:52cc:0:b0:2ca:2794:87e8 with SMTP id r12-20020a5d52cc000000b002ca279487e8mr24642900wrv.21.1678810645067;
        Tue, 14 Mar 2023 09:17:25 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id a16-20020a5d4570000000b002c5539171d1sm2426821wrc.41.2023.03.14.09.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:17:24 -0700 (PDT)
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
Subject: [net-next PATCH v3 03/14] net: dsa: qca8k: add LEDs blink_set() support
Date:   Tue, 14 Mar 2023 11:15:05 +0100
Message-Id: <20230314101516.20427-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314101516.20427-1-ansuelsmth@gmail.com>
References: <20230314101516.20427-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
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
index 7e1e1cc123cd..8054f867c708 100644
--- a/drivers/net/dsa/qca/qca8k-leds.c
+++ b/drivers/net/dsa/qca/qca8k-leds.c
@@ -91,6 +91,43 @@ qca8k_led_brightness_get(struct qca8k_led *led)
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
@@ -148,6 +185,7 @@ qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int p
 
 		port_led->cdev.max_brightness = 1;
 		port_led->cdev.brightness_set_blocking = qca8k_cled_brightness_set_blocking;
+		port_led->cdev.blink_set = qca8k_cled_blink_set;
 		init_data.default_label = ":port";
 		init_data.devicename = "qca8k";
 		init_data.fwnode = led;
-- 
2.39.2

