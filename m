Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555AD4A8371
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 13:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350373AbiBCMAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 07:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350369AbiBCMAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 07:00:22 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2560C06173D;
        Thu,  3 Feb 2022 04:00:22 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id l13so1939568plg.9;
        Thu, 03 Feb 2022 04:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D+QcOf27G0AKCegHYxDyR6taGGMQc+Nv1nDTQ5yZ2VM=;
        b=YXBfOxZPElSf/LHgSTF5ycZCfkjl72C6pO7v+1/qedquGVbWYYWQg5xch9Osc3VOVP
         FC0JAafrbiXx8qU9rvWMQ1uVJhJVEL8O6PXUiJPcfyQIlZw3WmVtropHn3ZCYzTHfIpt
         XzS8yHQknvwd3q3BWAUS04ifJR/AjQi0aKRuUP/xzU+GHTVlPzYeSU72A5fwA5Gaqw3g
         9PvNBNX4a+fsehpDNGiMqVKZ2PnA435VWor/8UR4hsqLHO7cVzgbkN5SI7zujGI2jleA
         khs+HUvhgpEYO+VLgH2c+ZxAEbmCHcoB8VO3IzfU/VL2MaaiLAxNOGrnRo+x6xjSMG6V
         n40w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D+QcOf27G0AKCegHYxDyR6taGGMQc+Nv1nDTQ5yZ2VM=;
        b=KQfYS4iGt3PABWgNUlxZBHGzbGhoLCJBUBIIzYu8xGXF/gN/haYvnE0ZCg3sz5HXSP
         FCQOpwiLCdQWslVbhkpkYEJ8HW+dfE9UnNy2k9kp4izN56oia7FfQLjUMI+wMGkdZok5
         UZKm9uY4lyRQhgEBhEbvZiPdKVm/hOsq8QEXQJtWQfBdsZr+LQLRrV0XBYKppKX/Rztt
         vReT1TGpw43aDAD9+DcT/dKNdkTllC3TUO1xq96tE7bV3jBCu8+WQt+k6p74ayeKXgZA
         qhvtPf3R1gIhvQELw+ZWHn8rdXFVHRvdB4wYj2usPlYXQV/lqTaywFE5d3LY6TEThUTD
         Qaiw==
X-Gm-Message-State: AOAM530zQObl/eixre10Pl/Vu7mnTIqazgt/1K3IG6TKUVCP1OQ76csy
        ry15QmYlqGP723XvDIuzfp4=
X-Google-Smtp-Source: ABdhPJzDvhBJICD0+IJfAWr+RRHRN0UiGlMtI6G9ghCiB1oeUvZ4moY3KsSLrZh+CQz+F4NEbFAg/g==
X-Received: by 2002:a17:902:ce92:: with SMTP id f18mr5270090plg.166.1643889622390;
        Thu, 03 Feb 2022 04:00:22 -0800 (PST)
Received: from e30-rocky8.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id f12sm16506697pfc.70.2022.02.03.04.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 04:00:22 -0800 (PST)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        "Jiri Pirko" <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Jozsef Kadlecsik" <kadlec@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Paul Blakey <paulb@nvidia.com>
Subject: [PATCH net-next 1/3] netfilter: flowtable: Support GRE
Date:   Thu,  3 Feb 2022 20:59:39 +0900
Message-Id: <20220203115941.3107572-2-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220203115941.3107572-1-toshiaki.makita1@gmail.com>
References: <20220203115941.3107572-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support GREv0 without NAT.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 net/netfilter/nf_flow_table_core.c    | 10 +++++--
 net/netfilter/nf_flow_table_ip.c      | 54 ++++++++++++++++++++++++++++-------
 net/netfilter/nf_flow_table_offload.c | 19 +++++++-----
 net/netfilter/nft_flow_offload.c      | 13 +++++++++
 4 files changed, 77 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index b90eca7..e66a375 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -39,8 +39,14 @@
 
 	ft->l3proto = ctt->src.l3num;
 	ft->l4proto = ctt->dst.protonum;
-	ft->src_port = ctt->src.u.tcp.port;
-	ft->dst_port = ctt->dst.u.tcp.port;
+
+	switch (ctt->dst.protonum) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+		ft->src_port = ctt->src.u.tcp.port;
+		ft->dst_port = ctt->dst.u.tcp.port;
+		break;
+	}
 }
 
 struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 889cf88..48e2f58 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -172,6 +172,7 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	struct flow_ports *ports;
 	unsigned int thoff;
 	struct iphdr *iph;
+	u8 ipproto;
 
 	if (!pskb_may_pull(skb, sizeof(*iph) + offset))
 		return -1;
@@ -185,13 +186,19 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 
 	thoff += offset;
 
-	switch (iph->protocol) {
+	ipproto = iph->protocol;
+	switch (ipproto) {
 	case IPPROTO_TCP:
 		*hdrsize = sizeof(struct tcphdr);
 		break;
 	case IPPROTO_UDP:
 		*hdrsize = sizeof(struct udphdr);
 		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE:
+		*hdrsize = sizeof(struct gre_base_hdr);
+		break;
+#endif
 	default:
 		return -1;
 	}
@@ -202,15 +209,25 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	if (!pskb_may_pull(skb, thoff + *hdrsize))
 		return -1;
 
+	if (ipproto == IPPROTO_GRE) {
+		struct gre_base_hdr *greh;
+
+		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
+		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
+			return -1;
+	}
+
 	iph = (struct iphdr *)(skb_network_header(skb) + offset);
-	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 
 	tuple->src_v4.s_addr	= iph->saddr;
 	tuple->dst_v4.s_addr	= iph->daddr;
-	tuple->src_port		= ports->source;
-	tuple->dst_port		= ports->dest;
+	if (ipproto == IPPROTO_TCP || ipproto == IPPROTO_UDP) {
+		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+		tuple->src_port		= ports->source;
+		tuple->dst_port		= ports->dest;
+	}
 	tuple->l3proto		= AF_INET;
-	tuple->l4proto		= iph->protocol;
+	tuple->l4proto		= ipproto;
 	tuple->iifidx		= dev->ifindex;
 	nf_flow_tuple_encap(skb, tuple);
 
@@ -521,6 +538,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	struct flow_ports *ports;
 	struct ipv6hdr *ip6h;
 	unsigned int thoff;
+	u8 nexthdr;
 
 	thoff = sizeof(*ip6h) + offset;
 	if (!pskb_may_pull(skb, thoff))
@@ -528,13 +546,19 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
 
-	switch (ip6h->nexthdr) {
+	nexthdr = ip6h->nexthdr;
+	switch (nexthdr) {
 	case IPPROTO_TCP:
 		*hdrsize = sizeof(struct tcphdr);
 		break;
 	case IPPROTO_UDP:
 		*hdrsize = sizeof(struct udphdr);
 		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE:
+		*hdrsize = sizeof(struct gre_base_hdr);
+		break;
+#endif
 	default:
 		return -1;
 	}
@@ -545,15 +569,25 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	if (!pskb_may_pull(skb, thoff + *hdrsize))
 		return -1;
 
+	if (nexthdr == IPPROTO_GRE) {
+		struct gre_base_hdr *greh;
+
+		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
+		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
+			return -1;
+	}
+
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
-	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 
 	tuple->src_v6		= ip6h->saddr;
 	tuple->dst_v6		= ip6h->daddr;
-	tuple->src_port		= ports->source;
-	tuple->dst_port		= ports->dest;
+	if (nexthdr == IPPROTO_TCP || nexthdr == IPPROTO_UDP) {
+		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+		tuple->src_port		= ports->source;
+		tuple->dst_port		= ports->dest;
+	}
 	tuple->l3proto		= AF_INET6;
-	tuple->l4proto		= ip6h->nexthdr;
+	tuple->l4proto		= nexthdr;
 	tuple->iifidx		= dev->ifindex;
 	nf_flow_tuple_encap(skb, tuple);
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b561e0a..9b81080 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -170,6 +170,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_TCP);
 		break;
 	case IPPROTO_UDP:
+	case IPPROTO_GRE:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -178,15 +179,19 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	key->basic.ip_proto = tuple->l4proto;
 	mask->basic.ip_proto = 0xff;
 
-	key->tp.src = tuple->src_port;
-	mask->tp.src = 0xffff;
-	key->tp.dst = tuple->dst_port;
-	mask->tp.dst = 0xffff;
-
 	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_META) |
 				      BIT(FLOW_DISSECTOR_KEY_CONTROL) |
-				      BIT(FLOW_DISSECTOR_KEY_BASIC) |
-				      BIT(FLOW_DISSECTOR_KEY_PORTS);
+				      BIT(FLOW_DISSECTOR_KEY_BASIC);
+
+	if (tuple->l4proto == IPPROTO_TCP || tuple->l4proto == IPPROTO_UDP) {
+		key->tp.src = tuple->src_port;
+		mask->tp.src = 0xffff;
+		key->tp.dst = tuple->dst_port;
+		mask->tp.dst = 0xffff;
+
+		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_PORTS);
+	}
+
 	return 0;
 }
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 0af34ad..731b5d8 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -298,6 +298,19 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		break;
 	case IPPROTO_UDP:
 		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE: {
+		struct nf_conntrack_tuple *tuple;
+
+		if (ct->status & IPS_NAT_MASK)
+			goto out;
+		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+		/* No support for GRE v1 */
+		if (tuple->src.u.gre.key || tuple->dst.u.gre.key)
+			goto out;
+		break;
+	}
+#endif
 	default:
 		goto out;
 	}
-- 
1.8.3.1

