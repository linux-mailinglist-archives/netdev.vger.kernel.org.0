Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683E16AF8E2
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbjCGWdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjCGWdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:33:36 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978A19CBF4;
        Tue,  7 Mar 2023 14:33:32 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id p16so8741995wmq.5;
        Tue, 07 Mar 2023 14:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678228411;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YjQ9zUptjAK9h5PeGCnuwsF6N6MpAnfvAgnGqTv2rz4=;
        b=GkLKswhEJ9JuupGG6E3ZcmL7Zm/7UGS+ozpbz8erPkYNUz6oOWiB54xmyleejG5j02
         Mptq4VsYzAZzm3aGEHga9EJtlkULAs6Ek49Q0YkaJ/rIupmaSL3+N7mjiUAY8tTWIxAQ
         QMr4a8L/5lJGvOPJPuB5FyLRpNCkFB8gaYrKVP7gyH73H1WdiTyVJlEkcNzf0EUIzNi1
         1skSrABkofuK7Vw8xeVL7jJY5TS1x0ebU0KpRNrjL1l9sTKwhEMUKtHRqm5JYNGJkOOB
         FLAVUn6Lk6ylJZ9VaOKW4TH2swOLEZ6RimgLk52jdEb6KbDxfmeYZC3DkZ1t9PFBH0Oa
         0SXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678228411;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YjQ9zUptjAK9h5PeGCnuwsF6N6MpAnfvAgnGqTv2rz4=;
        b=pPznldiSYkcIereEEdF8n0gpiGEqXamCxUjHhDgu2Pmy/FaeiX7qp/Z2X192YEDkjJ
         qkCmuxozgqEOhdiIwPi/lVqQqPN8K/NbBdDMdjBOwH+f5/l3v3rC0qbqqgl57dxWfbpC
         KTpJULXdux3RFntYFUAFYF7DrfxxZHlgeRpYmmj7Ty2vP2uGaEehPF6ulEQsL185FQoo
         qc+hMT08+ByLeL17EkiGwr3RGL52KqSYSMpf3vVGVWmpviDtu2kJjCkEyn9ANUqiErEY
         S/i5iUuoveV6jJ1W4oz9pNo1AFnc4dwHoQmEPAqmUNNep6ow4v6rGHhcbrfWrgZRqyWa
         ilOg==
X-Gm-Message-State: AO0yUKXyo2eT3o6mHYcfhrIZuBcGA5KEPoMo8ChEU9NE0GzQyna0lSg+
        j9XveyROwbTRwtrfdGh53EU=
X-Google-Smtp-Source: AK7set9l0qDHMnv3eD+X7VfkfGOlqB4qKtpI1Na/Z2zrCkh0ePpNtbjGoHUxOy77dtVVhiZw8WwgUA==
X-Received: by 2002:a05:600c:a48:b0:3da:acb1:2f09 with SMTP id c8-20020a05600c0a4800b003daacb12f09mr14888815wmq.19.1678228410991;
        Tue, 07 Mar 2023 14:33:30 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id q11-20020a05600c46cb00b003dc1d668866sm19233101wmo.10.2023.03.07.14.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 14:33:30 -0800 (PST)
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
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH 05/11] net: phy: marvell: Add software control of the LEDs
Date:   Tue,  7 Mar 2023 18:00:40 +0100
Message-Id: <20230307170046.28917-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170046.28917-1-ansuelsmth@gmail.com>
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
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

