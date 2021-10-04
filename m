Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6C542064A
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 09:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbhJDHCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 03:02:38 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62138 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232989AbhJDHBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 03:01:40 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 193KVrKa020063;
        Sun, 3 Oct 2021 23:59:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Q3YMm823IQkz3GmjcTsMhN6piUKCkpf6vjgE5V/NCzQ=;
 b=EZ9r738A+YbJE2Ntrq8n7qTOGRzT+kM5fFhGj4FoizJ8H3ICo3c37yCKuEKznjvUq/G3
 e5T7TiCw7j4tEpNOQbWKez5lz47QiIcjzMHEziGOslFlrBr5mtEnq3Ahon4RlKI+5BiV
 RLDCnDss64un1SzAbfY1dWrHf5AzLEw/iF7cJGQl931uY5+FxELo1InfxCo8ZBXC3znn
 iuzC7O3XZrrqLf4eOtxd9P6EGieJPLNmHUwGzPNcwyiVa1N1oZFkeDrniUURWk1tKLPr
 ePF3HbifyGW+65lBamxUwa7im5oJ4RW0IgbFUNwNFnEEIL2m1uyOmlGAzxR5TYSgQW9T rw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bfc9y9und-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 03 Oct 2021 23:59:48 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 3 Oct
 2021 23:59:46 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Sun, 3 Oct 2021 23:59:43 -0700
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <aelior@marvell.com>,
        <smalin@marvell.com>, <jhasan@marvell.com>,
        <mrangankar@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        Nikolay Assa <nassa@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>
Subject: [PATCH v2 11/13] qed: Update TCP silly-window-syndrome timeout for iwarp, scsi
Date:   Mon, 4 Oct 2021 09:58:49 +0300
Message-ID: <20211004065851.1903-12-pkushwaha@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20211004065851.1903-1-pkushwaha@marvell.com>
References: <20211004065851.1903-1-pkushwaha@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 57JLVA1CB8p7K0R4OCvIgo5oxHXUaOyj
X-Proofpoint-ORIG-GUID: 57JLVA1CB8p7K0R4OCvIgo5oxHXUaOyj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-04_02,2021-10-01_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Assa <nassa@marvell.com>

Update TCP silly-window-syndrome timeout, for the cases where
initiator's small TCP window size prevents FW from transmitting
packets on the connection. Timeout causes FW to retransmit
window probes if needed, preventing I/O stall if initiator ignores
first window probe.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nikolay Assa <nassa@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 1 +
 drivers/scsi/qedi/qedi_main.c               | 1 +
 include/linux/qed/qed_if.h                  | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index 186d0048a9d1..b2c0e522e51f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -114,6 +114,7 @@ qed_iwarp_init_fw_ramrod(struct qed_hwfn *p_hwfn,
 	    RESC_START(p_hwfn, QED_LL2_RAM_QUEUE) +
 	    p_hwfn->p_rdma_info->iwarp.ll2_ooo_handle;
 
+	p_ramrod->tcp.tx_sws_timer = cpu_to_le16(QED_TX_SWS_TIMER_DFLT);
 	p_ramrod->tcp.max_fin_rt = QED_IWARP_MAX_FIN_RT_DEFAULT;
 
 	return;
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index fe36ddb82aef..8c2f32655424 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -866,6 +866,7 @@ static int qedi_set_iscsi_pf_param(struct qedi_ctx *qedi)
 	qedi->pf_params.iscsi_pf_params.num_queues = qedi->num_queues;
 	qedi->pf_params.iscsi_pf_params.debug_mode = qedi_fw_debug;
 	qedi->pf_params.iscsi_pf_params.two_msl_timer = 4000;
+	qedi->pf_params.iscsi_pf_params.tx_sws_timer = QED_TX_SWS_TIMER_DFLT;
 	qedi->pf_params.iscsi_pf_params.max_fin_rt = 2;
 
 	for (log_page_size = 0 ; log_page_size < 32 ; log_page_size++) {
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 4dcd0d37a521..07f8d19421ab 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -24,6 +24,8 @@
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <net/devlink.h>
 
+#define QED_TX_SWS_TIMER_DFLT  500
+
 enum dcbx_protocol_type {
 	DCBX_PROTOCOL_ISCSI,
 	DCBX_PROTOCOL_FCOE,
-- 
2.24.1

