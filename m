Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3E33667DE
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 11:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238110AbhDUJYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 05:24:09 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4956 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238130AbhDUJYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 05:24:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13L9MPtA032465;
        Wed, 21 Apr 2021 02:23:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=zgcLLJkquPvtMuaqmXsViD6O7xkYlAU4cJnZvVnZmg0=;
 b=RNc29UtaLbAHptXUPZe1QFe/5HCWjmraUU7R6akLwKjSYW+KLm/1Ku/zZoibNujm11zP
 BNnRDCJpWD7WLV6KuugE0+ok9T3wckMT2C2XcatGc72zbjUeEccg3oMTdNJrvYahraOd
 spuTCs4w2jMf6q5GTQr2y6YhpeWyDaXzWsi3iNOSdu8EMnR259GJ360+LvwNt42Zpnkr
 KBNFKr6DYrJQvHYxKdYKFcluMkyWHEtkQIkdrk7s1zqfmhBJSlMpmWDAbRkoUodJeaeg
 fOp70KfBjiNFzzLSAcWk8Li/VfhR1JQlwPo78RfSmK2K3SUAnYZ9sKP4vwbt8KrqbRbA nA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3828x6hey0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 02:23:24 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 02:23:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 02:23:22 -0700
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 943963F703F;
        Wed, 21 Apr 2021 02:23:18 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <pathreya@marvell.com>, "Srujana Challa" <schalla@marvell.com>,
        Vidya Sagar Velumuri <vvelumuri@marvell.com>
Subject: [PATCH v2 1/3] octeontx2-af: cn10k: Mailbox changes for CN10K CPT
Date:   Wed, 21 Apr 2021 14:53:00 +0530
Message-ID: <20210421092302.22402-2-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210421092302.22402-1-schalla@marvell.com>
References: <20210421092302.22402-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: a5-hRgtIgo51UM6wxt7Stx96Jg_vr5Vu
X-Proofpoint-ORIG-GUID: a5-hRgtIgo51UM6wxt7Stx96Jg_vr5Vu
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_02:2021-04-21,2021-04-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds changes to existing CPT mailbox messages to support
CN10K CPT block. This patch also adds new register defines
for CN10K CPT.

Signed-off-by: Vidya Sagar Velumuri <vvelumuri@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 11 +++++++++-
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   | 21 +++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 0945c3a3b180..42c474957b69 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -9,6 +9,10 @@
 
 /* CPT PF device id */
 #define	PCI_DEVID_OTX2_CPT_PF	0xA0FD
+#define	PCI_DEVID_OTX2_CPT10K_PF 0xA0F2
+
+/* Length of initial context fetch in 128 byte words */
+#define CPT_CTX_ILEN    2
 
 static int get_cpt_pf_num(struct rvu *rvu)
 {
@@ -21,7 +25,8 @@ static int get_cpt_pf_num(struct rvu *rvu)
 		if (!pdev)
 			continue;
 
-		if (pdev->device == PCI_DEVID_OTX2_CPT_PF) {
+		if (pdev->device == PCI_DEVID_OTX2_CPT_PF ||
+		    pdev->device == PCI_DEVID_OTX2_CPT10K_PF) {
 			cpt_pf_num = i;
 			put_device(&pdev->dev);
 			break;
@@ -103,6 +108,9 @@ int rvu_mbox_handler_cpt_lf_alloc(struct rvu *rvu,
 
 		/* Set CPT LF group and priority */
 		val = (u64)req->eng_grpmsk << 48 | 1;
+		if (!is_rvu_otx2(rvu))
+			val |= (CPT_CTX_ILEN << 17);
+
 		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), val);
 
 		/* Set CPT LF NIX_PF_FUNC and SSO_PF_FUNC */
@@ -192,6 +200,7 @@ static bool is_valid_offset(struct rvu *rvu, struct cpt_rd_wr_reg_msg *req)
 		case CPT_AF_PF_FUNC:
 		case CPT_AF_BLK_RST:
 		case CPT_AF_CONSTANTS1:
+		case CPT_AF_CTX_FLUSH_TIMER:
 			return true;
 		}
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 3e401fd8ac63..ac71c0f2f960 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -494,6 +494,27 @@
 #define CPT_AF_RAS_INT_W1S              (0x47028)
 #define CPT_AF_RAS_INT_ENA_W1S          (0x47030)
 #define CPT_AF_RAS_INT_ENA_W1C          (0x47038)
+#define CPT_AF_CTX_FLUSH_TIMER          (0x48000ull)
+#define CPT_AF_CTX_ERR                  (0x48008ull)
+#define CPT_AF_CTX_ENC_ID               (0x48010ull)
+#define CPT_AF_CTX_MIS_PC		(0x49400ull)
+#define CPT_AF_CTX_HIT_PC		(0x49408ull)
+#define CPT_AF_CTX_AOP_PC		(0x49410ull)
+#define CPT_AF_CTX_AOP_LATENCY_PC       (0x49418ull)
+#define CPT_AF_CTX_IFETCH_PC            (0x49420ull)
+#define CPT_AF_CTX_IFETCH_LATENCY_PC    (0x49428ull)
+#define CPT_AF_CTX_FFETCH_PC            (0x49430ull)
+#define CPT_AF_CTX_FFETCH_LATENCY_PC    (0x49438ull)
+#define CPT_AF_CTX_WBACK_PC             (0x49440ull)
+#define CPT_AF_CTX_WBACK_LATENCY_PC     (0x49448ull)
+#define CPT_AF_CTX_PSH_PC               (0x49450ull)
+#define CPT_AF_CTX_PSH_LATENCY_PC       (0x49458ull)
+#define CPT_AF_RXC_TIME                 (0x50010ull)
+#define CPT_AF_RXC_TIME_CFG             (0x50018ull)
+#define CPT_AF_RXC_DFRG                 (0x50020ull)
+#define CPT_AF_RXC_ACTIVE_STS           (0x50028ull)
+#define CPT_AF_RXC_ZOMBIE_STS           (0x50030ull)
+#define CPT_AF_X2PX_LINK_CFG(a)         (0x51000ull | (u64)(a) << 3)
 
 #define AF_BAR2_ALIASX(a, b)            (0x9100000ull | (a) << 12 | (b))
 #define CPT_AF_BAR2_SEL                 0x9000000
-- 
2.25.1

