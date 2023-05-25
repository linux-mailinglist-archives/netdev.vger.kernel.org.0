Return-Path: <netdev+bounces-5353-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC14D710ECE
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:55:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D1201C20A70
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F9FC156F0;
	Thu, 25 May 2023 14:54:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3509917AD5
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:54:56 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB53189;
	Thu, 25 May 2023 07:54:54 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-3093a7b71fbso2169366f8f.2;
        Thu, 25 May 2023 07:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685026493; x=1687618493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2XcetGsyY64nRsofxWNfYd5cm6afWXm/2XDUNvEa4CI=;
        b=C35jgQvYw4Dhhjlq99GXGkWM9YbjFEYiiw9LfV1Tp1x6yoEIDZnO3hkXa6LWtJe3IU
         By2/VVkms0uR6f+WLhqc3CRLPXSq4XIWO+FHMsMIDPkaDxdWrdQSHlvRcgJOw3XwCutc
         BX/lVhXxlPIExBREDcetGXhrHXetoYkHgb/hSeMInbMRbDpvcbRe7vYOHkAq0B7lwHpM
         UY3/QqC81e1vj85hb7k3fQLKHLTKNIf+8mZpm00ZvGZEaE6a/bvJ9BlEiAWNiVuu4BpO
         Ag47CGEEDZ3+x5DfFVgccLmvEnfGiR8fHulRMnDP2G9CHkBOeiEbNojYoHrO0P3/b2s7
         lB3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685026493; x=1687618493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2XcetGsyY64nRsofxWNfYd5cm6afWXm/2XDUNvEa4CI=;
        b=HwoKe6sY4ER4NXUAC1cE0Yl12Vu1GSX9fo80dOri/RM+S3fRyuaVKR47zNBQVzj6KS
         +CjniBx5GnC8kR7owMgd+8ioJanS8hOTZgA/eU/V2bFm+kheba6vvt8UdVyDRrQKM2PO
         nPs/ppR2qW1eyWDEV/HnTa/NXUoaIsRjxq5HtQNbCeWgwfXeqc5ogWYuB2F9fvUdLq/M
         I4tW42i3muS6XdC0xsLLiPANWTWNOHwM4Trzm70vQGWvETqgTM0M/L4bXqbdJdq2/z9O
         MDAeOg08gNnGsfjA1dqwQeWH2o6uvS9N/12Mxt5vM5Rs7dQNAuiRpnCsv9EQ9wCD9seL
         rIGA==
X-Gm-Message-State: AC+VfDxqZxH84ISX6u2sqBT5cR2lel9Jo0QI5G2ZvtE0is6VdilOsrZD
	0wP7tvPgAgSAfwz1eAJF2/o=
X-Google-Smtp-Source: ACHHUZ4yim//MQYKl+ciB5nU+SaUj6ChGYSycH1ljm+IfjlbfZGvhl9UUJDQN5vgUEGbhB9wl0gn/A==
X-Received: by 2002:a5d:574d:0:b0:309:54b6:33b0 with SMTP id q13-20020a5d574d000000b0030954b633b0mr2822027wrw.44.1685026492884;
        Thu, 25 May 2023 07:54:52 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id t11-20020a5d49cb000000b0030732d6e104sm2048043wrs.105.2023.05.25.07.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 07:54:52 -0700 (PDT)
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
Subject: [net-next PATCH v2 02/13] leds: add API to get attached device for LED hw control
Date: Thu, 25 May 2023 16:53:50 +0200
Message-Id: <20230525145401.27007-3-ansuelsmth@gmail.com>
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


