Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9935B1E6155
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389979AbgE1MsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:48:25 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5369 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389970AbgE1MsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 08:48:22 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4C1685302C407AC1B015;
        Thu, 28 May 2020 20:46:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 28 May 2020 20:46:38 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 09/11] net: hns3: remove two duplicated register macros in hclgevf_main.h
Date:   Thu, 28 May 2020 20:45:10 +0800
Message-ID: <1590669912-21867-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590669912-21867-1-git-send-email-tanhuazhong@huawei.com>
References: <1590669912-21867-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HCLGEVF_CMDQ_INTR_SRC_REG and HCLGEVF_CMDQ_INTR_STS_REG are same
as HCLGEVF_VECTOR0_CMDQ_SRC_REG and HCLGEVF_VECTOR0_CMDQ_STAT_REG,
replace the former with the latter, and rename macro
HCLGEVF_VECTOR0_CMDQ_STAT_REG since 'stat' is not abbreviation of
'state'.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 6 +++---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 4 +---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index be5789b..a8c0e79 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -46,7 +46,7 @@ static const u32 cmdq_reg_addr_list[] = {HCLGEVF_CMDQ_TX_ADDR_L_REG,
 					 HCLGEVF_CMDQ_RX_TAIL_REG,
 					 HCLGEVF_CMDQ_RX_HEAD_REG,
 					 HCLGEVF_VECTOR0_CMDQ_SRC_REG,
-					 HCLGEVF_CMDQ_INTR_STS_REG,
+					 HCLGEVF_VECTOR0_CMDQ_STATE_REG,
 					 HCLGEVF_CMDQ_INTR_EN_REG,
 					 HCLGEVF_CMDQ_INTR_GEN_REG};
 
@@ -1826,7 +1826,7 @@ static void hclgevf_dump_rst_info(struct hclgevf_dev *hdev)
 	dev_info(&hdev->pdev->dev, "vector0 interrupt enable status: 0x%x\n",
 		 hclgevf_read_dev(&hdev->hw, HCLGEVF_MISC_VECTOR_REG_BASE));
 	dev_info(&hdev->pdev->dev, "vector0 interrupt status: 0x%x\n",
-		 hclgevf_read_dev(&hdev->hw, HCLGEVF_VECTOR0_CMDQ_STAT_REG));
+		 hclgevf_read_dev(&hdev->hw, HCLGEVF_VECTOR0_CMDQ_STATE_REG));
 	dev_info(&hdev->pdev->dev, "handshake status: 0x%x\n",
 		 hclgevf_read_dev(&hdev->hw, HCLGEVF_CMDQ_TX_DEPTH_REG));
 	dev_info(&hdev->pdev->dev, "function reset status: 0x%x\n",
@@ -2250,7 +2250,7 @@ static enum hclgevf_evt_cause hclgevf_check_evt_cause(struct hclgevf_dev *hdev,
 
 	/* fetch the events from their corresponding regs */
 	cmdq_stat_reg = hclgevf_read_dev(&hdev->hw,
-					 HCLGEVF_VECTOR0_CMDQ_STAT_REG);
+					 HCLGEVF_VECTOR0_CMDQ_STATE_REG);
 
 	if (BIT(HCLGEVF_VECTOR0_RST_INT_B) & cmdq_stat_reg) {
 		rst_ing_reg = hclgevf_read_dev(&hdev->hw, HCLGEVF_RST_ING);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index f19583c..738de12 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -42,8 +42,6 @@
 #define HCLGEVF_CMDQ_RX_DEPTH_REG		0x27020
 #define HCLGEVF_CMDQ_RX_TAIL_REG		0x27024
 #define HCLGEVF_CMDQ_RX_HEAD_REG		0x27028
-#define HCLGEVF_CMDQ_INTR_SRC_REG		0x27100
-#define HCLGEVF_CMDQ_INTR_STS_REG		0x27104
 #define HCLGEVF_CMDQ_INTR_EN_REG		0x27108
 #define HCLGEVF_CMDQ_INTR_GEN_REG		0x2710C
 
@@ -88,7 +86,7 @@
 /* Vector0 interrupt CMDQ event source register(RW) */
 #define HCLGEVF_VECTOR0_CMDQ_SRC_REG	0x27100
 /* Vector0 interrupt CMDQ event status register(RO) */
-#define HCLGEVF_VECTOR0_CMDQ_STAT_REG	0x27104
+#define HCLGEVF_VECTOR0_CMDQ_STATE_REG	0x27104
 /* CMDQ register bits for RX event(=MBX event) */
 #define HCLGEVF_VECTOR0_RX_CMDQ_INT_B	1
 /* RST register bits for RESET event */
-- 
2.7.4

