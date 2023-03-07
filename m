Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B30A6AF8CE
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjCGWdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:33:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjCGWda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:33:30 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1282999C0C;
        Tue,  7 Mar 2023 14:33:29 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id ay29-20020a05600c1e1d00b003e9f4c2b623so88316wmb.3;
        Tue, 07 Mar 2023 14:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678228407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nDSS3ewB7gG1U+v8T7rnOXrGZSm+UO+B7Lfb/7bhXAg=;
        b=blz3/ELBOXjUrdpi07dtGFW6XFc748WAF+shCc4Fr8mm44kTCg6M/mJ3MTyY+QY6Xj
         HUFb89ZpGWr8FXC5jEvTsI3N/N3+bXy09ur7qmeKjP0idN9vd/Kb7N69FcJyeQF6fZvK
         K5fLOK9MSyCRDeFCnT3bLQ+J5CKFi8x6vv9Efp8dvBjgmBSsm/xP30sLXQ6vGVRBZnDL
         +DA1xIh+PIHUtWm5Ya4XQHrHo0mvCl98DdXUAW0FnuJSO4Cw/5xyI1AKNZOKf7o+KPOk
         zsO+0Wn57TIU2rFc5uM1hm6S6CTyvhn5aceIC6o8l/eTkYnB8gESS8Q5jzv6ZuG3RaKy
         2Lfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678228407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nDSS3ewB7gG1U+v8T7rnOXrGZSm+UO+B7Lfb/7bhXAg=;
        b=0mFIhSD/xLZ0empwXpxfvvKsl3pg1xEwgc1T79Zuz8OtUdb7CykDkLDFmbGS/xpYMx
         YY1VzMAIU9YSKEUjaZDtD3qVwuii7dytl2gY5WJnguRi/VOP6hbLtR817tGRk3oVFVNj
         BwP+RH+RsrVSK/B8dXhLDTTW5ervwjvVi3md8m4WugSgYZ+mf3i5PuY6Guslw/zbHobz
         s1TOtKIY4bbboZ1kyvZRof83iHcDRY+oY56z2EUtmXvftEh9iVTPvf5g8THnK1mmhVsR
         7U0keRhV38ZYFdzJE3eWGk4oKELJvFepbdDTCuVM+hcpVMsE0f9U3n57XSDlOqEyYJZ8
         iYmg==
X-Gm-Message-State: AO0yUKXt1Fd5gxL4rYihdJBPCZQuDM4dMCtWduRULh/PX8BX+tkHbL3t
        RegD5rdQ3uuH/eQfxOb1nkQ=
X-Google-Smtp-Source: AK7set/RMdqTxdOk4/p5y0aZH3QBbMwhSDw9pPagi1QOQdzjMzgGd2yZuM7LJ8k8DM9k9S+APgYOhA==
X-Received: by 2002:a05:600c:354e:b0:3eb:38e6:f652 with SMTP id i14-20020a05600c354e00b003eb38e6f652mr13920493wmq.13.1678228407200;
        Tue, 07 Mar 2023 14:33:27 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id q11-20020a05600c46cb00b003dc1d668866sm19233101wmo.10.2023.03.07.14.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 14:33:26 -0800 (PST)
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
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH 02/11] net: dsa: qca8k: add LEDs blink_set() support
Date:   Tue,  7 Mar 2023 18:00:37 +0100
Message-Id: <20230307170046.28917-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170046.28917-1-ansuelsmth@gmail.com>
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
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
---
 drivers/net/dsa/qca/qca8k-leds.c | 38 ++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
index 079f1b423f9a..821ffa1f5b5d 100644
--- a/drivers/net/dsa/qca/qca8k-leds.c
+++ b/drivers/net/dsa/qca/qca8k-leds.c
@@ -98,6 +98,43 @@ qca8k_cled_brightness_get(struct led_classdev *ldev)
 	return qca8k_led_brightness_get(led);
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
@@ -155,6 +192,7 @@ qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int p
 		port_led->cdev.max_brightness = 1;
 		port_led->cdev.brightness_set_blocking = qca8k_cled_brightness_set_blocking;
 		port_led->cdev.brightness_get = qca8k_cled_brightness_get;
+		port_led->cdev.blink_set = qca8k_cled_blink_set;
 		init_data.default_label = ":port";
 		init_data.devicename = "qca8k";
 		init_data.fwnode = led;
-- 
2.39.2

