Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AC430ED9C
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 08:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbhBDHmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 02:42:52 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12125 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbhBDHms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 02:42:48 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DWVpN3Khwz163Mb;
        Thu,  4 Feb 2021 15:40:44 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Thu, 4 Feb 2021 15:41:56 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] xfrm: Return the correct errno code
Date:   Thu, 4 Feb 2021 15:42:54 +0800
Message-ID: <20210204074254.18572-1-zhengyongjun3@huawei.com>
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
 net/xfrm/xfrm_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index d0c32a8fcc4a..ad63a6c77edd 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2444,7 +2444,7 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 		encap = kmemdup(nla_data(attrs[XFRMA_ENCAP]),
 				sizeof(*encap), GFP_KERNEL);
 		if (!encap)
-			return 0;
+			return -ENOMEM;
 	}
 
 	err = xfrm_migrate(&pi->sel, pi->dir, type, m, n, kmp, net, encap);
-- 
2.22.0

