Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF7B3DF5EC
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 21:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbfJUTYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 15:24:33 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54355 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728943AbfJUTYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 15:24:33 -0400
Received: by mail-wm1-f65.google.com with SMTP id p7so14627035wmp.4
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 12:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4ViceCBKEekVuaHxAnRKEgIe72ikZrvUeXDTiix/QuQ=;
        b=m+t+w3r2TkNWz0NiGx4/4M8eucZy9kGzcp60o/LAu2I8UrDFdU3+EkHUdpD13USbYC
         SjTWxvLv3SIzMWsSXUX+x7ivxcEsrAi0URj3Uvs1zBhaBd+aIoOoAB28AGOM1zcPTmYQ
         Ta+3TKnGKsU/nf7ENGPnYV4/nOOIC+oqrF7JOSfLlq+K1RQPdnaJ4JbzRq3aCw1exLU5
         O2NIiTfsWknFlipuQESgQ6AQEiTm168tn7IS/Dz1nEzHh5/qbEDweP8ZA+D0zoeZtBT7
         bnYdWlHi4149XPhuDMqWK09AyQHKUlCKokgQNFTntLwefFaFhwEKATth9lIojMHsuAXG
         ThWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ViceCBKEekVuaHxAnRKEgIe72ikZrvUeXDTiix/QuQ=;
        b=Dl+1wAL9pP80ucTq1GFoeyuM0gLv+6bjM2ixPOHOeuzem2S32MgYe+XTbIps7v6j7C
         jNijIVMboT2qrzhKDLk+VxTEKVfWK0KBCThH1fyr4tNEaNqPxnmHwpEM6sc7SMUxC44S
         yQbSM6HqkMz5d1IT/oETc+1i3nEx5ISn6AoZ1Yztqoi6jI2jDRtMphGz27w1/06hy0tq
         DQ+QDw2/cBQw5It7NJTt08xSkNeR2e81ml+fQ1w4mjRxjEg13eBRo+QQlgPfXOUXwL9J
         2p6UBXYeyDAWQJVIc2dwnlaWwJy7k9l+5ZURvZHg0VWVDo4xJreDw3HOjVUPM6in3DaG
         uf8A==
X-Gm-Message-State: APjAAAXjzhW3JC3jjT8DbedgGxf5RUNjC5O7h6bMzEQiPd+fjXsGLRpC
        VdHb7d2mahG2ms92XRl1rT8py5FZ
X-Google-Smtp-Source: APXvYqwHiw1WpBt274RDlzu4jj/+30SAXgY8OUPkgXSvyq2hIov32KxLKiw3zrFSBDGFNw2luGCpVA==
X-Received: by 2002:a1c:ab0a:: with SMTP id u10mr3594951wme.0.1571685868291;
        Mon, 21 Oct 2019 12:24:28 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:1cea:5bb:1373:bc70? (p200300EA8F2664001CEA05BB1373BC70.dip0.t-ipconnect.de. [2003:ea:8f26:6400:1cea:5bb:1373:bc70])
        by smtp.googlemail.com with ESMTPSA id p12sm16630950wrm.62.2019.10.21.12.24.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 12:24:27 -0700 (PDT)
Subject: [PATCH net-next 1/4] r8169: remove fiddling with the PCIe max read
 request size
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c4f2e4fc-9cbe-2ba1-b0b2-1e734032b550@gmail.com>
Message-ID: <13bf96be-1aae-eb73-a9b8-8f5d41e2b478@gmail.com>
Date:   Mon, 21 Oct 2019 21:22:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c4f2e4fc-9cbe-2ba1-b0b2-1e734032b550@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The attempt to improve performance by changing the PCIe max read request
size was added in the vendor driver more than 10 years back and copied
to r8169 driver. In the vendor driver this has been removed long ago.
Obviously it had no effect, also in my tests I didn't see any
difference. Typically the max payload size is less than 512 bytes
anyway, and the PCI core takes care that the maximum supported value
is set. So let's remove fiddling with PCIe max read request size from
r8169 too.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 40 +++--------------------
 1 file changed, 4 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 350b0d949..41680bd08 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -741,12 +741,6 @@ static void rtl_unlock_config_regs(struct rtl8169_private *tp)
 	RTL_W8(tp, Cfg9346, Cfg9346_Unlock);
 }
 
-static void rtl_tx_performance_tweak(struct rtl8169_private *tp, u16 force)
-{
-	pcie_capability_clear_and_set_word(tp->pci_dev, PCI_EXP_DEVCTL,
-					   PCI_EXP_DEVCTL_READRQ, force);
-}
-
 static bool rtl_is_8125(struct rtl8169_private *tp)
 {
 	return tp->mac_version >= RTL_GIGA_MAC_VER_60;
@@ -4032,14 +4026,12 @@ static void r8168c_hw_jumbo_enable(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) | Jumbo_En0);
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) | Jumbo_En1);
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_512B);
 }
 
 static void r8168c_hw_jumbo_disable(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Jumbo_En0);
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) & ~Jumbo_En1);
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 }
 
 static void r8168dp_hw_jumbo_enable(struct rtl8169_private *tp)
@@ -4057,7 +4049,6 @@ static void r8168e_hw_jumbo_enable(struct rtl8169_private *tp)
 	RTL_W8(tp, MaxTxPacketSize, 0x3f);
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) | Jumbo_En0);
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) | 0x01);
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_512B);
 }
 
 static void r8168e_hw_jumbo_disable(struct rtl8169_private *tp)
@@ -4065,19 +4056,18 @@ static void r8168e_hw_jumbo_disable(struct rtl8169_private *tp)
 	RTL_W8(tp, MaxTxPacketSize, 0x0c);
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Jumbo_En0);
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) & ~0x01);
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 }
 
 static void r8168b_0_hw_jumbo_enable(struct rtl8169_private *tp)
 {
-	rtl_tx_performance_tweak(tp,
-		PCI_EXP_DEVCTL_READRQ_512B | PCI_EXP_DEVCTL_NOSNOOP_EN);
+	pcie_capability_set_word(tp->pci_dev, PCI_EXP_DEVCTL,
+				 PCI_EXP_DEVCTL_NOSNOOP_EN);
 }
 
 static void r8168b_0_hw_jumbo_disable(struct rtl8169_private *tp)
 {
-	rtl_tx_performance_tweak(tp,
-		PCI_EXP_DEVCTL_READRQ_4096B | PCI_EXP_DEVCTL_NOSNOOP_EN);
+	pcie_capability_set_word(tp->pci_dev, PCI_EXP_DEVCTL,
+				 PCI_EXP_DEVCTL_NOSNOOP_EN);
 }
 
 static void r8168b_1_hw_jumbo_enable(struct rtl8169_private *tp)
@@ -4550,18 +4540,12 @@ static void rtl_hw_start_8168d(struct rtl8169_private *tp)
 	rtl_set_def_aspm_entry_latency(tp);
 
 	rtl_disable_clock_request(tp);
-
-	if (tp->dev->mtu <= ETH_DATA_LEN)
-		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 }
 
 static void rtl_hw_start_8168dp(struct rtl8169_private *tp)
 {
 	rtl_set_def_aspm_entry_latency(tp);
 
-	if (tp->dev->mtu <= ETH_DATA_LEN)
-		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_disable_clock_request(tp);
 }
 
@@ -4576,8 +4560,6 @@ static void rtl_hw_start_8168d_4(struct rtl8169_private *tp)
 
 	rtl_set_def_aspm_entry_latency(tp);
 
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_ephy_init(tp, e_info_8168d_4);
 
 	rtl_enable_clock_request(tp);
@@ -4652,8 +4634,6 @@ static void rtl_hw_start_8168f(struct rtl8169_private *tp)
 {
 	rtl_set_def_aspm_entry_latency(tp);
 
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
 	rtl_set_fifo_size(tp, 0x10, 0x10, 0x02, 0x06);
@@ -4716,8 +4696,6 @@ static void rtl_hw_start_8168g(struct rtl8169_private *tp)
 
 	rtl_set_def_aspm_entry_latency(tp);
 
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_reset_packet_filter(tp);
 	rtl_eri_write(tp, 0x2f8, ERIAR_MASK_0011, 0x1d8f);
 
@@ -4954,8 +4932,6 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 
 	rtl_set_def_aspm_entry_latency(tp);
 
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_reset_packet_filter(tp);
 
 	rtl_eri_set_bits(tp, 0xdc, ERIAR_MASK_1111, BIT(4));
@@ -5013,8 +4989,6 @@ static void rtl_hw_start_8168ep(struct rtl8169_private *tp)
 
 	rtl_set_def_aspm_entry_latency(tp);
 
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_reset_packet_filter(tp);
 
 	rtl_eri_set_bits(tp, 0xd4, ERIAR_MASK_1111, 0x1f80);
@@ -5117,8 +5091,6 @@ static void rtl_hw_start_8102e_1(struct rtl8169_private *tp)
 
 	RTL_W8(tp, DBG_REG, FIX_NAK_1);
 
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	RTL_W8(tp, Config1,
 	       LEDS1 | LEDS0 | Speed_down | MEMMAP | IOMAP | VPD | PMEnable);
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
@@ -5134,8 +5106,6 @@ static void rtl_hw_start_8102e_2(struct rtl8169_private *tp)
 {
 	rtl_set_def_aspm_entry_latency(tp);
 
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	RTL_W8(tp, Config1, MEMMAP | IOMAP | VPD | PMEnable);
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
 }
@@ -5196,8 +5166,6 @@ static void rtl_hw_start_8402(struct rtl8169_private *tp)
 
 	rtl_ephy_init(tp, e_info_8402);
 
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_set_fifo_size(tp, 0x00, 0x00, 0x02, 0x06);
 	rtl_reset_packet_filter(tp);
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
-- 
2.23.0


