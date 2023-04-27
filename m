Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437C36EFE58
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242957AbjD0ATN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242865AbjD0ATI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:19:08 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD55240CC;
        Wed, 26 Apr 2023 17:19:01 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-2f3fe12de15so4802692f8f.3;
        Wed, 26 Apr 2023 17:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682554740; x=1685146740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3erF+RQHrb/sgzGgqnLNu3kV+pj1N6QGpP0Z+KGtn1g=;
        b=SYVBeBp7NgMvzIAh/sYvJ6Rk62fQC2Fj2uzxY+gzSmug1Aab6+SdQ+9kr6EmkUTAhK
         5V0NjtjXr/pW49+Yx5CUQ2LrSKChq+0fjECw9IX+n3huTXjlONH7LLbMJZ7JUiQIwGj/
         2m3lFxfSTtK8lo307xZFq3wRR3wi8EqMGk562z0FhI9WN7Py7M1gajeqgTN4+dJUh2Bv
         T8Q1sIKij6vZWmoo8luvLxxuy75qkMDye5HFgbVNdHQv2sNY0qaZvjrEt/6NhA/jEbfI
         pLAzHULAKQxfnIZFou/+eUnDglveHUSPsGsj0IaPREKYELbDvOsz5QGxQvTPgNvbClSk
         3xSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682554740; x=1685146740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3erF+RQHrb/sgzGgqnLNu3kV+pj1N6QGpP0Z+KGtn1g=;
        b=bK5Xf4lVezLPKurzJXkJ5AoNV+ClFvYTyhBhuu0CPK4QiYA6k7TM9kBjy1vA42ocUL
         mucR86nDRZO7cBKBHjW/bYLWF+3RWTemNnSbw4TD0CvwGa7WldOanF/TTOdiPDZHDBJ1
         4A4UxFL9xsAWvdCCook8Dah992h30q0mlA4oAEoFT3Iscpt2+lI/cPULMIe0w3u8Gk3l
         muRKO8aSz43FgPPzCTeTtpXzv0cCysuUSDMF1XcEoZp6rsqJtumEMNtV24qi8nSLSAL0
         FLp36jwRx365g6BO5OrkMsUM0++gfO/lAq+x25Yf7b1IVwRlWD7Cxyyu28ZwVIRArihy
         Airg==
X-Gm-Message-State: AAQBX9ftGUDXFGX0kbR0zeL1ylbICnkN17lJGzBKdXMQKIWaZ8Si7NH+
        IysbB2xukqrUOEl7wBS1S9g=
X-Google-Smtp-Source: AKy350YktU7STFc0Y2dEuiSm9vuhvdVHXM3Fegegp+iHh9zvYWYs2B0O5eTaEvmfBLBteG9nlJ15og==
X-Received: by 2002:adf:ec46:0:b0:2ce:9fb8:b560 with SMTP id w6-20020adfec46000000b002ce9fb8b560mr16167448wrn.8.1682554739808;
        Wed, 26 Apr 2023 17:18:59 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id r3-20020adfda43000000b003047ae72b14sm8624916wrl.82.2023.04.26.17.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 17:18:59 -0700 (PDT)
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
Subject: [PATCH 06/11] leds: trigger: netdev: add knob to set hw control possible
Date:   Thu, 27 Apr 2023 02:15:36 +0200
Message-Id: <20230427001541.18704-7-ansuelsmth@gmail.com>
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

Add knob with the new value hw_control in trigger_data struct to
set hw control possible. Useful for future implementation to implement
in set_baseline_state() the required function to set the requested mode
using LEDs hw control ops and in other function to reject set if hw
control is currently active.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 81e0b0083f2f..28c4465a2584 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -51,6 +51,7 @@ struct led_netdev_data {
 
 	unsigned long mode;
 	bool carrier_link_up;
+	bool hw_control;
 };
 
 enum led_trigger_netdev_modes {
@@ -92,7 +93,7 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 }
 
 static int validate_requested_mode(struct led_netdev_data *trigger_data,
-				   unsigned long mode)
+				   unsigned long mode, bool *can_use_hw_control)
 {
 	return 0;
 }
@@ -175,6 +176,7 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 {
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
 	unsigned long state, new_mode = trigger_data->mode;
+	bool can_use_hw_control = false;
 	int ret;
 	int bit;
 
@@ -197,13 +199,15 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 	else
 		clear_bit(bit, &new_mode);
 
-	ret = validate_requested_mode(trigger_data, new_mode);
+	ret = validate_requested_mode(trigger_data, new_mode,
+				      &can_use_hw_control);
 	if (ret)
 		return ret;
 
 	cancel_delayed_work_sync(&trigger_data->work);
 
 	trigger_data->mode = new_mode;
+	trigger_data->hw_control = can_use_hw_control;
 
 	set_baseline_state(trigger_data);
 
-- 
2.39.2

