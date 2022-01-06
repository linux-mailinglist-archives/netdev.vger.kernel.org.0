Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FFB486A84
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 20:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243307AbiAFTaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 14:30:06 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:39927 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243374AbiAFT37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 14:29:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641497399; x=1673033399;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2DinoxuCgTun0ef/xTWICoY/2RelHt0XIz6b7Di/8u0=;
  b=Wh24ONFqUQVexHT9ndy4xdEKLPjAq2vaDXJE+H9NljNAIMDw8GTqqgpd
   blx0habBMgWD1aI6S5MQbYAWmELgeHDbVL98D06HmTp6pHmNI1f22eOp1
   up43MgOw+9gX51pmahoy+f7VFxArXyarsjsM0yL0a1DkIVD5/nerqPlVi
   g=;
X-IronPort-AV: E=Sophos;i="5.88,267,1635206400"; 
   d="scan'208";a="168316260"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-1box-2b-eee1d651.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 06 Jan 2022 19:29:58 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-1box-2b-eee1d651.us-west-2.amazon.com (Postfix) with ESMTPS id A6362C0902;
        Thu,  6 Jan 2022 19:29:57 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 6 Jan 2022 19:29:51 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 6 Jan 2022 19:29:50 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Thu, 6 Jan 2022 19:29:48 +0000
From:   Arthur Kiyanovski <akiyano@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        Nati Koler <nkoler@amazon.com>
Subject: [PATCH V1 net-next 09/10] net: ena: Change the name of bad_csum variable
Date:   Thu, 6 Jan 2022 19:29:14 +0000
Message-ID: <20220106192915.22616-10-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220106192915.22616-1-akiyano@amazon.com>
References: <20220106192915.22616-1-akiyano@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changed bad_csum to csum_bad to align with csum_unchecked & csum_good

Signed-off-by: Nati Koler <nkoler@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 4 ++--
 drivers/net/ethernet/amazon/ena/ena_netdev.h  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index c09e1b37048e..39242c5a1729 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -82,7 +82,7 @@ static const struct ena_stats ena_stats_rx_strings[] = {
 	ENA_STAT_RX_ENTRY(rx_copybreak_pkt),
 	ENA_STAT_RX_ENTRY(csum_good),
 	ENA_STAT_RX_ENTRY(refil_partial),
-	ENA_STAT_RX_ENTRY(bad_csum),
+	ENA_STAT_RX_ENTRY(csum_bad),
 	ENA_STAT_RX_ENTRY(page_alloc_fail),
 	ENA_STAT_RX_ENTRY(skb_alloc_fail),
 	ENA_STAT_RX_ENTRY(dma_mapping_err),
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 33e414dbf7a1..0cc72303a2da 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1558,7 +1558,7 @@ static void ena_rx_checksum(struct ena_ring *rx_ring,
 		     (ena_rx_ctx->l3_csum_err))) {
 		/* ipv4 checksum error */
 		skb->ip_summed = CHECKSUM_NONE;
-		ena_increase_stat(&rx_ring->rx_stats.bad_csum, 1,
+		ena_increase_stat(&rx_ring->rx_stats.csum_bad, 1,
 				  &rx_ring->syncp);
 		netif_dbg(rx_ring->adapter, rx_err, rx_ring->netdev,
 			  "RX IPv4 header checksum error\n");
@@ -1570,7 +1570,7 @@ static void ena_rx_checksum(struct ena_ring *rx_ring,
 		   (ena_rx_ctx->l4_proto == ENA_ETH_IO_L4_PROTO_UDP))) {
 		if (unlikely(ena_rx_ctx->l4_csum_err)) {
 			/* TCP/UDP checksum error */
-			ena_increase_stat(&rx_ring->rx_stats.bad_csum, 1,
+			ena_increase_stat(&rx_ring->rx_stats.csum_bad, 1,
 					  &rx_ring->syncp);
 			netif_dbg(rx_ring->adapter, rx_err, rx_ring->netdev,
 				  "RX L4 checksum error\n");
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 25b9d4dd0535..1659f0b6b824 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -204,7 +204,7 @@ struct ena_stats_rx {
 	u64 rx_copybreak_pkt;
 	u64 csum_good;
 	u64 refil_partial;
-	u64 bad_csum;
+	u64 csum_bad;
 	u64 page_alloc_fail;
 	u64 skb_alloc_fail;
 	u64 dma_mapping_err;
-- 
2.32.0

