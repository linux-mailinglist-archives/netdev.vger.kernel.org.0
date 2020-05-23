Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7AC1DF6D2
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 13:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387778AbgEWLXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 07:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728006AbgEWLXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 07:23:41 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5845C061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 04:23:40 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f5so4239011wmh.2
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 04:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pqEcywYAhG56tPcZ/MLgEb0puRtO2zd2w4uaIe1HPEY=;
        b=U0+wY4EsPtiCO3v2f+RgPOlXOoQGxkby1yiRimXFg9MzjnSyHGMnHG1C6jhIHeLMtq
         ZTbnd+r3ffJm4bPiGObm16CU0vPtVUWelrUnbiGsmPebW5pZa+JQNsd0Dd/83gZgqr6g
         40fEfvhUpAg9s490GQi2Dm00YVNzb1H061djVoqLXuqCMkRiNeHOseM9nlQ00Wzfit7K
         MHsMmG3KZ2FPg3K14xJID2iW+I2/9R4ck/z1gHewrXWeaRcdkQ2ZMuYQWn69JFv595PY
         R/R4zLw+jz7dXLvBF9fclEA5HqVoNOz6FNPHCGNKJfgx9LGh9P9uNEMy07Y+9DYAWEj7
         8m2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pqEcywYAhG56tPcZ/MLgEb0puRtO2zd2w4uaIe1HPEY=;
        b=cenK/FXl9Oyq7G/8A4aVGGJ2EwaUpDSlvCScrP05WSSG5xrJo9soZQqbyHHAbbfC4G
         n+9w91cpyKeBe6SNFdXoyKcAYOFHMPXyL1VQ7+rcQij1u0q6+t0B6tSk1zbjBEIacqB7
         RN5WJd8sGDR7Ad5tnYNcpOSUP+6UGBtpdKjQ6Qi/QI1GQu87sKSw47Fg6sHDFiTFvIfg
         aM91tqIQw564sxmgammgtgbA8f9OhJjgXK1fXpGRC6mA6fjwxgzKrKDnzhT5VhY53NVk
         51zsf3PSmp7xw5RNodDAWd1nK7ebS1oxdDL57Lfai23Vl+1q4QazPsV5ACv8LM2PBXmY
         zyrw==
X-Gm-Message-State: AOAM532IeYO9e2FN+1lCvonvtsyoUjeBYIAmVva3Y5miymM0vBMTbzSR
        CTkS9p7fb6pewY1XE2vYPhNQh4zu
X-Google-Smtp-Source: ABdhPJxJ8TgSmDYZNiRdHcJi1EU/Q1rJz5JhjiRmbMAqOUisFnta4QjODdBA4GyludbhQkJQXZzxyA==
X-Received: by 2002:a7b:c95a:: with SMTP id i26mr17385442wml.117.1590233019242;
        Sat, 23 May 2020 04:23:39 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:69db:99aa:4dc0:a302? (p200300ea8f28520069db99aa4dc0a302.dip0.t-ipconnect.de. [2003:ea:8f28:5200:69db:99aa:4dc0:a302])
        by smtp.googlemail.com with ESMTPSA id 89sm12325545wrj.37.2020.05.23.04.23.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2020 04:23:38 -0700 (PDT)
Subject: [PATCH net-next 1/3] r8169: remove mask argument from rtl_w0w1_eri
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ba72d0ee-713b-0721-ed50-5dbfe502ffba@gmail.com>
Message-ID: <c0a28d5a-06d5-ee4e-dc1c-b3207e392d88@gmail.com>
Date:   Sat, 23 May 2020 13:21:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <ba72d0ee-713b-0721-ed50-5dbfe502ffba@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtl_eri_read() returns the full 32bit value, therefore there's no
benefit in writing back parts of it only. handle it like the vendor
driver and write the full 32 bit always. Omitting the mask argument
avoids some overhead and makes the code better readable.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 66 +++++++++++------------
 1 file changed, 30 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 51e0430cb..b6528b1cb 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1074,25 +1074,21 @@ static u32 rtl_eri_read(struct rtl8169_private *tp, int addr)
 	return _rtl_eri_read(tp, addr, ERIAR_EXGMAC);
 }
 
-static void rtl_w0w1_eri(struct rtl8169_private *tp, int addr, u32 mask, u32 p,
-			 u32 m)
+static void rtl_w0w1_eri(struct rtl8169_private *tp, int addr, u32 p, u32 m)
 {
-	u32 val;
+	u32 val = rtl_eri_read(tp, addr);
 
-	val = rtl_eri_read(tp, addr);
-	rtl_eri_write(tp, addr, mask, (val & ~m) | p);
+	rtl_eri_write(tp, addr, ERIAR_MASK_1111, (val & ~m) | p);
 }
 
-static void rtl_eri_set_bits(struct rtl8169_private *tp, int addr, u32 mask,
-			     u32 p)
+static void rtl_eri_set_bits(struct rtl8169_private *tp, int addr, u32 p)
 {
-	rtl_w0w1_eri(tp, addr, mask, p, 0);
+	rtl_w0w1_eri(tp, addr, p, 0);
 }
 
-static void rtl_eri_clear_bits(struct rtl8169_private *tp, int addr, u32 mask,
-			       u32 m)
+static void rtl_eri_clear_bits(struct rtl8169_private *tp, int addr, u32 m)
 {
-	rtl_w0w1_eri(tp, addr, mask, 0, m);
+	rtl_w0w1_eri(tp, addr, 0, m);
 }
 
 static u32 r8168dp_ocp_read(struct rtl8169_private *tp, u8 mask, u16 reg)
@@ -1256,8 +1252,8 @@ static bool r8168_check_dash(struct rtl8169_private *tp)
 
 static void rtl_reset_packet_filter(struct rtl8169_private *tp)
 {
-	rtl_eri_clear_bits(tp, 0xdc, ERIAR_MASK_0001, BIT(0));
-	rtl_eri_set_bits(tp, 0xdc, ERIAR_MASK_0001, BIT(0));
+	rtl_eri_clear_bits(tp, 0xdc, BIT(0));
+	rtl_eri_set_bits(tp, 0xdc, BIT(0));
 }
 
 DECLARE_RTL_COND(rtl_efusear_cond)
@@ -1384,11 +1380,9 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 	if (rtl_is_8168evl_up(tp)) {
 		tmp--;
 		if (wolopts & WAKE_MAGIC)
-			rtl_eri_set_bits(tp, 0x0dc, ERIAR_MASK_0100,
-					 MagicPacket_v2);
+			rtl_eri_set_bits(tp, 0x0dc, MagicPacket_v2);
 		else
-			rtl_eri_clear_bits(tp, 0x0dc, ERIAR_MASK_0100,
-					   MagicPacket_v2);
+			rtl_eri_clear_bits(tp, 0x0dc, MagicPacket_v2);
 	} else if (rtl_is_8125(tp)) {
 		tmp--;
 		if (wolopts & WAKE_MAGIC)
@@ -2132,7 +2126,7 @@ static void rtl8168_config_eee_mac(struct rtl8169_private *tp)
 	if (tp->mac_version != RTL_GIGA_MAC_VER_38)
 		RTL_W8(tp, EEE_LED, RTL_R8(tp, EEE_LED) & ~0x07);
 
-	rtl_eri_set_bits(tp, 0x1b0, ERIAR_MASK_1111, 0x0003);
+	rtl_eri_set_bits(tp, 0x1b0, 0x0003);
 }
 
 static void rtl8125_config_eee_mac(struct rtl8169_private *tp)
@@ -2296,7 +2290,7 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_40:
 	case RTL_GIGA_MAC_VER_41:
 	case RTL_GIGA_MAC_VER_49:
-		rtl_eri_clear_bits(tp, 0x1a8, ERIAR_MASK_1111, 0xfc000000);
+		rtl_eri_clear_bits(tp, 0x1a8, 0xfc000000);
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) & ~0x80);
 		break;
 	default:
@@ -2329,7 +2323,7 @@ static void rtl_pll_power_up(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_41:
 	case RTL_GIGA_MAC_VER_49:
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) | 0xc0);
-		rtl_eri_set_bits(tp, 0x1a8, ERIAR_MASK_1111, 0xfc000000);
+		rtl_eri_set_bits(tp, 0x1a8, 0xfc000000);
 		break;
 	default:
 		break;
@@ -2938,8 +2932,8 @@ static void rtl_hw_start_8168e_2(struct rtl8169_private *tp)
 	rtl_set_fifo_size(tp, 0x10, 0x10, 0x02, 0x06);
 	rtl_eri_write(tp, 0xcc, ERIAR_MASK_1111, 0x00000050);
 	rtl_eri_write(tp, 0xd0, ERIAR_MASK_1111, 0x07ff0060);
-	rtl_eri_set_bits(tp, 0x1b0, ERIAR_MASK_0001, BIT(4));
-	rtl_w0w1_eri(tp, 0x0d4, ERIAR_MASK_0011, 0x0c00, 0xff00);
+	rtl_eri_set_bits(tp, 0x1b0, BIT(4));
+	rtl_w0w1_eri(tp, 0x0d4, 0x0c00, 0xff00);
 
 	rtl_disable_clock_request(tp);
 
@@ -2962,8 +2956,8 @@ static void rtl_hw_start_8168f(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
 	rtl_set_fifo_size(tp, 0x10, 0x10, 0x02, 0x06);
 	rtl_reset_packet_filter(tp);
-	rtl_eri_set_bits(tp, 0x1b0, ERIAR_MASK_0001, BIT(4));
-	rtl_eri_set_bits(tp, 0x1d0, ERIAR_MASK_0001, BIT(4));
+	rtl_eri_set_bits(tp, 0x1b0, BIT(4));
+	rtl_eri_set_bits(tp, 0x1d0, BIT(4));
 	rtl_eri_write(tp, 0xcc, ERIAR_MASK_1111, 0x00000050);
 	rtl_eri_write(tp, 0xd0, ERIAR_MASK_1111, 0x00000060);
 
@@ -2992,7 +2986,7 @@ static void rtl_hw_start_8168f_1(struct rtl8169_private *tp)
 
 	rtl_ephy_init(tp, e_info_8168f_1);
 
-	rtl_w0w1_eri(tp, 0x0d4, ERIAR_MASK_0011, 0x0c00, 0xff00);
+	rtl_w0w1_eri(tp, 0x0d4, 0x0c00, 0xff00);
 }
 
 static void rtl_hw_start_8411(struct rtl8169_private *tp)
@@ -3010,7 +3004,7 @@ static void rtl_hw_start_8411(struct rtl8169_private *tp)
 
 	rtl_ephy_init(tp, e_info_8168f_1);
 
-	rtl_eri_set_bits(tp, 0x0d4, ERIAR_MASK_0011, 0x0c00);
+	rtl_eri_set_bits(tp, 0x0d4, 0x0c00);
 }
 
 static void rtl_hw_start_8168g(struct rtl8169_private *tp)
@@ -3030,8 +3024,8 @@ static void rtl_hw_start_8168g(struct rtl8169_private *tp)
 
 	rtl8168_config_eee_mac(tp);
 
-	rtl_w0w1_eri(tp, 0x2fc, ERIAR_MASK_0001, 0x01, 0x06);
-	rtl_eri_clear_bits(tp, 0x1b0, ERIAR_MASK_0011, BIT(12));
+	rtl_w0w1_eri(tp, 0x2fc, 0x01, 0x06);
+	rtl_eri_clear_bits(tp, 0x1b0, BIT(12));
 
 	rtl_pcie_state_l2l3_disable(tp);
 }
@@ -3257,9 +3251,9 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 
 	rtl_reset_packet_filter(tp);
 
-	rtl_eri_set_bits(tp, 0xdc, ERIAR_MASK_1111, BIT(4));
+	rtl_eri_set_bits(tp, 0xdc, BIT(4));
 
-	rtl_eri_set_bits(tp, 0xd4, ERIAR_MASK_1111, 0x1f00);
+	rtl_eri_set_bits(tp, 0xd4, 0x1f00);
 
 	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87);
 
@@ -3275,7 +3269,7 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 
 	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) & ~TX_10M_PS_EN);
 
-	rtl_eri_clear_bits(tp, 0x1b0, ERIAR_MASK_0011, BIT(12));
+	rtl_eri_clear_bits(tp, 0x1b0, BIT(12));
 
 	rtl_pcie_state_l2l3_disable(tp);
 
@@ -3312,7 +3306,7 @@ static void rtl_hw_start_8168ep(struct rtl8169_private *tp)
 
 	rtl_reset_packet_filter(tp);
 
-	rtl_eri_set_bits(tp, 0xd4, ERIAR_MASK_1111, 0x1f80);
+	rtl_eri_set_bits(tp, 0xd4, 0x1f80);
 
 	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87);
 
@@ -3323,7 +3317,7 @@ static void rtl_hw_start_8168ep(struct rtl8169_private *tp)
 
 	rtl8168_config_eee_mac(tp);
 
-	rtl_w0w1_eri(tp, 0x2fc, ERIAR_MASK_0001, 0x01, 0x06);
+	rtl_w0w1_eri(tp, 0x2fc, 0x01, 0x06);
 
 	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) & ~TX_10M_PS_EN);
 
@@ -3415,7 +3409,7 @@ static void rtl_hw_start_8117(struct rtl8169_private *tp)
 
 	rtl_reset_packet_filter(tp);
 
-	rtl_eri_set_bits(tp, 0xd4, ERIAR_MASK_1111, 0x1f90);
+	rtl_eri_set_bits(tp, 0xd4, 0x1f90);
 
 	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87);
 
@@ -3431,7 +3425,7 @@ static void rtl_hw_start_8117(struct rtl8169_private *tp)
 
 	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) & ~TX_10M_PS_EN);
 
-	rtl_eri_clear_bits(tp, 0x1b0, ERIAR_MASK_0011, BIT(12));
+	rtl_eri_clear_bits(tp, 0x1b0, BIT(12));
 
 	rtl_pcie_state_l2l3_disable(tp);
 
@@ -3556,7 +3550,7 @@ static void rtl_hw_start_8402(struct rtl8169_private *tp)
 	rtl_reset_packet_filter(tp);
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
-	rtl_w0w1_eri(tp, 0x0d4, ERIAR_MASK_0011, 0x0e00, 0xff00);
+	rtl_w0w1_eri(tp, 0x0d4, 0x0e00, 0xff00);
 
 	/* disable EEE */
 	rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
-- 
2.26.2


