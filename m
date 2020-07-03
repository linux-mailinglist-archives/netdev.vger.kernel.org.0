Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13CF2139C9
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 14:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgGCMHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 08:07:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44208 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725984AbgGCMHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 08:07:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593778064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0mfUeqVaSjXVBL7MpL+xeLd04ZVHKvfTrHYEuTtF6zs=;
        b=UmxnH7/1jjZKDzWakTH4bOt4VR+li+118S+PU7T8DaPt58BwqCw6xCefGpC6ICFaQugKnn
        OybjIfUIwug95KFARwajZay9GDwEGa9FA9/carvEhugpjrBS9AQTMBu5+P4Xyp9Oxh9vRI
        sv1/XjrXIGiGbpPoCuzrkkot/ae5zuI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-CwFoet3YMXmL4LmBgKrjfQ-1; Fri, 03 Jul 2020 08:07:41 -0400
X-MC-Unique: CwFoet3YMXmL4LmBgKrjfQ-1
Received: by mail-qt1-f200.google.com with SMTP id i5so21682130qtw.3
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 05:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0mfUeqVaSjXVBL7MpL+xeLd04ZVHKvfTrHYEuTtF6zs=;
        b=V32H+eIz6j46sdSUbS5CVah53ld8H/xkDbqCacQMNUUrZoJAYKmZdMjlX9BlXyO/Ub
         FmqgSeEGEVK0Ifp5frHtPSFqKxoAqYKzFFV+zq21EPOb6yrSjR/HCU00wqki6S6rUB9v
         OIbOvfuJ5cIIIGo2RPsuixEylIqAAu+KooWWlBql9UnPj7TpxX0wpTzvGXoP23hxc41Z
         mosNqcZwe8f5JSmDXFOAhzv8Z0UW0X5upIo+LCJOLQt2thK9Ho8CImq+y9VKiSI0Q1Kz
         qx5+H2tQOaejMcX4Yu/aWQGYM7gd7pUo3cErkyPUHzDInHXeir6MmbB69afc97vvlEao
         MOaw==
X-Gm-Message-State: AOAM530buX2O6IoRG2KczcRxsybJvzEAojJ4Xwk6OZz2z/UFYP0gCNLu
        LxsL7KUgIiya9QoJ2DuSvnfZZw360fbEwjjN50/WPy+ZpMnQ458NbkWnvR0HtYDefXHbNmyeHGT
        cytUljRjR283Z3LVs
X-Received: by 2002:ac8:65c3:: with SMTP id t3mr36777462qto.132.1593778060136;
        Fri, 03 Jul 2020 05:07:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYmUdVM2bqV7zYNmZNQ2nDKnu0DaVAe0Y7nn9XLqcJ17h7Uj3gNmPMOPU7BQrZ97QB2alOyg==
X-Received: by 2002:ac8:65c3:: with SMTP id t3mr36777430qto.132.1593778059791;
        Fri, 03 Jul 2020 05:07:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id h16sm9960518qkl.96.2020.07.03.05.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 05:07:39 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 61DCC1828E4; Fri,  3 Jul 2020 14:07:37 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     davem@davemloft.net
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Ilya Ponetayev <i.ponetaev@ndmsystems.com>
Subject: [PATCH net] sched: consistently handle layer3 header accesses in the presence of VLANs
Date:   Fri,  3 Jul 2020 14:05:23 +0200
Message-Id: <20200703120523.465334-1-toke@redhat.com>
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

Reported-by: Ilya Ponetayev <i.ponetaev@ndmsystems.com>
Fixes: d8b9605d2697 ("net: sched: fix skb->protocol use in case of accelerated vlan path")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/if_vlan.h | 27 +++++++++++++++++++++++++++
 include/net/inet_ecn.h  |  5 +++--
 include/net/pkt_sched.h | 11 -----------
 net/sched/act_csum.c    |  2 +-
 net/sched/act_ctinfo.c  |  4 ++--
 net/sched/act_skbedit.c |  2 +-
 net/sched/cls_api.c     |  2 +-
 net/sched/cls_flow.c    |  8 ++++----
 net/sched/em_ipset.c    |  2 +-
 net/sched/em_ipt.c      |  2 +-
 net/sched/em_meta.c     |  2 +-
 net/sched/sch_cake.c    |  4 ++--
 net/sched/sch_dsmark.c  |  6 +++---
 net/sched/sch_teql.c    |  2 +-
 14 files changed, 48 insertions(+), 31 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index b05e855f1ddd..761aae890b2d 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -78,6 +78,33 @@ static inline bool is_vlan_dev(const struct net_device *dev)
 #define skb_vlan_tag_get_cfi(__skb)	(!!((__skb)->vlan_tci & VLAN_CFI_MASK))
 #define skb_vlan_tag_get_prio(__skb)	(((__skb)->vlan_tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT)
 
+/* A getter for the SKB protocol field which will handle VLAN tags consistently
+ * whether VLAN acceleration is enabled or not.
+ */
+static inline __be16 skb_protocol(const struct sk_buff *skb, bool skip_vlan)
+{
+	unsigned int offset = skb_mac_offset(skb) + sizeof(struct ethhdr);
+	__be16 proto = skb->protocol;
+	struct vlan_hdr vhdr, *vh;
+
+	if (!skip_vlan)
+		/* VLAN acceleration strips the VLAN header from the skb and
+		 * moves it to skb->vlan_proto
+		 */
+		return skb_vlan_tag_present(skb) ? skb->vlan_proto : proto;
+
+	while (proto == htons(ETH_P_8021Q) || proto == htons(ETH_P_8021AD)) {
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
 static inline int vlan_get_rx_ctag_filter_info(struct net_device *dev)
 {
 	ASSERT_RTNL();
diff --git a/include/net/inet_ecn.h b/include/net/inet_ecn.h
index 0f0d1efe06dd..82763ba597f2 100644
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
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 19649623493b..82f9088a3c30 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -96,13 +96,13 @@ static int tcf_ctinfo_act(struct sk_buff *skb, const struct tc_action *a,
 	action = READ_ONCE(ca->tcf_action);
 
 	wlen = skb_network_offset(skb);
-	if (tc_skb_protocol(skb) == htons(ETH_P_IP)) {
+	if (skb_protocol(skb, true) == htons(ETH_P_IP)) {
 		wlen += sizeof(struct iphdr);
 		if (!pskb_may_pull(skb, wlen))
 			goto out;
 
 		proto = NFPROTO_IPV4;
-	} else if (tc_skb_protocol(skb) == htons(ETH_P_IPV6)) {
+	} else if (skb_protocol(skb, true) == htons(ETH_P_IPV6)) {
 		wlen += sizeof(struct ipv6hdr);
 		if (!pskb_may_pull(skb, wlen))
 			goto out;
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
index 80ae7b9fa90a..19ebf6c1a848 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -80,7 +80,7 @@ static u32 flow_get_dst(const struct sk_buff *skb, const struct flow_keys *flow)
 	if (dst)
 		return ntohl(dst);
 
-	return addr_fold(skb_dst(skb)) ^ (__force u16) tc_skb_protocol(skb);
+	return addr_fold(skb_dst(skb)) ^ (__force u16) skb_protocol(skb, true);
 }
 
 static u32 flow_get_proto(const struct sk_buff *skb,
@@ -104,7 +104,7 @@ static u32 flow_get_proto_dst(const struct sk_buff *skb,
 	if (flow->ports.ports)
 		return ntohs(flow->ports.dst);
 
-	return addr_fold(skb_dst(skb)) ^ (__force u16) tc_skb_protocol(skb);
+	return addr_fold(skb_dst(skb)) ^ (__force u16) skb_protocol(skb, true);
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

