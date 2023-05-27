Return-Path: <netdev+bounces-5876-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9168713452
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:29:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FC6A1C209BE
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 11:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E3A8D52C;
	Sat, 27 May 2023 11:29:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C30C2DE
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 11:29:19 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED80EC;
	Sat, 27 May 2023 04:29:17 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f6e72a1464so11282895e9.1;
        Sat, 27 May 2023 04:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685186956; x=1687778956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cKIEgFgmjScZJvZv6lwQPPIWSzDEZLIyZZgdXEW7tPM=;
        b=Qm7mtFvwyOtLsXMIBBdsJUUvDcTdhgqd7uvMQvrFYKE+PN5lndQuLSUSG3eNRNNcrl
         KYrI706mvURTxKfjsRzxAQ1XnSO6uKcOtiCvoLCbS8gZgPYA16FfQBoNFSTbHZcTlARs
         Hj/yKs8+BF/hkg02+3kNfu+ekWKXIA9DZKzDALjWAjV9k0Hn/zKowW5rgiGaNdqResMu
         +nMzJ5lSBWSrgo+KLd5ZckJuUnBPkXmgh9E6OjkboGwvOboQ7lwoyGedWUDBDiRfYG7m
         TwO68GP7st33FwoiMdbcJLjczZW6dT/odDu3MTtpBFsxmPA7lTPmP5p+QGVMDs2wgBMN
         JfDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685186956; x=1687778956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cKIEgFgmjScZJvZv6lwQPPIWSzDEZLIyZZgdXEW7tPM=;
        b=MkPcWJ8jNMAW6NsPpEPEpc9i3wyuF74Jmjju3PL/6PYszVx7jq55A9Pekv5XqGK/jp
         DUAoXsdTORSU8+q+D/q0nduSylRMZVpK8fcHANuO9BCacKo1pX8EnpesI7SYY3yjA85u
         qMlyDRoOHYPVK19JVhPuL2XJMx7EF8oPZAERK9RbSkIB4ROBuTl6zVvvBlOpCNzpUW1q
         TuEv8oIKu9SNL30RXQwFpxlsoMIUuh/ouDm91rJ2i2SR1qFjElaBKMewONgEhd/6Z+pv
         m2rqOUD49bn5T1Psp9/1yYXctkDeXspHiyo1PbrI2mUygkumGLDgc4iLa/DfdI8a86Wv
         HcPQ==
X-Gm-Message-State: AC+VfDwaQ10+f9dZFpPSvGydkCjSr9y0u3PaS2QG4P+dmG6jLLqZxGoe
	uv/43E1aFEMcIMwc0Q2dFs0=
X-Google-Smtp-Source: ACHHUZ7o1wkUaLli52LDfkiyqcqaayfOslQnq6OTbtulevqOtcaRNvN2RNEo5wvbWH7Ls3yp8J6Mig==
X-Received: by 2002:a7b:c853:0:b0:3f4:239c:f19 with SMTP id c19-20020a7bc853000000b003f4239c0f19mr3880291wml.36.1685186955862;
        Sat, 27 May 2023 04:29:15 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id q13-20020a7bce8d000000b003f43f82001asm11711000wmj.31.2023.05.27.04.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 04:29:15 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	linux-leds@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [net-next PATCH v3 01/13] leds: add APIs for LEDs hw control
Date: Sat, 27 May 2023 13:28:42 +0200
Message-Id: <20230527112854.2366-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230527112854.2366-1-ansuelsmth@gmail.com>
References: <20230527112854.2366-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add an option to permit LED driver to declare support for a specific
trigger to use hw control and setup the LED to blink based on specific
provided modes.

Add APIs for LEDs hw control. These functions will be used to activate
hardware control where a LED will use the provided flags, from an
unique defined supported trigger, to setup the LED to be driven by
hardware.

Add hw_control_is_supported() to ask the LED driver if the requested
mode by the trigger are supported and the LED can be setup to follow
the requested modes.

Deactivate hardware blink control by setting brightness to LED_OFF via
the brightness_set() callback.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 include/linux/leds.h | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index c39bbf17a25b..4caf559b1922 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -183,6 +183,43 @@ struct led_classdev {
 
 	/* LEDs that have private triggers have this set */
 	struct led_hw_trigger_type	*trigger_type;
+
+	/* Unique trigger name supported by LED set in hw control mode */
+	const char		*hw_control_trigger;
+	/*
+	 * Check if the LED driver supports the requested mode provided by the
+	 * defined supported trigger to setup the LED to hw control mode.
+	 *
+	 * Return 0 on success. Return -EOPNOTSUPP when the passed flags are not
+	 * supported and software fallback needs to be used.
+	 * Return a negative error number on any other case  for check fail due
+	 * to various reason like device not ready or timeouts.
+	 */
+	int			(*hw_control_is_supported)(struct led_classdev *led_cdev,
+							   unsigned long flags);
+	/*
+	 * Activate hardware control, LED driver will use the provided flags
+	 * from the supported trigger and setup the LED to be driven by hardware
+	 * following the requested mode from the trigger flags.
+	 * Deactivate hardware blink control by setting brightness to LED_OFF via
+	 * the brightness_set() callback.
+	 *
+	 * Return 0 on success, a negative error number on flags apply fail.
+	 */
+	int			(*hw_control_set)(struct led_classdev *led_cdev,
+						  unsigned long flags);
+	/*
+	 * Get from the LED driver the current mode that the LED is set in hw
+	 * control mode and put them in flags.
+	 * Trigger can use this to get the initial state of a LED already set in
+	 * hardware blink control.
+	 *
+	 * Return 0 on success, a negative error number on failing parsing the
+	 * initial mode. Error from this function is NOT FATAL as the device
+	 * may be in a not supported initial state by the attached LED trigger.
+	 */
+	int			(*hw_control_get)(struct led_classdev *led_cdev,
+						  unsigned long *flags);
 #endif
 
 #ifdef CONFIG_LEDS_BRIGHTNESS_HW_CHANGED
-- 
2.39.2


