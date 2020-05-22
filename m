Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197EF1DE2A5
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbgEVJLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:11:32 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:12877 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbgEVJLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:11:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590138691; x=1621674691;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=jQ2q81LFJAHLzCcAtbw7SPvBKsCsAWZpwQLK/WY38gA=;
  b=U4vWMJaYu0MFMgRADUBAyRvVzHgpCMacg8fisKjxzqLy1UGseIiXQ4ni
   xrb5CUDSlE6lsb5KLPMAnU1Zrxfg1fDxeqAyoBT1lYDdpIKimt5qeZpp4
   MfcEd1D/2/oD2fS6jvlrO/Jai/vPYx7YshUrmM1SgCEljgjvzaiouLJ4E
   I=;
IronPort-SDR: eBcxO8m/aLWnWw2KZXF1+jwQSYHHPaYCUqoF6ifqzPwgccXG2JcAcPScGlX0L7Gx44/Ld3TA8D
 8ZHN0xrtYSVQ==
X-IronPort-AV: E=Sophos;i="5.73,421,1583193600"; 
   d="scan'208";a="45268344"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 22 May 2020 09:11:23 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id A4FF1A26A5;
        Fri, 22 May 2020 09:11:22 +0000 (UTC)
Received: from EX13D10UWB003.ant.amazon.com (10.43.161.106) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:22 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB003.ant.amazon.com (10.43.161.106) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:21 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.161.249) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 09:11:17 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>, Igor Chauskin <igorch@amazon.com>
Subject: [PATCH V2 net-next 02/14] net: ena: rename ena_com_free_desc to make API more uniform
Date:   Fri, 22 May 2020 12:08:53 +0300
Message-ID: <1590138545-501-3-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590138545-501-1-git-send-email-akiyano@amazon.com>
References: <1590138545-501-1-git-send-email-akiyano@amazon.com>
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

