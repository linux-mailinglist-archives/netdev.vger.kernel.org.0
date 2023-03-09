Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2102C6B3113
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 23:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjCIWia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 17:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjCIWiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 17:38:09 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFB821A28;
        Thu,  9 Mar 2023 14:38:05 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id t25-20020a1c7719000000b003eb052cc5ccso4760621wmi.4;
        Thu, 09 Mar 2023 14:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678401484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tDRoLkLZ4ceS0IqWkmGrgNhXPijtgv6U26EGp7OciKo=;
        b=kJWeoVWro/WHEmM9GBnZFxWYJc70QnoBY+rdDq2a8KBy6TjLM8yjHHkgdk5dMJqHJ1
         lD/CpHUPZddFSS+GgBAGOVZTTfhgOv80gAtBr9XHwH0UZ8zgHRFfH+BR3zZnxjT65wId
         oK2jgzZknCXw0sjnSs30GeLudFDz754/kfq1fCO/vO3F52JlUiR92aZd94IPImPiO4Zu
         WgtZMqu/k/ME5NVMUBeXB5+rRW6WmaOmC9xjYTaN5S/ApsnDNsUlt+OJccsIf41yywrf
         B927tJsAcnFWZrTYPwvQpEsvnxxJk7ihKeFObQ5H1CTptC3meSWJUb1yWOjRsn80d9Cl
         OzPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678401484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tDRoLkLZ4ceS0IqWkmGrgNhXPijtgv6U26EGp7OciKo=;
        b=hxfO5jkirNgLBW3llTZWXy1WiRX0q5HFuNs1QgmTo6pB8e/jsGuD8CHF0NrsXxRBaY
         WvoPhjSoL+9+vRsx/ufQRRD9hkAkOr8/gTR7dery7RUzPliEXAIAHjkWBZAjukJNABur
         QtYVlfar8kSr+d9h/nRH7sfjcdTCw2Ti1CVxZ7NXMPACanEKgqT3sn+TeR6mxchj+3+o
         FdyUg1iDhV3IvPyhsGVAYmueIZajL/qG7ByzV0LCRojTAa6GvTXtOjXyFa+Dx3vwDbaI
         +qrfr9x3V2efz8lA67RbILbBsCZTu9sQmcO/c/uXSthjY0kSm/ZbF8soc0gmVAsfD8de
         SwkQ==
X-Gm-Message-State: AO0yUKXhkGimwLfZmkwoiZDaMlNBu93/s+6xLgT9dKuiXUYjOiObpfNp
        bUCDnu3XDhSXzBHsYRtKBVnFkI8GtbA=
X-Google-Smtp-Source: AK7set+apqoa0KPiDsZ/+wQr+J2aA/U4dxCr+v2C+6auaXVj3NgBz8cH2c+K2x2II47e9c+SN6G8CA==
X-Received: by 2002:a05:600c:3d88:b0:3eb:33fb:9dcf with SMTP id bi8-20020a05600c3d8800b003eb33fb9dcfmr732506wmb.5.1678401483775;
        Thu, 09 Mar 2023 14:38:03 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id g12-20020a05600c310c00b003e209b45f6bsm1183981wmo.29.2023.03.09.14.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 14:38:03 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH v2 05/14] net: phy: phy_device: Call into the PHY driver to set LED brightness.
Date:   Thu,  9 Mar 2023 23:35:15 +0100
Message-Id: <20230309223524.23364-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309223524.23364-1-ansuelsmth@gmail.com>
References: <20230309223524.23364-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

Linux LEDs can be software controlled via the brightness file in /sys.
LED drivers need to implement a brightness_set function which the core
will call. Implement an intermediary in phy_device, which will call
into the phy driver if it implements the necessary function.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/phy/phy_device.c | 14 +++++++++++---
 include/linux/phy.h          |  9 +++++++++
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8acade42615c..e4df4fcb6b05 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2967,11 +2967,18 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 	return phydrv->config_intr && phydrv->handle_interrupt;
 }
 
-/* Dummy implementation until calls into PHY driver are added */
 static int phy_led_set_brightness(struct led_classdev *led_cdev,
 				  enum led_brightness value)
 {
-	return 0;
+	struct phy_led *phyled = to_phy_led(led_cdev);
+	struct phy_device *phydev = phyled->phydev;
+	int err;
+
+	mutex_lock(&phydev->lock);
+	err = phydev->drv->led_brightness_set(phydev, phyled->index, value);
+	mutex_unlock(&phydev->lock);
+
+	return err;
 }
 
 static int of_phy_led(struct phy_device *phydev,
@@ -2995,7 +3002,8 @@ static int of_phy_led(struct phy_device *phydev,
 	if (err)
 		return err;
 
-	cdev->brightness_set_blocking = phy_led_set_brightness;
+	if (phydev->drv->led_brightness_set)
+		cdev->brightness_set_blocking = phy_led_set_brightness;
 	cdev->max_brightness = 1;
 	init_data.devicename = dev_name(&phydev->mdio.dev);
 	init_data.fwnode = of_fwnode_handle(led);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 1b1efe120f0f..83d3ed7485e0 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -841,6 +841,8 @@ struct phy_led {
 	u32 index;
 };
 
+#define to_phy_led(d) container_of(d, struct phy_led, led_cdev)
+
 /**
  * struct phy_driver - Driver structure for a particular PHY type
  *
@@ -1063,6 +1065,13 @@ struct phy_driver {
 	/** @get_plca_status: Return the current PLCA status info */
 	int (*get_plca_status)(struct phy_device *dev,
 			       struct phy_plca_status *plca_st);
+
+	/* Set a PHY LED brightness. Index indicates which of the PHYs
+	 * led should be set. Value follows the standard LED class meaning,
+	 * e.g. LED_OFF, LED_HALF, LED_FULL.
+	 */
+	int (*led_brightness_set)(struct phy_device *dev,
+				  u32 index, enum led_brightness value);
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
-- 
2.39.2

