Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC353288404
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 09:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732381AbgJIHzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 03:55:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15198 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732239AbgJIHzT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 03:55:19 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3F743A54B8DDE1C5C05E;
        Fri,  9 Oct 2020 15:55:16 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Fri, 9 Oct 2020
 15:55:05 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <ericvh@gmail.com>, <lucho@ionkov.net>, <asmadeus@codewreck.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <v9fs-developer@lists.sourceforge.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH] 9p/xen: Fix format argument warning
Date:   Fri, 9 Oct 2020 16:05:52 +0800
Message-ID: <20201009080552.89918-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.16.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix follow warnings:
[net/9p/trans_xen.c:454]: (warning) %u in format string (no. 1) requires
'unsigned int' but the argument type is 'int'.
[net/9p/trans_xen.c:460]: (warning) %u in format string (no. 1) requires
'unsigned int' but the argument type is 'int'.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 net/9p/trans_xen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index bc8807d9281f..f4fea28e05da 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -451,13 +451,13 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
 		char str[16];
 
 		BUILD_BUG_ON(XEN_9PFS_NUM_RINGS > 9);
-		sprintf(str, "ring-ref%u", i);
+		sprintf(str, "ring-ref%d", i);
 		ret = xenbus_printf(xbt, dev->nodename, str, "%d",
 				    priv->rings[i].ref);
 		if (ret)
 			goto error_xenbus;
 
-		sprintf(str, "event-channel-%u", i);
+		sprintf(str, "event-channel-%d", i);
 		ret = xenbus_printf(xbt, dev->nodename, str, "%u",
 				    priv->rings[i].evtchn);
 		if (ret)
-- 
2.16.2.dirty

