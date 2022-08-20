Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C9C59AE96
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 15:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345927AbiHTNyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 09:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345124AbiHTNyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 09:54:39 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16FC71711
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 06:54:37 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 2so655712edx.2
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 06:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=NSAqLKm5v7LC885LP4TJhDfY36sDMzCl5TSFE2NC9zg=;
        b=aylavSVT66kIHULzscnHCKs2HPGDSG95iyeHeOY5M8OExZRl/jGOadcYiFILphqZbi
         qJFaokZhgM6n8PueU6H00jYFEnlK7SPo6wihCDmpRywNCUxtUKtIIMWteALOydFFQke6
         qQhhlSrP8mgerPROV0r9HKIgG4DsEaUAQlEE6q6ppQIxcTvR1KFgh59LGuds4ZXojF6H
         XpeaeW1TBNEpzmKAFQG2BCIxyRpwdw94MYePC+oUfOIk255uQ75uhf+v7p1gHLSHoGaZ
         5xoga9eHPirJa9/Ry5/T6l0HOExDDJJuXq0Z2DGZx+TMZTha2W9+cWn1Hl0g3SFlCQ9b
         wpkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=NSAqLKm5v7LC885LP4TJhDfY36sDMzCl5TSFE2NC9zg=;
        b=zrP2+0Q6eAf9SMKxUiaNT9u5I2y+j+RdPzxdOf5O6unczbT6Tv2IjhHAPWr94WX9OC
         URZcUsowfmV0qCV95+WmcM5F3E00hyLYLUNvokw1OoFPtJqcXgTxUtUnR65g+9pxres7
         gNSEbQyUFL5m9y/MdghLXkmDWyiopBMrFT8TBNPvFCKOUSdwUuQt/0JzZsdMTeJE6vQt
         eo0eAlvx7dSTlW1b+HfJ5VuSMxvgwEYylkpU48UH3M//U2ZaaO81W4RVQ63bgnC50ySR
         m4ZYuVM/tC0l1zOaMeuCdwo1sJdTqm5QvFmH8UHjHwzvDqza9iXBZXkNEVOqJzTU4hqT
         bjbw==
X-Gm-Message-State: ACgBeo1FNIfCvpIRmqciRuKijYBRO9R0fGsEaHmd5mG4poLAFHxKnr2z
        mHl7qY6a+2An/tBTpEe62hLkHZbTbUI=
X-Google-Smtp-Source: AA6agR4YjrOQc0rl+lO4Th1+vLBG9bcDcSG2tNNlSXLNGXWdH9Zl12EuHKpzCgAyQ/mACitX3laYug==
X-Received: by 2002:a05:6402:4282:b0:43e:612c:fcf7 with SMTP id g2-20020a056402428200b0043e612cfcf7mr9571734edc.242.1661003676537;
        Sat, 20 Aug 2022 06:54:36 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c0bb:f700:3cb6:47a0:41b9:1531? (dynamic-2a01-0c23-c0bb-f700-3cb6-47a0-41b9-1531.c23.pool.telefonica.de. [2a01:c23:c0bb:f700:3cb6:47a0:41b9:1531])
        by smtp.googlemail.com with ESMTPSA id q12-20020a1709060f8c00b007308bdef04bsm3637215ejj.103.2022.08.20.06.54.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Aug 2022 06:54:35 -0700 (PDT)
Message-ID: <debd8685-9da1-fef0-b47f-5de784bea555@gmail.com>
Date:   Sat, 20 Aug 2022 15:52:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: [PATCH net-next 2/5] r8169: remove support for chip versions 45 and
 47
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

Detection of these chip versions has been disabled for few kernel versions now.
Nobody complained, so remove support for this chip version.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.h          |  4 +-
 drivers/net/ethernet/realtek/r8169_main.c     | 16 +----
 .../net/ethernet/realtek/r8169_phy_config.c   | 67 -------------------
 3 files changed, 5 insertions(+), 82 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
index e2ace50e0..a66b10850 100644
--- a/drivers/net/ethernet/realtek/r8169.h
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -55,9 +55,9 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_42,
 	RTL_GIGA_MAC_VER_43,
 	RTL_GIGA_MAC_VER_44,
-	RTL_GIGA_MAC_VER_45,
+	/* support for RTL_GIGA_MAC_VER_45 has been removed */
 	RTL_GIGA_MAC_VER_46,
-	RTL_GIGA_MAC_VER_47,
+	/* support for RTL_GIGA_MAC_VER_47 has been removed */
 	RTL_GIGA_MAC_VER_48,
 	RTL_GIGA_MAC_VER_49,
 	RTL_GIGA_MAC_VER_50,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a2baeb8da..0e7d10cd6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -49,10 +49,8 @@
 #define FIRMWARE_8106E_2	"rtl_nic/rtl8106e-2.fw"
 #define FIRMWARE_8168G_2	"rtl_nic/rtl8168g-2.fw"
 #define FIRMWARE_8168G_3	"rtl_nic/rtl8168g-3.fw"
-#define FIRMWARE_8168H_1	"rtl_nic/rtl8168h-1.fw"
 #define FIRMWARE_8168H_2	"rtl_nic/rtl8168h-2.fw"
 #define FIRMWARE_8168FP_3	"rtl_nic/rtl8168fp-3.fw"
-#define FIRMWARE_8107E_1	"rtl_nic/rtl8107e-1.fw"
 #define FIRMWARE_8107E_2	"rtl_nic/rtl8107e-2.fw"
 #define FIRMWARE_8125A_3	"rtl_nic/rtl8125a-3.fw"
 #define FIRMWARE_8125B_2	"rtl_nic/rtl8125b-2.fw"
@@ -134,9 +132,7 @@ static const struct {
 	[RTL_GIGA_MAC_VER_42] = {"RTL8168gu/8111gu",	FIRMWARE_8168G_3},
 	[RTL_GIGA_MAC_VER_43] = {"RTL8106eus",		FIRMWARE_8106E_2},
 	[RTL_GIGA_MAC_VER_44] = {"RTL8411b",		FIRMWARE_8411_2 },
-	[RTL_GIGA_MAC_VER_45] = {"RTL8168h/8111h",	FIRMWARE_8168H_1},
 	[RTL_GIGA_MAC_VER_46] = {"RTL8168h/8111h",	FIRMWARE_8168H_2},
-	[RTL_GIGA_MAC_VER_47] = {"RTL8107e",		FIRMWARE_8107E_1},
 	[RTL_GIGA_MAC_VER_48] = {"RTL8107e",		FIRMWARE_8107E_2},
 	[RTL_GIGA_MAC_VER_49] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_50] = {"RTL8168ep/8111ep"			},
@@ -657,10 +653,8 @@ MODULE_FIRMWARE(FIRMWARE_8106E_1);
 MODULE_FIRMWARE(FIRMWARE_8106E_2);
 MODULE_FIRMWARE(FIRMWARE_8168G_2);
 MODULE_FIRMWARE(FIRMWARE_8168G_3);
-MODULE_FIRMWARE(FIRMWARE_8168H_1);
 MODULE_FIRMWARE(FIRMWARE_8168H_2);
 MODULE_FIRMWARE(FIRMWARE_8168FP_3);
-MODULE_FIRMWARE(FIRMWARE_8107E_1);
 MODULE_FIRMWARE(FIRMWARE_8107E_2);
 MODULE_FIRMWARE(FIRMWARE_8125A_3);
 MODULE_FIRMWARE(FIRMWARE_8125B_2);
@@ -2086,8 +2080,6 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 	if (ver != RTL_GIGA_MAC_NONE && !gmii) {
 		if (ver == RTL_GIGA_MAC_VER_42)
 			ver = RTL_GIGA_MAC_VER_43;
-		else if (ver == RTL_GIGA_MAC_VER_45)
-			ver = RTL_GIGA_MAC_VER_47;
 		else if (ver == RTL_GIGA_MAC_VER_46)
 			ver = RTL_GIGA_MAC_VER_48;
 	}
@@ -2698,7 +2690,7 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
 
 		switch (tp->mac_version) {
-		case RTL_GIGA_MAC_VER_45 ... RTL_GIGA_MAC_VER_48:
+		case RTL_GIGA_MAC_VER_46 ... RTL_GIGA_MAC_VER_48:
 		case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
 			/* reset ephy tx/rx disable timer */
 			r8168_mac_ocp_modify(tp, 0xe094, 0xff00, 0);
@@ -2710,7 +2702,7 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 		}
 	} else {
 		switch (tp->mac_version) {
-		case RTL_GIGA_MAC_VER_45 ... RTL_GIGA_MAC_VER_48:
+		case RTL_GIGA_MAC_VER_46 ... RTL_GIGA_MAC_VER_48:
 		case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
 			r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, 0);
 			break;
@@ -3749,9 +3741,7 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_42] = rtl_hw_start_8168g_2,
 		[RTL_GIGA_MAC_VER_43] = rtl_hw_start_8168g_2,
 		[RTL_GIGA_MAC_VER_44] = rtl_hw_start_8411_2,
-		[RTL_GIGA_MAC_VER_45] = rtl_hw_start_8168h_1,
 		[RTL_GIGA_MAC_VER_46] = rtl_hw_start_8168h_1,
-		[RTL_GIGA_MAC_VER_47] = rtl_hw_start_8168h_1,
 		[RTL_GIGA_MAC_VER_48] = rtl_hw_start_8168h_1,
 		[RTL_GIGA_MAC_VER_49] = rtl_hw_start_8168ep_1,
 		[RTL_GIGA_MAC_VER_50] = rtl_hw_start_8168ep_2,
@@ -5375,7 +5365,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	if (rtl_aspm_is_safe(tp))
 		rc = 0;
-	else if (tp->mac_version >= RTL_GIGA_MAC_VER_45)
+	else if (tp->mac_version >= RTL_GIGA_MAC_VER_46)
 		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
 	else
 		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index 2b4bc2d6f..8653f678a 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -793,71 +793,6 @@ static void rtl8168g_2_hw_phy_config(struct rtl8169_private *tp,
 	rtl8168g_config_eee_phy(phydev);
 }
 
-static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	u16 dout_tapbin;
-	u32 data;
-
-	r8169_apply_firmware(tp);
-
-	/* CHN EST parameters adjust - giga master */
-	r8168g_phy_param(phydev, 0x809b, 0xf800, 0x8000);
-	r8168g_phy_param(phydev, 0x80a2, 0xff00, 0x8000);
-	r8168g_phy_param(phydev, 0x80a4, 0xff00, 0x8500);
-	r8168g_phy_param(phydev, 0x809c, 0xff00, 0xbd00);
-
-	/* CHN EST parameters adjust - giga slave */
-	r8168g_phy_param(phydev, 0x80ad, 0xf800, 0x7000);
-	r8168g_phy_param(phydev, 0x80b4, 0xff00, 0x5000);
-	r8168g_phy_param(phydev, 0x80ac, 0xff00, 0x4000);
-
-	/* CHN EST parameters adjust - fnet */
-	r8168g_phy_param(phydev, 0x808e, 0xff00, 0x1200);
-	r8168g_phy_param(phydev, 0x8090, 0xff00, 0xe500);
-	r8168g_phy_param(phydev, 0x8092, 0xff00, 0x9f00);
-
-	/* enable R-tune & PGA-retune function */
-	dout_tapbin = 0;
-	data = phy_read_paged(phydev, 0x0a46, 0x13);
-	data &= 3;
-	data <<= 2;
-	dout_tapbin |= data;
-	data = phy_read_paged(phydev, 0x0a46, 0x12);
-	data &= 0xc000;
-	data >>= 14;
-	dout_tapbin |= data;
-	dout_tapbin = ~(dout_tapbin ^ 0x08);
-	dout_tapbin <<= 12;
-	dout_tapbin &= 0xf000;
-
-	r8168g_phy_param(phydev, 0x827a, 0xf000, dout_tapbin);
-	r8168g_phy_param(phydev, 0x827b, 0xf000, dout_tapbin);
-	r8168g_phy_param(phydev, 0x827c, 0xf000, dout_tapbin);
-	r8168g_phy_param(phydev, 0x827d, 0xf000, dout_tapbin);
-	r8168g_phy_param(phydev, 0x0811, 0x0000, 0x0800);
-	phy_modify_paged(phydev, 0x0a42, 0x16, 0x0000, 0x0002);
-
-	rtl8168g_enable_gphy_10m(phydev);
-
-	/* SAR ADC performance */
-	phy_modify_paged(phydev, 0x0bca, 0x17, BIT(12) | BIT(13), BIT(14));
-
-	r8168g_phy_param(phydev, 0x803f, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x8047, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x804f, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x8057, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x805f, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x8067, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x806f, 0x3000, 0x0000);
-
-	/* disable phy pfm mode */
-	phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
-
-	rtl8168g_disable_aldps(phydev);
-	rtl8168h_config_eee_phy(phydev);
-}
-
 static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp,
 				     struct phy_device *phydev)
 {
@@ -1269,9 +1204,7 @@ void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
 		[RTL_GIGA_MAC_VER_42] = rtl8168g_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_43] = rtl8168g_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_44] = rtl8168g_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_45] = rtl8168h_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_46] = rtl8168h_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_47] = rtl8168h_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_48] = rtl8168h_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_49] = rtl8168ep_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_50] = rtl8168ep_2_hw_phy_config,
-- 
2.37.2


