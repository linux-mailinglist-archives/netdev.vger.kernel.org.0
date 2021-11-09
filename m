Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AAB44A4A4
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 03:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241673AbhKIC3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 21:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240594AbhKIC3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 21:29:04 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E77C061208;
        Mon,  8 Nov 2021 18:26:17 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id f8so70626372edy.4;
        Mon, 08 Nov 2021 18:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=iCOwN/z7D6ASI5Jgro5XbNNvlehxYiy9qRTyoHFyqjk=;
        b=SzgaquJqCaDhGcImUczGL5CsmfHGiynMg1n4wGvq2D77C0Ja6U5+6/JqQvDFadyiT7
         9NvJ33hyjQRp/NUd4KO1RDptI6oVXqr72H4dV4a25DQkpvmkJLFXRtCw3FADI/idj4/u
         rtoTsy05Hv6SSUkQbbrdPGSdJmPX2lGDFFYfhW/Ny4wsuW/c2pWZ3HKiH36J7Mydz9tP
         SEWqb9Rg2VXpO7fOVmgxp6FQ0B8Trkjkvf8dRnQ56t5+O44Ms/PhX6lh0ONxA47LMR32
         1rB3J+vqw7oOhNOBTXyFeLMndopm3VoDsIQ2DVaRQLT1dfov3C/qvzFvl+7rPnnT4IOy
         pkUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iCOwN/z7D6ASI5Jgro5XbNNvlehxYiy9qRTyoHFyqjk=;
        b=G06zSnqAQIvJKUkdsw7Xxs9Z++luz5qZ+hIWUkMFQ+8z+Jw47JULC6ILlN04AgE0w4
         XighjAOL1H+HIO3dNbjQlfOkPhs9Y2FDr56thFUtHORdga8Sp1pqXGzDvEdUfg/VKcPx
         O9vPr/PAB+Hw5dONoshb4NMuevDlgTgtSOGasXtLQ+wGZd28BfmpGRcqbSXZz8BUrzHr
         sDy1bJgpYgpuRHFjH+Tyj9GZMcKihql0NGP4n3C7Eus6zv2YfW+gRtLVLomhwaF0OH2N
         FH3Cd5h/wurHj6C5WIlCXUhRFdyBSdygwXPNhoM35vlSXqGECquWywbnjlKzDF0nrwF7
         ELRw==
X-Gm-Message-State: AOAM531hPUtw+6iPyMfN0QTgojf3G1P4W7eeohr4ES622dSfZJXZTuCa
        jEKmG+GG8D3AvV1i2QV1qG8=
X-Google-Smtp-Source: ABdhPJzhCC7SxqTTpWjZV9Rxo/GgUWgb1WvSUJz5npTfjiTl+on8yoIemJy2jJlwO+ciCYtjxzUC/g==
X-Received: by 2002:a05:6402:1a51:: with SMTP id bf17mr5156773edb.253.1636424776106;
        Mon, 08 Nov 2021 18:26:16 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m5sm8760900ejc.62.2021.11.08.18.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 18:26:15 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [RFC PATCH v3 2/8] leds: add function to configure hardware controlled LED
Date:   Tue,  9 Nov 2021 03:26:02 +0100
Message-Id: <20211109022608.11109-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211109022608.11109-1-ansuelsmth@gmail.com>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add hw_control_configure helper to configure how the LED should work in
hardware mode. The function require to support the particular trigger and
will use the passed flag to elaborate the data and apply the
correct configuration. This function will then be used by the trigger to
request and update hardware configuration.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/leds/leds-class.rst | 25 ++++++++++++++++++++
 include/linux/leds.h              | 39 +++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
index 645940b78d81..efd2f68c46a7 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -198,6 +198,31 @@ With HARDWARE_CONTROLLED blink_mode hw_control_status/start/stop is optional
 and any software only trigger will reject activation as the LED supports only
 hardware mode.
 
+A trigger once he declared support for hardware controlled blinks, will use the function
+hw_control_configure() provided by the driver to check support for a particular blink mode.
+This function passes as the first argument (flag) a u32 flag.
+The second argument (cmd) of hw_control_configure() method can be used to do various
+operations for the specific blink mode. We currently support ENABLE, DISABLE, READ, ZERO
+and SUPPORTED to enable, disable, read the state of the blink mode, ask the LED
+driver if it does supports the specific blink mode and to reset any blink mode active.
+
+In ENABLE/DISABLE hw_control_configure() should configure the LED to enable/disable the
+requested blink mode (flag).
+In READ hw_control_configure() should return 0 or 1 based on the status of the requested
+blink mode (flag).
+In SUPPORTED hw_control_configure() should return 0 or 1 if the LED driver supports the
+requested blink mode (flags) or not.
+In ZERO hw_control_configure() should return 0 with success operation or error.
+
+The unsigned long flag is specific to the trigger and change across them. It's in the LED
+driver interest know how to elaborate this flag and to declare support for a
+particular trigger. For this exact reason explicit support for the specific
+trigger is mandatory or the driver returns -EOPNOTSUPP if asked to enter offload mode
+with a not supported trigger.
+If the driver returns -EOPNOTSUPP on hw_control_configure(), the trigger activation will
+fail as the driver doesn't support that specific offload trigger or doesn't know
+how to handle the provided flags.
+
 Known Issues
 ============
 
diff --git a/include/linux/leds.h b/include/linux/leds.h
index cf0c6005c297..00bc4d6ed7ca 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -73,6 +73,16 @@ enum led_blink_modes {
 	SOFTWARE_HARDWARE_CONTROLLED,
 };
 
+#ifdef CONFIG_LEDS_HARDWARE_CONTROL
+enum blink_mode_cmd {
+	BLINK_MODE_ENABLE, /* Enable the hardware blink mode */
+	BLINK_MODE_DISABLE, /* Disable the hardware blink mode */
+	BLINK_MODE_READ, /* Read the status of the hardware blink mode */
+	BLINK_MODE_SUPPORTED, /* Ask the driver if the hardware blink mode is supported */
+	BLINK_MODE_ZERO, /* Disable any hardware blink active */
+};
+#endif
+
 struct led_classdev {
 	const char		*name;
 	unsigned int brightness;
@@ -185,6 +195,17 @@ struct led_classdev {
 	 * the old status but that is not mandatory and also putting it off is accepted.
 	 */
 	int			(*hw_control_stop)(struct led_classdev *led_cdev);
+	/* This will be used to configure the various blink modes LED support in hardware
+	 * mode.
+	 * The LED driver require to support the active trigger and will elaborate the
+	 * unsigned long flag and do the operation based on the provided cmd.
+	 * Current operation are enable,disable,supported and status.
+	 * A trigger will use this to enable or disable the asked blink mode, check the
+	 * status of the blink mode or ask if the blink mode can run in hardware mode.
+	 */
+	int			(*hw_control_configure)(struct led_classdev *led_cdev,
+							unsigned long flag,
+							enum blink_mode_cmd cmd);
 #endif
 #endif
 
@@ -454,6 +475,24 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 	return led_cdev->trigger_data;
 }
 
+#ifdef CONFIG_LEDS_HARDWARE_CONTROL
+static inline bool led_trigger_blink_mode_is_supported(struct led_classdev *led_cdev,
+						       unsigned long flag)
+{
+	int ret;
+
+	/* Sanity check: make sure led support hw mode */
+	if (led_cdev->blink_mode == SOFTWARE_CONTROLLED)
+		return false;
+
+	ret = led_cdev->hw_control_configure(led_cdev, flag, BLINK_MODE_SUPPORTED);
+	if (ret > 0)
+		return true;
+
+	return false;
+}
+#endif
+
 /**
  * led_trigger_rename_static - rename a trigger
  * @name: the new trigger name
-- 
2.32.0

