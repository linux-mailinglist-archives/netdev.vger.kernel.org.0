Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F49544EA58
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbhKLPjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbhKLPjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:39:04 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B44DC061208;
        Fri, 12 Nov 2021 07:36:10 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id i8-20020a7bc948000000b0030db7b70b6bso10167567wml.1;
        Fri, 12 Nov 2021 07:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KUnHZe884NpmCH64YY/DVb8a7ciFakw6u25MaWzmV24=;
        b=J4SOSH98HHCGQSAVio+ccNj/sbjCKXnOopykrhvOkwB9t6QdKx8I5F29poniW6ibow
         dSI77+gkoOWdL+S4X5dsKon+WCb7JKRvRoUGcCSAZN7s1EYDiWrtLvCMi5feDc2jNKDX
         Luk6SADfLrtE/cyPFR+r4Lf/lSietK6AhyPsSpHJCL/6vIS6GsRYjYwQjRrn2m8Cw0pG
         bYKdKZHwpxg/V3ccm/aqu43Utsa3mMgTNYUjW3hYWfswRyGg2Gorxat+owLR5dZgNBBx
         HPRxvWEGzYWLPgUL2mECTuFSJAMLKK7wsTOXGiGLVsndwZLdSXx5iAp02/9k2NwJ8sPZ
         mC7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KUnHZe884NpmCH64YY/DVb8a7ciFakw6u25MaWzmV24=;
        b=Q2GN+28e4DFBAaPtKT+Q/y7r6FQm0Dkt1ol7s0ka60DTq9RGP83p6SXHNYVmTAJr24
         6Vqj7W5V0cW2lP+zNdpJOLAQumugKfnaVVQlCkEmyxYydE5WIDejkUoqJBk+egt/s2V/
         IYA2wnvdCtX+Czv8SSPOSjznsdJSTaWRLHVNHOVymbGuELOYsKsKkAs4R0uUjUi+lvtW
         Fqjt+C5GVBSTvsUZfkfGcXD0yfvZLuX8s5WfOP2r2Rac5khSpLrgJXmbuGq7zsusH+YT
         JzNfPDhExOcRHnu0S8r3AwwTVRLjUj38ifHRUwwgsiWz536QpSKIyKMXEFuQ67T5ibr3
         AQIw==
X-Gm-Message-State: AOAM531Cvc7L4sylJxKYYN7eJsJAtP+dkGddi/OMA47aqtYU1B0XtLeD
        83D85UFn6+Xmb+NylJC4QIU=
X-Google-Smtp-Source: ABdhPJzeznUt7IW6Dd+vBI87MWnzw5kem9yKH2c0tJEpaBkN69XK7Dic/to0MzcDPI1bajDpo7ahgQ==
X-Received: by 2002:a1c:4686:: with SMTP id t128mr17771539wma.194.1636731368420;
        Fri, 12 Nov 2021 07:36:08 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id az4sm4217543wmb.20.2021.11.12.07.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 07:36:08 -0800 (PST)
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
Subject: [PATCH v5 5/8] leds: trigger: netdev: add hardware control support
Date:   Fri, 12 Nov 2021 16:35:54 +0100
Message-Id: <20211112153557.26941-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211112153557.26941-1-ansuelsmth@gmail.com>
References: <20211112153557.26941-1-ansuelsmth@gmail.com>
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
 1 file changed, 28 insertions(+), 2 deletions(-)

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
-- 
2.32.0

