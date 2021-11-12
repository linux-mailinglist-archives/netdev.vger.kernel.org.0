Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C5044EA46
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhKLPjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235276AbhKLPi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:38:57 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CB5C061767;
        Fri, 12 Nov 2021 07:36:06 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id b12so16224304wrh.4;
        Fri, 12 Nov 2021 07:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4jGWHLurbyA4/FNcd6iSsivOCVyFz9hIK/N30AnY3g4=;
        b=dvUVdbRJz8af65msBLml9vdXAaDpZl4VJjWLFvbA/Fn9ZwxgBuyoH+HOAqNGn0ZD6Q
         GM9NqIMPIv4wC8BT9nXMDb1VX+wNB0/m98lC7HHKtHaJZDcaAfRu+emCsQYdAJAezAec
         W4sVnAezjgAqSW+b2Qml4ZcoZRQeRInEQs/ctLcRzPtlJxDs9g83+CG85P5RUOifrYDl
         TcKFyzpe7TAIJ71+6HWc0vPcZpBqd5qu1R1pTe3GS3CVKCi6ZwNfaPwVWoeqCnt4MNDW
         Fw/779dq+/kqakffVO7+km0P724Ry9mjVnryXOzxBCYD9iLheOen8Zf6Bwa+qdaFrh6b
         UWdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4jGWHLurbyA4/FNcd6iSsivOCVyFz9hIK/N30AnY3g4=;
        b=W8F0G9U/HPg+NzbLqxYcWTs/hJAlcIue+M3ZdlzoMYrdYzq2C4cDyUlIcPhp1ywsYn
         mXPpGnXjlEqZUyVMU9bGzXgZ0R761qssjbqSXSaCZhGRkEGUsij5HkWrMquwbvBZ+an3
         txFQPvG5ZvHJ4nPfr0reJwjIOQiK0KMRrtCE4qNypD4LbJbY64f1+RgpHjpnAMswSbsz
         4ZoSXR+GLU2DEX9Y58S8Tb80bgG8/a6DYJKCKqTaP39rOE1V9wFZW+jzc0yjEbOAIjme
         mYgXDgRjFsMgf02E3vY8EwPQS1xuUl3hN6PxcS0VfPLurENEdIPruAmqL2smWHDn5KH/
         Rbpw==
X-Gm-Message-State: AOAM533dgxMZ8BiuGIQ9QPTXk4+EUwXBDpk08XaQJJBJUkZ6TWaHL+rU
        XmUTvvTwn4Rfh5WCeUgRc4U=
X-Google-Smtp-Source: ABdhPJxHqBolAxoEFyGpKEC/hKiG0pOutcmXOe9vu935+06JxkMbxCN0idm2sjgonBaATYsVlvRgYA==
X-Received: by 2002:a5d:5244:: with SMTP id k4mr20074388wrc.77.1636731364446;
        Fri, 12 Nov 2021 07:36:04 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id az4sm4217543wmb.20.2021.11.12.07.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 07:36:04 -0800 (PST)
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
Subject: [PATCH v5 2/8] leds: document additional use of blink_set for hardware control
Date:   Fri, 12 Nov 2021 16:35:51 +0100
Message-Id: <20211112153557.26941-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211112153557.26941-1-ansuelsmth@gmail.com>
References: <20211112153557.26941-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

blink_set can now be used also to configure blink modes when hardware
control is supported and active.
Trigger will try to use blink_set and a LED driver will use the
trigger_data to configure the blink_modes once blink_set is called.
Setting a brightness to LED_OFF will reset any blink mode and disable
hardware control setting the LED off.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/leds/leds-class.rst | 17 +++++++++++++++++
 drivers/leds/led-class.c          |  7 +++++++
 include/linux/leds.h              |  9 +++++++++
 3 files changed, 33 insertions(+)

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
index e5d266919a19..fa6e1cfc4628 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -202,6 +202,23 @@ hardware mode and any software only trigger will reject activation.
 On init an LED driver that support a hardware mode should reset every blink mode
 set by default.
 
+Once a trigger has declared support for hardware-controlled blinks, it will use
+blink_set() to try to offload his trigger on activation/configuration.
+blink_set() will return 0 if the requested modes set in trigger_data can be
+controlled by hardware or an error if both of the bitmap modes are not supported by
+the hardware or there was a problem in the configuration.
+
+Following blink_set logic, setting brightness to LED_OFF with hardware control active
+will reset any active blink mode and disable hardware control setting the LED to off.
+
+It's in the LED driver's interest to know how to elaborate the trigger data and report support
+for a particular set of blink modes. For this exact reason explicit support for the specific
+trigger is mandatory or the driver returns -EOPNOTSUPP if asked to enter hardware mode
+with a not supported trigger.
+If the driver returns -EOPNOTSUPP on hw_control_configure(), the trigger activation will
+fail as the driver doesn't support that specific hardware blink mode or doesn't know
+how to handle the provided trigger data.
+
 Known Issues
 ============
 
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index dbe9840863d0..ebd023e480ac 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -180,6 +180,13 @@ static int led_classdev_check_hw_control_functions(struct led_classdev *led_cdev
 	    led_cdev->hw_control_stop))
 		return -EINVAL;
 
+	/* blink_set is mandatory to configure the blink modes
+	 * in hardware control.
+	 */
+	if ((LED_HARDWARE_CONTROLLED & led_cdev->flags) &&
+	    !led_cdev->blink_set)
+		return -EINVAL;
+
 	return 0;
 }
 #endif
diff --git a/include/linux/leds.h b/include/linux/leds.h
index c8e97fb9252f..fa929215cdcc 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -76,6 +76,7 @@ struct led_classdev {
 	/* Lower 16 bits reflect status */
 #define LED_SUSPENDED		BIT(0)
 #define LED_UNREGISTERING	BIT(1)
+#define LED_HARDWARE_CONTROL	BIT(2)
 	/* Upper 16 bits reflect control information */
 #define LED_CORE_SUSPENDRESUME	BIT(16)
 #define LED_SYSFS_DISABLE	BIT(17)
@@ -123,6 +124,12 @@ struct led_classdev {
 	 * match the values specified exactly.
 	 * Deactivate blinking again when the brightness is set to LED_OFF
 	 * via the brightness_set() callback.
+	 * With LED_HARDWARE_CONTROL set in LED flags blink_set will also
+	 * configure blink modes requested by the current trigger if
+	 * supported by the LED driver.
+	 * Setting brightness to LED_OFF with hardware control active will
+	 * reset any active blink mode and disable hardware control setting
+	 * the LED off.
 	 */
 	int		(*blink_set)(struct led_classdev *led_cdev,
 				     unsigned long *delay_on,
@@ -165,6 +172,8 @@ struct led_classdev {
 	 */
 	bool			(*hw_control_status)(struct led_classdev *led_cdev);
 	/* Set LED in hardware mode and reset any blink mode active by default.
+	 * A trigger supporting hardware mode will have to use blink_set to configure
+	 * the modes.
 	 */
 	int			(*hw_control_start)(struct led_classdev *led_cdev);
 	/* Disable hardware mode for LED. It's advised to the LED driver to put it to
-- 
2.32.0

