Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D5051882D
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238132AbiECPV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238106AbiECPVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:21:51 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B793A5D1;
        Tue,  3 May 2022 08:18:18 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id dk23so34087352ejb.8;
        Tue, 03 May 2022 08:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0NJOjZivHdsEAPSUPe4gZceqMCkKHdM1DQMNmyoIcXA=;
        b=lfIR5fLXlCnaezJxzcYNVgw8KrAyPD9Rs95FJN8IAch5pJH73kVTI8QMl0OFIAG5eB
         2QOY4FbqZYlGQoBriUwsUqKV19PUWUOncdOcFeI373Rbw2E93tzf3Wb1jhYCwT8r9FwW
         eb3aM6Ff+HB62d97wskvIgADClW8JOL+7Qc1ThLH25VyJgCCHPCEz7b+CbPpognNyTrJ
         Z6TfaNKG6k9SVdKEhPzWaO+/zuFvZuqSzZ/1Uh45GedEP360SmodEiMDgnoWV9JbaVAW
         Lb2wN/FFlMXmEkmXZriE/u8v7VeLHSX2X25AOmMLI4RXMLSu+Z569TgAALBnqqt/BKhW
         COFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0NJOjZivHdsEAPSUPe4gZceqMCkKHdM1DQMNmyoIcXA=;
        b=bJuklK09TnE3KTyahHV2wHgkapoJu2lvb/Qm8hKncdD5zr8iTZjRDLx7Jx9VR6802F
         6T7iV5VcdZh4uZYTZOhuoilDBPdj3g34yHoBebC5Yxk9rWOi4+yzR2cL5j7XZMLYw0fQ
         zFSc9xDDRcVE08+lVVFt7B3BYaP452Oi/OPp9N7bUAjK7OGYBV7uurEABQgC4BbyeCby
         pTDP6Rjp5dp5Fuzy3YZa5ipJezj3tSszm1wXkCxJYBGZe1pYzNNXHcQ5M62RPRWzjoLy
         K0LcW+c6eL+Qoy22Hwnl4eo0FbILlp6T5qv4gOLZveqgJ/H0uZErw23+befGjXopRbtL
         O1KQ==
X-Gm-Message-State: AOAM532DrjjnbgDt8WWuuyhp7hSJQkR+7BaJflRT+T7+P3kqHuTTIR3+
        NK6UlbKOSQGN94B3IRndvPs=
X-Google-Smtp-Source: ABdhPJw0y+mKwrYFwFmEnp90BLS+xK7XuBP6Wk4nRuznWG7ZLwCvFq6kCAznYEL5zV8bquR/WYG5yQ==
X-Received: by 2002:a17:907:2ce3:b0:6f3:a4c4:100a with SMTP id hz3-20020a1709072ce300b006f3a4c4100amr16031507ejc.218.1651591097142;
        Tue, 03 May 2022 08:18:17 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id v3-20020aa7d9c3000000b0042617ba63cesm7947507eds.88.2022.05.03.08.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 08:18:16 -0700 (PDT)
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
Subject: [RFC PATCH v6 02/11] leds: add function to configure hardware controlled LED
Date:   Tue,  3 May 2022 17:16:24 +0200
Message-Id: <20220503151633.18760-3-ansuelsmth@gmail.com>
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
index 09ff1dc6f48d..b5aad67fecfb 100644
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
2.34.1

