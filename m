Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F2C21405A
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 22:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgGCU1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 16:27:48 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50678 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726638AbgGCU1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 16:27:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593808064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qjFdI6gwi+WACg4Wj1dPXSQONSFYoYYjLYblfl+digA=;
        b=HnaXmMiAnmkNOFz+pLbH2+kSB6IeKtUF1QWfMmVLUuvq2mHH/a7l66WPX+PkS08m/VHsuf
        kVl939v757R87hWlfrq7gYqguC/6qUw3eok+wuRpmS5d4Zn7RM6Kun8JAF8wKN+lIxnGp/
        lXugZ1i25sT7iHjN27HnY9NZGKTnyMk=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-yEglk3ZoNkSHuYPpJGZIAQ-1; Fri, 03 Jul 2020 16:27:41 -0400
X-MC-Unique: yEglk3ZoNkSHuYPpJGZIAQ-1
Received: by mail-pg1-f198.google.com with SMTP id j9so20489895pgm.8
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 13:27:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qjFdI6gwi+WACg4Wj1dPXSQONSFYoYYjLYblfl+digA=;
        b=r25a4ohDGzSxAoPsfBsRsz5/4CJW2rJSKoMOp81ySrc0JS0yfuGC6fLRbQMQcKkgbU
         6FvfRDlyMq/oMFsIR4KKcnyyUttkdBxM4jtVIYbCmHDLdKTQSFBTXp1C/GmAtvgdZl1M
         PK1j7U5cqYkh8JmDRK1r31m9onCorRFWk2gasmd4HxCxWgRmyp6dO7Awy8RFF5e5J9hB
         ac6WYk6yBZDTB3bkmYbeKHtdvchG3fEcTdBeLn1DQRyzSJ/wuwYEiPuytT0ZN962Lfhb
         W1CfDpAsknKP+96XLapor9JuPzirgQp+kmi4XUuJV2J57kIEvDxWmpkkFRY0HVT3vJuV
         rzmA==
X-Gm-Message-State: AOAM5301RXxa2VcXwv1t0OdaGT0OLIIiPYPNN1pjSWwy78Kpwefya4ue
        bQe/Q+qTvsgd2/RPHgPkSl/B3JWe86wQ/zXkXI/0cWB4lffkUdUSA73bznDG4slxYlXgC5zsPRw
        yniPbjQlnRKQL5w8f
X-Received: by 2002:a17:90a:b781:: with SMTP id m1mr36980548pjr.14.1593808059071;
        Fri, 03 Jul 2020 13:27:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1ATBE7EypPvRFq8yRn0n7Bj1TQiEG6LjUf2mfuHXCK1xJzVOJA+/Bmj7JtKXMDNH9e0gNaw==
X-Received: by 2002:a17:90a:b781:: with SMTP id m1mr36980523pjr.14.1593808058741;
        Fri, 03 Jul 2020 13:27:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id m92sm12081848pje.13.2020.07.03.13.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 13:27:37 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D00151804A8; Fri,  3 Jul 2020 22:27:32 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     davem@davemloft.net
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        cake@lists.bufferbloat.net, Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Ilya Ponetayev <i.ponetaev@ndmsystems.com>
Subject: [PATCH net v3] sched: consistently handle layer3 header accesses in the presence of VLANs
Date:   Fri,  3 Jul 2020 22:26:43 +0200
Message-Id: <20200703202643.12919-1-toke@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a couple of places in net/sched/ that check skb->protocol and act
on the value there. However, in the presence of VLAN tags, the value stored
in skb->protocol can be inconsistent based on whether VLAN acceleration is
enabled. The commit quoted in the Fixes tag below fixed the users of
skb->protocol to use a helper that will always see the VLAN ethertype.

However, most of the callers don't actually handle the VLAN ethertype, but
expect to find the IP header type in the protocol field. This means that
things like changing the ECN field, or parsing diffserv values, stops
working if there's a VLAN tag, or if there are multiple nested VLAN
tags (QinQ).

To fix this, change the helper to take an argument that indicates whether
the caller wants to skip the VLAN tags or not. When skipping VLAN tags, we
make sure to skip all of them, so behaviour is consistent even in QinQ
mode.

To make the helper usable from the ECN code, move it to if_vlan.h instead
of pkt_sched.h.

v3:
- Remove empty lines
- Move vlan variable definitions inside loop in skb_protocol()
- Also use skb_protocol() helper in IP{,6}_ECN_decapsulate() and
  bpf_skb_ecn_set_ce()

v2:
- Use eth_type_vlan() helper in skb_protocol()
- Also fix code that reads skb->protocol directly
- Change a couple of 'if/else if' statements to switch constructs to avoid
  calling the helper twice

Reported-by: Ilya Ponetayev <i.ponetaev@ndmsystems.com>
Fixes: d8b9605d2697 ("net: sched: fix skb->protocol use in case of accelerated vlan path")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/if_vlan.h  | 28 ++++++++++++++++++++++++++++
 include/net/inet_ecn.h   | 25 +++++++++++++++++--------
 include/net/pkt_sched.h  | 11 -----------
 net/core/filter.c        | 10 +++++++---
 net/sched/act_connmark.c |  9 ++++++---
 net/sched/act_csum.c     |  2 +-
 net/sched/act_ct.c       |  9 ++++-----
 net/sched/act_ctinfo.c   |  9 ++++++---
 net/sched/act_mpls.c     |  2 +-
 net/sched/act_skbedit.c  |  2 +-
 net/sched/cls_api.c      |  2 +-
 net/sched/cls_flow.c     |  8 ++++----
 net/sched/cls_flower.c   |  2 +-
 net/sched/em_ipset.c     |  2 +-
 net/sched/em_ipt.c       |  2 +-
 net/sched/em_meta.c      |  2 +-
 net/sched/sch_cake.c     |  4 ++--
 net/sched/sch_dsmark.c   |  6 +++---
 net/sched/sch_teql.c     |  2 +-
 19 files changed, 86 insertions(+), 51 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index b05e855f1ddd..427a5b8597c2 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -308,6 +308,34 @@ static inline bool eth_type_vlan(__be16 ethertype)
 	}
 }
 
+/* A getter for the SKB protocol field which will handle VLAN tags consistently
+ * whether VLAN acceleration is enabled or not.
+ */
+static inline __be16 skb_protocol(const struct sk_buff *skb, bool skip_vlan)
+{
+	unsigned int offset = skb_mac_offset(skb) + sizeof(struct ethhdr);
+	__be16 proto = skb->protocol;
+
+	if (!skip_vlan)
+		/* VLAN acceleration strips the VLAN header from the skb and
+		 * moves it to skb->vlan_proto
+		 */
+		return skb_vlan_tag_present(skb) ? skb->vlan_proto : proto;
+
+	while (eth_type_vlan(proto)) {
+		struct vlan_hdr vhdr, *vh;
+
+		vh = skb_header_pointer(skb, offset, sizeof(vhdr), &vhdr);
+		if (!vh)
+			break;
+
+		proto = vh->h_vlan_encapsulated_proto;
+		offset += sizeof(vhdr);
+	}
+
+	return proto;
+}
+
 static inline bool vlan_hw_offload_capable(netdev_features_t features,
 					   __be16 proto)
 {
diff --git a/include/net/inet_ecn.h b/include/net/inet_ecn.h
index 0f0d1efe06dd..e1eaf1780288 100644
--- a/include/net/inet_ecn.h
+++ b/include/net/inet_ecn.h
@@ -4,6 +4,7 @@
 
 #include <linux/ip.h>
 #include <linux/skbuff.h>
+#include <linux/if_vlan.h>
 
 #include <net/inet_sock.h>
 #include <net/dsfield.h>
@@ -172,7 +173,7 @@ static inline void ipv6_copy_dscp(unsigned int dscp, struct ipv6hdr *inner)
 
 static inline int INET_ECN_set_ce(struct sk_buff *skb)
 {
-	switch (skb->protocol) {
+	switch (skb_protocol(skb, true)) {
 	case cpu_to_be16(ETH_P_IP):
 		if (skb_network_header(skb) + sizeof(struct iphdr) <=
 		    skb_tail_pointer(skb))
@@ -191,7 +192,7 @@ static inline int INET_ECN_set_ce(struct sk_buff *skb)
 
 static inline int INET_ECN_set_ect1(struct sk_buff *skb)
 {
-	switch (skb->protocol) {
+	switch (skb_protocol(skb, true)) {
 	case cpu_to_be16(ETH_P_IP):
 		if (skb_network_header(skb) + sizeof(struct iphdr) <=
 		    skb_tail_pointer(skb))
@@ -272,12 +273,16 @@ static inline int IP_ECN_decapsulate(const struct iphdr *oiph,
 {
 	__u8 inner;
 
-	if (skb->protocol == htons(ETH_P_IP))
+	switch (skb_protocol(skb, true)) {
+	case htons(ETH_P_IP):
 		inner = ip_hdr(skb)->tos;
-	else if (skb->protocol == htons(ETH_P_IPV6))
+		break;
+	case htons(ETH_P_IPV6):
 		inner = ipv6_get_dsfield(ipv6_hdr(skb));
-	else
+		break;
+	default:
 		return 0;
+	}
 
 	return INET_ECN_decapsulate(skb, oiph->tos, inner);
 }
@@ -287,12 +292,16 @@ static inline int IP6_ECN_decapsulate(const struct ipv6hdr *oipv6h,
 {
 	__u8 inner;
 
-	if (skb->protocol == htons(ETH_P_IP))
+	switch (skb_protocol(skb, true)) {
+	case htons(ETH_P_IP):
 		inner = ip_hdr(skb)->tos;
-	else if (skb->protocol == htons(ETH_P_IPV6))
+		break;
+	case htons(ETH_P_IPV6):
 		inner = ipv6_get_dsfield(ipv6_hdr(skb));
-	else
+		break;
+	default:
 		return 0;
+	}
 
 	return INET_ECN_decapsulate(skb, ipv6_get_dsfield(oipv6h), inner);
 }
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 9092e697059e..ac8c890a2657 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -136,17 +136,6 @@ static inline void qdisc_run(struct Qdisc *q)
 	}
 }
 
-static inline __be16 tc_skb_protocol(const struct sk_buff *skb)
-{
-	/* We need to take extra care in case the skb came via
-	 * vlan accelerated path. In that case, use skb->vlan_proto
-	 * as the original vlan header was already stripped.
-	 */
-	if (skb_vlan_tag_present(skb))
-		return skb->vlan_proto;
-	return skb->protocol;
-}
-
 /* Calculate maximal size of packet seen by hard_start_xmit
    routine of this device.
  */
diff --git a/net/core/filter.c b/net/core/filter.c
index 73395384afe2..82e1b5b06167 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5853,12 +5853,16 @@ BPF_CALL_1(bpf_skb_ecn_set_ce, struct sk_buff *, skb)
 {
 	unsigned int iphdr_len;
 
-	if (skb->protocol == cpu_to_be16(ETH_P_IP))
+	switch (skb_protocol(skb, true)) {
+	case cpu_to_be16(ETH_P_IP):
 		iphdr_len = sizeof(struct iphdr);
-	else if (skb->protocol == cpu_to_be16(ETH_P_IPV6))
+		break;
+	case cpu_to_be16(ETH_P_IPV6):
 		iphdr_len = sizeof(struct ipv6hdr);
-	else
+		break;
+	default:
 		return 0;
+	}
 
 	if (skb_headlen(skb) < iphdr_len)
 		return 0;
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 43a243081e7d..f901421b0634 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -43,17 +43,20 @@ static int tcf_connmark_act(struct sk_buff *skb, const struct tc_action *a,
 	tcf_lastuse_update(&ca->tcf_tm);
 	bstats_update(&ca->tcf_bstats, skb);
 
-	if (skb->protocol == htons(ETH_P_IP)) {
+	switch (skb_protocol(skb, true)) {
+	case htons(ETH_P_IP):
 		if (skb->len < sizeof(struct iphdr))
 			goto out;
 
 		proto = NFPROTO_IPV4;
-	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		break;
+	case htons(ETH_P_IPV6):
 		if (skb->len < sizeof(struct ipv6hdr))
 			goto out;
 
 		proto = NFPROTO_IPV6;
-	} else {
+		break;
+	default:
 		goto out;
 	}
 
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index cb8608f0a77a..c60674cf25c4 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -587,7 +587,7 @@ static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
 		goto drop;
 
 	update_flags = params->update_flags;
-	protocol = tc_skb_protocol(skb);
+	protocol = skb_protocol(skb, false);
 again:
 	switch (protocol) {
 	case cpu_to_be16(ETH_P_IP):
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index e9f3576cbf71..86ed02487467 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -624,7 +624,7 @@ static u8 tcf_ct_skb_nf_family(struct sk_buff *skb)
 {
 	u8 family = NFPROTO_UNSPEC;
 
-	switch (skb->protocol) {
+	switch (skb_protocol(skb, true)) {
 	case htons(ETH_P_IP):
 		family = NFPROTO_IPV4;
 		break;
@@ -748,6 +748,7 @@ static int ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 			  const struct nf_nat_range2 *range,
 			  enum nf_nat_manip_type maniptype)
 {
+	__be16 proto = skb_protocol(skb, true);
 	int hooknum, err = NF_ACCEPT;
 
 	/* See HOOK2MANIP(). */
@@ -759,14 +760,13 @@ static int ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 	switch (ctinfo) {
 	case IP_CT_RELATED:
 	case IP_CT_RELATED_REPLY:
-		if (skb->protocol == htons(ETH_P_IP) &&
+		if (proto == htons(ETH_P_IP) &&
 		    ip_hdr(skb)->protocol == IPPROTO_ICMP) {
 			if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
 							   hooknum))
 				err = NF_DROP;
 			goto out;
-		} else if (IS_ENABLED(CONFIG_IPV6) &&
-			   skb->protocol == htons(ETH_P_IPV6)) {
+		} else if (IS_ENABLED(CONFIG_IPV6) && proto == htons(ETH_P_IPV6)) {
 			__be16 frag_off;
 			u8 nexthdr = ipv6_hdr(skb)->nexthdr;
 			int hdrlen = ipv6_skip_exthdr(skb,
@@ -1550,4 +1550,3 @@ MODULE_AUTHOR("Yossi Kuperman <yossiku@mellanox.com>");
 MODULE_AUTHOR("Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>");
 MODULE_DESCRIPTION("Connection tracking action");
 MODULE_LICENSE("GPL v2");
-
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 19649623493b..b5042f3ea079 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -96,19 +96,22 @@ static int tcf_ctinfo_act(struct sk_buff *skb, const struct tc_action *a,
 	action = READ_ONCE(ca->tcf_action);
 
 	wlen = skb_network_offset(skb);
-	if (tc_skb_protocol(skb) == htons(ETH_P_IP)) {
+	switch (skb_protocol(skb, true)) {
+	case htons(ETH_P_IP):
 		wlen += sizeof(struct iphdr);
 		if (!pskb_may_pull(skb, wlen))
 			goto out;
 
 		proto = NFPROTO_IPV4;
-	} else if (tc_skb_protocol(skb) == htons(ETH_P_IPV6)) {
+		break;
+	case htons(ETH_P_IPV6):
 		wlen += sizeof(struct ipv6hdr);
 		if (!pskb_may_pull(skb, wlen))
 			goto out;
 
 		proto = NFPROTO_IPV6;
-	} else {
+		break;
+	default:
 		goto out;
 	}
 
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index be3f215cd027..8118e2640979 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -82,7 +82,7 @@ static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
 			goto drop;
 		break;
 	case TCA_MPLS_ACT_PUSH:
-		new_lse = tcf_mpls_get_lse(NULL, p, !eth_p_mpls(skb->protocol));
+		new_lse = tcf_mpls_get_lse(NULL, p, !eth_p_mpls(skb_protocol(skb, true)));
 		if (skb_mpls_push(skb, new_lse, p->tcfm_proto, mac_len,
 				  skb->dev && skb->dev->type == ARPHRD_ETHER))
 			goto drop;
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index b125b2be4467..b2b3faa57294 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -41,7 +41,7 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 	if (params->flags & SKBEDIT_F_INHERITDSFIELD) {
 		int wlen = skb_network_offset(skb);
 
-		switch (tc_skb_protocol(skb)) {
+		switch (skb_protocol(skb, true)) {
 		case htons(ETH_P_IP):
 			wlen += sizeof(struct iphdr);
 			if (!pskb_may_pull(skb, wlen))
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index faa78b7dd962..e62beec0d844 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1538,7 +1538,7 @@ static inline int __tcf_classify(struct sk_buff *skb,
 reclassify:
 #endif
 	for (; tp; tp = rcu_dereference_bh(tp->next)) {
-		__be16 protocol = tc_skb_protocol(skb);
+		__be16 protocol = skb_protocol(skb, false);
 		int err;
 
 		if (tp->protocol != protocol &&
diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index 80ae7b9fa90a..ab53a93b2f2b 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -80,7 +80,7 @@ static u32 flow_get_dst(const struct sk_buff *skb, const struct flow_keys *flow)
 	if (dst)
 		return ntohl(dst);
 
-	return addr_fold(skb_dst(skb)) ^ (__force u16) tc_skb_protocol(skb);
+	return addr_fold(skb_dst(skb)) ^ (__force u16)skb_protocol(skb, true);
 }
 
 static u32 flow_get_proto(const struct sk_buff *skb,
@@ -104,7 +104,7 @@ static u32 flow_get_proto_dst(const struct sk_buff *skb,
 	if (flow->ports.ports)
 		return ntohs(flow->ports.dst);
 
-	return addr_fold(skb_dst(skb)) ^ (__force u16) tc_skb_protocol(skb);
+	return addr_fold(skb_dst(skb)) ^ (__force u16)skb_protocol(skb, true);
 }
 
 static u32 flow_get_iif(const struct sk_buff *skb)
@@ -151,7 +151,7 @@ static u32 flow_get_nfct(const struct sk_buff *skb)
 static u32 flow_get_nfct_src(const struct sk_buff *skb,
 			     const struct flow_keys *flow)
 {
-	switch (tc_skb_protocol(skb)) {
+	switch (skb_protocol(skb, true)) {
 	case htons(ETH_P_IP):
 		return ntohl(CTTUPLE(skb, src.u3.ip));
 	case htons(ETH_P_IPV6):
@@ -164,7 +164,7 @@ static u32 flow_get_nfct_src(const struct sk_buff *skb,
 static u32 flow_get_nfct_dst(const struct sk_buff *skb,
 			     const struct flow_keys *flow)
 {
-	switch (tc_skb_protocol(skb)) {
+	switch (skb_protocol(skb, true)) {
 	case htons(ETH_P_IP):
 		return ntohl(CTTUPLE(skb, dst.u3.ip));
 	case htons(ETH_P_IPV6):
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index b2da37286082..e30bd969fc48 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -313,7 +313,7 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		/* skb_flow_dissect() does not set n_proto in case an unknown
 		 * protocol, so do it rather here.
 		 */
-		skb_key.basic.n_proto = skb->protocol;
+		skb_key.basic.n_proto = skb_protocol(skb, false);
 		skb_flow_dissect_tunnel_info(skb, &mask->dissector, &skb_key);
 		skb_flow_dissect_ct(skb, &mask->dissector, &skb_key,
 				    fl_ct_info_to_flower_map,
diff --git a/net/sched/em_ipset.c b/net/sched/em_ipset.c
index df00566d327d..c95cf86fb431 100644
--- a/net/sched/em_ipset.c
+++ b/net/sched/em_ipset.c
@@ -59,7 +59,7 @@ static int em_ipset_match(struct sk_buff *skb, struct tcf_ematch *em,
 	};
 	int ret, network_offset;
 
-	switch (tc_skb_protocol(skb)) {
+	switch (skb_protocol(skb, true)) {
 	case htons(ETH_P_IP):
 		state.pf = NFPROTO_IPV4;
 		if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
diff --git a/net/sched/em_ipt.c b/net/sched/em_ipt.c
index 18755d29fd15..3650117da47f 100644
--- a/net/sched/em_ipt.c
+++ b/net/sched/em_ipt.c
@@ -212,7 +212,7 @@ static int em_ipt_match(struct sk_buff *skb, struct tcf_ematch *em,
 	struct nf_hook_state state;
 	int ret;
 
-	switch (tc_skb_protocol(skb)) {
+	switch (skb_protocol(skb, true)) {
 	case htons(ETH_P_IP):
 		if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
 			return 0;
diff --git a/net/sched/em_meta.c b/net/sched/em_meta.c
index d99966a55c84..46254968d390 100644
--- a/net/sched/em_meta.c
+++ b/net/sched/em_meta.c
@@ -195,7 +195,7 @@ META_COLLECTOR(int_priority)
 META_COLLECTOR(int_protocol)
 {
 	/* Let userspace take care of the byte ordering */
-	dst->value = tc_skb_protocol(skb);
+	dst->value = skb_protocol(skb, false);
 }
 
 META_COLLECTOR(int_pkttype)
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index ca813697728e..ebaeec1e5c82 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -592,7 +592,7 @@ static bool cake_update_flowkeys(struct flow_keys *keys,
 	bool rev = !skb->_nfct, upd = false;
 	__be32 ip;
 
-	if (tc_skb_protocol(skb) != htons(ETH_P_IP))
+	if (skb_protocol(skb, true) != htons(ETH_P_IP))
 		return false;
 
 	if (!nf_ct_get_tuple_skb(&tuple, skb))
@@ -1557,7 +1557,7 @@ static u8 cake_handle_diffserv(struct sk_buff *skb, bool wash)
 	u16 *buf, buf_;
 	u8 dscp;
 
-	switch (tc_skb_protocol(skb)) {
+	switch (skb_protocol(skb, true)) {
 	case htons(ETH_P_IP):
 		buf = skb_header_pointer(skb, offset, sizeof(buf_), &buf_);
 		if (unlikely(!buf))
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index 05605b30bef3..2b88710994d7 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -210,7 +210,7 @@ static int dsmark_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	if (p->set_tc_index) {
 		int wlen = skb_network_offset(skb);
 
-		switch (tc_skb_protocol(skb)) {
+		switch (skb_protocol(skb, true)) {
 		case htons(ETH_P_IP):
 			wlen += sizeof(struct iphdr);
 			if (!pskb_may_pull(skb, wlen) ||
@@ -303,7 +303,7 @@ static struct sk_buff *dsmark_dequeue(struct Qdisc *sch)
 	index = skb->tc_index & (p->indices - 1);
 	pr_debug("index %d->%d\n", skb->tc_index, index);
 
-	switch (tc_skb_protocol(skb)) {
+	switch (skb_protocol(skb, true)) {
 	case htons(ETH_P_IP):
 		ipv4_change_dsfield(ip_hdr(skb), p->mv[index].mask,
 				    p->mv[index].value);
@@ -320,7 +320,7 @@ static struct sk_buff *dsmark_dequeue(struct Qdisc *sch)
 		 */
 		if (p->mv[index].mask != 0xff || p->mv[index].value)
 			pr_warn("%s: unsupported protocol %d\n",
-				__func__, ntohs(tc_skb_protocol(skb)));
+				__func__, ntohs(skb_protocol(skb, true)));
 		break;
 	}
 
diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 689ef6f3ded8..2f1f0a378408 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -239,7 +239,7 @@ __teql_resolve(struct sk_buff *skb, struct sk_buff *skb_res,
 		char haddr[MAX_ADDR_LEN];
 
 		neigh_ha_snapshot(haddr, n, dev);
-		err = dev_hard_header(skb, dev, ntohs(tc_skb_protocol(skb)),
+		err = dev_hard_header(skb, dev, ntohs(skb_protocol(skb, false)),
 				      haddr, NULL, skb->len);
 
 		if (err < 0)
-- 
2.27.0

