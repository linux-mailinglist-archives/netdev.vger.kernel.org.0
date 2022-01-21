Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C93F4959FE
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378719AbiAUGfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:35:22 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64506 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378729AbiAUGfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:35:22 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20L05k3P029271;
        Thu, 20 Jan 2022 22:35:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=30RzIWHj5uY7So1IXkM025Q7ssXw8O0P3wqmkpK2+ss=;
 b=d19kULp6AIRuoI+/iaqc0R/Qp2gVcZb3jFTETmD7rg7/sCBoeUbT7/z09pCM+G/g09Kz
 123KxY6moF96xWT+ebW3O6DWTqBIMPpUi+/J1IEqBadLkclpzx9Eek787S5rlQXYrcM9
 YHeRNliLhW8O9ft7/DoP4OnoUBtelPifR9i5WCKQzWqGwTJCX3SZeW3B+mjcQkshZhRD
 QsC3v4mRfAJSS6RKVHbTUNF1hyHNCdadU4L13QZ97rcJ34IOPHln4VBU6OCuaNemXoHQ
 trbeSsUwvcWmCKN8m9Z3Np/RVbkO6IjEuqc+8pncoFBlj+FvY35B5+qmYAq5f5on07yH 6Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dqj05gxxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 22:35:18 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 20 Jan
 2022 22:35:16 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 20 Jan 2022 22:35:16 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id CCED83F7097;
        Thu, 20 Jan 2022 22:35:13 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH 7/9] octeontx2-af: cn10k: Do not enable RPM loopback for LPC interfaces
Date:   Fri, 21 Jan 2022 12:04:45 +0530
Message-ID: <1642746887-30924-8-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
References: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 8X9eO4Up3Y_06VeF4OMIpX2AosUTOtkq
X-Proofpoint-ORIG-GUID: 8X9eO4Up3Y_06VeF4OMIpX2AosUTOtkq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_02,2022-01-20_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

Internal looback is not supported to low rate LPCS interface like
SGMII/QSGMII. Hence don't allow to enable for such interfaces.

Fixes: 3ad3f8f93c81 ("octeontx2-af: cn10k: MAC internal loopback support")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c | 27 +++++++++++--------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 4cbd915..9ea2f6a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -291,23 +291,20 @@ int rpm_lmac_internal_loopback(void *rpmd, int lmac_id, bool enable)
 	if (!rpm || lmac_id >= rpm->lmac_count)
 		return -ENODEV;
 	lmac_type = rpm->mac_ops->get_lmac_type(rpm, lmac_id);
-	if (lmac_type == LMAC_MODE_100G_R) {
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_PCS100X_CONTROL1);
-
-		if (enable)
-			cfg |= RPMX_MTI_PCS_LBK;
-		else
-			cfg &= ~RPMX_MTI_PCS_LBK;
-		rpm_write(rpm, lmac_id, RPMX_MTI_PCS100X_CONTROL1, cfg);
-	} else {
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_LPCSX_CONTROL1);
-		if (enable)
-			cfg |= RPMX_MTI_PCS_LBK;
-		else
-			cfg &= ~RPMX_MTI_PCS_LBK;
-		rpm_write(rpm, lmac_id, RPMX_MTI_LPCSX_CONTROL1, cfg);
+
+	if (lmac_type == LMAC_MODE_QSGMII || lmac_type == LMAC_MODE_SGMII) {
+		dev_err(&rpm->pdev->dev, "loopback not supported for LPC mode\n");
+		return 0;
 	}
 
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_PCS100X_CONTROL1);
+
+	if (enable)
+		cfg |= RPMX_MTI_PCS_LBK;
+	else
+		cfg &= ~RPMX_MTI_PCS_LBK;
+	rpm_write(rpm, lmac_id, RPMX_MTI_PCS100X_CONTROL1, cfg);
+
 	return 0;
 }
 
-- 
2.7.4

