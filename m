Return-Path: <netdev+bounces-6149-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6E6F714E8D
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:37:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D7E51C20AED
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DED671095F;
	Mon, 29 May 2023 16:34:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9A410942
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 16:34:55 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45C3E4;
	Mon, 29 May 2023 09:34:53 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f6a6b9c079so22898335e9.1;
        Mon, 29 May 2023 09:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685378092; x=1687970092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oXdnCyspEAq8AAhyVqhCs6kBBPc1hkVJYJIy6Md5CI4=;
        b=lkOnQVzBPdRH8/Nv2j5AFDxm8M4Adtic9A52/87JrFWw4lb3jSVuFUfQwO0DUjEuM0
         vgeuHA2KtHfXxjKdbz+WgWPFSKBsR28f1ydXaUm22KrCT+xI7u1rTwBmic+fuJj9WuUG
         kMWXW5U1R3dJtGVgaaJnSJMuePK3lreYxTd7/CWWAcSf2l6Bw/4e7y0vg5aSWBYUHe2B
         AoTIt6EmFblw3xkxb3o6BRoRGD5dHuspKMLxmdf5DApF/8y8bFko1RNjNquOSuK2jXKM
         agNh9ScnILi4enQpYNQviO40o2ZfGKO3TfdNPKeNFkEgpO0x4Ja94oLD/xuvkEXFY6um
         jHRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685378092; x=1687970092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oXdnCyspEAq8AAhyVqhCs6kBBPc1hkVJYJIy6Md5CI4=;
        b=lEbNPYU5etMY4M1HMKSpDosCS8NXF0PF2QYCQbexLUt8atthoe+Jmgpfljt5w3zO2N
         +R/5aZIiwnOrDsEYOdpWePesf7fpTy+brcmceMBsCGF4N6heV0zWQ4QN4tkAaxuBjmSy
         n2kN1TraJpWfQq5xyUb8Y/nM4x8U6vm3gjgAlqW/f1SoGTyATbTc+qe7XxYwV/GQpKp5
         jFDav3SA/stm33gtrbv8IHY1mMk+EBSLPtXL+6GfDCf9BAkVeSPC5SQ684HRthD+YCKC
         kTX54NqQLLyyPM+xUfY0vqgPIg39W1gVgz/Muo2h+DfaBX4De/JIH6tyc4Vv561A+pv4
         VgcQ==
X-Gm-Message-State: AC+VfDzdIxR5cq+Y/U534cgA6iIXVA2Kk6gjHboMWlEmwwJ0ekR4fcgS
	xvF2DdsV9u4z6Niv0paL1GQ=
X-Google-Smtp-Source: ACHHUZ46PXEr+fp6kcMm5T7lr5uu8Qi5+YIdKuudLNN1ssmWGLZUc7rEucyhIi2gPF0cMsxa0o4lCg==
X-Received: by 2002:a05:600c:2316:b0:3f6:15c:96fc with SMTP id 22-20020a05600c231600b003f6015c96fcmr10069687wmo.17.1685378091818;
        Mon, 29 May 2023 09:34:51 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id h14-20020a5d6e0e000000b002ff2c39d072sm417513wrz.104.2023.05.29.09.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:34:51 -0700 (PDT)
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
Subject: [net-next PATCH v4 09/13] leds: trigger: netdev: validate configured netdev
Date: Mon, 29 May 2023 18:32:39 +0200
Message-Id: <20230529163243.9555-10-ansuelsmth@gmail.com>
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
index 8f592a77cbef..0f3c2ace408d 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -110,6 +110,24 @@ static bool supports_hw_control(struct led_classdev *led_cdev)
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
 	unsigned long default_interval = msecs_to_jiffies(NETDEV_LED_DEFAULT_INTERVAL);
@@ -131,9 +149,11 @@ static bool can_hw_control(struct led_netdev_data *trigger_data)
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


