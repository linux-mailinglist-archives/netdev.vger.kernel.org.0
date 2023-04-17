Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31FE6E4CB4
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjDQPUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjDQPUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:20:15 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD795FE4;
        Mon, 17 Apr 2023 08:19:52 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id q5so13974601wmo.4;
        Mon, 17 Apr 2023 08:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744790; x=1684336790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ePi4CR2T47RYrwRBfSvRAkHXEjaIE7F/c3iGG+RBl5w=;
        b=X1p9RfbMQaDa0pFdeTw5VL13ToVUD6z3eITOT7ZwMipgfrT34+XGMWmPMZ9lYzR9Ew
         pj25Krt/L7ZEZGwnpoKAHVM5TUqP3AR5kAbAAKGOz/ysag4CpdhwfgyRnfFCERZutDPT
         /zUNuhpbYsgobHnjtQiXlgMgAaVuEfPQi6oJvxckViwefQZD0AVZSegjYi1favfkAuD3
         Tu3R4tjlsu2ouSFB+PDqAtX61217eMG0Dzjc0rs5/VLu2311JLa5asQxez9EJXlhI2CL
         8LkZ2TZR8o08L3p3Q0KxLn+14MzGH/Kui2DE/idLmspQ9QiqbQPn8FRADuXW6ZWBWIJ8
         Xb0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744790; x=1684336790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ePi4CR2T47RYrwRBfSvRAkHXEjaIE7F/c3iGG+RBl5w=;
        b=PVaRh9lajtbNtDl2PjWTuYElAtFYQi7JYcoalP8/38FDn7Q62PVtXnnmpL0HVl/xC9
         gUHjFGaftzEK2awV+FouWKUV4weRY5C9vSbDImQCZpbtjRo7tCrM1lr8MaIGJJPyJTtY
         vM88fYD9DwfU2TW4eer9S0KFcEgBtv33ddMmbgmgFNeSRUH8Jkcc3yAa+3hHHl8tS1p1
         H8pwwbn5ZmzHoQxNBdPkI1KAjSWdO6HNb1t/DJVW8ksvWP8mW2d6dHsfjZcqGY4mRB3d
         DG1g6+kCTKjR1c814De4toeG1WjfOd/XU9ikkZGBNcX96KODl5dtmmjVOkC+CBVzGOsc
         n98w==
X-Gm-Message-State: AAQBX9eLXjyDBlt2mfaxuNIJCMZIUxFg1xMzZBJQQgtuF/6X+sEzYWi9
        FlGZw9sf5/vMewleTGr9cck=
X-Google-Smtp-Source: AKy350a6Il4UQ79RJ2tdvRO07JYzuuVijegQEFUCQxc1IgCIU7F41z7HR3KWS+jAG9ds+JB1zo4Lgw==
X-Received: by 2002:a05:600c:2196:b0:3f1:73c1:d1ad with SMTP id e22-20020a05600c219600b003f173c1d1admr2309302wme.35.1681744790361;
        Mon, 17 Apr 2023 08:19:50 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c1c0f00b003f173be2ccfsm3501354wms.2.2023.04.17.08.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:19:27 -0700 (PDT)
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
Subject: [net-next PATCH v7 03/16] net: dsa: qca8k: add LEDs blink_set() support
Date:   Mon, 17 Apr 2023 17:17:25 +0200
Message-Id: <20230417151738.19426-4-ansuelsmth@gmail.com>
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

Add LEDs blink_set() support to qca8k Switch Family.
These LEDs support hw accellerated blinking at a fixed rate
of 4Hz.

Reject any other value since not supported by the LEDs switch.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/qca/qca8k-leds.c | 38 ++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
index 0146ee12d34c..b883692b7d86 100644
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
@@ -186,6 +223,7 @@ qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int p
 
 		port_led->cdev.max_brightness = 1;
 		port_led->cdev.brightness_set_blocking = qca8k_cled_brightness_set_blocking;
+		port_led->cdev.blink_set = qca8k_cled_blink_set;
 		init_data.default_label = ":port";
 		init_data.fwnode = led;
 		init_data.devname_mandatory = true;
-- 
2.39.2

