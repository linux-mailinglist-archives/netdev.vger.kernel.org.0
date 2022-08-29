Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1AA5A4B77
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbiH2MVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiH2MU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:20:56 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B077A6C27;
        Mon, 29 Aug 2022 05:04:19 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id ay39-20020a05600c1e2700b003a5503a80cfso4308443wmb.2;
        Mon, 29 Aug 2022 05:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc;
        bh=hxqAbFcpuVmdCzBbtEdTgdjeLFVRaXCJcGCpu8UlHog=;
        b=iZzG6XdkeygsKjHjT6RHpXFX6DlmUVFzmovWRy8vNxWLeceNyeXYUKr7L2XB4+8AVq
         aahDfhtahb9AAneV5jaW2aYoF+XY26cVuqyDoLP5zOeN57xcRIicsllLxN2YrHhBJWFF
         f2+pHPwMdJOcfsrSB/qE2aIjOGfrwCYmc2X3awL4QPEeLhFp6eR2bQ7uhoxf15GL7Qcc
         LmA8cXhgJ+zR9f3Bq6Nq7fyPEqxDBuHAEq0wuMSTFfURW3nElycUDfgfX6p1JCsdgyjf
         XqSL+QnTp4e15Yz/u+jtPc+QXYOvwhTcnS8kLQvdI9J4qFa2KG4qj0bHUmYne1tcX+f4
         rBFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc;
        bh=hxqAbFcpuVmdCzBbtEdTgdjeLFVRaXCJcGCpu8UlHog=;
        b=mJVvjSYyfFUjLfAS/mMZULatd0WHiDEke5qX1UD7NkofsY3tUKOaCykwteyT7ja6j8
         L/WS8BlGK0cq91vZ/IafHDGGdIoFPe6hNmzt4zLZbZAhvIGZg4o41Oq5JetMmOEAg0zl
         Ko/n7yLfTLm5/5ABxCStTnfG8ZzUw7NM/3TysTE2XivHSqHCBT2vZGrOuCACEK2Sgy5z
         qpVNuC3Yxb1QtRmggRYOAlifj2otK/cy7lKICeC66PvdL98fNxswrzCaZwTnkMGeY0op
         cIqFfWbaQKiY3e4azrXga9BE/htAsSv6ISdCXShC3u/yLR8t8uKr23+tf/20NjG3LnsW
         rpeA==
X-Gm-Message-State: ACgBeo0++LOYr2JpCMmdCAaXh6ItEkR0tFUnE/muF0rIPfpKIes5bwh6
        gj7+cn4gqBmV/8d2eRFfDacmf/tAe5I=
X-Google-Smtp-Source: AA6agR7YxhHVMj9XWpJVMLkVYl9/G+NCIxQVTy6U5aONCYYoP9w92jav+CBywTEPIw3JdyMrtVUZ+g==
X-Received: by 2002:a05:600c:3b8c:b0:3a6:71a:f286 with SMTP id n12-20020a05600c3b8c00b003a6071af286mr6463379wms.120.1661773632330;
        Mon, 29 Aug 2022 04:47:12 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id o7-20020adfeac7000000b00226332f9275sm6768446wrn.22.2022.08.29.04.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 04:47:12 -0700 (PDT)
Date:   Mon, 29 Aug 2022 13:45:20 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, alex.aring@gmail.com,
        stefan@datenfreihafen.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, kafai@fb.com,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH 1/4] net-next: frags: move inetpeer from ip4 to inet
Message-ID: <20220829114507.GA2348@debian>
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

Move frags-related inetpeer logic from ip4 to inet. This allows us to
access peer information inside inet_frag logic.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 include/net/inet_frag.h  |  1 +
 net/ipv4/inet_fragment.c | 11 ++++++++++-
 net/ipv4/ip_fragment.c   | 19 +++----------------
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 0b0876610553..05d95fad8a1a 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -98,6 +98,7 @@ struct inet_frag_queue {
 	__u8			flags;
 	u16			max_size;
 	struct fqdir		*fqdir;
+	struct inet_peer	*peer;
 	struct rcu_head		rcu;
 };
 
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index c9f9ac5013a7..c3ec1dbe7081 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -23,6 +23,7 @@
 #include <net/inet_ecn.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
+#include <net/inetpeer.h>
 
 /* Use skb->cb to track consecutive/adjacent fragments coming at
  * the end of the queue. Nodes in the rb-tree queue will
@@ -282,6 +283,14 @@ unsigned int inet_frag_rbtree_purge(struct rb_root *root)
 }
 EXPORT_SYMBOL(inet_frag_rbtree_purge);
 
+void inet_frag_free(struct inet_frag_queue *q)
+{
+	if (q->peer)
+		inet_putpeer(q->peer);
+
+	call_rcu(&q->rcu, inet_frag_destroy_rcu);
+}
+
 void inet_frag_destroy(struct inet_frag_queue *q)
 {
 	struct fqdir *fqdir;
@@ -297,7 +306,7 @@ void inet_frag_destroy(struct inet_frag_queue *q)
 	sum_truesize = inet_frag_rbtree_purge(&q->rb_fragments);
 	sum = sum_truesize + f->qsize;
 
-	call_rcu(&q->rcu, inet_frag_destroy_rcu);
+	inet_frag_free(q);
 
 	sub_frag_mem_limit(fqdir, sum);
 }
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index fb153569889e..d0c22c41cf26 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -65,7 +65,6 @@ struct ipq {
 	u16		max_df_size; /* largest frag with DF set seen */
 	int             iif;
 	unsigned int    rid;
-	struct inet_peer *peer;
 };
 
 static u8 ip4_frag_ecn(u8 tos)
@@ -88,21 +87,9 @@ static void ip4_frag_init(struct inet_frag_queue *q, const void *a)
 
 	q->key.v4 = *key;
 	qp->ecn = 0;
-	qp->peer = q->fqdir->max_dist ?
-		inet_getpeer_v4(net->ipv4.peers, key->saddr, key->vif, 1) :
-		NULL;
+	q->peer = inet_getpeer_v4(net->ipv4.peers, key->saddr, key->vif, 1);
 }
 
-static void ip4_frag_free(struct inet_frag_queue *q)
-{
-	struct ipq *qp;
-
-	qp = container_of(q, struct ipq, q);
-	if (qp->peer)
-		inet_putpeer(qp->peer);
-}
-
-
 /* Destruction primitives. */
 
 static void ipq_put(struct ipq *ipq)
@@ -224,7 +211,7 @@ static struct ipq *ip_find(struct net *net, struct iphdr *iph,
 /* Is the fragment too far ahead to be part of ipq? */
 static int ip_frag_too_far(struct ipq *qp)
 {
-	struct inet_peer *peer = qp->peer;
+	struct inet_peer *peer = qp->q.peer;
 	unsigned int max = qp->q.fqdir->max_dist;
 	unsigned int start, end;
 
@@ -741,7 +728,7 @@ static const struct rhashtable_params ip4_rhash_params = {
 void __init ipfrag_init(void)
 {
 	ip4_frags.constructor = ip4_frag_init;
-	ip4_frags.destructor = ip4_frag_free;
+	ip4_frags.destructor = NULL;
 	ip4_frags.qsize = sizeof(struct ipq);
 	ip4_frags.frag_expire = ip_expire;
 	ip4_frags.frags_cache_name = ip_frag_cache_name;
-- 
2.36.1

