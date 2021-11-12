Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB01044EA42
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbhKLPi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235240AbhKLPiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:38:55 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C98C061766;
        Fri, 12 Nov 2021 07:36:04 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id u1so16147002wru.13;
        Fri, 12 Nov 2021 07:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IwypWslryGEOUCdwRCWHFfnKAKA1I0ITX6IWEz1PyGA=;
        b=D+1BNEy+IXKi93+WqRBgBkVgSyRLtOGDBDzI91k6meQQ1OUSSR4cpBQmgb5LUzi5VH
         W4CwjFcAYd2SFvwOcmt1cvzO9skR3nw3cdgOjfl5Qj48opzDCLMaMxQDd2tQ8/pHTCCN
         Nhn0tbwLYFWSvHsoe/h6CGkn1nAYx1LPlV/Rzd0sbLGGwNpMAvvL8XoJukJLYvAqdyhh
         aWgJl5oVzcWPJBeczAKkiQnLCwlCLtSKPIdC4z/K4Pq24h12HYo6fXEqtAoSQvRtt5gI
         vtTSw8P7HpsM8T89P3kwt9igpsKpwOf1tJtL5s2Q0j630xtIZKOnwk8Kb6WmuMt0g9Y9
         bg2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IwypWslryGEOUCdwRCWHFfnKAKA1I0ITX6IWEz1PyGA=;
        b=4/HSfbATluuNC3dT4LKccNupqYomusgYznrdb6+kZjs6UzgrFu90iGQIY/fYuslo/q
         S2UKUjE5C800qQ0W9zz9r6w/FWZqnPo+bTWMb38yzsVMmwLxvpybwZgKuf0ofN0DnIio
         CROpQjNMT/0W1oaeeXZJEp9pvHFMJDmwKY/HJqOVW2VVPyzsHpulqGGq8f+jIpDfTC11
         KzqXZKLKhFFpQuzIyZg8VB+QVaNynAROd/wvYmAc/kM1CaC9AasMP+97FAEQ/WAXMonH
         pMo+lBT3kFkv3fhKSTu6paJMZTE3Hs+EeKXuU+0U+OnWmmTS6tj0daFM511Dshdq16Vh
         XKXw==
X-Gm-Message-State: AOAM533UrzZ3neZ+7ZbF9sVJpFdzr1WT0cs9yFrhP93MllmTt/Ayq4dx
        LWaxZZifPCgRhD4SI8vEV1A=
X-Google-Smtp-Source: ABdhPJz3ofOdqzNOuVTdKBpaZ3ny1prsA8kyETZphZX+WOFL0Xt3zp8jgoj1yWijqjJJkdYOTWyZkg==
X-Received: by 2002:a05:6000:1869:: with SMTP id d9mr19353352wri.416.1636731363138;
        Fri, 12 Nov 2021 07:36:03 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id az4sm4217543wmb.20.2021.11.12.07.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 07:36:02 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH v5 1/8] leds: add support for hardware driven LEDs
Date:   Fri, 12 Nov 2021 16:35:50 +0100
Message-Id: <20211112153557.26941-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211112153557.26941-1-ansuelsmth@gmail.com>
References: <20211112153557.26941-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some LEDs can be driven by hardware (for example an LED connected to
an ethernet PHY or an ethernet switch can be configured to blink on
activity on the network, which in software is done by the netdev trigger).

To do such offloading, LED driver must support this and a supported
trigger must be used.

LED driver should declare the correct control mode supported and should
set the LED_SOFTWARE_CONTROLLED or LED_HARDWARE_CONTROLLED bit in the
flags parameter.
The trigger will check these bits and fail to activate if the control mode
is not supported. By default if a LED driver doesn't declare a control
mode, bit LED_SOFTWARE_CONTROLLED is assumed and set.

The LED must implement 3 main APIs:
- hw_control_status(): This asks the LED driver if hardware mode is
    enabled or not.
- hw_control_start(): This will simply enable the hardware mode for the
    LED and the LED driver should reset any active blink_mode.
- hw_control_stop(): This will simply disable the hardware mode for the
    LED. It's advised for the driver to put the LED in the old state but
    this is not enforced and putting the LED off is also accepted.

If LED_HARDWARE_CONTROLLED bit is the only control mode set
(LED_SOFTWARE_CONTROLLED not set) set hw_control_status/start/stop is
optional as the LED supports only hardware mode and any software only
trigger will reject activation.

On init an LED driver that support a hardware mode should reset every
blink mode set by default.

By setting the config CONFIG_LEDS_TRIGGERS support for LEDs that can
be controlled by hardware is also enabled.

Cc: Marek Behún <kabel@kernel.org>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/leds/leds-class.rst | 32 ++++++++++++++++++++++++++++++
 drivers/leds/led-class.c          | 33 +++++++++++++++++++++++++++++++
 drivers/leds/led-triggers.c       | 22 +++++++++++++++++++++
 drivers/leds/trigger/Kconfig      | 10 +++++++++-
 include/linux/leds.h              | 32 +++++++++++++++++++++++++++++-
 5 files changed, 127 insertions(+), 2 deletions(-)

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
index cd155ead8703..e5d266919a19 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -169,6 +169,38 @@ Setting the brightness to zero with brightness_set() callback function
 should completely turn off the LED and cancel the previously programmed
 hardware blinking function, if any.
 
+Hardware driven LEDs
+===================================
+
+Some LEDs can be driven by hardware (for example an LED connected to
+an ethernet PHY or an ethernet switch can be configured to blink on activity on
+the network, which in software is done by the netdev trigger).
+
+To do such offloading, LED driver must support this and a supported trigger must
+be used.
+
+LED driver should declare the correct control mode supported and should set
+the LED_SOFTWARE_CONTROLLED or LED_HARDWARE_CONTROLLED bit in the flags
+parameter.
+The trigger will check these bits and fail to activate if the control mode
+is not supported. By default if a LED driver doesn't declare a control mode,
+bit LED_SOFTWARE_CONTROLLED is assumed and set.
+
+The LED must implement 3 main APIs:
+- hw_control_status(): This asks the LED driver if hardware mode is enabled
+    or not.
+- hw_control_start(): This will simply enable the hardware mode for the LED
+    and the LED driver should reset any active blink_mode.
+- hw_control_stop(): This will simply disable the hardware mode for the LED.
+    It's advised to the driver to put the LED in the old state but this is not
+    enforced and putting the LED off is also accepted.
+
+If LED_HARDWARE_CONTROLLED bit is the only control mode set (LED_SOFTWARE_CONTROLLED
+not set) set hw_control_status/start/stop is optional as the LED supports only
+hardware mode and any software only trigger will reject activation.
+
+On init an LED driver that support a hardware mode should reset every blink mode
+set by default.
 
 Known Issues
 ============
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index f4bb02f6e042..dbe9840863d0 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -164,6 +164,26 @@ static void led_remove_brightness_hw_changed(struct led_classdev *led_cdev)
 }
 #endif
 
+#ifdef CONFIG_LEDS_TRIGGERS
+static int led_classdev_check_hw_control_functions(struct led_classdev *led_cdev)
+{
+	if ((LED_SOFTWARE_CONTROLLED & led_cdev->flags) &&
+	    (LED_HARDWARE_CONTROLLED & led_cdev->flags) &&
+	    (!led_cdev->hw_control_status ||
+	    !led_cdev->hw_control_start ||
+	    !led_cdev->hw_control_stop))
+		return -EINVAL;
+
+	if ((LED_SOFTWARE_CONTROLLED & led_cdev->flags) &&
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
@@ -367,6 +387,19 @@ int led_classdev_register_ext(struct device *parent,
 	if (ret < 0)
 		return ret;
 
+	/* Make sure a control mode is set.
+	 * With no control mode declared, set SOFTWARE_CONTROLLED by default.
+	 */
+	if (!(LED_SOFTWARE_CONTROLLED & led_cdev->flags) &&
+	    !(LED_HARDWARE_CONTROLLED & led_cdev->flags))
+		led_cdev->flags |= LED_SOFTWARE_CONTROLLED;
+
+#ifdef CONFIG_LEDS_TRIGGERS
+	ret = led_classdev_check_hw_control_functions(led_cdev);
+	if (ret < 0)
+		return ret;
+#endif
+
 	mutex_init(&led_cdev->led_access);
 	mutex_lock(&led_cdev->led_access);
 	led_cdev->dev = device_create_with_groups(leds_class, parent, 0,
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 072491d3e17b..69dff5a29bea 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -154,6 +154,20 @@ ssize_t led_trigger_read(struct file *filp, struct kobject *kobj,
 }
 EXPORT_SYMBOL_GPL(led_trigger_read);
 
+static bool led_trigger_is_supported(struct led_classdev *led_cdev,
+				     struct led_trigger *trigger)
+{
+	if (trigger->supported_blink_modes == SOFTWARE_ONLY &&
+	    !(LED_SOFTWARE_CONTROLLED & led_cdev->flags))
+		return 0;
+
+	if (trigger->supported_blink_modes == HARDWARE_ONLY &&
+	    !(LED_HARDWARE_CONTROLLED & led_cdev->flags))
+		return 0;
+
+	return 1;
+}
+
 /* Caller must ensure led_cdev->trigger_lock held */
 int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 {
@@ -179,6 +193,10 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 
 		cancel_work_sync(&led_cdev->set_brightness_work);
 		led_stop_software_blink(led_cdev);
+		/* Disable hardware mode on trigger change if supported */
+		if ((led_cdev->flags & LED_HARDWARE_CONTROLLED) &&
+		    led_cdev->hw_control_status(led_cdev))
+			led_cdev->hw_control_stop(led_cdev);
 		if (led_cdev->trigger->deactivate)
 			led_cdev->trigger->deactivate(led_cdev);
 		device_remove_groups(led_cdev->dev, led_cdev->trigger->groups);
@@ -188,6 +206,10 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
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
diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
index dc6816d36d06..18a8970bfae6 100644
--- a/drivers/leds/trigger/Kconfig
+++ b/drivers/leds/trigger/Kconfig
@@ -5,7 +5,15 @@ menuconfig LEDS_TRIGGERS
 	help
 	  This option enables trigger support for the leds class.
 	  These triggers allow kernel events to drive the LEDs and can
-	  be configured via sysfs. If unsure, say Y.
+	  be configured via sysfs.
+
+	  This option also enables Hardware control support used by LEDs
+	  that can be driven in hardware by using supported triggers.
+
+	  Hardware blink modes will be exposed by sysfs class in
+	  /sys/class/leds based on the trigger currently active.
+
+	  If unsure, say Y.
 
 if LEDS_TRIGGERS
 
diff --git a/include/linux/leds.h b/include/linux/leds.h
index ba4861ec73d3..c8e97fb9252f 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -85,6 +85,11 @@ struct led_classdev {
 #define LED_BRIGHT_HW_CHANGED	BIT(21)
 #define LED_RETAIN_AT_SHUTDOWN	BIT(22)
 #define LED_INIT_DEFAULT_TRIGGER BIT(23)
+/* LED can be controlled by software. This is set by default
+ * if the LED driver doesn't report SOFTWARE or HARDWARE
+ */
+#define LED_SOFTWARE_CONTROLLED	BIT(24)
+#define LED_HARDWARE_CONTROLLED	BIT(25)
 
 	/* set_brightness_work / blink_timer flags, atomic, private. */
 	unsigned long		work_flags;
@@ -154,6 +159,18 @@ struct led_classdev {
 
 	/* LEDs that have private triggers have this set */
 	struct led_hw_trigger_type	*trigger_type;
+
+	/* Ask the LED driver if hardware mode is enabled or not.
+	 * Triggers will check if the hardware mode is active or not.
+	 */
+	bool			(*hw_control_status)(struct led_classdev *led_cdev);
+	/* Set LED in hardware mode and reset any blink mode active by default.
+	 */
+	int			(*hw_control_start)(struct led_classdev *led_cdev);
+	/* Disable hardware mode for LED. It's advised to the LED driver to put it to
+	 * the old status but that is not mandatory and also putting it off is accepted.
+	 */
+	int			(*hw_control_stop)(struct led_classdev *led_cdev);
 #endif
 
 #ifdef CONFIG_LEDS_BRIGHTNESS_HW_CHANGED
@@ -215,7 +232,6 @@ extern struct led_classdev *of_led_get(struct device_node *np, int index);
 extern void led_put(struct led_classdev *led_cdev);
 struct led_classdev *__must_check devm_of_led_get(struct device *dev,
 						  int index);
-
 /**
  * led_blink_set - set blinking with software fallback
  * @led_cdev: the LED to start blinking
@@ -350,12 +366,26 @@ static inline bool led_sysfs_is_disabled(struct led_classdev *led_cdev)
 
 #define TRIG_NAME_MAX 50
 
+enum led_trigger_blink_supported_modes {
+	SOFTWARE_ONLY = BIT(0),
+	HARDWARE_ONLY = BIT(1),
+	SOFTWARE_HARDWARE = BIT(2),
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
+	 * if is task is only configure LED blink modes and expose
+	 * them in sysfs.
+	 */
+	enum led_trigger_blink_supported_modes supported_blink_modes;
+
 	/* LED-private triggers have this set */
 	struct led_hw_trigger_type *trigger_type;
 
-- 
2.32.0

