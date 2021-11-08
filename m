Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B184476E1
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 01:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236809AbhKHA1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 19:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbhKHA1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 19:27:49 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D91DC061570;
        Sun,  7 Nov 2021 16:25:06 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id j21so55504246edt.11;
        Sun, 07 Nov 2021 16:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1J/Wz/1ljWta/ijf6VTHqMRxNuGNDGOOF5jyDMPGesw=;
        b=i8QlGmQ2W1f2kJiyJiIGfGCnt45aCL2frADBunjLTxKdHu/p/2iqs7Y5E4/U6SLpVP
         vk9NN0Dhyay0YuFbMqZQgoAuwKPvFNsJmzQvEkK6dqHpw4Ff9zCMSPAr6Z4bIU6jq9ui
         eSFNKnu6oebPNQMZEMEnzsIVjLpFinke0Es+NtjpB86iFzG55mJhbkocLHilTkugp+2Q
         UbZaNmp4DEtxQ5pmSIWtQgq9ij3kPIgg73h7Bnuz9XtrbeqzgbBO/45h7i+E5EC+lclg
         QUQPYjJjwZtyi/s2+4ewtM/wGvyxfDhblCH3yH+8JxO5BmKDev0wSK3dp4PMiUEzIDJ4
         6jWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1J/Wz/1ljWta/ijf6VTHqMRxNuGNDGOOF5jyDMPGesw=;
        b=e9jNW5j4e8wkRQNNgsTh8AURxulwjsK4+Fs8/oOdV+6FYKqB1weTLnbedZ8RCaLcvS
         EExJYCL6FlhBdpN/pL7+vuEF0FtKVL063Hu2JdwD8N+xAtMhVKaDt49lj2mYyWPoF9xg
         KVymJZdBewlKQ2JbP2R7ReMT1DXzKF9VG/bZwpmNCPdpnqz0N17bbD9c+IQKdFzl+bok
         sN71J0FP7XQZDq4A7jYG9YXMI6Z4Z0W6P0FjJKXeWBbqIX8dY8PfWAbQvcHSyG9JyDgr
         ZcyYTAYSJZZVP0cawMPHlBmq9P+kEi2fZzrVTwfAOTQGbJa/kvm7te6OqBKVs3FykkWV
         x8/w==
X-Gm-Message-State: AOAM530O9GY32344MbEtBJX8W4uwc5gxm683aWJZRxZYvSG68Hf97hgg
        uojWsnkuaVIoFU7HLH01EdYpnTf/QAY=
X-Google-Smtp-Source: ABdhPJynpInC5TfqlyhmhZ79G4P1Op+gbixpbsM8IdypfMm8eaV6YafRoDb6KIQC83Sqqz8vZ94IRw==
X-Received: by 2002:a17:906:314e:: with SMTP id e14mr92728525eje.165.1636331104667;
        Sun, 07 Nov 2021 16:25:04 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id bf8sm8537878edb.46.2021.11.07.16.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 16:25:04 -0800 (PST)
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
Subject: [RFC PATCH v2 1/5] leds: trigger: add API for HW offloading of triggers
Date:   Mon,  8 Nov 2021 01:24:56 +0100
Message-Id: <20211108002500.19115-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211108002500.19115-1-ansuelsmth@gmail.com>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
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
 Documentation/leds/leds-class.rst | 20 +++++++++++++++++++
 drivers/leds/led-triggers.c       |  1 +
 drivers/leds/trigger/Kconfig      | 10 ++++++++++
 include/linux/leds.h              | 33 +++++++++++++++++++++++++++++++
 4 files changed, 64 insertions(+)

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
index cd155ead8703..5bf6e5d471ce 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -169,6 +169,26 @@ Setting the brightness to zero with brightness_set() callback function
 should completely turn off the LED and cancel the previously programmed
 hardware blinking function, if any.
 
+Hardware offloading of LED triggers
+===================================
+
+Some LEDs can be driven by hardware triggers (for example a LED connected to
+an ethernet PHY or an ethernet switch can be configured to blink on activity on
+the network, which in software is done by the netdev trigger).
+
+To do such offloading, LED driver must support this and a deficated offload
+trigger must be used. The LED must implement the trigger_offload() method and
+the trigger code must try to call this method (via led_trigger_offload()
+function) to set the LED to this particular mode. (and disable any software
+blinking)
+
+The implementation of the trigger_offload() method by the LED driver must return
+0 if the offload is successful and -EOPNOTSUPP if the requested trigger
+configuration is not supported.
+
+If the second argument (enable) to the trigger_offload() method is false, any
+active HW offloading must be deactivated. In this case errors are not permitted
+in the trigger_offload() method and the driver will be set to the new trigger.
 
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
index dc6816d36d06..33aba8defeab 100644
--- a/drivers/leds/trigger/Kconfig
+++ b/drivers/leds/trigger/Kconfig
@@ -9,6 +9,16 @@ menuconfig LEDS_TRIGGERS
 
 if LEDS_TRIGGERS
 
+config LEDS_OFFLOAD_TRIGGERS
+	bool "LED Offload Trigger support"
+	help
+	  This option enabled offload triggers support used by leds that
+	  can be driven in hardware by declaring some specific triggers.
+	  A offload trigger will expose a sysfs dir to configure the
+	  different blinking trigger and the available hardware triggers.
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

