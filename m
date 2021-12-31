Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B33482340
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 11:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhLaKUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 05:20:08 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:30132 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhLaKT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 05:19:59 -0500
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JQLdx0sXrz1DKPL;
        Fri, 31 Dec 2021 18:16:37 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:19:57 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:19:57 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 10/10] net: hns3: delete the hclge_cmd.c and hclgevf_cmd.c
Date:   Fri, 31 Dec 2021 18:14:59 +0800
Message-ID: <20211231101459.56083-11-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211231101459.56083-1-huangguangbin2@huawei.com>
References: <20211231101459.56083-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

currently most cmdq APIs are unified in hclge_comm_cmd.c. Newly developed
cmdq APIs should also be placed in hclge_comm_cmd.c. So there is no need to
keep hclge_cmd.c and hclgevf_cmd.c.

This patch moves the hclge(vf)_cmd_send to hclge(vf)_main.c and deletes
the source files and makefile scripts.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/Makefile  |  4 +-
 .../hisilicon/hns3/hns3pf/hclge_cmd.c         | 26 -------------
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 14 +++++++
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.c       | 38 -------------------
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 26 +++++++++++++
 5 files changed, 42 insertions(+), 66 deletions(-)
 delete mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
 delete mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c

diff --git a/drivers/net/ethernet/hisilicon/hns3/Makefile b/drivers/net/ethernet/hisilicon/hns3/Makefile
index cb3aaf5252d0..18f833138562 100644
--- a/drivers/net/ethernet/hisilicon/hns3/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/Makefile
@@ -17,11 +17,11 @@ hns3-$(CONFIG_HNS3_DCB) += hns3_dcbnl.o
 
 obj-$(CONFIG_HNS3_HCLGEVF) += hclgevf.o
 
-hclgevf-objs = hns3vf/hclgevf_main.o hns3vf/hclgevf_cmd.o hns3vf/hclgevf_mbx.o  hns3vf/hclgevf_devlink.o \
+hclgevf-objs = hns3vf/hclgevf_main.o hns3vf/hclgevf_mbx.o  hns3vf/hclgevf_devlink.o \
 		hns3_common/hclge_comm_cmd.o
 
 obj-$(CONFIG_HNS3_HCLGE) += hclge.o
-hclge-objs = hns3pf/hclge_main.o hns3pf/hclge_cmd.o hns3pf/hclge_mdio.o hns3pf/hclge_tm.o \
+hclge-objs = hns3pf/hclge_main.o hns3pf/hclge_mdio.o hns3pf/hclge_tm.o \
 		hns3pf/hclge_mbx.o hns3pf/hclge_err.o  hns3pf/hclge_debugfs.o hns3pf/hclge_ptp.o hns3pf/hclge_devlink.o \
 		hns3_common/hclge_comm_cmd.o
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
deleted file mode 100644
index 6a066d3ac86e..000000000000
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ /dev/null
@@ -1,26 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-// Copyright (c) 2016-2017 Hisilicon Limited.
-
-#include <linux/dma-mapping.h>
-#include <linux/slab.h>
-#include <linux/pci.h>
-#include <linux/device.h>
-#include <linux/err.h>
-#include <linux/dma-direction.h>
-#include "hclge_cmd.h"
-#include "hnae3.h"
-#include "hclge_main.h"
-
-/**
- * hclge_cmd_send - send command to command queue
- * @hw: pointer to the hw struct
- * @desc: prefilled descriptor for describing the command
- * @num : the number of descriptors to be sent
- *
- * This is the main send command for command queue, it
- * sends the queue, cleans the queue, etc
- **/
-int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num)
-{
-	return hclge_comm_cmd_send(&hw->hw, desc, num, true);
-}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 9eab97f804c8..bc117ea3c9c5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -479,6 +479,20 @@ static const struct key_info tuple_key_info[] = {
 	  offsetof(struct hclge_fd_rule, tuples_mask.l4_user_def) },
 };
 
+/**
+ * hclge_cmd_send - send command to command queue
+ * @hw: pointer to the hw struct
+ * @desc: prefilled descriptor for describing the command
+ * @num : the number of descriptors to be sent
+ *
+ * This is the main send command for command queue, it
+ * sends the queue, cleans the queue, etc
+ **/
+int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num)
+{
+	return hclge_comm_cmd_send(&hw->hw, desc, num, true);
+}
+
 static int hclge_mac_update_stats_defective(struct hclge_dev *hdev)
 {
 #define HCLGE_MAC_CMD_NUM 21
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
deleted file mode 100644
index fc9dc506cfd2..000000000000
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ /dev/null
@@ -1,38 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-// Copyright (c) 2016-2017 Hisilicon Limited.
-
-#include <linux/device.h>
-#include <linux/dma-direction.h>
-#include <linux/dma-mapping.h>
-#include <linux/err.h>
-#include <linux/pci.h>
-#include <linux/slab.h>
-#include "hclgevf_cmd.h"
-#include "hclgevf_main.h"
-#include "hnae3.h"
-
-/* hclgevf_cmd_send - send command to command queue
- * @hw: pointer to the hw struct
- * @desc: prefilled descriptor for describing the command
- * @num : the number of descriptors to be sent
- *
- * This is the main send command for command queue, it
- * sends the queue, cleans the queue, etc
- */
-int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclge_desc *desc, int num)
-{
-	return hclge_comm_cmd_send(&hw->hw, desc, num, false);
-}
-
-void hclgevf_arq_init(struct hclgevf_dev *hdev)
-{
-	struct hclge_comm_cmq *cmdq = &hdev->hw.hw.cmq;
-
-	spin_lock(&cmdq->crq.lock);
-	/* initialize the pointers of async rx queue of mailbox */
-	hdev->arq.hdev = hdev;
-	hdev->arq.head = 0;
-	hdev->arq.tail = 0;
-	atomic_set(&hdev->arq.count, 0);
-	spin_unlock(&cmdq->crq.lock);
-}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 2889c75195c5..08bd6fe0f29e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -92,6 +92,32 @@ static const u32 tqp_intr_reg_addr_list[] = {HCLGEVF_TQP_INTR_CTRL_REG,
 					     HCLGEVF_TQP_INTR_GL2_REG,
 					     HCLGEVF_TQP_INTR_RL_REG};
 
+/* hclgevf_cmd_send - send command to command queue
+ * @hw: pointer to the hw struct
+ * @desc: prefilled descriptor for describing the command
+ * @num : the number of descriptors to be sent
+ *
+ * This is the main send command for command queue, it
+ * sends the queue, cleans the queue, etc
+ */
+int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclge_desc *desc, int num)
+{
+	return hclge_comm_cmd_send(&hw->hw, desc, num, false);
+}
+
+void hclgevf_arq_init(struct hclgevf_dev *hdev)
+{
+	struct hclge_comm_cmq *cmdq = &hdev->hw.hw.cmq;
+
+	spin_lock(&cmdq->crq.lock);
+	/* initialize the pointers of async rx queue of mailbox */
+	hdev->arq.hdev = hdev;
+	hdev->arq.head = 0;
+	hdev->arq.tail = 0;
+	atomic_set(&hdev->arq.count, 0);
+	spin_unlock(&cmdq->crq.lock);
+}
+
 static struct hclgevf_dev *hclgevf_ae_get_hdev(struct hnae3_handle *handle)
 {
 	if (!handle->client)
-- 
2.33.0

