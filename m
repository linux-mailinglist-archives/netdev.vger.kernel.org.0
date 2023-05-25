Return-Path: <netdev+bounces-5361-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5B98710EDD
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A614E1C20EF0
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0EEE1D2AA;
	Thu, 25 May 2023 14:55:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A971D2A6
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:55:09 +0000 (UTC)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF97E41;
	Thu, 25 May 2023 07:55:03 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-30950eecc1eso2202038f8f.0;
        Thu, 25 May 2023 07:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685026502; x=1687618502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t032UqrKs2qK0Tmykkb/w0e10wBacVTlNSbQa7zNqmM=;
        b=lk+LPQzKeEhjejpM7t5dj1Id8x9o3Kde6+5yRdFfD8o17qYlM53Rc1EQO2MZDE6GCK
         xZxoq7ef6Qb4sEt3lRvgzzADsWYuqR+Yum4tz1uOgIj2aDl32mdWDE0bnRPaQsQh95OA
         fg0tzv/UMNn1+kmKlKPLuPHmkrndmBkA6xdZypAAyKudtHEEijLGAWdGTCRLm4REcVbd
         NsSwKrslT2xT1f+o8rf0rasPaqWHBs7UYz9uI9+U56V2rWOdJ5+daTtzy88LXuEAy84t
         9FCBnLuUeoglXeqE3XxjvBIUKZxiN0PmyZ/ztBv0KqOGLB25MNzlJtiasPmGC112QAJx
         IEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685026502; x=1687618502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t032UqrKs2qK0Tmykkb/w0e10wBacVTlNSbQa7zNqmM=;
        b=CLsnXgV6VisrRKqayVln5HvMb1PV7q0yyF56o06Fi0Ypmu82BvKcsDxAfmGV+Vuqxa
         OXULMZDNBHOWLpUW2SpbPAX+1rvTmLKYg36IVJbFfDHhhMa+CC5VZA8yTMrR0uojE5Kq
         HluO7qGWij8EdvAhAQCsencZ5x+AsqV4AeArdUYt4NcshqeuEp+F93J/35/0Im23C6j6
         QwEI4BF+ZlJd+oXw3ctFJjuuc06jfkyQVcNkGvu26c1jgtdf9JqHbQW7eYduS23B/yKp
         gjJu5JqO9DOKogbPtyDcxa8H3ajvsVFrAqRfqho9zU4bVhdcBiMX/IncKj1PSfg7hVrg
         zrrw==
X-Gm-Message-State: AC+VfDzQ+TBTs+PFWVVQsRl7M9fSbFxGYsC7ibIGbzWJi4pqB0QucPxi
	3K1B7Wi4ZdvJkiY8/cakV5HexziaRNk=
X-Google-Smtp-Source: ACHHUZ7uYjwK0LlEOlSsD0tHabtZUW+f31t2nJZASWhMK5V5HmzdsVKNmt8iZo6KsmAxmNfh0Zz5vA==
X-Received: by 2002:a5d:670f:0:b0:306:3817:4a80 with SMTP id o15-20020a5d670f000000b0030638174a80mr2968518wru.0.1685026502084;
        Thu, 25 May 2023 07:55:02 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id t11-20020a5d49cb000000b0030732d6e104sm2048043wrs.105.2023.05.25.07.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 07:55:01 -0700 (PDT)
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
Subject: [net-next PATCH v2 10/13] leds: trigger: netdev: init mode if hw control already active
Date: Thu, 25 May 2023 16:53:58 +0200
Message-Id: <20230525145401.27007-11-ansuelsmth@gmail.com>
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
index 5b59441fc415..b0cab2b84ce2 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -452,6 +452,8 @@ static void netdev_trig_work(struct work_struct *work)
 static int netdev_trig_activate(struct led_classdev *led_cdev)
 {
 	struct led_netdev_data *trigger_data;
+	unsigned long mode;
+	struct device *dev;
 	int rc;
 
 	trigger_data = kzalloc(sizeof(struct led_netdev_data), GFP_KERNEL);
@@ -473,6 +475,21 @@ static int netdev_trig_activate(struct led_classdev *led_cdev)
 	atomic_set(&trigger_data->interval, msecs_to_jiffies(50));
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


