Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A739F4A9A78
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 14:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359164AbiBDN62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 08:58:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45902 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359167AbiBDN6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 08:58:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643983104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Un6EwVu85g90lfpb+AqMx2D21JFbT6Jj34yeS3qzgs=;
        b=WNRG3XxtI4pqeQQQ0giBVH9puH3rlOWkrEXX5J7kuUMIlBiIpeB/+Bbxc5lkpDbZeh6ehx
        lOGrXKmSkeXD9/D4lDdOtsEjddqWthMiWR4OgOCbN+W7+7gibXbsdqjuhyyxjDUUXP8vYw
        TpU/AcztPiH3hfMKBqJSw4U0h/y+R/Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-OtxjUiZHPu-tFTIK4IvfSw-1; Fri, 04 Feb 2022 08:58:23 -0500
X-MC-Unique: OtxjUiZHPu-tFTIK4IvfSw-1
Received: by mail-wm1-f71.google.com with SMTP id l20-20020a05600c1d1400b0035153bf34c3so7625098wms.2
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 05:58:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Un6EwVu85g90lfpb+AqMx2D21JFbT6Jj34yeS3qzgs=;
        b=gSDe7oPHpZaj49haTHy+AN2JRxtMhjBM9wdwEvS/70EWBlD/c4vAw5tLiZD3Fse8Jr
         wak23TYP3mo2qCJeFRPV0CkhywoO7oye+0c+B7aB8rXMVsbm/PtxkleFUAbmGiuOEzAG
         zyJEZA1oXpOia7uSAYHjLon5TaE9GdefowiNcexQXY8A2pnbvc7DD9gXJ3zK2xMi/yhs
         OsrOFcym2deyT/T2fuG6myp2s7ke0EPMGJXh7lKhJEDwEU39HXwEIj7tIN23cW0pMfNb
         cwKpXPVmVQofndL1zQ4aCCfj2wkATfvKkSNQ0BDnP7KOKwzZ/oUtzEtVM7Gff24zi/pE
         vjWw==
X-Gm-Message-State: AOAM532dpHma5fRHFv0Af22055u8qwSN2ZX7b92hAtzYJ/RPRFGF6H01
        RJKSUpUXWAgthPIsBuYtyszUKOTLwMxJaXtSHu38RlbEcyifyszljT9Bs2aeX0kJY48Yd7QtZpS
        oUw1yudbfgfytMWwE
X-Received: by 2002:a7b:c7c3:: with SMTP id z3mr223425wmk.68.1643983101883;
        Fri, 04 Feb 2022 05:58:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwYo4QnVoMwSbmdlTryywiWMGImENpc2F/d0N/22E4+OD+YrT0zckGvXeJwnlURMP1wtHmjeA==
X-Received: by 2002:a7b:c7c3:: with SMTP id z3mr223414wmk.68.1643983101682;
        Fri, 04 Feb 2022 05:58:21 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id p14sm2335262wrr.7.2022.02.04.05.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 05:58:21 -0800 (PST)
Date:   Fri, 4 Feb 2022 14:58:19 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Russell Strong <russell@strong.id.au>,
        Dave Taht <dave.taht@gmail.com>
Subject: [PATCH net-next 4/4] ipv4: Use dscp_t in struct fib_alias
Message-ID: <36cd033d0edf2b8f40997493b991e812f4b0b2a0.1643981839.git.gnault@redhat.com>
References: <cover.1643981839.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1643981839.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new dscp_t type to replace the fa_tos field of fib_alias. This
ensures ECN bits are ignored and makes the field compatible with the
fc_dscp field of struct fib_config.

Converting old *tos variables and fields to dscp_t allows sparse to
flag incorrect uses of DSCP and ECN bits. This patch is entirely about
type annotation and shouldn't change any existing behaviour.

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
index 4c5399450682..c9c4f2f66b38 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -32,6 +32,7 @@
 #include <linux/hash.h>
 
 #include <net/arp.h>
+#include <net/inet_dscp.h>
 #include <net/ip.h>
 #include <net/protocol.h>
 #include <net/route.h>
@@ -523,7 +524,7 @@ void rtmsg_fib(int event, __be32 key, struct fib_alias *fa,
 	fri.tb_id = tb_id;
 	fri.dst = key;
 	fri.dst_len = dst_len;
-	fri.tos = fa->fa_tos;
+	fri.tos = inet_dscp_to_dsfield(fa->fa_dscp);
 	fri.type = fa->fa_type;
 	fri.offload = fa->offload;
 	fri.trap = fa->trap;
@@ -2039,7 +2040,7 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
 	int order = -1, last_idx = -1;
 	struct fib_alias *fa, *fa1 = NULL;
 	u32 last_prio = res->fi->fib_priority;
-	u8 last_tos = 0;
+	dscp_t last_dscp = 0;
 
 	hlist_for_each_entry_rcu(fa, fa_head, fa_list) {
 		struct fib_info *next_fi = fa->fa_info;
@@ -2047,19 +2048,20 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
 
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
index d937eeebb812..c05cd105e95e 100644
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
+		u8 __fa_dscp = inet_dscp_to_dsfield(fa->fa_dscp);
+		u8 __dscp = inet_dscp_to_dsfield(dscp);
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
+	pr_debug("Deleting %08x/%d dsfield=0x%02x t=%p\n", key, plen,
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
+				seq_printf(seq, " tos=%d",
+					   inet_dscp_to_dsfield(fa->fa_dscp));
 			seq_putc(seq, '\n');
 		}
 	}
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 8b35075088e1..634766e6c7cc 100644
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
@@ -3391,7 +3392,7 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 
 				if (fa->fa_slen == slen &&
 				    fa->tb_id == fri.tb_id &&
-				    fa->fa_tos == fri.tos &&
+				    fa->fa_dscp == inet_dsfield_to_dscp(fri.tos) &&
 				    fa->fa_info == res.fi &&
 				    fa->fa_type == fri.type) {
 					fri.offload = fa->offload;
-- 
2.21.3

