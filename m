Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784403DF2DE
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237221AbhHCQjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:39:14 -0400
Received: from mga06.intel.com ([134.134.136.31]:46659 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234357AbhHCQiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:38:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="274787051"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="274787051"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:38:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="458336256"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 03 Aug 2021 09:37:49 -0700
Received: from alobakin-mobl.ger.corp.intel.com (eflejszm-mobl2.ger.corp.intel.com [10.213.26.164])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173GahF5029968;
        Tue, 3 Aug 2021 17:37:45 +0100
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
Subject: [PATCH net-next 15/21] veth: rename xdp_xmit_errors to xdp_xmit_drops
Date:   Tue,  3 Aug 2021 18:36:35 +0200
Message-Id: <20210803163641.3743-16-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803163641.3743-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

veth keeps tracking of numbers of XDP frames being dropped from
inside of .ndo_xdp_xmit() callback. This counter really should
be named after drops, not errors.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/veth.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 914aebfbe7c4..c5079b9145c9 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -47,7 +47,7 @@ struct veth_stats {
 	u64	xdp_tx;
 	u64	xdp_tx_err;
 	u64	peer_tq_xdp_xmit;
-	u64	peer_tq_xdp_xmit_err;
+	u64	peer_tq_xdp_xmit_drops;
 };
 
 struct veth_rq_stats {
@@ -105,7 +105,7 @@ static const struct veth_q_stat_desc veth_rq_stats_desc[] = {
 
 static const struct veth_q_stat_desc veth_tq_stats_desc[] = {
 	{ "xdp_xmit",		VETH_RQ_STAT(peer_tq_xdp_xmit) },
-	{ "xdp_xmit_errors",	VETH_RQ_STAT(peer_tq_xdp_xmit_err) },
+	{ "xdp_xmit_drops",	VETH_RQ_STAT(peer_tq_xdp_xmit_drops) },
 };
 
 #define VETH_TQ_STATS_LEN	ARRAY_SIZE(veth_tq_stats_desc)
@@ -375,25 +375,25 @@ static void veth_stats_rx(struct veth_stats *result, struct net_device *dev)
 	struct veth_priv *priv = netdev_priv(dev);
 	int i;
 
-	result->peer_tq_xdp_xmit_err = 0;
+	result->peer_tq_xdp_xmit_drops = 0;
 	result->xdp_packets = 0;
 	result->xdp_tx_err = 0;
 	result->xdp_bytes = 0;
 	result->xdp_errors = 0;
 	for (i = 0; i < dev->num_rx_queues; i++) {
-		u64 packets, bytes, xdp_err, xdp_tx_err, peer_tq_xdp_xmit_err;
+		u64 packets, bytes, xdp_err, xdp_tx_err, peer_tq_xdp_xmit_drops;
 		struct veth_rq_stats *stats = &priv->rq[i].stats;
 		unsigned int start;
 
 		do {
 			start = u64_stats_fetch_begin_irq(&stats->syncp);
-			peer_tq_xdp_xmit_err = stats->vs.peer_tq_xdp_xmit_err;
+			peer_tq_xdp_xmit_drops = stats->vs.peer_tq_xdp_xmit_drops;
 			xdp_tx_err = stats->vs.xdp_tx_err;
 			packets = stats->vs.xdp_packets;
 			bytes = stats->vs.xdp_bytes;
 			xdp_err = stats->vs.xdp_errors;
 		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
-		result->peer_tq_xdp_xmit_err += peer_tq_xdp_xmit_err;
+		result->peer_tq_xdp_xmit_drops += peer_tq_xdp_xmit_drops;
 		result->xdp_tx_err += xdp_tx_err;
 		result->xdp_packets += packets;
 		result->xdp_bytes += bytes;
@@ -415,7 +415,7 @@ static void veth_get_stats64(struct net_device *dev,
 
 	veth_stats_rx(&rx, dev);
 	tot->tx_dropped += rx.xdp_tx_err;
-	tot->rx_dropped = rx.xdp_errors + rx.peer_tq_xdp_xmit_err;
+	tot->rx_dropped = rx.xdp_errors + rx.peer_tq_xdp_xmit_drops;
 	tot->rx_bytes = rx.xdp_bytes;
 	tot->rx_packets = rx.xdp_packets;
 
@@ -427,7 +427,7 @@ static void veth_get_stats64(struct net_device *dev,
 		tot->rx_packets += packets;
 
 		veth_stats_rx(&rx, peer);
-		tot->tx_dropped += rx.peer_tq_xdp_xmit_err;
+		tot->tx_dropped += rx.peer_tq_xdp_xmit_drops;
 		tot->rx_dropped += rx.xdp_tx_err;
 		tot->tx_bytes += rx.xdp_bytes;
 		tot->tx_packets += rx.xdp_packets;
@@ -515,7 +515,7 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 	if (ndo_xmit) {
 		u64_stats_update_begin(&rq->stats.syncp);
 		rq->stats.vs.peer_tq_xdp_xmit += nxmit;
-		rq->stats.vs.peer_tq_xdp_xmit_err += n - nxmit;
+		rq->stats.vs.peer_tq_xdp_xmit_drops += n - nxmit;
 		u64_stats_update_end(&rq->stats.syncp);
 	}
 
-- 
2.31.1

