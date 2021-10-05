Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03964224A1
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbhJELJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:09:19 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:50357 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234396AbhJELJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 07:09:11 -0400
X-IronPort-AV: E=Sophos;i="5.85,348,1624287600"; 
   d="scan'208";a="96017457"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 05 Oct 2021 20:07:20 +0900
Received: from localhost.localdomain (unknown [10.226.93.104])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 3419740078B9;
        Tue,  5 Oct 2021 20:07:17 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [RFC 09/12] ravb: Add support to retrieve stats for GbEthernet
Date:   Tue,  5 Oct 2021 12:06:39 +0100
Message-Id: <20211005110642.3744-10-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for retrieving stats information for GbEthernet.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
RFC changes:
 * New patch.
---
 drivers/net/ethernet/renesas/ravb_main.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index c057de81ec58..e2238cea9f3e 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1515,6 +1515,24 @@ static void ravb_set_msglevel(struct net_device *ndev, u32 value)
 	priv->msg_enable = value;
 }
 
+static const char ravb_gstrings_stats_gbeth[][ETH_GSTRING_LEN] = {
+	"rx_queue_0_current",
+	"tx_queue_0_current",
+	"rx_queue_0_dirty",
+	"tx_queue_0_dirty",
+	"rx_queue_0_packets",
+	"tx_queue_0_packets",
+	"rx_queue_0_bytes",
+	"tx_queue_0_bytes",
+	"rx_queue_0_mcast_packets",
+	"rx_queue_0_errors",
+	"rx_queue_0_crc_errors",
+	"rx_queue_0_frame_errors",
+	"rx_queue_0_length_errors",
+	"rx_queue_0_csum_offload_errors",
+	"rx_queue_0_over_errors",
+};
+
 static const char ravb_gstrings_stats[][ETH_GSTRING_LEN] = {
 	"rx_queue_0_current",
 	"tx_queue_0_current",
@@ -2492,6 +2510,9 @@ static const struct ravb_hw_info gbeth_hw_info = {
 	.dmac_init = ravb_dmac_init_gbeth,
 	.emac_init = ravb_emac_init_gbeth,
 	.net_hw_features = (NETIF_F_HW_CSUM | NETIF_F_RXCSUM),
+	.gstrings_stats = ravb_gstrings_stats_gbeth,
+	.gstrings_size = sizeof(ravb_gstrings_stats_gbeth),
+	.stats_len = ARRAY_SIZE(ravb_gstrings_stats_gbeth),
 	.max_rx_len = ALIGN(GBETH_RX_BUFF_MAX, RAVB_ALIGN),
 	.tsrq = TCCR_TSRQ0,
 	.rx_max_buf_size = SZ_8K,
-- 
2.17.1

