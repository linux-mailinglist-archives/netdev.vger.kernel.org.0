Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF4E277CE0
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgIYA3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:29:02 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14278 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726694AbgIYA3B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:29:01 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CF303DA0153B6FBC5FDA;
        Fri, 25 Sep 2020 08:28:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Fri, 25 Sep 2020 08:28:52 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/6] net: hns3: refactor the function for dumping tc information in debugfs
Date:   Fri, 25 Sep 2020 08:26:13 +0800
Message-ID: <1600993578-41008-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600993578-41008-1-git-send-email-tanhuazhong@huawei.com>
References: <1600993578-41008-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Remove some unnecessary parameters of hclge_title_idx_print(),
and rename this function for readability.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c    | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 26f6f06..28be561 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -428,17 +428,13 @@ static void hclge_dbg_dump_reg_cmd(struct hclge_dev *hdev, const char *cmd_buf)
 	}
 }
 
-static void hclge_title_idx_print(struct hclge_dev *hdev, bool flag, int index,
-				  char *title_buf, char *true_buf,
-				  char *false_buf)
+static void hclge_print_tc_info(struct hclge_dev *hdev, bool flag, int index)
 {
 	if (flag)
-		dev_info(&hdev->pdev->dev, "%s(%d): %s weight: %u\n",
-			 title_buf, index, true_buf,
-			 hdev->tm_info.pg_info[0].tc_dwrr[index]);
+		dev_info(&hdev->pdev->dev, "tc(%d): no sp mode weight: %u\n",
+			 index, hdev->tm_info.pg_info[0].tc_dwrr[index]);
 	else
-		dev_info(&hdev->pdev->dev, "%s(%d): %s\n", title_buf, index,
-			 false_buf);
+		dev_info(&hdev->pdev->dev, "tc(%d): sp mode\n", index);
 }
 
 static void hclge_dbg_dump_tc(struct hclge_dev *hdev)
@@ -469,8 +465,7 @@ static void hclge_dbg_dump_tc(struct hclge_dev *hdev)
 		 ets_weight->weight_offset);
 
 	for (i = 0; i < HNAE3_MAX_TC; i++)
-		hclge_title_idx_print(hdev, ets_weight->tc_weight[i], i,
-				      "tc", "no sp mode", "sp mode");
+		hclge_print_tc_info(hdev, ets_weight->tc_weight[i], i);
 }
 
 static void hclge_dbg_dump_tm_pg(struct hclge_dev *hdev)
-- 
2.7.4

