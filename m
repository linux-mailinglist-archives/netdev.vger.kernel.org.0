Return-Path: <netdev+bounces-11811-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D61AC734804
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 21:24:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 122561C20961
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 19:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5113BA3F;
	Sun, 18 Jun 2023 19:24:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2B6BA33
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 19:24:08 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C7CFC;
	Sun, 18 Jun 2023 12:24:07 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-31109cd8d8cso2331275f8f.2;
        Sun, 18 Jun 2023 12:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687116246; x=1689708246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZEXma0Sl180nUlDy6+RTrJLABcn2sDvoD62d8qplRAU=;
        b=XZ5hLMCAYHBMPQznv/Xp3G1BsWCfm/1kAYr+CoOHq+aL8GxSNszlAFqoiYRvMwGdh7
         ghHX9KKRGiqPfW5TsyhD20wNdmbBdXeoha6TvD4GhGBYi8NjzY2BxmkUxlqfz/yazRET
         +S6Mu401gFqYe7DC1ZF+NKHDsAQjVHClGl7XZQYczV+MuO7L5dBwYa86X7TgFrCYW3Um
         xeVZabIRlZ6Zx28YC5pCttJXSjIjegLOhCS27NVU3KSNRsn4kuVhWlRxiAL4kr+m0WXh
         eNOOvq6ltDaQbOSFW2MqhQ5eo1TruyawPP6DowVgQnTBB4ixcCGEDiNlFyNAXua1NMgB
         qJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687116246; x=1689708246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZEXma0Sl180nUlDy6+RTrJLABcn2sDvoD62d8qplRAU=;
        b=bzp/DwxQtcIGRjjvF89f9+ausL15mGt0xfizJZeiLg+Hbg50aSgbuFAkPBvMlvcHB8
         9epcZSEwx4dWIpZXwRcJXnSS0bid52NdeY40t4XayMJQLWagkEZ97kIXL1Pvnrqek5Kh
         J3L6+wrU7geMP2i1tcxeP+PxVw4509+qjcsUpnhoyatD1m3fyWOl8ACuy3UZSYQ9aJvW
         dTZcKcEOY0n7xVxjNSElDN+Y6jjYsh7vxI4pwZ7POUdWGKuj68A93b7vuwN7i3JcaM67
         /b2Yzvph1QAwB/NVtUNGWiDsLLH8oMOxpKkOhBjaAndYKQTzRKcXWlyxyTDaRgWNsI7b
         2IuA==
X-Gm-Message-State: AC+VfDyTBnuJ0V5+P+L7+wcJrBYcW6hqrdqcI6pgXO70J/WaLm5nDBk8
	Qh9lDBdhoCO54OGZPv1ei5N++DIn6X0=
X-Google-Smtp-Source: ACHHUZ7tiN+lGuYHCcpXKC1UbVJFN640zFJjOk2lFlhHPtZidTsKqxE0aPxnK8Tni5eQI1Ty87nJbQ==
X-Received: by 2002:adf:f9c4:0:b0:30a:e70d:9e73 with SMTP id w4-20020adff9c4000000b0030ae70d9e73mr6262358wrr.33.1687116245399;
        Sun, 18 Jun 2023 12:24:05 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id h12-20020adffd4c000000b0031130b9b173sm4065871wrs.34.2023.06.18.12.24.04
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
Subject: [net-next PATCH v4 2/3] leds: trigger: netdev: add additional specific link duplex mode
Date: Sat, 17 Jun 2023 13:53:54 +0200
Message-Id: <20230617115355.22868-3-ansuelsmth@gmail.com>
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

Add additional modes for specific link duplex. Use ethtool APIs to get the
current link duplex and enable the LED accordingly. Under netdev event
handler the rtnl lock is already held and is not needed to be set to
access ethtool APIs.

This is especially useful for PHY and Switch that supports LEDs hw
control for specific link duplex.

Add additional modes:
- half_duplex: Turn on LED when link is half duplex
- full_duplex: Turn on LED when link is full duplex

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 27 +++++++++++++++++++++++++--
 include/linux/leds.h                  |  2 ++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 8e6132f069af..90b682d49998 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -55,6 +55,7 @@ struct led_netdev_data {
 
 	unsigned long mode;
 	int link_speed;
+	u8 duplex;
 
 	bool carrier_link_up;
 	bool hw_control;
@@ -98,6 +99,14 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 		    trigger_data->link_speed == SPEED_1000)
 			blink_on = true;
 
+		if (test_bit(TRIGGER_NETDEV_HALF_DUPLEX, &trigger_data->mode) &&
+		    trigger_data->duplex == DUPLEX_HALF)
+			blink_on = true;
+
+		if (test_bit(TRIGGER_NETDEV_FULL_DUPLEX, &trigger_data->mode) &&
+		    trigger_data->duplex == DUPLEX_FULL)
+			blink_on = true;
+
 		if (blink_on)
 			led_set_brightness(led_cdev,
 					   led_cdev->blink_brightness);
@@ -190,8 +199,10 @@ static void get_device_state(struct led_netdev_data *trigger_data)
 	if (!trigger_data->carrier_link_up)
 		return;
 
-	if (!__ethtool_get_link_ksettings(trigger_data->net_dev, &cmd))
+	if (!__ethtool_get_link_ksettings(trigger_data->net_dev, &cmd)) {
 		trigger_data->link_speed = cmd.base.speed;
+		trigger_data->duplex = cmd.base.duplex;
+	}
 }
 
 static ssize_t device_name_show(struct device *dev,
@@ -230,6 +241,7 @@ static int set_device_name(struct led_netdev_data *trigger_data,
 
 	trigger_data->carrier_link_up = false;
 	trigger_data->link_speed = SPEED_UNKNOWN;
+	trigger_data->duplex = DUPLEX_UNKNOWN;
 	if (trigger_data->net_dev != NULL) {
 		rtnl_lock();
 		get_device_state(trigger_data);
@@ -274,6 +286,8 @@ static ssize_t netdev_led_attr_show(struct device *dev, char *buf,
 	case TRIGGER_NETDEV_LINK_10:
 	case TRIGGER_NETDEV_LINK_100:
 	case TRIGGER_NETDEV_LINK_1000:
+	case TRIGGER_NETDEV_HALF_DUPLEX:
+	case TRIGGER_NETDEV_FULL_DUPLEX:
 	case TRIGGER_NETDEV_TX:
 	case TRIGGER_NETDEV_RX:
 		bit = attr;
@@ -302,6 +316,8 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 	case TRIGGER_NETDEV_LINK_10:
 	case TRIGGER_NETDEV_LINK_100:
 	case TRIGGER_NETDEV_LINK_1000:
+	case TRIGGER_NETDEV_HALF_DUPLEX:
+	case TRIGGER_NETDEV_FULL_DUPLEX:
 	case TRIGGER_NETDEV_TX:
 	case TRIGGER_NETDEV_RX:
 		bit = attr;
@@ -348,6 +364,8 @@ DEFINE_NETDEV_TRIGGER(link, TRIGGER_NETDEV_LINK);
 DEFINE_NETDEV_TRIGGER(link_10, TRIGGER_NETDEV_LINK_10);
 DEFINE_NETDEV_TRIGGER(link_100, TRIGGER_NETDEV_LINK_100);
 DEFINE_NETDEV_TRIGGER(link_1000, TRIGGER_NETDEV_LINK_1000);
+DEFINE_NETDEV_TRIGGER(half_duplex, TRIGGER_NETDEV_HALF_DUPLEX);
+DEFINE_NETDEV_TRIGGER(full_duplex, TRIGGER_NETDEV_FULL_DUPLEX);
 DEFINE_NETDEV_TRIGGER(tx, TRIGGER_NETDEV_TX);
 DEFINE_NETDEV_TRIGGER(rx, TRIGGER_NETDEV_RX);
 
@@ -394,6 +412,8 @@ static struct attribute *netdev_trig_attrs[] = {
 	&dev_attr_link_10.attr,
 	&dev_attr_link_100.attr,
 	&dev_attr_link_1000.attr,
+	&dev_attr_full_duplex.attr,
+	&dev_attr_half_duplex.attr,
 	&dev_attr_rx.attr,
 	&dev_attr_tx.attr,
 	&dev_attr_interval.attr,
@@ -425,6 +445,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 
 	trigger_data->carrier_link_up = false;
 	trigger_data->link_speed = SPEED_UNKNOWN;
+	trigger_data->duplex = DUPLEX_UNKNOWN;
 	switch (evt) {
 	case NETDEV_CHANGENAME:
 		get_device_state(trigger_data);
@@ -486,7 +507,9 @@ static void netdev_trig_work(struct work_struct *work)
 		invert = test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode) ||
 			 test_bit(TRIGGER_NETDEV_LINK_10, &trigger_data->mode) ||
 			 test_bit(TRIGGER_NETDEV_LINK_100, &trigger_data->mode) ||
-			 test_bit(TRIGGER_NETDEV_LINK_1000, &trigger_data->mode);
+			 test_bit(TRIGGER_NETDEV_LINK_1000, &trigger_data->mode) ||
+			 test_bit(TRIGGER_NETDEV_HALF_DUPLEX, &trigger_data->mode) ||
+			 test_bit(TRIGGER_NETDEV_FULL_DUPLEX, &trigger_data->mode);
 		interval = jiffies_to_msecs(
 				atomic_read(&trigger_data->interval));
 		/* base state is ON (link present) */
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 39f15b1e772c..7d428100b42b 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -585,6 +585,8 @@ enum led_trigger_netdev_modes {
 	TRIGGER_NETDEV_LINK_10,
 	TRIGGER_NETDEV_LINK_100,
 	TRIGGER_NETDEV_LINK_1000,
+	TRIGGER_NETDEV_HALF_DUPLEX,
+	TRIGGER_NETDEV_FULL_DUPLEX,
 	TRIGGER_NETDEV_TX,
 	TRIGGER_NETDEV_RX,
 
-- 
2.40.1


