Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C84F64D421
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbiLNX72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiLNX6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:58:42 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C1D5D68A;
        Wed, 14 Dec 2022 15:55:42 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so661750wms.2;
        Wed, 14 Dec 2022 15:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HIQLn3R4SCs99bjDVoXYTRZNozVoU+CdDZgHxRak2QU=;
        b=D1IVLz6ghcphn0qXbSkoviXQk8a5Nq6Dx10LVz7QkVtci/Yopy1+R7vF9AvYj8ClAw
         uC6SIeQNcRUSSl0BOihVFP+w1kyvlBzB6YIe1NuYQZSg6+gEhe4VG5qlrJX7jQ9K1/mW
         NtU5S0gKPScM42Y+5FEkH4g+MfkZQxQFLPwASkQ/G4EQRChc8yVirs4XlcYWc120a+C+
         sb09itbejdAU4i4eHpGsy/IKkX43ADU5cYxU+PmHi3PVgDHICMNyizctspmN5BM29uVv
         pLJY9OY+ZIgQgYMMD5sezSn7unXZtU+4MtFbUZu1SBb6JCpAH+/hKO4ntqrwZQQ8asTm
         /oAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HIQLn3R4SCs99bjDVoXYTRZNozVoU+CdDZgHxRak2QU=;
        b=mIcqYbQ2z28YnvSCnGS1p4SiVXqimD35vbNbc/X2ZFqix6485H7+isgf5VedbXcA9W
         dQ51WyzqP/jBq4HXci5p69sFJQ5R2ZYA24VStMVGos5toXBiOfXIfDERdffo634y0UvF
         3rU2mGh6U0m5D6J9i5hux35Wn7G2ZpGwatMLT+MuhNqh4jYdA5Ho8aVGw7Ov0FbmIJYU
         CyIVVrK8OkQBbuTXVLGiEiJ6AHhaosFCXVQLMgrr9ujN/TXXFEEUIi13YJYPhssJOjso
         nSIJ+K1xLEJdmGuD/i5EZGNz4daqQfUvYK16rUq22kVssc4ziSTUHzpqdrsDfQkXRos8
         gdFQ==
X-Gm-Message-State: ANoB5pkhQ7wAxK7gjCHL+QLS8Ff6SOD/p6kSP9NvsIZZL7oGqaGpyVAm
        d65wnRXtGyGe0FrlqXx7C6k=
X-Google-Smtp-Source: AA0mqf40/1dqaBUxgU46CXTg4yXTNXGHB92WAaHnahd38QVj9oZVlYFRJ1gC9PPRPhU8YMTyEFasug==
X-Received: by 2002:a05:600c:19c7:b0:3d0:8722:a145 with SMTP id u7-20020a05600c19c700b003d08722a145mr20479827wmq.40.1671062110084;
        Wed, 14 Dec 2022 15:55:10 -0800 (PST)
Received: from localhost.localdomain (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.googlemail.com with ESMTPSA id u2-20020adff882000000b00241d21d4652sm4163549wrp.21.2022.12.14.15.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 15:55:09 -0800 (PST)
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
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH v7 02/11] leds: add function to configure hardware controlled LED
Date:   Thu, 15 Dec 2022 00:54:29 +0100
Message-Id: <20221214235438.30271-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221214235438.30271-1-ansuelsmth@gmail.com>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
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
 Documentation/leds/leds-class.rst | 25 ++++++++++++++++++++
 include/linux/leds.h              | 39 +++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
index 645940b78d81..efd2f68c46a7 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -198,6 +198,31 @@ With HARDWARE_CONTROLLED blink_mode hw_control_status/start/stop is optional
 and any software only trigger will reject activation as the LED supports only
 hardware mode.
 
+A trigger once he declared support for hardware controlled blinks, will use the function
+hw_control_configure() provided by the driver to check support for a particular blink mode.
+This function passes as the first argument (flag) a u32 flag.
+The second argument (cmd) of hw_control_configure() method can be used to do various
+operations for the specific blink mode. We currently support ENABLE, DISABLE, READ, ZERO
+and SUPPORTED to enable, disable, read the state of the blink mode, ask the LED
+driver if it does supports the specific blink mode and to reset any blink mode active.
+
+In ENABLE/DISABLE hw_control_configure() should configure the LED to enable/disable the
+requested blink mode (flag).
+In READ hw_control_configure() should return 0 or 1 based on the status of the requested
+blink mode (flag).
+In SUPPORTED hw_control_configure() should return 0 or 1 if the LED driver supports the
+requested blink mode (flags) or not.
+In ZERO hw_control_configure() should return 0 with success operation or error.
+
+The unsigned long flag is specific to the trigger and change across them. It's in the LED
+driver interest know how to elaborate this flag and to declare support for a
+particular trigger. For this exact reason explicit support for the specific
+trigger is mandatory or the driver returns -EOPNOTSUPP if asked to enter offload mode
+with a not supported trigger.
+If the driver returns -EOPNOTSUPP on hw_control_configure(), the trigger activation will
+fail as the driver doesn't support that specific offload trigger or doesn't know
+how to handle the provided flags.
+
 Known Issues
 ============
 
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 09ff1dc6f48d..b5aad67fecfb 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -73,6 +73,16 @@ enum led_blink_modes {
 	SOFTWARE_HARDWARE_CONTROLLED,
 };
 
+#ifdef CONFIG_LEDS_HARDWARE_CONTROL
+enum blink_mode_cmd {
+	BLINK_MODE_ENABLE, /* Enable the hardware blink mode */
+	BLINK_MODE_DISABLE, /* Disable the hardware blink mode */
+	BLINK_MODE_READ, /* Read the status of the hardware blink mode */
+	BLINK_MODE_SUPPORTED, /* Ask the driver if the hardware blink mode is supported */
+	BLINK_MODE_ZERO, /* Disable any hardware blink active */
+};
+#endif
+
 struct led_classdev {
 	const char		*name;
 	unsigned int brightness;
@@ -185,6 +195,17 @@ struct led_classdev {
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
+							enum blink_mode_cmd cmd);
 #endif
 #endif
 
@@ -454,6 +475,24 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 	return led_cdev->trigger_data;
 }
 
+#ifdef CONFIG_LEDS_HARDWARE_CONTROL
+static inline bool led_trigger_blink_mode_is_supported(struct led_classdev *led_cdev,
+						       unsigned long flag)
+{
+	int ret;
+
+	/* Sanity check: make sure led support hw mode */
+	if (led_cdev->blink_mode == SOFTWARE_CONTROLLED)
+		return false;
+
+	ret = led_cdev->hw_control_configure(led_cdev, flag, BLINK_MODE_SUPPORTED);
+	if (ret > 0)
+		return true;
+
+	return false;
+}
+#endif
+
 /**
  * led_trigger_rename_static - rename a trigger
  * @name: the new trigger name
-- 
2.37.2

