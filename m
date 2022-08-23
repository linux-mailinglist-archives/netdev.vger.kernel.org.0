Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A697D59E4D8
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 16:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240337AbiHWOD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 10:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243840AbiHWOBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 10:01:22 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5658B5E5C
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 04:09:17 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id u15so18010709ejt.6
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 04:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=A6i/QEneWbzZZ/g6NI6Uy3TEdhc/E5BhHsrYfek3YM8=;
        b=nq1pw5BNYTwX5MkTN5oljl46vo8BsoB7/RPy2DgSwAqN5NBK4pkBCvDODYzyjOlF2e
         oD8WIAsCwSQAaI0gi5LFt20MoA7qn5ivtgUPSt54j3yRDNKSjQbSwD2lXUcbeIvtPd8I
         VHlbFzbPOVv1Y/JcX2Lq0YOEYh2ioNyrenxyFKZ6ipCPcfpI+y2i/DjTuvsQ8zSBzLIy
         U+HTuUWXkn59DoBHsrv96m7BUztnHflhIE5031jgqyFVCurrn88QfP18fntFO8hJhC3l
         FH/8GY7Xrn58SRfMhIappwPR47imLfcynqwkHkSJF94w66hrmIuUAH254xMYQ0edNrMc
         XsxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=A6i/QEneWbzZZ/g6NI6Uy3TEdhc/E5BhHsrYfek3YM8=;
        b=M7AMFOmM1NTLc5A+vdUExZSm+7jF3WvYoM7s3jZHX8/iJiFEG0ZoKnpOd8/LhKG9jQ
         aE1q6PgyXHbSv/Ts9kOI2XfcB7KJFWb/zkOmALviS2/fE9gTPnApLOd2xvPO5tqW71Mc
         gDF5MQEBqxZy8gDH14l0tTKg/r34L6QGOGt6G4Wiv0CjYbbOvHL1l1KAGP2txdp57R9N
         FGFEcok4Y0QlQF5BAYigHFhL0tWShUTOM13P1fRNVpkWaeb6TCV7IhSk1JEsccJ7Ztmu
         X6Maa/gLzgnfSFPkb46jcTJsYIZSUQlXoe+D5SO8hh1uqI1Mz/YkIYjOEvpt1+fQjxaD
         uZOQ==
X-Gm-Message-State: ACgBeo3hRGd0gl+/J6oaF4IpvurADSx0xtJ5LTiS+IBmSHLfuUfI7bSD
        9uDXSW1zTN0/I0V+z/Nxn/0=
X-Google-Smtp-Source: AA6agR6ImKzC4Fc6pG6cdBqzA+fi2vaY0ie976k+nEIiO26WtVNNlvaBoCvn4sGZ+cr5orDZxNawWA==
X-Received: by 2002:a17:907:284a:b0:73d:a818:5a2a with SMTP id el10-20020a170907284a00b0073da8185a2amr505185ejc.159.1661252888200;
        Tue, 23 Aug 2022 04:08:08 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7758:1500:d4cf:79a3:3d29:c3f8? (dynamic-2a01-0c22-7758-1500-d4cf-79a3-3d29-c3f8.c22.pool.telefonica.de. [2a01:c22:7758:1500:d4cf:79a3:3d29:c3f8])
        by smtp.googlemail.com with ESMTPSA id z22-20020a170906435600b007308812ce89sm7358165ejm.168.2022.08.23.04.08.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 04:08:07 -0700 (PDT)
Message-ID: <98c9b799-cd8e-e4a7-5a74-8cdbaa60ff4b@gmail.com>
Date:   Tue, 23 Aug 2022 13:06:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: [PATCH net-next v2 3/5] r8169: remove support for chip version 49
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ceb7b283-a41a-6c7d-1b63-7909da2c8a7a@gmail.com>
In-Reply-To: <ceb7b283-a41a-6c7d-1b63-7909da2c8a7a@gmail.com>
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

v2:
- fix a typo: RTL_GIGA_MAC_VER_40 -> RTL_GIGA_MAC_VER_50

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
+	case RTL_GIGA_MAC_VER_50 ... RTL_GIGA_MAC_VER_53:
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

