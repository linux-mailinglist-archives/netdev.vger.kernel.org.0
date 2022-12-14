Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF41064D426
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiLNX7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiLNX6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:58:46 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079385D69B;
        Wed, 14 Dec 2022 15:55:43 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id h11so1415834wrw.13;
        Wed, 14 Dec 2022 15:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GIse2mS6EUrosfauTgonOKCy80Gj0M+YuBtbKf2QcRU=;
        b=opBxg9Aw+zpzwjImlK0YP8I0L/gsointpa3zlGLwVw0yi63IsTRCjZR+Dov9f18XO5
         3QQpM2xhUoESahtUFdJZWA8DQdp6TDExOs22zdVcOgWCmkTcQvTIzuEi2v52f7xV0Fvu
         4jNoHZAozweRJY+tJ7UsYP/nSoEY/6gWY17Q4ZASLcUkBKG+gdhNhFNhSrkVsVGzFXsO
         3enqERpLTgSUHxE0HhcZ/hE7dWdMGKom+tfteA6nvwTtP9Cytdrr2ZL/Lc+92CiLctai
         lIL/+dwZ0FZFehzBRfH1G/I5Lhx2lxKWAvj5UzLpFSyDTn1k+Yop3j+f/vxn7tNv7ElX
         TU6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GIse2mS6EUrosfauTgonOKCy80Gj0M+YuBtbKf2QcRU=;
        b=iOFcIZicy9ssLvHBrFsYToAxMEBjDZcLxcN+w6gka4YUvF0Td8AfTSpyU88yX9o+cU
         AMXsrLax8B0f50KxhAswo49qbsKvuEO8qC9CyBZWwUCPX7LOHvu3IE6VRPtf57VYcCPY
         SEAzCVD49xjYK9u4x2SdYAYLBPx5eHWfBFQ0YSurGzUv9IFNci1AqpmAUPb8Y/v5F2gE
         vPkebuCareU4QWkXF9Bth/j/ET7TN9KqOkybzuHIeLoZRA2W57APcghFgkIcqk9ps8hp
         /UmkqLahWJ50Z76MHVyVUhjriGbmqHbKrcWH5p5LdMLpyxren5TCSqvk9EXjpyWMEAwu
         VgPA==
X-Gm-Message-State: AFqh2ko5MfuOhPzzBbVrVQ2gx6btpa7on+qbb1JyjdX1xvGOFbZGKmFp
        XiI0mLWMMDzEhZ+bFf9PZlo=
X-Google-Smtp-Source: AMrXdXs7kkdKEgQh9iyjXfbOEio2vB9D9Eli1VL8wBpvPO9jgGdq5kbhmb2RMtEgO7w0wNQRTQKkwQ==
X-Received: by 2002:adf:e410:0:b0:254:9b64:8883 with SMTP id g16-20020adfe410000000b002549b648883mr4902381wrm.21.1671062113315;
        Wed, 14 Dec 2022 15:55:13 -0800 (PST)
Received: from localhost.localdomain (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.googlemail.com with ESMTPSA id u2-20020adff882000000b00241d21d4652sm4163549wrp.21.2022.12.14.15.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 15:55:12 -0800 (PST)
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
Subject: [PATCH v7 04/11] leds: trigger: netdev: rename and expose NETDEV trigger enum modes
Date:   Thu, 15 Dec 2022 00:54:31 +0100
Message-Id: <20221214235438.30271-5-ansuelsmth@gmail.com>
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

Rename NETDEV trigger enum modes to a more simbolic name and move them
in leds.h to make them accessible by any user.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 53 +++++++++------------------
 include/linux/leds.h                  |  7 ++++
 2 files changed, 25 insertions(+), 35 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 66a81cc9b64d..6872da08676b 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -51,15 +51,6 @@ struct led_netdev_data {
 
 	unsigned long mode;
 	bool carrier_link_up;
-#define NETDEV_LED_LINK	0
-#define NETDEV_LED_TX	1
-#define NETDEV_LED_RX	2
-};
-
-enum netdev_led_attr {
-	NETDEV_ATTR_LINK,
-	NETDEV_ATTR_TX,
-	NETDEV_ATTR_RX
 };
 
 static void set_baseline_state(struct led_netdev_data *trigger_data)
@@ -76,7 +67,7 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	if (!trigger_data->carrier_link_up) {
 		led_set_brightness(led_cdev, LED_OFF);
 	} else {
-		if (test_bit(NETDEV_LED_LINK, &trigger_data->mode))
+		if (test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode))
 			led_set_brightness(led_cdev,
 					   led_cdev->blink_brightness);
 		else
@@ -85,8 +76,8 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
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
@@ -146,20 +137,16 @@ static ssize_t device_name_store(struct device *dev,
 static DEVICE_ATTR_RW(device_name);
 
 static ssize_t netdev_led_attr_show(struct device *dev, char *buf,
-	enum netdev_led_attr attr)
+				    enum led_trigger_netdev_modes attr)
 {
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
 	int bit;
 
 	switch (attr) {
-	case NETDEV_ATTR_LINK:
-		bit = NETDEV_LED_LINK;
-		break;
-	case NETDEV_ATTR_TX:
-		bit = NETDEV_LED_TX;
-		break;
-	case NETDEV_ATTR_RX:
-		bit = NETDEV_LED_RX;
+	case TRIGGER_NETDEV_LINK:
+	case TRIGGER_NETDEV_TX:
+	case TRIGGER_NETDEV_RX:
+		bit = attr;
 		break;
 	default:
 		return -EINVAL;
@@ -169,7 +156,7 @@ static ssize_t netdev_led_attr_show(struct device *dev, char *buf,
 }
 
 static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
-	size_t size, enum netdev_led_attr attr)
+				     size_t size, enum led_trigger_netdev_modes attr)
 {
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
 	unsigned long state;
@@ -181,14 +168,10 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 		return ret;
 
 	switch (attr) {
-	case NETDEV_ATTR_LINK:
-		bit = NETDEV_LED_LINK;
-		break;
-	case NETDEV_ATTR_TX:
-		bit = NETDEV_LED_TX;
-		break;
-	case NETDEV_ATTR_RX:
-		bit = NETDEV_LED_RX;
+	case TRIGGER_NETDEV_LINK:
+	case TRIGGER_NETDEV_TX:
+	case TRIGGER_NETDEV_RX:
+		bit = attr;
 		break;
 	default:
 		return -EINVAL;
@@ -358,21 +341,21 @@ static void netdev_trig_work(struct work_struct *work)
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
index b5aad67fecfb..13862f8b1e07 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -548,6 +548,13 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 
 #endif /* CONFIG_LEDS_TRIGGERS */
 
+/* Trigger specific enum */
+enum led_trigger_netdev_modes {
+	TRIGGER_NETDEV_LINK = 1,
+	TRIGGER_NETDEV_TX,
+	TRIGGER_NETDEV_RX,
+};
+
 /* Trigger specific functions */
 #ifdef CONFIG_LEDS_TRIGGER_DISK
 void ledtrig_disk_activity(bool write);
-- 
2.37.2

