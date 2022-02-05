Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8B04AA76D
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 08:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379638AbiBEHsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 02:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379616AbiBEHsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 02:48:16 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73B0C061353;
        Fri,  4 Feb 2022 23:48:15 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id h12so7774267pjq.3;
        Fri, 04 Feb 2022 23:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R5oxeTlCZV+XvE1sgbFLa3xKvlTQGz9d/BNh7vx4mzs=;
        b=K+aMofl2ew/1XakIwJhloWcROFsb169W2ch0QziGgzH+PeqFB9juea5hoMmb7aPPId
         K0QBdSrWnAgcs6J5JT0JIcudmSqu1NuC7ZXHs7u6arlelsmWJeZRvqtzQt1kagFJgJA0
         gzWoeqbhnCUPIshqosYyLIC2xnTe7b07y0s7GkKh4eQZ7jLUicgHLrtsQLP9JpeYy9lt
         +yZgOXE/LsRvxFfCiPY7joJplFKsHockOmEx5ZwHXqUXzoTZoB7LEfTD/B8cp4lC/7hd
         OLGYougD7xg082mADLQ4eWL/4jfQCfzDWeik35q7eugGjonNijoOpszaE0LCs3MkK34u
         UqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R5oxeTlCZV+XvE1sgbFLa3xKvlTQGz9d/BNh7vx4mzs=;
        b=R0bt14VOgqCrQ+NjCW+8R+CXHSpy2snpcaAQpOv+PtsWFPwZfqOJffkkuPJdyvb6wz
         tlSOd0zk2HoEH18h8C9ZObQnm+XBqOeVnH9TlnKVzzk/E00aDGZ34jFLUPYQLk12ANWA
         x04K3Xta1OzvVBau1oudQhgmB5nOHggawa/bdTTwJyiPJj2Fw9/gJY8Qw+IjRKypGCTJ
         yaCkNiOvRmssXpwbhwv42XnmM2uovQ5nxyo5GmLvlfLQP5G+F2n6PGabgWOOHsziuZu4
         W+cf1JWcvJ06DmovN5TZZoKh654Djq6m6CFNMs+qjIllVAs8+i+AY0lJNahhwo88iYSJ
         A50g==
X-Gm-Message-State: AOAM533sI+G63Fbj27+UaVaZGPm7qnlsM65qwZrppXJMom9eJNaI6M3T
        zgdQ+DZkBm1J82xTP7HY8+A=
X-Google-Smtp-Source: ABdhPJwRCYzWWTnsyxsrvlmycYJjW5Lp1/rbAh8gSQgHZ+kg7cpt4lXhljpi4MZcLdB0zUu1knqRcA==
X-Received: by 2002:a17:90b:164a:: with SMTP id il10mr3081560pjb.117.1644047295489;
        Fri, 04 Feb 2022 23:48:15 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id p21sm5165844pfh.89.2022.02.04.23.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 23:48:15 -0800 (PST)
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
Subject: [PATCH v4 net-next 4/7] net: ipv4: use kfree_skb_reason() in ip_rcv_finish_core()
Date:   Sat,  5 Feb 2022 15:47:36 +0800
Message-Id: <20220205074739.543606-5-imagedong@tencent.com>
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

Replace kfree_skb() with kfree_skb_reason() in ip_rcv_finish_core(),
following drop reasons are introduced:

SKB_DROP_REASON_IP_RPFILTER
SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
v2:
- remove SKB_DROP_REASON_EARLY_DEMUX and SKB_DROP_REASON_IP_ROUTE_INPUT
- add document for SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST and
  SKB_DROP_REASON_IP_RPFILTER
---
 include/linux/skbuff.h     |  9 +++++++++
 include/trace/events/skb.h |  3 +++
 net/ipv4/ip_input.c        | 14 ++++++++++----
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8e82130b3c52..4baba45f223d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -330,6 +330,15 @@ enum skb_drop_reason {
 					 * IP header (see
 					 * IPSTATS_MIB_INHDRERRORS)
 					 */
+	SKB_DROP_REASON_IP_RPFILTER,	/* IP rpfilter validate failed.
+					 * see the document for rp_filter
+					 * in ip-sysctl.rst for more
+					 * information
+					 */
+	SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST, /* destination address of L2
+						  * is multicast, but L3 is
+						  * unicast.
+						  */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index f2b1778485f0..485a1d3034a4 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -20,6 +20,9 @@
 	EM(SKB_DROP_REASON_OTHERHOST, OTHERHOST)		\
 	EM(SKB_DROP_REASON_IP_CSUM, IP_CSUM)			\
 	EM(SKB_DROP_REASON_IP_INHDR, IP_INHDR)			\
+	EM(SKB_DROP_REASON_IP_RPFILTER, IP_RPFILTER)		\
+	EM(SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST,		\
+	   UNICAST_IN_L2_MULTICAST)				\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 7be18de32e16..d5222c0fa87c 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -318,8 +318,10 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 {
 	const struct iphdr *iph = ip_hdr(skb);
 	int (*edemux)(struct sk_buff *skb);
+	int err, drop_reason;
 	struct rtable *rt;
-	int err;
+
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 	if (ip_can_use_hint(skb, iph, hint)) {
 		err = ip_route_use_hint(skb, iph->daddr, iph->saddr, iph->tos,
@@ -396,19 +398,23 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 		 * so-called "hole-196" attack) so do it for both.
 		 */
 		if (in_dev &&
-		    IN_DEV_ORCONF(in_dev, DROP_UNICAST_IN_L2_MULTICAST))
+		    IN_DEV_ORCONF(in_dev, DROP_UNICAST_IN_L2_MULTICAST)) {
+			drop_reason = SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST;
 			goto drop;
+		}
 	}
 
 	return NET_RX_SUCCESS;
 
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return NET_RX_DROP;
 
 drop_error:
-	if (err == -EXDEV)
+	if (err == -EXDEV) {
+		drop_reason = SKB_DROP_REASON_IP_RPFILTER;
 		__NET_INC_STATS(net, LINUX_MIB_IPRPFILTER);
+	}
 	goto drop;
 }
 
-- 
2.34.1

