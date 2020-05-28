Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F051E62E3
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390762AbgE1Nwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:52:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5379 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390612AbgE1NvF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 09:51:05 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4D979DEE3C8A0E03DD1D;
        Thu, 28 May 2020 21:50:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Thu, 28 May 2020 21:50:52 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 12/12] net: hns3: print out speed info when parsing speed fails
Date:   Thu, 28 May 2020 21:48:19 +0800
Message-ID: <1590673699-63819-13-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590673699-63819-1-git-send-email-tanhuazhong@huawei.com>
References: <1590673699-63819-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling hclge_parse_speed() fails, printing out the speed is
helpful for debugging.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 1e4f285..96bfad5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1387,7 +1387,8 @@ static int hclge_configure(struct hclge_dev *hdev)
 
 	ret = hclge_parse_speed(cfg.default_speed, &hdev->hw.mac.speed);
 	if (ret) {
-		dev_err(&hdev->pdev->dev, "Get wrong speed ret=%d.\n", ret);
+		dev_err(&hdev->pdev->dev, "failed to parse speed %u, ret = %d\n",
+			cfg.default_speed, ret);
 		return ret;
 	}
 
-- 
2.7.4

