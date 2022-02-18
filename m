Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4724BB448
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbiBRIdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:33:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbiBRId1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:33:27 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CD73298D;
        Fri, 18 Feb 2022 00:33:02 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id y11so1786731pfa.6;
        Fri, 18 Feb 2022 00:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YfkPNEIHP/FZToJsJM5n11iuHLqEk1bkFf9s+J4zLMU=;
        b=Uaq1KCzE6admxBBALvA+MlP8pUcKALVyyfGfN7v+Vg8P19XBpFx9jlgFakpFSn2VV/
         GtY537oMOrzNk5DOnM/CtSwGiOsXuCTYtQNnEwRXfc/NwkIDWzogw+pczuV6HPth0WKw
         ixv/+Jp1FPWnMKJKu2QiENeo3oK18y9lZDPl7f1lnxOqe/f4XvpDikJ0nU00R9TEUT39
         MBCFG+MmPcHO4VSHJEkbO8vbeuu9SzEd+ErvnLfArI66JRNa4udnfMyvPY8uU8S8YOpB
         86l26jjw79pilm75HZU3Y31ollS7fv0K8HWQ1bRD5EugKMX8jY7HcuKAh4R0MHXQG7Vq
         S1rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YfkPNEIHP/FZToJsJM5n11iuHLqEk1bkFf9s+J4zLMU=;
        b=wnrMEbx1fFnvtn4BbqaYtUvfzSaIfJoxh3oLJMqp1wXfMxoACPSWoqhQ6rWZrRJTMK
         F02GlatVbCTBOLEx4H3iRDW52x/6dbocz2GrLeM4fsTjE0BKSBtul0QWmJiyANDCM0fs
         T11YJ+hsyCyHLfpF2BQrvnsYdDZM5557yxaykBhTibw0jFvZh19bXb90RY6chJ+Df+Lz
         QvzAQKeytdpDsovR5FIt6dPjJu8CG5Yv18Ae4jUwljjBH1HRvBvjLh3KMo+fbO44l80s
         OjGZltCCSRqSZZAj9fUE2yacz7Ip5JLECudHGmYrAx1YuD7uGNdJndj+iw1JdlLMfzH1
         V4Sg==
X-Gm-Message-State: AOAM530Et821TS2pNvEU7Y7NJTSiPYN7+71+v3GutUiycWmGPbaAA2Jm
        ypd9DU6qaOk/sQzWdPjeIrA=
X-Google-Smtp-Source: ABdhPJw1hwitH4AXxbFdwx8kafHPrRcC0gAVufHWSCrohSJHFIWogyhRcMMZY/RxvPamytdVtScYCw==
X-Received: by 2002:aa7:8d42:0:b0:4bd:265:def4 with SMTP id s2-20020aa78d42000000b004bd0265def4mr6743779pfe.24.1645173182262;
        Fri, 18 Feb 2022 00:33:02 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id m23sm1963530pff.201.2022.02.18.00.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 00:33:01 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@redhat.com, yoshfuji@linux-ipv6.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        memxor@gmail.com, atenart@kernel.org, bigeasy@linutronix.de,
        pabeni@redhat.com, linyunsheng@huawei.com, arnd@arndb.de,
        yajun.deng@linux.dev, roopa@nvidia.com, willemb@google.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, flyingpeng@tencent.com
Subject: [PATCH net-next v2 6/9] net: tcp: use kfree_skb_reason() for tcp_v{4,6}_do_rcv()
Date:   Fri, 18 Feb 2022 16:31:30 +0800
Message-Id: <20220218083133.18031-7-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218083133.18031-1-imagedong@tencent.com>
References: <20220218083133.18031-1-imagedong@tencent.com>
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

Replace kfree_skb() used in tcp_v4_do_rcv() and tcp_v6_do_rcv() with
kfree_skb_reason().

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- init 'reason' properly in tcp_v6_do_rcv()
---
 net/ipv4/tcp_ipv4.c | 5 ++++-
 net/ipv6/tcp_ipv6.c | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index cbca8637ba2f..d42824aedc36 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1708,6 +1708,7 @@ INDIRECT_CALLABLE_DECLARE(struct dst_entry *ipv4_dst_check(struct dst_entry *,
  */
 int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 {
+	enum skb_drop_reason reason;
 	struct sock *rsk;
 
 	if (sk->sk_state == TCP_ESTABLISHED) { /* Fast path */
@@ -1730,6 +1731,7 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 		return 0;
 	}
 
+	reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (tcp_checksum_complete(skb))
 		goto csum_err;
 
@@ -1757,7 +1759,7 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 reset:
 	tcp_v4_send_reset(rsk, skb);
 discard:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	/* Be careful here. If this function gets more complicated and
 	 * gcc suffers from register pressure on the x86, sk (in %ebx)
 	 * might be destroyed here. This current version compiles correctly,
@@ -1766,6 +1768,7 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 	return 0;
 
 csum_err:
+	reason = SKB_DROP_REASON_TCP_CSUM;
 	trace_tcp_bad_csum(skb);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index abf0ad547858..91cee8010285 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1476,6 +1476,7 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 {
 	struct ipv6_pinfo *np = tcp_inet6_sk(sk);
 	struct sk_buff *opt_skb = NULL;
+	enum skb_drop_reason reason;
 	struct tcp_sock *tp;
 
 	/* Imagine: socket is IPv6. IPv4 packet arrives,
@@ -1510,6 +1511,7 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 	if (np->rxopt.all)
 		opt_skb = skb_clone(skb, sk_gfp_mask(sk, GFP_ATOMIC));
 
+	reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (sk->sk_state == TCP_ESTABLISHED) { /* Fast path */
 		struct dst_entry *dst;
 
@@ -1563,9 +1565,10 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 discard:
 	if (opt_skb)
 		__kfree_skb(opt_skb);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return 0;
 csum_err:
+	reason = SKB_DROP_REASON_TCP_CSUM;
 	trace_tcp_bad_csum(skb);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
-- 
2.34.1

