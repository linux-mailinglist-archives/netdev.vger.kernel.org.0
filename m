Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC46FF618F
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 22:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfKIVCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 16:02:52 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54734 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfKIVCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 16:02:52 -0500
Received: by mail-wm1-f66.google.com with SMTP id z26so9530888wmi.4
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 13:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MjxTP/kuD813z8GjrmmY/xERoO1MKE4zI8jGQhUvz2Y=;
        b=Vu5bB1sK3wYPYvi8QvJTZRPxe6piLmNZ/3m1FkWGxStI90ZUkcIMHMXEqTOdy4JYY8
         w7G1L0GjM6N+qOG7Bvdt8ZRQi436gT5IPvzr0cfqtioMka02AytwDNXNlPErZuJQp46P
         Gq96at0zbVUMNXTyMYE3jDObk/UWQfb+d/xJov01KmRlrukhM1Y8L5rx/51HvUHFdon3
         VDV3Tgrv4Piq3tvt0ENxHBxlj4Ptbzs8FCZSs9sq1xt+PlxVZAnsplhU41H9lNds+Ylc
         auhpW6Qme+LESCh9V/istZgiwXaY0xnfGsQwJHbj9f92nZ2AWhWeFUWaHQLiDPr30aBS
         wlCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MjxTP/kuD813z8GjrmmY/xERoO1MKE4zI8jGQhUvz2Y=;
        b=du9mTlsytwkzeBdSDDrQhvfs8LX/SWutNeyP53B437JhL0ej3+xNWRcLVe1uHALE6S
         pAnwC7dWvthu3QGjRjRTitvW87rMsvjf2u4wbczt4lRk6teF/8ceL5nXRnZVhqM4qIkr
         ukV33e6npS8sCz5RZcVueoGyTjkL2FuVMGnkyPHh8HA/ZPKMSv3Lhy9jQEbmsYNUfUax
         cffy8dXXzGhWY1A/u6fdjZGk0T3p79449RESamloPIUI+sWAL2PRVwGi/uqPrwm0E9rL
         arbru+CMFyi2s3Rze1jotvYnXtNfNU0DNHt1rzyBvdyyFawsTmamHYlr6amx1+RdeJ+H
         tuLw==
X-Gm-Message-State: APjAAAVyn/6YjmwLZ963oEIE9cm3am0nZk3L4EHxP8QjlTh0Eu+GjzPI
        VIFPNjhrYOmHYvss4iwfQt4RNL0I
X-Google-Smtp-Source: APXvYqxuDyVa2BV03vVbqBGtVlYeEEOYRDL0BpUHGlnkVbZhE8mn4RKyNg9aFmjRh6MMvXq96uEpUQ==
X-Received: by 2002:a1c:152:: with SMTP id 79mr13399337wmb.70.1573333368488;
        Sat, 09 Nov 2019 13:02:48 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4d:a200:7127:c2c7:8451:a38b? (p200300EA8F4DA2007127C2C78451A38B.dip0.t-ipconnect.de. [2003:ea:8f4d:a200:7127:c2c7:8451:a38b])
        by smtp.googlemail.com with ESMTPSA id f6sm11094793wrm.61.2019.11.09.13.02.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 13:02:48 -0800 (PST)
Subject: [PATCH net-next 2/5] r8169: add helper r8168d_phy_param
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <11f690c9-ed72-f84b-a7c3-9e18235d6a9a@gmail.com>
Message-ID: <be5b320d-fd31-16c4-a6cc-8cc4ebbb88c2@gmail.com>
Date:   Sat, 9 Nov 2019 22:00:13 +0100
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

Integrated PHY's from RTL8168d support an indirect access method for
PHY parameters. On page 0x0005 parameter number is written to register
0x05, then the parameter can be accessed via register 0x06.
Add a helper for this to improve readability and simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 249 ++++++++--------------
 1 file changed, 85 insertions(+), 164 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index dbdb77d71..fa4b3d71f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1086,6 +1086,17 @@ static void rtl_w0w1_phy(struct rtl8169_private *tp, int reg_addr, int p, int m)
 	rtl_writephy(tp, reg_addr, (val & ~m) | p);
 }
 
+static void r8168d_phy_param(struct phy_device *phydev, u16 parm,
+			     u16 mask, u16 val)
+{
+	int oldpage = phy_select_page(phydev, 0x0005);
+
+	__phy_write(phydev, 0x05, parm);
+	__phy_modify(phydev, 0x06, mask, val);
+
+	phy_restore_page(phydev, oldpage, 0);
+}
+
 static void r8168g_phy_param(struct phy_device *phydev, u16 parm,
 			     u16 mask, u16 val)
 {
@@ -2295,12 +2306,9 @@ static void rtl8168f_config_eee_phy(struct rtl8169_private *tp)
 	phy_write(phydev, 0x1f, 0x0007);
 	phy_write(phydev, 0x1e, 0x0020);
 	phy_set_bits(phydev, 0x15, BIT(8));
-
-	phy_write(phydev, 0x1f, 0x0005);
-	phy_write(phydev, 0x05, 0x8b85);
-	phy_set_bits(phydev, 0x06, BIT(13));
-
 	phy_write(phydev, 0x1f, 0x0000);
+
+	r8168d_phy_param(phydev, 0x8b85, 0, BIT(13));
 }
 
 static void rtl8168g_config_eee_phy(struct rtl8169_private *tp)
@@ -2738,15 +2746,8 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp)
 				rtl_writephy(tp, 0x0d, val | set[i]);
 		}
 	} else {
-		static const struct phy_reg phy_reg_init[] = {
-			{ 0x1f, 0x0002 },
-			{ 0x05, 0x6662 },
-			{ 0x1f, 0x0005 },
-			{ 0x05, 0x8330 },
-			{ 0x06, 0x6662 }
-		};
-
-		rtl_writephy_batch(tp, phy_reg_init);
+		phy_write_paged(tp->phydev, 0x0002, 0x05, 0x6662);
+		r8168d_phy_param(tp->phydev, 0x8330, 0xffff, 0x6662);
 	}
 
 	/* RSET couple improve */
@@ -2791,15 +2792,8 @@ static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp)
 				rtl_writephy(tp, 0x0d, val | set[i]);
 		}
 	} else {
-		static const struct phy_reg phy_reg_init[] = {
-			{ 0x1f, 0x0002 },
-			{ 0x05, 0x2642 },
-			{ 0x1f, 0x0005 },
-			{ 0x05, 0x8330 },
-			{ 0x06, 0x2642 }
-		};
-
-		rtl_writephy_batch(tp, phy_reg_init);
+		phy_write_paged(tp->phydev, 0x0002, 0x05, 0x2642);
+		r8168d_phy_param(tp->phydev, 0x8330, 0xffff, 0x2642);
 	}
 
 	/* Fine tune PLL performance */
@@ -2899,12 +2893,6 @@ static void rtl8168d_4_hw_phy_config(struct rtl8169_private *tp)
 static void rtl8168e_1_hw_phy_config(struct rtl8169_private *tp)
 {
 	static const struct phy_reg phy_reg_init[] = {
-		/* Enable Delay cap */
-		{ 0x1f, 0x0005 },
-		{ 0x05, 0x8b80 },
-		{ 0x06, 0xc896 },
-		{ 0x1f, 0x0000 },
-
 		/* Channel estimation fine tune */
 		{ 0x1f, 0x0001 },
 		{ 0x0b, 0x6c20 },
@@ -2925,9 +2913,13 @@ static void rtl8168e_1_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x18, 0x0006 },
 		{ 0x1f, 0x0000 }
 	};
+	struct phy_device *phydev = tp->phydev;
 
 	rtl_apply_firmware(tp);
 
+	/* Enable Delay cap */
+	r8168d_phy_param(phydev, 0x8b80, 0xffff, 0xc896);
+
 	rtl_writephy_batch(tp, phy_reg_init);
 
 	/* DCO enable for 10M IDLE Power */
@@ -2948,25 +2940,17 @@ static void rtl8168e_1_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0000);
 	rtl_w0w1_phy(tp, 0x14, 0x8000, 0x0000);
 
-	rtl_writephy(tp, 0x1f, 0x0005);
-	rtl_writephy(tp, 0x05, 0x8b86);
-	rtl_w0w1_phy(tp, 0x06, 0x0001, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168d_phy_param(phydev, 0x8b86, 0x0000, 0x0001);
+	r8168d_phy_param(phydev, 0x8b85, 0x2000, 0x0000);
 
-	rtl_writephy(tp, 0x1f, 0x0005);
-	rtl_writephy(tp, 0x05, 0x8b85);
-	rtl_w0w1_phy(tp, 0x06, 0x0000, 0x2000);
 	rtl_writephy(tp, 0x1f, 0x0007);
 	rtl_writephy(tp, 0x1e, 0x0020);
 	rtl_w0w1_phy(tp, 0x15, 0x0000, 0x1100);
 	rtl_writephy(tp, 0x1f, 0x0006);
 	rtl_writephy(tp, 0x00, 0x5a00);
 	rtl_writephy(tp, 0x1f, 0x0000);
-	rtl_writephy(tp, 0x0d, 0x0007);
-	rtl_writephy(tp, 0x0e, 0x003c);
-	rtl_writephy(tp, 0x0d, 0x4007);
-	rtl_writephy(tp, 0x0e, 0x0000);
-	rtl_writephy(tp, 0x0d, 0x0000);
+
+	phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0x0000);
 }
 
 static void rtl_rar_exgmac_set(struct rtl8169_private *tp, u8 *addr)
@@ -3000,22 +2984,18 @@ static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x09, 0xa20f },
 		{ 0x1f, 0x0000 },
 		{ 0x1f, 0x0000 },
-
-		/* Green Setting */
-		{ 0x1f, 0x0005 },
-		{ 0x05, 0x8b5b },
-		{ 0x06, 0x9222 },
-		{ 0x05, 0x8b6d },
-		{ 0x06, 0x8000 },
-		{ 0x05, 0x8b76 },
-		{ 0x06, 0x8000 },
-		{ 0x1f, 0x0000 }
 	};
+	struct phy_device *phydev = tp->phydev;
 
 	rtl_apply_firmware(tp);
 
 	rtl_writephy_batch(tp, phy_reg_init);
 
+	/* Green Setting */
+	r8168d_phy_param(phydev, 0x8b5b, 0xffff, 0x9222);
+	r8168d_phy_param(phydev, 0x8b6d, 0xffff, 0x8000);
+	r8168d_phy_param(phydev, 0x8b76, 0xffff, 0x8000);
+
 	/* For 4-corner performance improve */
 	rtl_writephy(tp, 0x1f, 0x0005);
 	rtl_writephy(tp, 0x05, 0x8b80);
@@ -3032,16 +3012,10 @@ static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp)
 	rtl_w0w1_phy(tp, 0x14, 0x8000, 0x0000);
 
 	/* improve 10M EEE waveform */
-	rtl_writephy(tp, 0x1f, 0x0005);
-	rtl_writephy(tp, 0x05, 0x8b86);
-	rtl_w0w1_phy(tp, 0x06, 0x0001, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168d_phy_param(phydev, 0x8b86, 0x0000, 0x0001);
 
 	/* Improve 2-pair detection performance */
-	rtl_writephy(tp, 0x1f, 0x0005);
-	rtl_writephy(tp, 0x05, 0x8b85);
-	rtl_w0w1_phy(tp, 0x06, 0x4000, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168d_phy_param(phydev, 0x8b85, 0x0000, 0x4000);
 
 	rtl8168f_config_eee_phy(tp);
 	rtl_enable_eee(tp);
@@ -3061,11 +3035,10 @@ static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp)
 
 static void rtl8168f_hw_phy_config(struct rtl8169_private *tp)
 {
+	struct phy_device *phydev = tp->phydev;
+
 	/* For 4-corner performance improve */
-	rtl_writephy(tp, 0x1f, 0x0005);
-	rtl_writephy(tp, 0x05, 0x8b80);
-	rtl_w0w1_phy(tp, 0x06, 0x0006, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168d_phy_param(phydev, 0x8b80, 0x0000, 0x0006);
 
 	/* PHY auto speed down */
 	rtl_writephy(tp, 0x1f, 0x0007);
@@ -3075,10 +3048,7 @@ static void rtl8168f_hw_phy_config(struct rtl8169_private *tp)
 	rtl_w0w1_phy(tp, 0x14, 0x8000, 0x0000);
 
 	/* Improve 10M EEE waveform */
-	rtl_writephy(tp, 0x1f, 0x0005);
-	rtl_writephy(tp, 0x05, 0x8b86);
-	rtl_w0w1_phy(tp, 0x06, 0x0001, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168d_phy_param(phydev, 0x8b86, 0x0000, 0x0001);
 
 	rtl8168f_config_eee_phy(tp);
 	rtl_enable_eee(tp);
@@ -3086,52 +3056,34 @@ static void rtl8168f_hw_phy_config(struct rtl8169_private *tp)
 
 static void rtl8168f_1_hw_phy_config(struct rtl8169_private *tp)
 {
-	static const struct phy_reg phy_reg_init[] = {
-		/* Channel estimation fine tune */
-		{ 0x1f, 0x0003 },
-		{ 0x09, 0xa20f },
-		{ 0x1f, 0x0000 },
+	struct phy_device *phydev = tp->phydev;
 
-		/* Modify green table for giga & fnet */
-		{ 0x1f, 0x0005 },
-		{ 0x05, 0x8b55 },
-		{ 0x06, 0x0000 },
-		{ 0x05, 0x8b5e },
-		{ 0x06, 0x0000 },
-		{ 0x05, 0x8b67 },
-		{ 0x06, 0x0000 },
-		{ 0x05, 0x8b70 },
-		{ 0x06, 0x0000 },
-		{ 0x1f, 0x0000 },
-		{ 0x1f, 0x0007 },
-		{ 0x1e, 0x0078 },
-		{ 0x17, 0x0000 },
-		{ 0x19, 0x00fb },
-		{ 0x1f, 0x0000 },
+	rtl_apply_firmware(tp);
 
-		/* Modify green table for 10M */
-		{ 0x1f, 0x0005 },
-		{ 0x05, 0x8b79 },
-		{ 0x06, 0xaa00 },
-		{ 0x1f, 0x0000 },
+	/* Channel estimation fine tune */
+	phy_write_paged(phydev, 0x0003, 0x09, 0xa20f);
 
-		/* Disable hiimpedance detection (RTCT) */
-		{ 0x1f, 0x0003 },
-		{ 0x01, 0x328a },
-		{ 0x1f, 0x0000 }
-	};
+	/* Modify green table for giga & fnet */
+	r8168d_phy_param(phydev, 0x8b55, 0xffff, 0x0000);
+	r8168d_phy_param(phydev, 0x8b5e, 0xffff, 0x0000);
+	r8168d_phy_param(phydev, 0x8b67, 0xffff, 0x0000);
+	r8168d_phy_param(phydev, 0x8b70, 0xffff, 0x0000);
+	phy_write(phydev, 0x1f, 0x0007);
+	phy_write(phydev, 0x1e, 0x0078);
+	phy_write(phydev, 0x17, 0x0000);
+	phy_write(phydev, 0x19, 0x00fb);
+	phy_write(phydev, 0x1f, 0x0000);
 
-	rtl_apply_firmware(tp);
+	/* Modify green table for 10M */
+	r8168d_phy_param(phydev, 0x8b79, 0xffff, 0xaa00);
 
-	rtl_writephy_batch(tp, phy_reg_init);
+	/* Disable hiimpedance detection (RTCT) */
+	phy_write_paged(phydev, 0x0003, 0x01, 0x328a);
 
 	rtl8168f_hw_phy_config(tp);
 
 	/* Improve 2-pair detection performance */
-	rtl_writephy(tp, 0x1f, 0x0005);
-	rtl_writephy(tp, 0x05, 0x8b85);
-	rtl_w0w1_phy(tp, 0x06, 0x4000, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168d_phy_param(phydev, 0x8b85, 0x0000, 0x4000);
 }
 
 static void rtl8168f_2_hw_phy_config(struct rtl8169_private *tp)
@@ -3143,77 +3095,46 @@ static void rtl8168f_2_hw_phy_config(struct rtl8169_private *tp)
 
 static void rtl8411_hw_phy_config(struct rtl8169_private *tp)
 {
-	static const struct phy_reg phy_reg_init[] = {
-		/* Channel estimation fine tune */
-		{ 0x1f, 0x0003 },
-		{ 0x09, 0xa20f },
-		{ 0x1f, 0x0000 },
-
-		/* Modify green table for giga & fnet */
-		{ 0x1f, 0x0005 },
-		{ 0x05, 0x8b55 },
-		{ 0x06, 0x0000 },
-		{ 0x05, 0x8b5e },
-		{ 0x06, 0x0000 },
-		{ 0x05, 0x8b67 },
-		{ 0x06, 0x0000 },
-		{ 0x05, 0x8b70 },
-		{ 0x06, 0x0000 },
-		{ 0x1f, 0x0000 },
-		{ 0x1f, 0x0007 },
-		{ 0x1e, 0x0078 },
-		{ 0x17, 0x0000 },
-		{ 0x19, 0x00aa },
-		{ 0x1f, 0x0000 },
-
-		/* Modify green table for 10M */
-		{ 0x1f, 0x0005 },
-		{ 0x05, 0x8b79 },
-		{ 0x06, 0xaa00 },
-		{ 0x1f, 0x0000 },
-
-		/* Disable hiimpedance detection (RTCT) */
-		{ 0x1f, 0x0003 },
-		{ 0x01, 0x328a },
-		{ 0x1f, 0x0000 }
-	};
-
+	struct phy_device *phydev = tp->phydev;
 
 	rtl_apply_firmware(tp);
 
 	rtl8168f_hw_phy_config(tp);
 
 	/* Improve 2-pair detection performance */
-	rtl_writephy(tp, 0x1f, 0x0005);
-	rtl_writephy(tp, 0x05, 0x8b85);
-	rtl_w0w1_phy(tp, 0x06, 0x4000, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168d_phy_param(phydev, 0x8b85, 0x0000, 0x4000);
 
-	rtl_writephy_batch(tp, phy_reg_init);
+	/* Channel estimation fine tune */
+	phy_write_paged(phydev, 0x0003, 0x09, 0xa20f);
+
+	/* Modify green table for giga & fnet */
+	r8168d_phy_param(phydev, 0x8b55, 0xffff, 0x0000);
+	r8168d_phy_param(phydev, 0x8b5e, 0xffff, 0x0000);
+	r8168d_phy_param(phydev, 0x8b67, 0xffff, 0x0000);
+	r8168d_phy_param(phydev, 0x8b70, 0xffff, 0x0000);
+	phy_write(phydev, 0x1f, 0x0007);
+	phy_write(phydev, 0x1e, 0x0078);
+	phy_write(phydev, 0x17, 0x0000);
+	phy_write(phydev, 0x19, 0x00aa);
+	phy_write(phydev, 0x1f, 0x0000);
+
+	/* Modify green table for 10M */
+	r8168d_phy_param(phydev, 0x8b79, 0xffff, 0xaa00);
+
+	/* Disable hiimpedance detection (RTCT) */
+	phy_write_paged(phydev, 0x0003, 0x01, 0x328a);
 
 	/* Modify green table for giga */
-	rtl_writephy(tp, 0x1f, 0x0005);
-	rtl_writephy(tp, 0x05, 0x8b54);
-	rtl_w0w1_phy(tp, 0x06, 0x0000, 0x0800);
-	rtl_writephy(tp, 0x05, 0x8b5d);
-	rtl_w0w1_phy(tp, 0x06, 0x0000, 0x0800);
-	rtl_writephy(tp, 0x05, 0x8a7c);
-	rtl_w0w1_phy(tp, 0x06, 0x0000, 0x0100);
-	rtl_writephy(tp, 0x05, 0x8a7f);
-	rtl_w0w1_phy(tp, 0x06, 0x0100, 0x0000);
-	rtl_writephy(tp, 0x05, 0x8a82);
-	rtl_w0w1_phy(tp, 0x06, 0x0000, 0x0100);
-	rtl_writephy(tp, 0x05, 0x8a85);
-	rtl_w0w1_phy(tp, 0x06, 0x0000, 0x0100);
-	rtl_writephy(tp, 0x05, 0x8a88);
-	rtl_w0w1_phy(tp, 0x06, 0x0000, 0x0100);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168d_phy_param(phydev, 0x8b54, 0x0800, 0x0000);
+	r8168d_phy_param(phydev, 0x8b5d, 0x0800, 0x0000);
+	r8168d_phy_param(phydev, 0x8a7c, 0x0100, 0x0000);
+	r8168d_phy_param(phydev, 0x8a7f, 0x0000, 0x0100);
+	r8168d_phy_param(phydev, 0x8a82, 0x0100, 0x0000);
+	r8168d_phy_param(phydev, 0x8a85, 0x0100, 0x0000);
+	r8168d_phy_param(phydev, 0x8a88, 0x0100, 0x0000);
 
 	/* uc same-seed solution */
-	rtl_writephy(tp, 0x1f, 0x0005);
-	rtl_writephy(tp, 0x05, 0x8b85);
-	rtl_w0w1_phy(tp, 0x06, 0x8000, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168d_phy_param(phydev, 0x8b85, 0x0000, 0x8000);
 
 	/* Green feature */
 	rtl_writephy(tp, 0x1f, 0x0003);
-- 
2.24.0


