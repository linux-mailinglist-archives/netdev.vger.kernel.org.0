Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A9164D43A
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 01:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiLOAAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 19:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiLNX71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:59:27 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E5EFCED;
        Wed, 14 Dec 2022 15:55:56 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id h16so1420268wrz.12;
        Wed, 14 Dec 2022 15:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9MMLnTteUrqIxH9MlpZEihuzNBu6Jv5Ux8kWMNNeLhU=;
        b=CrDS8suCiCLiSApldYHkNJ+1wtFo6lr4JJPQz5VoMWHZs9D6CTZgBtF4OlJz8Ud5ya
         2WF+NYj2sT6AnHKaDPVhyoGUi8qHDcuK2lFrGKKo1DvBdKWWadt3IkM1T4EFgIb+HVIN
         j6TLXcYr0Pf2fiJE9v8cPKuuTlbpPyPezXCuxcK3FlQEolAj3fr1TZ79YzF19dXeFVr8
         vy0dVJ9Xw2N0LVnwqVBEEpKoKSUBYFqqqAJ77o1aFKnvafR/ASU7tJosZNhoowkaZY03
         Rl+Abn1keOOLj0fWgroz8ylRmPPsm/7XRTtwc2eKBdXMLb8PwHCczJ5j6HW0Nk/ogExc
         UinA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9MMLnTteUrqIxH9MlpZEihuzNBu6Jv5Ux8kWMNNeLhU=;
        b=H1MOk6fTFK34FYlo9JpJHPLrCJceJ2uu0uG4pEYrMsPzQxEK8LJyO/ZrH+Zqa8lbUO
         JOxvMftUu8GdH8wDs6Fh6n9XtVIlNNP1eBXkhhEYbQDGI6NJxl9191zFXvrSZttsmHJM
         vay2+z4S7/jK8hxp29B79rXGdj2eZGtzLTOqJo+/k24PWK/o0uoL/Gok8cZlhGvx+EY2
         1YlKSo05AOS2Ov2BQBM2UphmFSJog6MMTscTnJxY3RR3Xxd5WrlcRvGRQwGPDqdNTg7j
         NbKSipf8Dz04f575R79ZEAkAw1EkEkGthc0S5t4eZYBEU8QEQDl8+rX0Yu15MCkbfvx7
         diCg==
X-Gm-Message-State: ANoB5plzZcsRDlUGpnBLhCGUtNWlasKlJ9roQbLDAKrp4HVRpbPuYfpW
        CUGbsCbBqyaa2DWVU9boZLM=
X-Google-Smtp-Source: AA0mqf5Lkgg/dpJOYekqqk1uqf9OtMA0S0/LY06DpNjzTwpWpcoCyaCWhMtE0+2jpAlCx+WxnORkUw==
X-Received: by 2002:adf:ec05:0:b0:242:5ceb:fafa with SMTP id x5-20020adfec05000000b002425cebfafamr16573139wrn.34.1671062120107;
        Wed, 14 Dec 2022 15:55:20 -0800 (PST)
Received: from localhost.localdomain (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.googlemail.com with ESMTPSA id u2-20020adff882000000b00241d21d4652sm4163549wrp.21.2022.12.14.15.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 15:55:19 -0800 (PST)
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
Subject: [PATCH v7 08/11] leds: trigger: netdev: add available mode sysfs attr
Date:   Thu, 15 Dec 2022 00:54:35 +0100
Message-Id: <20221214235438.30271-9-ansuelsmth@gmail.com>
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

Add avaiable_mode sysfs attr to show and give some details about the
supported modes and how they can be handled by the trigger.
This is in preparation for hardware only modes that doesn't support
software fallback.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 32 +++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index a471e0cde836..3a3b77bb41fb 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -33,6 +33,8 @@
  *         (has carrier) or not
  * tx -  LED blinks on transmitted data
  * rx -  LED blinks on receive data
+ * available_mode - Display available mode and how they can be handled
+ *                  by the LED
  *
  */
 
@@ -370,12 +372,42 @@ static ssize_t interval_store(struct device *dev,
 
 static DEVICE_ATTR_RW(interval);
 
+static ssize_t available_mode_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
+	struct netdev_led_attr_detail *detail;
+	int i, len = 0;
+
+	for (i = 0; i < ARRAY_SIZE(attr_details); i++) {
+		detail = &attr_details[i];
+
+		if (led_trigger_blink_mode_is_supported(trigger_data->led_cdev, detail->bit)) {
+			if (!trigger_data->net_dev) {
+				if (detail->hardware_only)
+					len += sprintf(buf + len, "%s [hardware]\n",
+						       detail->name);
+				else
+					len += sprintf(buf + len, "%s [software-hardware]\n",
+						       detail->name);
+			}
+		} else {
+			len += sprintf(buf + len, "%s [software]\n", detail->name);
+		}
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
2.37.2

