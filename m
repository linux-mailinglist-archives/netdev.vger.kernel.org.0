Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4CF39F75A
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhFHNNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 09:13:36 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:5292 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbhFHNNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 09:13:34 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fzr9N3RFdz1BJWk;
        Tue,  8 Jun 2021 21:06:48 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 21:11:39 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 21:11:38 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 4/5] net: hns3: update error recovery module and type
Date:   Tue, 8 Jun 2021 21:08:30 +0800
Message-ID: <1623157711-26846-5-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623157711-26846-1-git-send-email-huangguangbin2@huawei.com>
References: <1623157711-26846-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

Update error recovery module and type for RoCE.

The enumeration values of module names and error types are not sorted
in sequence. If use the current printing mode, they cannot be correctly
printed.

Use the index mode, If mod_id and type_id match the enumerated value,
display the corresponding information.

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 58 ++++++++++++++++++++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h | 18 +++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  3 +-
 3 files changed, 74 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 36f8055bd859..0e942d11dbf3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -677,6 +677,36 @@ static const struct hclge_hw_module_id hclge_hw_module_id_st[] = {
 	}, {
 		.module_id = MODULE_MASTER,
 		.msg = "MODULE_MASTER"
+	}, {
+		.module_id = MODULE_ROCEE_TOP,
+		.msg = "MODULE_ROCEE_TOP"
+	}, {
+		.module_id = MODULE_ROCEE_TIMER,
+		.msg = "MODULE_ROCEE_TIMER"
+	}, {
+		.module_id = MODULE_ROCEE_MDB,
+		.msg = "MODULE_ROCEE_MDB"
+	}, {
+		.module_id = MODULE_ROCEE_TSP,
+		.msg = "MODULE_ROCEE_TSP"
+	}, {
+		.module_id = MODULE_ROCEE_TRP,
+		.msg = "MODULE_ROCEE_TRP"
+	}, {
+		.module_id = MODULE_ROCEE_SCC,
+		.msg = "MODULE_ROCEE_SCC"
+	}, {
+		.module_id = MODULE_ROCEE_CAEP,
+		.msg = "MODULE_ROCEE_CAEP"
+	}, {
+		.module_id = MODULE_ROCEE_GEN_AC,
+		.msg = "MODULE_ROCEE_GEN_AC"
+	}, {
+		.module_id = MODULE_ROCEE_QMM,
+		.msg = "MODULE_ROCEE_QMM"
+	}, {
+		.module_id = MODULE_ROCEE_LSAN,
+		.msg = "MODULE_ROCEE_LSAN"
 	}
 };
 
@@ -720,6 +750,12 @@ static const struct hclge_hw_type_id hclge_hw_type_id_st[] = {
 	}, {
 		.type_id = GLB_ERROR,
 		.msg = "glb_error"
+	}, {
+		.type_id = ROCEE_NORMAL_ERR,
+		.msg = "rocee_normal_error"
+	}, {
+		.type_id = ROCEE_OVF_ERR,
+		.msg = "rocee_ovf_error"
 	}
 };
 
@@ -2125,6 +2161,8 @@ hclge_handle_error_type_reg_log(struct device *dev,
 #define HCLGE_ERR_TYPE_IS_RAS_OFFSET 7
 
 	u8 mod_id, total_module, type_id, total_type, i, is_ras;
+	u8 index_module = MODULE_NONE;
+	u8 index_type = NONE_ERROR;
 
 	mod_id = mod_info->mod_id;
 	type_id = type_reg_info->type_id & HCLGE_ERR_TYPE_MASK;
@@ -2133,11 +2171,25 @@ hclge_handle_error_type_reg_log(struct device *dev,
 	total_module = ARRAY_SIZE(hclge_hw_module_id_st);
 	total_type = ARRAY_SIZE(hclge_hw_type_id_st);
 
-	if (mod_id < total_module && type_id < total_type)
+	for (i = 0; i < total_module; i++) {
+		if (mod_id == hclge_hw_module_id_st[i].module_id) {
+			index_module = i;
+			break;
+		}
+	}
+
+	for (i = 0; i < total_type; i++) {
+		if (type_id == hclge_hw_type_id_st[i].type_id) {
+			index_type = i;
+			break;
+		}
+	}
+
+	if (index_module != MODULE_NONE && index_type != NONE_ERROR)
 		dev_err(dev,
 			"found %s %s, is %s error.\n",
-			hclge_hw_module_id_st[mod_id].msg,
-			hclge_hw_type_id_st[type_id].msg,
+			hclge_hw_module_id_st[index_module].msg,
+			hclge_hw_type_id_st[index_type].msg,
 			is_ras ? "ras" : "msix");
 	else
 		dev_err(dev,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index 27ab772c665e..ce4c96bbef8e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -15,6 +15,8 @@
 #define HCLGE_RAS_PF_OTHER_INT_STS_REG   0x20B00
 #define HCLGE_RAS_REG_NFE_MASK   0xFF00
 #define HCLGE_RAS_REG_ROCEE_ERR_MASK   0x3000000
+#define HCLGE_RAS_REG_ERR_MASK \
+	(HCLGE_RAS_REG_NFE_MASK | HCLGE_RAS_REG_ROCEE_ERR_MASK)
 
 #define HCLGE_VECTOR0_REG_MSIX_MASK   0x1FF00
 
@@ -134,6 +136,18 @@ enum hclge_mod_name_list {
 	MODULE_RCB_TX		= 12,
 	MODULE_TXDMA		= 13,
 	MODULE_MASTER		= 14,
+	/* add new MODULE NAME for NIC here in order */
+	MODULE_ROCEE_TOP	= 40,
+	MODULE_ROCEE_TIMER	= 41,
+	MODULE_ROCEE_MDB	= 42,
+	MODULE_ROCEE_TSP	= 43,
+	MODULE_ROCEE_TRP	= 44,
+	MODULE_ROCEE_SCC	= 45,
+	MODULE_ROCEE_CAEP	= 46,
+	MODULE_ROCEE_GEN_AC	= 47,
+	MODULE_ROCEE_QMM	= 48,
+	MODULE_ROCEE_LSAN	= 49,
+	/* add new MODULE NAME for RoCEE here in order */
 };
 
 enum hclge_err_type_list {
@@ -150,6 +164,10 @@ enum hclge_err_type_list {
 	ETS_ERROR		= 10,
 	NCSI_ERROR		= 11,
 	GLB_ERROR		= 12,
+	/* add new ERROR TYPE for NIC here in order */
+	ROCEE_NORMAL_ERR	= 40,
+	ROCEE_OVF_ERR		= 41,
+	/* add new ERROR TYPE for ROCEE here in order */
 };
 
 struct hclge_hw_blk {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index cf34216df171..9ff4210f6477 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3343,8 +3343,7 @@ static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 
 	/* check for vector0 msix event and hardware error event source */
 	if (msix_src_reg & HCLGE_VECTOR0_REG_MSIX_MASK ||
-	    hw_err_src_reg & HCLGE_RAS_REG_NFE_MASK ||
-	    hw_err_src_reg & HCLGE_RAS_REG_ROCEE_ERR_MASK)
+	    hw_err_src_reg & HCLGE_RAS_REG_ERR_MASK)
 		return HCLGE_VECTOR0_EVENT_ERR;
 
 	/* check for vector0 mailbox(=CMDQ RX) event source */
-- 
2.8.1

