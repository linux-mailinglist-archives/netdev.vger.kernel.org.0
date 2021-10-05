Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C491E4224A7
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbhJELJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:09:25 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:50357 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234396AbhJELJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 07:09:21 -0400
X-IronPort-AV: E=Sophos;i="5.85,348,1624287600"; 
   d="scan'208";a="96017469"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 05 Oct 2021 20:07:31 +0900
Received: from localhost.localdomain (unknown [10.226.93.104])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 1669840078B9;
        Tue,  5 Oct 2021 20:07:27 +0900 (JST)
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
Subject: [RFC 12/12] ravb: Update/Add comments
Date:   Tue,  5 Oct 2021 12:06:42 +0100
Message-Id: <20211005110642.3744-13-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch update/add the following comments

1) Fix the typo AVB->DMAC in comment, as the code following the comment
   is for GbEthernet DMAC in ravb_dmac_init_gbeth()

2) Update the comment "PAUSE prohibition"-> "EMAC Mode: PAUSE
   prohibition; Duplex; TX; RX;" in ravb_emac_init_gbeth()

3) Document PFRI register bit, as it is only supported for
   R-Car Gen3 and RZ/G2L.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
RFC changes:
 * New patch.
---
 drivers/net/ethernet/renesas/ravb.h      | 2 +-
 drivers/net/ethernet/renesas/ravb_main.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 010dad82091c..472254612d6a 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -833,7 +833,7 @@ enum ECSR_BIT {
 	ECSR_MPD	= 0x00000002,
 	ECSR_LCHNG	= 0x00000004,
 	ECSR_PHYI	= 0x00000008,
-	ECSR_PFRI	= 0x00000010,
+	ECSR_PFRI	= 0x00000010,	/* Documented for R-Car Gen3 and RZ/G2L */
 };
 
 /* ECSIPR */
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index dfbbda3681f8..4a057005a470 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -519,7 +519,7 @@ static void ravb_emac_init_gbeth(struct net_device *ndev)
 	/* Receive frame limit set register */
 	ravb_write(ndev, GBETH_RX_BUFF_MAX + ETH_FCS_LEN, RFLR);
 
-	/* PAUSE prohibition */
+	/* EMAC Mode: PAUSE prohibition; Duplex; TX; RX; */
 	ravb_write(ndev, ECMR_ZPF | ((priv->duplex > 0) ? ECMR_DM : 0) |
 			 ECMR_TE | ECMR_RE | ECMR_RCPT |
 			 ECMR_TXF | ECMR_RXF | ECMR_PRM, ECMR);
@@ -588,7 +588,7 @@ static int ravb_dmac_init_gbeth(struct net_device *ndev)
 	/* Descriptor format */
 	ravb_ring_format(ndev, RAVB_BE);
 
-	/* Set AVB RX */
+	/* Set DMAC RX */
 	ravb_write(ndev, 0x60000000, RCR);
 
 	/* Set Max Frame Length (RTC) */
-- 
2.17.1

