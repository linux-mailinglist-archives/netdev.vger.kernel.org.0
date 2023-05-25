Return-Path: <netdev+bounces-5359-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E37F8710EDA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:57:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A39991C20F14
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B2E19BC4;
	Thu, 25 May 2023 14:55:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700851B8F3
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:55:06 +0000 (UTC)
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFE91AC;
	Thu, 25 May 2023 07:55:01 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-3094910b150so2177604f8f.0;
        Thu, 25 May 2023 07:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685026500; x=1687618500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=duk7D4T1VAqrdSK3J+2RtTub/SxkfwJR2fWIQ5D7Ni0=;
        b=L4RmAw3XRXnmmRpYDcP8hy1SU0hm5E0T2muMkL0ByGYoY8SHDyIfOLB+Au7OBORQJr
         3Z4zb7bIbJvLZuk4ChKWLOd/szhiTwiAMAYDcopAepffd7L6lesv/jSHhL20IlGC0CO7
         vliPhSZLxQy0CiaNwXDbWIidJ+z5fSAQ5WKxOl58KX/d2cgt0r7Kni0AmBIGyoU9Mpnd
         DRxmRLlsoF0zQvFAuMuqv2G+i9PWl4NNbnkvJFomq85mvr6h5sLlXRa+wN3KKlExP2NS
         mIajra2wE0vTaxSEjr4GiR/qbABuvoxuACJnhPdR5S28umVt3qGduQ5dlPypfjL9FRAw
         ZVkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685026500; x=1687618500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=duk7D4T1VAqrdSK3J+2RtTub/SxkfwJR2fWIQ5D7Ni0=;
        b=hTR32unKk6UyJD+SR6KGsv+L7L8VK1APrOVssVDJUBTYpeVnfRjCphxlOMoAd45/qO
         UliAl4adjGOgHRVHdD1L8Oq0BXYJLniA+6au3h4d5qVh4Qcu+8CE6aamE636+sGRZ1+N
         62DTwKfSM0ZkgDAh02US/OsHNJSzOrsgLgb2P48A4x8RCj0CsQHth+K0DZP7LRq4HdW3
         IWea1q19XQQUgjAaAAi6vuC+LNCvKwvqAr34EaqDSaQ28/MfaDsas29lWqGGoxRe80Ux
         54BXPkfcV1F3r0yKwk9S198DEb3Ua9EZMBn2hygrIcQ+F2O6fxUBQe62oEPGYcNvIwq5
         aNNQ==
X-Gm-Message-State: AC+VfDzo8ncaNws9qAp0jU9Muo8pcN4Mqvjap1n9l5Rn3rJhh/faEe6t
	hyW0aSK8/ivfgN6i2SwgSAc=
X-Google-Smtp-Source: ACHHUZ63aC3p/Y9apeYCYpX+JXDoCoMpXpET+sAt7Kk9dDl7t0U8Erz0Z3Itk3eq6QnvoMYpGnMVXA==
X-Received: by 2002:a5d:4952:0:b0:307:8126:5e30 with SMTP id r18-20020a5d4952000000b0030781265e30mr2428897wrs.38.1685026499900;
        Thu, 25 May 2023 07:54:59 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id t11-20020a5d49cb000000b0030732d6e104sm2048043wrs.105.2023.05.25.07.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 07:54:59 -0700 (PDT)
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
Subject: [net-next PATCH v2 08/13] leds: trigger: netdev: add support for LED hw control
Date: Thu, 25 May 2023 16:53:56 +0200
Message-Id: <20230525145401.27007-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525145401.27007-1-ansuelsmth@gmail.com>
References: <20230525145401.27007-1-ansuelsmth@gmail.com>
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


