Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1AE483AF4
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 04:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbiADDWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 22:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbiADDWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 22:22:16 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76434C061784;
        Mon,  3 Jan 2022 19:22:16 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id 8so31545470pgc.10;
        Mon, 03 Jan 2022 19:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fYXWXYjnKsnVSNERKBA5KzKXAO+7cw8k8EULgzO2jhw=;
        b=px6Q1Nbdx26hO2PGIWkMzygvJVBF8sgIqKmCx8wulXnYsy+wi9tv8utBdQnP96vyJV
         NogGPlr4LGvysSsFu+hjI1+Z3ZG+s9OzBOdb+pOd99CoNdKjRBUlziHjfMLbs9TATg8v
         VeoNxfxCtQDqys2uMSIk8mf71rI5E812fIf/SqkKOBqpwsWxSssKkM95nqB1a+3r9ZnT
         UYEtaBTbgYVAQhWI8f3+ty0s5bR46/7W+1JN9hllj2syWb7mFZd+WU2rFi3US9vxi8I4
         XqpR4gfiFmCnDrS0WlhsPywoVEJ9Zl2YHKWJgg8isGkVEJVvbbd8Qm9CrxpTBu/uhfm0
         G/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fYXWXYjnKsnVSNERKBA5KzKXAO+7cw8k8EULgzO2jhw=;
        b=pK7bGaI8KqWBgEMBMJ8SvKQ8LXZfh7/wxOmmCZVJtnm80s00xCD7ew4e7sXLTVN5rz
         zmrge032V4iUVqJSrXGY7pVVyAJsuE//wuKfxtDyn/0bAk+WhpX1SggKhxBdkcTE9+t/
         RlkwzveFcIwRH5FFR0s51CGlaQJ7y4CL6cNF6G/JSZ7RLwlpA6mhbRqKV5gX3LKobBYS
         tjrYtNhe4zqwheCmcqQ+As4qyXVjjx1Ld41SAPNte7jB7BZ8/Qa9MAGuFLPdBS1m/KES
         6I2qN14o3KQGJQXraUJ/he3uRwit4ZJDQOXEsWAUWsJplsyuteJOlXS4e6Z5LxIQc395
         tQxw==
X-Gm-Message-State: AOAM530vW8jKDre0nGC6EmBXcVm8fELY6ipCISgjc2SHIJc2oIoJl4pF
        230KCnwBADXADNfQ36VuhR0=
X-Google-Smtp-Source: ABdhPJzScOQOxlF12IEi2WeX3mj0J3cFsDgH2ktEouo771/HSX25Qe9kHOH5uLS4t50cp/T6NwGgaA==
X-Received: by 2002:a63:5906:: with SMTP id n6mr42358367pgb.586.1641266535755;
        Mon, 03 Jan 2022 19:22:15 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id y3sm36029078pju.37.2022.01.03.19.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 19:22:15 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     rostedt@goodmis.org, kuba@kernel.org, dsahern@kernel.org
Cc:     mingo@redhat.com, davem@davemloft.net, nhorman@tuxdriver.com,
        edumazet@google.com, yoshfuji@linux-ipv6.org,
        jonathan.lemon@gmail.com, alobakin@pm.me, keescook@chromium.org,
        cong.wang@bytedance.com, talalahmad@google.com, haokexin@gmail.com,
        imagedong@tencent.com, atenart@kernel.org, bigeasy@linutronix.de,
        weiwan@google.com, arnd@arndb.de, pabeni@redhat.com,
        vvs@virtuozzo.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, mengensun@tencent.com,
        mungerjiang@tencent.com
Subject: [PATCH v3 net-next 3/3] net: skb: use kfree_skb_reason() in __udp4_lib_rcv()
Date:   Tue,  4 Jan 2022 11:21:34 +0800
Message-Id: <20220104032134.1239096-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220104032134.1239096-1-imagedong@tencent.com>
References: <20220104032134.1239096-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in __udp4_lib_rcv.
New drop reason 'SKB_DROP_REASON_UDP_CSUM' is added for udp csum
error.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v3:
- rename kfree_skb_with_reason() to kfree_skb_reason()
---
 include/linux/skbuff.h     |  1 +
 include/trace/events/skb.h |  1 +
 net/ipv4/udp.c             | 10 ++++++++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c9c97b0d0fe9..af64c7de9b53 100644
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
index c16febea9f62..75075512ae19 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -15,6 +15,7 @@
 	EM(SKB_DROP_REASON_PKT_TOO_SMALL, PKT_TOO_SMALL)	\
 	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
 	EM(SKB_DROP_REASON_TCP_FILTER, TCP_FILTER)		\
+	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 7b18a6f42f18..22f277cbd97c 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2411,6 +2411,9 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	__be32 saddr, daddr;
 	struct net *net = dev_net(skb->dev);
 	bool refcounted;
+	int drop_reason;
+
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 	/*
 	 *  Validate the packet.
@@ -2466,6 +2469,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	if (udp_lib_checksum_complete(skb))
 		goto csum_error;
 
+	drop_reason = SKB_DROP_REASON_NO_SOCKET;
 	__UDP_INC_STATS(net, UDP_MIB_NOPORTS, proto == IPPROTO_UDPLITE);
 	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
 
@@ -2473,10 +2477,11 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	 * Hmm.  We got an UDP packet to a port to which we
 	 * don't wanna listen.  Ignore it.
 	 */
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return 0;
 
 short_packet:
+	drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 	net_dbg_ratelimited("UDP%s: short packet: From %pI4:%u %d/%d to %pI4:%u\n",
 			    proto == IPPROTO_UDPLITE ? "Lite" : "",
 			    &saddr, ntohs(uh->source),
@@ -2489,6 +2494,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	 * RFC1122: OK.  Discards the bad packet silently (as far as
 	 * the network is concerned, anyway) as per 4.1.3.4 (MUST).
 	 */
+	drop_reason = SKB_DROP_REASON_UDP_CSUM;
 	net_dbg_ratelimited("UDP%s: bad checksum. From %pI4:%u to %pI4:%u ulen %d\n",
 			    proto == IPPROTO_UDPLITE ? "Lite" : "",
 			    &saddr, ntohs(uh->source), &daddr, ntohs(uh->dest),
@@ -2496,7 +2502,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	__UDP_INC_STATS(net, UDP_MIB_CSUMERRORS, proto == IPPROTO_UDPLITE);
 drop:
 	__UDP_INC_STATS(net, UDP_MIB_INERRORS, proto == IPPROTO_UDPLITE);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return 0;
 }
 
-- 
2.30.2

