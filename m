Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506D148883F
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 07:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbiAIGhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 01:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235232AbiAIGhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 01:37:31 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FD7C06173F;
        Sat,  8 Jan 2022 22:37:31 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id rj2-20020a17090b3e8200b001b1944bad25so12739801pjb.5;
        Sat, 08 Jan 2022 22:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UcJQ/igXAjjb9zNSIv1UStOkEDIB31SAlch2s5VfL8E=;
        b=b0zG8TMNq3nA8wFcRolEprDd4XNA3SPwY4VAAbPkyPIuz1jdhggxVNSo/1CuBuDTN+
         dtHyoZVQpkZdMmMAMA4KhuAtCharfnSKJ4l/YUQYy1j0Zl3X1FXOifsOgaUHUvSF2kP4
         +bC97V/uZCb6VOYyDL8Lv6DRcpixfmGxTj3dJPXxvNtPWn+JSAjvZHFRLe6YT9vS0dCA
         2Dx2XDH75JNxNWlGqc5dkMxGiQpPQl64iwiWlvlCXKBhyzx56Cppy1iap0v5RrXT1iTq
         zOXjYkqM/5cbdTbEzuu/4HxDWv3wN3A9QenKXpBR6JodINWSd3lldQepLgIIUmMH777S
         w57Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UcJQ/igXAjjb9zNSIv1UStOkEDIB31SAlch2s5VfL8E=;
        b=5GhkPCtYuV/xGTxkGGwhMMWGEOm0zEwKyVLoiR809hceQ2J0e3GrZtTIDjiREM4xxZ
         lJVmyVeQ3YKht5J3Dn9n5urVARg7C5vnxtOGjomHJV+e5VhBsOOab7r3DPeNq2nVVS8g
         673pXxo11JJ2tNOZ3eOm5wnFsQm6L9N1ug25Jqa0HP5V5wmeQ5z2dxGpzwYlEahVprp8
         p/4Ai78qwyLqUfUh4qWVGpwUuWGbedA8j03k32i+2o3jZWmMTQKdJKPjecGd0RGsjHD4
         ooZz3IXvyMktgRc4oQcUWCsh0ntnp2XApho6knFaWLiKtLyAhfmfUPjWkQmpiMNvdKr4
         uiBQ==
X-Gm-Message-State: AOAM5324uFI6AwT5swKD0BEx2WR8SDoFjCjYENkp+t+NK8QQeEKGe/H7
        Xu3JbjyN+qSi9xiPs9fVGNk=
X-Google-Smtp-Source: ABdhPJxYaoPNAgqxcQgPhtgvwmWfjK2iJdfLj1vXmnMpMQ73BUjhgWGuQn9FIh0bomxs/D0R/U01wQ==
X-Received: by 2002:a17:90a:c254:: with SMTP id d20mr1961989pjx.226.1641710250797;
        Sat, 08 Jan 2022 22:37:30 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id my5sm5892042pjb.5.2022.01.08.22.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 22:37:30 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     rostedt@goodmis.org, dsahern@kernel.org
Cc:     mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        nhorman@tuxdriver.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, alobakin@pm.me, willemb@google.com,
        cong.wang@bytedance.com, keescook@chromium.org, pabeni@redhat.com,
        talalahmad@google.com, haokexin@gmail.com,
        ilias.apalodimas@linaro.org, memxor@gmail.com, atenart@kernel.org,
        bigeasy@linutronix.de, weiwan@google.com, arnd@arndb.de,
        vvs@virtuozzo.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        imagedong@tencent.com
Subject: [PATCH v4 net-next 2/3] net: skb: use kfree_skb_reason() in tcp_v4_rcv()
Date:   Sun,  9 Jan 2022 14:36:27 +0800
Message-Id: <20220109063628.526990-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220109063628.526990-1-imagedong@tencent.com>
References: <20220109063628.526990-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in tcp_v4_rcv(). Following
drop reasons are added:

SKB_DROP_REASON_NO_SOCKET
SKB_DROP_REASON_PKT_TOO_SMALL
SKB_DROP_REASON_TCP_CSUM
SKB_DROP_REASON_TCP_FILTER

After this patch, 'kfree_skb' event will print message like this:

$           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
$              | |         |   |||||     |         |
          <idle>-0       [000] ..s1.    36.113438: kfree_skb: skbaddr=(____ptrval____) protocol=2048 location=(____ptrval____) reason: NO_SOCKET

The reason of skb drop is printed too.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v3:
- rename kfree_skb_with_reason() to kfree_skb_reason()

v2:
- rename some reason name as David suggested
- add the new reason: SKB_DROP_REASON_TCP_FILTER
---
 include/linux/skbuff.h     |  4 ++++
 include/trace/events/skb.h |  4 ++++
 net/ipv4/tcp_ipv4.c        | 14 +++++++++++---
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ef0870abc791..c9c97b0d0fe9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -313,6 +313,10 @@ struct sk_buff;
  */
 enum skb_drop_reason {
 	SKB_DROP_REASON_NOT_SPECIFIED,
+	SKB_DROP_REASON_NO_SOCKET,
+	SKB_DROP_REASON_PKT_TOO_SMALL,
+	SKB_DROP_REASON_TCP_CSUM,
+	SKB_DROP_REASON_TCP_FILTER,
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index b5ef652e5a93..c16febea9f62 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -11,6 +11,10 @@
 
 #define TRACE_SKB_DROP_REASON					\
 	EM(SKB_DROP_REASON_NOT_SPECIFIED, NOT_SPECIFIED)	\
+	EM(SKB_DROP_REASON_NO_SOCKET, NO_SOCKET)		\
+	EM(SKB_DROP_REASON_PKT_TOO_SMALL, PKT_TOO_SMALL)	\
+	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
+	EM(SKB_DROP_REASON_TCP_FILTER, TCP_FILTER)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ac10e4cdd8d0..f83efcc6e76e 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1971,8 +1971,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	const struct tcphdr *th;
 	bool refcounted;
 	struct sock *sk;
+	int drop_reason;
 	int ret;
 
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (skb->pkt_type != PACKET_HOST)
 		goto discard_it;
 
@@ -1984,8 +1986,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	th = (const struct tcphdr *)skb->data;
 
-	if (unlikely(th->doff < sizeof(struct tcphdr) / 4))
+	if (unlikely(th->doff < sizeof(struct tcphdr) / 4)) {
+		drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 		goto bad_packet;
+	}
 	if (!pskb_may_pull(skb, th->doff * 4))
 		goto discard_it;
 
@@ -2090,8 +2094,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	nf_reset_ct(skb);
 
-	if (tcp_filter(sk, skb))
+	if (tcp_filter(sk, skb)) {
+		drop_reason = SKB_DROP_REASON_TCP_FILTER;
 		goto discard_and_relse;
+	}
 	th = (const struct tcphdr *)skb->data;
 	iph = ip_hdr(skb);
 	tcp_v4_fill_cb(skb, iph, th);
@@ -2124,6 +2130,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	return ret;
 
 no_tcp_socket:
+	drop_reason = SKB_DROP_REASON_NO_SOCKET;
 	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto discard_it;
 
@@ -2131,6 +2138,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	if (tcp_checksum_complete(skb)) {
 csum_error:
+		drop_reason = SKB_DROP_REASON_TCP_CSUM;
 		trace_tcp_bad_csum(skb);
 		__TCP_INC_STATS(net, TCP_MIB_CSUMERRORS);
 bad_packet:
@@ -2141,7 +2149,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 discard_it:
 	/* Discard frame. */
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return 0;
 
 discard_and_relse:
-- 
2.30.2

