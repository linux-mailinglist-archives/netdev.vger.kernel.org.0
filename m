Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3BF94A8373
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 13:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350368AbiBCMA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 07:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiBCMA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 07:00:26 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3290DC06173B;
        Thu,  3 Feb 2022 04:00:26 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id j16so1955902plx.4;
        Thu, 03 Feb 2022 04:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/58ZWb/Iv5GS0MWB+kxPvMl58xYsr2tKtsiFsskxVhA=;
        b=kDSMbjwpYhqLjomXvrVglmceH7yt/Q5mQ8UKQU6/C4ktOM0RUY4wWIcx7b5aW408sG
         zXrOnkBc9JwklsGwyxdaKQXKE/n5gDfRT9mzvgWpr0f0tWFFZVMkCvEriKwQICl+I4ob
         Qail59NdGKIbDUCUtHSNfe6SqSabDho8DhPj6GxxKCjhVRQX6XRswLcx8OC5XuyXgxaP
         M3evReRkbmGmjCBgpz+NtspuLUlxFOl28CpxKVIEobAljVsOQm0m4Wuz4FjhiLQbNIPm
         PMIYvxR+DmyBIzTJZbKrzGn8uvCjpMB8Ue11i6QJI7Buf7UVKDBaTcXhO4EbgSMVwl8P
         D4sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/58ZWb/Iv5GS0MWB+kxPvMl58xYsr2tKtsiFsskxVhA=;
        b=C5vQef9Qbf/GNb/CxWiV8a3caMeqsfA2VTkoRyEXR+TKI0yYzMFzVQDrgNkc3CtZVx
         1OtTLf0cFZ0bQfuYbmyAr7ObrEMv53CGhG/UuYYas+gJx8x4BCmVWA0lXsWD/fjGkVTU
         m/qZnpX7kJbTJQbEjOu1Mdp/8u2OBLh5LGr3xN2F24ojd1dlgoYDDH6tUP3DGQGlZtYR
         rEe5MsPMMysQTZsG0s0SXf3q2ycbP0CzRTahEMCYUNkgUaSYNcv7Q1j2vjSzt7WfQWSQ
         /UeKkuEzD1t77QtQiVdvZudxW4RLkn1Qw1g0yk86aZWLZmFDSeGmRRMWoE0vXsl+kTNI
         zoaQ==
X-Gm-Message-State: AOAM532aZRX44MlyCH1Owtj5TSXTMDcV5+kDY7RBEYLtUgBe1cc1GBwp
        dCUt7UZnddaXZ5jlwAgzcvQ=
X-Google-Smtp-Source: ABdhPJwjAfFLI6JUHTa4TFFRwq2L2qWF/uTTF1NABiklHpOWO5npxSqblK1t6XbWNWlnaF8wgq9kjA==
X-Received: by 2002:a17:902:b403:: with SMTP id x3mr22545067plr.61.1643889625707;
        Thu, 03 Feb 2022 04:00:25 -0800 (PST)
Received: from e30-rocky8.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id f12sm16506697pfc.70.2022.02.03.04.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 04:00:25 -0800 (PST)
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
Subject: [PATCH net-next 2/3] act_ct: Support GRE offload
Date:   Thu,  3 Feb 2022 20:59:40 +0900
Message-Id: <20220203115941.3107572-3-toshiaki.makita1@gmail.com>
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
 net/sched/act_ct.c | 101 +++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 79 insertions(+), 22 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index f99247f..a5f47d5 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -421,6 +421,19 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 		break;
 	case IPPROTO_UDP:
 		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE: {
+		struct nf_conntrack_tuple *tuple;
+
+		if (ct->status & IPS_NAT_MASK)
+			return;
+		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+		/* No support for GRE v1 */
+		if (tuple->src.u.gre.key || tuple->dst.u.gre.key)
+			return;
+		break;
+	}
+#endif
 	default:
 		return;
 	}
@@ -440,6 +453,8 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 	struct flow_ports *ports;
 	unsigned int thoff;
 	struct iphdr *iph;
+	size_t hdrsize;
+	u8 ipproto;
 
 	if (!pskb_network_may_pull(skb, sizeof(*iph)))
 		return false;
@@ -451,29 +466,49 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 	    unlikely(thoff != sizeof(struct iphdr)))
 		return false;
 
-	if (iph->protocol != IPPROTO_TCP &&
-	    iph->protocol != IPPROTO_UDP)
+	ipproto = iph->protocol;
+	switch (ipproto) {
+	case IPPROTO_TCP:
+		hdrsize = sizeof(struct tcphdr);
+		break;
+	case IPPROTO_UDP:
+		hdrsize = sizeof(*ports);
+		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE:
+		hdrsize = sizeof(struct gre_base_hdr);
+		break;
+#endif
+	default:
 		return false;
+	}
 
 	if (iph->ttl <= 1)
 		return false;
 
-	if (!pskb_network_may_pull(skb, iph->protocol == IPPROTO_TCP ?
-					thoff + sizeof(struct tcphdr) :
-					thoff + sizeof(*ports)))
+	if (!pskb_network_may_pull(skb, thoff + hdrsize))
 		return false;
 
 	iph = ip_hdr(skb);
-	if (iph->protocol == IPPROTO_TCP)
+	if (ipproto == IPPROTO_TCP) {
 		*tcph = (void *)(skb_network_header(skb) + thoff);
+	} else if (ipproto == IPPROTO_GRE) {
+		struct gre_base_hdr *greh;
+
+		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
+		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
+			return false;
+	}
 
-	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 	tuple->src_v4.s_addr = iph->saddr;
 	tuple->dst_v4.s_addr = iph->daddr;
-	tuple->src_port = ports->source;
-	tuple->dst_port = ports->dest;
+	if (ipproto == IPPROTO_TCP || ipproto == IPPROTO_UDP) {
+		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+		tuple->src_port = ports->source;
+		tuple->dst_port = ports->dest;
+	}
 	tuple->l3proto = AF_INET;
-	tuple->l4proto = iph->protocol;
+	tuple->l4proto = ipproto;
 
 	return true;
 }
@@ -486,36 +521,58 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 	struct flow_ports *ports;
 	struct ipv6hdr *ip6h;
 	unsigned int thoff;
+	size_t hdrsize;
+	u8 nexthdr;
 
 	if (!pskb_network_may_pull(skb, sizeof(*ip6h)))
 		return false;
 
 	ip6h = ipv6_hdr(skb);
+	thoff = sizeof(*ip6h);
 
-	if (ip6h->nexthdr != IPPROTO_TCP &&
-	    ip6h->nexthdr != IPPROTO_UDP)
-		return false;
+	nexthdr = ip6h->nexthdr;
+	switch (nexthdr) {
+	case IPPROTO_TCP:
+		hdrsize = sizeof(struct tcphdr);
+		break;
+	case IPPROTO_UDP:
+		hdrsize = sizeof(*ports);
+		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE:
+		hdrsize = sizeof(struct gre_base_hdr);
+		break;
+#endif
+	default:
+		return -1;
+	}
 
 	if (ip6h->hop_limit <= 1)
 		return false;
 
-	thoff = sizeof(*ip6h);
-	if (!pskb_network_may_pull(skb, ip6h->nexthdr == IPPROTO_TCP ?
-					thoff + sizeof(struct tcphdr) :
-					thoff + sizeof(*ports)))
+	if (!pskb_network_may_pull(skb, thoff + hdrsize))
 		return false;
 
 	ip6h = ipv6_hdr(skb);
-	if (ip6h->nexthdr == IPPROTO_TCP)
+	if (nexthdr == IPPROTO_TCP) {
 		*tcph = (void *)(skb_network_header(skb) + thoff);
+	} else if (nexthdr == IPPROTO_GRE) {
+		struct gre_base_hdr *greh;
+
+		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
+		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
+			return false;
+	}
 
-	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 	tuple->src_v6 = ip6h->saddr;
 	tuple->dst_v6 = ip6h->daddr;
-	tuple->src_port = ports->source;
-	tuple->dst_port = ports->dest;
+	if (nexthdr == IPPROTO_TCP || nexthdr == IPPROTO_UDP) {
+		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+		tuple->src_port = ports->source;
+		tuple->dst_port = ports->dest;
+	}
 	tuple->l3proto = AF_INET6;
-	tuple->l4proto = ip6h->nexthdr;
+	tuple->l4proto = nexthdr;
 
 	return true;
 }
-- 
1.8.3.1

