Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3098B84E78
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 16:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388235AbfHGORZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 10:17:25 -0400
Received: from kadath.azazel.net ([81.187.231.250]:46008 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729814AbfHGORK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 10:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cLHb+2/E+/0zX7gVGsE92ZZ3sBmljvhN6XZT4HL39Kg=; b=Nia3m4s/37Dhjt0IZX3jA/A+dN
        adk16jOkTnKDRqLOkuiunI1g9OjN0XZ1sZYx8wbZy+e27S2l+GichYmyRKWMcBSPpTskex83QQsIH
        FBWBZB9t2ZN9kB3xpeZlyYZ/2gXDJ5DEMQS/IqITDVWsP6fHjFvf6KHbs9nKiFLUM+99r/WkQULhJ
        EbyhIQ5Eh8/Kw/x9qHuULYDDd1ni5KEc1XdoY1f9UypimjLBwIEhylb+F3BFp9g9sjWIMRX/Y2Lja
        F5dGlhRKiwEQjgY8j64HOcmCun3w2FLfEwd/DUojH1UA7RA74NmPplGXBtH5+wVF4r8HYDFXRKlOA
        NLxOLyYQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hvMkV-0001Wc-2c; Wed, 07 Aug 2019 15:17:07 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Net Dev <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH net-next v1 6/8] netfilter: added missing IS_ENABLED(CONFIG_NETFILTER) checks to some header-files.
Date:   Wed,  7 Aug 2019 15:17:03 +0100
Message-Id: <20190807141705.4864-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190807141705.4864-1-jeremy@azazel.net>
References: <20190722201615.GE23346@azazel.net>
 <20190807141705.4864-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

linux/netfilter.h defines a number of struct and inline function
definitions which are only available is CONFIG_NETFILTER is enabled.
These structs and functions are used in declarations and definitions in
other header-files.  Added preprocessor checks to make sure these
headers will compile if CONFIG_NETFILTER is disabled.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/x_tables.h           | 6 ++++++
 include/linux/netfilter_arp/arp_tables.h     | 2 ++
 include/linux/netfilter_bridge/ebtables.h    | 2 ++
 include/linux/netfilter_ipv4/ip_tables.h     | 4 ++++
 include/linux/netfilter_ipv6/ip6_tables.h    | 2 ++
 include/net/netfilter/br_netfilter.h         | 2 ++
 include/net/netfilter/nf_conntrack_bridge.h  | 2 ++
 include/net/netfilter/nf_conntrack_core.h    | 3 +++
 include/net/netfilter/nf_conntrack_l4proto.h | 2 ++
 include/net/netfilter/nf_conntrack_tuple.h   | 2 ++
 include/net/netfilter/nf_flow_table.h        | 4 ++++
 include/net/netfilter/nf_nat.h               | 4 ++++
 include/net/netfilter/nf_queue.h             | 5 +++++
 include/net/netfilter/nf_synproxy.h          | 4 ++++
 include/net/netfilter/nf_tables.h            | 8 ++++++++
 15 files changed, 52 insertions(+)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 1f852ef7b098..ae62bf1c6824 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -35,12 +35,15 @@ struct xt_action_param {
 	union {
 		const void *matchinfo, *targinfo;
 	};
+#if IS_ENABLED(CONFIG_NETFILTER)
 	const struct nf_hook_state *state;
+#endif
 	int fragoff;
 	unsigned int thoff;
 	bool hotdrop;
 };
 
+#if IS_ENABLED(CONFIG_NETFILTER)
 static inline struct net *xt_net(const struct xt_action_param *par)
 {
 	return par->state->net;
@@ -75,6 +78,7 @@ static inline u_int8_t xt_family(const struct xt_action_param *par)
 {
 	return par->state->pf;
 }
+#endif
 
 /**
  * struct xt_mtchk_param - parameters for match extensions'
@@ -446,7 +450,9 @@ xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
 	return cnt;
 }
 
+#if IS_ENABLED(CONFIG_NETFILTER)
 struct nf_hook_ops *xt_hook_ops_alloc(const struct xt_table *, nf_hookfn *);
+#endif
 
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index e98028f00e47..1b7b35bb9c27 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -49,6 +49,7 @@ struct arpt_error {
 }
 
 extern void *arpt_alloc_initial_table(const struct xt_table *);
+#if IS_ENABLED(CONFIG_NETFILTER)
 int arpt_register_table(struct net *net, const struct xt_table *table,
 			const struct arpt_replace *repl,
 			const struct nf_hook_ops *ops, struct xt_table **res);
@@ -57,6 +58,7 @@ void arpt_unregister_table(struct net *net, struct xt_table *table,
 extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
 				  struct xt_table *table);
+#endif
 
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index c6935be7c6ca..b5b2d371f0ef 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -105,6 +105,7 @@ struct ebt_table {
 
 #define EBT_ALIGN(s) (((s) + (__alignof__(struct _xt_align)-1)) & \
 		     ~(__alignof__(struct _xt_align)-1))
+#if IS_ENABLED(CONFIG_NETFILTER)
 extern int ebt_register_table(struct net *net,
 			      const struct ebt_table *table,
 			      const struct nf_hook_ops *ops,
@@ -114,6 +115,7 @@ extern void ebt_unregister_table(struct net *net, struct ebt_table *table,
 extern unsigned int ebt_do_table(struct sk_buff *skb,
 				 const struct nf_hook_state *state,
 				 struct ebt_table *table);
+#endif
 
 /* True if the hook mask denotes that the rule is in a base chain,
  * used in the check() functions */
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index d026e63a5aa4..f40a65481df4 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -25,11 +25,13 @@
 
 extern void ipt_init(void) __init;
 
+#if IS_ENABLED(CONFIG_NETFILTER)
 int ipt_register_table(struct net *net, const struct xt_table *table,
 		       const struct ipt_replace *repl,
 		       const struct nf_hook_ops *ops, struct xt_table **res);
 void ipt_unregister_table(struct net *net, struct xt_table *table,
 			  const struct nf_hook_ops *ops);
+#endif
 
 /* Standard entry. */
 struct ipt_standard {
@@ -65,9 +67,11 @@ struct ipt_error {
 }
 
 extern void *ipt_alloc_initial_table(const struct xt_table *);
+#if IS_ENABLED(CONFIG_NETFILTER)
 extern unsigned int ipt_do_table(struct sk_buff *skb,
 				 const struct nf_hook_state *state,
 				 struct xt_table *table);
+#endif
 
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 99cbfd3add40..53b7309613bf 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -26,6 +26,7 @@
 extern void ip6t_init(void) __init;
 
 extern void *ip6t_alloc_initial_table(const struct xt_table *);
+#if IS_ENABLED(CONFIG_NETFILTER)
 int ip6t_register_table(struct net *net, const struct xt_table *table,
 			const struct ip6t_replace *repl,
 			const struct nf_hook_ops *ops, struct xt_table **res);
@@ -34,6 +35,7 @@ void ip6t_unregister_table(struct net *net, struct xt_table *table,
 extern unsigned int ip6t_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
 				  struct xt_table *table);
+#endif
 
 /* Check for an extension */
 static inline int
diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index 33533ea852a1..2a613c84d49f 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -55,6 +55,7 @@ static inline struct rtable *bridge_parent_rtable(const struct net_device *dev)
 struct net_device *setup_pre_routing(struct sk_buff *skb,
 				     const struct net *net);
 
+#if IS_ENABLED(CONFIG_NETFILTER)
 #if IS_ENABLED(CONFIG_IPV6)
 int br_validate_ipv6(struct net *net, struct sk_buff *skb);
 unsigned int br_nf_pre_routing_ipv6(void *priv,
@@ -73,5 +74,6 @@ br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops, struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 #endif
+#endif
 
 #endif /* _BR_NETFILTER_H_ */
diff --git a/include/net/netfilter/nf_conntrack_bridge.h b/include/net/netfilter/nf_conntrack_bridge.h
index 8f2e5b2ab523..34c28f248b18 100644
--- a/include/net/netfilter/nf_conntrack_bridge.h
+++ b/include/net/netfilter/nf_conntrack_bridge.h
@@ -6,7 +6,9 @@
 #include <uapi/linux/if_ether.h>
 
 struct nf_ct_bridge_info {
+#if IS_ENABLED(CONFIG_NETFILTER)
 	struct nf_hook_ops	*ops;
+#endif
 	unsigned int		ops_size;
 	struct module		*me;
 };
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index de10faf2ce91..71a2d9cb64ea 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -20,7 +20,10 @@
 /* This header is used to share core functionality between the
    standalone connection tracking module, and the compatibility layer's use
    of connection tracking. */
+
+#if IS_ENABLED(CONFIG_NETFILTER)
 unsigned int nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state);
+#endif
 
 int nf_conntrack_init_net(struct net *net);
 void nf_conntrack_cleanup_net(struct net *net);
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 1990d54bf8f2..c200b95d27ae 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -75,6 +75,7 @@ bool nf_conntrack_invert_icmp_tuple(struct nf_conntrack_tuple *tuple,
 bool nf_conntrack_invert_icmpv6_tuple(struct nf_conntrack_tuple *tuple,
 				      const struct nf_conntrack_tuple *orig);
 
+#if IS_ENABLED(CONFIG_NETFILTER)
 int nf_conntrack_inet_error(struct nf_conn *tmpl, struct sk_buff *skb,
 			    unsigned int dataoff,
 			    const struct nf_hook_state *state,
@@ -131,6 +132,7 @@ int nf_conntrack_gre_packet(struct nf_conn *ct,
 			    unsigned int dataoff,
 			    enum ip_conntrack_info ctinfo,
 			    const struct nf_hook_state *state);
+#endif
 
 void nf_conntrack_generic_init_net(struct net *net);
 void nf_conntrack_tcp_init_net(struct net *net);
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index bf0444e111a6..480c87b44a96 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -121,6 +121,7 @@ struct nf_conntrack_tuple_hash {
 	struct nf_conntrack_tuple tuple;
 };
 
+#if IS_ENABLED(CONFIG_NETFILTER)
 static inline bool __nf_ct_tuple_src_equal(const struct nf_conntrack_tuple *t1,
 					   const struct nf_conntrack_tuple *t2)
 { 
@@ -183,5 +184,6 @@ nf_ct_tuple_mask_cmp(const struct nf_conntrack_tuple *t,
 	return nf_ct_tuple_src_mask_cmp(t, tuple, mask) &&
 	       __nf_ct_tuple_dst_equal(t, tuple);
 }
+#endif
 
 #endif /* _NF_CONNTRACK_TUPLE_H */
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 7249e331bd0b..609df33b1209 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -17,7 +17,9 @@ struct nf_flowtable_type {
 	int				family;
 	int				(*init)(struct nf_flowtable *ft);
 	void				(*free)(struct nf_flowtable *ft);
+#if IS_ENABLED(CONFIG_NETFILTER)
 	nf_hookfn			*hook;
+#endif
 	struct module			*owner;
 };
 
@@ -115,10 +117,12 @@ struct flow_ports {
 	__be16 source, dest;
 };
 
+#if IS_ENABLED(CONFIG_NETFILTER)
 unsigned int nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 				     const struct nf_hook_state *state);
 unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				       const struct nf_hook_state *state);
+#endif
 
 #define MODULE_ALIAS_NF_FLOWTABLE(family)	\
 	MODULE_ALIAS("nf-flowtable-" __stringify(family))
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 423cda2c6542..eec208fb9c23 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -69,10 +69,12 @@ static inline bool nf_nat_oif_changed(unsigned int hooknum,
 #endif
 }
 
+#if IS_ENABLED(CONFIG_NETFILTER)
 int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		       const struct nf_hook_ops *nat_ops, unsigned int ops_count);
 void nf_nat_unregister_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 			  unsigned int ops_count);
+#endif
 
 unsigned int nf_nat_packet(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 			   unsigned int hooknum, struct sk_buff *skb);
@@ -92,6 +94,7 @@ int nf_nat_icmpv6_reply_translation(struct sk_buff *skb, struct nf_conn *ct,
 				    enum ip_conntrack_info ctinfo,
 				    unsigned int hooknum, unsigned int hdrlen);
 
+#if IS_ENABLED(CONFIG_NETFILTER)
 int nf_nat_ipv4_register_fn(struct net *net, const struct nf_hook_ops *ops);
 void nf_nat_ipv4_unregister_fn(struct net *net, const struct nf_hook_ops *ops);
 
@@ -104,6 +107,7 @@ void nf_nat_inet_unregister_fn(struct net *net, const struct nf_hook_ops *ops);
 unsigned int
 nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state);
+#endif
 
 int nf_xfrm_me_harder(struct net *n, struct sk_buff *s, unsigned int family);
 
diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 359b80b43169..80edb46a1bbc 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -15,7 +15,9 @@ struct nf_queue_entry {
 	unsigned int		id;
 	unsigned int		hook_index;	/* index in hook_entries->hook[] */
 
+#if IS_ENABLED(CONFIG_NETFILTER)
 	struct nf_hook_state	state;
+#endif
 	u16			size; /* sizeof(entry) + saved route keys */
 
 	/* extra space to store route keys */
@@ -121,6 +123,9 @@ nfqueue_hash(const struct sk_buff *skb, u16 queue, u16 queues_total, u8 family,
 	return queue;
 }
 
+#if IS_ENABLED(CONFIG_NETFILTER)
 int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
 	     unsigned int index, unsigned int verdict);
+#endif
+
 #endif /* _NF_QUEUE_H */
diff --git a/include/net/netfilter/nf_synproxy.h b/include/net/netfilter/nf_synproxy.h
index 87d73fb5279d..dc420b47e3aa 100644
--- a/include/net/netfilter/nf_synproxy.h
+++ b/include/net/netfilter/nf_synproxy.h
@@ -20,8 +20,10 @@ bool synproxy_recv_client_ack(struct net *net,
 			      const struct tcphdr *th,
 			      struct synproxy_options *opts, u32 recv_seq);
 
+#if IS_ENABLED(CONFIG_NETFILTER)
 unsigned int ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 				const struct nf_hook_state *nhs);
+#endif
 int nf_synproxy_ipv4_init(struct synproxy_net *snet, struct net *net);
 void nf_synproxy_ipv4_fini(struct synproxy_net *snet, struct net *net);
 
@@ -35,8 +37,10 @@ bool synproxy_recv_client_ack_ipv6(struct net *net, const struct sk_buff *skb,
 				   const struct tcphdr *th,
 				   struct synproxy_options *opts, u32 recv_seq);
 
+#if IS_ENABLED(CONFIG_NETFILTER)
 unsigned int ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 				const struct nf_hook_state *nhs);
+#endif
 int nf_synproxy_ipv6_init(struct synproxy_net *snet, struct net *net);
 void nf_synproxy_ipv6_fini(struct synproxy_net *snet, struct net *net);
 #else
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 66edf76301d3..dc301e3d6739 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -25,6 +25,7 @@ struct nft_pktinfo {
 	struct xt_action_param		xt;
 };
 
+#if IS_ENABLED(CONFIG_NETFILTER)
 static inline struct net *nft_net(const struct nft_pktinfo *pkt)
 {
 	return pkt->xt.state->net;
@@ -57,6 +58,7 @@ static inline void nft_set_pktinfo(struct nft_pktinfo *pkt,
 	pkt->skb = skb;
 	pkt->xt.state = state;
 }
+#endif
 
 static inline void nft_set_pktinfo_unspec(struct nft_pktinfo *pkt,
 					  struct sk_buff *skb)
@@ -927,9 +929,11 @@ struct nft_chain_type {
 	int				family;
 	struct module			*owner;
 	unsigned int			hook_mask;
+#if IS_ENABLED(CONFIG_NETFILTER)
 	nf_hookfn			*hooks[NF_MAX_HOOKS];
 	int				(*ops_register)(struct net *net, const struct nf_hook_ops *ops);
 	void				(*ops_unregister)(struct net *net, const struct nf_hook_ops *ops);
+#endif
 };
 
 int nft_chain_validate_dependency(const struct nft_chain *chain,
@@ -955,7 +959,9 @@ struct nft_stats {
  *	@flow_block: flow block (for hardware offload)
  */
 struct nft_base_chain {
+#if IS_ENABLED(CONFIG_NETFILTER)
 	struct nf_hook_ops		ops;
+#endif
 	const struct nft_chain_type	*type;
 	u8				policy;
 	u8				flags;
@@ -1152,7 +1158,9 @@ struct nft_flowtable {
 					use:30;
 	u64				handle;
 	/* runtime data below here */
+#if IS_ENABLED(CONFIG_NETFILTER)
 	struct nf_hook_ops		*ops ____cacheline_aligned;
+#endif
 	struct nf_flowtable		data;
 };
 
-- 
2.20.1

