Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8EA3E1BDD
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242127AbhHES63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241963AbhHES6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:58:20 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC9DC06179B
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 11:58:05 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id v24-20020a0568300918b02904f3d10c9742so2825355ott.4
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 11:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EgqUcHAG2vGcpdpfUay6hx8j72N34L2yrkDeZsCR+8g=;
        b=rIBKNd3iR4OCpBzAGkH5S6JawdLLkwwoYcK5YOA7ZPPXUaaCVFQZEgKtRk2nLS9+3w
         8UVdd7ol6HOyO3f58zHXcFMk4isI8IMwiDTFPofPnNAk1U+SnRcuVD7XBxUInSLYGa3i
         ogJ+XNyzum6/mi9po8tJ73x6sRk2NzYe0qWOl7aVBmEnbaDHh5ANC6nJp+VvsS2ms9gK
         FPyais9JW0+9av1chGcYKbyrZqtmDHpmIKNShglR+p+XcaW5pvNaWNTblz27W7X1OBEz
         iqA8UVSWcyevBlDSz7FIgWzI24M4kA1L9quj0CpqsOYBRSs3EhpKSWELQBDLDjO1NZ4w
         m8jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EgqUcHAG2vGcpdpfUay6hx8j72N34L2yrkDeZsCR+8g=;
        b=P17wOBecHydwpw+UPJB0Wl4ER4N3I/mn87AVWspXcwPQPggonYy+ed4zVAE41Iwnc3
         kILKbVoOmo4+FLtf4bIQ0DWKfNvBFP29h/+yrwQco2o3CoSAR0CGNf74Bcq6sflNU8B0
         Gh6ETULUFkHOg4HEBveE1CILRA58Gg9W2smJWkA8FuW+dytImGg4FMTa38LeD0E7S3zZ
         0asay0ATarO17D2pn6PX9OBXt+LCBCZdBycu+9Jj8/oV48OK2M/+bT3GJS5dcnCbQ6a1
         YDScjCzncWdgnp9klAxdCzvR6c26cJf0QcKvWWdTLIxMcJFw8gkLq4nqPvXD3StiQb2Z
         B74Q==
X-Gm-Message-State: AOAM530A5gPY7WpqRQiSztA6j9CE58Ztngr3UwHJw5QdcyFVPxIb7QaU
        gaSgW4CO0KEg6pTEuGS3Ld80r1egzU0=
X-Google-Smtp-Source: ABdhPJxjQmGYINWWR+9NB5HoR4duuCb3QnFoiNis8vpbKNkwD24usAaS6OCjJu0tl9skTwdfYYJNYQ==
X-Received: by 2002:a9d:6a93:: with SMTP id l19mr2448355otq.252.1628189885081;
        Thu, 05 Aug 2021 11:58:05 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c64b:2366:2e53:c024])
        by smtp.gmail.com with ESMTPSA id r5sm358678otk.71.2021.08.05.11.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:58:04 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next 12/13] ipv6: introduce tracepoint trace_tcp_v6_rcv()
Date:   Thu,  5 Aug 2021 11:57:49 -0700
Message-Id: <20210805185750.4522-13-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Tracepoint trace_tcp_v6_rcv() is introduced to trace skb
at the entrance of TCPv6 on RX side.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/tcp.h | 9 +++++++++
 net/core/net-traces.c      | 1 +
 net/ipv6/tcp_ipv6.c        | 3 +++
 3 files changed, 13 insertions(+)

diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index adf84866dee9..f788ac43c4bf 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -116,6 +116,15 @@ DEFINE_EVENT(tcp_event_sk_skb, tcp_v4_rcv,
 	TP_ARGS(sk, skb)
 );
 
+#if IS_ENABLED(CONFIG_IPV6)
+DEFINE_EVENT(tcp_event_sk_skb, tcp_v6_rcv,
+
+	TP_PROTO(const struct sock *sk, const struct sk_buff *skb),
+
+	TP_ARGS(sk, skb)
+);
+#endif
+
 /*
  * skb of trace_tcp_send_reset is the skb that caused RST. In case of
  * active reset, skb should be NULL
diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index 83df315708ba..e0840efe479a 100644
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@ -66,4 +66,5 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(tcp_bad_csum);
 EXPORT_TRACEPOINT_SYMBOL_GPL(udp_v6_send_skb);
 EXPORT_TRACEPOINT_SYMBOL_GPL(ipv6_rcv);
 EXPORT_TRACEPOINT_SYMBOL_GPL(udpv6_rcv);
+EXPORT_TRACEPOINT_SYMBOL_GPL(tcp_v6_rcv);
 #endif
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0ce52d46e4f8..eb9586d798b7 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1765,6 +1765,9 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	bh_unlock_sock(sk);
 	if (skb_to_free)
 		__kfree_skb(skb_to_free);
+	if (!ret)
+		trace_tcp_v6_rcv(sk, skb);
+
 put_and_return:
 	if (refcounted)
 		sock_put(sk);
-- 
2.27.0

