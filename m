Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF4F6C0422
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjCSTTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjCSTSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:18:43 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183A61994;
        Sun, 19 Mar 2023 12:18:42 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r29so8501824wra.13;
        Sun, 19 Mar 2023 12:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679253520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GonJ8ooxBIpDwINNR4y8inzQ1f1MzMkTJ7LjdzraRGU=;
        b=feSVwEzD7l9JYlCYA+zVM5K/7NBQzYbdCA0mwV7qYGCMZbmmsgMmp+oD9hkZND/9B+
         KMCrsGuCRx1OE5ZElPdSxd4/YAFAkAv9Rr7cl2W8tgY0IpPgQiip6CRTZd23cKXi8jax
         zFS09SYUJuPOd0PUr5ZC5k2KPWeO+Md4ZwzYjMxGzbxPs4RlRXGfoJr7/iM0eHx1Oi49
         eT7bR/n7MiDDp+DxtPLzU6FgwZWFjyfQV9M08QhsbXeSEJ88yBdfYxGmBz3+s4HlsoPJ
         Op4w8HmYC75Hnt+P0yu6d7cEwkwVp7CU8SAg+R/Q3DrHqFHESOaIKayUSh6qYLo0viFi
         3RIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679253520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GonJ8ooxBIpDwINNR4y8inzQ1f1MzMkTJ7LjdzraRGU=;
        b=DQfmLVT+yoKRtk+s9cbnveLlWBD8roi6KIyGaaTCmhPEcD8UQSq+LSqM7CiWfIbdnH
         ONKE0ZXMYXPDbHHMrhsdkUr8+Qs1ZgUWpnXoTBZ/xPctpaUosVXEuvG4FYnbv60PN/5X
         HtGKhkMwBxMhbX8QL3CReWtdYQvHkMrZBHBNDodmXX9UA4FMGxytHymivsg7TlsIjELx
         TW1jSfeLxLhDpbSabDIydQ0uwIM6L6smn1lUTQAEBZtVtU7HV4eKDJQ9pcLTupzaUA0x
         M6OoQQxF7Lp+fIdebv1gb7CC9GO+qyEl5X0NTghcop8N5wX0gl+kqTIdTwvGowGpwd3s
         OuAA==
X-Gm-Message-State: AO0yUKV2aXdoUvN7GjbYJR1YDHIZBd/F+jOHoxoqi1X1c7r0CDEsDcN2
        Q268JZ3pi0LjWdMFqExN1CS3K/b8ViM=
X-Google-Smtp-Source: AK7set/qOxMnXBb6bHl21rmH3Hn6LUIeXznITjs5sepPn4279eZZHy92EBFNxNf20nKcTOgrvSwQyQ==
X-Received: by 2002:a5d:5189:0:b0:2ce:9f13:a169 with SMTP id k9-20020a5d5189000000b002ce9f13a169mr12080664wrv.64.1679253520415;
        Sun, 19 Mar 2023 12:18:40 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id b7-20020a5d4b87000000b002cfe0ab1246sm7165167wrt.20.2023.03.19.12.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:18:40 -0700 (PDT)
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
Subject: [net-next PATCH v5 04/15] leds: Provide stubs for when CLASS_LED is disabled
Date:   Sun, 19 Mar 2023 20:18:03 +0100
Message-Id: <20230319191814.22067-5-ansuelsmth@gmail.com>
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

From: Andrew Lunn <andrew@lunn.ch>

Provide stubs for devm_led_classdev_register_ext() and
led_init_default_state_get() so that LED drivers embedded within other
drivers such as PHYs and Ethernet switches still build when LEDS_CLASS
is disabled. This also helps with Kconfig dependencies, which are
somewhat hairy for phylib and mdio and only get worse when adding a
dependency on LED_CLASS.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 include/linux/leds.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index d71201a968b6..f6dec57453da 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -82,7 +82,15 @@ struct led_init_data {
 	bool devname_mandatory;
 };
 
+#if IS_ENABLED(CONFIG_LEDS_CLASS)
 enum led_default_state led_init_default_state_get(struct fwnode_handle *fwnode);
+#else
+static inline enum led_default_state
+led_init_default_state_get(struct fwnode_handle *fwnode)
+{
+	return LEDS_DEFSTATE_OFF;
+}
+#endif
 
 struct led_hw_trigger_type {
 	int dummy;
@@ -217,9 +225,19 @@ static inline int led_classdev_register(struct device *parent,
 	return led_classdev_register_ext(parent, led_cdev, NULL);
 }
 
+#if IS_ENABLED(CONFIG_LEDS_CLASS)
 int devm_led_classdev_register_ext(struct device *parent,
 					  struct led_classdev *led_cdev,
 					  struct led_init_data *init_data);
+#else
+static inline int
+devm_led_classdev_register_ext(struct device *parent,
+			       struct led_classdev *led_cdev,
+			       struct led_init_data *init_data)
+{
+	return 0;
+}
+#endif
 
 static inline int devm_led_classdev_register(struct device *parent,
 					     struct led_classdev *led_cdev)
-- 
2.39.2

