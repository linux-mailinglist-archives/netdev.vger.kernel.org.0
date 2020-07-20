Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BE6226E50
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbgGTSdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:33:01 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53982 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730457AbgGTSc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:32:59 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KIFx1o021903;
        Mon, 20 Jul 2020 11:32:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=uE4lTU89tW1FB5sQ1r9FZAY3BL/Qve5cCkMHHNgDzmE=;
 b=guHbgxexISXlVH+4izdu1t2O7CUxFRL7tGSlXIZ5XfHqS71XSTd73SZlddcMFEV7uwlW
 fgp2x2NdDB1NRUjGuBwHYVKum/fcCiJ3ApHB9RH2lg9wy99bcITCrNm0nYl9TIcwDl/6
 j33mIZLIuNcwAPr78+cnv/idxd8kfKxAPIdkFwCOgKQI0917vASQuT7eEg4DZf1u1s7Y
 1O4bUe5YzvpS4u7cK76/wp6Fdfwub50jBKyBN/Dzxs+XxqFX0yR9p6SF/HZQFw2sH3uQ
 SUl2XiDgi3gvHuXGeYzPb3gkrO06bAcnSLxXwBUJL5AwACrJ9xZaI9hn5BcleT0RItjK 8A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkfb8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:32:55 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:32:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:32:54 -0700
Received: from NN-LT0044.marvell.com (NN-LT0044.marvell.com [10.193.54.8])
        by maili.marvell.com (Postfix) with ESMTP id 830123F703F;
        Mon, 20 Jul 2020 11:32:52 -0700 (PDT)
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>
Subject: [PATCH v3 net-next 02/13] net: atlantic: use simple assignment in _get_stats and _get_sw_stats
Date:   Mon, 20 Jul 2020 21:32:33 +0300
Message-ID: <20200720183244.10029-3-mstarovoitov@marvell.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200720183244.10029-1-mstarovoitov@marvell.com>
References: <20200720183244.10029-1-mstarovoitov@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces addition assignment operator with a simple assignment
in aq_vec_get_stats() and aq_vec_get_sw_stats(), because it is
sufficient in both cases and this change simplifies the introduction of
u64_stats_update_* in these functions.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_vec.c   | 47 ++++++++++---------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index d1d43c8ce400..2acdaee18ba0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File aq_vec.c: Definition of common structure for vector of Rx and Tx rings.
@@ -349,7 +350,7 @@ cpumask_t *aq_vec_get_affinity_mask(struct aq_vec_s *self)
 	return &self->aq_ring_param.affinity_mask;
 }
 
-static void aq_vec_add_stats(struct aq_vec_s *self,
+static void aq_vec_get_stats(struct aq_vec_s *self,
 			     const unsigned int tc,
 			     struct aq_ring_stats_rx_s *stats_rx,
 			     struct aq_ring_stats_tx_s *stats_tx)
@@ -359,23 +360,23 @@ static void aq_vec_add_stats(struct aq_vec_s *self,
 	if (tc < self->rx_rings) {
 		struct aq_ring_stats_rx_s *rx = &ring[AQ_VEC_RX_ID].stats.rx;
 
-		stats_rx->packets += rx->packets;
-		stats_rx->bytes += rx->bytes;
-		stats_rx->errors += rx->errors;
-		stats_rx->jumbo_packets += rx->jumbo_packets;
-		stats_rx->lro_packets += rx->lro_packets;
-		stats_rx->pg_losts += rx->pg_losts;
-		stats_rx->pg_flips += rx->pg_flips;
-		stats_rx->pg_reuses += rx->pg_reuses;
+		stats_rx->packets = rx->packets;
+		stats_rx->bytes = rx->bytes;
+		stats_rx->errors = rx->errors;
+		stats_rx->jumbo_packets = rx->jumbo_packets;
+		stats_rx->lro_packets = rx->lro_packets;
+		stats_rx->pg_losts = rx->pg_losts;
+		stats_rx->pg_flips = rx->pg_flips;
+		stats_rx->pg_reuses = rx->pg_reuses;
 	}
 
 	if (tc < self->tx_rings) {
 		struct aq_ring_stats_tx_s *tx = &ring[AQ_VEC_TX_ID].stats.tx;
 
-		stats_tx->packets += tx->packets;
-		stats_tx->bytes += tx->bytes;
-		stats_tx->errors += tx->errors;
-		stats_tx->queue_restarts += tx->queue_restarts;
+		stats_tx->packets = tx->packets;
+		stats_tx->bytes = tx->bytes;
+		stats_tx->errors = tx->errors;
+		stats_tx->queue_restarts = tx->queue_restarts;
 	}
 }
 
@@ -389,16 +390,16 @@ int aq_vec_get_sw_stats(struct aq_vec_s *self, const unsigned int tc, u64 *data,
 	memset(&stats_rx, 0U, sizeof(struct aq_ring_stats_rx_s));
 	memset(&stats_tx, 0U, sizeof(struct aq_ring_stats_tx_s));
 
-	aq_vec_add_stats(self, tc, &stats_rx, &stats_tx);
+	aq_vec_get_stats(self, tc, &stats_rx, &stats_tx);
 
 	/* This data should mimic aq_ethtool_queue_stat_names structure
 	 */
-	data[count] += stats_rx.packets;
-	data[++count] += stats_tx.packets;
-	data[++count] += stats_tx.queue_restarts;
-	data[++count] += stats_rx.jumbo_packets;
-	data[++count] += stats_rx.lro_packets;
-	data[++count] += stats_rx.errors;
+	data[count] = stats_rx.packets;
+	data[++count] = stats_tx.packets;
+	data[++count] = stats_tx.queue_restarts;
+	data[++count] = stats_rx.jumbo_packets;
+	data[++count] = stats_rx.lro_packets;
+	data[++count] = stats_rx.errors;
 
 	if (p_count)
 		*p_count = ++count;
-- 
2.25.1

