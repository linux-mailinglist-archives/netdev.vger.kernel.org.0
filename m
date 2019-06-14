Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 790B14545E
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 07:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfFNFzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 01:55:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41909 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfFNFzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 01:55:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so1112848wrm.8
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 22:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g9EGG66pvxXW6mzL7zbyXm5OxkdYUcNvKZgvgnHUWWM=;
        b=IQnmzfys0r5MPZhm1njhrGeu3eZp4csekN2WObBxllea7ZqpmQ82A19Sr6zij/IJrP
         VbrwwTg4RcPyf6mN4fLnjC+EkUdSf+//5GdkdKteexdTSxJNsZj95ZcaGvOpM+JP3k0H
         sk8BwffsUcGjTtXWGlQI6FY1hpAygYO4nH8KFl/WJyeajwRZAlD9T0S5oY1wVy3CYIDc
         +XdqLunBy2pGTQLTkghNcgtde9F+sc+M+/wXoVecVpK8HJj06csd1Pyv0fEhEcLTJd1X
         xJFojXaivTd/+psrQqu4sUYMYXJ4SrWE3MrumrEw4rWrujcTS3L63qVz5sVwAgt3PPSm
         Y0og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g9EGG66pvxXW6mzL7zbyXm5OxkdYUcNvKZgvgnHUWWM=;
        b=sMIn5sP5wfwslLQ91lHtdH9DQAgJ9V+GSZeALWCdpFB+qh/I5kAm++qp7BDXKrnNbL
         FVwqxplDe/U1MQ581AcTBCzrV/KFSPRPBbeRG8rjeE2Ds7pyv+ASJUHuiY7qHgC/xfOV
         miuDoJyqHGCOd9zxoxU8hESfnmtTLKXlbsT2o3d1IcheL0Shx2EHxJ2PzTKyRAHJi589
         J6xZFoxRxEE/xxA3clIG4YyMt4D3gaGNPfEkJ4//meVEF9qDR0vHousCaQga8r4D96Nu
         0yor//tTw2EEaOUzVi5GS4LtHS68Mp5J/V2HqPstUaBri9q98UePQRkLAOcl1lNmK595
         ZWtw==
X-Gm-Message-State: APjAAAV5Yj/J/80bQkyZO7sE0Zv78JfkPiVb4TeUrLfebS9RZesSawmL
        Q3F4LAqVoOofRfUm0cCIVIhiQ3yX
X-Google-Smtp-Source: APXvYqxotB/QONhjZo1KvK7il1xEaW9Pb0B8f90TK1ONhpwJmSjM+RFPJBXXCNfIB2XZbu/Q0N6YSg==
X-Received: by 2002:a5d:62c9:: with SMTP id o9mr29500346wrv.186.1560491738054;
        Thu, 13 Jun 2019 22:55:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:9178:4599:8cd6:9f81? (p200300EA8BF3BD00917845998CD69F81.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:9178:4599:8cd6:9f81])
        by smtp.googlemail.com with ESMTPSA id p3sm2781493wrd.47.2019.06.13.22.55.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 22:55:37 -0700 (PDT)
Subject: [PATCH net-next 2/2] r8169: use helper rtl_is_8168evl_up for setting
 register MaxTxPacketSize
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0c355e89-8e6b-7ea9-4971-21980f9e64da@gmail.com>
Message-ID: <7ebdce28-2599-935f-f334-8b882f814d8a@gmail.com>
Date:   Fri, 14 Jun 2019 07:55:21 +0200
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

>From RTL8168e-vl the value in register MaxTxPacketSize is interpreted
differently, therefore use new helper rtl_is_8168evl_up to set this
register.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 24 ++++-------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9f851ed99..ef900ebf9 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4331,8 +4331,6 @@ static void rtl_hw_start_8168bef(struct rtl8169_private *tp)
 {
 	rtl_hw_start_8168bb(tp);
 
-	RTL_W8(tp, MaxTxPacketSize, TxPacketMax);
-
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) & ~(1 << 0));
 }
 
@@ -4384,8 +4382,6 @@ static void rtl_hw_start_8168cp_3(struct rtl8169_private *tp)
 	/* Magic. */
 	RTL_W8(tp, DBG_REG, 0x20);
 
-	RTL_W8(tp, MaxTxPacketSize, TxPacketMax);
-
 	if (tp->dev->mtu <= ETH_DATA_LEN)
 		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 }
@@ -4439,8 +4435,6 @@ static void rtl_hw_start_8168d(struct rtl8169_private *tp)
 
 	rtl_disable_clock_request(tp);
 
-	RTL_W8(tp, MaxTxPacketSize, TxPacketMax);
-
 	if (tp->dev->mtu <= ETH_DATA_LEN)
 		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 }
@@ -4452,8 +4446,6 @@ static void rtl_hw_start_8168dp(struct rtl8169_private *tp)
 	if (tp->dev->mtu <= ETH_DATA_LEN)
 		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 
-	RTL_W8(tp, MaxTxPacketSize, TxPacketMax);
-
 	rtl_disable_clock_request(tp);
 }
 
@@ -4469,8 +4461,6 @@ static void rtl_hw_start_8168d_4(struct rtl8169_private *tp)
 
 	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 
-	RTL_W8(tp, MaxTxPacketSize, TxPacketMax);
-
 	rtl_ephy_init(tp, e_info_8168d_4);
 
 	rtl_enable_clock_request(tp);
@@ -4501,8 +4491,6 @@ static void rtl_hw_start_8168e_1(struct rtl8169_private *tp)
 	if (tp->dev->mtu <= ETH_DATA_LEN)
 		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 
-	RTL_W8(tp, MaxTxPacketSize, TxPacketMax);
-
 	rtl_disable_clock_request(tp);
 
 	/* Reset tx FIFO pointer */
@@ -4534,8 +4522,6 @@ static void rtl_hw_start_8168e_2(struct rtl8169_private *tp)
 	rtl_eri_set_bits(tp, 0x1b0, ERIAR_MASK_0001, BIT(4));
 	rtl_w0w1_eri(tp, 0x0d4, ERIAR_MASK_0011, 0x0c00, 0xff00);
 
-	RTL_W8(tp, MaxTxPacketSize, EarlySize);
-
 	rtl_disable_clock_request(tp);
 
 	RTL_W8(tp, MCU, RTL_R8(tp, MCU) & ~NOW_IS_OOB);
@@ -4564,8 +4550,6 @@ static void rtl_hw_start_8168f(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0xcc, ERIAR_MASK_1111, 0x00000050);
 	rtl_eri_write(tp, 0xd0, ERIAR_MASK_1111, 0x00000060);
 
-	RTL_W8(tp, MaxTxPacketSize, EarlySize);
-
 	rtl_disable_clock_request(tp);
 
 	RTL_W8(tp, MCU, RTL_R8(tp, MCU) & ~NOW_IS_OOB);
@@ -4622,7 +4606,6 @@ static void rtl_hw_start_8168g(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0x2f8, ERIAR_MASK_0011, 0x1d8f);
 
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
-	RTL_W8(tp, MaxTxPacketSize, EarlySize);
 
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
@@ -4720,7 +4703,6 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87);
 
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
-	RTL_W8(tp, MaxTxPacketSize, EarlySize);
 
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
@@ -4796,7 +4778,6 @@ static void rtl_hw_start_8168ep(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87);
 
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
-	RTL_W8(tp, MaxTxPacketSize, EarlySize);
 
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
@@ -5068,7 +5049,10 @@ static void rtl_hw_start_8168(struct rtl8169_private *tp)
 		pcie_capability_set_word(tp->pci_dev, PCI_EXP_DEVCTL,
 					 PCI_EXP_DEVCTL_NOSNOOP_EN);
 
-	RTL_W8(tp, MaxTxPacketSize, TxPacketMax);
+	if (rtl_is_8168evl_up(tp))
+		RTL_W8(tp, MaxTxPacketSize, EarlySize);
+	else
+		RTL_W8(tp, MaxTxPacketSize, TxPacketMax);
 
 	rtl_hw_config(tp);
 }
-- 
2.22.0


