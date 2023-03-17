Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F1D6BDEC6
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjCQCdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjCQCdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:33:36 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5506F10407;
        Thu, 16 Mar 2023 19:33:28 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id o7so3191160wrg.5;
        Thu, 16 Mar 2023 19:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679020406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VMcNLbmNu1IC9Ea6lnqltnBFoBgoPx4QsFmf6AH28VU=;
        b=bPAzEkLkh2idGz96hGdIeQqeotS/uUEVkZssv/m3V2O5F8nb5Nq+D3Z6yNxGly88B/
         6+otGpsasteHFvS0Ggmjf5pgW7et/WdxQkU4oZwmFS3rI4bPGX1Cv6+2c9HU0/B6/zVL
         DwckB4/YaGXXcb8PICGs7dhI/D7oUbxDopvRzCdgXHVaMtgojrYiWa/+cfBGmChOKHcx
         hsOQMTQK4UoGOWwPIFyz2P/YjRRXvWBVYYwAclAc71Uh92pCTB/NXCZ8Bg2UG7Nh1aBj
         LtpcBNSYded+jUB7S+5eJaUWRndfIbzt5IqgMCsiBDFmwqBDSFuG1mzPbscOcDc+Kdrn
         EQCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679020406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VMcNLbmNu1IC9Ea6lnqltnBFoBgoPx4QsFmf6AH28VU=;
        b=dA0Ry8rv5DXh9wg1O79AVPFCLJolVZhSwUWvNBF1OpVQEv0lB7cZgItL23ls/sQW/X
         1LviPlwUX7FCT8n6MuLzKqYTEeNwflY5qDcOtCdSI4+XrLdXwmdzwENpUZRwt6dklm8q
         n6Wej/u0kFZSbgmNezsPtKnT00xj+8+G16l4H4QGBhJFJaZkcculQF9jakTRHqxENEaM
         prVPYoUOlxB2DBRV8c21PSRVrzJQGcY4EUWp4wwCmFpL0Psa+3cFRpilhxJ77KEmAUIj
         WoCN9k7ZG//k3PCMrjH+rWPjkjjPff5Wjdg799LbAf5lLmsZn5Y6h+GByeGgjrpnuGOM
         f7oA==
X-Gm-Message-State: AO0yUKV9iExaw5SLhJUPWu1TmNTVKhMjrj3DXihSTNxh4n0KPh75eMjp
        zt4qTfS47V2W2F6kDock9Ic=
X-Google-Smtp-Source: AK7set+q59W1RYMtv95UcF4w09yWKGPNVs1o2aEKUlyf/F/of1Qg64wMr9s8S44seQ4ZfsblZIUPAg==
X-Received: by 2002:adf:e8cd:0:b0:2ce:a85b:17b with SMTP id k13-20020adfe8cd000000b002cea85b017bmr5490389wrn.61.1679020406514;
        Thu, 16 Mar 2023 19:33:26 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id z15-20020a5d44cf000000b002ce9f0e4a8fsm782313wrr.84.2023.03.16.19.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 19:33:26 -0700 (PDT)
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
Subject: [net-next PATCH v4 05/14] net: phy: phy_device: Call into the PHY driver to set LED brightness
Date:   Fri, 17 Mar 2023 03:31:16 +0100
Message-Id: <20230317023125.486-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230317023125.486-1-ansuelsmth@gmail.com>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
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
 drivers/net/phy/phy_device.c | 15 ++++++++++++---
 include/linux/phy.h          | 11 +++++++++++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ee800f93c8c3..c7312a9e820d 100644
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
@@ -2988,12 +2995,14 @@ static int of_phy_led(struct phy_device *phydev,
 		return -ENOMEM;
 
 	cdev = &phyled->led_cdev;
+	phyled->phydev = phydev;
 
 	err = of_property_read_u32(led, "reg", &phyled->index);
 	if (err)
 		return err;
 
-	cdev->brightness_set_blocking = phy_led_set_brightness;
+	if (phydev->drv->led_brightness_set)
+		cdev->brightness_set_blocking = phy_led_set_brightness;
 	cdev->max_brightness = 1;
 	init_data.devicename = dev_name(&phydev->mdio.dev);
 	init_data.fwnode = of_fwnode_handle(led);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 88a77ff60be9..94fd21d5e145 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -832,15 +832,19 @@ struct phy_plca_status {
  * struct phy_led: An LED driven by the PHY
  *
  * @list: List of LEDs
+ * @phydev: PHY this LED is attached to
  * @led_cdev: Standard LED class structure
  * @index: Number of the LED
  */
 struct phy_led {
 	struct list_head list;
+	struct phy_device *phydev;
 	struct led_classdev led_cdev;
 	u32 index;
 };
 
+#define to_phy_led(d) container_of(d, struct phy_led, led_cdev)
+
 /**
  * struct phy_driver - Driver structure for a particular PHY type
  *
@@ -1063,6 +1067,13 @@ struct phy_driver {
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

