Return-Path: <netdev+bounces-6148-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E11A8714E88
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:37:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8783F1C20AF2
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5929E10943;
	Mon, 29 May 2023 16:34:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E79010942
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 16:34:53 +0000 (UTC)
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A762C4;
	Mon, 29 May 2023 09:34:51 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-30ae967ef74so839322f8f.0;
        Mon, 29 May 2023 09:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685378091; x=1687970091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k9zDcLuDmRuulvW9kwOBJYpZilY8B3eQJR6LQKF7+iY=;
        b=kinBxrFz77HNF/XtwhSWtBAd7mEOLCK2AR+m8MZp8Xz1PtERhfYwYGVqVUy0zWFs5B
         UkEj84uzwX29FDEmRbDKRxaQulRPxBealoaP4La97X4BbD8rW3XX90z6A2Koauo9dTB0
         IvaO2BFZKQtNdjH6/sHzBlVvtEVhNe2opzvRhAQZ+wpAKUC9d6rTCmZsvvvaKIToNtau
         QQzNTGZLYplb9MuJnsueJJF6xQahBxj28X/mVCwtCB05FzGJ1EmOLE84pfFXji6a4bth
         Ptui/zARqnladVkb6rFSatzmeNUGplecshb5Jr8WUr2l5UHj0ejo5EQK1ZA5+2yh46Ou
         lW2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685378091; x=1687970091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k9zDcLuDmRuulvW9kwOBJYpZilY8B3eQJR6LQKF7+iY=;
        b=crkMC9DKft+Do4RePPEMY2nX+NbyIlQRvMtcg0o+FPYsHvM4DNy3NNZsXPunZ7hnZZ
         3hVYj0Zkf1vLk0zGHjViUZ5ushZ6b74ZbKonkSRnzooBfDgeWgpOcLRzVlCBgvZeYyH7
         StJn8ggzinY1LcYKxc47gyvQnnEbWgatd0JXufLAroYAr4bwBYPLAgQgNX7OTuXaK3R0
         syObZVKJglT6Q1NdGDWKAO6bdG2L/Fsf7C3MybbH8yXb6ZRphW0osuPx9i9I3uZ4h5Cb
         05Ptsy2TNP3wCmtBGjKF+vxo6ztWKA1BA1Ya+Zdv0x/ChvX/Ui6asVSiYbTtXvgOU2Hp
         +8jw==
X-Gm-Message-State: AC+VfDzpVgjf0KJpKWb8o72P5K/YPryvedWcmXBvrYOKjzSSoyttNXdw
	rciQxnSHuhTBJ6Hzjqx4QXI=
X-Google-Smtp-Source: ACHHUZ7GqW3WwEMsm/Vm1s+I7dlZGDtsqkt/s+aTLIWNJ214HF6QA7zx9Syi/U/kWZgar2002rOwEA==
X-Received: by 2002:a5d:43c3:0:b0:309:1c89:c61b with SMTP id v3-20020a5d43c3000000b003091c89c61bmr11510309wrr.29.1685378090774;
        Mon, 29 May 2023 09:34:50 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id h14-20020a5d6e0e000000b002ff2c39d072sm417513wrz.104.2023.05.29.09.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:34:50 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	linux-leds@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [net-next PATCH v4 08/13] leds: trigger: netdev: add support for LED hw control
Date: Mon, 29 May 2023 18:32:38 +0200
Message-Id: <20230529163243.9555-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230529163243.9555-1-ansuelsmth@gmail.com>
References: <20230529163243.9555-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for LED hw control for the netdev trigger.

The trigger on calling set_baseline_state to configure a new mode, will
do various check to verify if hw control can be used for the requested
mode in can_hw_control() function.

It will first check if the LED driver supports hw control for the netdev
trigger, then will use hw_control_is_supported() and finally will call
hw_control_set() to apply the requested mode.

To use such mode, interval MUST be set to the default value and net_dev
MUST be set. If one of these 2 value are not valid, hw control will
never be used and normal software fallback is used.

The default interval value is moved to a define to make sure they are
always synced.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/leds/trigger/ledtrig-netdev.c | 43 +++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index cb2ec33abc4e..8f592a77cbef 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -24,6 +24,8 @@
 #include <linux/timer.h>
 #include "../leds.h"
 
+#define NETDEV_LED_DEFAULT_INTERVAL	50
+
 /*
  * Configurable sysfs attributes:
  *
@@ -68,6 +70,13 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	int current_brightness;
 	struct led_classdev *led_cdev = trigger_data->led_cdev;
 
+	/* Already validated, hw control is possible with the requested mode */
+	if (trigger_data->hw_control) {
+		led_cdev->hw_control_set(led_cdev, trigger_data->mode);
+
+		return;
+	}
+
 	current_brightness = led_cdev->brightness;
 	if (current_brightness)
 		led_cdev->blink_brightness = current_brightness;
@@ -103,12 +112,42 @@ static bool supports_hw_control(struct led_classdev *led_cdev)
 
 static bool can_hw_control(struct led_netdev_data *trigger_data)
 {
+	unsigned long default_interval = msecs_to_jiffies(NETDEV_LED_DEFAULT_INTERVAL);
+	unsigned int interval = atomic_read(&trigger_data->interval);
 	struct led_classdev *led_cdev = trigger_data->led_cdev;
+	int ret;
 
 	if (!supports_hw_control(led_cdev))
 		return false;
 
-	return false;
+	/*
+	 * Interval must be set to the default
+	 * value. Any different value is rejected if in hw
+	 * control.
+	 */
+	if (interval != default_interval)
+		return false;
+
+	/*
+	 * net_dev must be set with hw control, otherwise no
+	 * blinking can be happening and there is nothing to
+	 * offloaded.
+	 */
+	if (!trigger_data->net_dev)
+		return false;
+
+	/* Check if the requested mode is supported */
+	ret = led_cdev->hw_control_is_supported(led_cdev, trigger_data->mode);
+	/* Fall back to software blinking if not supported */
+	if (ret == -EOPNOTSUPP)
+		return false;
+	if (ret) {
+		dev_warn(led_cdev->dev,
+			 "Current mode check failed with error %d\n", ret);
+		return false;
+	}
+
+	return true;
 }
 
 static ssize_t device_name_show(struct device *dev,
@@ -413,7 +452,7 @@ static int netdev_trig_activate(struct led_classdev *led_cdev)
 	trigger_data->device_name[0] = 0;
 
 	trigger_data->mode = 0;
-	atomic_set(&trigger_data->interval, msecs_to_jiffies(50));
+	atomic_set(&trigger_data->interval, msecs_to_jiffies(NETDEV_LED_DEFAULT_INTERVAL));
 	trigger_data->last_activity = 0;
 
 	led_set_trigger_data(led_cdev, trigger_data);
-- 
2.39.2


