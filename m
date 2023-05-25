Return-Path: <netdev+bounces-5362-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F4A2710EDE
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:58:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B02C2815A3
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:58:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57395168A4;
	Thu, 25 May 2023 14:55:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF991D2A6
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:55:13 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7F5E4F;
	Thu, 25 May 2023 07:55:05 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f6042d605dso5344265e9.2;
        Thu, 25 May 2023 07:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685026504; x=1687618504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KxSZPUywOkLEyYIsTb69Uiy6IYUweaN3dPoh9bCN08U=;
        b=gbDuAeAounTF7FAEjlshh/hIMWkWCmhJabp/xwtY206Lc+GTbH/8lthE+qx+E6b1vz
         l9kSa4irHdr+JbZCfx+OEWmfBIVcEOYiSeb0nD9M7ti56XPIPyRHtPI0fafvSkRNejS+
         CabEkgo4/kvnublJ6Gknq2T4FlfbHBSOTwL/XPWKkT2e/V3O5UXj7RbNliDQ/iZX6TY6
         +KqkyBfCLd+MGt7ysR+dnLSmGcu/WHKryBUjtuOrJsHlYc0YsOc6dc13B6ZJoitAioLW
         x6ZU8l0Mggd1ciZp/u83qepmQco91QdWHYz8E4MsVOzHEMibxmM4l/+2gWvwivlzb9in
         kGIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685026504; x=1687618504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KxSZPUywOkLEyYIsTb69Uiy6IYUweaN3dPoh9bCN08U=;
        b=h79XPZh7Ub9CsfzvuIaiXKuCedgizzuEcs/brK6tnRUdkyZj0JCfD0+BI5zPVuamvB
         CcpG06aP8o1SaRsnco6e9wn70ALNbWP8hf2fOJwFjz08krfh/Bf0ls+RwslsRTRAII1+
         z3SRDowwfqVK4MlWX9ggWjlIsZGB70ZvV56JCdsKlJgo/iPmye+BW3Eyn/Fefqeqq3CM
         eOYwN3xYMQo7DL0QXTw7PHCYtuYbc9ywfwI8ZiRU2lJlLJFqyX/yb0LjzgWWAgG485tA
         EUWDaOnNeFbqhrQt16PVY7mdYPk5PEn1gupsH69PYwLldxFMnrBJ58jt7G4MR+ZoddZb
         0wNQ==
X-Gm-Message-State: AC+VfDxKHZG/XF9M6Tm2OCVy0TXXAejuenEUoz4cR/iGO0w+3lfv/LeS
	TiXQcdgYp+YgwWheqxLNuSs=
X-Google-Smtp-Source: ACHHUZ77bqRckmaPsw145x7H7sVy/IGAsadgOLDj1wInpboGicuy+OTGdAqe1zsgJN3gJiG4LWwCuA==
X-Received: by 2002:a7b:ce94:0:b0:3f4:2492:a91f with SMTP id q20-20020a7bce94000000b003f42492a91fmr2716489wmj.27.1685026503262;
        Thu, 25 May 2023 07:55:03 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id t11-20020a5d49cb000000b0030732d6e104sm2048043wrs.105.2023.05.25.07.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 07:55:02 -0700 (PDT)
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
Subject: [net-next PATCH v2 11/13] leds: trigger: netdev: expose netdev trigger modes in linux include
Date: Thu, 25 May 2023 16:53:59 +0200
Message-Id: <20230525145401.27007-12-ansuelsmth@gmail.com>
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


