Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A47226E52
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730641AbgGTSdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:33:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64868 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730570AbgGTSdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:33:06 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KIFthe015880;
        Mon, 20 Jul 2020 11:33:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=6Ot/bPvfw5BKPXRW7p53lnrjOuhaGfcF6LzuZzai5Ks=;
 b=m5KaIPbUTEOts9d+lgmcJinTJrYY/qBoIPWjcX0hxs+y2nRt09BvHRCo6V7c5uon5PZs
 CM1/bjVOQxOAFNLWZQVEofCi3S/ZnpI8dM1PSRfouXWL11HVrZ3ImkFKxFNIUqSrn8Tr
 B3C9nKATY693xf57/l6zwF1lIMO46hcldkWU64r/5TRrj+E+Gx4tDivJ7oWU0uo8w4rq
 DcVj7qs05BCFyKVv3BEjtpGCNzYvGGgqeYWf3td2ujMEIwmvNdTqfB9OMPAcnJYW5Ydq
 93r0f8uaLCIm+YkZiQgglr9mvoGbSAXqvJRyvn+PjsufpwE6bB4xLi9u/fOAOOLMWk91 rg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxeng0ge-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:33:05 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:33:05 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:33:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:33:03 -0700
Received: from NN-LT0044.marvell.com (NN-LT0044.marvell.com [10.193.54.8])
        by maili.marvell.com (Postfix) with ESMTP id 853063F7040;
        Mon, 20 Jul 2020 11:33:01 -0700 (PDT)
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>,
        "Dmitry Bogdanov" <dbogdanov@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>
Subject: [PATCH v3 net-next 06/13] net: atlantic: additional per-queue stats
Date:   Mon, 20 Jul 2020 21:32:37 +0300
Message-ID: <20200720183244.10029-7-mstarovoitov@marvell.com>
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

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch adds additional per-queue stats, these could
be useful for debugging and diagnostics.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c    |  3 +++
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   | 14 ++++++++++++++
 drivers/net/ethernet/aquantia/atlantic/aq_ring.h   |  3 +++
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    |  3 +++
 4 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 98ba8355a0f0..9e18d30d2e44 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -94,6 +94,9 @@ static const char * const aq_ethtool_queue_rx_stat_names[] = {
 	"%sQueue[%d] InJumboPackets",
 	"%sQueue[%d] InLroPackets",
 	"%sQueue[%d] InErrors",
+	"%sQueue[%d] AllocFails",
+	"%sQueue[%d] SkbAllocFails",
+	"%sQueue[%d] Polls",
 };
 
 static const char * const aq_ethtool_queue_tx_stat_names[] = {
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index b51ab2dbf6fe..4f913658eea4 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -94,6 +94,11 @@ static int aq_get_rxpages(struct aq_ring_s *self, struct aq_ring_buff_s *rxbuf,
 	if (!rxbuf->rxdata.page) {
 		ret = aq_get_rxpage(&rxbuf->rxdata, order,
 				    aq_nic_get_dev(self->aq_nic));
+		if (ret) {
+			u64_stats_update_begin(&self->stats.rx.syncp);
+			self->stats.rx.alloc_fails++;
+			u64_stats_update_end(&self->stats.rx.syncp);
+		}
 		return ret;
 	}
 
@@ -414,6 +419,9 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 			skb = build_skb(aq_buf_vaddr(&buff->rxdata),
 					AQ_CFG_RX_FRAME_MAX);
 			if (unlikely(!skb)) {
+				u64_stats_update_begin(&self->stats.rx.syncp);
+				self->stats.rx.skb_alloc_fails++;
+				u64_stats_update_end(&self->stats.rx.syncp);
 				err = -ENOMEM;
 				goto err_exit;
 			}
@@ -427,6 +435,9 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		} else {
 			skb = napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);
 			if (unlikely(!skb)) {
+				u64_stats_update_begin(&self->stats.rx.syncp);
+				self->stats.rx.skb_alloc_fails++;
+				u64_stats_update_end(&self->stats.rx.syncp);
 				err = -ENOMEM;
 				goto err_exit;
 			}
@@ -599,6 +610,9 @@ unsigned int aq_ring_fill_stats_data(struct aq_ring_s *self, u64 *data)
 			data[++count] = self->stats.rx.jumbo_packets;
 			data[++count] = self->stats.rx.lro_packets;
 			data[++count] = self->stats.rx.errors;
+			data[++count] = self->stats.rx.alloc_fails;
+			data[++count] = self->stats.rx.skb_alloc_fails;
+			data[++count] = self->stats.rx.polls;
 		} while (u64_stats_fetch_retry_irq(&self->stats.rx.syncp, start));
 	} else {
 		/* This data should mimic aq_ethtool_queue_tx_stat_names structure */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
index c92c3a0651a9..93659e58f1ce 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -95,6 +95,9 @@ struct aq_ring_stats_rx_s {
 	u64 bytes;
 	u64 lro_packets;
 	u64 jumbo_packets;
+	u64 alloc_fails;
+	u64 skb_alloc_fails;
+	u64 polls;
 	u64 pg_losts;
 	u64 pg_flips;
 	u64 pg_reuses;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index b008d12e923a..d281322d7dd2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -45,6 +45,9 @@ static int aq_vec_poll(struct napi_struct *napi, int budget)
 	} else {
 		for (i = 0U, ring = self->ring[0];
 			self->tx_rings > i; ++i, ring = self->ring[i]) {
+			u64_stats_update_begin(&ring[AQ_VEC_RX_ID].stats.rx.syncp);
+			ring[AQ_VEC_RX_ID].stats.rx.polls++;
+			u64_stats_update_end(&ring[AQ_VEC_RX_ID].stats.rx.syncp);
 			if (self->aq_hw_ops->hw_ring_tx_head_update) {
 				err = self->aq_hw_ops->hw_ring_tx_head_update(
 							self->aq_hw,
-- 
2.25.1

