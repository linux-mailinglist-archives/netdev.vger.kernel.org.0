Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803186EFE5F
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242858AbjD0ATE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242677AbjD0AS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:18:59 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B26410FC;
        Wed, 26 Apr 2023 17:18:58 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f182d745deso77781325e9.0;
        Wed, 26 Apr 2023 17:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682554736; x=1685146736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6nCO0bAV1fl1UMAb2NU6tG7bDtFqxmTJnKdetZK7lbg=;
        b=XeDD7IELGyQlMswgdeBLKCzRuckgJrekb3X9gp2H0BY+aAMuRtMUxYKxjrgbspI88p
         0r/KrE8wX6wMWz27KUzQKCKVPkQJEN28w0Ap182fB7OqpOcdOiFD2zzdr3hIPqnbsZxP
         nvjHANtjPoqFOm0+tX2dRijCKWwf459l5AeH+GeQD+WNPfvxgndyWq63j9DejVj7O8Eq
         BF9/OLmMktpRbsmX0Kez0ozmbuJhgdS5Y0nKq+6DUxYeq8NSEWDArOG+AAynVuWt3WuS
         wFySdLWvZMsrb8D6TX9xz2NtNPtgyJ0hH9mXRtIzpqqS46IgwNz9zS6I9LGCsECzzmVF
         CRow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682554736; x=1685146736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6nCO0bAV1fl1UMAb2NU6tG7bDtFqxmTJnKdetZK7lbg=;
        b=jt1+cAkqv/68TpkAea3tpiCy78neL42G1JLno9isbUvrwHKvh1DJloSIMdIBq6ajtp
         9XQuSHjOQQP0fuJgBBFPkpQRxMTZOWxaBhIFmVxU1wJ0NTzb+76a0eds8JaCHQSYQOac
         mC+7x5109C0G8ZsP8PC9PXaMJPrdXd3Dv1lX+7HJ/kCAXxLqTKZgdUR6GY+na9fg+b5F
         8y729Z3W/ZQiFYmRLPAOuf01pqCfC9vsI349+3UXPdeUkMQU4i3Xbxx/LYIwKP36k0oh
         HbpMIZ92IehXUX+rcXCwnRF1ulNX+ReVY3hQpaczousrXzaKusx8BDHHQbpAkTj1UirC
         oN6Q==
X-Gm-Message-State: AAQBX9dNt9Z+zyDAawFxHuxZsUiVPdudSKyaDD/3BVQkQV5bLWrIKx/k
        WmpXFpo6c46tdXWHdALWFUE=
X-Google-Smtp-Source: AKy350Y3aQuv6BQ2YZjrckCx9etJKg4rHfc/tTYUbFUfH0Er4GmlaRqBspc0TDYvShtx1kVpIXkRFQ==
X-Received: by 2002:a1c:4b1a:0:b0:3f0:9f44:c7ce with SMTP id y26-20020a1c4b1a000000b003f09f44c7cemr15091924wma.22.1682554736466;
        Wed, 26 Apr 2023 17:18:56 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id r3-20020adfda43000000b003047ae72b14sm8624916wrl.82.2023.04.26.17.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 17:18:56 -0700 (PDT)
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
Subject: [PATCH 03/11] leds: add helper function to use trigger in hw blink mode
Date:   Thu, 27 Apr 2023 02:15:33 +0200
Message-Id: <20230427001541.18704-4-ansuelsmth@gmail.com>
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

Add helper function to use trigger in hw blink mode.

Add function led_trigger_can_hw_control() that will check if hw_control
ops are defined and if the current trigger match the one supported for
hw_control.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 include/linux/leds.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index 06a67c62ed6e..b9152bff3a96 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -425,6 +425,14 @@ void led_trigger_blink_oneshot(struct led_trigger *trigger,
 void led_trigger_set_default(struct led_classdev *led_cdev);
 int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger);
 void led_trigger_remove(struct led_classdev *led_cdev);
+static inline bool led_trigger_can_hw_control(struct led_classdev *led_cdev)
+{
+	if (!led_cdev->hw_control_get || !led_cdev->hw_control_set ||
+	    !led_cdev->hw_control_is_supported)
+		return false;
+
+	return !strcmp(led_cdev->hw_control_trigger, led_cdev->trigger->name);
+}
 
 static inline void led_set_trigger_data(struct led_classdev *led_cdev,
 					void *trigger_data)
-- 
2.39.2

