Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B32D6EFE7A
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242880AbjD0ATR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242890AbjD0ATJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:19:09 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC573C01;
        Wed, 26 Apr 2023 17:19:03 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-3023a56048bso6821559f8f.3;
        Wed, 26 Apr 2023 17:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682554742; x=1685146742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vq88sr+XdxkhlGzkSzosGS5fqAIxTv3rcg/Ss2wQpM8=;
        b=Gl6zqJNxxAydZzsM1MzmRQVBjvXY5Wpc110QWDhnADqo8D3jVd6nym40fagFiKjy6n
         5HWf5ggNKOMPzY5KDRKHBzJLs8UaQUzJDY2qDzRZklCo/uBsjdppE9zIcBrXp+gP4U1C
         uhmLjcaDrPVVfgZZ4lfviphde3zL3Pja4J+mjPVczSk0OYvh4yzHQkA2yoOMkBd8DaRO
         0s0O9/Y3aUxs4llrwX/JU/JRaTJGeuHaAHgifB8Cx4tgTTKW9BaFw64g4rbm00cRYfvV
         p1kG5rH9V0F0c3x0Y3bSaBqEw0RUHXt88W+EzRrY8TIr2o+C/rSa82T08f1PJqgbl3Ps
         wIMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682554742; x=1685146742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vq88sr+XdxkhlGzkSzosGS5fqAIxTv3rcg/Ss2wQpM8=;
        b=EKj3YuuM8kmbT514uH1Halgct5lmPZIllOQy8kIX4Ihdq8PtdkopenFd0XUbaIPlBu
         Wu/0wGmH6iUtTUb9rs0b0yp8ATFDHnf8NRCu4WzC/O0c8zVVRO7BeZcGLrsqEZgdQY5K
         jmIpTJVrXn1iWaY1Lax9TntN/EFCBXTqLcc4uLFbi3x50ReX1zlIRB80TESeHKcAr0qu
         lCK4ZIceo3pr4tuA+KU7fQm/W88CYgSnJS4WNLBEP8UuA1igalnm18M2MPG/dGKd9t1D
         Rnxe0rjGQ7YnfKJZFTmypeIj0TPfuIsDZdJ0MIgtUqYLB7K6Mf1B+QAOU5rU4C8ywhO8
         pfIA==
X-Gm-Message-State: AAQBX9eoR27Kx0LofkaOdlmtYH0h/Z4trXPIlcKqlUf34KuGulnExXng
        YAO9r6jeF+oQIeQc3xNe3ro=
X-Google-Smtp-Source: AKy350akYVShwTgrlmnU7iXi5WHu+nOlGJsQhgLmGlzKB7rexb2/mFBOMoIsTFP7zratCNPqLfLUcw==
X-Received: by 2002:adf:e9d0:0:b0:2ff:6906:7169 with SMTP id l16-20020adfe9d0000000b002ff69067169mr15018930wrn.68.1682554742144;
        Wed, 26 Apr 2023 17:19:02 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id r3-20020adfda43000000b003047ae72b14sm8624916wrl.82.2023.04.26.17.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 17:19:01 -0700 (PDT)
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
Subject: [PATCH 08/11] leds: trigger: netdev: add support for LED hw control
Date:   Thu, 27 Apr 2023 02:15:38 +0200
Message-Id: <20230427001541.18704-9-ansuelsmth@gmail.com>
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

Add support for LED hw control for the netdev trigger.

The trigger on calling set_baseline_state to configure a new mode, will
do various check to verify if hw control can be used for the requested
mode in the validate_requested_mode() function.

It will first check if the LED driver supports hw control for the netdev
trigger, then will check if the requested mode are in the trigger mode
mask and finally will call hw_control_set() to apply the requested mode.

To use such mode, interval MUST be set to the default value and net_dev
MUST be empty. If one of these 2 value are not valid, hw control will
never be used and normal software fallback is used.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 52 +++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 8cd876647a27..61bc19fd0c7a 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -68,6 +68,13 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	int current_brightness;
 	struct led_classdev *led_cdev = trigger_data->led_cdev;
 
+	/* Already validated, hw control is possible with the requested mode */
+	if (trigger_data->hw_control) {
+		led_cdev->hw_control_set(led_cdev, trigger_data->mode);
+
+		return;
+	}
+
 	current_brightness = led_cdev->brightness;
 	if (current_brightness)
 		led_cdev->blink_brightness = current_brightness;
@@ -95,6 +102,51 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 static int validate_requested_mode(struct led_netdev_data *trigger_data,
 				   unsigned long mode, bool *can_use_hw_control)
 {
+	unsigned int interval = atomic_read(&trigger_data->interval);
+	unsigned long hw_supported_mode, hw_mode = 0, sw_mode = 0;
+	struct led_classdev *led_cdev = trigger_data->led_cdev;
+	unsigned long default_interval = msecs_to_jiffies(50);
+	bool force_sw = false;
+	int i, ret;
+
+	hw_supported_mode = led_cdev->trigger_supported_flags_mask;
+
+	/* Check if trigger can use hw control */
+	if (!led_trigger_can_hw_control(led_cdev))
+		force_sw = true;
+
+	/* Compose a list of mode that can run in hw or sw */
+	for (i = 0; i < __TRIGGER_NETDEV_MAX; i++) {
+		/* Skip checking mode not active */
+		if (!test_bit(i, &mode))
+			continue;
+
+		/* net_dev is not supported and must be empty for hw control.
+		 * interval must be set to the default value. Any different
+		 * value is rejected if in hw control.
+		 */
+		if (interval == default_interval && !trigger_data->net_dev &&
+		    !force_sw && test_bit(i, &hw_supported_mode))
+			set_bit(i, &hw_mode);
+		else
+			set_bit(i, &sw_mode);
+	}
+
+	/* We can't run modes handled by both sw and hw */
+	if (sw_mode && hw_mode)
+		return -EINVAL;
+
+	/* Exit early if we are using software fallback */
+	if (sw_mode)
+		return 0;
+
+	/* Check if the requested mode is supported */
+	ret = led_cdev->hw_control_is_supported(led_cdev, hw_mode);
+	if (ret)
+		return ret;
+
+	*can_use_hw_control = true;
+
 	return 0;
 }
 
-- 
2.39.2

