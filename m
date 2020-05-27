Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765BB1E3440
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgE0BA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:00:56 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5342 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727813AbgE0BAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:00:44 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C7A2858C2580136F5CA8;
        Wed, 27 May 2020 09:00:41 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Wed, 27 May 2020 09:00:34 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 4/4] net: hns3: add a print for initializing CMDQ when reset pending
Date:   Wed, 27 May 2020 08:59:17 +0800
Message-ID: <1590541157-6803-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590541157-6803-1-git-send-email-tanhuazhong@huawei.com>
References: <1590541157-6803-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When initializing CMDQ fails because of reset pending,
there is no hint for debugging, so adds a log for it.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 7f509ef..64a1d0bd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -426,6 +426,9 @@ int hclge_cmd_init(struct hclge_dev *hdev)
 	 * reset may happen when lower level reset is being processed.
 	 */
 	if ((hclge_is_reset_pending(hdev))) {
+		dev_err(&hdev->pdev->dev,
+			"failed to init cmd since reset %#lx pending\n",
+			hdev->reset_pending);
 		ret = -EBUSY;
 		goto err_cmd_init;
 	}
-- 
2.7.4

