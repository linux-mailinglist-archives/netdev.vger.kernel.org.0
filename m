Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDF2496371
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380007AbiAUQ6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380025AbiAUQzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:55:18 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894CBC061757;
        Fri, 21 Jan 2022 08:55:07 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id q16-20020a4a3010000000b002dde2463e66so3486183oof.9;
        Fri, 21 Jan 2022 08:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v7u/1reZfs0BoCSFwSj+daUOVIdy7CF8lGf6AzgFwV8=;
        b=dUOYa3+iMqZXKhKXRcAf//V+c049D5heIy9QFjxhsiTO/lGEOqy6uNxoq+GzfKpUk5
         MEZAMsqOpgmn3b+tyP42LjxdhK3iF8t2Vo9PJV+78hMvS6E3HTV7Ld+y2CpsX8SPaIbf
         HlpuYROwuiBADozL4lPZ89RIcJGxAjwcflh8qmkWsTTdCTv41ic03v/lliYc1q2XriGH
         GwCE6T/U7oYnOWM+Ikhp8+IjZYyCPw2Hev08/zkDx83ezLQHMUTJAFM9rqyesSoYtVVI
         lPJFfEViD7jt9X3i5Ms/4rmyT+A3W2FzIaOjMlZ5DyE6MLCt7/WNDDI08HO5NvDZ2+kt
         JEBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v7u/1reZfs0BoCSFwSj+daUOVIdy7CF8lGf6AzgFwV8=;
        b=KwH9zXLoh8iTTSbAcdYjLFKgIVlZg4enexS2l5PTbmpABZeWkh4aOP2oDV7BjBljIT
         dwIoziHO3rtQOQtaG5Xsbyd9dTAb9D5JwIEEW25P8SiytOu11kV+iar1uT8kn8F2iHxh
         nFitbJgB2H9XRDOeOfzG+ELSXbpHRLgDFhYYnGGokll3kWD/11veNOA7UnYSoj4pfiIu
         VL1kK0M74Y1hNvs7zdOwAaS91YkYAvjw/ud50xE3qRkLGRrBwIarDh+jZe0c/TgB3BE8
         VIuwSlQdbUcD6ojvTZfHd+odxCaj2rWjK11eCzlBsMSgz2zaj5SYktIN/m34rC6v2Zn7
         xfnw==
X-Gm-Message-State: AOAM533tDJbIuDrtEiZbilpJCOCb11aAlyboN2z3Ymqt52jbaI5OQdjo
        8lupqaesnG+NAZleBGObGjk=
X-Google-Smtp-Source: ABdhPJx7+MxuKThO+YBT6naKuMHTwYdavYAds1jlnbwFonjq9bexJ87FdRlAV6oXlywXptGdgQ1aAQ==
X-Received: by 2002:a4a:e60f:: with SMTP id f15mr3106188oot.75.1642784106971;
        Fri, 21 Jan 2022 08:55:06 -0800 (PST)
Received: from thinkpad.localdomain ([2804:14d:5cd1:5d03:cf72:4317:3105:f6e5])
        by smtp.gmail.com with ESMTPSA id y8sm1089271oou.23.2022.01.21.08.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 08:55:06 -0800 (PST)
From:   Luiz Sampaio <sampaio.ime@gmail.com>
To:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath9k-devel@qca.qualcomm.com
Cc:     linux-kernel@vger.kernel.org, Luiz Sampaio <sampaio.ime@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 14/31] net: wireless: ath: changing LED_* from enum led_brightness to actual value
Date:   Fri, 21 Jan 2022 13:54:19 -0300
Message-Id: <20220121165436.30956-15-sampaio.ime@gmail.com>
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
 drivers/net/wireless/ath/ath5k/led.c          | 2 +-
 drivers/net/wireless/ath/ath9k/gpio.c         | 4 ++--
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index 33e9928af363..df3db4851bf3 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -118,7 +118,7 @@ ath5k_led_brightness_set(struct led_classdev *led_dev,
 	struct ath5k_led *led = container_of(led_dev, struct ath5k_led,
 		led_dev);
 
-	if (brightness == LED_OFF)
+	if (brightness == 0)
 		ath5k_led_off(led->ah);
 	else
 		ath5k_led_on(led->ah);
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index b457e52dd365..0828dc9d3503 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -52,7 +52,7 @@ static void ath_led_brightness(struct led_classdev *led_cdev,
 			       enum led_brightness brightness)
 {
 	struct ath_softc *sc = container_of(led_cdev, struct ath_softc, led_cdev);
-	u32 val = (brightness == LED_OFF);
+	u32 val = (brightness == 0);
 
 	if (sc->sc_ah->config.led_active_high)
 		val = !val;
@@ -65,7 +65,7 @@ void ath_deinit_leds(struct ath_softc *sc)
 	if (!sc->led_registered)
 		return;
 
-	ath_led_brightness(&sc->led_cdev, LED_OFF);
+	ath_led_brightness(&sc->led_cdev, 0);
 	led_classdev_unregister(&sc->led_cdev);
 
 	ath9k_hw_gpio_free(sc->sc_ah, sc->sc_ah->led_pin);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index ecb848b60725..7a9369f06534 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -230,7 +230,7 @@ void ath9k_led_work(struct work_struct *work)
 						   led_work);
 
 	ath9k_hw_set_gpio(priv->ah, priv->ah->led_pin,
-			  (priv->brightness == LED_OFF));
+			  (priv->brightness == 0));
 }
 
 static void ath9k_led_brightness(struct led_classdev *led_cdev,
@@ -250,7 +250,7 @@ void ath9k_deinit_leds(struct ath9k_htc_priv *priv)
 	if (!priv->led_registered)
 		return;
 
-	ath9k_led_brightness(&priv->led_cdev, LED_OFF);
+	ath9k_led_brightness(&priv->led_cdev, 0);
 	led_classdev_unregister(&priv->led_cdev);
 	cancel_work_sync(&priv->led_work);
 
-- 
2.34.1

