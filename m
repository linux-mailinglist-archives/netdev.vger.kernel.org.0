Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A96E2634DA
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgIIRnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:43:51 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59262 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726440AbgIIRnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 13:43:46 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 089HfKLB020078;
        Wed, 9 Sep 2020 10:43:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=O2rzkkNlKHr10mms8EQJdKmJtMAHyRKzEi+ECoKZoYA=;
 b=AA4MSso3WVqGZMK+muxb7C0pbvbHsyczy5H2LUOvmKCnvzhxT7zQSfgwMSzpvHmRjQ6h
 8ovsUO1AgQu7FAMpK4alRLcXRzh1cxZ0vJ8Dy/HJH1qyes9zLRNm5EWalBPTn1zfHyHX
 2VPpKNuXV3N1TWApz1OXC0CaF9VnHgQUfc06YAcHc5qVDPkr4dqAjjSnTKvC1NDQtr1W
 2j4W29k10eehLSUuHXnVw8mR6XbdidoV51laZ+0BkdbessSG6/nJFRXI6gxpovR4pr/1
 K64yChDS3OwlaNi9TMuaING2zEZ+faZkXiq4LAzRmXo8q8UeFylHrew80yoSNyTpuNfH WA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81q0u5c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 10:43:43 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Sep
 2020 10:43:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Sep 2020 10:43:42 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.6.200.75])
        by maili.marvell.com (Postfix) with ESMTP id C54883F7043;
        Wed,  9 Sep 2020 10:43:39 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v3 net 1/3] net: qed: Disable aRFS for NPAR and 100G
Date:   Wed, 9 Sep 2020 20:43:08 +0300
Message-ID: <20200909174310.686-2-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200909174310.686-1-irusskikh@marvell.com>
References: <20200909174310.686-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-09_13:2020-09-09,2020-09-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

In CMT and NPAR the PF is unknown when the GFS block processes the
packet. Therefore cannot use searcher as it has a per PF database,
and thus ARFS must be disabled.

Fixes: d51e4af5c209 ("qed: aRFS infrastructure support")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c  | 11 ++++++++++-
 drivers/net/ethernet/qlogic/qed/qed_l2.c   |  3 +++
 drivers/net/ethernet/qlogic/qed/qed_main.c |  2 ++
 include/linux/qed/qed_if.h                 |  1 +
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index f7f08e6a3acf..d2f5855b2ea7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -4254,7 +4254,8 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 			cdev->mf_bits = BIT(QED_MF_LLH_MAC_CLSS) |
 					BIT(QED_MF_LLH_PROTO_CLSS) |
 					BIT(QED_MF_LL2_NON_UNICAST) |
-					BIT(QED_MF_INTER_PF_SWITCH);
+					BIT(QED_MF_INTER_PF_SWITCH) |
+					BIT(QED_MF_DISABLE_ARFS);
 			break;
 		case NVM_CFG1_GLOB_MF_MODE_DEFAULT:
 			cdev->mf_bits = BIT(QED_MF_LLH_MAC_CLSS) |
@@ -4267,6 +4268,14 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 
 		DP_INFO(p_hwfn, "Multi function mode is 0x%lx\n",
 			cdev->mf_bits);
+
+		/* In CMT the PF is unknown when the GFS block processes the
+		 * packet. Therefore cannot use searcher as it has a per PF
+		 * database, and thus ARFS must be disabled.
+		 *
+		 */
+		if (QED_IS_CMT(cdev))
+			cdev->mf_bits |= BIT(QED_MF_DISABLE_ARFS);
 	}
 
 	DP_INFO(p_hwfn, "Multi function mode is 0x%lx\n",
diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index 4c6ac8862744..07824bf9d68d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -1980,6 +1980,9 @@ void qed_arfs_mode_configure(struct qed_hwfn *p_hwfn,
 			     struct qed_ptt *p_ptt,
 			     struct qed_arfs_config_params *p_cfg_params)
 {
+	if (test_bit(QED_MF_DISABLE_ARFS, &p_hwfn->cdev->mf_bits))
+		return;
+
 	if (p_cfg_params->mode != QED_FILTER_CONFIG_MODE_DISABLE) {
 		qed_gft_config(p_hwfn, p_ptt, p_hwfn->rel_pf_id,
 			       p_cfg_params->tcp,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 5b149ceff6b6..91e7cd04636c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -445,6 +445,8 @@ int qed_fill_dev_info(struct qed_dev *cdev,
 		dev_info->fw_eng = FW_ENGINEERING_VERSION;
 		dev_info->b_inter_pf_switch = test_bit(QED_MF_INTER_PF_SWITCH,
 						       &cdev->mf_bits);
+		if (!test_bit(QED_MF_DISABLE_ARFS, &cdev->mf_bits))
+			dev_info->b_arfs_capable = true;
 		dev_info->tx_switching = true;
 
 		if (hw_info->b_wol_support == QED_WOL_SUPPORT_PME)
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 56fa55841d39..57fb295ea41a 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -624,6 +624,7 @@ struct qed_dev_info {
 #define QED_MFW_VERSION_3_OFFSET	24
 
 	u32		flash_size;
+	bool		b_arfs_capable;
 	bool		b_inter_pf_switch;
 	bool		tx_switching;
 	bool		rdma_supported;
-- 
2.17.1

