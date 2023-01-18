Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3BE671C57
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjARMmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjARMkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:40:31 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E87C80898
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 04:04:30 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I9ugC3028626;
        Wed, 18 Jan 2023 04:04:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=k62HJ5/ZtHuGj2U9kNlb7qsLc2hfWTOP/tlM15Sj9ik=;
 b=GWE05w8Mkbg3fQfH6y+GDKghQ0XKNQvfsL5ESynPBFJs7LveL9p1t6+CuAhFryjIZN/I
 7/cBpzVgrB21iOxjiwPxA2nHvRHWg9OM45q+ZhUXSaPnjJGaDWOobhmsiHB8c/qgOf5h
 ChQoPLFnVCxehRk+4PGgpCBcQhU/VDGxNHvQk+LdHvvm1TEKo4yksTku+gvefbXFdOiY
 QVF37cbgwNTGiAxlYxoL8hDxQD17oYW69e0Zmv2CdNd0+CIcZxPXFh+7IIVBBvCCWQ2y
 EjwZpmAS8IF2bwJJAqSR/hw9iD6+6a5Wl7whl5HTyNqYgoooqbxr87AYUlePQXzTZeck Gg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n3vstgucd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 04:04:24 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 18 Jan
 2023 04:04:22 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 18 Jan 2023 04:04:21 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 9A5A53F704E;
        Wed, 18 Jan 2023 04:04:18 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jerinj@marvell.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <schalla@marvell.com>
Subject: [PATCH net-next v3 6/7] octeontx2-af: update cpt lf alloc mailbox
Date:   Wed, 18 Jan 2023 17:33:53 +0530
Message-ID: <20230118120354.1017961-7-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230118120354.1017961-1-schalla@marvell.com>
References: <20230118120354.1017961-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: u-7YzYSNBstt-BuLC8wV22cO4dE_pBhL
X-Proofpoint-GUID: u-7YzYSNBstt-BuLC8wV22cO4dE_pBhL
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

The CN10K CPT coprocessor contains a context processor
to accelerate updates to the IPsec security association
contexts. The context processor contains a context cache.
This patch updates CPT LF ALLOC mailbox to config ctx_ilen
requested by VFs. CPT_LF_ALLOC:ctx_ilen is the size of
initial context fetch.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h    |  2 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c | 10 +++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 9eac73bfc9cb..abe86778b064 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1614,6 +1614,8 @@ struct cpt_lf_alloc_req_msg {
 	u16 sso_pf_func;
 	u16 eng_grpmsk;
 	int blkaddr;
+	u8 ctx_ilen_valid : 1;
+	u8 ctx_ilen : 7;
 };
 
 #define CPT_INLINE_INBOUND      0
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 302ff549284e..d7ca7e953683 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -17,7 +17,7 @@
 #define	PCI_DEVID_OTX2_CPT10K_PF 0xA0F2
 
 /* Length of initial context fetch in 128 byte words */
-#define CPT_CTX_ILEN    2ULL
+#define CPT_CTX_ILEN    1ULL
 
 #define cpt_get_eng_sts(e_min, e_max, rsp, etype)                   \
 ({                                                                  \
@@ -421,8 +421,12 @@ int rvu_mbox_handler_cpt_lf_alloc(struct rvu *rvu,
 
 		/* Set CPT LF group and priority */
 		val = (u64)req->eng_grpmsk << 48 | 1;
-		if (!is_rvu_otx2(rvu))
-			val |= (CPT_CTX_ILEN << 17);
+		if (!is_rvu_otx2(rvu)) {
+			if (req->ctx_ilen_valid)
+				val |= (req->ctx_ilen << 17);
+			else
+				val |= (CPT_CTX_ILEN << 17);
+		}
 
 		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), val);
 
-- 
2.25.1

