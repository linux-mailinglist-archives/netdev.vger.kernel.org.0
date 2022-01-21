Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F23D496365
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381998AbiAUQ55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379421AbiAUQ4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:56:48 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EEAC061401;
        Fri, 21 Jan 2022 08:55:22 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id s22so14315382oie.10;
        Fri, 21 Jan 2022 08:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9FkOQM5u5ppX0zk2cCe8h17WreOcSuyA+cCjXY4Ibok=;
        b=FImpVhK9ZDZtG1dz51vQYI+AlMCcxdaba/9f1CXpNApQCy38g6sYulfphRnyOrmCQa
         Ug2GmcTOm7WP5jTgcvWBrL46Jq1T/T0Y+ZI5YkHDKuIpBqlNdJ0eOKiLveK3OT7JcHct
         +oPN+9I+Nw2rWZrMaWVgrhwVMPXD+CTIeJyPtb5eUivV8wDYSv+aJoc9AOkuxwFIzOA6
         /XUFpoEAwyVjwFJ/4/cvPwMunTEHZPQzDxTs6FCHQL0mL2l0v6I2JP4LDJ5g7b4TENCX
         0Fi1g8vLruqjZLWCsbkQeHM8aBWg83w4iOqfR3D4utcscqfzbpJyvmp+sL0pzasfQsj/
         lyag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9FkOQM5u5ppX0zk2cCe8h17WreOcSuyA+cCjXY4Ibok=;
        b=iRO2/J7Uq/RKupYUOJKVsG4ind1LM1RszlXbJyR5Plsb2CwHN0Zspu02DbRdbY1Vf9
         Ee0d6vBsj98N7ccv8JTpQIzefbeMXRf8Dj68Iy6YideY6vDdbMyI24wVIZMLPpdB+phT
         V4PMR9vgUiSf1OSMR/qkjfqZgZYyZ8xgKEqNnd/0yi+Yz6DpHWm6E8Jbo0oV3EHV08gg
         1OtluL/LxXP4zVQOMatrOK/m1rpl3scdWhoh8DSvNQTbS1hZ4rITsyunWCgWl3OEm42x
         PZ3Y6k5WkqDKHLiIc/uATsX8Kyqnb4NyGPN9O0fHfabw3ceVZ8LD4wvCqt4SPWlj1ZFi
         Xy0Q==
X-Gm-Message-State: AOAM5335eSDZF27Lc6AJJ4JsYVh2/dlwoMG0JR00X3mIAyqk8rigydx3
        uOm5t07cxGQQf4o04gyjVnc=
X-Google-Smtp-Source: ABdhPJx8j5Rh7OutZLuKLTpoZF2an+JuV/Gd63EofLmY8JJ/xD3MoU6NM+EYsXzEfYtITA3o2R3p3w==
X-Received: by 2002:a05:6808:11c5:: with SMTP id p5mr1269478oiv.51.1642784121430;
        Fri, 21 Jan 2022 08:55:21 -0800 (PST)
Received: from thinkpad.localdomain ([2804:14d:5cd1:5d03:cf72:4317:3105:f6e5])
        by smtp.gmail.com with ESMTPSA id y8sm1089271oou.23.2022.01.21.08.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 08:55:21 -0800 (PST)
From:   Luiz Sampaio <sampaio.ime@gmail.com>
To:     Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Luiz Sampaio <sampaio.ime@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 18/31] net: wireless: ralink: changing LED_* from enum led_brightness to actual value
Date:   Fri, 21 Jan 2022 13:54:23 -0300
Message-Id: <20220121165436.30956-19-sampaio.ime@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220121165436.30956-1-sampaio.ime@gmail.com>
References: <20220121165436.30956-1-sampaio.ime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The enum led_brightness, which contains the declaration of LED_OFF,
LED_ON, LED_HALF and LED_FULL is obsolete, as the led class now supports
max_brightness.
---
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c  |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c  |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500usb.c  |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c  |  4 ++--
 drivers/net/wireless/ralink/rt2x00/rt2x00leds.c | 16 ++++++++--------
 drivers/net/wireless/ralink/rt2x00/rt61pci.c    |  4 ++--
 drivers/net/wireless/ralink/rt2x00/rt73usb.c    |  4 ++--
 7 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
index dec6ffdf07c4..d8b7f1a73267 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
@@ -204,7 +204,7 @@ static void rt2400pci_brightness_set(struct led_classdev *led_cdev,
 {
 	struct rt2x00_led *led =
 	    container_of(led_cdev, struct rt2x00_led, led_dev);
-	unsigned int enabled = brightness != LED_OFF;
+	unsigned int enabled = brightness != 0;
 	u32 reg;
 
 	reg = rt2x00mmio_register_read(led->rt2x00dev, LEDCSR);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
index 8faa0a80e73a..fe490a6382fe 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
@@ -204,7 +204,7 @@ static void rt2500pci_brightness_set(struct led_classdev *led_cdev,
 {
 	struct rt2x00_led *led =
 	    container_of(led_cdev, struct rt2x00_led, led_dev);
-	unsigned int enabled = brightness != LED_OFF;
+	unsigned int enabled = brightness != 0;
 	u32 reg;
 
 	reg = rt2x00mmio_register_read(led->rt2x00dev, LEDCSR);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
index bb5ed6630645..b25c32a03d99 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
@@ -267,7 +267,7 @@ static void rt2500usb_brightness_set(struct led_classdev *led_cdev,
 {
 	struct rt2x00_led *led =
 	    container_of(led_cdev, struct rt2x00_led, led_dev);
-	unsigned int enabled = brightness != LED_OFF;
+	unsigned int enabled = brightness != 0;
 	u16 reg;
 
 	reg = rt2500usb_register_read(led->rt2x00dev, MAC_CSR20);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index deddb0afd312..8441e6e5320a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1521,7 +1521,7 @@ static void rt2800_brightness_set(struct led_classdev *led_cdev,
 {
 	struct rt2x00_led *led =
 	    container_of(led_cdev, struct rt2x00_led, led_dev);
-	unsigned int enabled = brightness != LED_OFF;
+	unsigned int enabled = brightness != 0;
 	unsigned int bg_mode =
 	    (enabled && led->rt2x00dev->curr_band == NL80211_BAND_2GHZ);
 	unsigned int polarity =
@@ -1570,7 +1570,7 @@ static void rt2800_brightness_set(struct led_classdev *led_cdev,
 			 *	(1 << level) - 1
 			 */
 			rt2800_mcu_request(led->rt2x00dev, MCU_LED_STRENGTH, 0xff,
-					      (1 << brightness / (LED_FULL / 6)) - 1,
+					      (1 << brightness / (255 / 6)) - 1,
 					      polarity);
 		}
 	}
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00leds.c b/drivers/net/wireless/ralink/rt2x00/rt2x00leds.c
index f5361d582d4e..3ef2a81aed7d 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00leds.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00leds.c
@@ -52,7 +52,7 @@ void rt2x00leds_led_quality(struct rt2x00_dev *rt2x00dev, int rssi)
 	 * is going to calculate the value and might use it in a
 	 * division.
 	 */
-	brightness = ((LED_FULL / 6) * rssi) + 1;
+	brightness = ((255 / 6) * rssi) + 1;
 	if (brightness != led->led_dev.brightness) {
 		led->led_dev.brightness_set(&led->led_dev, brightness);
 		led->led_dev.brightness = brightness;
@@ -61,7 +61,7 @@ void rt2x00leds_led_quality(struct rt2x00_dev *rt2x00dev, int rssi)
 
 static void rt2x00led_led_simple(struct rt2x00_led *led, bool enabled)
 {
-	unsigned int brightness = enabled ? LED_FULL : LED_OFF;
+	unsigned int brightness = enabled ? 255 : 0;
 
 	if (!(led->flags & LED_REGISTERED))
 		return;
@@ -96,7 +96,7 @@ static int rt2x00leds_register_led(struct rt2x00_dev *rt2x00dev,
 	int retval;
 
 	led->led_dev.name = name;
-	led->led_dev.brightness = LED_OFF;
+	led->led_dev.brightness = 0;
 
 	retval = led_classdev_register(device, &led->led_dev);
 	if (retval) {
@@ -179,7 +179,7 @@ static void rt2x00leds_unregister_led(struct rt2x00_led *led)
 	 * possible yet.
 	 */
 	if (!(led->led_dev.flags & LED_SUSPENDED))
-		led->led_dev.brightness_set(&led->led_dev, LED_OFF);
+		led->led_dev.brightness_set(&led->led_dev, 0);
 
 	led->flags &= ~LED_REGISTERED;
 }
@@ -199,8 +199,8 @@ static inline void rt2x00leds_suspend_led(struct rt2x00_led *led)
 	led_classdev_suspend(&led->led_dev);
 
 	/* This shouldn't be needed, but just to be safe */
-	led->led_dev.brightness_set(&led->led_dev, LED_OFF);
-	led->led_dev.brightness = LED_OFF;
+	led->led_dev.brightness_set(&led->led_dev, 0);
+	led->led_dev.brightness = 0;
 }
 
 void rt2x00leds_suspend(struct rt2x00_dev *rt2x00dev)
@@ -218,8 +218,8 @@ static inline void rt2x00leds_resume_led(struct rt2x00_led *led)
 	led_classdev_resume(&led->led_dev);
 
 	/* Device might have enabled the LEDS during resume */
-	led->led_dev.brightness_set(&led->led_dev, LED_OFF);
-	led->led_dev.brightness = LED_OFF;
+	led->led_dev.brightness_set(&led->led_dev, 0);
+	led->led_dev.brightness = 0;
 }
 
 void rt2x00leds_resume(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
index 82cfc2aadc2b..d48a7d06013c 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -242,7 +242,7 @@ static void rt61pci_brightness_set(struct led_classdev *led_cdev,
 {
 	struct rt2x00_led *led =
 	    container_of(led_cdev, struct rt2x00_led, led_dev);
-	unsigned int enabled = brightness != LED_OFF;
+	unsigned int enabled = brightness != 0;
 	unsigned int a_mode =
 	    (enabled && led->rt2x00dev->curr_band == NL80211_BAND_5GHZ);
 	unsigned int bg_mode =
@@ -271,7 +271,7 @@ static void rt61pci_brightness_set(struct led_classdev *led_cdev,
 		 * argument into the matching level within that range.
 		 */
 		rt61pci_mcu_request(led->rt2x00dev, MCU_LED_STRENGTH, 0xff,
-				    brightness / (LED_FULL / 6), 0);
+				    brightness / (255 / 6), 0);
 	}
 }
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt73usb.c b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
index 5ff2c740c3ea..45b98395cf9e 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
@@ -187,7 +187,7 @@ static void rt73usb_brightness_set(struct led_classdev *led_cdev,
 {
 	struct rt2x00_led *led =
 	   container_of(led_cdev, struct rt2x00_led, led_dev);
-	unsigned int enabled = brightness != LED_OFF;
+	unsigned int enabled = brightness != 0;
 	unsigned int a_mode =
 	    (enabled && led->rt2x00dev->curr_band == NL80211_BAND_5GHZ);
 	unsigned int bg_mode =
@@ -216,7 +216,7 @@ static void rt73usb_brightness_set(struct led_classdev *led_cdev,
 		 * argument into the matching level within that range.
 		 */
 		rt2x00usb_vendor_request_sw(led->rt2x00dev, USB_LED_CONTROL,
-					    brightness / (LED_FULL / 6),
+					    brightness / (255 / 6),
 					    led->rt2x00dev->led_mcu_reg,
 					    REGISTER_TIMEOUT);
 	}
-- 
2.34.1

