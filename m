Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78DAA561896
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbiF3KzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbiF3KzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:55:21 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD844133B;
        Thu, 30 Jun 2022 03:55:21 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25U84bcH015732;
        Thu, 30 Jun 2022 03:55:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=2i29PaMcywSIHClBciOD80TrQpVS0dYcB/9AP/KqRl0=;
 b=hkjsntywwyYz5ikHnkgr6ed68Pshot4MbsNV5pQtycLRxQGJVPI7HJtguOpgIQzLMB1V
 DvtSCjrPOueRM4shoGkyiVFoHoGmtB4J4UWOEjhB3Y5dXFasE3d0QHQqjlUmGFGRfkiq
 dDvHgH7wiXH/3i6QctTJFeDIs2f5FUO5xsA+n8RUW02tEc63NHPCPM3iojewleLmx/KE
 liWqoevTiDlQ2X5DzcpnuRzsQyDeq+UZ9tRcrHzAPsx9Pc71Wa8XlroQPkZhoNlxtwrn
 BlC0qt3tzs5Z2PVY2jDkdBtEn6FI4/v/l2UvyrJEKDuMnw+zYbqQ0v8E45umb52OtorB SA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3h0f85ecvu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 03:55:01 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 30 Jun
 2022 03:55:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Jun 2022 03:55:00 -0700
Received: from localhost.localdomain (unknown [10.28.34.29])
        by maili.marvell.com (Postfix) with ESMTP id 649D83F7066;
        Thu, 30 Jun 2022 03:54:55 -0700 (PDT)
From:   Shijith Thotton <sthotton@marvell.com>
To:     Arnaud Ebalard <arno@natisbad.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Boris Brezillon <bbrezillon@kernel.org>
CC:     Shijith Thotton <sthotton@marvell.com>,
        <linux-crypto@vger.kernel.org>, <jerinj@marvell.com>,
        <sgoutham@marvell.com>, Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:MARVELL OCTEONTX2 RVU ADMIN FUNCTION DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] octeontx2-af: fix operand size in bitwise operation
Date:   Thu, 30 Jun 2022 16:24:31 +0530
Message-ID: <f4fba33fe4f89b420b4da11d51255e7cc6ea1dbf.1656586269.git.sthotton@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <6baefc0e5cddb99df98b6a96a15fbd0328b12bda.1653637964.git.sthotton@marvell.com>
References: <6baefc0e5cddb99df98b6a96a15fbd0328b12bda.1653637964.git.sthotton@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: wgDpD4ZzcycQxyPavz-aElEakR0df5l8
X-Proofpoint-ORIG-GUID: wgDpD4ZzcycQxyPavz-aElEakR0df5l8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_07,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Made size of operands same in bitwise operations.

The patch fixes the klocwork issue, operands in a bitwise operation have
different size at line 375 and 483.

Signed-off-by: Shijith Thotton <sthotton@marvell.com>
---
v2:
* Rebased.

 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index a9da85e418a4..38bbae5d9ae0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -17,7 +17,7 @@
 #define	PCI_DEVID_OTX2_CPT10K_PF 0xA0F2
 
 /* Length of initial context fetch in 128 byte words */
-#define CPT_CTX_ILEN    2
+#define CPT_CTX_ILEN    2ULL
 
 #define cpt_get_eng_sts(e_min, e_max, rsp, etype)                   \
 ({                                                                  \
@@ -480,7 +480,7 @@ static int cpt_inline_ipsec_cfg_inbound(struct rvu *rvu, int blkaddr, u8 cptlf,
 	 */
 	if (!is_rvu_otx2(rvu)) {
 		val = (ilog2(NIX_CHAN_CPT_X2P_MASK + 1) << 16);
-		val |= rvu->hw->cpt_chan_base;
+		val |= (u64)rvu->hw->cpt_chan_base;
 
 		rvu_write64(rvu, blkaddr, CPT_AF_X2PX_LINK_CFG(0), val);
 		rvu_write64(rvu, blkaddr, CPT_AF_X2PX_LINK_CFG(1), val);
-- 
2.25.1

