Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C0329BB7
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390304AbfEXQDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:03:48 -0400
Received: from mail-vs1-f73.google.com ([209.85.217.73]:55765 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389706AbfEXQDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:03:48 -0400
Received: by mail-vs1-f73.google.com with SMTP id q63so2170237vsq.22
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cxhEAyq8LPXFAH2PLsZy5+ZSuggLdCxa9UQDQZd+yk4=;
        b=MSXxKwbgGmlzk8isu9BIGWbvR/puSIaRCugv8e3TlCA+vHkq0BtsIUhVVCSe8gVp8d
         kPB+UEcM6R29l68gp6gR8hx/Td/+UxDefFTxH9c+slgjAnS5+FMDDdctYARDAkYn7BAJ
         IXderUu3LilBhBwsrpdb76ISVva3kIchgWmNk9TXRKRD4hgnT+D9qJz9B37++csC3XA7
         ShX71edKca8MEh8ePREhUib1PHbihwH+PjwTo+oJoYpMcNhO8xI3z+hWML8U2mRiwAAy
         jLMMA07mnJG5AasymyMYRcyToAXm3seEPpA6w+E+wurTzbcvdYadFvqZiuWqQ031TeSg
         ndFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cxhEAyq8LPXFAH2PLsZy5+ZSuggLdCxa9UQDQZd+yk4=;
        b=l5l1T6v6d4irq+aGh+CDNM7Vx6iN+O2ox/vKCkxi12Swumqolqkf4vIIa5fFmmvga5
         eTo+qr2PoB4BCKa8ShWcUc3Zn/IhBS0yRk0KM5mULLkXkIY7lTavXd+ej1MLrsGpFhKd
         ozYTxohAaAdV2cHP/PVw1kLYo1jeaW3dctSOxwCEGEvGrTWqlWKFdGuHc2a91Mj5VOV/
         aa4oOngq0olgcALw95nqifoxo/TVRKQPjVQ+R0XsYxDbqunPeGYk1gNQ0qIiDdTaUBFL
         sADe356nmenNIkfjszuMhsjHnbetAbdz+IoOu1uY3MLZOlgEpkfg8HjiYdM3I5ydNFZT
         eGlg==
X-Gm-Message-State: APjAAAWUTpYzVc1LO19XqWkJAau3/KINVzV99jR1xzy+9d1crm4O+SLL
        69poTquyQNyH1uw2voXfjnkZVHfHkrbvpg==
X-Google-Smtp-Source: APXvYqxQ6um3yqW5B24K5915B932Bq912jSxRR/NVDRYZW5nL/P1uAnymJb5KPJ1NHSbXSPBhVOFEPA8IKz/vQ==
X-Received: by 2002:ab0:224f:: with SMTP id z15mr19682918uan.88.1558713826905;
 Fri, 24 May 2019 09:03:46 -0700 (PDT)
Date:   Fri, 24 May 2019 09:03:30 -0700
In-Reply-To: <20190524160340.169521-1-edumazet@google.com>
Message-Id: <20190524160340.169521-2-edumazet@google.com>
Mime-Version: 1.0
References: <20190524160340.169521-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next 01/11] inet: rename netns_frags to fqdir
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

1) struct netns_frags is renamed to struct fqdir
  This structure is really holding many frag queues in a hash table.

2) (struct inet_frag_queue)->net field is renamed to fqdir
  since net is generally associated to a 'struct net' pointer
  in networking stack.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_frag.h                 | 29 +++++++-------
 include/net/netns/ieee802154_6lowpan.h  |  2 +-
 include/net/netns/ipv4.h                |  2 +-
 include/net/netns/ipv6.h                |  4 +-
 net/ieee802154/6lowpan/reassembly.c     |  2 +-
 net/ipv4/inet_fragment.c                | 52 ++++++++++++-------------
 net/ipv4/ip_fragment.c                  | 20 +++++-----
 net/ipv6/netfilter/nf_conntrack_reasm.c |  4 +-
 net/ipv6/reassembly.c                   |  6 +--
 9 files changed, 61 insertions(+), 60 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 378904ee91296ff06a78d3ede4151892186f4545..b19b1ba44ac595215f44b9c86029d6ad27e26458 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -4,7 +4,8 @@
 
 #include <linux/rhashtable-types.h>
 
-struct netns_frags {
+/* Per netns frag queues directory */
+struct fqdir {
 	/* sysctls */
 	long			high_thresh;
 	long			low_thresh;
@@ -64,7 +65,7 @@ struct frag_v6_compare_key {
  * @meat: length of received fragments so far
  * @flags: fragment queue flags
  * @max_size: maximum received fragment size
- * @net: namespace that this frag belongs to
+ * @fqdir: pointer to struct fqdir
  * @rcu: rcu head for freeing deferall
  */
 struct inet_frag_queue {
@@ -84,7 +85,7 @@ struct inet_frag_queue {
 	int			meat;
 	__u8			flags;
 	u16			max_size;
-	struct netns_frags      *net;
+	struct fqdir		*fqdir;
 	struct rcu_head		rcu;
 };
 
@@ -103,16 +104,16 @@ struct inet_frags {
 int inet_frags_init(struct inet_frags *);
 void inet_frags_fini(struct inet_frags *);
 
-static inline int inet_frags_init_net(struct netns_frags *nf)
+static inline int inet_frags_init_net(struct fqdir *fqdir)
 {
-	atomic_long_set(&nf->mem, 0);
-	return rhashtable_init(&nf->rhashtable, &nf->f->rhash_params);
+	atomic_long_set(&fqdir->mem, 0);
+	return rhashtable_init(&fqdir->rhashtable, &fqdir->f->rhash_params);
 }
-void inet_frags_exit_net(struct netns_frags *nf);
+void inet_frags_exit_net(struct fqdir *fqdir);
 
 void inet_frag_kill(struct inet_frag_queue *q);
 void inet_frag_destroy(struct inet_frag_queue *q);
-struct inet_frag_queue *inet_frag_find(struct netns_frags *nf, void *key);
+struct inet_frag_queue *inet_frag_find(struct fqdir *fqdir, void *key);
 
 /* Free all skbs in the queue; return the sum of their truesizes. */
 unsigned int inet_frag_rbtree_purge(struct rb_root *root);
@@ -125,19 +126,19 @@ static inline void inet_frag_put(struct inet_frag_queue *q)
 
 /* Memory Tracking Functions. */
 
-static inline long frag_mem_limit(const struct netns_frags *nf)
+static inline long frag_mem_limit(const struct fqdir *fqdir)
 {
-	return atomic_long_read(&nf->mem);
+	return atomic_long_read(&fqdir->mem);
 }
 
-static inline void sub_frag_mem_limit(struct netns_frags *nf, long val)
+static inline void sub_frag_mem_limit(struct fqdir *fqdir, long val)
 {
-	atomic_long_sub(val, &nf->mem);
+	atomic_long_sub(val, &fqdir->mem);
 }
 
-static inline void add_frag_mem_limit(struct netns_frags *nf, long val)
+static inline void add_frag_mem_limit(struct fqdir *fqdir, long val)
 {
-	atomic_long_add(val, &nf->mem);
+	atomic_long_add(val, &fqdir->mem);
 }
 
 /* RFC 3168 support :
diff --git a/include/net/netns/ieee802154_6lowpan.h b/include/net/netns/ieee802154_6lowpan.h
index 736aeac52f56c98723901ade68b7adb0f10d2a37..48897cbcb538cbae7658bb03e5a5a702c2036739 100644
--- a/include/net/netns/ieee802154_6lowpan.h
+++ b/include/net/netns/ieee802154_6lowpan.h
@@ -16,7 +16,7 @@ struct netns_sysctl_lowpan {
 
 struct netns_ieee802154_lowpan {
 	struct netns_sysctl_lowpan sysctl;
-	struct netns_frags	frags;
+	struct fqdir	frags;
 };
 
 #endif
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 7698460a3dd1e5070e12d406b3ee58834688cdc9..22f712141962c2c86cd0210ea97a7f111de5ee16 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -72,7 +72,7 @@ struct netns_ipv4 {
 
 	struct inet_peer_base	*peers;
 	struct sock  * __percpu	*tcp_sk;
-	struct netns_frags	frags;
+	struct fqdir	frags;
 #ifdef CONFIG_NETFILTER
 	struct xt_table		*iptable_filter;
 	struct xt_table		*iptable_mangle;
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 5e61b5a8635d7a01181886e3968d258eb7d74698..a22e8702d82866576c235489a810040adb4267c7 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -58,7 +58,7 @@ struct netns_ipv6 {
 	struct ipv6_devconf	*devconf_all;
 	struct ipv6_devconf	*devconf_dflt;
 	struct inet_peer_base	*peers;
-	struct netns_frags	frags;
+	struct fqdir	frags;
 #ifdef CONFIG_NETFILTER
 	struct xt_table		*ip6table_filter;
 	struct xt_table		*ip6table_mangle;
@@ -116,7 +116,7 @@ struct netns_ipv6 {
 
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 struct netns_nf_frag {
-	struct netns_frags	frags;
+	struct fqdir	frags;
 };
 #endif
 
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index 4196bcd4105ae047b88cdaf090055980144fcc2b..8551d307f2149d0c9e74c7d9f89665b082ed63bc 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -139,7 +139,7 @@ static int lowpan_frag_queue(struct lowpan_frag_queue *fq,
 		fq->q.flags |= INET_FRAG_FIRST_IN;
 
 	fq->q.meat += skb->len;
-	add_frag_mem_limit(fq->q.net, skb->truesize);
+	add_frag_mem_limit(fq->q.fqdir, skb->truesize);
 
 	if (fq->q.flags == (INET_FRAG_FIRST_IN | INET_FRAG_LAST_IN) &&
 	    fq->q.meat == fq->q.len) {
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 737808e27f8b1cd65aac21c9316a5db5d0f40111..f8de2860e3a3e0941d29c9d65ab8336cfee56f65 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -145,11 +145,11 @@ static void inet_frags_free_cb(void *ptr, void *arg)
 	inet_frag_put(fq);
 }
 
-void inet_frags_exit_net(struct netns_frags *nf)
+void inet_frags_exit_net(struct fqdir *fqdir)
 {
-	nf->high_thresh = 0; /* prevent creation of new frags */
+	fqdir->high_thresh = 0; /* prevent creation of new frags */
 
-	rhashtable_free_and_destroy(&nf->rhashtable, inet_frags_free_cb, NULL);
+	rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
 }
 EXPORT_SYMBOL(inet_frags_exit_net);
 
@@ -159,10 +159,10 @@ void inet_frag_kill(struct inet_frag_queue *fq)
 		refcount_dec(&fq->refcnt);
 
 	if (!(fq->flags & INET_FRAG_COMPLETE)) {
-		struct netns_frags *nf = fq->net;
+		struct fqdir *fqdir = fq->fqdir;
 
 		fq->flags |= INET_FRAG_COMPLETE;
-		rhashtable_remove_fast(&nf->rhashtable, &fq->node, nf->f->rhash_params);
+		rhashtable_remove_fast(&fqdir->rhashtable, &fq->node, fqdir->f->rhash_params);
 		refcount_dec(&fq->refcnt);
 	}
 }
@@ -172,7 +172,7 @@ static void inet_frag_destroy_rcu(struct rcu_head *head)
 {
 	struct inet_frag_queue *q = container_of(head, struct inet_frag_queue,
 						 rcu);
-	struct inet_frags *f = q->net->f;
+	struct inet_frags *f = q->fqdir->f;
 
 	if (f->destructor)
 		f->destructor(q);
@@ -203,7 +203,7 @@ EXPORT_SYMBOL(inet_frag_rbtree_purge);
 
 void inet_frag_destroy(struct inet_frag_queue *q)
 {
-	struct netns_frags *nf;
+	struct fqdir *fqdir;
 	unsigned int sum, sum_truesize = 0;
 	struct inet_frags *f;
 
@@ -211,18 +211,18 @@ void inet_frag_destroy(struct inet_frag_queue *q)
 	WARN_ON(del_timer(&q->timer) != 0);
 
 	/* Release all fragment data. */
-	nf = q->net;
-	f = nf->f;
+	fqdir = q->fqdir;
+	f = fqdir->f;
 	sum_truesize = inet_frag_rbtree_purge(&q->rb_fragments);
 	sum = sum_truesize + f->qsize;
 
 	call_rcu(&q->rcu, inet_frag_destroy_rcu);
 
-	sub_frag_mem_limit(nf, sum);
+	sub_frag_mem_limit(fqdir, sum);
 }
 EXPORT_SYMBOL(inet_frag_destroy);
 
-static struct inet_frag_queue *inet_frag_alloc(struct netns_frags *nf,
+static struct inet_frag_queue *inet_frag_alloc(struct fqdir *fqdir,
 					       struct inet_frags *f,
 					       void *arg)
 {
@@ -232,9 +232,9 @@ static struct inet_frag_queue *inet_frag_alloc(struct netns_frags *nf,
 	if (!q)
 		return NULL;
 
-	q->net = nf;
+	q->fqdir = fqdir;
 	f->constructor(q, arg);
-	add_frag_mem_limit(nf, f->qsize);
+	add_frag_mem_limit(fqdir, f->qsize);
 
 	timer_setup(&q->timer, f->frag_expire, 0);
 	spin_lock_init(&q->lock);
@@ -243,21 +243,21 @@ static struct inet_frag_queue *inet_frag_alloc(struct netns_frags *nf,
 	return q;
 }
 
-static struct inet_frag_queue *inet_frag_create(struct netns_frags *nf,
+static struct inet_frag_queue *inet_frag_create(struct fqdir *fqdir,
 						void *arg,
 						struct inet_frag_queue **prev)
 {
-	struct inet_frags *f = nf->f;
+	struct inet_frags *f = fqdir->f;
 	struct inet_frag_queue *q;
 
-	q = inet_frag_alloc(nf, f, arg);
+	q = inet_frag_alloc(fqdir, f, arg);
 	if (!q) {
 		*prev = ERR_PTR(-ENOMEM);
 		return NULL;
 	}
-	mod_timer(&q->timer, jiffies + nf->timeout);
+	mod_timer(&q->timer, jiffies + fqdir->timeout);
 
-	*prev = rhashtable_lookup_get_insert_key(&nf->rhashtable, &q->key,
+	*prev = rhashtable_lookup_get_insert_key(&fqdir->rhashtable, &q->key,
 						 &q->node, f->rhash_params);
 	if (*prev) {
 		q->flags |= INET_FRAG_COMPLETE;
@@ -269,18 +269,18 @@ static struct inet_frag_queue *inet_frag_create(struct netns_frags *nf,
 }
 
 /* TODO : call from rcu_read_lock() and no longer use refcount_inc_not_zero() */
-struct inet_frag_queue *inet_frag_find(struct netns_frags *nf, void *key)
+struct inet_frag_queue *inet_frag_find(struct fqdir *fqdir, void *key)
 {
 	struct inet_frag_queue *fq = NULL, *prev;
 
-	if (!nf->high_thresh || frag_mem_limit(nf) > nf->high_thresh)
+	if (!fqdir->high_thresh || frag_mem_limit(fqdir) > fqdir->high_thresh)
 		return NULL;
 
 	rcu_read_lock();
 
-	prev = rhashtable_lookup(&nf->rhashtable, key, nf->f->rhash_params);
+	prev = rhashtable_lookup(&fqdir->rhashtable, key, fqdir->f->rhash_params);
 	if (!prev)
-		fq = inet_frag_create(nf, key, &prev);
+		fq = inet_frag_create(fqdir, key, &prev);
 	if (prev && !IS_ERR(prev)) {
 		fq = prev;
 		if (!refcount_inc_not_zero(&fq->refcnt))
@@ -391,7 +391,7 @@ void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
 
 	delta += head->truesize;
 	if (delta)
-		add_frag_mem_limit(q->net, delta);
+		add_frag_mem_limit(q->fqdir, delta);
 
 	/* If the first fragment is fragmented itself, we split
 	 * it to two chunks: the first with data and paged part
@@ -413,7 +413,7 @@ void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
 		head->truesize += clone->truesize;
 		clone->csum = 0;
 		clone->ip_summed = head->ip_summed;
-		add_frag_mem_limit(q->net, clone->truesize);
+		add_frag_mem_limit(q->fqdir, clone->truesize);
 		skb_shinfo(head)->frag_list = clone;
 		nextp = &clone->next;
 	} else {
@@ -466,7 +466,7 @@ void inet_frag_reasm_finish(struct inet_frag_queue *q, struct sk_buff *head,
 			rbn = rbnext;
 		}
 	}
-	sub_frag_mem_limit(q->net, head->truesize);
+	sub_frag_mem_limit(q->fqdir, head->truesize);
 
 	*nextp = NULL;
 	skb_mark_not_on_list(head);
@@ -494,7 +494,7 @@ struct sk_buff *inet_frag_pull_head(struct inet_frag_queue *q)
 	if (head == q->fragments_tail)
 		q->fragments_tail = NULL;
 
-	sub_frag_mem_limit(q->net, head->truesize);
+	sub_frag_mem_limit(q->fqdir, head->truesize);
 
 	return head;
 }
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index cf2b0a6a33372a7a6ed8bc30f505a350be463d91..c93e27cb0a8d1e404fd54e6aa5ea6a99ccecba4a 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -82,7 +82,7 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 static void ip4_frag_init(struct inet_frag_queue *q, const void *a)
 {
 	struct ipq *qp = container_of(q, struct ipq, q);
-	struct netns_ipv4 *ipv4 = container_of(q->net, struct netns_ipv4,
+	struct netns_ipv4 *ipv4 = container_of(q->fqdir, struct netns_ipv4,
 					       frags);
 	struct net *net = container_of(ipv4, struct net, ipv4);
 
@@ -90,7 +90,7 @@ static void ip4_frag_init(struct inet_frag_queue *q, const void *a)
 
 	q->key.v4 = *key;
 	qp->ecn = 0;
-	qp->peer = q->net->max_dist ?
+	qp->peer = q->fqdir->max_dist ?
 		inet_getpeer_v4(net->ipv4.peers, key->saddr, key->vif, 1) :
 		NULL;
 }
@@ -142,7 +142,7 @@ static void ip_expire(struct timer_list *t)
 	int err;
 
 	qp = container_of(frag, struct ipq, q);
-	net = container_of(qp->q.net, struct net, ipv4.frags);
+	net = container_of(qp->q.fqdir, struct net, ipv4.frags);
 
 	rcu_read_lock();
 	spin_lock(&qp->q.lock);
@@ -222,7 +222,7 @@ static struct ipq *ip_find(struct net *net, struct iphdr *iph,
 static int ip_frag_too_far(struct ipq *qp)
 {
 	struct inet_peer *peer = qp->peer;
-	unsigned int max = qp->q.net->max_dist;
+	unsigned int max = qp->q.fqdir->max_dist;
 	unsigned int start, end;
 
 	int rc;
@@ -239,7 +239,7 @@ static int ip_frag_too_far(struct ipq *qp)
 	if (rc) {
 		struct net *net;
 
-		net = container_of(qp->q.net, struct net, ipv4.frags);
+		net = container_of(qp->q.fqdir, struct net, ipv4.frags);
 		__IP_INC_STATS(net, IPSTATS_MIB_REASMFAILS);
 	}
 
@@ -250,13 +250,13 @@ static int ip_frag_reinit(struct ipq *qp)
 {
 	unsigned int sum_truesize = 0;
 
-	if (!mod_timer(&qp->q.timer, jiffies + qp->q.net->timeout)) {
+	if (!mod_timer(&qp->q.timer, jiffies + qp->q.fqdir->timeout)) {
 		refcount_inc(&qp->q.refcnt);
 		return -ETIMEDOUT;
 	}
 
 	sum_truesize = inet_frag_rbtree_purge(&qp->q.rb_fragments);
-	sub_frag_mem_limit(qp->q.net, sum_truesize);
+	sub_frag_mem_limit(qp->q.fqdir, sum_truesize);
 
 	qp->q.flags = 0;
 	qp->q.len = 0;
@@ -273,7 +273,7 @@ static int ip_frag_reinit(struct ipq *qp)
 /* Add new segment to existing queue. */
 static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 {
-	struct net *net = container_of(qp->q.net, struct net, ipv4.frags);
+	struct net *net = container_of(qp->q.fqdir, struct net, ipv4.frags);
 	int ihl, end, flags, offset;
 	struct sk_buff *prev_tail;
 	struct net_device *dev;
@@ -352,7 +352,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 	qp->q.stamp = skb->tstamp;
 	qp->q.meat += skb->len;
 	qp->ecn |= ecn;
-	add_frag_mem_limit(qp->q.net, skb->truesize);
+	add_frag_mem_limit(qp->q.fqdir, skb->truesize);
 	if (offset == 0)
 		qp->q.flags |= INET_FRAG_FIRST_IN;
 
@@ -399,7 +399,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 			 struct sk_buff *prev_tail, struct net_device *dev)
 {
-	struct net *net = container_of(qp->q.net, struct net, ipv4.frags);
+	struct net *net = container_of(qp->q.fqdir, struct net, ipv4.frags);
 	struct iphdr *iph;
 	void *reasm_data;
 	int len, err;
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 3de0e9b0a48247f0eef0691295642d6d8f521280..5b877d732b2fff23adb5be64dcbed587ab4e8077 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -151,7 +151,7 @@ static void nf_ct_frag6_expire(struct timer_list *t)
 	struct net *net;
 
 	fq = container_of(frag, struct frag_queue, q);
-	net = container_of(fq->q.net, struct net, nf_frag.frags);
+	net = container_of(fq->q.fqdir, struct net, nf_frag.frags);
 
 	ip6frag_expire_frag_queue(net, fq);
 }
@@ -276,7 +276,7 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 	fq->ecn |= ecn;
 	if (payload_len > fq->q.max_size)
 		fq->q.max_size = payload_len;
-	add_frag_mem_limit(fq->q.net, skb->truesize);
+	add_frag_mem_limit(fq->q.fqdir, skb->truesize);
 
 	/* The first fragment.
 	 * nhoffset is obtained from the first fragment, of course.
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 1a832f5e190bb00554026b50837329606371ed47..acd5a9a04415506570da67cc3dcee9cb61cfbd5b 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -79,7 +79,7 @@ static void ip6_frag_expire(struct timer_list *t)
 	struct net *net;
 
 	fq = container_of(frag, struct frag_queue, q);
-	net = container_of(fq->q.net, struct net, ipv6.frags);
+	net = container_of(fq->q.fqdir, struct net, ipv6.frags);
 
 	ip6frag_expire_frag_queue(net, fq);
 }
@@ -200,7 +200,7 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
 	fq->q.stamp = skb->tstamp;
 	fq->q.meat += skb->len;
 	fq->ecn |= ecn;
-	add_frag_mem_limit(fq->q.net, skb->truesize);
+	add_frag_mem_limit(fq->q.fqdir, skb->truesize);
 
 	fragsize = -skb_network_offset(skb) + skb->len;
 	if (fragsize > fq->q.max_size)
@@ -254,7 +254,7 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
 static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
 			  struct sk_buff *prev_tail, struct net_device *dev)
 {
-	struct net *net = container_of(fq->q.net, struct net, ipv6.frags);
+	struct net *net = container_of(fq->q.fqdir, struct net, ipv6.frags);
 	unsigned int nhoff;
 	void *reasm_data;
 	int payload_len;
-- 
2.22.0.rc1.257.g3120a18244-goog

