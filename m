Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2055444A4B5
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 03:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242014AbhKIC3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 21:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241284AbhKIC3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 21:29:07 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD4EC061767;
        Mon,  8 Nov 2021 18:26:21 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id f8so70626860edy.4;
        Mon, 08 Nov 2021 18:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yGOfJM0myGJ9WNoV+7xlGJ0AyPi6t90BpfeCjdvbki0=;
        b=jyCWj+7Cv7s2+oMLEi9HQeskxlU9QUu3KZ2y2mT0adK9F8buG7I9fBFjlu5XcUZxub
         Cu7l40mmX+P+VHnWFnJkCxytUVBCQGujk/4TXzqB4yOKdvG6q6egHEgULAZARsHCxQaG
         LszC2LxFCTdOKFORNPjOuj3Jmh4a5lGclLcOZXRXG1v7OWu2GA7zRoSWrGdGqY4PFMAK
         dUBIbnnH4r660HjzYnj9StSI7502wKFRG/qyFUILkHbpFUU9dBnvtqTFF7kpS/YR0by7
         ce8Z1vzI/h+Gm4V+4n0i7TAnMFybRJ78Ysf3W62QvOSnEuP6Cv1ewIEp7sjeTHDv5C8f
         PnuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yGOfJM0myGJ9WNoV+7xlGJ0AyPi6t90BpfeCjdvbki0=;
        b=TQy1QKVA3mhTyv2TFBS7cU230sgwa0hoe2f64iVeq45pJEGfd1SfKcyWxOjQFknm/4
         kk3Ri8v0YNR+wwzuc/9SoHXMnrJVnFrSc0awOGaJ9Mr1kNEvwRGFNy7anVSg9FcJdDZZ
         IsUnOVkZ3uGX0swy3qVC/bfYt9ihgR98UsJh5084FK5+PUfoqRF5jqj0W11A6Qz/+jKc
         b1PKZ20wARJg8YHp3oV9S2lpcp8PxQvJQym4Qw1HOH0LgeIz3KyCvWXSOvx/wU/CUybH
         RWHBpKUT+6pZwWMyJyRGJgo8AD7PfmIorpJhlkm98UZufR11o165UrCuELNI9E0m5YwT
         oWbQ==
X-Gm-Message-State: AOAM532oHWnA3rTpYaixXgumGLTesx92C5F2dzsugXt/l87iRaEx3qbj
        tB1a1ondzOkn/F1cw9Tv3cMYk83nwew=
X-Google-Smtp-Source: ABdhPJxCzaLSs5BdwfSMP6QLAebGM2WNVdZEhoCPu5TbGdeU1auKUErDXYCZmBZZvnWLWfVDTnCKcw==
X-Received: by 2002:a05:6402:34d3:: with SMTP id w19mr5293694edc.35.1636424779579;
        Mon, 08 Nov 2021 18:26:19 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m5sm8760900ejc.62.2021.11.08.18.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 18:26:19 -0800 (PST)
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
Subject: [RFC PATCH v3 5/8] leds: trigger: netdev: add hardware control support
Date:   Tue,  9 Nov 2021 03:26:05 +0100
Message-Id: <20211109022608.11109-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211109022608.11109-1-ansuelsmth@gmail.com>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
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
 drivers/leds/trigger/ledtrig-netdev.c | 61 ++++++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 0a3c0b54dbb9..28d9def2fbd0 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -37,6 +37,7 @@
  */
 
 struct led_netdev_data {
+	bool hw_mode_supported;
 	spinlock_t lock;
 
 	struct delayed_work work;
@@ -61,9 +62,52 @@ enum netdev_led_attr {
 
 static void set_baseline_state(struct led_netdev_data *trigger_data)
 {
+	bool can_offload;
 	int current_brightness;
+	u32 hw_blink_mode_supported;
 	struct led_classdev *led_cdev = trigger_data->led_cdev;
 
+	if (trigger_data->hw_mode_supported) {
+		if (test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode) &&
+		    led_trigger_blink_mode_is_supported(led_cdev, TRIGGER_NETDEV_LINK))
+			hw_blink_mode_supported |= TRIGGER_NETDEV_LINK;
+		if (test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode) &&
+		    led_trigger_blink_mode_is_supported(led_cdev, TRIGGER_NETDEV_TX))
+			hw_blink_mode_supported |= TRIGGER_NETDEV_TX;
+		if (test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode) &&
+		    led_trigger_blink_mode_is_supported(led_cdev, TRIGGER_NETDEV_RX))
+			hw_blink_mode_supported |= TRIGGER_NETDEV_RX;
+
+		/* All the requested blink mode can be triggered by hardware.
+		 * Put it in hardware mode.
+		 */
+		if (hw_blink_mode_supported == trigger_data->mode)
+			can_offload = true;
+
+		if (can_offload) {
+			/* We are refreshing the blink modes. Reset them */
+			led_cdev->hw_control_configure(led_cdev, TRIGGER_NETDEV_LINK,
+						       BLINK_MODE_ZERO);
+
+			if (test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode))
+				led_cdev->hw_control_configure(led_cdev, TRIGGER_NETDEV_LINK,
+							       BLINK_MODE_ENABLE);
+			if (test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode))
+				led_cdev->hw_control_configure(led_cdev, TRIGGER_NETDEV_TX,
+							       BLINK_MODE_ENABLE);
+			if (test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode))
+				led_cdev->hw_control_configure(led_cdev, TRIGGER_NETDEV_RX,
+							       BLINK_MODE_ENABLE);
+			led_cdev->hw_control_start(led_cdev);
+
+			return;
+		}
+	}
+
+	/* If LED supports only hardware mode then skip any software handling */
+	if (led_cdev->blink_mode == HARDWARE_CONTROLLED)
+		return;
+
 	current_brightness = led_cdev->brightness;
 	if (current_brightness)
 		led_cdev->blink_brightness = current_brightness;
@@ -407,13 +451,27 @@ static int netdev_trig_activate(struct led_classdev *led_cdev)
 	trigger_data->mode = 0;
 	atomic_set(&trigger_data->interval, msecs_to_jiffies(50));
 	trigger_data->last_activity = 0;
+	if (led_cdev->blink_mode != SOFTWARE_CONTROLLED) {
+		trigger_data->hw_mode_supported = true;
+
+		/* With hw mode enabled reset any rule set by default */
+		if (led_cdev->hw_control_status(led_cdev)) {
+			rc = led_cdev->hw_control_configure(led_cdev, TRIGGER_NETDEV_LINK,
+							    BLINK_MODE_ZERO);
+			if (rc)
+				goto err;
+		}
+	}
 
 	led_set_trigger_data(led_cdev, trigger_data);
 
 	rc = register_netdevice_notifier(&trigger_data->notifier);
 	if (rc)
-		kfree(trigger_data);
+		goto err;
 
+	return 0;
+err:
+	kfree(trigger_data);
 	return rc;
 }
 
@@ -433,6 +491,7 @@ static void netdev_trig_deactivate(struct led_classdev *led_cdev)
 
 static struct led_trigger netdev_led_trigger = {
 	.name = "netdev",
+	.supported_blink_modes = SOFTWARE_HARDWARE,
 	.activate = netdev_trig_activate,
 	.deactivate = netdev_trig_deactivate,
 	.groups = netdev_trig_groups,
-- 
2.32.0

