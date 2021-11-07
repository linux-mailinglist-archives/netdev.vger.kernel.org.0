Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283E64474C6
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 18:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236057AbhKGSAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 13:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236050AbhKGSAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 13:00:42 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF7EC061570;
        Sun,  7 Nov 2021 09:57:59 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id ee33so53623767edb.8;
        Sun, 07 Nov 2021 09:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QULGmrTqCLxJGFukNsnY5+P3UKYk27qIk13ZoZ0RKo4=;
        b=m6SHADWhbziTvhHaZ0FeP+dpR4kT/KR7fVqo4gdL9DkEO20Z7csRzLVPdlfqdIBfQg
         TznVC3bOFTKk1+Q2lLgZDDhUHBz2gox7Jt4VWcPqciC9dKZcxh2rZJbA7W7vzvyB2Y+f
         cJvQPdrkSPS/giCPCssx5LFkxvJzDwxN1jCb3lpkuFAavjoCwpNuGaBwB70PsLVWbclW
         HnBw2MO0ZkXwFdhQ8a94ZsRsu9dHgCxTl8MLVI66HE+A2zQHFUAMWzPsV5BryVoRy4GK
         SUZ7bRZefR4ocnmrASCAzGuOW9lXD05n0BI4wKjF+MpDfUS3w0VyCP/ckPW9Okt2DOad
         e5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QULGmrTqCLxJGFukNsnY5+P3UKYk27qIk13ZoZ0RKo4=;
        b=cUVrdWBD30+XgJpMF0NsWmE+Lltci7mvurJLZH+sWxScbZPwN8EeIz/XCoXoesZSGQ
         AbWffFhe05NphKjDWynkgR+CnTrhrHYU3cD43Z2X2/fiLWtBHrclpg6+gZSPWYVcOfzF
         ticekU2qwK69P+FPnpP9+oHJH71jICpjT6nLAfYGCcyZIWwVqaqjGJFzFnMUh0Ed/1+/
         YiCNXXOEfUtOjnrdaeq4GtOH3VoRcANiF4xwIoF+I0q+1qR5jdIqZpH/eTvipVcwqNbh
         rUBMyAkSffwFLsHqvDEbv308Bh7a/8gK/IrvwnfHf0pT8MJRJ2le5YxKU/T868mQYJe/
         szUw==
X-Gm-Message-State: AOAM533LC0AYYNKJ+o4O5va+WZWusraOh2+4uoPC1kDG23woVlLna8dy
        j8lBlPmp2PaReuyPJxT9PDk=
X-Google-Smtp-Source: ABdhPJz5LburZdsDP0AZK6FqUWMGKKxFNi0CwB4Ps0KSUPTouLG3JRlC4ZpRSsDcw0aDVIDx+iYbng==
X-Received: by 2002:a50:e1c4:: with SMTP id m4mr99540306edl.307.1636307877663;
        Sun, 07 Nov 2021 09:57:57 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m11sm4251182edd.58.2021.11.07.09.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 09:57:57 -0800 (PST)
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
Subject: [RFC PATCH 3/6] leds: add function to configure offload leds
Date:   Sun,  7 Nov 2021 18:57:15 +0100
Message-Id: <20211107175718.9151-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211107175718.9151-1-ansuelsmth@gmail.com>
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add configure_offload helper to configure how the LED should work in
offload mode. The function require to support the particular trigger and
will use the passed offload_flags to elaborate the data and apply the
correct configuration. This function will then be used by the offload
trigger to request and update offload configuration.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/leds/leds-class.rst | 12 ++++++++++++
 include/linux/leds.h              | 16 ++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
index ab50b58d6a21..af84cce09068 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -191,6 +191,18 @@ If the second argument (enable) to the trigger_offload() method is false, any
 active HW offloading must be deactivated. In this case errors are not permitted
 in the trigger_offload() method.
 
+The offload trigger will use the function configure_offload() provided by the driver
+that will configure the offloaded mode for the LED.
+This function pass as the first argument (offload_flags) a u32 flag, it's in the LED
+driver interest how to elaborate this flags and to declare support for a particular
+offload trigger.
+The second argument (cmd) of the configure_offload() method can be used to do various
+operation for the specific trigger. We currently support ENABLE, DISABLE and READ to
+enable, disable and read the state of the offload trigger for the LED driver.
+If the driver return -ENOTSUPP on configure_offload, the trigger activation will
+fail as the driver doesn't support that specific offload trigger or don't know
+how to handle the provided flags.
+
 LEDs can declare the supported offload trigger using linux,supported-offload-triggers
 binding in the dts. This is just an array of string that will be used by any
 offload trigger to check the supported triggers and configure the LED offload mode
diff --git a/include/linux/leds.h b/include/linux/leds.h
index ff1f903f8079..eb06d812bc24 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -67,6 +67,14 @@ struct led_hw_trigger_type {
 	int dummy;
 };
 
+#ifdef CONFIG_LEDS_OFFLOAD_TRIGGERS
+enum offload_trigger_cmd {
+	TRIGGER_ENABLE,
+	TRIGGER_DISABLE,
+	TRIGGER_READ
+};
+#endif
+
 struct led_classdev {
 	const char		*name;
 	unsigned int brightness;
@@ -163,6 +171,14 @@ struct led_classdev {
 	/* some LEDs may be able to offload some SW triggers to HW */
 	int			(*trigger_offload)(struct led_classdev *led_cdev,
 						   bool enable);
+	/* Function to configure how the LEDs should work in offload mode.
+	 * The function require to support the trigger and will use the
+	 * passed flags to elaborate the trigger requested and apply the
+	 * correct configuration.
+	 */
+	int			(*configure_offload)(struct led_classdev *led_cdev,
+						     u32 offload_flags,
+						     enum offload_trigger_cmd cmd);
 #endif
 #endif
 
-- 
2.32.0

