Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA5E3A3F46
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 11:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhFKJoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 05:44:34 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26054 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231511AbhFKJob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 05:44:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B9fgJb023268;
        Fri, 11 Jun 2021 02:42:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=SqEJNjW66iXT+mSSwV+lAw0kQeyhaI/MCEuhMYWgJDc=;
 b=FUnPmRkyqV973lJ8WfWAFd6O1TxE3AvJ5Kf4simufWdDhHoftWqQWp4iyWSCi7PWLWDU
 a5hh5ptcmcJNcgASNfe/rqYLM812zwZJHTaWfmMHf8sOcIHN8zQFbUFuhk4u5p4SX0mL
 U0sCf1ypQ2vMRg9wS44bl3vQe0uYASzofdQc6/IEsBHk5AkUWYouOIGMFqGQQK43n1Rt
 O0TZE7wXGpY0HjpQMZBjV89NN0pkLAhbAYigPaoSMmVcT75pyVuoTP2AHFOhJLF5F3ZX
 Vxr25iob75ykNvi1Quc3b5GECNmtTJtXDxHoXnVaUAFsirmQk1CuXkI6ouRLQ6fYdz0P pw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 39417n8vb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 02:42:31 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Jun
 2021 02:42:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Jun 2021 02:42:29 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id B51BE3F7074;
        Fri, 11 Jun 2021 02:42:26 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <lcherian@marvell.com>, <gakula@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Sunil Kovvuri Goutham <Sunil.Goutham@marvell.com>
Subject: [PATCH net-next 3/4] octeontx2-af: add new mailbox to configure VF trust mode
Date:   Fri, 11 Jun 2021 15:12:04 +0530
Message-ID: <20210611094205.28230-4-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20210611094205.28230-1-naveenm@marvell.com>
References: <20210611094205.28230-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: javRlp9JqZg_PkuvnKLNUSTofaqAhqB4
X-Proofpoint-ORIG-GUID: javRlp9JqZg_PkuvnKLNUSTofaqAhqB4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_03:2021-06-11,2021-06-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

Add new mailbox to enable PF to configure VF as trusted VF.
Trusted VF feature allows VFs to perform priviliged operations
such as enabling VF promiscuous mode, all-multicast mode and
changing the VF MAC address configured by PF. Refactored the
VF interface flags maintained by the AF driver such that the
flags do not overlap for various configurations.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <Sunil.Goutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  9 +++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    | 42 ++++++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  6 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 16 +++++++--
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 16 +++++++--
 5 files changed, 83 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index ed0bc9d3d5dd..aee6a6f31b0d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -134,6 +134,7 @@ M(MSIX_OFFSET,		0x005, msix_offset, msg_req, msix_offset_rsp)	\
 M(VF_FLR,		0x006, vf_flr, msg_req, msg_rsp)		\
 M(PTP_OP,		0x007, ptp_op, ptp_req, ptp_rsp)		\
 M(GET_HW_CAP,		0x008, get_hw_cap, msg_req, get_hw_cap_rsp)	\
+M(SET_VF_PERM,		0x00b, set_vf_perm, set_vf_perm, msg_rsp)	\
 /* CGX mbox IDs (range 0x200 - 0x3FF) */				\
 M(CGX_START_RXTX,	0x200, cgx_start_rxtx, msg_req, msg_rsp)	\
 M(CGX_STOP_RXTX,	0x201, cgx_stop_rxtx, msg_req, msg_rsp)		\
@@ -1231,6 +1232,14 @@ struct ptp_rsp {
 	u64 clk;
 };
 
+struct set_vf_perm  {
+	struct  mbox_msghdr hdr;
+	u16	vf;
+#define RESET_VF_PERM		BIT_ULL(0)
+#define	VF_TRUSTED		BIT_ULL(1)
+	u64	flags;
+};
+
 /* CPT mailbox error codes
  * Range 901 - 1000.
  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index bc71a9c462de..f11a02d6b6ef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1758,6 +1758,48 @@ int rvu_mbox_handler_get_hw_cap(struct rvu *rvu, struct msg_req *req,
 	return 0;
 }
 
+int rvu_mbox_handler_set_vf_perm(struct rvu *rvu, struct set_vf_perm *req,
+				 struct msg_rsp *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_pfvf *pfvf;
+	int blkaddr, nixlf;
+	u16 target;
+
+	/* Only PF can add VF permissions */
+	if ((pcifunc & RVU_PFVF_FUNC_MASK) || is_afvf(pcifunc))
+		return -EOPNOTSUPP;
+
+	target = (pcifunc & ~RVU_PFVF_FUNC_MASK) | (req->vf + 1);
+	pfvf = rvu_get_pfvf(rvu, target);
+
+	if (req->flags & RESET_VF_PERM) {
+		pfvf->flags &= RVU_CLEAR_VF_PERM;
+	} else if (test_bit(PF_SET_VF_TRUSTED, &pfvf->flags) ^
+		 (req->flags & VF_TRUSTED)) {
+		change_bit(PF_SET_VF_TRUSTED, &pfvf->flags);
+		/* disable multicast and promisc entries */
+		if (!test_bit(PF_SET_VF_TRUSTED, &pfvf->flags)) {
+			blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, target);
+			if (blkaddr < 0)
+				return 0;
+			nixlf = rvu_get_lf(rvu, &hw->block[blkaddr],
+					   target, 0);
+			if (nixlf < 0)
+				return 0;
+			npc_enadis_default_mce_entry(rvu, target, nixlf,
+						     NIXLF_ALLMULTI_ENTRY,
+						     false);
+			npc_enadis_default_mce_entry(rvu, target, nixlf,
+						     NIXLF_PROMISC_ENTRY,
+						     false);
+		}
+	}
+
+	return 0;
+}
+
 static int rvu_process_mbox_msg(struct otx2_mbox *mbox, int devid,
 				struct mbox_msghdr *req)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 29bc9a6792d3..c88dab7747ef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -223,7 +223,6 @@ struct rvu_pfvf {
 	u16		maxlen;
 	u16		minlen;
 
-	u8		pf_set_vf_cfg;
 	u8		mac_addr[ETH_ALEN]; /* MAC address of this PF/VF */
 	u8		default_mac[ETH_ALEN]; /* MAC address from FWdata */
 
@@ -249,8 +248,13 @@ struct rvu_pfvf {
 
 enum rvu_pfvf_flags {
 	NIXLF_INITIALIZED = 0,
+	PF_SET_VF_MAC,
+	PF_SET_VF_CFG,
+	PF_SET_VF_TRUSTED,
 };
 
+#define RVU_CLEAR_VF_PERM  ~GENMASK(PF_SET_VF_TRUSTED, PF_SET_VF_MAC)
+
 struct nix_txsch {
 	struct rsrc_bmap schq;
 	u8   lvl;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 8c8d739755cd..d8cb665b7d8a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3137,15 +3137,22 @@ int rvu_mbox_handler_nix_set_mac_addr(struct rvu *rvu,
 
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
 
-	/* VF can't overwrite admin(PF) changes */
-	if (from_vf && pfvf->pf_set_vf_cfg)
+	/* untrusted VF can't overwrite admin(PF) changes */
+	if (!test_bit(PF_SET_VF_TRUSTED, &pfvf->flags) &&
+	    (from_vf && test_bit(PF_SET_VF_MAC, &pfvf->flags))) {
+		dev_warn(rvu->dev,
+			 "MAC address set by admin(PF) cannot be overwritten by untrusted VF");
 		return -EPERM;
+	}
 
 	ether_addr_copy(pfvf->mac_addr, req->mac_addr);
 
 	rvu_npc_install_ucast_entry(rvu, pcifunc, nixlf,
 				    pfvf->rx_chan_base, req->mac_addr);
 
+	if (test_bit(PF_SET_VF_TRUSTED, &pfvf->flags) && from_vf)
+		ether_addr_copy(pfvf->default_mac, req->mac_addr);
+
 	return 0;
 }
 
@@ -3188,6 +3195,11 @@ int rvu_mbox_handler_nix_set_rx_mode(struct rvu *rvu, struct nix_rx_mode *req,
 		return 0;
 	}
 
+	/* untrusted VF can't configure promisc/allmulti */
+	if (is_vf(pcifunc) && !test_bit(PF_SET_VF_TRUSTED, &pfvf->flags) &&
+	    (promisc || allmulti))
+		return 0;
+
 	err = nix_get_nixlf(rvu, pcifunc, &nixlf, NULL);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index bc37858c6a14..6ba6a835e2fa 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -1103,9 +1103,11 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 	if (pf_set_vfs_mac) {
 		ether_addr_copy(pfvf->default_mac, req->packet.dmac);
 		ether_addr_copy(pfvf->mac_addr, req->packet.dmac);
+		set_bit(PF_SET_VF_MAC, &pfvf->flags);
 	}
 
-	if (pfvf->pf_set_vf_cfg && req->vtag0_type == NIX_AF_LFX_RX_VTAG_TYPE7)
+	if (test_bit(PF_SET_VF_CFG, &pfvf->flags) &&
+	    req->vtag0_type == NIX_AF_LFX_RX_VTAG_TYPE7)
 		rule->vfvlan_cfg = true;
 
 	return 0;
@@ -1167,7 +1169,7 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 
 	/* PF installing for its VF */
 	if (req->hdr.pcifunc && !from_vf && req->vf)
-		pfvf->pf_set_vf_cfg = 1;
+		set_bit(PF_SET_VF_CFG, &pfvf->flags);
 
 	/* update req destination mac addr */
 	if ((req->features & BIT_ULL(NPC_DMAC)) && is_npc_intf_rx(req->intf) &&
@@ -1177,7 +1179,7 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 	}
 
 	err = nix_get_nixlf(rvu, target, &nixlf, NULL);
-	if (err)
+	if (err && is_npc_intf_rx(req->intf) && !pf_set_vfs_mac)
 		return -EINVAL;
 
 	/* don't enable rule when nixlf not attached or initialized */
@@ -1196,6 +1198,14 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 	if (from_vf && !enable)
 		return -EINVAL;
 
+	/* PF sets VF mac & VF NIXLF is not attached, update the mac addr */
+	if (pf_set_vfs_mac && !enable) {
+		ether_addr_copy(pfvf->default_mac, req->packet.dmac);
+		ether_addr_copy(pfvf->mac_addr, req->packet.dmac);
+		set_bit(PF_SET_VF_MAC, &pfvf->flags);
+		return 0;
+	}
+
 	/* If message is from VF then its flow should not overlap with
 	 * reserved unicast flow.
 	 */
-- 
2.16.5

