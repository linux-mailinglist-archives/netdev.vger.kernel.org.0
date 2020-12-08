Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E762D2A61
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgLHMKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:10:21 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8964 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729286AbgLHMKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 07:10:21 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CqzVr47hDzhngr;
        Tue,  8 Dec 2020 20:09:08 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Dec 2020 20:09:21 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: ipv6: rpl_iptunnel: simplify the return expression of rpl_do_srh()
Date:   Tue, 8 Dec 2020 20:09:49 +0800
Message-ID: <20201208120949.9243-1-zhengyongjun3@huawei.com>
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
 net/ipv6/rpl_iptunnel.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/ipv6/rpl_iptunnel.c b/net/ipv6/rpl_iptunnel.c
index 5fdf3ebb953f..f16cf45a2421 100644
--- a/net/ipv6/rpl_iptunnel.c
+++ b/net/ipv6/rpl_iptunnel.c
@@ -190,18 +190,13 @@ static int rpl_do_srh(struct sk_buff *skb, const struct rpl_lwt *rlwt)
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct rpl_iptunnel_encap *tinfo;
-	int err = 0;
 
 	if (skb->protocol != htons(ETH_P_IPV6))
 		return -EINVAL;
 
 	tinfo = rpl_encap_lwtunnel(dst->lwtstate);
 
-	err = rpl_do_srh_inline(skb, rlwt, tinfo->srh);
-	if (err)
-		return err;
-
-	return 0;
+	return rpl_do_srh_inline(skb, rlwt, tinfo->srh);
 }
 
 static int rpl_output(struct net *net, struct sock *sk, struct sk_buff *skb)
-- 
2.22.0

