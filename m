Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C754FF278
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiDMIqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234048AbiDMIqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:46:33 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D6450E32;
        Wed, 13 Apr 2022 01:44:06 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 32so1186381pgl.4;
        Wed, 13 Apr 2022 01:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g2uGX3AJpOqUTdBgIa4AzRYdxv6dc20RcbYbquov+3M=;
        b=j7Vp2QiBGWmgO/BsTPDq/NWAuOPlBJHVPcw+bnEH9wgsVb9etOZJiFGArTYdCLPW2D
         xv836atZIdezpmT/5ZKc7NrQZDoEgTC2wtrQn6TC7+CMCBAOOva1S2tLciuuv7xiyBbG
         AUyuKHDgJePte3lwB3bL1AhzC7LGiJmfWc9uL5tRO1wtoClQnGH1jLsDUsXhHdoE9zF7
         smg32EtM5qQXc3CbT6quKgn/vYcmVtZC6tGyr4Yg+99+TEjMYP9fqFjMd4G9iH9qU8/X
         RFcNMm3XEJ3xTrkGToYF1/JafDqhIry0qBHkdKmv8BqrP3MSRD2x8z9Ky7bOfFpntDpD
         D43A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g2uGX3AJpOqUTdBgIa4AzRYdxv6dc20RcbYbquov+3M=;
        b=ZjfmY9zxU7TS7c0wzuci4kKAu7uUFTSlhAkWMYli/91iw7ZQJcsE3VqZ5nXcgmp4PO
         9prwyxRr0Hy2VNarKt/MfpBbZk9Clhm80nZZ6ZwaGjjKH+Dz9iHckOCYP9PU6oqvbHYF
         LVxMgYztNdNP4aCKHNPmICN+QM1tnw6+++j+mO0pG91ky8MwURTYD7WY73kVvCZgLzqR
         ZXE92yQluZw0tjdxLCvLCp6qRFLxT/hu4njqFvPytXM9t5BEm1JQSxXP/aidcO5k5UkJ
         dG48pTOBGCXlt28+/lR2LmtfEAiTu3+ZZWD/Io828gkUTOKxWKXgES8BJeIul9fnMcsQ
         eLaQ==
X-Gm-Message-State: AOAM5319vI1KQMtVM89+eyBNfhWWtlHjs9OTHDgol3V8BFz3wFA3DZkG
        6ph8ad55Sk2EGQbjMZBEYKU=
X-Google-Smtp-Source: ABdhPJzfcEMfKn1etm+JcZXu/yPxcVNR6LpMlsMmyd+4wyYNsYAMIMnNyOaw7oKkBYSTBhcuOg/qZw==
X-Received: by 2002:a63:fe45:0:b0:39c:e41e:b7d4 with SMTP id x5-20020a63fe45000000b0039ce41eb7d4mr23235014pgj.226.1649839445934;
        Wed, 13 Apr 2022 01:44:05 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.119])
        by smtp.gmail.com with ESMTPSA id l5-20020a63f305000000b0039daaa10a1fsm2410335pgh.65.2022.04.13.01.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 01:44:05 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        benbjiang@tencent.com, flyingpeng@tencent.com,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        mengensun@tencent.com, dongli.zhang@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 4/9] net: ip: add skb drop reasons to ip forwarding
Date:   Wed, 13 Apr 2022 16:15:55 +0800
Message-Id: <20220413081600.187339-5-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413081600.187339-1-imagedong@tencent.com>
References: <20220413081600.187339-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() which is used in ip6_forward() and ip_forward()
with kfree_skb_reason().

The new drop reason 'SKB_DROP_REASON_PKT_TOO_BIG' is introduced for
the case that the length of the packet exceeds MTU and can't
fragment.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
---
 include/linux/skbuff.h     |  3 +++
 include/trace/events/skb.h |  1 +
 net/ipv4/ip_forward.c      | 13 ++++++++++---
 net/ipv6/ip6_output.c      |  9 ++++++---
 4 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 886e83ac4b70..0ef11df1bc67 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -453,6 +453,9 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_IP_INNOROUTES,	/* network unreachable, corresponding
 					 * to IPSTATS_MIB_INADDRERRORS
 					 */
+	SKB_DROP_REASON_PKT_TOO_BIG,	/* packet size is too big (maybe exceed
+					 * the MTU)
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 0acac7e5a019..2da72a9a5764 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -65,6 +65,7 @@
 	EM(SKB_DROP_REASON_INVALID_PROTO, INVALID_PROTO)	\
 	EM(SKB_DROP_REASON_IP_INADDRERRORS, IP_INADDRERRORS)	\
 	EM(SKB_DROP_REASON_IP_INNOROUTES, IP_INNOROUTES)	\
+	EM(SKB_DROP_REASON_PKT_TOO_BIG, PKT_TOO_BIG)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
index 92ba3350274b..e3aa436a1bdf 100644
--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -90,6 +90,7 @@ int ip_forward(struct sk_buff *skb)
 	struct rtable *rt;	/* Route we use */
 	struct ip_options *opt	= &(IPCB(skb)->opt);
 	struct net *net;
+	SKB_DR(reason);
 
 	/* that should never happen */
 	if (skb->pkt_type != PACKET_HOST)
@@ -101,8 +102,10 @@ int ip_forward(struct sk_buff *skb)
 	if (skb_warn_if_lro(skb))
 		goto drop;
 
-	if (!xfrm4_policy_check(NULL, XFRM_POLICY_FWD, skb))
+	if (!xfrm4_policy_check(NULL, XFRM_POLICY_FWD, skb)) {
+		SKB_DR_SET(reason, XFRM_POLICY);
 		goto drop;
+	}
 
 	if (IPCB(skb)->opt.router_alert && ip_call_ra_chain(skb))
 		return NET_RX_SUCCESS;
@@ -118,8 +121,10 @@ int ip_forward(struct sk_buff *skb)
 	if (ip_hdr(skb)->ttl <= 1)
 		goto too_many_hops;
 
-	if (!xfrm4_route_forward(skb))
+	if (!xfrm4_route_forward(skb)) {
+		SKB_DR_SET(reason, XFRM_POLICY);
 		goto drop;
+	}
 
 	rt = skb_rtable(skb);
 
@@ -132,6 +137,7 @@ int ip_forward(struct sk_buff *skb)
 		IP_INC_STATS(net, IPSTATS_MIB_FRAGFAILS);
 		icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 			  htonl(mtu));
+		SKB_DR_SET(reason, PKT_TOO_BIG);
 		goto drop;
 	}
 
@@ -169,7 +175,8 @@ int ip_forward(struct sk_buff *skb)
 	/* Tell the sender its packet died... */
 	__IP_INC_STATS(net, IPSTATS_MIB_INHDRERRORS);
 	icmp_send(skb, ICMP_TIME_EXCEEDED, ICMP_EXC_TTL, 0);
+	SKB_DR_SET(reason, IP_INHDR);
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return NET_RX_DROP;
 }
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index e23f058166af..3e729cee6486 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -469,6 +469,7 @@ int ip6_forward(struct sk_buff *skb)
 	struct inet6_skb_parm *opt = IP6CB(skb);
 	struct net *net = dev_net(dst->dev);
 	struct inet6_dev *idev;
+	SKB_DR(reason);
 	u32 mtu;
 
 	idev = __in6_dev_get_safely(dev_get_by_index_rcu(net, IP6CB(skb)->iif));
@@ -518,7 +519,7 @@ int ip6_forward(struct sk_buff *skb)
 		icmpv6_send(skb, ICMPV6_TIME_EXCEED, ICMPV6_EXC_HOPLIMIT, 0);
 		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
 
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_IP_INHDR);
 		return -ETIMEDOUT;
 	}
 
@@ -537,6 +538,7 @@ int ip6_forward(struct sk_buff *skb)
 
 	if (!xfrm6_route_forward(skb)) {
 		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
+		SKB_DR_SET(reason, XFRM_POLICY);
 		goto drop;
 	}
 	dst = skb_dst(skb);
@@ -596,7 +598,7 @@ int ip6_forward(struct sk_buff *skb)
 		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INTOOBIGERRORS);
 		__IP6_INC_STATS(net, ip6_dst_idev(dst),
 				IPSTATS_MIB_FRAGFAILS);
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_PKT_TOO_BIG);
 		return -EMSGSIZE;
 	}
 
@@ -618,8 +620,9 @@ int ip6_forward(struct sk_buff *skb)
 
 error:
 	__IP6_INC_STATS(net, idev, IPSTATS_MIB_INADDRERRORS);
+	SKB_DR_SET(reason, IP_INADDRERRORS);
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return -EINVAL;
 }
 
-- 
2.35.1

