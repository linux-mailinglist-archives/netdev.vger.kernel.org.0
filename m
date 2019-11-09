Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5DABF6190
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 22:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfKIVCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 16:02:54 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56155 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfKIVCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 16:02:54 -0500
Received: by mail-wm1-f66.google.com with SMTP id b11so9516462wmb.5
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 13:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hpvdTj//YhwZvEdzZgKOFrKODL2Z5pFINiJtN37s6Ow=;
        b=aJWP9b3Syu7DTV4n1g4fnICkHRFuI9mTPS5Q9QRPcWvk9I4irEdSuY+j4uyt3rIe10
         /a+JtNhMdxsUEpRGSD8sRv61XO9i1zSjhSWxhJRG7oBcMdquOUAcN/iQN1GWim7iC1bB
         SF9pNeMZ93GcLTRqdLZO4oJwViCPAxHjWPthgfKmDf1WxBFlYMeW1K5tqWKvfNeWZWAL
         a3jS8PamZaAczOKcYhnhuXLg8PisSV7O2vW22Xmq1VbE3uid7kaq5WTzu4X1wXFDn5Ww
         2oOZZay1OYfz+LNLlSxzf4exk40XhxQ4y5Ez+fjA5TFLNKloFx23JxzNWL1JlHNFhe9D
         27Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hpvdTj//YhwZvEdzZgKOFrKODL2Z5pFINiJtN37s6Ow=;
        b=XkvGiKQMseMFK4EX7HuWHc7iuDAIrZbArp01RnKk2BkXCGMbyydsIJR7awycsRJ5Kx
         DkTu/yZKJXpzwQOwur5UcDEK+bQl6qVdDBbkH7tnfep0ieyNF+96pcUQcy/YMhOGTkWz
         xwAXyasq0WgiJep60RQIP8dRzAYkFc1K4z4cs3Jnj5fTSlRvQKXZsJ0gRn51nw1BD6x3
         5sxexrMU3rGLGkamqF4T2kSq40obt962z7SawOUaykmZQYQUGwOSZymQfl07A5ucILHW
         8G7KOV60CmPY6s5T63saQr089ycSw0KqzRuCvI92ESRIt6HLridUyIjT1MKYoqgHStVM
         hFmg==
X-Gm-Message-State: APjAAAUsVskJ0OF20HK3PauoPb8n+FFriTvO41Y2tamvJoVKhT9ucLiP
        rrMf/6Yx6EqfIlz7yvUYGypbdplv
X-Google-Smtp-Source: APXvYqyC2YtV6ucVO7p2pSaV/fsu18KOuhEUJzweoEOmhWnHD/e0mBBd9RK64ZfoAo3LjtLnX4UV3g==
X-Received: by 2002:a1c:610b:: with SMTP id v11mr13766620wmb.156.1573333370476;
        Sat, 09 Nov 2019 13:02:50 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4d:a200:7127:c2c7:8451:a38b? (p200300EA8F4DA2007127C2C78451A38B.dip0.t-ipconnect.de. [2003:ea:8f4d:a200:7127:c2c7:8451:a38b])
        by smtp.googlemail.com with ESMTPSA id y6sm10115145wrw.6.2019.11.09.13.02.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 13:02:50 -0800 (PST)
Subject: [PATCH net-next 4/5] r8169: add helper r8168d_modify_extpage
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <11f690c9-ed72-f84b-a7c3-9e18235d6a9a@gmail.com>
Message-ID: <83c15641-7630-c0b4-a28a-d937265da540@gmail.com>
Date:   Sat, 9 Nov 2019 22:01:36 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <11f690c9-ed72-f84b-a7c3-9e18235d6a9a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Certain integrated PHY's from RTL8168d support extended pages. On page
0x0007 the number of the extended page is written to register 0x1e,
then the registers on the extended page can be accessed. Add a helper
for this to improve readability and simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 121 +++++++---------------
 1 file changed, 39 insertions(+), 82 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index b3263a887..8aa681dfe 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1086,6 +1086,17 @@ static void rtl_w0w1_phy(struct rtl8169_private *tp, int reg_addr, int p, int m)
 	rtl_writephy(tp, reg_addr, (val & ~m) | p);
 }
 
+static void r8168d_modify_extpage(struct phy_device *phydev, int extpage,
+				  int reg, u16 mask, u16 val)
+{
+	int oldpage = phy_select_page(phydev, 0x0007);
+
+	__phy_write(phydev, 0x1e, extpage);
+	__phy_modify(phydev, reg, mask, val);
+
+	phy_restore_page(phydev, oldpage, 0);
+}
+
 static void r8168d_phy_param(struct phy_device *phydev, u16 parm,
 			     u16 mask, u16 val)
 {
@@ -2830,30 +2841,18 @@ static void rtl8168d_3_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x04, 0xf800 },
 		{ 0x04, 0xf000 },
 		{ 0x1f, 0x0000 },
-
-		{ 0x1f, 0x0007 },
-		{ 0x1e, 0x0023 },
-		{ 0x16, 0x0000 },
-		{ 0x1f, 0x0000 }
 	};
 
 	rtl_writephy_batch(tp, phy_reg_init);
+
+	r8168d_modify_extpage(tp->phydev, 0x0023, 0x16, 0xffff, 0x0000);
 }
 
 static void rtl8168d_4_hw_phy_config(struct rtl8169_private *tp)
 {
-	static const struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0001 },
-		{ 0x17, 0x0cc0 },
-
-		{ 0x1f, 0x0007 },
-		{ 0x1e, 0x002d },
-		{ 0x18, 0x0040 },
-		{ 0x1f, 0x0000 }
-	};
-
-	rtl_writephy_batch(tp, phy_reg_init);
-	rtl_patchphy(tp, 0x0d, 1 << 5);
+	phy_write_paged(tp->phydev, 0x0001, 0x17, 0x0cc0);
+	r8168d_modify_extpage(tp->phydev, 0x002d, 0x18, 0xffff, 0x0040);
+	phy_set_bits(tp->phydev, 0x0d, BIT(5));
 }
 
 static void rtl8168e_1_hw_phy_config(struct rtl8169_private *tp)
@@ -2867,17 +2866,6 @@ static void rtl8168e_1_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x1f, 0x0003 },
 		{ 0x14, 0x6420 },
 		{ 0x1f, 0x0000 },
-
-		/* Update PFM & 10M TX idle timer */
-		{ 0x1f, 0x0007 },
-		{ 0x1e, 0x002f },
-		{ 0x15, 0x1919 },
-		{ 0x1f, 0x0000 },
-
-		{ 0x1f, 0x0007 },
-		{ 0x1e, 0x00ac },
-		{ 0x18, 0x0006 },
-		{ 0x1f, 0x0000 }
 	};
 	struct phy_device *phydev = tp->phydev;
 
@@ -2888,31 +2876,26 @@ static void rtl8168e_1_hw_phy_config(struct rtl8169_private *tp)
 
 	rtl_writephy_batch(tp, phy_reg_init);
 
+	/* Update PFM & 10M TX idle timer */
+	r8168d_modify_extpage(phydev, 0x002f, 0x15, 0xffff, 0x1919);
+
+	r8168d_modify_extpage(phydev, 0x00ac, 0x18, 0xffff, 0x0006);
+
 	/* DCO enable for 10M IDLE Power */
-	rtl_writephy(tp, 0x1f, 0x0007);
-	rtl_writephy(tp, 0x1e, 0x0023);
-	rtl_w0w1_phy(tp, 0x17, 0x0006, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168d_modify_extpage(phydev, 0x0023, 0x17, 0x0000, 0x0006);
 
 	/* For impedance matching */
 	phy_modify_paged(phydev, 0x0002, 0x08, 0x7f00, 0x8000);
 
 	/* PHY auto speed down */
-	rtl_writephy(tp, 0x1f, 0x0007);
-	rtl_writephy(tp, 0x1e, 0x002d);
-	rtl_w0w1_phy(tp, 0x18, 0x0050, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
-	rtl_w0w1_phy(tp, 0x14, 0x8000, 0x0000);
+	r8168d_modify_extpage(phydev, 0x002d, 0x18, 0x0000, 0x0050);
+	phy_set_bits(phydev, 0x14, BIT(15));
 
 	r8168d_phy_param(phydev, 0x8b86, 0x0000, 0x0001);
 	r8168d_phy_param(phydev, 0x8b85, 0x2000, 0x0000);
 
-	rtl_writephy(tp, 0x1f, 0x0007);
-	rtl_writephy(tp, 0x1e, 0x0020);
-	rtl_w0w1_phy(tp, 0x15, 0x0000, 0x1100);
-	rtl_writephy(tp, 0x1f, 0x0006);
-	rtl_writephy(tp, 0x00, 0x5a00);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168d_modify_extpage(phydev, 0x0020, 0x15, 0x1100, 0x0000);
+	phy_write_paged(phydev, 0x0006, 0x00, 0x5a00);
 
 	phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0x0000);
 }
@@ -2933,27 +2916,15 @@ static void rtl_rar_exgmac_set(struct rtl8169_private *tp, u8 *addr)
 
 static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp)
 {
-	static const struct phy_reg phy_reg_init[] = {
-		/* Enable Delay cap */
-		{ 0x1f, 0x0004 },
-		{ 0x1f, 0x0007 },
-		{ 0x1e, 0x00ac },
-		{ 0x18, 0x0006 },
-		{ 0x1f, 0x0002 },
-		{ 0x1f, 0x0000 },
-		{ 0x1f, 0x0000 },
-
-		/* Channel estimation fine tune */
-		{ 0x1f, 0x0003 },
-		{ 0x09, 0xa20f },
-		{ 0x1f, 0x0000 },
-		{ 0x1f, 0x0000 },
-	};
 	struct phy_device *phydev = tp->phydev;
 
 	rtl_apply_firmware(tp);
 
-	rtl_writephy_batch(tp, phy_reg_init);
+	/* Enable Delay cap */
+	r8168d_modify_extpage(phydev, 0x00ac, 0x18, 0xffff, 0x0006);
+
+	/* Channel estimation fine tune */
+	phy_write_paged(phydev, 0x0003, 0x09, 0xa20f);
 
 	/* Green Setting */
 	r8168d_phy_param(phydev, 0x8b5b, 0xffff, 0x9222);
@@ -2967,13 +2938,8 @@ static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0000);
 
 	/* PHY auto speed down */
-	rtl_writephy(tp, 0x1f, 0x0004);
-	rtl_writephy(tp, 0x1f, 0x0007);
-	rtl_writephy(tp, 0x1e, 0x002d);
-	rtl_w0w1_phy(tp, 0x18, 0x0010, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0002);
-	rtl_writephy(tp, 0x1f, 0x0000);
-	rtl_w0w1_phy(tp, 0x14, 0x8000, 0x0000);
+	r8168d_modify_extpage(phydev, 0x002d, 0x18, 0x0000, 0x0010);
+	phy_set_bits(phydev, 0x14, BIT(15));
 
 	/* improve 10M EEE waveform */
 	r8168d_phy_param(phydev, 0x8b86, 0x0000, 0x0001);
@@ -3005,11 +2971,8 @@ static void rtl8168f_hw_phy_config(struct rtl8169_private *tp)
 	r8168d_phy_param(phydev, 0x8b80, 0x0000, 0x0006);
 
 	/* PHY auto speed down */
-	rtl_writephy(tp, 0x1f, 0x0007);
-	rtl_writephy(tp, 0x1e, 0x002d);
-	rtl_w0w1_phy(tp, 0x18, 0x0010, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
-	rtl_w0w1_phy(tp, 0x14, 0x8000, 0x0000);
+	r8168d_modify_extpage(phydev, 0x002d, 0x18, 0x0000, 0x0010);
+	phy_set_bits(phydev, 0x14, BIT(15));
 
 	/* Improve 10M EEE waveform */
 	r8168d_phy_param(phydev, 0x8b86, 0x0000, 0x0001);
@@ -3032,11 +2995,8 @@ static void rtl8168f_1_hw_phy_config(struct rtl8169_private *tp)
 	r8168d_phy_param(phydev, 0x8b5e, 0xffff, 0x0000);
 	r8168d_phy_param(phydev, 0x8b67, 0xffff, 0x0000);
 	r8168d_phy_param(phydev, 0x8b70, 0xffff, 0x0000);
-	phy_write(phydev, 0x1f, 0x0007);
-	phy_write(phydev, 0x1e, 0x0078);
-	phy_write(phydev, 0x17, 0x0000);
-	phy_write(phydev, 0x19, 0x00fb);
-	phy_write(phydev, 0x1f, 0x0000);
+	r8168d_modify_extpage(phydev, 0x0078, 0x17, 0xffff, 0x0000);
+	r8168d_modify_extpage(phydev, 0x0078, 0x19, 0xffff, 0x00fb);
 
 	/* Modify green table for 10M */
 	r8168d_phy_param(phydev, 0x8b79, 0xffff, 0xaa00);
@@ -3076,11 +3036,8 @@ static void rtl8411_hw_phy_config(struct rtl8169_private *tp)
 	r8168d_phy_param(phydev, 0x8b5e, 0xffff, 0x0000);
 	r8168d_phy_param(phydev, 0x8b67, 0xffff, 0x0000);
 	r8168d_phy_param(phydev, 0x8b70, 0xffff, 0x0000);
-	phy_write(phydev, 0x1f, 0x0007);
-	phy_write(phydev, 0x1e, 0x0078);
-	phy_write(phydev, 0x17, 0x0000);
-	phy_write(phydev, 0x19, 0x00aa);
-	phy_write(phydev, 0x1f, 0x0000);
+	r8168d_modify_extpage(phydev, 0x0078, 0x17, 0xffff, 0x0000);
+	r8168d_modify_extpage(phydev, 0x0078, 0x19, 0xffff, 0x00aa);
 
 	/* Modify green table for 10M */
 	r8168d_phy_param(phydev, 0x8b79, 0xffff, 0xaa00);
-- 
2.24.0


