Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37C8A16394A
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 02:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgBSBYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 20:24:21 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10211 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727939AbgBSBYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 20:24:13 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BFC159C5DE81D9E6A99F;
        Wed, 19 Feb 2020 09:24:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Wed, 19 Feb 2020 09:24:00 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/4] net: hns3: add enabled TC numbers and DWRR weight info in debugfs
Date:   Wed, 19 Feb 2020 09:23:31 +0800
Message-ID: <1582075413-34966-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582075413-34966-1-git-send-email-tanhuazhong@huawei.com>
References: <1582075413-34966-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

The actual enabled TC numbers and the DWRR weight of each
TC may be helpful for debugging, so adds them into debugfs.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 67fad80..5e94b35 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -310,8 +310,9 @@ static void hclge_title_idx_print(struct hclge_dev *hdev, bool flag, int index,
 				  char *false_buf)
 {
 	if (flag)
-		dev_info(&hdev->pdev->dev, "%s(%d): %s\n", title_buf, index,
-			 true_buf);
+		dev_info(&hdev->pdev->dev, "%s(%d): %s weight: %u\n",
+			 title_buf, index, true_buf,
+			 hdev->tm_info.pg_info[0].tc_dwrr[index]);
 	else
 		dev_info(&hdev->pdev->dev, "%s(%d): %s\n", title_buf, index,
 			 false_buf);
@@ -339,7 +340,8 @@ static void hclge_dbg_dump_tc(struct hclge_dev *hdev)
 
 	ets_weight = (struct hclge_ets_tc_weight_cmd *)desc.data;
 
-	dev_info(&hdev->pdev->dev, "dump tc\n");
+	dev_info(&hdev->pdev->dev, "dump tc: %u tc enabled\n",
+		 hdev->tm_info.num_tc);
 	dev_info(&hdev->pdev->dev, "weight_offset: %u\n",
 		 ets_weight->weight_offset);
 
-- 
2.7.4

