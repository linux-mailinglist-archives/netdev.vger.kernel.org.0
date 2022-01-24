Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F384980DA
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 14:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243132AbiAXNQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 08:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243051AbiAXNQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 08:16:22 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4AEC06173B;
        Mon, 24 Jan 2022 05:16:21 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id nn16-20020a17090b38d000b001b56b2bce31so5921760pjb.3;
        Mon, 24 Jan 2022 05:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ppg6e0FUc7/+T7KoOP2mY3oDf3knGfZ3sgY11AP0m8c=;
        b=N5OpEeEZ2HG1lv9lhr/M0WNCOXjyW8crtPrGnqtEsi58aHeDVaonh/NC4L+/NAr7jA
         1Au/zsIikA/hhJtAOy/Si8ivuFNx1hnQKBRgA2qw0GqeQY2IKv3k52SkBbLBaAKDznR9
         jrEOQKcvWyqCAP7BoXZ2bih7m40BjApEvhdrNyV4yiBb++3LyIbtBXM4vXFHpn3nQilf
         YF4/RSVA+GM3cDZ7i/WEFCWJEiEw2me/ekjvL3M4jRmrlQ4/mcLp649Mjz+cGpMZQyLb
         yzeCQVHYhdT/wPs0FwtuZww57l9VZfgooDbnpp59W5lzDMtNjxNpmIEyF/GT3pCNk/X+
         jLoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ppg6e0FUc7/+T7KoOP2mY3oDf3knGfZ3sgY11AP0m8c=;
        b=QqsVU4C75YS+WaVCAnSJVq2TodjjoNMl1PpfJqmpUJIlgpMQ07yVTDTG19IPRvRSQl
         8sWP7mR+Fr41fWjwC82u0kWU9sm1gFCGzgXvQaypTT48j39tg8Idy5vTlC0zjih1BA3X
         KYWY9eI3qelOIkXiMLkUmm/P85q5IU7WzgtXqYD267rEASnCEOay0Z0TT0Yi2+V8N/8I
         8Jgim2VZjeiHcaR/bfyvMrR4oCttFizds+k1Vgns2Al3qRUbGTD8N988BxtxCMIBKCpO
         nS5CwPnfQ1xHYqD1rJ12D1FJKEPbTo+7w+NXnyu+KWoHn0kh59FmNWnn7N4rYPteGhNk
         J8ew==
X-Gm-Message-State: AOAM532GuMfNFN1+2hzm2+Ch4M985avV+KJJg0/Spn1+Ba5RYMTgKGR/
        k60NXsW4m/C/cV6X8KGzkig=
X-Google-Smtp-Source: ABdhPJxQNeH7Fa20w+9Hv2sUuwO57UWFPyWYTuKKQZ9D1pnJMIjizaXst04CmDMwtEPTRWhI7VmoYA==
X-Received: by 2002:a17:903:32c1:b0:14b:3c0c:9118 with SMTP id i1-20020a17090332c100b0014b3c0c9118mr7867771plr.58.1643030181201;
        Mon, 24 Jan 2022 05:16:21 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id j11sm16508806pfu.55.2022.01.24.05.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 05:16:20 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, paulb@nvidia.com,
        pabeni@redhat.com, talalahmad@google.com, haokexin@gmail.com,
        keescook@chromium.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com
Subject: [PATCH net-next 6/6] net: udp: use kfree_skb_reason() in __udp_queue_rcv_skb()
Date:   Mon, 24 Jan 2022 21:15:38 +0800
Message-Id: <20220124131538.1453657-7-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220124131538.1453657-1-imagedong@tencent.com>
References: <20220124131538.1453657-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in __udp_queue_rcv_skb().
Following new drop reasons are introduced:

SKB_DROP_REASON_SOCKET_RCVBUFF
SKB_DROP_REASON_PROTO_MEM

For example, following log will be printed by ftrace when udp socket
receive buff overflow:

> 3345.537796: kfree_skb: skbaddr=00000000f013dfb6 protocol=2048 location=00000000c74d2ddd reason: SOCKET_RCVBUFF
> 3345.638805: kfree_skb: skbaddr=00000000cbc73bc7 protocol=2048 location=00000000c74d2ddd reason: SOCKET_RCVBUFF
> 3345.739975: kfree_skb: skbaddr=00000000717f24bb protocol=2048 location=00000000c74d2ddd reason: SOCKET_RCVBUFF
> 3345.841172: kfree_skb: skbaddr=00000000c62d20e9 protocol=2048 location=00000000c74d2ddd reason: SOCKET_RCVBUFF
> 3345.941353: kfree_skb: skbaddr=000000007eea9d4d protocol=2048 location=00000000c74d2ddd reason: SOCKET_RCVBUFF
> 3346.042610: kfree_skb: skbaddr=00000000c62d20e9 protocol=2048 location=00000000c74d2ddd reason: SOCKET_RCVBUFF
> 3346.142723: kfree_skb: skbaddr=00000000717f24bb protocol=2048 location=00000000c74d2ddd reason: SOCKET_RCVBUFF
> 3346.242785: kfree_skb: skbaddr=00000000cbc73bc7 protocol=2048 location=00000000c74d2ddd reason: SOCKET_RCVBUFF

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     |  5 +++++
 include/trace/events/skb.h |  2 ++
 net/ipv4/udp.c             | 10 +++++++---
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index dd64a4f2ff1d..723fc1cbbe3c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -331,6 +331,11 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_XFRM_POLICY,
 	SKB_DROP_REASON_IP_NOPROTO,
 	SKB_DROP_REASON_UDP_FILTER,
+	SKB_DROP_REASON_SOCKET_RCVBUFF,	/* socket receive buff is full */
+	SKB_DROP_REASON_PROTO_MEM,	/* proto memory limition, such as
+					 * udp packet drop out of
+					 * udp_memory_allocated.
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 6db61ce4d6f5..0496bbb0fe08 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -28,6 +28,8 @@
 	EM(SKB_DROP_REASON_XFRM_POLICY, XFRM_POLICY)		\
 	EM(SKB_DROP_REASON_IP_NOPROTO, IP_NOPROTO)		\
 	EM(SKB_DROP_REASON_UDP_FILTER, UDP_FILTER)		\
+	EM(SKB_DROP_REASON_SOCKET_RCVBUFF, SOCKET_RCVBUFF)	\
+	EM(SKB_DROP_REASON_PROTO_MEM, PROTO_MEM)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 57681e98e6bf..ca9ed24704ec 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2093,16 +2093,20 @@ static int __udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	rc = __udp_enqueue_schedule_skb(sk, skb);
 	if (rc < 0) {
 		int is_udplite = IS_UDPLITE(sk);
+		int drop_reason;
 
 		/* Note that an ENOMEM error is charged twice */
-		if (rc == -ENOMEM)
+		if (rc == -ENOMEM) {
 			UDP_INC_STATS(sock_net(sk), UDP_MIB_RCVBUFERRORS,
 					is_udplite);
-		else
+			drop_reason = SKB_DROP_REASON_SOCKET_RCVBUFF;
+		} else {
 			UDP_INC_STATS(sock_net(sk), UDP_MIB_MEMERRORS,
 				      is_udplite);
+			drop_reason = SKB_DROP_REASON_PROTO_MEM;
+		}
 		UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
-		kfree_skb(skb);
+		kfree_skb_reason(skb, drop_reason);
 		trace_udp_fail_queue_rcv_skb(rc, sk);
 		return -1;
 	}
-- 
2.34.1

