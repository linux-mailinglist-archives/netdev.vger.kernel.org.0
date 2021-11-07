Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC2D4474C3
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 18:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236051AbhKGSAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 13:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236040AbhKGSAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 13:00:40 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7F4C061570;
        Sun,  7 Nov 2021 09:57:57 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id o8so53301456edc.3;
        Sun, 07 Nov 2021 09:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=VyeZHDdSwGISZyzqOK+B4uXVVUSgq43HQIoWxpUGxj4=;
        b=TnpWk0pFTsLmNk8kJbZWTS7Gy1s6k52LvKPishdlowMQAxNKbwHvJWL1Y5fcDnreuG
         FRtkdNUyEOZqNCOcKWzZJ/iVzVldQt7G3pjpU74H0ohQhYrpnpH5siAV1RO5OCsnt4p6
         s5HEPHne+Z58cPV+Jn43v972a0aObB1OKZ1Ddou6x5jGzWChIKNunRvfocXmA+k+knRg
         4TRnF6oEaFGph/hKRYnw6ScgrlxZeSJEBsDU0W9sa/VVAnpd7BN31bYeO78+o1PqiE8W
         PrgfXp6oynpk1mjHzRRbUCMSLniVq9GKhqoj2vB2z+wA1fjfnOiANLPrwLfrZ4Q186xQ
         OXhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VyeZHDdSwGISZyzqOK+B4uXVVUSgq43HQIoWxpUGxj4=;
        b=Y9pY0Xpnn1/SrSfdi5b5bPTNNTMZ3NSGgiwEjUXKiCL52XT92U5705/wdLYkZF+d6t
         M69vRj9zGqEwe17L+P0h/WQpN9xe8MG+GprMczKSCcZzkLlMT56tE/g4oLvQsmjsWJBR
         7It79IhxhXCWBHNvoZWssoEyJ1fq8sXkzzCNCb9k+PRXLTXKGwWX/bwyrMP+IpONtz3f
         kr5Xj5nPq0az4jJwGN6oCPH/AHvjqd5CDnhbbSGsrHwXmyWaMAnEeb3Jvl342Tvs15tC
         y6e6HNJAGKQN+Fors6r5YWmrDkJMUXq30CItvSreah17Au42PklX8cEesFgYgi69RKuR
         2SCg==
X-Gm-Message-State: AOAM531mfx7FLJStsBA5kFI+OQV/hSA9IwlQGRJ8lghzx6STfhULecbl
        hny4HgJpN5iULjmEZkuLps8=
X-Google-Smtp-Source: ABdhPJzQT+JYP6N1YNinw2ehJD2SgqYt9rYnl596lrJN8LaT7d6yXI3d4ED6iemb7Nzpxr0mGBidkQ==
X-Received: by 2002:a17:906:ecac:: with SMTP id qh12mr31479962ejb.377.1636307876105;
        Sun, 07 Nov 2021 09:57:56 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m11sm4251182edd.58.2021.11.07.09.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 09:57:55 -0800 (PST)
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
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [RFC PATCH 2/6] leds: permit to declare supported offload triggers
Date:   Sun,  7 Nov 2021 18:57:14 +0100
Message-Id: <20211107175718.9151-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211107175718.9151-1-ansuelsmth@gmail.com>
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With LEDs that can be offload driven, permit to declare supported triggers
in the dts and add them to the cled struct to be used by the related
offload trigger. This is particurally useful for phy that have support
for HW blinking on tx/rx traffic or based on the speed link.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/leds/leds-class.rst |  4 ++++
 drivers/leds/led-class.c          | 15 ++++++++++++++-
 include/linux/leds.h              |  5 ++++-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
index 035a738afc4a..ab50b58d6a21 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -191,6 +191,10 @@ If the second argument (enable) to the trigger_offload() method is false, any
 active HW offloading must be deactivated. In this case errors are not permitted
 in the trigger_offload() method.
 
+LEDs can declare the supported offload trigger using linux,supported-offload-triggers
+binding in the dts. This is just an array of string that will be used by any
+offload trigger to check the supported triggers and configure the LED offload mode
+and bheaviour.
 
 Known Issues
 ============
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index f4bb02f6e042..56f75e70b81e 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -339,7 +339,7 @@ int led_classdev_register_ext(struct device *parent,
 	char composed_name[LED_MAX_NAME_SIZE];
 	char final_name[LED_MAX_NAME_SIZE];
 	const char *proposed_name = composed_name;
-	int ret;
+	int count, ret;
 
 	if (init_data) {
 		if (init_data->devname_mandatory && !init_data->devicename) {
@@ -358,6 +358,19 @@ int led_classdev_register_ext(struct device *parent,
 			if (fwnode_property_present(init_data->fwnode,
 						    "retain-state-shutdown"))
 				led_cdev->flags |= LED_RETAIN_AT_SHUTDOWN;
+
+			if (fwnode_property_present(init_data->fwnode,
+						    "linux,supported-offload-triggers")) {
+				count = fwnode_property_string_array_count(
+				    init_data->fwnode, "linux,supported-offload-triggers");
+
+				led_cdev->supported_offload_triggers =
+				    kcalloc(count, sizeof(char *), GFP_KERNEL);
+				fwnode_property_read_string_array(
+				    init_data->fwnode, "linux,supported-offload-triggers",
+				    led_cdev->supported_offload_triggers, count);
+				led_cdev->supported_offload_triggers_count = count;
+			}
 		}
 	} else {
 		proposed_name = led_cdev->name;
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 949ab461287f..ff1f903f8079 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -157,7 +157,10 @@ struct led_classdev {
 
 #ifdef CONFIG_LEDS_OFFLOAD_TRIGGERS
 	int			offloaded;
-	/* some LEDs cne be driven by HW */
+	/* LEDs can have multiple offload triggers */
+	int			supported_offload_triggers_count;
+	const char		**supported_offload_triggers;
+	/* some LEDs may be able to offload some SW triggers to HW */
 	int			(*trigger_offload)(struct led_classdev *led_cdev,
 						   bool enable);
 #endif
-- 
2.32.0

