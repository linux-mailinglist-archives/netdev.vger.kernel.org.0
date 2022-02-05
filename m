Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83754AA776
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 08:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379662AbiBEHsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 02:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379619AbiBEHse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 02:48:34 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F24C061347;
        Fri,  4 Feb 2022 23:48:34 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id s6so7033460plg.12;
        Fri, 04 Feb 2022 23:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9pvmS13AHWSjRM47Jhdp6MkeVnK13IvKcbnz13xDaLE=;
        b=lSIJtl9jKVNqlSJP68ZtPIvJXK7FivpbvUb8I7KHPx3pk45QxppS+wOjpoi1dApI/q
         0jmTU+VWeGpxPKbU2Z5Yy/J+b/blH4IrVfLCd5B3rVf1bRFEBRmMTforC1MvE3IaLHya
         BAXO0rFzSlwGqtYmhfDsfHvktj5xXU+wgiBkYLgbW3So4SMphCi/1pA1e8lCB8dBJO0M
         SU/biRDERDB0vZ9aED6tDpZ8/LH535441Ch0qkhZYKfX96RpkZ5TH176CrEPa20wmGcS
         fA5FSVsYh7c0jXn5vo0Hsw/woZ4mQsuRVchROTGHOFj1Xga89CgS7t/jqQRE2QKoOHs8
         wHhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9pvmS13AHWSjRM47Jhdp6MkeVnK13IvKcbnz13xDaLE=;
        b=ajg5sN+A14Ye5l9luGoRPEbk4Vn7LwoqtcNst5nBHuXxe8n7JbHens+ZAOX39znRiz
         uo+dxvnWbPgtzSZJD8RegXo2J3kSgiTMVDBEsvc4zSaT9/i4o5Nq85zndckDZE3bxThI
         XjnnSS8OBMMPY7p6oXXC5mBGGcQQtU/HBlGIwrhN3lKdbHADChHbaKSfrExs3ZnI2A6b
         wBcKuV+tC1/dwkgKN6cmiKE07/e1hzpjRVeieqEcVzDvHfg8zui5AVPmT2IGnTe6wIoD
         fNM6v3mHfJs6+kRnif+AenpdI1TOJ6PGxf/c+I0KxtENphJrJlVRanarPr0giwvqHI1a
         jO6g==
X-Gm-Message-State: AOAM5319N7cOdeNq7PAE+ra0RNLfMhPvFFBJn3KoPVD4gqymWHaauvrU
        w3IZV2In2jAjZ5knj6OR6p8=
X-Google-Smtp-Source: ABdhPJxhsnjGiJZF8PGXfpb97dgdLRQSe/8+NXuxEr2/Qmygq/RV+nnomhFmEY4MOTq91nNRfBtISA==
X-Received: by 2002:a17:902:e812:: with SMTP id u18mr7196603plg.12.1644047313617;
        Fri, 04 Feb 2022 23:48:33 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id p21sm5165844pfh.89.2022.02.04.23.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 23:48:33 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, edumazet@google.com, alobakin@pm.me, ast@kernel.org,
        imagedong@tencent.com, pabeni@redhat.com, keescook@chromium.org,
        talalahmad@google.com, haokexin@gmail.com,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        paulb@nvidia.com, cong.wang@bytedance.com, mengensun@tencent.com
Subject: [PATCH v4 net-next 7/7] net: udp: use kfree_skb_reason() in __udp_queue_rcv_skb()
Date:   Sat,  5 Feb 2022 15:47:39 +0800
Message-Id: <20220205074739.543606-8-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220205074739.543606-1-imagedong@tencent.com>
References: <20220205074739.543606-1-imagedong@tencent.com>
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

Replace kfree_skb() with kfree_skb_reason() in __udp_queue_rcv_skb().
Following new drop reasons are introduced:

SKB_DROP_REASON_SOCKET_RCVBUFF
SKB_DROP_REASON_PROTO_MEM

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 include/linux/skbuff.h     |  5 +++++
 include/trace/events/skb.h |  2 ++
 net/ipv4/udp.c             | 10 +++++++---
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2a64afa97910..a5adbf6b51e8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -341,6 +341,11 @@ enum skb_drop_reason {
 						  */
 	SKB_DROP_REASON_XFRM_POLICY,	/* xfrm policy check failed */
 	SKB_DROP_REASON_IP_NOPROTO,	/* no support for IP protocol */
+	SKB_DROP_REASON_SOCKET_RCVBUFF,	/* socket receive buff is full */
+	SKB_DROP_REASON_PROTO_MEM,	/* proto memory limition, such as
+					 * udp packet drop out of
+					 * udp_memory_allocated.
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 985e481c092d..cfcfd26399f7 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -25,6 +25,8 @@
 	   UNICAST_IN_L2_MULTICAST)				\
 	EM(SKB_DROP_REASON_XFRM_POLICY, XFRM_POLICY)		\
 	EM(SKB_DROP_REASON_IP_NOPROTO, IP_NOPROTO)		\
+	EM(SKB_DROP_REASON_SOCKET_RCVBUFF, SOCKET_RCVBUFF)	\
+	EM(SKB_DROP_REASON_PROTO_MEM, PROTO_MEM)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 952f5bf108a5..6b4d8361560f 100644
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

