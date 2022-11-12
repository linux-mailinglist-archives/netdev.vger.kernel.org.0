Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED506266FA
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 05:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbiKLEel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 23:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234679AbiKLEcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 23:32:54 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29AC61B99;
        Fri, 11 Nov 2022 20:32:30 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AC1FwAX018992;
        Fri, 11 Nov 2022 20:32:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=qlZ5L8Q+hUZ5WYrawcPYm2F1OUivMCPfG9xh1VErLmc=;
 b=g3JMKDrDOtIoUgOfgLAyTEs5ef/0Uz+QIPpRYJNdUdadcTizmnKfrU/+9PPmX3TZ0jBz
 QC7roBmcx3V9YJ16J9hFcd1XD+FkpVhOJuNI9iyEq8y017ecT++tt0PJI3sVhJwpZT5R
 p5bWrk4NkFZVEvcmb2qlpd9aGpUDeHDt7RglIOzd5Vf9+l0UyFBMHnj6lDaysPcwSxDi
 CENAm1MCqh2VpA3pToh6x9CvzhEBkS7a84fG6TJznIip/1ywjQnkOmPEkcKRZWRnHMgl
 pQK/M/pRvf91J5/4IyW6mD8VYJ/7jHZOQQFClfZMdmcd4k/o1qxMOgGjqtIlZ6SBBXkr uw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kt1nv0bf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 20:32:24 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Nov
 2022 20:32:23 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 11 Nov 2022 20:32:23 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 07D903F7048;
        Fri, 11 Nov 2022 20:32:18 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: [net-next PATCH 9/9] octeontx2-af: Add programmed macaddr to RVU pfvf
Date:   Sat, 12 Nov 2022 10:01:41 +0530
Message-ID: <20221112043141.13291-10-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221112043141.13291-1-hkelam@marvell.com>
References: <20221112043141.13291-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: zYwb1PUs8_OyX8SAVBs2o9hl713gmjBi
X-Proofpoint-GUID: zYwb1PUs8_OyX8SAVBs2o9hl713gmjBi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-12_02,2022-11-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vidhya Vidhyaraman <Vidhya.Raman@cavium.com>

This commit adds the mac address that is programmed from
application into the RVU pfvf structure. The mac address
retrieval will return the address from RVU pfvf structure.

Signed-off-by: Vidhya Vidhyaraman <Vidhya.Raman@cavium.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 26 +++++++++----------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 60c77db3ba6d..2f280c97712a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -626,16 +626,19 @@ int rvu_mbox_handler_cgx_mac_addr_set(struct rvu *rvu,
 				      struct cgx_mac_addr_set_or_get *rsp)
 {
 	int pf = rvu_get_pf(req->hdr.pcifunc);
+	struct rvu_pfvf *pfvf;
 	u8 cgx_id, lmac_id;
 
-	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
-		return -EPERM;
+	if (!is_pf_cgxmapped(rvu, pf))
+		return LMAC_AF_ERR_PF_NOT_MAPPED;
 
 	if (rvu_npc_exact_has_match_table(rvu))
 		return rvu_npc_exact_mac_addr_set(rvu, req, rsp);
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
+	pfvf = &rvu->pf[pf];
+	memcpy(pfvf->mac_addr, req->mac_addr, ETH_ALEN);
 	cgx_lmac_addr_set(cgx_id, lmac_id, req->mac_addr);
 
 	return 0;
@@ -713,21 +716,16 @@ int rvu_mbox_handler_cgx_mac_addr_get(struct rvu *rvu,
 				      struct cgx_mac_addr_set_or_get *req,
 				      struct cgx_mac_addr_set_or_get *rsp)
 {
-	int pf = rvu_get_pf(req->hdr.pcifunc);
-	u8 cgx_id, lmac_id;
-	int rc = 0, i;
-	u64 cfg;
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
+	int i;
 
-	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
-		return -EPERM;
-
-	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	if (!is_pf_cgxmapped(rvu, rvu_get_pf(req->hdr.pcifunc)))
+		return LMAC_AF_ERR_PF_NOT_MAPPED;
 
-	rsp->hdr.rc = rc;
-	cfg = cgx_lmac_addr_get(cgx_id, lmac_id);
-	/* copy 48 bit mac address to req->mac_addr */
+	/* copy 48 bit mac address to rsp->mac_addr */
 	for (i = 0; i < ETH_ALEN; i++)
-		rsp->mac_addr[i] = cfg >> (ETH_ALEN - 1 - i) * 8;
+		rsp->mac_addr[i] = pfvf->mac_addr[i];
+
 	return 0;
 }
 
-- 
2.17.1

