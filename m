Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE6A1E6158
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390034AbgE1Msv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:48:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5370 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389971AbgE1MsZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 08:48:25 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 47A3B2A2028A432ABA86;
        Thu, 28 May 2020 20:46:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 28 May 2020 20:46:39 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 11/11] net: hns3: print out speed info when parsing speed fails
Date:   Thu, 28 May 2020 20:45:12 +0800
Message-ID: <1590669912-21867-12-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590669912-21867-1-git-send-email-tanhuazhong@huawei.com>
References: <1590669912-21867-1-git-send-email-tanhuazhong@huawei.com>
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
index 87473f7..21a73b0 100644
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

