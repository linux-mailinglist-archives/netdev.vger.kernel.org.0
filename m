Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D97216C043E
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjCSTTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjCSTTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:19:07 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3A510242;
        Sun, 19 Mar 2023 12:18:49 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id l27so200895wrb.2;
        Sun, 19 Mar 2023 12:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679253527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sFDnakGrHwc9YezMrBpj3kUh14Ewx9Mr1i8Y8CEIfEg=;
        b=Y8L+jOt4zV+0JKKDKR40z03wZRfUuaGzlyvhdbtYRcFk6OVRZBDGmbCto3lbxTB6rC
         UewSv/njrZ3zdBt8qOjV/U+kA6nOR/8mcTcm8Q9AMvKNtjwfZkXjp9gaUIOvFB5IT3eq
         j+wi7nu3I98FsuQYXwfCAxwU2Cq6t3kRGNdi5d/9iOKxCMdDvdSaWMLcCjyYOF3Rkxg8
         77qMHMXb5eS5hB6MmI18j2By4784xuYWEg4QIshPFEWsY/RoQ9unzr7Gyp7oUuQNYQHD
         S9KGWlgsRvWHLM5HQjW4I9R4PkaV0MRi/RrA35jfJl9XVhNCzsCiUzPhlwdFaK3F/80n
         Gv3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679253527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sFDnakGrHwc9YezMrBpj3kUh14Ewx9Mr1i8Y8CEIfEg=;
        b=4uNl7PZc01tGwoLfvimy7npYdk4D4XwI4rXaEYfDoe7iaj8cw4l2EeoxsoLYjmwTig
         xqJ9cZ8HSFY9WHrvPeP+DSkzwI6Xl1zJAY4aVFyuLzOEMwV2gTbnyDAbxfDuLmO1CtwP
         tBeDARIjSABvs7cx6S47F8ZnXTTwc57E4KkLHOKIygR8Wr/TM0LwHmJiiBQ2tYkaBuii
         okoyjOrQPPkCFukiGOW/+dZuAfI0tCmsf9yZPYoos0JZV3mJFdM+dvZqipw6armm41mS
         F0t6eMe0YxUnFGMQUGCq0I1wzzXcQ0D2/Kdnl+XDEQthv+780dqfXlPUyhvnIyhxA41E
         lkHA==
X-Gm-Message-State: AO0yUKXKEprB68oup5afRi3SchwOqnkKerdOn39/uPzauL0padGz/4Lk
        CTf98xkaXJMLDtj7WRkij08=
X-Google-Smtp-Source: AK7set8xZ8lyD/9/85wUOIGIe+7bOT05rW6mUFgZpNojuichjGSuN7KLJfE+GsEviAdWrdpYML6bNQ==
X-Received: by 2002:a5d:4a4c:0:b0:2d0:cf21:a40e with SMTP id v12-20020a5d4a4c000000b002d0cf21a40emr11562615wrs.30.1679253527330;
        Sun, 19 Mar 2023 12:18:47 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id b7-20020a5d4b87000000b002cfe0ab1246sm7165167wrt.20.2023.03.19.12.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:18:47 -0700 (PDT)
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
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [net-next PATCH v5 09/15] net: phy: marvell: Implement led_blink_set()
Date:   Sun, 19 Mar 2023 20:18:08 +0100
Message-Id: <20230319191814.22067-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230319191814.22067-1-ansuelsmth@gmail.com>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
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

The Marvell PHY can blink the LEDs, simple on/off. All LEDs blink at
the same rate, and the reset default is 84ms per blink, which is
around 12Hz.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/phy/marvell.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 5f4caca93983..c00f67f229f5 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -147,6 +147,8 @@
 #define MII_88E1318S_PHY_LED_FUNC		0x10
 #define MII_88E1318S_PHY_LED_FUNC_OFF		(0x8)
 #define MII_88E1318S_PHY_LED_FUNC_ON		(0x9)
+#define MII_88E1318S_PHY_LED_FUNC_HI_Z		(0xa)
+#define MII_88E1318S_PHY_LED_FUNC_BLINK		(0xb)
 #define MII_88E1318S_PHY_LED_TCR		0x12
 #define MII_88E1318S_PHY_LED_TCR_FORCE_INT	BIT(15)
 #define MII_88E1318S_PHY_LED_TCR_INTn_ENABLE	BIT(7)
@@ -2862,6 +2864,35 @@ static int m88e1318_led_brightness_set(struct phy_device *phydev,
 			       MII_88E1318S_PHY_LED_FUNC, reg);
 }
 
+static int m88e1318_led_blink_set(struct phy_device *phydev, u32 index,
+				  unsigned long *delay_on,
+				  unsigned long *delay_off)
+{
+	int reg;
+
+	reg = phy_read_paged(phydev, MII_MARVELL_LED_PAGE,
+			     MII_88E1318S_PHY_LED_FUNC);
+	if (reg < 0)
+		return reg;
+
+	switch (index) {
+	case 0:
+	case 1:
+	case 2:
+		reg &= ~(0xf << (4 * index));
+			reg |= MII_88E1318S_PHY_LED_FUNC_BLINK << (4 * index);
+			/* Reset default is 84ms */
+			*delay_on = 84 / 2;
+			*delay_off = 84 / 2;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return phy_write_paged(phydev, MII_MARVELL_LED_PAGE,
+			       MII_88E1318S_PHY_LED_FUNC, reg);
+}
+
 static int marvell_probe(struct phy_device *phydev)
 {
 	struct marvell_priv *priv;
@@ -3112,6 +3143,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
 		.led_brightness_set = m88e1318_led_brightness_set,
+		.led_blink_set = m88e1318_led_blink_set,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1145,
@@ -3219,6 +3251,7 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
 		.led_brightness_set = m88e1318_led_brightness_set,
+		.led_blink_set = m88e1318_led_blink_set,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1540,
@@ -3246,6 +3279,7 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
 		.led_brightness_set = m88e1318_led_brightness_set,
+		.led_blink_set = m88e1318_led_blink_set,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1545,
@@ -3273,6 +3307,7 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
 		.led_brightness_set = m88e1318_led_brightness_set,
+		.led_blink_set = m88e1318_led_blink_set,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E3016,
@@ -3415,6 +3450,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
 		.led_brightness_set = m88e1318_led_brightness_set,
+		.led_blink_set = m88e1318_led_blink_set,
 	},
 };
 
-- 
2.39.2

