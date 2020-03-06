Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E2517B4B6
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 03:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgCFC6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 21:58:18 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:38322 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727050AbgCFC6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 21:58:02 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6A4BBCADAAF88A417D2A;
        Fri,  6 Mar 2020 10:57:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Mar 2020 10:57:51 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 9/9] net: hns3: delete unnecessary logs after kzalloc fails
Date:   Fri, 6 Mar 2020 10:57:18 +0800
Message-ID: <1583463438-60953-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583463438-60953-1-git-send-email-tanhuazhong@huawei.com>
References: <1583463438-60953-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Since kernel already has logs after kzalloc fails,
it's unnecessary to print duplicate logs. So this
patch deletes these logs.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 8ba6985..f07d2f4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -145,10 +145,8 @@ static void hclge_dbg_dump_reg_common(struct hclge_dev *hdev,
 
 	buf_len	= sizeof(struct hclge_desc) * bd_num;
 	desc_src = kzalloc(buf_len, GFP_KERNEL);
-	if (!desc_src) {
-		dev_err(&hdev->pdev->dev, "call kzalloc failed\n");
+	if (!desc_src)
 		return;
-	}
 
 	desc = desc_src;
 	ret = hclge_dbg_cmd_send(hdev, desc, index, bd_num, reg_msg->cmd);
@@ -1082,11 +1080,8 @@ static void hclge_dbg_get_m7_stats_info(struct hclge_dev *hdev)
 
 	buf_len	 = sizeof(struct hclge_desc) * bd_num;
 	desc_src = kzalloc(buf_len, GFP_KERNEL);
-	if (!desc_src) {
-		dev_err(&hdev->pdev->dev,
-			"allocate desc for get_m7_stats failed\n");
+	if (!desc_src)
 		return;
-	}
 
 	desc_tmp = desc_src;
 	ret  = hclge_dbg_cmd_send(hdev, desc_tmp, 0, bd_num,
-- 
2.7.4

