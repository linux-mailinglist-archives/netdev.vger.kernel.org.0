Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4460C15FEB8
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 14:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgBONyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 08:54:40 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33009 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgBONyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 08:54:39 -0500
Received: by mail-wr1-f65.google.com with SMTP id u6so14375294wrt.0
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 05:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pUGf2Ho0bCBVsbAF5uHCl31N3nVW81QsrAYQPPOeOjQ=;
        b=meBnS20y6ev9dtxRDOAbAZRlHncAPBK/OS4CrSv66Vvj0Q35MTB+OSkhRMPiSWOhLZ
         C2Y8xc7YSL1n+Mou0MnQZ2h6sp8467OErHPtiPTPhMkv6mNbMD9euc6g1HOoi40sPZ81
         OrNtAUE1uWyGxKMtnP5rvCqkaFy/lZusNGR7lfdo7VvDbEQTi5bzuhCfVahSbRzLiIE/
         nJByF1x1CzmzyJqlCDKeaub8F23Fn3ZYR2KsC+6O0WsexEe7CUDC6ZUhlsZaEpkb61K3
         QLpfnFUwuCqfZfJGmK2ggwYLM7Kz06CY7M8xaIDrOpBaLbPVbQIaY0ICyZHhZB1ziGGL
         DCzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pUGf2Ho0bCBVsbAF5uHCl31N3nVW81QsrAYQPPOeOjQ=;
        b=J25e3c5t2uIZ3E1+hD0vMIkHF2JSLZdpvztMsXwkq0ld6wZYDmAn7pled7ME0XExf5
         Ld320hWhyiYrRZGgU01F9+2Iec3zivXSMiSisZFE9wPeKukA0JFvF96WSA5HZBP0e2O3
         xxmp/gV9Sp7trM8a4poBx8MUtoF3q1N1ZHjmbyjOu7WouSpAKL9X7ODtX5bwxz8Eddfm
         AQmE76e9FNZO3425d6merKFpfdf8MQeLTsm/ml2x/PW6QKAAWuYLtOLNDs7PKiB853SI
         zr0ZV5pXN2XSs/D99L34tkagxXsTDCWMJhWcTwAlIxyCLGzDkm//O3UUculojsuvWCN4
         Xxvw==
X-Gm-Message-State: APjAAAXmUyPU2OFwxgnZ2rqQ4dFqTD9HUyFD/0nO7iY9FPw51LJ/AuK3
        K6ZrfxfLiPBRR/cPt/aoHqRH0kE7
X-Google-Smtp-Source: APXvYqz/AfEmwd8VyweaHENebZ33MCTQXxhJo40Y23n+rspD/4auigVATpCmYRA3qNmp8eFOf5qXFw==
X-Received: by 2002:adf:cd04:: with SMTP id w4mr10860664wrm.219.1581774878022;
        Sat, 15 Feb 2020 05:54:38 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:1ddf:2e8f:533:981f? (p200300EA8F2960001DDF2E8F0533981F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1ddf:2e8f:533:981f])
        by smtp.googlemail.com with ESMTPSA id x132sm21294006wmg.0.2020.02.15.05.54.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 05:54:37 -0800 (PST)
Subject: [PATCH net-next 4/7] r8169: add helper rtl_pci_commit
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bd37db86-a725-57b3-4618-527597752798@gmail.com>
Message-ID: <7fc7a475-3b03-b165-96df-3666038ccbca@gmail.com>
Date:   Sat, 15 Feb 2020 14:50:29 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <bd37db86-a725-57b3-4618-527597752798@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In few places we do a PCI commit by reading an arbitrary chip register.
It's not always obvious that the read is meant to be a PCI commit,
therefore add a helper for it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 25 ++++++++++++++---------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index bc92e8c55..46e8e3dfa 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -689,6 +689,12 @@ static void rtl_unlock_config_regs(struct rtl8169_private *tp)
 	RTL_W8(tp, Cfg9346, Cfg9346_Unlock);
 }
 
+static void rtl_pci_commit(struct rtl8169_private *tp)
+{
+	/* Read an arbitrary register to commit a preceding PCI write */
+	RTL_R8(tp, ChipCmd);
+}
+
 static bool rtl_is_8125(struct rtl8169_private *tp)
 {
 	return tp->mac_version >= RTL_GIGA_MAC_VER_60;
@@ -1319,8 +1325,7 @@ static void rtl8169_irq_mask_and_ack(struct rtl8169_private *tp)
 {
 	rtl_irq_disable(tp);
 	rtl_ack_events(tp, 0xffffffff);
-	/* PCI commit */
-	RTL_R8(tp, ChipCmd);
+	rtl_pci_commit(tp);
 }
 
 static void rtl_link_chg_patch(struct rtl8169_private *tp)
@@ -1532,7 +1537,7 @@ static int rtl8169_set_features(struct net_device *dev,
 	}
 
 	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
-	RTL_R16(tp, CPlusCmd);
+	rtl_pci_commit(tp);
 
 	rtl_unlock_work(tp);
 
@@ -1618,7 +1623,7 @@ static bool rtl8169_do_counters(struct rtl8169_private *tp, u32 counter_cmd)
 	u32 cmd;
 
 	RTL_W32(tp, CounterAddrHigh, (u64)paddr >> 32);
-	RTL_R32(tp, CounterAddrHigh);
+	rtl_pci_commit(tp);
 	cmd = (u64)paddr & DMA_BIT_MASK(32);
 	RTL_W32(tp, CounterAddrLow, cmd);
 	RTL_W32(tp, CounterAddrLow, cmd | counter_cmd);
@@ -1942,7 +1947,7 @@ static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 
 	tp->cp_cmd = (tp->cp_cmd & ~INTT_MASK) | cp01;
 	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
-	RTL_R16(tp, CPlusCmd);
+	rtl_pci_commit(tp);
 
 	rtl_unlock_work(tp);
 
@@ -2260,10 +2265,10 @@ static void rtl_rar_set(struct rtl8169_private *tp, u8 *addr)
 	rtl_unlock_config_regs(tp);
 
 	RTL_W32(tp, MAC4, addr[4] | addr[5] << 8);
-	RTL_R32(tp, MAC4);
+	rtl_pci_commit(tp);
 
 	RTL_W32(tp, MAC0, addr[0] | addr[1] << 8 | addr[2] << 16 | addr[3] << 24);
-	RTL_R32(tp, MAC0);
+	rtl_pci_commit(tp);
 
 	if (tp->mac_version == RTL_GIGA_MAC_VER_34)
 		rtl_rar_exgmac_set(tp, addr);
@@ -3873,7 +3878,8 @@ static void rtl_hw_start(struct  rtl8169_private *tp)
 	rtl_jumbo_config(tp, tp->dev->mtu);
 
 	/* Initially a 10 us delay. Turned it into a PCI commit. - FR */
-	RTL_R16(tp, CPlusCmd);
+	rtl_pci_commit(tp);
+
 	RTL_W8(tp, ChipCmd, CmdTxEnb | CmdRxEnb);
 	rtl_init_rxcfg(tp);
 	rtl_set_tx_config_registers(tp);
@@ -5091,8 +5097,7 @@ static void rtl_wol_shutdown_quirk(struct rtl8169_private *tp)
 		pci_clear_master(tp->pci_dev);
 
 		RTL_W8(tp, ChipCmd, CmdRxEnb);
-		/* PCI commit */
-		RTL_R8(tp, ChipCmd);
+		rtl_pci_commit(tp);
 		break;
 	default:
 		break;
-- 
2.25.0


