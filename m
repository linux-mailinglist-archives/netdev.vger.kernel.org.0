Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7AE449DD86
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238390AbiA0JOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238378AbiA0JOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 04:14:00 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D166C061714;
        Thu, 27 Jan 2022 01:14:00 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id q63so2325133pja.1;
        Thu, 27 Jan 2022 01:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iNxRgqQKJNdJpC+mPAku5kVn5VXzltTyRgKSsRUN7zk=;
        b=JyyijivxbUtsI0uAU5enFrSTkPGx1ng4RIe0DQA9xREDCNWKa2AiUOTFt8BwNRWT83
         2+bMsSEv+Kq38zsd7FAflz1PN/9xdZmlZVYdx6AEXVKyieA4V5Nifq+xNYRBncS/NF8K
         PJ4K1dLN1zsMMXtKh/QyVrrY7EkGsCixb/mwGf357LkDJrN7T5WmQSwuijMNc082YDwz
         ou6Fj1bgdZo/b6fDR5+SnOa+Derg5Jh13QtcDK/q1/J+azxfiUo6I4KWUdfMoR33IHj1
         r3j0EkELPbBoEYLvn4q42GYnRE/ula7wudShkSVxKOGfK/q33ILJXTg05fcIK4eDpDxV
         q8kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iNxRgqQKJNdJpC+mPAku5kVn5VXzltTyRgKSsRUN7zk=;
        b=JExRULoJuVScjhyC6VG8/XzuHRmBAL4uCfRwUL6i2pc9PF2qbM7iBZqg2PTUFz3IU7
         IweHsyPmzaPFr1Ybo/d0Y+ywOjpcZPyvUUS3q8Fx/6OcEd4mUdd8jLr4Obd64SzoCrC6
         fEN9f9moml6nFkP+/mSjmbDm1edNpYliJe9lIaUfo78aOyPbkB2e93vFNq6NLgZAG/KK
         PLQixlFdm5b/AAH9baqoutCSxkqnt1kHpW1uWTwV76+qgjkNzOn9aUUtLcb1/zvf/SRg
         clpTtIv10Vr61gyMu3YCki1Gp8zgNDTkP8pwbk1foxUV/Mdn8RahnBwmAIFnjckfy7Yo
         DlRQ==
X-Gm-Message-State: AOAM5329UQgsBqMFU0gb7EdEt98jUU52F+SNE+OULtKjvlUbf1dCoy5U
        eLTMlNDOk13qpvr0HJamupQ=
X-Google-Smtp-Source: ABdhPJykzSoG4zvb/hqjgC6dgKVX17pCyFsC4UATiEKloQt6GG+6boq0kP1E2UbsXoTuYGh3/8EMsw==
X-Received: by 2002:a17:902:c101:: with SMTP id 1mr2435921pli.70.1643274839685;
        Thu, 27 Jan 2022 01:13:59 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id j11sm2046338pjf.53.2022.01.27.01.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 01:13:59 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        alobakin@pm.me, pabeni@redhat.com, cong.wang@bytedance.com,
        talalahmad@google.com, haokexin@gmail.com, keescook@chromium.org,
        memxor@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, mengensun@tencent.com
Subject: [PATCH v2 net-next 4/8] net: ipv4: use kfree_skb_reason() in ip_rcv_core()
Date:   Thu, 27 Jan 2022 17:13:04 +0800
Message-Id: <20220127091308.91401-5-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220127091308.91401-1-imagedong@tencent.com>
References: <20220127091308.91401-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in ip_rcv_core(). Three new
drop reasons are introduced:

SKB_DROP_REASON_OTHERHOST
SKB_DROP_REASON_IP_CSUM
SKB_DROP_REASON_IP_INHDR

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- remove unrelated cleanup
- add document for introduced drop reasons
---
 include/linux/skbuff.h     |  9 +++++++++
 include/trace/events/skb.h |  3 +++
 net/ipv4/ip_input.c        | 11 +++++++++--
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 786ea2c2334e..2e87da91424f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -321,6 +321,15 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_SOCKET_FILTER,	/* dropped by socket filter */
 	SKB_DROP_REASON_UDP_CSUM,	/* UDP checksum error */
 	SKB_DROP_REASON_NETFILTER_DROP,	/* dropped by netfilter */
+	SKB_DROP_REASON_OTHERHOST,	/* packet don't belong to current
+					 * host (interface is in promisc
+					 * mode)
+					 */
+	SKB_DROP_REASON_IP_CSUM,	/* IP checksum error */
+	SKB_DROP_REASON_IP_INHDR,	/* there is something wrong with
+					 * IP header (see
+					 * IPSTATS_MIB_INHDRERRORS)
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 3d89f7b09a43..f2b1778485f0 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -17,6 +17,9 @@
 	EM(SKB_DROP_REASON_SOCKET_FILTER, SOCKET_FILTER)	\
 	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
 	EM(SKB_DROP_REASON_NETFILTER_DROP, NETFILTER_DROP)	\
+	EM(SKB_DROP_REASON_OTHERHOST, OTHERHOST)		\
+	EM(SKB_DROP_REASON_IP_CSUM, IP_CSUM)			\
+	EM(SKB_DROP_REASON_IP_INHDR, IP_INHDR)			\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 3a025c011971..7f64c5432cba 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -436,13 +436,18 @@ static int ip_rcv_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
 static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 {
 	const struct iphdr *iph;
+	int drop_reason;
 	u32 len;
 
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
+
 	/* When the interface is in promisc. mode, drop all the crap
 	 * that it receives, do not try to analyse it.
 	 */
-	if (skb->pkt_type == PACKET_OTHERHOST)
+	if (skb->pkt_type == PACKET_OTHERHOST) {
+		drop_reason = SKB_DROP_REASON_OTHERHOST;
 		goto drop;
+	}
 
 	__IP_UPD_PO_STATS(net, IPSTATS_MIB_IN, skb->len);
 
@@ -516,11 +521,13 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	return skb;
 
 csum_error:
+	drop_reason = SKB_DROP_REASON_IP_CSUM;
 	__IP_INC_STATS(net, IPSTATS_MIB_CSUMERRORS);
 inhdr_error:
+	drop_reason = drop_reason ?: SKB_DROP_REASON_IP_INHDR;
 	__IP_INC_STATS(net, IPSTATS_MIB_INHDRERRORS);
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 out:
 	return NULL;
 }
-- 
2.34.1

