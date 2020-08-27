Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B89254937
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgH0PWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:22:11 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10330 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728620AbgH0Lat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 07:30:49 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EFA9321DABEC54E4AC31;
        Thu, 27 Aug 2020 19:30:40 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Thu, 27 Aug 2020
 19:30:32 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pshelar@ovn.org>,
        <fw@strlen.de>, <martin.varghese@nokia.com>, <edumazet@google.com>,
        <dcaratti@redhat.com>, <steffen.klassert@secunet.com>,
        <pabeni@redhat.com>, <shmulik@metanetworks.com>,
        <kyk.segfault@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Set trailer iff skb1 is the last one
Date:   Thu, 27 Aug 2020 07:29:22 -0400
Message-ID: <20200827112922.48889-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set trailer iff skb1 is the skbuff where the tailbits space begins.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/core/skbuff.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0b24aed04060..18ed56316e56 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4488,8 +4488,9 @@ int skb_cow_data(struct sk_buff *skb, int tailbits, struct sk_buff **trailer)
 			skb1 = skb2;
 		}
 		elt++;
-		*trailer = skb1;
 		skb_p = &skb1->next;
+		if (!*skb_p)
+			*trailer = skb1;
 	}
 
 	return elt;
-- 
2.19.1

