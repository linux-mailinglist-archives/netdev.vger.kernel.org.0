Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C713F3F32
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 14:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbhHVMDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 08:03:49 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26950 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233491AbhHVMDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 08:03:45 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17MBLSwS006972;
        Sun, 22 Aug 2021 05:03:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=vMPO17NFbaw7qXt5KjfFKE+yyDoD5Tx/Njmm7W4fCOk=;
 b=cKkyjpVmnBDxRXwjUDOE9rCZjTatznmXOEBuMGW69QsH+FC4jf5aWbSKbsbpJjYBkxjw
 U28Koc1h/OGvNUrXCYyhpIUQn82P0V0qRcT0CiFHvrP82zF5BLiyDR6LmpQk9gpnYCWd
 MAnknQybgyCQ9TijTRjKuOlpwL0XIk3XeL3zVXNyY/4bFfybzasrkJl/H00wDvJ9Eesc
 3Cabj/7BBG6eVT/MsEq6JUHIlQz5EhOLOvdhj2CCjPKUoPHQEpP4Ho1hQYhJICYf4gPO
 QsuaM0r6W9vUhmtCzhA1zYAT1cjC9icJKfI2cB42Ad6tc/pB+jxm5pJFeE6veKGN2whn +Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ak10mtr6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 22 Aug 2021 05:03:02 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Sun, 22 Aug
 2021 05:03:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.23 via Frontend
 Transport; Sun, 22 Aug 2021 05:03:00 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id C46933F7061;
        Sun, 22 Aug 2021 05:02:58 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [net PATCH 10/10] octeontx2-af: cn10k: Use FLIT0 register instead of FLIT1
Date:   Sun, 22 Aug 2021 17:32:27 +0530
Message-ID: <1629633747-22061-11-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
References: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: HmIqPs-_YTpU0QnxfDH8zM1S0CWCT_yM
X-Proofpoint-ORIG-GUID: HmIqPs-_YTpU0QnxfDH8zM1S0CWCT_yM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-21_11,2021-08-20_03,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

RVU SMMU widget stores the final translated PA at
RVU_AF_SMMU_TLN_FLIT0<57:18> instead of FLIT1 register. This patch
fixes the address translation logic to use the correct register.

Fixes: 893ae97214c3 ("octeontx2-af: cn10k: Support configurable LMTST regions")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c | 4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index 28dcce7..dbe9149 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -82,10 +82,10 @@ static int rvu_get_lmtaddr(struct rvu *rvu, u16 pcifunc,
 		dev_err(rvu->dev, "%s LMTLINE iova transulation failed err:%llx\n", __func__, val);
 		return -EIO;
 	}
-	/* PA[51:12] = RVU_AF_SMMU_TLN_FLIT1[60:21]
+	/* PA[51:12] = RVU_AF_SMMU_TLN_FLIT0[57:18]
 	 * PA[11:0] = IOVA[11:0]
 	 */
-	pa = rvu_read64(rvu, BLKADDR_RVUM, RVU_AF_SMMU_TLN_FLIT1) >> 21;
+	pa = rvu_read64(rvu, BLKADDR_RVUM, RVU_AF_SMMU_TLN_FLIT0) >> 18;
 	pa &= GENMASK_ULL(39, 0);
 	*lmt_addr = (pa << 12) | (iova  & 0xFFF);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 8b01ef6..4215841 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -53,7 +53,7 @@
 #define RVU_AF_SMMU_TXN_REQ		    (0x6008)
 #define RVU_AF_SMMU_ADDR_RSP_STS	    (0x6010)
 #define RVU_AF_SMMU_ADDR_TLN		    (0x6018)
-#define RVU_AF_SMMU_TLN_FLIT1		    (0x6030)
+#define RVU_AF_SMMU_TLN_FLIT0		    (0x6020)
 
 /* Admin function's privileged PF/VF registers */
 #define RVU_PRIV_CONST                      (0x8000000)
-- 
2.7.4

