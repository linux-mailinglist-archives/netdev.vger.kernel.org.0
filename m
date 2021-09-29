Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C6E41C483
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343817AbhI2MRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:17:20 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8870 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1343627AbhI2MQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 08:16:33 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18TBK10w014468;
        Wed, 29 Sep 2021 05:13:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=8a+mYKHb/CRB6utTU0bzcTFL5KSCDmq2wOpp0oW6lds=;
 b=dRUAFKu0HjYAlhx2DEJO4rCORGz7ICeKP9HTAum4HQlKZlfB6Ge+q2pRS4qjA7z4GAd9
 nZhfEIlMUbXZoMNKZRQRb8T+Dvyq//R1C5WcJ9kbhirJdjOL7hz027gVQsbcpQWRMEY+
 doa8W9/J91aBSqEYgnqkKy2BYiH/5arVL3qNEWx/lEK6CrMyE0w/w8qwB3q2txM87ExY
 wVhJwBTpeBkqQuasPME5eQyVFFn2J/7fyHtTEss1N//4aD5ofrUYM9iUdwhYsorbBY0R
 R1ExqzDpcnpDfohsvISxpurJxxZ7M2ysQGHIeL7u4cFT2ifPrlS+jTfeWKCH40fla7Xz Kw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bcq67g60r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 05:13:15 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 05:13:14 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 29 Sep 2021 05:13:10 -0700
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <aelior@marvell.com>,
        <smalin@marvell.com>, <jhasan@marvell.com>,
        <mrangankar@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        Nikolay Assa <nassa@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>
Subject: [PATCH 11/12] qed: Update the TCP active termination 2 MSL timer ("TIME_WAIT")
Date:   Wed, 29 Sep 2021 15:12:14 +0300
Message-ID: <20210929121215.17864-12-pkushwaha@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210929121215.17864-1-pkushwaha@marvell.com>
References: <20210929121215.17864-1-pkushwaha@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: UoPEcOX9uUnhAlPMGUm_hbKoh8e6so1W
X-Proofpoint-GUID: UoPEcOX9uUnhAlPMGUm_hbKoh8e6so1W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_05,2021-09-29_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize 2 MSL timeout value used for the TCP TIME_WAIT state to
non-zero default.

This patch also removes magic number from qedi/qedi_main.c.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nikolay Assa <nassa@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 1 +
 drivers/scsi/qedi/qedi_main.c               | 2 +-
 include/linux/qed/qed_if.h                  | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index b2c0e522e51f..1d1d4caad680 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -115,6 +115,7 @@ qed_iwarp_init_fw_ramrod(struct qed_hwfn *p_hwfn,
 	    p_hwfn->p_rdma_info->iwarp.ll2_ooo_handle;
 
 	p_ramrod->tcp.tx_sws_timer = cpu_to_le16(QED_TX_SWS_TIMER_DFLT);
+	p_ramrod->tcp.two_msl_timer = cpu_to_le32(QED_TWO_MSL_TIMER_DFLT);
 	p_ramrod->tcp.max_fin_rt = QED_IWARP_MAX_FIN_RT_DEFAULT;
 
 	return;
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 8c2f32655424..1dec814d8788 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -865,7 +865,7 @@ static int qedi_set_iscsi_pf_param(struct qedi_ctx *qedi)
 	qedi->pf_params.iscsi_pf_params.num_uhq_pages_in_ring = num_sq_pages;
 	qedi->pf_params.iscsi_pf_params.num_queues = qedi->num_queues;
 	qedi->pf_params.iscsi_pf_params.debug_mode = qedi_fw_debug;
-	qedi->pf_params.iscsi_pf_params.two_msl_timer = 4000;
+	qedi->pf_params.iscsi_pf_params.two_msl_timer = QED_TWO_MSL_TIMER_DFLT;
 	qedi->pf_params.iscsi_pf_params.tx_sws_timer = QED_TX_SWS_TIMER_DFLT;
 	qedi->pf_params.iscsi_pf_params.max_fin_rt = 2;
 
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 829cbc148a67..0e1933ba52c2 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -25,6 +25,7 @@
 #include <net/devlink.h>
 
 #define QED_TX_SWS_TIMER_DFLT  500
+#define QED_TWO_MSL_TIMER_DFLT 4000
 
 enum dcbx_protocol_type {
 	DCBX_PROTOCOL_ISCSI,
-- 
2.24.1

