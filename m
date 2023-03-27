Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719F96CA6EB
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbjC0OLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbjC0OLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:11:06 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDF630FA;
        Mon, 27 Mar 2023 07:11:04 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id e18so8938791wra.9;
        Mon, 27 Mar 2023 07:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679926263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fa8ioINt3A7lUc49MvB+EY/lPc2nYqFxTMECk7yeZBM=;
        b=XNKfsz5SdqRgzm+FLClI8hxxmZ1+HMY1SkmB4nd90z+fCfSjGg9VzPMM7Ref0XQFTV
         j8FC2AaRhsy+sz4cwpaxRbHwtgRdBkeNrj7VwGxTWncaRo9MwqbbG+fSsOx0Cs5yPA7g
         k+l39X9PP4nebJ3wleAf+CsqVhIKjtfqnmr178n7UETd9fzDQzcIpDPa8wAltH09fQ/L
         +V3VemWUJvuGo6YmIo8hWe1StDpku0bflZZ2t3YfV7MWpaT8IuvBiuSzX3/u7LM3c9t1
         hAPlxw/p0ts6D3jAnNtMQTW+n5W/8LP7UH8pOlvyKVelJbv2pt8kfpP4apCebRdFDX+H
         Vq8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fa8ioINt3A7lUc49MvB+EY/lPc2nYqFxTMECk7yeZBM=;
        b=GoVR72DIUNUVH4pEoqiXP8Lhhqw8yfiLlEKfwhpeB4Y/Ai5699CzUeSn3SexDom2AC
         zey5mCnNJoaqcL8/7E/RGpEco4MjsO2qG85g1CPxNbfCld8S3pkGsgvFz4M6uHFnVA01
         vVt2qhYs4ShfJU6X2KBFRLRTp54plRim2Qma+rKSp3olPckvZfnwwCVCWVi2FjU9e4Fh
         Tp31JOe6p35m/ICF6TN0sHxPncD9nYBeoF2HwfO0HcaPkhQwy6c4aQIubchkPcC5WFq7
         Raum7Zak1XTcwHPOePBYI/Wl3gut2fcQrKPF46YlymOsmPDkAGYkWy4qcOhDVhrbX3hT
         dn5w==
X-Gm-Message-State: AAQBX9eAKFVbJBBrfDZ0AK04tbxtCkK/gHrNwHEx3mWbn4/GsYHRs5py
        TasvJ4uUfsAI13Wsu3WZ2NE=
X-Google-Smtp-Source: AKy350ZJ2Jtgm4IyyN0i0YWMLpC2sIoULcJklSonwV+iqy01oeLPzMz4LxObmOT+ZjxYOBTqUAdrxQ==
X-Received: by 2002:a5d:5192:0:b0:2c9:70a4:4f94 with SMTP id k18-20020a5d5192000000b002c970a44f94mr10581523wrv.18.1679926263218;
        Mon, 27 Mar 2023 07:11:03 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm25307591wrj.47.2023.03.27.07.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:11:02 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: [net-next PATCH v6 03/16] net: dsa: qca8k: add LEDs blink_set() support
Date:   Mon, 27 Mar 2023 16:10:18 +0200
Message-Id: <20230327141031.11904-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327141031.11904-1-ansuelsmth@gmail.com>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
---
 drivers/net/dsa/qca/qca8k-leds.c | 38 ++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
index 3ad5e54fcdfd..0c104afdeca1 100644
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

