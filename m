Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A08B6BDEBE
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjCQCdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjCQCdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:33:37 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CCF6BDD1;
        Thu, 16 Mar 2023 19:33:30 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id q16so3199344wrw.2;
        Thu, 16 Mar 2023 19:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679020409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5HAlDMClSna0/uEvZR0Ovj6OmaH2Z8PGvM5wxNKi3Tc=;
        b=nKQ0XdS4521tYgbCKplAGUd7qQrJrc3wFKD3qy2l6gz1CG38r6JayUzjqLhnnaAu6s
         tQ6KBRxgmywpSHZJdn6SFVQgJQaVSCDUKGcPenmGgoX93il8SIU4Y83deG7oIs8EuQkc
         nbEFXbs+gW4mTzvOijBzMnB20X22z760q4qacbhvaBHDlatKVj/baXJAebc156c7BeD6
         /h4U3zeA2VlEWZoMYlr2L6C9K/Tl33kL0i5OCVfxHQZd7ZKvC3sdofLxoZc+MelV2f/R
         CVT/qSb+f2uYMCDOwGw9cQza7JvX7i/wyo1IlGzbSOuBusu/lvS9pWscUci1Rfbp9G+L
         ilgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679020409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5HAlDMClSna0/uEvZR0Ovj6OmaH2Z8PGvM5wxNKi3Tc=;
        b=SlK9tgmuy9pogumxu3iDtQOWkOZqTypPjKOnOpu3Lj2/2K0Y/ijwkXcCI9TzM/uolV
         maa7pct78fwVdotCDTmGtzlwXZid7BG3Gm4I5aZ7SgfQaOJSo761IOVHyRnS3Euc3oRh
         EtEP59pgpLRnIf2NliRzlHZ/5Dbv+PfNuMQoV52EUDggi3wG5DFbrvUMzG93p2CUoESB
         wCnJchoAV9DvY/Yik6Lg/SChbwZ5zNdvsve9/Elh1AFn6MOuHPg7DlEHzDwf8ll0dlau
         PX+I0FUcjmZA7zSS/u99jJYIdPtJDY3SCoH+4ZZaGx6aOEtVmOzNf6v+zTUEYXWMMNQH
         h7Kg==
X-Gm-Message-State: AO0yUKWWpnDAF7gCFkEULpARgXhyDvUyuPRs5AkYJX2l/yOwcRCmktA/
        YQKmHblEZpUuSFczntC+ONg=
X-Google-Smtp-Source: AK7set9B3AAouz73aYp6/ftKargRjZfg3mnSZKfhSWrSgE8yC9KYbmaJIr7p8NbWM6Alz+wU7c8UrA==
X-Received: by 2002:a5d:5249:0:b0:2bf:bf05:85ac with SMTP id k9-20020a5d5249000000b002bfbf0585acmr971817wrc.23.1679020409058;
        Thu, 16 Mar 2023 19:33:29 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id z15-20020a5d44cf000000b002ce9f0e4a8fsm782313wrr.84.2023.03.16.19.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 19:33:28 -0700 (PDT)
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
Subject: [net-next PATCH v4 07/14] net: phy: phy_device: Call into the PHY driver to set LED blinking
Date:   Fri, 17 Mar 2023 03:31:18 +0100
Message-Id: <20230317023125.486-8-ansuelsmth@gmail.com>
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

Linux LEDs can be requested to perform hardware accelerated
blinking. Pass this to the PHY driver, if it implements the op.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/phy/phy_device.c | 18 ++++++++++++++++++
 include/linux/phy.h          |  8 ++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c7312a9e820d..b4be02a21bb8 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2981,6 +2981,22 @@ static int phy_led_set_brightness(struct led_classdev *led_cdev,
 	return err;
 }
 
+static int phy_led_blink_set(struct led_classdev *led_cdev,
+			     unsigned long *delay_on,
+			     unsigned long *delay_off)
+{
+	struct phy_led *phyled = to_phy_led(led_cdev);
+	struct phy_device *phydev = phyled->phydev;
+	int err;
+
+	mutex_lock(&phydev->lock);
+	err = phydev->drv->led_blink_set(phydev, phyled->index,
+					 delay_on, delay_off);
+	mutex_unlock(&phydev->lock);
+
+	return err;
+}
+
 static int of_phy_led(struct phy_device *phydev,
 		      struct device_node *led)
 {
@@ -3003,6 +3019,8 @@ static int of_phy_led(struct phy_device *phydev,
 
 	if (phydev->drv->led_brightness_set)
 		cdev->brightness_set_blocking = phy_led_set_brightness;
+	if (phydev->drv->led_blink_set)
+		cdev->blink_set = phy_led_blink_set;
 	cdev->max_brightness = 1;
 	init_data.devicename = dev_name(&phydev->mdio.dev);
 	init_data.fwnode = of_fwnode_handle(led);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 94fd21d5e145..58cb44960573 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1074,6 +1074,14 @@ struct phy_driver {
 	 */
 	int (*led_brightness_set)(struct phy_device *dev,
 				  u32 index, enum led_brightness value);
+	/* Activate hardware accelerated blink, delays are in milliseconds
+	 * and if both are zero then a sensible default should be chosen.
+	 * The call should adjust the timings in that case and if it can't
+	 * match the values specified exactly.
+	 */
+	int (*led_blink_set)(struct phy_device *dev, u32 index,
+			     unsigned long *delay_on,
+			     unsigned long *delay_off);
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
-- 
2.39.2

