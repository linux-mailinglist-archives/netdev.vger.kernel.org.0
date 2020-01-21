Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8B1143884
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 09:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgAUImd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 03:42:33 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10118 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729028AbgAUImd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 03:42:33 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DCB27D6787B3046631CE;
        Tue, 21 Jan 2020 16:42:29 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Tue, 21 Jan 2020 16:42:22 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/9] net: hns3: move duplicated macro definition into header
Date:   Tue, 21 Jan 2020 16:42:08 +0800
Message-ID: <1579596133-54842-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579596133-54842-1-git-send-email-tanhuazhong@huawei.com>
References: <1579596133-54842-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

Macro HCLGE_GET_DFX_REG_TYPE_CNT in hclge_dbg_get_dfx_bd_num()
and macro HCLGE_DFX_REG_BD_NUM in hclge_get_dfx_reg_bd_num()
have the same meaning, so just defines HCLGE_GET_DFX_REG_TYPE_CNT
in hclge_main.h.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 2 --
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 4 +---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h    | 2 ++
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index f3d4cbd..67fad80 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -73,8 +73,6 @@ static struct hclge_dbg_reg_type_info hclge_dbg_reg_info[] = {
 
 static int hclge_dbg_get_dfx_bd_num(struct hclge_dev *hdev, int offset)
 {
-#define HCLGE_GET_DFX_REG_TYPE_CNT	4
-
 	struct hclge_desc desc[HCLGE_GET_DFX_REG_TYPE_CNT];
 	int entries_per_desc;
 	int index;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 76e8aa4..8e007b7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10204,10 +10204,8 @@ static int hclge_get_dfx_reg_bd_num(struct hclge_dev *hdev,
 				    int *bd_num_list,
 				    u32 type_num)
 {
-#define HCLGE_DFX_REG_BD_NUM	4
-
 	u32 entries_per_desc, desc_index, index, offset, i;
-	struct hclge_desc desc[HCLGE_DFX_REG_BD_NUM];
+	struct hclge_desc desc[HCLGE_GET_DFX_REG_TYPE_CNT];
 	int ret;
 
 	ret = hclge_query_bd_num_cmd_send(hdev, desc);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 1c1d6b3..f78cbb4c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -139,6 +139,8 @@
 #define HCLGE_PHY_MDIX_STATUS_B		6
 #define HCLGE_PHY_SPEED_DUP_RESOLVE_B	11
 
+#define HCLGE_GET_DFX_REG_TYPE_CNT	4
+
 /* Factor used to calculate offset and bitmap of VF num */
 #define HCLGE_VF_NUM_PER_CMD           64
 
-- 
2.7.4

