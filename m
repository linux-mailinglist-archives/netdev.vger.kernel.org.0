Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED661D301E
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 14:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgENMnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 08:43:24 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59344 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726141AbgENMnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 08:43:00 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 15A02E744D14484AA51E;
        Thu, 14 May 2020 20:42:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 14 May 2020 20:42:49 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/5] net: hns3: remove a duplicated printing in hclge_configure()
Date:   Thu, 14 May 2020 20:41:23 +0800
Message-ID: <1589460086-61130-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589460086-61130-1-git-send-email-tanhuazhong@huawei.com>
References: <1589460086-61130-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since hclge_get_cfg() already has error print, so hclge_configure()
should not print error when calling hclge_get_cfg() fail.

Reported-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 1ff896a..b796d3f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1363,10 +1363,8 @@ static int hclge_configure(struct hclge_dev *hdev)
 	int ret;
 
 	ret = hclge_get_cfg(hdev, &cfg);
-	if (ret) {
-		dev_err(&hdev->pdev->dev, "get mac mode error %d.\n", ret);
+	if (ret)
 		return ret;
-	}
 
 	hdev->num_vmdq_vport = cfg.vmdq_vport_num;
 	hdev->base_tqp_pid = 0;
-- 
2.7.4

