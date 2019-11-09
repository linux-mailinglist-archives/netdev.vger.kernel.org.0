Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A666DF618D
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 22:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfKIVCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 16:02:52 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34775 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfKIVCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 16:02:51 -0500
Received: by mail-wr1-f66.google.com with SMTP id e6so10751016wrw.1
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 13:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GYvWPkLZcCoqAIu4qI5kGHWy4TPAlL/v96ytg1xV+B4=;
        b=EYROeDZahFkRoJozEnkiQaW/Tm7pUKjsIdaL5/rIPXbGYeJaRYySPoUpPvp6yk+nzA
         cmmz1l8W29i8RdNHkN9RJGaeVk6M6imPQyElUnynIuuvu5UHfa/7QNu0laxZzaCEZm3R
         WIc0VLPPDWMzk2/QJbyFdSB1PqqUfFUaYqkMDhhdFXX9f6UfwV3a+eIfVgbreN0GOXwh
         fjwasL8fkJMdB4mETblQ2CMYEFB/0H8ZzrmNJL4+8Ykfr4Pwl2h6btscmrf3+ZySWOf0
         FaOLcXSTgaqHXClADA2kCYpZDyDhU7SegyK7x80jgOu7x9ka1aUcjMCi/72SYufPEaoH
         jvmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GYvWPkLZcCoqAIu4qI5kGHWy4TPAlL/v96ytg1xV+B4=;
        b=KnF49dMTzHwF+9LXwVxDuZU4PUGSyHrHsIfaOKFvI9vMFt5eOoxURf/x1ZEEE6y2eE
         gYDI2sojXtauIexJ6iDcuyYab8yv29bZFVGGSs34husmBdBMtBDLBfjQXU2/YGTugMdM
         9W+qM+29/bX1Y216jeIXijoM7pFdx7WQ21J6yrX9ruGGY0AHRrntxLTn8Iwfxo7Pq9OY
         hgmGGLE0nRH3j2dJdCrGfDkzInmfPdo3vKNd7FDohEHDEJqOa12D2I6w7ABtIpHbm+uc
         3CuhICzd3UwMCdsO9yGcK3vN5ChV52E1ab84OqmzHEI6i29J3xxlCMgMk3DbAheZO2DY
         LQCQ==
X-Gm-Message-State: APjAAAXmP+WmZdrOiIwY6MQQJWZ5Mrj0jSrQxxh4p6uqkMiMp6nOhM1k
        kNOxWs2aUjNTtpXp1b8QVVJ0NONQ
X-Google-Smtp-Source: APXvYqztJrdfqfx/zmrKXtGpRY+WIpH0QYJi4ZRAd4owh2AYBiCG9m67/w7xL3rnj9MMu6b2rHqoYg==
X-Received: by 2002:adf:f945:: with SMTP id q5mr5415759wrr.33.1573333367394;
        Sat, 09 Nov 2019 13:02:47 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4d:a200:7127:c2c7:8451:a38b? (p200300EA8F4DA2007127C2C78451A38B.dip0.t-ipconnect.de. [2003:ea:8f4d:a200:7127:c2c7:8451:a38b])
        by smtp.googlemail.com with ESMTPSA id p14sm11867368wrq.72.2019.11.09.13.02.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 13:02:46 -0800 (PST)
Subject: [PATCH net-next 1/5] r8169: add helper r8168g_phy_param
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <11f690c9-ed72-f84b-a7c3-9e18235d6a9a@gmail.com>
Message-ID: <193ecd02-7306-98ba-cae6-2416c177a700@gmail.com>
Date:   Sat, 9 Nov 2019 21:59:43 +0100
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

Integrated PHY's from RTL8168g support an indirect access method for
PHY parameters. On page 0x0a43 parameter number is written to register
0x13, then the parameter can be accessed via register 0x14.
Add a helper for this to improve readability and simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 285 ++++++++--------------
 1 file changed, 98 insertions(+), 187 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8a7b22301..dbdb77d71 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1086,6 +1086,17 @@ static void rtl_w0w1_phy(struct rtl8169_private *tp, int reg_addr, int p, int m)
 	rtl_writephy(tp, reg_addr, (val & ~m) | p);
 }
 
+static void r8168g_phy_param(struct phy_device *phydev, u16 parm,
+			     u16 mask, u16 val)
+{
+	int oldpage = phy_select_page(phydev, 0x0a43);
+
+	__phy_write(phydev, 0x13, parm);
+	__phy_modify(phydev, 0x14, mask, val);
+
+	phy_restore_page(phydev, oldpage, 0);
+}
+
 DECLARE_RTL_COND(rtl_ephyar_cond)
 {
 	return RTL_R32(tp, EPHYAR) & EPHYAR_FLAG;
@@ -3222,12 +3233,8 @@ static void rtl8168g_phy_adjust_10m_aldps(struct rtl8169_private *tp)
 
 	phy_modify_paged(phydev, 0x0bcc, 0x14, BIT(8), 0);
 	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(7) | BIT(6));
-	phy_write(phydev, 0x1f, 0x0a43);
-	phy_write(phydev, 0x13, 0x8084);
-	phy_clear_bits(phydev, 0x14, BIT(14) | BIT(13));
-	phy_set_bits(phydev, 0x10, BIT(12) | BIT(1) | BIT(0));
-
-	phy_write(phydev, 0x1f, 0x0000);
+	r8168g_phy_param(phydev, 0x8084, 0x6000, 0x0000);
+	phy_modify_paged(phydev, 0x0a43, 0x10, 0x0000, 0x1003);
 }
 
 static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp)
@@ -3257,9 +3264,7 @@ static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp)
 	phy_modify_paged(tp->phydev, 0x0a4b, 0x11, 0, BIT(2));
 
 	/* Enable UC LPF tune function */
-	rtl_writephy(tp, 0x1f, 0x0a43);
-	rtl_writephy(tp, 0x13, 0x8012);
-	rtl_w0w1_phy(tp, 0x14, 0x8000, 0x0000);
+	r8168g_phy_param(tp->phydev, 0x8012, 0x0000, 0x8000);
 
 	phy_modify_paged(tp->phydev, 0x0c42, 0x11, BIT(13), BIT(14));
 
@@ -3289,73 +3294,48 @@ static void rtl8168g_2_hw_phy_config(struct rtl8169_private *tp)
 
 static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp)
 {
+	struct phy_device *phydev = tp->phydev;
 	u16 dout_tapbin;
 	u32 data;
 
 	rtl_apply_firmware(tp);
 
 	/* CHN EST parameters adjust - giga master */
-	rtl_writephy(tp, 0x1f, 0x0a43);
-	rtl_writephy(tp, 0x13, 0x809b);
-	rtl_w0w1_phy(tp, 0x14, 0x8000, 0xf800);
-	rtl_writephy(tp, 0x13, 0x80a2);
-	rtl_w0w1_phy(tp, 0x14, 0x8000, 0xff00);
-	rtl_writephy(tp, 0x13, 0x80a4);
-	rtl_w0w1_phy(tp, 0x14, 0x8500, 0xff00);
-	rtl_writephy(tp, 0x13, 0x809c);
-	rtl_w0w1_phy(tp, 0x14, 0xbd00, 0xff00);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168g_phy_param(phydev, 0x809b, 0xf800, 0x8000);
+	r8168g_phy_param(phydev, 0x80a2, 0xff00, 0x8000);
+	r8168g_phy_param(phydev, 0x80a4, 0xff00, 0x8500);
+	r8168g_phy_param(phydev, 0x809c, 0xff00, 0xbd00);
 
 	/* CHN EST parameters adjust - giga slave */
-	rtl_writephy(tp, 0x1f, 0x0a43);
-	rtl_writephy(tp, 0x13, 0x80ad);
-	rtl_w0w1_phy(tp, 0x14, 0x7000, 0xf800);
-	rtl_writephy(tp, 0x13, 0x80b4);
-	rtl_w0w1_phy(tp, 0x14, 0x5000, 0xff00);
-	rtl_writephy(tp, 0x13, 0x80ac);
-	rtl_w0w1_phy(tp, 0x14, 0x4000, 0xff00);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168g_phy_param(phydev, 0x80ad, 0xf800, 0x7000);
+	r8168g_phy_param(phydev, 0x80b4, 0xff00, 0x5000);
+	r8168g_phy_param(phydev, 0x80ac, 0xff00, 0x4000);
 
 	/* CHN EST parameters adjust - fnet */
-	rtl_writephy(tp, 0x1f, 0x0a43);
-	rtl_writephy(tp, 0x13, 0x808e);
-	rtl_w0w1_phy(tp, 0x14, 0x1200, 0xff00);
-	rtl_writephy(tp, 0x13, 0x8090);
-	rtl_w0w1_phy(tp, 0x14, 0xe500, 0xff00);
-	rtl_writephy(tp, 0x13, 0x8092);
-	rtl_w0w1_phy(tp, 0x14, 0x9f00, 0xff00);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168g_phy_param(phydev, 0x808e, 0xff00, 0x1200);
+	r8168g_phy_param(phydev, 0x8090, 0xff00, 0xe500);
+	r8168g_phy_param(phydev, 0x8092, 0xff00, 0x9f00);
 
 	/* enable R-tune & PGA-retune function */
 	dout_tapbin = 0;
-	rtl_writephy(tp, 0x1f, 0x0a46);
-	data = rtl_readphy(tp, 0x13);
+	data = phy_read_paged(phydev, 0x0a46, 0x13);
 	data &= 3;
 	data <<= 2;
 	dout_tapbin |= data;
-	data = rtl_readphy(tp, 0x12);
+	data = phy_read_paged(phydev, 0x0a46, 0x12);
 	data &= 0xc000;
 	data >>= 14;
 	dout_tapbin |= data;
 	dout_tapbin = ~(dout_tapbin^0x08);
 	dout_tapbin <<= 12;
 	dout_tapbin &= 0xf000;
-	rtl_writephy(tp, 0x1f, 0x0a43);
-	rtl_writephy(tp, 0x13, 0x827a);
-	rtl_w0w1_phy(tp, 0x14, dout_tapbin, 0xf000);
-	rtl_writephy(tp, 0x13, 0x827b);
-	rtl_w0w1_phy(tp, 0x14, dout_tapbin, 0xf000);
-	rtl_writephy(tp, 0x13, 0x827c);
-	rtl_w0w1_phy(tp, 0x14, dout_tapbin, 0xf000);
-	rtl_writephy(tp, 0x13, 0x827d);
-	rtl_w0w1_phy(tp, 0x14, dout_tapbin, 0xf000);
-
-	rtl_writephy(tp, 0x1f, 0x0a43);
-	rtl_writephy(tp, 0x13, 0x0811);
-	rtl_w0w1_phy(tp, 0x14, 0x0800, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0a42);
-	rtl_w0w1_phy(tp, 0x16, 0x0002, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+
+	r8168g_phy_param(phydev, 0x827a, 0xf000, dout_tapbin);
+	r8168g_phy_param(phydev, 0x827b, 0xf000, dout_tapbin);
+	r8168g_phy_param(phydev, 0x827c, 0xf000, dout_tapbin);
+	r8168g_phy_param(phydev, 0x827d, 0xf000, dout_tapbin);
+	r8168g_phy_param(phydev, 0x0811, 0x0000, 0x0800);
+	phy_modify_paged(phydev, 0x0a42, 0x16, 0x0000, 0x0002);
 
 	/* enable GPHY 10M */
 	phy_modify_paged(tp->phydev, 0x0a44, 0x11, 0, BIT(11));
@@ -3363,22 +3343,13 @@ static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp)
 	/* SAR ADC performance */
 	phy_modify_paged(tp->phydev, 0x0bca, 0x17, BIT(12) | BIT(13), BIT(14));
 
-	rtl_writephy(tp, 0x1f, 0x0a43);
-	rtl_writephy(tp, 0x13, 0x803f);
-	rtl_w0w1_phy(tp, 0x14, 0x0000, 0x3000);
-	rtl_writephy(tp, 0x13, 0x8047);
-	rtl_w0w1_phy(tp, 0x14, 0x0000, 0x3000);
-	rtl_writephy(tp, 0x13, 0x804f);
-	rtl_w0w1_phy(tp, 0x14, 0x0000, 0x3000);
-	rtl_writephy(tp, 0x13, 0x8057);
-	rtl_w0w1_phy(tp, 0x14, 0x0000, 0x3000);
-	rtl_writephy(tp, 0x13, 0x805f);
-	rtl_w0w1_phy(tp, 0x14, 0x0000, 0x3000);
-	rtl_writephy(tp, 0x13, 0x8067);
-	rtl_w0w1_phy(tp, 0x14, 0x0000, 0x3000);
-	rtl_writephy(tp, 0x13, 0x806f);
-	rtl_w0w1_phy(tp, 0x14, 0x0000, 0x3000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168g_phy_param(phydev, 0x803f, 0x3000, 0x0000);
+	r8168g_phy_param(phydev, 0x8047, 0x3000, 0x0000);
+	r8168g_phy_param(phydev, 0x804f, 0x3000, 0x0000);
+	r8168g_phy_param(phydev, 0x8057, 0x3000, 0x0000);
+	r8168g_phy_param(phydev, 0x805f, 0x3000, 0x0000);
+	r8168g_phy_param(phydev, 0x8067, 0x3000, 0x0000);
+	r8168g_phy_param(phydev, 0x806f, 0x3000, 0x0000);
 
 	/* disable phy pfm mode */
 	phy_modify_paged(tp->phydev, 0x0a44, 0x11, BIT(7), 0);
@@ -3391,24 +3362,18 @@ static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp)
 static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp)
 {
 	u16 ioffset_p3, ioffset_p2, ioffset_p1, ioffset_p0;
+	struct phy_device *phydev = tp->phydev;
 	u16 rlen;
 	u32 data;
 
 	rtl_apply_firmware(tp);
 
 	/* CHIN EST parameter update */
-	rtl_writephy(tp, 0x1f, 0x0a43);
-	rtl_writephy(tp, 0x13, 0x808a);
-	rtl_w0w1_phy(tp, 0x14, 0x000a, 0x003f);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168g_phy_param(phydev, 0x808a, 0x003f, 0x000a);
 
 	/* enable R-tune & PGA-retune function */
-	rtl_writephy(tp, 0x1f, 0x0a43);
-	rtl_writephy(tp, 0x13, 0x0811);
-	rtl_w0w1_phy(tp, 0x14, 0x0800, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0a42);
-	rtl_w0w1_phy(tp, 0x16, 0x0002, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168g_phy_param(phydev, 0x0811, 0x0000, 0x0800);
+	phy_modify_paged(phydev, 0x0a42, 0x16, 0x0000, 0x0002);
 
 	/* enable GPHY 10M */
 	phy_modify_paged(tp->phydev, 0x0a44, 0x11, 0, BIT(11));
@@ -3428,26 +3393,20 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp)
 	data = (ioffset_p3<<12)|(ioffset_p2<<8)|(ioffset_p1<<4)|(ioffset_p0);
 
 	if ((ioffset_p3 != 0x0f) || (ioffset_p2 != 0x0f) ||
-	    (ioffset_p1 != 0x0f) || (ioffset_p0 != 0x0f)) {
-		rtl_writephy(tp, 0x1f, 0x0bcf);
-		rtl_writephy(tp, 0x16, data);
-		rtl_writephy(tp, 0x1f, 0x0000);
-	}
+	    (ioffset_p1 != 0x0f) || (ioffset_p0 != 0x0f))
+		phy_write_paged(phydev, 0x0bcf, 0x16, data);
 
 	/* Modify rlen (TX LPF corner frequency) level */
-	rtl_writephy(tp, 0x1f, 0x0bcd);
-	data = rtl_readphy(tp, 0x16);
+	data = phy_read_paged(phydev, 0x0bcd, 0x16);
 	data &= 0x000f;
 	rlen = 0;
 	if (data > 3)
 		rlen = data - 3;
 	data = rlen | (rlen<<4) | (rlen<<8) | (rlen<<12);
-	rtl_writephy(tp, 0x17, data);
-	rtl_writephy(tp, 0x1f, 0x0bcd);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_write_paged(phydev, 0x0bcd, 0x17, data);
 
 	/* disable phy pfm mode */
-	phy_modify_paged(tp->phydev, 0x0a44, 0x11, BIT(7), 0);
+	phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
 
 	rtl8168g_disable_aldps(tp);
 	rtl8168g_config_eee_phy(tp);
@@ -3456,22 +3415,21 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp)
 
 static void rtl8168ep_1_hw_phy_config(struct rtl8169_private *tp)
 {
+	struct phy_device *phydev = tp->phydev;
+
 	/* Enable PHY auto speed down */
-	phy_modify_paged(tp->phydev, 0x0a44, 0x11, 0, BIT(3) | BIT(2));
+	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(3) | BIT(2));
 
 	rtl8168g_phy_adjust_10m_aldps(tp);
 
 	/* Enable EEE auto-fallback function */
-	phy_modify_paged(tp->phydev, 0x0a4b, 0x11, 0, BIT(2));
+	phy_modify_paged(phydev, 0x0a4b, 0x11, 0, BIT(2));
 
 	/* Enable UC LPF tune function */
-	rtl_writephy(tp, 0x1f, 0x0a43);
-	rtl_writephy(tp, 0x13, 0x8012);
-	rtl_w0w1_phy(tp, 0x14, 0x8000, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168g_phy_param(phydev, 0x8012, 0x0000, 0x8000);
 
 	/* set rg_sel_sdm_rate */
-	phy_modify_paged(tp->phydev, 0x0c42, 0x11, BIT(13), BIT(14));
+	phy_modify_paged(phydev, 0x0c42, 0x11, BIT(13), BIT(14));
 
 	rtl8168g_disable_aldps(tp);
 	rtl8168g_config_eee_phy(tp);
@@ -3480,63 +3438,38 @@ static void rtl8168ep_1_hw_phy_config(struct rtl8169_private *tp)
 
 static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp)
 {
+	struct phy_device *phydev = tp->phydev;
+
 	rtl8168g_phy_adjust_10m_aldps(tp);
 
 	/* Enable UC LPF tune function */
-	rtl_writephy(tp, 0x1f, 0x0a43);
-	rtl_writephy(tp, 0x13, 0x8012);
-	rtl_w0w1_phy(tp, 0x14, 0x8000, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	r8168g_phy_param(phydev, 0x8012, 0x0000, 0x8000);
 
 	/* Set rg_sel_sdm_rate */
 	phy_modify_paged(tp->phydev, 0x0c42, 0x11, BIT(13), BIT(14));
 
 	/* Channel estimation parameters */
-	rtl_writephy(tp, 0x1f, 0x0a43);
-	rtl_writephy(tp, 0x13, 0x80f3);
-	rtl_w0w1_phy(tp, 0x14, 0x8b00, ~0x8bff);
-	rtl_writephy(tp, 0x13, 0x80f0);
-	rtl_w0w1_phy(tp, 0x14, 0x3a00, ~0x3aff);
-	rtl_writephy(tp, 0x13, 0x80ef);
-	rtl_w0w1_phy(tp, 0x14, 0x0500, ~0x05ff);
-	rtl_writephy(tp, 0x13, 0x80f6);
-	rtl_w0w1_phy(tp, 0x14, 0x6e00, ~0x6eff);
-	rtl_writephy(tp, 0x13, 0x80ec);
-	rtl_w0w1_phy(tp, 0x14, 0x6800, ~0x68ff);
-	rtl_writephy(tp, 0x13, 0x80ed);
-	rtl_w0w1_phy(tp, 0x14, 0x7c00, ~0x7cff);
-	rtl_writephy(tp, 0x13, 0x80f2);
-	rtl_w0w1_phy(tp, 0x14, 0xf400, ~0xf4ff);
-	rtl_writephy(tp, 0x13, 0x80f4);
-	rtl_w0w1_phy(tp, 0x14, 0x8500, ~0x85ff);
-	rtl_writephy(tp, 0x1f, 0x0a43);
-	rtl_writephy(tp, 0x13, 0x8110);
-	rtl_w0w1_phy(tp, 0x14, 0xa800, ~0xa8ff);
-	rtl_writephy(tp, 0x13, 0x810f);
-	rtl_w0w1_phy(tp, 0x14, 0x1d00, ~0x1dff);
-	rtl_writephy(tp, 0x13, 0x8111);
-	rtl_w0w1_phy(tp, 0x14, 0xf500, ~0xf5ff);
-	rtl_writephy(tp, 0x13, 0x8113);
-	rtl_w0w1_phy(tp, 0x14, 0x6100, ~0x61ff);
-	rtl_writephy(tp, 0x13, 0x8115);
-	rtl_w0w1_phy(tp, 0x14, 0x9200, ~0x92ff);
-	rtl_writephy(tp, 0x13, 0x810e);
-	rtl_w0w1_phy(tp, 0x14, 0x0400, ~0x04ff);
-	rtl_writephy(tp, 0x13, 0x810c);
-	rtl_w0w1_phy(tp, 0x14, 0x7c00, ~0x7cff);
-	rtl_writephy(tp, 0x13, 0x810b);
-	rtl_w0w1_phy(tp, 0x14, 0x5a00, ~0x5aff);
-	rtl_writephy(tp, 0x1f, 0x0a43);
-	rtl_writephy(tp, 0x13, 0x80d1);
-	rtl_w0w1_phy(tp, 0x14, 0xff00, ~0xffff);
-	rtl_writephy(tp, 0x13, 0x80cd);
-	rtl_w0w1_phy(tp, 0x14, 0x9e00, ~0x9eff);
-	rtl_writephy(tp, 0x13, 0x80d3);
-	rtl_w0w1_phy(tp, 0x14, 0x0e00, ~0x0eff);
-	rtl_writephy(tp, 0x13, 0x80d5);
-	rtl_w0w1_phy(tp, 0x14, 0xca00, ~0xcaff);
-	rtl_writephy(tp, 0x13, 0x80d7);
-	rtl_w0w1_phy(tp, 0x14, 0x8400, ~0x84ff);
+	r8168g_phy_param(phydev, 0x80f3, 0xff00, 0x8b00);
+	r8168g_phy_param(phydev, 0x80f0, 0xff00, 0x3a00);
+	r8168g_phy_param(phydev, 0x80ef, 0xff00, 0x0500);
+	r8168g_phy_param(phydev, 0x80f6, 0xff00, 0x6e00);
+	r8168g_phy_param(phydev, 0x80ec, 0xff00, 0x6800);
+	r8168g_phy_param(phydev, 0x80ed, 0xff00, 0x7c00);
+	r8168g_phy_param(phydev, 0x80f2, 0xff00, 0xf400);
+	r8168g_phy_param(phydev, 0x80f4, 0xff00, 0x8500);
+	r8168g_phy_param(phydev, 0x8110, 0xff00, 0xa800);
+	r8168g_phy_param(phydev, 0x810f, 0xff00, 0x1d00);
+	r8168g_phy_param(phydev, 0x8111, 0xff00, 0xf500);
+	r8168g_phy_param(phydev, 0x8113, 0xff00, 0x6100);
+	r8168g_phy_param(phydev, 0x8115, 0xff00, 0x9200);
+	r8168g_phy_param(phydev, 0x810e, 0xff00, 0x0400);
+	r8168g_phy_param(phydev, 0x810c, 0xff00, 0x7c00);
+	r8168g_phy_param(phydev, 0x810b, 0xff00, 0x5a00);
+	r8168g_phy_param(phydev, 0x80d1, 0xff00, 0xff00);
+	r8168g_phy_param(phydev, 0x80cd, 0xff00, 0x9e00);
+	r8168g_phy_param(phydev, 0x80d3, 0xff00, 0x0e00);
+	r8168g_phy_param(phydev, 0x80d5, 0xff00, 0xca00);
+	r8168g_phy_param(phydev, 0x80d7, 0xff00, 0x8400);
 
 	/* Force PWM-mode */
 	rtl_writephy(tp, 0x1f, 0x0bcd);
@@ -3651,38 +3584,22 @@ static void rtl8125_1_hw_phy_config(struct rtl8169_private *tp)
 	phy_modify_paged(phydev, 0xad1, 0x15, 0x0000, 0x03ff);
 	phy_modify_paged(phydev, 0xad1, 0x16, 0x0000, 0x03ff);
 
-	phy_write(phydev, 0x1f, 0x0a43);
-	phy_write(phydev, 0x13, 0x80ea);
-	phy_modify(phydev, 0x14, 0xff00, 0xc400);
-	phy_write(phydev, 0x13, 0x80eb);
-	phy_modify(phydev, 0x14, 0x0700, 0x0300);
-	phy_write(phydev, 0x13, 0x80f8);
-	phy_modify(phydev, 0x14, 0xff00, 0x1c00);
-	phy_write(phydev, 0x13, 0x80f1);
-	phy_modify(phydev, 0x14, 0xff00, 0x3000);
-	phy_write(phydev, 0x13, 0x80fe);
-	phy_modify(phydev, 0x14, 0xff00, 0xa500);
-	phy_write(phydev, 0x13, 0x8102);
-	phy_modify(phydev, 0x14, 0xff00, 0x5000);
-	phy_write(phydev, 0x13, 0x8105);
-	phy_modify(phydev, 0x14, 0xff00, 0x3300);
-	phy_write(phydev, 0x13, 0x8100);
-	phy_modify(phydev, 0x14, 0xff00, 0x7000);
-	phy_write(phydev, 0x13, 0x8104);
-	phy_modify(phydev, 0x14, 0xff00, 0xf000);
-	phy_write(phydev, 0x13, 0x8106);
-	phy_modify(phydev, 0x14, 0xff00, 0x6500);
-	phy_write(phydev, 0x13, 0x80dc);
-	phy_modify(phydev, 0x14, 0xff00, 0xed00);
-	phy_write(phydev, 0x13, 0x80df);
-	phy_set_bits(phydev, 0x14, BIT(8));
-	phy_write(phydev, 0x13, 0x80e1);
-	phy_clear_bits(phydev, 0x14, BIT(8));
-	phy_write(phydev, 0x1f, 0x0000);
+	r8168g_phy_param(phydev, 0x80ea, 0xff00, 0xc400);
+	r8168g_phy_param(phydev, 0x80eb, 0x0700, 0x0300);
+	r8168g_phy_param(phydev, 0x80f8, 0xff00, 0x1c00);
+	r8168g_phy_param(phydev, 0x80f1, 0xff00, 0x3000);
+	r8168g_phy_param(phydev, 0x80fe, 0xff00, 0xa500);
+	r8168g_phy_param(phydev, 0x8102, 0xff00, 0x5000);
+	r8168g_phy_param(phydev, 0x8105, 0xff00, 0x3300);
+	r8168g_phy_param(phydev, 0x8100, 0xff00, 0x7000);
+	r8168g_phy_param(phydev, 0x8104, 0xff00, 0xf000);
+	r8168g_phy_param(phydev, 0x8106, 0xff00, 0x6500);
+	r8168g_phy_param(phydev, 0x80dc, 0xff00, 0xed00);
+	r8168g_phy_param(phydev, 0x80df, 0x0000, 0x0100);
+	r8168g_phy_param(phydev, 0x80e1, 0x0100, 0x0000);
 
 	phy_modify_paged(phydev, 0xbf0, 0x13, 0x003f, 0x0038);
-	phy_write_paged(phydev, 0xa43, 0x13, 0x819f);
-	phy_write_paged(phydev, 0xa43, 0x14, 0xd0b6);
+	r8168g_phy_param(phydev, 0x819f, 0xffff, 0xd0b6);
 
 	phy_write_paged(phydev, 0xbc3, 0x12, 0x5555);
 	phy_modify_paged(phydev, 0xbf0, 0x15, 0x0e00, 0x0a00);
@@ -3737,22 +3654,16 @@ static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp)
 	phy_write(phydev, 0x14, 0x0002);
 	for (i = 0; i < 25; i++)
 		phy_write(phydev, 0x14, 0x0000);
-
-	phy_write(phydev, 0x13, 0x8257);
-	phy_write(phydev, 0x14, 0x020F);
-
-	phy_write(phydev, 0x13, 0x80EA);
-	phy_write(phydev, 0x14, 0x7843);
 	phy_write(phydev, 0x1f, 0x0000);
 
+	r8168g_phy_param(phydev, 0x8257, 0xffff, 0x020F);
+	r8168g_phy_param(phydev, 0x80ea, 0xffff, 0x7843);
+
 	rtl_apply_firmware(tp);
 
 	phy_modify_paged(phydev, 0xd06, 0x14, 0x0000, 0x2000);
 
-	phy_write(phydev, 0x1f, 0x0a43);
-	phy_write(phydev, 0x13, 0x81a2);
-	phy_set_bits(phydev, 0x14, BIT(8));
-	phy_write(phydev, 0x1f, 0x0000);
+	r8168g_phy_param(phydev, 0x81a2, 0x0000, 0x0100);
 
 	phy_modify_paged(phydev, 0xb54, 0x16, 0xff00, 0xdb00);
 	phy_modify_paged(phydev, 0xa45, 0x12, 0x0001, 0x0000);
-- 
2.24.0


