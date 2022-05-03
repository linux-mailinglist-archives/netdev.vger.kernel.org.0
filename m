Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421C351882F
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238139AbiECPV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238104AbiECPVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:21:51 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE6C3A707;
        Tue,  3 May 2022 08:18:17 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id l7so34135150ejn.2;
        Tue, 03 May 2022 08:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YD8HL+QQXXNygErRS0QTa/lYoHOoQ4QJTCFR4YQ1N8I=;
        b=TTYXsoGmEhS1qQTso+FAAjkTHFgF6JcUqZfrUvYpFQ01dyCmFaXHDoCiny4YkEQ0jr
         s//mmeL7G0I5GFf0vxAi5v6Xnfcg08003c6Evdoauxc/XFC2/n89iVpJ8LDLiyXcDuVt
         YkzW1SDLNv2BBVUOzrT+/UHauf0r6dky7pUpaM6FGnCOjd69JzmXSupgSTfWGBb6vHkx
         Yn4ND+IZHBpLgRIEOt9LvnVl+vom442y3ycD9oqRe380s4F3+6BLEeHe08uAH2zSS/aL
         dQPw8tNxL4Z1IH8fhwYj9dOzwghQ6K3nlZYkyvZO07TIR8oGbJQsC8Lf+8awD2IWGEWw
         Y2Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YD8HL+QQXXNygErRS0QTa/lYoHOoQ4QJTCFR4YQ1N8I=;
        b=aDFMyL8bvAMGNCJ9TBUIXS2SFwIY953UiB7g2gA9DAoEe1ID+3OmSn9UEZYanIQhIr
         rrk3481gfmnV/geVOosnuV/u2X3m2KH6kMLmkaBHcGP++GDGzMAeBe4ZP3XaRUiopv+Z
         5roM2GKu11E9dS/Hn3unEPwSdtTHxC9KeWSwabJs699DYpLmncIaeX5cWY91pKEhun7G
         4+oSiFlfZCE0cs38QcRXnB1KO44o9tRQicA58WSsZynq/CgTis4KzOIz/wUcLou2vt8d
         akYbbmvhPUoNS/K9kyZwVaB+vqXHsFPgf5JYOG6Ax8WqZ3AHpqBev65sHkhdlnAtCOee
         +i9g==
X-Gm-Message-State: AOAM533vyYJaefRtKzYJdUF1ypdNZmyjnUAjAl0a5njaCjHDrktrqw+h
        i4oEQA58a7aqm3vmGXtI+6A=
X-Google-Smtp-Source: ABdhPJwA2xn6DxGEBOGePH9Byz9P2IcABI2GcFUx9Fhj8oPtqtxcA3X5rR1lzR4QUXPmFTFz2mfPVQ==
X-Received: by 2002:a17:907:97cf:b0:6df:846f:ad0a with SMTP id js15-20020a17090797cf00b006df846fad0amr16000853ejc.286.1651591095745;
        Tue, 03 May 2022 08:18:15 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id v3-20020aa7d9c3000000b0042617ba63cesm7947507eds.88.2022.05.03.08.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 08:18:14 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [RFC PATCH v6 01/11] leds: add support for hardware driven LEDs
Date:   Tue,  3 May 2022 17:16:23 +0200
Message-Id: <20220503151633.18760-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220503151633.18760-1-ansuelsmth@gmail.com>
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 6090e647daee..965aa8ba5164 100644
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
2.34.1

