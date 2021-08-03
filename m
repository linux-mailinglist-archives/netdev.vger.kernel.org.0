Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26753DF2E5
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236045AbhHCQjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:39:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:62885 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234647AbhHCQiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:38:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="194013707"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="194013707"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:37:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="636665324"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 03 Aug 2021 09:37:33 -0700
Received: from alobakin-mobl.ger.corp.intel.com (eflejszm-mobl2.ger.corp.intel.com [10.213.26.164])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173GahF1029968;
        Tue, 3 Aug 2021 17:37:28 +0100
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
Subject: [PATCH net-next 11/21] ethernet, mvpp2: rename xdp_xmit_err to xdp_xmit_drops
Date:   Tue,  3 Aug 2021 18:36:31 +0200
Message-Id: <20210803163641.3743-12-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803163641.3743-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp_xmit_err stat is defined as num_frames - nxmit in
.ndo_xdp_xmit() callback implementation, and regarding that the
frames which weren't transmitted are treated as drops by BPF core,
give it a more fitting name in preparation for switching to standard
XDP stats.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index b9fbc9f000f2..2be6123be6f3 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1121,7 +1121,7 @@ struct mvpp2_pcpu_stats {
 	u64	xdp_pass;
 	u64	xdp_drop;
 	u64	xdp_xmit;
-	u64	xdp_xmit_err;
+	u64	xdp_xmit_drops;
 	u64	xdp_tx;
 	u64	xdp_tx_err;
 };
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 99bd8b8aa0e2..a3aee1a6d760 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1831,7 +1831,7 @@ enum {
 	ETHTOOL_XDP_TX,
 	ETHTOOL_XDP_TX_ERR,
 	ETHTOOL_XDP_XMIT,
-	ETHTOOL_XDP_XMIT_ERR,
+	ETHTOOL_XDP_XMIT_DROPS,
 };
 
 struct mvpp2_ethtool_counter {
@@ -1933,7 +1933,7 @@ static const struct mvpp2_ethtool_counter mvpp2_ethtool_xdp[] = {
 	{ ETHTOOL_XDP_TX, "rx_xdp_tx", },
 	{ ETHTOOL_XDP_TX_ERR, "rx_xdp_tx_errors", },
 	{ ETHTOOL_XDP_XMIT, "tx_xdp_xmit", },
-	{ ETHTOOL_XDP_XMIT_ERR, "tx_xdp_xmit_errors", },
+	{ ETHTOOL_XDP_XMIT_DROPS, "tx_xdp_xmit_drops", },
 };
 
 #define MVPP2_N_ETHTOOL_STATS(ntxqs, nrxqs)	(ARRAY_SIZE(mvpp2_ethtool_mib_regs) + \
@@ -2000,7 +2000,7 @@ mvpp2_get_xdp_stats(struct mvpp2_port *port, struct mvpp2_pcpu_stats *xdp_stats)
 		u64	xdp_pass;
 		u64	xdp_drop;
 		u64	xdp_xmit;
-		u64	xdp_xmit_err;
+		u64	xdp_xmit_drops;
 		u64	xdp_tx;
 		u64	xdp_tx_err;
 
@@ -2011,7 +2011,7 @@ mvpp2_get_xdp_stats(struct mvpp2_port *port, struct mvpp2_pcpu_stats *xdp_stats)
 			xdp_pass   = cpu_stats->xdp_pass;
 			xdp_drop = cpu_stats->xdp_drop;
 			xdp_xmit   = cpu_stats->xdp_xmit;
-			xdp_xmit_err   = cpu_stats->xdp_xmit_err;
+			xdp_xmit_drops = cpu_stats->xdp_xmit_drops;
 			xdp_tx   = cpu_stats->xdp_tx;
 			xdp_tx_err   = cpu_stats->xdp_tx_err;
 		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
@@ -2020,7 +2020,7 @@ mvpp2_get_xdp_stats(struct mvpp2_port *port, struct mvpp2_pcpu_stats *xdp_stats)
 		xdp_stats->xdp_pass   += xdp_pass;
 		xdp_stats->xdp_drop += xdp_drop;
 		xdp_stats->xdp_xmit   += xdp_xmit;
-		xdp_stats->xdp_xmit_err   += xdp_xmit_err;
+		xdp_stats->xdp_xmit_drops += xdp_xmit_drops;
 		xdp_stats->xdp_tx   += xdp_tx;
 		xdp_stats->xdp_tx_err   += xdp_tx_err;
 	}
@@ -2083,8 +2083,8 @@ static void mvpp2_read_stats(struct mvpp2_port *port)
 		case ETHTOOL_XDP_XMIT:
 			*pstats++ = xdp_stats.xdp_xmit;
 			break;
-		case ETHTOOL_XDP_XMIT_ERR:
-			*pstats++ = xdp_stats.xdp_xmit_err;
+		case ETHTOOL_XDP_XMIT_DROPS:
+			*pstats++ = xdp_stats.xdp_xmit_drops;
 			break;
 		}
 	}
@@ -3773,7 +3773,7 @@ mvpp2_xdp_xmit(struct net_device *dev, int num_frame,
 	stats->tx_bytes += nxmit_byte;
 	stats->tx_packets += nxmit;
 	stats->xdp_xmit += nxmit;
-	stats->xdp_xmit_err += num_frame - nxmit;
+	stats->xdp_xmit_drops += num_frame - nxmit;
 	u64_stats_update_end(&stats->syncp);
 
 	return nxmit;
-- 
2.31.1

