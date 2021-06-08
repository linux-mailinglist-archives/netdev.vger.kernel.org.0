Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC2439EFE3
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 09:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhFHHt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 03:49:27 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:5284 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFHHt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 03:49:26 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FzhzQ1k8Fz1BK3r;
        Tue,  8 Jun 2021 15:42:42 +0800 (CST)
Received: from huawei.com (10.175.113.133) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 8 Jun
 2021 15:47:32 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <aelior@marvell.com>,
        <GR-everest-linux-l2@marvell.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: qede: Use list_for_each_entry() to simplify code
Date:   Tue, 8 Jun 2021 07:57:37 +0000
Message-ID: <20210608075737.52085-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert list_for_each() to list_for_each_entry() where
applicable. This simplifies the code.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/qlogic/qede/qede_rdma.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_rdma.c b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
index 2f6598086d9b..6304514a6f2c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_rdma.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
@@ -247,12 +247,10 @@ static struct qede_rdma_event_work *
 qede_rdma_get_free_event_node(struct qede_dev *edev)
 {
 	struct qede_rdma_event_work *event_node = NULL;
-	struct list_head *list_node = NULL;
 	bool found = false;
 
-	list_for_each(list_node, &edev->rdma_info.rdma_event_list) {
-		event_node = list_entry(list_node, struct qede_rdma_event_work,
-					list);
+	list_for_each_entry(event_node, &edev->rdma_info.rdma_event_list,
+			    list) {
 		if (!work_pending(&event_node->work)) {
 			found = true;
 			break;
-- 
2.17.1

