Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F62544CEE2
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 02:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbhKKBiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 20:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233067AbhKKBiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 20:38:04 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3322EC061767;
        Wed, 10 Nov 2021 17:35:16 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id p3-20020a05600c1d8300b003334fab53afso3157837wms.3;
        Wed, 10 Nov 2021 17:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SBtdLBLw2eoYI8PcSch2YIbDJHD+2YGJt7MMLHzgrUo=;
        b=Hlby/SNskGUI1OFKCcoU3gHZ6ovHSJcOVMbFqS7xccD9TA02nEpALw/33EXxlEp/ip
         ZgKmdHKUWkZb9/yddiRlMQQFcQ/teKYlTJ4t6hU+Vd8nIKuAwmdD4YXGFqRDO4ldFeGf
         f/Am9uq85xPbCU3+QxBKVnYdSRpNpg2aT6qmOoddnEGHagdUTPRDcFLXLDE0NM3srmos
         bgcsUr/uNwy6YUGz8vkjizTI/cbGVVKklwzfeJFjzpyz9XBBeDyfwNbfblwmLQ34GvSx
         ElRezvhuW1RNz2f1Fj1S7IG+6xmSfSvp30egKNwEWRBjRj9Z/CBiqrG8VKlx5m3jTaq1
         X6OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SBtdLBLw2eoYI8PcSch2YIbDJHD+2YGJt7MMLHzgrUo=;
        b=PQEiMk+2w5UNE3Dp1dyxTM68f7vzvlT5TMcvu30AL2McYcMzUQj8qVispyjNT87d/x
         CBqj3nAS7Ma9vLSWS3mcxEwL8e3v/oWXcLm8gzImQXVfWtka9mB5KBsfrpA1uEvrMcXD
         NT4oCLYrKy1XlhouA0yYIm2hLb0dgea9LQyf/aWvEFDq+Xn1wlBddR2KBmktWn3akhbJ
         LZFxPISi9u09mO+o8Iy0c9PvjbWmvMMgjK2DFSlo1gzZ5YJvtb1FU07a9RMxDJxedegU
         HMd1IHJ115qyGfkLlkjVaoclSNik9p9VaKTs0KWz6fLfgSUalZsEki+VRTx3ryZNXzP2
         LCFQ==
X-Gm-Message-State: AOAM530o7vYV1QVO0gx0t9ZGt6G6vz6vNqQ3dzID/WQZr2zQhGv7pBMe
        o4Dzs4T4YR4NosDvXxO1hm4=
X-Google-Smtp-Source: ABdhPJx3cfNBYRCPs4O9wAoXN5WMTF3SZYuTBjxzSYpYuOI6Hc5f2uDh/e2v9I9fBa6HHY0Cznp1lA==
X-Received: by 2002:a05:600c:1d97:: with SMTP id p23mr4144201wms.144.1636594514650;
        Wed, 10 Nov 2021 17:35:14 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id d8sm1369989wrm.76.2021.11.10.17.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 17:35:14 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [RFC PATCH v4 5/8] leds: trigger: netdev: add hardware control support
Date:   Thu, 11 Nov 2021 02:34:57 +0100
Message-Id: <20211111013500.13882-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211111013500.13882-1-ansuelsmth@gmail.com>
References: <20211111013500.13882-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add hardware control support for the Netdev trigger.
The trigger on config change will check if the requested trigger can set
to blink mode using LED hardware mode and if every blink mode is supported,
the trigger will enable hardware mode with the requested configuration.
If there is at least one trigger that is not supported and can't run in
hardware mode, then software mode will be used instead.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 30 +++++++++++++++++++++++++--
 include/linux/leds.h                  |  3 +++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 01e4544fa7b0..74c9a6ecfbbf 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -44,9 +44,31 @@ enum netdev_led_attr {
 
 static void set_baseline_state(struct led_netdev_data *trigger_data)
 {
-	int current_brightness;
+	int current_brightness, can_offload;
 	struct led_classdev *led_cdev = trigger_data->led_cdev;
 
+	if (LED_HARDWARE_CONTROLLED & led_cdev->flags) {
+		/* Check if blink mode can he set in hardware mode.
+		 * The LED driver will chose a interval based on the trigger_data
+		 * and its implementation.
+		 */
+		can_offload = led_cdev->blink_set(led_cdev, 0, 0);
+
+		/* If blink_set doesn't return error we can run in hardware mode
+		 * So actually activate it.
+		 */
+		if (!can_offload) {
+			led_cdev->hw_control_start(led_cdev);
+			return;
+		}
+	}
+
+	/* If LED supports only hardware mode and we reach this point,
+	 * then skip any software handling.
+	 */
+	if (!(LED_SOFTWARE_CONTROLLED & led_cdev->flags))
+		return;
+
 	current_brightness = led_cdev->brightness;
 	if (current_brightness)
 		led_cdev->blink_brightness = current_brightness;
@@ -395,8 +417,11 @@ static int netdev_trig_activate(struct led_classdev *led_cdev)
 
 	rc = register_netdevice_notifier(&trigger_data->notifier);
 	if (rc)
-		kfree(trigger_data);
+		goto err;
 
+	return 0;
+err:
+	kfree(trigger_data);
 	return rc;
 }
 
@@ -416,6 +441,7 @@ static void netdev_trig_deactivate(struct led_classdev *led_cdev)
 
 static struct led_trigger netdev_led_trigger = {
 	.name = "netdev",
+	.supported_blink_modes = SOFTWARE_HARDWARE,
 	.activate = netdev_trig_activate,
 	.deactivate = netdev_trig_deactivate,
 	.groups = netdev_trig_groups,
diff --git a/include/linux/leds.h b/include/linux/leds.h
index bc3c54eb269a..dd41acd564a3 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -17,6 +17,9 @@
 #include <linux/spinlock.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
+#ifdef CONFIG_LEDS_TRIGGER_NETDEV
+#include <linux/netdevice.h>
+#endif
 
 struct device;
 struct led_pattern;
-- 
2.32.0

