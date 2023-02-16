Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD906989FB
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjBPBgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjBPBgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:36:43 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DAE460AE;
        Wed, 15 Feb 2023 17:36:27 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id az4-20020a05600c600400b003dff767a1f1so452867wmb.2;
        Wed, 15 Feb 2023 17:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vhCM3b28R3+woNIHZgCVKD0ugnkmVKAOEKg8BSCfbhs=;
        b=JTYXQusfYeTpKf5CIdokbUYI/O7XT0GoPLukiIK1Adc91kJgFlf2Db3655jXCjrv9w
         J3IJLu4tYNvvX9FXmx2wcTLpNIW4n9JbhxcGxitvAsi+b+ZPp2Yctykm1ijGh3tNYDGE
         AW30u8UMsgt4i/tMHSpDfTS3dI28gNZmj8/xyCwNNzhPHxR/B+kIabo0uRudlkhALAy1
         ROexqntER7ioYliK5TNv7sbMput5dSwp88btslEwR3BC9TTOZ+A5qCPrp9y4Xk6ICN5I
         LyjrP2w+86R+sB3xiUrLkVDdGDI+56VYVKtTxPnJdxk0ooZP7jEpU1U5lIbORNE4JW3g
         uH9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vhCM3b28R3+woNIHZgCVKD0ugnkmVKAOEKg8BSCfbhs=;
        b=yOpAm2i0swewGlEmFc2a1CfHJGeGBQ/2hlNkjz19E+0gX4u4aE15HtGCu6raHueNKN
         Lm2TDjrWLdT+baiooH8U67GcQLpJe58JwgMaP82+Dds39tv9rT8O9ZPRG7r/21+yDmN8
         HiOeegx/XaVXVUu0n1Dt1nPkKvZIQkA/FyXWaG34FXaJidGle6eWQLrpSvLWEVepa4Za
         EANqmdIFxoLygKHjDdiHe/CY43Axdshf6w1Bh6mIh1G5YXbmuVKgmIwOMQnv6bLIy++Z
         MmVazFBl3/g4Dmy3gCVkIGM+BfKMqiSlJaXc312HlWd4Ss4p6TddJ0X7KmgE5YbN37CO
         4cyg==
X-Gm-Message-State: AO0yUKW9xMQXWxuP9EwvrzAySymQjwHg+/9MBTvzN6tzy1ZQf0G1D2G/
        NWgHqlnIvLu0bdZ0pA1Gt6M=
X-Google-Smtp-Source: AK7set+hcJir70mP7Ikeox+RQ2xNCGRSITRsjGZD9D0kXvJCA08S8XHPyXxewOyEAXl1yGPcsWy1+w==
X-Received: by 2002:a05:600c:44d2:b0:3e2:662:add6 with SMTP id f18-20020a05600c44d200b003e20662add6mr2330599wmo.11.1676511387365;
        Wed, 15 Feb 2023 17:36:27 -0800 (PST)
Received: from localhost.localdomain (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.googlemail.com with ESMTPSA id v15-20020a05600c214f00b003e1fb31fc2bsm64189wml.37.2023.02.15.17.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 17:36:27 -0800 (PST)
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
Subject: [PATCH v8 08/13] leds: trigger: netdev: add available mode sysfs attr
Date:   Thu, 16 Feb 2023 02:32:25 +0100
Message-Id: <20230216013230.22978-9-ansuelsmth@gmail.com>
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

Add avaiable_mode sysfs attr to show and give some details about the
supported modes and how they can be handled by the trigger.

this can be used to get an overview of the different modes currently
available and active.

A mode with [hardware] can hw blink.
A mode with [software] con blink with sw support.
A mode with [hardware][software] support both mode but will fallback to
sw mode if needed.
A mode with [unavailable] will reject any option and can't be enabled
due to hw limitation or current configuration.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 41 +++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 6dd04f4d70ea..b992d617f406 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -35,6 +35,8 @@
  *         (has carrier) or not
  * tx -  LED blinks on transmitted data
  * rx -  LED blinks on receive data
+ * available_mode - Display available mode and how they can be handled
+ *                  by the LED
  *
  */
 
@@ -382,12 +384,51 @@ static ssize_t interval_store(struct device *dev,
 
 static DEVICE_ATTR_RW(interval);
 
+static ssize_t available_mode_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
+	struct netdev_led_attr_detail *detail;
+	bool support_hw_mode;
+	int i, len = 0;
+
+	for (i = 0; i < ARRAY_SIZE(attr_details); i++) {
+		detail = &attr_details[i];
+		support_hw_mode = led_trigger_blink_mode_is_supported(trigger_data->led_cdev,
+								      BIT(detail->bit));
+
+		len += sprintf(buf + len, "%s ", detail->name);
+
+		if (detail->hardware_only) {
+			if (trigger_data->net_dev || !support_hw_mode)
+				len += sprintf(buf + len, "[unavailable]");
+			else
+				len += sprintf(buf + len, "[hardware]");
+		} else {
+			len += sprintf(buf + len, "[software]");
+
+			if (support_hw_mode && !trigger_data->net_dev)
+				len += sprintf(buf + len, "[hardware]");
+		}
+
+		if (test_bit(detail->bit, &trigger_data->mode))
+			len += sprintf(buf + len, "[on]");
+
+		len += sprintf(buf + len, "\n");
+	}
+
+	return len;
+}
+
+static DEVICE_ATTR_RO(available_mode);
+
 static struct attribute *netdev_trig_attrs[] = {
 	&dev_attr_device_name.attr,
 	&dev_attr_link.attr,
 	&dev_attr_rx.attr,
 	&dev_attr_tx.attr,
 	&dev_attr_interval.attr,
+	&dev_attr_available_mode.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(netdev_trig);
-- 
2.38.1

