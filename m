Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFEC46E4CD0
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjDQPWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjDQPVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:21:35 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8158A44B7;
        Mon, 17 Apr 2023 08:20:49 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-2efbaad83b8so993912f8f.0;
        Mon, 17 Apr 2023 08:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744843; x=1684336843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=szf3ygE87xUCju0anF41cpULXxylHL2GWUmuOySoNxI=;
        b=KkT85xTNMLZ4fOATjcpyY0p2PuhGDZLwQ6JVQr/SfipLOtjHbe3R0m7x6xVvqZa65D
         Z65TtSWWqVKR9qi+D/7kPzzcqhOLNAKTb/46Kzf8BHGIHX2sJEgU6FOrAxxIdhQx+fwt
         oKzEtCCtRHcLYcJWicHRl+blapxA3+i0/ghtozb9u6YQgaScnMftcFI8mSj5DYsWDVPJ
         BWlmGK8a2bAM/d6NFGws/vglEoZ0BG9ru68cR/b3y7yPw/ck/rc3+WkW3B9220tujjbp
         MUpP6CX7xXCL5w6klPeuxPWPAJxLmEQ9bTotcZ/y2GC2iYDDoH4nUtO+mBH2h80nML4q
         bEXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744843; x=1684336843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=szf3ygE87xUCju0anF41cpULXxylHL2GWUmuOySoNxI=;
        b=eiRQ26TRYAn3OvUkCQa9fVEPLNQcVWZAUxiTzDapTVo2/Z321vQtEZmh5yMrQzmiS3
         qoxmiGsZ2T+5CW8M6PPjIuM7k8ws1nW2wMTe08dQE3s/UPvdBN8yFmNTsmeuL7RXEDLL
         Kx2apwu4mG7lIx4MuMKkKMcl58RWhrtCA/55BxVW5nMNS3yLGyIUqItBreHJnjPbexxf
         WYTeRVlskKNXnvNzsQLeA+jODaNluQGR2Sp5Km6Xkij+GYc8T9sjcehD1hN9kBFrJn52
         TDXdzZWQgrL++qhvz3/XKJr4w990smTFgY7fffObN5Cmuq5Qthdv4NIOFGFSVS6+e4t9
         qsJA==
X-Gm-Message-State: AAQBX9dkPUN6O2gpNc3qls0ibPsewpDunUr10ceo8LeBM0A4c09E+kb/
        IsL9aapT98y+KCLzPLZDzYw=
X-Google-Smtp-Source: AKy350bv+mp8vhueW8qG/FJJJtGId8y20dMrXj2IguoepJG1AKZlE5NzINNm4TBcPD5kwzreHGQ3Ww==
X-Received: by 2002:a5d:4208:0:b0:2f1:d17f:cf95 with SMTP id n8-20020a5d4208000000b002f1d17fcf95mr6033958wrq.12.1681744842567;
        Mon, 17 Apr 2023 08:20:42 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c1c0f00b003f173be2ccfsm3501354wms.2.2023.04.17.08.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:20:33 -0700 (PDT)
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
        Jonathan Corbet <corbet@lwn.net>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [net-next PATCH v7 06/16] net: phy: phy_device: Call into the PHY driver to set LED brightness
Date:   Mon, 17 Apr 2023 17:17:28 +0200
Message-Id: <20230417151738.19426-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417151738.19426-1-ansuelsmth@gmail.com>
References: <20230417151738.19426-1-ansuelsmth@gmail.com>
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

From: Andrew Lunn <andrew@lunn.ch>

Linux LEDs can be software controlled via the brightness file in /sys.
LED drivers need to implement a brightness_set function which the core
will call. Implement an intermediary in phy_device, which will call
into the phy driver if it implements the necessary function.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy_device.c | 15 ++++++++++++---
 include/linux/phy.h          | 13 +++++++++++++
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 61b971251de5..5c1200160c51 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2991,11 +2991,18 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
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
@@ -3012,12 +3019,14 @@ static int of_phy_led(struct phy_device *phydev,
 		return -ENOMEM;
 
 	cdev = &phyled->led_cdev;
+	phyled->phydev = phydev;
 
 	err = of_property_read_u8(led, "reg", &phyled->index);
 	if (err)
 		return err;
 
-	cdev->brightness_set_blocking = phy_led_set_brightness;
+	if (phydev->drv->led_brightness_set)
+		cdev->brightness_set_blocking = phy_led_set_brightness;
 	cdev->max_brightness = 1;
 	init_data.devicename = dev_name(&phydev->mdio.dev);
 	init_data.fwnode = of_fwnode_handle(led);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index bd6b5e9bb729..f3c7e3c99f24 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -841,15 +841,19 @@ struct phy_plca_status {
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
 	u8 index;
 };
 
+#define to_phy_led(d) container_of(d, struct phy_led, led_cdev)
+
 /**
  * struct phy_driver - Driver structure for a particular PHY type
  *
@@ -1072,6 +1076,15 @@ struct phy_driver {
 	/** @get_plca_status: Return the current PLCA status info */
 	int (*get_plca_status)(struct phy_device *dev,
 			       struct phy_plca_status *plca_st);
+
+	/**
+	 * @led_brightness_set: Set a PHY LED brightness. Index
+	 * indicates which of the PHYs led should be set. Value
+	 * follows the standard LED class meaning, e.g. LED_OFF,
+	 * LED_HALF, LED_FULL.
+	 */
+	int (*led_brightness_set)(struct phy_device *dev,
+				  u8 index, enum led_brightness value);
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
-- 
2.39.2

