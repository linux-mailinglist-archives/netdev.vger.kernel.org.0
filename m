Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E429321AFFA
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 09:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgGJHVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 03:21:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7288 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725966AbgGJHVI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 03:21:08 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 2852D40EC75B68E2D374;
        Fri, 10 Jul 2020 15:21:06 +0800 (CST)
Received: from kernelci-master.huawei.com (10.175.101.6) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Fri, 10 Jul 2020 15:20:58 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Hulk Robot <hulkci@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        "Taehee Yoo" <ap420073@gmail.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>
Subject: [PATCH net-next] net: make symbol 'flush_works' static
Date:   Fri, 10 Jul 2020 15:31:04 +0800
Message-ID: <20200710073104.58784-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sparse tool complains as follows:

net/core/dev.c:5594:1: warning:
 symbol '__pcpu_scope_flush_works' was not declared. Should it be static?

'flush_works' is not used outside of dev.c, so marks
it static.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index eab4ebe3c21c..b61075828358 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5591,7 +5591,7 @@ void netif_receive_skb_list(struct list_head *head)
 }
 EXPORT_SYMBOL(netif_receive_skb_list);
 
-DEFINE_PER_CPU(struct work_struct, flush_works);
+static DEFINE_PER_CPU(struct work_struct, flush_works);
 
 /* Network device is going away, flush any packets still pending */
 static void flush_backlog(struct work_struct *work)

