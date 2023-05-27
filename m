Return-Path: <netdev+bounces-5883-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D47A5713476
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:32:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87FC61C2117C
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 11:32:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 102F911CB1;
	Sat, 27 May 2023 11:29:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3706125A5
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 11:29:27 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDDFEC;
	Sat, 27 May 2023 04:29:25 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f6dbe3c230so17238705e9.3;
        Sat, 27 May 2023 04:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685186964; x=1687778964;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=duk7D4T1VAqrdSK3J+2RtTub/SxkfwJR2fWIQ5D7Ni0=;
        b=Q4eeR6uHB+pvn7nDFCDWVsNawzmGyfWCckzPa50tB46duXdpYa0FUEXppo34gUP5Ve
         KhZ41gWPtIIYeCeDCVUewl21fw46CGKI/QT50xt6SlyFwf9eGXNDBZJSzWCaJZsZ2UQ0
         x744nbGK93FJa24T5L2aHkI3jGXn5TvqHkdCktB525myHQdZioP1rN//ul3w0CN/tWGA
         VEIfaGGCLVcglYU6EkLPCa8kkkRI5xDPAhY9KDdSlrlTBhTfMn9le7eVTxm/ZqKgew0K
         3Lq2EjHORjkQTlPxvcgmPSNmmSm3StJYpeoeIWMivHhqjcaYHEuGp4rv/MLO9EZGcC6s
         Sj5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685186964; x=1687778964;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=duk7D4T1VAqrdSK3J+2RtTub/SxkfwJR2fWIQ5D7Ni0=;
        b=Tmeyhu3QvbnOqI4xYduce39zEVMyq3SV4yf/lIQcLRGY74wbWT5W+v2DlFDiy40Gtf
         NSJ8Vn2xwm/QTG5CdvAktLGnlZWLDpB6hAFv/eTUD4dY4Q7XMbr3wb3XvkB+lPpe6Il/
         0SHcYZza9x6NwdubjY+dvJedYxzjdS5R7j7GN92PdvpX7rESeftBf9l6erhr0UG84j1A
         nh6/JW5MY9kW4+NoCH9HZETcxwBmOrGKjf2mtcHtJCPHMrKejIkg8og5NqM6bF9eEsX4
         9A/0bzB4BzqUd1Gp9jtvSnF8EICAqit7QZV+173Swqeq7bUaeAmD0jZBpg5qpjX5hkWs
         3b0A==
X-Gm-Message-State: AC+VfDx3Jt2bN5BKv3ZWDA8/JM45JK4AUEwjJXiGgbA86hOlzYXvNBJD
	jSBmGtlH17nfmB6VFbMrMUQ=
X-Google-Smtp-Source: ACHHUZ5VvE6ydMGvSDb5vXsf3ZAjcrS5fakqvmcWUY+9rLxNoqR6cmva9vmr/Tj0XmTfWeD7VJw8Eg==
X-Received: by 2002:a7b:c40f:0:b0:3f4:f7c2:d681 with SMTP id k15-20020a7bc40f000000b003f4f7c2d681mr4293720wmi.29.1685186963963;
        Sat, 27 May 2023 04:29:23 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id q13-20020a7bce8d000000b003f43f82001asm11711000wmj.31.2023.05.27.04.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 04:29:23 -0700 (PDT)
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
Subject: [net-next PATCH v3 08/13] leds: trigger: netdev: add support for LED hw control
Date: Sat, 27 May 2023 13:28:49 +0200
Message-Id: <20230527112854.2366-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230527112854.2366-1-ansuelsmth@gmail.com>
References: <20230527112854.2366-1-ansuelsmth@gmail.com>
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

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 39 ++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index cb2ec33abc4e..8d6381415208 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -68,6 +68,13 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
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
@@ -103,12 +110,42 @@ static bool supports_hw_control(struct led_classdev *led_cdev)
 
 static bool can_hw_control(struct led_netdev_data *trigger_data)
 {
+	unsigned int interval = atomic_read(&trigger_data->interval);
 	struct led_classdev *led_cdev = trigger_data->led_cdev;
+	unsigned long default_interval = msecs_to_jiffies(50);
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
-- 
2.39.2


