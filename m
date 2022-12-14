Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCDD64D423
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiLNX7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiLNX6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:58:43 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4725D695;
        Wed, 14 Dec 2022 15:55:43 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id o5so1477939wrm.1;
        Wed, 14 Dec 2022 15:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AM6Sy+u27cRKYcUzXWKt9kLEw6zGEH9U/Yts/6M0SW0=;
        b=DxxSA8R18AgPUYSN71xPuAxxUi18sylXJl5SnQO65+6qhmYsAJdaEHI12mlMqzT3rE
         u1KLSnYpirb0+3AQI3m++t36S6DCth/0DbvdfJfwLnDUi+ONwHIBhUhNBx3bCuIVli7M
         dVounvqZRHn/eP6BXkKo0E7FODkoXVmy2b+SrLSIwOVyh36UpGL6zSJysjHeF9A8ds3m
         riLKuh9D6apfTVO8hiKUcAN7URzzVMeZDVRc7Y726Cgh3IVS1gydxwgZ5TyCgCgdmLO1
         x6zi9wNM77V/TC860cfkct/XU5/VEYU2nKm4ynImYKndlFujNkh9DGo3kZ7ZNsp1gYO3
         ltGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AM6Sy+u27cRKYcUzXWKt9kLEw6zGEH9U/Yts/6M0SW0=;
        b=QkrZ0WKodYW6KS+1IpwLWCUKVONpABgq3vBhERq4EvJErKDP5whG8kHUI6kva6bzdZ
         WlAvX3so3mvH9PDdU59zOnpqSdAhd9QDv8Mj8k97XEuCY4cfdEzg6PrBWVjtXZTqydgy
         H3e2fZ1XWxZpVz7beeowlduQ1E7qIv6KjtZaPTkw8kdJzKBnkLJN+yw7vYy6QIvLfvyb
         J5rXZ7UuI6H+FAX/f2fDYbVEjH0WIHTsdyRrbl6BWnkB8D2w+uyVlz+kP/JGAHrdlfiE
         wB0NYq7Hj9UvQXETaTqwpcz6X8C05xkdzKZW9j13kKIthptPo7swgJiBSpGbDBIuE0C+
         Uq3g==
X-Gm-Message-State: ANoB5pl00MPKBT+5oLugOovfb3MR5W6jcnbIJ26atT/gbnuIFJO27J43
        Y7COo5UyJalTHktr6MjOXhw=
X-Google-Smtp-Source: AA0mqf6TMHJlRLvpVfuGxfWdLdTWGdGPX/HSkD9/ya9h2pPu+tbfd9zeukjLn4mzk9k3ASMWHg7rbA==
X-Received: by 2002:a5d:654c:0:b0:242:65d:c401 with SMTP id z12-20020a5d654c000000b00242065dc401mr17724702wrv.6.1671062111732;
        Wed, 14 Dec 2022 15:55:11 -0800 (PST)
Received: from localhost.localdomain (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.googlemail.com with ESMTPSA id u2-20020adff882000000b00241d21d4652sm4163549wrp.21.2022.12.14.15.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 15:55:11 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH v7 03/11] leds: trigger: netdev: drop NETDEV_LED_MODE_LINKUP from mode
Date:   Thu, 15 Dec 2022 00:54:30 +0100
Message-Id: <20221214235438.30271-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221214235438.30271-1-ansuelsmth@gmail.com>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop NETDEV_LED_MODE_LINKUP from mode list and convert to a simple bool
that will be true or false based on the carrier link. No functional
change intended.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
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
2.37.2

