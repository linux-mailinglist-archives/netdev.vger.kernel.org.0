Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8FDB6CA6F9
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjC0OLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbjC0OLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:11:35 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BE749C2;
        Mon, 27 Mar 2023 07:11:10 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h17so8935554wrt.8;
        Mon, 27 Mar 2023 07:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679926268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NCx6caR6IZgTqSPdn2HwL+62wmCa1NHNRk8GEDmxS/c=;
        b=SuNkCJ5n76SuyMydmVY30jYSlLMqt5ctuxMv0YdpxEzdgUvl0dJzVUhVkAQWGcUCeH
         bOuzYtrgR3SmYFNfl65Vlw7agM43eMZ3+hwNXoBCqoglPbcXFiwsX7pH1aX89wxGVnYG
         D9BAK2lv0e0nKBZoyazzTgkYPiWQ8zvNTdsoUPPNeu42Z1G4prfSuXskhV8lemxlweUD
         EONcIBC/QOGlLbHluyPdrVEF0URJXsmF6zayRonwxbJKbKLNELVzqpHhI4kGGHFIpC1g
         ohnOK09ygnHguPlCNHEOASMVGhh31tRxpYQrG9RNLlpGvzhSReglIZva26RV6z43d0DQ
         G/ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NCx6caR6IZgTqSPdn2HwL+62wmCa1NHNRk8GEDmxS/c=;
        b=tmvBJ6W9gBC+aU46Qw7pgAnDHmHzmtS2hQQGaNm+kILPg4XpoD9m+ODgzpS2/7MIEQ
         5DXUP8AbDKKt9W/sN/+FGOom4Nj9QMi/cskYmgavlAxhBynPp/HPHJjHBF89qv8dJxaI
         xY/Cj/enDf4v/D5qzELnKCFhv2focgw5TbS2iMJstwpntPAyPdhNulggQwaHtksjL0Dh
         w9W97dX21Y5oa8qc0BhauAohuHv/TD6HxCAMWR9nCoZOt6n5KdZAzWimeHjPtzIFYvo5
         xEPyixhHtYBZkmQTottKycWxShQcC+pqXKsVCaQluQhxDURzbsiMokXSQ850tx3NtluN
         GMcQ==
X-Gm-Message-State: AAQBX9dWQWxE1sfJYbdVlxrns/yj3kVHS8NBXHHUdkmp2/XPXF9TLran
        T3m7jrOTMpWwyIOV0icMOkY=
X-Google-Smtp-Source: AKy350bROacD4r8upQdnz4/Rhm/jWEyZomsqFkuGG+4Y25pmz6cwLgL3KeP3tvpdEKmMY5A89ioXtQ==
X-Received: by 2002:adf:e9c9:0:b0:2ce:ae4c:c420 with SMTP id l9-20020adfe9c9000000b002ceae4cc420mr9564282wrn.3.1679926268243;
        Mon, 27 Mar 2023 07:11:08 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm25307591wrj.47.2023.03.27.07.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:11:07 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: [net-next PATCH v6 06/16] net: phy: phy_device: Call into the PHY driver to set LED brightness
Date:   Mon, 27 Mar 2023 16:10:21 +0200
Message-Id: <20230327141031.11904-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327141031.11904-1-ansuelsmth@gmail.com>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index 39af989947f9..141d63ef3897 100644
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
index 11fb76a1c507..2a5ee66b79b0 100644
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
 	u32 index;
 };
 
+#define to_phy_led(d) container_of(d, struct phy_led, led_cdev)
+
 /**
  * struct phy_driver - Driver structure for a particular PHY type
  *
@@ -1072,6 +1076,13 @@ struct phy_driver {
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

