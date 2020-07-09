Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1425C219685
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 05:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgGIDPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 23:15:00 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23424 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726107AbgGIDPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 23:15:00 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0693BljE006951;
        Wed, 8 Jul 2020 20:14:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=A7xf4HnnKkp9cKBBE4Jxj673KXi33rdsPe8t/Qxclpo=;
 b=aQcN1GAJXKobcM3AYAidkgFbg3SUAyMbz+o7pQsAQzhqTdBrDe37fDDV1AnqL0KuTmzD
 JUmohQ268lRCV9yZzXExghTzrz2dB6FYal7NY0F9RP1qY30NBjg/LMuTIjW1Hlv4zD0v
 k5gP/TNlDSf7zGvR+vccTVhEuIXFMl3qEoOBWuPdx6HE6q6JtMfTwvQ7/dY4acvayBbu
 qbfm8eooPU3UsSxqZH/zQ2IyJ9rW+HSNsbvoyENfVcKjdbQcaBuBNIxO655fp5oeHnWM
 F55Wo/t0mVhnzN0CClUHX5Gq2dqbl5mYjwiWbhdntBS8T0c0S1FGpxsXr6rWwF65szvJ 1Q== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 325jyv1p6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 20:14:58 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 8 Jul
 2020 20:14:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 8 Jul 2020 20:14:56 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8116C3F703F;
        Wed,  8 Jul 2020 20:14:56 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0693EuVb008304;
        Wed, 8 Jul 2020 20:14:56 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0693EthC008303;
        Wed, 8 Jul 2020 20:14:55 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net v3 1/1] qed: Populate nvm-file attributes while reading nvm config partition.
Date:   Wed, 8 Jul 2020 20:14:29 -0700
Message-ID: <20200709031429.8267-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_19:2020-07-08,2020-07-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NVM config file address will be modified when the MBI image is upgraded.
Driver would return stale config values if user reads the nvm-config
(via ethtool -d) in this state. The fix is to re-populate nvm attribute
info while reading the nvm config values/partition.

Changes from previous version:
-------------------------------
v3: Corrected the formatting in 'Fixes' tag.
v2: Added 'Fixes' tag.

Fixes: 1ac4329a1cff ("qed: Add configuration information to register dump and debug data")
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_debug.c |  4 ++++
 drivers/net/ethernet/qlogic/qed/qed_dev.c   | 12 +++---------
 drivers/net/ethernet/qlogic/qed/qed_mcp.c   |  7 +++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h   |  7 +++++++
 4 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index cb80863..3b9bbaf 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -7941,6 +7941,10 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 		DP_ERR(cdev, "qed_dbg_mcp_trace failed. rc = %d\n", rc);
 	}
 
+	/* Re-populate nvm attribute info */
+	qed_mcp_nvm_info_free(p_hwfn);
+	qed_mcp_nvm_info_populate(p_hwfn);
+
 	/* nvm cfg1 */
 	rc = qed_dbg_nvm_image(cdev,
 			       (u8 *)buffer + offset +
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 3aa5137..9c26fde 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -4472,12 +4472,6 @@ static int qed_get_dev_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	return 0;
 }
 
-static void qed_nvm_info_free(struct qed_hwfn *p_hwfn)
-{
-	kfree(p_hwfn->nvm_info.image_att);
-	p_hwfn->nvm_info.image_att = NULL;
-}
-
 static int qed_hw_prepare_single(struct qed_hwfn *p_hwfn,
 				 void __iomem *p_regview,
 				 void __iomem *p_doorbells,
@@ -4562,7 +4556,7 @@ static int qed_hw_prepare_single(struct qed_hwfn *p_hwfn,
 	return rc;
 err3:
 	if (IS_LEAD_HWFN(p_hwfn))
-		qed_nvm_info_free(p_hwfn);
+		qed_mcp_nvm_info_free(p_hwfn);
 err2:
 	if (IS_LEAD_HWFN(p_hwfn))
 		qed_iov_free_hw_info(p_hwfn->cdev);
@@ -4623,7 +4617,7 @@ int qed_hw_prepare(struct qed_dev *cdev,
 		if (rc) {
 			if (IS_PF(cdev)) {
 				qed_init_free(p_hwfn);
-				qed_nvm_info_free(p_hwfn);
+				qed_mcp_nvm_info_free(p_hwfn);
 				qed_mcp_free(p_hwfn);
 				qed_hw_hwfn_free(p_hwfn);
 			}
@@ -4657,7 +4651,7 @@ void qed_hw_remove(struct qed_dev *cdev)
 
 	qed_iov_free_hw_info(cdev);
 
-	qed_nvm_info_free(p_hwfn);
+	qed_mcp_nvm_info_free(p_hwfn);
 }
 
 static void qed_chain_free_next_ptr(struct qed_dev *cdev,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 9624616..0fd4520 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -3280,6 +3280,13 @@ int qed_mcp_nvm_info_populate(struct qed_hwfn *p_hwfn)
 	return rc;
 }
 
+void qed_mcp_nvm_info_free(struct qed_hwfn *p_hwfn)
+{
+	kfree(p_hwfn->nvm_info.image_att);
+	p_hwfn->nvm_info.image_att = NULL;
+	p_hwfn->nvm_info.valid = false;
+}
+
 int
 qed_mcp_get_nvm_image_att(struct qed_hwfn *p_hwfn,
 			  enum qed_nvm_images image_id,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index 5750b4c..12a705e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -1221,6 +1221,13 @@ void qed_mcp_resc_lock_default_init(struct qed_resc_lock_params *p_lock,
 int qed_mcp_nvm_info_populate(struct qed_hwfn *p_hwfn);
 
 /**
+ * @brief Delete nvm info shadow in the given hardware function
+ *
+ * @param p_hwfn
+ */
+void qed_mcp_nvm_info_free(struct qed_hwfn *p_hwfn);
+
+/**
  * @brief Get the engine affinity configuration.
  *
  * @param p_hwfn
-- 
1.8.3.1

