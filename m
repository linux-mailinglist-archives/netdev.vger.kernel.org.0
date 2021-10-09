Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE08427CFF
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 21:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhJITKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 15:10:36 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:31354 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230327AbhJITKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 15:10:34 -0400
X-IronPort-AV: E=Sophos;i="5.85,361,1624287600"; 
   d="scan'208";a="96659006"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 10 Oct 2021 04:08:36 +0900
Received: from localhost.localdomain (unknown [10.226.92.6])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 797FD4009415;
        Sun, 10 Oct 2021 04:08:33 +0900 (JST)
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
Subject: [PATCH 08/14] ravb: Add support to retrieve stats for GbEthernet
Date:   Sat,  9 Oct 2021 20:07:56 +0100
Message-Id: <20211009190802.18585-9-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211009190802.18585-1-biju.das.jz@bp.renesas.com>
References: <20211009190802.18585-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for retrieving stats information for GbEthernet.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
RFC->v1:
 * No change. Added Sergey's Rb tag.
RFC changes:
 * New patch.
---
 drivers/net/ethernet/renesas/ravb_main.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index eefff19d1739..2f194a7bc367 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1493,6 +1493,24 @@ static void ravb_set_msglevel(struct net_device *ndev, u32 value)
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
@@ -2434,6 +2452,9 @@ static const struct ravb_hw_info gbeth_hw_info = {
 	.set_feature = ravb_set_features_gbeth,
 	.dmac_init = ravb_dmac_init_gbeth,
 	.emac_init = ravb_emac_init_gbeth,
+	.gstrings_stats = ravb_gstrings_stats_gbeth,
+	.gstrings_size = sizeof(ravb_gstrings_stats_gbeth),
+	.stats_len = ARRAY_SIZE(ravb_gstrings_stats_gbeth),
 	.max_rx_len = ALIGN(GBETH_RX_BUFF_MAX, RAVB_ALIGN),
 	.tsrq = TCCR_TSRQ0,
 	.rx_max_buf_size = SZ_8K,
-- 
2.17.1

