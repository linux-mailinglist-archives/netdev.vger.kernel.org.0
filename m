Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0E56C041F
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjCSTTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjCSTSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:18:41 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA3314EA3;
        Sun, 19 Mar 2023 12:18:39 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id y14so8526069wrq.4;
        Sun, 19 Mar 2023 12:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679253519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/fQAP8qao36Gp1ceTdiBEfkcCfyz+YfQuWedgI+BBH4=;
        b=R5aCMvKEnY1JXb3Bwxg3BhQLkx8pqC3K5PScNmGBJyUAqbUfNPQpPTrRJbjJB0U6Pr
         Pw5S5VmAv7WokWlVFdjFeYx8oSDMxOlKkOcMpUFDBmlgRtXllba8BHARazAgK/EwRpqZ
         3wjIom5VY5+lLBs1S7jU19gQr989J2ofpHC/l0YoIGhRWtA0H2O9dKi0G6UDVDylI3CV
         btHMDg5D8ZXy2/+HR/sWfhiGvclGQoc7hkFVDoZ6LTVIQUy8ys88GJaE8+o8UqMIR/sA
         3c7x5x5WQlb4AEuar1C7xop1+VaAhjL4aE/YJEji3Zn6vxrIWEm0K9b/uBuwqYPVxivP
         Tg1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679253519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/fQAP8qao36Gp1ceTdiBEfkcCfyz+YfQuWedgI+BBH4=;
        b=EKr25dMF/SV8YyUocDF9wMPe+VmxSd0v/qrRRU2xwi7cmwEsFuTi/cEZUvDJWRsOCX
         3SDS4hDrG/PO1M4S64NDq0agxG5ilLa2MZYxkXvGesayqATLPYRLrhW5qm1N4h7q7S+a
         rSAJRg00GtolQmdM7/9YNuyJ57sbbt+q7OOUoi9VqPgqszPv0JBlefjvNXlPJDJcTLl8
         B6h7P3yF4qepWgxqPeRiHYGoYdJV4a3wlGrfLVqm4U5vP1idqAoEUIjic6a4OoL7N0yd
         Pj4gmhsFeCDodlfn9JPvRykgAd4r32fJJTVuKeeSalJSEBNyptTmX0WiRm4S1vn3OBJ5
         KuGQ==
X-Gm-Message-State: AO0yUKWRhHa4T0/if+Tu59rAzGqMYTfzBw4LU6oI6y5PH6chb8obNx4E
        MBNGJkqtegaD/xX/xb0SQ+iDijKxc/4=
X-Google-Smtp-Source: AK7set9ZmcqMrTN/jVWeo4jlMpWW1C1z/Z/5d2YYYd08o3Om+n3rcd2impM/k4yBTXwuStrtbEmAuA==
X-Received: by 2002:a05:6000:104c:b0:2d4:a2c5:9f80 with SMTP id c12-20020a056000104c00b002d4a2c59f80mr4021247wrx.23.1679253519007;
        Sun, 19 Mar 2023 12:18:39 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id b7-20020a5d4b87000000b002cfe0ab1246sm7165167wrt.20.2023.03.19.12.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:18:38 -0700 (PDT)
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
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [net-next PATCH v5 03/15] net: dsa: qca8k: add LEDs blink_set() support
Date:   Sun, 19 Mar 2023 20:18:02 +0100
Message-Id: <20230319191814.22067-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230319191814.22067-1-ansuelsmth@gmail.com>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
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
index 5a29413ba94a..d0a37660faa2 100644
--- a/drivers/net/dsa/qca/qca8k-leds.c
+++ b/drivers/net/dsa/qca/qca8k-leds.c
@@ -127,6 +127,43 @@ qca8k_led_brightness_get(struct qca8k_led *led)
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
@@ -185,6 +222,7 @@ qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int p
 
 		port_led->cdev.max_brightness = 1;
 		port_led->cdev.brightness_set_blocking = qca8k_cled_brightness_set_blocking;
+		port_led->cdev.blink_set = qca8k_cled_blink_set;
 		init_data.default_label = ":port";
 		init_data.devicename = "qca8k";
 		init_data.fwnode = led;
-- 
2.39.2

