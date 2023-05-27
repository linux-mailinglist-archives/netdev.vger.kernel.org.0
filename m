Return-Path: <netdev+bounces-5885-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC226713478
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:32:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 752FD281862
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 11:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C8C0125A5;
	Sat, 27 May 2023 11:29:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCD1134A2
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 11:29:32 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A951194;
	Sat, 27 May 2023 04:29:29 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f603ff9c02so10976015e9.2;
        Sat, 27 May 2023 04:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685186968; x=1687778968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KxSZPUywOkLEyYIsTb69Uiy6IYUweaN3dPoh9bCN08U=;
        b=URCGY0DjnJr3dFx90UfzqHf9Qhb+oM6F7KdENTY7rAPOShs5L/VQkM6OUP7fduRylO
         v5gfdDLoqq6iSgI+il56PB+q7lMsBvoc6/oael6KD0xBjkmVJ4QtavVkk7u6MqHt7CQL
         S3qR/5PGjLt7d4zUr6FQDwR71qmrwrfz+2ygNlI6SlK5G6ATHQaPZJIiuia0qVqdhj2B
         Givsn2i2wchhYdQ+MBIbSnq7cpB0bUo/NCDkpWECM27U/NiYE0hUQYuO4C0DTH8mA2kC
         ImssXuO4v2SnIYVy2dkwmEdMEC2RIvyB8xCEHNFUBfKXVc2fElHxNYcSO1Un7a1qe616
         LySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685186968; x=1687778968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KxSZPUywOkLEyYIsTb69Uiy6IYUweaN3dPoh9bCN08U=;
        b=kW1G97tcBz52BjPxhM4jwcFbTBdMDjJAIiMtKVV+nZug5iI6pBcRMRVJkgv6Yf7JPw
         1GHP3rdaHsgsQgezoRyR8A2ZFMF9Z6k2VWX3nesbbwm25HtzYxaxCS6ud11qBmX1B7qa
         5rNNSHzn4bPagDPdEysNe+S51qgb1OvASRpg7NGKrKWWTmL+6O2dFemtudZeyvrnsuvX
         0LjQesFI/2UMO/CTUcCA5D/tROkpjSJEUNn63WqXzLqrtajZiQRe1/p8HwCERkKvNff8
         4A0pJht6sBQX88ZNskPJVtaDjXFYQCChm9aRnU2vze0O+Yq/lS508S9z/2l9TDNhUYC+
         Pgcg==
X-Gm-Message-State: AC+VfDySNjKTs5v8zjNjSV9WHr20CPgmSAzaR0tlg09yyHraxhIxAVgb
	RplUfDQ2Ug7Uaxh+x9IHF24=
X-Google-Smtp-Source: ACHHUZ4M4c2cW0Og7OtrUmhEcGHh/2HMj0K3FXRek1686jTNfghXqx9PTSMDfkOdyqFy9kyuiH4SEQ==
X-Received: by 2002:a05:600c:2304:b0:3f4:ffaf:a862 with SMTP id 4-20020a05600c230400b003f4ffafa862mr4155453wmo.12.1685186967730;
        Sat, 27 May 2023 04:29:27 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id q13-20020a7bce8d000000b003f43f82001asm11711000wmj.31.2023.05.27.04.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 04:29:27 -0700 (PDT)
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
Subject: [net-next PATCH v3 11/13] leds: trigger: netdev: expose netdev trigger modes in linux include
Date: Sat, 27 May 2023 13:28:52 +0200
Message-Id: <20230527112854.2366-12-ansuelsmth@gmail.com>
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

Expose netdev trigger modes to make them accessible by LED driver that
will support netdev trigger for hw control.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c |  9 ---------
 include/linux/leds.h                  | 10 ++++++++++
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index b0cab2b84ce2..8fbca94edfce 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -54,15 +54,6 @@ struct led_netdev_data {
 	bool hw_control;
 };
 
-enum led_trigger_netdev_modes {
-	TRIGGER_NETDEV_LINK = 0,
-	TRIGGER_NETDEV_TX,
-	TRIGGER_NETDEV_RX,
-
-	/* Keep last */
-	__TRIGGER_NETDEV_MAX,
-};
-
 static void set_baseline_state(struct led_netdev_data *trigger_data)
 {
 	int current_brightness;
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 3268b4e789d6..8af62ff431f0 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -552,6 +552,16 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 
 #endif /* CONFIG_LEDS_TRIGGERS */
 
+/* Trigger specific enum */
+enum led_trigger_netdev_modes {
+	TRIGGER_NETDEV_LINK = 0,
+	TRIGGER_NETDEV_TX,
+	TRIGGER_NETDEV_RX,
+
+	/* Keep last */
+	__TRIGGER_NETDEV_MAX,
+};
+
 /* Trigger specific functions */
 #ifdef CONFIG_LEDS_TRIGGER_DISK
 void ledtrig_disk_activity(bool write);
-- 
2.39.2


