Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35BC488841
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 07:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235253AbiAIGhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 01:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235248AbiAIGhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 01:37:37 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01120C06173F;
        Sat,  8 Jan 2022 22:37:37 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id n16so9522812plc.2;
        Sat, 08 Jan 2022 22:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fYXWXYjnKsnVSNERKBA5KzKXAO+7cw8k8EULgzO2jhw=;
        b=HNm9R5vGCp8WTKut21O5GXHocnWqwBr7ShyxWBx+/RBFBpQcVEapCxj5afYckqR0Bo
         AH/DdfrtuyakBKua0kapW+TOkWvS9XSfSd9B0cIgLyIvgLHhOBmzaycVGuiXo+sTLkMw
         qLR3DokF1ydcb/QSBkVSFI6NICXoeO9ZUvgVpDuG/1Pnk4rUDRO0jXdZiYo1tDlmOgTZ
         TXs+fE1Pklr4W1DAylcHEz0Yarux55xVNsPN6ouC5qZanhryuIjmyC1DEUHiOfEAMcRO
         ihMuWUx2hO9181QnGI9yCpoT979kZHWDjIYSFqjEtRoVpJf+VDvJDw2F0n0YI1iwE4e9
         xKXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fYXWXYjnKsnVSNERKBA5KzKXAO+7cw8k8EULgzO2jhw=;
        b=vIlSYddV17m6RU2/Mgc2pA4V12e7/rEfwy64yATOzZQVyELToLeb/0/P47qyYo4rde
         D15NjpuFEnj5yMa5E/Yf/roFNTfigkoCmHA/PIi/PD1mVON/FZxOzd/a2b4nSx6E5lyj
         WZ+XSu+UOCvsftOW7EdMkJHIQgdLhuinEqqwG8GUrq9JA+hDmf7nAKz6MrDiOO60sDYd
         y7fnrY9qcYMOe1pOPfDsGyrliwdRYKcQEz92EiLyTYEUDm+EMhcYwXklyIn/XUqKs6iO
         3a0Q6XaDLCkLitAvc6ky9KsNNtalNVM4yvihuRjaTLcZKRTjJ6NAq4lBsxmSS7UvDpP1
         5JAA==
X-Gm-Message-State: AOAM532W6I2YrsOLMvPWtb7Yk5eoBqlVfA50xunbeFL1PurhResjcP7K
        df/xmv6Y0qRmVJphcaOGr5E=
X-Google-Smtp-Source: ABdhPJz+0s0RtsnYpTtQbPx7DLIf/xHFUFbV3mY/+QM/j4x4pvDGaZAPzD0KjeBYO3Qf91CdwdNSSw==
X-Received: by 2002:a17:90b:4f85:: with SMTP id qe5mr24095179pjb.99.1641710256476;
        Sat, 08 Jan 2022 22:37:36 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id my5sm5892042pjb.5.2022.01.08.22.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 22:37:36 -0800 (PST)
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
Subject: [PATCH v4 net-next 3/3] net: skb: use kfree_skb_reason() in __udp4_lib_rcv()
Date:   Sun,  9 Jan 2022 14:36:28 +0800
Message-Id: <20220109063628.526990-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220109063628.526990-1-imagedong@tencent.com>
References: <20220109063628.526990-1-imagedong@tencent.com>
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

