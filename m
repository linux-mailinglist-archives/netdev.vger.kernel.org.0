Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BF01E62E8
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390785AbgE1NxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:53:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5383 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390609AbgE1NvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 09:51:04 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5B041FE075497678788E;
        Thu, 28 May 2020 21:50:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Thu, 28 May 2020 21:50:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 01/12] net: hns3: remove an unnecessary 'goto' in hclge_init_ae_dev()
Date:   Thu, 28 May 2020 21:48:08 +0800
Message-ID: <1590673699-63819-2-git-send-email-tanhuazhong@huawei.com>
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

Remove the redundant 'goto' and return -ENOMEM directly, when
allocating memory for 'hdev' fails in hclge_init_ae_dev().

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7c9f2ba..0e36f03 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9928,10 +9928,8 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	int ret;
 
 	hdev = devm_kzalloc(&pdev->dev, sizeof(*hdev), GFP_KERNEL);
-	if (!hdev) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!hdev)
+		return -ENOMEM;
 
 	hdev->pdev = pdev;
 	hdev->ae_dev = ae_dev;
-- 
2.7.4

