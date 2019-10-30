Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41AD1E9527
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 03:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbfJ3C7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 22:59:33 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5223 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726714AbfJ3C7d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 22:59:33 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CA582C4A544F66292673;
        Wed, 30 Oct 2019 10:59:30 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Wed, 30 Oct 2019 10:59:24 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-wimax@intel.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zhongjiang@huawei.com>
Subject: [PATCH] wimax: use DEFINE_DEBUGFS_ATTRIBUTE to define debugfs fops
Date:   Wed, 30 Oct 2019 10:55:34 +0800
Message-ID: <1572404134-45159-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is more clear to use DEFINE_DEBUGFS_ATTRIBUTE to define debugfs file
operation rather than DEFINE_SIMPLE_ATTRIBUTE.

It is detected with the help of coccinelle.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/wimax/i2400m/debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wimax/i2400m/debugfs.c b/drivers/net/wimax/i2400m/debugfs.c
index 73f5892..1c640b4 100644
--- a/drivers/net/wimax/i2400m/debugfs.c
+++ b/drivers/net/wimax/i2400m/debugfs.c
@@ -26,7 +26,7 @@ int debugfs_netdev_queue_stopped_get(void *data, u64 *val)
 	*val = netif_queue_stopped(i2400m->wimax_dev.net_dev);
 	return 0;
 }
-DEFINE_SIMPLE_ATTRIBUTE(fops_netdev_queue_stopped,
+DEFINE_DEBUGFS_ATTRIBUTE(fops_netdev_queue_stopped,
 			debugfs_netdev_queue_stopped_get,
 			NULL, "%llu\n");
 
@@ -154,7 +154,7 @@ int debugfs_i2400m_suspend_set(void *data, u64 val)
 		result = 0;
 	return result;
 }
-DEFINE_SIMPLE_ATTRIBUTE(fops_i2400m_suspend,
+DEFINE_DEBUGFS_ATTRIBUTE(fops_i2400m_suspend,
 			NULL, debugfs_i2400m_suspend_set,
 			"%llu\n");
 
@@ -183,7 +183,7 @@ int debugfs_i2400m_reset_set(void *data, u64 val)
 	}
 	return result;
 }
-DEFINE_SIMPLE_ATTRIBUTE(fops_i2400m_reset,
+DEFINE_DEBUGFS_ATTRIBUTE(fops_i2400m_reset,
 			NULL, debugfs_i2400m_reset_set,
 			"%llu\n");
 
-- 
1.7.12.4

