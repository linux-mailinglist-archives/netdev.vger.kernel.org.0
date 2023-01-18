Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA66A671C59
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjARMmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjARMkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:40:39 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED167E4A3
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 04:04:34 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I9uxtv029997;
        Wed, 18 Jan 2023 04:04:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=RH78EebqR8oZflkNg/5576/NN/ZFKOvHDYutXZxPYIc=;
 b=GbjyY03Vhdz4QExA7lpcGeJJl8ijqZ0XLJGNnpLEIiDTf9hf0yShWC5rqsGeHY0EhwZg
 VEGGpyDWwf8o8qMF7ZTuDFsHLQXmkNgvqtv7fzTbGd2kWGriK4l4CCdbcTeg4jpKyXwT
 F4EIdCwZTHYZfLJ2AYXQYsRbn2cbSiUb6govs8O4+F+3LNa6rz23CeRwESemvaEqJ1Lb
 TLq+5h7BK13CoJCLXcLVaLV96alqSqOkCskGm2UckGEStwjYj6rmn2BfAqx04j5MXANG
 70zAh+cPSACAMTQEfZKLd5JKM557DAv0RDqsCtWHQd0UHnfmWq5N6XmBD3u1mlzNt2SK SA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n3vstgucm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 04:04:28 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 18 Jan
 2023 04:04:26 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 18 Jan 2023 04:04:25 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 6C5B75B6934;
        Wed, 18 Jan 2023 04:04:22 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jerinj@marvell.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <schalla@marvell.com>
Subject: [PATCH net-next v3 7/7] octeontx2-af: add mbox to return CPT_AF_FLT_INT info
Date:   Wed, 18 Jan 2023 17:33:54 +0530
Message-ID: <20230118120354.1017961-8-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230118120354.1017961-1-schalla@marvell.com>
References: <20230118120354.1017961-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2YBT9A3sIpjYxkiY9UbQpbU-gCPJcEko
X-Proofpoint-GUID: 2YBT9A3sIpjYxkiY9UbQpbU-gCPJcEko
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CPT HW would trigger the CPT AF FLT interrupt when CPT engines
hits some uncorrectable errors and AF is the one which receives
the interrupt and recovers the engines.
This patch adds a mailbox for CPT VFs to request for CPT faulted
and recovered engines info.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  | 17 +++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  4 +++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 35 +++++++++++++++++++
 3 files changed, 56 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index abe86778b064..5727d67e0259 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -196,6 +196,8 @@ M(CPT_RXC_TIME_CFG,     0xA06, cpt_rxc_time_cfg, cpt_rxc_time_cfg_req,  \
 			       msg_rsp)                                 \
 M(CPT_CTX_CACHE_SYNC,   0xA07, cpt_ctx_cache_sync, msg_req, msg_rsp)    \
 M(CPT_LF_RESET,         0xA08, cpt_lf_reset, cpt_lf_rst_req, msg_rsp)	\
+M(CPT_FLT_ENG_INFO,     0xA09, cpt_flt_eng_info, cpt_flt_eng_info_req,	\
+			       cpt_flt_eng_info_rsp)			\
 /* SDP mbox IDs (range 0x1000 - 0x11FF) */				\
 M(SET_SDP_CHAN_INFO, 0x1000, set_sdp_chan_info, sdp_chan_info_msg, msg_rsp) \
 M(GET_SDP_CHAN_INFO, 0x1001, get_sdp_chan_info, msg_req, sdp_get_chan_info_msg) \
@@ -1706,6 +1708,21 @@ struct cpt_lf_rst_req {
 	u32 rsvd;
 };
 
+/* Mailbox message format to request for CPT faulted engines */
+struct cpt_flt_eng_info_req {
+	struct mbox_msghdr hdr;
+	int blkaddr;
+	bool reset;
+	u32 rsvd;
+};
+
+struct cpt_flt_eng_info_rsp {
+	struct mbox_msghdr hdr;
+	u64 flt_eng_map[CPT_10K_AF_INT_VEC_RVU];
+	u64 rcvrd_eng_map[CPT_10K_AF_INT_VEC_RVU];
+	u64 rsvd;
+};
+
 struct sdp_node_info {
 	/* Node to which this PF belons to */
 	u8 node_id;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 2f480c73ef55..5eea2b6cf6bd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -108,6 +108,8 @@ struct rvu_block {
 	u64  lfreset_reg;
 	unsigned char name[NAME_SIZE];
 	struct rvu *rvu;
+	u64 cpt_flt_eng_map[3];
+	u64 cpt_rcvrd_eng_map[3];
 };
 
 struct nix_mcast {
@@ -526,6 +528,8 @@ struct rvu {
 	struct list_head	mcs_intrq_head;
 	/* mcs interrupt queue lock */
 	spinlock_t		mcs_intrq_lock;
+	/* CPT interrupt lock */
+	spinlock_t		cpt_intr_lock;
 };
 
 static inline void rvu_write64(struct rvu *rvu, u64 block, u64 offset, u64 val)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index d7ca7e953683..f047185f38e0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -70,6 +70,14 @@ static irqreturn_t cpt_af_flt_intr_handler(int vec, void *ptr)
 
 		rvu_write64(rvu, blkaddr, CPT_AF_EXEX_CTL2(eng), grp);
 		rvu_write64(rvu, blkaddr, CPT_AF_EXEX_CTL(eng), val | 1ULL);
+
+		spin_lock(&rvu->cpt_intr_lock);
+		block->cpt_flt_eng_map[vec] |= BIT_ULL(i);
+		val = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_STS(eng));
+		val = val & 0x3;
+		if (val == 0x1 || val == 0x2)
+			block->cpt_rcvrd_eng_map[vec] |= BIT_ULL(i);
+		spin_unlock(&rvu->cpt_intr_lock);
 	}
 	rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT(vec), reg);
 
@@ -899,6 +907,31 @@ int rvu_mbox_handler_cpt_lf_reset(struct rvu *rvu, struct cpt_lf_rst_req *req,
 	return 0;
 }
 
+int rvu_mbox_handler_cpt_flt_eng_info(struct rvu *rvu, struct cpt_flt_eng_info_req *req,
+				      struct cpt_flt_eng_info_rsp *rsp)
+{
+	struct rvu_block *block;
+	unsigned long flags;
+	int blkaddr, vec;
+
+	blkaddr = validate_and_get_cpt_blkaddr(req->blkaddr);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	block = &rvu->hw->block[blkaddr];
+	for (vec = 0; vec < CPT_10K_AF_INT_VEC_RVU; vec++) {
+		spin_lock_irqsave(&rvu->cpt_intr_lock, flags);
+		rsp->flt_eng_map[vec] = block->cpt_flt_eng_map[vec];
+		rsp->rcvrd_eng_map[vec] = block->cpt_rcvrd_eng_map[vec];
+		if (req->reset) {
+			block->cpt_flt_eng_map[vec] = 0x0;
+			block->cpt_rcvrd_eng_map[vec] = 0x0;
+		}
+		spin_unlock_irqrestore(&rvu->cpt_intr_lock, flags);
+	}
+	return 0;
+}
+
 static void cpt_rxc_teardown(struct rvu *rvu, int blkaddr)
 {
 	struct cpt_rxc_time_cfg_req req, prev;
@@ -1182,5 +1215,7 @@ int rvu_cpt_init(struct rvu *rvu)
 {
 	/* Retrieve CPT PF number */
 	rvu->cpt_pf_num = get_cpt_pf_num(rvu);
+	spin_lock_init(&rvu->cpt_intr_lock);
+
 	return 0;
 }
-- 
2.25.1

