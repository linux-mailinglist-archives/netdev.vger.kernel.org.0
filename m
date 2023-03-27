Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAF96CA705
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbjC0OMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbjC0OLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:11:38 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D5159C4;
        Mon, 27 Mar 2023 07:11:11 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v1so8961447wrv.1;
        Mon, 27 Mar 2023 07:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679926270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bVPm5LTqdstAjglzeKOLAIOblz6QeFFvOdN+bAnB5DQ=;
        b=Uan5J+SgdnRacxOuVP6099V+JI4h1XGNzESQgiK5xEoWXOOvWXRVq5cht1ZHpsQWMF
         sUKGm0TzI4kfTAPPrj7KzBEtEhg8b3uMWJtwfkxUFgBdwa0mVKchwa0RGh7BaZuGfsLK
         rqT9V6l8ooWArRr8m8hLmQtpLOZ/22uK50mpp+W44IGu8dJ232+38pzzoSkQvfd6WH/e
         4YMTBoMJ+yWM/71DnROwsEbB7oMpwgU6ZSZE5/5AJ48Bu+3suM/m90/clTpC69oEIOcE
         1YaSfwftZmBlEQGYFmJSPWeMYORRjj4MQfpXEWCeba7381+HmbwxROcy7YftIY98AQWo
         hyjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bVPm5LTqdstAjglzeKOLAIOblz6QeFFvOdN+bAnB5DQ=;
        b=7va0VSBR0lD+X1PkaCSjnKR8HJ9auv6umKGt8ISjtlnf4jqYxGRUNcxPj3WrHrokHN
         2iGyxV6pJv4N/cu0Q1QuZyp03GE5zGxmvipL5dGN2agFo+4+/71kGrhMWLUBfIR+kfs7
         1JpqPAsBKu7DNO6ARuwpr8DSF95/xJBi8Pbo2WwzvPrEBRcu0IX1ZqADUFyF473PBgNn
         VS4XU8r76uykuIOsjiv1bfkaW4zhjN7OkSkVERycSthcBkexM2WDem9sfsZvWL5GQill
         3eYPhHqXm11WOXPG1M7lehAvup/gxbKujz07h10OMbkiyTkBzeFeojIZFgB4gxTKIjYu
         y45g==
X-Gm-Message-State: AAQBX9fiuBrZWRoTfbBh0Zuc7MVUDmyPPoWAy7nqPYvjZEtig0+snoDm
        h86xo9vWfmzhdKNLIUuoTWQ=
X-Google-Smtp-Source: AKy350abvzdSrHOKMaTGlNSixVNAaExuNPoky089FzZwCptwYSwuxnlFqHr2yDLLWfz+FivkGvjSHw==
X-Received: by 2002:adf:e9c3:0:b0:2da:90a8:7180 with SMTP id l3-20020adfe9c3000000b002da90a87180mr8921913wrn.3.1679926269816;
        Mon, 27 Mar 2023 07:11:09 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm25307591wrj.47.2023.03.27.07.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:11:09 -0700 (PDT)
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
Subject: [net-next PATCH v6 07/16] net: phy: marvell: Add software control of the LEDs
Date:   Mon, 27 Mar 2023 16:10:22 +0200
Message-Id: <20230327141031.11904-8-ansuelsmth@gmail.com>
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

Add a brightness function, so the LEDs can be controlled from
software using the standard Linux LED infrastructure.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/net/phy/marvell.c | 45 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 63a3644d86c9..5f4caca93983 100644
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

