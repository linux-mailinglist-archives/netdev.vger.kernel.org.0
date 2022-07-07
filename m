Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F66F569BC0
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbiGGHfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbiGGHf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:35:29 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275B231DE1;
        Thu,  7 Jul 2022 00:35:22 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 266NFQTQ008098;
        Thu, 7 Jul 2022 00:35:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=ZSk/a5kvKGgnF6HkXBA27+cNCJVtIZvIFDYoJIKOcyw=;
 b=Wtg3sly+u4hTG0WOjNdOeuJQpQOstNtl5ICT0VnR5ybge9MnGad4NNR0OMergq7w2UOv
 EQ65q5FOVCZmnZ7vzlM18TWIK/WDRoEnLGlwL016zDdYJK4MYOdnoBSwbRcv3T0aP6vx
 ux0iDoreIFfh+T9pwGo8Ih35dDZUv8H/ONEstiEx5zw0mxN06pG7fVReGItnoBRsuUKB
 uex8OOmwfe2eDlQ0fCVUpzlpi+e3XGi4Jg3dTRvozs220zPj2SKwQwOx5pUKaNFU5RMt
 YaSfKn420hOGn3x5/xparM503LLinvFvrOQSjMSkbK5y4wFKp1IMM3AKknl+0gwMdfov rA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3h5kwj1guk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 00:35:16 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Jul
 2022 00:35:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 7 Jul 2022 00:35:15 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id E99273F706B;
        Thu,  7 Jul 2022 00:35:12 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [net-next PATCH V3 08/12] octeontx2: Modify mbox request and response structures
Date:   Thu, 7 Jul 2022 13:03:49 +0530
Message-ID: <20220707073353.2752279-9-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220707073353.2752279-1-rkannoth@marvell.com>
References: <20220707073353.2752279-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: R2lWhkUfRrxuvFXgdnoXJPj8i5aES53_
X-Proofpoint-GUID: R2lWhkUfRrxuvFXgdnoXJPj8i5aES53_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_05,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Exact match table modification requires wider fields as it has
more number of slots to fill in. Modifying an entry in exact match
table may cause hash collision and may be required to delete entry
from 4-way 2K table and add to fully associative 32 entry CAM table.

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  | 27 ++++++++++++++-----
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |  4 +--
 .../marvell/octeontx2/nic/otx2_dmac_flt.c     |  2 +-
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 38e064bdaf72..430aa8a05c23 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -169,9 +169,10 @@ M(CGX_GET_PHY_FEC_STATS, 0x219, cgx_get_phy_fec_stats, msg_req, msg_rsp) \
 M(CGX_FEATURES_GET,	0x21B, cgx_features_get, msg_req,		\
 			       cgx_features_info_msg)			\
 M(RPM_STATS,		0x21C, rpm_stats, msg_req, rpm_stats_rsp)	\
-M(CGX_MAC_ADDR_RESET,	0x21D, cgx_mac_addr_reset, msg_req, msg_rsp)	\
+M(CGX_MAC_ADDR_RESET,	0x21D, cgx_mac_addr_reset, cgx_mac_addr_reset_req, \
+							msg_rsp) \
 M(CGX_MAC_ADDR_UPDATE,	0x21E, cgx_mac_addr_update, cgx_mac_addr_update_req, \
-			       msg_rsp)					\
+						    cgx_mac_addr_update_rsp) \
 M(CGX_PRIO_FLOW_CTRL_CFG, 0x21F, cgx_prio_flow_ctrl_cfg, cgx_pfc_cfg,  \
 				 cgx_pfc_rsp)                               \
 /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
@@ -455,6 +456,7 @@ struct cgx_fec_stats_rsp {
 struct cgx_mac_addr_set_or_get {
 	struct mbox_msghdr hdr;
 	u8 mac_addr[ETH_ALEN];
+	u32 index;
 };
 
 /* Structure for requesting the operation to
@@ -470,7 +472,7 @@ struct cgx_mac_addr_add_req {
  */
 struct cgx_mac_addr_add_rsp {
 	struct mbox_msghdr hdr;
-	u8 index;
+	u32 index;
 };
 
 /* Structure for requesting the operation to
@@ -478,7 +480,7 @@ struct cgx_mac_addr_add_rsp {
  */
 struct cgx_mac_addr_del_req {
 	struct mbox_msghdr hdr;
-	u8 index;
+	u32 index;
 };
 
 /* Structure for response against the operation to
@@ -486,7 +488,7 @@ struct cgx_mac_addr_del_req {
  */
 struct cgx_max_dmac_entries_get_rsp {
 	struct mbox_msghdr hdr;
-	u8 max_dmac_filters;
+	u32 max_dmac_filters;
 };
 
 struct cgx_link_user_info {
@@ -587,10 +589,20 @@ struct cgx_set_link_mode_rsp {
 	int status;
 };
 
+struct cgx_mac_addr_reset_req {
+	struct mbox_msghdr hdr;
+	u32 index;
+};
+
 struct cgx_mac_addr_update_req {
 	struct mbox_msghdr hdr;
 	u8 mac_addr[ETH_ALEN];
-	u8 index;
+	u32 index;
+};
+
+struct cgx_mac_addr_update_rsp {
+	struct mbox_msghdr hdr;
+	u32 index;
 };
 
 #define RVU_LMAC_FEAT_FC		BIT_ULL(0) /* pause frames */
@@ -1636,6 +1648,9 @@ enum cgx_af_status {
 	LMAC_AF_ERR_PERM_DENIED		= -1103,
 	LMAC_AF_ERR_PFC_ENADIS_PERM_DENIED       = -1104,
 	LMAC_AF_ERR_8023PAUSE_ENADIS_PERM_DENIED = -1105,
+	LMAC_AF_ERR_EXACT_MATCH_TBL_ADD_FAILED = -1108,
+	LMAC_AF_ERR_EXACT_MATCH_TBL_DEL_FAILED = -1109,
+	LMAC_AF_ERR_EXACT_MATCH_TBL_LOOK_UP_FAILED = -1110,
 };
 
 #endif /* MBOX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 97a633c1d395..0d86f3e68fa0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -1089,7 +1089,7 @@ int rvu_mbox_handler_cgx_set_link_mode(struct rvu *rvu,
 	return 0;
 }
 
-int rvu_mbox_handler_cgx_mac_addr_reset(struct rvu *rvu, struct msg_req *req,
+int rvu_mbox_handler_cgx_mac_addr_reset(struct rvu *rvu, struct cgx_mac_addr_reset_req *req,
 					struct msg_rsp *rsp)
 {
 	int pf = rvu_get_pf(req->hdr.pcifunc);
@@ -1104,7 +1104,7 @@ int rvu_mbox_handler_cgx_mac_addr_reset(struct rvu *rvu, struct msg_req *req,
 
 int rvu_mbox_handler_cgx_mac_addr_update(struct rvu *rvu,
 					 struct cgx_mac_addr_update_req *req,
-					 struct msg_rsp *rsp)
+					 struct cgx_mac_addr_update_rsp *rsp)
 {
 	int pf = rvu_get_pf(req->hdr.pcifunc);
 	u8 cgx_id, lmac_id;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
index 2ec800f741d8..142d87722bed 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
@@ -93,7 +93,7 @@ static int otx2_dmacflt_do_remove(struct otx2_nic *pfvf, const u8 *mac,
 
 static int otx2_dmacflt_remove_pfmac(struct otx2_nic *pf)
 {
-	struct msg_req *req;
+	struct cgx_mac_addr_reset_req *req;
 	int err;
 
 	mutex_lock(&pf->mbox.lock);
-- 
2.25.1

