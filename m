Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E998F362E3D
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 09:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbhDQHKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 03:10:07 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:17353 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhDQHKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 03:10:00 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FMkfC1BtRzCqk0;
        Sat, 17 Apr 2021 15:06:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Sat, 17 Apr 2021 15:09:09 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/3] net: hns3: remove a duplicate pf reset counting
Date:   Sat, 17 Apr 2021 15:09:22 +0800
Message-ID: <1618643364-64872-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618643364-64872-1-git-send-email-tanhuazhong@huawei.com>
References: <1618643364-64872-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When enter suspend mode the counter of pf reset will be increased
twice, since both hclge_prepare_general() and hclge_prepare_wait()
increase this counter. So remove the duplicate counting in
hclge_prepare_general().

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index dc06986..c296ab6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11126,8 +11126,6 @@ static void hclge_reset_prepare_general(struct hnae3_ae_dev *ae_dev,
 
 	if (hdev->reset_type == HNAE3_FLR_RESET)
 		hdev->rst_stats.flr_rst_cnt++;
-	else if (hdev->reset_type == HNAE3_FUNC_RESET)
-		hdev->rst_stats.pf_rst_cnt++;
 }
 
 static void hclge_reset_done(struct hnae3_ae_dev *ae_dev)
-- 
2.7.4

