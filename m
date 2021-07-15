Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2A23C978E
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 06:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237396AbhGOEje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 00:39:34 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:38858 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230311AbhGOEjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 00:39:33 -0400
X-UUID: d689f176c0114730ba304c56bea3bc6c-20210715
X-UUID: d689f176c0114730ba304c56bea3bc6c-20210715
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1599588048; Thu, 15 Jul 2021 12:36:37 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 15 Jul 2021 12:36:30 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 15 Jul 2021 12:36:29 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        <rocco.yue@gmail.com>, Rocco Yue <rocco.yue@mediatek.com>
Subject: [PATCH v2] net: ipv6: remove unused local variable
Date:   Thu, 15 Jul 2021 12:20:34 +0800
Message-ID: <20210715042034.6525-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The local variable "struct net *net" in the two functions of
inet6_rtm_getaddr() and inet6_dump_addr() are actually useless,
so remove them.

Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
---
 net/ipv6/addrconf.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3bf685fe64b9..e2f625e39455 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5211,8 +5211,7 @@ static int inet6_dump_addr(struct sk_buff *skb, struct netlink_callback *cb,
 		.netnsid = -1,
 		.type = type,
 	};
-	struct net *net = sock_net(skb->sk);
-	struct net *tgt_net = net;
+	struct net *tgt_net = sock_net(skb->sk);
 	int idx, s_idx, s_ip_idx;
 	int h, s_h;
 	struct net_device *dev;
@@ -5351,7 +5350,7 @@ static int inet6_rtm_valid_getaddr_req(struct sk_buff *skb,
 static int inet6_rtm_getaddr(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 			     struct netlink_ext_ack *extack)
 {
-	struct net *net = sock_net(in_skb->sk);
+	struct net *tgt_net = sock_net(in_skb->sk);
 	struct inet6_fill_args fillargs = {
 		.portid = NETLINK_CB(in_skb).portid,
 		.seq = nlh->nlmsg_seq,
@@ -5359,7 +5358,6 @@ static int inet6_rtm_getaddr(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 		.flags = 0,
 		.netnsid = -1,
 	};
-	struct net *tgt_net = net;
 	struct ifaddrmsg *ifm;
 	struct nlattr *tb[IFA_MAX+1];
 	struct in6_addr *addr = NULL, *peer;
-- 
2.18.0

