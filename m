Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD2169F28F
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730339AbfH0SnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:43:06 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34452 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728312AbfH0SnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 14:43:06 -0400
Received: by mail-wr1-f68.google.com with SMTP id s18so19848597wrn.1
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 11:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L4KNMcf7QsD9QdaqX5IZBDgjAGDgAoDOZS3jPmv9Xd8=;
        b=N4LqA8wIcUm6AOs+rV+1kc247f57z5c+TIfOLdWy4igQjzqUbnsST/Fl2Rojfoo8wc
         cMiNxxdmK79gtf+3pi/2fOjPymnKmp/ixjSzvFv5fJxpFxPbaj04vCMK0GPKncKIne17
         AXerD0YA0l6IED8B206Jw+fVN7jT75zx2tqq6+vRh6tNu1WUgCmeJpa9kSczoM7tO1O7
         9YhsBgiV2t8D9rZOnEritJWjJqt8wWqTfziMooQDWcJYX/tkdlOF46IoBop8/BS2mCXs
         c1KqYusmlzKUz6vPCXWOwVJftckHBBkbzVT6jMXKZJ4dPXBZ+X9dJDyGlwFgkVWe32IE
         pUoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L4KNMcf7QsD9QdaqX5IZBDgjAGDgAoDOZS3jPmv9Xd8=;
        b=igXqsaB+PmhgvxGKrkp6/lSshFakxg0LEcNm+OG4G8xzcQsLiKDb5o7FWnBDbAcLhI
         FO2qXn5sRFR9sN7RUbWBC8GryM6gg7QwAD1bWoIe11tq0FLlUlpW+v5SPz9ta3rTiqqO
         GydZSESmRY7b/olvO4XcDV6jevJPlQ6eT2FOPCsdLiGEg8wkUBELyAOnIzIyZdNqTZz/
         jxQslXiq1Jg+GOvFzTWcEjAykWgGNrqVV56/pRU8YpdaJAWdScQIhCdKRNjeRW0cSirM
         UWYnJkq8PRturlraB/WSZBs5TSSkpzUxDhLuCwdymuCSN6WvZvqePS5zbQZS7XObtsbO
         x3WQ==
X-Gm-Message-State: APjAAAXXnlPe+r/iScd/0okr1O6O+S5oNKb5UdixIR+IF3bEiOHlvv/I
        uNC7P7G5DO4THieUTGlqVns=
X-Google-Smtp-Source: APXvYqznUO/POaOd5mPq3qGbTUpasFhdxE+MXIj+J+ak+Ju0YQzd28Uy0xIPw8zvLpWWQhDW8zlB4Q==
X-Received: by 2002:adf:f206:: with SMTP id p6mr32235104wro.216.1566931383957;
        Tue, 27 Aug 2019 11:43:03 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:4dc:3c33:31aa:f4c0? (p200300EA8F047C0004DC3C3331AAF4C0.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:4dc:3c33:31aa:f4c0])
        by smtp.googlemail.com with ESMTPSA id 2sm29294453wrg.83.2019.08.27.11.43.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 11:43:03 -0700 (PDT)
Subject: [PATCH net-next 1/4] r8169: prepare for adding RTL8125 support
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
References: <55099fc6-1e29-4023-337c-98fc04189e5e@gmail.com>
Message-ID: <66ac2b09-ea87-a4ba-f6f3-1885e9587298@gmail.com>
Date:   Tue, 27 Aug 2019 20:41:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <55099fc6-1e29-4023-337c-98fc04189e5e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch prepares the driver for adding RTL8125 support:
- change type of interrupt mask to u32
- restrict rtl_is_8168evl_up to RTL8168 chip versions
- factor out reading MAC address from registers
- re-add function rtl_get_events
- move disabling interrupt coalescing to RTL8169/RTL8168 init
- read different register for PCI commit
- don't use bit LastFrag in tx descriptor after send, RTL8125 clears it

No functional change intended.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 44 ++++++++++++++++-------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index faa4041cf..32b444d13 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -645,7 +645,7 @@ struct rtl8169_private {
 	struct page *Rx_databuff[NUM_RX_DESC];	/* Rx data buffers */
 	struct ring_info tx_skb[NUM_TX_DESC];	/* Tx data buffers */
 	u16 cp_cmd;
-	u16 irq_mask;
+	u32 irq_mask;
 	struct clk *clk;
 
 	struct {
@@ -730,7 +730,8 @@ static void rtl_tx_performance_tweak(struct rtl8169_private *tp, u16 force)
 static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
 {
 	return tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
-	       tp->mac_version != RTL_GIGA_MAC_VER_39;
+	       tp->mac_version != RTL_GIGA_MAC_VER_39 &&
+	       tp->mac_version <= RTL_GIGA_MAC_VER_51;
 }
 
 static bool rtl_supports_eee(struct rtl8169_private *tp)
@@ -740,6 +741,14 @@ static bool rtl_supports_eee(struct rtl8169_private *tp)
 	       tp->mac_version != RTL_GIGA_MAC_VER_39;
 }
 
+static void rtl_read_mac_from_reg(struct rtl8169_private *tp, u8 *mac, int reg)
+{
+	int i;
+
+	for (i = 0; i < ETH_ALEN; i++)
+		mac[i] = RTL_R8(tp, reg + i);
+}
+
 struct rtl_cond {
 	bool (*check)(struct rtl8169_private *);
 	const char *msg;
@@ -1313,7 +1322,12 @@ static u8 rtl8168d_efuse_read(struct rtl8169_private *tp, int reg_addr)
 		RTL_R32(tp, EFUSEAR) & EFUSEAR_DATA_MASK : ~0;
 }
 
-static void rtl_ack_events(struct rtl8169_private *tp, u16 bits)
+static u32 rtl_get_events(struct rtl8169_private *tp)
+{
+	return RTL_R16(tp, IntrStatus);
+}
+
+static void rtl_ack_events(struct rtl8169_private *tp, u32 bits)
 {
 	RTL_W16(tp, IntrStatus, bits);
 }
@@ -1337,7 +1351,7 @@ static void rtl_irq_enable(struct rtl8169_private *tp)
 static void rtl8169_irq_mask_and_ack(struct rtl8169_private *tp)
 {
 	rtl_irq_disable(tp);
-	rtl_ack_events(tp, 0xffff);
+	rtl_ack_events(tp, 0xffffffff);
 	/* PCI commit */
 	RTL_R8(tp, ChipCmd);
 }
@@ -5073,6 +5087,9 @@ static void rtl_hw_start_8168(struct rtl8169_private *tp)
 		RTL_W8(tp, MaxTxPacketSize, TxPacketMax);
 
 	rtl_hw_config(tp);
+
+	/* disable interrupt coalescing */
+	RTL_W16(tp, IntrMitigate, 0x0000);
 }
 
 static void rtl_hw_start_8169(struct rtl8169_private *tp)
@@ -5096,6 +5113,9 @@ static void rtl_hw_start_8169(struct rtl8169_private *tp)
 	rtl8169_set_magic_reg(tp, tp->mac_version);
 
 	RTL_W32(tp, RxMissed, 0);
+
+	/* disable interrupt coalescing */
+	RTL_W16(tp, IntrMitigate, 0x0000);
 }
 
 static void rtl_hw_start(struct  rtl8169_private *tp)
@@ -5114,10 +5134,8 @@ static void rtl_hw_start(struct  rtl8169_private *tp)
 	rtl_set_rx_tx_desc_registers(tp);
 	rtl_lock_config_regs(tp);
 
-	/* disable interrupt coalescing */
-	RTL_W16(tp, IntrMitigate, 0x0000);
 	/* Initially a 10 us delay. Turned it into a PCI commit. - FR */
-	RTL_R8(tp, IntrMask);
+	RTL_R8(tp, ChipCmd);
 	RTL_W8(tp, ChipCmd, CmdTxEnb | CmdRxEnb);
 	rtl_init_rxcfg(tp);
 	rtl_set_tx_config_registers(tp);
@@ -5695,7 +5713,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 
 		rtl8169_unmap_tx_skb(tp_to_dev(tp), tx_skb,
 				     tp->TxDescArray + entry);
-		if (status & LastFrag) {
+		if (tx_skb->skb) {
 			pkts_compl++;
 			bytes_compl += tx_skb->skb->len;
 			napi_consume_skb(tx_skb->skb, budget);
@@ -5854,9 +5872,10 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 {
 	struct rtl8169_private *tp = dev_instance;
-	u16 status = RTL_R16(tp, IntrStatus);
+	u32 status = rtl_get_events(tp);
 
-	if (!tp->irq_enabled || status == 0xffff || !(status & tp->irq_mask))
+	if (!tp->irq_enabled || (status & 0xffff) == 0xffff ||
+	    !(status & tp->irq_mask))
 		return IRQ_NONE;
 
 	if (unlikely(status & SYSErr)) {
@@ -6623,7 +6642,7 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
 {
 	struct net_device *dev = tp->dev;
 	u8 *mac_addr = dev->dev_addr;
-	int rc, i;
+	int rc;
 
 	rc = eth_platform_get_mac_address(tp_to_dev(tp), mac_addr);
 	if (!rc)
@@ -6633,8 +6652,7 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
 	if (is_valid_ether_addr(mac_addr))
 		goto done;
 
-	for (i = 0; i < ETH_ALEN; i++)
-		mac_addr[i] = RTL_R8(tp, MAC0 + i);
+	rtl_read_mac_from_reg(tp, mac_addr, MAC0);
 	if (is_valid_ether_addr(mac_addr))
 		goto done;
 
-- 
2.23.0


