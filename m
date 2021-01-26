Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D6C3055E3
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S316946AbhAZXMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730387AbhAZV0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 16:26:50 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EB8C0617AA
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 13:25:48 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id m6so11247036pfk.1
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 13:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netflix.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=guz8B7dcncash3KlLe8/l8GPke5Dsr2atiqlYSNGWxM=;
        b=oqISJEYUJ6VzCrQZt6jLwQ7L0ejaXIfEeZlo0EZ+VHUKeDiuRFlOQoe31ECIfQBEBZ
         598HMbo4+R4CWz1+9Ym5sgVmH7JXjnZ6QNkbhe8eYIG5Ydt2dEjIpPKfIj249fxTZb+i
         hKLRIMhmRtjNewFtj6BsVYWYbU4UIYY8Gc8NQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=guz8B7dcncash3KlLe8/l8GPke5Dsr2atiqlYSNGWxM=;
        b=rJT+7NMrJbTR/X0EnpsIH/Mfuozbor0lIe+44P2gx3YjvaI8C6ujinmp90dPwoQrgk
         RFbH8p4ECu1GNgDMTOy5DIsWOkNum9BZ3Dim8YYQnmDVtp+DaTDkwH6ifmPSahJzEeDg
         IuYVLnTUMhG3qu/oDXw8BmrKSVBy2MHhVPOkjJS+/Qebfh4zIR5WbnJ6TLsgiQQNeEKM
         YDQnrQXwxErpdaZ2l8xMUuT2BNxlrS9PXTmAUQXkP0CQVhf2IxcxBsPR++2i+QzSuamm
         sdvfM5uaTbmiRGSV9fca3jMdwrc8FGQXYaZv/QfcTJRUQGPxGfIJweFExGKDrgJoPRJF
         rS7A==
X-Gm-Message-State: AOAM5307MUPgNX8/g9tbRw4PdmtIOqrifDiNtLOs4xqewcFZXrFd1ZO5
        PkPyxqqOBCm4gUhn+Luhe/iPUg==
X-Google-Smtp-Source: ABdhPJwRS5TLRCbyszW4J+d7f0ezmiSIU9SJ/lQMfFZywZp5rHQNmJuNuzwUsFUcH30Pw3GFCzjELQ==
X-Received: by 2002:a62:ea14:0:b029:1bf:f580:3375 with SMTP id t20-20020a62ea140000b02901bff5803375mr7064523pfh.53.1611696347654;
        Tue, 26 Jan 2021 13:25:47 -0800 (PST)
Received: from localhost.localdomain (c-69-181-214-217.hsd1.ca.comcast.net. [69.181.214.217])
        by smtp.gmail.com with ESMTPSA id j9sm20432482pgb.47.2021.01.26.13.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 13:25:46 -0800 (PST)
From:   Hariharan Ananthakrishnan <hari@netflix.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Hariharan Ananthakrishnan <hari@netflix.com>
Subject: [PATCH 1/1] net: tracepoint: exposing sk_family in all tcp:tracepoints
Date:   Tue, 26 Jan 2021 21:25:30 +0000
Message-Id: <20210126212530.6510-2-hari@netflix.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210126212530.6510-1-hari@netflix.com>
References: <20210126212530.6510-1-hari@netflix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Hariharan Ananthakrishnan <hari@netflix.com>
---
 include/trace/events/tcp.h | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index cf97f6339acb..a319d2f86cd9 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -59,6 +59,7 @@ DECLARE_EVENT_CLASS(tcp_event_sk_skb,
 		__field(int, state)
 		__field(__u16, sport)
 		__field(__u16, dport)
+		__field(__u16, family)
 		__array(__u8, saddr, 4)
 		__array(__u8, daddr, 4)
 		__array(__u8, saddr_v6, 16)
@@ -75,6 +76,7 @@ DECLARE_EVENT_CLASS(tcp_event_sk_skb,
 
 		__entry->sport = ntohs(inet->inet_sport);
 		__entry->dport = ntohs(inet->inet_dport);
+		__entry->family = sk->sk_family;
 
 		p32 = (__be32 *) __entry->saddr;
 		*p32 = inet->inet_saddr;
@@ -86,7 +88,8 @@ DECLARE_EVENT_CLASS(tcp_event_sk_skb,
 			      sk->sk_v6_rcv_saddr, sk->sk_v6_daddr);
 	),
 
-	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c state=%s",
+	TP_printk("family=%s sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c state=%s",
+		  show_family_name(__entry->family),
 		  __entry->sport, __entry->dport, __entry->saddr, __entry->daddr,
 		  __entry->saddr_v6, __entry->daddr_v6,
 		  show_tcp_state_name(__entry->state))
@@ -125,6 +128,7 @@ DECLARE_EVENT_CLASS(tcp_event_sk,
 		__field(const void *, skaddr)
 		__field(__u16, sport)
 		__field(__u16, dport)
+		__field(__u16, family)
 		__array(__u8, saddr, 4)
 		__array(__u8, daddr, 4)
 		__array(__u8, saddr_v6, 16)
@@ -140,6 +144,7 @@ DECLARE_EVENT_CLASS(tcp_event_sk,
 
 		__entry->sport = ntohs(inet->inet_sport);
 		__entry->dport = ntohs(inet->inet_dport);
+		__entry->family = sk->sk_family;
 
 		p32 = (__be32 *) __entry->saddr;
 		*p32 = inet->inet_saddr;
@@ -153,7 +158,8 @@ DECLARE_EVENT_CLASS(tcp_event_sk,
 		__entry->sock_cookie = sock_gen_cookie(sk);
 	),
 
-	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c sock_cookie=%llx",
+	TP_printk("family=%s sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c sock_cookie=%llx",
+		  show_family_name(__entry->family),
 		  __entry->sport, __entry->dport,
 		  __entry->saddr, __entry->daddr,
 		  __entry->saddr_v6, __entry->daddr_v6,
@@ -192,6 +198,7 @@ TRACE_EVENT(tcp_retransmit_synack,
 		__field(const void *, req)
 		__field(__u16, sport)
 		__field(__u16, dport)
+		__field(__u16, family)
 		__array(__u8, saddr, 4)
 		__array(__u8, daddr, 4)
 		__array(__u8, saddr_v6, 16)
@@ -207,6 +214,7 @@ TRACE_EVENT(tcp_retransmit_synack,
 
 		__entry->sport = ireq->ir_num;
 		__entry->dport = ntohs(ireq->ir_rmt_port);
+		__entry->family = sk->sk_family;
 
 		p32 = (__be32 *) __entry->saddr;
 		*p32 = ireq->ir_loc_addr;
@@ -218,7 +226,8 @@ TRACE_EVENT(tcp_retransmit_synack,
 			      ireq->ir_v6_loc_addr, ireq->ir_v6_rmt_addr);
 	),
 
-	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c",
+	TP_printk("family=%s sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c",
+	          show_family_name(__entry->family),
 		  __entry->sport, __entry->dport,
 		  __entry->saddr, __entry->daddr,
 		  __entry->saddr_v6, __entry->daddr_v6)
@@ -238,6 +247,7 @@ TRACE_EVENT(tcp_probe,
 		__array(__u8, daddr, sizeof(struct sockaddr_in6))
 		__field(__u16, sport)
 		__field(__u16, dport)
+		__field(__u16, family)
 		__field(__u32, mark)
 		__field(__u16, data_len)
 		__field(__u32, snd_nxt)
@@ -264,6 +274,7 @@ TRACE_EVENT(tcp_probe,
 		__entry->sport = ntohs(inet->inet_sport);
 		__entry->dport = ntohs(inet->inet_dport);
 		__entry->mark = skb->mark;
+		__entry->family = sk->sk_family;
 
 		__entry->data_len = skb->len - __tcp_hdrlen(th);
 		__entry->snd_nxt = tp->snd_nxt;
@@ -276,7 +287,8 @@ TRACE_EVENT(tcp_probe,
 		__entry->sock_cookie = sock_gen_cookie(sk);
 	),
 
-	TP_printk("src=%pISpc dest=%pISpc mark=%#x data_len=%d snd_nxt=%#x snd_una=%#x snd_cwnd=%u ssthresh=%u snd_wnd=%u srtt=%u rcv_wnd=%u sock_cookie=%llx",
+	TP_printk("family=%s src=%pISpc dest=%pISpc mark=%#x data_len=%d snd_nxt=%#x snd_una=%#x snd_cwnd=%u ssthresh=%u snd_wnd=%u srtt=%u rcv_wnd=%u sock_cookie=%llx",
+		  show_family_name(__entry->family),
 		  __entry->saddr, __entry->daddr, __entry->mark,
 		  __entry->data_len, __entry->snd_nxt, __entry->snd_una,
 		  __entry->snd_cwnd, __entry->ssthresh, __entry->snd_wnd,
-- 
2.27.0

