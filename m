Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1437F51884B
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbiECPW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238160AbiECPWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:22:06 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337E83B018;
        Tue,  3 May 2022 08:18:28 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id p18so20219417edr.7;
        Tue, 03 May 2022 08:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=tR8IRWH0xQBqVx+xXwpjUsHhcTEL0yAEgJc1yrKzhxk=;
        b=R4bOOQCZ1zDudeP2d/a3ERHdfnM/No7BIv3UC7sgI44lAz8JuT0xZI4wlYdSWq6MbM
         2FHUrhiuDfpNbIIo8JL4HTUGahP0SXeS4ZFnN+Nq39UIg/ALC3475+7Du2wwfPqZoPCS
         uFIEs7VCcUYJCyjtM3LY+MNy4r/5agitYnUIp+sA5hvifHOz3DJjeERXUcMH5IhxewTT
         dD79aBVvXIEVCvk2BQ4FhplNpPHQVOmZw33Son3Cz2eQsAYPV+G/cxnfe8vS+VN9+DWx
         1zOdTgODZ9RbQ0opp+AipX5K6QXcuAul/nOzkn4d+va/5p6r/2GM3oaGegm9wAR4n8Vl
         RnSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tR8IRWH0xQBqVx+xXwpjUsHhcTEL0yAEgJc1yrKzhxk=;
        b=T4+adFXXUHgY3RieW+xlYhLYxMVmR66cl8sqv/0o86g401MUT9Qx3SOkPQOqcwKjhs
         9f7SboDBoo2dHZf4sXW6sTF4kIIhfHK2f7VowCy3eDviCjuOCyFlxErhW+1ccGqpp5Pf
         5gVd2ZrGWSO0Kn/rEuEaeiD7eNWoBFn0nQNr8F+Uzzs7ujMxObwNFj//chKbef6FCbPT
         XWuCBPl8/6JmaeMdDmERvFEgQIeI3VciKAduRf178Mtgdy9XVEH0FQl0W55OqyBpPjk/
         kh7/6+hzLtCtzG5gpUntKw/SKzli315AMDkZoG3R3fj8o8CvRgoIH/O8v4sHH7h7S38P
         HeNQ==
X-Gm-Message-State: AOAM5339deki3n1WVRqhh7U6D3YWHptk2DQklsOkyzzp8GJbOEeS+7R2
        jN58PvxxbzO/5cCpkYNceGk=
X-Google-Smtp-Source: ABdhPJyM/DXKKPyfASY7GZhfHVYG8hE5CdiRrdrFvNXqwhpWDJxzDev6qxXbRaDL6lSIrrHmMsBoRQ==
X-Received: by 2002:aa7:d393:0:b0:425:a8f8:663a with SMTP id x19-20020aa7d393000000b00425a8f8663amr18269119edq.323.1651591106568;
        Tue, 03 May 2022 08:18:26 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id v3-20020aa7d9c3000000b0042617ba63cesm7947507eds.88.2022.05.03.08.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 08:18:26 -0700 (PDT)
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
Subject: [RFC PATCH v6 09/11] leds: trigger: netdev: add additional hardware only triggers
Date:   Tue,  3 May 2022 17:16:31 +0200
Message-Id: <20220503151633.18760-10-ansuelsmth@gmail.com>
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

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 58 +++++++++++++++++++++++++++
 include/linux/leds.h                  | 10 +++++
 2 files changed, 68 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index d88b0c6a910e..bced05fafb1c 100644
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
2.34.1

