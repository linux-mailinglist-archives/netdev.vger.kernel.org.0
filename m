Return-Path: <netdev+bounces-5884-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D1CB713477
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:32:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 568751C20FBB
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 11:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7858125C1;
	Sat, 27 May 2023 11:29:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C861F125A5
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 11:29:29 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEB0134;
	Sat, 27 May 2023 04:29:26 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f603ff9c02so10975905e9.2;
        Sat, 27 May 2023 04:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685186965; x=1687778965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bzjSHLcSLKuyYbnB5oKrxVcxoSmgJOggg+ZfYlmNaGM=;
        b=QvdxWdjS+hkm5YxMe4Xjwx6raCsHbgdApVs96yBMFyu4JBQGn7WL9PTQjAf0MFsLhx
         ukBY+kIwoOZ1VW+GZt6vKfZ0XaRj/Xv4v0sukbM71DPI9aaxDYGow3jSnMGmvhqkjKCE
         J/keKNKvgB/O7f4DHcfj4Qh9iHIyz1cQW+XV1QBUy8zX3cvcq4/w+BTwDMjWmykuHmYo
         yQ2QNooQIEOuCLCS/Xo9FW75yFAzhqkU9ggDFFB3Injx28fVaYJgETUw9Yc7XgkMobgd
         J7p+68EqlpkZLPGF4yVngmqm+k5XmVPOEmbXhigcpaRkskDj5zyg9wWhOTmqpBSAtE3a
         1jgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685186965; x=1687778965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bzjSHLcSLKuyYbnB5oKrxVcxoSmgJOggg+ZfYlmNaGM=;
        b=FhhBqoscuIs8qVhecoqhUa416htFYCS1bKOy4yKl4dTu2kWZrlnujSLFl/cWvaG9pd
         R54RXP6NCYmQKUj8fgOTCbVwflFmzxkEA4C24OOgjo8fESwIrPOu2s1geuQozWmLP8Lo
         NMswDrZm5fIrwdakOAnibbiXnvxDJ0Srd6Dj/lEq9ACF2Hhs+WlNQ/f7/2fLwsIfzyvk
         wNt2Zu2z19no59bdL2edPwGtGRuWbzw32rEhcb0XbGDO4Fv/kh8vizFR+T0TB7attcO8
         skM1JS6adV638Wdrit7cnf+UDvL35PPPLt9Hy65J83I7L+19J7+hSaYsLim4klVugWGG
         1XwA==
X-Gm-Message-State: AC+VfDzDq2hqSUTr8pbxzObNiJwwnsM/ZS/J6UuPvdt4pyyoNW/xGJV0
	oJg+k3tNAA13eRsBYFx+Fh4=
X-Google-Smtp-Source: ACHHUZ6y9k7RyQ4acYi1QtYqybdqeTHG7B+8XEu2DH1j+5XI68i03hl312Mm/633WgXOLA6wjaYI3g==
X-Received: by 2002:a1c:f70e:0:b0:3f5:1728:bde9 with SMTP id v14-20020a1cf70e000000b003f51728bde9mr3682830wmh.2.1685186965133;
        Sat, 27 May 2023 04:29:25 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id q13-20020a7bce8d000000b003f43f82001asm11711000wmj.31.2023.05.27.04.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 04:29:24 -0700 (PDT)
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
Subject: [net-next PATCH v3 09/13] leds: trigger: netdev: validate configured netdev
Date: Sat, 27 May 2023 13:28:50 +0200
Message-Id: <20230527112854.2366-10-ansuelsmth@gmail.com>
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

From: Andrew Lunn <andrew@lunn.ch>

The netdev which the LED should blink for is configurable in
/sys/class/led/foo/device_name. Ensure when offloading that the
configured netdev is the same as the netdev the LED is associated
with. If it is not, only perform software blinking.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 8d6381415208..5b59441fc415 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -108,6 +108,24 @@ static bool supports_hw_control(struct led_classdev *led_cdev)
 	return !strcmp(led_cdev->hw_control_trigger, led_cdev->trigger->name);
 }
 
+/*
+ * Validate the configured netdev is the same as the one associated with
+ * the LED driver in hw control.
+ */
+static bool validate_net_dev(struct led_classdev *led_cdev,
+			     struct net_device *net_dev)
+{
+	struct device *dev = led_cdev->hw_control_get_device(led_cdev);
+	struct net_device *ndev;
+
+	if (!dev)
+		return false;
+
+	ndev = to_net_dev(dev);
+
+	return ndev == net_dev;
+}
+
 static bool can_hw_control(struct led_netdev_data *trigger_data)
 {
 	unsigned int interval = atomic_read(&trigger_data->interval);
@@ -129,9 +147,11 @@ static bool can_hw_control(struct led_netdev_data *trigger_data)
 	/*
 	 * net_dev must be set with hw control, otherwise no
 	 * blinking can be happening and there is nothing to
-	 * offloaded.
+	 * offloaded. Additionally, for hw control to be
+	 * valid, the configured netdev must be the same as
+	 * netdev associated to the LED.
 	 */
-	if (!trigger_data->net_dev)
+	if (!validate_net_dev(led_cdev, trigger_data->net_dev))
 		return false;
 
 	/* Check if the requested mode is supported */
-- 
2.39.2


