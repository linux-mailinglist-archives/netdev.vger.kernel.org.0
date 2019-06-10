Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE7E3B969
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbfFJQ2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:28:16 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44208 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390342AbfFJQZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:25:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id b17so9816609wrq.11
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 09:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EwoaQDH1xKPizgcukJ5DuiiAji9hIxbjc9ahIR7rJpw=;
        b=hyEVbNBWgillPlkPrpAgzrZngFzmdAMTelt20bH7wxpnxfjzojAPBREuYPWzDvaoSm
         QZjGx8hBPKzwitgJRZ97tard3JazGvYytuCg4GKq/0ZxzuyrhCsxaUVygsZYyf597eQH
         f9msFWNEdqkmLhgw4w2dkDlzvDcrmsifevo6FVUT27nyJFPTQcjFSeIDBvwhvZ5tXDuu
         LcT315O7b9Nf6REx5NmJPNcGSe1zLM9f+tVCknc3FGotmi3EDpqT3ygDuXSUWraqyLMy
         UWqa9ADfxyjKvd/RrcTc6VFntiIyNCmUMzV8gcbPybE8igsWBE/vK3utV0JMvueufubr
         JXtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EwoaQDH1xKPizgcukJ5DuiiAji9hIxbjc9ahIR7rJpw=;
        b=gnf2io6Jc3kem81rW1Bf7qiY1GJvX+bLIt7Ga3lsq3NdfsS/CiIKMS6F1w3UvM1tyg
         mWnZ3qO3gzRgi85vps+kKZLHd2J3yF3KCNBjU5Jk6GG8T8wUbpuk2Z7WknWrafjDiNQJ
         27d0EvgeqI7ogz+LQJ2kyf93afBN2cV6CtJSBtcZ/ZbdE0x3z3CXCvxXz4n8Vw45eLVT
         dV+QuclAGLtqNxdiWypFqtmG0exEceA5e4chUe761hVhEK0Q0pElCVeQx3937tIlR9fj
         gpMbIlnAd9OjrAZZhLLFheW/tMFVAhYymco74plfZIDtmiO8lU7/g53jWnQQl0Nlj2yx
         5HTg==
X-Gm-Message-State: APjAAAXzNoOyJBX0Z+fn09USx+4bQA6nuPp0puEP5un2ZOl1IkueiMWX
        LDM6lP3sz6wj2hJlprFAaok3y+oj
X-Google-Smtp-Source: APXvYqywAXLJnILs+eFw9b4jEzWL2Y5As7fHU9fkUIV4OGLZ7QLzp1DdWBUA2oyDTGWswskFdl6R6g==
X-Received: by 2002:adf:e344:: with SMTP id n4mr21600508wrj.192.1560183945780;
        Mon, 10 Jun 2019 09:25:45 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:8cc:c330:790b:34f7? (p200300EA8BF3BD0008CCC330790B34F7.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:8cc:c330:790b:34f7])
        by smtp.googlemail.com with ESMTPSA id b136sm13977161wme.30.2019.06.10.09.25.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 09:25:45 -0700 (PDT)
Subject: [PATCH next 3/5] r8169: remove callback hw_start from struct
 rtl_cfg_info
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1afce631-e188-58a9-ca72-3de2e5e73d09@gmail.com>
Message-ID: <a24517e6-2016-192f-f9a0-f9322997a325@gmail.com>
Date:   Mon, 10 Jun 2019 18:23:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1afce631-e188-58a9-ca72-3de2e5e73d09@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the latest changes we don't need separate functions
rtl_hw_start_8168 and rtl_hw_start_8101 any longer. This allows us to
simplify the code. For this change we need to move rtl_hw_start() and 
rtl_hw_start_8169(). rtl_hw_start_8169() is unchanged.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 117 ++++++++++------------
 1 file changed, 53 insertions(+), 64 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9a03b7a09..4a53276da 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -652,8 +652,6 @@ struct rtl8169_private {
 	const struct rtl_coalesce_info *coalesce_info;
 	struct clk *clk;
 
-	void (*hw_start)(struct rtl8169_private *tp);
-
 	struct {
 		DECLARE_BITMAP(flags, RTL_FLAG_MAX);
 		struct mutex mutex;
@@ -4206,56 +4204,6 @@ static void rtl_set_rx_mode(struct net_device *dev)
 	RTL_W32(tp, RxConfig, tmp);
 }
 
-static void rtl_hw_start(struct  rtl8169_private *tp)
-{
-	rtl_unlock_config_regs(tp);
-
-	tp->cp_cmd &= CPCMD_MASK;
-	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
-
-	tp->hw_start(tp);
-
-	rtl_set_rx_max_size(tp);
-	rtl_set_rx_tx_desc_registers(tp);
-	rtl_lock_config_regs(tp);
-
-	/* disable interrupt coalescing */
-	RTL_W16(tp, IntrMitigate, 0x0000);
-	/* Initially a 10 us delay. Turned it into a PCI commit. - FR */
-	RTL_R8(tp, IntrMask);
-	RTL_W8(tp, ChipCmd, CmdTxEnb | CmdRxEnb);
-	rtl_init_rxcfg(tp);
-	rtl_set_tx_config_registers(tp);
-
-	rtl_set_rx_mode(tp->dev);
-	/* no early-rx interrupts */
-	RTL_W16(tp, MultiIntr, RTL_R16(tp, MultiIntr) & 0xf000);
-	rtl_irq_enable(tp);
-}
-
-static void rtl_hw_start_8169(struct rtl8169_private *tp)
-{
-	if (tp->mac_version == RTL_GIGA_MAC_VER_05)
-		pci_write_config_byte(tp->pci_dev, PCI_CACHE_LINE_SIZE, 0x08);
-
-	RTL_W8(tp, EarlyTxThres, NoEarlyTx);
-
-	tp->cp_cmd |= PCIMulRW;
-
-	if (tp->mac_version == RTL_GIGA_MAC_VER_02 ||
-	    tp->mac_version == RTL_GIGA_MAC_VER_03) {
-		netif_dbg(tp, drv, tp->dev,
-			  "Set MAC Reg C+CR Offset 0xe0. Bit 3 and Bit 14 MUST be 1\n");
-		tp->cp_cmd |= (1 << 14);
-	}
-
-	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
-
-	rtl8169_set_magic_reg(tp, tp->mac_version);
-
-	RTL_W32(tp, RxMissed, 0);
-}
-
 DECLARE_RTL_COND(rtl_csiar_cond)
 {
 	return RTL_R32(tp, CSIAR) & CSIAR_FLAG;
@@ -5121,13 +5069,6 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 }
 
 static void rtl_hw_start_8168(struct rtl8169_private *tp)
-{
-	RTL_W8(tp, MaxTxPacketSize, TxPacketMax);
-
-	rtl_hw_config(tp);
-}
-
-static void rtl_hw_start_8101(struct rtl8169_private *tp)
 {
 	if (tp->mac_version == RTL_GIGA_MAC_VER_13 ||
 	    tp->mac_version == RTL_GIGA_MAC_VER_16)
@@ -5139,6 +5080,59 @@ static void rtl_hw_start_8101(struct rtl8169_private *tp)
 	rtl_hw_config(tp);
 }
 
+static void rtl_hw_start_8169(struct rtl8169_private *tp)
+{
+	if (tp->mac_version == RTL_GIGA_MAC_VER_05)
+		pci_write_config_byte(tp->pci_dev, PCI_CACHE_LINE_SIZE, 0x08);
+
+	RTL_W8(tp, EarlyTxThres, NoEarlyTx);
+
+	tp->cp_cmd |= PCIMulRW;
+
+	if (tp->mac_version == RTL_GIGA_MAC_VER_02 ||
+	    tp->mac_version == RTL_GIGA_MAC_VER_03) {
+		netif_dbg(tp, drv, tp->dev,
+			  "Set MAC Reg C+CR Offset 0xe0. Bit 3 and Bit 14 MUST be 1\n");
+		tp->cp_cmd |= (1 << 14);
+	}
+
+	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
+
+	rtl8169_set_magic_reg(tp, tp->mac_version);
+
+	RTL_W32(tp, RxMissed, 0);
+}
+
+static void rtl_hw_start(struct  rtl8169_private *tp)
+{
+	rtl_unlock_config_regs(tp);
+
+	tp->cp_cmd &= CPCMD_MASK;
+	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
+
+	if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
+		rtl_hw_start_8169(tp);
+	else
+		rtl_hw_start_8168(tp);
+
+	rtl_set_rx_max_size(tp);
+	rtl_set_rx_tx_desc_registers(tp);
+	rtl_lock_config_regs(tp);
+
+	/* disable interrupt coalescing */
+	RTL_W16(tp, IntrMitigate, 0x0000);
+	/* Initially a 10 us delay. Turned it into a PCI commit. - FR */
+	RTL_R8(tp, IntrMask);
+	RTL_W8(tp, ChipCmd, CmdTxEnb | CmdRxEnb);
+	rtl_init_rxcfg(tp);
+	rtl_set_tx_config_registers(tp);
+
+	rtl_set_rx_mode(tp->dev);
+	/* no early-rx interrupts */
+	RTL_W16(tp, MultiIntr, RTL_R16(tp, MultiIntr) & 0xf000);
+	rtl_irq_enable(tp);
+}
+
 static int rtl8169_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
@@ -6466,22 +6460,18 @@ static const struct net_device_ops rtl_netdev_ops = {
 };
 
 static const struct rtl_cfg_info {
-	void (*hw_start)(struct rtl8169_private *tp);
 	unsigned int has_gmii:1;
 	const struct rtl_coalesce_info *coalesce_info;
 } rtl_cfg_infos [] = {
 	[RTL_CFG_0] = {
-		.hw_start	= rtl_hw_start_8169,
 		.has_gmii	= 1,
 		.coalesce_info	= rtl_coalesce_info_8169,
 	},
 	[RTL_CFG_1] = {
-		.hw_start	= rtl_hw_start_8168,
 		.has_gmii	= 1,
 		.coalesce_info	= rtl_coalesce_info_8168_8136,
 	},
 	[RTL_CFG_2] = {
-		.hw_start	= rtl_hw_start_8101,
 		.coalesce_info	= rtl_coalesce_info_8168_8136,
 	}
 };
@@ -6860,7 +6850,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->max_mtu = jumbo_max;
 
 	rtl_set_irq_mask(tp);
-	tp->hw_start = cfg->hw_start;
 	tp->coalesce_info = cfg->coalesce_info;
 
 	tp->fw_name = rtl_chip_infos[chipset].fw_name;
-- 
2.21.0


