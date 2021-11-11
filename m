Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF6C44CEDA
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 02:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhKKBiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 20:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbhKKBiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 20:38:00 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C71CC061766;
        Wed, 10 Nov 2021 17:35:12 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id u18so7091055wrg.5;
        Wed, 10 Nov 2021 17:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=aDae9VxboKRaYt/bmJ4i7DdbNxdsamkoSFhw7jBOT04=;
        b=I+ZE03+s2DnPChb7w5vVscZVz4Vm/u+CPDUlMKYQC2MVSFj6eMTzJhHSGVKJysDTvH
         z75CJVfAPVJ9PqY/425CUiqQ6x/hUMeBBPDGBTYz6SLBYquL8KHhoxr04Px8p3WNSJgp
         WKFemzT8IEDR7WQaYisHj6oAMMSr/faFNI90cGzI4gBD55WipTZkBBTtMVFT26TqL/BM
         KIO17hc4VEMUIxUN4+y+afur5nVJrijq/8q3R8IYrcj/jTbmH0IyaBJjhTExFIxruHqR
         b7HjCQXFg/S8xetRgXBZClam6NwG6o0+4KJe6KtgaurcJv/rzuQYuYsHv0ARJzDEpvKa
         UwTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aDae9VxboKRaYt/bmJ4i7DdbNxdsamkoSFhw7jBOT04=;
        b=5lwmm62wLUvxDUGhsCw7QznRXScm2K70AGfQthI5KFxIEuWVEYP+8h5u29XkS0j576
         fIwKs6ZKFqm9shsTXk4eyInwSwwa2rNh4tbyPI3208zIjM6D+qOBz8nhPUHAqbHZvnoa
         TnzNRAbifz6NeEzTJoj4fB075gB2LRlOtJou0PS30myiM0S5Qynua2A0pR0nWcB6rmxW
         9jGMmi1kRRpZWQS6YkQlo0pd9TZ+NSpTntOWK7LOyWsDR+IMkeEa5B5vbk7M2A/PKME3
         VrpYj6Pxy4gG+VbgI8RxLpMqa286sr6CgcRPeWDYKkPslemwDOAoqvS2RmpbVaGx3pPS
         mryg==
X-Gm-Message-State: AOAM533BCEWSLevWqZ/i2b+EN7CJFQ4F1kfwPxCICTC33pLPeebUJD1s
        V3pnHT/jtSfYST9H4soHt0U=
X-Google-Smtp-Source: ABdhPJy1ZbIhmlxx9WFsg16UXToWTUhD5rZF8HiDyEgclOZ/yUGydD/DK1UZ3ZRU8Cb/XVdQVVDhOw==
X-Received: by 2002:a5d:6091:: with SMTP id w17mr4230096wrt.65.1636594510585;
        Wed, 10 Nov 2021 17:35:10 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id d8sm1369989wrm.76.2021.11.10.17.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 17:35:10 -0800 (PST)
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
Subject: [RFC PATCH v4 3/8] leds: trigger: netdev: drop NETDEV_LED_MODE_LINKUP from mode
Date:   Thu, 11 Nov 2021 02:34:55 +0100
Message-Id: <20211111013500.13882-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211111013500.13882-1-ansuelsmth@gmail.com>
References: <20211111013500.13882-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NETDEV_LED_MODE_LINKUP is not strictly a blink mode but really a status
of the current situation of the carrier. It seems wrong to accomunate a
link status to the blink mode list and would cause some confusion as
someone would think that MODE_LINKUP is a separate mode that provide the
netdev trigger with the other 3 LINK, RX and TX.

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

