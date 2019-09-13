Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78AC5B1C43
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388184AbfIMLbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:31:34 -0400
Received: from correo.us.es ([193.147.175.20]:42754 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388179AbfIMLbd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BFA874FFE25
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ABEDBA7E21
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9E221A7E26; Fri, 13 Sep 2019 13:31:27 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A867A7E23;
        Fri, 13 Sep 2019 13:31:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id EA5944265A5A;
        Fri, 13 Sep 2019 13:31:24 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 25/27] netfilter: remove CONFIG_NETFILTER checks from headers.
Date:   Fri, 13 Sep 2019 13:31:00 +0200
Message-Id: <20190913113102.15776-26-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

`struct nf_hook_ops`, `struct nf_hook_state` and the `nf_hookfn`
function typedef appear in function and struct declarations and
definitions in a number of netfilter headers.  The structs and typedef
themselves are defined by linux/netfilter.h but only when
CONFIG_NETFILTER is enabled.  Define them unconditionally and add
forward declarations in order to remove CONFIG_NETFILTER conditionals
from the other headers.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h                    | 2 +-
 include/linux/netfilter/x_tables.h           | 6 ------
 include/linux/netfilter_arp/arp_tables.h     | 2 --
 include/linux/netfilter_bridge/ebtables.h    | 3 +--
 include/linux/netfilter_ipv4/ip_tables.h     | 7 +------
 include/linux/netfilter_ipv6/ip6_tables.h    | 5 +----
 include/net/netfilter/br_netfilter.h         | 2 --
 include/net/netfilter/nf_conntrack_bridge.h  | 4 ++--
 include/net/netfilter/nf_conntrack_core.h    | 5 ++---
 include/net/netfilter/nf_conntrack_l4proto.h | 2 --
 include/net/netfilter/nf_conntrack_tuple.h   | 2 --
 include/net/netfilter/nf_flow_table.h        | 4 ----
 include/net/netfilter/nf_nat.h               | 4 ----
 include/net/netfilter/nf_queue.h             | 4 ----
 include/net/netfilter/nf_synproxy.h          | 6 ++----
 include/net/netfilter/nf_tables.h            | 8 --------
 16 files changed, 10 insertions(+), 56 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 754995d028e2..77ebb61faf48 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -15,7 +15,6 @@
 #include <linux/netdevice.h>
 #include <net/net_namespace.h>
 
-#ifdef CONFIG_NETFILTER
 static inline int NF_DROP_GETERR(int verdict)
 {
 	return -(verdict >> NF_VERDICT_QBITS);
@@ -118,6 +117,7 @@ struct nf_hook_entries {
 	 */
 };
 
+#ifdef CONFIG_NETFILTER
 static inline struct nf_hook_ops **nf_hook_entries_get_hook_ops(const struct nf_hook_entries *e)
 {
 	unsigned int n = e->num_hook_entries;
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index b9bc25f57c8e..1b261c51b3a3 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -35,15 +35,12 @@ struct xt_action_param {
 	union {
 		const void *matchinfo, *targinfo;
 	};
-#if IS_ENABLED(CONFIG_NETFILTER)
 	const struct nf_hook_state *state;
-#endif
 	int fragoff;
 	unsigned int thoff;
 	bool hotdrop;
 };
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 static inline struct net *xt_net(const struct xt_action_param *par)
 {
 	return par->state->net;
@@ -78,7 +75,6 @@ static inline u_int8_t xt_family(const struct xt_action_param *par)
 {
 	return par->state->pf;
 }
-#endif
 
 /**
  * struct xt_mtchk_param - parameters for match extensions'
@@ -450,9 +446,7 @@ xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
 	return cnt;
 }
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 struct nf_hook_ops *xt_hook_ops_alloc(const struct xt_table *, nf_hookfn *);
-#endif
 
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 1b7b35bb9c27..e98028f00e47 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -49,7 +49,6 @@ struct arpt_error {
 }
 
 extern void *arpt_alloc_initial_table(const struct xt_table *);
-#if IS_ENABLED(CONFIG_NETFILTER)
 int arpt_register_table(struct net *net, const struct xt_table *table,
 			const struct arpt_replace *repl,
 			const struct nf_hook_ops *ops, struct xt_table **res);
@@ -58,7 +57,6 @@ void arpt_unregister_table(struct net *net, struct xt_table *table,
 extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
 				  struct xt_table *table);
-#endif
 
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index b5b2d371f0ef..162f59d0d17a 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -105,7 +105,7 @@ struct ebt_table {
 
 #define EBT_ALIGN(s) (((s) + (__alignof__(struct _xt_align)-1)) & \
 		     ~(__alignof__(struct _xt_align)-1))
-#if IS_ENABLED(CONFIG_NETFILTER)
+
 extern int ebt_register_table(struct net *net,
 			      const struct ebt_table *table,
 			      const struct nf_hook_ops *ops,
@@ -115,7 +115,6 @@ extern void ebt_unregister_table(struct net *net, struct ebt_table *table,
 extern unsigned int ebt_do_table(struct sk_buff *skb,
 				 const struct nf_hook_state *state,
 				 struct ebt_table *table);
-#endif
 
 /* True if the hook mask denotes that the rule is in a base chain,
  * used in the check() functions */
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 0b0d43ad9ed9..e9e1ed74cdf1 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -17,19 +17,16 @@
 
 #include <linux/if.h>
 #include <linux/in.h>
+#include <linux/init.h>
 #include <linux/ip.h>
 #include <linux/skbuff.h>
-
-#include <linux/init.h>
 #include <uapi/linux/netfilter_ipv4/ip_tables.h>
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 int ipt_register_table(struct net *net, const struct xt_table *table,
 		       const struct ipt_replace *repl,
 		       const struct nf_hook_ops *ops, struct xt_table **res);
 void ipt_unregister_table(struct net *net, struct xt_table *table,
 			  const struct nf_hook_ops *ops);
-#endif
 
 /* Standard entry. */
 struct ipt_standard {
@@ -65,11 +62,9 @@ struct ipt_error {
 }
 
 extern void *ipt_alloc_initial_table(const struct xt_table *);
-#if IS_ENABLED(CONFIG_NETFILTER)
 extern unsigned int ipt_do_table(struct sk_buff *skb,
 				 const struct nf_hook_state *state,
 				 struct xt_table *table);
-#endif
 
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 3a0a2bd054cc..78ab959c4575 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -17,15 +17,13 @@
 
 #include <linux/if.h>
 #include <linux/in6.h>
+#include <linux/init.h>
 #include <linux/ipv6.h>
 #include <linux/skbuff.h>
-
-#include <linux/init.h>
 #include <uapi/linux/netfilter_ipv6/ip6_tables.h>
 
 extern void *ip6t_alloc_initial_table(const struct xt_table *);
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 int ip6t_register_table(struct net *net, const struct xt_table *table,
 			const struct ip6t_replace *repl,
 			const struct nf_hook_ops *ops, struct xt_table **res);
@@ -34,7 +32,6 @@ void ip6t_unregister_table(struct net *net, struct xt_table *table,
 extern unsigned int ip6t_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
 				  struct xt_table *table);
-#endif
 
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index c53909fd22cd..371696ec11b2 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -55,7 +55,6 @@ static inline struct rtable *bridge_parent_rtable(const struct net_device *dev)
 struct net_device *setup_pre_routing(struct sk_buff *skb,
 				     const struct net *net);
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 #if IS_ENABLED(CONFIG_IPV6)
 int br_validate_ipv6(struct net *net, struct sk_buff *skb);
 unsigned int br_nf_pre_routing_ipv6(void *priv,
@@ -74,6 +73,5 @@ br_nf_pre_routing_ipv6(void *priv, struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 #endif
-#endif
 
 #endif /* _BR_NETFILTER_H_ */
diff --git a/include/net/netfilter/nf_conntrack_bridge.h b/include/net/netfilter/nf_conntrack_bridge.h
index 01b62fd5efa2..c564281ede5e 100644
--- a/include/net/netfilter/nf_conntrack_bridge.h
+++ b/include/net/netfilter/nf_conntrack_bridge.h
@@ -5,10 +5,10 @@
 #include <linux/types.h>
 #include <uapi/linux/if_ether.h>
 
+struct nf_hook_ops;
+
 struct nf_ct_bridge_info {
-#if IS_ENABLED(CONFIG_NETFILTER)
 	struct nf_hook_ops	*ops;
-#endif
 	unsigned int		ops_size;
 	struct module		*me;
 };
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index d340886e012d..09f2efea0b97 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -22,9 +22,8 @@
    standalone connection tracking module, and the compatibility layer's use
    of connection tracking. */
 
-#if IS_ENABLED(CONFIG_NETFILTER)
-unsigned int nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state);
-#endif
+unsigned int nf_conntrack_in(struct sk_buff *skb,
+			     const struct nf_hook_state *state);
 
 int nf_conntrack_init_net(struct net *net);
 void nf_conntrack_cleanup_net(struct net *net);
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 97240f1a3f5f..4cad1f0a327a 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -75,7 +75,6 @@ bool nf_conntrack_invert_icmp_tuple(struct nf_conntrack_tuple *tuple,
 bool nf_conntrack_invert_icmpv6_tuple(struct nf_conntrack_tuple *tuple,
 				      const struct nf_conntrack_tuple *orig);
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 int nf_conntrack_inet_error(struct nf_conn *tmpl, struct sk_buff *skb,
 			    unsigned int dataoff,
 			    const struct nf_hook_state *state,
@@ -132,7 +131,6 @@ int nf_conntrack_gre_packet(struct nf_conn *ct,
 			    unsigned int dataoff,
 			    enum ip_conntrack_info ctinfo,
 			    const struct nf_hook_state *state);
-#endif
 
 void nf_conntrack_generic_init_net(struct net *net);
 void nf_conntrack_tcp_init_net(struct net *net);
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index 68ea9b932736..9334371c94e2 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -121,7 +121,6 @@ struct nf_conntrack_tuple_hash {
 	struct nf_conntrack_tuple tuple;
 };
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 static inline bool __nf_ct_tuple_src_equal(const struct nf_conntrack_tuple *t1,
 					   const struct nf_conntrack_tuple *t2)
 {
@@ -184,6 +183,5 @@ nf_ct_tuple_mask_cmp(const struct nf_conntrack_tuple *t,
 	return nf_ct_tuple_src_mask_cmp(t, tuple, mask) &&
 	       __nf_ct_tuple_dst_equal(t, tuple);
 }
-#endif
 
 #endif /* _NF_CONNTRACK_TUPLE_H */
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index d875be62cdf0..b37a7d608134 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -17,9 +17,7 @@ struct nf_flowtable_type {
 	int				family;
 	int				(*init)(struct nf_flowtable *ft);
 	void				(*free)(struct nf_flowtable *ft);
-#if IS_ENABLED(CONFIG_NETFILTER)
 	nf_hookfn			*hook;
-#endif
 	struct module			*owner;
 };
 
@@ -117,12 +115,10 @@ struct flow_ports {
 	__be16 source, dest;
 };
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 unsigned int nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 				     const struct nf_hook_state *state);
 unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				       const struct nf_hook_state *state);
-#endif
 
 #define MODULE_ALIAS_NF_FLOWTABLE(family)	\
 	MODULE_ALIAS("nf-flowtable-" __stringify(family))
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 362ff94fa6b0..0d412dd63707 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -68,12 +68,10 @@ static inline bool nf_nat_oif_changed(unsigned int hooknum,
 #endif
 }
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		       const struct nf_hook_ops *nat_ops, unsigned int ops_count);
 void nf_nat_unregister_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 			  unsigned int ops_count);
-#endif
 
 unsigned int nf_nat_packet(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 			   unsigned int hooknum, struct sk_buff *skb);
@@ -93,7 +91,6 @@ int nf_nat_icmpv6_reply_translation(struct sk_buff *skb, struct nf_conn *ct,
 				    enum ip_conntrack_info ctinfo,
 				    unsigned int hooknum, unsigned int hdrlen);
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 int nf_nat_ipv4_register_fn(struct net *net, const struct nf_hook_ops *ops);
 void nf_nat_ipv4_unregister_fn(struct net *net, const struct nf_hook_ops *ops);
 
@@ -106,7 +103,6 @@ void nf_nat_inet_unregister_fn(struct net *net, const struct nf_hook_ops *ops);
 unsigned int
 nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state);
-#endif
 
 int nf_xfrm_me_harder(struct net *n, struct sk_buff *s, unsigned int family);
 
diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 80edb46a1bbc..47088083667b 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -15,9 +15,7 @@ struct nf_queue_entry {
 	unsigned int		id;
 	unsigned int		hook_index;	/* index in hook_entries->hook[] */
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 	struct nf_hook_state	state;
-#endif
 	u16			size; /* sizeof(entry) + saved route keys */
 
 	/* extra space to store route keys */
@@ -123,9 +121,7 @@ nfqueue_hash(const struct sk_buff *skb, u16 queue, u16 queues_total, u8 family,
 	return queue;
 }
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
 	     unsigned int index, unsigned int verdict);
-#endif
 
 #endif /* _NF_QUEUE_H */
diff --git a/include/net/netfilter/nf_synproxy.h b/include/net/netfilter/nf_synproxy.h
index 19d1af7a0348..a336f9434e73 100644
--- a/include/net/netfilter/nf_synproxy.h
+++ b/include/net/netfilter/nf_synproxy.h
@@ -58,10 +58,10 @@ bool synproxy_recv_client_ack(struct net *net,
 			      const struct tcphdr *th,
 			      struct synproxy_options *opts, u32 recv_seq);
 
-#if IS_ENABLED(CONFIG_NETFILTER)
+struct nf_hook_state;
+
 unsigned int ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 				const struct nf_hook_state *nhs);
-#endif
 int nf_synproxy_ipv4_init(struct synproxy_net *snet, struct net *net);
 void nf_synproxy_ipv4_fini(struct synproxy_net *snet, struct net *net);
 
@@ -75,10 +75,8 @@ bool synproxy_recv_client_ack_ipv6(struct net *net, const struct sk_buff *skb,
 				   const struct tcphdr *th,
 				   struct synproxy_options *opts, u32 recv_seq);
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 unsigned int ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 				const struct nf_hook_state *nhs);
-#endif
 int nf_synproxy_ipv6_init(struct synproxy_net *snet, struct net *net);
 void nf_synproxy_ipv6_fini(struct synproxy_net *snet, struct net *net);
 #else
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3d9e66aa0139..2655e03dbe1b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -26,7 +26,6 @@ struct nft_pktinfo {
 	struct xt_action_param		xt;
 };
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 static inline struct net *nft_net(const struct nft_pktinfo *pkt)
 {
 	return pkt->xt.state->net;
@@ -59,7 +58,6 @@ static inline void nft_set_pktinfo(struct nft_pktinfo *pkt,
 	pkt->skb = skb;
 	pkt->xt.state = state;
 }
-#endif
 
 static inline void nft_set_pktinfo_unspec(struct nft_pktinfo *pkt,
 					  struct sk_buff *skb)
@@ -947,11 +945,9 @@ struct nft_chain_type {
 	int				family;
 	struct module			*owner;
 	unsigned int			hook_mask;
-#if IS_ENABLED(CONFIG_NETFILTER)
 	nf_hookfn			*hooks[NF_MAX_HOOKS];
 	int				(*ops_register)(struct net *net, const struct nf_hook_ops *ops);
 	void				(*ops_unregister)(struct net *net, const struct nf_hook_ops *ops);
-#endif
 };
 
 int nft_chain_validate_dependency(const struct nft_chain *chain,
@@ -977,9 +973,7 @@ struct nft_stats {
  *	@flow_block: flow block (for hardware offload)
  */
 struct nft_base_chain {
-#if IS_ENABLED(CONFIG_NETFILTER)
 	struct nf_hook_ops		ops;
-#endif
 	const struct nft_chain_type	*type;
 	u8				policy;
 	u8				flags;
@@ -1179,9 +1173,7 @@ struct nft_flowtable {
 					use:30;
 	u64				handle;
 	/* runtime data below here */
-#if IS_ENABLED(CONFIG_NETFILTER)
 	struct nf_hook_ops		*ops ____cacheline_aligned;
-#endif
 	struct nf_flowtable		data;
 };
 
-- 
2.11.0

