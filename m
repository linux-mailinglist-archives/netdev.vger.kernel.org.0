Return-Path: <netdev+bounces-5877-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10321713468
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:30:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A06661C20EF8
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 11:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28B73F9D8;
	Sat, 27 May 2023 11:29:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3F7F9D6
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 11:29:20 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C606CF3;
	Sat, 27 May 2023 04:29:18 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f6d01d390bso17282645e9.2;
        Sat, 27 May 2023 04:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685186957; x=1687778957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2XcetGsyY64nRsofxWNfYd5cm6afWXm/2XDUNvEa4CI=;
        b=dItUINqJ0j/EFzW9NkTjcU1vd9oNOuBXLj1889FO0p+5zqglA2/dqcacpIqXZSQApP
         fjwxnijxiC+GIao/6+lMnOoUshp63q4Ur8Tm3B26ERlVYjGh22ZOlSDs54h/BG6kRmJM
         ADdQ2we+9gXqsh6MEICdBNegPLsBf7mNtZ6VBgiWf1QTqDgnudM+qe8yM7hdHLrY0nN5
         tG5gzA+fjyBJoO9HE2Yv7+UjgHfIirVT59zzswA2hX/EaV/aYDLjB5tFpcN+vP3EHKSf
         5faA+7Na0f5/hHttMkH/JGFWuQMgNDpO79OzP9dqEzNO0rrBvOIIVycoVlJRnyGZWoY9
         llOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685186957; x=1687778957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2XcetGsyY64nRsofxWNfYd5cm6afWXm/2XDUNvEa4CI=;
        b=bJGEfRBsH/jgcTtAJAZwGB+q2sPoRiMRMbEbt8kHi2ywNRC6zW+zaVYySjqU5Vvi/p
         V2Xa/AQJse4OGxvXnmStN7jAjzEfqNITJO4hi/zcUJJyuRwmeMlwm5qwbOLWHftZpZDU
         2YrYBF6MIeevx+fJa5AytmcB7MN2qG5VF82TMn7sbqoGunAnoizMlfuV1NPx1DzFx3l1
         Sr4lkAWKPhkr7/loDh8pJFPFStBbBWRWUxV9eIPpm7gPbepvJFAfS0TA5MndXzqiMwi1
         yineszN0JfuPtMUCzq4LKc6+aeCgDLFN6831iUVay/mBmW+bGDDPoU1RjUfopoav7JWr
         J7Fw==
X-Gm-Message-State: AC+VfDz8V0HfAbh6uIyZdwZo2nnqUOd7GfkNKS6olIAjGTxo4SIMVKiJ
	S8gHCtH4P6HWrYuagpC02Os=
X-Google-Smtp-Source: ACHHUZ6xaD419xhM4dliKQFPwJi+MNWqeiTC2+J0+4So6yJxgnfzQvOTTUW6FTpD/GW0RWKVeW0kUA==
X-Received: by 2002:a7b:c7c6:0:b0:3f5:f83:4d72 with SMTP id z6-20020a7bc7c6000000b003f50f834d72mr4531992wmk.38.1685186957126;
        Sat, 27 May 2023 04:29:17 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id q13-20020a7bce8d000000b003f43f82001asm11711000wmj.31.2023.05.27.04.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 04:29:16 -0700 (PDT)
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
Subject: [net-next PATCH v3 02/13] leds: add API to get attached device for LED hw control
Date: Sat, 27 May 2023 13:28:43 +0200
Message-Id: <20230527112854.2366-3-ansuelsmth@gmail.com>
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

Some specific LED triggers blink the LED based on events from a device
or subsystem.
For example, an LED could be blinked to indicate a network device is
receiving packets, or a disk is reading blocks. To correctly enable and
request the hw control of the LED, the trigger has to check if the
network interface or block device configured via a /sys/class/led file
match the one the LED driver provide for hw control for.

Provide an API call to get the device which the LED blinks for.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 include/linux/leds.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index 4caf559b1922..3268b4e789d6 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -220,6 +220,12 @@ struct led_classdev {
 	 */
 	int			(*hw_control_get)(struct led_classdev *led_cdev,
 						  unsigned long *flags);
+	/*
+	 * Get the device this LED blinks in response to.
+	 * e.g. for a PHY LED, it is the network device. If the LED is
+	 * not yet associated to a device, return NULL.
+	 */
+	struct device		*(*hw_control_get_device)(struct led_classdev *led_cdev);
 #endif
 
 #ifdef CONFIG_LEDS_BRIGHTNESS_HW_CHANGED
-- 
2.39.2


