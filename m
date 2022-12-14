Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D9264D42D
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiLNX7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiLNX6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:58:52 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA935D6B3;
        Wed, 14 Dec 2022 15:55:46 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id h12so1433839wrv.10;
        Wed, 14 Dec 2022 15:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O8VEqn1f9hQgSk4zsH0ZS+dGwOqygrQKRIv4lYmvhVU=;
        b=HzwsZtHoobMLXGAbSQ8GEDfHllAQlen6Y6PPe7Dxc005ffypjDa8cGh/iqjubLfUX6
         9BVEq1IY6BZwZJVbJVuFo/8s/wLB/hW3ic55AIpAKm3dTYQtejTvKtTfFZnfBuWqF+cY
         3iY0YCSWskVjPuusL+y31yLF9FQK9Iv5219JY7DbdSyH+M1xH2UhtdCKGY+Epzx6CFm3
         xpjoAA7IMWGKOj7gJT0EkAA3v4lQtQRCpKLBaFtCK4EV6L0qWiBWtxwUayBQAR1itkPq
         REmposvouSyy4OuRTBIqd4O4vCDlKQ+gTa97FzeUHlT4CK2cv2PhJFiooOhPcPg3BYJK
         qNMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O8VEqn1f9hQgSk4zsH0ZS+dGwOqygrQKRIv4lYmvhVU=;
        b=i61QlZXSzHf7axItnAyv+6ZnlRqVhGfOk8d5vlFo8OBtTe72SESajrI2+bEzv5x7cd
         veGAEdkwSyd6kKEtwaRT9XTbis71DJWY56qLp6kOiZwEcglIRGkASItfbzu99N3A8VvX
         p+HvTzdzFeZyQWl880tsWZSY0cIwydHR+eUnTOTjZ6q7lgmtg41gt/5KTAvaDpHB7c1H
         mrBfj7DlYKYI6cCkdVrYPay3C+hVJzk6Rz1f2UE+mZcy7XVlmt1UMX2bPMoh+27sWF08
         uziZIlWdOuqXqtoFzdhcNDi3twycHSxD9ZhttpPBkXXUaGIvkT/BWh/ZxOjX67qffHi6
         dEQg==
X-Gm-Message-State: ANoB5pkqebG3o2gYJnhm4SfFnqWRpe/b99+NoR6jXZ8G4gEf/osxD3Ev
        36GrmU3loU012XvMdufXK/w=
X-Google-Smtp-Source: AA0mqf6Uvus+C+C/boDPbm3QySVMtQ/MtZA5vgX/JPaeM5upf4K54TbeFCXocEwVlHj0L9MfGgze7g==
X-Received: by 2002:a5d:4d4c:0:b0:24e:79f2:a5bd with SMTP id a12-20020a5d4d4c000000b0024e79f2a5bdmr12280368wru.47.1671062116688;
        Wed, 14 Dec 2022 15:55:16 -0800 (PST)
Received: from localhost.localdomain (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.googlemail.com with ESMTPSA id u2-20020adff882000000b00241d21d4652sm4163549wrp.21.2022.12.14.15.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 15:55:16 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH v7 06/11] leds: trigger: netdev: add hardware control support
Date:   Thu, 15 Dec 2022 00:54:33 +0100
Message-Id: <20221214235438.30271-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221214235438.30271-1-ansuelsmth@gmail.com>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add hardware control support for the Netdev trigger.
The trigger on config change will check if the requested trigger can set
to blink mode using LED hardware mode and if every blink mode is supported,
the trigger will enable hardware mode with the requested configuration.
If there is at least one trigger that is not supported and can't run in
hardware mode, then software mode will be used instead.
A validation is done on every value change and on fail the old value is
restored and -EINVAL is returned.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 155 +++++++++++++++++++++++++-
 1 file changed, 149 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index dd63cadb896e..ed019cb5867c 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -37,6 +37,7 @@
  */
 
 struct led_netdev_data {
+	enum led_blink_modes blink_mode;
 	spinlock_t lock;
 
 	struct delayed_work work;
@@ -53,11 +54,105 @@ struct led_netdev_data {
 	bool carrier_link_up;
 };
 
+struct netdev_led_attr_detail {
+	char *name;
+	bool hardware_only;
+	enum led_trigger_netdev_modes bit;
+};
+
+static struct netdev_led_attr_detail attr_details[] = {
+	{ .name = "link", .bit = TRIGGER_NETDEV_LINK},
+	{ .name = "tx", .bit = TRIGGER_NETDEV_TX},
+	{ .name = "rx", .bit = TRIGGER_NETDEV_RX},
+};
+
+static bool validate_baseline_state(struct led_netdev_data *trigger_data)
+{
+	struct led_classdev *led_cdev = trigger_data->led_cdev;
+	struct netdev_led_attr_detail *detail;
+	u32 hw_blink_mode_supported = 0;
+	bool force_sw = false;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(attr_details); i++) {
+		detail = &attr_details[i];
+
+		/* Mode not active, skip */
+		if (!test_bit(detail->bit, &trigger_data->mode))
+			continue;
+
+		/* Hardware only mode enabled on software controlled led */
+		if (led_cdev->blink_mode == SOFTWARE_CONTROLLED &&
+		    detail->hardware_only)
+			return false;
+
+		/* Check if the mode supports hardware mode */
+		if (led_cdev->blink_mode != SOFTWARE_CONTROLLED) {
+			/* With a net dev set, force software mode.
+			 * With modes are handled by hardware, led will blink
+			 * based on his own events and will ignore any event
+			 * from the provided dev.
+			 */
+			if (trigger_data->net_dev) {
+				force_sw = true;
+				continue;
+			}
+
+			/* With empty dev, check if the mode is supported */
+			if (led_trigger_blink_mode_is_supported(led_cdev, detail->bit))
+				hw_blink_mode_supported |= BIT(detail->bit);
+		}
+	}
+
+	/* We can't run modes handled by both software and hardware.
+	 * Check if we run hardware modes and check if all the modes
+	 * can be handled by hardware.
+	 */
+	if (hw_blink_mode_supported && hw_blink_mode_supported != trigger_data->mode)
+		return false;
+
+	/* Modes are valid. Decide now the running mode to later
+	 * set the baseline.
+	 * Software mode is enforced with net_dev set. With an empty
+	 * one hardware mode is selected by default (if supported).
+	 */
+	if (force_sw || led_cdev->blink_mode == SOFTWARE_CONTROLLED)
+		trigger_data->blink_mode = SOFTWARE_CONTROLLED;
+	else
+		trigger_data->blink_mode = HARDWARE_CONTROLLED;
+
+	return true;
+}
+
 static void set_baseline_state(struct led_netdev_data *trigger_data)
 {
+	int i;
 	int current_brightness;
+	struct netdev_led_attr_detail *detail;
 	struct led_classdev *led_cdev = trigger_data->led_cdev;
 
+	/* Modes already validated. Directly apply hw trigger modes */
+	if (trigger_data->blink_mode == HARDWARE_CONTROLLED) {
+		/* We are refreshing the blink modes. Reset them */
+		led_cdev->hw_control_configure(led_cdev, BIT(TRIGGER_NETDEV_LINK),
+					       BLINK_MODE_ZERO);
+
+		for (i = 0; i < ARRAY_SIZE(attr_details); i++) {
+			detail = &attr_details[i];
+
+			if (!test_bit(detail->bit, &trigger_data->mode))
+				continue;
+
+			led_cdev->hw_control_configure(led_cdev, BIT(detail->bit),
+						       BLINK_MODE_ENABLE);
+		}
+
+		led_cdev->hw_control_start(led_cdev);
+
+		return;
+	}
+
+	/* Handle trigger modes by software */
 	current_brightness = led_cdev->brightness;
 	if (current_brightness)
 		led_cdev->blink_brightness = current_brightness;
@@ -100,10 +195,15 @@ static ssize_t device_name_store(struct device *dev,
 				 size_t size)
 {
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
+	struct net_device *old_net = trigger_data->net_dev;
+	char old_device_name[IFNAMSIZ];
 
 	if (size >= IFNAMSIZ)
 		return -EINVAL;
 
+	/* Backup old device name */
+	memcpy(old_device_name, trigger_data->device_name, IFNAMSIZ);
+
 	cancel_delayed_work_sync(&trigger_data->work);
 
 	spin_lock_bh(&trigger_data->lock);
@@ -122,6 +222,19 @@ static ssize_t device_name_store(struct device *dev,
 		trigger_data->net_dev =
 		    dev_get_by_name(&init_net, trigger_data->device_name);
 
+	if (!validate_baseline_state(trigger_data)) {
+		/* Restore old net_dev and device_name */
+		if (trigger_data->net_dev)
+			dev_put(trigger_data->net_dev);
+
+		dev_hold(old_net);
+		trigger_data->net_dev = old_net;
+		memcpy(trigger_data->device_name, old_device_name, IFNAMSIZ);
+
+		spin_unlock_bh(&trigger_data->lock);
+		return -EINVAL;
+	}
+
 	trigger_data->carrier_link_up = false;
 	if (trigger_data->net_dev != NULL)
 		trigger_data->carrier_link_up = netif_carrier_ok(trigger_data->net_dev);
@@ -159,7 +272,7 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 				     size_t size, enum led_trigger_netdev_modes attr)
 {
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
-	unsigned long state;
+	unsigned long state, old_mode = trigger_data->mode;
 	int ret;
 	int bit;
 
@@ -184,6 +297,12 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 	else
 		clear_bit(bit, &trigger_data->mode);
 
+	if (!validate_baseline_state(trigger_data)) {
+		/* Restore old mode on validation fail */
+		trigger_data->mode = old_mode;
+		return -EINVAL;
+	}
+
 	set_baseline_state(trigger_data);
 
 	return size;
@@ -220,6 +339,8 @@ static ssize_t interval_store(struct device *dev,
 			      size_t size)
 {
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
+	int old_interval = atomic_read(&trigger_data->interval);
+	u32 old_mode = trigger_data->mode;
 	unsigned long value;
 	int ret;
 
@@ -228,13 +349,22 @@ static ssize_t interval_store(struct device *dev,
 		return ret;
 
 	/* impose some basic bounds on the timer interval */
-	if (value >= 5 && value <= 10000) {
-		cancel_delayed_work_sync(&trigger_data->work);
+	if (value < 5 || value > 10000)
+		return -EINVAL;
+
+	cancel_delayed_work_sync(&trigger_data->work);
+
+	atomic_set(&trigger_data->interval, msecs_to_jiffies(value));
 
-		atomic_set(&trigger_data->interval, msecs_to_jiffies(value));
-		set_baseline_state(trigger_data);	/* resets timer */
+	if (!validate_baseline_state(trigger_data)) {
+		/* Restore old interval on validation error */
+		atomic_set(&trigger_data->interval, old_interval);
+		trigger_data->mode = old_mode;
+		return -EINVAL;
 	}
 
+	set_baseline_state(trigger_data);	/* resets timer */
+
 	return size;
 }
 
@@ -368,13 +498,25 @@ static int netdev_trig_activate(struct led_classdev *led_cdev)
 	trigger_data->mode = 0;
 	atomic_set(&trigger_data->interval, msecs_to_jiffies(50));
 	trigger_data->last_activity = 0;
+	if (led_cdev->blink_mode != SOFTWARE_CONTROLLED) {
+		/* With hw mode enabled reset any rule set by default */
+		if (led_cdev->hw_control_status(led_cdev)) {
+			rc = led_cdev->hw_control_configure(led_cdev, BIT(TRIGGER_NETDEV_LINK),
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
 
@@ -394,6 +536,7 @@ static void netdev_trig_deactivate(struct led_classdev *led_cdev)
 
 static struct led_trigger netdev_led_trigger = {
 	.name = "netdev",
+	.supported_blink_modes = SOFTWARE_HARDWARE,
 	.activate = netdev_trig_activate,
 	.deactivate = netdev_trig_deactivate,
 	.groups = netdev_trig_groups,
-- 
2.37.2

