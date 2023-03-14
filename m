Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEF56B9B03
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbjCNQS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbjCNQRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:17:52 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E32B06C0;
        Tue, 14 Mar 2023 09:17:30 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id l12so6601360wrm.10;
        Tue, 14 Mar 2023 09:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678810648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tDRoLkLZ4ceS0IqWkmGrgNhXPijtgv6U26EGp7OciKo=;
        b=iGlg/uX24MKMHHK8AAOSr2BKLyFS4HOhcBcxa70+pJ2Ns4LBP7fN/aw6CU6ziNhk3Y
         1kCs/ku6xXcSaOWBrI5FI077EwMOIS5g/uSq3LkvSQFb8AUUBNGCoDZ5yktYYT4obod1
         uoY5hfxsJ2j/Dd3AUBRWBvQxn3MHskR/ruhf9IJlb3egdAVrRgBP46QPJFioDbiTIvmt
         e47qovgD7t+azseA0kcaRRGzbMNdjjWge4Ic0/rERQOjYQFJ56c58l09LyduwtG5yKQk
         HSF38Vcwi8rkDlI0HyqL5yhf2hBL1mjR9Q1K/k0KCnwwAs2qb48SAR0GUmO7CtWTy+tX
         Lfyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tDRoLkLZ4ceS0IqWkmGrgNhXPijtgv6U26EGp7OciKo=;
        b=Yd8e4W3z25m9x/DnBZVhqNXkh7a+c9vrvqmZB3W/eV6hDayL6yU+ZjCJA3AySueRI4
         JXxcylWLfae7NubKKpYCwnCZACwVwozBRMNpWQerAOHLi2kV4PYWtaWM510cfmEjt9ZC
         ZqLRkaK8yee+i/qif9Pahwj2k7+qlSP2wKpGHg7ymofPx8cj886/39jQk/E+WL5GuhI/
         Vx1jKSxGilhyqAZnWZz2/RefDaF5aYLkK9sPePRAREH/UHgwgbLdPmKJq0O4DJwvde5X
         XAeUg6+mo2v/juJn36pefnvlPu86ihf6Kk8lWUuZYQs0dguVmhOhRLN4+mUgnMLIgSgd
         GYzQ==
X-Gm-Message-State: AO0yUKV0U+rIY41k1ml3VQtGnyFhuO4IOuwA/hBHlb5JQB4Kx/cuCiBq
        S/SuFPvV5zWfeDVs9xHa4Onitmgh754=
X-Google-Smtp-Source: AK7set/raFtgzucD42zPDJH5xaWGW0y19U+iZmVtEklrRSy/R46IpPblgcT3YzHPRTWqeB6wfvWWsw==
X-Received: by 2002:adf:e302:0:b0:2c7:a67:615e with SMTP id b2-20020adfe302000000b002c70a67615emr28433954wrj.0.1678810648104;
        Tue, 14 Mar 2023 09:17:28 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id a16-20020a5d4570000000b002c5539171d1sm2426821wrc.41.2023.03.14.09.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:17:27 -0700 (PDT)
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
Subject: [net-next PATCH v3 05/14] net: phy: phy_device: Call into the PHY driver to set LED brightness.
Date:   Tue, 14 Mar 2023 11:15:07 +0100
Message-Id: <20230314101516.20427-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314101516.20427-1-ansuelsmth@gmail.com>
References: <20230314101516.20427-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
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

