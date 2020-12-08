Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945CC2D2A69
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729408AbgLHMLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:11:11 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8965 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgLHMLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 07:11:11 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CqzWw2BxmzhnnR;
        Tue,  8 Dec 2020 20:10:04 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Dec 2020 20:10:19 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <jiri@nvidia.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: core: devlink: simplify the return expression of devlink_nl_cmd_trap_set_doit()
Date:   Tue, 8 Dec 2020 20:10:46 +0800
Message-ID: <20201208121046.9297-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/core/devlink.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 8c5ddffd707d..3f0a65ee0474 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6981,7 +6981,6 @@ static int devlink_nl_cmd_trap_set_doit(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_trap_item *trap_item;
-	int err;
 
 	if (list_empty(&devlink->trap_list))
 		return -EOPNOTSUPP;
@@ -6992,11 +6991,7 @@ static int devlink_nl_cmd_trap_set_doit(struct sk_buff *skb,
 		return -ENOENT;
 	}
 
-	err = devlink_trap_action_set(devlink, trap_item, info);
-	if (err)
-		return err;
-
-	return 0;
+	return devlink_trap_action_set(devlink, trap_item, info);
 }
 
 static struct devlink_trap_group_item *
-- 
2.22.0

