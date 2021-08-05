Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433193E1BDE
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241994AbhHES6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241976AbhHES6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:58:21 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA216C06179C
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 11:58:06 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id x15-20020a05683000cfb02904d1f8b9db81so6165500oto.12
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 11:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TfANmzxuxCY2gvVM/g2uHx9GgAPY4q4Zm0u5kvWrtVE=;
        b=qiom+Gue2FS4mIZMbZPuH6HG899nTXv0Tvb0mP82YiFve1hUd4znCCg0VQ+zloUC61
         cZk53WupcbWo0rMy1lm9CC7A8T7GmQVeFM9knFs+QAkYVm25m/lB8wV6PGNyJep6I/RL
         AvRgBeWksrOL9wuoyLCA+44BBlt6ijZhq8uAxVXhY7HKlQRO0caqb1lTC6qi7fd/iYlM
         4xqUVi9n9FMtECg0pF98cZVGjbZ6wcNm399+MEyePRifC9EUifuwl1PA4eRLBIZD5VLS
         GcF2lghXsHOiUf8cHR/ojSkyej9XMK5Uytpd5WqKX1VGUbX/WNTjr4Ht9e5EyXwlu6k7
         RlWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TfANmzxuxCY2gvVM/g2uHx9GgAPY4q4Zm0u5kvWrtVE=;
        b=KE/xhVL023PEuHAw77QggyxyaZie/AO77i9EnVYlRsSnw67dAerLLX2kb3BkznZIzC
         OMEqqJn8TmFu/af3zCxUM/TCXWvDZmNmcbUqvrBoVFkmTlp7EtFxKs/Kn7wjb9876Enf
         HvgR0+4Coz5NjvUrqkWM5xl69gZ/JeoBB7PoCciL816NgXQEMHQOszQ+9DJLazjxG62A
         cjJnAKl2CQaffItdZm1yl/DIt9/mJ7objz1zndUBMSu/5AGjYUInnqAP8PBqQAsjNo5P
         WBRo+jj54+phjL30okLMSw/aCe6ebAp5WqQyzN5ypiEGZ5x7XVh/X/bqjvV/h2FZWnGz
         mQyw==
X-Gm-Message-State: AOAM530OIyIXgu6ViT2UadNypnhs+ht7FbU3JtAv5Oew1Q1pzIgQAn+d
        bT1InBSXiekpy3qkVzmJkN8XQ3cOEqM=
X-Google-Smtp-Source: ABdhPJyUH6p3ypu0Ow/W/piO27aKavA0yS+cPHnJOphWnvv0ZRuMnyHneMh8gdTyqipT+rfNrEdB8g==
X-Received: by 2002:a05:6830:278b:: with SMTP id x11mr4954674otu.146.1628189885946;
        Thu, 05 Aug 2021 11:58:05 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c64b:2366:2e53:c024])
        by smtp.gmail.com with ESMTPSA id r5sm358678otk.71.2021.08.05.11.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:58:05 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next 13/13] sock: introduce tracepoint trace_sk_data_ready()
Date:   Thu,  5 Aug 2021 11:57:50 -0700
Message-Id: <20210805185750.4522-14-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Tracepoint trace_sk_data_ready is introduced to trace skb
at exit of socket layer on RX side. Here we only implement
it for UDP and TCP.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/sock.h | 19 +++++++++++++++++++
 net/ipv4/tcp_input.c        |  8 +++++++-
 net/ipv4/udp.c              |  5 ++++-
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index 12c315782766..860d8b0f02c5 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -261,6 +261,25 @@ TRACE_EVENT(inet_sk_error_report,
 		  __entry->error)
 );
 
+TRACE_EVENT(sk_data_ready,
+
+	TP_PROTO(const struct sock *sk, const struct sk_buff *skb),
+
+	TP_ARGS(sk, skb),
+
+	TP_STRUCT__entry(
+		__field(const void *, skaddr)
+		__field(const void *, skbaddr)
+	),
+
+	TP_fast_assign(
+		__entry->skaddr = sk;
+		__entry->skbaddr = skb;
+	),
+
+	TP_printk("skaddr=%px, skbaddr=%px", __entry->skaddr, __entry->skbaddr)
+);
+
 #endif /* _TRACE_SOCK_H */
 
 /* This part must be outside protection */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3f7bd7ae7d7a..16edb9d37529 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -77,6 +77,7 @@
 #include <asm/unaligned.h>
 #include <linux/errqueue.h>
 #include <trace/events/tcp.h>
+#include <trace/events/sock.h>
 #include <linux/jump_label_ratelimit.h>
 #include <net/busy_poll.h>
 #include <net/mptcp.h>
@@ -5034,6 +5035,8 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 
 		tcp_fast_path_check(sk);
 
+		if (!sock_flag(sk, SOCK_DEAD))
+			trace_sk_data_ready(sk, skb);
 		if (eaten > 0)
 			kfree_skb_partial(skb, fragstolen);
 		if (!sock_flag(sk, SOCK_DEAD))
@@ -5601,8 +5604,10 @@ static void tcp_urg(struct sock *sk, struct sk_buff *skb, const struct tcphdr *t
 			if (skb_copy_bits(skb, ptr, &tmp, 1))
 				BUG();
 			tp->urg_data = TCP_URG_VALID | tmp;
-			if (!sock_flag(sk, SOCK_DEAD))
+			if (!sock_flag(sk, SOCK_DEAD)) {
+				trace_sk_data_ready(sk, skb);
 				sk->sk_data_ready(sk);
+			}
 		}
 	}
 }
@@ -5894,6 +5899,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 
 			__tcp_ack_snd_check(sk, 0);
 no_ack:
+			trace_sk_data_ready(sk, skb);
 			if (eaten)
 				kfree_skb_partial(skb, fragstolen);
 			tcp_data_ready(sk);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 4751a8f9acff..b58cc943a862 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -108,6 +108,7 @@
 #include <linux/static_key.h>
 #include <linux/btf_ids.h>
 #include <trace/events/skb.h>
+#include <trace/events/sock.h>
 #include <net/busy_poll.h>
 #include "udp_impl.h"
 #include <net/sock_reuseport.h>
@@ -1579,8 +1580,10 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 	__skb_queue_tail(list, skb);
 	spin_unlock(&list->lock);
 
-	if (!sock_flag(sk, SOCK_DEAD))
+	if (!sock_flag(sk, SOCK_DEAD)) {
+		trace_sk_data_ready(sk, skb);
 		sk->sk_data_ready(sk);
+	}
 
 	busylock_release(busy);
 	return 0;
-- 
2.27.0

