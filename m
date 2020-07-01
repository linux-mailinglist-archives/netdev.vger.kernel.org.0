Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E6B210F52
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731870AbgGAPax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:30:53 -0400
Received: from mail-eopbgr70117.outbound.protection.outlook.com ([40.107.7.117]:46462
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731658AbgGAPaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 11:30:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bx09qmKYMh35vzNvRoV/jKLHH9WSZWdN7SrdSllOSSAcg8SJ1MUGPBZ1W3n6UC+Eag9392HY4swkLmSzqCja1tJyAEgx2QfBrWhVdX4S7tgoVdHVaFVCIwZAmWU7/XHnLB4M6EN+3c9BpaaV9MwaBLK+z1Q5k3Lu3FgpmyTfkEQFhVEYCmUC4apIEd8IT17/ew7mZpV9zhXNcBrChn0/vjfONcNSSbSsqLG8AJEHOB7vjZHvDeTB1YBnGQo6jV+59Wrlh8VRPonFdYA8BrXwBDA/rvp4BCrGkFkTGC8VsOEOi0bCtTsHHLWh4nk4UIZy0oFeHgN3WTOMoAV1c7u50g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/jpRZUYXpf4ovQPlLa/9+ZwWyvLeGdXciryWzo3VPE=;
 b=Y2VtHJOmGInFBJHUxcvk5DyoM1j6hSMLqi5OstKNDC+rkMVsYDdfu6wEqmM7gatdpfNfhgzMKYxKxuRgvB/Q4OA/7+R9Kq3sBR+R6BGeDhh14Knh2um82lNiTyXKCDvQr3iYN3Wd5Es7KAc+ajz53hp3kZKSnnM1t62gmG56rm9HfCl/xZXkX2dS4F6AY8lzwpLPLBGee48ETKaViik8ezCUf3JajxdUAbzVpxzeotaVCS0Cb1hp9V31aC3UQK4rUUzCioXSX7AtQ88Voq7YC5NDuaY/1Nrl/EwXaGUwFIJ7AtphiBRmJgK+Mn2uwWbGJqpGtx0GW9PMDZgdkTFlpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/jpRZUYXpf4ovQPlLa/9+ZwWyvLeGdXciryWzo3VPE=;
 b=VLuBWtrjpucoqnZoVjllMIbhwWGpcTiwyWnoemD8C47DIQuMlMa74KTT0A0n+0C+ZggrDcBiWGW5uZrczwaanN//lKkTJBQDeRxjcQSe0V+ByRDeivcRHO96fopJ5ZgkVjE/36YgBppYz0ax2Zb/3KdpX8Fh8KTaEYrRWfIzOhk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM0PR05MB6484.eurprd05.prod.outlook.com
 (2603:10a6:208:143::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Wed, 1 Jul
 2020 15:30:46 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3153.022; Wed, 1 Jul 2020
 15:30:46 +0000
Date:   Wed, 1 Jul 2020 17:30:44 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     netdev@vger.kernel.org
Cc:     mcroce@linux.microsoft.com, lorenzo@kernel.org,
        davem@davemloft.net, brouer@redhat.com, stefanc@marvell.com,
        mw@semihalf.com, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com
Subject: [PATCH 1/1] mvpp2: xdp ethtool stats
Message-ID: <20200701153044.qlzcnh7ve56o2ata@SvensMacBookAir.sven.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AM0PR03CA0025.eurprd03.prod.outlook.com
 (2603:10a6:208:14::38) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (109.193.235.168) by AM0PR03CA0025.eurprd03.prod.outlook.com (2603:10a6:208:14::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Wed, 1 Jul 2020 15:30:45 +0000
X-Originating-IP: [109.193.235.168]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2970f488-bc0e-452d-a2af-08d81dd3b962
X-MS-TrafficTypeDiagnostic: AM0PR05MB6484:
X-Microsoft-Antispam-PRVS: <AM0PR05MB648472844F4F6C008FC4171AEF6C0@AM0PR05MB6484.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:238;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oth6+cj4M4AxQa5C0lxIrzmkDGnYS3BdLrBiiA+zLv/DGRMFpTxHs1zWvh+7/r27X8R0x5GDFl1BwBiVU6j0Y3q2vNZIfFmybpT7HIA1zFIQy4VtDnE6JpOVzbjBTFoG1HVHZrLCY4eRa1fNdpevDDtnsy9RZft3EhIEI0l29tSHvp9rWROv9d69/dqLa9MKRCmlg60nDr6edPDnHW9LlfH9JP2nxgoDs6Vtenum0Qm3omP7Fq2c6DYQyG+7idR7nZ/QYat4DpRmzE+6Jbvm7HhumDuklwWJglBnzi018E/gk2OskIq2NBUFR+sek4CT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39830400003)(346002)(136003)(366004)(376002)(52116002)(7696005)(6506007)(66946007)(83380400001)(66556008)(66476007)(8936002)(6916009)(508600001)(956004)(16526019)(7416002)(26005)(44832011)(8676002)(316002)(186003)(2906002)(55016002)(1076003)(4326008)(5660300002)(86362001)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: pQIUFyKqISpHIY5K3iwBfYNfhfchJUfqNgK3kYJP9f7ylCtPHz+4uuj8GZ+rENWmP7KbWc8MuC7XMRbhkOxnEB+mnFrDiZFVnla3MPykhrjMjoIVSKnWIcRzYrLluWctDXK+IQcqKnZs/q/53ycesRorTukbeaB1k6sFQzwkjHapcUjq5vEUuRjK/RNiMnzQ4Kgd5ZabHRDXxEFCo7ZgCrGkqcCxP6zZKUqD0kgiMOxZhH4Lo6Lazkfj65Hr1e8JzZlZ/iO1MajNy60Xp4DO/gBWdarH7y9VWwyJw3dz/fgJbOvsoVRUap/TWCXiLv0UaDqfbybTFoQvzJvSQhw+ANuQzN2iAVY1I9PJfZSHN1Io5KB7bJSCJ8EQ4QCBm0ByawOWyfIWjoFOVIEJ16M4IAnbTIxpHPX1jd0xysrdPv1HMCqdKcBy3Ldpx8BkhQkjoftRi04pl7cQHRlo4mEwgg0C1Tt8RgC+4zgU2BcNp9RApXmZkSXhpNfkrRWQpCI9
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 2970f488-bc0e-452d-a2af-08d81dd3b962
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0501MB2785.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 15:30:46.0408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y9+qEhYBzMQxXV7GfKgpxFHWA+D1ApjPf+9783Ibf4xBqU1bkYXbhHXAQeQ2vos5SQH2UH3fLJsKyq0slJPQFvOwEkqhIIDYy8pkrM8ocBE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6484
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ethtool statistics for XDP.
This patch is a follow up for the mvpp2 XDP patch
upstreamed yesterday.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |   8 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 148 +++++++++++++++---
 2 files changed, 138 insertions(+), 18 deletions(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -846,6 +846,14 @@
 	u64	rx_bytes;
 	u64	tx_packets;
 	u64	tx_bytes;
+	/* xdp */
+	u64	xdp_redirect;
+	u64	xdp_pass;
+	u64	xdp_drop;
+	u64	xdp_xmit;
+	u64	xdp_xmit_err;
+	u64	xdp_tx;
+	u64	xdp_tx_err;
 };
 
 /* Per-CPU port control */
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1464,6 +1464,16 @@
 	writel(val, port->base + MVPP2_GMAC_CTRL_1_REG);
 }
 
+enum {
+	ETHTOOL_XDP_REDIRECT,
+	ETHTOOL_XDP_PASS,
+	ETHTOOL_XDP_DROP,
+	ETHTOOL_XDP_TX,
+	ETHTOOL_XDP_TX_ERR,
+	ETHTOOL_XDP_XMIT,
+	ETHTOOL_XDP_XMIT_ERR,
+};
+
 struct mvpp2_ethtool_counter {
 	unsigned int offset;
 	const char string[ETH_GSTRING_LEN];
@@ -1556,10 +1566,21 @@
 	{ MVPP2_RX_PKTS_BM_DROP_CTR, "rxq_%d_packets_bm_drops" },
 };
 
+static const struct mvpp2_ethtool_counter mvpp2_ethtool_xdp[] = {
+	{ ETHTOOL_XDP_REDIRECT, "rx_xdp_redirect", },
+	{ ETHTOOL_XDP_PASS, "rx_xdp_pass", },
+	{ ETHTOOL_XDP_DROP, "rx_xdp_drop", },
+	{ ETHTOOL_XDP_TX, "rx_xdp_tx", },
+	{ ETHTOOL_XDP_TX_ERR, "rx_xdp_tx_errors", },
+	{ ETHTOOL_XDP_XMIT, "tx_xdp_xmit", },
+	{ ETHTOOL_XDP_XMIT_ERR, "tx_xdp_xmit_errors", },
+};
+
 #define MVPP2_N_ETHTOOL_STATS(ntxqs, nrxqs)	(ARRAY_SIZE(mvpp2_ethtool_mib_regs) + \
 						 ARRAY_SIZE(mvpp2_ethtool_port_regs) + \
 						 (ARRAY_SIZE(mvpp2_ethtool_txq_regs) * (ntxqs)) + \
-						 (ARRAY_SIZE(mvpp2_ethtool_rxq_regs) * (nrxqs)))
+						 (ARRAY_SIZE(mvpp2_ethtool_rxq_regs) * (nrxqs)) + \
+						 ARRAY_SIZE(mvpp2_ethtool_xdp))
 
 static void mvpp2_ethtool_get_strings(struct net_device *netdev, u32 sset,
 				      u8 *data)
@@ -1598,11 +1619,58 @@
 			data += ETH_GSTRING_LEN;
 		}
 	}
+
+	for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_xdp); i++) {
+		strscpy(data, mvpp2_ethtool_xdp[i].string,
+			ETH_GSTRING_LEN);
+		data += ETH_GSTRING_LEN;
+	}
+}
+
+static void
+mvpp2_get_xdp_stats(struct mvpp2_port *port, struct mvpp2_pcpu_stats *xdp_stats)
+{
+	unsigned int start;
+	unsigned int cpu;
+
+	/* Gather XDP Statistics */
+	for_each_possible_cpu(cpu) {
+		struct mvpp2_pcpu_stats *cpu_stats;
+		u64	xdp_redirect;
+		u64	xdp_pass;
+		u64	xdp_drop;
+		u64	xdp_xmit;
+		u64	xdp_xmit_err;
+		u64	xdp_tx;
+		u64	xdp_tx_err;
+
+		cpu_stats = per_cpu_ptr(port->stats, cpu);
+		do {
+			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			xdp_redirect = cpu_stats->xdp_redirect;
+			xdp_pass   = cpu_stats->xdp_pass;
+			xdp_drop = cpu_stats->xdp_drop;
+			xdp_xmit   = cpu_stats->xdp_xmit;
+			xdp_xmit_err   = cpu_stats->xdp_xmit_err;
+			xdp_tx   = cpu_stats->xdp_tx;
+			xdp_tx_err   = cpu_stats->xdp_tx_err;
+		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+
+		xdp_stats->xdp_redirect += xdp_redirect;
+		xdp_stats->xdp_pass   += xdp_pass;
+		xdp_stats->xdp_drop += xdp_drop;
+		xdp_stats->xdp_xmit   += xdp_xmit;
+		xdp_stats->xdp_xmit_err   += xdp_xmit_err;
+		xdp_stats->xdp_tx   += xdp_tx;
+		xdp_stats->xdp_tx_err   += xdp_tx_err;
+	}
 }
 
 static void mvpp2_read_stats(struct mvpp2_port *port)
 {
 	u64 *pstats;
+	const struct mvpp2_ethtool_counter *s;
+	struct mvpp2_pcpu_stats xdp_stats = {};
 	int i, q;
 
 	pstats = port->ethtool_stats;
@@ -1629,6 +1697,37 @@
 			*pstats++ += mvpp2_read_index(port->priv,
 						      port->first_rxq + q,
 						      mvpp2_ethtool_rxq_regs[i].offset);
+
+	/* Gather XDP Statistics */
+	mvpp2_get_xdp_stats(port, &xdp_stats);
+
+	for (i = 0, s = mvpp2_ethtool_xdp;
+		 s < mvpp2_ethtool_xdp + ARRAY_SIZE(mvpp2_ethtool_xdp);
+	     s++, i++) {
+		switch (s->offset) {
+		case ETHTOOL_XDP_REDIRECT:
+			*pstats++ = xdp_stats.xdp_redirect;
+			break;
+		case ETHTOOL_XDP_PASS:
+			*pstats++ = xdp_stats.xdp_pass;
+			break;
+		case ETHTOOL_XDP_DROP:
+			*pstats++ = xdp_stats.xdp_drop;
+			break;
+		case ETHTOOL_XDP_TX:
+			*pstats++ = xdp_stats.xdp_tx;
+			break;
+		case ETHTOOL_XDP_TX_ERR:
+			*pstats++ = xdp_stats.xdp_tx_err;
+			break;
+		case ETHTOOL_XDP_XMIT:
+			*pstats++ = xdp_stats.xdp_xmit;
+			break;
+		case ETHTOOL_XDP_XMIT_ERR:
+			*pstats++ = xdp_stats.xdp_xmit_err;
+			break;
+		}
+	}
 }
 
 static void mvpp2_gather_hw_statistics(struct work_struct *work)
@@ -3041,7 +3140,6 @@
 static void mvpp2_xdp_finish_tx(struct mvpp2_port *port, u16 txq_id, int nxmit, int nxmit_byte)
 {
 	unsigned int thread = mvpp2_cpu_to_thread(port->priv, smp_processor_id());
-	struct mvpp2_pcpu_stats *stats = per_cpu_ptr(port->stats, thread);
 	struct mvpp2_tx_queue *aggr_txq;
 	struct mvpp2_txq_pcpu *txq_pcpu;
 	struct mvpp2_tx_queue *txq;
@@ -3063,11 +3161,6 @@
 	if (txq_pcpu->count >= txq_pcpu->stop_threshold)
 		netif_tx_stop_queue(nq);
 
-	u64_stats_update_begin(&stats->syncp);
-	stats->tx_bytes += nxmit_byte;
-	stats->tx_packets += nxmit;
-	u64_stats_update_end(&stats->syncp);
-
 	/* Finalize TX processing */
 	if (!port->has_tx_irqs && txq_pcpu->count >= txq->done_pkts_coal)
 		mvpp2_txq_done(port, txq, txq_pcpu);
@@ -3144,6 +3237,7 @@
 	struct xdp_frame *xdpf;
 	u16 txq_id;
 	int ret;
+	struct mvpp2_pcpu_stats *stats = this_cpu_ptr(port->stats);
 
 	xdpf = xdp_convert_buff_to_frame(xdp);
 	if (unlikely(!xdpf))
@@ -3155,8 +3249,19 @@
 	txq_id = mvpp2_cpu_to_thread(port->priv, smp_processor_id()) + (port->ntxqs / 2);
 
 	ret = mvpp2_xdp_submit_frame(port, txq_id, xdpf, false);
-	if (ret == MVPP2_XDP_TX)
+	if (ret == MVPP2_XDP_TX) {
+		u64_stats_update_begin(&stats->syncp);
+		stats->tx_bytes += xdpf->len;
+		stats->tx_packets++;
+		stats->xdp_tx++;
+		u64_stats_update_end(&stats->syncp);
+
 		mvpp2_xdp_finish_tx(port, txq_id, 1, xdpf->len);
+	} else {
+		u64_stats_update_begin(&stats->syncp);
+		stats->xdp_tx_err++;
+		u64_stats_update_end(&stats->syncp);
+	}
 
 	return ret;
 }
@@ -3166,6 +3271,7 @@
 	       struct xdp_frame **frames, u32 flags)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
+	struct mvpp2_pcpu_stats *stats = this_cpu_ptr(port->stats);
 	int i, nxmit_byte = 0, nxmit = num_frame;
 	u32 ret;
 	u16 txq_id;
@@ -3191,16 +3297,23 @@
 		}
 	}
 
-	if (nxmit > 0)
+	if (likely(nxmit > 0))
 		mvpp2_xdp_finish_tx(port, txq_id, nxmit, nxmit_byte);
 
+	u64_stats_update_begin(&stats->syncp);
+	stats->tx_bytes += nxmit_byte;
+	stats->tx_packets += nxmit;
+	stats->xdp_xmit += nxmit;
+	stats->xdp_xmit_err += num_frame - nxmit;
+	u64_stats_update_end(&stats->syncp);
+
 	return nxmit;
 }
 
 static int
 mvpp2_run_xdp(struct mvpp2_port *port, struct mvpp2_rx_queue *rxq,
 	      struct bpf_prog *prog, struct xdp_buff *xdp,
-	      struct page_pool *pp)
+	      struct page_pool *pp, struct mvpp2_pcpu_stats *stats)
 {
 	unsigned int len, sync, err;
 	struct page *page;
@@ -3215,6 +3328,7 @@
 
 	switch (act) {
 	case XDP_PASS:
+		stats->xdp_pass++;
 		ret = MVPP2_XDP_PASS;
 		break;
 	case XDP_REDIRECT:
@@ -3225,6 +3339,7 @@
 			page_pool_put_page(pp, page, sync, true);
 		} else {
 			ret = MVPP2_XDP_REDIR;
+			stats->xdp_redirect++;
 		}
 		break;
 	case XDP_TX:
@@ -3244,6 +3359,7 @@
 		page = virt_to_head_page(xdp->data);
 		page_pool_put_page(pp, page, sync, true);
 		ret = MVPP2_XDP_DROPPED;
+		stats->xdp_drop++;
 		break;
 	}
 
@@ -3258,11 +3374,10 @@
 	enum dma_data_direction dma_dir;
 	struct bpf_prog *xdp_prog;
 	struct xdp_buff xdp;
+	struct mvpp2_pcpu_stats ps = {};
 	int rx_received;
 	int rx_done = 0;
 	u32 xdp_ret = 0;
-	u32 rcvd_pkts = 0;
-	u32 rcvd_bytes = 0;
 
 	rcu_read_lock();
 
@@ -3337,7 +3452,7 @@
 
 			xdp_set_data_meta_invalid(&xdp);
 
-			ret = mvpp2_run_xdp(port, rxq, xdp_prog, &xdp, pp);
+			ret = mvpp2_run_xdp(port, rxq, xdp_prog, &xdp, pp, &ps);
 
 			if (ret) {
 				xdp_ret |= ret;
@@ -3347,6 +3462,8 @@
 					goto err_drop_frame;
 				}
 
+				ps.rx_packets++;
+				ps.rx_bytes += rx_bytes;
 				continue;
 			}
 		}
@@ -3370,8 +3487,8 @@
 					       bm_pool->buf_size, DMA_FROM_DEVICE,
 					       DMA_ATTR_SKIP_CPU_SYNC);
 
-		rcvd_pkts++;
-		rcvd_bytes += rx_bytes;
+		ps.rx_packets++;
+		ps.rx_bytes += rx_bytes;
 
 		skb_reserve(skb, MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM);
 		skb_put(skb, rx_bytes);
@@ -3393,12 +3510,16 @@
 	if (xdp_ret & MVPP2_XDP_REDIR)
 		xdp_do_flush_map();
 
-	if (rcvd_pkts) {
+	if (ps.rx_packets) {
 		struct mvpp2_pcpu_stats *stats = this_cpu_ptr(port->stats);
 
 		u64_stats_update_begin(&stats->syncp);
-		stats->rx_packets += rcvd_pkts;
-		stats->rx_bytes   += rcvd_bytes;
+		stats->rx_packets += ps.rx_packets;
+		stats->rx_bytes   += ps.rx_bytes;
+		/* xdp */
+		stats->xdp_redirect += ps.xdp_redirect;
+		stats->xdp_pass += ps.xdp_pass;
+		stats->xdp_drop += ps.xdp_drop;
 		u64_stats_update_end(&stats->syncp);
 	}
 
-- 
2.20.1
