Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C80659AE95
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 15:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346048AbiHTNyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 09:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346050AbiHTNyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 09:54:43 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B6E71726
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 06:54:41 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id fy5so13523631ejc.3
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 06:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=AnsJ0Y716eO2XCTb5oCUff8Jd6ejrCjSW0Iy98AvG/k=;
        b=XEBx36Gw6/lslYkotb4eg+KnhruymbgPMtCfN1sH/NMxbFY/8dtV97cgQ4CUzdJKeP
         1l414Fa6dr8BQ4CxCRNkH0ff/yfSWKQaHRA252JoC3ITfJfFqHocXfXDAzp2/L8aT9lx
         HnhF5I4iEUyw4Y5qu4d4yJBC2QFwpZPvxwWdrNJMgE5tsK+6CSdyIH3ALQkFFkcHmuKa
         5R8C8iIzCiVOhyZaS+GE+YL0gMleQFsFdDA49mPR3UIAhGrKLbpljtd8FDszrPZEn3jD
         YakVqi5WS+4ASWK5Sb7ofzFEovnIOiRsvMB40VBIieqqpavownzvLOJiguEc7+dL5Lwg
         cgjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=AnsJ0Y716eO2XCTb5oCUff8Jd6ejrCjSW0Iy98AvG/k=;
        b=Vw3ApdMgBw/vdIpo7gNgwCwVUPWAGzdCRa4shiJ4kB+GBYb3du0WRXQJUHAfPT1TI2
         eVOvz0yInnYD0G3H0D9taCECpaJcNhMmmaUG7KD0sG/oPRvziEWYnX8ALO/9wsgYMdrF
         hdpZ8MYi8Bi0Gr3yPYeWLFqT42VHK3Dddu5z/qBatt7b0ZOFDq6ryXQC5CXaH13C3YE5
         8727Sr2annCP4McPk5mdi5RtliUB8mM5xfBPm5tY6Q64CAchbshUTB6Sbu6NEPL9HHoq
         Frdc6TRk5l3Sq3auzeCR0A+C33jVzt9+Cf8lr4gxKaADCnxxLvnYwbUZHOmk6xx4v9/h
         pM8g==
X-Gm-Message-State: ACgBeo0aIeusf0gp9FeDnOh3ql2xUCa2dc74qiDd6bqBbFeu3fvWKNg4
        shRD6ayFVn6SbUWMTizVjfiD28VF0x0=
X-Google-Smtp-Source: AA6agR5Ci/zygphfWi9H1+2cg4KgtaQH4GRIgan2MEN1XOulHEa4UlKUFws53CFzQhE59mr7Z4HGGw==
X-Received: by 2002:a17:907:2814:b0:738:545f:54be with SMTP id eb20-20020a170907281400b00738545f54bemr7709740ejc.534.1661003681071;
        Sat, 20 Aug 2022 06:54:41 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c0bb:f700:3cb6:47a0:41b9:1531? (dynamic-2a01-0c23-c0bb-f700-3cb6-47a0-41b9-1531.c23.pool.telefonica.de. [2a01:c23:c0bb:f700:3cb6:47a0:41b9:1531])
        by smtp.googlemail.com with ESMTPSA id r5-20020a056402018500b00445f8e0a86esm4669253edv.75.2022.08.20.06.54.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Aug 2022 06:54:40 -0700 (PDT)
Message-ID: <d29ec7ee-931f-6dd0-4a15-0e05eb8cf773@gmail.com>
Date:   Sat, 20 Aug 2022 15:54:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: [PATCH net-next 5/5] r8169: remove support for chip version 60
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
 drivers/net/ethernet/realtek/r8169_main.c     | 57 +++----------------
 .../net/ethernet/realtek/r8169_phy_config.c   | 39 -------------
 3 files changed, 8 insertions(+), 90 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
index 68cd71289..36d382676 100644
--- a/drivers/net/ethernet/realtek/r8169.h
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -64,7 +64,7 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_51,
 	RTL_GIGA_MAC_VER_52,
 	RTL_GIGA_MAC_VER_53,
-	RTL_GIGA_MAC_VER_60,
+	/* support for RTL_GIGA_MAC_VER_60 has been removed */
 	RTL_GIGA_MAC_VER_61,
 	RTL_GIGA_MAC_VER_63,
 	RTL_GIGA_MAC_NONE
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index db653776e..243477825 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -137,7 +137,6 @@ static const struct {
 	[RTL_GIGA_MAC_VER_51] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_52] = {"RTL8168fp/RTL8117",  FIRMWARE_8168FP_3},
 	[RTL_GIGA_MAC_VER_53] = {"RTL8168fp/RTL8117",			},
-	[RTL_GIGA_MAC_VER_60] = {"RTL8125A"				},
 	[RTL_GIGA_MAC_VER_61] = {"RTL8125A",		FIRMWARE_8125A_3},
 	/* reserve 62 for CFG_METHOD_4 in the vendor driver */
 	[RTL_GIGA_MAC_VER_63] = {"RTL8125B",		FIRMWARE_8125B_2},
@@ -680,7 +679,7 @@ static void rtl_pci_commit(struct rtl8169_private *tp)
 
 static bool rtl_is_8125(struct rtl8169_private *tp)
 {
-	return tp->mac_version >= RTL_GIGA_MAC_VER_60;
+	return tp->mac_version >= RTL_GIGA_MAC_VER_61;
 }
 
 static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
@@ -2258,7 +2257,7 @@ static void rtl_init_rxcfg(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
 		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
 		break;
-	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
+	case RTL_GIGA_MAC_VER_61 ... RTL_GIGA_MAC_VER_63:
 		RTL_W32(tp, RxConfig, RX_FETCH_DFLT_8125 | RX_DMA_BURST);
 		break;
 	default:
@@ -2442,7 +2441,7 @@ static void rtl_wait_txrx_fifo_empty(struct rtl8169_private *tp)
 		rtl_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 42);
 		rtl_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42);
 		break;
-	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_61:
+	case RTL_GIGA_MAC_VER_61 ... RTL_GIGA_MAC_VER_61:
 		rtl_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42);
 		break;
 	case RTL_GIGA_MAC_VER_63:
@@ -2688,7 +2687,7 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 
 		switch (tp->mac_version) {
 		case RTL_GIGA_MAC_VER_46 ... RTL_GIGA_MAC_VER_48:
-		case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
+		case RTL_GIGA_MAC_VER_61 ... RTL_GIGA_MAC_VER_63:
 			/* reset ephy tx/rx disable timer */
 			r8168_mac_ocp_modify(tp, 0xe094, 0xff00, 0);
 			/* chip can trigger L1.2 */
@@ -2700,7 +2699,7 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 	} else {
 		switch (tp->mac_version) {
 		case RTL_GIGA_MAC_VER_46 ... RTL_GIGA_MAC_VER_48:
-		case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
+		case RTL_GIGA_MAC_VER_61 ... RTL_GIGA_MAC_VER_63:
 			r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, 0);
 			break;
 		default:
@@ -3573,46 +3572,6 @@ static void rtl_hw_start_8125_common(struct rtl8169_private *tp)
 	udelay(10);
 }
 
-static void rtl_hw_start_8125a_1(struct rtl8169_private *tp)
-{
-	static const struct ephy_info e_info_8125a_1[] = {
-		{ 0x01, 0xffff, 0xa812 },
-		{ 0x09, 0xffff, 0x520c },
-		{ 0x04, 0xffff, 0xd000 },
-		{ 0x0d, 0xffff, 0xf702 },
-		{ 0x0a, 0xffff, 0x8653 },
-		{ 0x06, 0xffff, 0x001e },
-		{ 0x08, 0xffff, 0x3595 },
-		{ 0x20, 0xffff, 0x9455 },
-		{ 0x21, 0xffff, 0x99ff },
-		{ 0x02, 0xffff, 0x6046 },
-		{ 0x29, 0xffff, 0xfe00 },
-		{ 0x23, 0xffff, 0xab62 },
-
-		{ 0x41, 0xffff, 0xa80c },
-		{ 0x49, 0xffff, 0x520c },
-		{ 0x44, 0xffff, 0xd000 },
-		{ 0x4d, 0xffff, 0xf702 },
-		{ 0x4a, 0xffff, 0x8653 },
-		{ 0x46, 0xffff, 0x001e },
-		{ 0x48, 0xffff, 0x3595 },
-		{ 0x60, 0xffff, 0x9455 },
-		{ 0x61, 0xffff, 0x99ff },
-		{ 0x42, 0xffff, 0x6046 },
-		{ 0x69, 0xffff, 0xfe00 },
-		{ 0x63, 0xffff, 0xab62 },
-	};
-
-	rtl_set_def_aspm_entry_latency(tp);
-
-	/* disable aspm and clock request before access ephy */
-	rtl_hw_aspm_clkreq_enable(tp, false);
-	rtl_ephy_init(tp, e_info_8125a_1);
-
-	rtl_hw_start_8125_common(tp);
-	rtl_hw_aspm_clkreq_enable(tp, true);
-}
-
 static void rtl_hw_start_8125a_2(struct rtl8169_private *tp)
 {
 	static const struct ephy_info e_info_8125a_2[] = {
@@ -3704,7 +3663,6 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_51] = rtl_hw_start_8168ep_3,
 		[RTL_GIGA_MAC_VER_52] = rtl_hw_start_8117,
 		[RTL_GIGA_MAC_VER_53] = rtl_hw_start_8117,
-		[RTL_GIGA_MAC_VER_60] = rtl_hw_start_8125a_1,
 		[RTL_GIGA_MAC_VER_61] = rtl_hw_start_8125a_2,
 		[RTL_GIGA_MAC_VER_63] = rtl_hw_start_8125b,
 	};
@@ -4099,7 +4057,6 @@ static unsigned int rtl_quirk_packet_padto(struct rtl8169_private *tp,
 
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_34:
-	case RTL_GIGA_MAC_VER_60:
 	case RTL_GIGA_MAC_VER_61:
 	case RTL_GIGA_MAC_VER_63:
 		padto = max_t(unsigned int, padto, ETH_ZLEN);
@@ -5143,7 +5100,7 @@ static void rtl_hw_initialize(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_48:
 		rtl_hw_init_8168g(tp);
 		break;
-	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
+	case RTL_GIGA_MAC_VER_61 ... RTL_GIGA_MAC_VER_63:
 		rtl_hw_init_8125(tp);
 		break;
 	default:
@@ -5234,7 +5191,7 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
 /* register is set if system vendor successfully tested ASPM 1.2 */
 static bool rtl_aspm_is_safe(struct rtl8169_private *tp)
 {
-	if (tp->mac_version >= RTL_GIGA_MAC_VER_60 &&
+	if (tp->mac_version >= RTL_GIGA_MAC_VER_61 &&
 	    r8168_mac_ocp_read(tp, 0xc0b2) & 0xf)
 		return true;
 
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index 99e4f06f8..8c04cc56b 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -995,44 +995,6 @@ static void rtl8125_legacy_force_mode(struct phy_device *phydev)
 	phy_modify_paged(phydev, 0xa5b, 0x12, BIT(15), 0);
 }
 
-static void rtl8125a_1_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	phy_modify_paged(phydev, 0xad4, 0x10, 0x03ff, 0x0084);
-	phy_modify_paged(phydev, 0xad4, 0x17, 0x0000, 0x0010);
-	phy_modify_paged(phydev, 0xad1, 0x13, 0x03ff, 0x0006);
-	phy_modify_paged(phydev, 0xad3, 0x11, 0x003f, 0x0006);
-	phy_modify_paged(phydev, 0xac0, 0x14, 0x0000, 0x1100);
-	phy_modify_paged(phydev, 0xac8, 0x15, 0xf000, 0x7000);
-	phy_modify_paged(phydev, 0xad1, 0x14, 0x0000, 0x0400);
-	phy_modify_paged(phydev, 0xad1, 0x15, 0x0000, 0x03ff);
-	phy_modify_paged(phydev, 0xad1, 0x16, 0x0000, 0x03ff);
-
-	r8168g_phy_param(phydev, 0x80ea, 0xff00, 0xc400);
-	r8168g_phy_param(phydev, 0x80eb, 0x0700, 0x0300);
-	r8168g_phy_param(phydev, 0x80f8, 0xff00, 0x1c00);
-	r8168g_phy_param(phydev, 0x80f1, 0xff00, 0x3000);
-	r8168g_phy_param(phydev, 0x80fe, 0xff00, 0xa500);
-	r8168g_phy_param(phydev, 0x8102, 0xff00, 0x5000);
-	r8168g_phy_param(phydev, 0x8105, 0xff00, 0x3300);
-	r8168g_phy_param(phydev, 0x8100, 0xff00, 0x7000);
-	r8168g_phy_param(phydev, 0x8104, 0xff00, 0xf000);
-	r8168g_phy_param(phydev, 0x8106, 0xff00, 0x6500);
-	r8168g_phy_param(phydev, 0x80dc, 0xff00, 0xed00);
-	r8168g_phy_param(phydev, 0x80df, 0x0000, 0x0100);
-	r8168g_phy_param(phydev, 0x80e1, 0x0100, 0x0000);
-
-	phy_modify_paged(phydev, 0xbf0, 0x13, 0x003f, 0x0038);
-	r8168g_phy_param(phydev, 0x819f, 0xffff, 0xd0b6);
-
-	phy_write_paged(phydev, 0xbc3, 0x12, 0x5555);
-	phy_modify_paged(phydev, 0xbf0, 0x15, 0x0e00, 0x0a00);
-	phy_modify_paged(phydev, 0xa5c, 0x10, 0x0400, 0x0000);
-	rtl8168g_enable_gphy_10m(phydev);
-
-	rtl8125a_config_eee_phy(phydev);
-}
-
 static void rtl8125a_2_hw_phy_config(struct rtl8169_private *tp,
 				     struct phy_device *phydev)
 {
@@ -1188,7 +1150,6 @@ void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
 		[RTL_GIGA_MAC_VER_51] = rtl8168ep_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_52] = rtl8117_hw_phy_config,
 		[RTL_GIGA_MAC_VER_53] = rtl8117_hw_phy_config,
-		[RTL_GIGA_MAC_VER_60] = rtl8125a_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_61] = rtl8125a_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_63] = rtl8125b_hw_phy_config,
 	};
-- 
2.37.2


