Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FA444CED0
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 02:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbhKKBiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 20:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbhKKBh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 20:37:57 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD2EC061766;
        Wed, 10 Nov 2021 17:35:08 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id d72-20020a1c1d4b000000b00331140f3dc8so3311139wmd.1;
        Wed, 10 Nov 2021 17:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=CRwgLFkTE2iHeZ7Fledznp89U715UmxDDSYLUbCgdrw=;
        b=OJUkBu+wS8UFFvXDO2hE/YMMymEdXgtKYwLhbfUszClxbeDfTfWWvCh1Yxzvr5Cvkt
         q0EQjG0+4DfYMUKDQXZf9Pq+zqUYMo7PtKHap+vD6S/dMZ+6/fwh1SRXdSA40k9FrveT
         bcxGRPGuZB+c9lGvOrsiNlq3yHzaYL09ObpkyX3QGx2beqxRQuprVOr/swCviDJdZA98
         fds85FHA1mr8Gud+Ys1tDPVdJervt6jpMIOwbcI7im4gJUtGfpdpNdN4FYWMiFEKecD2
         J+mB01qNc6+1SwRleWFiQj6OyWiNEwfpytk1zVUVxdKuAsgDJHT7D10GS3sAOFl75OKa
         0JJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CRwgLFkTE2iHeZ7Fledznp89U715UmxDDSYLUbCgdrw=;
        b=weS+uVyb4quRk5Ddt5bwsuJ/Tcb+9R/nCm71SONzfOTuwsY6aYgEFYFhgkiRA5mkSV
         ut/dvCWWQj9h8BbiLT1tYEYE+ZmGQl7otmxzTSKxbAj5NodzfkdASXMYUIeky2XcoKIg
         rNBdXYb2KwaIPBlYm6BKKljHHxVBYB65gmmCpgn4y/4kvC33EVXp1/syvi2eGhtARwz+
         BqxTrBLJMV0vi/Sh8PE8pBRdanm8qtut3/eSCuEane6wnWwWSa6gsvFNUVGKRLNV6Rmh
         jcxq6Btki7wTZ8hb9Dfzn1G2sa3ue1D7JN7fB6R5QXqnZvs0IeaC1Wp92tpcxnRoJmha
         BVXg==
X-Gm-Message-State: AOAM531MIot7PbD57JvDNYI0PHrGMrJ8aIZ0794duTHTPH+sxbesJ/k5
        o1D57asD/tEctpvMh8zk4k8=
X-Google-Smtp-Source: ABdhPJyZaoL+PokYngD329Jx/C+UEebhRRhOKxkdqUsR3YlXqg1yeYenLyaQY782IXWvmm6S1PknrA==
X-Received: by 2002:a1c:f601:: with SMTP id w1mr21350094wmc.112.1636594506990;
        Wed, 10 Nov 2021 17:35:06 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id d8sm1369989wrm.76.2021.11.10.17.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 17:35:06 -0800 (PST)
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
Subject: [RFC PATCH v4 1/8] leds: add support for hardware driven LEDs
Date:   Thu, 11 Nov 2021 02:34:53 +0100
Message-Id: <20211111013500.13882-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211111013500.13882-1-ansuelsmth@gmail.com>
References: <20211111013500.13882-1-ansuelsmth@gmail.com>
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

LED driver should declare the correct control mode supported and should
set the LED_SOFTWARE_CONTROLLED or LED_HARDWARE_CONTROLLED bit in the
flags parameter.
The trigger will check these bit and fail to activate if the control mode
is not supported. By default if a LED driver doesn't declare a control
mode, bit LED_SOFTWARE_CONTROLLED is assumed and set by default.

The LED must implement 3 main API:
- hw_control_status(): This asks the LED driver if hardware mode is
    enabled or not.
- hw_control_start(): This will simply enable the hardware mode for the
    LED and the LED driver should reset any active blink_mode.
- hw_control_stop(): This will simply disable the hardware mode for the
    LED. It's advised for the driver to put the LED in the old state but
    this is not enforced and putting the LED off is also accepted.

If LED_HARDWARE_CONTROLLED bit is the only contro mode set
(LED_SOFTWARE_CONTROLLED not set) set hw_control_status/start/stop is
optional as the LED supports only hardware mode and any software only
trigger will reject activation.

On init a LED driver that support a hardware mode should reset every
blink mode set by default.

An additional config CONFIG_LEDS_HARDWARE_CONTROL is added to add support
for LEDs that can be controlled by hardware.

Cc: Marek Behún <kabel@kernel.org>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/leds/leds-class.rst | 32 +++++++++++++++++++++++++++++
 drivers/leds/Kconfig              | 11 ++++++++++
 drivers/leds/led-class.c          | 33 ++++++++++++++++++++++++++++++
 drivers/leds/led-triggers.c       | 22 ++++++++++++++++++++
 include/linux/leds.h              | 34 ++++++++++++++++++++++++++++++-
 5 files changed, 131 insertions(+), 1 deletion(-)

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
index cd155ead8703..0175954717a3 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -169,6 +169,38 @@ Setting the brightness to zero with brightness_set() callback function
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
+LED driver should declare the correct control mode supported and should set
+the LED_SOFTWARE_CONTROLLED or LED_HARDWARE_CONTROLLED bit in the flags
+parameter.
+The trigger will check these bit and fail to activate if the control mode
+is not supported. By default if a LED driver doesn't declare a control mode,
+bit LED_SOFTWARE_CONTROLLED is assumed and set by default.
+
+The LED must implement 3 main API:
+- hw_control_status(): This asks the LED driver if hardware mode is enabled
+    or not.
+- hw_control_start(): This will simply enable the hardware mode for the LED
+    and the LED driver should reset any active blink_mode.
+- hw_control_stop(): This will simply disable the hardware mode for the LED.
+    It's advised to the driver to put the LED in the old state but this is not
+    enforcerd and putting the LED off is also accepted.
+
+If LED_HARDWARE_CONTROLLED bit is the only contro mode set (LED_SOFTWARE_CONTROLLED
+not set) set hw_control_status/start/stop is optional as the LED supports only
+hardware mode and any software only trigger will reject activation.
+
+On init a LED driver that support a hardware mode should reset every blink mode
+set by default.
 
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
index f4bb02f6e042..98a4dc889344 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -164,6 +164,26 @@ static void led_remove_brightness_hw_changed(struct led_classdev *led_cdev)
 }
 #endif
 
+#ifdef CONFIG_LEDS_HARDWARE_CONTROL
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
+#ifdef CONFIG_LEDS_HARDWARE_CONTROL
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
diff --git a/include/linux/leds.h b/include/linux/leds.h
index ba4861ec73d3..d64e5768e7ab 100644
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
@@ -154,6 +159,20 @@ struct led_classdev {
 
 	/* LEDs that have private triggers have this set */
 	struct led_hw_trigger_type	*trigger_type;
+
+#ifdef CONFIG_LEDS_HARDWARE_CONTROL
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
+#endif
 #endif
 
 #ifdef CONFIG_LEDS_BRIGHTNESS_HW_CHANGED
@@ -215,7 +234,6 @@ extern struct led_classdev *of_led_get(struct device_node *np, int index);
 extern void led_put(struct led_classdev *led_cdev);
 struct led_classdev *__must_check devm_of_led_get(struct device *dev,
 						  int index);
-
 /**
  * led_blink_set - set blinking with software fallback
  * @led_cdev: the LED to start blinking
@@ -350,12 +368,26 @@ static inline bool led_sysfs_is_disabled(struct led_classdev *led_cdev)
 
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

