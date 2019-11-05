Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C73EF529
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 06:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387543AbfKEFwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 00:52:10 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20126 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387504AbfKEFwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 00:52:09 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA55o9x5019532;
        Mon, 4 Nov 2019 21:52:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=49I1OtUdZ2l82i4+O5B4SuTpG3R4dCiHhwHyBY6ss/4=;
 b=tT+izAx3dmBVENP1SmLfEQ/QlMkL/bFs3l2Ck1HlgmYkMGFQFaAnUhHJq7Ze4ZESskjx
 aSmXY7ujq5c235OoH7LZ6G8jKxwaG573p8ph1/1Z+4wKdOsQY3BKNdL+SxP3MMik8KG8
 PFV8TtoVVOtuPnsPFDvtowbcqXRqODUT5db/zhTtFlNAPyyfdSveEWYaY0rFAE1UjUr1
 OjOxLhy8uG6xWtIub8mmqWmhkmUWDueST6eSBkilc3qaFZ1wkZ/lgR148kDJGNz2JOi9
 pa2ebE8NfM0njKaB7OeW9pOqcAMgwCTnrablWjxPVs4kePgX6e4cgyvvXpqHalRoXUZK sg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w17n91eqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 04 Nov 2019 21:52:08 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 4 Nov
 2019 21:52:07 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 4 Nov 2019 21:52:07 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 6FFB33F7045;
        Mon,  4 Nov 2019 21:52:07 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xA55q7Hv030054;
        Mon, 4 Nov 2019 21:52:07 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xA55q7ZB030053;
        Mon, 4 Nov 2019 21:52:07 -0800
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <manishc@marvell.com>,
        <mrangankar@marvell.com>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 1/4] bnx2x: Utilize FW 7.13.15.0.
Date:   Mon, 4 Nov 2019 21:51:09 -0800
Message-ID: <20191105055112.30005-2-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191105055112.30005-1-skalluru@marvell.com>
References: <20191105055112.30005-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-05_01:2019-11-04,2019-11-05 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 97a27d6d6e8d "bnx2x: Add FW 7.13.15.0" added said .bin FW to
linux-firmware tree. This FW addresses few important issues in the earlier
FW release.
This patch incorporates FW 7.13.15.0 in the bnx2x driver.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 .../net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h    | 132 ++++++++++-----------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h    |   2 +-
 2 files changed, 67 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h
index 226ab29..3f84352 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h
@@ -32,31 +32,31 @@
 	* IRO[142].m2) + ((sbId) * IRO[142].m3))
 #define CSTORM_IGU_MODE_OFFSET (IRO[161].base)
 #define CSTORM_ISCSI_CQ_SIZE_OFFSET(pfId) \
-	(IRO[323].base + ((pfId) * IRO[323].m1))
-#define CSTORM_ISCSI_CQ_SQN_SIZE_OFFSET(pfId) \
 	(IRO[324].base + ((pfId) * IRO[324].m1))
+#define CSTORM_ISCSI_CQ_SQN_SIZE_OFFSET(pfId) \
+	(IRO[325].base + ((pfId) * IRO[325].m1))
 #define CSTORM_ISCSI_EQ_CONS_OFFSET(pfId, iscsiEqId) \
-	(IRO[316].base + ((pfId) * IRO[316].m1) + ((iscsiEqId) * IRO[316].m2))
+	(IRO[317].base + ((pfId) * IRO[317].m1) + ((iscsiEqId) * IRO[317].m2))
 #define CSTORM_ISCSI_EQ_NEXT_EQE_ADDR_OFFSET(pfId, iscsiEqId) \
-	(IRO[318].base + ((pfId) * IRO[318].m1) + ((iscsiEqId) * IRO[318].m2))
+	(IRO[319].base + ((pfId) * IRO[319].m1) + ((iscsiEqId) * IRO[319].m2))
 #define CSTORM_ISCSI_EQ_NEXT_PAGE_ADDR_OFFSET(pfId, iscsiEqId) \
-	(IRO[317].base + ((pfId) * IRO[317].m1) + ((iscsiEqId) * IRO[317].m2))
+	(IRO[318].base + ((pfId) * IRO[318].m1) + ((iscsiEqId) * IRO[318].m2))
 #define CSTORM_ISCSI_EQ_NEXT_PAGE_ADDR_VALID_OFFSET(pfId, iscsiEqId) \
-	(IRO[319].base + ((pfId) * IRO[319].m1) + ((iscsiEqId) * IRO[319].m2))
+	(IRO[320].base + ((pfId) * IRO[320].m1) + ((iscsiEqId) * IRO[320].m2))
 #define CSTORM_ISCSI_EQ_PROD_OFFSET(pfId, iscsiEqId) \
-	(IRO[315].base + ((pfId) * IRO[315].m1) + ((iscsiEqId) * IRO[315].m2))
+	(IRO[316].base + ((pfId) * IRO[316].m1) + ((iscsiEqId) * IRO[316].m2))
 #define CSTORM_ISCSI_EQ_SB_INDEX_OFFSET(pfId, iscsiEqId) \
-	(IRO[321].base + ((pfId) * IRO[321].m1) + ((iscsiEqId) * IRO[321].m2))
+	(IRO[322].base + ((pfId) * IRO[322].m1) + ((iscsiEqId) * IRO[322].m2))
 #define CSTORM_ISCSI_EQ_SB_NUM_OFFSET(pfId, iscsiEqId) \
-	(IRO[320].base + ((pfId) * IRO[320].m1) + ((iscsiEqId) * IRO[320].m2))
+	(IRO[321].base + ((pfId) * IRO[321].m1) + ((iscsiEqId) * IRO[321].m2))
 #define CSTORM_ISCSI_HQ_SIZE_OFFSET(pfId) \
-	(IRO[322].base + ((pfId) * IRO[322].m1))
+	(IRO[323].base + ((pfId) * IRO[323].m1))
 #define CSTORM_ISCSI_NUM_OF_TASKS_OFFSET(pfId) \
-	(IRO[314].base + ((pfId) * IRO[314].m1))
+	(IRO[315].base + ((pfId) * IRO[315].m1))
 #define CSTORM_ISCSI_PAGE_SIZE_LOG_OFFSET(pfId) \
-	(IRO[313].base + ((pfId) * IRO[313].m1))
+	(IRO[314].base + ((pfId) * IRO[314].m1))
 #define CSTORM_ISCSI_PAGE_SIZE_OFFSET(pfId) \
-	(IRO[312].base + ((pfId) * IRO[312].m1))
+	(IRO[313].base + ((pfId) * IRO[313].m1))
 #define CSTORM_RECORD_SLOW_PATH_OFFSET(funcId) \
 	(IRO[155].base + ((funcId) * IRO[155].m1))
 #define CSTORM_SP_STATUS_BLOCK_DATA_OFFSET(pfId) \
@@ -99,81 +99,81 @@
 #define TSTORM_FUNC_EN_OFFSET(funcId) \
 	(IRO[107].base + ((funcId) * IRO[107].m1))
 #define TSTORM_ISCSI_ERROR_BITMAP_OFFSET(pfId) \
-	(IRO[278].base + ((pfId) * IRO[278].m1))
-#define TSTORM_ISCSI_L2_ISCSI_OOO_CID_TABLE_OFFSET(pfId) \
 	(IRO[279].base + ((pfId) * IRO[279].m1))
-#define TSTORM_ISCSI_L2_ISCSI_OOO_CLIENT_ID_TABLE_OFFSET(pfId) \
+#define TSTORM_ISCSI_L2_ISCSI_OOO_CID_TABLE_OFFSET(pfId) \
 	(IRO[280].base + ((pfId) * IRO[280].m1))
-#define TSTORM_ISCSI_L2_ISCSI_OOO_PROD_OFFSET(pfId) \
+#define TSTORM_ISCSI_L2_ISCSI_OOO_CLIENT_ID_TABLE_OFFSET(pfId) \
 	(IRO[281].base + ((pfId) * IRO[281].m1))
+#define TSTORM_ISCSI_L2_ISCSI_OOO_PROD_OFFSET(pfId) \
+	(IRO[282].base + ((pfId) * IRO[282].m1))
 #define TSTORM_ISCSI_NUM_OF_TASKS_OFFSET(pfId) \
-	(IRO[277].base + ((pfId) * IRO[277].m1))
+	(IRO[278].base + ((pfId) * IRO[278].m1))
 #define TSTORM_ISCSI_PAGE_SIZE_LOG_OFFSET(pfId) \
-	(IRO[276].base + ((pfId) * IRO[276].m1))
+	(IRO[277].base + ((pfId) * IRO[277].m1))
 #define TSTORM_ISCSI_PAGE_SIZE_OFFSET(pfId) \
-	(IRO[275].base + ((pfId) * IRO[275].m1))
+	(IRO[276].base + ((pfId) * IRO[276].m1))
 #define TSTORM_ISCSI_RQ_SIZE_OFFSET(pfId) \
-	(IRO[274].base + ((pfId) * IRO[274].m1))
+	(IRO[275].base + ((pfId) * IRO[275].m1))
 #define TSTORM_ISCSI_TCP_LOCAL_ADV_WND_OFFSET(pfId) \
-	(IRO[284].base + ((pfId) * IRO[284].m1))
+	(IRO[285].base + ((pfId) * IRO[285].m1))
 #define TSTORM_ISCSI_TCP_VARS_FLAGS_OFFSET(pfId) \
-	(IRO[270].base + ((pfId) * IRO[270].m1))
-#define TSTORM_ISCSI_TCP_VARS_LSB_LOCAL_MAC_ADDR_OFFSET(pfId) \
 	(IRO[271].base + ((pfId) * IRO[271].m1))
-#define TSTORM_ISCSI_TCP_VARS_MID_LOCAL_MAC_ADDR_OFFSET(pfId) \
+#define TSTORM_ISCSI_TCP_VARS_LSB_LOCAL_MAC_ADDR_OFFSET(pfId) \
 	(IRO[272].base + ((pfId) * IRO[272].m1))
-#define TSTORM_ISCSI_TCP_VARS_MSB_LOCAL_MAC_ADDR_OFFSET(pfId) \
+#define TSTORM_ISCSI_TCP_VARS_MID_LOCAL_MAC_ADDR_OFFSET(pfId) \
 	(IRO[273].base + ((pfId) * IRO[273].m1))
+#define TSTORM_ISCSI_TCP_VARS_MSB_LOCAL_MAC_ADDR_OFFSET(pfId) \
+	(IRO[274].base + ((pfId) * IRO[274].m1))
 #define TSTORM_MAC_FILTER_CONFIG_OFFSET(pfId) \
 	(IRO[206].base + ((pfId) * IRO[206].m1))
 #define TSTORM_RECORD_SLOW_PATH_OFFSET(funcId) \
 	(IRO[109].base + ((funcId) * IRO[109].m1))
 #define TSTORM_TCP_MAX_CWND_OFFSET(pfId) \
-	(IRO[223].base + ((pfId) * IRO[223].m1))
+	(IRO[224].base + ((pfId) * IRO[224].m1))
 #define TSTORM_VF_TO_PF_OFFSET(funcId) \
 	(IRO[108].base + ((funcId) * IRO[108].m1))
-#define USTORM_AGG_DATA_OFFSET (IRO[212].base)
-#define USTORM_AGG_DATA_SIZE (IRO[212].size)
+#define USTORM_AGG_DATA_OFFSET (IRO[213].base)
+#define USTORM_AGG_DATA_SIZE (IRO[213].size)
 #define USTORM_ASSERT_LIST_INDEX_OFFSET	(IRO[181].base)
 #define USTORM_ASSERT_LIST_OFFSET(assertListEntry) \
 	(IRO[180].base + ((assertListEntry) * IRO[180].m1))
 #define USTORM_ETH_PAUSE_ENABLED_OFFSET(portId) \
 	(IRO[187].base + ((portId) * IRO[187].m1))
 #define USTORM_FCOE_EQ_PROD_OFFSET(pfId) \
-	(IRO[325].base + ((pfId) * IRO[325].m1))
+	(IRO[326].base + ((pfId) * IRO[326].m1))
 #define USTORM_FUNC_EN_OFFSET(funcId) \
 	(IRO[182].base + ((funcId) * IRO[182].m1))
 #define USTORM_ISCSI_CQ_SIZE_OFFSET(pfId) \
-	(IRO[289].base + ((pfId) * IRO[289].m1))
-#define USTORM_ISCSI_CQ_SQN_SIZE_OFFSET(pfId) \
 	(IRO[290].base + ((pfId) * IRO[290].m1))
+#define USTORM_ISCSI_CQ_SQN_SIZE_OFFSET(pfId) \
+	(IRO[291].base + ((pfId) * IRO[291].m1))
 #define USTORM_ISCSI_ERROR_BITMAP_OFFSET(pfId) \
-	(IRO[294].base + ((pfId) * IRO[294].m1))
+	(IRO[295].base + ((pfId) * IRO[295].m1))
 #define USTORM_ISCSI_GLOBAL_BUF_PHYS_ADDR_OFFSET(pfId) \
-	(IRO[291].base + ((pfId) * IRO[291].m1))
+	(IRO[292].base + ((pfId) * IRO[292].m1))
 #define USTORM_ISCSI_NUM_OF_TASKS_OFFSET(pfId) \
-	(IRO[287].base + ((pfId) * IRO[287].m1))
+	(IRO[288].base + ((pfId) * IRO[288].m1))
 #define USTORM_ISCSI_PAGE_SIZE_LOG_OFFSET(pfId) \
-	(IRO[286].base + ((pfId) * IRO[286].m1))
+	(IRO[287].base + ((pfId) * IRO[287].m1))
 #define USTORM_ISCSI_PAGE_SIZE_OFFSET(pfId) \
-	(IRO[285].base + ((pfId) * IRO[285].m1))
+	(IRO[286].base + ((pfId) * IRO[286].m1))
 #define USTORM_ISCSI_R2TQ_SIZE_OFFSET(pfId) \
-	(IRO[288].base + ((pfId) * IRO[288].m1))
+	(IRO[289].base + ((pfId) * IRO[289].m1))
 #define USTORM_ISCSI_RQ_BUFFER_SIZE_OFFSET(pfId) \
-	(IRO[292].base + ((pfId) * IRO[292].m1))
-#define USTORM_ISCSI_RQ_SIZE_OFFSET(pfId) \
 	(IRO[293].base + ((pfId) * IRO[293].m1))
+#define USTORM_ISCSI_RQ_SIZE_OFFSET(pfId) \
+	(IRO[294].base + ((pfId) * IRO[294].m1))
 #define USTORM_MEM_WORKAROUND_ADDRESS_OFFSET(pfId) \
 	(IRO[186].base + ((pfId) * IRO[186].m1))
 #define USTORM_RECORD_SLOW_PATH_OFFSET(funcId) \
 	(IRO[184].base + ((funcId) * IRO[184].m1))
 #define USTORM_RX_PRODS_E1X_OFFSET(portId, clientId) \
-	(IRO[215].base + ((portId) * IRO[215].m1) + ((clientId) * \
-	IRO[215].m2))
+	(IRO[216].base + ((portId) * IRO[216].m1) + ((clientId) * \
+	IRO[216].m2))
 #define USTORM_RX_PRODS_E2_OFFSET(qzoneId) \
-	(IRO[216].base + ((qzoneId) * IRO[216].m1))
-#define USTORM_TPA_BTR_OFFSET (IRO[213].base)
-#define USTORM_TPA_BTR_SIZE (IRO[213].size)
+	(IRO[217].base + ((qzoneId) * IRO[217].m1))
+#define USTORM_TPA_BTR_OFFSET (IRO[214].base)
+#define USTORM_TPA_BTR_SIZE (IRO[214].size)
 #define USTORM_VF_TO_PF_OFFSET(funcId) \
 	(IRO[183].base + ((funcId) * IRO[183].m1))
 #define XSTORM_AGG_INT_FINAL_CLEANUP_COMP_TYPE (IRO[67].base)
@@ -188,39 +188,39 @@
 #define XSTORM_FUNC_EN_OFFSET(funcId) \
 	(IRO[47].base + ((funcId) * IRO[47].m1))
 #define XSTORM_ISCSI_HQ_SIZE_OFFSET(pfId) \
-	(IRO[302].base + ((pfId) * IRO[302].m1))
+	(IRO[303].base + ((pfId) * IRO[303].m1))
 #define XSTORM_ISCSI_LOCAL_MAC_ADDR0_OFFSET(pfId) \
-	(IRO[305].base + ((pfId) * IRO[305].m1))
-#define XSTORM_ISCSI_LOCAL_MAC_ADDR1_OFFSET(pfId) \
 	(IRO[306].base + ((pfId) * IRO[306].m1))
-#define XSTORM_ISCSI_LOCAL_MAC_ADDR2_OFFSET(pfId) \
+#define XSTORM_ISCSI_LOCAL_MAC_ADDR1_OFFSET(pfId) \
 	(IRO[307].base + ((pfId) * IRO[307].m1))
-#define XSTORM_ISCSI_LOCAL_MAC_ADDR3_OFFSET(pfId) \
+#define XSTORM_ISCSI_LOCAL_MAC_ADDR2_OFFSET(pfId) \
 	(IRO[308].base + ((pfId) * IRO[308].m1))
-#define XSTORM_ISCSI_LOCAL_MAC_ADDR4_OFFSET(pfId) \
+#define XSTORM_ISCSI_LOCAL_MAC_ADDR3_OFFSET(pfId) \
 	(IRO[309].base + ((pfId) * IRO[309].m1))
-#define XSTORM_ISCSI_LOCAL_MAC_ADDR5_OFFSET(pfId) \
+#define XSTORM_ISCSI_LOCAL_MAC_ADDR4_OFFSET(pfId) \
 	(IRO[310].base + ((pfId) * IRO[310].m1))
-#define XSTORM_ISCSI_LOCAL_VLAN_OFFSET(pfId) \
+#define XSTORM_ISCSI_LOCAL_MAC_ADDR5_OFFSET(pfId) \
 	(IRO[311].base + ((pfId) * IRO[311].m1))
+#define XSTORM_ISCSI_LOCAL_VLAN_OFFSET(pfId) \
+	(IRO[312].base + ((pfId) * IRO[312].m1))
 #define XSTORM_ISCSI_NUM_OF_TASKS_OFFSET(pfId) \
-	(IRO[301].base + ((pfId) * IRO[301].m1))
+	(IRO[302].base + ((pfId) * IRO[302].m1))
 #define XSTORM_ISCSI_PAGE_SIZE_LOG_OFFSET(pfId) \
-	(IRO[300].base + ((pfId) * IRO[300].m1))
+	(IRO[301].base + ((pfId) * IRO[301].m1))
 #define XSTORM_ISCSI_PAGE_SIZE_OFFSET(pfId) \
-	(IRO[299].base + ((pfId) * IRO[299].m1))
+	(IRO[300].base + ((pfId) * IRO[300].m1))
 #define XSTORM_ISCSI_R2TQ_SIZE_OFFSET(pfId) \
-	(IRO[304].base + ((pfId) * IRO[304].m1))
+	(IRO[305].base + ((pfId) * IRO[305].m1))
 #define XSTORM_ISCSI_SQ_SIZE_OFFSET(pfId) \
-	(IRO[303].base + ((pfId) * IRO[303].m1))
+	(IRO[304].base + ((pfId) * IRO[304].m1))
 #define XSTORM_ISCSI_TCP_VARS_ADV_WND_SCL_OFFSET(pfId) \
-	(IRO[298].base + ((pfId) * IRO[298].m1))
+	(IRO[299].base + ((pfId) * IRO[299].m1))
 #define XSTORM_ISCSI_TCP_VARS_FLAGS_OFFSET(pfId) \
-	(IRO[297].base + ((pfId) * IRO[297].m1))
+	(IRO[298].base + ((pfId) * IRO[298].m1))
 #define XSTORM_ISCSI_TCP_VARS_TOS_OFFSET(pfId) \
-	(IRO[296].base + ((pfId) * IRO[296].m1))
+	(IRO[297].base + ((pfId) * IRO[297].m1))
 #define XSTORM_ISCSI_TCP_VARS_TTL_OFFSET(pfId) \
-	(IRO[295].base + ((pfId) * IRO[295].m1))
+	(IRO[296].base + ((pfId) * IRO[296].m1))
 #define XSTORM_RATE_SHAPING_PER_VN_VARS_OFFSET(pfId) \
 	(IRO[44].base + ((pfId) * IRO[44].m1))
 #define XSTORM_RECORD_SLOW_PATH_OFFSET(funcId) \
@@ -233,12 +233,12 @@
 #define XSTORM_SPQ_PROD_OFFSET(funcId) \
 	(IRO[31].base + ((funcId) * IRO[31].m1))
 #define XSTORM_TCP_GLOBAL_DEL_ACK_COUNTER_ENABLED_OFFSET(portId) \
-	(IRO[217].base + ((portId) * IRO[217].m1))
-#define XSTORM_TCP_GLOBAL_DEL_ACK_COUNTER_MAX_COUNT_OFFSET(portId) \
 	(IRO[218].base + ((portId) * IRO[218].m1))
+#define XSTORM_TCP_GLOBAL_DEL_ACK_COUNTER_MAX_COUNT_OFFSET(portId) \
+	(IRO[219].base + ((portId) * IRO[219].m1))
 #define XSTORM_TCP_TX_SWS_TIMER_VAL_OFFSET(pfId) \
-	(IRO[220].base + (((pfId)>>1) * IRO[220].m1) + (((pfId)&1) * \
-	IRO[220].m2))
+	(IRO[221].base + (((pfId)>>1) * IRO[221].m1) + (((pfId)&1) * \
+	IRO[221].m2))
 #define XSTORM_VF_TO_PF_OFFSET(funcId) \
 	(IRO[48].base + ((funcId) * IRO[48].m1))
 #define COMMON_ASM_INVALID_ASSERT_OPCODE 0x0
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h
index 78326a6..622fadc 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h
@@ -3024,7 +3024,7 @@ struct afex_stats {
 
 #define BCM_5710_FW_MAJOR_VERSION			7
 #define BCM_5710_FW_MINOR_VERSION			13
-#define BCM_5710_FW_REVISION_VERSION		11
+#define BCM_5710_FW_REVISION_VERSION		15
 #define BCM_5710_FW_ENGINEERING_VERSION		0
 #define BCM_5710_FW_COMPILE_FLAGS			1
 
-- 
1.8.3.1

