Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8639206783
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388671AbgFWWsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388122AbgFWWrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:47:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99071C06179B
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 15:31:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s9so145069ybj.18
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 15:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4Jt/exe2aCimikPbk0dVDesSpmGWpO1f0YIFYhmLyKI=;
        b=Zx2QL7B8B41mBHVjZU7VGilPeSvpfNMMIKl5/J6c5xIoyRKhCotOCIfv6a2DnAVokl
         7HsaQuV/+1MW6oLd6zrtZNWnEg68Zgn4dRMinOqljCsK8B2pyvRJrcDPwuumbPg6aDiz
         7SMmdPmOqF6eFtVWCXUvyR2APOHuHk7e5nD9ROvD/HDqIfhTOEK1oCSVJfSkOGlfFIl8
         LlRC25d1+sVjn1ZL0j4Y2nlmEXWRIYPneNz85JS9J3whsQgWgqnd8Z1CV2bKLRVpGQN0
         IxEtGmTgLR1tQz3YKhYXI+ZzGJt1TxP4Vi2bzyRF6OzxzQ34jLaXFt2sf8M7mY00dg7j
         D4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4Jt/exe2aCimikPbk0dVDesSpmGWpO1f0YIFYhmLyKI=;
        b=bmG2NndhdzXsTEBQQlNxg2/yn3OmMx5J4QFXfrQUASIcHuwgxXbpe9+zIaRskc3CYe
         xcrpkFpoYP9cVptXByoX0nvnfnMpH+LKKXY8n25vpoFvxnNC9uwCQVsiXy9Af4n+2QEL
         3/+7S9BY50F540RTU2PwWdwWIN5A6HUAgrRYC53RpwF4zzOEFg01kUC1cE1/IXDN9PbA
         f5IFrC2TSEJM06beShBokMugZJ0VMm2/aw8DSfUsEvXdV8YQcfTh/QyN2614+oByrFU+
         TTZH3lPi6+HBx+6xN4RsY6CYhioa8A30ZBUlkIbPyRQTzdMyoQ822bmZjdtBFA3ksy+F
         p/kA==
X-Gm-Message-State: AOAM5314qLKv/g8ocHX9N25DCsi6JAzelJXBOH4ATD9Gu/vc7tEIrHFu
        fOjK7BgCFluqdIKVIaQ/kst0e8mxpeLBfQ==
X-Google-Smtp-Source: ABdhPJyWgkrgyP2+KqtHioIEYnBJkCBb5YJPxKHutzltYjLL8q9J1k1w4JGCzX8eDksn2zi/ieLNY6YKjH+Y6w==
X-Received: by 2002:a25:df0b:: with SMTP id w11mr41142058ybg.449.1592951490870;
 Tue, 23 Jun 2020 15:31:30 -0700 (PDT)
Date:   Tue, 23 Jun 2020 15:31:15 -0700
In-Reply-To: <20200623223115.152832-1-edumazet@google.com>
Message-Id: <20200623223115.152832-6-edumazet@google.com>
Mime-Version: 1.0
References: <20200623223115.152832-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH net-next 5/5] udp: move gro declarations to net/udp.h
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This removes following warnings :
  CC      net/ipv4/udp_offload.o
net/ipv4/udp_offload.c:504:17: warning: no previous prototype for 'udp4_gro_receive' [-Wmissing-prototypes]
  504 | struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *skb)
      |                 ^~~~~~~~~~~~~~~~
net/ipv4/udp_offload.c:584:29: warning: no previous prototype for 'udp4_gro_complete' [-Wmissing-prototypes]
  584 | INDIRECT_CALLABLE_SCOPE int udp4_gro_complete(struct sk_buff *skb, int nhoff)
      |                             ^~~~~~~~~~~~~~~~~

  CHECK   net/ipv6/udp_offload.c
net/ipv6/udp_offload.c:115:16: warning: symbol 'udp6_gro_receive' was not declared. Should it be static?
net/ipv6/udp_offload.c:148:29: warning: symbol 'udp6_gro_complete' was not declared. Should it be static?
  CC      net/ipv6/udp_offload.o
net/ipv6/udp_offload.c:115:17: warning: no previous prototype for 'udp6_gro_receive' [-Wmissing-prototypes]
  115 | struct sk_buff *udp6_gro_receive(struct list_head *head, struct sk_buff *skb)
      |                 ^~~~~~~~~~~~~~~~
net/ipv6/udp_offload.c:148:29: warning: no previous prototype for 'udp6_gro_complete' [-Wmissing-prototypes]
  148 | INDIRECT_CALLABLE_SCOPE int udp6_gro_complete(struct sk_buff *skb, int nhoff)
      |                             ^~~~~~~~~~~~~~~~~
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/udp.h      | 7 +++++++
 net/ipv4/af_inet.c     | 3 ---
 net/ipv6/ip6_offload.c | 4 +---
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index a8fa6c0c6dede2f56629165f5a85218f061c6ead..5a2d677432f0fcf7b5731860c21e0f50fb19fb8f 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -27,6 +27,7 @@
 #include <linux/ipv6.h>
 #include <linux/seq_file.h>
 #include <linux/poll.h>
+#include <linux/indirect_call_wrapper.h>
 
 /**
  *	struct udp_skb_cb  -  UDP(-Lite) private variables
@@ -166,6 +167,12 @@ static inline void udp_csum_pull_header(struct sk_buff *skb)
 typedef struct sock *(*udp_lookup_t)(struct sk_buff *skb, __be16 sport,
 				     __be16 dport);
 
+INDIRECT_CALLABLE_DECLARE(struct sk_buff *udp4_gro_receive(struct list_head *,
+							   struct sk_buff *));
+INDIRECT_CALLABLE_DECLARE(int udp4_gro_complete(struct sk_buff *, int));
+INDIRECT_CALLABLE_DECLARE(struct sk_buff *udp6_gro_receive(struct list_head *,
+							   struct sk_buff *));
+INDIRECT_CALLABLE_DECLARE(int udp6_gro_complete(struct sk_buff *, int));
 struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 				struct udphdr *uh, struct sock *sk);
 int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index d8dbff1dd1fa155171b45a2dbf3034563db22db5..ea6ed6d487ed390d99049864540519108a0647bb 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1432,8 +1432,6 @@ static struct sk_buff *ipip_gso_segment(struct sk_buff *skb,
 	return inet_gso_segment(skb, features);
 }
 
-INDIRECT_CALLABLE_DECLARE(struct sk_buff *udp4_gro_receive(struct list_head *,
-							   struct sk_buff *));
 struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
 {
 	const struct net_offload *ops;
@@ -1606,7 +1604,6 @@ int inet_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 	return -EINVAL;
 }
 
-INDIRECT_CALLABLE_DECLARE(int udp4_gro_complete(struct sk_buff *, int));
 int inet_gro_complete(struct sk_buff *skb, int nhoff)
 {
 	__be16 newlen = htons(skb->len - nhoff);
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index 78eec5b423856c853b6a59adab425dbe29a2c4fc..a80f90bf3ae7dc1aec904fd93b3d8e8c87a926e4 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -14,6 +14,7 @@
 #include <net/ipv6.h>
 #include <net/inet_common.h>
 #include <net/tcp.h>
+#include <net/udp.h>
 
 #include "ip6_offload.h"
 
@@ -178,8 +179,6 @@ static int ipv6_exthdrs_len(struct ipv6hdr *iph,
 	return len;
 }
 
-INDIRECT_CALLABLE_DECLARE(struct sk_buff *udp6_gro_receive(struct list_head *,
-							   struct sk_buff *));
 INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 							 struct sk_buff *skb)
 {
@@ -318,7 +317,6 @@ static struct sk_buff *ip4ip6_gro_receive(struct list_head *head,
 	return inet_gro_receive(head, skb);
 }
 
-INDIRECT_CALLABLE_DECLARE(int udp6_gro_complete(struct sk_buff *, int));
 INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
 {
 	const struct net_offload *ops;
-- 
2.27.0.111.gc72c7da667-goog

