Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200786B3101
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 23:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjCIWiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 17:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjCIWiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 17:38:04 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12A81913D;
        Thu,  9 Mar 2023 14:38:02 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso4792713wmb.0;
        Thu, 09 Mar 2023 14:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678401481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jAjYaCokdDFeoHBYZ8ajEHyinrj2ay5j+y5y2pyEMkc=;
        b=DirXdVf5HBsEqP0FuGmWmFyGILlI68FKvJs+WbmYdTMj7rBphcg5E+Js76FQF1gUvb
         3md+bEy9mi1Y90r1AWW7kvFU1Sixd0spfyHx8GPIG4OyAZzIs1j2n7rQc8qB8g//bO7w
         wzcebbNtq0XnDQgIA/mE4x8YUyBa2odPk2sv4tFY5VwdpFTI9XeUN8cWtVuhgog28LvS
         LCiuBLPF984KdIKG+IrrXPkJxHWAShwTN/Zz0vuIFIYWw55WrbIKWGu0Mu3sxJlm4nLC
         dhfrUHJGta0K0B+Yrw+r2BRAxL/eeBMycB2kyFT8RapdCLkTY6KsFbFxO7Ytjd+HMr/z
         PxWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678401481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jAjYaCokdDFeoHBYZ8ajEHyinrj2ay5j+y5y2pyEMkc=;
        b=iWGta3DBc5fIpBcmPeNQ2dsu938DKN12L07bflPaImz69FtnVlnLqDC1uPNyV/D2Hl
         ykJT0EfNu/mb10LFp5EQkMM6fujTpzNOOWYd/MMfsHQlW2egF+GkrEZyDfDc7NBo950o
         DxoMTuP4Xm86GapGxfQLAmEw7nUoXLSjj4hxkareF5Z1G7k2Ut06rpEiJDbJBV07gSGu
         rEVKxfHoXYElRN0M6WvcDcafT4Oe3fCb2c+TfmfbOvE/ySBeWPk03ZroYtuDgqNakYet
         y5e+oksuPL4sTz/EdYtoAP4HmVqz3sv9dRxefeJiMq5OfOnJ4kaa4W3SD+S9o7w9tMiQ
         3dYg==
X-Gm-Message-State: AO0yUKW2iwOr7g+UkupD/2UdzKCUoFpD7dVqYz5VHmJzu0Yht2iuMvne
        0Pj5e0gMPW6Tnptejaf2kqc=
X-Google-Smtp-Source: AK7set8B6B4IHkmMi9Kt2of4xqwy/XP6aBgiq1LT9tStWRvZb5Tsu0Dn84Waf2UQyEWVDGHPKTq5YA==
X-Received: by 2002:a05:600c:1553:b0:3d9:f769:2115 with SMTP id f19-20020a05600c155300b003d9f7692115mr752038wmg.26.1678401481047;
        Thu, 09 Mar 2023 14:38:01 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id g12-20020a05600c310c00b003e209b45f6bsm1183981wmo.29.2023.03.09.14.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 14:38:00 -0800 (PST)
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
Subject: [net-next PATCH v2 03/14] net: dsa: qca8k: add LEDs blink_set() support
Date:   Thu,  9 Mar 2023 23:35:13 +0100
Message-Id: <20230309223524.23364-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309223524.23364-1-ansuelsmth@gmail.com>
References: <20230309223524.23364-1-ansuelsmth@gmail.com>
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
index 7ae2ea082aae..df7106d498db 100644
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

