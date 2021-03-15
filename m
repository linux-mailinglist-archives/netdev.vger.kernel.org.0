Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21DF233ABCE
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 07:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhCOGvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 02:51:47 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:13925 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhCOGve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 02:51:34 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DzRqn69DkzlVjG;
        Mon, 15 Mar 2021 14:49:57 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Mon, 15 Mar 2021 14:51:20 +0800
From:   Jay Fang <f.fangjian@huawei.com>
To:     <manishc@marvell.com>, <GR-Linux-NIC-Dev@marvell.com>
CC:     <netdev@vger.kernel.org>, <dan.carpenter@oracle.com>,
        <huangdaode@huawei.com>
Subject: [PATCH] staging: qlge : fix missing error codes
Date:   Mon, 15 Mar 2021 14:51:57 +0800
Message-ID: <1615791117-56711-1-git-send-email-f.fangjian@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zihao Tang <tangzihao1@hisilicon.com>

Fixes one smatch warnings:

drivers/staging/qlge/qlge_main.c:4564 qlge_probe() warn: missing error code 'err'

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Zihao Tang <tangzihao1@hisilicon.com>
Signed-off-by: Jay Fang <f.fangjian@huawei.com>
---
 drivers/staging/qlge/qlge_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 5516be3..44b7724 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4561,8 +4561,10 @@ static int qlge_probe(struct pci_dev *pdev,
 	ndev = alloc_etherdev_mq(sizeof(struct qlge_netdev_priv),
 				 min(MAX_CPUS,
 				     netif_get_num_default_rss_queues()));
-	if (!ndev)
+	if (!ndev) {
+		err = -ENOMEM;
 		goto devlink_free;
+	}
 
 	ndev_priv = netdev_priv(ndev);
 	ndev_priv->qdev = qdev;
-- 
2.7.4

