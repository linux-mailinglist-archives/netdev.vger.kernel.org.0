Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF94344EA5F
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235486AbhKLPjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235358AbhKLPjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:39:04 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E7EC06120D;
        Fri, 12 Nov 2021 07:36:11 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id b184-20020a1c1bc1000000b0033140bf8dd5so7014525wmb.5;
        Fri, 12 Nov 2021 07:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=oJEpltYphpc/zLEEBz/4uTdZYomePaTobwU7mT3TYiE=;
        b=iQzYX3VZTmkz4zyTwS5qiIZuUw83l5QMby/hBe3lwC2UxliEcMRAp0XrXSEhCztBlq
         b7wPbgiyM+S1iA6KBuPSjonD/UHUhKHc9RzgM5o9qJoeQia6KwscSGvCZogY9V98WB21
         iYWlZB04GIi9weuswOgoh8gBiHeIL2jcqx//M4pvbbtO8rqpOow42LGqfjVbY9p4blB/
         eZeq3R8fDizkmQF8qb7Fo/3n9qrqTQpuKUo0m6suje5rNVtt5+VNoY4esC2zxewroLVp
         Rls6OIdviFtCmo+Di1DHTXtuGA/OPLE1Pnoc31ba95iz8E61+S1jNnPHurlubv7gOYM+
         +o8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oJEpltYphpc/zLEEBz/4uTdZYomePaTobwU7mT3TYiE=;
        b=WPcXScwas5EvMwtCnywt8LXO26uZdiuR1FustodYo/ASJCM+r1WgKwkLmF2BI4W11F
         VOtgjHH+3eF+vK9469HKNaZkJIcX1n0aOfM53GQ7684xY9ouZSIFQHS0yyNq5VtLMHYW
         joiXu57zbRZhew5fuZs7xCLDpRE9cY1tMnWKma2jR53o153E9h/r+t51KPbfo6M8Zijq
         dwpI97swksvH+GcNqHnLWw8JJnnFi7EHO8EfT2Wk1LyHth03HinC2fInZAboerRA14uW
         NSBn+rh4ve9hVDfX8SoH4JIMl6t0DUCuvflvWw/GZLLiYo+R3++ocaA0L0tJKHXYCC5Z
         WjNg==
X-Gm-Message-State: AOAM531SdNXTLcKxC1+wTAkJiDck0GOU9y9mh3eqLRTyjzaMFH+jhDvz
        Fk6GDIgS3IT773JCc9566kVtIm9dd6E=
X-Google-Smtp-Source: ABdhPJwgT9Avjp3XQdfuyfiBR5UKJNF48LLs6Z7YhnWzsX6suW7a9U7A/6S3B3sAJFvLOXu9kl+lJA==
X-Received: by 2002:a05:600c:3510:: with SMTP id h16mr34967324wmq.144.1636731369778;
        Fri, 12 Nov 2021 07:36:09 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id az4sm4217543wmb.20.2021.11.12.07.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 07:36:09 -0800 (PST)
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
Subject: [PATCH v5 6/8] leds: trigger: add hardware-phy-activity trigger
Date:   Fri, 12 Nov 2021 16:35:55 +0100
Message-Id: <20211112153557.26941-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211112153557.26941-1-ansuelsmth@gmail.com>
References: <20211112153557.26941-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Hardware Only Trigger for PHY Activity. This special trigger is used to
configure and expose the different HW trigger that are provided by the
PHY. Each blink mode can be configured by sysfs and on trigger
activation the hardware mode is enabled.

This currently implement these hw triggers:
  - blink_tx: Blink LED on tx packet receive
  - blink_rx: Blink LED on rx packet receive
  - link_10m: Keep LED on with 10m link speed
  - link_100m: Keep LED on with 100m link speed
  - link_1000m: Keep LED on with 1000m link speed
  - half_duplex: Keep LED on with half duplex link
  - full_duplex: Keep LED on with full duplex link
  - option_linkup_over: Ignore blink tx/rx with link keep not active
  - option_power_on_reset: Keep LED on with switch reset

The trigger will check if the LED driver support the various blink modes
and will expose the blink modes in sysfs.
It will finally enable hw mode for the LED without configuring any rule.
It's in the led driver interest the detection and knowing how to
elaborate the passed flags and should report -EOPNOTSUPP otherwise.

The different hw triggers are exposed in the led sysfs dir under the
hardware-phy-activity subdir.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/Kconfig                  |  27 +++
 drivers/leds/trigger/Makefile                 |   1 +
 .../trigger/ledtrig-hardware-phy-activity.c   | 180 ++++++++++++++++++
 include/linux/leds.h                          |  24 +++
 4 files changed, 232 insertions(+)
 create mode 100644 drivers/leds/trigger/ledtrig-hardware-phy-activity.c

diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
index 18a8970bfae6..ea7b33995e8d 100644
--- a/drivers/leds/trigger/Kconfig
+++ b/drivers/leds/trigger/Kconfig
@@ -162,4 +162,31 @@ config LEDS_TRIGGER_TTY
 
 	  When build as a module this driver will be called ledtrig-tty.
 
+config LEDS_TRIGGER_HARDWARE_PHY_ACTIVITY
+	tristate "LED Trigger for PHY Activity for Hardware Controlled LED"
+	help
+	  This allows LEDs to run by hardware and offloaded based on some
+	  rules. The LED will blink or be on based on the PHY
+	  activity for example on packet receive or based on the link speed.
+
+	  The current supported offload triggers are:
+	  - blink_tx: Blink LED on tx packet receive
+	  - blink_rx: Blink LED on rx packet receive
+	  - keep_link_10m: Keep LED on with 10m link speed
+	  - keep_link_100m: Keep LED on with 100m link speed
+	  - keep_link_1000m: Keep LED on with 1000m link speed
+	  - keep_half_duplex: Keep LED on with half duplex link
+	  - keep_full_duplex: Keep LED on with full duplex link
+	  - option_linkup_over: Blink rules are ignored with absent link
+	  - option_power_on_reset: Power ON Led on Switch/PHY reset
+	  - option_blink_2hz: Set blink speed at 2hz for every blink event
+	  - option_blink_4hz: Set blink speed at 4hz for every blink event
+	  - option_blink_8hz: Set blink speed at 8hz for every blink event
+
+	  These blink modes are present in the LED sysfs dir under
+	  hardware-phy-activity if supported by the LED driver.
+
+	  This trigger can be used only by LEDs that support Hardware mode.
+
+
 endif # LEDS_TRIGGERS
diff --git a/drivers/leds/trigger/Makefile b/drivers/leds/trigger/Makefile
index 25c4db97cdd4..f5d0d0057d2b 100644
--- a/drivers/leds/trigger/Makefile
+++ b/drivers/leds/trigger/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_LEDS_TRIGGER_NETDEV)	+= ledtrig-netdev.o
 obj-$(CONFIG_LEDS_TRIGGER_PATTERN)	+= ledtrig-pattern.o
 obj-$(CONFIG_LEDS_TRIGGER_AUDIO)	+= ledtrig-audio.o
 obj-$(CONFIG_LEDS_TRIGGER_TTY)		+= ledtrig-tty.o
+obj-$(CONFIG_LEDS_TRIGGER_HARDWARE_PHY_ACTIVITY) += ledtrig-hardware-phy-activity.o
diff --git a/drivers/leds/trigger/ledtrig-hardware-phy-activity.c b/drivers/leds/trigger/ledtrig-hardware-phy-activity.c
new file mode 100644
index 000000000000..4ac51011d029
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-hardware-phy-activity.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/leds.h>
+#include <linux/slab.h>
+
+#define PHY_ACTIVITY_MAX_BLINK_MODE 9
+
+static ssize_t blink_mode_common_show(int blink_mode, struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = led_trigger_get_led(dev);
+	struct hardware_phy_activity_data *trigger_data = led_cdev->trigger_data;
+	int val;
+
+	val = test_bit(blink_mode, &trigger_data->mode);
+	return sprintf(buf, "%d\n", val ? 1 : 0);
+}
+
+static ssize_t blink_mode_common_store(int blink_mode, struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = led_trigger_get_led(dev);
+	struct hardware_phy_activity_data *trigger_data = led_cdev->trigger_data;
+	unsigned long state;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &state);
+	if (ret)
+		return ret;
+
+	if (!!state)
+		set_bit(blink_mode, &trigger_data->mode);
+	else
+		clear_bit(blink_mode, &trigger_data->mode);
+
+	/* Update the configuration with every change */
+	led_cdev->blink_set(led_cdev, 0, 0);
+	return size;
+}
+
+#define DEFINE_HW_BLINK_MODE(blink_mode_name, blink_bit) \
+	static ssize_t blink_mode_name##_show(struct device *dev, \
+				struct device_attribute *attr, char *buf) \
+	{ \
+		return blink_mode_common_show(blink_bit, dev, attr, buf); \
+	} \
+	static ssize_t blink_mode_name##_store(struct device *dev, \
+					struct device_attribute *attr, \
+					const char *buf, size_t size) \
+	{ \
+		return blink_mode_common_store(blink_bit, dev, attr, buf, size); \
+	} \
+	DEVICE_ATTR_RW(blink_mode_name)
+
+/* Expose sysfs for every blink to be configurable from userspace */
+DEFINE_HW_BLINK_MODE(blink_tx, TRIGGER_PHY_ACTIVITY_BLINK_TX);
+DEFINE_HW_BLINK_MODE(blink_rx, TRIGGER_PHY_ACTIVITY_BLINK_RX);
+DEFINE_HW_BLINK_MODE(link_10M, TRIGGER_PHY_ACTIVITY_LINK_10M);
+DEFINE_HW_BLINK_MODE(link_100M, TRIGGER_PHY_ACTIVITY_LINK_100M);
+DEFINE_HW_BLINK_MODE(link_1000M, TRIGGER_PHY_ACTIVITY_LINK_1000M);
+DEFINE_HW_BLINK_MODE(half_duplex, TRIGGER_PHY_ACTIVITY_HALF_DUPLEX);
+DEFINE_HW_BLINK_MODE(full_duplex, TRIGGER_PHY_ACTIVITY_FULL_DUPLEX);
+DEFINE_HW_BLINK_MODE(option_linkup_over, TRIGGER_PHY_ACTIVITY_OPTION_LINKUP_OVER);
+DEFINE_HW_BLINK_MODE(option_power_on_reset, TRIGGER_PHY_ACTIVITY_OPTION_POWER_ON_RESET);
+
+static struct attribute *blink_mode_tbl[PHY_ACTIVITY_MAX_BLINK_MODE] = {
+	&dev_attr_blink_tx.attr,
+	&dev_attr_blink_rx.attr,
+	&dev_attr_link_10M.attr,
+	&dev_attr_link_100M.attr,
+	&dev_attr_link_1000M.attr,
+	&dev_attr_half_duplex.attr,
+	&dev_attr_full_duplex.attr,
+	&dev_attr_option_linkup_over.attr,
+	&dev_attr_option_power_on_reset.attr,
+};
+
+/* The attrs will be placed dynamically based on the supported triggers */
+// static struct attribute *phy_activity_attrs[PHY_ACTIVITY_MAX_TRIGGERS + 1];
+
+static int hardware_phy_activity_activate(struct led_classdev *led_cdev)
+{
+	struct hardware_phy_activity_data *trigger_data;
+	struct attribute_group *phy_activity_group;
+	struct attribute **phy_activity_attrs;
+	unsigned long supported_mode = 0;
+	int i, j, count = 0, ret;
+
+	trigger_data = kzalloc(sizeof(*trigger_data), GFP_KERNEL);
+	if (!trigger_data)
+		return -ENOMEM;
+
+	led_set_trigger_data(led_cdev, trigger_data);
+
+	/* Check supported blink modes
+	 * Request one mode at time and check if it can run in hardware mode
+	 */
+	for (i = 0; i < PHY_ACTIVITY_MAX_BLINK_MODE; i++) {
+		trigger_data->mode = 0;
+
+		set_bit(i, &trigger_data->mode);
+
+		if (!led_cdev->blink_set(led_cdev, 0, 0)) {
+			set_bit(i, &supported_mode);
+			count++;
+		}
+	}
+
+	if (!count) {
+		ret = -EINVAL;
+		goto fail_alloc_driver_data;
+	}
+
+	phy_activity_group = kzalloc(sizeof(phy_activity_group), GFP_KERNEL);
+	if (!phy_activity_group) {
+		ret = -ENOMEM;
+		goto fail_alloc_driver_data;
+	}
+
+	phy_activity_attrs = kcalloc(count + 1, sizeof(struct attribute *), GFP_KERNEL);
+	if (!phy_activity_attrs)
+		goto fail_alloc_attrs;
+
+	phy_activity_group->name = "hardware-phy-activity";
+	phy_activity_group->attrs = phy_activity_attrs;
+
+	for (i = 0, j = 0; i < count; i++)
+		if (test_bit(i, &supported_mode))
+			phy_activity_attrs[j++] = blink_mode_tbl[i];
+
+	ret = device_add_group(led_cdev->dev, phy_activity_group);
+	if (ret)
+		goto fail_alloc_group;
+
+	trigger_data->group = phy_activity_group;
+
+	/* Enable hardware mode. No custom configuration is applied,
+	 * the LED driver will use whatever default configuration is
+	 * currently configured.
+	 */
+	ret = led_cdev->hw_control_start(led_cdev);
+	if (ret)
+		goto fail_alloc_group;
+
+	return 0;
+fail_alloc_driver_data:
+	kfree(trigger_data);
+fail_alloc_group:
+	kfree(phy_activity_attrs);
+fail_alloc_attrs:
+	kfree(phy_activity_group);
+	return ret;
+}
+
+static void hardware_phy_activity_deactivate(struct led_classdev *led_cdev)
+{
+	struct hardware_phy_activity_data *trigger_data = led_get_trigger_data(led_cdev);
+
+	led_cdev->hw_control_stop(led_cdev);
+	device_remove_group(led_cdev->dev, trigger_data->group);
+	kfree(trigger_data->group->attrs);
+	kfree(trigger_data->group);
+	kfree(trigger_data);
+}
+
+static struct led_trigger hardware_phy_activity_trigger = {
+	.supported_blink_modes = HARDWARE_ONLY,
+	.name       = "hardware-phy-activity",
+	.activate   = hardware_phy_activity_activate,
+	.deactivate = hardware_phy_activity_deactivate,
+};
+
+static int __init hardware_phy_activity_init(void)
+{
+	return led_trigger_register(&hardware_phy_activity_trigger);
+}
+device_initcall(hardware_phy_activity_init);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 89ed009eecad..f6cdca894c53 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -532,6 +532,30 @@ enum led_trigger_netdev_modes {
 };
 #endif
 
+#ifdef CONFIG_LEDS_TRIGGER_HARDWARE_PHY_ACTIVITY
+/* 3 main category for offload trigger:
+ * - blink: the led will blink on trigger
+ * - keep: the led will be kept on with condition
+ * - option: a configuration value internal to the led on how offload works
+ */
+enum hardware_phy_activity {
+	TRIGGER_PHY_ACTIVITY_BLINK_TX, /* Blink on TX traffic */
+	TRIGGER_PHY_ACTIVITY_BLINK_RX, /* Blink on RX traffic */
+	TRIGGER_PHY_ACTIVITY_LINK_10M, /* LED on with 10M link */
+	TRIGGER_PHY_ACTIVITY_LINK_100M, /* LED on with 100M link */
+	TRIGGER_PHY_ACTIVITY_LINK_1000M, /* LED on with 1000M link */
+	TRIGGER_PHY_ACTIVITY_HALF_DUPLEX, /* LED on with Half-Duplex link */
+	TRIGGER_PHY_ACTIVITY_FULL_DUPLEX, /* LED on with Full-Duplex link */
+	TRIGGER_PHY_ACTIVITY_OPTION_LINKUP_OVER, /* LED will be on with KEEP blink mode and blink on BLINK traffic */
+	TRIGGER_PHY_ACTIVITY_OPTION_POWER_ON_RESET, /* LED will be on Switch reset */
+};
+
+struct hardware_phy_activity_data {
+	unsigned long mode;
+	struct attribute_group *group;
+};
+#endif
+
 /* Trigger specific functions */
 #ifdef CONFIG_LEDS_TRIGGER_DISK
 void ledtrig_disk_activity(bool write);
-- 
2.32.0

