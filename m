Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E47414388A
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 09:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgAUImj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 03:42:39 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10115 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727847AbgAUIme (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 03:42:34 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CEF07EE49FC211532070;
        Tue, 21 Jan 2020 16:42:29 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Tue, 21 Jan 2020 16:42:21 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/9] net: hns3: set VF's default reset_type to HNAE3_NONE_RESET
Date:   Tue, 21 Jan 2020 16:42:07 +0800
Message-ID: <1579596133-54842-4-git-send-email-tanhuazhong@huawei.com>
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

reset_type means what kind of reset the driver is handling now,
so after initializing or reset, the reset_type of VF should be
set to HNAE3_NONE_RESET, otherwise, this unknown default value
may be a little misleading when the device is running.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index b26b8ad..2a472b0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1862,6 +1862,7 @@ static void hclgevf_reset_service_task(struct hclgevf_dev *hdev)
 		hclgevf_reset_task_schedule(hdev);
 	}
 
+	hdev->reset_type = HNAE3_NONE_RESET;
 	clear_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
 	up(&hdev->reset_sem);
 }
@@ -2742,6 +2743,7 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 
 	hclgevf_state_init(hdev);
 	hdev->reset_level = HNAE3_VF_FUNC_RESET;
+	hdev->reset_type = HNAE3_NONE_RESET;
 
 	ret = hclgevf_misc_irq_init(hdev);
 	if (ret) {
-- 
2.7.4

