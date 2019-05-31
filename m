Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5441030AFC
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 11:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfEaJDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 05:03:03 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:15870 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfEaJDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 05:03:03 -0400
Received: from 10-19-61-167.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 1706941B73;
        Fri, 31 May 2019 17:02:59 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] netfilter: ipv6: fix compile err unknown field br_defrag and br_fragment
Date:   Fri, 31 May 2019 17:02:55 +0800
Message-Id: <1559293375-14385-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kIGBQJHllBWUlVSUNJQkJCQkJJSExLTUpZV1koWUFJQjdXWS1ZQUlXWQ
        kOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PBg6Qio*Mjg#DCIJNjdODQ4P
        H00aCitVSlVKTk5CSUJISExCSUhMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpMSEo3Bg++
X-HM-Tid: 0a6b0d20c2612086kuqy1706941b73
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

When CONFIG_IPV6 is not build with modules and CONIFG_NF_CONNTRACK_BRIDGE=m
There will compile err:
net/ipv6/netfilter.c:242:2: error: unknown field 'br_defrag' specified in initializer
  .br_defrag  = nf_ct_frag6_gather,
net/ipv6/netfilter.c:243:2: error: unknown field 'br_fragment' specified in initializer
  .br_fragment  = br_ip6_fragment,

Fixes: 764dd163ac92 ("netfilter: nf_conntrack_bridge: add support for IPv6")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/ipv6/netfilter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index c666538..9530cc2 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -238,7 +238,7 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	.route_input		= ip6_route_input,
 	.fragment		= ip6_fragment,
 	.reroute		= nf_ip6_reroute,
-#if IS_MODULE(CONFIG_NF_CONNTRACK_BRIDGE)
+#if IS_MODULE(CONFIG_IPV6)
 	.br_defrag		= nf_ct_frag6_gather,
 	.br_fragment		= br_ip6_fragment,
 #endif
-- 
1.8.3.1

