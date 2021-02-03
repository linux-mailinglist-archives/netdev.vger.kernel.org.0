Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B017E30DBDE
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 14:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhBCNw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 08:52:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232486AbhBCNwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 08:52:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00F3264E49;
        Wed,  3 Feb 2021 13:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612360293;
        bh=97ineLGbwE5eLATsvelyKxWfNBel0Ygaolc5YZ+tYYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2lIRhP9DqAg8Pzw7L8vyceIOak60lShChASCoH7MQ+TgwSSqiwegVtbARQWS9syh
         gZIqeuhJdUoK+i1zMlUvz2QPh3giWbUTz/8/5qMxiO5OrdMKndCzh90mGD0hooGLFm
         yZTR5GB/SKSQf+k7cCNdLLrcT9uIsvBWiqCM110hYtCl4cMhPKbHzOKG7ejA+oJYoK
         TcRQVAZJK4FYjeO5lx89U+Ec1qapC+FfDUlkfobN+lNgm5Ua57AgykftX9k4xdWSPu
         i1VDlR2Ybl6kKlG8WQ1huE1ZLrmKhHHAFnpI26SSm+Cn8zSruXqHD1X89SfK9d0uqh
         VzHeuj1ecxYOg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, coreteam@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Julian Anastasov <ja@ssi.bg>, lvs-devel@vger.kernel.org,
        Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Simon Horman <horms@verge.net.au>
Subject: [PATCH net-next v2 3/4] net/core: move gro function declarations to separate header
Date:   Wed,  3 Feb 2021 15:51:11 +0200
Message-Id: <20210203135112.4083711-4-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203135112.4083711-1-leon@kernel.org>
References: <20210203135112.4083711-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Fir the following compilation warnings:
 1031 | INDIRECT_CALLABLE_SCOPE void udp_v6_early_demux(struct sk_buff *skb)

net/ipv6/ip6_offload.c:182:41: warning: no previous prototype for ‘ipv6_gro_receive’ [-Wmissing-prototypes]
  182 | INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
      |                                         ^~~~~~~~~~~~~~~~
net/ipv6/ip6_offload.c:320:29: warning: no previous prototype for ‘ipv6_gro_complete’ [-Wmissing-prototypes]
  320 | INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
      |                             ^~~~~~~~~~~~~~~~~
net/ipv6/ip6_offload.c:182:41: warning: no previous prototype for ‘ipv6_gro_receive’ [-Wmissing-prototypes]
  182 | INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
      |                                         ^~~~~~~~~~~~~~~~
net/ipv6/ip6_offload.c:320:29: warning: no previous prototype for ‘ipv6_gro_complete’ [-Wmissing-prototypes]
  320 | INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/gro.h      | 12 ++++++++++++
 net/core/dev.c         |  7 +------
 net/ipv6/ip6_offload.c |  1 +
 3 files changed, 14 insertions(+), 6 deletions(-)
 create mode 100644 include/net/gro.h

diff --git a/include/net/gro.h b/include/net/gro.h
new file mode 100644
index 000000000000..8a6eb5303cc4
--- /dev/null
+++ b/include/net/gro.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _NET_IPV6_GRO_H
+#define _NET_IPV6_GRO_H
+
+INDIRECT_CALLABLE_DECLARE(struct sk_buff *ipv6_gro_receive(struct list_head *,
+							   struct sk_buff *));
+INDIRECT_CALLABLE_DECLARE(int ipv6_gro_complete(struct sk_buff *, int));
+INDIRECT_CALLABLE_DECLARE(struct sk_buff *inet_gro_receive(struct list_head *,
+							   struct sk_buff *));
+INDIRECT_CALLABLE_DECLARE(int inet_gro_complete(struct sk_buff *, int));
+#endif /* _NET_IPV6_GRO_H */
diff --git a/net/core/dev.c b/net/core/dev.c
index c360bb5367e2..6521aada4259 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -101,6 +101,7 @@
 #include <net/dsa.h>
 #include <net/dst.h>
 #include <net/dst_metadata.h>
+#include <net/gro.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 #include <net/checksum.h>
@@ -5742,8 +5743,6 @@ static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb)
 		gro_normal_list(napi);
 }

-INDIRECT_CALLABLE_DECLARE(int inet_gro_complete(struct sk_buff *, int));
-INDIRECT_CALLABLE_DECLARE(int ipv6_gro_complete(struct sk_buff *, int));
 static int napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
 {
 	struct packet_offload *ptype;
@@ -5912,10 +5911,6 @@ static void gro_flush_oldest(struct napi_struct *napi, struct list_head *head)
 	napi_gro_complete(napi, oldest);
 }

-INDIRECT_CALLABLE_DECLARE(struct sk_buff *inet_gro_receive(struct list_head *,
-							   struct sk_buff *));
-INDIRECT_CALLABLE_DECLARE(struct sk_buff *ipv6_gro_receive(struct list_head *,
-							   struct sk_buff *));
 static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
 {
 	u32 hash = skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index a80f90bf3ae7..1b9827ff8ccf 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -15,6 +15,7 @@
 #include <net/inet_common.h>
 #include <net/tcp.h>
 #include <net/udp.h>
+#include <net/gro.h>

 #include "ip6_offload.h"

--
2.29.2

