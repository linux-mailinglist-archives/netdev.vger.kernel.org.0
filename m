Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE4530EAD4
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 04:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbhBDDTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 22:19:23 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12072 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbhBDDTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 22:19:21 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DWNy13c4dzMTcg;
        Thu,  4 Feb 2021 11:16:57 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Thu, 4 Feb 2021 11:18:28 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: core: Return the correct errno code
Date:   Thu, 4 Feb 2021 11:19:23 +0800
Message-ID: <20210204031923.15264-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 7d7223691783..6df8fb25668b 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -177,7 +177,7 @@ static int rtnl_register_internal(struct module *owner,
 	struct rtnl_link *link, *old;
 	struct rtnl_link __rcu **tab;
 	int msgindex;
-	int ret = -ENOBUFS;
+	int ret = -ENOMEM;
 
 	BUG_ON(protocol < 0 || protocol > RTNL_FAMILY_MAX);
 	msgindex = rtm_msgindex(msgtype);
-- 
2.22.0

