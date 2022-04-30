Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115DC515A31
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 05:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382152AbiD3DoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 23:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiD3DoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 23:44:10 -0400
Received: from mail-pj1-x1064.google.com (mail-pj1-x1064.google.com [IPv6:2607:f8b0:4864:20::1064])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222CE606F9
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 20:40:48 -0700 (PDT)
Received: by mail-pj1-x1064.google.com with SMTP id l11-20020a17090a49cb00b001d923a9ca99so8813669pjm.1
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 20:40:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:from:to:cc:subject:date
         :message-id:in-reply-to:references:content-transfer-encoding;
        bh=u6hTtfz+hORBH7Ipz/k8t7/DLjFpKm6aGAHQesdLeHg=;
        b=bm0Q0I1YgzJyxx+A9qIa/A0HRpFAPkvsEFGW3Kwb6rWY4rrf3iZ2NyfyjFh5hNDb7q
         TDWQy6uEfNb2JWftskAiiUJDIPwspVhryyJxv3HgRtmfpYpNxhm2iKUSxv7rOAWV9Syd
         MSORHjnP/WCaWrXXg36IzGm/HbZaKH6JjWwP7Gc6zpZs8tfpzMtINlJ9M/QZ0Z8QOAiB
         0U+tTZi3iwc9i1Nnja6yU4CY+aKvDQXeBsz8Kma/HqsJsHs3idMj+JKoYPoNkOBo+evP
         mlMS21vOW/X1mo5HDHsaCEv4Cy62GpnOErFLKehDB1sWpxV5DnChBOrMj9Tf+KZok5fS
         gGpg==
X-Gm-Message-State: AOAM533rEsEAZFn7KeK5XgYh5IamsyIaO0fHBeAf5YNsnk1O/DyAeIYx
        aoKtTbt15IK+fsz1t2B/7aAlES8sRNoa1GjVs35dXbf6jUZE
X-Google-Smtp-Source: ABdhPJytKIiWIdp8k5v0JT7u+iUDvUBPSbmXsFn+4ICUrV1uM0MPds6eSMBx0Vt+D7zdvvS2fgbwgEhI536X
X-Received: by 2002:a17:902:70cb:b0:158:424e:a657 with SMTP id l11-20020a17090270cb00b00158424ea657mr2340918plt.6.1651290047667;
        Fri, 29 Apr 2022 20:40:47 -0700 (PDT)
Received: from smtp.aristanetworks.com (smtp.aristanetworks.com. [52.0.43.43])
        by smtp-relay.gmail.com with ESMTPS id kx3-20020a17090b228300b001dc2bd0ee43sm18281pjb.10.2022.04.29.20.40.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Apr 2022 20:40:47 -0700 (PDT)
X-Relaying-Domain: arista.com
Received: from chmeee (unknown [10.95.70.41])
        by smtp.aristanetworks.com (Postfix) with ESMTPS id 7892030000A6;
        Fri, 29 Apr 2022 20:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1651290043;
        bh=u6hTtfz+hORBH7Ipz/k8t7/DLjFpKm6aGAHQesdLeHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AsLpz0UcwklCqHSBtn8EgTmsTeeB7fWgJHcjqS9/VoGz7SY6ip44EewZyAyhSUIrM
         bn0ogHv9Nwr9FIlwQF1LlijmYLSqousG5w67WyAoQtTKkJ3k34lbozhnLhLX3aoo69
         xQR2Z8PMztdpN1G5B0MTt1eIRokh3/gQ7QmD+LMuHEK7emCpgeXY/bTqyj3FPYH6O7
         Eke3/+xtKznBEVttRPrnFic971BPd0mfMKVIjygXE5IXGGh4SfcO7aXOsDSVTKQlXP
         BhWpOwmpsoerFTpjw7Nkla2mEVPzYMW5h1pzW6p5aC4GBDFd/89ofps8kOatvixIuV
         PJ3TWpcTfDpww==
Received: from kevmitch by chmeee with local (Exim 4.95)
        (envelope-from <kevmitch@chmeee>)
        id 1nkdyI-0005ZA-2r;
        Fri, 29 Apr 2022 20:40:38 -0700
From:   Kevin Mitchell <kevmitch@arista.com>
Cc:     kevmitch@arista.com, gal@nvidia.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v3] netfilter: conntrack: skip verification of zero UDP checksum
Date:   Fri, 29 Apr 2022 20:40:27 -0700
Message-Id: <20220430034027.21286-1-kevmitch@arista.com>
In-Reply-To: <YmlVAXceuasAJjnN@salvia>
References: <YmlVAXceuasAJjnN@salvia>
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The checksum is optional for UDP packets. However nf_reject would
previously require a valid checksum to elicit a response such as
ICMP_DEST_UNREACH.

Add some logic to nf_reject_verify_csum to determine if a UDP packet has
a zero checksum and should therefore not be verified.

Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
---
 include/net/netfilter/nf_reject.h   | 21 +++++++++++++++++----
 net/ipv4/netfilter/nf_reject_ipv4.c | 10 +++++++---
 net/ipv6/netfilter/nf_reject_ipv6.c |  4 ++--
 3 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_reject.h b/include/net/netfilter/nf_reject.h
index 9051c3a0c8e7..7c669792fb9c 100644
--- a/include/net/netfilter/nf_reject.h
+++ b/include/net/netfilter/nf_reject.h
@@ -5,12 +5,28 @@
 #include <linux/types.h>
 #include <uapi/linux/in.h>
 
-static inline bool nf_reject_verify_csum(__u8 proto)
+static inline bool nf_reject_verify_csum(struct sk_buff *skb, int dataoff,
+					  __u8 proto)
 {
 	/* Skip protocols that don't use 16-bit one's complement checksum
 	 * of the entire payload.
 	 */
 	switch (proto) {
+		/* Protocols with optional checksums. */
+		case IPPROTO_UDP: {
+			const struct udphdr *udp_hdr;
+			struct udphdr _udp_hdr;
+
+			udp_hdr = skb_header_pointer(skb, dataoff,
+						     sizeof(_udp_hdr),
+						     &_udp_hdr);
+			if (!udp_hdr || udp_hdr->check)
+				return true;
+
+			return false;
+		}
+		case IPPROTO_GRE:
+
 		/* Protocols with other integrity checks. */
 		case IPPROTO_AH:
 		case IPPROTO_ESP:
@@ -19,9 +35,6 @@ static inline bool nf_reject_verify_csum(__u8 proto)
 		/* Protocols with partial checksums. */
 		case IPPROTO_UDPLITE:
 		case IPPROTO_DCCP:
-
-		/* Protocols with optional checksums. */
-		case IPPROTO_GRE:
 			return false;
 	}
 	return true;
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 4eed5afca392..6c46d4e8ab84 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -82,6 +82,7 @@ struct sk_buff *nf_reject_skb_v4_unreach(struct net *net,
 	unsigned int len;
 	__wsum csum;
 	u8 proto;
+	int dataoff;
 
 	if (!nf_reject_iphdr_validate(oldskb))
 		return NULL;
@@ -99,10 +100,11 @@ struct sk_buff *nf_reject_skb_v4_unreach(struct net *net,
 	if (pskb_trim_rcsum(oldskb, ntohs(ip_hdr(oldskb)->tot_len)))
 		return NULL;
 
+	dataoff = ip_hdrlen(oldskb);
 	proto = ip_hdr(oldskb)->protocol;
 
 	if (!skb_csum_unnecessary(oldskb) &&
-	    nf_reject_verify_csum(proto) &&
+	    nf_reject_verify_csum(oldskb, dataoff, proto) &&
 	    nf_ip_checksum(oldskb, hook, ip_hdrlen(oldskb), proto))
 		return NULL;
 
@@ -312,6 +314,7 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 {
 	struct iphdr *iph = ip_hdr(skb_in);
 	u8 proto = iph->protocol;
+	int dataoff = ip_hdrlen(skb_in);
 
 	if (iph->frag_off & htons(IP_OFFSET))
 		return;
@@ -320,12 +323,13 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	    nf_reject_fill_skb_dst(skb_in) < 0)
 		return;
 
-	if (skb_csum_unnecessary(skb_in) || !nf_reject_verify_csum(proto)) {
+	if (skb_csum_unnecessary(skb_in) ||
+	    !nf_reject_verify_csum(skb_in, dataoff, proto)) {
 		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
 		return;
 	}
 
-	if (nf_ip_checksum(skb_in, hook, ip_hdrlen(skb_in), proto) == 0)
+	if (nf_ip_checksum(skb_in, hook, dataoff, proto) == 0)
 		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
 }
 EXPORT_SYMBOL_GPL(nf_send_unreach);
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index dffeaaaadcde..f61d4f18e1cf 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -31,7 +31,7 @@ static bool nf_reject_v6_csum_ok(struct sk_buff *skb, int hook)
 	if (thoff < 0 || thoff >= skb->len || (fo & htons(~0x7)) != 0)
 		return false;
 
-	if (!nf_reject_verify_csum(proto))
+	if (!nf_reject_verify_csum(skb, thoff, proto))
 		return true;
 
 	return nf_ip6_checksum(skb, hook, thoff, proto) == 0;
@@ -388,7 +388,7 @@ static bool reject6_csum_ok(struct sk_buff *skb, int hook)
 	if (thoff < 0 || thoff >= skb->len || (fo & htons(~0x7)) != 0)
 		return false;
 
-	if (!nf_reject_verify_csum(proto))
+	if (!nf_reject_verify_csum(skb, thoff, proto))
 		return true;
 
 	return nf_ip6_checksum(skb, hook, thoff, proto) == 0;
-- 
2.35.1

