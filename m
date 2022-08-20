Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479E059AE92
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 15:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346079AbiHTNyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 09:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345124AbiHTNyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 09:54:41 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE8D6F55B
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 06:54:39 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gi31so6994873ejc.5
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 06:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=o0rVWKWp8jtC9XyZCLngwZhFjWc+dVcwE5ndTbFrQqg=;
        b=DxOrIc+97iBtQ3YQ8twrOEaYXbCRHgSyQPf2z0El3uC/7350c2yIsSR7zB8ich9cmk
         2IKnLuzCPTP0YMC5F7GxoHT6u7lxYP7GdEb+fL5ubcY4a7zHYQEFg4Puik0IgzSVemsz
         IFsLdf0/IdQKO+xbfS1mc+F/0unUoRbOe4QsGD4CdOdnfaQnpbuJFocLdEvoPkHm7/1e
         E72cEMl8R422bXammo7bq+94c2LTuajeaWT+kB/T+cU4Oaf/brBCf4YNVBYh5v5Jx+qI
         7DwMEvwsbl7XtuZr+PyWFTMjJOFe0YLYcmglwqMluUP9U7Etee/dSKHQ7AnsCm1lYkjj
         dSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=o0rVWKWp8jtC9XyZCLngwZhFjWc+dVcwE5ndTbFrQqg=;
        b=ZqCWudoUcdWKKA7soHD8xMH6DTeOL4a+JrEgBQlFgg7aoplnPpBCNR6ewJu8g1ohmG
         joLEVW4AYn5faJugbFk7qd4K8HmRIYtvJLcCKQHM+CAR6p37h9H6DjjVN/sD+JkrgfbB
         lm71BajMVplitAdGbKl994lvX7rIYkmCuOPhwgipzqEg3/hi0OoXaJslyWHpCO+oEH1y
         8Qj7tFQV5VTk1jnN8VnpCYLlTud0w6IvYgQVikoJDr7Or9DctHU3Rqb429T4RgfjX9HE
         oKKirgr/q/RphjBx3toxjHv4Gy/K3J2jFr2JGnl6RoI79kJRXrSSs0fwP1Vf83KuAdPT
         6WpQ==
X-Gm-Message-State: ACgBeo1G9ll3HnQ7yF76VVKqStvNA0A9N8li9polE5mYPm6kcP/CqssP
        A+Y6SsiN9EaQwMYBpzTnW+E=
X-Google-Smtp-Source: AA6agR7f44WqJIm7LazlKh6NAm6vKoilYFZr7czssBpGqxH5F69OzMErcpj6gsc0R2iHikTTD3Xzow==
X-Received: by 2002:a17:907:2cf8:b0:730:d739:dc00 with SMTP id hz24-20020a1709072cf800b00730d739dc00mr8031734ejc.423.1661003678338;
        Sat, 20 Aug 2022 06:54:38 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c0bb:f700:3cb6:47a0:41b9:1531? (dynamic-2a01-0c23-c0bb-f700-3cb6-47a0-41b9-1531.c23.pool.telefonica.de. [2a01:c23:c0bb:f700:3cb6:47a0:41b9:1531])
        by smtp.googlemail.com with ESMTPSA id b9-20020a17090630c900b0073c9d68ca0dsm2674385ejb.133.2022.08.20.06.54.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Aug 2022 06:54:37 -0700 (PDT)
Message-ID: <470b2f1c-54bd-f6e9-1398-64d0cc204684@gmail.com>
Date:   Sat, 20 Aug 2022 15:53:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: [PATCH net-next 3/5] r8169: remove support for chip version 49
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e3d2fc9d-3ce7-b545-9cd1-6ad9fbe0adb7@gmail.com>
In-Reply-To: <e3d2fc9d-3ce7-b545-9cd1-6ad9fbe0adb7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Detection of this chip version has been disabled for few kernel versions now.
Nobody complained, so remove support for this chip version.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.h          |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c     | 26 ++-----------------
 .../net/ethernet/realtek/r8169_phy_config.c   | 22 ----------------
 3 files changed, 3 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
index a66b10850..7c85c4696 100644
--- a/drivers/net/ethernet/realtek/r8169.h
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -59,7 +59,7 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_46,
 	/* support for RTL_GIGA_MAC_VER_47 has been removed */
 	RTL_GIGA_MAC_VER_48,
-	RTL_GIGA_MAC_VER_49,
+	/* support for RTL_GIGA_MAC_VER_49 has been removed */
 	RTL_GIGA_MAC_VER_50,
 	RTL_GIGA_MAC_VER_51,
 	RTL_GIGA_MAC_VER_52,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0e7d10cd6..b22b80aab 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -134,7 +134,6 @@ static const struct {
 	[RTL_GIGA_MAC_VER_44] = {"RTL8411b",		FIRMWARE_8411_2 },
 	[RTL_GIGA_MAC_VER_46] = {"RTL8168h/8111h",	FIRMWARE_8168H_2},
 	[RTL_GIGA_MAC_VER_48] = {"RTL8107e",		FIRMWARE_8107E_2},
-	[RTL_GIGA_MAC_VER_49] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_50] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_51] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_52] = {"RTL8168fp/RTL8117",  FIRMWARE_8168FP_3},
@@ -885,7 +884,6 @@ static void rtl8168g_phy_suspend_quirk(struct rtl8169_private *tp, int value)
 {
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_40:
-	case RTL_GIGA_MAC_VER_49:
 		if (value & BMCR_RESET || !(value & BMCR_PDOWN))
 			rtl_eri_set_bits(tp, 0x1a8, 0xfc000000);
 		else
@@ -1199,7 +1197,7 @@ static enum rtl_dash_type rtl_check_dash(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_28:
 	case RTL_GIGA_MAC_VER_31:
 		return r8168dp_check_dash(tp) ? RTL_DASH_DP : RTL_DASH_NONE;
-	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_53:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
 		return r8168ep_check_dash(tp) ? RTL_DASH_EP : RTL_DASH_NONE;
 	default:
 		return RTL_DASH_NONE;
@@ -3278,25 +3276,6 @@ static void rtl_hw_start_8168ep(struct rtl8169_private *tp)
 	rtl_pcie_state_l2l3_disable(tp);
 }
 
-static void rtl_hw_start_8168ep_1(struct rtl8169_private *tp)
-{
-	static const struct ephy_info e_info_8168ep_1[] = {
-		{ 0x00, 0xffff,	0x10ab },
-		{ 0x06, 0xffff,	0xf030 },
-		{ 0x08, 0xffff,	0x2006 },
-		{ 0x0d, 0xffff,	0x1666 },
-		{ 0x0c, 0x3ff0,	0x0000 }
-	};
-
-	/* disable aspm and clock request before access ephy */
-	rtl_hw_aspm_clkreq_enable(tp, false);
-	rtl_ephy_init(tp, e_info_8168ep_1);
-
-	rtl_hw_start_8168ep(tp);
-
-	rtl_hw_aspm_clkreq_enable(tp, true);
-}
-
 static void rtl_hw_start_8168ep_2(struct rtl8169_private *tp)
 {
 	static const struct ephy_info e_info_8168ep_2[] = {
@@ -3743,7 +3722,6 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_44] = rtl_hw_start_8411_2,
 		[RTL_GIGA_MAC_VER_46] = rtl_hw_start_8168h_1,
 		[RTL_GIGA_MAC_VER_48] = rtl_hw_start_8168h_1,
-		[RTL_GIGA_MAC_VER_49] = rtl_hw_start_8168ep_1,
 		[RTL_GIGA_MAC_VER_50] = rtl_hw_start_8168ep_2,
 		[RTL_GIGA_MAC_VER_51] = rtl_hw_start_8168ep_3,
 		[RTL_GIGA_MAC_VER_52] = rtl_hw_start_8117,
@@ -5181,7 +5159,7 @@ static void rtl_hw_init_8125(struct rtl8169_private *tp)
 static void rtl_hw_initialize(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_53:
+	case RTL_GIGA_MAC_VER_50 ... RTL_GIGA_MAC_VER_53:
 		rtl8168ep_stop_cmac(tp);
 		fallthrough;
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_48:
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index 8653f678a..de1d78df4 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -830,27 +830,6 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp,
 	rtl8168g_config_eee_phy(phydev);
 }
 
-static void rtl8168ep_1_hw_phy_config(struct rtl8169_private *tp,
-				      struct phy_device *phydev)
-{
-	/* Enable PHY auto speed down */
-	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(3) | BIT(2));
-
-	rtl8168g_phy_adjust_10m_aldps(phydev);
-
-	/* Enable EEE auto-fallback function */
-	phy_modify_paged(phydev, 0x0a4b, 0x11, 0, BIT(2));
-
-	/* Enable UC LPF tune function */
-	r8168g_phy_param(phydev, 0x8012, 0x0000, 0x8000);
-
-	/* set rg_sel_sdm_rate */
-	phy_modify_paged(phydev, 0x0c42, 0x11, BIT(13), BIT(14));
-
-	rtl8168g_disable_aldps(phydev);
-	rtl8168g_config_eee_phy(phydev);
-}
-
 static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp,
 				      struct phy_device *phydev)
 {
@@ -1206,7 +1185,6 @@ void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
 		[RTL_GIGA_MAC_VER_44] = rtl8168g_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_46] = rtl8168h_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_48] = rtl8168h_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_49] = rtl8168ep_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_50] = rtl8168ep_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_51] = rtl8168ep_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_52] = rtl8117_hw_phy_config,
-- 
2.37.2


