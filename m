Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDAD4476F0
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 01:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbhKHA15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 19:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236808AbhKHA1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 19:27:52 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D545C061570;
        Sun,  7 Nov 2021 16:25:08 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id b15so36348390edd.7;
        Sun, 07 Nov 2021 16:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9SgyI4sGJbXscjvIGxLavpMHgkTTZKLHre1z7SLAwQc=;
        b=ESAKVX16u2WjEUO2Ui01oeXGzmVRTExWfRzZgIZo+Qb85jVQoYTu01CSpDykXCofok
         330jRh5rSasBzK7g9I2R+k2P8DufvONO6SbpiuGYFeEKYHhQxY7wA9oRqm+3BB3pViwL
         03X4eKI0QtDKF/87ffhTpHZtAylKEpRFy7PhpmseFdYeyu+IyCAZjIq8//+kYEc4PL51
         voHn7gex858GGj09NGWIM6XuFKs8MezeYSJr66+KyO3FEDdtEpnqlsX9bIl3rBkAbxM6
         UlmynaSXNlaUBboJzV23D8YKrHuL/4Yk/u6hm49c5aV+JvfHGrSYWb6WEfsNITHcHUCe
         n1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9SgyI4sGJbXscjvIGxLavpMHgkTTZKLHre1z7SLAwQc=;
        b=OEjwOKKJ14AeTICL9pYfwtFPKD3DhI3GBhsEPqzVGc6ArXfdhnq3++vmn4nc7fdMlu
         fr61dlaajDUyqm+TcHGG4wuhOns9+GHsZuw2COMnxxhD1cjCn5P61NLfTlQ5gUiOXhSF
         jpip/X425iqhwHev0B5VoWcAuAITZQynfhnCuwWjJlAyDvxnqixwSBiXcNLQR24nvxsg
         9N6EQqjWpC5c7eU/eP/F1tXBNKRzm37U5YVOuzn89CCv/VsUzg1tEfjS86ArvJXm1gpJ
         4WFDQRmmf1UDtJ/+1ee0glaNXLJOzpWMJg5rtUysz4ClchyjfaU5LBJEj1Hd7D365Na7
         s+4Q==
X-Gm-Message-State: AOAM531TfPmFiODAMYT+HFghSetTzfSVZeMoTTkJLWLia30I6SXL4atk
        /V+MUxb5SUuUimc6OOk+V++wZpm3Kxc=
X-Google-Smtp-Source: ABdhPJx2ksZ1DrK8yRJUSLMhmNh1owgjpJKcdCUC+pwxfseYvGn9RHmZDYIspR7gA1uCTd6whEmi5w==
X-Received: by 2002:a05:6402:4304:: with SMTP id m4mr47383308edc.396.1636331107026;
        Sun, 07 Nov 2021 16:25:07 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id bf8sm8537878edb.46.2021.11.07.16.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 16:25:06 -0800 (PST)
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
Subject: [RFC PATCH v2 3/5] leds: trigger: add offload-phy-activity trigger
Date:   Mon,  8 Nov 2021 01:24:58 +0100
Message-Id: <20211108002500.19115-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211108002500.19115-1-ansuelsmth@gmail.com>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
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

The trigger will check if the LED driver support the offload trigger and
will expose the offload triggers in sysfs.
It will finally enable hw mode for the LED without configuring any rule.
This mean that the LED will blink/follow whatever offload trigger is
active by default and the user needs to manually configure the desired
offload triggers using sysfs.
A flag is passed to configure_offload with the related rule from this
trigger to active or disable.
It's in the led driver interest the detection and knowing how to
elaborate the passed flags and should report -EOPNOTSUPP otherwise.

The different hw triggers are exposed in the led sysfs dir under the
offload-phy-activity subdir.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/Kconfig                  |  29 ++++
 drivers/leds/trigger/Makefile                 |   1 +
 .../trigger/ledtrig-offload-phy-activity.c    | 145 ++++++++++++++++++
 include/linux/leds.h                          |  24 +++
 4 files changed, 199 insertions(+)
 create mode 100644 drivers/leds/trigger/ledtrig-offload-phy-activity.c

diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
index 33aba8defeab..14023e160ba1 100644
--- a/drivers/leds/trigger/Kconfig
+++ b/drivers/leds/trigger/Kconfig
@@ -164,4 +164,33 @@ config LEDS_TRIGGER_TTY
 
 	  When build as a module this driver will be called ledtrig-tty.
 
+config LEDS_OFFLOAD_TRIGGER_PHY_ACTIVITY
+	tristate "LED Offload Trigger for PHY Activity"
+	depends on LEDS_OFFLOAD_TRIGGERS
+	help
+	  This allows LEDs to be configured to run by hardware and offloaded
+	  based on some rules. The LED will blink or be on based on the PHY
+	  Activity for example on packet receive or based on the link speed.
+
+	  The current supported offload triggers are:
+	  - blink_tx: Blink LED on tx packet receive
+	  - blink_rx: Blink LED on rx packet receive
+	  - blink_collision: Blink LED on collision detection
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
+	  - option_blink_auto: Set blink speed at 2hz for 10m link speed,
+	                       4hz for 100m and 8hz for 1000m
+
+	  These offload triggers are present in the LED sysfs dir under
+	  offload-phy-activity if supported by the LED driver.
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
index 000000000000..4fadd7f31d1a
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-offload-phy-activity.c
@@ -0,0 +1,145 @@
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
+	int i, trigger, ret;
+
+	/* This triggered is supported only by LEDs that can be offload driven */
+	if (!led_cdev->trigger_offload || !led_cdev->trigger_offload)
+		return -EOPNOTSUPP;
+
+	/* Scan the supported offload triggers and expose them in sysfs if supported */
+	for (trigger = 0, i = 0; trigger < PHY_ACTIVITY_MAX_TRIGGERS; trigger++) {
+		if (led_trigger_offload_is_supported(led_cdev, BLINK_TX))
+			phy_activity_attrs[i++] = &dev_attr_blink_tx.attr;
+
+		if (led_trigger_offload_is_supported(led_cdev, BLINK_RX))
+			phy_activity_attrs[i++] = &dev_attr_blink_rx.attr;
+
+		if (led_trigger_offload_is_supported(led_cdev, BLINK_COLLISION))
+			phy_activity_attrs[i++] = &dev_attr_blink_collision.attr;
+
+		if (led_trigger_offload_is_supported(led_cdev, KEEP_LINK_10M))
+			phy_activity_attrs[i++] = &dev_attr_keep_link_10m.attr;
+
+		if (led_trigger_offload_is_supported(led_cdev, KEEP_LINK_100M))
+			phy_activity_attrs[i++] = &dev_attr_keep_link_100m.attr;
+
+		if (led_trigger_offload_is_supported(led_cdev, KEEP_LINK_1000M))
+			phy_activity_attrs[i++] = &dev_attr_keep_link_1000m.attr;
+
+		if (led_trigger_offload_is_supported(led_cdev, KEEP_HALF_DUPLEX))
+			phy_activity_attrs[i++] = &dev_attr_keep_half_duplex.attr;
+
+		if (led_trigger_offload_is_supported(led_cdev, KEEP_FULL_DUPLEX))
+			phy_activity_attrs[i++] = &dev_attr_keep_full_duplex.attr;
+
+		if (led_trigger_offload_is_supported(led_cdev, OPTION_LINKUP_OVER))
+			phy_activity_attrs[i++] = &dev_attr_option_linkup_over.attr;
+
+		if (led_trigger_offload_is_supported(led_cdev, OPTION_POWER_ON_RESET))
+			phy_activity_attrs[i++] = &dev_attr_option_power_on_reset.attr;
+
+		if (led_trigger_offload_is_supported(led_cdev, OPTION_BLINK_2HZ))
+			phy_activity_attrs[i++] = &dev_attr_option_blink_2hz.attr;
+
+		if (led_trigger_offload_is_supported(led_cdev, OPTION_BLINK_4HZ))
+			phy_activity_attrs[i++] = &dev_attr_option_blink_4hz.attr;
+
+		if (led_trigger_offload_is_supported(led_cdev, OPTION_BLINK_8HZ))
+			phy_activity_attrs[i++] = &dev_attr_option_blink_8hz.attr;
+
+		if (led_trigger_offload_is_supported(led_cdev, OPTION_BLINK_AUTO))
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
index 2a1e60e4d73e..fea06ca65da8 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -546,6 +546,30 @@ static inline void ledtrig_flash_ctrl(bool on) {}
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

