Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D7C6EFE62
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242850AbjD0ATD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242695AbjD0AS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:18:58 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC281FF2;
        Wed, 26 Apr 2023 17:18:56 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f19afc4fbfso56907385e9.2;
        Wed, 26 Apr 2023 17:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682554735; x=1685146735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JQLN6Kj8zf+yGWqAeSf/98ml910O+iserPB9frhTCgU=;
        b=ZxmP0RZFi4wMigwJWtc/nxrVk03RlZrZUK6UxenwjvgVKTjL8VtwM/ogBugNWIpEof
         +HTu40HqRdzq9cFXPdFhH3ZaKi5Jt17Mueer0n0IfvriF5JxMajyh1YC+5Ol9wST+5X1
         RNMNxZQreigdZHUJmG1SXPJXyj+GDu6+9yTF8wpJ5XojuY4GeHbDVRJDjjVRwJkrlfGy
         DJNaaMgnDa9pr3JPRibdqcTBgCVoJhRpub/uMt8X1NcgSG1lTt5S07hwpY+EeG2Ef/0q
         PzaP8F3OJzSF2pzE/96eben9nfCchHQiOFRVS4tEA5eOhX3MfqpkMM/EkG2ACQP/d4jB
         J2gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682554735; x=1685146735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JQLN6Kj8zf+yGWqAeSf/98ml910O+iserPB9frhTCgU=;
        b=F35+3Tg733LvU++9BWafCxa/tYI893LPAafR46t4tf+g4/6hwbKdNrTtsMKwHKnVHf
         O0fWQOF0FjrShpRwCvdLWyPXoccdFo58yYiLVg5zMLwUo7RlY5M51HufuQEnrLn82TC6
         PYE9G5oK36jIMpMTaYldWTIq5TJ9A1XUrlwgQXozPPxm5POhE6lPqY9z+CETWEYI+6nZ
         1Q2akJLPLZYMc9BNvwlBKvAfsEl+CcPAs1jxL58Al6hGGK9cW3MOBOCBE/qiW2NWDlRt
         a+rDyjeAD8nmnWJRQIsXIct7VR7PdphRz01t3Ra4hHSODRZAKbY+jAXzJhW1V5bbRTTc
         9brg==
X-Gm-Message-State: AAQBX9f+RF8pA9XGKJgj6zVRt7qV+jtTFSZ3KBeAvyfv68X8R1v1win9
        9KLFpoPVXmUAbBrmhNXhiyI=
X-Google-Smtp-Source: AKy350Zwg/vVucdRJNBBseuh/duo9cKFNzZMJasEMQZW40wYwmJ6JygbjRhM5FoG4SfYgrloarMe1A==
X-Received: by 2002:a5d:670e:0:b0:2de:e7c3:166f with SMTP id o14-20020a5d670e000000b002dee7c3166fmr15117006wru.62.1682554735382;
        Wed, 26 Apr 2023 17:18:55 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id r3-20020adfda43000000b003047ae72b14sm8624916wrl.82.2023.04.26.17.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 17:18:54 -0700 (PDT)
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
Subject: [PATCH 02/11] leds: add binding to check support for LED hw control
Date:   Thu, 27 Apr 2023 02:15:32 +0200
Message-Id: <20230427001541.18704-3-ansuelsmth@gmail.com>
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

Add 2 binding to facilitate checking support for LED hw control.

Add a mask for the LED driver to declare support for specific modes of
the defined hw control trigger.

Add hw_control_is_supported() to ask the LED driver if the requested
mode by the trigger are supported and the LED can be setup to follow
the requested modes.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 include/linux/leds.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index b3bd1cc8ace8..06a67c62ed6e 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -157,6 +157,8 @@ struct led_classdev {
 
 	/* Unique trigger name supported by LED set in hw control mode */
 	const char		*hw_control_trigger;
+	/* Mask of the different supported trigger mode in hw control mode */
+	unsigned long		trigger_supported_flags_mask;
 	/*
 	 * Activate hardware control, LED driver will use the provided flags
 	 * from the supported trigger and setup the LED to be driven by hardware
@@ -174,6 +176,12 @@ struct led_classdev {
 	 */
 	int			(*hw_control_get)(struct led_classdev *led_cdev,
 						  unsigned long *flags);
+	/*
+	 * Check if the LED driver supports the requested mode provided by the
+	 * defined supported trigger to setup the LED to hw control mode.
+	 */
+	int			(*hw_control_is_supported)(struct led_classdev *led_cdev,
+							   unsigned long flags);
 #endif
 
 #ifdef CONFIG_LEDS_BRIGHTNESS_HW_CHANGED
-- 
2.39.2

