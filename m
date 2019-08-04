Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8038809DF
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 09:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfHDHwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 03:52:55 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38245 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfHDHwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 03:52:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so81296323wrr.5
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 00:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=m8pP+OHQ/yE46E75zeEGRSlW4RjMN0eG2FyhWtPGlM0=;
        b=HFNmQqLZNDf+EXKdyCBm3l2vXH4o3WenUg2HUmunrl2oanRtEHSaAwPLJYglb86+jd
         UQs8jbAqdVQ5zlluihE9ooLnzaxIzbu24iWYDSBWDnSd0yqB5/a+OgHh9bJyP+1OUCP6
         QXC7vC2KMOXTr2fx+Lh+p5cLR/kMJbi8n2jmpSj+UHRsUIrEqB2GJe3w8MIF45VEmLec
         zw88+HJGnGEGRdC0zm2zMtIIe5vjsO468cKgarewI/VqGnj3S6xJP3Io8+ksPnv9pN8k
         2H5WUa4rHQrkwx4ja0+U3pR9nriZO0flJ6HwADUL1RI0KGlmEjsPdSjbaLGUSrU6zzBc
         clVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=m8pP+OHQ/yE46E75zeEGRSlW4RjMN0eG2FyhWtPGlM0=;
        b=XuR2hCM6VDiHGrcxaLefZ4onUKklfFvnzEtod/xFdB6oP2djGeDIOnzMG+dFmZgpJh
         yxL81v3zkbd1XWJNgJEzvw8g4OF+xcB1v4AKpc2YBBq//AGdC8c6H5Y4Nwz1j9Yh59UK
         LpYJeuHDu/Dp26WX8sy0wNdiiilKDpcjczeV95vuzsNmU/fqwZQJU7+5vESLCcZFwi3B
         /RE71CTAHc4lNkyh7WXZ3QYf7oOGKq3wAtXlwGBjYzyuz+PiA6LvYiJaNj46yLSI2CMo
         y65Xl+WiLREBgmHozsCfsJ2pyReSMvZIQGQcPqE23KcUmdN3cAhesRY47Zq2jMRyg+YY
         j2kQ==
X-Gm-Message-State: APjAAAW7oTKFjmeDmsn8oaB9pE93+qb/BkhOi/rQ77q3PQRVIhbiFEmY
        W6qm99eVHEMOR8n83oH+s8ZIjmaaO/M=
X-Google-Smtp-Source: APXvYqw3nWENKeD6JZNHu9OJRQA4DW496YKTg1lt747JBivUpBNnVIg4mUrQHq42z3IqkwY2TVrI5Q==
X-Received: by 2002:adf:f08f:: with SMTP id n15mr997968wro.213.1564905172060;
        Sun, 04 Aug 2019 00:52:52 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:9900:d80f:58c5:990d:c59b? (p200300EA8F289900D80F58C5990DC59B.dip0.t-ipconnect.de. [2003:ea:8f28:9900:d80f:58c5:990d:c59b])
        by smtp.googlemail.com with ESMTPSA id j10sm148650719wrd.26.2019.08.04.00.52.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 00:52:51 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: add helper r8168_mac_ocp_modify
Message-ID: <dc905b86-2852-86c2-be14-22164bd4a06d@gmail.com>
Date:   Sun, 4 Aug 2019 09:47:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper for MAC OCP read-modify-write operations.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 65 +++++++----------------
 1 file changed, 19 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e38bc01eb..039a967c7 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -850,6 +850,14 @@ static u16 r8168_mac_ocp_read(struct rtl8169_private *tp, u32 reg)
 	return RTL_R32(tp, OCPDR);
 }
 
+static void r8168_mac_ocp_modify(struct rtl8169_private *tp, u32 reg, u16 mask,
+				 u16 set)
+{
+	u16 data = r8168_mac_ocp_read(tp, reg);
+
+	r8168_mac_ocp_write(tp, reg, (data & ~mask) | set);
+}
+
 #define OCP_STD_PHY_BASE	0xa400
 
 static void r8168g_mdio_write(struct rtl8169_private *tp, int reg, int value)
@@ -4809,8 +4817,6 @@ static void rtl_hw_start_8411_2(struct rtl8169_private *tp)
 
 static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 {
-	int rg_saw_cnt;
-	u32 data;
 	static const struct ephy_info e_info_8168h_1[] = {
 		{ 0x1e, 0x0800,	0x0001 },
 		{ 0x1d, 0x0000,	0x0800 },
@@ -4819,6 +4825,7 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 		{ 0x04, 0xffff,	0x154a },
 		{ 0x01, 0xffff,	0x068b }
 	};
+	int rg_saw_cnt;
 
 	/* disable aspm and clock request before access ephy */
 	rtl_hw_aspm_clkreq_enable(tp, false);
@@ -4863,31 +4870,13 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 
 		sw_cnt_1ms_ini = 16000000/rg_saw_cnt;
 		sw_cnt_1ms_ini &= 0x0fff;
-		data = r8168_mac_ocp_read(tp, 0xd412);
-		data &= ~0x0fff;
-		data |= sw_cnt_1ms_ini;
-		r8168_mac_ocp_write(tp, 0xd412, data);
+		r8168_mac_ocp_modify(tp, 0xd412, 0x0fff, sw_cnt_1ms_ini);
 	}
 
-	data = r8168_mac_ocp_read(tp, 0xe056);
-	data &= ~0xf0;
-	data |= 0x70;
-	r8168_mac_ocp_write(tp, 0xe056, data);
-
-	data = r8168_mac_ocp_read(tp, 0xe052);
-	data &= ~0x6000;
-	data |= 0x8008;
-	r8168_mac_ocp_write(tp, 0xe052, data);
-
-	data = r8168_mac_ocp_read(tp, 0xe0d6);
-	data &= ~0x01ff;
-	data |= 0x017f;
-	r8168_mac_ocp_write(tp, 0xe0d6, data);
-
-	data = r8168_mac_ocp_read(tp, 0xd420);
-	data &= ~0x0fff;
-	data |= 0x047f;
-	r8168_mac_ocp_write(tp, 0xd420, data);
+	r8168_mac_ocp_modify(tp, 0xe056, 0x00f0, 0x0070);
+	r8168_mac_ocp_modify(tp, 0xe052, 0x6000, 0x8008);
+	r8168_mac_ocp_modify(tp, 0xe0d6, 0x01ff, 0x017f);
+	r8168_mac_ocp_modify(tp, 0xd420, 0x0fff, 0x047f);
 
 	r8168_mac_ocp_write(tp, 0xe63e, 0x0001);
 	r8168_mac_ocp_write(tp, 0xe63e, 0x0000);
@@ -4969,7 +4958,6 @@ static void rtl_hw_start_8168ep_2(struct rtl8169_private *tp)
 
 static void rtl_hw_start_8168ep_3(struct rtl8169_private *tp)
 {
-	u32 data;
 	static const struct ephy_info e_info_8168ep_3[] = {
 		{ 0x00, 0xffff,	0x10a3 },
 		{ 0x19, 0xffff,	0x7c00 },
@@ -4986,18 +4974,9 @@ static void rtl_hw_start_8168ep_3(struct rtl8169_private *tp)
 	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) & ~PFM_EN);
 	RTL_W8(tp, MISC_1, RTL_R8(tp, MISC_1) & ~PFM_D3COLD_EN);
 
-	data = r8168_mac_ocp_read(tp, 0xd3e2);
-	data &= 0xf000;
-	data |= 0x0271;
-	r8168_mac_ocp_write(tp, 0xd3e2, data);
-
-	data = r8168_mac_ocp_read(tp, 0xd3e4);
-	data &= 0xff00;
-	r8168_mac_ocp_write(tp, 0xd3e4, data);
-
-	data = r8168_mac_ocp_read(tp, 0xe860);
-	data |= 0x0080;
-	r8168_mac_ocp_write(tp, 0xe860, data);
+	r8168_mac_ocp_modify(tp, 0xd3e2, 0x0fff, 0x0271);
+	r8168_mac_ocp_modify(tp, 0xd3e4, 0x00ff, 0x0000);
+	r8168_mac_ocp_modify(tp, 0xe860, 0x0000, 0x0080);
 
 	rtl_hw_aspm_clkreq_enable(tp, true);
 }
@@ -6659,8 +6638,6 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 
 static void rtl_hw_init_8168g(struct rtl8169_private *tp)
 {
-	u32 data;
-
 	tp->ocp_base = OCP_STD_PHY_BASE;
 
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | RXDV_GATED_EN);
@@ -6675,16 +6652,12 @@ static void rtl_hw_init_8168g(struct rtl8169_private *tp)
 	msleep(1);
 	RTL_W8(tp, MCU, RTL_R8(tp, MCU) & ~NOW_IS_OOB);
 
-	data = r8168_mac_ocp_read(tp, 0xe8de);
-	data &= ~(1 << 14);
-	r8168_mac_ocp_write(tp, 0xe8de, data);
+	r8168_mac_ocp_modify(tp, 0xe8de, BIT(14), 0);
 
 	if (!rtl_udelay_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42))
 		return;
 
-	data = r8168_mac_ocp_read(tp, 0xe8de);
-	data |= (1 << 15);
-	r8168_mac_ocp_write(tp, 0xe8de, data);
+	r8168_mac_ocp_modify(tp, 0xe8de, 0, BIT(15));
 
 	rtl_udelay_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42);
 }
-- 
2.22.0

