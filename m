Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C6064D43F
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 01:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiLOAAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 19:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiLNX7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:59:30 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4902AF0;
        Wed, 14 Dec 2022 15:55:53 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id ay2-20020a05600c1e0200b003d22e3e796dso702444wmb.0;
        Wed, 14 Dec 2022 15:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3SLBazAEXX8c9aNBWqHC2LBtXZiu/faWpD9Dr8HQgfw=;
        b=Sd5w+zrgozdOgXZu3CYRiWzYFIYHBJRZlWErRQTWRVQ1H/7gIk7kbasFVgObvrIF8D
         UYXyf8SnqpjvzX43aWNnKVzJifB7JBhFevkYlwY6TD46RhEglensBZVsmOv290lLgxFX
         ABzeuYgT/bGs4JalWs5pFUOygX/yX0qeJBJKB7RrGztMtuTYZ/TWJPh+SPq2c/pi4Jq5
         0Q6GmQ1pPaP9pvG+CWw/sZ4M2E6bms/rCe5X2nbgg41S9G8YXI9H727cDitLzpAuE4fG
         ye6e/KEG/5rI4RjQZ7xjaRxBiSULOLxGa9YWRAck/aKKPfTZV6P8pb1orgIKvyCycn/k
         v59g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3SLBazAEXX8c9aNBWqHC2LBtXZiu/faWpD9Dr8HQgfw=;
        b=uJChWfZCX1nzYrUsBlW8HoPeBO2si51K/WEdzm0CS3rQUd8Ob9w5SP1x1zr3z8VlTF
         Wfxo5gtTss0QM/m8DNMsJJtFRqWDZLdNSb9L2aIUKatruar+cw2LSmuCAc1iQVUp0S0t
         RrtGQwGnFHFLgdGpRDPd0HDU0bKIOB5xWRdX6X6/p5bC4vuU+hRElhw+9Uo6LWVY6zy4
         jtoA7tDBK5Xps1GPGavQekiyywTfjeer5oA/pE2jTXIYkqwML754CIeHnSfOW2ZFwgEp
         C4ndahp8j7WKqlFLt4w/uEPV9DhcLwFpoir0IdeHSQStao0SNavQELGBMI6qpZLxHQqx
         f3VQ==
X-Gm-Message-State: ANoB5pniqz7nE84XvqKgyfQNaSiy8r0FLJ/7rb90yNNZ5waZqohqSHQi
        MNcEzr2aDqpQp0G8w4TU3Ks=
X-Google-Smtp-Source: AA0mqf4HhPWe4wji4lvvDsBpMmP2ENS+uedHUEMV7XB4XaA9lxnWMhH5PvaIhmvQeJo2RK9RqKmAtg==
X-Received: by 2002:a05:600c:795:b0:3d1:cee0:46d0 with SMTP id z21-20020a05600c079500b003d1cee046d0mr20434927wmo.25.1671062118403;
        Wed, 14 Dec 2022 15:55:18 -0800 (PST)
Received: from localhost.localdomain (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.googlemail.com with ESMTPSA id u2-20020adff882000000b00241d21d4652sm4163549wrp.21.2022.12.14.15.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 15:55:17 -0800 (PST)
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
Subject: [PATCH v7 07/11] leds: trigger: netdev: use mutex instead of spinlocks
Date:   Thu, 15 Dec 2022 00:54:34 +0100
Message-Id: <20221214235438.30271-8-ansuelsmth@gmail.com>
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

Some LEDs may require to sleep to apply their hardware rules. Convert to
mutex lock to fix warning for sleeping under spinlock softirq.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index ed019cb5867c..a471e0cde836 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -20,7 +20,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/timer.h>
 #include "../leds.h"
 
@@ -38,7 +38,7 @@
 
 struct led_netdev_data {
 	enum led_blink_modes blink_mode;
-	spinlock_t lock;
+	struct mutex lock;
 
 	struct delayed_work work;
 	struct notifier_block notifier;
@@ -183,9 +183,9 @@ static ssize_t device_name_show(struct device *dev,
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
 	ssize_t len;
 
-	spin_lock_bh(&trigger_data->lock);
+	mutex_lock(&trigger_data->lock);
 	len = sprintf(buf, "%s\n", trigger_data->device_name);
-	spin_unlock_bh(&trigger_data->lock);
+	mutex_unlock(&trigger_data->lock);
 
 	return len;
 }
@@ -206,7 +206,7 @@ static ssize_t device_name_store(struct device *dev,
 
 	cancel_delayed_work_sync(&trigger_data->work);
 
-	spin_lock_bh(&trigger_data->lock);
+	mutex_lock(&trigger_data->lock);
 
 	if (trigger_data->net_dev) {
 		dev_put(trigger_data->net_dev);
@@ -231,7 +231,7 @@ static ssize_t device_name_store(struct device *dev,
 		trigger_data->net_dev = old_net;
 		memcpy(trigger_data->device_name, old_device_name, IFNAMSIZ);
 
-		spin_unlock_bh(&trigger_data->lock);
+		mutex_unlock(&trigger_data->lock);
 		return -EINVAL;
 	}
 
@@ -242,7 +242,7 @@ static ssize_t device_name_store(struct device *dev,
 	trigger_data->last_activity = 0;
 
 	set_baseline_state(trigger_data);
-	spin_unlock_bh(&trigger_data->lock);
+	mutex_unlock(&trigger_data->lock);
 
 	return size;
 }
@@ -400,7 +400,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 
 	cancel_delayed_work_sync(&trigger_data->work);
 
-	spin_lock_bh(&trigger_data->lock);
+	mutex_lock(&trigger_data->lock);
 
 	trigger_data->carrier_link_up = false;
 	switch (evt) {
@@ -423,7 +423,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 
 	set_baseline_state(trigger_data);
 
-	spin_unlock_bh(&trigger_data->lock);
+	mutex_unlock(&trigger_data->lock);
 
 	return NOTIFY_DONE;
 }
@@ -484,7 +484,7 @@ static int netdev_trig_activate(struct led_classdev *led_cdev)
 	if (!trigger_data)
 		return -ENOMEM;
 
-	spin_lock_init(&trigger_data->lock);
+	mutex_init(&trigger_data->lock);
 
 	trigger_data->notifier.notifier_call = netdev_trig_notify;
 	trigger_data->notifier.priority = 10;
-- 
2.37.2

