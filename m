Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4A26989EC
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjBPBgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjBPBgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:36:22 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB2D442E4;
        Wed, 15 Feb 2023 17:36:20 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id z13so466043wmp.2;
        Wed, 15 Feb 2023 17:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2zG2FPF2HCGhFA3A8x50o1BhWQSoAA49i+eyxanDZew=;
        b=L+bMCtbEgyGO9OyU2gUMYD6oXJIOZh7/f4h4mBtaGKN4V5p3nX1dkt/LWwvA3UXAiu
         9ssexsSbHh66qgqPpRpW7AliysJyU6+HeNaMC+V3EXNUYjOOCVxJhtSwcW/1KH2cqq9u
         WWHedEj/Up3Mfr+BpeFGh4pWAyRt1cpIV4IFWee08JGEPgIaKHoE1geBBLZWNmy4Uaqu
         bfQQ87+I4yzW4/77PS0OTFtLlzwdPKjJt+7pKxt2LSUy7enTUNSxScX+Wr8RvtjP+ayB
         Lo/4u0141+BEJKKVj5zSRl1ana87BfX4Of0r2Z238Ar2nZuD9dmFgn+5c9rupxiEV6Rs
         hoKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2zG2FPF2HCGhFA3A8x50o1BhWQSoAA49i+eyxanDZew=;
        b=S+VE8lFoDYjWAqkDDy5yRALtrm/AVtPmWU3Daz5dNLOqnkPLZSmu7p/cXvOcS4Wbgn
         nLvsnTvPekwxa7QyTzp+1qDt5/ogxr1yOoJBky2hhUpojOPu3OSVuTMZJnNjhUBgLmvT
         2WD5c+xxnTK/Wf0XQrpKGAEp3axAgINMuG6elKKTl4c+QjhZ2Xbvf4LzuTZrJ0I5RX+r
         /mM9UDJfJuPVo5ASWJH8iSuqRPxK2iYcyqa/Q0RWd6pmNdrWPcwbag5rWkKUVurtImhB
         zePwklDSK2F98JDLu1BhvenGCrDEnrf8VqZHt51pdYZJxOhCUMYoVsl7bp5bwv9gihrL
         AYTA==
X-Gm-Message-State: AO0yUKUHfEo2Qsf+T3sVPPqih4Bc8qYBuTM9lN/SxSNJ36V73YCtFc0m
        VqxUQlgB0KLjlgSM6qjZ3bw=
X-Google-Smtp-Source: AK7set+4vZgcDlLPQ/VEq4HwYKKoG4VxRFS+f3SFohNr0eUk2UIf/RzUUwbPdSqVCp7zOFnS6KiHFw==
X-Received: by 2002:a05:600c:492a:b0:3dc:42d2:aee4 with SMTP id f42-20020a05600c492a00b003dc42d2aee4mr3447006wmp.25.1676511378802;
        Wed, 15 Feb 2023 17:36:18 -0800 (PST)
Received: from localhost.localdomain (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.googlemail.com with ESMTPSA id v15-20020a05600c214f00b003e1fb31fc2bsm64189wml.37.2023.02.15.17.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 17:36:18 -0800 (PST)
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
        Jonathan Corbet <corbet@lwn.net>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Arun.Ramadoss@microchip.com
Subject: [PATCH v8 02/13] leds: add function to configure hardware controlled LED
Date:   Thu, 16 Feb 2023 02:32:19 +0100
Message-Id: <20230216013230.22978-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230216013230.22978-1-ansuelsmth@gmail.com>
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
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

Add hw_control_configure helper to configure how the LED should work in
hardware mode. The function require to support the particular trigger and
will use the passed flag to elaborate the data and apply the
correct configuration. This function will then be used by the trigger to
request and update hardware configuration.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 Documentation/leds/leds-class.rst | 60 +++++++++++++++++++++++++++++++
 include/linux/leds.h              | 43 ++++++++++++++++++++++
 2 files changed, 103 insertions(+)

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
index 984d73499d83..8a23589e9fca 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -200,10 +200,70 @@ The LED must implement 3 main API:
 		It's advised to the driver to put the LED in the old state
 		but this is not enforcerd and putting the LED off is also accepted.
 
+- hw_control_configure():
+		This will be used to configure the various blink modes LED support
+		in hardware mode.
+
 With LED_BLINK_HW_CONTROLLED blink_mode hw_control_status/start/stop is optional
 and any software only trigger will reject activation as the LED supports only
 hardware mode.
 
+Where a trigger has support for hardware controlled blink modes,
+hw_control_configure() will be used to check whether a particular blink mode
+is supported and configure the blink mode using various specific command.
+
+hw_control_configure() takes 3 arguments:
+
+- struct led_classdev *led_cdev
+
+- unsigned long flag:
+		This can be used for multiple purpose based on passed command
+		in the 3rd argument of this function.
+		It may be NULL if the 3rd argument doesn't require them.
+
+		The unsigned long flag is specific to the trigger and its meaning
+		change across different triggers.
+		For this exact reason LED driver needs to declare explicit support
+		for the trigger supporting hardware blink mode.
+		The driver should return -EOPNOTSUPP if asked to enter in hardware
+		blink mode with an unsupported trigger.
+
+		The LED driver may also report -EOPNOTSUPP if the requested flag
+		are rejected and can't be handled in hw blink mode by the LED.
+
+		Flag can both be a single blink mode or a set of multiple blink
+		mode. LED driver must be able to handle both cases.
+
+- enum led_blink_hw_cmd cmd:
+		This is used to request to the LED driver various operation.
+
+		They may return -EOPNOTSUPP or -EINVAL based on the provided flags.
+
+hw_control_configure() supports the following cmd:
+
+- LED_BLINK_HW_ENABLE:
+		enable the blink mode requested in flag. Returns 0 or a negative
+		error.
+
+- LED_BLINK_HW_DISABLE:
+		disable the blink mode requested in flag. Returns 0 or a negative
+		error.
+
+- LED_BLINK_HW_STATUS:
+		read the status of the blink mode requested in flag. Return a mask
+		of the enabled blink mode requested in flag or a negative error.
+
+- LED_BLINK_HW_SUPPORTED:
+		ask the LED driver if the blink mode requested in flag is supported.
+		Return 1 if supported or a negative error in any other case.
+
+- LED_BLINK_HW_RESET:
+		reset any blink mode currently active. Value in flag are ignored.
+		Return 0 or a negative error.
+
+		LED driver can set the blink mode to a default state or keep everything
+		disabled.
+
 Known Issues
 ============
 
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 5c360fba9ccf..c25558ca5f85 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -94,6 +94,14 @@ enum led_blink_modes {
 	LED_BLINK_SWHW_CONTROLLED,
 };
 
+enum led_blink_hw_cmd {
+	LED_BLINK_HW_ENABLE, /* Enable the hardware blink mode */
+	LED_BLINK_HW_DISABLE, /* Disable the hardware blink mode */
+	LED_BLINK_HW_STATUS, /* Read the status of the hardware blink mode */
+	LED_BLINK_HW_SUPPORTED, /* Ask the driver if the hardware blink mode is supported */
+	LED_BLINK_HW_RESET, /* Reset any hardware blink active */
+};
+
 struct led_classdev {
 	const char		*name;
 	unsigned int brightness;
@@ -199,6 +207,17 @@ struct led_classdev {
 	 * the old status but that is not mandatory and also putting it off is accepted.
 	 */
 	int			(*hw_control_stop)(struct led_classdev *led_cdev);
+	/* This will be used to configure the various blink modes LED support in hardware
+	 * mode.
+	 * The LED driver require to support the active trigger and will elaborate the
+	 * unsigned long flag and do the operation based on the provided cmd.
+	 * Current operation are enable,disable,supported and status.
+	 * A trigger will use this to enable or disable the asked blink mode, check the
+	 * status of the blink mode or ask if the blink mode can run in hardware mode.
+	 */
+	int			(*hw_control_configure)(struct led_classdev *led_cdev,
+							unsigned long flag,
+							enum led_blink_hw_cmd cmd);
 #endif
 
 #ifdef CONFIG_LEDS_BRIGHTNESS_HW_CHANGED
@@ -473,6 +492,30 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 	return led_cdev->trigger_data;
 }
 
+#ifdef CONFIG_LEDS_HARDWARE_CONTROL
+static inline bool led_trigger_blink_mode_is_supported(struct led_classdev *led_cdev,
+						       unsigned long flag)
+{
+	int ret;
+
+	/* Sanity check: make sure led support hw mode */
+	if (led_cdev->blink_mode == LED_BLINK_SW_CONTROLLED)
+		return false;
+
+	ret = led_cdev->hw_control_configure(led_cdev, flag, LED_BLINK_HW_SUPPORTED);
+	if (ret > 0)
+		return true;
+
+	return false;
+}
+#else
+static inline bool led_trigger_blink_mode_is_supported(struct led_classdev *led_cdev,
+						       unsigned long flag)
+{
+	return false;
+}
+#endif
+
 /**
  * led_trigger_rename_static - rename a trigger
  * @name: the new trigger name
-- 
2.38.1

