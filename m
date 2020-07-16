Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D3B2221DE
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 13:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgGPL4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 07:56:30 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59210 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728655AbgGPL4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 07:56:24 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GBp6Mp032017;
        Thu, 16 Jul 2020 04:56:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=pQ404B8L4MyjD+j2c6PxO4O97MfuQmisnaLW5tx1GA0=;
 b=K5UOFpKgT/9/a9eWIbtVQfeHR9N0OAQ4bwEI6p4TvrmmY5UQo7weY6/VwSp3rcR+QnWu
 +cQI5z1vvFa3BhgokWBS173gxaIslxEz8HE+maZr5p++ZRgaNo9nhWC0cqHCWJHTwEpm
 33SuSEaLZc5Gk1Oqid9tdwtC5/DPusgtrjHVPCHcRixAfeSUCSWoBbtDl/qv4M7HukuS
 V7Uvijr+cMGI9AJDnGOg9pByET7UbUB3BBFb7Dt6hBztwbiBIJ7uR8LLcoXCMONojs6l
 VK6mPXZ8OX9C5S0HQqHklpftKwqz/B/MYnvntrfb78nGuMmrJnIVSenAwGS3yThgoBDj bA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32ap7v81s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 04:56:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Jul
 2020 04:56:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Jul 2020 04:56:21 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 495433F703F;
        Thu, 16 Jul 2020 04:56:17 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@cavium.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 10/13] qed: add support for new port modes
Date:   Thu, 16 Jul 2020 14:54:43 +0300
Message-ID: <20200716115446.994-11-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716115446.994-1-alobakin@marvell.com>
References: <20200716115446.994-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_05:2020-07-16,2020-07-16 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These ports ship on new boards revisions and are supported by newer
firmware versions.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h     |  5 +++++
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 15 +++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_hsi.h |  5 +++++
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 6a1d12da7910..63fcbd5a295a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -257,6 +257,11 @@ enum QED_PORT_MODE {
 	QED_PORT_MODE_DE_1X25G,
 	QED_PORT_MODE_DE_4X25G,
 	QED_PORT_MODE_DE_2X10G,
+	QED_PORT_MODE_DE_2X50G_R1,
+	QED_PORT_MODE_DE_4X50G_R1,
+	QED_PORT_MODE_DE_1X100G_R2,
+	QED_PORT_MODE_DE_2X100G_R2,
+	QED_PORT_MODE_DE_1X100G_R4,
 };
 
 enum qed_dev_cap {
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index d929556247a5..4bad836d0f74 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -4026,6 +4026,21 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X25G:
 		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_4X25G;
 		break;
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X50G_R1:
+		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_2X50G_R1;
+		break;
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_4X50G_R1:
+		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_4X50G_R1;
+		break;
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R2:
+		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_1X100G_R2;
+		break;
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X100G_R2:
+		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_2X100G_R2;
+		break;
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R4:
+		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_1X100G_R4;
+		break;
 	default:
 		DP_NOTICE(p_hwfn, "Unknown port mode in 0x%08x\n", core_cfg);
 		break;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index a4a845579fd2..debc55923251 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -13015,6 +13015,11 @@ struct nvm_cfg1_glob {
 #define NVM_CFG1_GLOB_NETWORK_PORT_MODE_1X25G			0xd
 #define NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X25G			0xe
 #define NVM_CFG1_GLOB_NETWORK_PORT_MODE_2X10G			0xf
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X50G_R1		0x11
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_4X50G_R1		0x12
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R2		0x13
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X100G_R2		0x14
+#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R4		0x15
 
 	u32							e_lane_cfg1;
 	u32							e_lane_cfg2;
-- 
2.25.1

