Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6091730D745
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 11:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbhBCKRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 05:17:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233508AbhBCKRM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 05:17:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD12664F59;
        Wed,  3 Feb 2021 10:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612347390;
        bh=gbQKWpoigw5T4LA71N8+zEj+Pfe+Ze66zWTEQ1M1lwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5v3d2Vz+8KCRIjP1Qg9DrkhtQftasu7wZ4T7ckQ1ktFvMrwGzz1vfWCjctoOgVdp
         7r+UNKYrj7pazF4p7/Sn5tpJ6JlIPlLLVIUVLJ9shTixXA1HScsChjuaySqjn8D4w2
         AhOQ8DADthjCsvOe/+w/rG2CFpdLjR+a6iTnTqjF8mXzf4pnDCU+VTdWAMORdtYdPH
         /UVKuEQH0fNSlReAfSfeyeCc6fQteFE/r6jKsqFY83e9OmVTa92b8XYBS8juUapsAg
         cdkAqfQdneqJKV7npH6hhdnrmK0KHPdu6k2cmTcba8LbQ97rbXfp5lKnK94WPc/oeI
         260BXZ74tqEJg==
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
Subject: [PATCH net-next v1 3/4] net/core: move gro function declarations to separate header
Date:   Wed,  3 Feb 2021 12:16:11 +0200
Message-Id: <20210203101612.4004322-4-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203101612.4004322-1-leon@kernel.org>
References: <20210203101612.4004322-1-leon@kernel.org>
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
 include/net/gro.h | 12 ++++++++++++
 net/core/dev.c    |  7 +------
 2 files changed, 13 insertions(+), 6 deletions(-)
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
--
2.29.2

