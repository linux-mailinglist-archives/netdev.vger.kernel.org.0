Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675EA2BA5B9
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgKTJQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:16:25 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8563 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbgKTJQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:16:22 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CcrWK15zczLqnH;
        Fri, 20 Nov 2020 17:15:57 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 20 Nov 2020 17:16:12 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/5] net: hns3: adds debugfs to dump more info of shaping parameters
Date:   Fri, 20 Nov 2020 17:16:23 +0800
Message-ID: <1605863783-36995-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605863783-36995-1-git-send-email-tanhuazhong@huawei.com>
References: <1605863783-36995-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

Adds debugfs to dump new shaping parameters: rate and flag.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index c82d2ca..bedbc11 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -498,6 +498,9 @@ static void hclge_dbg_dump_tm_pg(struct hclge_dev *hdev)
 	dev_info(&hdev->pdev->dev, "PG_P pg_id: %u\n", pg_shap_cfg_cmd->pg_id);
 	dev_info(&hdev->pdev->dev, "PG_P pg_shapping: 0x%x\n",
 		 le32_to_cpu(pg_shap_cfg_cmd->pg_shapping_para));
+	dev_info(&hdev->pdev->dev, "PG_P flag: %#x\n", pg_shap_cfg_cmd->flag);
+	dev_info(&hdev->pdev->dev, "PG_P pg_rate: %u(Mbps)\n",
+		 le32_to_cpu(pg_shap_cfg_cmd->pg_rate));
 
 	cmd = HCLGE_OPC_TM_PORT_SHAPPING;
 	hclge_cmd_setup_basic_desc(&desc, cmd, true);
@@ -508,6 +511,9 @@ static void hclge_dbg_dump_tm_pg(struct hclge_dev *hdev)
 	port_shap_cfg_cmd = (struct hclge_port_shapping_cmd *)desc.data;
 	dev_info(&hdev->pdev->dev, "PORT port_shapping: 0x%x\n",
 		 le32_to_cpu(port_shap_cfg_cmd->port_shapping_para));
+	dev_info(&hdev->pdev->dev, "PORT flag: %#x\n", port_shap_cfg_cmd->flag);
+	dev_info(&hdev->pdev->dev, "PORT port_rate: %u(Mbps)\n",
+		 le32_to_cpu(port_shap_cfg_cmd->port_rate));
 
 	cmd = HCLGE_OPC_TM_PG_SCH_MODE_CFG;
 	hclge_cmd_setup_basic_desc(&desc, cmd, true);
@@ -655,6 +661,9 @@ static void hclge_dbg_dump_tm(struct hclge_dev *hdev)
 	dev_info(&hdev->pdev->dev, "PRI_C pri_id: %u\n", shap_cfg_cmd->pri_id);
 	dev_info(&hdev->pdev->dev, "PRI_C pri_shapping: 0x%x\n",
 		 le32_to_cpu(shap_cfg_cmd->pri_shapping_para));
+	dev_info(&hdev->pdev->dev, "PRI_C flag: %#x\n", shap_cfg_cmd->flag);
+	dev_info(&hdev->pdev->dev, "PRI_C pri_rate: %u(Mbps)\n",
+		 le32_to_cpu(shap_cfg_cmd->pri_rate));
 
 	cmd = HCLGE_OPC_TM_PRI_P_SHAPPING;
 	hclge_cmd_setup_basic_desc(&desc, cmd, true);
@@ -666,6 +675,9 @@ static void hclge_dbg_dump_tm(struct hclge_dev *hdev)
 	dev_info(&hdev->pdev->dev, "PRI_P pri_id: %u\n", shap_cfg_cmd->pri_id);
 	dev_info(&hdev->pdev->dev, "PRI_P pri_shapping: 0x%x\n",
 		 le32_to_cpu(shap_cfg_cmd->pri_shapping_para));
+	dev_info(&hdev->pdev->dev, "PRI_P flag: %#x\n", shap_cfg_cmd->flag);
+	dev_info(&hdev->pdev->dev, "PRI_P pri_rate: %u(Mbps)\n",
+		 le32_to_cpu(shap_cfg_cmd->pri_rate));
 
 	hclge_dbg_dump_tm_pg(hdev);
 
@@ -1401,6 +1413,7 @@ static void hclge_dbg_dump_qs_shaper_single(struct hclge_dev *hdev, u16 qsid)
 	u8 ir_u, ir_b, ir_s, bs_b, bs_s;
 	struct hclge_desc desc;
 	u32 shapping_para;
+	u32 rate;
 	int ret;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QCN_SHAPPING_CFG, true);
@@ -1422,10 +1435,11 @@ static void hclge_dbg_dump_qs_shaper_single(struct hclge_dev *hdev, u16 qsid)
 	ir_s = hclge_tm_get_field(shapping_para, IR_S);
 	bs_b = hclge_tm_get_field(shapping_para, BS_B);
 	bs_s = hclge_tm_get_field(shapping_para, BS_S);
+	rate = le32_to_cpu(shap_cfg_cmd->qs_rate);
 
 	dev_info(&hdev->pdev->dev,
-		 "qs%u ir_b:%u, ir_u:%u, ir_s:%u, bs_b:%u, bs_s:%u\n",
-		 qsid, ir_b, ir_u, ir_s, bs_b, bs_s);
+		 "qs%u ir_b:%u, ir_u:%u, ir_s:%u, bs_b:%u, bs_s:%u, flag:%#x, rate:%u(Mbps)\n",
+		 qsid, ir_b, ir_u, ir_s, bs_b, bs_s, shap_cfg_cmd->flag, rate);
 }
 
 static void hclge_dbg_dump_qs_shaper_all(struct hclge_dev *hdev)
-- 
2.7.4

