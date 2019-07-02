Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23D2C5D24C
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfGBPE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:04:28 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:62530 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725981AbfGBPE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:04:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x62F1IVI012242;
        Tue, 2 Jul 2019 08:04:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=k1ReAweHB51/J9Hj/2gZ9PybHrHv1N9UjQtW0Vx4tFo=;
 b=EB063j/ESI8JBKosojOYB0qyaLioDlwWU6vYbEiCUTNFKbF2sTOTLTjnh6kO5/NM+CYS
 FAWN2k0wCbhmIDPaUtFetNSI9AIgZM8reyR26To+qXQHc+i+fCEsc4AOa59qPMRePkFG
 0tSdc0PC4qRTNuUJMdl2WdkJ7dqaTYzuYb/hmQ8BXporBwvo2Fg3/Yp6jTyMQSTMjSye
 oJiwL/+s58Loi9bPM0fG0pArMnitIjeOf+l78YH5etTOnGun1BvcGchSyVD8xWGuSYox
 s9H2BJE9V+ghw7/t6DCipnXnm2fWepOFIE7ka2dHyhsD0LL04jJmBdP5t83cqKlGTroV iQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tg4jrsgft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Jul 2019 08:04:23 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 2 Jul
 2019 08:04:22 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 2 Jul 2019 08:04:22 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C430E3F7041;
        Tue,  2 Jul 2019 08:04:21 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x62F4LbQ031179;
        Tue, 2 Jul 2019 08:04:21 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x62F4Ll4031178;
        Tue, 2 Jul 2019 08:04:21 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 1/1] qed: Add support for Timestamping the unicast PTP packets.
Date:   Tue, 2 Jul 2019 08:04:12 -0700
Message-ID: <20190702150412.31132-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-02_08:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch masks the lower 4 bits of PARAM-MASK registers as required
by the Hardware to detect/timestamp the unicast PTP packets. The register
definition in the header file captures more details on the individual bits.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ptp.c b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
index f3ebdc5..4a7acfc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ptp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
@@ -243,7 +243,7 @@ static int qed_ptp_hw_cfg_filters(struct qed_dev *cdev,
 		return -EINVAL;
 	}
 
-	qed_wr(p_hwfn, p_ptt, NIG_REG_LLH_PTP_PARAM_MASK, 0);
+	qed_wr(p_hwfn, p_ptt, NIG_REG_LLH_PTP_PARAM_MASK, 0xF);
 	qed_wr(p_hwfn, p_ptt, NIG_REG_LLH_PTP_RULE_MASK, rule_mask);
 	qed_wr(p_hwfn, p_ptt, NIG_REG_RX_PTP_EN, enable_cfg);
 
@@ -253,7 +253,7 @@ static int qed_ptp_hw_cfg_filters(struct qed_dev *cdev,
 		qed_wr(p_hwfn, p_ptt, NIG_REG_TX_LLH_PTP_RULE_MASK, 0x3FFF);
 	} else {
 		qed_wr(p_hwfn, p_ptt, NIG_REG_TX_PTP_EN, enable_cfg);
-		qed_wr(p_hwfn, p_ptt, NIG_REG_TX_LLH_PTP_PARAM_MASK, 0);
+		qed_wr(p_hwfn, p_ptt, NIG_REG_TX_LLH_PTP_PARAM_MASK, 0xF);
 		qed_wr(p_hwfn, p_ptt, NIG_REG_TX_LLH_PTP_RULE_MASK, rule_mask);
 	}
 
-- 
1.8.3.1

