Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589E2481B28
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 10:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238373AbhL3JdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 04:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238389AbhL3JdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 04:33:17 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8620DC061401;
        Thu, 30 Dec 2021 01:33:17 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id w24so17852588ply.12;
        Thu, 30 Dec 2021 01:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hLhOt4oAKEoBQ8Mh83vcTQErz7uX8CzDjKjnYPRBdKw=;
        b=TjZFYY6aMR6riflOoKrCejyNab82OH6OFe5xmQCvrj1Ou95VB5wdiqBP0a1KM+M8aQ
         VVZ4Lr+Mc8DGhOgq5p0Hbr1nLBu/6wLqQxqhgKA1CfijnJk6aLCqp44tqXFXUlyLWMfm
         YV/K4Hog2KLFk6PnzG2qODTF5Txb4tXKj4Tx1UCovClQESZc8nilmCdN0994EQQmvYgF
         YMpGIu8ho6GjlG/7ToRV5AhApKgOq26n9sdo/rrpaEUwnN4n6qxDTAn0HYHOcHj+eez4
         KJPswjLnr2r+mToLukpuWZ3tbJgDQtIqOBfct7m2Uk/67bXl+dSZe1/ZEV53j0LvAQoZ
         Fs1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hLhOt4oAKEoBQ8Mh83vcTQErz7uX8CzDjKjnYPRBdKw=;
        b=JsgEmJXfo+jf3fLkYFn5LUJMudAKnkqGuPj9CAsKZRhNMFypsctWdZorC8r0aupR0R
         CULCjfiHFn7KttVx530S9l1jLfrq43y36e5SC2M0nuxJ4lL2EtEBj2mMfm2rItDiuxTQ
         CG3VZql6XsyuoNdCivEKpEvqpYngsw5Rjyh+XO4B/8w6j3xePOpw8gRiQfaS+Istl0nm
         niqZFrztX45wP5Bo5vfEzQXWssqm1QT0qeBXVl7cwyMzY7DhqIDm7u9yGRNmcfmkwJor
         Q8rQcbPSoCvWCdGep8INZ6t5Mqq0N9osej9Avwb9Dj6Cj7bUb2Qlj7rnyDbIJ1R1JXfA
         WmrQ==
X-Gm-Message-State: AOAM531pgvGVwmMnZdGLTaN7TtK+GC6ZLmj+Hej2JkObyWMokkU2MgHL
        ojHrJP5OnWa/TVsUmK9JMpA=
X-Google-Smtp-Source: ABdhPJxlPxVRcx3M5gcSjYd6AAzcuxgZwfM/7FrYYkG14UdtPr3Z3v7FOBuP1VfLqaqFaxskxHOZTQ==
X-Received: by 2002:a17:903:32c7:b0:149:7657:bbaf with SMTP id i7-20020a17090332c700b001497657bbafmr21373356plr.156.1640856797104;
        Thu, 30 Dec 2021 01:33:17 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id f4sm23231052pfj.25.2021.12.30.01.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 01:33:16 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     rostedt@goodmis.org, dsahern@kernel.org
Cc:     mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        nhorman@tuxdriver.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, jonathan.lemon@gmail.com, alobakin@pm.me,
        keescook@chromium.org, pabeni@redhat.com, talalahmad@google.com,
        haokexin@gmail.com, imagedong@tencent.com, atenart@kernel.org,
        bigeasy@linutronix.de, weiwan@google.com, arnd@arndb.de,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mengensun@tencent.com, mungerjiang@tencent.com
Subject: [PATCH net-next 3/3] net: skb: use kfree_skb_with_reason() in __udp4_lib_rcv()
Date:   Thu, 30 Dec 2021 17:32:40 +0800
Message-Id: <20211230093240.1125937-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211230093240.1125937-1-imagedong@tencent.com>
References: <20211230093240.1125937-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_with_reason() in __udp4_lib_rcv.
New drop reason 'SKB_DROP_REASON_UDP_CSUM' is added for udp csum
error.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     |  1 +
 include/trace/events/skb.h |  1 +
 net/ipv4/udp.c             | 10 ++++++++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 43cb3b75b5af..f0c6949fd19c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -317,6 +317,7 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_PKT_TOO_SMALL,
 	SKB_DROP_REASON_TCP_CSUM,
 	SKB_DROP_REASON_TCP_FILTER,
+	SKB_DROP_REASON_UDP_CSUM,
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index c6f4ecf6781e..f616547dddc6 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -15,6 +15,7 @@
 	EM(SKB_DROP_REASON_PKT_TOO_SMALL, PKT_TOO_SMALL)	\
 	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
 	EM(SKB_DROP_REASON_TCP_FILTER, TCP_FILTER)		\
+	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
 	EMe(SKB_DROP_REASON_MAX, HAHA_MAX)
 
 #undef EM
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index f376c777e8fc..463a5adcaacf 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2410,6 +2410,9 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	__be32 saddr, daddr;
 	struct net *net = dev_net(skb->dev);
 	bool refcounted;
+	int drop_reason;
+
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 	/*
 	 *  Validate the packet.
@@ -2465,6 +2468,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	if (udp_lib_checksum_complete(skb))
 		goto csum_error;
 
+	drop_reason = SKB_DROP_REASON_NO_SOCKET;
 	__UDP_INC_STATS(net, UDP_MIB_NOPORTS, proto == IPPROTO_UDPLITE);
 	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
 
@@ -2472,10 +2476,11 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	 * Hmm.  We got an UDP packet to a port to which we
 	 * don't wanna listen.  Ignore it.
 	 */
-	kfree_skb(skb);
+	kfree_skb_with_reason(skb, drop_reason);
 	return 0;
 
 short_packet:
+	drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 	net_dbg_ratelimited("UDP%s: short packet: From %pI4:%u %d/%d to %pI4:%u\n",
 			    proto == IPPROTO_UDPLITE ? "Lite" : "",
 			    &saddr, ntohs(uh->source),
@@ -2488,6 +2493,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	 * RFC1122: OK.  Discards the bad packet silently (as far as
 	 * the network is concerned, anyway) as per 4.1.3.4 (MUST).
 	 */
+	drop_reason = SKB_DROP_REASON_UDP_CSUM;
 	net_dbg_ratelimited("UDP%s: bad checksum. From %pI4:%u to %pI4:%u ulen %d\n",
 			    proto == IPPROTO_UDPLITE ? "Lite" : "",
 			    &saddr, ntohs(uh->source), &daddr, ntohs(uh->dest),
@@ -2495,7 +2501,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	__UDP_INC_STATS(net, UDP_MIB_CSUMERRORS, proto == IPPROTO_UDPLITE);
 drop:
 	__UDP_INC_STATS(net, UDP_MIB_INERRORS, proto == IPPROTO_UDPLITE);
-	kfree_skb(skb);
+	kfree_skb_with_reason(skb, drop_reason);
 	return 0;
 }
 
-- 
2.30.2

