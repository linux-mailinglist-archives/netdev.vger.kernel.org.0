Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D196E4CD4
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjDQPWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbjDQPVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:21:51 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F98B75E;
        Mon, 17 Apr 2023 08:20:57 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id he13so18996412wmb.2;
        Mon, 17 Apr 2023 08:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744855; x=1684336855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y9JlsERZxRAysF1OXmKg0b+HpklwlxOxkniV02+TBEI=;
        b=LAZZxjJsOwUZ/sE1o8nYTYBulM25lMrgdyvQurhhvYpFH/Ww7bS5AFP0iesQaoR7oS
         4tH93IMi/1lGcgy21Bk9BRx5NiHf1oHHXUElb+vcJbyNyQMGmUMomGlM1KgklJcGzGfA
         W7Vtwp0fNC5Bt5Nl+FrI8RSTKZC+5QmR1GLTwvp9JbFSshS1yXO1NpoJusiW6b9yplAD
         TNPqMC/Wp/OTw38CdtCkPGorNzi+1jAXNi4nNzd+k1krBmmwzQL4KiuTf3Iud3NaKzEN
         a/VOc5A2oUWWWXdctaoWfv0vp/MbTqLoQ/qJMfo8npdhQUBUJaVT2IBrUCeICoBAr8G5
         Sl6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744855; x=1684336855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y9JlsERZxRAysF1OXmKg0b+HpklwlxOxkniV02+TBEI=;
        b=iXdv1NDjzq/2SG8upOJCE2/MMzL1/INJeZGA2lrDwdMq/fOtM+Gs35C7g3PL54tbtq
         +dQ40oxChFjSs+UpUs8ulBgPQJ0W4j7HL00JP+MTDh+xxAAQZy1t5CBK6MsHEH/A70ji
         UTu0KExHNJ5VPenOBZ2F2IB7H0zLxwlK70sCgejIlC/9BpfyP6eZh2FSZFNTBujFuFsz
         pVlSv1RXPLo6FhfZzCRIxWXZOXwZpl5zENv7ydqyWR0rcnrGQvSBV4PoMM8KLyuGvDR3
         r1L8dN0W8tqBj5C3k7rHRw9erb8TYV1lSomZqknWaLOd5/4tVc8h7ylbOHh2gXJTwuHn
         Jx4w==
X-Gm-Message-State: AAQBX9emkhDusUizdQdRWxTkK53O51949JPA58PTECwd056PxufzIT5g
        bPkZL20fIFLDT1VvsToHOGY=
X-Google-Smtp-Source: AKy350YDjkgW5+FGV2rl9VjXreEK2H0WzLXx9qAi/BtaTOcKaFc4PYiWdODow7vRCsJXq529fvGEJg==
X-Received: by 2002:a7b:c8c9:0:b0:3f1:727d:77a6 with SMTP id f9-20020a7bc8c9000000b003f1727d77a6mr3916198wml.3.1681744855421;
        Mon, 17 Apr 2023 08:20:55 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c1c0f00b003f173be2ccfsm3501354wms.2.2023.04.17.08.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:20:48 -0700 (PDT)
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
Subject: [net-next PATCH v7 07/16] net: phy: marvell: Add software control of the LEDs
Date:   Mon, 17 Apr 2023 17:17:29 +0200
Message-Id: <20230417151738.19426-8-ansuelsmth@gmail.com>
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

Add a brightness function, so the LEDs can be controlled from
software using the standard Linux LED infrastructure.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/marvell.c | 45 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 24853e9a889e..8d1eb4c4e1ab 100644
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
+				       u8 index, enum led_brightness value)
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

