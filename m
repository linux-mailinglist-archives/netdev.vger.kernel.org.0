Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05C06EFE78
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242927AbjD0ATL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242838AbjD0ATB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:19:01 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704D33AA4;
        Wed, 26 Apr 2023 17:19:00 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-304935cc79bso2319355f8f.2;
        Wed, 26 Apr 2023 17:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682554739; x=1685146739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OIYgyKuwJ81AtZBMq4tmKJvwseDK3tdRGQbYOLsgLaU=;
        b=FNrRHJ0CJc/JgCz6dzu63p8tEJuFeVraat6eKkWBCSpEn+CoNPs8GwOh7FEnXrz6O+
         IFr/z44PHwDIcubxHV8A33yhPHrLrCrE+DM1OeTspj5frHImfD9d2Ql5hI9qI92O9XtR
         lYuaxiK3Wix7uw9GIzRzhJNvzgO3j8AdWkYl1U+DYpx+2dfWSaMnWFWMpWnfon8P8N5o
         +8a4D6EgxHufaMOEcA9h0ZggMZ9sIYuldb002HUfvc7MBU9SDZzXYfrJtTQaBObF5Tw2
         6d6JqvfpJVFDvrGN9VSBNiwIcAiqq2apsQuDQqe05B35ao8OIUhZ1kcbDUUz4Q8j+rHn
         Y86g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682554739; x=1685146739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OIYgyKuwJ81AtZBMq4tmKJvwseDK3tdRGQbYOLsgLaU=;
        b=RSC1Nxde7Ab9zYICq4p65Jj6KhOwC/ESLEK1609b1Y1eFRMO6xa1jVwc1DXTPLbRN0
         +eY5WG1Rl6yEmQ4si+9lMu1B1h0ZSjXA921nfEZtipGtB+AuLG8VuZRg2+TkINT5p8sV
         PySLNG33clMpOmLEmhvxromII7YHWbUUebIjzCYLSdt7pZsjCWbwQ5VmH9pz8AZpoxQG
         c41GteY5aT7uMPud4F6Zsr7QCeNJEr/+9kZVzw+jrcJose0rxgg/xvKLNpKZW5fNekL7
         n665lSrY7dntc1g6jyS6iqwy9ml9nMzYPj3ss/nzPzBPmg8FPsUcO6BKIli5wrj0Bsso
         bRhQ==
X-Gm-Message-State: AAQBX9fs+UUbOaeWOS1hCyO+/U5pGjDaJXEbAH2fXvWEesNVqOwvZEJ3
        YgUO6zonEqUdyR4EC4XHAgCtEnlhar4=
X-Google-Smtp-Source: AKy350YguoO64iuBT7gwcB9I2x9HOcGE8lI0Yxmk1eIsZ6Z8JsEtzxCo55nMUg5XkeXSk9FSKiEGNQ==
X-Received: by 2002:adf:dd8b:0:b0:2fe:605e:c77a with SMTP id x11-20020adfdd8b000000b002fe605ec77amr18006477wrl.52.1682554738696;
        Wed, 26 Apr 2023 17:18:58 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id r3-20020adfda43000000b003047ae72b14sm8624916wrl.82.2023.04.26.17.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 17:18:58 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Lee Jones <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 05/11] leds: trigger: netdev: introduce validating requested mode
Date:   Thu, 27 Apr 2023 02:15:35 +0200
Message-Id: <20230427001541.18704-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230427001541.18704-1-ansuelsmth@gmail.com>
References: <20230427001541.18704-1-ansuelsmth@gmail.com>
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

Introduce function to validate the requested mode in preparation for
hw control support. Currently everything is handled in software so
every mode is validated and accepted.

Requested mode are always validated before making any change, to follow
this rework the attr_store function to set the mode to a temp variable
and then apply the new mode only if accepted and validated.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 115f2bae9eee..81e0b0083f2f 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -91,6 +91,12 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	}
 }
 
+static int validate_requested_mode(struct led_netdev_data *trigger_data,
+				   unsigned long mode)
+{
+	return 0;
+}
+
 static ssize_t device_name_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -168,7 +174,7 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 				     size_t size, enum led_trigger_netdev_modes attr)
 {
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
-	unsigned long state;
+	unsigned long state, new_mode = trigger_data->mode;
 	int ret;
 	int bit;
 
@@ -186,12 +192,18 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 		return -EINVAL;
 	}
 
-	cancel_delayed_work_sync(&trigger_data->work);
-
 	if (state)
-		set_bit(bit, &trigger_data->mode);
+		set_bit(bit, &new_mode);
 	else
-		clear_bit(bit, &trigger_data->mode);
+		clear_bit(bit, &new_mode);
+
+	ret = validate_requested_mode(trigger_data, new_mode);
+	if (ret)
+		return ret;
+
+	cancel_delayed_work_sync(&trigger_data->work);
+
+	trigger_data->mode = new_mode;
 
 	set_baseline_state(trigger_data);
 
-- 
2.39.2

