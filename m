Return-Path: <netdev+bounces-6150-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7527A714E8E
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:37:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C1121C20AC5
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03EE21096F;
	Mon, 29 May 2023 16:34:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6B2A926
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 16:34:56 +0000 (UTC)
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931DCF4;
	Mon, 29 May 2023 09:34:54 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-3078a3f3b5fso3337238f8f.0;
        Mon, 29 May 2023 09:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685378093; x=1687970093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3JDhahJlRGp7rscxnWQW6zc0g/o81yCtHKEr1htw2Rg=;
        b=KzdaH2TttVBr8inSEozDQhuGSO031dUpGVf67TCRs3zHpF/QMJwT3VB23kwyK6YbUg
         9fLCU1rVE/5jjGXoSKzSl21kSL/sZXLSCtqCKzt/sByrB7TXjC2YGOi2ba5wPXtLozgh
         45b/hHPOGdcoSqqsIcqIi6jyqJuVU7lHePaQ/Uzj+2ZZKZMrMwjShPvpLl1UiRp+74c8
         w5oPCzmfJ6CnloJHxNLUc+J2BMy1brwH3b+uypeb5JO14Po1+rd14Mr9t31XNG9HpWiU
         BUkaf1Y8r6jL3AHNgfjRy809kgFumnyB1FLBDrQ11ARb9PeSVk6ncb2+ax/6EuPZ6rk2
         0Waw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685378093; x=1687970093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3JDhahJlRGp7rscxnWQW6zc0g/o81yCtHKEr1htw2Rg=;
        b=ZgQavdh3HoV+qFl1lmoRfjojm1YV1o/yeNAZ8nd2FYzQzVnNTrIYcWiSHt8G5HTwar
         rtCQWcnV47PckU4o+a5QkiEoU42oMPKfC87AiZPqyvquRiYJ+PqpmzdEcPW0uP0zHC2m
         D/q9ssBLr8PMpLFRXLTY/p/WSDkkEgLdBtGTI6ahWvjkyVj6KL7zIzK8rtAbyGZUKP/0
         6ieR6XpQPRi+wZ7nVrOU/zNSYahM+uZiYvvN2a0mikluYsxqANoMt5JZtaWJbgI+ZyNM
         AUHhsPhKJKSEw3mKBmSvtEnt5IPOkEiyrbUnSzZ99zuAQ2x6E7WMtg1evYbFJBSc758I
         5PQQ==
X-Gm-Message-State: AC+VfDwJc9V+lq41UrXgRnMWePqE7h4ltcUhW2vS5/vCThZNu3eG1tUm
	a7GHTFN0ZQTMLugXmmwvx8Y=
X-Google-Smtp-Source: ACHHUZ6fGxEY1P7QMULGLZn52wj9CCAtmBza94acxyhmpj8OJlgtvrRWcXaMb4gV98J+X6jY/Ifnsw==
X-Received: by 2002:a5d:54c4:0:b0:307:9194:9a94 with SMTP id x4-20020a5d54c4000000b0030791949a94mr8543087wrv.17.1685378092847;
        Mon, 29 May 2023 09:34:52 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id h14-20020a5d6e0e000000b002ff2c39d072sm417513wrz.104.2023.05.29.09.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:34:52 -0700 (PDT)
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
Subject: [net-next PATCH v4 10/13] leds: trigger: netdev: init mode if hw control already active
Date: Mon, 29 May 2023 18:32:40 +0200
Message-Id: <20230529163243.9555-11-ansuelsmth@gmail.com>
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

On netdev trigger activation, hw control may be already active by
default. If this is the case and a device is actually provided by
hw_control_get_device(), init the already active mode and set the
bool to hw_control bool to true to reflect the already set mode in the
trigger_data.

Co-developed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 0f3c2ace408d..e8bb9d0f85c0 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -454,6 +454,8 @@ static void netdev_trig_work(struct work_struct *work)
 static int netdev_trig_activate(struct led_classdev *led_cdev)
 {
 	struct led_netdev_data *trigger_data;
+	unsigned long mode;
+	struct device *dev;
 	int rc;
 
 	trigger_data = kzalloc(sizeof(struct led_netdev_data), GFP_KERNEL);
@@ -475,6 +477,21 @@ static int netdev_trig_activate(struct led_classdev *led_cdev)
 	atomic_set(&trigger_data->interval, msecs_to_jiffies(NETDEV_LED_DEFAULT_INTERVAL));
 	trigger_data->last_activity = 0;
 
+	/* Check if hw control is active by default on the LED.
+	 * Init already enabled mode in hw control.
+	 */
+	if (supports_hw_control(led_cdev) &&
+	    !led_cdev->hw_control_get(led_cdev, &mode)) {
+		dev = led_cdev->hw_control_get_device(led_cdev);
+		if (dev) {
+			const char *name = dev_name(dev);
+
+			set_device_name(trigger_data, name, strlen(name));
+			trigger_data->hw_control = true;
+			trigger_data->mode = mode;
+		}
+	}
+
 	led_set_trigger_data(led_cdev, trigger_data);
 
 	rc = register_netdevice_notifier(&trigger_data->notifier);
-- 
2.39.2


