Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67640518864
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238211AbiECPYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238158AbiECPWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:22:06 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF2F3B032;
        Tue,  3 May 2022 08:18:26 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g23so20213828edy.13;
        Tue, 03 May 2022 08:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=tVF3JHqeXvWfPLghH28nep5cSv0CTb1UsfiA1XgSFqA=;
        b=UDMJD0kZwKXiiM59N3ej5G5K8KwypCLOpZ4d0p571avKyESowbM9YRnpenSxJfPhI1
         6iOSQ/kl+Yhj3Mf8rlOOo02e0SoTZU6fLV92ZKau6wxltvtLyRiRNAWxV2qiAEu5pjbd
         Oz4nt1uYTYs4B5zWxHgbqzAxsTBftRj4lFZpeH0Xgtziy99bBxQGKqz9NxnooQ4jaiDB
         ZuQWc49SPJwTJfK10JgBhuguy9QIwkXIj2dgjfWMDv+eBP5GMIl875NAe3FMjXMOezjj
         VYsKM0sakh5EQaxtSf7ILRTD61WZJ14bDOjrFFxqdgbSTvEbhTB6OG58t3Tck8v4t3kU
         EOyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tVF3JHqeXvWfPLghH28nep5cSv0CTb1UsfiA1XgSFqA=;
        b=4PIi6u8fpZEjY/Jv9BbvHFVNxpHpV7VNK4S6vGjGZP8jn1RQEBoPXxTXg0DKk+C4uk
         CHBKeQTz2kHlVCl8lVZrht+9NkMKw8oGd2WCyyf2bRtUUvjEMYaRSUqxgly22Dn33jsi
         oPHpRSXzx7IiIU+cuQPJumV9mJjMWXXzHpRDRWQplH/I66HcxIFKwDwHaeozvWw5w39x
         G7YrRZD79xSvncBH3KFl0KaRymu4dMwIQKcHhd5HvylG9l06/cdOi7kNQ/Q3EQmmNtuo
         hdk1wt3OkPOY9ozQTmRdXHrb7rNmpHXA+IcGbvOWsElV2nIvmFTP23+3cOUUS/+Dswih
         KUTw==
X-Gm-Message-State: AOAM532PS4skwS/ljspvspxsq0KsQ42SM4TT8/LuAdDHO2+fENwAvFXJ
        u4dQiek9dkLCuJmw5lM2QBA=
X-Google-Smtp-Source: ABdhPJy7Y3NgLHFdEkhOkHD0ngHN0R8VghkVSF2eeoJcxy+lqIB0V3jpm7ftlNWzB/jQW3ars9gXDg==
X-Received: by 2002:aa7:d350:0:b0:425:e029:da56 with SMTP id m16-20020aa7d350000000b00425e029da56mr18644619edr.296.1651591105246;
        Tue, 03 May 2022 08:18:25 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id v3-20020aa7d9c3000000b0042617ba63cesm7947507eds.88.2022.05.03.08.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 08:18:24 -0700 (PDT)
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
Subject: [RFC PATCH v6 08/11] leds: trigger: netdev: add available mode sysfs attr
Date:   Tue,  3 May 2022 17:16:30 +0200
Message-Id: <20220503151633.18760-9-ansuelsmth@gmail.com>
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

Add avaiable_mode sysfs attr to show and give some details about the
supported modes and how they can be handled by the trigger.
This is in preparation for hardware only modes that doesn't support
software fallback.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 32 +++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index a471e0cde836..d88b0c6a910e 100644
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
+				      struct device_attribute *attr, char *buf)
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
+					len += sprintf(buf+len, "%s [hardware]\n",
+						       detail->name);
+				else
+					len += sprintf(buf+len, "%s [software-hardware]\n",
+						       detail->name);
+			}
+		} else {
+			len += sprintf(buf+len, "%s [software]\n", detail->name);
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
2.34.1

