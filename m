Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A9F6989E7
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjBPBgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjBPBgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:36:21 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F5642BE6;
        Wed, 15 Feb 2023 17:36:18 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id f47-20020a05600c492f00b003dc584a7b7eso3020841wmp.3;
        Wed, 15 Feb 2023 17:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MJbS4F2GHWn7NP0EYVJ0SuPaeB9gdcFW3nGUJZbjc3E=;
        b=CP0p05RaTpaY5SOGOF1sthHmNEY5jhqHm79driE5Tau6RpUMwK+Kl2ibY2elFPlDV6
         TXljlQUsX2Ail0Wk42tQMVIcFEQC/j9cmJw9E8ixcjkcW5wSyY7V5YhAuUNUosWdPTSX
         B9COUUAbW9KRljLtm4+7juGH4zDeO3DbtBkYP7WjiFETqzFdgA+FgjgzDB9rxlnJd9Kt
         49cvn9mI0PfhM3utS8q2oCDyES1hkLivHA4TE15T0OmWRnNwV9iN06XatT3e/UPFNqZc
         oVgx50AdAzfWQWcgfzlf3WU7rVxQIQ++8jnI7tlS9cUe0Sm0a2lH8eBsxdDpx2NMjiSm
         vlQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MJbS4F2GHWn7NP0EYVJ0SuPaeB9gdcFW3nGUJZbjc3E=;
        b=ZAEuj981OokGoJ/nKOQJq75Zr7+HLUzuxwBo0x7m1YvTtUW9vJGVHyllSlsZto+5F1
         EjAYXuBy1J5uLnPtpASzSQgveio8p6uOK0rdeJEtSkMYvz6uDEzcN3L67OolBNZRn96L
         j7GHnH+cThAujmfs9Qz3mH0b9bh/LRbOWGDm2VkrlO8WFtMppBCLxZu2Vatv/tP3YSJm
         gcoT7Xe83PbWWeGfMxhuFfv6DH+pynVy+FNJ/GQpzlvLYv4+ID3G05r/t92IkSqtq336
         RDDefxW27gJbYPgxiV4P13smtMxCOZi8TLLueIFIXlGo+BcehWkmUlMyf95sZTCKF+Pr
         Gdig==
X-Gm-Message-State: AO0yUKXn0sCHjs2TuqJicqEjgfT2h4/7h1J2y9Fpe3AKkPy6Q/32N7mw
        M1nP9vR6P6wFsYofzM9YylI=
X-Google-Smtp-Source: AK7set/y0ZEHteF/t3HK/blnPFM13dRmf+Lct65DmPlSUv/EbF2y/gkhi2KIUTk/AQ4461AxhAdbog==
X-Received: by 2002:a05:600c:16c6:b0:3e2:9b3:3cb4 with SMTP id l6-20020a05600c16c600b003e209b33cb4mr820751wmn.5.1676511377314;
        Wed, 15 Feb 2023 17:36:17 -0800 (PST)
Received: from localhost.localdomain (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.googlemail.com with ESMTPSA id v15-20020a05600c214f00b003e1fb31fc2bsm64189wml.37.2023.02.15.17.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 17:36:17 -0800 (PST)
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
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH v8 01/13] leds: add support for hardware driven LEDs
Date:   Thu, 16 Feb 2023 02:32:18 +0100
Message-Id: <20230216013230.22978-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230216013230.22978-1-ansuelsmth@gmail.com>
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Some LEDs can be driven by hardware (for example a LED connected to
an ethernet PHY or an ethernet switch can be configured to blink on
activity on the network, which in software is done by the netdev trigger).

To do such offloading, LED driver must support this and a supported
trigger must be used.

LED driver should declare the correct blink_mode supported and should set
the blink_mode parameter to one of LED_BLINK_HW_CONTROLLED or
LED_BLINK_SWHW_CONTROLLED.
The trigger will check this option and fail to activate if the blink_mode
is not supported.
By default if a LED driver doesn't declare blink_mode,
LED_BLINK_SW_CONTROLLED is assumed.

The LED must implement 3 main API:

- hw_control_status():
		This asks the LED driver if hardware mode is enabled
		or not.

- hw_control_start():
		This will simply enable the hardware mode for the LED.

- hw_control_stop():
		This will simply disable the hardware mode for the LED.
		It's advised to the driver to put the LED in the old state
		but this is not enforcerd and putting the LED off is also
		accepted.

With LED_BLINK_HW_CONTROLLED blink_mode hw_control_status/start/stop is
optional and any software only trigger will reject activation as the LED
supports only hardware mode.

An additional config CONFIG_LEDS_HARDWARE_CONTROL is added to add support
for LEDs that can be controlled by hardware.

Cc: Marek Behún <kabel@kernel.org>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 Documentation/leds/leds-class.rst | 34 +++++++++++++++++++++++++++
 drivers/leds/Kconfig              | 11 +++++++++
 drivers/leds/led-class.c          | 27 +++++++++++++++++++++
 drivers/leds/led-triggers.c       | 38 ++++++++++++++++++++++++++++++
 include/linux/leds.h              | 39 ++++++++++++++++++++++++++++++-
 5 files changed, 148 insertions(+), 1 deletion(-)

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
index cd155ead8703..984d73499d83 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -169,6 +169,40 @@ Setting the brightness to zero with brightness_set() callback function
 should completely turn off the LED and cancel the previously programmed
 hardware blinking function, if any.
 
+Hardware driven LEDs
+===================================
+
+Some LEDs can be driven by hardware (for example a LED connected to
+an ethernet PHY or an ethernet switch can be configured to blink on activity on
+the network, which in software is done by the netdev trigger).
+
+To do such offloading, LED driver must support this and a supported trigger must
+be used.
+
+LED driver should declare the correct blink_mode supported and should set the
+blink_mode parameter to one of LED_BLINK_HW_CONTROLLED or LED_BLINK_SWHW_CONTROLLED.
+The trigger will check this option and fail to activate if the blink_mode is not
+supported.
+By default if a LED driver doesn't declare blink_mode, LED_BLINK_SW_CONTROLLED is
+assumed.
+
+The LED must implement 3 main API:
+
+- hw_control_status():
+		This asks the LED driver if hardware mode is enabled
+		or not.
+
+- hw_control_start():
+		This will simply enable the hardware mode for the LED.
+
+- hw_control_stop():
+		This will simply disable the hardware mode for the LED.
+		It's advised to the driver to put the LED in the old state
+		but this is not enforcerd and putting the LED off is also accepted.
+
+With LED_BLINK_HW_CONTROLLED blink_mode hw_control_status/start/stop is optional
+and any software only trigger will reject activation as the LED supports only
+hardware mode.
 
 Known Issues
 ============
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 9dbce09eabac..019b4f344e01 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -49,6 +49,17 @@ config LEDS_BRIGHTNESS_HW_CHANGED
 
 	  See Documentation/ABI/testing/sysfs-class-led for details.
 
+config LEDS_HARDWARE_CONTROL
+	bool "LED Hardware Control support"
+	help
+	  This option enabled Hardware control support used by leds that
+	  can be driven in hardware by using supported triggers.
+
+	  Hardware blink modes will be exposed by sysfs class in
+	  /sys/class/leds based on the trigger currently active.
+
+	  If unsure, say Y.
+
 comment "LED drivers"
 
 config LEDS_88PM860X
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index a6b3adcd044a..10408bff8e10 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -166,6 +166,27 @@ static void led_remove_brightness_hw_changed(struct led_classdev *led_cdev)
 }
 #endif
 
+#ifdef CONFIG_LEDS_HARDWARE_CONTROL
+static int led_classdev_check_blink_hw_mode_functions(struct led_classdev *led_cdev)
+{
+	int mode = led_cdev->blink_mode;
+
+	if (mode == LED_BLINK_SWHW_CONTROLLED &&
+	    (!led_cdev->hw_control_status ||
+	    !led_cdev->hw_control_start ||
+	    !led_cdev->hw_control_stop))
+		return -EINVAL;
+
+	if (mode == LED_BLINK_SW_CONTROLLED &&
+	    (led_cdev->hw_control_status ||
+	    led_cdev->hw_control_start ||
+	    led_cdev->hw_control_stop))
+		return -EINVAL;
+
+	return 0;
+}
+#endif
+
 /**
  * led_classdev_suspend - suspend an led_classdev.
  * @led_cdev: the led_classdev to suspend.
@@ -466,6 +487,12 @@ int led_classdev_register_ext(struct device *parent,
 	if (ret < 0)
 		return ret;
 
+#ifdef CONFIG_LEDS_HARDWARE_CONTROL
+	ret = led_classdev_check_blink_hw_mode_functions(led_cdev);
+	if (ret < 0)
+		return ret;
+#endif
+
 	mutex_init(&led_cdev->led_access);
 	mutex_lock(&led_cdev->led_access);
 	led_cdev->dev = device_create_with_groups(leds_class, parent, 0,
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 072491d3e17b..00d9f6b06f5c 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -154,6 +154,38 @@ ssize_t led_trigger_read(struct file *filp, struct kobject *kobj,
 }
 EXPORT_SYMBOL_GPL(led_trigger_read);
 
+static bool led_trigger_is_supported(struct led_classdev *led_cdev,
+				     struct led_trigger *trigger)
+{
+	switch (led_cdev->blink_mode) {
+	case LED_BLINK_SW_CONTROLLED:
+		return trigger->supported_blink_modes != LED_TRIGGER_HW_ONLY;
+
+	case LED_BLINK_HW_CONTROLLED:
+		return trigger->supported_blink_modes != LED_TRIGGER_SW_ONLY;
+
+	case LED_BLINK_SWHW_CONTROLLED:
+		return true;
+	}
+
+	return 1;
+}
+
+static void led_trigger_hw_mode_stop(struct led_classdev *led_cdev)
+{
+	/* check if LED is in HW block mode */
+	if (led_cdev->blink_mode == LED_BLINK_SW_CONTROLLED)
+		return;
+
+	/*
+	 * We can assume these function are always present as
+	 * for LED support hw blink mode they MUST be provided or register
+	 * fail.
+	 */
+	if (led_cdev->hw_control_status(led_cdev))
+		led_cdev->hw_control_stop(led_cdev);
+}
+
 /* Caller must ensure led_cdev->trigger_lock held */
 int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 {
@@ -179,6 +211,8 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 
 		cancel_work_sync(&led_cdev->set_brightness_work);
 		led_stop_software_blink(led_cdev);
+		/* Disable hardware mode on trigger change if supported */
+		led_trigger_hw_mode_stop(led_cdev);
 		if (led_cdev->trigger->deactivate)
 			led_cdev->trigger->deactivate(led_cdev);
 		device_remove_groups(led_cdev->dev, led_cdev->trigger->groups);
@@ -188,6 +222,10 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 		led_set_brightness(led_cdev, LED_OFF);
 	}
 	if (trig) {
+		/* Make sure the trigger support the LED blink mode */
+		if (!led_trigger_is_supported(led_cdev, trig))
+			return -EINVAL;
+
 		spin_lock(&trig->leddev_list_lock);
 		list_add_tail_rcu(&led_cdev->trig_list, &trig->led_cdevs);
 		spin_unlock(&trig->leddev_list_lock);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index d71201a968b6..5c360fba9ccf 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -88,6 +88,12 @@ struct led_hw_trigger_type {
 	int dummy;
 };
 
+enum led_blink_modes {
+	LED_BLINK_SW_CONTROLLED = 0x0,
+	LED_BLINK_HW_CONTROLLED,
+	LED_BLINK_SWHW_CONTROLLED,
+};
+
 struct led_classdev {
 	const char		*name;
 	unsigned int brightness;
@@ -175,6 +181,24 @@ struct led_classdev {
 
 	/* LEDs that have private triggers have this set */
 	struct led_hw_trigger_type	*trigger_type;
+
+	/* This report the supported blink_mode. The driver should report the
+	 * correct LED capabilities.
+	 * With this set to LED_BLINK_HW_CONTROLLED, LED is always in offload
+	 * mode and triggers can't be simulated by software.
+	 * If the led is LED_BLINK_HW_CONTROLLED, status/start/stop function
+	 * are optional.
+	 * By default LED_BLINK_SW_CONTROLLED is set as blink_mode.
+	 */
+	enum led_blink_modes	blink_mode;
+	/* Ask the LED driver if hardware mode is enabled or not */
+	bool			(*hw_control_status)(struct led_classdev *led_cdev);
+	/* Set LED in hardware mode */
+	int			(*hw_control_start)(struct led_classdev *led_cdev);
+	/* Disable hardware mode for LED. It's advised to the LED driver to put it to
+	 * the old status but that is not mandatory and also putting it off is accepted.
+	 */
+	int			(*hw_control_stop)(struct led_classdev *led_cdev);
 #endif
 
 #ifdef CONFIG_LEDS_BRIGHTNESS_HW_CHANGED
@@ -242,7 +266,6 @@ extern struct led_classdev *of_led_get(struct device_node *np, int index);
 extern void led_put(struct led_classdev *led_cdev);
 struct led_classdev *__must_check devm_of_led_get(struct device *dev,
 						  int index);
-
 /**
  * led_blink_set - set blinking with software fallback
  * @led_cdev: the LED to start blinking
@@ -377,12 +400,26 @@ static inline bool led_sysfs_is_disabled(struct led_classdev *led_cdev)
 
 #define TRIG_NAME_MAX 50
 
+enum led_trigger_blink_supported_modes {
+	LED_TRIGGER_SW_ONLY = LED_BLINK_SW_CONTROLLED,
+	LED_TRIGGER_HW_ONLY = LED_BLINK_HW_CONTROLLED,
+	LED_TRIGGER_SWHW = LED_BLINK_SWHW_CONTROLLED,
+};
+
 struct led_trigger {
 	/* Trigger Properties */
 	const char	 *name;
 	int		(*activate)(struct led_classdev *led_cdev);
 	void		(*deactivate)(struct led_classdev *led_cdev);
 
+	/* Declare if the Trigger supports hardware control to
+	 * offload triggers or supports only software control.
+	 * A trigger can also declare support for hardware control
+	 * if its task is to only configure LED blink modes and expose
+	 * them in sysfs.
+	 */
+	enum led_trigger_blink_supported_modes supported_blink_modes;
+
 	/* LED-private triggers have this set */
 	struct led_hw_trigger_type *trigger_type;
 
-- 
2.38.1

