Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12AC23657CD
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 13:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhDTLo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 07:44:59 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50508 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230491AbhDTLo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 07:44:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13KBebXA007594;
        Tue, 20 Apr 2021 04:44:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=1mkCPIcb/JpmKKXHAQuPOJMejhta2XzkzzasuEmNKlY=;
 b=TqTQPPsQ3ZwWBx6GhhD8ZoxbTVmhLkwMUzVd8NLGL9VLD38g8gusveIA+hb4+1YQCozz
 4tEa4g0U43t+9uVNskvypMnyHX3TBdr3huvEDTzAqEjixdalGD+rnBFJ/UD1yf2bN5A6
 IAn2FnItLbYLijoHkPVkIWSK7WyO9mMuGUOOb1EMXtMJ+Hq4I8adp2i0r5iCcwfJ4Upp
 VQR8pYXP2aXo19mOyXmuCwijiwSKKyT6EM348K+RdDxNqbV6npkvdKeG5Bm49vxCI5+o
 ElOPyjnWOr5TfplQCJARhC9Odczi5DnGSsR0k0tHD8DhWoG++KTyaeH3lLq2zwDuMq2M yw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 381ryvrywk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 04:44:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 04:44:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Apr 2021 04:44:20 -0700
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 0C3263F7040;
        Tue, 20 Apr 2021 04:44:16 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <pathreya@marvell.com>, "Srujana Challa" <schalla@marvell.com>,
        Vidya Sagar Velumuri <vvelumuri@marvell.com>
Subject: [PATCH 1/3] octeontx2-af: cn10k: Mailbox changes for CN10K CPT
Date:   Tue, 20 Apr 2021 17:13:47 +0530
Message-ID: <20210420114349.22640-2-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210420114349.22640-1-schalla@marvell.com>
References: <20210420114349.22640-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 3NsPItyXCLsecemRFIPzsbZ3aBEP_ViW
X-Proofpoint-GUID: 3NsPItyXCLsecemRFIPzsbZ3aBEP_ViW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_02:2021-04-19,2021-04-20 signatures=0
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
2.29.0

