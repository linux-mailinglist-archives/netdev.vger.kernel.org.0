Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D46FCE5A40
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfJZLrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:47:48 -0400
Received: from correo.us.es ([193.147.175.20]:46406 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbfJZLrs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4F3D18C3C5E
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39B5EB8017
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:40 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2F213B8011; Sat, 26 Oct 2019 13:47:40 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A3DCB7FFE;
        Sat, 26 Oct 2019 13:47:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2889442EE393;
        Sat, 26 Oct 2019 13:47:37 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 02/31] netfilter: ipset: remove inline from static functions in .c files.
Date:   Sat, 26 Oct 2019 13:47:04 +0200
Message-Id: <20191026114733.28111-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

The inline function-specifier should not be used for static functions
defined in .c files since it bloats the kernel.  Instead leave the
compiler to decide which functions to inline.

While a couple of the files affected (ip_set_*_gen.h) are technically
headers, they contain templates for generating the common parts of
particular set-types and so we treat them like .c files.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h      |  2 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c       | 14 +++++++-------
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    | 18 +++++++++---------
 net/netfilter/ipset/ip_set_bitmap_port.c     | 14 +++++++-------
 net/netfilter/ipset/ip_set_core.c            | 20 ++++++++++----------
 net/netfilter/ipset/ip_set_hash_gen.h        |  4 ++--
 net/netfilter/ipset/ip_set_hash_ip.c         | 10 +++++-----
 net/netfilter/ipset/ip_set_hash_ipmac.c      |  8 ++++----
 net/netfilter/ipset/ip_set_hash_ipmark.c     |  8 ++++----
 net/netfilter/ipset/ip_set_hash_ipport.c     |  8 ++++----
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  8 ++++----
 net/netfilter/ipset/ip_set_hash_ipportnet.c  | 24 ++++++++++++------------
 net/netfilter/ipset/ip_set_hash_mac.c        |  6 +++---
 net/netfilter/ipset/ip_set_hash_net.c        | 24 ++++++++++++------------
 net/netfilter/ipset/ip_set_hash_netiface.c   | 24 ++++++++++++------------
 net/netfilter/ipset/ip_set_hash_netnet.c     | 28 ++++++++++++++--------------
 net/netfilter/ipset/ip_set_hash_netport.c    | 24 ++++++++++++------------
 net/netfilter/ipset/ip_set_hash_netportnet.c | 28 ++++++++++++++--------------
 net/netfilter/ipset/ip_set_list_set.c        |  4 ++--
 19 files changed, 138 insertions(+), 138 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 063df74b4647..1abd6f0dc227 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -192,7 +192,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 }
 
 #ifndef IP_SET_BITMAP_STORED_TIMEOUT
-static inline bool
+static bool
 mtype_is_filled(const struct mtype_elem *x)
 {
 	return true;
diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index 11ff9d4a7006..c06172d5b017 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -55,7 +55,7 @@ struct bitmap_ip_adt_elem {
 	u16 id;
 };
 
-static inline u32
+static u32
 ip_to_id(const struct bitmap_ip *m, u32 ip)
 {
 	return ((ip & ip_set_hostmask(m->netmask)) - m->first_ip) / m->hosts;
@@ -63,33 +63,33 @@ ip_to_id(const struct bitmap_ip *m, u32 ip)
 
 /* Common functions */
 
-static inline int
+static int
 bitmap_ip_do_test(const struct bitmap_ip_adt_elem *e,
 		  struct bitmap_ip *map, size_t dsize)
 {
 	return !!test_bit(e->id, map->members);
 }
 
-static inline int
+static int
 bitmap_ip_gc_test(u16 id, const struct bitmap_ip *map, size_t dsize)
 {
 	return !!test_bit(id, map->members);
 }
 
-static inline int
+static int
 bitmap_ip_do_add(const struct bitmap_ip_adt_elem *e, struct bitmap_ip *map,
 		 u32 flags, size_t dsize)
 {
 	return !!test_bit(e->id, map->members);
 }
 
-static inline int
+static int
 bitmap_ip_do_del(const struct bitmap_ip_adt_elem *e, struct bitmap_ip *map)
 {
 	return !test_and_clear_bit(e->id, map->members);
 }
 
-static inline int
+static int
 bitmap_ip_do_list(struct sk_buff *skb, const struct bitmap_ip *map, u32 id,
 		  size_t dsize)
 {
@@ -97,7 +97,7 @@ bitmap_ip_do_list(struct sk_buff *skb, const struct bitmap_ip *map, u32 id,
 			htonl(map->first_ip + id * map->hosts));
 }
 
-static inline int
+static int
 bitmap_ip_do_head(struct sk_buff *skb, const struct bitmap_ip *map)
 {
 	return nla_put_ipaddr4(skb, IPSET_ATTR_IP, htonl(map->first_ip)) ||
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 1d4e63326e68..b618713297da 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -65,7 +65,7 @@ struct bitmap_ipmac_elem {
 	unsigned char filled;
 } __aligned(__alignof__(u64));
 
-static inline u32
+static u32
 ip_to_id(const struct bitmap_ipmac *m, u32 ip)
 {
 	return ip - m->first_ip;
@@ -79,7 +79,7 @@ ip_to_id(const struct bitmap_ipmac *m, u32 ip)
 
 /* Common functions */
 
-static inline int
+static int
 bitmap_ipmac_do_test(const struct bitmap_ipmac_adt_elem *e,
 		     const struct bitmap_ipmac *map, size_t dsize)
 {
@@ -94,7 +94,7 @@ bitmap_ipmac_do_test(const struct bitmap_ipmac_adt_elem *e,
 	return -EAGAIN;
 }
 
-static inline int
+static int
 bitmap_ipmac_gc_test(u16 id, const struct bitmap_ipmac *map, size_t dsize)
 {
 	const struct bitmap_ipmac_elem *elem;
@@ -106,13 +106,13 @@ bitmap_ipmac_gc_test(u16 id, const struct bitmap_ipmac *map, size_t dsize)
 	return elem->filled == MAC_FILLED;
 }
 
-static inline int
+static int
 bitmap_ipmac_is_filled(const struct bitmap_ipmac_elem *elem)
 {
 	return elem->filled == MAC_FILLED;
 }
 
-static inline int
+static int
 bitmap_ipmac_add_timeout(unsigned long *timeout,
 			 const struct bitmap_ipmac_adt_elem *e,
 			 const struct ip_set_ext *ext, struct ip_set *set,
@@ -139,7 +139,7 @@ bitmap_ipmac_add_timeout(unsigned long *timeout,
 	return 0;
 }
 
-static inline int
+static int
 bitmap_ipmac_do_add(const struct bitmap_ipmac_adt_elem *e,
 		    struct bitmap_ipmac *map, u32 flags, size_t dsize)
 {
@@ -177,14 +177,14 @@ bitmap_ipmac_do_add(const struct bitmap_ipmac_adt_elem *e,
 	return IPSET_ADD_STORE_PLAIN_TIMEOUT;
 }
 
-static inline int
+static int
 bitmap_ipmac_do_del(const struct bitmap_ipmac_adt_elem *e,
 		    struct bitmap_ipmac *map)
 {
 	return !test_and_clear_bit(e->id, map->members);
 }
 
-static inline int
+static int
 bitmap_ipmac_do_list(struct sk_buff *skb, const struct bitmap_ipmac *map,
 		     u32 id, size_t dsize)
 {
@@ -197,7 +197,7 @@ bitmap_ipmac_do_list(struct sk_buff *skb, const struct bitmap_ipmac *map,
 		nla_put(skb, IPSET_ATTR_ETHER, ETH_ALEN, elem->ether));
 }
 
-static inline int
+static int
 bitmap_ipmac_do_head(struct sk_buff *skb, const struct bitmap_ipmac *map)
 {
 	return nla_put_ipaddr4(skb, IPSET_ATTR_IP, htonl(map->first_ip)) ||
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index 704a0dda1609..72fede25469d 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -46,7 +46,7 @@ struct bitmap_port_adt_elem {
 	u16 id;
 };
 
-static inline u16
+static u16
 port_to_id(const struct bitmap_port *m, u16 port)
 {
 	return port - m->first_port;
@@ -54,34 +54,34 @@ port_to_id(const struct bitmap_port *m, u16 port)
 
 /* Common functions */
 
-static inline int
+static int
 bitmap_port_do_test(const struct bitmap_port_adt_elem *e,
 		    const struct bitmap_port *map, size_t dsize)
 {
 	return !!test_bit(e->id, map->members);
 }
 
-static inline int
+static int
 bitmap_port_gc_test(u16 id, const struct bitmap_port *map, size_t dsize)
 {
 	return !!test_bit(id, map->members);
 }
 
-static inline int
+static int
 bitmap_port_do_add(const struct bitmap_port_adt_elem *e,
 		   struct bitmap_port *map, u32 flags, size_t dsize)
 {
 	return !!test_bit(e->id, map->members);
 }
 
-static inline int
+static int
 bitmap_port_do_del(const struct bitmap_port_adt_elem *e,
 		   struct bitmap_port *map)
 {
 	return !test_and_clear_bit(e->id, map->members);
 }
 
-static inline int
+static int
 bitmap_port_do_list(struct sk_buff *skb, const struct bitmap_port *map, u32 id,
 		    size_t dsize)
 {
@@ -89,7 +89,7 @@ bitmap_port_do_list(struct sk_buff *skb, const struct bitmap_port *map, u32 id,
 			     htons(map->first_port + id));
 }
 
-static inline int
+static int
 bitmap_port_do_head(struct sk_buff *skb, const struct bitmap_port *map)
 {
 	return nla_put_net16(skb, IPSET_ATTR_PORT, htons(map->first_port)) ||
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index e64d5f9a89dd..04266295a750 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -35,7 +35,7 @@ struct ip_set_net {
 
 static unsigned int ip_set_net_id __read_mostly;
 
-static inline struct ip_set_net *ip_set_pernet(struct net *net)
+static struct ip_set_net *ip_set_pernet(struct net *net)
 {
 	return net_generic(net, ip_set_net_id);
 }
@@ -67,13 +67,13 @@ MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_IPSET);
  * serialized by ip_set_type_mutex.
  */
 
-static inline void
+static void
 ip_set_type_lock(void)
 {
 	mutex_lock(&ip_set_type_mutex);
 }
 
-static inline void
+static void
 ip_set_type_unlock(void)
 {
 	mutex_unlock(&ip_set_type_mutex);
@@ -277,7 +277,7 @@ ip_set_free(void *members)
 }
 EXPORT_SYMBOL_GPL(ip_set_free);
 
-static inline bool
+static bool
 flag_nested(const struct nlattr *nla)
 {
 	return nla->nla_type & NLA_F_NESTED;
@@ -356,7 +356,7 @@ const struct ip_set_ext_type ip_set_extensions[] = {
 };
 EXPORT_SYMBOL_GPL(ip_set_extensions);
 
-static inline bool
+static bool
 add_extension(enum ip_set_ext_id id, u32 flags, struct nlattr *tb[])
 {
 	return ip_set_extensions[id].flag ?
@@ -506,7 +506,7 @@ EXPORT_SYMBOL_GPL(ip_set_match_extensions);
  * The set behind an index may change by swapping only, from userspace.
  */
 
-static inline void
+static void
 __ip_set_get(struct ip_set *set)
 {
 	write_lock_bh(&ip_set_ref_lock);
@@ -514,7 +514,7 @@ __ip_set_get(struct ip_set *set)
 	write_unlock_bh(&ip_set_ref_lock);
 }
 
-static inline void
+static void
 __ip_set_put(struct ip_set *set)
 {
 	write_lock_bh(&ip_set_ref_lock);
@@ -526,7 +526,7 @@ __ip_set_put(struct ip_set *set)
 /* set->ref can be swapped out by ip_set_swap, netlink events (like dump) need
  * a separate reference counter
  */
-static inline void
+static void
 __ip_set_put_netlink(struct ip_set *set)
 {
 	write_lock_bh(&ip_set_ref_lock);
@@ -541,7 +541,7 @@ __ip_set_put_netlink(struct ip_set *set)
  * so it can't be destroyed (or changed) under our foot.
  */
 
-static inline struct ip_set *
+static struct ip_set *
 ip_set_rcu_get(struct net *net, ip_set_id_t index)
 {
 	struct ip_set *set;
@@ -670,7 +670,7 @@ EXPORT_SYMBOL_GPL(ip_set_get_byname);
  *
  */
 
-static inline void
+static void
 __ip_set_put_byindex(struct ip_set_net *inst, ip_set_id_t index)
 {
 	struct ip_set *set;
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index d098d87bc331..7480ce55b5c8 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -39,7 +39,7 @@
 #ifdef IP_SET_HASH_WITH_MULTI
 #define AHASH_MAX(h)			((h)->ahash_max)
 
-static inline u8
+static u8
 tune_ahash_max(u8 curr, u32 multi)
 {
 	u32 n;
@@ -909,7 +909,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	return ret;
 }
 
-static inline int
+static int
 mtype_data_match(struct mtype_elem *data, const struct ip_set_ext *ext,
 		 struct ip_set_ext *mext, struct ip_set *set, u32 flags)
 {
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index f4432d9fcad0..5d6d68eaf6a9 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -44,7 +44,7 @@ struct hash_ip4_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_ip4_data_equal(const struct hash_ip4_elem *e1,
 		    const struct hash_ip4_elem *e2,
 		    u32 *multi)
@@ -63,7 +63,7 @@ hash_ip4_data_list(struct sk_buff *skb, const struct hash_ip4_elem *e)
 	return true;
 }
 
-static inline void
+static void
 hash_ip4_data_next(struct hash_ip4_elem *next, const struct hash_ip4_elem *e)
 {
 	next->ip = e->ip;
@@ -171,7 +171,7 @@ struct hash_ip6_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_ip6_data_equal(const struct hash_ip6_elem *ip1,
 		    const struct hash_ip6_elem *ip2,
 		    u32 *multi)
@@ -179,7 +179,7 @@ hash_ip6_data_equal(const struct hash_ip6_elem *ip1,
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6);
 }
 
-static inline void
+static void
 hash_ip6_netmask(union nf_inet_addr *ip, u8 prefix)
 {
 	ip6_netmask(ip, prefix);
@@ -196,7 +196,7 @@ hash_ip6_data_list(struct sk_buff *skb, const struct hash_ip6_elem *e)
 	return true;
 }
 
-static inline void
+static void
 hash_ip6_data_next(struct hash_ip6_elem *next, const struct hash_ip6_elem *e)
 {
 }
diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index 24d8f4df4230..e28cd72db6ad 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -47,7 +47,7 @@ struct hash_ipmac4_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_ipmac4_data_equal(const struct hash_ipmac4_elem *e1,
 		       const struct hash_ipmac4_elem *e2,
 		       u32 *multi)
@@ -67,7 +67,7 @@ hash_ipmac4_data_list(struct sk_buff *skb, const struct hash_ipmac4_elem *e)
 	return true;
 }
 
-static inline void
+static void
 hash_ipmac4_data_next(struct hash_ipmac4_elem *next,
 		      const struct hash_ipmac4_elem *e)
 {
@@ -154,7 +154,7 @@ struct hash_ipmac6_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_ipmac6_data_equal(const struct hash_ipmac6_elem *e1,
 		       const struct hash_ipmac6_elem *e2,
 		       u32 *multi)
@@ -175,7 +175,7 @@ hash_ipmac6_data_list(struct sk_buff *skb, const struct hash_ipmac6_elem *e)
 	return true;
 }
 
-static inline void
+static void
 hash_ipmac6_data_next(struct hash_ipmac6_elem *next,
 		      const struct hash_ipmac6_elem *e)
 {
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index 7a1734aad0c5..aba1df617d6e 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -42,7 +42,7 @@ struct hash_ipmark4_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_ipmark4_data_equal(const struct hash_ipmark4_elem *ip1,
 			const struct hash_ipmark4_elem *ip2,
 			u32 *multi)
@@ -64,7 +64,7 @@ hash_ipmark4_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static inline void
+static void
 hash_ipmark4_data_next(struct hash_ipmark4_elem *next,
 		       const struct hash_ipmark4_elem *d)
 {
@@ -165,7 +165,7 @@ struct hash_ipmark6_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_ipmark6_data_equal(const struct hash_ipmark6_elem *ip1,
 			const struct hash_ipmark6_elem *ip2,
 			u32 *multi)
@@ -187,7 +187,7 @@ hash_ipmark6_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static inline void
+static void
 hash_ipmark6_data_next(struct hash_ipmark6_elem *next,
 		       const struct hash_ipmark6_elem *d)
 {
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 32e240658334..1ff228717e29 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -47,7 +47,7 @@ struct hash_ipport4_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_ipport4_data_equal(const struct hash_ipport4_elem *ip1,
 			const struct hash_ipport4_elem *ip2,
 			u32 *multi)
@@ -71,7 +71,7 @@ hash_ipport4_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static inline void
+static void
 hash_ipport4_data_next(struct hash_ipport4_elem *next,
 		       const struct hash_ipport4_elem *d)
 {
@@ -202,7 +202,7 @@ struct hash_ipport6_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_ipport6_data_equal(const struct hash_ipport6_elem *ip1,
 			const struct hash_ipport6_elem *ip2,
 			u32 *multi)
@@ -226,7 +226,7 @@ hash_ipport6_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static inline void
+static void
 hash_ipport6_data_next(struct hash_ipport6_elem *next,
 		       const struct hash_ipport6_elem *d)
 {
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index 15d419353179..fa88afd812fa 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -46,7 +46,7 @@ struct hash_ipportip4_elem {
 	u8 padding;
 };
 
-static inline bool
+static bool
 hash_ipportip4_data_equal(const struct hash_ipportip4_elem *ip1,
 			  const struct hash_ipportip4_elem *ip2,
 			  u32 *multi)
@@ -72,7 +72,7 @@ hash_ipportip4_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static inline void
+static void
 hash_ipportip4_data_next(struct hash_ipportip4_elem *next,
 			 const struct hash_ipportip4_elem *d)
 {
@@ -210,7 +210,7 @@ struct hash_ipportip6_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_ipportip6_data_equal(const struct hash_ipportip6_elem *ip1,
 			  const struct hash_ipportip6_elem *ip2,
 			  u32 *multi)
@@ -236,7 +236,7 @@ hash_ipportip6_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static inline void
+static void
 hash_ipportip6_data_next(struct hash_ipportip6_elem *next,
 			 const struct hash_ipportip6_elem *d)
 {
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 7a4d7afd4121..eef6ecfcb409 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -59,7 +59,7 @@ struct hash_ipportnet4_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_ipportnet4_data_equal(const struct hash_ipportnet4_elem *ip1,
 			   const struct hash_ipportnet4_elem *ip2,
 			   u32 *multi)
@@ -71,25 +71,25 @@ hash_ipportnet4_data_equal(const struct hash_ipportnet4_elem *ip1,
 	       ip1->proto == ip2->proto;
 }
 
-static inline int
+static int
 hash_ipportnet4_do_data_match(const struct hash_ipportnet4_elem *elem)
 {
 	return elem->nomatch ? -ENOTEMPTY : 1;
 }
 
-static inline void
+static void
 hash_ipportnet4_data_set_flags(struct hash_ipportnet4_elem *elem, u32 flags)
 {
 	elem->nomatch = !!((flags >> 16) & IPSET_FLAG_NOMATCH);
 }
 
-static inline void
+static void
 hash_ipportnet4_data_reset_flags(struct hash_ipportnet4_elem *elem, u8 *flags)
 {
 	swap(*flags, elem->nomatch);
 }
 
-static inline void
+static void
 hash_ipportnet4_data_netmask(struct hash_ipportnet4_elem *elem, u8 cidr)
 {
 	elem->ip2 &= ip_set_netmask(cidr);
@@ -116,7 +116,7 @@ hash_ipportnet4_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static inline void
+static void
 hash_ipportnet4_data_next(struct hash_ipportnet4_elem *next,
 			  const struct hash_ipportnet4_elem *d)
 {
@@ -308,7 +308,7 @@ struct hash_ipportnet6_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_ipportnet6_data_equal(const struct hash_ipportnet6_elem *ip1,
 			   const struct hash_ipportnet6_elem *ip2,
 			   u32 *multi)
@@ -320,25 +320,25 @@ hash_ipportnet6_data_equal(const struct hash_ipportnet6_elem *ip1,
 	       ip1->proto == ip2->proto;
 }
 
-static inline int
+static int
 hash_ipportnet6_do_data_match(const struct hash_ipportnet6_elem *elem)
 {
 	return elem->nomatch ? -ENOTEMPTY : 1;
 }
 
-static inline void
+static void
 hash_ipportnet6_data_set_flags(struct hash_ipportnet6_elem *elem, u32 flags)
 {
 	elem->nomatch = !!((flags >> 16) & IPSET_FLAG_NOMATCH);
 }
 
-static inline void
+static void
 hash_ipportnet6_data_reset_flags(struct hash_ipportnet6_elem *elem, u8 *flags)
 {
 	swap(*flags, elem->nomatch);
 }
 
-static inline void
+static void
 hash_ipportnet6_data_netmask(struct hash_ipportnet6_elem *elem, u8 cidr)
 {
 	ip6_netmask(&elem->ip2, cidr);
@@ -365,7 +365,7 @@ hash_ipportnet6_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static inline void
+static void
 hash_ipportnet6_data_next(struct hash_ipportnet6_elem *next,
 			  const struct hash_ipportnet6_elem *d)
 {
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
index d94c585d33c5..0b61593165ef 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -37,7 +37,7 @@ struct hash_mac4_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_mac4_data_equal(const struct hash_mac4_elem *e1,
 		     const struct hash_mac4_elem *e2,
 		     u32 *multi)
@@ -45,7 +45,7 @@ hash_mac4_data_equal(const struct hash_mac4_elem *e1,
 	return ether_addr_equal(e1->ether, e2->ether);
 }
 
-static inline bool
+static bool
 hash_mac4_data_list(struct sk_buff *skb, const struct hash_mac4_elem *e)
 {
 	if (nla_put(skb, IPSET_ATTR_ETHER, ETH_ALEN, e->ether))
@@ -56,7 +56,7 @@ hash_mac4_data_list(struct sk_buff *skb, const struct hash_mac4_elem *e)
 	return true;
 }
 
-static inline void
+static void
 hash_mac4_data_next(struct hash_mac4_elem *next,
 		    const struct hash_mac4_elem *e)
 {
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index c259cbc3ef45..86133fae4b69 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -47,7 +47,7 @@ struct hash_net4_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_net4_data_equal(const struct hash_net4_elem *ip1,
 		     const struct hash_net4_elem *ip2,
 		     u32 *multi)
@@ -56,25 +56,25 @@ hash_net4_data_equal(const struct hash_net4_elem *ip1,
 	       ip1->cidr == ip2->cidr;
 }
 
-static inline int
+static int
 hash_net4_do_data_match(const struct hash_net4_elem *elem)
 {
 	return elem->nomatch ? -ENOTEMPTY : 1;
 }
 
-static inline void
+static void
 hash_net4_data_set_flags(struct hash_net4_elem *elem, u32 flags)
 {
 	elem->nomatch = (flags >> 16) & IPSET_FLAG_NOMATCH;
 }
 
-static inline void
+static void
 hash_net4_data_reset_flags(struct hash_net4_elem *elem, u8 *flags)
 {
 	swap(*flags, elem->nomatch);
 }
 
-static inline void
+static void
 hash_net4_data_netmask(struct hash_net4_elem *elem, u8 cidr)
 {
 	elem->ip &= ip_set_netmask(cidr);
@@ -97,7 +97,7 @@ hash_net4_data_list(struct sk_buff *skb, const struct hash_net4_elem *data)
 	return true;
 }
 
-static inline void
+static void
 hash_net4_data_next(struct hash_net4_elem *next,
 		    const struct hash_net4_elem *d)
 {
@@ -212,7 +212,7 @@ struct hash_net6_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_net6_data_equal(const struct hash_net6_elem *ip1,
 		     const struct hash_net6_elem *ip2,
 		     u32 *multi)
@@ -221,25 +221,25 @@ hash_net6_data_equal(const struct hash_net6_elem *ip1,
 	       ip1->cidr == ip2->cidr;
 }
 
-static inline int
+static int
 hash_net6_do_data_match(const struct hash_net6_elem *elem)
 {
 	return elem->nomatch ? -ENOTEMPTY : 1;
 }
 
-static inline void
+static void
 hash_net6_data_set_flags(struct hash_net6_elem *elem, u32 flags)
 {
 	elem->nomatch = (flags >> 16) & IPSET_FLAG_NOMATCH;
 }
 
-static inline void
+static void
 hash_net6_data_reset_flags(struct hash_net6_elem *elem, u8 *flags)
 {
 	swap(*flags, elem->nomatch);
 }
 
-static inline void
+static void
 hash_net6_data_netmask(struct hash_net6_elem *elem, u8 cidr)
 {
 	ip6_netmask(&elem->ip, cidr);
@@ -262,7 +262,7 @@ hash_net6_data_list(struct sk_buff *skb, const struct hash_net6_elem *data)
 	return true;
 }
 
-static inline void
+static void
 hash_net6_data_next(struct hash_net6_elem *next,
 		    const struct hash_net6_elem *d)
 {
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 87b29f971226..1a04e0929738 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -62,7 +62,7 @@ struct hash_netiface4_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_netiface4_data_equal(const struct hash_netiface4_elem *ip1,
 			  const struct hash_netiface4_elem *ip2,
 			  u32 *multi)
@@ -74,25 +74,25 @@ hash_netiface4_data_equal(const struct hash_netiface4_elem *ip1,
 	       strcmp(ip1->iface, ip2->iface) == 0;
 }
 
-static inline int
+static int
 hash_netiface4_do_data_match(const struct hash_netiface4_elem *elem)
 {
 	return elem->nomatch ? -ENOTEMPTY : 1;
 }
 
-static inline void
+static void
 hash_netiface4_data_set_flags(struct hash_netiface4_elem *elem, u32 flags)
 {
 	elem->nomatch = (flags >> 16) & IPSET_FLAG_NOMATCH;
 }
 
-static inline void
+static void
 hash_netiface4_data_reset_flags(struct hash_netiface4_elem *elem, u8 *flags)
 {
 	swap(*flags, elem->nomatch);
 }
 
-static inline void
+static void
 hash_netiface4_data_netmask(struct hash_netiface4_elem *elem, u8 cidr)
 {
 	elem->ip &= ip_set_netmask(cidr);
@@ -119,7 +119,7 @@ hash_netiface4_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static inline void
+static void
 hash_netiface4_data_next(struct hash_netiface4_elem *next,
 			 const struct hash_netiface4_elem *d)
 {
@@ -285,7 +285,7 @@ struct hash_netiface6_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_netiface6_data_equal(const struct hash_netiface6_elem *ip1,
 			  const struct hash_netiface6_elem *ip2,
 			  u32 *multi)
@@ -297,25 +297,25 @@ hash_netiface6_data_equal(const struct hash_netiface6_elem *ip1,
 	       strcmp(ip1->iface, ip2->iface) == 0;
 }
 
-static inline int
+static int
 hash_netiface6_do_data_match(const struct hash_netiface6_elem *elem)
 {
 	return elem->nomatch ? -ENOTEMPTY : 1;
 }
 
-static inline void
+static void
 hash_netiface6_data_set_flags(struct hash_netiface6_elem *elem, u32 flags)
 {
 	elem->nomatch = (flags >> 16) & IPSET_FLAG_NOMATCH;
 }
 
-static inline void
+static void
 hash_netiface6_data_reset_flags(struct hash_netiface6_elem *elem, u8 *flags)
 {
 	swap(*flags, elem->nomatch);
 }
 
-static inline void
+static void
 hash_netiface6_data_netmask(struct hash_netiface6_elem *elem, u8 cidr)
 {
 	ip6_netmask(&elem->ip, cidr);
@@ -342,7 +342,7 @@ hash_netiface6_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static inline void
+static void
 hash_netiface6_data_next(struct hash_netiface6_elem *next,
 			 const struct hash_netiface6_elem *d)
 {
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index a3ae69bfee66..bcb6d0b4db36 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -52,7 +52,7 @@ struct hash_netnet4_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_netnet4_data_equal(const struct hash_netnet4_elem *ip1,
 			const struct hash_netnet4_elem *ip2,
 			u32 *multi)
@@ -61,32 +61,32 @@ hash_netnet4_data_equal(const struct hash_netnet4_elem *ip1,
 	       ip1->ccmp == ip2->ccmp;
 }
 
-static inline int
+static int
 hash_netnet4_do_data_match(const struct hash_netnet4_elem *elem)
 {
 	return elem->nomatch ? -ENOTEMPTY : 1;
 }
 
-static inline void
+static void
 hash_netnet4_data_set_flags(struct hash_netnet4_elem *elem, u32 flags)
 {
 	elem->nomatch = (flags >> 16) & IPSET_FLAG_NOMATCH;
 }
 
-static inline void
+static void
 hash_netnet4_data_reset_flags(struct hash_netnet4_elem *elem, u8 *flags)
 {
 	swap(*flags, elem->nomatch);
 }
 
-static inline void
+static void
 hash_netnet4_data_reset_elem(struct hash_netnet4_elem *elem,
 			     struct hash_netnet4_elem *orig)
 {
 	elem->ip[1] = orig->ip[1];
 }
 
-static inline void
+static void
 hash_netnet4_data_netmask(struct hash_netnet4_elem *elem, u8 cidr, bool inner)
 {
 	if (inner) {
@@ -117,7 +117,7 @@ hash_netnet4_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static inline void
+static void
 hash_netnet4_data_next(struct hash_netnet4_elem *next,
 		       const struct hash_netnet4_elem *d)
 {
@@ -282,7 +282,7 @@ struct hash_netnet6_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_netnet6_data_equal(const struct hash_netnet6_elem *ip1,
 			const struct hash_netnet6_elem *ip2,
 			u32 *multi)
@@ -292,32 +292,32 @@ hash_netnet6_data_equal(const struct hash_netnet6_elem *ip1,
 	       ip1->ccmp == ip2->ccmp;
 }
 
-static inline int
+static int
 hash_netnet6_do_data_match(const struct hash_netnet6_elem *elem)
 {
 	return elem->nomatch ? -ENOTEMPTY : 1;
 }
 
-static inline void
+static void
 hash_netnet6_data_set_flags(struct hash_netnet6_elem *elem, u32 flags)
 {
 	elem->nomatch = (flags >> 16) & IPSET_FLAG_NOMATCH;
 }
 
-static inline void
+static void
 hash_netnet6_data_reset_flags(struct hash_netnet6_elem *elem, u8 *flags)
 {
 	swap(*flags, elem->nomatch);
 }
 
-static inline void
+static void
 hash_netnet6_data_reset_elem(struct hash_netnet6_elem *elem,
 			     struct hash_netnet6_elem *orig)
 {
 	elem->ip[1] = orig->ip[1];
 }
 
-static inline void
+static void
 hash_netnet6_data_netmask(struct hash_netnet6_elem *elem, u8 cidr, bool inner)
 {
 	if (inner) {
@@ -348,7 +348,7 @@ hash_netnet6_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static inline void
+static void
 hash_netnet6_data_next(struct hash_netnet6_elem *next,
 		       const struct hash_netnet6_elem *d)
 {
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 799f2272cc65..34448df80fb9 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -57,7 +57,7 @@ struct hash_netport4_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_netport4_data_equal(const struct hash_netport4_elem *ip1,
 			 const struct hash_netport4_elem *ip2,
 			 u32 *multi)
@@ -68,25 +68,25 @@ hash_netport4_data_equal(const struct hash_netport4_elem *ip1,
 	       ip1->cidr == ip2->cidr;
 }
 
-static inline int
+static int
 hash_netport4_do_data_match(const struct hash_netport4_elem *elem)
 {
 	return elem->nomatch ? -ENOTEMPTY : 1;
 }
 
-static inline void
+static void
 hash_netport4_data_set_flags(struct hash_netport4_elem *elem, u32 flags)
 {
 	elem->nomatch = !!((flags >> 16) & IPSET_FLAG_NOMATCH);
 }
 
-static inline void
+static void
 hash_netport4_data_reset_flags(struct hash_netport4_elem *elem, u8 *flags)
 {
 	swap(*flags, elem->nomatch);
 }
 
-static inline void
+static void
 hash_netport4_data_netmask(struct hash_netport4_elem *elem, u8 cidr)
 {
 	elem->ip &= ip_set_netmask(cidr);
@@ -112,7 +112,7 @@ hash_netport4_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static inline void
+static void
 hash_netport4_data_next(struct hash_netport4_elem *next,
 			const struct hash_netport4_elem *d)
 {
@@ -270,7 +270,7 @@ struct hash_netport6_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_netport6_data_equal(const struct hash_netport6_elem *ip1,
 			 const struct hash_netport6_elem *ip2,
 			 u32 *multi)
@@ -281,25 +281,25 @@ hash_netport6_data_equal(const struct hash_netport6_elem *ip1,
 	       ip1->cidr == ip2->cidr;
 }
 
-static inline int
+static int
 hash_netport6_do_data_match(const struct hash_netport6_elem *elem)
 {
 	return elem->nomatch ? -ENOTEMPTY : 1;
 }
 
-static inline void
+static void
 hash_netport6_data_set_flags(struct hash_netport6_elem *elem, u32 flags)
 {
 	elem->nomatch = !!((flags >> 16) & IPSET_FLAG_NOMATCH);
 }
 
-static inline void
+static void
 hash_netport6_data_reset_flags(struct hash_netport6_elem *elem, u8 *flags)
 {
 	swap(*flags, elem->nomatch);
 }
 
-static inline void
+static void
 hash_netport6_data_netmask(struct hash_netport6_elem *elem, u8 cidr)
 {
 	ip6_netmask(&elem->ip, cidr);
@@ -325,7 +325,7 @@ hash_netport6_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static inline void
+static void
 hash_netport6_data_next(struct hash_netport6_elem *next,
 			const struct hash_netport6_elem *d)
 {
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index a82b70e8b9a6..934c1712cba8 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -56,7 +56,7 @@ struct hash_netportnet4_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_netportnet4_data_equal(const struct hash_netportnet4_elem *ip1,
 			    const struct hash_netportnet4_elem *ip2,
 			    u32 *multi)
@@ -67,32 +67,32 @@ hash_netportnet4_data_equal(const struct hash_netportnet4_elem *ip1,
 	       ip1->proto == ip2->proto;
 }
 
-static inline int
+static int
 hash_netportnet4_do_data_match(const struct hash_netportnet4_elem *elem)
 {
 	return elem->nomatch ? -ENOTEMPTY : 1;
 }
 
-static inline void
+static void
 hash_netportnet4_data_set_flags(struct hash_netportnet4_elem *elem, u32 flags)
 {
 	elem->nomatch = !!((flags >> 16) & IPSET_FLAG_NOMATCH);
 }
 
-static inline void
+static void
 hash_netportnet4_data_reset_flags(struct hash_netportnet4_elem *elem, u8 *flags)
 {
 	swap(*flags, elem->nomatch);
 }
 
-static inline void
+static void
 hash_netportnet4_data_reset_elem(struct hash_netportnet4_elem *elem,
 				 struct hash_netportnet4_elem *orig)
 {
 	elem->ip[1] = orig->ip[1];
 }
 
-static inline void
+static void
 hash_netportnet4_data_netmask(struct hash_netportnet4_elem *elem,
 			      u8 cidr, bool inner)
 {
@@ -126,7 +126,7 @@ hash_netportnet4_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static inline void
+static void
 hash_netportnet4_data_next(struct hash_netportnet4_elem *next,
 			   const struct hash_netportnet4_elem *d)
 {
@@ -331,7 +331,7 @@ struct hash_netportnet6_elem {
 
 /* Common functions */
 
-static inline bool
+static bool
 hash_netportnet6_data_equal(const struct hash_netportnet6_elem *ip1,
 			    const struct hash_netportnet6_elem *ip2,
 			    u32 *multi)
@@ -343,32 +343,32 @@ hash_netportnet6_data_equal(const struct hash_netportnet6_elem *ip1,
 	       ip1->proto == ip2->proto;
 }
 
-static inline int
+static int
 hash_netportnet6_do_data_match(const struct hash_netportnet6_elem *elem)
 {
 	return elem->nomatch ? -ENOTEMPTY : 1;
 }
 
-static inline void
+static void
 hash_netportnet6_data_set_flags(struct hash_netportnet6_elem *elem, u32 flags)
 {
 	elem->nomatch = !!((flags >> 16) & IPSET_FLAG_NOMATCH);
 }
 
-static inline void
+static void
 hash_netportnet6_data_reset_flags(struct hash_netportnet6_elem *elem, u8 *flags)
 {
 	swap(*flags, elem->nomatch);
 }
 
-static inline void
+static void
 hash_netportnet6_data_reset_elem(struct hash_netportnet6_elem *elem,
 				 struct hash_netportnet6_elem *orig)
 {
 	elem->ip[1] = orig->ip[1];
 }
 
-static inline void
+static void
 hash_netportnet6_data_netmask(struct hash_netportnet6_elem *elem,
 			      u8 cidr, bool inner)
 {
@@ -402,7 +402,7 @@ hash_netportnet6_data_list(struct sk_buff *skb,
 	return true;
 }
 
-static inline void
+static void
 hash_netportnet6_data_next(struct hash_netportnet6_elem *next,
 			   const struct hash_netportnet6_elem *d)
 {
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 67ac50104e6f..cd747c0962fd 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -149,7 +149,7 @@ __list_set_del_rcu(struct rcu_head * rcu)
 	kfree(e);
 }
 
-static inline void
+static void
 list_set_del(struct ip_set *set, struct set_elem *e)
 {
 	struct list_set *map = set->data;
@@ -160,7 +160,7 @@ list_set_del(struct ip_set *set, struct set_elem *e)
 	call_rcu(&e->rcu, __list_set_del_rcu);
 }
 
-static inline void
+static void
 list_set_replace(struct ip_set *set, struct set_elem *e, struct set_elem *old)
 {
 	struct list_set *map = set->data;
-- 
2.11.0

