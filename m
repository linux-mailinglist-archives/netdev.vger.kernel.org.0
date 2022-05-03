Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B01B51883D
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238234AbiECPWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238118AbiECPVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:21:54 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E6C3AA5F;
        Tue,  3 May 2022 08:18:21 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id l18so34050820ejc.7;
        Tue, 03 May 2022 08:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=YkFrQ4/wi+cqyLXOlhLD4aOJANtZ19orl1Mof8QAy1Y=;
        b=lGGZDd9wSGMI1R1F9bB93M23m5dMXI46oaQiR62pm0dEOCTJQ5IPsD1vxO9d/emI2q
         1KzXBJpqwHYWNKONDA+gsVQ+LP/pE9GBem/IGTFjdgMRgvoE3CjvM3D0Ap9XBvmgormi
         rvfpnNeeXQSQ2QFkfodCEEzlrbScfBnlE7W2Vy1t5V1yAdeqcj2kOgk8zc3o2Uz0+fMi
         3xirS/sVKiWig9rnskwhrpQ0l7UHs8B0LqBHgpArha2mGq6WAfyRaQVlSXd+a4Yarj8g
         N4OxVhlAmLJeVQxy6p0RPYLB9pbcfCifrIa4kb+BGXlbJjrEJ/ToCJvBZkysE+41CltC
         HSGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YkFrQ4/wi+cqyLXOlhLD4aOJANtZ19orl1Mof8QAy1Y=;
        b=eVHla7FeAsup/MKpZkhUDYTGLoe4nWuus2Ffv8Ef5bbGF/seQhwYyd2vQPmBNza5PN
         wfMViapztqRTfuu1AMQsik3mD2hrhVFU3QAuMvUGbxwUM4nF6Rf4JClU3MhfGdLwr0gL
         DRDYvkF+Du4k/R5zp0LQlUzv2wlRWv0+DHIj57FQE2BzEDM9V39fXONky0btqY+dDzHK
         UFQ5uKgMy6ILQgxoRRqaMXU5UfWjLKeeomwxWpqKhmCDryP/+Zr73c7mHvL0xc7igukM
         11plqU6330KHewYHoHrnrTfQvovMYAoHqVmBd0TAZRkqxOqT9xlvv3ETVyoNE6ntLEmW
         j2xw==
X-Gm-Message-State: AOAM533u3+bSp/t372O9CAFsXej2E5hySddXfVej8a2vUTz544ul45AP
        jcQIGA00GWqmDwJiNFpdxDE=
X-Google-Smtp-Source: ABdhPJzJs0qkledNmUPM0IohTua8MkFilLH+VBdbuPdbxSmAgFDeHm7Y+dwgF1ovBN670OAHoLZrZw==
X-Received: by 2002:a17:906:b286:b0:6f3:b3e4:5f67 with SMTP id q6-20020a170906b28600b006f3b3e45f67mr16067213ejz.148.1651591099814;
        Tue, 03 May 2022 08:18:19 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id v3-20020aa7d9c3000000b0042617ba63cesm7947507eds.88.2022.05.03.08.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 08:18:19 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [RFC PATCH v6 04/11] leds: trigger: netdev: rename and expose NETDEV trigger enum modes
Date:   Tue,  3 May 2022 17:16:26 +0200
Message-Id: <20220503151633.18760-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220503151633.18760-1-ansuelsmth@gmail.com>
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename NETDEV trigger enum modes to a more simbolic name and move them
in leds.h to make them accessible by any user.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
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
2.34.1

