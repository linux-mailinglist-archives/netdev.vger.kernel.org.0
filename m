Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E50136126
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730696AbgAITfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:35:42 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39657 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730434AbgAITfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:35:39 -0500
Received: by mail-wm1-f67.google.com with SMTP id 20so4123957wmj.4
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6qzboydMotSkNVjdO0yLeK84G5o/eSoOJfB6WDMgiFU=;
        b=UukTB5bhHyuC3KftGRwndrDnyqTZKW+o0arnkZhrR8EZbpLk/4yZdbmvms4vTqxGNS
         h4SzP6fsTakr3rYATeWy//J7B5ukzAByJglggt12HZ7UafBOD+CltFS5A/6Zja6itpeC
         5wnqm2Z40P6UMtqDxcxsOCxIoklpxfMjSWn2WDg57nDskoWvjzBZFLPqhm0a1o4nLj8x
         luLRxXvj24Cu2qBExws+Hqn/O7BPyTy5lftZ7DqqbHzzvf1hrlX/PpZU74h/S8wqxGU0
         VrbppI1zBEKA5NRIX43Q2n6c2YkkLyGB9UEV+RXg83kJQLbsvapVq+qFZyYaqeLlbBGK
         L71A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6qzboydMotSkNVjdO0yLeK84G5o/eSoOJfB6WDMgiFU=;
        b=NO6oL9y/qHjChoM0f1UPhtawlUlbZuxVHgwAYtGBQYwuebzGFwxW4W0OzR6zgWo6mi
         ZBbP/4lWF1Ra3W1Ytx0NKpR8qxWN/gUyxzxcYyaUme5ArY31kGVdVAzDHzX8289y2TY9
         koIIVqfFqqwq/uzW9PyTk70+Aeute7VT+4wOZnTTUZ7UxneeoIVHea1k6T7FdnA3MAsv
         tKDj+vr+Ik0WNAnUXGbrLj+gOylytyIyFSvaRWQt1A0IWc1r5iOOp4tHX1qx19yX+wh5
         PTgoZhMIdMAbffu34Dt6TYAWvFu53xR1CjAsHPZViGHVhs8mWmhlBYc6rb7XQ2wRxJNT
         08Qw==
X-Gm-Message-State: APjAAAWRKnT4dWrQfTH689Ypj4eFMBGaoUr4m0fCYX4WWOr1cpcFLybt
        avl7hibajFkabyQUpopzOs6Lr/oz
X-Google-Smtp-Source: APXvYqxnngmkv1OkAytbkLWEMJmERKXrfIDMe2XAU0MRugeaMbRAfUj+g3ZA8nWgt4jkwuxHsjzhWA==
X-Received: by 2002:a7b:c450:: with SMTP id l16mr6659808wmi.31.1578598535485;
        Thu, 09 Jan 2020 11:35:35 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id r62sm4051506wma.32.2020.01.09.11.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 11:35:35 -0800 (PST)
Subject: [PATCH net-next 01/15] r8169: prepare for exporting rtl_hw_phy_config
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Message-ID: <3416f10b-5211-987a-2797-e233cf698662@gmail.com>
Date:   Thu, 9 Jan 2020 20:25:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preperation of factoring out the PHY configuration to a separate
source file this patch:
- avoids accessing rtl8169_private internals by passing the phy_device
  and mac_version as separate parameters
- renames rtl_hw_phy_config to r8169_hw_phy_config to avoid namespace
  clashes with other drivers for Realtek hardware

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 217 ++++++++++++----------
 1 file changed, 117 insertions(+), 100 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9c61ce294..df3df5e70 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -693,6 +693,8 @@ struct rtl8169_private {
 };
 
 typedef void (*rtl_generic_fct)(struct rtl8169_private *tp);
+typedef void (*rtl_phy_cfg_fct)(struct rtl8169_private *tp,
+				struct phy_device *phydev);
 
 MODULE_AUTHOR("Realtek and the Linux r8169 crew <netdev@vger.kernel.org>");
 MODULE_DESCRIPTION("RealTek RTL-8169 Gigabit Ethernet driver");
@@ -2349,7 +2351,8 @@ static void rtl8125_config_eee_phy(struct rtl8169_private *tp)
 	phy_modify_paged(phydev, 0xa6d, 0x14, 0x0010, 0x0000);
 }
 
-static void rtl8169s_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8169s_hw_phy_config(struct rtl8169_private *tp,
+				   struct phy_device *phydev)
 {
 	static const struct phy_reg phy_reg_init[] = {
 		{ 0x1f, 0x0001 },
@@ -2416,9 +2419,10 @@ static void rtl8169s_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy_batch(tp, phy_reg_init);
 }
 
-static void rtl8169sb_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8169sb_hw_phy_config(struct rtl8169_private *tp,
+				    struct phy_device *phydev)
 {
-	phy_write_paged(tp->phydev, 0x0002, 0x01, 0x90d0);
+	phy_write_paged(phydev, 0x0002, 0x01, 0x90d0);
 }
 
 static void rtl8169scd_hw_phy_config_quirk(struct rtl8169_private *tp)
@@ -2432,7 +2436,8 @@ static void rtl8169scd_hw_phy_config_quirk(struct rtl8169_private *tp)
 	phy_write_paged(tp->phydev, 0x0001, 0x10, 0xf01b);
 }
 
-static void rtl8169scd_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8169scd_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
 	static const struct phy_reg phy_reg_init[] = {
 		{ 0x1f, 0x0001 },
@@ -2479,7 +2484,8 @@ static void rtl8169scd_hw_phy_config(struct rtl8169_private *tp)
 	rtl8169scd_hw_phy_config_quirk(tp);
 }
 
-static void rtl8169sce_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8169sce_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
 	static const struct phy_reg phy_reg_init[] = {
 		{ 0x1f, 0x0001 },
@@ -2532,7 +2538,8 @@ static void rtl8169sce_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy_batch(tp, phy_reg_init);
 }
 
-static void rtl8168bb_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168bb_hw_phy_config(struct rtl8169_private *tp,
+				    struct phy_device *phydev)
 {
 	rtl_writephy(tp, 0x1f, 0x0001);
 	rtl_patchphy(tp, 0x16, 1 << 0);
@@ -2540,25 +2547,29 @@ static void rtl8168bb_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0000);
 }
 
-static void rtl8168bef_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168bef_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
-	phy_write_paged(tp->phydev, 0x0001, 0x10, 0xf41b);
+	phy_write_paged(phydev, 0x0001, 0x10, 0xf41b);
 }
 
-static void rtl8168cp_1_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168cp_1_hw_phy_config(struct rtl8169_private *tp,
+				      struct phy_device *phydev)
 {
-	phy_write(tp->phydev, 0x1d, 0x0f00);
-	phy_write_paged(tp->phydev, 0x0002, 0x0c, 0x1ec8);
+	phy_write(phydev, 0x1d, 0x0f00);
+	phy_write_paged(phydev, 0x0002, 0x0c, 0x1ec8);
 }
 
-static void rtl8168cp_2_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168cp_2_hw_phy_config(struct rtl8169_private *tp,
+				      struct phy_device *phydev)
 {
-	phy_set_bits(tp->phydev, 0x14, BIT(5));
-	phy_set_bits(tp->phydev, 0x0d, BIT(5));
-	phy_write_paged(tp->phydev, 0x0001, 0x1d, 0x3d98);
+	phy_set_bits(phydev, 0x14, BIT(5));
+	phy_set_bits(phydev, 0x0d, BIT(5));
+	phy_write_paged(phydev, 0x0001, 0x1d, 0x3d98);
 }
 
-static void rtl8168c_1_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168c_1_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
 	static const struct phy_reg phy_reg_init[] = {
 		{ 0x1f, 0x0001 },
@@ -2587,7 +2598,8 @@ static void rtl8168c_1_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0000);
 }
 
-static void rtl8168c_2_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168c_2_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
 	static const struct phy_reg phy_reg_init[] = {
 		{ 0x1f, 0x0001 },
@@ -2615,7 +2627,8 @@ static void rtl8168c_2_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0000);
 }
 
-static void rtl8168c_3_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168c_3_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
 	static const struct phy_reg phy_reg_init[] = {
 		{ 0x1f, 0x0001 },
@@ -2702,7 +2715,8 @@ static void rtl8168d_apply_firmware_cond(struct rtl8169_private *tp, u16 val)
 		rtl_apply_firmware(tp);
 }
 
-static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
 	rtl_writephy_batch(tp, rtl8168d_1_phy_reg_init_0);
 
@@ -2735,8 +2749,8 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp)
 				rtl_writephy(tp, 0x0d, val | set[i]);
 		}
 	} else {
-		phy_write_paged(tp->phydev, 0x0002, 0x05, 0x6662);
-		r8168d_phy_param(tp->phydev, 0x8330, 0xffff, 0x6662);
+		phy_write_paged(phydev, 0x0002, 0x05, 0x6662);
+		r8168d_phy_param(phydev, 0x8330, 0xffff, 0x6662);
 	}
 
 	/* RSET couple improve */
@@ -2753,7 +2767,8 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp)
 	rtl8168d_apply_firmware_cond(tp, 0xbf00);
 }
 
-static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
 	rtl_writephy_batch(tp, rtl8168d_1_phy_reg_init_0);
 
@@ -2777,8 +2792,8 @@ static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp)
 				rtl_writephy(tp, 0x0d, val | set[i]);
 		}
 	} else {
-		phy_write_paged(tp->phydev, 0x0002, 0x05, 0x2642);
-		r8168d_phy_param(tp->phydev, 0x8330, 0xffff, 0x2642);
+		phy_write_paged(phydev, 0x0002, 0x05, 0x2642);
+		r8168d_phy_param(phydev, 0x8330, 0xffff, 0x2642);
 	}
 
 	/* Fine tune PLL performance */
@@ -2794,7 +2809,8 @@ static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp)
 	rtl8168d_apply_firmware_cond(tp, 0xb300);
 }
 
-static void rtl8168d_3_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168d_3_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
 	static const struct phy_reg phy_reg_init[] = {
 		{ 0x1f, 0x0002 },
@@ -2849,17 +2865,19 @@ static void rtl8168d_3_hw_phy_config(struct rtl8169_private *tp)
 
 	rtl_writephy_batch(tp, phy_reg_init);
 
-	r8168d_modify_extpage(tp->phydev, 0x0023, 0x16, 0xffff, 0x0000);
+	r8168d_modify_extpage(phydev, 0x0023, 0x16, 0xffff, 0x0000);
 }
 
-static void rtl8168d_4_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168d_4_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
-	phy_write_paged(tp->phydev, 0x0001, 0x17, 0x0cc0);
-	r8168d_modify_extpage(tp->phydev, 0x002d, 0x18, 0xffff, 0x0040);
-	phy_set_bits(tp->phydev, 0x0d, BIT(5));
+	phy_write_paged(phydev, 0x0001, 0x17, 0x0cc0);
+	r8168d_modify_extpage(phydev, 0x002d, 0x18, 0xffff, 0x0040);
+	phy_set_bits(phydev, 0x0d, BIT(5));
 }
 
-static void rtl8168e_1_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168e_1_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
 	static const struct phy_reg phy_reg_init[] = {
 		/* Channel estimation fine tune */
@@ -2871,7 +2889,6 @@ static void rtl8168e_1_hw_phy_config(struct rtl8169_private *tp)
 		{ 0x14, 0x6420 },
 		{ 0x1f, 0x0000 },
 	};
-	struct phy_device *phydev = tp->phydev;
 
 	rtl_apply_firmware(tp);
 
@@ -2918,10 +2935,9 @@ static void rtl_rar_exgmac_set(struct rtl8169_private *tp, u8 *addr)
 	rtl_eri_write(tp, 0xf4, ERIAR_MASK_1111, w[1] | (w[2] << 16));
 }
 
-static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
-	struct phy_device *phydev = tp->phydev;
-
 	rtl_apply_firmware(tp);
 
 	/* Enable Delay cap */
@@ -2963,10 +2979,9 @@ static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0000);
 }
 
-static void rtl8168f_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168f_hw_phy_config(struct rtl8169_private *tp,
+				   struct phy_device *phydev)
 {
-	struct phy_device *phydev = tp->phydev;
-
 	/* For 4-corner performance improve */
 	r8168d_phy_param(phydev, 0x8b80, 0x0000, 0x0006);
 
@@ -2980,10 +2995,9 @@ static void rtl8168f_hw_phy_config(struct rtl8169_private *tp)
 	rtl8168f_config_eee_phy(tp);
 }
 
-static void rtl8168f_1_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168f_1_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
-	struct phy_device *phydev = tp->phydev;
-
 	rtl_apply_firmware(tp);
 
 	/* Channel estimation fine tune */
@@ -3003,26 +3017,26 @@ static void rtl8168f_1_hw_phy_config(struct rtl8169_private *tp)
 	/* Disable hiimpedance detection (RTCT) */
 	phy_write_paged(phydev, 0x0003, 0x01, 0x328a);
 
-	rtl8168f_hw_phy_config(tp);
+	rtl8168f_hw_phy_config(tp, phydev);
 
 	/* Improve 2-pair detection performance */
 	r8168d_phy_param(phydev, 0x8b85, 0x0000, 0x4000);
 }
 
-static void rtl8168f_2_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168f_2_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
 	rtl_apply_firmware(tp);
 
-	rtl8168f_hw_phy_config(tp);
+	rtl8168f_hw_phy_config(tp, phydev);
 }
 
-static void rtl8411_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8411_hw_phy_config(struct rtl8169_private *tp,
+				  struct phy_device *phydev)
 {
-	struct phy_device *phydev = tp->phydev;
-
 	rtl_apply_firmware(tp);
 
-	rtl8168f_hw_phy_config(tp);
+	rtl8168f_hw_phy_config(tp, phydev);
 
 	/* Improve 2-pair detection performance */
 	r8168d_phy_param(phydev, 0x8b85, 0x0000, 0x4000);
@@ -3078,36 +3092,37 @@ static void rtl8168g_phy_adjust_10m_aldps(struct rtl8169_private *tp)
 	phy_modify_paged(phydev, 0x0a43, 0x10, 0x0000, 0x1003);
 }
 
-static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
 	int ret;
 
 	rtl_apply_firmware(tp);
 
-	ret = phy_read_paged(tp->phydev, 0x0a46, 0x10);
+	ret = phy_read_paged(phydev, 0x0a46, 0x10);
 	if (ret & BIT(8))
-		phy_modify_paged(tp->phydev, 0x0bcc, 0x12, BIT(15), 0);
+		phy_modify_paged(phydev, 0x0bcc, 0x12, BIT(15), 0);
 	else
-		phy_modify_paged(tp->phydev, 0x0bcc, 0x12, 0, BIT(15));
+		phy_modify_paged(phydev, 0x0bcc, 0x12, 0, BIT(15));
 
-	ret = phy_read_paged(tp->phydev, 0x0a46, 0x13);
+	ret = phy_read_paged(phydev, 0x0a46, 0x13);
 	if (ret & BIT(8))
-		phy_modify_paged(tp->phydev, 0x0c41, 0x15, 0, BIT(1));
+		phy_modify_paged(phydev, 0x0c41, 0x15, 0, BIT(1));
 	else
-		phy_modify_paged(tp->phydev, 0x0c41, 0x15, BIT(1), 0);
+		phy_modify_paged(phydev, 0x0c41, 0x15, BIT(1), 0);
 
 	/* Enable PHY auto speed down */
-	phy_modify_paged(tp->phydev, 0x0a44, 0x11, 0, BIT(3) | BIT(2));
+	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(3) | BIT(2));
 
 	rtl8168g_phy_adjust_10m_aldps(tp);
 
 	/* EEE auto-fallback function */
-	phy_modify_paged(tp->phydev, 0x0a4b, 0x11, 0, BIT(2));
+	phy_modify_paged(phydev, 0x0a4b, 0x11, 0, BIT(2));
 
 	/* Enable UC LPF tune function */
-	r8168g_phy_param(tp->phydev, 0x8012, 0x0000, 0x8000);
+	r8168g_phy_param(phydev, 0x8012, 0x0000, 0x8000);
 
-	phy_modify_paged(tp->phydev, 0x0c42, 0x11, BIT(13), BIT(14));
+	phy_modify_paged(phydev, 0x0c42, 0x11, BIT(13), BIT(14));
 
 	/* Improve SWR Efficiency */
 	rtl_writephy(tp, 0x1f, 0x0bcd);
@@ -3125,15 +3140,16 @@ static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp)
 	rtl8168g_config_eee_phy(tp);
 }
 
-static void rtl8168g_2_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168g_2_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
 	rtl_apply_firmware(tp);
 	rtl8168g_config_eee_phy(tp);
 }
 
-static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
-	struct phy_device *phydev = tp->phydev;
 	u16 dout_tapbin;
 	u32 data;
 
@@ -3177,10 +3193,10 @@ static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp)
 	phy_modify_paged(phydev, 0x0a42, 0x16, 0x0000, 0x0002);
 
 	/* enable GPHY 10M */
-	phy_modify_paged(tp->phydev, 0x0a44, 0x11, 0, BIT(11));
+	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(11));
 
 	/* SAR ADC performance */
-	phy_modify_paged(tp->phydev, 0x0bca, 0x17, BIT(12) | BIT(13), BIT(14));
+	phy_modify_paged(phydev, 0x0bca, 0x17, BIT(12) | BIT(13), BIT(14));
 
 	r8168g_phy_param(phydev, 0x803f, 0x3000, 0x0000);
 	r8168g_phy_param(phydev, 0x8047, 0x3000, 0x0000);
@@ -3191,7 +3207,7 @@ static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp)
 	r8168g_phy_param(phydev, 0x806f, 0x3000, 0x0000);
 
 	/* disable phy pfm mode */
-	phy_modify_paged(tp->phydev, 0x0a44, 0x11, BIT(7), 0);
+	phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
 
 	rtl8168g_disable_aldps(tp);
 	rtl8168h_config_eee_phy(tp);
@@ -3213,9 +3229,9 @@ static u16 rtl8168h_2_get_adc_bias_ioffset(struct rtl8169_private *tp)
 	return ioffset;
 }
 
-static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
-	struct phy_device *phydev = tp->phydev;
 	u16 ioffset, rlen;
 	u32 data;
 
@@ -3229,7 +3245,7 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp)
 	phy_modify_paged(phydev, 0x0a42, 0x16, 0x0000, 0x0002);
 
 	/* enable GPHY 10M */
-	phy_modify_paged(tp->phydev, 0x0a44, 0x11, 0, BIT(11));
+	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(11));
 
 	ioffset = rtl8168h_2_get_adc_bias_ioffset(tp);
 	if (ioffset != 0xffff)
@@ -3251,10 +3267,9 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp)
 	rtl8168g_config_eee_phy(tp);
 }
 
-static void rtl8168ep_1_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168ep_1_hw_phy_config(struct rtl8169_private *tp,
+				      struct phy_device *phydev)
 {
-	struct phy_device *phydev = tp->phydev;
-
 	/* Enable PHY auto speed down */
 	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(3) | BIT(2));
 
@@ -3273,17 +3288,16 @@ static void rtl8168ep_1_hw_phy_config(struct rtl8169_private *tp)
 	rtl8168g_config_eee_phy(tp);
 }
 
-static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp,
+				      struct phy_device *phydev)
 {
-	struct phy_device *phydev = tp->phydev;
-
 	rtl8168g_phy_adjust_10m_aldps(tp);
 
 	/* Enable UC LPF tune function */
 	r8168g_phy_param(phydev, 0x8012, 0x0000, 0x8000);
 
 	/* Set rg_sel_sdm_rate */
-	phy_modify_paged(tp->phydev, 0x0c42, 0x11, BIT(13), BIT(14));
+	phy_modify_paged(phydev, 0x0c42, 0x11, BIT(13), BIT(14));
 
 	/* Channel estimation parameters */
 	r8168g_phy_param(phydev, 0x80f3, 0xff00, 0x8b00);
@@ -3324,10 +3338,9 @@ static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp)
 	rtl8168g_config_eee_phy(tp);
 }
 
-static void rtl8117_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8117_hw_phy_config(struct rtl8169_private *tp,
+				  struct phy_device *phydev)
 {
-	struct phy_device *phydev = tp->phydev;
-
 	/* CHN EST parameters adjust - fnet */
 	r8168g_phy_param(phydev, 0x808e, 0xff00, 0x4800);
 	r8168g_phy_param(phydev, 0x8090, 0xff00, 0xcc00);
@@ -3355,7 +3368,7 @@ static void rtl8117_hw_phy_config(struct rtl8169_private *tp)
 	r8168g_phy_param(phydev, 0x8011, 0x0000, 0x0800);
 
 	/* enable GPHY 10M */
-	phy_modify_paged(tp->phydev, 0x0a44, 0x11, 0, BIT(11));
+	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(11));
 
 	r8168g_phy_param(phydev, 0x8016, 0x0000, 0x0400);
 
@@ -3363,7 +3376,8 @@ static void rtl8117_hw_phy_config(struct rtl8169_private *tp)
 	rtl8168h_config_eee_phy(tp);
 }
 
-static void rtl8102e_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8102e_hw_phy_config(struct rtl8169_private *tp,
+				   struct phy_device *phydev)
 {
 	static const struct phy_reg phy_reg_init[] = {
 		{ 0x1f, 0x0003 },
@@ -3380,23 +3394,25 @@ static void rtl8102e_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy_batch(tp, phy_reg_init);
 }
 
-static void rtl8105e_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8105e_hw_phy_config(struct rtl8169_private *tp,
+				   struct phy_device *phydev)
 {
 	/* Disable ALDPS before ram code */
-	phy_write(tp->phydev, 0x18, 0x0310);
+	phy_write(phydev, 0x18, 0x0310);
 	msleep(100);
 
 	rtl_apply_firmware(tp);
 
-	phy_write_paged(tp->phydev, 0x0005, 0x1a, 0x0000);
-	phy_write_paged(tp->phydev, 0x0004, 0x1c, 0x0000);
-	phy_write_paged(tp->phydev, 0x0001, 0x15, 0x7701);
+	phy_write_paged(phydev, 0x0005, 0x1a, 0x0000);
+	phy_write_paged(phydev, 0x0004, 0x1c, 0x0000);
+	phy_write_paged(phydev, 0x0001, 0x15, 0x7701);
 }
 
-static void rtl8402_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8402_hw_phy_config(struct rtl8169_private *tp,
+				  struct phy_device *phydev)
 {
 	/* Disable ALDPS before setting firmware */
-	phy_write(tp->phydev, 0x18, 0x0310);
+	phy_write(phydev, 0x18, 0x0310);
 	msleep(20);
 
 	rtl_apply_firmware(tp);
@@ -3409,7 +3425,8 @@ static void rtl8402_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0000);
 }
 
-static void rtl8106e_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8106e_hw_phy_config(struct rtl8169_private *tp,
+				   struct phy_device *phydev)
 {
 	static const struct phy_reg phy_reg_init[] = {
 		{ 0x1f, 0x0004 },
@@ -3419,7 +3436,7 @@ static void rtl8106e_hw_phy_config(struct rtl8169_private *tp)
 	};
 
 	/* Disable ALDPS before ram code */
-	phy_write(tp->phydev, 0x18, 0x0310);
+	phy_write(phydev, 0x18, 0x0310);
 	msleep(100);
 
 	rtl_apply_firmware(tp);
@@ -3430,10 +3447,9 @@ static void rtl8106e_hw_phy_config(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0x1d0, ERIAR_MASK_0011, 0x0000);
 }
 
-static void rtl8125_1_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8125_1_hw_phy_config(struct rtl8169_private *tp,
+				    struct phy_device *phydev)
 {
-	struct phy_device *phydev = tp->phydev;
-
 	phy_modify_paged(phydev, 0xad4, 0x10, 0x03ff, 0x0084);
 	phy_modify_paged(phydev, 0xad4, 0x17, 0x0000, 0x0010);
 	phy_modify_paged(phydev, 0xad1, 0x13, 0x03ff, 0x0006);
@@ -3469,9 +3485,9 @@ static void rtl8125_1_hw_phy_config(struct rtl8169_private *tp)
 	rtl8125_config_eee_phy(tp);
 }
 
-static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp)
+static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp,
+				    struct phy_device *phydev)
 {
-	struct phy_device *phydev = tp->phydev;
 	int i;
 
 	phy_modify_paged(phydev, 0xad4, 0x17, 0x0000, 0x0010);
@@ -3534,9 +3550,11 @@ static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp)
 	rtl8125_config_eee_phy(tp);
 }
 
-static void rtl_hw_phy_config(struct net_device *dev)
+static void r8169_hw_phy_config(struct rtl8169_private *tp,
+				struct phy_device *phydev,
+				enum mac_version ver)
 {
-	static const rtl_generic_fct phy_configs[] = {
+	static const rtl_phy_cfg_fct phy_configs[] = {
 		/* PCI devices. */
 		[RTL_GIGA_MAC_VER_02] = rtl8169s_hw_phy_config,
 		[RTL_GIGA_MAC_VER_03] = rtl8169s_hw_phy_config,
@@ -3593,10 +3611,9 @@ static void rtl_hw_phy_config(struct net_device *dev)
 		[RTL_GIGA_MAC_VER_60] = rtl8125_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_61] = rtl8125_2_hw_phy_config,
 	};
-	struct rtl8169_private *tp = netdev_priv(dev);
 
-	if (phy_configs[tp->mac_version])
-		phy_configs[tp->mac_version](tp);
+	if (phy_configs[ver])
+		phy_configs[ver](tp, phydev);
 }
 
 static void rtl_schedule_task(struct rtl8169_private *tp, enum rtl_flag flag)
@@ -3607,7 +3624,7 @@ static void rtl_schedule_task(struct rtl8169_private *tp, enum rtl_flag flag)
 
 static void rtl8169_init_phy(struct net_device *dev, struct rtl8169_private *tp)
 {
-	rtl_hw_phy_config(dev);
+	r8169_hw_phy_config(tp, tp->phydev, tp->mac_version);
 
 	if (tp->mac_version <= RTL_GIGA_MAC_VER_06) {
 		pci_write_config_byte(tp->pci_dev, PCI_LATENCY_TIMER, 0x40);
-- 
2.24.1


