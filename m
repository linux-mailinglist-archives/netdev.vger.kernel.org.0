Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B934A6C1D49
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbjCTRHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233178AbjCTRGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:06:39 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9973847D;
        Mon, 20 Mar 2023 10:01:40 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id i5-20020a05600c354500b003edd24054e0so2854194wmq.4;
        Mon, 20 Mar 2023 10:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679331627;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=emunZ6Gfjz6hsGVJY+MFFdb08z3ajudd3PGryRdXWC8=;
        b=Uwtux0c9h9pZ2vV/Yw7YhOJueutyMdrBwEHhOFGu2ij/Z0qc8KnMZctQU8ixDyL76b
         5WgvdnzoMPfDCibT0av4gBeRKEZD+6aEywFVALM2U23HybKK2TbfxwmQUdCLd1dv9f0P
         5W+QwyLXyXdyT+M6U8FXu/qFuQXSVdVY+gQNP279JRQy4DHHtc8AaFd/Lvt3vN4vVsN2
         +Gway3YwHvveAtYDCNKxlRHse/YMXWIKu0vlV/y7hQqpHavwZX9w1GDUGyvK+R4k4Opw
         NMMjfUEEr4NVsqh9i3tiM0ihoz9limlMXnlLaE5D4f3bEYe9F/APKyvRW/Dopi2nVmra
         tMEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679331627;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=emunZ6Gfjz6hsGVJY+MFFdb08z3ajudd3PGryRdXWC8=;
        b=8SKYt3AMNEIS4ki7BPgCgnZNUfhc3VgkRRIVYJfmhEDqvDY4sM8JQ8GPBsReEO8Ses
         CKUU3tPLB6eywicsNDyUWIdC7Z/97XxpuVtr8/ZO6fNnOD96LtCf9ViCgfiuw7/Qem3k
         gpVOUJgiCGd8k+qnplp+RrIdCdI5nsOSf2F+hRX55UiWtWv+txcxsEJaYG6rEl5mXBoj
         KzcJjAk8JffwyB2QthlNHVt/WzgzdGcMv4oslMxeH/JTfNvfw1e8ohCmTJVlZ2iYi7ke
         4APrlkHNwIn+qOKENzPiSejWbeTmP9dBr7plvk58Ynx664rFqOQ1vnfNI1nLSQWFtre2
         cpHg==
X-Gm-Message-State: AO0yUKW/JauFgI3piNUeCEH0bZDRrwY79E6adUFNnuyGC6zrpgwQApJo
        /A7h8cjlwHVdVJJ889yyqqs=
X-Google-Smtp-Source: AK7set8ylWnYgP6bZ33lFx9G6VBpLHosVCFz06pVy3MvnKlBa19LJTo6HJ13nBTolHSYPkUUcVLyug==
X-Received: by 2002:a05:600c:2202:b0:3ed:9b20:c7c1 with SMTP id z2-20020a05600c220200b003ed9b20c7c1mr189663wml.20.1679331626994;
        Mon, 20 Mar 2023 10:00:26 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id p9-20020a1c5449000000b003dc1d668866sm16970352wmi.10.2023.03.20.10.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 10:00:26 -0700 (PDT)
Date:   Mon, 20 Mar 2023 18:00:11 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, alexanderduyck@fb.com,
        lucien.xin@gmail.com, lixiaoyan@google.com, iwienand@redhat.com,
        leon@kernel.org, ye.xingchen@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] gro: optimise redundant parsing of packets
Message-ID: <20230320170009.GA27961@debian>
References: <20230320163703.GA27712@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320163703.GA27712@debian>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the IPv6 extension headers are parsed twice: first in
ipv6_gro_receive, and then again in ipv6_gro_complete.

By using the new ->transport_proto field, and also storing the size of the
network header, we can avoid parsing extension headers a second time in
ipv6_gro_complete (which saves multiple memory dereferences and conditional
checks inside ipv6_exthdrs_len for a varying amount of extension headers in
IPv6 packets).

The implementation had to handle both inner and outer layers in case of
encapsulation (as they can't use the same field). I've applied a similar
optimisation to Ethernet.

Performance tests for TCP stream over IPv6 with a varying amount of
extension headers demonstrate throughput improvement of ~0.7%.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
v3 -> v4:
	- Updated commit msg as Eric suggested.
	- No code changes.
---
 include/net/gro.h      |  9 +++++++++
 net/ethernet/eth.c     | 14 +++++++++++---
 net/ipv6/ip6_offload.c | 20 +++++++++++++++-----
 3 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/include/net/gro.h b/include/net/gro.h
index 7b47dd6ce94f..35f60ea99f6c 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -86,6 +86,15 @@ struct napi_gro_cb {
 
 	/* used to support CHECKSUM_COMPLETE for tunneling protocols */
 	__wsum	csum;
+
+	/* Used in ipv6_gro_receive() */
+	u16	network_len;
+
+	/* Used in eth_gro_receive() */
+	__be16	network_proto;
+
+	/* Used in ipv6_gro_receive() */
+	u8	transport_proto;
 };
 
 #define NAPI_GRO_CB(skb) ((struct napi_gro_cb *)(skb)->cb)
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 2edc8b796a4e..c2b77d9401e4 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -439,6 +439,9 @@ struct sk_buff *eth_gro_receive(struct list_head *head, struct sk_buff *skb)
 		goto out;
 	}
 
+	if (!NAPI_GRO_CB(skb)->encap_mark)
+		NAPI_GRO_CB(skb)->network_proto = type;
+
 	skb_gro_pull(skb, sizeof(*eh));
 	skb_gro_postpull_rcsum(skb, eh, sizeof(*eh));
 
@@ -455,13 +458,18 @@ EXPORT_SYMBOL(eth_gro_receive);
 
 int eth_gro_complete(struct sk_buff *skb, int nhoff)
 {
-	struct ethhdr *eh = (struct ethhdr *)(skb->data + nhoff);
-	__be16 type = eh->h_proto;
 	struct packet_offload *ptype;
+	struct ethhdr *eh;
 	int err = -ENOSYS;
+	__be16 type;
 
-	if (skb->encapsulation)
+	if (skb->encapsulation) {
+		eh = (struct ethhdr *)(skb->data + nhoff);
 		skb_set_inner_mac_header(skb, nhoff);
+		type = eh->h_proto;
+	} else {
+		type = NAPI_GRO_CB(skb)->network_proto;
+	}
 
 	ptype = gro_find_complete_by_type(type);
 	if (ptype != NULL)
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index 00dc2e3b0184..6e3a923ad573 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -232,6 +232,11 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 	flush--;
 	nlen = skb_network_header_len(skb);
 
+	if (!NAPI_GRO_CB(skb)->encap_mark) {
+		NAPI_GRO_CB(skb)->transport_proto = proto;
+		NAPI_GRO_CB(skb)->network_len = nlen;
+	}
+
 	list_for_each_entry(p, head, list) {
 		const struct ipv6hdr *iph2;
 		__be32 first_word; /* <Version:4><Traffic_Class:8><Flow_Label:20> */
@@ -324,10 +329,6 @@ INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
 	int err = -ENOSYS;
 	u32 payload_len;
 
-	if (skb->encapsulation) {
-		skb_set_inner_protocol(skb, cpu_to_be16(ETH_P_IPV6));
-		skb_set_inner_network_header(skb, nhoff);
-	}
 
 	payload_len = skb->len - nhoff - sizeof(*iph);
 	if (unlikely(payload_len > IPV6_MAXPLEN)) {
@@ -341,6 +342,7 @@ INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
 		skb->len += hoplen;
 		skb->mac_header -= hoplen;
 		skb->network_header -= hoplen;
+		NAPI_GRO_CB(skb)->network_len += hoplen;
 		iph = (struct ipv6hdr *)(skb->data + nhoff);
 		hop_jumbo = (struct hop_jumbo_hdr *)(iph + 1);
 
@@ -358,7 +360,15 @@ INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
 		iph->payload_len = htons(payload_len);
 	}
 
-	nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);
+	if (skb->encapsulation) {
+		skb_set_inner_protocol(skb, cpu_to_be16(ETH_P_IPV6));
+		skb_set_inner_network_header(skb, nhoff);
+		nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);
+	} else {
+		ops = rcu_dereference(inet6_offloads[NAPI_GRO_CB(skb)->transport_proto]);
+		nhoff += NAPI_GRO_CB(skb)->network_len;
+	}
+
 	if (WARN_ON(!ops || !ops->callbacks.gro_complete))
 		goto out;
 
-- 
2.36.1
