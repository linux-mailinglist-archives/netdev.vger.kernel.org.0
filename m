Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6FE279788
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 09:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgIZHdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 03:33:18 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21090 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726149AbgIZHdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 03:33:17 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08Q7U93O013751;
        Sat, 26 Sep 2020 00:33:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=gg+ODcnfgXjJnOI1WEG9pWspGjaFMPYqxd78nofyjJw=;
 b=fCnxI64X3cHDaAJ+ZTeTTAnOOBomWZ2Q7Y0wHUfDvxhEGgXU9icP59JaPUhBtj1ArY6u
 STzkBMaNBOORYy2lFf7kVPNpYNfVJOIWwSXTJzSw6EyqQiLxzMmMrkYVYxd0elanSDe7
 BIGFHDFBGLO/k3bs8uIxQifNkNu8C2ZaxhX+VPAfl9UR66EcMJ3BdZpt/tADGTuPqFey
 kE8M6v1DrJbgxK7ADhev2vLgQRipatqEVgbjeEURSKmifhWrMyR8HWbulhTVPaOieJbQ
 lz4xn6wanz017cw1OVRSzPE0Dr5idRdnED9wHE4EGbEJSBWJkY6pePmmcl9sI60FvngQ mg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 33nhgnydc9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 00:33:15 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 26 Sep
 2020 00:33:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 26 Sep
 2020 00:33:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 26 Sep 2020 00:33:13 -0700
Received: from cavium.com.marvell.com (unknown [10.29.8.35])
        by maili.marvell.com (Postfix) with ESMTP id CD0513F7040;
        Sat, 26 Sep 2020 00:33:10 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <jerinj@marvell.com>, <davem@davemloft.net>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "Geetha sowjanya" <gakula@marvell.com>
Subject: [net PATCH] octeontx2-af: Fix enable/disable of default NPC entries
Date:   Sat, 26 Sep 2020 12:27:00 +0530
Message-ID: <1601103420-1591-1-git-send-email-gakula@marvell.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_06:2020-09-24,2020-09-26 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Packet replication feature present in Octeontx2
is a hardware linked list of PF and its VF
interfaces so that broadcast packets are sent
to all interfaces present in the list. It is
driver job to add and delete a PF/VF interface
to/from the list when the interface is brought
up and down. This patch fixes the
npc_enadis_default_entries function to handle
broadcast replication properly if packet replication
feature is present.

Fixes: 40df309e4166
("octeontx2-af: Support to enable/disable default MCAM entries")

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  3 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  5 ++---
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 26 ++++++++++++++++------
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index dcf25a0..b89dde2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -463,6 +463,7 @@ void rvu_nix_freemem(struct rvu *rvu);
 int rvu_get_nixlf_count(struct rvu *rvu);
 void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int npalf);
 int nix_get_nixlf(struct rvu *rvu, u16 pcifunc, int *nixlf, int *nix_blkaddr);
+int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add);
 
 /* NPC APIs */
 int rvu_npc_init(struct rvu *rvu);
@@ -477,7 +478,7 @@ void rvu_npc_disable_promisc_entry(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_enable_promisc_entry(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 				       int nixlf, u64 chan);
-void rvu_npc_disable_bcast_entry(struct rvu *rvu, u16 pcifunc);
+void rvu_npc_enable_bcast_entry(struct rvu *rvu, u16 pcifunc, bool enable);
 int rvu_npc_update_rxvlan(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 01a7931..0fc7082 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -17,7 +17,6 @@
 #include "npc.h"
 #include "cgx.h"
 
-static int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add);
 static int rvu_nix_get_bpid(struct rvu *rvu, struct nix_bp_cfg_req *req,
 			    int type, int chan_id);
 
@@ -2020,7 +2019,7 @@ static int nix_update_mce_list(struct nix_mce_list *mce_list,
 	return 0;
 }
 
-static int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add)
+int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add)
 {
 	int err = 0, idx, next_idx, last_idx;
 	struct nix_mce_list *mce_list;
@@ -2065,7 +2064,7 @@ static int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add)
 
 	/* Disable MCAM entry in NPC */
 	if (!mce_list->count) {
-		rvu_npc_disable_bcast_entry(rvu, pcifunc);
+		rvu_npc_enable_bcast_entry(rvu, pcifunc, false);
 		goto end;
 	}
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 0a21408..fbaf9bc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -530,7 +530,7 @@ void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 			      NIX_INTF_RX, &entry, true);
 }
 
-void rvu_npc_disable_bcast_entry(struct rvu *rvu, u16 pcifunc)
+void rvu_npc_enable_bcast_entry(struct rvu *rvu, u16 pcifunc, bool enable)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	int blkaddr, index;
@@ -543,7 +543,7 @@ void rvu_npc_disable_bcast_entry(struct rvu *rvu, u16 pcifunc)
 	pcifunc = pcifunc & ~RVU_PFVF_FUNC_MASK;
 
 	index = npc_get_nixlf_mcam_index(mcam, pcifunc, 0, NIXLF_BCAST_ENTRY);
-	npc_enable_mcam_entry(rvu, mcam, blkaddr, index, false);
+	npc_enable_mcam_entry(rvu, mcam, blkaddr, index, enable);
 }
 
 void rvu_npc_update_flowkey_alg_idx(struct rvu *rvu, u16 pcifunc, int nixlf,
@@ -622,23 +622,35 @@ static void npc_enadis_default_entries(struct rvu *rvu, u16 pcifunc,
 					 nixlf, NIXLF_UCAST_ENTRY);
 	npc_enable_mcam_entry(rvu, mcam, blkaddr, index, enable);
 
-	/* For PF, ena/dis promisc and bcast MCAM match entries */
-	if (pcifunc & RVU_PFVF_FUNC_MASK)
+	/* For PF, ena/dis promisc and bcast MCAM match entries.
+	 * For VFs add/delete from bcast list when RX multicast
+	 * feature is present.
+	 */
+	if (pcifunc & RVU_PFVF_FUNC_MASK && !rvu->hw->cap.nix_rx_multicast)
 		return;
 
 	/* For bcast, enable/disable only if it's action is not
 	 * packet replication, incase if action is replication
-	 * then this PF's nixlf is removed from bcast replication
+	 * then this PF/VF's nixlf is removed from bcast replication
 	 * list.
 	 */
-	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
+	index = npc_get_nixlf_mcam_index(mcam, pcifunc & ~RVU_PFVF_FUNC_MASK,
 					 nixlf, NIXLF_BCAST_ENTRY);
 	bank = npc_get_bank(mcam, index);
 	*(u64 *)&action = rvu_read64(rvu, blkaddr,
 	     NPC_AF_MCAMEX_BANKX_ACTION(index & (mcam->banksize - 1), bank));
-	if (action.op != NIX_RX_ACTIONOP_MCAST)
+
+	/* VFs will not have BCAST entry */
+	if (action.op != NIX_RX_ACTIONOP_MCAST &&
+	    !(pcifunc & RVU_PFVF_FUNC_MASK)) {
 		npc_enable_mcam_entry(rvu, mcam,
 				      blkaddr, index, enable);
+	} else {
+		nix_update_bcast_mce_list(rvu, pcifunc, enable);
+		/* Enable PF's BCAST entry for packet replication */
+		rvu_npc_enable_bcast_entry(rvu, pcifunc, enable);
+	}
+
 	if (enable)
 		rvu_npc_enable_promisc_entry(rvu, pcifunc, nixlf);
 	else
-- 
2.7.4

