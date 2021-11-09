Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08AD744A4B8
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 03:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241330AbhKIC3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 21:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241489AbhKIC3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 21:29:08 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2EFC06120C;
        Mon,  8 Nov 2021 18:26:22 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id ee33so70829217edb.8;
        Mon, 08 Nov 2021 18:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=iNsSN93Y1z+/kiBS70QDl+he4k5THhcrqZurM94zPkY=;
        b=QHczhkUmI5+YndEovbbvxtjhC8BbSYM1fAOD6UeDoPl3meOoQXY1Aa8FtwXd/qIRHv
         yeGrF1OXiqNGbnLm4rZSpSYvqwtjF7pA8H3755JCB1em2zFIeHH/Ft7Kj7becNIU621h
         ooI8GX/o5TkXYpkEe1qKR7k0H+sSN+iM1jTNHqLbROEWk1FLVrkB6HTalpyAq32NUqkp
         Q8ALRdDFpyy1Pcpp7aft+hCqHXlDfcsI3hDqVU8h3AdizSVOENUk7iBFMbsOzKY3MYwT
         FFpELx15A7XrGh6yCpQhQqMTnF4jYMi7huHo7mliN3kDXbwzqrlQAdWBE+JnN5tppBgy
         Bj1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iNsSN93Y1z+/kiBS70QDl+he4k5THhcrqZurM94zPkY=;
        b=Z+iP7ipnXzyfbjbDEbvR3bQLsF4VlGDb0Q57YimxQJ8S/JswSretiKxhmKBxzc6TVp
         9VeoTQ43ckzrZmI4FiRxwwRkXxYBM0mo/tqGiyk8qe3Ep+ooOWCRXwgZR/9VtWv/kVMb
         cr2x4aKOOUXGeFqY4vy6HjiJLYX1Kmj4jvJyN2yR0BbNZX4c/ToHocvfCuYNcZuFKPKo
         CwG+B/k8Hbi0JqF9AYDORSJVZBTEJLOw+saN8/OqK9RH2Vh4lzaDaD+5KMSVynurXO6f
         CAAkVgJy7wEFXz04FS2Mk44SgT3Xf1P7lq6ZXVWATLgt/kvXl6fzbRJYKWKL9GmNHFTS
         ouig==
X-Gm-Message-State: AOAM5332SfHmrm2prWn/IKcaw+pAw2NTygbngHNLvpHLwoz8kix0wd/H
        o9UEqUNsPvQZ+ZKDQSzO+5Y=
X-Google-Smtp-Source: ABdhPJxgGV+A6l/2B+jHy8ry7fjToT+vU7VPa+cxBEFbofCfPxg36H1SiGvParfXckUzGUi3WakCmQ==
X-Received: by 2002:aa7:cac2:: with SMTP id l2mr5286981edt.168.1636424781059;
        Mon, 08 Nov 2021 18:26:21 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m5sm8760900ejc.62.2021.11.08.18.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 18:26:20 -0800 (PST)
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
Subject: [RFC PATCH v3 6/8] leds: trigger: add hardware-phy-activity trigger
Date:   Tue,  9 Nov 2021 03:26:06 +0100
Message-Id: <20211109022608.11109-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211109022608.11109-1-ansuelsmth@gmail.com>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
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
  - keep_link_10m: Keep LED on with 10m link speed
  - keep_link_100m: Keep LED on with 100m link speed
  - kepp_link_1000m: Keep LED on with 1000m link speed
  - keep_half_duplex: Keep LED on with half duplex link
  - keep_full_duplex: Keep LED on with full duplex link
  - option_linkup_over: Ignore blink tx/rx with link keep not active
  - option_power_on_reset: Keep LED on with switch reset
  - option_blink_2hz: Set blink speed at 2hz for every blink event
  - option_blink_4hz: Set blink speed at 4hz for every blink event
  - option_blink_8hz: Set blink speed at 8hz for every blink event
  - option_blink_auto: Set blink speed at 2hz for 10m link speed,
      4hz for 100m and 8hz for 1000m

The trigger will check if the LED driver support the various blink modes
and will expose the blink modes in sysfs.
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
 drivers/leds/trigger/Kconfig                  |  28 +++
 drivers/leds/trigger/Makefile                 |   1 +
 .../trigger/ledtrig-hardware-phy-activity.c   | 171 ++++++++++++++++++
 include/linux/leds.h                          |  22 +++
 4 files changed, 222 insertions(+)
 create mode 100644 drivers/leds/trigger/ledtrig-hardware-phy-activity.c

diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
index dc6816d36d06..b947b238be3f 100644
--- a/drivers/leds/trigger/Kconfig
+++ b/drivers/leds/trigger/Kconfig
@@ -154,4 +154,32 @@ config LEDS_TRIGGER_TTY
 
 	  When build as a module this driver will be called ledtrig-tty.
 
+config LEDS_TRIGGER_HARDWARE_PHY_ACTIVITY
+	tristate "LED Trigger for PHY Activity for Hardware Controlled LED"
+	depends on LEDS_HARDWARE_CONTROL
+	help
+	  This allows LEDs to be configured to run by hardware and offloaded
+	  based on some rules. The LED will blink or be on based on the PHY
+	  Activity for example on packet receive or based on the link speed.
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
+	  This trigger can be used only by LEDs that supports Hardware mode
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
index 000000000000..7fd0557fe878
--- /dev/null
+++ b/drivers/leds/trigger/ledtrig-hardware-phy-activity.c
@@ -0,0 +1,171 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/leds.h>
+#include <linux/slab.h>
+
+#define PHY_ACTIVITY_MAX_TRIGGERS 12
+
+#define DEFINE_OFFLOAD_TRIGGER(trigger_name, trigger) \
+	static ssize_t trigger_name##_show(struct device *dev, \
+				struct device_attribute *attr, char *buf) \
+	{ \
+		struct led_classdev *led_cdev = led_trigger_get_led(dev); \
+		int val; \
+		val = led_cdev->hw_control_configure(led_cdev, trigger, BLINK_MODE_READ); \
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
+		cmd = !!state ? BLINK_MODE_ENABLE : BLINK_MODE_DISABLE; \
+		/* Update the configuration with every change */ \
+		led_cdev->hw_control_configure(led_cdev, trigger, cmd); \
+		return size; \
+	} \
+	DEVICE_ATTR_RW(trigger_name)
+
+/* Expose sysfs for every blink to be configurable from userspace */
+DEFINE_OFFLOAD_TRIGGER(blink_tx, BLINK_TX);
+DEFINE_OFFLOAD_TRIGGER(blink_rx, BLINK_RX);
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
+
+/* The attrs will be placed dynamically based on the supported triggers */
+static struct attribute *phy_activity_attrs[PHY_ACTIVITY_MAX_TRIGGERS + 1];
+
+static int offload_phy_activity_activate(struct led_classdev *led_cdev)
+{
+	u32 checked_list = 0;
+	int i, trigger, ret;
+
+	/* Scan the supported offload triggers and expose them in sysfs if supported */
+	for (trigger = 0, i = 0; trigger < PHY_ACTIVITY_MAX_TRIGGERS; trigger++) {
+		if (!(checked_list & BLINK_TX) &&
+		    led_trigger_blink_mode_is_supported(led_cdev, BLINK_TX)) {
+			phy_activity_attrs[i++] = &dev_attr_blink_tx.attr;
+			checked_list |= BLINK_TX;
+		}
+
+		if (!(checked_list & BLINK_RX) &&
+		    led_trigger_blink_mode_is_supported(led_cdev, BLINK_RX)) {
+			phy_activity_attrs[i++] = &dev_attr_blink_rx.attr;
+			checked_list |= BLINK_RX;
+		}
+
+		if (!(checked_list & KEEP_LINK_10M) &&
+		    led_trigger_blink_mode_is_supported(led_cdev, KEEP_LINK_10M)) {
+			phy_activity_attrs[i++] = &dev_attr_keep_link_10m.attr;
+			checked_list |= KEEP_LINK_10M;
+		}
+
+		if (!(checked_list & KEEP_LINK_100M) &&
+		    led_trigger_blink_mode_is_supported(led_cdev, KEEP_LINK_100M)) {
+			phy_activity_attrs[i++] = &dev_attr_keep_link_100m.attr;
+			checked_list |= KEEP_LINK_100M;
+		}
+
+		if (!(checked_list & KEEP_LINK_1000M) &&
+		    led_trigger_blink_mode_is_supported(led_cdev, KEEP_LINK_1000M)) {
+			phy_activity_attrs[i++] = &dev_attr_keep_link_1000m.attr;
+			checked_list |= KEEP_LINK_1000M;
+		}
+
+		if (!(checked_list & KEEP_HALF_DUPLEX) &&
+		    led_trigger_blink_mode_is_supported(led_cdev, KEEP_HALF_DUPLEX)) {
+			phy_activity_attrs[i++] = &dev_attr_keep_half_duplex.attr;
+			checked_list |= KEEP_HALF_DUPLEX;
+		}
+
+		if (!(checked_list & KEEP_FULL_DUPLEX) &&
+		    led_trigger_blink_mode_is_supported(led_cdev, KEEP_FULL_DUPLEX)) {
+			phy_activity_attrs[i++] = &dev_attr_keep_full_duplex.attr;
+			checked_list |= KEEP_FULL_DUPLEX;
+		}
+
+		if (!(checked_list & OPTION_LINKUP_OVER) &&
+		    led_trigger_blink_mode_is_supported(led_cdev, OPTION_LINKUP_OVER)) {
+			phy_activity_attrs[i++] = &dev_attr_option_linkup_over.attr;
+			checked_list |= OPTION_LINKUP_OVER;
+		}
+
+		if (!(checked_list & OPTION_POWER_ON_RESET) &&
+		    led_trigger_blink_mode_is_supported(led_cdev, OPTION_POWER_ON_RESET)) {
+			phy_activity_attrs[i++] = &dev_attr_option_power_on_reset.attr;
+			checked_list |= OPTION_POWER_ON_RESET;
+		}
+
+		if (!(checked_list & OPTION_BLINK_2HZ) &&
+		    led_trigger_blink_mode_is_supported(led_cdev, OPTION_BLINK_2HZ)) {
+			phy_activity_attrs[i++] = &dev_attr_option_blink_2hz.attr;
+			checked_list |= OPTION_BLINK_2HZ;
+		}
+
+		if (!(checked_list & OPTION_BLINK_4HZ) &&
+		    led_trigger_blink_mode_is_supported(led_cdev, OPTION_BLINK_4HZ)) {
+			phy_activity_attrs[i++] = &dev_attr_option_blink_4hz.attr;
+			checked_list |= OPTION_BLINK_4HZ;
+		}
+
+		if (!(checked_list & OPTION_BLINK_8HZ) &&
+		    led_trigger_blink_mode_is_supported(led_cdev, OPTION_BLINK_8HZ)) {
+			phy_activity_attrs[i++] = &dev_attr_option_blink_8hz.attr;
+			checked_list |= OPTION_BLINK_8HZ;
+		}
+	}
+
+	/* Enable hardware mode. No custom configuration is applied,
+	 * the LED driver will use whatever default configuration is
+	 * currently configured.
+	 */
+	ret = led_cdev->hw_control_start(led_cdev);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void offload_phy_activity_deactivate(struct led_classdev *led_cdev)
+{
+	led_cdev->hw_control_stop(led_cdev);
+}
+
+static const struct attribute_group phy_activity_group = {
+	.name = "hardware-phy-activity",
+	.attrs = phy_activity_attrs,
+};
+
+static const struct attribute_group *phy_activity_groups[] = {
+	&phy_activity_group,
+	NULL,
+};
+
+static struct led_trigger offload_phy_activity_trigger = {
+	.supported_blink_modes = HARDWARE_ONLY,
+	.name       = "hardware-phy-activity",
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
index 087debe6716d..3d2e06db6839 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -555,6 +555,28 @@ enum led_trigger_netdev_modes {
 	TRIGGER_NETDEV_RX,
 };
 
+#ifdef CONFIG_LEDS_TRIGGER_HARDWARE_PHY_ACTIVITY
+/* 3 main category for offload trigger:
+ * - blink: the led will blink on trigger
+ * - keep: the led will be kept on with condition
+ * - option: a configuration value internal to the led on how offload works
+ */
+enum hardware_phy_activity {
+	BLINK_TX, /* Blink on TX traffic */
+	BLINK_RX, /* Blink on RX traffic */
+	KEEP_LINK_10M, /* LED on with 10M link */
+	KEEP_LINK_100M, /* LED on with 100M link */
+	KEEP_LINK_1000M, /* LED on with 1000M link */
+	KEEP_HALF_DUPLEX, /* LED on with Half-Duplex link */
+	KEEP_FULL_DUPLEX, /* LED on with Full-Duplex link */
+	OPTION_LINKUP_OVER, /* LED will be on with KEEP blink mode and blink on BLINK traffic */
+	OPTION_POWER_ON_RESET, /* LED will be on Switch reset */
+	OPTION_BLINK_2HZ, /* LED will blink with any offload_trigger at 2Hz */
+	OPTION_BLINK_4HZ, /* LED will blink with any offload_trigger at 4Hz */
+	OPTION_BLINK_8HZ, /* LED will blink with any offload_trigger at 8Hz */
+};
+#endif
+
 /* Trigger specific functions */
 #ifdef CONFIG_LEDS_TRIGGER_DISK
 void ledtrig_disk_activity(bool write);
-- 
2.32.0

