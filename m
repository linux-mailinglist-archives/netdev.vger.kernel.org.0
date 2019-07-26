Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5110275D76
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 05:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfGZD1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 23:27:50 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3164 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726065AbfGZD1N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 23:27:13 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DE6E37045396CF3002CB;
        Fri, 26 Jul 2019 11:27:09 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Fri, 26 Jul 2019 11:27:00 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 11/11] net: hns3: use dev_info() instead of pr_info()
Date:   Fri, 26 Jul 2019 11:25:02 +0800
Message-ID: <1564111502-15504-12-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564111502-15504-1-git-send-email-tanhuazhong@huawei.com>
References: <1564111502-15504-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_info() is more appropriate for printing messages when driver
initialization done, so switch to dev_info().

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 4 +++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3e43dff..588fb42 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8864,7 +8864,9 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hclge_state_init(hdev);
 	hdev->last_reset_time = jiffies;
 
-	pr_info("%s driver initialization finished.\n", HCLGE_DRIVER_NAME);
+	dev_info(&hdev->pdev->dev, "%s driver initialization finished.\n",
+		 HCLGE_DRIVER_NAME);
+
 	return 0;
 
 err_mdiobus_unreg:
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index db84782..218fd5d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2703,7 +2703,8 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 	}
 
 	hdev->last_reset_time = jiffies;
-	pr_info("finished initializing %s driver\n", HCLGEVF_DRIVER_NAME);
+	dev_info(&hdev->pdev->dev, "finished initializing %s driver\n",
+		 HCLGEVF_DRIVER_NAME);
 
 	return 0;
 
-- 
2.7.4

