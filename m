Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FFB44EA53
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbhKLPjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235312AbhKLPi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:38:59 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961EAC061767;
        Fri, 12 Nov 2021 07:36:08 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id p3-20020a05600c1d8300b003334fab53afso7273701wms.3;
        Fri, 12 Nov 2021 07:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9dARbb7WkhVmXUcr3NCB/e51nXglhcyLlTHLejpbidM=;
        b=XWmrH3IPUYnS+mLIjgNMCfLcimT41UaWMHFcYQCvd8vSFbzflyWY4S2KrsAtcFarSg
         puPnTXN2PU9+qGn96BDk5yFqFaq7HYixhGe+/n+Q0KlYBDaOIUbhTfZ9T+Mf00O+zkS2
         Lag2HnoAj4L2mrMYVHLay0j7zo/Seur7uwHfY8TpDaUrEZvnXSwMIvu637WXPxXf/T4k
         dm2CHyjaUcAHlI/0OKWgQkzOdMB3O4It3H1DRiVqpXfonT9wmKp9enur0uxqwcX1k9t9
         +Z3VWxi2oSsTzyJVbBnPaLKsroWsem0KGyO5m2WNOt9h/6iYZt4BAxzDln6/45qC+4QQ
         R2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9dARbb7WkhVmXUcr3NCB/e51nXglhcyLlTHLejpbidM=;
        b=szZ/Wfrg7fz1ejeL+0QyWRkPldmFG0blVXeXa9s4LDPHYYoghwe2XVIFyHfhUrX4/R
         gWIFgb1T0nkgp4W+eKTtBrHWyJmaH/vi66FQ8jk9gD5Quv3rIz/UrkDb7w5zi5eb8kPK
         57MN93b9P38KiGt6Fqmz/9RV6CZHlh1iQ3OA/TrnrYFpIPdcqb09E8xj1G6jy1C5mx0o
         TGLIGzd6pVSwVrloWuaSintFzMPKO5Dyvj2EvGmJ/XcIK728KZcGQsSbo05HlxX+BERN
         RT2xn9LpFiZdr7KjEF+TaGzCY4RlQ7514GZLZlXH1itbaXxcaCMJHhlp1GW8n35kS/ca
         1sJQ==
X-Gm-Message-State: AOAM530Ld12ibNNAwJhg7ZWDXAoHRkNc7CdoODbQCck5vngap+SMeOgd
        7gpJI4nCItQTcjiG6bHvBCQ=
X-Google-Smtp-Source: ABdhPJzaY8AWB+11oUlqioLLTbrfwdAdLNSKtl/Oeo7zYvciPcrK5Qe2Cn6Gio4NMhbF3iS4fOWtnw==
X-Received: by 2002:a05:600c:1c13:: with SMTP id j19mr35213711wms.175.1636731366981;
        Fri, 12 Nov 2021 07:36:06 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id az4sm4217543wmb.20.2021.11.12.07.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 07:36:06 -0800 (PST)
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
Subject: [PATCH v5 4/8] leds: trigger: netdev: rename and expose NETDEV trigger enum and struct
Date:   Fri, 12 Nov 2021 16:35:53 +0100
Message-Id: <20211112153557.26941-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211112153557.26941-1-ansuelsmth@gmail.com>
References: <20211112153557.26941-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A LED driver, to support hardware control, requires to support a specific
trigger and requires to elaborate his trigger_data struct.
Move netdev trigger data struct to leds.h to make it accessible by any
LED driver that wants to add support for hardware control for the
specific netdev trigger.
Also rename NETDEV trigger enum modes to a more symbolic and descriptive
name.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 48 ++++++++-------------------
 include/linux/leds.h                  | 29 ++++++++++++++++
 2 files changed, 43 insertions(+), 34 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 66a81cc9b64d..01e4544fa7b0 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -36,26 +36,6 @@
  *
  */
 
-struct led_netdev_data {
-	spinlock_t lock;
-
-	struct delayed_work work;
-	struct notifier_block notifier;
-
-	struct led_classdev *led_cdev;
-	struct net_device *net_dev;
-
-	char device_name[IFNAMSIZ];
-	atomic_t interval;
-	unsigned int last_activity;
-
-	unsigned long mode;
-	bool carrier_link_up;
-#define NETDEV_LED_LINK	0
-#define NETDEV_LED_TX	1
-#define NETDEV_LED_RX	2
-};
-
 enum netdev_led_attr {
 	NETDEV_ATTR_LINK,
 	NETDEV_ATTR_TX,
@@ -76,7 +56,7 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	if (!trigger_data->carrier_link_up) {
 		led_set_brightness(led_cdev, LED_OFF);
 	} else {
-		if (test_bit(NETDEV_LED_LINK, &trigger_data->mode))
+		if (test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode))
 			led_set_brightness(led_cdev,
 					   led_cdev->blink_brightness);
 		else
@@ -85,8 +65,8 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 		/* If we are looking for RX/TX start periodically
 		 * checking stats
 		 */
-		if (test_bit(NETDEV_LED_TX, &trigger_data->mode) ||
-		    test_bit(NETDEV_LED_RX, &trigger_data->mode))
+		if (test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode) ||
+		    test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode))
 			schedule_delayed_work(&trigger_data->work, 0);
 	}
 }
@@ -153,13 +133,13 @@ static ssize_t netdev_led_attr_show(struct device *dev, char *buf,
 
 	switch (attr) {
 	case NETDEV_ATTR_LINK:
-		bit = NETDEV_LED_LINK;
+		bit = TRIGGER_NETDEV_LINK;
 		break;
 	case NETDEV_ATTR_TX:
-		bit = NETDEV_LED_TX;
+		bit = TRIGGER_NETDEV_TX;
 		break;
 	case NETDEV_ATTR_RX:
-		bit = NETDEV_LED_RX;
+		bit = TRIGGER_NETDEV_RX;
 		break;
 	default:
 		return -EINVAL;
@@ -182,13 +162,13 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 
 	switch (attr) {
 	case NETDEV_ATTR_LINK:
-		bit = NETDEV_LED_LINK;
+		bit = TRIGGER_NETDEV_LINK;
 		break;
 	case NETDEV_ATTR_TX:
-		bit = NETDEV_LED_TX;
+		bit = TRIGGER_NETDEV_TX;
 		break;
 	case NETDEV_ATTR_RX:
-		bit = NETDEV_LED_RX;
+		bit = TRIGGER_NETDEV_RX;
 		break;
 	default:
 		return -EINVAL;
@@ -358,21 +338,21 @@ static void netdev_trig_work(struct work_struct *work)
 	}
 
 	/* If we are not looking for RX/TX then return  */
-	if (!test_bit(NETDEV_LED_TX, &trigger_data->mode) &&
-	    !test_bit(NETDEV_LED_RX, &trigger_data->mode))
+	if (!test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode) &&
+	    !test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode))
 		return;
 
 	dev_stats = dev_get_stats(trigger_data->net_dev, &temp);
 	new_activity =
-	    (test_bit(NETDEV_LED_TX, &trigger_data->mode) ?
+	    (test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode) ?
 		dev_stats->tx_packets : 0) +
-	    (test_bit(NETDEV_LED_RX, &trigger_data->mode) ?
+	    (test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode) ?
 		dev_stats->rx_packets : 0);
 
 	if (trigger_data->last_activity != new_activity) {
 		led_stop_software_blink(trigger_data->led_cdev);
 
-		invert = test_bit(NETDEV_LED_LINK, &trigger_data->mode);
+		invert = test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode);
 		interval = jiffies_to_msecs(
 				atomic_read(&trigger_data->interval));
 		/* base state is ON (link present) */
diff --git a/include/linux/leds.h b/include/linux/leds.h
index fa929215cdcc..89ed009eecad 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -503,6 +503,35 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 
 #endif /* CONFIG_LEDS_TRIGGERS */
 
+/* Trigger specific trigger_data used by netdev trigger */
+#ifdef CONFIG_LEDS_TRIGGER_NETDEV
+#include <linux/netdevice.h>
+
+struct led_netdev_data {
+	spinlock_t lock;
+
+	struct delayed_work work;
+	struct notifier_block notifier;
+
+	struct led_classdev *led_cdev;
+	struct net_device *net_dev;
+
+	char device_name[IFNAMSIZ];
+	atomic_t interval;
+	unsigned int last_activity;
+
+	unsigned long mode;
+	bool carrier_link_up;
+};
+
+/* Trigger specific bitmap blink mode used by netdev trigger */
+enum led_trigger_netdev_modes {
+	TRIGGER_NETDEV_LINK,
+	TRIGGER_NETDEV_TX,
+	TRIGGER_NETDEV_RX,
+};
+#endif
+
 /* Trigger specific functions */
 #ifdef CONFIG_LEDS_TRIGGER_DISK
 void ledtrig_disk_activity(bool write);
-- 
2.32.0

