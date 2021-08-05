Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7023E1BD8
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241886AbhHES6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241923AbhHES6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:58:16 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA30C06179F
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 11:58:01 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id w6so8665087oiv.11
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 11:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uHLR0MavhDSaNhIg+Yt96bJSeYOMhkrDg2qD+caZse0=;
        b=kuxIx4Ia71vnyH30uqBRVt1/WNq8KzYvh04IeOG3IgJKE+XPncgeT0Fj1HJ3rNXZ0J
         nUGcvT7xNzbxpDqvZCDvhKTakyI+EMgr1pwA63Usjv1P7QktaF03XCNvqahXtkut0BJx
         gs03bc9M6fTMaTX+2/M2A5UT3DgPGpMjW2UM9UpQ3O9gcfFyrwOOwBsGC0xHML8vUjy3
         22wFAw0SS6UIMmaiivm3pYLXuopGfS2yGE7Sf6mJpcfTxfuXU1bDzcPYWB79bTwUm+EQ
         SwXkPfmeHCvOCB8FP6lTXLhhOMSTsiaIlhycGFtMIZ5qr1VjhyfuoqUcAID0VhiklpuW
         UAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uHLR0MavhDSaNhIg+Yt96bJSeYOMhkrDg2qD+caZse0=;
        b=BtyByI5fkzkWOqowJfEIzoJUmkz0kSdyNM3u3w0VpVFUa4p7VGAzvsCJ7A+jv32g+8
         edXD0LPF838TBirD/RW5Df8mGgxF7ujlmZRFSS0hIujqpTLiA0JP7QZoAeOUTvjWnjDL
         M9Pm3UT6b8RxacDDFsCiHad0ml4/NBqAwJXDwmSwlJsbdhXaISUFYrJpYXdEoVbNz/5r
         1fxNYYx4buKuVI15YEgt7yfY1pguVM9LShRYpy/VLUH4T3ff1phlmU5lUZLuCEdFdHfO
         Zqn4bVARSCyQD0HjKDSRCXd8aAVAqSr9YZUjhP+qscJeHNqXbstUK9k/Yx+Jyftgdctg
         7xNQ==
X-Gm-Message-State: AOAM530ZKNf3/grL5J/CfYYhmM3ipsmOdLXTxwhWuBe7eiVQ5PeAbqHa
        OaOQ032+TMRRzrAyCLpgvC7JA1UovwA=
X-Google-Smtp-Source: ABdhPJyprhj1I92oNj+V9Q53k7sYbbG1OXJOTvWpkA+cSlvxA5h07yQTUlIhmFDYBeR4eX/s4o/XYw==
X-Received: by 2002:a05:6808:bd2:: with SMTP id o18mr4877554oik.20.1628189880647;
        Thu, 05 Aug 2021 11:58:00 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c64b:2366:2e53:c024])
        by smtp.gmail.com with ESMTPSA id r5sm358678otk.71.2021.08.05.11.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:58:00 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next 07/13] ipv6: introduce tracepoint trace_ipv6_rcv()
Date:   Thu,  5 Aug 2021 11:57:44 -0700
Message-Id: <20210805185750.4522-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Tracepoint trace_ipv6_rcv() is introduced to trace skb at the
entrance of IPv6 layer on RX side.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/ip.h | 18 ++++++++++++++++++
 net/core/net-traces.c     |  1 +
 net/ipv6/ip6_input.c      |  5 ++++-
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/ip.h b/include/trace/events/ip.h
index 20ee1a81405c..6cd0907728ce 100644
--- a/include/trace/events/ip.h
+++ b/include/trace/events/ip.h
@@ -99,6 +99,24 @@ TRACE_EVENT(ip_rcv,
 	TP_printk("skbaddr=%px", __entry->skbaddr)
 );
 
+#if IS_ENABLED(CONFIG_IPV6)
+TRACE_EVENT(ipv6_rcv,
+	TP_PROTO(const struct sk_buff *skb),
+
+	TP_ARGS(skb),
+
+	TP_STRUCT__entry(
+		__field(const void *, skbaddr)
+	),
+
+	TP_fast_assign(
+		__entry->skbaddr = skb;
+	),
+
+	TP_printk("skbaddr=%px", __entry->skbaddr)
+);
+#endif
+
 #endif /* _TRACE_IP_H */
 
 /* This part must be outside protection */
diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index 0aca299dfb55..de5a13ae933c 100644
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@ -64,4 +64,5 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(tcp_send_reset);
 EXPORT_TRACEPOINT_SYMBOL_GPL(tcp_bad_csum);
 #if IS_ENABLED(CONFIG_IPV6)
 EXPORT_TRACEPOINT_SYMBOL_GPL(udp_v6_send_skb);
+EXPORT_TRACEPOINT_SYMBOL_GPL(ipv6_rcv);
 #endif
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 80256717868e..8ce23ef5f011 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -44,6 +44,7 @@
 #include <net/xfrm.h>
 #include <net/inet_ecn.h>
 #include <net/dst_metadata.h>
+#include <trace/events/ip.h>
 
 INDIRECT_CALLABLE_DECLARE(void tcp_v6_early_demux(struct sk_buff *));
 static void ip6_rcv_finish_core(struct net *net, struct sock *sk,
@@ -59,8 +60,10 @@ static void ip6_rcv_finish_core(struct net *net, struct sock *sk,
 			INDIRECT_CALL_2(edemux, tcp_v6_early_demux,
 					udp_v6_early_demux, skb);
 	}
-	if (!skb_valid_dst(skb))
+	if (!skb_valid_dst(skb)) {
+		trace_ipv6_rcv(skb);
 		ip6_route_input(skb);
+	}
 }
 
 int ip6_rcv_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
-- 
2.27.0

