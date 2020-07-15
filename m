Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C169220D08
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 14:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730153AbgGOMiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 08:38:21 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21810 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726968AbgGOMiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 08:38:20 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FCUo7d018240;
        Wed, 15 Jul 2020 05:38:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=kUULqIl1i5Ih6nIFmjSIKIoWjnbDawBH5rdiYGFJX9Y=;
 b=G3tOvOqqmYpKNzT1yX3LkuWk3f6o9ADihcrzwY51MJUZB92qjd61nAB3dOGP3AwZBahK
 pKHiNPkghKo4ZU3lY/78VHZvj1Op+tBHEu27B6ky+KjZd27JhNJBPC/VvNEBmh+47v79
 hKNv8BTlfcv5A7b1EOghnj9hjpXszj12cqAyYXyIMYxdadQERL6VmQYcTPdmeEDRnMDX
 T202a2bcMnnDgJ4yiF00/qJ3f+Y+EndGZ5D6fTm/JsGndQl2aGJ7DNXnAgZSSf6IV5tE
 IWxO703XWRUfy3ypQmSvyEO+WKnKYcNQUbGFebHAGM+TXqMSj3eL25z9LQpeU70mfL2N 6w== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 327asnhhke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 05:38:18 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 05:38:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jul 2020 05:38:17 -0700
Received: from hyd1358.caveonetworks.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 904353F7041;
        Wed, 15 Jul 2020 05:38:15 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        Zyta Szpak <zyta@marvell.com>
Subject: [PATCH v4 net-next 1/3] octeontx2-af: Support to enable/disable HW timestamping
Date:   Wed, 15 Jul 2020 18:08:07 +0530
Message-ID: <1594816689-5935-2-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594816689-5935-1-git-send-email-sbhatta@marvell.com>
References: <1594816689-5935-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_11:2020-07-15,2020-07-15 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zyta Szpak <zyta@marvell.com>

Four new mbox messages ids and handler are added in order to
enable or disable timestamping procedure on tx and rx side.
Additionally when PTP is enabled, the packet parser must skip
over 8 bytes and start analyzing packet data there. To make NPC
profiles work seemlesly PTR_ADVANCE of IKPU is set so that
parsing can be done as before when all data pointers
are shifted by 8 bytes automatically.

Signed-off-by: Zyta Szpak <zyta@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---

v4:
  No changes
v3:
  No changes
v2:
  No changes

 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 29 ++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  4 ++
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  4 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 54 ++++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 52 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 27 +++++++++++
 7 files changed, 171 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index a4e65da..8f17e26 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -468,6 +468,35 @@ static void cgx_lmac_pause_frm_config(struct cgx *cgx, int lmac_id, bool enable)
 	}
 }
 
+void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable)
+{
+	struct cgx *cgx = cgxd;
+	u64 cfg;
+
+	if (!cgx)
+		return;
+
+	if (enable) {
+		/* Enable inbound PTP timestamping */
+		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
+		cfg |= CGX_GMP_GMI_RXX_FRM_CTL_PTP_MODE;
+		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
+
+		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
+		cfg |= CGX_SMUX_RX_FRM_CTL_PTP_MODE;
+		cgx_write(cgx, lmac_id,	CGXX_SMUX_RX_FRM_CTL, cfg);
+	} else {
+		/* Disable inbound PTP stamping */
+		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
+		cfg &= ~CGX_GMP_GMI_RXX_FRM_CTL_PTP_MODE;
+		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
+
+		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
+		cfg &= ~CGX_SMUX_RX_FRM_CTL_PTP_MODE;
+		cgx_write(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL, cfg);
+	}
+}
+
 /* CGX Firmware interface low level support */
 static int cgx_fwi_cmd_send(u64 req, u64 *resp, struct lmac *lmac)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 394f965..27ca329 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -58,8 +58,10 @@
 
 #define CGXX_SMUX_RX_FRM_CTL		0x20020
 #define CGX_SMUX_RX_FRM_CTL_CTL_BCK	BIT_ULL(3)
+#define CGX_SMUX_RX_FRM_CTL_PTP_MODE	BIT_ULL(12)
 #define CGXX_GMP_GMI_RXX_FRM_CTL	0x38028
 #define CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK	BIT_ULL(3)
+#define CGX_GMP_GMI_RXX_FRM_CTL_PTP_MODE BIT_ULL(12)
 #define CGXX_SMUX_TX_CTL		0x20178
 #define CGXX_SMUX_TX_PAUSE_PKT_TIME	0x20110
 #define CGXX_SMUX_TX_PAUSE_PKT_INTERVAL	0x20120
@@ -139,4 +141,6 @@ int cgx_lmac_get_pause_frm(void *cgxd, int lmac_id,
 			   u8 *tx_pause, u8 *rx_pause);
 int cgx_lmac_set_pause_frm(void *cgxd, int lmac_id,
 			   u8 tx_pause, u8 rx_pause);
+void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable);
+
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 6dfd0f9..c89b098 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -143,6 +143,8 @@ M(CGX_STOP_LINKEVENTS,	0x208, cgx_stop_linkevents, msg_req, msg_rsp)	\
 M(CGX_GET_LINKINFO,	0x209, cgx_get_linkinfo, msg_req, cgx_link_info_msg) \
 M(CGX_INTLBK_ENABLE,	0x20A, cgx_intlbk_enable, msg_req, msg_rsp)	\
 M(CGX_INTLBK_DISABLE,	0x20B, cgx_intlbk_disable, msg_req, msg_rsp)	\
+M(CGX_PTP_RX_ENABLE,	0x20C, cgx_ptp_rx_enable, msg_req, msg_rsp)	\
+M(CGX_PTP_RX_DISABLE,	0x20D, cgx_ptp_rx_disable, msg_req, msg_rsp)	\
 M(CGX_CFG_PAUSE_FRM,	0x20E, cgx_cfg_pause_frm, cgx_pause_frm_cfg,	\
 			       cgx_pause_frm_cfg)			\
 /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
@@ -213,6 +215,8 @@ M(NIX_LSO_FORMAT_CFG,	0x8011, nix_lso_format_cfg,			\
 				 nix_lso_format_cfg,			\
 				 nix_lso_format_cfg_rsp)		\
 M(NIX_RXVLAN_ALLOC,	0x8012, nix_rxvlan_alloc, msg_req, msg_rsp)	\
+M(NIX_LF_PTP_TX_ENABLE, 0x8013, nix_lf_ptp_tx_enable, msg_req, msg_rsp)	\
+M(NIX_LF_PTP_TX_DISABLE, 0x8014, nix_lf_ptp_tx_disable, msg_req, msg_rsp) \
 M(NIX_BP_ENABLE,	0x8016, nix_bp_enable, nix_bp_cfg_req,	\
 				nix_bp_cfg_rsp)	\
 M(NIX_BP_DISABLE,	0x8017, nix_bp_disable, nix_bp_cfg_req, msg_rsp) \
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index dcf25a0..62c3ed2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -469,6 +469,7 @@ int rvu_npc_init(struct rvu *rvu);
 void rvu_npc_freemem(struct rvu *rvu);
 int rvu_npc_get_pkind(struct rvu *rvu, u16 pf);
 void rvu_npc_set_pkind(struct rvu *rvu, int pkind, struct rvu_pfvf *pfvf);
+int npc_config_ts_kpuaction(struct rvu *rvu, int pf, u16 pcifunc, bool en);
 void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 				 int nixlf, u64 chan, u8 *mac_addr);
 void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index f3c82e4..e751cbc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -509,6 +509,60 @@ int rvu_mbox_handler_cgx_promisc_disable(struct rvu *rvu, struct msg_req *req,
 	return 0;
 }
 
+int rvu_mbox_handler_cgx_ptp_rx_enable(struct rvu *rvu, struct msg_req *req,
+				       struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	int pf = rvu_get_pf(pcifunc);
+	u8 cgx_id, lmac_id;
+	void *cgxd;
+
+	/* This msg is expected only from PFs that are mapped to CGX LMACs,
+	 * if received from other PF/VF simply ACK, nothing to do.
+	 */
+	if ((req->hdr.pcifunc & RVU_PFVF_FUNC_MASK) ||
+	    !is_pf_cgxmapped(rvu, pf))
+		return -ENODEV;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	cgxd = rvu_cgx_pdata(cgx_id, rvu);
+
+	cgx_lmac_ptp_config(cgxd, lmac_id, true);
+	/* Inform NPC that packets to be parsed by this PF
+	 * will have their data shifted by 8B
+	 */
+	if (npc_config_ts_kpuaction(rvu, pf, pcifunc, true))
+		return -EINVAL;
+
+	return 0;
+}
+
+int rvu_mbox_handler_cgx_ptp_rx_disable(struct rvu *rvu, struct msg_req *req,
+					struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	int pf = rvu_get_pf(pcifunc);
+	u8 cgx_id, lmac_id;
+	void *cgxd;
+
+	/* This msg is expected only from PFs that are mapped to CGX LMACs,
+	 * if received from other PF/VF simply ACK, nothing to do.
+	 */
+	if ((req->hdr.pcifunc & RVU_PFVF_FUNC_MASK) ||
+	    !is_pf_cgxmapped(rvu, pf))
+		return -ENODEV;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	cgxd = rvu_cgx_pdata(cgx_id, rvu);
+
+	cgx_lmac_ptp_config(cgxd, lmac_id, false);
+	/* Inform NPC that 8B shift is cancelled */
+	if (npc_config_ts_kpuaction(rvu, pf, pcifunc, false))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int rvu_cgx_config_linkevents(struct rvu *rvu, u16 pcifunc, bool en)
 {
 	int pf = rvu_get_pf(pcifunc);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 36953d4..6c1abfb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3319,6 +3319,58 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 	nix_ctx_free(rvu, pfvf);
 }
 
+int rvu_mbox_handler_nix_lf_ptp_tx_enable(struct rvu *rvu, struct msg_req *req,
+					  struct msg_rsp *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_block *block;
+	int blkaddr;
+	int nixlf;
+	u64 cfg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+	if (blkaddr < 0)
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	block = &hw->block[blkaddr];
+	nixlf = rvu_get_lf(rvu, block, pcifunc, 0);
+	if (nixlf < 0)
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_TX_CFG(nixlf));
+	cfg |= BIT_ULL(32);
+	rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_CFG(nixlf), cfg);
+
+	return 0;
+}
+
+int rvu_mbox_handler_nix_lf_ptp_tx_disable(struct rvu *rvu, struct msg_req *req,
+					   struct msg_rsp *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_block *block;
+	int blkaddr;
+	int nixlf;
+	u64 cfg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+	if (blkaddr < 0)
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	block = &hw->block[blkaddr];
+	nixlf = rvu_get_lf(rvu, block, pcifunc, 0);
+	if (nixlf < 0)
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_TX_CFG(nixlf));
+	cfg &= ~BIT_ULL(32);
+	rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_CFG(nixlf), cfg);
+
+	return 0;
+}
+
 int rvu_mbox_handler_nix_lso_format_cfg(struct rvu *rvu,
 					struct nix_lso_format_cfg *req,
 					struct nix_lso_format_cfg_rsp *rsp)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 0a21408..8179bbe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -27,6 +27,7 @@
 #define NIXLF_PROMISC_ENTRY	2
 
 #define NPC_PARSE_RESULT_DMAC_OFFSET	8
+#define NPC_HW_TSTAMP_OFFSET		8
 
 static void npc_mcam_free_all_entries(struct rvu *rvu, struct npc_mcam *mcam,
 				      int blkaddr, u16 pcifunc);
@@ -61,6 +62,32 @@ int rvu_npc_get_pkind(struct rvu *rvu, u16 pf)
 	return -1;
 }
 
+int npc_config_ts_kpuaction(struct rvu *rvu, int pf, u16 pcifunc, bool en)
+{
+	int pkind, blkaddr;
+	u64 val;
+
+	pkind = rvu_npc_get_pkind(rvu, pf);
+	if (pkind < 0) {
+		dev_err(rvu->dev, "%s: pkind not mapped\n", __func__);
+		return -EINVAL;
+	}
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, pcifunc);
+	if (blkaddr < 0) {
+		dev_err(rvu->dev, "%s: NPC block not implemented\n", __func__);
+		return -EINVAL;
+	}
+	val = rvu_read64(rvu, blkaddr, NPC_AF_PKINDX_ACTION0(pkind));
+	val &= ~0xff00000ULL; /* Zero ptr advance field */
+	if (en)
+		/* Set to timestamp offset */
+		val |= (NPC_HW_TSTAMP_OFFSET << 20);
+	rvu_write64(rvu, blkaddr, NPC_AF_PKINDX_ACTION0(pkind), val);
+
+	return 0;
+}
+
 static int npc_get_nixlf_mcam_index(struct npc_mcam *mcam,
 				    u16 pcifunc, int nixlf, int type)
 {
-- 
2.7.4

