Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24054474CE
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 18:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbhKGSAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 13:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhKGSAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 13:00:43 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A53C061570;
        Sun,  7 Nov 2021 09:58:00 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id w1so53683527edd.10;
        Sun, 07 Nov 2021 09:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sEe+1LkpyqVUAysbuk16NQnbu9CMsj5PlHYRWnM+YQc=;
        b=NZYUClmyLP2CI6b4Q1/iySvUHvHJqOQFBzvfkusIblBXzAtXhhzjvLrhaIZTz4u0PS
         76dUCvo4OG3uEmkoqtpOzao5pj4C1YnL6er7PzeTYAEjI/pXsVXUtF8AOQSa+z+Dsmfq
         CLuqB90JtGsy8IOrh0kEf0lsy2lNIVHkFepFtLmta1VHa1ZjnYmP1BGhwZRHf5M5GfRk
         khzlNCrPOKlnqv16cBCP73cm64zeI1e1Ia/7WIPlqH2VRnvtp33ZsBg81yvDJWXX/ZZ1
         BxoP4DoT2EBKPZOISRW1A+cSNuvJzfo0y29Ytzb1RHz8lgUnaYwGKIy4xjOgqF08YSG1
         Hcuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sEe+1LkpyqVUAysbuk16NQnbu9CMsj5PlHYRWnM+YQc=;
        b=Dz3GZYKoal/6G6HHK2Ugw5GLFj7+K6XBfShkJPlFFGFa26+2J028V03j9344YO7jCo
         QGhNVOg5W+LBfqEf1RDTSyRGOtKlpMXUIoCbW6uQAvHw0WIBx2fP21rlmqKHucbaQTWm
         SNKJjVz/qdSz9byeItLf5CVbisrj32cQPJDF4aPyyZhiIHrdRHs0FJTlbIxX+tE6tX9x
         gHC98H/6JEl/feSeBPlgAEeLa1RlP9XSirGHRcdPzZS0NqTbr/WnEP3wukxZDDucvjDR
         W8mTpUv9QqgPCRpoQQXOqJGXOsOgSZZY5Of4lDXgS798u6EAVBikwVyRQ/+WS1PERO27
         Ovqw==
X-Gm-Message-State: AOAM533Vaa7vKyXsPUEKJ/14kVj2mmZOpQUuJuRfpIwXeQMTNWctRjFj
        qd66LwY0CIAAr00/55WVOg4=
X-Google-Smtp-Source: ABdhPJyoTl47W002p5zFUObFU/56+sl4cJrurtn4q+gc6U+sQ1mMnPLFo7JJrWb3QlJxqdMAoiusbg==
X-Received: by 2002:a05:6402:90c:: with SMTP id g12mr71312917edz.131.1636307879015;
        Sun, 07 Nov 2021 09:57:59 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m11sm4251182edd.58.2021.11.07.09.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 09:57:58 -0800 (PST)
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
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [RFC PATCH 4/6] leds: trigger: add offload-phy-activity trigger
Date:   Sun,  7 Nov 2021 18:57:16 +0100
Message-Id: <20211107175718.9151-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211107175718.9151-1-ansuelsmth@gmail.com>
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Offload Trigger for PHY Activity. This special trigger is used to
configure and expose the different HW trigger that are provided by the
PHY. Each offload trigger can be configured by sysfs and on trigger
activation the offload mode is enabled.

This currently implement these hw triggers:
  - blink_tx: Blink LED on tx packet receive
  - blink_rx: Blink LED on rx packet receive
  - blink_collision: Blink LED on collision detection
  - link_10m: Keep LED on with 10m link speed
  - link_100m: Keep LED on with 100m link speed
  - link_1000m: Keep LED on with 1000m link speed
  - half_duplex: Keep LED on with half duplex link
  - full_duplex: Keep LED on with full duplex link
  - linkup_over: Keep LED on with link speed and blink on rx/tx traffic
  - power_on_reset: Keep LED on with switch reset
  - blink_2hz: Set blink speed at 2hz for every blink event
  - blink_4hz: Set blink speed at 4hz for every blink event
  - blink_8hz: Set blink speed at 8hz for every blink event
  - blink_auto: Set blink speed at 2hz for 10m link speed,
      4hz for 100m and 8hz for 1000m

The trigger will read the supported offload trigger in the led cdev and
will expose the offload triggers in sysfs and then activate the offload
mode for the led in offload mode has it configured by default. A flag is
passed to configure_offload with the related rule from this trigger to
active or disable.
It's in the led driver interest the detection and knowing how to
elaborate the passed flags.

The different hw triggers are exposed in the led sysfs dir under the
offload-phy-activity subdir.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/Kconfig                  |  25 +++
 drivers/leds/trigger/Makefile                 |   1 +
 .../trigger/ledtrig-offload-phy-activity.c    | 151 ++++++++++++++++++
 include/linux/leds.h                          |  24 +++
 4 files changed, 201 insertions(+)
 create mode 100644 drivers/leds/trigger/ledtrig-offload-phy-activity.c

diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
index c073e64e0a37..377a8bceb0b7 100644
--- a/drivers/leds/trigger/Kconfig
+++ b/drivers/leds/trigger/Kconfig
@@ -164,4 +164,29 @@ config LEDS_TRIGGER_TTY
 
 	  When build as a module this driver will be called ledtrig-tty.
 
+config LEDS_OFFLOAD_TRIGGER_PHY_ACTIVITY
+	tristate "LED Offload Trigger for PHY Activity"
+	depends on LEDS_OFFLOAD_TRIGGERS
+	help
+	  This allows LEDs to be configured to run by HW and offloaded based
+	  on some rules. The LED will blink or be on based on the PHY Activity
+	  for example on packet receive of based on the link speed.
+	  The current rules are:
+	  - blink_tx: Blink LED on tx packet receive
+	  - blink_rx: Blink LED on rx packet receive
+	  - blink_collision: Blink LED on collision detection
+	  - link_10m: Keep LED on with 10m link speed
+	  - link_100m: Keep LED on with 100m link speed
+	  - link_1000m: Keep LED on with 1000m link speed
+	  - half_duplex: Keep LED on with half duplex link
+	  - full_duplex: Keep LED on with full duplex link
+	  - linkup_over: Keep LED on with link speed and blink on rx/tx traffic
+	  - power_on_reset: Keep LED on with switch reset
+	  - blink_2hz: Set blink speed at 2hz for every blink event
+	  - blink_4hz: Set blink speed at 4hz for every blink event
+	  - blink_8hz: Set blink speed at 8hz for every blink event
+	  - blink_auto: Set blink speed at 2hz for 10m link speed,
+	                4hz for 100m and 8hz for 1000m
+
+
 endif # LEDS_TRIGGERS
diff --git a/drivers/leds/trigger/Makefile b/drivers/leds/trigger/Makefile
index 25c4db97cdd4..392ca8568588 100644
--- a/drivers/leds/trigger/Makefile
+++ b/drivers/leds/trigger/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_LEDS_TRIGGER_NETDEV)	+= ledtrig-netdev.o
 obj-$(CONFIG_LEDS_TRIGGER_PATTERN)	+= ledtrig-pattern.o
 obj-$(CONFIG_LEDS_TRIGGER_AUDIO)	+= ledtrig-audio.o
 obj-$(CONFIG_LEDS_TRIGGER_TTY)		+= ledtrig-tty.o
+obj-$(CONFIG_LEDS_OFFLOAD_TRIGGER_PHY_ACTIVITY) += ledtrig-offload-phy-activity.o
diff --git a/drivers/leds/trigger/ledtrig-offload-phy-activity.c b/drivers/leds/trigger/ledtrig-offload-phy-activity.c
new file mode 100644
index 000000000000..ca0500b1d37a
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-offload-phy-activity.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/leds.h>
+#include <linux/slab.h>
+
+#define PHY_ACTIVITY_MAX_TRIGGERS 14
+
+#define DEFINE_OFFLOAD_TRIGGER(trigger_name, trigger) \
+	static ssize_t trigger_name##_show(struct device *dev, \
+				struct device_attribute *attr, char *buf) \
+	{ \
+		struct led_classdev *led_cdev = led_trigger_get_led(dev); \
+		int val; \
+		val = led_cdev->configure_offload(led_cdev, trigger, TRIGGER_READ); \
+		return sprintf(buf, "%d\n", val ? 1 : 0); \
+	} \
+	static ssize_t trigger_name##_store(struct device *dev, \
+					struct device_attribute *attr, \
+					const char *buf, size_t size) \
+	{ \
+		struct led_classdev *led_cdev = led_trigger_get_led(dev); \
+		unsigned long state; \
+		int cmd, ret; \
+		ret = kstrtoul(buf, 0, &state); \
+		if (ret) \
+			return ret; \
+		cmd = !!state ? TRIGGER_ENABLE : TRIGGER_DISABLE; \
+		/* Update the configuration with every change */ \
+		led_cdev->configure_offload(led_cdev, trigger, cmd); \
+		return size; \
+	} \
+	DEVICE_ATTR_RW(trigger_name)
+
+/* Expose sysfs for every blink to be configurable from userspace */
+DEFINE_OFFLOAD_TRIGGER(blink_tx, BLINK_TX);
+DEFINE_OFFLOAD_TRIGGER(blink_rx, BLINK_RX);
+DEFINE_OFFLOAD_TRIGGER(blink_collision, BLINK_COLLISION);
+DEFINE_OFFLOAD_TRIGGER(keep_link_10m, KEEP_LINK_10M);
+DEFINE_OFFLOAD_TRIGGER(keep_link_100m, KEEP_LINK_100M);
+DEFINE_OFFLOAD_TRIGGER(keep_link_1000m, KEEP_LINK_1000M);
+DEFINE_OFFLOAD_TRIGGER(keep_half_duplex, KEEP_HALF_DUPLEX);
+DEFINE_OFFLOAD_TRIGGER(keep_full_duplex, KEEP_FULL_DUPLEX);
+DEFINE_OFFLOAD_TRIGGER(option_linkup_over, OPTION_LINKUP_OVER);
+DEFINE_OFFLOAD_TRIGGER(option_power_on_reset, OPTION_POWER_ON_RESET);
+DEFINE_OFFLOAD_TRIGGER(option_blink_2hz, OPTION_BLINK_2HZ);
+DEFINE_OFFLOAD_TRIGGER(option_blink_4hz, OPTION_BLINK_4HZ);
+DEFINE_OFFLOAD_TRIGGER(option_blink_8hz, OPTION_BLINK_8HZ);
+DEFINE_OFFLOAD_TRIGGER(option_blink_auto, OPTION_BLINK_AUTO);
+
+/* The attrs will be placed dynamically based on the supported triggers */
+static struct attribute *phy_activity_attrs[PHY_ACTIVITY_MAX_TRIGGERS + 1];
+
+static int offload_phy_activity_activate(struct led_classdev *led_cdev)
+{
+	const char *offload_trigger;
+	int i, trigger, ret;
+
+	/* This triggered is supported only by LEDs that can be offload driven */
+	if (!led_cdev->trigger_offload || !led_cdev->trigger_offload)
+		return -EOPNOTSUPP;
+
+	/* Scan the supported offload triggers and expose them in sysfs if supported */
+	for (trigger = 0, i = 0; trigger < led_cdev->supported_offload_triggers_count; trigger++) {
+		offload_trigger = led_cdev->supported_offload_triggers[trigger];
+
+		if (i >= PHY_ACTIVITY_MAX_TRIGGERS)
+			break;
+
+		if (!strcmp(offload_trigger, "tx-blink"))
+			phy_activity_attrs[i++] = &dev_attr_blink_tx.attr;
+
+		if (!strcmp(offload_trigger, "rx-blink"))
+			phy_activity_attrs[i++] = &dev_attr_blink_rx.attr;
+
+		if (!strcmp(offload_trigger, "collision-blink"))
+			phy_activity_attrs[i++] = &dev_attr_blink_collision.attr;
+
+		if (!strcmp(offload_trigger, "link-10M"))
+			phy_activity_attrs[i++] = &dev_attr_keep_link_10m.attr;
+
+		if (!strcmp(offload_trigger, "link-100M"))
+			phy_activity_attrs[i++] = &dev_attr_keep_link_100m.attr;
+
+		if (!strcmp(offload_trigger, "link-1000M"))
+			phy_activity_attrs[i++] = &dev_attr_keep_link_1000m.attr;
+
+		if (!strcmp(offload_trigger, "half-duplex"))
+			phy_activity_attrs[i++] = &dev_attr_keep_half_duplex.attr;
+
+		if (!strcmp(offload_trigger, "full-duplex"))
+			phy_activity_attrs[i++] = &dev_attr_keep_full_duplex.attr;
+
+		if (!strcmp(offload_trigger, "linkup-over"))
+			phy_activity_attrs[i++] = &dev_attr_option_linkup_over.attr;
+
+		if (!strcmp(offload_trigger, "power-on-reset"))
+			phy_activity_attrs[i++] = &dev_attr_option_power_on_reset.attr;
+
+		if (!strcmp(offload_trigger, "blink-2hz"))
+			phy_activity_attrs[i++] = &dev_attr_option_blink_2hz.attr;
+
+		if (!strcmp(offload_trigger, "blink-4hz"))
+			phy_activity_attrs[i++] = &dev_attr_option_blink_4hz.attr;
+
+		if (!strcmp(offload_trigger, "blink-8hz"))
+			phy_activity_attrs[i++] = &dev_attr_option_blink_8hz.attr;
+
+		if (!strcmp(offload_trigger, "blink-auto"))
+			phy_activity_attrs[i++] = &dev_attr_option_blink_auto.attr;
+	}
+
+	/* Enable offload mode. No custom configuration is applied,
+	 * the LED driver will use whatever default configuration is
+	 * currently configured.
+	 */
+	ret = led_cdev->trigger_offload(led_cdev, true);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void offload_phy_activity_deactivate(struct led_classdev *led_cdev)
+{
+	led_cdev->trigger_offload(led_cdev, false);
+}
+
+static const struct attribute_group phy_activity_group = {
+	.name = "offload-phy-activity",
+	.attrs = phy_activity_attrs,
+};
+
+static const struct attribute_group *phy_activity_groups[] = {
+	&phy_activity_group,
+	NULL,
+};
+
+static struct led_trigger offload_phy_activity_trigger = {
+	.name       = "offload-phy-activity",
+	.activate   = offload_phy_activity_activate,
+	.deactivate = offload_phy_activity_deactivate,
+	.groups     = phy_activity_groups,
+};
+
+static int __init offload_phy_activity_init(void)
+{
+	return led_trigger_register(&offload_phy_activity_trigger);
+}
+device_initcall(offload_phy_activity_init);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index eb06d812bc24..1e8d1efcb44f 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -537,6 +537,30 @@ static inline void ledtrig_flash_ctrl(bool on) {}
 static inline void ledtrig_torch_ctrl(bool on) {}
 #endif
 
+#ifdef CONFIG_LEDS_OFFLOAD_TRIGGER_PHY_ACTIVITY
+/* 3 main category for offload trigger:
+ * - blink: the led will blink on trigger
+ * - keep: the led will be kept on with condition
+ * - option: a configuration value internal to the led on how offload works
+ */
+enum offload_phy_activity {
+	BLINK_TX = BIT(0), /* Blink on TX traffic */
+	BLINK_RX = BIT(1), /* Blink on RX traffic */
+	BLINK_COLLISION = BIT(2), /* Blink on Collision packet */
+	KEEP_LINK_10M = BIT(3), /* LED on with 10M link */
+	KEEP_LINK_100M = BIT(4), /* LED on with 100M link */
+	KEEP_LINK_1000M = BIT(5), /* LED on with 1000M link */
+	KEEP_HALF_DUPLEX = BIT(6), /* LED on with Half-Duplex link */
+	KEEP_FULL_DUPLEX = BIT(7), /* LED on with Full-Duplex link */
+	OPTION_LINKUP_OVER = BIT(8), /* LED will be on with KEEP offload_triggers and blink on BLINK traffic */
+	OPTION_POWER_ON_RESET = BIT(9), /* LED will be on Switch reset */
+	OPTION_BLINK_2HZ = BIT(10), /* LED will blink with any offload_trigger at 2Hz */
+	OPTION_BLINK_4HZ = BIT(11), /* LED will blink with any offload_trigger at 4Hz */
+	OPTION_BLINK_8HZ = BIT(12), /* LED will blink with any offload_trigger at 8Hz */
+	OPTION_BLINK_AUTO = BIT(13), /* LED will blink differently based on the Link Speed */
+};
+#endif
+
 /*
  * Generic LED platform data for describing LED names and default triggers.
  */
-- 
2.32.0

