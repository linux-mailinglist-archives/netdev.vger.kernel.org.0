Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BE024A050
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 15:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbgHSNpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 09:45:36 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:48095 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728523AbgHSNoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 09:44:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597844661; x=1629380661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=wr/Mw/Bt9jfJKJiOEVCD1XEmWkdqmhkWdY6pW/jQ0Ag=;
  b=Msj69qhCA0Sv3jPRLKEY6/rFc9gHOhrXdQPfyMepH/MSybZV8wyEAbHN
   hieOcKSR9KbaEVsFksL2uZCEbJjsSbX9CRGhy9ohYjqXEB0k8F0G/42Iu
   0yLODKq85v0Idn5WM00kbm6DcYsmSvti95P8+TzcUrc29IdjFw1fOeShl
   w=;
X-IronPort-AV: E=Sophos;i="5.76,331,1592870400"; 
   d="scan'208";a="48806488"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-60ce1996.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 19 Aug 2020 13:44:04 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-60ce1996.us-west-2.amazon.com (Postfix) with ESMTPS id 95DFDA05FB;
        Wed, 19 Aug 2020 13:44:03 +0000 (UTC)
Received: from EX13D10UWA003.ant.amazon.com (10.43.160.248) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 13:44:02 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA003.ant.amazon.com (10.43.160.248) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 13:44:02 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 19 Aug 2020 13:44:02 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 6640281C3D; Wed, 19 Aug 2020 13:44:02 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 1/4] net: ena: ethtool: use unsigned long for pointer arithmetics
Date:   Wed, 19 Aug 2020 13:43:46 +0000
Message-ID: <20200819134349.22129-2-sameehj@amazon.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20200819134349.22129-1-sameehj@amazon.com>
References: <20200819134349.22129-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

unsigned long is the type for doing maths on pointers.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 430275bc0..897beddc5 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -141,8 +141,8 @@ static void ena_queue_stats(struct ena_adapter *adapter, u64 **data)
 		for (j = 0; j < ENA_STATS_ARRAY_TX; j++) {
 			ena_stats = &ena_stats_tx_strings[j];
 
-			ptr = (u64 *)((uintptr_t)&ring->tx_stats +
-				(uintptr_t)ena_stats->stat_offset);
+			ptr = (u64 *)((unsigned long)&ring->tx_stats +
+				ena_stats->stat_offset);
 
 			ena_safe_update_stat(ptr, (*data)++, &ring->syncp);
 		}
@@ -153,8 +153,8 @@ static void ena_queue_stats(struct ena_adapter *adapter, u64 **data)
 		for (j = 0; j < ENA_STATS_ARRAY_RX; j++) {
 			ena_stats = &ena_stats_rx_strings[j];
 
-			ptr = (u64 *)((uintptr_t)&ring->rx_stats +
-				(uintptr_t)ena_stats->stat_offset);
+			ptr = (u64 *)((unsigned long)&ring->rx_stats +
+				ena_stats->stat_offset);
 
 			ena_safe_update_stat(ptr, (*data)++, &ring->syncp);
 		}
@@ -170,8 +170,8 @@ static void ena_dev_admin_queue_stats(struct ena_adapter *adapter, u64 **data)
 	for (i = 0; i < ENA_STATS_ARRAY_ENA_COM; i++) {
 		ena_stats = &ena_stats_ena_com_strings[i];
 
-		ptr = (u64 *)((uintptr_t)&adapter->ena_dev->admin_queue.stats +
-			(uintptr_t)ena_stats->stat_offset);
+		ptr = (u64 *)((unsigned long)&adapter->ena_dev->admin_queue.stats +
+			ena_stats->stat_offset);
 
 		*(*data)++ = *ptr;
 	}
@@ -189,8 +189,8 @@ static void ena_get_ethtool_stats(struct net_device *netdev,
 	for (i = 0; i < ENA_STATS_ARRAY_GLOBAL; i++) {
 		ena_stats = &ena_stats_global_strings[i];
 
-		ptr = (u64 *)((uintptr_t)&adapter->dev_stats +
-			(uintptr_t)ena_stats->stat_offset);
+		ptr = (u64 *)((unsigned long)&adapter->dev_stats +
+			ena_stats->stat_offset);
 
 		ena_safe_update_stat(ptr, data++, &adapter->syncp);
 	}
-- 
2.16.6

