Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D80A130AEA
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfEaI5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:57:40 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37040 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726330AbfEaI4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:56:35 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2967DE7E84081C631DD3;
        Fri, 31 May 2019 16:56:32 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Fri, 31 May 2019 16:56:25 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>
Subject: [PATCH net-next 01/12] net: hns3: remove redundant core reset
Date:   Fri, 31 May 2019 16:54:47 +0800
Message-ID: <1559292898-64090-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559292898-64090-1-git-send-email-tanhuazhong@huawei.com>
References: <1559292898-64090-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since core reset is similar to the global reset, so this
patch removes it and uses global reset to replace it.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 24 +++++++++----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 28 ----------------------
 3 files changed, 12 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index a18645e..51c2ff1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -154,7 +154,6 @@ enum hnae3_reset_type {
 	HNAE3_VF_FULL_RESET,
 	HNAE3_FLR_RESET,
 	HNAE3_FUNC_RESET,
-	HNAE3_CORE_RESET,
 	HNAE3_GLOBAL_RESET,
 	HNAE3_IMP_RESET,
 	HNAE3_UNKNOWN_RESET,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 4ac8063..55c4a1b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -87,25 +87,25 @@ static const struct hclge_hw_error hclge_msix_sram_ecc_int[] = {
 
 static const struct hclge_hw_error hclge_igu_int[] = {
 	{ .int_msk = BIT(0), .msg = "igu_rx_buf0_ecc_mbit_err",
-	  .reset_level = HNAE3_CORE_RESET },
+	  .reset_level = HNAE3_GLOBAL_RESET },
 	{ .int_msk = BIT(2), .msg = "igu_rx_buf1_ecc_mbit_err",
-	  .reset_level = HNAE3_CORE_RESET },
+	  .reset_level = HNAE3_GLOBAL_RESET },
 	{ /* sentinel */ }
 };
 
 static const struct hclge_hw_error hclge_igu_egu_tnl_int[] = {
 	{ .int_msk = BIT(0), .msg = "rx_buf_overflow",
-	  .reset_level = HNAE3_CORE_RESET },
+	  .reset_level = HNAE3_GLOBAL_RESET },
 	{ .int_msk = BIT(1), .msg = "rx_stp_fifo_overflow",
-	  .reset_level = HNAE3_CORE_RESET },
+	  .reset_level = HNAE3_GLOBAL_RESET },
 	{ .int_msk = BIT(2), .msg = "rx_stp_fifo_undeflow",
-	  .reset_level = HNAE3_CORE_RESET },
+	  .reset_level = HNAE3_GLOBAL_RESET },
 	{ .int_msk = BIT(3), .msg = "tx_buf_overflow",
-	  .reset_level = HNAE3_CORE_RESET },
+	  .reset_level = HNAE3_GLOBAL_RESET },
 	{ .int_msk = BIT(4), .msg = "tx_buf_underrun",
-	  .reset_level = HNAE3_CORE_RESET },
+	  .reset_level = HNAE3_GLOBAL_RESET },
 	{ .int_msk = BIT(5), .msg = "rx_stp_buf_overflow",
-	  .reset_level = HNAE3_CORE_RESET },
+	  .reset_level = HNAE3_GLOBAL_RESET },
 	{ /* sentinel */ }
 };
 
@@ -413,13 +413,13 @@ static const struct hclge_hw_error hclge_ppu_mpf_abnormal_int_st2[] = {
 
 static const struct hclge_hw_error hclge_ppu_mpf_abnormal_int_st3[] = {
 	{ .int_msk = BIT(4), .msg = "gro_bd_ecc_mbit_err",
-	  .reset_level = HNAE3_CORE_RESET },
+	  .reset_level = HNAE3_GLOBAL_RESET },
 	{ .int_msk = BIT(5), .msg = "gro_context_ecc_mbit_err",
-	  .reset_level = HNAE3_CORE_RESET },
+	  .reset_level = HNAE3_GLOBAL_RESET },
 	{ .int_msk = BIT(6), .msg = "rx_stash_cfg_ecc_mbit_err",
-	  .reset_level = HNAE3_CORE_RESET },
+	  .reset_level = HNAE3_GLOBAL_RESET },
 	{ .int_msk = BIT(7), .msg = "axi_rd_fbd_ecc_mbit_err",
-	  .reset_level = HNAE3_CORE_RESET },
+	  .reset_level = HNAE3_GLOBAL_RESET },
 	{ /* sentinel */ }
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 0545f38..f0f618d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2706,15 +2706,6 @@ static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 		return HCLGE_VECTOR0_EVENT_RST;
 	}
 
-	if (BIT(HCLGE_VECTOR0_CORERESET_INT_B) & rst_src_reg) {
-		dev_info(&hdev->pdev->dev, "core reset interrupt\n");
-		set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
-		set_bit(HNAE3_CORE_RESET, &hdev->reset_pending);
-		*clearval = BIT(HCLGE_VECTOR0_CORERESET_INT_B);
-		hdev->rst_stats.core_rst_cnt++;
-		return HCLGE_VECTOR0_EVENT_RST;
-	}
-
 	/* check for vector0 msix event source */
 	if (msix_src_reg & HCLGE_VECTOR0_REG_MSIX_MASK) {
 		dev_dbg(&hdev->pdev->dev, "received event 0x%x\n",
@@ -2941,10 +2932,6 @@ static int hclge_reset_wait(struct hclge_dev *hdev)
 		reg = HCLGE_GLOBAL_RESET_REG;
 		reg_bit = HCLGE_GLOBAL_RESET_BIT;
 		break;
-	case HNAE3_CORE_RESET:
-		reg = HCLGE_GLOBAL_RESET_REG;
-		reg_bit = HCLGE_CORE_RESET_BIT;
-		break;
 	case HNAE3_FUNC_RESET:
 		reg = HCLGE_FUN_RST_ING;
 		reg_bit = HCLGE_FUN_RST_ING_B;
@@ -3076,12 +3063,6 @@ static void hclge_do_reset(struct hclge_dev *hdev)
 		hclge_write_dev(&hdev->hw, HCLGE_GLOBAL_RESET_REG, val);
 		dev_info(&pdev->dev, "Global Reset requested\n");
 		break;
-	case HNAE3_CORE_RESET:
-		val = hclge_read_dev(&hdev->hw, HCLGE_GLOBAL_RESET_REG);
-		hnae3_set_bit(val, HCLGE_CORE_RESET_BIT, 1);
-		hclge_write_dev(&hdev->hw, HCLGE_GLOBAL_RESET_REG, val);
-		dev_info(&pdev->dev, "Core Reset requested\n");
-		break;
 	case HNAE3_FUNC_RESET:
 		dev_info(&pdev->dev, "PF Reset requested\n");
 		/* schedule again to check later */
@@ -3128,16 +3109,10 @@ static enum hnae3_reset_type hclge_get_reset_level(struct hclge_dev *hdev,
 		rst_level = HNAE3_IMP_RESET;
 		clear_bit(HNAE3_IMP_RESET, addr);
 		clear_bit(HNAE3_GLOBAL_RESET, addr);
-		clear_bit(HNAE3_CORE_RESET, addr);
 		clear_bit(HNAE3_FUNC_RESET, addr);
 	} else if (test_bit(HNAE3_GLOBAL_RESET, addr)) {
 		rst_level = HNAE3_GLOBAL_RESET;
 		clear_bit(HNAE3_GLOBAL_RESET, addr);
-		clear_bit(HNAE3_CORE_RESET, addr);
-		clear_bit(HNAE3_FUNC_RESET, addr);
-	} else if (test_bit(HNAE3_CORE_RESET, addr)) {
-		rst_level = HNAE3_CORE_RESET;
-		clear_bit(HNAE3_CORE_RESET, addr);
 		clear_bit(HNAE3_FUNC_RESET, addr);
 	} else if (test_bit(HNAE3_FUNC_RESET, addr)) {
 		rst_level = HNAE3_FUNC_RESET;
@@ -3165,9 +3140,6 @@ static void hclge_clear_reset_cause(struct hclge_dev *hdev)
 	case HNAE3_GLOBAL_RESET:
 		clearval = BIT(HCLGE_VECTOR0_GLOBALRESET_INT_B);
 		break;
-	case HNAE3_CORE_RESET:
-		clearval = BIT(HCLGE_VECTOR0_CORERESET_INT_B);
-		break;
 	default:
 		break;
 	}
-- 
2.7.4

