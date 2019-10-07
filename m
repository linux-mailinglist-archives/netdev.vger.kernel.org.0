Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1203CE3DB
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 15:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbfJGNiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 09:38:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52776 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727715AbfJGNiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 09:38:05 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 908F4140C3686
        for <netdev@vger.kernel.org>; Mon,  7 Oct 2019 06:38:05 -0700 (PDT)
Date:   Mon, 07 Oct 2019 15:38:04 +0200 (CEST)
Message-Id: <20191007.153804.598102160154212516.davem@davemloft.net>
To:     netdev@vger.kernel.org
Subject: [PATCH] ipv6: Make ipv6_mc_may_pull() return bool.
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Oct 2019 06:38:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Consistent with how pskb_may_pull() also now does so.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/net/addrconf.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 3f62b347b04a..1bab88184d3c 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -202,11 +202,11 @@ u32 ipv6_addr_label(struct net *net, const struct in6_addr *addr,
 /*
  *	multicast prototypes (mcast.c)
  */
-static inline int ipv6_mc_may_pull(struct sk_buff *skb,
-				   unsigned int len)
+static inline bool ipv6_mc_may_pull(struct sk_buff *skb,
+				    unsigned int len)
 {
 	if (skb_transport_offset(skb) + ipv6_transport_len(skb) < len)
-		return 0;
+		return false;
 
 	return pskb_may_pull(skb, len);
 }
-- 
2.21.0

