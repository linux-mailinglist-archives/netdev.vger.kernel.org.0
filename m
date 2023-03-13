Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE3B6B7DED
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjCMQqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjCMQqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:46:22 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C37231F7;
        Mon, 13 Mar 2023 09:46:21 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id k37so8516404wms.0;
        Mon, 13 Mar 2023 09:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678725979;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hTYnu0VjLSLl4fT62AvXkQqnVbpXY8CpKDsx2LnT+Sk=;
        b=SkEyZUu5Wins92IvLbf1iLADoZjZnwH9ahAJAFDIU7uXbA5WCMNyEkOKj29zOKdf32
         +gx/aoIbVZ44MKVhe7APSHo19s6EHvNuPTdKE7IPRUEnLo+JneuGBOp3ndFCQI50DKu6
         DnzjbDz7pTCqOXCsofxSQJI7CoStBhvv5W0e9nPWePTOUiA8MRxjZj46ayklKhEAXXgd
         W1b56e06Q+HBA3iSOs/1z+1JUUVHkW5QhUHEJ/NJmMGY4rk1bkdvkCUUWqJZWOXUm9rj
         TCcFnd9HWrubTf3DL3gazMM7AL1gsBDtUQQ4n0mKAF49LOLxQ+Eu/k/Ug+JQOlLtZPSt
         X1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678725979;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hTYnu0VjLSLl4fT62AvXkQqnVbpXY8CpKDsx2LnT+Sk=;
        b=BRquFpNHxEtqicG6VgKUcdJm0fc64z5bVVyJ4wC3nTln8scvskPwshoJwbbJf92Dpi
         Z+UccwuVSrlp8cT/blEvXql+orn3QUTFd1pflsV8Jf/zCHfT9vhdkjtlJyPx676Fv6CS
         SjxzJQ4CTmvlcsVEHOzOW4T+g+vFyGOPlmi+thJ9aJedFrP/TsYCPAumubnuDeSb00os
         AdinHx9I0aI1y1MN9hJtZVd1S6bhU9SGptZ7IY5CT1pcTYeMtIs4CIzQvojJO2DNa8FH
         5NMPSMNb85jrNVC9/ZBQHhKmVbM0xH3VQJmEHQVeQ76z8hN+dI5zAuNv9DqfWnG+1GCG
         YggQ==
X-Gm-Message-State: AO0yUKU6BhHKstvGietAjV2Q6VTCIuFORWEYYyrd8dkrAo54/8lTq9Ed
        5FLXL1mdJ5qoJ592YIIX58Fpcee7uF4=
X-Google-Smtp-Source: AK7set/dAyK1OEP8bLO5a434ttKT85OSsCYwmoaKDqppmHe11POybPTiktj/9j7yLORLSFuRje1h4g==
X-Received: by 2002:a05:600c:4f89:b0:3dc:5b88:e6dd with SMTP id n9-20020a05600c4f8900b003dc5b88e6ddmr12364964wmq.10.1678725979651;
        Mon, 13 Mar 2023 09:46:19 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id h22-20020a05600c351600b003e733a973d2sm249806wmq.39.2023.03.13.09.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 09:46:19 -0700 (PDT)
Date:   Mon, 13 Mar 2023 17:45:48 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, alexanderduyck@fb.com,
        lucien.xin@gmail.com, lixiaoyan@google.com, iwienand@redhat.com,
        leon@kernel.org, ye.xingchen@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] gro: optimise redundant parsing of packets
Message-ID: <20230313164541.GA17394@debian>
References: <20230313162520.GA17199@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313162520.GA17199@debian>
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

In addition, I fixed a potential future problem:
 - The call to skb_set_inner_network_header at the beginning of
   ipv6_gro_complete calculates inner_network_header based on skb->data by
   calling skb_set_inner_network_header, and setting it to point to the
   beginning of the ip header.
 - If a packet is going to be handled by BIG TCP, the following code block
   is going to shift the packet header, and skb->data is going to be
   changed as well.

When the two flows are combined, inner_network_header will point to the
wrong place - which might happen if encapsulation of BIG TCP will be
supported in the future.

The fix is to place the whole encapsulation branch after the BIG TCP code
block. This way, if encapsulation of BIG TCP will be supported,
inner_network_header will still be calculated with the correct value of
skb->data.
Also, by arranging the code that way, the optimisation does not
add an additional branch.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
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
