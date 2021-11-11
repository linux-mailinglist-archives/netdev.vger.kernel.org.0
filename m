Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F26844CED3
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 02:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbhKKBiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 20:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbhKKBh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 20:37:58 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26395C061766;
        Wed, 10 Nov 2021 17:35:10 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id d3so7071297wrh.8;
        Wed, 10 Nov 2021 17:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0YrpzavklP9dMJB93nfekw1m/g07assYZhHItNmGSCM=;
        b=nGWj2PmAQYdy5wvKH1ougucvO6gBTVjWUlPqRvPjN3yBtMl9MYolfA3ps7J03bs0s+
         LvM/oxfhyCqYqmfC7M1kQC84oXkKxCCG7R8G5ZGLs6KhM/2lYutJaR0taklxCIQwjwuB
         RWUlubEovhkyze2XmNQ5j5g5oOqGXu+IpNM4kyZQNhqHnzmbCfYCVyaqHsoZvc9t9oPD
         /P4TF1F+mcmmv0RnbjwQl1Y2Vtnco5De2jecllzsjGoLTX+cyh/07f3QkYlCnuN8GObK
         tnHmMrMWTaZrFKLyukKyWGYYBa0PwlpP6X7sWGT3I5RRzYBD8qQqN2XMWNKWx4NkMDCo
         xjTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0YrpzavklP9dMJB93nfekw1m/g07assYZhHItNmGSCM=;
        b=MmfpWzQrpeTQVYZCkyJ2OBN7+tQhU9bhe1LB7mboV0QEHgkPpzCcJuN3ZfvHT+DeOk
         QB1BPfQWz/TtQkiqEI7SD+Xs6MN5loVNBXBI0wjeqSlEfq7XOkoKGlnV1WvZClb6k2iL
         r/fqn92Q+m0HKI+RloQ7oGvRwuRnykcXU1ov+mApy4sTBgnM0GDVM7sCG+skY8UispQK
         bsEpJN1HtuMHJsLTdzoynfJqjR1Yu4G006nXLSZKErnuZ/etz/JR5uIDEBLxUpo+AleN
         Z4x3WEPDVCZhhPKmioGQqAi3EhsIi+qdrKlsnmglcEEZBJVVSY9wlug9jMRy/bGhDuD/
         tN2g==
X-Gm-Message-State: AOAM531xi+bN9j5aysDSLowa0ljKLNJh6EDvvCPmB14t17kaIzIi1cGg
        opaEJwcEDI072ae/dp/IfA8=
X-Google-Smtp-Source: ABdhPJxr1RtvUxWpTBYLCpz7ZcDlwtc7SrTS98C9bZ8eiNNszCnMjb0aDayV8Zz3ufJzieXBU6c5iw==
X-Received: by 2002:adf:eac8:: with SMTP id o8mr4401287wrn.337.1636594508534;
        Wed, 10 Nov 2021 17:35:08 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id d8sm1369989wrm.76.2021.11.10.17.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 17:35:08 -0800 (PST)
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
Subject: [RFC PATCH v4 2/8] leds: document additional use of blink_set for hardware control
Date:   Thu, 11 Nov 2021 02:34:54 +0100
Message-Id: <20211111013500.13882-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211111013500.13882-1-ansuelsmth@gmail.com>
References: <20211111013500.13882-1-ansuelsmth@gmail.com>
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
index 0175954717a3..c06a18b811de 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -202,6 +202,23 @@ hardware mode and any software only trigger will reject activation.
 On init a LED driver that support a hardware mode should reset every blink mode
 set by default.
 
+Once a trigger has declared support for hardware-controller blinks, it will use
+blink_set() to try to offload his trigger on activation/configuration.
+blink_set() will return 0 if the requested modes set in trigger_data can be
+controlled by hardware or an error if both the mode bitmap is not supported by
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
+fail as the driver doesn't support that specific hardware blink modes or doesn't know
+how to handle the provided trigger data.
+
 Known Issues
 ============
 
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 98a4dc889344..de39e76a7c6e 100644
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
index d64e5768e7ab..81d50269a446 100644
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
@@ -166,6 +173,8 @@ struct led_classdev {
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

