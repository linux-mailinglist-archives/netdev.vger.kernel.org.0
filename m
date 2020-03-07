Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8274517CBC5
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 04:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgCGDwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 22:52:37 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11606 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726382AbgCGDwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 22:52:34 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1D32B87EBF5CB4F6D62E;
        Sat,  7 Mar 2020 11:52:29 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Sat, 7 Mar 2020 11:52:21 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 9/9] net: hns3: delete unnecessary logs after kzalloc fails
Date:   Sat, 7 Mar 2020 11:42:50 +0800
Message-ID: <1583552570-51203-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583552570-51203-1-git-send-email-tanhuazhong@huawei.com>
References: <1583552570-51203-1-git-send-email-tanhuazhong@huawei.com>
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
index 07b30f9..1722828 100644
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

