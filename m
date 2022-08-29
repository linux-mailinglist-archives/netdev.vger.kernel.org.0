Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65BC5A4B00
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiH2MFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiH2MFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:05:22 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7B724951;
        Mon, 29 Aug 2022 04:50:13 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id e13so8927483wrm.1;
        Mon, 29 Aug 2022 04:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc;
        bh=1JiBGFDUygYonHEBJhR3zRy23bYSWcBPqoBDbyk9LKM=;
        b=o9pNB1tNXfWww6OS+v+xmZxDuCAFsASJkg0mb8Tx4Bf7shgj24utrrz6jvklu5yiPO
         QmemOsLxjLBlKj3GBSf70/UwcFLX4Ww71cETLbwFN6qYq5dIQn37sQ2RIymc1+m5Hs8Q
         b5JU+ojPf8yXpy8ye58gMCB72A+oK5TmXRQdpymIaJ2RDee4IAJ44yHHnr0FVUgAKvw0
         nRITg5165yLluoJsNJVK1yjG94yjxPniJanuWCuaM+tSzNd2BYc4FXO0EIya8iTLh0EN
         7l7XzrI4YIfTodENWApRXRCCqJnobc3U/bB+W5uMM8AQ8ycg3DPOfHnUB6EnpQVOJ23r
         DX/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc;
        bh=1JiBGFDUygYonHEBJhR3zRy23bYSWcBPqoBDbyk9LKM=;
        b=NObK9wraEQD2O2ZlhMOWKZGtjbmhrrLrtnYm00upATaSdTaJwbZZEhizEARYsRpon+
         H0P2O7bsu9pz20R9jcy0lP7ry3csNRdGlXhdyUcixspkIf8UF+hCndeHr4kgeOrpW3Fb
         iRkAu4d/hFI3qY6sry/ob7IQDMIB7e074kRytoKxMQxdaeQPrcJvgC8giFVegUW3jv21
         SxeSbgrs04DiwmBuC+/zg2JbVssYDfDd+4wZ4oFlQ9z8kAj8jKDHLBWs1Ik6IoaehC9X
         LHlMdqAmLmTBfNEffwnzGfon9CbrPsmoj9TZkm9eGMK8Wdb+Z6m/2gK08gncOti0Q3rn
         73Xw==
X-Gm-Message-State: ACgBeo2uYI1vqJFSzBDo9FtKv1mFNsD3AcIgYEz0spV7CXcQQJSdlvrd
        3n8r4PB8sKYdBzqv3NFUEZE=
X-Google-Smtp-Source: AA6agR4Gmyr4z3mS+5k0dLTFB7X7LzA++0d137SxJ1m9vPE3CqWEv0bDknBmvr0bQVkIc1tfpqsACA==
X-Received: by 2002:a5d:468d:0:b0:226:d8d9:25e3 with SMTP id u13-20020a5d468d000000b00226d8d925e3mr3216538wrq.415.1661773724712;
        Mon, 29 Aug 2022 04:48:44 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id l9-20020a7bc349000000b003a5fa79007fsm8660454wmj.7.2022.08.29.04.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 04:48:44 -0700 (PDT)
Date:   Mon, 29 Aug 2022 13:46:57 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, alex.aring@gmail.com,
        stefan@datenfreihafen.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, kafai@fb.com,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH 3/4] net-next: frags: add inetpeer frag_mem tracking
Message-ID: <20220829114648.GA2409@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Track per-peer fragment memory usage, using the existing per-fqdir
memory tracking logic.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 include/net/inet_frag.h                 | 11 ++------
 include/net/inetpeer.h                  |  1 +
 net/ieee802154/6lowpan/reassembly.c     |  2 +-
 net/ipv4/inet_fragment.c                | 36 ++++++++++++++++++++-----
 net/ipv4/inetpeer.c                     |  1 +
 net/ipv4/ip_fragment.c                  |  4 +--
 net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
 net/ipv6/reassembly.c                   |  2 +-
 8 files changed, 38 insertions(+), 21 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 05d95fad8a1a..077a0ec78a58 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -155,15 +155,8 @@ static inline long frag_mem_limit(const struct fqdir *fqdir)
 	return atomic_long_read(&fqdir->mem);
 }
 
-static inline void sub_frag_mem_limit(struct fqdir *fqdir, long val)
-{
-	atomic_long_sub(val, &fqdir->mem);
-}
-
-static inline void add_frag_mem_limit(struct fqdir *fqdir, long val)
-{
-	atomic_long_add(val, &fqdir->mem);
-}
+void sub_frag_mem_limit(struct inet_frag_queue *q, long val);
+void add_frag_mem_limit(struct inet_frag_queue *q, long val);
 
 /* RFC 3168 support :
  * We want to check ECN values of all fragments, do detect invalid combinations.
diff --git a/include/net/inetpeer.h b/include/net/inetpeer.h
index 74ff688568a0..1c602a706742 100644
--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -41,6 +41,7 @@ struct inet_peer {
 	u32			rate_tokens;	/* rate limiting for ICMP */
 	u32			n_redirects;
 	unsigned long		rate_last;
+	atomic_long_t		frag_mem;
 	/*
 	 * Once inet_peer is queued for deletion (refcnt == 0), following field
 	 * is not available: rid
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index a91283d1e5bf..0bf207e94082 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -135,7 +135,7 @@ static int lowpan_frag_queue(struct lowpan_frag_queue *fq,
 		fq->q.flags |= INET_FRAG_FIRST_IN;
 
 	fq->q.meat += skb->len;
-	add_frag_mem_limit(fq->q.fqdir, skb->truesize);
+	add_frag_mem_limit(&fq->q, skb->truesize);
 
 	if (fq->q.flags == (INET_FRAG_FIRST_IN | INET_FRAG_LAST_IN) &&
 	    fq->q.meat == fq->q.len) {
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index c3ec1dbe7081..8b8d77d548d4 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -250,6 +250,29 @@ void inet_frag_kill(struct inet_frag_queue *fq)
 }
 EXPORT_SYMBOL(inet_frag_kill);
 
+static inline long peer_mem_limit(const struct inet_frag_queue *q)
+{
+	if (!q->peer)
+		return 0;
+	return atomic_long_read(&q->peer->frag_mem);
+}
+
+void sub_frag_mem_limit(struct inet_frag_queue *q, long val)
+{
+	if (q->peer)
+		atomic_long_sub(val, &q->peer->frag_mem);
+	atomic_long_sub(val, &q->fqdir->mem);
+}
+EXPORT_SYMBOL(sub_frag_mem_limit);
+
+void add_frag_mem_limit(struct inet_frag_queue *q, long val)
+{
+	if (q->peer)
+		atomic_long_add(val, &q->peer->frag_mem);
+	atomic_long_add(val, &q->fqdir->mem);
+}
+EXPORT_SYMBOL(add_frag_mem_limit);
+
 static void inet_frag_destroy_rcu(struct rcu_head *head)
 {
 	struct inet_frag_queue *q = container_of(head, struct inet_frag_queue,
@@ -306,9 +329,8 @@ void inet_frag_destroy(struct inet_frag_queue *q)
 	sum_truesize = inet_frag_rbtree_purge(&q->rb_fragments);
 	sum = sum_truesize + f->qsize;
 
+	sub_frag_mem_limit(q, sum);
 	inet_frag_free(q);
-
-	sub_frag_mem_limit(fqdir, sum);
 }
 EXPORT_SYMBOL(inet_frag_destroy);
 
@@ -324,7 +346,7 @@ static struct inet_frag_queue *inet_frag_alloc(struct fqdir *fqdir,
 
 	q->fqdir = fqdir;
 	f->constructor(q, arg);
-	add_frag_mem_limit(fqdir, f->qsize);
+	add_frag_mem_limit(q, f->qsize);
 
 	timer_setup(&q->timer, f->frag_expire, 0);
 	spin_lock_init(&q->lock);
@@ -483,7 +505,7 @@ void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
 
 	delta += head->truesize;
 	if (delta)
-		add_frag_mem_limit(q->fqdir, delta);
+		add_frag_mem_limit(q, delta);
 
 	/* If the first fragment is fragmented itself, we split
 	 * it to two chunks: the first with data and paged part
@@ -505,7 +527,7 @@ void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
 		head->truesize += clone->truesize;
 		clone->csum = 0;
 		clone->ip_summed = head->ip_summed;
-		add_frag_mem_limit(q->fqdir, clone->truesize);
+		add_frag_mem_limit(q, clone->truesize);
 		skb_shinfo(head)->frag_list = clone;
 		nextp = &clone->next;
 	} else {
@@ -575,7 +597,7 @@ void inet_frag_reasm_finish(struct inet_frag_queue *q, struct sk_buff *head,
 			rbn = rbnext;
 		}
 	}
-	sub_frag_mem_limit(q->fqdir, sum_truesize);
+	sub_frag_mem_limit(q, sum_truesize);
 
 	*nextp = NULL;
 	skb_mark_not_on_list(head);
@@ -604,7 +626,7 @@ struct sk_buff *inet_frag_pull_head(struct inet_frag_queue *q)
 	if (head == q->fragments_tail)
 		q->fragments_tail = NULL;
 
-	sub_frag_mem_limit(q->fqdir, head->truesize);
+	sub_frag_mem_limit(q, head->truesize);
 
 	return head;
 }
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index e9fed83e9b3c..6e7325dba417 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -216,6 +216,7 @@ struct inet_peer *inet_getpeer(struct inet_peer_base *base,
 			p->dtime = (__u32)jiffies;
 			refcount_set(&p->refcnt, 2);
 			atomic_set(&p->rid, 0);
+			atomic_long_set(&p->frag_mem, 0);
 			p->metrics[RTAX_LOCK-1] = INETPEER_METRICS_NEW;
 			p->rate_tokens = 0;
 			p->n_redirects = 0;
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index d0c22c41cf26..e35061f6aadb 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -242,7 +242,7 @@ static int ip_frag_reinit(struct ipq *qp)
 	}
 
 	sum_truesize = inet_frag_rbtree_purge(&qp->q.rb_fragments);
-	sub_frag_mem_limit(qp->q.fqdir, sum_truesize);
+	sub_frag_mem_limit(&qp->q, sum_truesize);
 
 	qp->q.flags = 0;
 	qp->q.len = 0;
@@ -339,7 +339,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 	qp->q.mono_delivery_time = skb->mono_delivery_time;
 	qp->q.meat += skb->len;
 	qp->ecn |= ecn;
-	add_frag_mem_limit(qp->q.fqdir, skb->truesize);
+	add_frag_mem_limit(&qp->q, skb->truesize);
 	if (offset == 0)
 		qp->q.flags |= INET_FRAG_FIRST_IN;
 
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 7dd3629dd19e..11ce2335c584 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -269,7 +269,7 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 	fq->ecn |= ecn;
 	if (payload_len > fq->q.max_size)
 		fq->q.max_size = payload_len;
-	add_frag_mem_limit(fq->q.fqdir, skb->truesize);
+	add_frag_mem_limit(&fq->q, skb->truesize);
 
 	/* The first fragment.
 	 * nhoffset is obtained from the first fragment, of course.
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index ff866f2a879e..cd4ba6cc956b 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -197,7 +197,7 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
 	fq->q.mono_delivery_time = skb->mono_delivery_time;
 	fq->q.meat += skb->len;
 	fq->ecn |= ecn;
-	add_frag_mem_limit(fq->q.fqdir, skb->truesize);
+	add_frag_mem_limit(&fq->q, skb->truesize);
 
 	fragsize = -skb_network_offset(skb) + skb->len;
 	if (fragsize > fq->q.max_size)
-- 
2.36.1

