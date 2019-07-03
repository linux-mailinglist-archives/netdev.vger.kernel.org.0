Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8C65DDE2
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 08:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfGCGCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 02:02:18 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32636 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725927AbfGCGCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 02:02:18 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x635uw2R019290;
        Tue, 2 Jul 2019 23:02:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=BoHIDcqoCaRPP/G5FhJWpFFv7ORioiJpMDvbbGaNrVI=;
 b=mv3pogHFeH891tZtxBEkLx1qLZh9J/rP7cYLSDi58XBJtccwGT7TlZoR68CI4vIuC6Mn
 85WK4oNZZrHuDulIUik8r1Hic650i9v8WO4Sbsj4GFI7U5yWccxMjKREJ7MCIc6kN2Ju
 ZRcGvd3mBXEJgbK5pTZzttKit3+ceQ0yV8D3xO3Lnc/vs1shhVs5QbCz+1Be3/syIQ6L
 Aq9bAyNzlDs53L021XWoNO5kJzNPFMk0+Lj/8562nIroTzPiCHtY4JXPPHwnFJ/vB+5g
 S9IlIaGJTIoRu7EZFGc8azhttYl3LnOwtgHzj4KuW8fkBJIvI4wySzejztPMrbUeGVpO SQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tg57342eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Jul 2019 23:02:14 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 2 Jul
 2019 23:02:13 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 2 Jul 2019 23:02:13 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 2090D3F7043;
        Tue,  2 Jul 2019 23:02:13 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x6362Cdm014158;
        Tue, 2 Jul 2019 23:02:12 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x6362Cid014157;
        Tue, 2 Jul 2019 23:02:12 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next v2 1/1] qed: Add support for Timestamping the unicast PTP packets.
Date:   Tue, 2 Jul 2019 23:01:59 -0700
Message-ID: <20190703060159.14121-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-03_02:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds driver changes to detect/timestamp the unicast PTP packets.

Changes from previous version:
-------------------------------
v2: Defined a macro for unicast ptp param mask.

Please consider applying this to "net-next".

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_ptp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ptp.c b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
index f3ebdc5..0dacf2c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ptp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
@@ -44,6 +44,8 @@
 /* Add/subtract the Adjustment_Value when making a Drift adjustment */
 #define QED_DRIFT_CNTR_DIRECTION_SHIFT		31
 #define QED_TIMESTAMP_MASK			BIT(16)
+/* Param mask for Hardware to detect/timestamp the unicast PTP packets */
+#define QED_PTP_UCAST_PARAM_MASK		0xF
 
 static enum qed_resc_lock qed_ptcdev_to_resc(struct qed_hwfn *p_hwfn)
 {
@@ -243,7 +245,8 @@ static int qed_ptp_hw_cfg_filters(struct qed_dev *cdev,
 		return -EINVAL;
 	}
 
-	qed_wr(p_hwfn, p_ptt, NIG_REG_LLH_PTP_PARAM_MASK, 0);
+	qed_wr(p_hwfn, p_ptt, NIG_REG_LLH_PTP_PARAM_MASK,
+	       QED_PTP_UCAST_PARAM_MASK);
 	qed_wr(p_hwfn, p_ptt, NIG_REG_LLH_PTP_RULE_MASK, rule_mask);
 	qed_wr(p_hwfn, p_ptt, NIG_REG_RX_PTP_EN, enable_cfg);
 
@@ -253,7 +256,8 @@ static int qed_ptp_hw_cfg_filters(struct qed_dev *cdev,
 		qed_wr(p_hwfn, p_ptt, NIG_REG_TX_LLH_PTP_RULE_MASK, 0x3FFF);
 	} else {
 		qed_wr(p_hwfn, p_ptt, NIG_REG_TX_PTP_EN, enable_cfg);
-		qed_wr(p_hwfn, p_ptt, NIG_REG_TX_LLH_PTP_PARAM_MASK, 0);
+		qed_wr(p_hwfn, p_ptt, NIG_REG_TX_LLH_PTP_PARAM_MASK,
+		       QED_PTP_UCAST_PARAM_MASK);
 		qed_wr(p_hwfn, p_ptt, NIG_REG_TX_LLH_PTP_RULE_MASK, rule_mask);
 	}
 
-- 
1.8.3.1

