Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D79680E84
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 14:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235865AbjA3NIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 08:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235425AbjA3NIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 08:08:42 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EA238E82;
        Mon, 30 Jan 2023 05:08:26 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id k8-20020a05600c1c8800b003dc57ea0dfeso1994941wms.0;
        Mon, 30 Jan 2023 05:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NMug5rn4eBbCzTuP14/117PPtm8gZaNRz7jfLdaZaSE=;
        b=H/UESY5g+1hFVoQBanMALjhu4XqvZnKRhCA9betXDXWKEmsQe+rh0YPJcuO+F08OwU
         rvIgrbVGO/7L/4Fs68W+E3nJF5bJGUZTyHLUyf3VnfYxHi3NwSAzentarHJdbrcsY8dw
         7u+kAkccotcF7Cc07M0btvTPT0jhM0KN5IFMkW5zlnsqus4itC8DaUE63TnZpJS97kLp
         yfRF8ulFo1CHRIfIAM0yNshreTGwkvVr1fJX0Urm7rD0X/wE8PbRYVvBZuNEzIjICq9a
         VQXP0wkUwdPTVWgseR/xYSOraeHl1op4jX7l7aCN/dsWg3S0YaRayP3jajP2t0BcPRwT
         n0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NMug5rn4eBbCzTuP14/117PPtm8gZaNRz7jfLdaZaSE=;
        b=f7+nhexEzyd2tl8Eg5My7rEna+joSTCLnvLktsx22rksS5Mk4OyGhRtR8zzbjDu8g0
         KWDLLDMCSxCFfWjJ3P4Zls9eyYxc+zVDPVy5dat3oLi00FYGPdJMqhEPDg8FyGLN7YNh
         2yG8YIZzsJ3ydSAa8+88XYXNPhfqcZw1B7bsHcnr6i9G77Szs7OWQyf18chUH/CdMx0C
         PVcY68fccb6/4L1+hkDqi/In/n+Aam+DtmOZW1t+3zaJQ2BRDnVgI8/5zOxD9kBHoSOX
         JLAy2QKahLCUhGp8Qfshp1jc+pQc2idFlFpGCWOZTP0YpCyhtcnWMQJR2IMJx0ntCwxM
         BbkA==
X-Gm-Message-State: AO0yUKXICNrzEP8J6Xg7cSRcXJphqokXykPGo2iIVKkU3PeyEwtGCFbR
        c2B0v4AlhZCxFeILqkDy+Dw32q9+S/Y=
X-Google-Smtp-Source: AK7set/wd0Q7j6KtwIUYcvjb00u1lGhrJBZXjORWzM8mdBG5P9QAG8HZiVQBAtzFmx7ldWJlL2YI6Q==
X-Received: by 2002:a05:600c:12c6:b0:3dc:59a5:afc7 with SMTP id v6-20020a05600c12c600b003dc59a5afc7mr3411304wmd.20.1675084104638;
        Mon, 30 Jan 2023 05:08:24 -0800 (PST)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id 2-20020a05600c028200b003dc4baaedd3sm7282532wmk.37.2023.01.30.05.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 05:08:24 -0800 (PST)
Date:   Mon, 30 Jan 2023 14:07:55 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        steffen.klassert@secunet.com, lixiaoyan@google.com,
        alexanderduyck@fb.com, leon@kernel.org, ye.xingchen@zte.com.cn,
        iwienand@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] gro: optimise redundant parsing of packets
Message-ID: <20230130130752.GA8015@debian>
References: <20230130130047.GA7913@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130130047.GA7913@debian>
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

Currently, the IPv6 extension headers are parsed twice: first in
ipv6_gro_receive, and then again in ipv6_gro_complete.

The field NAPI_GRO_CB(skb)->proto is used by GRO to hold the layer 4
protocol type that comes after the IPv6 layer. I noticed that it is set
in ipv6_gro_receive, but isn't used anywhere. By using this field, and
also storing the size of the network header, we can avoid parsing
extension headers a second time in ipv6_gro_complete.

The implementation had to handle both inner and outer layers in case of
encapsulation (as they can't use the same field).

I've applied this optimisation to all base protocols (IPv6, IPv4,
Ethernet). Then, I benchmarked this patch on my machine, using ftrace to
measure ipv6_gro_complete's performance, and there was an improvement.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 include/net/gro.h      |  8 ++++++--
 net/ethernet/eth.c     | 11 +++++++++--
 net/ipv4/af_inet.c     |  8 +++++++-
 net/ipv6/ip6_offload.c | 15 ++++++++++++---
 4 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/include/net/gro.h b/include/net/gro.h
index 7b47dd6ce94f..d364616cb930 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -41,8 +41,8 @@ struct napi_gro_cb {
 	/* Number of segments aggregated. */
 	u16	count;
 
-	/* Used in ipv6_gro_receive() and foo-over-udp */
-	u16	proto;
+	/* Used in eth_gro_receive() */
+	__be16	network_proto;
 
 /* Used in napi_gro_cb::free */
 #define NAPI_GRO_FREE             1
@@ -86,6 +86,10 @@ struct napi_gro_cb {
 
 	/* used to support CHECKSUM_COMPLETE for tunneling protocols */
 	__wsum	csum;
+
+	/* Used in inet and ipv6 _gro_receive() */
+	u16	network_len;
+	u8	transport_proto;
 };
 
 #define NAPI_GRO_CB(skb) ((struct napi_gro_cb *)(skb)->cb)
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 2edc8b796a4e..d68ad90f0a9e 100644
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
 
@@ -456,12 +459,16 @@ EXPORT_SYMBOL(eth_gro_receive);
 int eth_gro_complete(struct sk_buff *skb, int nhoff)
 {
 	struct ethhdr *eh = (struct ethhdr *)(skb->data + nhoff);
-	__be16 type = eh->h_proto;
+	__be16 type;
 	struct packet_offload *ptype;
 	int err = -ENOSYS;
 
-	if (skb->encapsulation)
+	if (skb->encapsulation) {
 		skb_set_inner_mac_header(skb, nhoff);
+		type = eh->h_proto;
+	} else {
+		type = NAPI_GRO_CB(skb)->network_proto;
+	}
 
 	ptype = gro_find_complete_by_type(type);
 	if (ptype != NULL)
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 6c0ec2789943..4401af7b3a15 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1551,6 +1551,9 @@ struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
 	 * immediately following this IP hdr.
 	 */
 
+	if (!NAPI_GRO_CB(skb)->encap_mark)
+		NAPI_GRO_CB(skb)->transport_proto = proto;
+
 	/* Note : No need to call skb_gro_postpull_rcsum() here,
 	 * as we already checked checksum over ipv4 header was 0
 	 */
@@ -1621,12 +1624,15 @@ int inet_gro_complete(struct sk_buff *skb, int nhoff)
 	__be16 newlen = htons(skb->len - nhoff);
 	struct iphdr *iph = (struct iphdr *)(skb->data + nhoff);
 	const struct net_offload *ops;
-	int proto = iph->protocol;
+	int proto;
 	int err = -ENOSYS;
 
 	if (skb->encapsulation) {
 		skb_set_inner_protocol(skb, cpu_to_be16(ETH_P_IP));
 		skb_set_inner_network_header(skb, nhoff);
+		proto = iph->protocol;
+	} else {
+		proto = NAPI_GRO_CB(skb)->transport_proto;
 	}
 
 	csum_replace2(&iph->check, iph->tot_len, newlen);
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index 00dc2e3b0184..79ba5882f576 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -227,11 +227,14 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 		iph = ipv6_hdr(skb);
 	}
 
-	NAPI_GRO_CB(skb)->proto = proto;
-
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
@@ -358,7 +361,13 @@ INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
 		iph->payload_len = htons(payload_len);
 	}
 
-	nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);
+	if (!skb->encapsulation) {
+		ops = rcu_dereference(inet6_offloads[NAPI_GRO_CB(skb)->transport_proto]);
+		nhoff += NAPI_GRO_CB(skb)->network_len;
+	} else {
+		nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);
+	}
+
 	if (WARN_ON(!ops || !ops->callbacks.gro_complete))
 		goto out;
 
-- 
2.36.1

