Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB2E51884A
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238295AbiECPWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238156AbiECPWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:22:06 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718393B02A;
        Tue,  3 May 2022 08:18:25 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id y21so20257316edo.2;
        Tue, 03 May 2022 08:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=xNl4nmp4IV8sA0Ju8qo0RZUW9W5BZsaB6Tx1+KaqS3o=;
        b=ZF247WjkHLXEKtHUKwvhmhMpDqhZRT7GAaj/mb3pM7kvPHZHPXU/6/89C02GQXIgeP
         UD6ElA2prslnviD7PZiTJFxY5e+N86FRtl8VF4qA4mIsnayFiIxUtPigqtTNgV/w2PNO
         jCqnTqGlbFLTYxmw7ne9JGekSUfGo5m4hPLBDXw7WyCqPKGOIipzxnINz59FL5TkBBCn
         Mk/tO0DuIE9jfNp93ITwAC/2DvyqvR3n2BDRlEd1vZVHp2sKzPTeh48izp5I3pZxGEpD
         mn0e0+mHdr/L0vTyRBbWyhH/6aBe3fwiJKlrZ2RcnWs99utgQidh0gGc6DmB1y7QZhRp
         RUGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xNl4nmp4IV8sA0Ju8qo0RZUW9W5BZsaB6Tx1+KaqS3o=;
        b=QTL8g0ZCNE9pWC73mpGNJ60bEqH133MqMvwKtZCJG2mrQ0MIq1FVktMclI29T73zbs
         Ch6rJqldSCouU/23GE8B4F6N7gWYpU2NSZC8sLFlYt1LakuVm3MwAAuuHpj8w9Jly1yd
         pkboGoiXlKnzE5Ep/6fiS5wDUL1MYQVO9IPH9Q1CXRiNc+uZ9j6wghOc7FpCkP+z+bu/
         8gzx9SDYh5XAtHKlK/EXglaXBJCQZ8Ads52LhGZwKqp/ULyjOKVQ8PVaWt/dUJJqWfxi
         VEgkeAhS33H/+UsdzpczoC3PgV8+Rtyl5GnbtEAqhkUvY3cx9xgCq/BrsO2RU54l4quc
         BAIQ==
X-Gm-Message-State: AOAM531hMIw8xDtyONOqfpJk/Ekgnvq5NVPEbREZoNP8D9YpMLREBwCJ
        Q+lV+3sTw5NfvjXv+PGUpfxSjJZVtxc=
X-Google-Smtp-Source: ABdhPJxtS8DIiS2+xg3yYgni5xA7D+vICcNmhMo4bzVa0Y5kAQUWDSDSblXWlO+HvIh8YZBGC4puxQ==
X-Received: by 2002:a05:6402:296:b0:427:e497:29ef with SMTP id l22-20020a056402029600b00427e49729efmr3578296edv.399.1651591103741;
        Tue, 03 May 2022 08:18:23 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id v3-20020aa7d9c3000000b0042617ba63cesm7947507eds.88.2022.05.03.08.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 08:18:23 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [RFC PATCH v6 07/11] leds: trigger: netdev: use mutex instead of spinlocks
Date:   Tue,  3 May 2022 17:16:29 +0200
Message-Id: <20220503151633.18760-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220503151633.18760-1-ansuelsmth@gmail.com>
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some LEDs may require to sleep to apply their hardware rules. Convert to
mutex lock to fix warning for sleeping unser spinlock softirq.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
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
2.34.1

