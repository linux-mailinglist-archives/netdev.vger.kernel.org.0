Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C49254680
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 16:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgH0OKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 10:10:32 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10339 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727781AbgH0OKO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 10:10:14 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A14B365A25F8A4801769;
        Thu, 27 Aug 2020 22:09:55 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Thu, 27 Aug 2020
 22:09:48 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <kuba@kernel.org>, <mcroce@redhat.com>
CC:     <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] netfilter: xt_HMARK: Use ip_is_fragment() helper
Date:   Thu, 27 Aug 2020 22:08:13 +0800
Message-ID: <20200827140813.28624-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use ip_is_fragment() to simpify code.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/netfilter/xt_HMARK.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_HMARK.c b/net/netfilter/xt_HMARK.c
index 713fb38541df..8928ec56c388 100644
--- a/net/netfilter/xt_HMARK.c
+++ b/net/netfilter/xt_HMARK.c
@@ -276,7 +276,7 @@ hmark_pkt_set_htuple_ipv4(const struct sk_buff *skb, struct hmark_tuple *t,
 		return 0;
 
 	/* follow-up fragments don't contain ports, skip all fragments */
-	if (ip->frag_off & htons(IP_MF | IP_OFFSET))
+	if (ip_is_fragment(ip))
 		return 0;
 
 	hmark_set_tuple_ports(skb, (ip->ihl * 4) + nhoff, t, info);
-- 
2.17.1


