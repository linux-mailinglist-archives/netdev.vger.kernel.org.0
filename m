Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6680821781F
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgGGTlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgGGTly (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 15:41:54 -0400
Received: from embeddedor (unknown [200.39.26.250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ECE6206BE;
        Tue,  7 Jul 2020 19:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594150912;
        bh=MKiankuisiqEc/WQL0kZBzbmZ+hawSXGCP9/kjSXctU=;
        h=Date:From:To:Cc:Subject:From;
        b=MtHtJjophvaS9h3syJTrxeN1cU5LRt9/9Socw+2NYaIr/VXO4Qn7Xua5t5UbMP0O9
         fhbb7b3ZThRdbYjWuevbAHXM0yDZwbLDuRMOUWv436zU4cHA4jYqlKLkDjmXHKfyvT
         4YduQEqoy+djjv2i5x6Peq9cn8kxOCLufo1SEtEw=
Date:   Tue, 7 Jul 2020 14:47:17 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] netfilter: nf_tables: Use fallthrough pseudo-keyword
Message-ID: <20200707194717.GA3596@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
fall-through markings when it is the case.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/bridge/netfilter/ebtables.c         |    2 +-
 net/netfilter/ipset/ip_set_core.c       |    2 +-
 net/netfilter/nf_conntrack_h323_asn1.c  |    6 +++---
 net/netfilter/nf_conntrack_proto.c      |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c  |    2 +-
 net/netfilter/nf_conntrack_standalone.c |    2 +-
 net/netfilter/nf_nat_core.c             |   10 +++++-----
 net/netfilter/nf_synproxy_core.c        |    6 ++----
 net/netfilter/nf_tables_api.c           |    8 ++++----
 net/netfilter/nf_tables_core.c          |    2 +-
 net/netfilter/nfnetlink_cttimeout.c     |    2 +-
 net/netfilter/nft_cmp.c                 |    4 ++--
 net/netfilter/nft_ct.c                  |    4 ++--
 net/netfilter/nft_fib.c                 |    2 +-
 net/netfilter/nft_payload.c             |    2 +-
 net/netfilter/utils.c                   |    8 ++++----
 net/netfilter/x_tables.c                |    2 +-
 17 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index c83ffe912163..38e946fdd041 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1935,7 +1935,7 @@ static int compat_mtw_from_user(const struct compat_ebt_entry_mwt *mwt,
 			size_kern = match_size;
 		module_put(match->me);
 		break;
-	case EBT_COMPAT_WATCHER: /* fallthrough */
+	case EBT_COMPAT_WATCHER:
 	case EBT_COMPAT_TARGET:
 		wt = xt_request_find_target(NFPROTO_BRIDGE, name,
 					    mwt->u.revision);
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 340cb955af25..7d1f6d2da3f1 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1642,7 +1642,7 @@ ip_set_dump_do(struct sk_buff *skb, struct netlink_callback *cb)
 				goto next_set;
 			if (set->variant->uref)
 				set->variant->uref(set, cb, true);
-			/* fall through */
+			fallthrough;
 		default:
 			ret = set->variant->list(set, skb, cb);
 			if (!cb->args[IPSET_CB_ARG0])
diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 573cb4481481..e697a824b001 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -257,15 +257,15 @@ static unsigned int get_uint(struct bitstr *bs, int b)
 	case 4:
 		v |= *bs->cur++;
 		v <<= 8;
-		/* fall through */
+		fallthrough;
 	case 3:
 		v |= *bs->cur++;
 		v <<= 8;
-		/* fall through */
+		fallthrough;
 	case 2:
 		v |= *bs->cur++;
 		v <<= 8;
-		/* fall through */
+		fallthrough;
 	case 1:
 		v |= *bs->cur++;
 		break;
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index a0560d175a7f..95f79980348c 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -610,7 +610,7 @@ void nf_ct_netns_put(struct net *net, uint8_t nfproto)
 	switch (nfproto) {
 	case NFPROTO_BRIDGE:
 		nf_ct_netns_do_put(net, NFPROTO_BRIDGE);
-		/* fall through */
+		fallthrough;
 	case NFPROTO_INET:
 		nf_ct_netns_do_put(net, NFPROTO_IPV4);
 		nf_ct_netns_do_put(net, NFPROTO_IPV6);
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 1926fd56df56..6892e497781c 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -900,7 +900,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 				return -NF_REPEAT;
 			return NF_DROP;
 		}
-		/* Fall through */
+		fallthrough;
 	case TCP_CONNTRACK_IGNORE:
 		/* Ignored packets:
 		 *
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 6a26299cb064..a604f43e3e6b 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -60,7 +60,7 @@ print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
 			   ntohs(tuple->src.u.tcp.port),
 			   ntohs(tuple->dst.u.tcp.port));
 		break;
-	case IPPROTO_UDPLITE: /* fallthrough */
+	case IPPROTO_UDPLITE:
 	case IPPROTO_UDP:
 		seq_printf(s, "sport=%hu dport=%hu ",
 			   ntohs(tuple->src.u.udp.port),
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index bfc555fcbc72..c2f1bcb8f8e6 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -408,7 +408,7 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 	static const unsigned int max_attempts = 128;
 
 	switch (tuple->dst.protonum) {
-	case IPPROTO_ICMP: /* fallthrough */
+	case IPPROTO_ICMP:
 	case IPPROTO_ICMPV6:
 		/* id is same for either direction... */
 		keyptr = &tuple->src.u.icmp.id;
@@ -442,10 +442,10 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 		}
 		goto find_free_id;
 #endif
-	case IPPROTO_UDP:	/* fallthrough */
-	case IPPROTO_UDPLITE:	/* fallthrough */
-	case IPPROTO_TCP:	/* fallthrough */
-	case IPPROTO_SCTP:	/* fallthrough */
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+	case IPPROTO_TCP:
+	case IPPROTO_SCTP:
 	case IPPROTO_DCCP:	/* fallthrough */
 		if (maniptype == NF_NAT_MANIP_SRC)
 			keyptr = &tuple->src.u.all;
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index b9cbe1e2453e..e911635d9ccb 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -704,8 +704,7 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 		nf_ct_seqadj_init(ct, ctinfo, 0);
 		synproxy->tsoff = 0;
 		this_cpu_inc(snet->stats->conn_reopened);
-
-		/* fall through */
+		fallthrough;
 	case TCP_CONNTRACK_SYN_SENT:
 		if (!synproxy_parse_options(skb, thoff, th, &opts))
 			return NF_DROP;
@@ -1128,8 +1127,7 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 		nf_ct_seqadj_init(ct, ctinfo, 0);
 		synproxy->tsoff = 0;
 		this_cpu_inc(snet->stats->conn_reopened);
-
-		/* fall through */
+		fallthrough;
 	case TCP_CONNTRACK_SYN_SENT:
 		if (!synproxy_parse_options(skb, thoff, th, &opts))
 			return NF_DROP;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7647ecfa0d40..f4c2a37aae8e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4291,7 +4291,7 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 	case NFT_TRANS_ABORT:
 	case NFT_TRANS_RELEASE:
 		set->use--;
-		/* fall through */
+		fallthrough;
 	default:
 		nf_tables_unbind_set(ctx, set, binding,
 				     phase == NFT_TRANS_COMMIT);
@@ -6159,7 +6159,7 @@ void nf_tables_deactivate_flowtable(const struct nft_ctx *ctx,
 	case NFT_TRANS_ABORT:
 	case NFT_TRANS_RELEASE:
 		flowtable->use--;
-		/* fall through */
+		fallthrough;
 	default:
 		return;
 	}
@@ -7165,7 +7165,7 @@ static int nf_tables_validate(struct net *net)
 		break;
 	case NFT_VALIDATE_NEED:
 		nft_validate_state_update(net, NFT_VALIDATE_DO);
-		/* fall through */
+		fallthrough;
 	case NFT_VALIDATE_DO:
 		list_for_each_entry(table, &net->nft.tables, list) {
 			if (nft_table_validate(net, table) < 0)
@@ -8234,7 +8234,7 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 		default:
 			return -EINVAL;
 		}
-		/* fall through */
+		fallthrough;
 	case NFT_CONTINUE:
 	case NFT_BREAK:
 	case NFT_RETURN:
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 96c74c4c7176..587897a2498b 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -213,7 +213,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		jumpstack[stackptr].chain = chain;
 		jumpstack[stackptr].rules = rules + 1;
 		stackptr++;
-		/* fall through */
+		fallthrough;
 	case NFT_GOTO:
 		nft_trace_packet(&info, chain, rule,
 				 NFT_TRACETYPE_RULE);
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index da915c224a82..89a381f7f945 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -451,7 +451,7 @@ static int cttimeout_default_get(struct net *net, struct sock *ctnl,
 	case IPPROTO_TCP:
 		timeouts = nf_tcp_pernet(net)->timeouts;
 		break;
-	case IPPROTO_UDP: /* fallthrough */
+	case IPPROTO_UDP:
 	case IPPROTO_UDPLITE:
 		timeouts = nf_udp_pernet(net)->timeouts;
 		break;
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 8a28c127effc..16f4d84599ac 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -43,7 +43,7 @@ void nft_cmp_eval(const struct nft_expr *expr,
 	case NFT_CMP_LT:
 		if (d == 0)
 			goto mismatch;
-		/* fall through */
+		fallthrough;
 	case NFT_CMP_LTE:
 		if (d > 0)
 			goto mismatch;
@@ -51,7 +51,7 @@ void nft_cmp_eval(const struct nft_expr *expr,
 	case NFT_CMP_GT:
 		if (d == 0)
 			goto mismatch;
-		/* fall through */
+		fallthrough;
 	case NFT_CMP_GTE:
 		if (d < 0)
 			goto mismatch;
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index faea72c2df32..8b65be8a29e3 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -129,7 +129,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		return;
 	}
 #endif
-	case NFT_CT_BYTES: /* fallthrough */
+	case NFT_CT_BYTES:
 	case NFT_CT_PKTS: {
 		const struct nf_conn_acct *acct = nf_conn_acct_find(ct);
 		u64 count = 0;
@@ -1013,7 +1013,7 @@ static int nft_ct_helper_obj_init(const struct nft_ctx *ctx,
 		help6 = nf_conntrack_helper_try_module_get(name, family,
 							   priv->l4proto);
 		break;
-	case NFPROTO_NETDEV: /* fallthrough */
+	case NFPROTO_NETDEV:
 	case NFPROTO_BRIDGE: /* same */
 	case NFPROTO_INET:
 		help4 = nf_conntrack_helper_try_module_get(name, NFPROTO_IPV4,
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index cfac0964f48d..4dfdaeaf09a5 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -32,7 +32,7 @@ int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	unsigned int hooks;
 
 	switch (priv->result) {
-	case NFT_FIB_RESULT_OIF: /* fallthrough */
+	case NFT_FIB_RESULT_OIF:
 	case NFT_FIB_RESULT_OIFNAME:
 		hooks = (1 << NF_INET_PRE_ROUTING);
 		break;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index a7de3a58f553..ed7cb9f747f6 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -467,7 +467,7 @@ static int nft_payload_l4csum_offset(const struct nft_pktinfo *pkt,
 	case IPPROTO_UDP:
 		if (!nft_payload_udp_checksum(skb, pkt->xt.thoff))
 			return -1;
-		/* Fall through. */
+		fallthrough;
 	case IPPROTO_UDPLITE:
 		*l4csum_offset = offsetof(struct udphdr, check);
 		break;
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 51b454d8fa9c..cedf47ab3c6f 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -25,7 +25,7 @@ __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	case CHECKSUM_NONE:
 		if (protocol != IPPROTO_TCP && protocol != IPPROTO_UDP)
 			skb->csum = 0;
@@ -51,7 +51,7 @@ static __sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
 	case CHECKSUM_COMPLETE:
 		if (len == skb->len - dataoff)
 			return nf_ip_checksum(skb, hook, dataoff, protocol);
-		/* fall through */
+		fallthrough;
 	case CHECKSUM_NONE:
 		skb->csum = csum_tcpudp_nofold(iph->saddr, iph->daddr, protocol,
 					       skb->len - dataoff, 0);
@@ -79,7 +79,7 @@ __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	case CHECKSUM_NONE:
 		skb->csum = ~csum_unfold(
 				csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
@@ -106,7 +106,7 @@ static __sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
 	case CHECKSUM_COMPLETE:
 		if (len == skb->len - dataoff)
 			return nf_ip6_checksum(skb, hook, dataoff, protocol);
-		/* fall through */
+		fallthrough;
 	case CHECKSUM_NONE:
 		hsum = skb_checksum(skb, 0, dataoff, 0);
 		skb->csum = ~csum_unfold(csum_ipv6_magic(&ip6h->saddr,
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 99a468be4a59..8b2daccaf8df 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1571,7 +1571,7 @@ static void *xt_mttg_seq_next(struct seq_file *seq, void *v, loff_t *ppos,
 		trav->curr = trav->curr->next;
 		if (trav->curr != trav->head)
 			break;
-		/* fall through */
+		fallthrough;
 	default:
 		return NULL;
 	}

