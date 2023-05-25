Return-Path: <netdev+bounces-5358-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74D0A710ED8
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:57:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33B071C20EFA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D3A19BD1;
	Thu, 25 May 2023 14:55:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D5F19BC4
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:55:05 +0000 (UTC)
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF6519C;
	Thu, 25 May 2023 07:54:59 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-30a8c4afa46so851286f8f.1;
        Thu, 25 May 2023 07:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685026498; x=1687618498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9HiOL7lEFVgjMaEJrcmVlJpY1uQMDGELzriKpZXWbcM=;
        b=WR6lGEYzaUQzezgwM1Zx2/XWcpf6TwAB5cAfMIg5d3BUkNWNZZlNkUsS9Ob3L6F/V/
         ss/4WJXw9NaWnh+eDyFR9NdyN+Dpg92W3uqAGVHkES27O+lwIA38SLXAGWzi4ot7+4Yu
         2NZHsC1SXt6vWZteYEyUWspwCVVx3yRnYvbaSYzpwGP6z5ZOqGXt7Bv5kO2oIeMIVAXQ
         GLfIVUF+Q+EmS7PfTuw2yWBKe/biuDMZPuVxUQXjgWkgaK8bGgs/xBd5HGgFctI5uhTa
         dzlCeyZEFXXigGojH6ijXLLknJQbFZ7UNzK3dWlaof9B8U1b9JJzd9KcbIBEXT822HbF
         ckXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685026498; x=1687618498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9HiOL7lEFVgjMaEJrcmVlJpY1uQMDGELzriKpZXWbcM=;
        b=OEgcA1PvADnbqv5woX2nXCGIGyI5dCE2NiTR7RTaQOd1BEy1M2kZCfwr5cUOTvyR1Y
         B1cr5IHctJ6V3AxJyJk7fumEDdlqGzAypExSAX92A8x+6HsiuItI4tnJ7ERGIQBi7EqA
         TxGlij8XsFLTmXh82PvD6KWoSstlDMa5iC1XJaKUUpkGJ2GxkDB9katb9o8gpF7P322w
         4GMRokgQ6qvyzA3tmpj9ez7Hzx4BCgeUFWgrwUHCJxZS75o71I+9rXnQZ8bAd7/bcbXh
         UTzcojoHbNrR5Q/RpSw8/n2AGXPndd0ImZltEUtzHuw4gq9D7n1Aptcm9OQv8jm+VpES
         5rjA==
X-Gm-Message-State: AC+VfDwp9aGUNL4sYMRMWlpmK3aqe/siIu0LaDu0cLPthiGli08ifSTE
	t9SpyqRLJ/liJdAIxEILfYwrWkiXv4k=
X-Google-Smtp-Source: ACHHUZ4ekmf2x7kEuvrJ5ydkFNVMlIkPJmj5XvRmgqhLQB57SdEaUX5AkBoPGKYjbOTehz1qLhRpow==
X-Received: by 2002:adf:eb8a:0:b0:307:f75:f581 with SMTP id t10-20020adfeb8a000000b003070f75f581mr2268693wrn.18.1685026497648;
        Thu, 25 May 2023 07:54:57 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id t11-20020a5d49cb000000b0030732d6e104sm2048043wrs.105.2023.05.25.07.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 07:54:57 -0700 (PDT)
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
Subject: [net-next PATCH v2 06/13] leds: trigger: netdev: add basic check for hw control support
Date: Thu, 25 May 2023 16:53:54 +0200
Message-Id: <20230525145401.27007-7-ansuelsmth@gmail.com>
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

Add basic check for hw control support. Check if the required API are
defined and check if the defined trigger supported in hw control for the
LED driver match netdev.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index e1f3cedd5d57..2101cbbda707 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -92,8 +92,22 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	}
 }
 
+static bool supports_hw_control(struct led_classdev *led_cdev)
+{
+	if (!led_cdev->hw_control_get || !led_cdev->hw_control_set ||
+	    !led_cdev->hw_control_is_supported)
+		return false;
+
+	return !strcmp(led_cdev->hw_control_trigger, led_cdev->trigger->name);
+}
+
 static bool can_hw_control(struct led_netdev_data *trigger_data)
 {
+	struct led_classdev *led_cdev = trigger_data->led_cdev;
+
+	if (!supports_hw_control(led_cdev))
+		return false;
+
 	return false;
 }
 
-- 
2.39.2


