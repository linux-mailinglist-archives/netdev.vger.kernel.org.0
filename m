Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D518698A0F
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjBPBh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjBPBgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:36:46 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64B846164;
        Wed, 15 Feb 2023 17:36:30 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id s13-20020a05600c45cd00b003ddca7a2bcbso436494wmo.3;
        Wed, 15 Feb 2023 17:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cvd+xH+uABWYG4lAo6qwQojco60Jw9t/Cf4VcdLlrbU=;
        b=LExgDe66nojEag9TulRXjtJR+0NOwJTKsN2FewR9qwomKPDL6p4qU3sA8qazmP1h0F
         2kuI8z8De/F9heHpDfxs0VAwGoNowXVpZyqW7U2LnC5RrF88EM+F1NafTO7XfVgrYPhA
         5Xp82NfP3/DpwLc2/EFKauA8nq5GYv+w3+Qig8iYnAa8DbtYnyQroydivC7nt9c4a8Z5
         bMygdeSSKzVfgVcbHf1sCgRGLbvMZtZZ2MFyqj33oqLVR4MbyLOZukJf1Eh8DbdAfyOG
         a1dVKXXHZZ3bVEbCSqenXDRzv22xJ7+0FL/8+mt+oeW5m2aRKRAwuoNSr6qMDzHKbnRx
         8IFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cvd+xH+uABWYG4lAo6qwQojco60Jw9t/Cf4VcdLlrbU=;
        b=BCnYFXEWoxdwbu/7F1h12mN/8kZwisvoSsZccheXieE/zLCkn7QX44TVFT+/z+3QvW
         7E08reLCRCvAApNNFSyyjravg5v+9N85t+6aH1Cc1fty83OYlTYUnuuY8soVUL+ut1QD
         y7JoVVV7cRA75myfbP6WA7pNko2RIcGOR9KFQzqmRmV+7uArfpR+upjhD32FKkpKQfjD
         sIAk25kipzayEtwGC0hFysnEvl+RbHLAGp0waG0F5KLnfwVuEwkZCqPOUkLYxdW1NZVw
         YBjOLYARo/dsqFw7D3xY0XZRe53USSd7R3gSm/4+tXh8n/eF79SgKN3XNYBo2S0zY+XE
         XAFw==
X-Gm-Message-State: AO0yUKUt1Y6Z+UbiooRfbU52nCxmM0eVUhOLBuDYFYaFdyhqIb2UfTx0
        PpXqWRuXOJQj7GXkfpGmBRk=
X-Google-Smtp-Source: AK7set/yaSvTl+DcBsbUCR9AmTFw/OJe/93EaxiOAi69Ff1hlit5AFMf8fBOsIQd0OOsQncBCplXXg==
X-Received: by 2002:a05:600c:c0e:b0:3df:f860:3089 with SMTP id fm14-20020a05600c0c0e00b003dff8603089mr3719917wmb.32.1676511388774;
        Wed, 15 Feb 2023 17:36:28 -0800 (PST)
Received: from localhost.localdomain (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.googlemail.com with ESMTPSA id v15-20020a05600c214f00b003e1fb31fc2bsm64189wml.37.2023.02.15.17.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 17:36:28 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Arun.Ramadoss@microchip.com
Subject: [PATCH v8 09/13] leds: trigger: netdev: add additional hardware only triggers
Date:   Thu, 16 Feb 2023 02:32:26 +0100
Message-Id: <20230216013230.22978-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230216013230.22978-1-ansuelsmth@gmail.com>
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
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
activity: LED blink on tx or rx event

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 58 +++++++++++++++++++++++++++
 include/linux/leds.h                  |  6 +++
 2 files changed, 64 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index b992d617f406..b229bdb69501 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -33,6 +33,17 @@
  *            (not supported in hw mode)
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
+ * activity - LED's blinks on transmitted or received data (hardware only)
  * tx -  LED blinks on transmitted data
  * rx -  LED blinks on receive data
  * available_mode - Display available mode and how they can be handled
@@ -66,6 +77,12 @@ struct netdev_led_attr_detail {
 
 static struct netdev_led_attr_detail attr_details[] = {
 	{ .name = "link", .bit = TRIGGER_NETDEV_LINK},
+	{ .name = "link_10", .hardware_only = true, .bit = TRIGGER_NETDEV_LINK_10},
+	{ .name = "link_100", .hardware_only = true, .bit = TRIGGER_NETDEV_LINK_100},
+	{ .name = "link_1000", .hardware_only = true, .bit = TRIGGER_NETDEV_LINK_1000},
+	{ .name = "half_duplex", .hardware_only = true, .bit = TRIGGER_NETDEV_HALF_DUPLEX},
+	{ .name = "full_duplex", .hardware_only = true, .bit = TRIGGER_NETDEV_FULL_DUPLEX},
+	{ .name = "activity", .hardware_only = true, .bit = TRIGGER_NETDEV_ACTIVITY },
 	{ .name = "tx", .bit = TRIGGER_NETDEV_TX},
 	{ .name = "rx", .bit = TRIGGER_NETDEV_RX},
 };
@@ -123,6 +140,23 @@ static bool validate_baseline_state(struct led_netdev_data *trigger_data)
 	if (hw_blink_modes && hw_blink_modes != trigger_data->mode)
 		return false;
 
+	/* Check conflicts single rx or tx can't be active if activity is
+	 * active.
+	 */
+	if (test_bit(TRIGGER_NETDEV_ACTIVITY, &hw_blink_modes) &&
+	    (test_bit(TRIGGER_NETDEV_TX, &hw_blink_modes) ||
+	     test_bit(TRIGGER_NETDEV_RX, &hw_blink_modes)))
+		return false;
+
+	/* Check conflicts single link speed can't be active if link is
+	 * active.
+	 */
+	if (test_bit(TRIGGER_NETDEV_LINK, &hw_blink_modes) &&
+	    (test_bit(TRIGGER_NETDEV_LINK_10, &hw_blink_modes) ||
+	     test_bit(TRIGGER_NETDEV_LINK_100, &hw_blink_modes) ||
+	     test_bit(TRIGGER_NETDEV_LINK_1000, &hw_blink_modes)))
+		return false;
+
 	/* Modes are valid. Decide now the running mode to later
 	 * set the baseline.
 	 */
@@ -267,6 +301,12 @@ static ssize_t netdev_led_attr_show(struct device *dev, char *buf,
 
 	switch (attr) {
 	case TRIGGER_NETDEV_LINK:
+	case TRIGGER_NETDEV_LINK_10:
+	case TRIGGER_NETDEV_LINK_100:
+	case TRIGGER_NETDEV_LINK_1000:
+	case TRIGGER_NETDEV_HALF_DUPLEX:
+	case TRIGGER_NETDEV_FULL_DUPLEX:
+	case TRIGGER_NETDEV_ACTIVITY:
 	case TRIGGER_NETDEV_TX:
 	case TRIGGER_NETDEV_RX:
 		bit = attr;
@@ -292,6 +332,12 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 
 	switch (attr) {
 	case TRIGGER_NETDEV_LINK:
+	case TRIGGER_NETDEV_LINK_10:
+	case TRIGGER_NETDEV_LINK_100:
+	case TRIGGER_NETDEV_LINK_1000:
+	case TRIGGER_NETDEV_HALF_DUPLEX:
+	case TRIGGER_NETDEV_FULL_DUPLEX:
+	case TRIGGER_NETDEV_ACTIVITY:
 	case TRIGGER_NETDEV_TX:
 	case TRIGGER_NETDEV_RX:
 		bit = attr;
@@ -332,6 +378,12 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 	static DEVICE_ATTR_RW(trigger_name)
 
 DEFINE_NETDEV_TRIGGER(link, TRIGGER_NETDEV_LINK);
+DEFINE_NETDEV_TRIGGER(link_10, TRIGGER_NETDEV_LINK_10);
+DEFINE_NETDEV_TRIGGER(link_100, TRIGGER_NETDEV_LINK_100);
+DEFINE_NETDEV_TRIGGER(link_1000, TRIGGER_NETDEV_LINK_1000);
+DEFINE_NETDEV_TRIGGER(half_duplex, TRIGGER_NETDEV_HALF_DUPLEX);
+DEFINE_NETDEV_TRIGGER(full_duplex, TRIGGER_NETDEV_FULL_DUPLEX);
+DEFINE_NETDEV_TRIGGER(activity, TRIGGER_NETDEV_ACTIVITY);
 DEFINE_NETDEV_TRIGGER(tx, TRIGGER_NETDEV_TX);
 DEFINE_NETDEV_TRIGGER(rx, TRIGGER_NETDEV_RX);
 
@@ -425,6 +477,12 @@ static DEVICE_ATTR_RO(available_mode);
 static struct attribute *netdev_trig_attrs[] = {
 	&dev_attr_device_name.attr,
 	&dev_attr_link.attr,
+	&dev_attr_link_10.attr,
+	&dev_attr_link_100.attr,
+	&dev_attr_link_1000.attr,
+	&dev_attr_half_duplex.attr,
+	&dev_attr_full_duplex.attr,
+	&dev_attr_activity.attr,
 	&dev_attr_rx.attr,
 	&dev_attr_tx.attr,
 	&dev_attr_interval.attr,
diff --git a/include/linux/leds.h b/include/linux/leds.h
index a31f158e5351..9071ab768776 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -574,6 +574,12 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 /* Trigger specific enum */
 enum led_trigger_netdev_modes {
 	TRIGGER_NETDEV_LINK = 1,
+	TRIGGER_NETDEV_LINK_10,
+	TRIGGER_NETDEV_LINK_100,
+	TRIGGER_NETDEV_LINK_1000,
+	TRIGGER_NETDEV_HALF_DUPLEX,
+	TRIGGER_NETDEV_FULL_DUPLEX,
+	TRIGGER_NETDEV_ACTIVITY,
 	TRIGGER_NETDEV_TX,
 	TRIGGER_NETDEV_RX,
 };
-- 
2.38.1

