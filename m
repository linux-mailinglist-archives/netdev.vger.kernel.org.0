Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23C64AA767
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 08:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376747AbiBEHsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 02:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379623AbiBEHsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 02:48:08 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A74C043180;
        Fri,  4 Feb 2022 23:48:04 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id g15-20020a17090a67cf00b001b7d5b6bedaso8238399pjm.4;
        Fri, 04 Feb 2022 23:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rmUqM+JYtP9hKEr5gUjT2LuBcGNasQZbfimvB5akS00=;
        b=bVnW1ILz5WJbdtR3mf7RSwTPUsLjCHL9XeEA2kcpIu7QkO+EgQ+tYHedySRYPMGMJp
         Z3R0NX1tr1ZRS3DNDyy+x6+7hst6dLzmaGYUYVF3eYg+E0P5CV4wx0A0m6GtwiP5PoqP
         HUqw0rIDos+bB6COQVe+Zv0x8ZNAY5o1r+RW6MmI+gOv1xyf6IvLMqH79/bmM1mPSwJe
         fmqFjtMVamOYhml13eem2cfUz55bOPGUZcWZPonaztmw+MU/WK/mRZu8AJlLqtGP2wF7
         JaSfzUIqlxoYoN7HruDrjsZsXBjmo1R5BZoz41itbISF4KVmXWGFDptDMpuTc5Q0D2Mt
         ZF8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rmUqM+JYtP9hKEr5gUjT2LuBcGNasQZbfimvB5akS00=;
        b=HkfZkha0W1Y0vAE9hfN0BqBoTOjX7cg1Laf2koQg4mfVM4k756Ct7zRkloSgY9g8Og
         KX2vqqxWiHY3Cv3lekKDDD3KjwBSfmnK2JTuYE/94Orj7P9gQzONl8HywI/8JP09o0eh
         6c9Mofv86RNmT0sny8ZN8n9QV/L2jGZWMcJAh7FQVHrBLWXk7h2DyAJkTFTZZ6Q1s/vH
         d1OxOwsSUsdOH/HYfpZdbq30l25oL20hBQoDWBkssRhWWsSEjmZeZ/71BK4prOuuqqg1
         vNPuz+JNUefj9nCL/xfccCbA4ORoIHBp5TRPjJieHkirWrB1GquAl+KcGKAuqzbobx5q
         zGGQ==
X-Gm-Message-State: AOAM533SHCeresHycfRypodUoBeFFWxUJJzE/agyjcxavj9tcAZ38xYO
        Ch+ErKLw6S8vfvn2ii5/fdM=
X-Google-Smtp-Source: ABdhPJzMlxmlw8YH91GcLyV34WOI1xXzkODCQvuPtu9ZdLRfbSUUBhOWPfWc0+73AFMCHNRZuFeSlg==
X-Received: by 2002:a17:90b:3e8e:: with SMTP id rj14mr3110941pjb.35.1644047283967;
        Fri, 04 Feb 2022 23:48:03 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id p21sm5165844pfh.89.2022.02.04.23.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 23:48:03 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, edumazet@google.com, alobakin@pm.me, ast@kernel.org,
        imagedong@tencent.com, pabeni@redhat.com, keescook@chromium.org,
        talalahmad@google.com, haokexin@gmail.com,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        paulb@nvidia.com, cong.wang@bytedance.com, mengensun@tencent.com
Subject: [PATCH v4 net-next 2/7] net: netfilter: use kfree_drop_reason() for NF_DROP
Date:   Sat,  5 Feb 2022 15:47:34 +0800
Message-Id: <20220205074739.543606-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220205074739.543606-1-imagedong@tencent.com>
References: <20220205074739.543606-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in nf_hook_slow() when
skb is dropped by reason of NF_DROP. Following new drop reasons
are introduced:

SKB_DROP_REASON_NETFILTER_DROP

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- add document for SKB_DROP_REASON_NETFILTER_DROP
---
 include/linux/skbuff.h     | 1 +
 include/trace/events/skb.h | 1 +
 net/netfilter/core.c       | 3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5c5615a487e7..786ea2c2334e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -320,6 +320,7 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_CSUM,	/* TCP checksum error */
 	SKB_DROP_REASON_SOCKET_FILTER,	/* dropped by socket filter */
 	SKB_DROP_REASON_UDP_CSUM,	/* UDP checksum error */
+	SKB_DROP_REASON_NETFILTER_DROP,	/* dropped by netfilter */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index a8a64b97504d..3d89f7b09a43 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -16,6 +16,7 @@
 	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
 	EM(SKB_DROP_REASON_SOCKET_FILTER, SOCKET_FILTER)	\
 	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
+	EM(SKB_DROP_REASON_NETFILTER_DROP, NETFILTER_DROP)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 354cb472f386..d1c9dfbb11fa 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -621,7 +621,8 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 		case NF_ACCEPT:
 			break;
 		case NF_DROP:
-			kfree_skb(skb);
+			kfree_skb_reason(skb,
+					 SKB_DROP_REASON_NETFILTER_DROP);
 			ret = NF_DROP_GETERR(verdict);
 			if (ret == 0)
 				ret = -EPERM;
-- 
2.34.1

