Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3636D3F74F7
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 14:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240919AbhHYMUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 08:20:04 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5608 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240880AbhHYMTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 08:19:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17P6e3nW014197;
        Wed, 25 Aug 2021 05:19:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=zn2HuZawow4+ge20GEyZVJK50gdMayKGswAKJSCLS+k=;
 b=eg8QAQmD8C3b4fd2vm2dGdggJ9VzbATLPkQZmJN2aZRo4Dw2GA3bf9ETUIIAs3KR5z+d
 Kcncjhz2554gFeD8LMiLyzO1cbkdbU+/b//lZh6JYo1T9MwyyooWqwM8Uqk+k+UxJUQY
 FdYBy/K3829GA5se/XtPCUwrXck8g3uCf27Eg1SXysO8OmA3GiBPmoif2vLGa+VTT9w3
 QA3AwzHpz2SJFOY/sTx0snaUSif+t1JZppZYJWjGpxqU6bW7U4un3wjlTPF5lbLPtXv3
 ma26ToW9Zf+3/d20lBcJIGFGGxDBjGRD7uBKkqzZ5QYwQfx3dNMdUHnl0UGsAYbaGkKf PA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3angt017pd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Aug 2021 05:19:00 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 25 Aug
 2021 05:18:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 25 Aug 2021 05:18:59 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 0090C3F7072;
        Wed, 25 Aug 2021 05:18:56 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [net-next PATCH 3/9] octeontx2-pf: cleanup transmit link deriving logic
Date:   Wed, 25 Aug 2021 17:48:40 +0530
Message-ID: <1629893926-18398-4-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629893926-18398-1-git-send-email-sgoutham@marvell.com>
References: <1629893926-18398-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: rmzHISUKb9DO3keOyztE97R61OqPYa2D
X-Proofpoint-GUID: rmzHISUKb9DO3keOyztE97R61OqPYa2D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-25_05,2021-08-25_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Unlike OcteonTx2, the channel numbers used by CGX/RPM
and LBK on CN10K silicons aren't fixed in HW. They are
SW programmable, hence we cannot derive transmit link
from static channel numbers anymore. Get the same from
admin function via mailbox.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  9 +++++++--
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 23 ++--------------------
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  1 +
 4 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 8ee9504..487b834 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -725,6 +725,7 @@ struct nix_lf_alloc_rsp {
 	u8	cgx_links;  /* No. of CGX links present in HW */
 	u8	lbk_links;  /* No. of LBK links present in HW */
 	u8	sdp_links;  /* No. of SDP links present in HW */
+	u8	tx_link;    /* Transmit channel link number */
 };
 
 struct nix_lf_free_req {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index a07d99a..0cac0f3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -290,9 +290,11 @@ static bool is_valid_txschq(struct rvu *rvu, int blkaddr,
 	return true;
 }
 
-static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
+static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf,
+			      struct nix_lf_alloc_rsp *rsp)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	struct rvu_hwinfo *hw = rvu->hw;
 	struct mac_ops *mac_ops;
 	int pkind, pf, vf, lbkid;
 	u8 cgx_id, lmac_id;
@@ -317,6 +319,8 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 		pfvf->tx_chan_base = pfvf->rx_chan_base;
 		pfvf->rx_chan_cnt = 1;
 		pfvf->tx_chan_cnt = 1;
+		rsp->tx_link = cgx_id * hw->lmac_per_cgx + lmac_id;
+
 		cgx_set_pkind(rvu_cgx_pdata(cgx_id, rvu), lmac_id, pkind);
 		rvu_npc_set_pkind(rvu, pkind, pfvf);
 
@@ -350,6 +354,7 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 					rvu_nix_chan_lbk(rvu, lbkid, vf + 1);
 		pfvf->rx_chan_cnt = 1;
 		pfvf->tx_chan_cnt = 1;
+		rsp->tx_link = hw->cgx_links + lbkid;
 		rvu_npc_set_pkind(rvu, NPC_RX_LBK_PKIND, pfvf);
 		rvu_npc_install_promisc_entry(rvu, pcifunc, nixlf,
 					      pfvf->rx_chan_base,
@@ -1304,7 +1309,7 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 	rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_PARSE_CFG(nixlf), cfg);
 
 	intf = is_afvf(pcifunc) ? NIX_INTF_TYPE_LBK : NIX_INTF_TYPE_CGX;
-	err = nix_interface_init(rvu, pcifunc, intf, nixlf);
+	err = nix_interface_init(rvu, pcifunc, intf, nixlf, rsp);
 	if (err)
 		goto free_mem;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index f630e57..e026827 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -584,25 +584,6 @@ void otx2_get_mac_from_af(struct net_device *netdev)
 }
 EXPORT_SYMBOL(otx2_get_mac_from_af);
 
-static int otx2_get_link(struct otx2_nic *pfvf)
-{
-	int link = 0;
-	u16 map;
-
-	/* cgx lmac link */
-	if (pfvf->hw.tx_chan_base >= CGX_CHAN_BASE) {
-		map = pfvf->hw.tx_chan_base & 0x7FF;
-		link = 4 * ((map >> 8) & 0xF) + ((map >> 4) & 0xF);
-	}
-	/* LBK channel */
-	if (pfvf->hw.tx_chan_base < SDP_CHAN_BASE) {
-		map = pfvf->hw.tx_chan_base & 0x7FF;
-		link = pfvf->hw.cgx_links | ((map >> 8) & 0xF);
-	}
-
-	return link;
-}
-
 int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 {
 	struct otx2_hw *hw = &pfvf->hw;
@@ -661,8 +642,7 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 		req->regval[1] = TXSCH_TL1_DFLT_RR_PRIO << 24 | dwrr_val;
 
 		req->num_regs++;
-		req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq,
-							otx2_get_link(pfvf));
+		req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw->tx_link);
 		/* Enable this queue and backpressure */
 		req->regval[2] = BIT_ULL(13) | BIT_ULL(12);
 
@@ -1610,6 +1590,7 @@ void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
 	pfvf->hw.lso_tsov6_idx = rsp->lso_tsov6_idx;
 	pfvf->hw.cgx_links = rsp->cgx_links;
 	pfvf->hw.lbk_links = rsp->lbk_links;
+	pfvf->hw.tx_link = rsp->tx_link;
 }
 EXPORT_SYMBOL(mbox_handler_nix_lf_alloc);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 1a97b76..96eddd0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -218,6 +218,7 @@ struct otx2_hw {
 	u64			cgx_fec_uncorr_blks;
 	u8			cgx_links;  /* No. of CGX links present in HW */
 	u8			lbk_links;  /* No. of LBK links present in HW */
+	u8			tx_link;    /* Transmit channel link number */
 #define HW_TSO			0
 #define CN10K_MBOX		1
 #define CN10K_LMTST		2
-- 
2.7.4

