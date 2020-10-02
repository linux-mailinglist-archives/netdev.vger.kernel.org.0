Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9070D281E97
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgJBWoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:44:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbgJBWoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:44:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601678676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L7v4r8GvjE2awxXMg7y7oMnjHrshCEZlOFHniQl3LiE=;
        b=F6iRadgMQI8fpoVtCIJOru42oAqOTsE9ys41uelm5wGjUqNLWhY+g5F2PF1kOgQ0qld4tA
        5fdzzfdB2gRY2w9jOe3i6tQJV8ZmCR2JXTJtTMfhWQRECgUlnVzBVvUsH69trY13cGeJmc
        d8MhQPE5QmF4DFttFLYEAXvQ4a5Srp4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-A_1fduF_PZCGBXtcTbJEEw-1; Fri, 02 Oct 2020 18:44:32 -0400
X-MC-Unique: A_1fduF_PZCGBXtcTbJEEw-1
Received: by mail-wm1-f71.google.com with SMTP id d197so856585wmd.4
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 15:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L7v4r8GvjE2awxXMg7y7oMnjHrshCEZlOFHniQl3LiE=;
        b=lZ2MRjygHl5GFUW06EE9TnZkJD6sE/hhXu9gwl6zf9P6m5X+60cncDoC7pMmlRk+tu
         R+YkVMwFKWurIJsuS/XLef185qYAA6FnZVQB8Olxn+Ra938feJWpYho/Y+sT21Sp/DTl
         7EYmxnti5O9moA/ZJnCwcpORQ3q+RLnpSQnr64W20IZ5taeW438ap4k/A35m9LoBsEuy
         SmVexOVYU8uUa+D21KyTJdV6Wr5i1gLxHO/1YKFlvjaXuMakWWi2eRHReIX1N4S3awMZ
         nWiHEdrOJsdeiafdXzJAVxocOE25dm930veOHEL7L+YiPUwKnM9NjBdwATS8bWXY34NN
         CM6A==
X-Gm-Message-State: AOAM530YcHBtwJH90/m+CWnU22dBVUn5mXcoB3ZbZYewXRomDdYBcv2J
        ncKzlNnR2Oev46e2pQBz552l3OLO2ORM/LAhZ2lZKBJ8oGC3hCMcSvZqumvcZfZE4n8n2+/Ej46
        j3BiJrx7Ts57hFqSp
X-Received: by 2002:adf:ec92:: with SMTP id z18mr5666362wrn.53.1601678671108;
        Fri, 02 Oct 2020 15:44:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTnmHV+bEzgjnJYAcigNmcAU7ZoUBIuba9i8cJ5oygY9FCdK8L3bYG60eQPRykwjI/0bCpeQ==
X-Received: by 2002:adf:ec92:: with SMTP id z18mr5666335wrn.53.1601678670799;
        Fri, 02 Oct 2020 15:44:30 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id 92sm3360023wra.19.2020.10.02.15.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 15:44:30 -0700 (PDT)
Date:   Sat, 3 Oct 2020 00:44:28 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Benc <jbenc@redhat.com>,
        Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net-next 1/2] net/sched: act_vlan: Add {POP,PUSH}_ETH actions
Message-ID: <cf7838b37483913bb782e104c5b7e4801c409729.1601673174.git.gnault@redhat.com>
References: <cover.1601673174.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1601673174.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement TCA_VLAN_ACT_POP_ETH and TCA_VLAN_ACT_PUSH_ETH, to
respectively pop and push a base Ethernet header at the beginning of a
frame.

POP_ETH is just a matter of pulling ETH_HLEN bytes. VLAN tags, if any,
must be stripped before calling POP_ETH.

PUSH_ETH is restricted to skbs with no mac_header, and only the MAC
addresses can be configured. The Ethertype is automatically set from
skb->protocol. These restrictions ensure that all skb's fields remain
consistent, so that this action can't confuse other part of the
networking stack (like GSO).

Since openvswitch already had these actions, consolidate the code in
skbuff.c (like for vlan and mpls push/pop).

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/linux/skbuff.h              |  3 ++
 include/net/tc_act/tc_vlan.h        |  2 +
 include/uapi/linux/tc_act/tc_vlan.h |  4 ++
 net/core/skbuff.c                   | 67 +++++++++++++++++++++++++++++
 net/openvswitch/actions.c           | 28 +++++-------
 net/sched/act_vlan.c                | 40 +++++++++++++++++
 6 files changed, 126 insertions(+), 18 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3d0cf3722bb4..42131e325e27 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3573,6 +3573,9 @@ int skb_ensure_writable(struct sk_buff *skb, int write_len);
 int __skb_vlan_pop(struct sk_buff *skb, u16 *vlan_tci);
 int skb_vlan_pop(struct sk_buff *skb);
 int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci);
+int skb_eth_pop(struct sk_buff *skb);
+int skb_eth_push(struct sk_buff *skb, const unsigned char *dst,
+		 const unsigned char *src);
 int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
 		  int mac_len, bool ethernet);
 int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
diff --git a/include/net/tc_act/tc_vlan.h b/include/net/tc_act/tc_vlan.h
index 4e2502408c31..f051046ba034 100644
--- a/include/net/tc_act/tc_vlan.h
+++ b/include/net/tc_act/tc_vlan.h
@@ -11,6 +11,8 @@
 
 struct tcf_vlan_params {
 	int               tcfv_action;
+	unsigned char     tcfv_push_dst[ETH_ALEN];
+	unsigned char     tcfv_push_src[ETH_ALEN];
 	u16               tcfv_push_vid;
 	__be16            tcfv_push_proto;
 	u8                tcfv_push_prio;
diff --git a/include/uapi/linux/tc_act/tc_vlan.h b/include/uapi/linux/tc_act/tc_vlan.h
index 168995b54a70..5b306fe815cc 100644
--- a/include/uapi/linux/tc_act/tc_vlan.h
+++ b/include/uapi/linux/tc_act/tc_vlan.h
@@ -16,6 +16,8 @@
 #define TCA_VLAN_ACT_POP	1
 #define TCA_VLAN_ACT_PUSH	2
 #define TCA_VLAN_ACT_MODIFY	3
+#define TCA_VLAN_ACT_POP_ETH	4
+#define TCA_VLAN_ACT_PUSH_ETH	5
 
 struct tc_vlan {
 	tc_gen;
@@ -30,6 +32,8 @@ enum {
 	TCA_VLAN_PUSH_VLAN_PROTOCOL,
 	TCA_VLAN_PAD,
 	TCA_VLAN_PUSH_VLAN_PRIORITY,
+	TCA_VLAN_PUSH_ETH_DST,
+	TCA_VLAN_PUSH_ETH_SRC,
 	__TCA_VLAN_MAX,
 };
 #define TCA_VLAN_MAX (__TCA_VLAN_MAX - 1)
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e0774471f56d..75b043accddb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5558,6 +5558,73 @@ int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci)
 }
 EXPORT_SYMBOL(skb_vlan_push);
 
+/**
+ * skb_eth_pop() - Drop the Ethernet header at the head of a packet
+ *
+ * @skb: Socket buffer to modify
+ *
+ * Drop the Ethernet header of @skb.
+ *
+ * Expects that skb->data points to the mac header and that no VLAN tags are
+ * present.
+ *
+ * Returns 0 on success, -errno otherwise.
+ */
+int skb_eth_pop(struct sk_buff *skb)
+{
+	if (!pskb_may_pull(skb, ETH_HLEN) || skb_vlan_tagged(skb) ||
+	    skb_network_offset(skb) < ETH_HLEN)
+		return -EPROTO;
+
+	skb_pull_rcsum(skb, ETH_HLEN);
+	skb_reset_mac_header(skb);
+	skb_reset_mac_len(skb);
+
+	return 0;
+}
+EXPORT_SYMBOL(skb_eth_pop);
+
+/**
+ * skb_eth_push() - Add a new Ethernet header at the head of a packet
+ *
+ * @skb: Socket buffer to modify
+ * @dst: Destination MAC address of the new header
+ * @src: Source MAC address of the new header
+ *
+ * Prepend @skb with a new Ethernet header.
+ *
+ * Expects that skb->data points to the mac header, which must be empty.
+ *
+ * Returns 0 on success, -errno otherwise.
+ */
+int skb_eth_push(struct sk_buff *skb, const unsigned char *dst,
+		 const unsigned char *src)
+{
+	struct ethhdr *eth;
+	int err;
+
+	if (skb_network_offset(skb) || skb_vlan_tag_present(skb))
+		return -EPROTO;
+
+	err = skb_cow_head(skb, sizeof(*eth));
+	if (err < 0)
+		return err;
+
+	skb_push(skb, sizeof(*eth));
+	skb_reset_mac_header(skb);
+	skb_reset_mac_len(skb);
+
+	eth = eth_hdr(skb);
+	ether_addr_copy(eth->h_dest, dst);
+	ether_addr_copy(eth->h_source, src);
+	eth->h_proto = skb->protocol;
+
+	skb_postpush_rcsum(skb, eth, sizeof(*eth));
+
+	return 0;
+}
+EXPORT_SYMBOL(skb_eth_push);
+
 /* Update the ethertype of hdr and the skb csum value if required. */
 static void skb_mod_eth_type(struct sk_buff *skb, struct ethhdr *hdr,
 			     __be16 ethertype)
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 855f2c155956..b87bfc82f44f 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -277,9 +277,11 @@ static int set_eth_addr(struct sk_buff *skb, struct sw_flow_key *flow_key,
  */
 static int pop_eth(struct sk_buff *skb, struct sw_flow_key *key)
 {
-	skb_pull_rcsum(skb, ETH_HLEN);
-	skb_reset_mac_header(skb);
-	skb_reset_mac_len(skb);
+	int err;
+
+	err = skb_eth_pop(skb);
+	if (err)
+		return err;
 
 	/* safe right before invalidate_flow_key */
 	key->mac_proto = MAC_PROTO_NONE;
@@ -290,22 +292,12 @@ static int pop_eth(struct sk_buff *skb, struct sw_flow_key *key)
 static int push_eth(struct sk_buff *skb, struct sw_flow_key *key,
 		    const struct ovs_action_push_eth *ethh)
 {
-	struct ethhdr *hdr;
-
-	/* Add the new Ethernet header */
-	if (skb_cow_head(skb, ETH_HLEN) < 0)
-		return -ENOMEM;
-
-	skb_push(skb, ETH_HLEN);
-	skb_reset_mac_header(skb);
-	skb_reset_mac_len(skb);
-
-	hdr = eth_hdr(skb);
-	ether_addr_copy(hdr->h_source, ethh->addresses.eth_src);
-	ether_addr_copy(hdr->h_dest, ethh->addresses.eth_dst);
-	hdr->h_proto = skb->protocol;
+	int err;
 
-	skb_postpush_rcsum(skb, hdr, ETH_HLEN);
+	err = skb_eth_push(skb, ethh->addresses.eth_dst,
+			   ethh->addresses.eth_src);
+	if (err)
+		return err;
 
 	/* safe right before invalidate_flow_key */
 	key->mac_proto = MAC_PROTO_ETHERNET;
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index a5ff9f68ab02..8758bd2a78fa 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -77,6 +77,16 @@ static int tcf_vlan_act(struct sk_buff *skb, const struct tc_action *a,
 		/* put updated tci as hwaccel tag */
 		__vlan_hwaccel_put_tag(skb, p->tcfv_push_proto, tci);
 		break;
+	case TCA_VLAN_ACT_POP_ETH:
+		err = skb_eth_pop(skb);
+		if (err)
+			goto drop;
+		break;
+	case TCA_VLAN_ACT_PUSH_ETH:
+		err = skb_eth_push(skb, p->tcfv_push_dst, p->tcfv_push_src);
+		if (err)
+			goto drop;
+		break;
 	default:
 		BUG();
 	}
@@ -93,10 +103,13 @@ static int tcf_vlan_act(struct sk_buff *skb, const struct tc_action *a,
 }
 
 static const struct nla_policy vlan_policy[TCA_VLAN_MAX + 1] = {
+	[TCA_VLAN_UNSPEC]		= { .strict_start_type = TCA_VLAN_PUSH_ETH_DST },
 	[TCA_VLAN_PARMS]		= { .len = sizeof(struct tc_vlan) },
 	[TCA_VLAN_PUSH_VLAN_ID]		= { .type = NLA_U16 },
 	[TCA_VLAN_PUSH_VLAN_PROTOCOL]	= { .type = NLA_U16 },
 	[TCA_VLAN_PUSH_VLAN_PRIORITY]	= { .type = NLA_U8 },
+	[TCA_VLAN_PUSH_ETH_DST]		= NLA_POLICY_ETH_ADDR,
+	[TCA_VLAN_PUSH_ETH_SRC]		= NLA_POLICY_ETH_ADDR,
 };
 
 static int tcf_vlan_init(struct net *net, struct nlattr *nla,
@@ -179,6 +192,17 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 		if (tb[TCA_VLAN_PUSH_VLAN_PRIORITY])
 			push_prio = nla_get_u8(tb[TCA_VLAN_PUSH_VLAN_PRIORITY]);
 		break;
+	case TCA_VLAN_ACT_POP_ETH:
+		break;
+	case TCA_VLAN_ACT_PUSH_ETH:
+		if (!tb[TCA_VLAN_PUSH_ETH_DST] || !tb[TCA_VLAN_PUSH_ETH_SRC]) {
+			if (exists)
+				tcf_idr_release(*a, bind);
+			else
+				tcf_idr_cleanup(tn, index);
+			return -EINVAL;
+		}
+		break;
 	default:
 		if (exists)
 			tcf_idr_release(*a, bind);
@@ -219,6 +243,13 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 	p->tcfv_push_prio = push_prio;
 	p->tcfv_push_proto = push_proto;
 
+	if (action == TCA_VLAN_ACT_PUSH_ETH) {
+		nla_memcpy(&p->tcfv_push_dst, tb[TCA_VLAN_PUSH_ETH_DST],
+			   ETH_ALEN);
+		nla_memcpy(&p->tcfv_push_src, tb[TCA_VLAN_PUSH_ETH_SRC],
+			   ETH_ALEN);
+	}
+
 	spin_lock_bh(&v->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 	p = rcu_replace_pointer(v->vlan_p, p, lockdep_is_held(&v->tcf_lock));
@@ -279,6 +310,15 @@ static int tcf_vlan_dump(struct sk_buff *skb, struct tc_action *a,
 					      p->tcfv_push_prio))))
 		goto nla_put_failure;
 
+	if (p->tcfv_action == TCA_VLAN_ACT_PUSH_ETH) {
+		if (nla_put(skb, TCA_VLAN_PUSH_ETH_DST, ETH_ALEN,
+			    p->tcfv_push_dst))
+			goto nla_put_failure;
+		if (nla_put(skb, TCA_VLAN_PUSH_ETH_SRC, ETH_ALEN,
+			    p->tcfv_push_src))
+			goto nla_put_failure;
+	}
+
 	tcf_tm_dump(&t, &v->tcf_tm);
 	if (nla_put_64bit(skb, TCA_VLAN_TM, sizeof(t), &t, TCA_VLAN_PAD))
 		goto nla_put_failure;
-- 
2.21.3

