Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25AF63F9715
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 11:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244885AbhH0Jd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 05:33:28 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8788 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244729AbhH0JdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 05:33:09 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GwvcH49hPzYv3d;
        Fri, 27 Aug 2021 17:31:43 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 27 Aug 2021 17:32:17 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 27 Aug 2021 17:32:17 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 7/8] net: hns3: merge some repetitive macros
Date:   Fri, 27 Aug 2021 17:28:23 +0800
Message-ID: <1630056504-31725-8-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630056504-31725-1-git-send-email-huangguangbin2@huawei.com>
References: <1630056504-31725-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

There are some repetitive macros have same meaning and value, this patch
merges them to make code clean.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h | 10 ----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 22 +++++++++++-----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    | 22 +++++++++++-----------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   | 10 ----------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 22 +++++++++++-----------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  | 21 +++++++++++----------
 6 files changed, 44 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 2e49a52dfd3a..afca9ee9ca4f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1017,16 +1017,6 @@ struct hclge_common_lb_cmd {
 
 #define HCLGE_TYPE_CRQ			0
 #define HCLGE_TYPE_CSQ			1
-#define HCLGE_NIC_CSQ_BASEADDR_L_REG	0x27000
-#define HCLGE_NIC_CSQ_BASEADDR_H_REG	0x27004
-#define HCLGE_NIC_CSQ_DEPTH_REG		0x27008
-#define HCLGE_NIC_CSQ_TAIL_REG		0x27010
-#define HCLGE_NIC_CSQ_HEAD_REG		0x27014
-#define HCLGE_NIC_CRQ_BASEADDR_L_REG	0x27018
-#define HCLGE_NIC_CRQ_BASEADDR_H_REG	0x2701c
-#define HCLGE_NIC_CRQ_DEPTH_REG		0x27020
-#define HCLGE_NIC_CRQ_TAIL_REG		0x27024
-#define HCLGE_NIC_CRQ_HEAD_REG		0x27028
 
 /* this bit indicates that the driver is ready for hardware reset */
 #define HCLGE_NIC_SW_RST_RDY_B		16
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index cb756cf307eb..750390c2533a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -92,23 +92,23 @@ static const struct pci_device_id ae_algo_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, ae_algo_pci_tbl);
 
-static const u32 cmdq_reg_addr_list[] = {HCLGE_CMDQ_TX_ADDR_L_REG,
-					 HCLGE_CMDQ_TX_ADDR_H_REG,
-					 HCLGE_CMDQ_TX_DEPTH_REG,
-					 HCLGE_CMDQ_TX_TAIL_REG,
-					 HCLGE_CMDQ_TX_HEAD_REG,
-					 HCLGE_CMDQ_RX_ADDR_L_REG,
-					 HCLGE_CMDQ_RX_ADDR_H_REG,
-					 HCLGE_CMDQ_RX_DEPTH_REG,
-					 HCLGE_CMDQ_RX_TAIL_REG,
-					 HCLGE_CMDQ_RX_HEAD_REG,
+static const u32 cmdq_reg_addr_list[] = {HCLGE_NIC_CSQ_BASEADDR_L_REG,
+					 HCLGE_NIC_CSQ_BASEADDR_H_REG,
+					 HCLGE_NIC_CSQ_DEPTH_REG,
+					 HCLGE_NIC_CSQ_TAIL_REG,
+					 HCLGE_NIC_CSQ_HEAD_REG,
+					 HCLGE_NIC_CRQ_BASEADDR_L_REG,
+					 HCLGE_NIC_CRQ_BASEADDR_H_REG,
+					 HCLGE_NIC_CRQ_DEPTH_REG,
+					 HCLGE_NIC_CRQ_TAIL_REG,
+					 HCLGE_NIC_CRQ_HEAD_REG,
 					 HCLGE_VECTOR0_CMDQ_SRC_REG,
 					 HCLGE_CMDQ_INTR_STS_REG,
 					 HCLGE_CMDQ_INTR_EN_REG,
 					 HCLGE_CMDQ_INTR_GEN_REG};
 
 static const u32 common_reg_addr_list[] = {HCLGE_MISC_VECTOR_REG_BASE,
-					   HCLGE_VECTOR0_OTER_EN_REG,
+					   HCLGE_PF_OTHER_INT_REG,
 					   HCLGE_MISC_RESET_STS_REG,
 					   HCLGE_MISC_VECTOR_INT_STS,
 					   HCLGE_GLOBAL_RESET_REG,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index b6c1153945e5..9ca7bb26912a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -38,22 +38,22 @@
 #define HCLGE_VECTOR_REG_OFFSET_H	0x1000
 #define HCLGE_VECTOR_VF_OFFSET		0x100000
 
-#define HCLGE_CMDQ_TX_ADDR_L_REG	0x27000
-#define HCLGE_CMDQ_TX_ADDR_H_REG	0x27004
-#define HCLGE_CMDQ_TX_DEPTH_REG		0x27008
-#define HCLGE_CMDQ_TX_TAIL_REG		0x27010
-#define HCLGE_CMDQ_TX_HEAD_REG		0x27014
-#define HCLGE_CMDQ_RX_ADDR_L_REG	0x27018
-#define HCLGE_CMDQ_RX_ADDR_H_REG	0x2701C
-#define HCLGE_CMDQ_RX_DEPTH_REG		0x27020
-#define HCLGE_CMDQ_RX_TAIL_REG		0x27024
-#define HCLGE_CMDQ_RX_HEAD_REG		0x27028
+#define HCLGE_NIC_CSQ_BASEADDR_L_REG	0x27000
+#define HCLGE_NIC_CSQ_BASEADDR_H_REG	0x27004
+#define HCLGE_NIC_CSQ_DEPTH_REG		0x27008
+#define HCLGE_NIC_CSQ_TAIL_REG		0x27010
+#define HCLGE_NIC_CSQ_HEAD_REG		0x27014
+#define HCLGE_NIC_CRQ_BASEADDR_L_REG	0x27018
+#define HCLGE_NIC_CRQ_BASEADDR_H_REG	0x2701C
+#define HCLGE_NIC_CRQ_DEPTH_REG		0x27020
+#define HCLGE_NIC_CRQ_TAIL_REG		0x27024
+#define HCLGE_NIC_CRQ_HEAD_REG		0x27028
+
 #define HCLGE_CMDQ_INTR_STS_REG		0x27104
 #define HCLGE_CMDQ_INTR_EN_REG		0x27108
 #define HCLGE_CMDQ_INTR_GEN_REG		0x2710C
 
 /* bar registers for common func */
-#define HCLGE_VECTOR0_OTER_EN_REG	0x20600
 #define HCLGE_GRO_EN_REG		0x28000
 #define HCLGE_RXD_ADV_LAYOUT_EN_REG	0x28008
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 5b82177f98b4..f6d6502f0389 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -266,16 +266,6 @@ struct hclgevf_cfg_tx_queue_pointer_cmd {
 
 #define HCLGEVF_TYPE_CRQ		0
 #define HCLGEVF_TYPE_CSQ		1
-#define HCLGEVF_NIC_CSQ_BASEADDR_L_REG	0x27000
-#define HCLGEVF_NIC_CSQ_BASEADDR_H_REG	0x27004
-#define HCLGEVF_NIC_CSQ_DEPTH_REG	0x27008
-#define HCLGEVF_NIC_CSQ_TAIL_REG	0x27010
-#define HCLGEVF_NIC_CSQ_HEAD_REG	0x27014
-#define HCLGEVF_NIC_CRQ_BASEADDR_L_REG	0x27018
-#define HCLGEVF_NIC_CRQ_BASEADDR_H_REG	0x2701c
-#define HCLGEVF_NIC_CRQ_DEPTH_REG	0x27020
-#define HCLGEVF_NIC_CRQ_TAIL_REG	0x27024
-#define HCLGEVF_NIC_CRQ_HEAD_REG	0x27028
 
 /* this bit indicates that the driver is ready for hardware reset */
 #define HCLGEVF_NIC_SW_RST_RDY_B	16
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 60588b194fe7..82e727020120 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -40,16 +40,16 @@ static const u8 hclgevf_hash_key[] = {
 
 MODULE_DEVICE_TABLE(pci, ae_algovf_pci_tbl);
 
-static const u32 cmdq_reg_addr_list[] = {HCLGEVF_CMDQ_TX_ADDR_L_REG,
-					 HCLGEVF_CMDQ_TX_ADDR_H_REG,
-					 HCLGEVF_CMDQ_TX_DEPTH_REG,
-					 HCLGEVF_CMDQ_TX_TAIL_REG,
-					 HCLGEVF_CMDQ_TX_HEAD_REG,
-					 HCLGEVF_CMDQ_RX_ADDR_L_REG,
-					 HCLGEVF_CMDQ_RX_ADDR_H_REG,
-					 HCLGEVF_CMDQ_RX_DEPTH_REG,
-					 HCLGEVF_CMDQ_RX_TAIL_REG,
-					 HCLGEVF_CMDQ_RX_HEAD_REG,
+static const u32 cmdq_reg_addr_list[] = {HCLGEVF_NIC_CSQ_BASEADDR_L_REG,
+					 HCLGEVF_NIC_CSQ_BASEADDR_H_REG,
+					 HCLGEVF_NIC_CSQ_DEPTH_REG,
+					 HCLGEVF_NIC_CSQ_TAIL_REG,
+					 HCLGEVF_NIC_CSQ_HEAD_REG,
+					 HCLGEVF_NIC_CRQ_BASEADDR_L_REG,
+					 HCLGEVF_NIC_CRQ_BASEADDR_H_REG,
+					 HCLGEVF_NIC_CRQ_DEPTH_REG,
+					 HCLGEVF_NIC_CRQ_TAIL_REG,
+					 HCLGEVF_NIC_CRQ_HEAD_REG,
 					 HCLGEVF_VECTOR0_CMDQ_SRC_REG,
 					 HCLGEVF_VECTOR0_CMDQ_STATE_REG,
 					 HCLGEVF_CMDQ_INTR_EN_REG,
@@ -1963,7 +1963,7 @@ static void hclgevf_dump_rst_info(struct hclgevf_dev *hdev)
 	dev_info(&hdev->pdev->dev, "vector0 interrupt status: 0x%x\n",
 		 hclgevf_read_dev(&hdev->hw, HCLGEVF_VECTOR0_CMDQ_STATE_REG));
 	dev_info(&hdev->pdev->dev, "handshake status: 0x%x\n",
-		 hclgevf_read_dev(&hdev->hw, HCLGEVF_CMDQ_TX_DEPTH_REG));
+		 hclgevf_read_dev(&hdev->hw, HCLGEVF_NIC_CSQ_DEPTH_REG));
 	dev_info(&hdev->pdev->dev, "function reset status: 0x%x\n",
 		 hclgevf_read_dev(&hdev->hw, HCLGEVF_RST_ING));
 	dev_info(&hdev->pdev->dev, "hdev state: 0x%lx\n", hdev->state);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 1de8e2deda15..883130a9b48f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -33,16 +33,17 @@
 #define HCLGEVF_VECTOR_VF_OFFSET		0x100000
 
 /* bar registers for cmdq */
-#define HCLGEVF_CMDQ_TX_ADDR_L_REG		0x27000
-#define HCLGEVF_CMDQ_TX_ADDR_H_REG		0x27004
-#define HCLGEVF_CMDQ_TX_DEPTH_REG		0x27008
-#define HCLGEVF_CMDQ_TX_TAIL_REG		0x27010
-#define HCLGEVF_CMDQ_TX_HEAD_REG		0x27014
-#define HCLGEVF_CMDQ_RX_ADDR_L_REG		0x27018
-#define HCLGEVF_CMDQ_RX_ADDR_H_REG		0x2701C
-#define HCLGEVF_CMDQ_RX_DEPTH_REG		0x27020
-#define HCLGEVF_CMDQ_RX_TAIL_REG		0x27024
-#define HCLGEVF_CMDQ_RX_HEAD_REG		0x27028
+#define HCLGEVF_NIC_CSQ_BASEADDR_L_REG		0x27000
+#define HCLGEVF_NIC_CSQ_BASEADDR_H_REG		0x27004
+#define HCLGEVF_NIC_CSQ_DEPTH_REG		0x27008
+#define HCLGEVF_NIC_CSQ_TAIL_REG		0x27010
+#define HCLGEVF_NIC_CSQ_HEAD_REG		0x27014
+#define HCLGEVF_NIC_CRQ_BASEADDR_L_REG		0x27018
+#define HCLGEVF_NIC_CRQ_BASEADDR_H_REG		0x2701C
+#define HCLGEVF_NIC_CRQ_DEPTH_REG		0x27020
+#define HCLGEVF_NIC_CRQ_TAIL_REG		0x27024
+#define HCLGEVF_NIC_CRQ_HEAD_REG		0x27028
+
 #define HCLGEVF_CMDQ_INTR_EN_REG		0x27108
 #define HCLGEVF_CMDQ_INTR_GEN_REG		0x2710C
 
-- 
2.8.1

