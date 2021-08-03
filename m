Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F40E3DF2E1
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbhHCQjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:39:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:42216 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234681AbhHCQiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:38:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="299318827"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="299318827"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:38:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="511394862"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Aug 2021 09:37:53 -0700
Received: from alobakin-mobl.ger.corp.intel.com (eflejszm-mobl2.ger.corp.intel.com [10.213.26.164])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173GahF6029968;
        Tue, 3 Aug 2021 17:37:49 +0100
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
Subject: [PATCH net-next 16/21] veth: rename drop xdp_ suffix from packets and bytes stats
Date:   Tue,  3 Aug 2021 18:36:36 +0200
Message-Id: <20210803163641.3743-17-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803163641.3743-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

They get updated not only on XDP path. Moreover, packet counter
stores the total number of frames, not only the ones passed to
bpf_prog_run_xdp(), so it's rather confusing.
Drop the xdp_ suffix from both of them to not mix XDP-only stats
with the general ones.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/veth.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index c5079b9145c9..d7e95f09e19d 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -38,9 +38,9 @@
 #define VETH_XDP_BATCH		16
 
 struct veth_stats {
+	u64	packets;
+	u64	bytes;
 	/* xdp */
-	u64	xdp_packets;
-	u64	xdp_bytes;
 	u64	xdp_errors;
 	u64	xdp_redirect;
 	u64	xdp_drops;
@@ -92,8 +92,8 @@ struct veth_q_stat_desc {
 #define VETH_RQ_STAT(m)	offsetof(struct veth_stats, m)
 
 static const struct veth_q_stat_desc veth_rq_stats_desc[] = {
-	{ "xdp_packets",	VETH_RQ_STAT(xdp_packets) },
-	{ "xdp_bytes",		VETH_RQ_STAT(xdp_bytes) },
+	{ "packets",		VETH_RQ_STAT(packets) },
+	{ "bytes",		VETH_RQ_STAT(bytes) },
 	{ "xdp_errors",		VETH_RQ_STAT(xdp_errors) },
 	{ "xdp_redirect",	VETH_RQ_STAT(xdp_redirect) },
 	{ "xdp_drops",		VETH_RQ_STAT(xdp_drops) },
@@ -376,9 +376,9 @@ static void veth_stats_rx(struct veth_stats *result, struct net_device *dev)
 	int i;
 
 	result->peer_tq_xdp_xmit_drops = 0;
-	result->xdp_packets = 0;
+	result->packets = 0;
 	result->xdp_tx_err = 0;
-	result->xdp_bytes = 0;
+	result->bytes = 0;
 	result->xdp_errors = 0;
 	for (i = 0; i < dev->num_rx_queues; i++) {
 		u64 packets, bytes, xdp_err, xdp_tx_err, peer_tq_xdp_xmit_drops;
@@ -389,14 +389,14 @@ static void veth_stats_rx(struct veth_stats *result, struct net_device *dev)
 			start = u64_stats_fetch_begin_irq(&stats->syncp);
 			peer_tq_xdp_xmit_drops = stats->vs.peer_tq_xdp_xmit_drops;
 			xdp_tx_err = stats->vs.xdp_tx_err;
-			packets = stats->vs.xdp_packets;
-			bytes = stats->vs.xdp_bytes;
+			packets = stats->vs.packets;
+			bytes = stats->vs.bytes;
 			xdp_err = stats->vs.xdp_errors;
 		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
 		result->peer_tq_xdp_xmit_drops += peer_tq_xdp_xmit_drops;
 		result->xdp_tx_err += xdp_tx_err;
-		result->xdp_packets += packets;
-		result->xdp_bytes += bytes;
+		result->packets += packets;
+		result->bytes += bytes;
 		result->xdp_errors += xdp_err;
 	}
 }
@@ -416,8 +416,8 @@ static void veth_get_stats64(struct net_device *dev,
 	veth_stats_rx(&rx, dev);
 	tot->tx_dropped += rx.xdp_tx_err;
 	tot->rx_dropped = rx.xdp_errors + rx.peer_tq_xdp_xmit_drops;
-	tot->rx_bytes = rx.xdp_bytes;
-	tot->rx_packets = rx.xdp_packets;
+	tot->rx_bytes = rx.bytes;
+	tot->rx_packets = rx.packets;
 
 	rcu_read_lock();
 	peer = rcu_dereference(priv->peer);
@@ -429,8 +429,8 @@ static void veth_get_stats64(struct net_device *dev,
 		veth_stats_rx(&rx, peer);
 		tot->tx_dropped += rx.peer_tq_xdp_xmit_drops;
 		tot->rx_dropped += rx.xdp_tx_err;
-		tot->tx_bytes += rx.xdp_bytes;
-		tot->tx_packets += rx.xdp_packets;
+		tot->tx_bytes += rx.bytes;
+		tot->tx_packets += rx.packets;
 	}
 	rcu_read_unlock();
 }
@@ -862,7 +862,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 			/* ndo_xdp_xmit */
 			struct xdp_frame *frame = veth_ptr_to_xdp(ptr);
 
-			stats->xdp_bytes += frame->len;
+			stats->bytes += frame->len;
 			frame = veth_xdp_rcv_one(rq, frame, bq, stats);
 			if (frame) {
 				/* XDP_PASS */
@@ -877,7 +877,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 			/* ndo_start_xmit */
 			struct sk_buff *skb = ptr;
 
-			stats->xdp_bytes += skb->len;
+			stats->bytes += skb->len;
 			skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
 			if (skb)
 				napi_gro_receive(&rq->xdp_napi, skb);
@@ -890,10 +890,10 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 
 	u64_stats_update_begin(&rq->stats.syncp);
 	rq->stats.vs.xdp_redirect += stats->xdp_redirect;
-	rq->stats.vs.xdp_bytes += stats->xdp_bytes;
+	rq->stats.vs.bytes += stats->bytes;
 	rq->stats.vs.xdp_drops += stats->xdp_drops;
 	rq->stats.vs.xdp_errors += stats->xdp_errors;
-	rq->stats.vs.xdp_packets += done;
+	rq->stats.vs.packets += done;
 	u64_stats_update_end(&rq->stats.syncp);
 
 	return done;
-- 
2.31.1

