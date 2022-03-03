Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D18F4CC4DF
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbiCCSRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235658AbiCCSRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:17:21 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D911A3628
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 10:16:35 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id q11so5311549pln.11
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 10:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+CSkEctJW7GjpAww/3igLK3CdQysYQhPQmjkKqHIjNs=;
        b=mZyR2EadcOUIHTaWhY3u+CiPwN9j8gIBObEy6N1BnEY5J8+BNgF4LFvx5TaLBKzMBG
         j0/4jzu0V6Mbm6kJfrTzTv27cJuxBxIUvNCUJ/48HOV2+oz8lnU8+MvgmdeEcoDK+edh
         faC7jiSrTKWiQdabRrOx9iK1LTXThpu7YlWrKWx6dOWm4G14xMvvJwYeesvsD6+Wpi2s
         AlPhLt8qGiTYD6sS8WfPoAXrz/DchIuIdGkP3miq3qEeyXycVdf8t7kwm3wrEoaDGhDV
         GFU+AN2HD8gnXLEynfgAWvKQhQI4/d2LK41IAShE9mgGZFmMhWzbX1jcCvM9yF99xSMT
         TmrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+CSkEctJW7GjpAww/3igLK3CdQysYQhPQmjkKqHIjNs=;
        b=1Bkx4pahSrpj9+f5PtXBFXKxbdHRQZIB0f7BQDUi08GK9n9H3E7Ztd7l3CANJ+67RM
         JtgffXt/q3fJt8JPyp+aKmJEVa8fpGJsx0lCbtJ3llyelY+hUIBV1ybPzEiHoa3tbUxK
         7C/sZwRNco4lZTbsINBLtaW20z1WTAfESeiAqr8mA+AKzRx9XHUZMGPKj4poWMrsoMOb
         A7Hb+x5giVg7lilQ5oELaFU7C7w3ZeL2dhEyO/yolYPnZwsAtAiHUxEgB8C8VqLxDr2F
         wXXbn8ai57iMuyJbUYTZkDHD4gVsDcTamE10imVg8H60DNh/XZeoEMIe1y3kn0ADqjdB
         70dg==
X-Gm-Message-State: AOAM530dVeepFPmnGr1tFIc2HvOvrSA3Vodmr5+SkBBc9wciUQsgPPto
        FbCOlXFD16X8RqT5fPZ9dLA=
X-Google-Smtp-Source: ABdhPJx5far9y2kRX00O1YKDpCMmpV/NPN1YggHkmY4sBULN0E/IcO+9xNFN+IjFwTIk9wZEfCtIWg==
X-Received: by 2002:a17:90a:7c09:b0:1bc:a2fd:d4d8 with SMTP id v9-20020a17090a7c0900b001bca2fdd4d8mr6731942pjf.73.1646331395353;
        Thu, 03 Mar 2022 10:16:35 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5388:c313:5e37:a261])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090adb4e00b001bee5dd39basm7611016pjx.1.2022.03.03.10.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:16:34 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        David Ahern <dsahern@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 05/14] ipv6/gso: remove temporary HBH/jumbo header
Date:   Thu,  3 Mar 2022 10:15:58 -0800
Message-Id: <20220303181607.1094358-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220303181607.1094358-1-eric.dumazet@gmail.com>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

ipv6 tcp and gro stacks will soon be able to build big TCP packets,
with an added temporary Hop By Hop header.

If GSO is involved for these large packets, we need to remove
the temporary HBH header before segmentation happens.

v2: perform HBH removal from ipv6_gso_segment() instead of
    skb_segment() (Alexander feedback)

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ipv6.h     | 33 +++++++++++++++++++++++++++++++++
 net/ipv6/ip6_offload.c | 24 +++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 95f405cde9e539d7909b6b89af2b956655f38b94..efe0025bdbb9668ceb01989705ce8bccbf592350 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -467,6 +467,39 @@ bool ipv6_opt_accepted(const struct sock *sk, const struct sk_buff *skb,
 struct ipv6_txoptions *ipv6_update_options(struct sock *sk,
 					   struct ipv6_txoptions *opt);
 
+/* This helper is specialized for BIG TCP needs.
+ * It assumes the hop_jumbo_hdr will immediately follow the IPV6 header.
+ * It assumes headers are already in skb->head.
+ * Returns 0, or IPPROTO_TCP if a BIG TCP packet is there.
+ */
+static inline int ipv6_has_hopopt_jumbo(const struct sk_buff *skb)
+{
+	const struct hop_jumbo_hdr *jhdr;
+	const struct ipv6hdr *nhdr;
+
+	if (likely(skb->len <= GRO_MAX_SIZE))
+		return 0;
+
+	if (skb->protocol != htons(ETH_P_IPV6))
+		return 0;
+
+	if (skb_network_offset(skb) +
+	    sizeof(struct ipv6hdr) +
+	    sizeof(struct hop_jumbo_hdr) > skb_headlen(skb))
+		return 0;
+
+	nhdr = ipv6_hdr(skb);
+
+	if (nhdr->nexthdr != NEXTHDR_HOP)
+		return 0;
+
+	jhdr = (const struct hop_jumbo_hdr *) (nhdr + 1);
+	if (jhdr->tlv_type != IPV6_TLV_JUMBO || jhdr->hdrlen != 0 ||
+	    jhdr->nexthdr != IPPROTO_TCP)
+		return 0;
+	return jhdr->nexthdr;
+}
+
 static inline bool ipv6_accept_ra(struct inet6_dev *idev)
 {
 	/* If forwarding is enabled, RA are not accepted unless the special
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index c4fc03c1ac99dbecd92e2b47b2db65374197434d..a6a6c1539c28d242ef8c35fcd5ce900512ce912d 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -77,7 +77,7 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	struct ipv6hdr *ipv6h;
 	const struct net_offload *ops;
-	int proto;
+	int proto, nexthdr;
 	struct frag_hdr *fptr;
 	unsigned int payload_len;
 	u8 *prevhdr;
@@ -87,6 +87,28 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
 	bool gso_partial;
 
 	skb_reset_network_header(skb);
+	nexthdr = ipv6_has_hopopt_jumbo(skb);
+	if (nexthdr) {
+		const int hophdr_len = sizeof(struct hop_jumbo_hdr);
+		int err;
+
+		err = skb_cow_head(skb, 0);
+		if (err < 0)
+			return ERR_PTR(err);
+
+		/* remove the HBH header.
+		 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
+		 */
+		memmove(skb_mac_header(skb) + hophdr_len,
+			skb_mac_header(skb),
+			ETH_HLEN + sizeof(struct ipv6hdr));
+		skb->data += hophdr_len;
+		skb->len -= hophdr_len;
+		skb->network_header += hophdr_len;
+		skb->mac_header += hophdr_len;
+		ipv6h = (struct ipv6hdr *)skb->data;
+		ipv6h->nexthdr = nexthdr;
+	}
 	nhoff = skb_network_header(skb) - skb_mac_header(skb);
 	if (unlikely(!pskb_may_pull(skb, sizeof(*ipv6h))))
 		goto out;
-- 
2.35.1.616.g0bdcbb4464-goog

