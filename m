Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F24487DB1
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 21:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbiAGUYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 15:24:39 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:55208 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbiAGUYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 15:24:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641587078; x=1673123078;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2DinoxuCgTun0ef/xTWICoY/2RelHt0XIz6b7Di/8u0=;
  b=Lpocy5bPqfkVal0ugTnPq/SlW5BWWCEJk7jl1E53Ak20Yk3WQXqA23vi
   WoJHx2wvs9/FosD/Dxe2BddzAJ74CXh0ZwyvPMesufOGDSuSI5JNoPGlf
   KSh2sEgxbPN3yu5W6WvaXvQNF13FMBIMGKne/a4lgRwhGG7g4V5+8sbja
   M=;
X-IronPort-AV: E=Sophos;i="5.88,270,1635206400"; 
   d="scan'208";a="983088277"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-87b71607.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 07 Jan 2022 20:24:24 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-87b71607.us-east-1.amazon.com (Postfix) with ESMTPS id 81F30144044;
        Fri,  7 Jan 2022 20:24:23 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 7 Jan 2022 20:24:19 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 7 Jan 2022 20:24:19 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Fri, 7 Jan 2022 20:24:17 +0000
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
Subject: [PATCH V2 net-next 09/10] net: ena: Change the name of bad_csum variable
Date:   Fri, 7 Jan 2022 20:23:45 +0000
Message-ID: <20220107202346.3522-10-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220107202346.3522-1-akiyano@amazon.com>
References: <20220107202346.3522-1-akiyano@amazon.com>
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

