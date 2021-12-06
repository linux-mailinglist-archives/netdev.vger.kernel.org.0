Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492B246A3ED
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346779AbhLFSZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:25:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26276 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346777AbhLFSZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:25:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638814940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=26c++pLtqvXVRNhT0zVgcuBwbntt8anqzxmdqAqLJnM=;
        b=bwwGEeIkKfjVciv4nc9bAIv9WnbtsFcst2XRjJc8KTHOfUA4kK/+4foBcrF2azTZAZVuQk
        z1TCdqkczwiK6eKa6GxyVmfCmUJFDXzQvJQuKHzMAVW1eAZKLVZxgiqqIgveNQyUtnh7+9
        MYX3GcaVdagRYasfDFChjzAPXn0DZRQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-VBvHqVv4PEeZAwkn4-mWPA-1; Mon, 06 Dec 2021 13:22:19 -0500
X-MC-Unique: VBvHqVv4PEeZAwkn4-mWPA-1
Received: by mail-wm1-f70.google.com with SMTP id 69-20020a1c0148000000b0033214e5b021so6486031wmb.3
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 10:22:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=26c++pLtqvXVRNhT0zVgcuBwbntt8anqzxmdqAqLJnM=;
        b=7H9avNHC4dkoN5jxeZYVallnMAcRrUU+XRydKDBQVi/WhF2fvvomtBnIb0aZjYAnIU
         EncRfWBizFj777GHYn6AsOaMKmIzQmILrlSSzZv4gEcjcLsnTPmVFYUz6M7PHpOFx83V
         EpXp7H2F1ZFBoJmH8c8zboOicFox662L1KjqddYnwuzKsHJE89LvH9N/Tz5+bozbRAKQ
         KV7BV8BVGZnAPaE66PwjlRi5nIdAjO/BBzyle/94WCQDcKBU+U14VgfGq2jco59FGxyf
         WtZ5VkSSJAgzjrJioOrwNlLTuQEZ+n3cLNU0f9NkTvbvrew2r8G9fdGst7Knww3TpdNL
         yKzA==
X-Gm-Message-State: AOAM533r9y1MTCWWGZKOzMnBdjS4L9VN+WsC3SMfRGuRylcJmXqMX4MY
        QM5OAmtX+buJMTg7LcUAyy2QUPCaaB7unI0QUsdwxghO/dWVogv1esI0AOrn1HSXoQdekvgs3Ko
        WZ9fkuOrAV4UiEjcL
X-Received: by 2002:adf:e387:: with SMTP id e7mr43681555wrm.412.1638814937511;
        Mon, 06 Dec 2021 10:22:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyZhLTOPYm0rqRbuEpFVVAEK7XAmD4GECFI95Hk+PskLQuW1ks7+2hL99YKwNgNoZOAoa2E4w==
X-Received: by 2002:adf:e387:: with SMTP id e7mr43681525wrm.412.1638814937246;
        Mon, 06 Dec 2021 10:22:17 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id b6sm98815wmq.45.2021.12.06.10.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:22:16 -0800 (PST)
Date:   Mon, 6 Dec 2021 19:22:14 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Russell Strong <russell@strong.id.au>
Subject: [PATCH net-next 4/4] ipv4: Use dscp_t in struct fib_alias
Message-ID: <16e93e56a10ab541f5e84b954e15f9779f68ac8d.1638814614.git.gnault@redhat.com>
References: <cover.1638814614.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1638814614.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new dscp_t type to replace the fa_tos field of fib_alias. This
ensures ECN bits are ignored and makes the field compatible with
fc_dscp (struct fib_config).

Converting old *tos variables and fields to dscp_t, allows sparse to
flag incorrect uses of DSCP and ECN bits.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/fib_lookup.h    |  3 +-
 net/ipv4/fib_semantics.c | 14 ++++++----
 net/ipv4/fib_trie.c      | 59 ++++++++++++++++++++++------------------
 net/ipv4/route.c         |  3 +-
 4 files changed, 45 insertions(+), 34 deletions(-)

diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index e184bcb19943..a63014b54809 100644
--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -4,13 +4,14 @@
 
 #include <linux/types.h>
 #include <linux/list.h>
+#include <net/inet_dscp.h>
 #include <net/ip_fib.h>
 #include <net/nexthop.h>
 
 struct fib_alias {
 	struct hlist_node	fa_list;
 	struct fib_info		*fa_info;
-	u8			fa_tos;
+	dscp_t			fa_dscp;
 	u8			fa_type;
 	u8			fa_state;
 	u8			fa_slen;
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index fde7797b5806..872adeee9e5b 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -31,6 +31,7 @@
 #include <linux/netlink.h>
 
 #include <net/arp.h>
+#include <net/inet_dscp.h>
 #include <net/ip.h>
 #include <net/protocol.h>
 #include <net/route.h>
@@ -515,7 +516,7 @@ void rtmsg_fib(int event, __be32 key, struct fib_alias *fa,
 	fri.tb_id = tb_id;
 	fri.dst = key;
 	fri.dst_len = dst_len;
-	fri.tos = fa->fa_tos;
+	fri.tos = inet_dscp_to_dsfield(fa->fa_dscp);
 	fri.type = fa->fa_type;
 	fri.offload = fa->offload;
 	fri.trap = fa->trap;
@@ -2016,7 +2017,7 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
 	int order = -1, last_idx = -1;
 	struct fib_alias *fa, *fa1 = NULL;
 	u32 last_prio = res->fi->fib_priority;
-	u8 last_tos = 0;
+	dscp_t last_dscp = 0;
 
 	hlist_for_each_entry_rcu(fa, fa_head, fa_list) {
 		struct fib_info *next_fi = fa->fa_info;
@@ -2024,19 +2025,20 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
 
 		if (fa->fa_slen != slen)
 			continue;
-		if (fa->fa_tos && fa->fa_tos != flp->flowi4_tos)
+		if (fa->fa_dscp &&
+		    fa->fa_dscp != inet_dsfield_to_dscp(flp->flowi4_tos))
 			continue;
 		if (fa->tb_id != tb->tb_id)
 			continue;
 		if (next_fi->fib_priority > last_prio &&
-		    fa->fa_tos == last_tos) {
-			if (last_tos)
+		    fa->fa_dscp == last_dscp) {
+			if (last_dscp)
 				continue;
 			break;
 		}
 		if (next_fi->fib_flags & RTNH_F_DEAD)
 			continue;
-		last_tos = fa->fa_tos;
+		last_dscp = fa->fa_dscp;
 		last_prio = next_fi->fib_priority;
 
 		if (next_fi->fib_scope != res->scope ||
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index d937eeebb812..eb8ce2cb8aa2 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -82,7 +82,7 @@ static int call_fib_entry_notifier(struct notifier_block *nb,
 		.dst = dst,
 		.dst_len = dst_len,
 		.fi = fa->fa_info,
-		.tos = fa->fa_tos,
+		.tos = inet_dscp_to_dsfield(fa->fa_dscp),
 		.type = fa->fa_type,
 		.tb_id = fa->tb_id,
 	};
@@ -99,7 +99,7 @@ static int call_fib_entry_notifiers(struct net *net,
 		.dst = dst,
 		.dst_len = dst_len,
 		.fi = fa->fa_info,
-		.tos = fa->fa_tos,
+		.tos = inet_dscp_to_dsfield(fa->fa_dscp),
 		.type = fa->fa_type,
 		.tb_id = fa->tb_id,
 	};
@@ -974,13 +974,13 @@ static struct key_vector *fib_find_node(struct trie *t,
 	return n;
 }
 
-/* Return the first fib alias matching TOS with
+/* Return the first fib alias matching DSCP with
  * priority less than or equal to PRIO.
  * If 'find_first' is set, return the first matching
- * fib alias, regardless of TOS and priority.
+ * fib alias, regardless of DSCP and priority.
  */
 static struct fib_alias *fib_find_alias(struct hlist_head *fah, u8 slen,
-					u8 tos, u32 prio, u32 tb_id,
+					dscp_t dscp, u32 prio, u32 tb_id,
 					bool find_first)
 {
 	struct fib_alias *fa;
@@ -989,6 +989,10 @@ static struct fib_alias *fib_find_alias(struct hlist_head *fah, u8 slen,
 		return NULL;
 
 	hlist_for_each_entry(fa, fah, fa_list) {
+		/* Avoid Sparse warning when using dscp_t in inequalities */
+		u8 __fa_dscp = (__force u8)fa->fa_dscp;
+		u8 __dscp = (__force u8)dscp;
+
 		if (fa->fa_slen < slen)
 			continue;
 		if (fa->fa_slen != slen)
@@ -999,9 +1003,9 @@ static struct fib_alias *fib_find_alias(struct hlist_head *fah, u8 slen,
 			break;
 		if (find_first)
 			return fa;
-		if (fa->fa_tos > tos)
+		if (__fa_dscp > __dscp)
 			continue;
-		if (fa->fa_info->fib_priority >= prio || fa->fa_tos < tos)
+		if (fa->fa_info->fib_priority >= prio || __fa_dscp < __dscp)
 			return fa;
 	}
 
@@ -1028,8 +1032,8 @@ fib_find_matching_alias(struct net *net, const struct fib_rt_info *fri)
 
 	hlist_for_each_entry_rcu(fa, &l->leaf, fa_list) {
 		if (fa->fa_slen == slen && fa->tb_id == fri->tb_id &&
-		    fa->fa_tos == fri->tos && fa->fa_info == fri->fi &&
-		    fa->fa_type == fri->type)
+		    fa->fa_dscp == inet_dsfield_to_dscp(fri->tos) &&
+		    fa->fa_info == fri->fi && fa->fa_type == fri->type)
 			return fa;
 	}
 
@@ -1211,9 +1215,9 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 	struct fib_info *fi;
 	u8 plen = cfg->fc_dst_len;
 	u8 slen = KEYLENGTH - plen;
+	dscp_t dscp;
 	u32 key;
 	int err;
-	u8 tos;
 
 	key = ntohl(cfg->fc_dst);
 
@@ -1228,13 +1232,13 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 		goto err;
 	}
 
-	tos = inet_dscp_to_dsfield(cfg->fc_dscp);
+	dscp = cfg->fc_dscp;
 	l = fib_find_node(t, &tp, key);
-	fa = l ? fib_find_alias(&l->leaf, slen, tos, fi->fib_priority,
+	fa = l ? fib_find_alias(&l->leaf, slen, dscp, fi->fib_priority,
 				tb->tb_id, false) : NULL;
 
 	/* Now fa, if non-NULL, points to the first fib alias
-	 * with the same keys [prefix,tos,priority], if such key already
+	 * with the same keys [prefix,dscp,priority], if such key already
 	 * exists or to the node before which we will insert new one.
 	 *
 	 * If fa is NULL, we will need to allocate a new one and
@@ -1242,7 +1246,7 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 	 * of the new alias.
 	 */
 
-	if (fa && fa->fa_tos == tos &&
+	if (fa && fa->fa_dscp == dscp &&
 	    fa->fa_info->fib_priority == fi->fib_priority) {
 		struct fib_alias *fa_first, *fa_match;
 
@@ -1262,7 +1266,7 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 		hlist_for_each_entry_from(fa, fa_list) {
 			if ((fa->fa_slen != slen) ||
 			    (fa->tb_id != tb->tb_id) ||
-			    (fa->fa_tos != tos))
+			    (fa->fa_dscp != dscp))
 				break;
 			if (fa->fa_info->fib_priority != fi->fib_priority)
 				break;
@@ -1290,7 +1294,7 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 				goto out;
 
 			fi_drop = fa->fa_info;
-			new_fa->fa_tos = fa->fa_tos;
+			new_fa->fa_dscp = fa->fa_dscp;
 			new_fa->fa_info = fi;
 			new_fa->fa_type = cfg->fc_type;
 			state = fa->fa_state;
@@ -1353,7 +1357,7 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 		goto out;
 
 	new_fa->fa_info = fi;
-	new_fa->fa_tos = tos;
+	new_fa->fa_dscp = dscp;
 	new_fa->fa_type = cfg->fc_type;
 	new_fa->fa_state = 0;
 	new_fa->fa_slen = slen;
@@ -1569,7 +1573,8 @@ int fib_table_lookup(struct fib_table *tb, const struct flowi4 *flp,
 			if (index >= (1ul << fa->fa_slen))
 				continue;
 		}
-		if (fa->fa_tos && fa->fa_tos != flp->flowi4_tos)
+		if (fa->fa_dscp &&
+		    inet_dscp_to_dsfield(fa->fa_dscp) != flp->flowi4_tos)
 			continue;
 		if (fi->fib_dead)
 			continue;
@@ -1705,8 +1710,8 @@ int fib_table_delete(struct net *net, struct fib_table *tb,
 	struct key_vector *l, *tp;
 	u8 plen = cfg->fc_dst_len;
 	u8 slen = KEYLENGTH - plen;
+	dscp_t dscp;
 	u32 key;
-	u8 tos;
 
 	key = ntohl(cfg->fc_dst);
 
@@ -1717,12 +1722,13 @@ int fib_table_delete(struct net *net, struct fib_table *tb,
 	if (!l)
 		return -ESRCH;
 
-	tos = inet_dscp_to_dsfield(cfg->fc_dscp);
-	fa = fib_find_alias(&l->leaf, slen, tos, 0, tb->tb_id, false);
+	dscp = cfg->fc_dscp;
+	fa = fib_find_alias(&l->leaf, slen, dscp, 0, tb->tb_id, false);
 	if (!fa)
 		return -ESRCH;
 
-	pr_debug("Deleting %08x/%d tos=%d t=%p\n", key, plen, tos, t);
+	pr_debug("Deleting %08x/%d dsfield=%u t=%p\n", key, plen,
+		 inet_dscp_to_dsfield(dscp), t);
 
 	fa_to_delete = NULL;
 	hlist_for_each_entry_from(fa, fa_list) {
@@ -1730,7 +1736,7 @@ int fib_table_delete(struct net *net, struct fib_table *tb,
 
 		if ((fa->fa_slen != slen) ||
 		    (fa->tb_id != tb->tb_id) ||
-		    (fa->fa_tos != tos))
+		    (fa->fa_dscp != dscp))
 			break;
 
 		if ((!cfg->fc_type || fa->fa_type == cfg->fc_type) &&
@@ -2298,7 +2304,7 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
 				fri.tb_id = tb->tb_id;
 				fri.dst = xkey;
 				fri.dst_len = KEYLENGTH - fa->fa_slen;
-				fri.tos = fa->fa_tos;
+				fri.tos = inet_dscp_to_dsfield(fa->fa_dscp);
 				fri.type = fa->fa_type;
 				fri.offload = fa->offload;
 				fri.trap = fa->trap;
@@ -2810,8 +2816,9 @@ static int fib_trie_seq_show(struct seq_file *seq, void *v)
 					     fa->fa_info->fib_scope),
 				   rtn_type(buf2, sizeof(buf2),
 					    fa->fa_type));
-			if (fa->fa_tos)
-				seq_printf(seq, " tos=%d", fa->fa_tos);
+			if (fa->fa_dscp)
+				seq_printf(seq, " tos=%u",
+					   inet_dscp_to_dsfield(fa->fa_dscp));
 			seq_putc(seq, '\n');
 		}
 	}
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 243a0c52be42..8432bc066839 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -84,6 +84,7 @@
 #include <linux/jhash.h>
 #include <net/dst.h>
 #include <net/dst_metadata.h>
+#include <net/inet_dscp.h>
 #include <net/net_namespace.h>
 #include <net/ip.h>
 #include <net/route.h>
@@ -3390,7 +3391,7 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 
 				if (fa->fa_slen == slen &&
 				    fa->tb_id == fri.tb_id &&
-				    fa->fa_tos == fri.tos &&
+				    fa->fa_dscp == inet_dsfield_to_dscp(fri.tos) &&
 				    fa->fa_info == res.fi &&
 				    fa->fa_type == fri.type) {
 					fri.offload = fa->offload;
-- 
2.21.3

