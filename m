Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69C7F4545D
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 07:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfFNFzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 01:55:39 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33955 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfFNFzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 01:55:39 -0400
Received: by mail-wm1-f68.google.com with SMTP id w9so8086094wmd.1
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 22:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pAJ7oWohp8W4FWHGTQ8Trx7E0W61Srss4A+NiBOsTzQ=;
        b=jU4OVU/IJAMNvul7gLm1AlFY4+Sfb3R0WJX/H6h0WU3tWcZtfuIzUmtbgStuZH/l4x
         9ISQdQzqFq37jXqTT7WJpKAplWYiBmrGOUdmtm+xKXupRXJYGfAGmUFOFOqSKNe0KCCi
         6QdQaq0uajNkofKkVvyRqLR/grPWYGveM4KDbM/ScaZ1ir6P+OhPlQ5X5oWPCeRmfDos
         nVBIuUVV7Aza2AkKRRjFAWJ99V0oSBQJ6T4VaOpt5iuYIze8IGwTKagh51WuDZaXHDQy
         /o9f25xGJWNu+rJ6r9Ef1fFoSkuYiwWgLVCb+C1IFhaS0pIqIaSm1Ot+nCWnEkztrW2Q
         ahDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pAJ7oWohp8W4FWHGTQ8Trx7E0W61Srss4A+NiBOsTzQ=;
        b=L1PrjST3Hw/8f6ZVVYH3MkIfEzCtDfj3oO8529clJQspPJNzqnMOzxnGM+5TD45YrM
         cIY4wk06alsyoV+es6YcLSlyGR131zC+8kNI6Bau2t9/oS7N+LCOqFEGL9zNRm7Yfqtl
         sPN5Qq3/DnHcdvrsLwaGpT4YxJhUQDotHo5QVQc3zqYbUpJ6H2XXVEabJrJb+fChf/z0
         ZGxUHnqwzXfYR29hK2CzyZSzfYtx+kgsDRi2xxAbHP47KsVkE5KDFdeBulOHH/Vu/KVt
         FCgUno+y+MHEZWbOmX5Lo3ztYA2fhBldon7ZF/Kn8loE0xYrLezQdhahoyQ9tdXCGOxY
         4+3g==
X-Gm-Message-State: APjAAAWGzqT3ZsBvUkBw5i3PLnJmBVb3mVM+zwkjCYwjyOlRudTbcfrj
        zx3zeUhX4D+sJpRKca2wj5alvD0z
X-Google-Smtp-Source: APXvYqy7Rsi4m2XW4XwuvpJAGyOpb+wnEsxjPeII6vqHOKwSnaBWu1M6YwhmB/t4Rs1ziyXr/bcPyw==
X-Received: by 2002:a1c:c747:: with SMTP id x68mr6385119wmf.138.1560491736803;
        Thu, 13 Jun 2019 22:55:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:9178:4599:8cd6:9f81? (p200300EA8BF3BD00917845998CD69F81.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:9178:4599:8cd6:9f81])
        by smtp.googlemail.com with ESMTPSA id h90sm5264532wrh.15.2019.06.13.22.55.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 22:55:36 -0700 (PDT)
Subject: [PATCH net-next 1/2] r8169: add helper rtl_is_8168evl_up
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0c355e89-8e6b-7ea9-4971-21980f9e64da@gmail.com>
Message-ID: <f7a35192-b456-eb4d-9c8d-498d3b76d21f@gmail.com>
Date:   Fri, 14 Jun 2019 07:54:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <0c355e89-8e6b-7ea9-4971-21980f9e64da@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper rtl_is_8168evl_up to make the code better readable and to
simplify it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 29 ++++++++++-------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8519f88ac..9f851ed99 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -724,6 +724,12 @@ static void rtl_tx_performance_tweak(struct rtl8169_private *tp, u16 force)
 					   PCI_EXP_DEVCTL_READRQ, force);
 }
 
+static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
+{
+	return tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
+	       tp->mac_version != RTL_GIGA_MAC_VER_39;
+}
+
 struct rtl_cond {
 	bool (*check)(struct rtl8169_private *);
 	const char *msg;
@@ -1389,9 +1395,7 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 
 	rtl_unlock_config_regs(tp);
 
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_38:
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
+	if (rtl_is_8168evl_up(tp)) {
 		tmp = ARRAY_SIZE(cfg) - 1;
 		if (wolopts & WAKE_MAGIC)
 			rtl_eri_set_bits(tp, 0x0dc, ERIAR_MASK_0100,
@@ -1399,10 +1403,8 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 		else
 			rtl_eri_clear_bits(tp, 0x0dc, ERIAR_MASK_0100,
 					   MagicPacket_v2);
-		break;
-	default:
+	} else {
 		tmp = ARRAY_SIZE(cfg);
-		break;
 	}
 
 	for (i = 0; i < tmp; i++) {
@@ -4101,8 +4103,7 @@ static void rtl_set_tx_config_registers(struct rtl8169_private *tp)
 	u32 val = TX_DMA_BURST << TxDMAShift |
 		  InterFrameGap << TxInterFrameGapShift;
 
-	if (tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
-	    tp->mac_version != RTL_GIGA_MAC_VER_39)
+	if (rtl_is_8168evl_up(tp))
 		val |= TXCFG_AUTO_FIFO;
 
 	RTL_W32(tp, TxConfig, val);
@@ -6483,13 +6484,10 @@ static int rtl_alloc_irq(struct rtl8169_private *tp)
 static void rtl_read_mac_address(struct rtl8169_private *tp,
 				 u8 mac_addr[ETH_ALEN])
 {
-	u32 value;
-
 	/* Get MAC address */
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_35 ... RTL_GIGA_MAC_VER_38:
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
-		value = rtl_eri_read(tp, 0xe0);
+	if (rtl_is_8168evl_up(tp) && tp->mac_version != RTL_GIGA_MAC_VER_34) {
+		u32 value = rtl_eri_read(tp, 0xe0);
+
 		mac_addr[0] = (value >>  0) & 0xff;
 		mac_addr[1] = (value >>  8) & 0xff;
 		mac_addr[2] = (value >> 16) & 0xff;
@@ -6498,9 +6496,6 @@ static void rtl_read_mac_address(struct rtl8169_private *tp,
 		value = rtl_eri_read(tp, 0xe4);
 		mac_addr[4] = (value >>  0) & 0xff;
 		mac_addr[5] = (value >>  8) & 0xff;
-		break;
-	default:
-		break;
 	}
 }
 
-- 
2.22.0


