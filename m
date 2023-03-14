Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59BA6B9B06
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbjCNQS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjCNQR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:17:57 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76274B420C;
        Tue, 14 Mar 2023 09:17:31 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id l12so6601430wrm.10;
        Tue, 14 Mar 2023 09:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678810649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bhHnF/S3YeXHYbPEZLJBWZo9IBQDiim5+f+K7WIjxP8=;
        b=JmdJ4lQrygrnfTg1/V1GKTLeL8CWX8Zu6lbubK7rdIQjreE/Dp4eZbWLWBBKDvpwBX
         VWOgQX1AtKZo+KLZnFxfED145ItnuxaPcqoM7q8VJoRIEtf7jjQQnyh1llyBNU0UJCr6
         tsupwDMlWO0I6Fdb49e8USmNzomdLM4agoMtidMPr+DE/3uTCJkBDc8FzbR3GwFCwd4v
         ytQYtjn1oBygv/ct7R1cF6F8ieM0E9ps/6BTaFHAds8i9lzkWf0tc58yY5XHOHbNXeGu
         95FHR3+2tygioramplnAwDM1WVpOPv8a6GgGA6aRLTx1QrxJjzuFU/9+4mq37P3uaBQD
         d6pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bhHnF/S3YeXHYbPEZLJBWZo9IBQDiim5+f+K7WIjxP8=;
        b=zOU4pxFhVqtnsdAAnt7pxxnxOzrmWbJLKTQfeu88FAvx19zL1ZXnuFqlQ7UgW+NpCc
         UQ3jFolxogurWxVieHILYKItT7ruYBeOh3PfHZVv7bP4VqpR/Fu9+myq0yEZmmUInunz
         +fsotQ6em1eG8e33OMDx80Heq9x3tip70UfIAbTb0znqY0m4tPA2gIoBOQUH9BXCIXqs
         Db3LOyN57qQvE2GjPnGPt0piBqIe3qF4ro2yLzNYr+iITkKpH7JxK2JU2wsyxOrDBFhR
         RiB+U6X92s6G5XVA/jgL9M2Kuk2mR07j31VTtFkfkO5vKiypuNpa2AblotyEsr6emrzn
         qsaA==
X-Gm-Message-State: AO0yUKWK10mgKd2tbcDcoQ+GR8vkVekKo58xz/ujavtKsQXNmh6rRp13
        /PM/Io3kISby5dR5RJ9SOSs=
X-Google-Smtp-Source: AK7set/zhnvNypY3pveKGvBnHu7zkwsj26l3S9De2/SXKdcyKgt2tp5zk6MN8QYDy40TWIet9eK4XA==
X-Received: by 2002:a5d:6602:0:b0:2cf:e3c7:5975 with SMTP id n2-20020a5d6602000000b002cfe3c75975mr4936237wru.34.1678810649509;
        Tue, 14 Mar 2023 09:17:29 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id a16-20020a5d4570000000b002c5539171d1sm2426821wrc.41.2023.03.14.09.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:17:29 -0700 (PDT)
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
Subject: [net-next PATCH v3 06/14] net: phy: marvell: Add software control of the LEDs
Date:   Tue, 14 Mar 2023 11:15:08 +0100
Message-Id: <20230314101516.20427-7-ansuelsmth@gmail.com>
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

Add a brightness function, so the LEDs can be controlled from
software using the standard Linux LED infrastructure.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/phy/marvell.c | 45 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 0d706ee266af..e44a4a26346a 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -144,11 +144,13 @@
 /* WOL Event Interrupt Enable */
 #define MII_88E1318S_PHY_CSIER_WOL_EIE			BIT(7)
 
-/* LED Timer Control Register */
-#define MII_88E1318S_PHY_LED_TCR			0x12
-#define MII_88E1318S_PHY_LED_TCR_FORCE_INT		BIT(15)
-#define MII_88E1318S_PHY_LED_TCR_INTn_ENABLE		BIT(7)
-#define MII_88E1318S_PHY_LED_TCR_INT_ACTIVE_LOW		BIT(11)
+#define MII_88E1318S_PHY_LED_FUNC		0x10
+#define MII_88E1318S_PHY_LED_FUNC_OFF		(0x8)
+#define MII_88E1318S_PHY_LED_FUNC_ON		(0x9)
+#define MII_88E1318S_PHY_LED_TCR		0x12
+#define MII_88E1318S_PHY_LED_TCR_FORCE_INT	BIT(15)
+#define MII_88E1318S_PHY_LED_TCR_INTn_ENABLE	BIT(7)
+#define MII_88E1318S_PHY_LED_TCR_INT_ACTIVE_LOW	BIT(11)
 
 /* Magic Packet MAC address registers */
 #define MII_88E1318S_PHY_MAGIC_PACKET_WORD2		0x17
@@ -2832,6 +2834,34 @@ static int marvell_hwmon_probe(struct phy_device *phydev)
 }
 #endif
 
+static int m88e1318_led_brightness_set(struct phy_device *phydev,
+				       u32 index, enum led_brightness value)
+{
+	u16 reg;
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
+		if (value == LED_OFF)
+			reg |= MII_88E1318S_PHY_LED_FUNC_OFF << (4 * index);
+		else
+			reg |= MII_88E1318S_PHY_LED_FUNC_ON << (4 * index);
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
@@ -3081,6 +3111,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
+		.led_brightness_set = m88e1318_led_brightness_set,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1145,
@@ -3187,6 +3218,7 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_start = marvell_vct7_cable_test_start,
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
+		.led_brightness_set = m88e1318_led_brightness_set,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1540,
@@ -3213,6 +3245,7 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_start = marvell_vct7_cable_test_start,
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
+		.led_brightness_set = m88e1318_led_brightness_set,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1545,
@@ -3239,6 +3272,7 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_start = marvell_vct7_cable_test_start,
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
+		.led_brightness_set = m88e1318_led_brightness_set,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E3016,
@@ -3380,6 +3414,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
+		.led_brightness_set = m88e1318_led_brightness_set,
 	},
 };
 
-- 
2.39.2

