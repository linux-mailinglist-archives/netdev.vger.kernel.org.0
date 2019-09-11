Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA9DAAF46C
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 04:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfIKCnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 22:43:13 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51352 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726545AbfIKCnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 22:43:12 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 851BFDE31AF07456DF53;
        Wed, 11 Sep 2019 10:43:10 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Wed, 11 Sep 2019 10:42:59 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>
Subject: [PATCH V2 net-next 6/7] net: hns3: check NULL pointer before use
Date:   Wed, 11 Sep 2019 10:40:38 +0800
Message-ID: <1568169639-43658-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568169639-43658-1-git-send-email-tanhuazhong@huawei.com>
References: <1568169639-43658-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

This patch checks ops->set_default_reset_request whether is NULL
before using it in function hns3_slot_reset.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 8dbaf36..616cad0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2006,7 +2006,8 @@ static pci_ers_result_t hns3_slot_reset(struct pci_dev *pdev)
 
 	ops = ae_dev->ops;
 	/* request the reset */
-	if (ops->reset_event && ops->get_reset_level) {
+	if (ops->reset_event && ops->get_reset_level &&
+	    ops->set_default_reset_request) {
 		if (ae_dev->hw_err_reset_req) {
 			reset_type = ops->get_reset_level(ae_dev,
 						&ae_dev->hw_err_reset_req);
-- 
2.7.4

