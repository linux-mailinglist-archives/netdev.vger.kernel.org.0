Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85C994AA770
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 08:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379660AbiBEHs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 02:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379624AbiBEHsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 02:48:22 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2799C061347;
        Fri,  4 Feb 2022 23:48:21 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id x3so7073886pll.3;
        Fri, 04 Feb 2022 23:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9BmxrMHdsxTVTtMUopIY8p4Hr0XxhRFGz/KMlExKtGA=;
        b=afPBOLrpEdRPwhZ/1UjBJl+6+uH6cRdp0zy2uU05sPEzGfdC86irsfBYWpziIwRRZv
         Nr0zJv0IOEI+GAXA+4m9WEivE3SmudoDG7u0Ihn5j/hAEM4bYFXTqNBXNHqau7nc8+OD
         bf/zrRkdnd2K8XzWoTEo7fQUJerkeKctVy7u1OmCMjQfhSI1VDf0CXiWXdkwqBz2HQRb
         JM/BEY1cOUBzCoJth4kb2uEmhyEpUNxgh2U45sHiPBAuWOyfJxjVnoLqQGtNpqmBCDLB
         8M5U3Dn8/WM7/qMfIHXEY4jwfc2Az1u2Q2rcLlu8017o8aRNMNe326rMhgHub0FCj+7I
         26HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9BmxrMHdsxTVTtMUopIY8p4Hr0XxhRFGz/KMlExKtGA=;
        b=AOZy4Usn5E+H/HqT1qm5IZ8rfT53uMHuHNl0C3AokhhZIref3R+fs1QrydRiltdJNb
         Q+uDsJKwGPneESy2otkobpEa8i4TP+nhnQ7oPs/NHgwj+mI3Z2dbZIBekx61ZvBMlSMK
         kiavoLX4Sur7/bzQWTo84YzsbZueLFEwZcKrtOE99Vj26PuCgxAmIkWxrWjliUwYPlfj
         Y09AhF5+AmNninnf+r47xFvoJULw12f2gP7BRPpmKf/Q+xWdip5bjNzipb3rs9VHekBa
         y4Cfno2WgYBZuiV+KmZiN5plDuEF96hvm8QhBpbjW3ElT8cXywRuFJxzvu2S9stwehVS
         zf7A==
X-Gm-Message-State: AOAM533uuxBpzeJQtyKw6gPpn2/1skaQ7fTpRtizUhiQk+eX0mnd+T32
        UondulOFHaj4xL8BaUoH8PU=
X-Google-Smtp-Source: ABdhPJzFXlYTP5IPYJSOe/hYmDd9uwpUtlyBRWWoMwRa3tvdQzczSnAD2WE1dtuXPzcDtxYfEtQpKA==
X-Received: by 2002:a17:903:2446:: with SMTP id l6mr7302518pls.48.1644047301439;
        Fri, 04 Feb 2022 23:48:21 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id p21sm5165844pfh.89.2022.02.04.23.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 23:48:20 -0800 (PST)
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
Subject: [PATCH v4 net-next 5/7] net: ipv4: use kfree_skb_reason() in ip_protocol_deliver_rcu()
Date:   Sat,  5 Feb 2022 15:47:37 +0800
Message-Id: <20220205074739.543606-6-imagedong@tencent.com>
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

Replace kfree_skb() with kfree_skb_reason() in ip_protocol_deliver_rcu().
Following new drop reasons are introduced:

SKB_DROP_REASON_XFRM_POLICY
SKB_DROP_REASON_IP_NOPROTO

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
v2:
- add document for the introduced drop reasons
---
 include/linux/skbuff.h     | 2 ++
 include/trace/events/skb.h | 2 ++
 net/ipv4/ip_input.c        | 5 +++--
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4baba45f223d..2a64afa97910 100644
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
index d5222c0fa87c..d94f9f7e60c3 100644
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

