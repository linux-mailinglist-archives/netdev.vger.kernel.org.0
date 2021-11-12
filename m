Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429D744EA51
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbhKLPjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235290AbhKLPi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:38:58 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391CAC061766;
        Fri, 12 Nov 2021 07:36:07 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id c4so16151925wrd.9;
        Fri, 12 Nov 2021 07:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=aDae9VxboKRaYt/bmJ4i7DdbNxdsamkoSFhw7jBOT04=;
        b=Mx+Y+GV2GKATil2tdoypyr/7UxBELXYHV/2UlF4TI/AgAdtRYcyARXmSxew1DUWdTe
         6pRUW+Tj9P4xRUTPtxHlkA905GRrYIJDhGm9yR7AOMDuxR2lmlOcd/r2DUa/0aOaR8a3
         76K6PtyN04d4/5OnoUenNb/hFOhz/I1FBNelAuYinCXtYmO9+lsOfSlcfG8SQ07DuBrx
         W13UdO4nJnKXH5VeV89UMRtQjcsPRri5QEToi4d+xiE5d0j4f2ve6Sc+bzWkvuS3E2D2
         Srk8qmrBa+wGcmSqkEjFw06slBz1L+nS6vQ+i55r0qW9VeGAJYsdCaOyhpr0eSyQkqMm
         ZluQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aDae9VxboKRaYt/bmJ4i7DdbNxdsamkoSFhw7jBOT04=;
        b=W9SdBOk6iG+LXCOvhIRrAD3X2r8cOFEWNMnHiZOCZpCIWHKs2ODU/pAr1KZuc9ZRB5
         QnDFFW8IRwNWt6Isfd4iofOSaVYMYb0JW/6X2/a/oOULou4J/Nc887fkOCKH1/Pw/Dfs
         T1jq3WDnhGh8FzMReywAXJp3fgj64qQS/ShkgCtT3HgqbLlV2bkpzXxZPPJePF6O6dqN
         2WaTq1Rue5aLsiAtoIXbXiorjIJaXn5/sfQ9FkDsp+/MZLG0/B8tDMmrchRz436KHBsL
         pwC3XvN7SHKEru1pGgCnWbqMrKviS8JU3jonPTmzbuQt8RP3kDFYxeOO3JEg8Z09FWI2
         tLww==
X-Gm-Message-State: AOAM531lOuTQESRZ94PwPqjb4uQ5ays/Kwm6P9qEuM765pgPCfsc6fMR
        m+C8s7FOnFmfR9okJV3M/fkt7jMeYvY=
X-Google-Smtp-Source: ABdhPJzmvlESmo0uzPUq1oRR9TgG9ZUW5Zqaa7duYCqHfLYbWeQ6PCuFOjeN7412d1HsOs/ZWgo2Gw==
X-Received: by 2002:adf:e8c8:: with SMTP id k8mr19192896wrn.135.1636731365698;
        Fri, 12 Nov 2021 07:36:05 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id az4sm4217543wmb.20.2021.11.12.07.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 07:36:05 -0800 (PST)
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
Subject: [PATCH v5 3/8] leds: trigger: netdev: drop NETDEV_LED_MODE_LINKUP from mode
Date:   Fri, 12 Nov 2021 16:35:52 +0100
Message-Id: <20211112153557.26941-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211112153557.26941-1-ansuelsmth@gmail.com>
References: <20211112153557.26941-1-ansuelsmth@gmail.com>
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

