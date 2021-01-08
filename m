Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3F12EF2F3
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 14:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbhAHNWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 08:22:10 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:10423 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbhAHNWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 08:22:09 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DC3d50QXrzj41q;
        Fri,  8 Jan 2021 21:20:41 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0; Fri, 8 Jan 2021
 21:21:17 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <jerry.lilijun@huawei.com>, <xudingke@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] devlink: fix return of uninitialized variable err
Date:   Fri, 8 Jan 2021 21:21:13 +0800
Message-ID: <1610112073-23424-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.243.127]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

There is a potential execution path in which variable err is
returned without being properly initialized previously. Fix
this by initializing variable err to 0.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 1db64e8733f6 ("devlink: Add devlink formatted message (fmsg) API")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 net/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index ee828e4b1007..470215cd60b5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5699,7 +5699,7 @@ devlink_fmsg_prepare_skb(struct devlink_fmsg *fmsg, struct sk_buff *skb,
 	struct devlink_fmsg_item *item;
 	struct nlattr *fmsg_nlattr;
 	int i = 0;
-	int err;
+	int err = 0;
 
 	fmsg_nlattr = nla_nest_start_noflag(skb, DEVLINK_ATTR_FMSG);
 	if (!fmsg_nlattr)
-- 
2.23.0

