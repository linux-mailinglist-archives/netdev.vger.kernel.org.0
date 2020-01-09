Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C7D136134
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731059AbgAITgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:36:01 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39673 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730685AbgAITfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:35:47 -0500
Received: by mail-wm1-f68.google.com with SMTP id 20so4124395wmj.4
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SvKRmU7/Fthm2pJhN2Mi/fuHuJ0lgz5PHjmW/oZMxFg=;
        b=vLO1QCczDNuI7w5q2L07+laVB38HcjcjLCSZ9TLe/bsMrLTFTUoBWJlSxLrrqx1uQ3
         NC2mXNkjtAsLAfgOA3huoRqgxz67MCG4LTnJF1NnrSQmGtQ67viy3PjKIqcBGZ56cH2L
         clVL/ARabiQSMaB7s8HyTCGmpp7pfvKmXZCLqhZCiPNON79IALl9tQ9HVi2qN5K9xas6
         MNODCNDDdx+J0gXLrEwDkw6A/EHsJlBAHgJFbNnTjhl1u2C5tZ2s92Md+Md7kBJDzENG
         DGG+REV1HI5wpHPbrukzq7ELWRg+qy4RWLEuTt/jUTrLuvo6jirQOguM57qREu5qdgfn
         p0bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SvKRmU7/Fthm2pJhN2Mi/fuHuJ0lgz5PHjmW/oZMxFg=;
        b=emTJycZZDBOvUgpGKWZaGnyGc3cQMMpisfkVYeeQ0L5a9lfKZ8nI0/HDbeMRp19vyz
         3mfCh6y00ozf3tj5sC04WRCivXZNmT3T/2qAXbO9wx33iswMdyJsJXdjXmXF6P4BVG0x
         kL4VvIDxIFYBTRkMoY4/9IsuBdAtsQCZkwhlGrrJbo4Eu8fsHeyOLY80GgZmIQUUGfgN
         VL0UB3h8zKmR17025kbbpjmWYWU9MGCo75GbL98JE2KFhfX/lkHWhl7woYkTNUQ9x8fT
         QSKSMWXAEwrrXKuVLofA6MF8wIOcAs2/ox8lyAvYePgaYF5NyiMoFffau+0y8Vqql8fS
         aVJA==
X-Gm-Message-State: APjAAAVnZOx7Gtb9DPqeQBLNAK2/OO+MBd+okdAPLVoqwOdUizpkt/iP
        xOvX8gw/SbL+oZBicGaOhKsowyaS
X-Google-Smtp-Source: APXvYqyuWDGrIcG4dtgpt0ltqVtYDplc+oHwX4FmEl9WKEh0qKvL8gWniyRhcsrNYhTGkC9GGfiNXQ==
X-Received: by 2002:a05:600c:108a:: with SMTP id e10mr6324191wmd.38.1578598544850;
        Thu, 09 Jan 2020 11:35:44 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id b137sm4122966wme.26.2020.01.09.11.35.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 11:35:44 -0800 (PST)
Subject: [PATCH net-next 10/15] r8169: replace rtl_w0w1_phy
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Message-ID: <5c5a7c1d-346e-52dd-65c7-a0c5b2544119@gmail.com>
Date:   Thu, 9 Jan 2020 20:31:10 +0100
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

Replace rtl_w0w1_phy with phylib functions.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 34 ++++++++---------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9765f49e7..457c8cdec 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1081,14 +1081,6 @@ static int rtl_readphy(struct rtl8169_private *tp, int location)
 	}
 }
 
-static void rtl_w0w1_phy(struct rtl8169_private *tp, int reg_addr, int p, int m)
-{
-	int val;
-
-	val = rtl_readphy(tp, reg_addr);
-	rtl_writephy(tp, reg_addr, (val & ~m) | p);
-}
-
 static void r8168d_modify_extpage(struct phy_device *phydev, int extpage,
 				  int reg, u16 mask, u16 val)
 {
@@ -2702,8 +2694,8 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp,
 	 * Fine Tune Switching regulator parameter
 	 */
 	rtl_writephy(tp, 0x1f, 0x0002);
-	rtl_w0w1_phy(tp, 0x0b, 0x0010, 0x00ef);
-	rtl_w0w1_phy(tp, 0x0c, 0xa200, 0x5d00);
+	phy_modify(phydev, 0x0b, 0x00ef, 0x0010);
+	phy_modify(phydev, 0x0c, 0x5d00, 0xa200);
 
 	if (rtl8168d_efuse_read(tp, 0x01) == 0xb1) {
 		int val;
@@ -2737,8 +2729,8 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp,
 
 	/* Fine tune PLL performance */
 	rtl_writephy(tp, 0x1f, 0x0002);
-	rtl_w0w1_phy(tp, 0x02, 0x0100, 0x0600);
-	rtl_w0w1_phy(tp, 0x03, 0x0000, 0xe000);
+	phy_modify(phydev, 0x02, 0x0600, 0x0100);
+	phy_clear_bits(phydev, 0x03, 0xe000);
 	rtl_writephy(tp, 0x1f, 0x0000);
 
 	rtl8168d_apply_firmware_cond(tp, 0xbf00);
@@ -2775,8 +2767,8 @@ static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp,
 
 	/* Fine tune PLL performance */
 	rtl_writephy(tp, 0x1f, 0x0002);
-	rtl_w0w1_phy(tp, 0x02, 0x0100, 0x0600);
-	rtl_w0w1_phy(tp, 0x03, 0x0000, 0xe000);
+	phy_modify(phydev, 0x02, 0x0600, 0x0100);
+	phy_clear_bits(phydev, 0x03, 0xe000);
 	rtl_writephy(tp, 0x1f, 0x0000);
 
 	/* Switching regulator Slew rate */
@@ -2929,7 +2921,7 @@ static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp,
 	/* For 4-corner performance improve */
 	rtl_writephy(tp, 0x1f, 0x0005);
 	rtl_writephy(tp, 0x05, 0x8b80);
-	rtl_w0w1_phy(tp, 0x17, 0x0006, 0x0000);
+	phy_set_bits(phydev, 0x17, 0x0006);
 	rtl_writephy(tp, 0x1f, 0x0000);
 
 	/* PHY auto speed down */
@@ -2946,12 +2938,10 @@ static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp,
 
 	/* Green feature */
 	rtl_writephy(tp, 0x1f, 0x0003);
-	rtl_w0w1_phy(tp, 0x19, 0x0001, 0x0000);
-	rtl_w0w1_phy(tp, 0x10, 0x0400, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0005);
-	rtl_w0w1_phy(tp, 0x01, 0x0100, 0x0000);
+	phy_set_bits(phydev, 0x19, BIT(0));
+	phy_set_bits(phydev, 0x10, BIT(10));
 	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_modify_paged(phydev, 0x0005, 0x01, 0, BIT(8));
 }
 
 static void rtl8168f_hw_phy_config(struct rtl8169_private *tp,
@@ -3047,8 +3037,8 @@ static void rtl8411_hw_phy_config(struct rtl8169_private *tp,
 
 	/* Green feature */
 	rtl_writephy(tp, 0x1f, 0x0003);
-	rtl_w0w1_phy(tp, 0x19, 0x0000, 0x0001);
-	rtl_w0w1_phy(tp, 0x10, 0x0000, 0x0400);
+	phy_clear_bits(phydev, 0x19, BIT(0));
+	phy_clear_bits(phydev, 0x10, BIT(10));
 	rtl_writephy(tp, 0x1f, 0x0000);
 }
 
-- 
2.24.1


