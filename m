Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE364600AF6
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 11:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiJQJgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 05:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbiJQJgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 05:36:01 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFC81C401;
        Mon, 17 Oct 2022 02:35:58 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VSLqolQ_1665999342;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VSLqolQ_1665999342)
          by smtp.aliyun-inc.com;
          Mon, 17 Oct 2022 17:35:49 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] net: ip6_gre: Remove the unused function ip6gre_tnl_addr_conflict()
Date:   Mon, 17 Oct 2022 17:35:40 +0800
Message-Id: <20221017093540.26806-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function ip6gre_tnl_addr_conflict() is defined in the ip6_gre.c file,
but not called elsewhere, so delete this unused function.

net/ipv6/ip6_gre.c:887:20: warning: unused function 'ip6gre_tnl_addr_conflict'.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2419
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/ipv6/ip6_gre.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 48b4ff0294f6..02b1b54165e8 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -870,26 +870,6 @@ static inline int ip6gre_xmit_ipv6(struct sk_buff *skb, struct net_device *dev)
 	return 0;
 }
 
-/**
- * ip6gre_tnl_addr_conflict - compare packet addresses to tunnel's own
- *   @t: the outgoing tunnel device
- *   @hdr: IPv6 header from the incoming packet
- *
- * Description:
- *   Avoid trivial tunneling loop by checking that tunnel exit-point
- *   doesn't match source of incoming packet.
- *
- * Return:
- *   1 if conflict,
- *   0 else
- **/
-
-static inline bool ip6gre_tnl_addr_conflict(const struct ip6_tnl *t,
-	const struct ipv6hdr *hdr)
-{
-	return ipv6_addr_equal(&t->parms.raddr, &hdr->saddr);
-}
-
 static int ip6gre_xmit_other(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ip6_tnl *t = netdev_priv(dev);
-- 
2.20.1.7.g153144c

