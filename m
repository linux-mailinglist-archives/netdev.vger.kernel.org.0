Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FF264D419
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiLNX7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiLNX6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:58:35 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CEB5C77D;
        Wed, 14 Dec 2022 15:55:40 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id y16so1475639wrm.2;
        Wed, 14 Dec 2022 15:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hSDIT5ag90Nh6sLPPU0LfNfXfC5EyDn5AXJFiDZJ1Ew=;
        b=Owd7ZjM2tg6I4/iYJ2yBFvCSLEhRb+uGZxZHoiYke/omnbxXf4kNgoG9jM5+Coc68h
         neHikIdhRiAQdwsltDuAdRTyJbvSB0sNbbehpFQFu3J11sHvIovlbHVGez/S55gq7AfQ
         bhv0aMVV9L2BupW1ADSvDQVqyuFWYFJzux3NGRe4TEePfCchczjkC6f0KDVwqkpyY7dB
         YF7G9ppFZJYo0PZfkRpFdH9AoXL8mgT8f5K0+tvstUFcjJdHDoc/pQFGHJDwZukz4BWj
         I9N9EPYN0P/b7l4AAH3gcizA6uFriMAAaFnQAZvOja+S5Spvrx5gQV7nTKt2LNRnH/Wh
         Vt4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hSDIT5ag90Nh6sLPPU0LfNfXfC5EyDn5AXJFiDZJ1Ew=;
        b=rOaiJcXB7y0RpHZhLfHUY8tSVK5zrU7cGe57gPJBPm1whIv83QUDlONJ6N3TY3nXWC
         CVZTLdAiUsFfEKi4qeAZILrVHWYcj1dBXuoY/eWIrnpMmdIjl8BnkRfqRSAX/Rj64rdw
         idS8YYV8hRzQtq3l23MmDHWCrNdLHn1LeI5r9OUkq3qh4wMBO6xmO2TtT29Tp6KLbI6Y
         1RNKRrEgcYi+qiSmIOmjWiyCXjItGVzhzHgGt8JiuhWc62fmzoNYqUE8VLo2fj1NhA99
         HaJAncdZ/xhC65m6rOloXEEfwKCFihYRWdSbA10A63LeA7OY94J0F5hpYfIcch3xv5gE
         RmRQ==
X-Gm-Message-State: ANoB5pl8TiXz9zsy/tw4TylLtwnR2i6w9NWHA/hVXkko04QiwiL5Io2H
        js/PYNDlqqtUMvdTsRl8Va0=
X-Google-Smtp-Source: AA0mqf7UT5urptFMJBCSSyO0aCy3wTeHq9tmFsu1KENoU4r/3a5v+tG9wtYigU9ZcEZk94TlY5FwqQ==
X-Received: by 2002:adf:f809:0:b0:242:4576:b6eb with SMTP id s9-20020adff809000000b002424576b6ebmr17366151wrp.7.1671062108431;
        Wed, 14 Dec 2022 15:55:08 -0800 (PST)
Received: from localhost.localdomain (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.googlemail.com with ESMTPSA id u2-20020adff882000000b00241d21d4652sm4163549wrp.21.2022.12.14.15.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 15:55:07 -0800 (PST)
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
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH v7 01/11] leds: add support for hardware driven LEDs
Date:   Thu, 15 Dec 2022 00:54:28 +0100
Message-Id: <20221214235438.30271-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221214235438.30271-1-ansuelsmth@gmail.com>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
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
the blink_mode parameter to one of HARDWARE_CONTROLLED or
SOFTWARE_HARDWARE_CONTROLLED.
The trigger will check this option and fail to activate if the blink_mode
is not supported. By default if a LED driver doesn't declare blink_mode,
SOFTWARE_CONTROLLED is assumed.

The LED must implement 3 main API:
- hw_control_status(): This asks the LED driver if hardware mode is
    enabled or not.
    Triggers will check if the offload mode is supported and will be
    activated accordingly. If the trigger can't run in software mode,
    return -EOPNOTSUPP as the blinking can't be simulated by software.
- hw_control_start(): This will simply enable the hardware mode for
    the LED.
    With this not declared and hw_control_status() returning true,
    it's assumed that the LED is always in hardware mode.
- hw_control_stop(): This will simply disable the hardware mode for
    the LED.
    With this not declared and hw_control_status() returning true,
    it's assumed that the LED is always in hardware mode.
    It's advised to the driver to put the LED in the old state but this
    is not enforcerd and putting the LED off is also accepted.

With HARDWARE_CONTROLLED blink_mode hw_control_status/start/stop is
optional and any software only trigger will reject activation as the LED
supports only hardware mode.

An additional config CONFIG_LEDS_HARDWARE_CONTROL is added to add support
for LEDs that can be controlled by hardware.

Cc: Marek Behún <kabel@kernel.org>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 Documentation/leds/leds-class.rst | 28 ++++++++++++++++++
 drivers/leds/Kconfig              | 11 ++++++++
 drivers/leds/led-class.c          | 27 ++++++++++++++++++
 drivers/leds/led-triggers.c       | 29 +++++++++++++++++++
 include/linux/leds.h              | 47 ++++++++++++++++++++++++++++++-
 5 files changed, 141 insertions(+), 1 deletion(-)

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
index cd155ead8703..645940b78d81 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -169,6 +169,34 @@ Setting the brightness to zero with brightness_set() callback function
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
+blink_mode parameter to one of HARDWARE_CONTROLLED or SOFTWARE_HARDWARE_CONTROLLED.
+The trigger will check this option and fail to activate if the blink_mode is not
+supported. By default if a LED driver doesn't declare blink_mode, SOFTWARE_CONTROLLED
+is assumed.
+
+The LED must implement 3 main API:
+- hw_control_status(): This asks the LED driver if hardware mode is enabled
+    or not. Triggers will check if the hardware mode is active and will try
+    to offload their triggers if supported by the driver.
+- hw_control_start(): This will simply enable the hardware mode for the LED.
+- hw_control_stop(): This will simply disable the hardware mode for the LED.
+    It's advised to the driver to put the LED in the old state but this is not
+    enforcerd and putting the LED off is also accepted.
+
+With HARDWARE_CONTROLLED blink_mode hw_control_status/start/stop is optional
+and any software only trigger will reject activation as the LED supports only
+hardware mode.
 
 Known Issues
 ============
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 499d0f215a8b..891f4821b2c8 100644
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
index 6a8ea94834fa..3516ae3c4c3c 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -164,6 +164,27 @@ static void led_remove_brightness_hw_changed(struct led_classdev *led_cdev)
 }
 #endif
 
+#ifdef CONFIG_LEDS_HARDWARE_CONTROL
+static int led_classdev_check_blink_mode_functions(struct led_classdev *led_cdev)
+{
+	int mode = led_cdev->blink_mode;
+
+	if (mode == SOFTWARE_HARDWARE_CONTROLLED &&
+	    (!led_cdev->hw_control_status ||
+	    !led_cdev->hw_control_start ||
+	    !led_cdev->hw_control_stop))
+		return -EINVAL;
+
+	if (mode == SOFTWARE_CONTROLLED &&
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
@@ -367,6 +388,12 @@ int led_classdev_register_ext(struct device *parent,
 	if (ret < 0)
 		return ret;
 
+#ifdef CONFIG_LEDS_HARDWARE_CONTROL
+	ret = led_classdev_check_blink_mode_functions(led_cdev);
+	if (ret < 0)
+		return ret;
+#endif
+
 	mutex_init(&led_cdev->led_access);
 	mutex_lock(&led_cdev->led_access);
 	led_cdev->dev = device_create_with_groups(leds_class, parent, 0,
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 072491d3e17b..693c5d0fa980 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -154,6 +154,27 @@ ssize_t led_trigger_read(struct file *filp, struct kobject *kobj,
 }
 EXPORT_SYMBOL_GPL(led_trigger_read);
 
+static bool led_trigger_is_supported(struct led_classdev *led_cdev,
+				     struct led_trigger *trigger)
+{
+	switch (led_cdev->blink_mode) {
+	case SOFTWARE_CONTROLLED:
+		if (trigger->supported_blink_modes == HARDWARE_ONLY)
+			return 0;
+		break;
+	case HARDWARE_CONTROLLED:
+		if (trigger->supported_blink_modes == SOFTWARE_ONLY)
+			return 0;
+		break;
+	case SOFTWARE_HARDWARE_CONTROLLED:
+		break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
 /* Caller must ensure led_cdev->trigger_lock held */
 int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 {
@@ -179,6 +200,10 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 
 		cancel_work_sync(&led_cdev->set_brightness_work);
 		led_stop_software_blink(led_cdev);
+		/* Disable hardware mode on trigger change if supported */
+		if (led_cdev->blink_mode != SOFTWARE_CONTROLLED &&
+		    led_cdev->hw_control_status(led_cdev))
+			led_cdev->hw_control_stop(led_cdev);
 		if (led_cdev->trigger->deactivate)
 			led_cdev->trigger->deactivate(led_cdev);
 		device_remove_groups(led_cdev->dev, led_cdev->trigger->groups);
@@ -188,6 +213,10 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
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
index ba4861ec73d3..09ff1dc6f48d 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -67,6 +67,12 @@ struct led_hw_trigger_type {
 	int dummy;
 };
 
+enum led_blink_modes {
+	SOFTWARE_CONTROLLED = 0x0,
+	HARDWARE_CONTROLLED,
+	SOFTWARE_HARDWARE_CONTROLLED,
+};
+
 struct led_classdev {
 	const char		*name;
 	unsigned int brightness;
@@ -154,6 +160,32 @@ struct led_classdev {
 
 	/* LEDs that have private triggers have this set */
 	struct led_hw_trigger_type	*trigger_type;
+
+	/* This report the supported blink_mode. The driver should report the
+	 * correct LED capabilities.
+	 * With this set to HARDWARE_CONTROLLED, LED is always in offload mode
+	 * and triggers can't be simulated by software.
+	 * If the led is HARDWARE_CONTROLLED, status/start/stop function
+	 * are optional.
+	 * By default SOFTWARE_CONTROLLED is set as blink_mode.
+	 */
+	enum led_blink_modes	blink_mode;
+#ifdef CONFIG_LEDS_HARDWARE_CONTROL
+	/* Ask the LED driver if hardware mode is enabled or not.
+	 * If the option is not declared by the LED driver, SOFTWARE_CONTROLLED
+	 * is assumed.
+	 * Triggers will check if the hardware mode is supported and will be
+	 * activated accordingly. If the trigger can't run in hardware mode,
+	 * return -EOPNOTSUPP as the blinking can't be simulated by software.
+	 */
+	bool			(*hw_control_status)(struct led_classdev *led_cdev);
+	/* Set LED in hardware mode */
+	int			(*hw_control_start)(struct led_classdev *led_cdev);
+	/* Disable hardware mode for LED. It's advised to the LED driver to put it to
+	 * the old status but that is not mandatory and also putting it off is accepted.
+	 */
+	int			(*hw_control_stop)(struct led_classdev *led_cdev);
+#endif
 #endif
 
 #ifdef CONFIG_LEDS_BRIGHTNESS_HW_CHANGED
@@ -215,7 +247,6 @@ extern struct led_classdev *of_led_get(struct device_node *np, int index);
 extern void led_put(struct led_classdev *led_cdev);
 struct led_classdev *__must_check devm_of_led_get(struct device *dev,
 						  int index);
-
 /**
  * led_blink_set - set blinking with software fallback
  * @led_cdev: the LED to start blinking
@@ -350,12 +381,26 @@ static inline bool led_sysfs_is_disabled(struct led_classdev *led_cdev)
 
 #define TRIG_NAME_MAX 50
 
+enum led_trigger_blink_supported_modes {
+	SOFTWARE_ONLY = SOFTWARE_CONTROLLED,
+	HARDWARE_ONLY = HARDWARE_CONTROLLED,
+	SOFTWARE_HARDWARE = SOFTWARE_HARDWARE_CONTROLLED,
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
2.37.2

