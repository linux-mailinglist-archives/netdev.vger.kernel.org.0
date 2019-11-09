Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C10B1F6191
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 22:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfKIVCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 16:02:55 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34825 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbfKIVCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 16:02:54 -0500
Received: by mail-wr1-f68.google.com with SMTP id p2so10728150wro.2
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 13:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ibiLE+pcyQqLCDrO5hL4RpaWrQlSgp9oWgf9PyFLxSU=;
        b=EBqhvKkaJV1+7xfCkYJuwervawvevzgos/7eMIlUIWLJUSbLI/FEjhWjEnBQlLh/Ct
         LvcyLS+QZ6FV4b1vIHvUtKDARMd315xkqoj/cRCqlNklbr+SKg6X+T7hLT4JznIpdNns
         EGqnvcrfRGvfyVcnRHh5RlLEfgB9letYD8Mz3PWmJZZlIb9ocRUqKimxEb4Gjy4qpxE1
         yEKymM32mIo12cc/ivNUFSNIk22B5Zs2Xde88akP0mtW7m27+UD4YIkvJjnJWL9Dm4CD
         5cQmC1jJiiU7Q2DlgtASgwm2/STEblDDTjXGHKPo1SugNDUfgEBpyNRhN/PUW36erF8B
         82IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ibiLE+pcyQqLCDrO5hL4RpaWrQlSgp9oWgf9PyFLxSU=;
        b=VLt7zVFVURpm0z+L/byWSo6/kN7PHZjsYTOisoUgim+5gPVQbiWfOs9QVhAcvWTD4X
         V+dexmlPNJ9XJWv/Bdv1G5CwuyuflhW645jk8vp6orPBqNkjdXS/vMtkc8a42QV7sNKb
         F1NUV7bxzJ5G80ge4MMLNyVrpMSrEkZTkGfVyCxVbIQExDmPwmyaTkzV0zjgvmIKQbkM
         mBifCNtlrzLL2vdbN0MxNxMPChPZi+/TNBX+YHmFreKoDZO3E8iHEFU/xsmgZ8R5xjlT
         TTotFgdfdbNrbNqnCZc+wBiwMRuvm51e/px0wiDRk51tcTfTmrSVkcL47VfFzQ9IxjVP
         fq9A==
X-Gm-Message-State: APjAAAWX1AJ553/c5sTAAhIDvr98U5Q/FWpO8b7Mb2MqwYICPgofDEuf
        /1K+/Yfcj4jywDsWPBqCFS0ijgz/
X-Google-Smtp-Source: APXvYqyoqqumWuS4jdBjfrflf6+m0CxbdC2nnuJ70FaRlsRZnV0ZJzW0axKlU5opv1/Py+4BwVTnrA==
X-Received: by 2002:a5d:4445:: with SMTP id x5mr4970604wrr.42.1573333369516;
        Sat, 09 Nov 2019 13:02:49 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4d:a200:7127:c2c7:8451:a38b? (p200300EA8F4DA2007127C2C78451A38B.dip0.t-ipconnect.de. [2003:ea:8f4d:a200:7127:c2c7:8451:a38b])
        by smtp.googlemail.com with ESMTPSA id q15sm1173341wrs.91.2019.11.09.13.02.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 13:02:49 -0800 (PST)
Subject: [PATCH net-next 3/5] r8169: switch to phylib functions in more places
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <11f690c9-ed72-f84b-a7c3-9e18235d6a9a@gmail.com>
Message-ID: <a3de4783-e91e-f5bc-7c10-c3835a936dda@gmail.com>
Date:   Sat, 9 Nov 2019 22:00:51 +0100
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

Use the phylib MDIO access functions in more places to simplify
the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 85 +++++------------------
 1 file changed, 17 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index fa4b3d71f..b3263a887 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2405,13 +2405,7 @@ static void rtl8169s_hw_phy_config(struct rtl8169_private *tp)
 
 static void rtl8169sb_hw_phy_config(struct rtl8169_private *tp)
 {
-	static const struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0002 },
-		{ 0x01, 0x90d0 },
-		{ 0x1f, 0x0000 }
-	};
-
-	rtl_writephy_batch(tp, phy_reg_init);
+	phy_write_paged(tp->phydev, 0x0002, 0x01, 0x90d0);
 }
 
 static void rtl8169scd_hw_phy_config_quirk(struct rtl8169_private *tp)
@@ -2422,9 +2416,7 @@ static void rtl8169scd_hw_phy_config_quirk(struct rtl8169_private *tp)
 	    (pdev->subsystem_device != 0xe000))
 		return;
 
-	rtl_writephy(tp, 0x1f, 0x0001);
-	rtl_writephy(tp, 0x10, 0xf01b);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_write_paged(tp->phydev, 0x0001, 0x10, 0xf01b);
 }
 
 static void rtl8169scd_hw_phy_config(struct rtl8169_private *tp)
@@ -2529,54 +2521,28 @@ static void rtl8169sce_hw_phy_config(struct rtl8169_private *tp)
 
 static void rtl8168bb_hw_phy_config(struct rtl8169_private *tp)
 {
-	static const struct phy_reg phy_reg_init[] = {
-		{ 0x10, 0xf41b },
-		{ 0x1f, 0x0000 }
-	};
-
 	rtl_writephy(tp, 0x1f, 0x0001);
 	rtl_patchphy(tp, 0x16, 1 << 0);
-
-	rtl_writephy_batch(tp, phy_reg_init);
+	rtl_writephy(tp, 0x10, 0xf41b);
+	rtl_writephy(tp, 0x1f, 0x0000);
 }
 
 static void rtl8168bef_hw_phy_config(struct rtl8169_private *tp)
 {
-	static const struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0001 },
-		{ 0x10, 0xf41b },
-		{ 0x1f, 0x0000 }
-	};
-
-	rtl_writephy_batch(tp, phy_reg_init);
+	phy_write_paged(tp->phydev, 0x0001, 0x10, 0xf41b);
 }
 
 static void rtl8168cp_1_hw_phy_config(struct rtl8169_private *tp)
 {
-	static const struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0000 },
-		{ 0x1d, 0x0f00 },
-		{ 0x1f, 0x0002 },
-		{ 0x0c, 0x1ec8 },
-		{ 0x1f, 0x0000 }
-	};
-
-	rtl_writephy_batch(tp, phy_reg_init);
+	phy_write(tp->phydev, 0x1d, 0x0f00);
+	phy_write_paged(tp->phydev, 0x0002, 0x0c, 0x1ec8);
 }
 
 static void rtl8168cp_2_hw_phy_config(struct rtl8169_private *tp)
 {
-	static const struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0001 },
-		{ 0x1d, 0x3d98 },
-		{ 0x1f, 0x0000 }
-	};
-
-	rtl_writephy(tp, 0x1f, 0x0000);
-	rtl_patchphy(tp, 0x14, 1 << 5);
-	rtl_patchphy(tp, 0x0d, 1 << 5);
-
-	rtl_writephy_batch(tp, phy_reg_init);
+	phy_set_bits(tp->phydev, 0x14, BIT(5));
+	phy_set_bits(tp->phydev, 0x0d, BIT(5));
+	phy_write_paged(tp->phydev, 0x0001, 0x1d, 0x3d98);
 }
 
 static void rtl8168c_1_hw_phy_config(struct rtl8169_private *tp)
@@ -2929,9 +2895,7 @@ static void rtl8168e_1_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0000);
 
 	/* For impedance matching */
-	rtl_writephy(tp, 0x1f, 0x0002);
-	rtl_w0w1_phy(tp, 0x08, 0x8000, 0x7f00);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_modify_paged(phydev, 0x0002, 0x08, 0x7f00, 0x8000);
 
 	/* PHY auto speed down */
 	rtl_writephy(tp, 0x1f, 0x0007);
@@ -3428,35 +3392,21 @@ static void rtl8102e_hw_phy_config(struct rtl8169_private *tp)
 
 static void rtl8105e_hw_phy_config(struct rtl8169_private *tp)
 {
-	static const struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0005 },
-		{ 0x1a, 0x0000 },
-		{ 0x1f, 0x0000 },
-
-		{ 0x1f, 0x0004 },
-		{ 0x1c, 0x0000 },
-		{ 0x1f, 0x0000 },
-
-		{ 0x1f, 0x0001 },
-		{ 0x15, 0x7701 },
-		{ 0x1f, 0x0000 }
-	};
-
 	/* Disable ALDPS before ram code */
-	rtl_writephy(tp, 0x1f, 0x0000);
-	rtl_writephy(tp, 0x18, 0x0310);
+	phy_write(tp->phydev, 0x18, 0x0310);
 	msleep(100);
 
 	rtl_apply_firmware(tp);
 
-	rtl_writephy_batch(tp, phy_reg_init);
+	phy_write_paged(tp->phydev, 0x0005, 0x1a, 0x0000);
+	phy_write_paged(tp->phydev, 0x0004, 0x1c, 0x0000);
+	phy_write_paged(tp->phydev, 0x0001, 0x15, 0x7701);
 }
 
 static void rtl8402_hw_phy_config(struct rtl8169_private *tp)
 {
 	/* Disable ALDPS before setting firmware */
-	rtl_writephy(tp, 0x1f, 0x0000);
-	rtl_writephy(tp, 0x18, 0x0310);
+	phy_write(tp->phydev, 0x18, 0x0310);
 	msleep(20);
 
 	rtl_apply_firmware(tp);
@@ -3479,8 +3429,7 @@ static void rtl8106e_hw_phy_config(struct rtl8169_private *tp)
 	};
 
 	/* Disable ALDPS before ram code */
-	rtl_writephy(tp, 0x1f, 0x0000);
-	rtl_writephy(tp, 0x18, 0x0310);
+	phy_write(tp->phydev, 0x18, 0x0310);
 	msleep(100);
 
 	rtl_apply_firmware(tp);
-- 
2.24.0


