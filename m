Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284B844A4AC
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 03:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240870AbhKIC3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 21:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239625AbhKIC3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 21:29:05 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42FDC061570;
        Mon,  8 Nov 2021 18:26:19 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id m14so69877397edd.0;
        Mon, 08 Nov 2021 18:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=jFe5KTURBcOOWrUfhODd1Eso/w+chUk7dQ+LiJPhNjU=;
        b=Kn3VTkVxk2VjycPtbFj/RgOqzsDJ/GGvEDv+ZxBOlFw+AbafgbXdqycJZ4brzm39Fh
         DdCZpPlsNiXdEH1VdxDVmRC+0e4yOarZeETaryroCttm63J1VYdBnz9QDgCn+JQTeDa3
         yn3LSpwRU2IGtTCioXrMUORcTWX7Vi5B5IrEUs2U2MsGu+dBx0qDBU31HWmUG6fSabMW
         Xo9rtxBqlSRpW3qhgjKrKq8wUzmEAwt05pfGU1Ox7+QXyIm/YwGjvCl4bRQId6JvNBCj
         QX+5829bpytIbfSxfJIhghk42dUBnIbOh4luDf1s16i4Wal4JUc4ldmKuj5EdOSnAsC/
         hr2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jFe5KTURBcOOWrUfhODd1Eso/w+chUk7dQ+LiJPhNjU=;
        b=8Rtz7SSPRPjIvGc8BXc7stFkVDmZozQ9X5/9LLwYEwoWvLTT0d3d3IEHQFJ52nrf8i
         8y18saJzaVIwvTBoWiPDls6PrVOFL/o5PFGA87UOBlZ1WZEGJOhio0/u6VkKZFtEwSev
         zFJf31/BrY56zysjYycuf1Nry2tdpBtUP7MB3K5Pxwtkda21qw+UpW0XMaYrf4KxJ8Nm
         Su5DEZ7SpeWvUTKMhU32EgvhmQOT9Hebb3XY2qj2YKtSjO1S0//gmSe0AyqcNdVc1dsr
         peasJU0dq2hyyscMyjWZYVdDth5e9ZJukjHhkgD+8eJm/CF3kdndtUClk8vAE7b+sAaP
         iI1g==
X-Gm-Message-State: AOAM533A2Rtr84kDMz5XcveXVgMyoD5E601R4vU9W0kuN1brR61YdBhm
        1TyZ3exUThAqKhl4OsiczT43zAquHME=
X-Google-Smtp-Source: ABdhPJx7ldT+O4kZz2zJaD34Ue5F6nXtqzu7OIQcKLXN0CQhEgIgVe8Fqg1QNXS2NSZgEG0ow7qNAA==
X-Received: by 2002:a17:906:a949:: with SMTP id hh9mr5038520ejb.294.1636424778328;
        Mon, 08 Nov 2021 18:26:18 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m5sm8760900ejc.62.2021.11.08.18.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 18:26:18 -0800 (PST)
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
Subject: [RFC PATCH v3 4/8] leds: trigger: netdev: rename and expose NETDEV trigger enum modes
Date:   Tue,  9 Nov 2021 03:26:04 +0100
Message-Id: <20211109022608.11109-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211109022608.11109-1-ansuelsmth@gmail.com>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename NETDEV trigger enum modes to a more simbolic name and move them
in leds.h to make them accessible by any user.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 31 ++++++++++++---------------
 include/linux/leds.h                  |  7 ++++++
 2 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 66a81cc9b64d..0a3c0b54dbb9 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -51,9 +51,6 @@ struct led_netdev_data {
 
 	unsigned long mode;
 	bool carrier_link_up;
-#define NETDEV_LED_LINK	0
-#define NETDEV_LED_TX	1
-#define NETDEV_LED_RX	2
 };
 
 enum netdev_led_attr {
@@ -76,7 +73,7 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	if (!trigger_data->carrier_link_up) {
 		led_set_brightness(led_cdev, LED_OFF);
 	} else {
-		if (test_bit(NETDEV_LED_LINK, &trigger_data->mode))
+		if (test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode))
 			led_set_brightness(led_cdev,
 					   led_cdev->blink_brightness);
 		else
@@ -85,8 +82,8 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
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
@@ -153,13 +150,13 @@ static ssize_t netdev_led_attr_show(struct device *dev, char *buf,
 
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
@@ -182,13 +179,13 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 
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
@@ -358,21 +355,21 @@ static void netdev_trig_work(struct work_struct *work)
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
index 00bc4d6ed7ca..087debe6716d 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -548,6 +548,13 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 
 #endif /* CONFIG_LEDS_TRIGGERS */
 
+/* Trigger specific enum */
+enum led_trigger_netdev_modes {
+	TRIGGER_NETDEV_LINK,
+	TRIGGER_NETDEV_TX,
+	TRIGGER_NETDEV_RX,
+};
+
 /* Trigger specific functions */
 #ifdef CONFIG_LEDS_TRIGGER_DISK
 void ledtrig_disk_activity(bool write);
-- 
2.32.0

