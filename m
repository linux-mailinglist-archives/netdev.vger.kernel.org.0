Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8980528F631
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 17:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389900AbgJOPvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 11:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389852AbgJOPvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 11:51:35 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43B1C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 08:51:34 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l24so3571664edj.8
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 08:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Lieqmg2kpO/cVhmlQ17TOZxbIgp5fwMdOy7myfEO1BI=;
        b=gUDWyJFBmLrKVkMM3xOvMOa8DJzYCgQc34/x0vg5MVm98NdVLNqr2XZ+bv9+RhMKyd
         f6EHHUp/Y5LQe5wAOvFCV1yF91ae4CcX5KNJrHq8sb6fTn2ZMtVwI8BgbqA28SMv2Lo+
         wQ4OnhvdQSYS9CoJNkv0oyQPwt4X+6YLxbNSknKbl+89zjv/ZiE9zHQrXXGBiZdDmrT2
         bfryTkjCna7/268k+qmS22dYWGH0PTmYyOPvIcbV1aJAHMiBk4MEY8IgPrfvisgddIXf
         MeTYDzjCoRQo3WBMOp01hny+/tSPZtpzwEfxRgwQKKRf+qiqL51/EeajJlaBwzwIYj1N
         s2Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lieqmg2kpO/cVhmlQ17TOZxbIgp5fwMdOy7myfEO1BI=;
        b=uF9O8PwVSYAcpA8VUx3VLTERtiUUmvMu3wZn25RmQ6xgcKJqxXRrKOHd1IohjGh3KL
         xz1z2pOusDI+QlBK/30zpwq1jDBS/fd2I5KxCJ8gufPveY6asYY2aH6xhMmTbfhusCCf
         DY5S72wUcFsi1V4WQwRapRWOQ0hON+1k7gYrvmo7zwcO671Frg/X7o01S4NqMCQWzDWB
         KyI9OlD5BCF1TEDPKO+w0UnjCVv9kTgbij0mDzlQM90k8yYN1k62vvmhxzJfSkU6fGs+
         Danrr7dv4nCwMiD5oD+Q+oXCA21tqiXV9r8vl5Xf7uNeqSsCuKuRZZ0cXi+0Ipq3i4V1
         P8cw==
X-Gm-Message-State: AOAM532AJm5XbfsBkIUQcigDZPYnYCaZxUvEIJf5MrY87WvPCdE43aKd
        MTnguH7r5onM8DG1x77kybQwwzH1XJQ=
X-Google-Smtp-Source: ABdhPJxO4QNda/Gvy+uTfydeGCzRoAt7FrGKSQgRcRUVl5VbLn7FZdQMm1uzzoxND4UYHMF7AUDAZw==
X-Received: by 2002:a50:d5d8:: with SMTP id g24mr4956948edj.119.1602777093380;
        Thu, 15 Oct 2020 08:51:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:c92:1571:ee2d:f2ef? (p200300ea8f2328000c921571ee2df2ef.dip0.t-ipconnect.de. [2003:ea:8f23:2800:c92:1571:ee2d:f2ef])
        by smtp.googlemail.com with ESMTPSA id m6sm2106982ejl.94.2020.10.15.08.51.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 08:51:32 -0700 (PDT)
Subject: [PATCH net-next 4/4] r8169: remove no longer needed private rx/tx
 packet/byte counters
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e25761cc-60c2-92fe-f7df-b8c55cf12ec7@gmail.com>
Message-ID: <001f7596-d30a-c2a6-dffb-3ead88ae769e@gmail.com>
Date:   Thu, 15 Oct 2020 17:51:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <e25761cc-60c2-92fe-f7df-b8c55cf12ec7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After switching to the net core rx/tx byte/packet counters we can
remove the now unused private version.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 34 -----------------------
 1 file changed, 34 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 840543bc8..345cd5f00 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -584,12 +584,6 @@ enum rtl_flag {
 	RTL_FLAG_MAX
 };
 
-struct rtl8169_stats {
-	u64			packets;
-	u64			bytes;
-	struct u64_stats_sync	syncp;
-};
-
 struct rtl8169_private {
 	void __iomem *mmio_addr;	/* memory map physical address */
 	struct pci_dev *pci_dev;
@@ -600,8 +594,6 @@ struct rtl8169_private {
 	u32 cur_rx; /* Index into the Rx descriptor buffer of next Rx pkt. */
 	u32 cur_tx; /* Index into the Tx descriptor buffer of next Rx pkt. */
 	u32 dirty_tx;
-	struct rtl8169_stats rx_stats;
-	struct rtl8169_stats tx_stats;
 	struct TxDesc *TxDescArray;	/* 256-aligned Tx descriptor ring */
 	struct RxDesc *RxDescArray;	/* 256-aligned Rx descriptor ring */
 	dma_addr_t TxPhyAddr;
@@ -700,27 +692,6 @@ static bool rtl_supports_eee(struct rtl8169_private *tp)
 	       tp->mac_version != RTL_GIGA_MAC_VER_39;
 }
 
-static void rtl_get_priv_stats(struct rtl8169_stats *stats,
-			       u64 *pkts, u64 *bytes)
-{
-	unsigned int start;
-
-	do {
-		start = u64_stats_fetch_begin_irq(&stats->syncp);
-		*pkts = stats->packets;
-		*bytes = stats->bytes;
-	} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
-}
-
-static void rtl_inc_priv_stats(struct rtl8169_stats *stats,
-			       u64 pkts, u64 bytes)
-{
-	u64_stats_update_begin(&stats->syncp);
-	stats->packets += pkts;
-	stats->bytes += bytes;
-	u64_stats_update_end(&stats->syncp);
-}
-
 static void rtl_read_mac_from_reg(struct rtl8169_private *tp, u8 *mac, int reg)
 {
 	int i;
@@ -4416,9 +4387,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 
 	if (tp->dirty_tx != dirty_tx) {
 		netdev_completed_queue(dev, pkts_compl, bytes_compl);
-
 		dev_sw_netstats_tx_add(dev, pkts_compl, bytes_compl);
-		rtl_inc_priv_stats(&tp->tx_stats, pkts_compl, bytes_compl);
 
 		tp->dirty_tx = dirty_tx;
 		/* Sync with rtl8169_start_xmit:
@@ -4541,7 +4510,6 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 		napi_gro_receive(&tp->napi, skb);
 
 		dev_sw_netstats_rx_add(dev, pkt_size);
-		rtl_inc_priv_stats(&tp->rx_stats, 1, pkt_size);
 release_descriptor:
 		rtl8169_mark_to_asic(desc);
 	}
@@ -5345,8 +5313,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	INIT_WORK(&tp->wk.work, rtl_task);
-	u64_stats_init(&tp->rx_stats.syncp);
-	u64_stats_init(&tp->tx_stats.syncp);
 
 	rtl_init_mac_address(tp);
 
-- 
2.28.0


