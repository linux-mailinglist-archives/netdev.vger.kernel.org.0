Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9D376024
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 09:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfGZHxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 03:53:49 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2773 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726473AbfGZHxi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 03:53:38 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D37CE5C456BCE2471C5C;
        Fri, 26 Jul 2019 15:53:34 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Fri, 26 Jul 2019 15:53:25 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <saeedm@mellanox.com>,
        Guangbin Huang <huangguangbin@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 02/10] net: hns3: add a check for get_reset_level
Date:   Fri, 26 Jul 2019 15:51:22 +0800
Message-ID: <1564127490-22173-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564127490-22173-1-git-send-email-tanhuazhong@huawei.com>
References: <1564127490-22173-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin@huawei.com>

For some cases, ops->get_reset_level may not be implemented, so we
should check whether it is NULL before calling get_reset_level.

Signed-off-by: Guangbin Huang <huangguangbin@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 08af782..4d58c53 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1963,7 +1963,7 @@ static pci_ers_result_t hns3_slot_reset(struct pci_dev *pdev)
 
 	ops = ae_dev->ops;
 	/* request the reset */
-	if (ops->reset_event) {
+	if (ops->reset_event && ops->get_reset_level) {
 		if (ae_dev->hw_err_reset_req) {
 			reset_type = ops->get_reset_level(ae_dev,
 						&ae_dev->hw_err_reset_req);
-- 
2.7.4

