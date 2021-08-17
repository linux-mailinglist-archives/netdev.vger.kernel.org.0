Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66C73EE5C4
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 06:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbhHQEpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 00:45:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42628 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230272AbhHQEpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 00:45:40 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2m19D006952;
        Mon, 16 Aug 2021 21:45:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=svlnJv0LSaHrqusMARLAEk4mXw9g+SWN7Nc8dzpXfxI=;
 b=kDbZnsLe86LMyy97davbrvjHbVzNxAVblf460HOUwFvjRq3bf4L6uoqenqmwp4TSRNY4
 BwNlAEhmqojET+QqqxWHWYxzBcXOtEDJKlV2Iz8LvcP8Z0gCoDbUOQnABp80OFPxh0iY
 719gYeg1UoI7DwNVLlVzBj+46wIy3oli3qRhxqQfiNCObhb3ENdZl+ZaHtMjZpI9o14F
 QJOqEcCaDw74Iu3A4/SVkhQEo22j6bUD+Va+SxOFFxYa3ymA60GOavmND1pKJYDNXLjB
 HsZOaZULmX4DDosQxNTLkDdbGGFTwG7rkg4/0AuR6yn88Ecq2g10CoAA48zzT9PhagWn Hw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0ra4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 21:45:06 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 21:45:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 21:45:04 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 5E5AD3F70A9;
        Mon, 16 Aug 2021 21:45:00 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 01/11] octeontx2-af: Modify install flow error codes
Date:   Tue, 17 Aug 2021 10:14:43 +0530
Message-ID: <1629175493-4895-2-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
References: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: WxpqwXC9Orkv4vSHOn6WS_Lcf-OnwQEd
X-Proofpoint-ORIG-GUID: WxpqwXC9Orkv4vSHOn6WS_Lcf-OnwQEd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When installing a flow using npc_install_flow
mailbox there are number of reasons to reject
the request like caller is not permitted,
invalid channel specified in request, flow
not supported in extraction profile and so on.
Hence define new error codes for npc flows and use
them instead of generic error codes.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h       |  7 +++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 16 ++++++++--------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 4470933..3ad10a4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1078,6 +1078,13 @@ enum npc_af_status {
 	NPC_MCAM_ALLOC_DENIED	= -702,
 	NPC_MCAM_ALLOC_FAILED	= -703,
 	NPC_MCAM_PERM_DENIED	= -704,
+	NPC_FLOW_INTF_INVALID	= -707,
+	NPC_FLOW_CHAN_INVALID	= -708,
+	NPC_FLOW_NO_NIXLF	= -709,
+	NPC_FLOW_NOT_SUPPORTED	= -710,
+	NPC_FLOW_VF_PERM_DENIED	= -711,
+	NPC_FLOW_VF_NOT_INIT	= -712,
+	NPC_FLOW_VF_OVERLAP	= -713,
 };
 
 struct npc_mcam_alloc_entry_req {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 5c01cf4..fd07562 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -600,7 +600,7 @@ static int npc_check_unsupported_flows(struct rvu *rvu, u64 features, u8 intf)
 		dev_info(rvu->dev, "Unsupported flow(s):\n");
 		for_each_set_bit(bit, (unsigned long *)&unsupported, 64)
 			dev_info(rvu->dev, "%s ", npc_get_field_name(bit));
-		return NIX_AF_ERR_NPC_KEY_NOT_SUPP;
+		return -EOPNOTSUPP;
 	}
 
 	return 0;
@@ -1143,10 +1143,10 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 	}
 
 	if (!is_npc_interface_valid(rvu, req->intf))
-		return -EINVAL;
+		return NPC_FLOW_INTF_INVALID;
 
 	if (from_vf && req->default_rule)
-		return NPC_MCAM_PERM_DENIED;
+		return NPC_FLOW_VF_PERM_DENIED;
 
 	/* Each PF/VF info is maintained in struct rvu_pfvf.
 	 * rvu_pfvf for the target PF/VF needs to be retrieved
@@ -1172,12 +1172,12 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 
 	err = npc_check_unsupported_flows(rvu, req->features, req->intf);
 	if (err)
-		return err;
+		return NPC_FLOW_NOT_SUPPORTED;
 
 	/* Skip channel validation if AF is installing */
 	if (!is_pffunc_af(req->hdr.pcifunc) &&
 	    npc_mcam_verify_channel(rvu, target, req->intf, req->channel))
-		return -EINVAL;
+		return NPC_FLOW_CHAN_INVALID;
 
 	pfvf = rvu_get_pfvf(rvu, target);
 
@@ -1195,7 +1195,7 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 	/* Proceed if NIXLF is attached or not for TX rules */
 	err = nix_get_nixlf(rvu, target, &nixlf, NULL);
 	if (err && is_npc_intf_rx(req->intf) && !pf_set_vfs_mac)
-		return -EINVAL;
+		return NPC_FLOW_NO_NIXLF;
 
 	/* don't enable rule when nixlf not attached or initialized */
 	if (!(is_nixlf_attached(rvu, target) &&
@@ -1211,7 +1211,7 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 
 	/* Do not allow requests from uninitialized VFs */
 	if (from_vf && !enable)
-		return -EINVAL;
+		return NPC_FLOW_VF_NOT_INIT;
 
 	/* PF sets VF mac & VF NIXLF is not attached, update the mac addr */
 	if (pf_set_vfs_mac && !enable) {
@@ -1226,7 +1226,7 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 	 */
 	if (from_vf && pfvf->def_ucast_rule && is_npc_intf_rx(req->intf) &&
 	    pfvf->def_ucast_rule->features & req->features)
-		return -EINVAL;
+		return NPC_FLOW_VF_OVERLAP;
 
 	return npc_install_flow(rvu, blkaddr, target, nixlf, pfvf, req, rsp,
 				enable, pf_set_vfs_mac);
-- 
2.7.4

