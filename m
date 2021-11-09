Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F7A44A4A0
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 03:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239280AbhKIC3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 21:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240308AbhKIC3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 21:29:01 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB19C061764;
        Mon,  8 Nov 2021 18:26:16 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id v11so68082559edc.9;
        Mon, 08 Nov 2021 18:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=FFynjmtlhdSwmh2Qga59C0YfGk7BBztphHVzn7wUz9Q=;
        b=POCOvYFxFR67j4XjyCRwyE02RR43yUnwGKmj/uDE6nV1yrEvK2sXRR7OS9Muacs29K
         AbbV4jqWathXL3PJn8/TVqDBlFMbTYWwJshgJKnTupV/JvtMEeNUU8h8JjFrek41h9Tv
         SG5Znxs/qKqXq/Fs4anyTRY5vproUN2pnPqqQ8Ga77c0MhNWTFXEpV4bdq8WDFVdHrsM
         2ZXbL//dgOhFPoUFzPZrUHQWR67YmhEc81h4BiJiGuUlF1vOwpmMZpQPEtSnyGf/dacz
         EtZyBJKGN/T5/slG2QdqwWbp1JHFS8WeqWWYDoEowvy2dD32/0DkLZeyCYPyrBYZDNpQ
         JsDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FFynjmtlhdSwmh2Qga59C0YfGk7BBztphHVzn7wUz9Q=;
        b=r4klONcyS2yrD3bW1NNbvnAbJtKHAbQZJm9jFAivWqp5EyJBhDe8/ymw6OZ0zOUdlB
         PgUn+LG33wHvDa1NB8wWivGHqtorCCc+4eFuOkH3XY2NlrMOmodEn3DTb7Sx0WbwcvQh
         P9lWgHqOBYmNlJSEiwkq9/exPo5hQFV9aLlt+Elq2JqxfNdVfqFPvjN1xtxQj+A9pTbu
         vZuIE0+Ed3UdRFBIbugTZQtTEoiCmKMXVU6QBfPIEENbiIehRzog49+tBcy4I6cxkvmB
         J5pYukpqMk9BnObwouCJT9aBagdf1S2tiem3IvopltdS1ljK3YnLEK6L2wW8FLg5hYXq
         zoVw==
X-Gm-Message-State: AOAM533PfvEv7tvJE7gA2Hyx2SRJ81AjzV1/rEBzZEDQkVlZMorOZPx6
        5vZJWpcvULFzQTHiXkp3D8k=
X-Google-Smtp-Source: ABdhPJzJeBHRS2P2HoMhaYlxq6cjm3QntZ2KXWEy2q8L5cj23N8HpZWPnzhnJ35M9gD1YTLJ0QtSpg==
X-Received: by 2002:a17:906:3d32:: with SMTP id l18mr4994365ejf.393.1636424775000;
        Mon, 08 Nov 2021 18:26:15 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m5sm8760900ejc.62.2021.11.08.18.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 18:26:14 -0800 (PST)
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
Subject: [RFC PATCH v3 1/8] leds: add support for hardware driven LEDs
Date:   Tue,  9 Nov 2021 03:26:01 +0100
Message-Id: <20211109022608.11109-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211109022608.11109-1-ansuelsmth@gmail.com>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
- trigger_offload_status(): This asks the LED driver if offload mode is
    enabled or not.
    Triggers will check if the offload mode is supported and will be
    activated accordingly. If the trigger can't run in software mode,
    return -EOPNOTSUPP as the blinking can't be simulated by software.
- trigger_offload_start(): This will simply enable the offload mode for
    the LED.
    With this not declared and trigger_offload_status() returning true,
    it's assumed that the LED is always in offload mode.
- trigger_offload_stop(): This will simply disable the offload mode for
    the LED.
    With this not declared and trigger_offload_status() returning true,
    it's assumed that the LED is always in offload mode.
    It's advised to the driver to put the LED in the old state but this
    is not enforcerd and putting the LED off is also accepted.

With HARDWARE_CONTROLLED blink_mode trigger_offload_status/start/stop is
optional and any software only trigger will reject activation as the LED
supports only hardware mode.

An additional config CONFIG_LEDS_HARDWARE_CONTROL is added to add support
for LEDs that can be controlled by hardware.

Cc: Marek Behún <kabel@kernel.org>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
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
index ed800f5da7d8..bd2b19cc77ec 100644
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
index f4bb02f6e042..1df782ecac66 100644
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
index ba4861ec73d3..cf0c6005c297 100644
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
+	 * if is task is only configure LED blink modes and expose
+	 * them in sysfs.
+	 */
+	enum led_trigger_blink_supported_modes supported_blink_modes;
+
 	/* LED-private triggers have this set */
 	struct led_hw_trigger_type *trigger_type;
 
-- 
2.32.0

