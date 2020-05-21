Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2491DD6B2
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbgEUTJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:09:05 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:35608 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730260AbgEUTJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590088144; x=1621624144;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=jQ2q81LFJAHLzCcAtbw7SPvBKsCsAWZpwQLK/WY38gA=;
  b=rEFraXiX9tCrTcB2K+50PvUNCEvdFusUWqozpL9MPIwWHcBOybpgu9/a
   trVakFwaLf18En64utN/3riNKGg6nAjuelizwdV2dm4xAMkvzlazf2fV2
   LwtT0hawxoXcXH/NorbXxQwJk3vUJjUh3a6cQq8OJHjcgYm/3d8lQUzna
   I=;
IronPort-SDR: q3N4WvqxU6UXlJElynor/EgRPrSB6VBxeGGiwBWPTvVOLl2EqJ5nD94Be6nK6jtpOkAPmV3k0K
 QwxKRp5lSOTA==
X-IronPort-AV: E=Sophos;i="5.73,418,1583193600"; 
   d="scan'208";a="32967702"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 21 May 2020 19:09:03 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id EFED5A2451;
        Thu, 21 May 2020 19:09:02 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:08:45 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:08:44 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.27) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 21 May 2020 19:08:42 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>, Igor Chauskin <igorch@amazon.com>
Subject: [PATCH V1 net-next 02/15] net: ena: rename ena_com_free_desc to make API more uniform
Date:   Thu, 21 May 2020 22:08:21 +0300
Message-ID: <1590088114-381-3-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590088114-381-1-git-send-email-akiyano@amazon.com>
References: <1590088114-381-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Rename ena_com_free_desc to ena_com_free_q_entries to match
the LLQ mode.

In non-LLQ mode, an entry in an IO ring corresponds to a
a descriptor. In LLQ mode an entry may correspond to several
descriptors (per LLQ definition).

Signed-off-by: Igor Chauskin <igorch@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_eth_com.h | 6 +++---
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 5 ++---
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.h b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
index 9834b5cdb655..8b1afd3b32f2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
@@ -96,7 +96,7 @@ static inline void ena_com_unmask_intr(struct ena_com_io_cq *io_cq,
 	writel(intr_reg->intr_control, io_cq->unmask_reg);
 }
 
-static inline int ena_com_free_desc(struct ena_com_io_sq *io_sq)
+static inline int ena_com_free_q_entries(struct ena_com_io_sq *io_sq)
 {
 	u16 tail, next_to_comp, cnt;
 
@@ -114,7 +114,7 @@ static inline bool ena_com_sq_have_enough_space(struct ena_com_io_sq *io_sq,
 	int temp;
 
 	if (io_sq->mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_HOST)
-		return ena_com_free_desc(io_sq) >= required_buffers;
+		return ena_com_free_q_entries(io_sq) >= required_buffers;
 
 	/* This calculation doesn't need to be 100% accurate. So to reduce
 	 * the calculation overhead just Subtract 2 lines from the free descs
@@ -123,7 +123,7 @@ static inline bool ena_com_sq_have_enough_space(struct ena_com_io_sq *io_sq,
 	 */
 	temp = required_buffers / io_sq->llq_info.descs_per_entry + 2;
 
-	return ena_com_free_desc(io_sq) > temp;
+	return ena_com_free_q_entries(io_sq) > temp;
 }
 
 static inline bool ena_com_meta_desc_changed(struct ena_com_io_sq *io_sq,
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 33578297dc56..c3cbe48b353e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1691,7 +1691,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 
 	rx_ring->next_to_clean = next_to_clean;
 
-	refill_required = ena_com_free_desc(rx_ring->ena_com_io_sq);
+	refill_required = ena_com_free_q_entries(rx_ring->ena_com_io_sq);
 	refill_threshold =
 		min_t(int, rx_ring->ring_size / ENA_RX_REFILL_THRESH_DIVIDER,
 		      ENA_RX_REFILL_THRESH_PACKET);
@@ -3694,8 +3694,7 @@ static void check_for_empty_rx_ring(struct ena_adapter *adapter)
 	for (i = 0; i < adapter->num_io_queues; i++) {
 		rx_ring = &adapter->rx_ring[i];
 
-		refill_required =
-			ena_com_free_desc(rx_ring->ena_com_io_sq);
+		refill_required = ena_com_free_q_entries(rx_ring->ena_com_io_sq);
 		if (unlikely(refill_required == (rx_ring->ring_size - 1))) {
 			rx_ring->empty_rx_queue++;
 
-- 
2.23.1

