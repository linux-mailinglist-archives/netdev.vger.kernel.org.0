Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4DDF49DD8E
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238429AbiA0JOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238434AbiA0JOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 04:14:11 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E2EC061748;
        Thu, 27 Jan 2022 01:14:10 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id d187so2066329pfa.10;
        Thu, 27 Jan 2022 01:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AAC7L6aHlRQtxgtk8rcpxBhloOR2RlrXxvp2Txw/5xE=;
        b=MRKmhsTNLZLleU81qV7xLErDVASy6I3To0/5fdfxXhHCd6gL/Csd8O0V+33LfyDwTY
         sQh7Ubp0Pj8PUOiKsBEBEqDi9kET2sO8exYb4nOCL1bNGYJe2uLP74o3k2TwlU6Z8dwT
         LvjpdhUq2fxumOjRSihH58g1NswCTFbW4YEwC3K0TbE4H8WTRbg98ejTdmyEVD2JpGAT
         m+H+XnkrpSLOnAcDJR2nZslsDbQteie9aZp6MIoNi6VUahkejqU/5ZLx1D1mCZ1eiA06
         xH2oHA2AYvOersRrP/xaQ+8jSgOqF9BcQXJ8kn/xztqQTlYB0930V7ASvGujsGFt3NRE
         Hqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AAC7L6aHlRQtxgtk8rcpxBhloOR2RlrXxvp2Txw/5xE=;
        b=L2sxQuce6usjV5QTOgXQ1+TkISa0ywS2lZyKMJpAS2P7RLC1RWN7UKUB31YaLdhmCg
         HH9L6jQmilp0fSoOgiJtBB9O6mQr226pMg1XJMHBuohZJ5pHxjhvavdwi7lONnFh2HSQ
         Uu8Alz75bvx5MaeZrytsSuWuGAIAa6LEoIEPfUOugSFshM9z37XERzvCWZG5A5biLyzj
         LrnjUThhteqYdAqfr5nT//hwOWLIXV2t3bE3deiNpWrtI27ngBLBxkleQqi4T+4VF3H/
         ekpI0P4WEAJJbky8PuucbrOKnrzhHuubs8aIkzo4vtUJwOb/HZlBi9kdIAEx/DBusST5
         Enjw==
X-Gm-Message-State: AOAM532vFE/J4s8fT/c/s0IwHca76sFOBHl/FfQyjveqpdySTMsgAxgO
        FTvBd8+UcJtzYQA/xDcWoTs=
X-Google-Smtp-Source: ABdhPJwCOcuBlP+heAAlOrxsbAtPfegoo6mEkqibvGXk8MzoLUlQAgGj1IJ7fXgnKmB5HE9dZBwYuA==
X-Received: by 2002:a05:6a00:1342:: with SMTP id k2mr2139063pfu.20.1643274850283;
        Thu, 27 Jan 2022 01:14:10 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id j11sm2046338pjf.53.2022.01.27.01.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 01:14:09 -0800 (PST)
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
Subject: [PATCH v2 net-next 6/8] net: ipv4: use kfree_skb_reason() in ip_protocol_deliver_rcu()
Date:   Thu, 27 Jan 2022 17:13:06 +0800
Message-Id: <20220127091308.91401-7-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220127091308.91401-1-imagedong@tencent.com>
References: <20220127091308.91401-1-imagedong@tencent.com>
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

