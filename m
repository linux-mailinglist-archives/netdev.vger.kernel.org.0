Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BA859EC93
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbiHWTk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbiHWTkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:40:22 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477993F307
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 11:38:16 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id gt3so16736808ejb.12
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 11:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=NSAqLKm5v7LC885LP4TJhDfY36sDMzCl5TSFE2NC9zg=;
        b=Z4NUd3KgUfoJea1t5n3xNMH26ZEdvejnkzHmsuMVMod+gP/RhOTjmKS4Q1SPpywt4W
         6kEODpvr3Hak3AgZCYlL+Fiv6MnCtc6U6Qa54+HvULXxAemacy1j8nf+HCzmg6HmwPM1
         go4+5TJhdgseZVkksN5GoX/dOKoBmPMd3Zg+P/3qEdOOcZZmTJUibEPejCP9HtDrv/Ae
         2oxvpIukzPZiWM7aio126grn8Em4ktIES0ak9vuW6HL1Bi0yvzCvLdsFehZ1EmtDTASV
         ABiuPBSn6Gud4XrQEDvJlVqJpRbszTmpvp+Kw7P6pyW50vmV03R1l6F5fP/V/GfyjuAP
         e/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=NSAqLKm5v7LC885LP4TJhDfY36sDMzCl5TSFE2NC9zg=;
        b=XD6p8tmVT35gI4lwkk0kSmWPEgdyH8U9MikYF0IGteMvPR6z9WDpHaFQfGDgvh2bCl
         L4NWuVECLiclReVmfGt7unIm8q7iH1PSbxvUlPSN/hnjA4/aWC4viyhgtBPbSCafYVC3
         vw0epHsTHYXguGAspArRrXMwffKbbEWY2VErEbPx/G0YRLpcBLi5adX/gEzZ2ZFuniyn
         rAqOWgDMjtYLHK/vpqJGw9zjWGC2UP7/pk4vdj5Dy8vYv5RM0qoWXrXdfz0sHK1fCHtx
         7w9Txfd6Yd3/gekisH9z6XguVjT+90y0EY6x7ZOU2FzGrdGnq9gwLAqxhl0f0aWZS0cx
         buqw==
X-Gm-Message-State: ACgBeo3q3ZavvDnthWaeyDMnflbkZjtURES9a4dhGsKS00vm/xnGdTPD
        Nu4AJXT6odmpfKXGD8kFo6I=
X-Google-Smtp-Source: AA6agR7erurdobVWsBp9wE8yStiSYLojj9IeILfxYZIvu5RVFkSoKYkX6fOBbSf32DcnBDseRP8u5g==
X-Received: by 2002:a17:907:7d8c:b0:731:65f6:1f28 with SMTP id oz12-20020a1709077d8c00b0073165f61f28mr541605ejc.91.1661279895487;
        Tue, 23 Aug 2022 11:38:15 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7758:1500:8528:d099:20f2:8fd6? (dynamic-2a01-0c22-7758-1500-8528-d099-20f2-8fd6.c22.pool.telefonica.de. [2a01:c22:7758:1500:8528:d099:20f2:8fd6])
        by smtp.googlemail.com with ESMTPSA id t26-20020a50c25a000000b0043bbc9503ddsm1842728edf.76.2022.08.23.11.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 11:38:15 -0700 (PDT)
Message-ID: <083262b4-ba05-9540-955a-a9ec3bb8e81c@gmail.com>
Date:   Tue, 23 Aug 2022 20:35:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: [PATCH net-next v3 2/5] r8169: remove support for chip versions 45
 and 47
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <3bff9a7a-2353-3b37-3b6e-ebcae00f7816@gmail.com>
In-Reply-To: <3bff9a7a-2353-3b37-3b6e-ebcae00f7816@gmail.com>
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


