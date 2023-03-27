Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCBC6CA6F3
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbjC0OLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbjC0OLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:11:08 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACDF19B9;
        Mon, 27 Mar 2023 07:11:06 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r11so8932820wrr.12;
        Mon, 27 Mar 2023 07:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679926265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B/6cPPqnfkL0XCsWQ9CSmSKrElE+ntPWQyKfv7omo6Q=;
        b=e5HxzgtS+Pzj+UsLrWClJb0LAXwayJGcSE1D/xsRAvc38BtM9nmrSmoio7uz4p8fBF
         Bgpqw8l+d65JG61EZ8uYcxZAga99iSTynYeaqyOz/iIW1b32V4hrbY+g97LyCtlSF6OX
         mlaL5dSHInHsJZiiT+ucOA0MQvcCXwkImjcwIYH4elJGR0L+PTnmiHkwQKb4eSa8la2t
         p2weyip0QQR6nfwdLOmnZFwpJWEEw9HOqTS1eNHm8Izu4zXOLpAaUOBcb8LVEc9eTbUG
         YGzygmuERaK/cLRqF4vCMeDwB7pavUXJ1v/y4uUAcWDuD4Gn/d8QYfwB9O+pAuRvKedB
         avLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B/6cPPqnfkL0XCsWQ9CSmSKrElE+ntPWQyKfv7omo6Q=;
        b=QJ+diinSjDFjdKKmvdR4ooP3JYYRjx4GsvQmZDLzxVqyWOw2kNBnQfKo6KmVFpTZxq
         a9dnv9FK8sWzkGjpg8JF4+TZCk+XJGSw79Gx8he/njKL76/acr/wREG6yFeji7q9orJL
         Fgbsd1hMjhZWTV2gENCRJOCJwWa+LYu0aGuBSZpVHGpVzj/taaSCCDxYt/UyJk/9gWAo
         T5VXtLNEe6BBrWeurcwEQKSTed/6ztpENbc9Nd2iMDvY9D+aFKvTOGRVSR31fPgJWTm+
         PIbcYBSJ2tY+BYk5DTFFmYiRgmYROIL0qNrDfiE9sEaytb72TlmOiLKwjDkBpiM3oSXB
         5S8w==
X-Gm-Message-State: AAQBX9fwoqEshguaNsK0GQyWAJb2BNzbyClAmtOg6Abd/ZrO0p+0WfSb
        a8/f0iWYMOrcIzIKYmtd9Ck=
X-Google-Smtp-Source: AKy350Z8lf3ruklgge7NzqCuVGA+RTP8zZNmEGcCPC0WtduOojihPwGJ7a5BJ1uzeZtVmChNcxnN8A==
X-Received: by 2002:a5d:4092:0:b0:2dc:c0da:405 with SMTP id o18-20020a5d4092000000b002dcc0da0405mr10175531wrp.34.1679926264832;
        Mon, 27 Mar 2023 07:11:04 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm25307591wrj.47.2023.03.27.07.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:11:04 -0700 (PDT)
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
Subject: [net-next PATCH v6 04/16] leds: Provide stubs for when CLASS_LED & NEW_LEDS are disabled
Date:   Mon, 27 Mar 2023 16:10:19 +0200
Message-Id: <20230327141031.11904-5-ansuelsmth@gmail.com>
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

From: Andrew Lunn <andrew@lunn.ch>

Provide stubs for devm_led_classdev_register_ext() and
led_init_default_state_get() so that LED drivers embedded within other
drivers such as PHYs and Ethernet switches still build when LEDS_CLASS
or NEW_LEDS are disabled. This also helps with Kconfig dependencies,
which are somewhat hairy for phylib and mdio and only get worse when
adding a dependency on LED_CLASS.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 include/linux/leds.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index d71201a968b6..aa48e643f655 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -82,7 +82,15 @@ struct led_init_data {
 	bool devname_mandatory;
 };
 
+#if IS_ENABLED(CONFIG_NEW_LEDS)
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

