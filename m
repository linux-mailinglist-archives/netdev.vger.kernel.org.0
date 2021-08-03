Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0493A3DF2C8
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbhHCQia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:38:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:29119 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234423AbhHCQhz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:37:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="200922535"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="200922535"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:37:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="419720881"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 03 Aug 2021 09:37:25 -0700
Received: from alobakin-mobl.ger.corp.intel.com (eflejszm-mobl2.ger.corp.intel.com [10.213.26.164])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173GahEx029968;
        Tue, 3 Aug 2021 17:37:20 +0100
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
Subject: [PATCH net-next 09/21] ethernet, mvneta: rename xdp_xmit_err to xdp_xmit_drops
Date:   Tue,  3 Aug 2021 18:36:29 +0200
Message-Id: <20210803163641.3743-10-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803163641.3743-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NETA driver also doesn't separate XDP xmit errors from drops, and in
that case more general "drops" should be used.
Rename the field before converting to standard XDP stats infra.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index ff8db311963c..f030d5b7bdee 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -351,7 +351,7 @@ enum {
 	ETHTOOL_XDP_TX,
 	ETHTOOL_XDP_TX_ERR,
 	ETHTOOL_XDP_XMIT,
-	ETHTOOL_XDP_XMIT_ERR,
+	ETHTOOL_XDP_XMIT_DROPS,
 	ETHTOOL_MAX_STATS,
 };
 
@@ -412,7 +412,7 @@ static const struct mvneta_statistic mvneta_statistics[] = {
 	{ ETHTOOL_XDP_TX, T_SW, "rx_xdp_tx", },
 	{ ETHTOOL_XDP_TX_ERR, T_SW, "rx_xdp_tx_errors", },
 	{ ETHTOOL_XDP_XMIT, T_SW, "tx_xdp_xmit", },
-	{ ETHTOOL_XDP_XMIT_ERR, T_SW, "tx_xdp_xmit_errors", },
+	{ ETHTOOL_XDP_XMIT_DROPS, T_SW, "tx_xdp_xmit_drops", },
 };
 
 struct mvneta_stats {
@@ -425,7 +425,7 @@ struct mvneta_stats {
 	u64	xdp_pass;
 	u64	xdp_drop;
 	u64	xdp_xmit;
-	u64	xdp_xmit_err;
+	u64	xdp_xmit_drops;
 	u64	xdp_tx;
 	u64	xdp_tx_err;
 };
@@ -2166,7 +2166,7 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
 	stats->es.ps.tx_bytes += nxmit_byte;
 	stats->es.ps.tx_packets += nxmit;
 	stats->es.ps.xdp_xmit += nxmit;
-	stats->es.ps.xdp_xmit_err += num_frame - nxmit;
+	stats->es.ps.xdp_xmit_drops += num_frame - nxmit;
 	u64_stats_update_end(&stats->syncp);
 
 	return nxmit;
@@ -4630,9 +4630,9 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
 	for_each_possible_cpu(cpu) {
 		struct mvneta_pcpu_stats *stats;
 		u64 skb_alloc_error;
+		u64 xdp_xmit_drops;
 		u64 refill_error;
 		u64 xdp_redirect;
-		u64 xdp_xmit_err;
 		u64 xdp_tx_err;
 		u64 xdp_pass;
 		u64 xdp_drop;
@@ -4648,7 +4648,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
 			xdp_pass = stats->es.ps.xdp_pass;
 			xdp_drop = stats->es.ps.xdp_drop;
 			xdp_xmit = stats->es.ps.xdp_xmit;
-			xdp_xmit_err = stats->es.ps.xdp_xmit_err;
+			xdp_xmit_drops = stats->es.ps.xdp_xmit_drops;
 			xdp_tx = stats->es.ps.xdp_tx;
 			xdp_tx_err = stats->es.ps.xdp_tx_err;
 		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
@@ -4659,7 +4659,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
 		es->ps.xdp_pass += xdp_pass;
 		es->ps.xdp_drop += xdp_drop;
 		es->ps.xdp_xmit += xdp_xmit;
-		es->ps.xdp_xmit_err += xdp_xmit_err;
+		es->ps.xdp_xmit_drops += xdp_xmit_drops;
 		es->ps.xdp_tx += xdp_tx;
 		es->ps.xdp_tx_err += xdp_tx_err;
 	}
@@ -4720,8 +4720,8 @@ static void mvneta_ethtool_update_stats(struct mvneta_port *pp)
 			case ETHTOOL_XDP_XMIT:
 				pp->ethtool_stats[i] = stats.ps.xdp_xmit;
 				break;
-			case ETHTOOL_XDP_XMIT_ERR:
-				pp->ethtool_stats[i] = stats.ps.xdp_xmit_err;
+			case ETHTOOL_XDP_XMIT_DROPS:
+				pp->ethtool_stats[i] = stats.ps.xdp_xmit_drops;
 				break;
 			}
 			break;
-- 
2.31.1

