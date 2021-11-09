Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6526244A4AA
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 03:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241814AbhKIC3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 21:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240656AbhKIC3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 21:29:04 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD61C06120B;
        Mon,  8 Nov 2021 18:26:18 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id f4so70178416edx.12;
        Mon, 08 Nov 2021 18:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=CRvxsAujAKzK6tNNH/MA87pACBBURig2sWfuX6qEXgk=;
        b=hsCK3LyoWkQmjwUv5e+X/iz3QGIEI26HgYWavD9o9G2B5M44umYxvB2fQl9SbrStvu
         DT7XwJceqVajIUt+qonhChoai8Da1VCao2OIBUEllMFFDeuzkfn3uniTyKd1WZqqscCt
         WwllqBkuiSwXCvvWwszO5hAs2jvNRyVsq13M7a3if+7m9A89BIgiZ6R2odkKO8wl5rhm
         +/ochY3jed2H0rWhfj1zM30Tl2xfaUo01kG0VPfC4CP2nfBjV1dvedR1dJW+k4Iw56CW
         c3IjY7HDYn8CA+Q0MUiEQWxz9cRQx5zC0Gt+zLCyBKNHhh4QFF6r93VelHUFpxkjj1Rf
         7lPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CRvxsAujAKzK6tNNH/MA87pACBBURig2sWfuX6qEXgk=;
        b=EDlLI6PQPh8gIxOePPPcKoM7yBj3BAaD8Nex/07qzPGbkFVQgwgmy3xikkzMpKinmi
         ecLjyJTQ9S5NXP6tLqh6PKBiD1cmnQmxYzxZLfOhhXujX3zHw4CGc7Mb9cmIhDNhM7H5
         ue4XozRbAsOy5f2RlpKFlD6t2YvHJXufMW6+kZvgZSb7Em5AIFZyEF1tRddVwq8ym0YA
         WogQ0It5xXwlk4blvg3LIMgcvFdx8422wcsUxxn/JTpdH2HsJuxB7vQsxKs1aX+A01Qe
         OQHzG60t8DQyLLxaOcfWqmtWcLA06Ncu95QL89RAf67WsPvKtXpvoi62v0l1uaSc5mI1
         FQEA==
X-Gm-Message-State: AOAM532l7ofuWHQprXa6wiovZl6RaDuRSwlcCfapkkQ19ytY5M3Li1KM
        mjy8G/Cn0tf3JxuIrH/ulYk=
X-Google-Smtp-Source: ABdhPJyAQzg+TxF5Krbkk0EfXQdIS8CaIkudZizYqe6C+9lKso59XmUNSAXagUL2YVI2kIfMBfcHSA==
X-Received: by 2002:a17:906:2c16:: with SMTP id e22mr4813443ejh.501.1636424777227;
        Mon, 08 Nov 2021 18:26:17 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m5sm8760900ejc.62.2021.11.08.18.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 18:26:16 -0800 (PST)
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
Subject: [RFC PATCH v3 3/8] leds: trigger: netdev: drop NETDEV_LED_MODE_LINKUP from mode
Date:   Tue,  9 Nov 2021 03:26:03 +0100
Message-Id: <20211109022608.11109-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211109022608.11109-1-ansuelsmth@gmail.com>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop NETDEV_LED_MODE_LINKUP from mode list and convert to a simple bool
that will be true or false based on the carrier link. No functional
change intended.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index d5e774d83021..66a81cc9b64d 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -50,10 +50,10 @@ struct led_netdev_data {
 	unsigned int last_activity;
 
 	unsigned long mode;
+	bool carrier_link_up;
 #define NETDEV_LED_LINK	0
 #define NETDEV_LED_TX	1
 #define NETDEV_LED_RX	2
-#define NETDEV_LED_MODE_LINKUP	3
 };
 
 enum netdev_led_attr {
@@ -73,9 +73,9 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	if (!led_cdev->blink_brightness)
 		led_cdev->blink_brightness = led_cdev->max_brightness;
 
-	if (!test_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode))
+	if (!trigger_data->carrier_link_up) {
 		led_set_brightness(led_cdev, LED_OFF);
-	else {
+	} else {
 		if (test_bit(NETDEV_LED_LINK, &trigger_data->mode))
 			led_set_brightness(led_cdev,
 					   led_cdev->blink_brightness);
@@ -131,10 +131,9 @@ static ssize_t device_name_store(struct device *dev,
 		trigger_data->net_dev =
 		    dev_get_by_name(&init_net, trigger_data->device_name);
 
-	clear_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
+	trigger_data->carrier_link_up = false;
 	if (trigger_data->net_dev != NULL)
-		if (netif_carrier_ok(trigger_data->net_dev))
-			set_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
+		trigger_data->carrier_link_up = netif_carrier_ok(trigger_data->net_dev);
 
 	trigger_data->last_activity = 0;
 
@@ -315,7 +314,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 
 	spin_lock_bh(&trigger_data->lock);
 
-	clear_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
+	trigger_data->carrier_link_up = false;
 	switch (evt) {
 	case NETDEV_CHANGENAME:
 	case NETDEV_REGISTER:
@@ -330,8 +329,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 		break;
 	case NETDEV_UP:
 	case NETDEV_CHANGE:
-		if (netif_carrier_ok(dev))
-			set_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
+		trigger_data->carrier_link_up = netif_carrier_ok(dev);
 		break;
 	}
 
-- 
2.32.0

