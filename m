Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB975215ADE
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbgGFPjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:39:02 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6748 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729254AbgGFPjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:39:00 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066FaHP4025568;
        Mon, 6 Jul 2020 08:38:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=/MlQpUdHQi/tPmeFZqTc9PApmsWBagd+PHi9+WAE3QA=;
 b=iUD+ydcv6yurBxSsWpHmt6D7IiMr/SVIoUCa72D43T+c5AXAvogWTCftork9FiEZ3P2n
 NrI+OVsrZdjtkMr97kGwovBYpbSp5T/DdS3SSTGLwFe0OWnA4n0dwpmeuI7q//47h1/G
 VycKzDN+u1zME5Xe6BZQR45zxUigBnBQ5pPsMbneVuh724CBC+SlzVTB3JiTUPksmEFe
 Qv3ANgwAG2wvGRLlpfuJdrCtNjSyJ3H6jr/+opd7fv6ACOAuziZt54WCddla3KoRHzz1
 9iSUwYUJRFNJPS7xu6nJMJPktOPDDoWvaRzaP87DWO3xG6AL9zpY+MpZ+kTBI6S5yK58 0Q== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 322q4pqm5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 08:38:59 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jul
 2020 08:38:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jul 2020 08:38:58 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 114D53F703F;
        Mon,  6 Jul 2020 08:38:54 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 2/9] net: qed: cleanup global structs declarations
Date:   Mon, 6 Jul 2020 18:38:14 +0300
Message-ID: <20200706153821.786-3-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706153821.786-1-alobakin@marvell.com>
References: <20200706153821.786-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_12:2020-07-06,2020-07-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix several sparse warnings by moving structs declarations into
the corresponding header files:

drivers/net/ethernet/qlogic/qed/qed_dcbx.c:2402:32: warning:
symbol 'qed_dcbnl_ops_pass' was not declared. Should it be static?

drivers/net/ethernet/qlogic/qed/qed_ll2.c:2754:26: warning: symbol
'qed_ll2_ops_pass' was not declared. Should it be static?

drivers/net/ethernet/qlogic/qed/qed_ptp.c:449:30: warning: symbol
'qed_ptp_ops_pass' was not declared. Should it be static?

drivers/net/ethernet/qlogic/qed/qed_sriov.c:5265:29: warning:
symbol 'qed_iov_ops_pass' was not declared. Should it be static?

(some of them were declared twice in different header files)

Also make qed_hw_err_type_descr[] const while at it.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dcbx.h  |  2 ++
 drivers/net/ethernet/qlogic/qed/qed_fcoe.h  |  5 -----
 drivers/net/ethernet/qlogic/qed/qed_iscsi.h |  4 ----
 drivers/net/ethernet/qlogic/qed/qed_l2.c    | 12 ++----------
 drivers/net/ethernet/qlogic/qed/qed_ll2.h   |  2 ++
 drivers/net/ethernet/qlogic/qed/qed_main.c  |  4 ++--
 drivers/net/ethernet/qlogic/qed/qed_ptp.c   |  1 +
 drivers/net/ethernet/qlogic/qed/qed_ptp.h   |  9 +++++++++
 drivers/net/ethernet/qlogic/qed/qed_sriov.h |  2 ++
 9 files changed, 20 insertions(+), 21 deletions(-)
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_ptp.h

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dcbx.h b/drivers/net/ethernet/qlogic/qed/qed_dcbx.h
index ba5f3927034c..e1798925b444 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dcbx.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_dcbx.h
@@ -81,6 +81,8 @@ struct qed_dcbx_mib_meta_data {
 	u32 addr;
 };
 
+extern const struct qed_eth_dcbnl_ops qed_dcbnl_ops_pass;
+
 #ifdef CONFIG_DCB
 int qed_dcbx_get_config_params(struct qed_hwfn *, struct qed_dcbx_set *);
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_fcoe.h b/drivers/net/ethernet/qlogic/qed/qed_fcoe.h
index 13c5ccfe06e7..19c85adf4ceb 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_fcoe.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_fcoe.h
@@ -45,9 +45,4 @@ static inline void qed_get_protocol_stats_fcoe(struct qed_dev *cdev,
 }
 #endif /* CONFIG_QED_FCOE */
 
-#ifdef CONFIG_QED_LL2
-extern const struct qed_common_ops qed_common_ops_pass;
-extern const struct qed_ll2_ops qed_ll2_ops_pass;
-#endif
-
 #endif /* _QED_FCOE_H */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iscsi.h b/drivers/net/ethernet/qlogic/qed/qed_iscsi.h
index d6af7ea19bbb..dab7a5d09f87 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iscsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_iscsi.h
@@ -26,10 +26,6 @@ struct qed_iscsi_info {
 	iscsi_event_cb_t event_cb;
 };
 
-#ifdef CONFIG_QED_LL2
-extern const struct qed_ll2_ops qed_ll2_ops_pass;
-#endif
-
 #if IS_ENABLED(CONFIG_QED_ISCSI)
 int qed_iscsi_alloc(struct qed_hwfn *p_hwfn);
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index 03dc804c92a9..bf02748f5185 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -24,6 +24,7 @@
 #include "qed.h"
 #include <linux/qed/qed_chain.h>
 #include "qed_cxt.h"
+#include "qed_dcbx.h"
 #include "qed_dev_api.h"
 #include <linux/qed/qed_eth_if.h>
 #include "qed_hsi.h"
@@ -31,6 +32,7 @@
 #include "qed_int.h"
 #include "qed_l2.h"
 #include "qed_mcp.h"
+#include "qed_ptp.h"
 #include "qed_reg_addr.h"
 #include "qed_sp.h"
 #include "qed_sriov.h"
@@ -2874,16 +2876,6 @@ static int qed_req_bulletin_update_mac(struct qed_dev *cdev, u8 *mac)
 	return 0;
 }
 
-#ifdef CONFIG_QED_SRIOV
-extern const struct qed_iov_hv_ops qed_iov_ops_pass;
-#endif
-
-#ifdef CONFIG_DCB
-extern const struct qed_eth_dcbnl_ops qed_dcbnl_ops_pass;
-#endif
-
-extern const struct qed_eth_ptp_ops qed_ptp_ops_pass;
-
 static const struct qed_eth_ops qed_eth_ops_pass = {
 	.common = &qed_common_ops_pass,
 #ifdef CONFIG_QED_SRIOV
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.h b/drivers/net/ethernet/qlogic/qed/qed_ll2.h
index 8356c7d4a193..500d0c4f8077 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.h
@@ -116,6 +116,8 @@ struct qed_ll2_info {
 	struct qed_ll2_cbs cbs;
 };
 
+extern const struct qed_ll2_ops qed_ll2_ops_pass;
+
 /**
  * @brief qed_ll2_acquire_connection - allocate resources,
  *        starts rx & tx (if relevant) queues pair. Provides
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 98527e42f918..236013da9453 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -2451,7 +2451,7 @@ void qed_schedule_recovery_handler(struct qed_hwfn *p_hwfn)
 		ops->schedule_recovery_handler(cookie);
 }
 
-static char *qed_hw_err_type_descr[] = {
+static const char * const qed_hw_err_type_descr[] = {
 	[QED_HW_ERR_FAN_FAIL]		= "Fan Failure",
 	[QED_HW_ERR_MFW_RESP_FAIL]	= "MFW Response Failure",
 	[QED_HW_ERR_HW_ATTN]		= "HW Attention",
@@ -2466,7 +2466,7 @@ void qed_hw_error_occurred(struct qed_hwfn *p_hwfn,
 {
 	struct qed_common_cb_ops *ops = p_hwfn->cdev->protocol_ops.common;
 	void *cookie = p_hwfn->cdev->ops_cookie;
-	char *err_str;
+	const char *err_str;
 
 	if (err_type > QED_HW_ERR_LAST)
 		err_type = QED_HW_ERR_LAST;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ptp.c b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
index 3bd2f8c961c9..2c62d732e5c2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ptp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
@@ -10,6 +10,7 @@
 #include "qed_hw.h"
 #include "qed_l2.h"
 #include "qed_mcp.h"
+#include "qed_ptp.h"
 #include "qed_reg_addr.h"
 
 /* 16 nano second time quantas to wait before making a Drift adjustment */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ptp.h b/drivers/net/ethernet/qlogic/qed/qed_ptp.h
new file mode 100644
index 000000000000..40a11c0e1185
--- /dev/null
+++ b/drivers/net/ethernet/qlogic/qed/qed_ptp.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+/* Copyright (c) 2020 Marvell International Ltd. */
+
+#ifndef __QED_PTP_H
+#define __QED_PTP_H
+
+extern const struct qed_eth_ptp_ops qed_ptp_ops_pass;
+
+#endif /* __QED_PTP_H */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.h b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
index 552892c45670..eacd6457f195 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
@@ -246,6 +246,8 @@ enum qed_iov_wq_flag {
 	QED_IOV_WQ_VF_FORCE_LINK_QUERY_FLAG,
 };
 
+extern const struct qed_iov_hv_ops qed_iov_ops_pass;
+
 #ifdef CONFIG_QED_SRIOV
 /**
  * @brief Check if given VF ID @vfid is valid
-- 
2.25.1

