Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65331227943
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 09:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgGUHJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 03:09:47 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8341 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726039AbgGUHJq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 03:09:46 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 520625E64979C2EEB907;
        Tue, 21 Jul 2020 15:09:42 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 21 Jul 2020 15:09:34 +0800
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangxiongfeng2@huawei.com>
Subject: [PATCH v2] net-sysfs: add a newline when printing 'tx_timeout' by sysfs
Date:   Tue, 21 Jul 2020 15:02:57 +0800
Message-ID: <1595314977-57991-1-git-send-email-wangxiongfeng2@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When I cat 'tx_timeout' by sysfs, it displays as follows. It's better to
add a newline for easy reading.

root@syzkaller:~# cat /sys/devices/virtual/net/lo/queues/tx-0/tx_timeout
0root@syzkaller:~#

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 net/core/net-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index e353b82..7bd6440 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1108,7 +1108,7 @@ static ssize_t tx_timeout_show(struct netdev_queue *queue, char *buf)
 	trans_timeout = queue->trans_timeout;
 	spin_unlock_irq(&queue->_xmit_lock);
 
-	return sprintf(buf, "%lu", trans_timeout);
+	return sprintf(buf, fmt_ulong, trans_timeout);
 }
 
 static unsigned int get_netdev_queue_index(struct netdev_queue *queue)
-- 
1.7.12.4

