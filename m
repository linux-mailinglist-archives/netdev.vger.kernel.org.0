Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBA44BCCF9
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 08:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243469AbiBTHJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 02:09:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243481AbiBTHJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 02:09:00 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604AA4DF5E;
        Sat, 19 Feb 2022 23:08:25 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id j10-20020a17090a94ca00b001bc2a9596f6so554886pjw.5;
        Sat, 19 Feb 2022 23:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QPZoWV1SKW4iKxyXPzKvu7NeooPUoHjyNJIyJ7KsDy0=;
        b=j1Ycl3l7ax1SCuYlRD0hZNQwYMt1gZ2i7EbZ4o/xpXHbGTeYlbSuzkrZpqaezxF26a
         yMn1DG4+Fyt1x67BTLBtDGkoezn/wlX3gI4epYVoj+4kKsx0Fq9GoS9v6l4OSNMtHkNM
         Nrz1hfVd9zqMajqlI/Yr2lz8CocheR0fEw67/XxdPwQxCLc3vjYV5M6ihi9KOZsNhjcP
         caeueyqfSyRO64CW1FzA8pKceNq9qw2IMdIQmMXar4NVo3wRodvGrc/cbswylzLElF8p
         6x+NumebyngS3aEmVPq13tmrsmjFHe3mRwHQ2Ogyf4tspKRZOyGpwW+hhSohp2EBJFqR
         uYlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QPZoWV1SKW4iKxyXPzKvu7NeooPUoHjyNJIyJ7KsDy0=;
        b=rD9nhQSPPpWfXSNZuvGUMQFyJS4pKfXgBOORIo7/WyYVXQqmifZ7YHZCim3vBRfPBo
         MKeW+va5/MJj4sZOtJhQ/veUSV0yxsaOB2yu8BMlRnsMQng6OPF1d5chTK+H10gDzoKp
         gFkDuC+aBoYnitNe3r2TRSrGcC5+CD9hnT19TbAGFxmH4woNUDK8PWECbH+pNo2afFKX
         0sBD5kA9D6FyFcpzPI5C89843sIZu8nUFaOpS0ktV4MmH1wdiRU3Izq46xc5WRxxMPXq
         7dA1g3zBVCp50v/Sj76A+kFmvtLrF2txqUKKTuflfU4pG0mMUJ8KfFNa48Ic7gIqnZ+v
         KKHA==
X-Gm-Message-State: AOAM530P0qjEwW012qRvx0DOSKZHVr1eK4VqfAtAwBgO6NwD0u8aojxc
        vhtTcJFzXa0YdH4ANxdfhjg=
X-Google-Smtp-Source: ABdhPJzspKnbl5A1pgj9ocX4cj94uj4n/en/TEZjjDavnyMt3x9k0kxQqbt++lhtrmCyj+gKjpdGoA==
X-Received: by 2002:a17:90b:1e11:b0:1b9:d23:bc3c with SMTP id pg17-20020a17090b1e1100b001b90d23bc3cmr20012492pjb.77.1645340904943;
        Sat, 19 Feb 2022 23:08:24 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id p1sm8351326pfo.212.2022.02.19.23.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 23:08:24 -0800 (PST)
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
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        flyingpeng@tencent.com, mengensun@tencent.com
Subject: [PATCH net-next v3 6/9] net: tcp: use kfree_skb_reason() for tcp_v{4,6}_do_rcv()
Date:   Sun, 20 Feb 2022 15:06:34 +0800
Message-Id: <20220220070637.162720-7-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220070637.162720-1-imagedong@tencent.com>
References: <20220220070637.162720-1-imagedong@tencent.com>
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

Reviewed-by: Mengen Sun <mengensun@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
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
2.35.1

