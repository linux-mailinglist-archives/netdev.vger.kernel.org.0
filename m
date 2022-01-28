Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F7C49F46B
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 08:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346859AbiA1HeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 02:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346862AbiA1HeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 02:34:16 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9318C06173B;
        Thu, 27 Jan 2022 23:34:15 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id j16so5135197plx.4;
        Thu, 27 Jan 2022 23:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AAC7L6aHlRQtxgtk8rcpxBhloOR2RlrXxvp2Txw/5xE=;
        b=qnM3arX6oZNhV6fsJDc/1y/fWTl7N8rL1qSWOu48nxtHtpyxNmPHCKRK+WtyFYuQTJ
         QygsDVWYkn6j3l4AmQCB4Jc1xhtG5WADCFKvLKdonaMMn0vfstZmxufRIt/6oKnOlh0b
         W3bi0R3EISpQbql+THIS/pizjVh4fiWqJd4DTrHvnQkRp1JMvOFzNIrYGXNlZ0vv69vI
         FQqj1Hwde9+6ZRFGTxxRCANFOQfRLY1FLAcftzC3crWV89Td2G89bO3VIUETAndfkmkW
         u+q4BlJQdqJzlHJDZZodiXdAelXlmc6N6bbXp0bt28+2z9QM86JQoN42Xb70VWlmFFr3
         J2Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AAC7L6aHlRQtxgtk8rcpxBhloOR2RlrXxvp2Txw/5xE=;
        b=VM48NjZXoQUAWQYrdolXKGJhjIqT+5S9exathw1gsQvzf3ORoBqjQ4JjsJnDCqt16+
         XXGVDQ6hOdznfjdkJmkNz4tneF6lTcEe9c2i5D/1NYNfMPLlhc16e3TaTJkCmRAK3klw
         EAPoAIo9c+XdoQIKwst3vCZCLdrTGSybeFjljP3/w/RTYurg03ACrZRB+Lqytq9DkO17
         7hMvnWBlPhCfQKEoBLXonq2dXCxjOdT6z2AGGfmtmU9a6WH36T5NoA2nETO8sMSNrkXh
         pKUmFYIFbXw2K64Oj5aQs913dP4Fu416V+0nbcS0fUAlF5v/2A5OyRCxNLXL3lToktUO
         dM4A==
X-Gm-Message-State: AOAM530Rp3u9dFoI+Q9Z3o82ZSV31qiRKWVeGglQcTVwNtDG30ypVvhk
        b3YQCLoTOhjCop4JQZXzRVM=
X-Google-Smtp-Source: ABdhPJwm2Uhq/CQRAF92urwcv6L88GUNudhEcyLu0B+U5S/w5xyex2JL2hdhIH3QE1zKZQPNIsD8yQ==
X-Received: by 2002:a17:90a:1b0d:: with SMTP id q13mr18355261pjq.14.1643355255539;
        Thu, 27 Jan 2022 23:34:15 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id q17sm8548846pfu.160.2022.01.27.23.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 23:34:14 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, imagedong@tencent.com, edumazet@google.com,
        alobakin@pm.me, paulb@nvidia.com, keescook@chromium.org,
        talalahmad@google.com, haokexin@gmail.com, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com, mengensun@tencent.com
Subject: [PATCH v3 net-next 5/7] net: ipv4: use kfree_skb_reason() in ip_protocol_deliver_rcu()
Date:   Fri, 28 Jan 2022 15:33:17 +0800
Message-Id: <20220128073319.1017084-6-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220128073319.1017084-1-imagedong@tencent.com>
References: <20220128073319.1017084-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in ip_protocol_deliver_rcu().
Following new drop reasons are introduced:

SKB_DROP_REASON_XFRM_POLICY
SKB_DROP_REASON_IP_NOPROTO

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- add document for the introduced drop reasons
---
 include/linux/skbuff.h     | 2 ++
 include/trace/events/skb.h | 2 ++
 net/ipv4/ip_input.c        | 5 +++--
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2d712459d564..4e55321e2fc2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -339,6 +339,8 @@ enum skb_drop_reason {
 						  * is multicast, but L3 is
 						  * unicast.
 						  */
+	SKB_DROP_REASON_XFRM_POLICY,	/* xfrm policy check failed */
+	SKB_DROP_REASON_IP_NOPROTO,	/* no support for IP protocol */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 485a1d3034a4..985e481c092d 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -23,6 +23,8 @@
 	EM(SKB_DROP_REASON_IP_RPFILTER, IP_RPFILTER)		\
 	EM(SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST,		\
 	   UNICAST_IN_L2_MULTICAST)				\
+	EM(SKB_DROP_REASON_XFRM_POLICY, XFRM_POLICY)		\
+	EM(SKB_DROP_REASON_IP_NOPROTO, IP_NOPROTO)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 184decb1c8eb..74c090f6eb9d 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -196,7 +196,8 @@ void ip_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int protocol)
 	if (ipprot) {
 		if (!ipprot->no_policy) {
 			if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb)) {
-				kfree_skb(skb);
+				kfree_skb_reason(skb,
+						 SKB_DROP_REASON_XFRM_POLICY);
 				return;
 			}
 			nf_reset_ct(skb);
@@ -215,7 +216,7 @@ void ip_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int protocol)
 				icmp_send(skb, ICMP_DEST_UNREACH,
 					  ICMP_PROT_UNREACH, 0);
 			}
-			kfree_skb(skb);
+			kfree_skb_reason(skb, SKB_DROP_REASON_IP_NOPROTO);
 		} else {
 			__IP_INC_STATS(net, IPSTATS_MIB_INDELIVERS);
 			consume_skb(skb);
-- 
2.34.1

