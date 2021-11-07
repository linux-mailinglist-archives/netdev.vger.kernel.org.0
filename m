Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03DA14474C2
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 18:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbhKGSAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 13:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236037AbhKGSAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 13:00:39 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75758C061570;
        Sun,  7 Nov 2021 09:57:56 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id w1so53683129edd.10;
        Sun, 07 Nov 2021 09:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qsrWkEZJe3KJI4dG+ley0IYfo6K833DEzNzDa11eMDg=;
        b=WH74vJyAcBWvvxgL8gPD9QqwVcy0mV4+mY2nzQ9Pjq4GtSIAQ0hcrawI3Pjbw5oJTF
         wPPupxLS/wg0qNAfmk0gQ5sANbaOBDPUaJ8shvQ6Q801dOZaVSu/sAqAZOWd7AONjyoJ
         H+h23Qo+CJqSmNO2x8Q1fAY1sZNvjO6HdQORH8n/EafVRMQcXGnObzhcvn5c6qcEXnSY
         cWupeo3ezFE8zXCxN2cctlcktauHgR1KcyeDtthKbWkLJ5jbP7SCI1TKu6vdONj1uOqF
         SwssNHXuprCjRvJ5OEcTrB4hAM0FILOV/Ya4C2lHVVzasvUdUlxllwsrBBrtwZ7WBArC
         M7FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qsrWkEZJe3KJI4dG+ley0IYfo6K833DEzNzDa11eMDg=;
        b=4IO5VsX8i3h+hqcIRjnEq8Uw1xMnTiXAfS6cnBz1ZKAniYQN35hIXTZcqe03jOYhbH
         HzxY2XUHe67rwomy7zNp7z9hscTcx3WG1+JplVNPp9FvW7jes6pnJEQWDP4mg14zBTDK
         Bb8m8YuTBfUzBPlhBpLPDp99ZIZlrP/XMzslqedE2cqYPx363eJClm34lYcUSdMCqSCq
         5i4CnqWQXuv3eFIQalE0RvmF2FgzOy8SJLydzu1rfbW1n+7fj5q7PWQXH9f2d0UOSSOy
         J6aamvlIN2koQbObg0bF4MWX6+B2UlNYHuuMNIR3x5bFmoR3b4a6wgVJePKCib79q/r8
         VPxA==
X-Gm-Message-State: AOAM533Np6ET+XOAWXTR2dtXtRmLFiYZE4SBbSbM/vd6xeFfplVhvO76
        k5OKC4dZzOMgpKYRpT8ByJY=
X-Google-Smtp-Source: ABdhPJwJFYrVyYUMXRXCWjYkG6FK1+ODCXxf44AZwrkW5SGScnit2++8BNPsHjMQ0uFdQXR4V6YaAg==
X-Received: by 2002:a17:906:ce2a:: with SMTP id sd10mr49478290ejb.154.1636307874921;
        Sun, 07 Nov 2021 09:57:54 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m11sm4251182edd.58.2021.11.07.09.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 09:57:54 -0800 (PST)
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
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [RFC PATCH 1/6] leds: trigger: add API for HW offloading of triggers
Date:   Sun,  7 Nov 2021 18:57:13 +0100
Message-Id: <20211107175718.9151-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211107175718.9151-1-ansuelsmth@gmail.com>
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

Add method trigger_offload() and member variable `offloaded` to struct
led_classdev. Add helper functions led_trigger_offload() and
led_trigger_offload_stop().

The trigger_offload() method, when implemented by the LED driver, should
be called (via led_trigger_offload() function) from trigger code wanting
to be offloaded at the moment when configuration of the trigger changes.

If the trigger is successfully offloaded, this method returns 0 and the
trigger does not have to blink the LED in software.

If the trigger with given configuration cannot be offloaded, the method
should return -EOPNOTSUPP, in which case the trigger must blink the LED
in SW.

The second argument to trigger_offload() being false means that the
offloading is being disabled. In this case the function must return 0,
errors are not permitted.

An additional config CONFIG_LEDS_OFFLOAD_TRIGGERS is added to add support
for these special trigger offload driven.

Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/leds/leds-class.rst | 22 +++++++++++++++++++++
 drivers/leds/led-triggers.c       |  1 +
 drivers/leds/trigger/Kconfig      | 10 ++++++++++
 include/linux/leds.h              | 33 +++++++++++++++++++++++++++++++
 4 files changed, 66 insertions(+)

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
index cd155ead8703..035a738afc4a 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -169,6 +169,28 @@ Setting the brightness to zero with brightness_set() callback function
 should completely turn off the LED and cancel the previously programmed
 hardware blinking function, if any.
 
+Hardware offloading of LED triggers
+===================================
+
+Some LEDs can offload SW triggers to hardware (for example a LED connected to
+an ethernet PHY or an ethernet switch can be configured to blink on activity on
+the network, which in software is done by the netdev trigger).
+
+To do such offloading, LED driver must support the this and a deficated offload
+trigger must be used. The LED must implement the trigger_offload() method and
+the trigger code must try to call this method (via led_trigger_offload()
+function) when configuration of the trigger (trigger_data) changes.
+
+The implementation of the trigger_offload() method by the LED driver must return
+0 if the offload is successful and -EOPNOTSUPP if the requested trigger
+configuration is not supported and the trigger should be executed in software.
+If trigger_offload() returns negative value, the triggering will be done in
+software, so any active offloading must also be disabled.
+
+If the second argument (enable) to the trigger_offload() method is false, any
+active HW offloading must be deactivated. In this case errors are not permitted
+in the trigger_offload() method.
+
 
 Known Issues
 ============
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 072491d3e17b..281c52914f42 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -179,6 +179,7 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 
 		cancel_work_sync(&led_cdev->set_brightness_work);
 		led_stop_software_blink(led_cdev);
+		led_trigger_offload_stop(led_cdev);
 		if (led_cdev->trigger->deactivate)
 			led_cdev->trigger->deactivate(led_cdev);
 		device_remove_groups(led_cdev->dev, led_cdev->trigger->groups);
diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
index dc6816d36d06..c073e64e0a37 100644
--- a/drivers/leds/trigger/Kconfig
+++ b/drivers/leds/trigger/Kconfig
@@ -9,6 +9,16 @@ menuconfig LEDS_TRIGGERS
 
 if LEDS_TRIGGERS
 
+config LEDS_OFFLOAD_TRIGGERS
+	bool "LED Offload Trigger support"
+	help
+	  This option enabled offload triggers support used by leds that
+	  can be driven in HW by declaring some specific triggers.
+	  A offload trigger will expose a sysfs dir to configure the
+	  different blinking trigger and the available hw trigger.
+
+	  If unsure, say Y.
+
 config LEDS_TRIGGER_TIMER
 	tristate "LED Timer Trigger"
 	help
diff --git a/include/linux/leds.h b/include/linux/leds.h
index ba4861ec73d3..949ab461287f 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -154,6 +154,13 @@ struct led_classdev {
 
 	/* LEDs that have private triggers have this set */
 	struct led_hw_trigger_type	*trigger_type;
+
+#ifdef CONFIG_LEDS_OFFLOAD_TRIGGERS
+	int			offloaded;
+	/* some LEDs cne be driven by HW */
+	int			(*trigger_offload)(struct led_classdev *led_cdev,
+						   bool enable);
+#endif
 #endif
 
 #ifdef CONFIG_LEDS_BRIGHTNESS_HW_CHANGED
@@ -409,6 +416,32 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 	return led_cdev->trigger_data;
 }
 
+#ifdef CONFIG_LEDS_OFFLOAD_TRIGGERS
+static inline int led_trigger_offload(struct led_classdev *led_cdev)
+{
+	int ret;
+
+	if (!led_cdev->trigger_offload)
+		return -EOPNOTSUPP;
+
+	ret = led_cdev->trigger_offload(led_cdev, true);
+	led_cdev->offloaded = !ret;
+
+	return ret;
+}
+
+static inline void led_trigger_offload_stop(struct led_classdev *led_cdev)
+{
+	if (!led_cdev->trigger_offload)
+		return;
+
+	if (led_cdev->offloaded) {
+		led_cdev->trigger_offload(led_cdev, false);
+		led_cdev->offloaded = false;
+	}
+}
+#endif
+
 /**
  * led_trigger_rename_static - rename a trigger
  * @name: the new trigger name
-- 
2.32.0

