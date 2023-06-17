Return-Path: <netdev+bounces-11810-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5210C734801
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 21:24:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 781131C208D4
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 19:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6B47A947;
	Sun, 18 Jun 2023 19:24:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99C2A941
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 19:24:07 +0000 (UTC)
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31998E44;
	Sun, 18 Jun 2023 12:24:06 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-311099fac92so3125689f8f.0;
        Sun, 18 Jun 2023 12:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687116244; x=1689708244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=guP6wSLsxzWpfvfaaFfXjzJkT5z7hOXmt03lBFrApjw=;
        b=Fq8GtGPZKF3ZYJfTaXrx+3L+WsIehDT+wcMtSQFAyh2JT7gXt0J/UOZg3EU/bVH5LM
         VA/hSNo53/OYkxv1QaDiHqUA8st6F3B68kMWPZaL00eguVoGzMtsp1nCW2ZLM6fUjBfh
         B7QN/5Mm3hD8cjzr3basqbNj+ejxplm5WxdKjB+ANqD4UEpMhpK2i8bNAUBTFj7XnTJn
         KwsL6ot9WYVsEFU/KuuJxH1G7zkZ/Af52RARhaEpQ1IlbJH8XCvR6h6kRuGvMGyogmPa
         fWoA7DbNwAAOv/rcZBF68XrKlAAZf5xkQywEWsZlhabQ0xP343N8rrygBA1K5MT9htA5
         HsnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687116244; x=1689708244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=guP6wSLsxzWpfvfaaFfXjzJkT5z7hOXmt03lBFrApjw=;
        b=Js1Thxq4X69TiJrUzJheeTIpBjmB6sIFIHHDTMmnCM5sBIDWRUHX6AkTTKilVpyOI0
         vmtodV7x/54A8OXf7+5AlYHXJPZn6N6PHFt7F++mFgq4MoIataCPjRMAw8/K8HAdNSq6
         lScgzntRUuvMabTrHD3vxI2lm8LsfR67yK47GHJYRz81OeHWZMPMTlO6C/eWb+Yd1ma0
         OceG/bXkbte30zTyUuxdUtqEmw3faulnNCvLoRayX+ka/fxohLtIQ8iWgL/7Wrnm6Q58
         I3WCHV/EYiyv640tqe4e37rtCQENvX2cLgK3ZwYGynZCQ3KrEbjJX/MbkjGUiaUZZDwS
         gYFQ==
X-Gm-Message-State: AC+VfDyZDvHGG+CDu4k1AJCC5PMPzbbxsFRzg+4gKe3xUN95Volt9ocr
	xgydv1ZciRCcLOUXzUfQBJY=
X-Google-Smtp-Source: ACHHUZ52SDcoKvUemgSuCAaLRksZnpdFqYnpirKFe+zt2i0e2qJDm1cWyeayArN+KU/nTLUU/TOsNg==
X-Received: by 2002:adf:f203:0:b0:2f9:4fe9:74bb with SMTP id p3-20020adff203000000b002f94fe974bbmr6787496wro.40.1687116244321;
        Sun, 18 Jun 2023 12:24:04 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id h12-20020adffd4c000000b0031130b9b173sm4065871wrs.34.2023.06.18.12.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jun 2023 12:24:04 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Yang Li <yang.lee@linux.alibaba.com>,
	linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [net-next PATCH v4 1/3] leds: trigger: netdev: add additional specific link speed mode
Date: Sat, 17 Jun 2023 13:53:53 +0200
Message-Id: <20230617115355.22868-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230617115355.22868-1-ansuelsmth@gmail.com>
References: <20230617115355.22868-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add additional modes for specific link speed. Use ethtool APIs to get the
current link speed and enable the LED accordingly. Under netdev event
handler the rtnl lock is already held and is not needed to be set to
access ethtool APIs.

This is especially useful for PHY and Switch that supports LEDs hw
control for specific link speed. (example scenario a PHY that have 2 LED
connected one green and one orange where the green is turned on with
1000mbps speed and orange is turned on with 10mpbs speed)

On mode set from sysfs we check if we have enabled split link speed mode
and reject enabling generic link mode to prevent wrong and redundant
configuration.

Rework logic on the set baseline state to support these new modes to
select if we need to turn on or off the LED.

Add additional modes:
- link_10: Turn on LED when link speed is 10mbps
- link_100: Turn on LED when link speed is 100mbps
- link_1000: Turn on LED when link speed is 1000mbps

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/leds/trigger/ledtrig-netdev.c | 80 +++++++++++++++++++++++----
 include/linux/leds.h                  |  3 +
 2 files changed, 73 insertions(+), 10 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index c9b040bacbb0..8e6132f069af 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -13,6 +13,7 @@
 #include <linux/atomic.h>
 #include <linux/ctype.h>
 #include <linux/device.h>
+#include <linux/ethtool.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
@@ -21,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/mutex.h>
+#include <linux/rtnetlink.h>
 #include <linux/timer.h>
 #include "../leds.h"
 
@@ -52,6 +54,8 @@ struct led_netdev_data {
 	unsigned int last_activity;
 
 	unsigned long mode;
+	int link_speed;
+
 	bool carrier_link_up;
 	bool hw_control;
 };
@@ -77,7 +81,24 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	if (!trigger_data->carrier_link_up) {
 		led_set_brightness(led_cdev, LED_OFF);
 	} else {
+		bool blink_on = false;
+
 		if (test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode))
+			blink_on = true;
+
+		if (test_bit(TRIGGER_NETDEV_LINK_10, &trigger_data->mode) &&
+		    trigger_data->link_speed == SPEED_10)
+			blink_on = true;
+
+		if (test_bit(TRIGGER_NETDEV_LINK_100, &trigger_data->mode) &&
+		    trigger_data->link_speed == SPEED_100)
+			blink_on = true;
+
+		if (test_bit(TRIGGER_NETDEV_LINK_1000, &trigger_data->mode) &&
+		    trigger_data->link_speed == SPEED_1000)
+			blink_on = true;
+
+		if (blink_on)
 			led_set_brightness(led_cdev,
 					   led_cdev->blink_brightness);
 		else
@@ -161,6 +182,18 @@ static bool can_hw_control(struct led_netdev_data *trigger_data)
 	return true;
 }
 
+static void get_device_state(struct led_netdev_data *trigger_data)
+{
+	struct ethtool_link_ksettings cmd;
+
+	trigger_data->carrier_link_up = netif_carrier_ok(trigger_data->net_dev);
+	if (!trigger_data->carrier_link_up)
+		return;
+
+	if (!__ethtool_get_link_ksettings(trigger_data->net_dev, &cmd))
+		trigger_data->link_speed = cmd.base.speed;
+}
+
 static ssize_t device_name_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -196,8 +229,12 @@ static int set_device_name(struct led_netdev_data *trigger_data,
 		    dev_get_by_name(&init_net, trigger_data->device_name);
 
 	trigger_data->carrier_link_up = false;
-	if (trigger_data->net_dev != NULL)
-		trigger_data->carrier_link_up = netif_carrier_ok(trigger_data->net_dev);
+	trigger_data->link_speed = SPEED_UNKNOWN;
+	if (trigger_data->net_dev != NULL) {
+		rtnl_lock();
+		get_device_state(trigger_data);
+		rtnl_unlock();
+	}
 
 	trigger_data->last_activity = 0;
 
@@ -234,6 +271,9 @@ static ssize_t netdev_led_attr_show(struct device *dev, char *buf,
 
 	switch (attr) {
 	case TRIGGER_NETDEV_LINK:
+	case TRIGGER_NETDEV_LINK_10:
+	case TRIGGER_NETDEV_LINK_100:
+	case TRIGGER_NETDEV_LINK_1000:
 	case TRIGGER_NETDEV_TX:
 	case TRIGGER_NETDEV_RX:
 		bit = attr;
@@ -249,7 +289,7 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 				     size_t size, enum led_trigger_netdev_modes attr)
 {
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
-	unsigned long state;
+	unsigned long state, mode = trigger_data->mode;
 	int ret;
 	int bit;
 
@@ -259,6 +299,9 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 
 	switch (attr) {
 	case TRIGGER_NETDEV_LINK:
+	case TRIGGER_NETDEV_LINK_10:
+	case TRIGGER_NETDEV_LINK_100:
+	case TRIGGER_NETDEV_LINK_1000:
 	case TRIGGER_NETDEV_TX:
 	case TRIGGER_NETDEV_RX:
 		bit = attr;
@@ -267,13 +310,20 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 		return -EINVAL;
 	}
 
-	cancel_delayed_work_sync(&trigger_data->work);
-
 	if (state)
-		set_bit(bit, &trigger_data->mode);
+		set_bit(bit, &mode);
 	else
-		clear_bit(bit, &trigger_data->mode);
+		clear_bit(bit, &mode);
+
+	if (test_bit(TRIGGER_NETDEV_LINK, &mode) &&
+	    (test_bit(TRIGGER_NETDEV_LINK_10, &mode) ||
+	     test_bit(TRIGGER_NETDEV_LINK_100, &mode) ||
+	     test_bit(TRIGGER_NETDEV_LINK_1000, &mode)))
+		return -EINVAL;
+
+	cancel_delayed_work_sync(&trigger_data->work);
 
+	trigger_data->mode = mode;
 	trigger_data->hw_control = can_hw_control(trigger_data);
 
 	set_baseline_state(trigger_data);
@@ -295,6 +345,9 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 	static DEVICE_ATTR_RW(trigger_name)
 
 DEFINE_NETDEV_TRIGGER(link, TRIGGER_NETDEV_LINK);
+DEFINE_NETDEV_TRIGGER(link_10, TRIGGER_NETDEV_LINK_10);
+DEFINE_NETDEV_TRIGGER(link_100, TRIGGER_NETDEV_LINK_100);
+DEFINE_NETDEV_TRIGGER(link_1000, TRIGGER_NETDEV_LINK_1000);
 DEFINE_NETDEV_TRIGGER(tx, TRIGGER_NETDEV_TX);
 DEFINE_NETDEV_TRIGGER(rx, TRIGGER_NETDEV_RX);
 
@@ -338,6 +391,9 @@ static DEVICE_ATTR_RW(interval);
 static struct attribute *netdev_trig_attrs[] = {
 	&dev_attr_device_name.attr,
 	&dev_attr_link.attr,
+	&dev_attr_link_10.attr,
+	&dev_attr_link_100.attr,
+	&dev_attr_link_1000.attr,
 	&dev_attr_rx.attr,
 	&dev_attr_tx.attr,
 	&dev_attr_interval.attr,
@@ -368,9 +424,10 @@ static int netdev_trig_notify(struct notifier_block *nb,
 	mutex_lock(&trigger_data->lock);
 
 	trigger_data->carrier_link_up = false;
+	trigger_data->link_speed = SPEED_UNKNOWN;
 	switch (evt) {
 	case NETDEV_CHANGENAME:
-		trigger_data->carrier_link_up = netif_carrier_ok(dev);
+		get_device_state(trigger_data);
 		fallthrough;
 	case NETDEV_REGISTER:
 		dev_put(trigger_data->net_dev);
@@ -383,7 +440,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 		break;
 	case NETDEV_UP:
 	case NETDEV_CHANGE:
-		trigger_data->carrier_link_up = netif_carrier_ok(dev);
+		get_device_state(trigger_data);
 		break;
 	}
 
@@ -426,7 +483,10 @@ static void netdev_trig_work(struct work_struct *work)
 	if (trigger_data->last_activity != new_activity) {
 		led_stop_software_blink(trigger_data->led_cdev);
 
-		invert = test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode);
+		invert = test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode) ||
+			 test_bit(TRIGGER_NETDEV_LINK_10, &trigger_data->mode) ||
+			 test_bit(TRIGGER_NETDEV_LINK_100, &trigger_data->mode) ||
+			 test_bit(TRIGGER_NETDEV_LINK_1000, &trigger_data->mode);
 		interval = jiffies_to_msecs(
 				atomic_read(&trigger_data->interval));
 		/* base state is ON (link present) */
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 4b3d8bda1fff..39f15b1e772c 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -582,6 +582,9 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 /* Trigger specific enum */
 enum led_trigger_netdev_modes {
 	TRIGGER_NETDEV_LINK = 0,
+	TRIGGER_NETDEV_LINK_10,
+	TRIGGER_NETDEV_LINK_100,
+	TRIGGER_NETDEV_LINK_1000,
 	TRIGGER_NETDEV_TX,
 	TRIGGER_NETDEV_RX,
 
-- 
2.40.1


