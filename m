Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCE427DD95
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 03:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgI3BHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 21:07:54 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59830 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729159AbgI3BHx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 21:07:53 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 50DDC2EE432A2832D1CB;
        Wed, 30 Sep 2020 09:07:51 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Wed, 30 Sep 2020
 09:07:41 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH 2/2] net-sysfs: Fix inconsistent of format with argument type in  net-sysfs.c
Date:   Wed, 30 Sep 2020 09:08:38 +0800
Message-ID: <20200930010838.1266872-3-yebin10@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200930010838.1266872-1-yebin10@huawei.com>
References: <20200930010838.1266872-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix follow warnings:
[net/core/net-sysfs.c:1161]: (warning) %u in format string (no. 1)
	requires 'unsigned int' but the argument type is 'int'.
[net/core/net-sysfs.c:1162]: (warning) %u in format string (no. 1)
	requires 'unsigned int' but the argument type is 'int'.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 net/core/net-sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 8d4128d59655..999b70c59761 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1158,8 +1158,8 @@ static ssize_t traffic_class_show(struct netdev_queue *queue,
 	 * belongs to the root device it will be reported with just the
 	 * traffic class, so just "0" for TC 0 for example.
 	 */
-	return dev->num_tc < 0 ? sprintf(buf, "%u%d\n", tc, dev->num_tc) :
-				 sprintf(buf, "%u\n", tc);
+	return dev->num_tc < 0 ? sprintf(buf, "%d%d\n", tc, dev->num_tc) :
+				 sprintf(buf, "%d\n", tc);
 }
 
 #ifdef CONFIG_XPS
-- 
2.25.4

