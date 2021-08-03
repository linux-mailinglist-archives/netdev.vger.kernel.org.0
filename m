Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309823DF2E3
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbhHCQjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:39:22 -0400
Received: from mga06.intel.com ([134.134.136.31]:46653 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234579AbhHCQiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:38:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="274787025"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="274787025"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:37:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="636665396"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 03 Aug 2021 09:37:45 -0700
Received: from alobakin-mobl.ger.corp.intel.com (eflejszm-mobl2.ger.corp.intel.com [10.213.26.164])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173GahF4029968;
        Tue, 3 Aug 2021 17:37:40 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net-next 14/21] veth: rename rx_drops to xdp_errors
Date:   Tue,  3 Aug 2021 18:36:34 +0200
Message-Id: <20210803163641.3743-15-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803163641.3743-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rx_drops field stores the number of errors occurred on XDP path, such
as XDP_TX or XDP_REDIRECT non-zero return codes. There are no stores
of this field outside XDP code.
Give it a more fitting name which also aligns well with the standard
XDP stats.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/veth.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 50eb43e5bf45..914aebfbe7c4 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -38,10 +38,10 @@
 #define VETH_XDP_BATCH		16
 
 struct veth_stats {
-	u64	rx_drops;
 	/* xdp */
 	u64	xdp_packets;
 	u64	xdp_bytes;
+	u64	xdp_errors;
 	u64	xdp_redirect;
 	u64	xdp_drops;
 	u64	xdp_tx;
@@ -94,7 +94,7 @@ struct veth_q_stat_desc {
 static const struct veth_q_stat_desc veth_rq_stats_desc[] = {
 	{ "xdp_packets",	VETH_RQ_STAT(xdp_packets) },
 	{ "xdp_bytes",		VETH_RQ_STAT(xdp_bytes) },
-	{ "drops",		VETH_RQ_STAT(rx_drops) },
+	{ "xdp_errors",		VETH_RQ_STAT(xdp_errors) },
 	{ "xdp_redirect",	VETH_RQ_STAT(xdp_redirect) },
 	{ "xdp_drops",		VETH_RQ_STAT(xdp_drops) },
 	{ "xdp_tx",		VETH_RQ_STAT(xdp_tx) },
@@ -379,9 +379,9 @@ static void veth_stats_rx(struct veth_stats *result, struct net_device *dev)
 	result->xdp_packets = 0;
 	result->xdp_tx_err = 0;
 	result->xdp_bytes = 0;
-	result->rx_drops = 0;
+	result->xdp_errors = 0;
 	for (i = 0; i < dev->num_rx_queues; i++) {
-		u64 packets, bytes, drops, xdp_tx_err, peer_tq_xdp_xmit_err;
+		u64 packets, bytes, xdp_err, xdp_tx_err, peer_tq_xdp_xmit_err;
 		struct veth_rq_stats *stats = &priv->rq[i].stats;
 		unsigned int start;
 
@@ -391,13 +391,13 @@ static void veth_stats_rx(struct veth_stats *result, struct net_device *dev)
 			xdp_tx_err = stats->vs.xdp_tx_err;
 			packets = stats->vs.xdp_packets;
 			bytes = stats->vs.xdp_bytes;
-			drops = stats->vs.rx_drops;
+			xdp_err = stats->vs.xdp_errors;
 		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
 		result->peer_tq_xdp_xmit_err += peer_tq_xdp_xmit_err;
 		result->xdp_tx_err += xdp_tx_err;
 		result->xdp_packets += packets;
 		result->xdp_bytes += bytes;
-		result->rx_drops += drops;
+		result->xdp_errors += xdp_err;
 	}
 }
 
@@ -415,7 +415,7 @@ static void veth_get_stats64(struct net_device *dev,
 
 	veth_stats_rx(&rx, dev);
 	tot->tx_dropped += rx.xdp_tx_err;
-	tot->rx_dropped = rx.rx_drops + rx.peer_tq_xdp_xmit_err;
+	tot->rx_dropped = rx.xdp_errors + rx.peer_tq_xdp_xmit_err;
 	tot->rx_bytes = rx.xdp_bytes;
 	tot->rx_packets = rx.xdp_packets;
 
@@ -633,7 +633,7 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
 			if (unlikely(veth_xdp_tx(rq, &xdp, bq) < 0)) {
 				trace_xdp_exception(rq->dev, xdp_prog, act);
 				frame = &orig_frame;
-				stats->rx_drops++;
+				stats->xdp_errors++;
 				goto err_xdp;
 			}
 			stats->xdp_tx++;
@@ -644,7 +644,7 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
 			xdp.rxq->mem = frame->mem;
 			if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
 				frame = &orig_frame;
-				stats->rx_drops++;
+				stats->xdp_errors++;
 				goto err_xdp;
 			}
 			stats->xdp_redirect++;
@@ -683,7 +683,7 @@ static void veth_xdp_rcv_bulk_skb(struct veth_rq *rq, void **frames,
 			       GFP_ATOMIC | __GFP_ZERO) < 0) {
 		for (i = 0; i < n_xdpf; i++)
 			xdp_return_frame(frames[i]);
-		stats->rx_drops += n_xdpf;
+		stats->xdp_errors += n_xdpf;
 
 		return;
 	}
@@ -695,7 +695,7 @@ static void veth_xdp_rcv_bulk_skb(struct veth_rq *rq, void **frames,
 						 rq->dev);
 		if (!skb) {
 			xdp_return_frame(frames[i]);
-			stats->rx_drops++;
+			stats->xdp_errors++;
 			continue;
 		}
 		napi_gro_receive(&rq->xdp_napi, skb);
@@ -783,7 +783,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 		xdp.rxq->mem = rq->xdp_mem;
 		if (unlikely(veth_xdp_tx(rq, &xdp, bq) < 0)) {
 			trace_xdp_exception(rq->dev, xdp_prog, act);
-			stats->rx_drops++;
+			stats->xdp_errors++;
 			goto err_xdp;
 		}
 		stats->xdp_tx++;
@@ -794,7 +794,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 		consume_skb(skb);
 		xdp.rxq->mem = rq->xdp_mem;
 		if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
-			stats->rx_drops++;
+			stats->xdp_errors++;
 			goto err_xdp;
 		}
 		stats->xdp_redirect++;
@@ -833,7 +833,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 out:
 	return skb;
 drop:
-	stats->rx_drops++;
+	stats->xdp_errors++;
 xdp_drop:
 	rcu_read_unlock();
 	kfree_skb(skb);
@@ -892,7 +892,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 	rq->stats.vs.xdp_redirect += stats->xdp_redirect;
 	rq->stats.vs.xdp_bytes += stats->xdp_bytes;
 	rq->stats.vs.xdp_drops += stats->xdp_drops;
-	rq->stats.vs.rx_drops += stats->rx_drops;
+	rq->stats.vs.xdp_errors += stats->xdp_errors;
 	rq->stats.vs.xdp_packets += done;
 	u64_stats_update_end(&rq->stats.syncp);
 
-- 
2.31.1

