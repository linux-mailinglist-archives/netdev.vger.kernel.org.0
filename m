Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9648D64D444
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 01:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiLOABF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 19:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiLNX7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:59:34 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2D3396D7;
        Wed, 14 Dec 2022 15:56:00 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id i7so1445083wrv.8;
        Wed, 14 Dec 2022 15:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rRwDJXgAmTfDMJnqkydYiAsYVO0tTqwWRPMDyDIA3K4=;
        b=fki68Ia+FHYPxe5KSFHG4ZjHvDoY8LUNbwK9p7N5AMGZYRw0nW1KjM/GAYgCcujIvN
         eescXs/vUIgtGcv2weVmwRzY9DqIcm+zGdJEQhGcPGfFh3fTi0/tAedkCWrRgumPP9dQ
         1yKNsfeuov6HOc9H8uVzSZE5+Yj0wFW8H9ILKGa1IDJM+wUxR5c3GP8zPXpR+PIj5dZd
         wDDauc93bwVQ9L3YD1/JImPPk7hgyUVAMpaJ3RuJpesJIimxywaYpVyPXt0XKC+Ufhtw
         +aGE1LePuRBl0itX9n0JWicfmH53CDqkm/y3QKQ/A9pH6dgFwJbWP6trS7u2ahtY91fg
         5jaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rRwDJXgAmTfDMJnqkydYiAsYVO0tTqwWRPMDyDIA3K4=;
        b=JPh1Y+/rg1nFlqTq+jxCh7GwWe7wi3fnBdk90jHSvLNFcZ3guPcsLv2a7zVZVMAIxR
         XrzxqhFix7d78Q7Px7keqI4SA8FMShJUs2hc7eTE/9HTELkACSQj+aKVymeKSgdosU4k
         mL+VC0mWnN/wnedUlcJMcKuAc+c25dD/HCtPxhlPiUm0Evmd//DIDyNoPAAblAkTHf/t
         KvAu5PZ2n9UribaJ10D8jy8bJbQP6vhpBJRkYEA2m86P/jQ6pz0eWG5N8YzPXlJueqpW
         mPxZxIxcl80UE07Fr0tUFIa8+/9UgL2ctqHe03DbTXFH2W8F4fUQinDywFnltl4VuS0N
         CoSA==
X-Gm-Message-State: ANoB5pk0Webvg2DSfxA6ppd/uQqDLlDhEhDhU/H0xqr2xDQtkgYMY2Bn
        cm9EG4TDwDs68P4zv05J0Ak=
X-Google-Smtp-Source: AA0mqf4q39KC0NfaDQJFlVPhEulQbgvCtjW9TEL4j/IONO5+Q9je33aEi0Z2YYL8pOJv+mcjUxUC3g==
X-Received: by 2002:a05:6000:234:b0:242:29fc:ad51 with SMTP id l20-20020a056000023400b0024229fcad51mr17235558wrz.20.1671062121916;
        Wed, 14 Dec 2022 15:55:21 -0800 (PST)
Received: from localhost.localdomain (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.googlemail.com with ESMTPSA id u2-20020adff882000000b00241d21d4652sm4163549wrp.21.2022.12.14.15.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 15:55:21 -0800 (PST)
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
Subject: [PATCH v7 09/11] leds: trigger: netdev: add additional hardware only triggers
Date:   Thu, 15 Dec 2022 00:54:36 +0100
Message-Id: <20221214235438.30271-10-ansuelsmth@gmail.com>
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

Add additional hardware only triggers commonly supported by switch LEDs.

Additional modes:
link_10: LED on with link up AND speed 10mbps
link_100: LED on with link up AND speed 100mbps
link_1000: LED on with link up AND speed 1000mbps
half_duplex: LED on with link up AND half_duplex mode
full_duplex: LED on with link up AND full duplex mode

Additional blink interval modes:
blink_2hz: LED blink on any even at 2Hz (250ms)
blink_4hz: LED blink on any even at 4Hz (125ms)
blink_8hz: LED blink on any even at 8Hz (62ms)

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 58 +++++++++++++++++++++++++++
 include/linux/leds.h                  | 10 +++++
 2 files changed, 68 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 3a3b77bb41fb..880d5e65f7a2 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -29,8 +29,20 @@
  *
  * device_name - network device name to monitor
  * interval - duration of LED blink, in milliseconds
+ *            (in hardware mode 2hz (62ms), 4hz (125ms) or 8hz (250ms)
+ *             are supported)
  * link -  LED's normal state reflects whether the link is up
  *         (has carrier) or not
+ * link_10 - LED's normal state reflects whether the link is
+ *           up and at 10mbps speed (hardware only)
+ * link_100 - LED's normal state reflects whether the link is
+ *            up and at 100mbps speed (hardware only)
+ * link_1000 - LED's normal state reflects whether the link is
+ *             up and at 1000mbps speed (hardware only)
+ * half_duplex - LED's normal state reflects whether the link is
+ *               up and hafl duplex (hardware only)
+ * full_duplex - LED's normal state reflects whether the link is
+ *               up and full duplex (hardware only)
  * tx -  LED blinks on transmitted data
  * rx -  LED blinks on receive data
  * available_mode - Display available mode and how they can be handled
@@ -64,8 +76,19 @@ struct netdev_led_attr_detail {
 
 static struct netdev_led_attr_detail attr_details[] = {
 	{ .name = "link", .bit = TRIGGER_NETDEV_LINK},
+	{ .name = "link_10", .hardware_only = true, .bit = TRIGGER_NETDEV_LINK_10},
+	{ .name = "link_100", .hardware_only = true, .bit = TRIGGER_NETDEV_LINK_100},
+	{ .name = "link_1000", .hardware_only = true, .bit = TRIGGER_NETDEV_LINK_1000},
+	{ .name = "half_duplex", .hardware_only = true, .bit = TRIGGER_NETDEV_HALF_DUPLEX},
+	{ .name = "full_duplex", .hardware_only = true, .bit = TRIGGER_NETDEV_FULL_DUPLEX},
 	{ .name = "tx", .bit = TRIGGER_NETDEV_TX},
 	{ .name = "rx", .bit = TRIGGER_NETDEV_RX},
+	{ .name = "hw blink 2hz (interval set to 62)", .hardware_only = true,
+	  .bit = TRIGGER_NETDEV_BLINK_2HZ},
+	{ .name = "hw blink 4hz (interval set to 125)", .hardware_only = true,
+	  .bit = TRIGGER_NETDEV_BLINK_4HZ},
+	{ .name = "hw blink 8hz (interval set to 250)", .hardware_only = true,
+	  .bit = TRIGGER_NETDEV_BLINK_8HZ},
 };
 
 static bool validate_baseline_state(struct led_netdev_data *trigger_data)
@@ -259,6 +282,11 @@ static ssize_t netdev_led_attr_show(struct device *dev, char *buf,
 
 	switch (attr) {
 	case TRIGGER_NETDEV_LINK:
+	case TRIGGER_NETDEV_LINK_10:
+	case TRIGGER_NETDEV_LINK_100:
+	case TRIGGER_NETDEV_LINK_1000:
+	case TRIGGER_NETDEV_HALF_DUPLEX:
+	case TRIGGER_NETDEV_FULL_DUPLEX:
 	case TRIGGER_NETDEV_TX:
 	case TRIGGER_NETDEV_RX:
 		bit = attr;
@@ -284,6 +312,11 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 
 	switch (attr) {
 	case TRIGGER_NETDEV_LINK:
+	case TRIGGER_NETDEV_LINK_10:
+	case TRIGGER_NETDEV_LINK_100:
+	case TRIGGER_NETDEV_LINK_1000:
+	case TRIGGER_NETDEV_HALF_DUPLEX:
+	case TRIGGER_NETDEV_FULL_DUPLEX:
 	case TRIGGER_NETDEV_TX:
 	case TRIGGER_NETDEV_RX:
 		bit = attr;
@@ -324,6 +357,11 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 	static DEVICE_ATTR_RW(trigger_name)
 
 DEFINE_NETDEV_TRIGGER(link, TRIGGER_NETDEV_LINK);
+DEFINE_NETDEV_TRIGGER(link_10, TRIGGER_NETDEV_LINK_10);
+DEFINE_NETDEV_TRIGGER(link_100, TRIGGER_NETDEV_LINK_100);
+DEFINE_NETDEV_TRIGGER(link_1000, TRIGGER_NETDEV_LINK_1000);
+DEFINE_NETDEV_TRIGGER(half_duplex, TRIGGER_NETDEV_HALF_DUPLEX);
+DEFINE_NETDEV_TRIGGER(full_duplex, TRIGGER_NETDEV_FULL_DUPLEX);
 DEFINE_NETDEV_TRIGGER(tx, TRIGGER_NETDEV_TX);
 DEFINE_NETDEV_TRIGGER(rx, TRIGGER_NETDEV_RX);
 
@@ -356,6 +394,21 @@ static ssize_t interval_store(struct device *dev,
 
 	cancel_delayed_work_sync(&trigger_data->work);
 
+	if (trigger_data->blink_mode == HARDWARE_CONTROLLED) {
+		/* Interval are handled as triggers. Reset them. */
+		trigger_data->mode &= ~(BIT(TRIGGER_NETDEV_BLINK_8HZ) |
+					BIT(TRIGGER_NETDEV_BLINK_4HZ) |
+					BIT(TRIGGER_NETDEV_BLINK_2HZ));
+
+		/* Support a common value of 2Hz, 4Hz and 8Hz. */
+		if (value > 5 && value <= 62) /* 8Hz */
+			trigger_data->mode |= BIT(TRIGGER_NETDEV_BLINK_8HZ);
+		else if (value > 63 && value <= 125) /* 4Hz */
+			trigger_data->mode |= BIT(TRIGGER_NETDEV_BLINK_4HZ);
+		else /* 2Hz */
+			trigger_data->mode |= BIT(TRIGGER_NETDEV_BLINK_2HZ);
+	}
+
 	atomic_set(&trigger_data->interval, msecs_to_jiffies(value));
 
 	if (!validate_baseline_state(trigger_data)) {
@@ -404,6 +457,11 @@ static DEVICE_ATTR_RO(available_mode);
 static struct attribute *netdev_trig_attrs[] = {
 	&dev_attr_device_name.attr,
 	&dev_attr_link.attr,
+	&dev_attr_link_10.attr,
+	&dev_attr_link_100.attr,
+	&dev_attr_link_1000.attr,
+	&dev_attr_half_duplex.attr,
+	&dev_attr_full_duplex.attr,
 	&dev_attr_rx.attr,
 	&dev_attr_tx.attr,
 	&dev_attr_interval.attr,
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 13862f8b1e07..5fcc6d233757 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -551,8 +551,18 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 /* Trigger specific enum */
 enum led_trigger_netdev_modes {
 	TRIGGER_NETDEV_LINK = 1,
+	TRIGGER_NETDEV_LINK_10,
+	TRIGGER_NETDEV_LINK_100,
+	TRIGGER_NETDEV_LINK_1000,
+	TRIGGER_NETDEV_HALF_DUPLEX,
+	TRIGGER_NETDEV_FULL_DUPLEX,
 	TRIGGER_NETDEV_TX,
 	TRIGGER_NETDEV_RX,
+
+	/* Hardware Interval options */
+	TRIGGER_NETDEV_BLINK_2HZ,
+	TRIGGER_NETDEV_BLINK_4HZ,
+	TRIGGER_NETDEV_BLINK_8HZ,
 };
 
 /* Trigger specific functions */
-- 
2.37.2

