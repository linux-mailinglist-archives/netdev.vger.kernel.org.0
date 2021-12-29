Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8F4481421
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 15:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240288AbhL2Ocl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 09:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240307AbhL2Ock (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 09:32:40 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FABC061574;
        Wed, 29 Dec 2021 06:32:40 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id a11-20020a17090a854b00b001b11aae38d6so20102175pjw.2;
        Wed, 29 Dec 2021 06:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ftgRhaFoF0uJiV/41YkRikVf0UZIjoIH5cO3oYaR7Lc=;
        b=ZvOOOTpoOXaaPukDubhHiTuSiOZJ8Q946A2m6uRMxhJ+UkiSOsfUemmSolCbJt/C0m
         6X9MwB/H1r9a/OHCe+yw2oEjVBgJNkNxiY3qOTiKrKxaNiXIrTLdoBh7vI5XWP6J/Sct
         Kx8x44mpUUX7gB7cIl28t5mkj/zuKInUqxlEbW4ryqOSFFPIO9EJbWYieiRumK6MFeIL
         dAsXM8DHCK7cxTfFkgHfOay6aqClHGM+4fCOiqIsgdSMfJvIQ/DVrifcSzh24O9IEC2P
         9yLA8LNRwFGCLbuAxTMWcK968c8w+fsI+4MQz2/glItuj4TAP7CM3YQcM4TD9owtcRXN
         3u/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ftgRhaFoF0uJiV/41YkRikVf0UZIjoIH5cO3oYaR7Lc=;
        b=3gYDgIYpnvsfI18lwYa0a2hU4rI9rUbyQaLV42JbeltvpbwsRhFXNqSd7eKDApEHBz
         oF/jfadyCJqtt4lxXco24T2uwHWB07b5P1HQFlWm7ObssV5pEDpxNv8chHXydz+whZkK
         8dIAQNnnA+8ZAKO9HyRi4tbvLYSRZbuH2eR1HBlvL4tBig1Itrs7PJ4Rwc9wfUf4LKHp
         ygQFGsgowznQhIRrd2hI+UYJBrN1GYB17VUNvywFlEJLC+qKUZ0fZlnRixFRAEwxPNi/
         qOw7UQrA6rOvywsjG8mx9pN41BD12CmZqEXB2SRKa9dpeLALitI4EgiXWiQ22Exja8Zl
         iV/A==
X-Gm-Message-State: AOAM531sRR1ESzizUENRBgmpq+7eJtXo2Dmflhj78Da05rLUAD9dljYj
        Y8flAdJRyoit+BkJNpiN5rA=
X-Google-Smtp-Source: ABdhPJxF6jZJpOa6go3FPc+464NZRGv+RFPif813Pq0QQP6YQPXBcxg0W5t0yOjxMsrG8gAFATCigg==
X-Received: by 2002:a17:902:c407:b0:149:2ef4:b6b2 with SMTP id k7-20020a170902c40700b001492ef4b6b2mr27413504plk.112.1640788359771;
        Wed, 29 Dec 2021 06:32:39 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id v16sm24860393pfu.131.2021.12.29.06.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 06:32:39 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     rostedt@goodmis.org, dsahern@kernel.org
Cc:     mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        nhorman@tuxdriver.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, jonathan.lemon@gmail.com, alobakin@pm.me,
        cong.wang@bytedance.com, pabeni@redhat.com, talalahmad@google.com,
        haokexin@gmail.com, keescook@chromium.org, imagedong@tencent.com,
        atenart@kernel.org, bigeasy@linutronix.de, weiwan@google.com,
        arnd@arndb.de, vvs@virtuozzo.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: skb: use kfree_skb_with_reason() in tcp_v4_rcv()
Date:   Wed, 29 Dec 2021 22:32:05 +0800
Message-Id: <20211229143205.410731-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211229143205.410731-1-imagedong@tencent.com>
References: <20211229143205.410731-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_with_reason() in tcp_v4_rcv().
Following drop reason are added:

SKB_DROP_REASON_NO_SOCK
SKB_DROP_REASON_BAD_PACKET
SKB_DROP_REASON_TCP_CSUM

After this patch, 'kfree_skb' event will print message like this:

$           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
$              | |         |   |||||     |         |
          <idle>-0       [000] ..s1.    36.113438: kfree_skb: skbaddr=(____ptrval____) protocol=2048 location=(____ptrval____) reason: NO_SOCK

The reason of skb drop is printed too.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     |  3 +++
 include/trace/events/skb.h |  3 +++
 net/ipv4/tcp_ipv4.c        | 10 ++++++++--
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3620b3ff2154..f85db6c035d1 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -313,6 +313,9 @@ struct sk_buff;
  */
 enum skb_drop_reason {
 	SKB_DROP_REASON_NOT_SPECIFIED,
+	SKB_DROP_REASON_NO_SOCK,
+	SKB_DROP_REASON_BAD_PACKET,
+	SKB_DROP_REASON_TCP_CSUM,
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index cab1c08a30cd..b9ea6b4ed7ec 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -11,6 +11,9 @@
 
 #define TRACE_SKB_DROP_REASON					\
 	EM(SKB_DROP_REASON_NOT_SPECIFIED, NOT_SPECIFIED)	\
+	EM(SKB_DROP_REASON_NO_SOCK, NO_SOCK)			\
+	EM(SKB_DROP_REASON_BAD_PACKET, BAD_PACKET)		\
+	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
 	EMe(SKB_DROP_REASON_MAX, HAHA_MAX)
 
 #undef EM
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ac10e4cdd8d0..03dc4c79b84b 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1971,8 +1971,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	const struct tcphdr *th;
 	bool refcounted;
 	struct sock *sk;
+	int drop_reason;
 	int ret;
 
+	drop_reason = 0;
 	if (skb->pkt_type != PACKET_HOST)
 		goto discard_it;
 
@@ -1984,8 +1986,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	th = (const struct tcphdr *)skb->data;
 
-	if (unlikely(th->doff < sizeof(struct tcphdr) / 4))
+	if (unlikely(th->doff < sizeof(struct tcphdr) / 4)) {
+		drop_reason = SKB_DROP_REASON_BAD_PACKET;
 		goto bad_packet;
+	}
 	if (!pskb_may_pull(skb, th->doff * 4))
 		goto discard_it;
 
@@ -2124,6 +2128,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	return ret;
 
 no_tcp_socket:
+	drop_reason = SKB_DROP_REASON_NO_SOCK;
 	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto discard_it;
 
@@ -2131,6 +2136,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	if (tcp_checksum_complete(skb)) {
 csum_error:
+		drop_reason = SKB_DROP_REASON_TCP_CSUM;
 		trace_tcp_bad_csum(skb);
 		__TCP_INC_STATS(net, TCP_MIB_CSUMERRORS);
 bad_packet:
@@ -2141,7 +2147,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 discard_it:
 	/* Discard frame. */
-	kfree_skb(skb);
+	kfree_skb_with_reason(skb, drop_reason);
 	return 0;
 
 discard_and_relse:
-- 
2.30.2

