Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03002608DB
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 05:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgIHDC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 23:02:59 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47866 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728411AbgIHDCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 23:02:30 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C73517F4414749013AF6;
        Tue,  8 Sep 2020 11:02:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Sep 2020 11:02:19 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/7] net: hns3: narrow two local variable range in hclgevf_reset_prepare_wait()
Date:   Tue, 8 Sep 2020 10:59:48 +0800
Message-ID: <1599533994-32744-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599533994-32744-1-git-send-email-tanhuazhong@huawei.com>
References: <1599533994-32744-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since variable send_msg and ret only used in if branch, so move
their definition into the if branch.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index e972138..20dd04c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1788,10 +1788,10 @@ static int hclgevf_reset_prepare_wait(struct hclgevf_dev *hdev)
 {
 #define HCLGEVF_RESET_SYNC_TIME 100
 
-	struct hclge_vf_to_pf_msg send_msg;
-	int ret = 0;
-
 	if (hdev->reset_type == HNAE3_VF_FUNC_RESET) {
+		struct hclge_vf_to_pf_msg send_msg;
+		int ret;
+
 		hclgevf_build_send_msg(&send_msg, HCLGE_MBX_RESET, 0);
 		ret = hclgevf_send_mbx_msg(hdev, &send_msg, true, NULL, 0);
 		if (ret) {
@@ -1806,10 +1806,10 @@ static int hclgevf_reset_prepare_wait(struct hclgevf_dev *hdev)
 	/* inform hardware that preparatory work is done */
 	msleep(HCLGEVF_RESET_SYNC_TIME);
 	hclgevf_reset_handshake(hdev, true);
-	dev_info(&hdev->pdev->dev, "prepare reset(%d) wait done, ret:%d\n",
-		 hdev->reset_type, ret);
+	dev_info(&hdev->pdev->dev, "prepare reset(%d) wait done\n",
+		 hdev->reset_type);
 
-	return ret;
+	return 0;
 }
 
 static void hclgevf_dump_rst_info(struct hclgevf_dev *hdev)
-- 
2.7.4

