Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B2830ED86
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 08:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbhBDHjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 02:39:48 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12418 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234633AbhBDHjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 02:39:45 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DWVlB2YFyzjHJC;
        Thu,  4 Feb 2021 15:37:58 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Thu, 4 Feb 2021 15:38:53 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: sched: Return the correct errno code
Date:   Thu, 4 Feb 2021 15:39:50 +0800
Message-ID: <20210204073950.18372-1-zhengyongjun3@huawei.com>
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
 net/sched/em_nbyte.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/em_nbyte.c b/net/sched/em_nbyte.c
index 2c1192a2ee5e..a83b237cbeb0 100644
--- a/net/sched/em_nbyte.c
+++ b/net/sched/em_nbyte.c
@@ -31,7 +31,7 @@ static int em_nbyte_change(struct net *net, void *data, int data_len,
 	em->datalen = sizeof(*nbyte) + nbyte->len;
 	em->data = (unsigned long)kmemdup(data, em->datalen, GFP_KERNEL);
 	if (em->data == 0UL)
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	return 0;
 }
-- 
2.22.0

