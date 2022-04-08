Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B5D4F8E2B
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbiDHEgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 00:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiDHEf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 00:35:58 -0400
Received: from mail-pl1-x664.google.com (mail-pl1-x664.google.com [IPv6:2607:f8b0:4864:20::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9591ED4CB8
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 21:33:54 -0700 (PDT)
Received: by mail-pl1-x664.google.com with SMTP id s11so6874377pla.8
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 21:33:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:from:to:cc:subject:date
         :message-id:in-reply-to:references:content-transfer-encoding;
        bh=9CYUHr8sc1keYeTHR45nH7V/JN2e+SSVKE6SwVUg4TY=;
        b=k9st4l0wmlOdK5IcTdXsGmupZ9m2V73wG9jDgOJ3ZFB76rV5M1F85E3FG052KJWuSr
         0jHMkXdYyUbn9DnTFhsJMatTXc3HimUIMJ9a1IJ/ENtoyjl1fWxxY1Wn/01u0CvL20qf
         /zMVvq1hea5C43FEtNDnfret7Gvfaef/H3PYb1UyZJOdz2E/1xYGRpOaG0g7ZkFXSVIF
         /lhr692Fi5D6T48YTc1WDvP/fbJmZrVsLPRnN/p1fisi1cFFQLLmm+WCqjdAhPRtkBhF
         p0K9L5qKlrh6i3O8eOK6COoHUvHm5POgW/pAfI24DnonvuqrSABTdX6YHaywFVgfnzml
         gtsg==
X-Gm-Message-State: AOAM533YndhHu3Z4EOf/eMYk3Gn0v3e4t7bctIFXGXpzenEE6uos5l9P
        2fYZPLl1cluffWk3BHCV+9RF3iRc81/3FHQD50/qVvtEtIEk
X-Google-Smtp-Source: ABdhPJxmG0LfNAmoxbFQy9Z6AjwcMB6i3Af6j7erW3fLmvKaKYvxXQGL+HwaT2N9Y/AXRaOfGNpsnqM2uZ9A
X-Received: by 2002:a17:90a:6389:b0:1c9:ee11:6c2c with SMTP id f9-20020a17090a638900b001c9ee116c2cmr19860434pjj.107.1649392434046;
        Thu, 07 Apr 2022 21:33:54 -0700 (PDT)
Received: from smtp.aristanetworks.com (smtp.aristanetworks.com. [54.193.82.35])
        by smtp-relay.gmail.com with ESMTPS id f18-20020a170902ce9200b001566cf99a80sm721140plg.97.2022.04.07.21.33.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Apr 2022 21:33:54 -0700 (PDT)
X-Relaying-Domain: arista.com
Received: from chmeee (unknown [10.95.70.41])
        by smtp.aristanetworks.com (Postfix) with ESMTPS id 9BB58302BF87;
        Thu,  7 Apr 2022 21:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1649392433;
        bh=9CYUHr8sc1keYeTHR45nH7V/JN2e+SSVKE6SwVUg4TY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWjhJsihO3WCswjLp2YmG/zMlEvF80hn/+Q6sZawOzo8iyX+XxFtvnJLoixZvCK2Z
         AJ4/BCBQ6jU4e4LumrcmV7aeJjVaznVHrRcE78qws2YPyP6eYVAuE/ExJ8UUiuWGvm
         MOl6TI4h9dplyHSWgPOOswDj5ZMAnOGrsPZmN099MEqnxbBuSZrA/JLOiUQLf998KO
         50hs2fS/FW+Ojz3O9eN8mN27AOJcecYS/Mdw/5QFdDsHkFXd84Z5tkb+1v9B5BFcLJ
         p8lfaSGo8NTZe8V2c1OtSUWdPidCrZZ7T6Jl9jkPaPFdED3Sa9ksSgjhX033UuWlD0
         MtvQ9PXK5MqMA==
Received: from kevmitch by chmeee with local (Exim 4.95)
        (envelope-from <kevmitch@chmeee>)
        id 1ncgJk-001kHs-5Q;
        Thu, 07 Apr 2022 21:33:52 -0700
From:   Kevin Mitchell <kevmitch@arista.com>
Cc:     kevmitch@arista.com, gal@nvidia.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v2 1/1] netfilter: conntrack: skip verification of zero UDP checksum
Date:   Thu,  7 Apr 2022 21:33:40 -0700
Message-Id: <20220408043341.416219-1-kevmitch@arista.com>
In-Reply-To: <20220405234739.269371-2-kevmitch@arista.com>
References: <20220405234739.269371-2-kevmitch@arista.com>
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The checksum is optional for UDP packets in IPv4. However nf_reject
would previously require a valid checksum to elicit a response such as
ICMP_DEST_UNREACH.

Add some logic to nf_reject_verify_csum to determine if a UDP packet has
a zero checksum and should therefore not be verified. Explicitly require
a valid checksum for IPv6 consistent RFC 2460 and with the non-netfilter
stack (see udp6_csum_zero_error).

Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
---
 include/net/netfilter/nf_reject.h   | 27 +++++++++++++++++++++++----
 net/ipv4/netfilter/nf_reject_ipv4.c | 10 +++++++---
 net/ipv6/netfilter/nf_reject_ipv6.c |  4 ++--
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_reject.h b/include/net/netfilter/nf_reject.h
index 9051c3a0c8e7..f248c1ff8b22 100644
--- a/include/net/netfilter/nf_reject.h
+++ b/include/net/netfilter/nf_reject.h
@@ -5,12 +5,34 @@
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
+			/* Checksum is required in IPv6
+			 * see RFC 2460 section 8.1
+			 */
+			if (skb->protocol == htons(ETH_P_IPV6))
+				return true;
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
@@ -19,9 +41,6 @@ static inline bool nf_reject_verify_csum(__u8 proto)
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

