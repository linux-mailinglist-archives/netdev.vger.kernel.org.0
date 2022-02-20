Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4EE4BCD16
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 08:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243509AbiBTHJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 02:09:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243464AbiBTHI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 02:08:58 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAA14D9EB;
        Sat, 19 Feb 2022 23:08:18 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id ay3so1597197plb.1;
        Sat, 19 Feb 2022 23:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DbbNOV68vkmEiWU6Oj+oPKRTONiCzDjrU+Vk7Cw0dQ8=;
        b=JgxrsgWUOHSPgwJ0q6CXqNBxRDZVmHTU1BXWoi2hj6+2lAxwZQjhc6m7QKe0Imbxqu
         yEXyFosLOdHDsHh1stQg/duIIe5KRCjpcj0VOEQedlyNs+2mMLxqtQfy9EqQSJUT7/bM
         BvSWzgriaID4IdmZzq6tU6/s9Wp9VmUryqHSgKaytq3/t/h7OAuOXc4koMPEKb7RuabM
         8UPs40ym6+oxzIvbA//cBOeZV4Bzha2qyLemFL0n9Rf7TK6LBYbvAWxTI2e83zrwW5NA
         N6l1bcQGzqxjwoaRkiIGch5UH9DKuLox07HjNGijci+q6SBDEpeve1vHDDEHvwkzWxC5
         SRqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DbbNOV68vkmEiWU6Oj+oPKRTONiCzDjrU+Vk7Cw0dQ8=;
        b=276REIHAORg7XXA5DfoM5qyySkACvMeDTI+jND/kRbXeUiTVy9uvlI/HppSWz7cu1r
         iBw3FnMjhpMDkKPS1V164jxq0JGBSg66DBPUOUMZXynXQ5iGFAGhDPeWsVFVeoss2kBo
         XjGjOjo8I2fGMH2A0PcZsfC5wqf7uuf2rgcPlDQ9VygMFU/ys38yfY/qdYzBgSjZuucv
         Uh71zXRUZkmKszUkIrur9qmZw3N+H0ssgx6rCeJn+Jhzgwk+RMCbgXIhTiybhxDZgE8f
         +sDBlyoI4Eo4eu1YqOF+GFV2H6A6iTrbO7hX3QVxcfrqAxN9AxPmAwBG5qSP3BP0wx/Y
         KgEA==
X-Gm-Message-State: AOAM531Dq3AaQlQGRs2irgztW/IZcg4eimDR/KMcKl9kDX0rctkXpjFQ
        wtzlGZnUdEYMvQTtCMYZUGU=
X-Google-Smtp-Source: ABdhPJw+dEz+p4UjR4z3rPqMMgAa4JKkZ8oscraFHe9EL9sZd7lnuct9SfYUJayY3bIBX8K12JVUtA==
X-Received: by 2002:a17:90a:ab08:b0:1b9:c59:82c3 with SMTP id m8-20020a17090aab0800b001b90c5982c3mr20071502pjq.95.1645340897917;
        Sat, 19 Feb 2022 23:08:17 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id p1sm8351326pfo.212.2022.02.19.23.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 23:08:17 -0800 (PST)
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
Subject: [PATCH net-next v3 5/9] net: tcp: add skb drop reasons to tcp_add_backlog()
Date:   Sun, 20 Feb 2022 15:06:33 +0800
Message-Id: <20220220070637.162720-6-imagedong@tencent.com>
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

Pass the address of drop_reason to tcp_add_backlog() to store the
reasons for skb drops when fails. Following drop reasons are
introduced:

SKB_DROP_REASON_SOCKET_BACKLOG

Reviewed-by: Mengen Sun <mengensun@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 include/linux/skbuff.h     | 4 ++++
 include/net/tcp.h          | 3 ++-
 include/trace/events/skb.h | 1 +
 net/ipv4/tcp_ipv4.c        | 7 +++++--
 net/ipv6/tcp_ipv6.c        | 2 +-
 5 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 46678eb587ff..f7f33c79945b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -358,6 +358,10 @@ enum skb_drop_reason {
 					 * corresponding to
 					 * LINUX_MIB_TCPMD5FAILURE
 					 */
+	SKB_DROP_REASON_SOCKET_BACKLOG,	/* failed to add skb to socket
+					 * backlog (see
+					 * LINUX_MIB_TCPBACKLOGDROP)
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index eff2487d972d..04f4650e0ff0 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1367,7 +1367,8 @@ static inline bool tcp_checksum_complete(struct sk_buff *skb)
 		__skb_checksum_complete(skb);
 }
 
-bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb);
+bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
+		     enum skb_drop_reason *reason);
 
 #ifdef CONFIG_INET
 void __sk_defer_free_flush(struct sock *sk);
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 46c06b0be850..bfccd77e9071 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -31,6 +31,7 @@
 	EM(SKB_DROP_REASON_TCP_MD5UNEXPECTED,			\
 	   TCP_MD5UNEXPECTED)					\
 	EM(SKB_DROP_REASON_TCP_MD5FAILURE, TCP_MD5FAILURE)	\
+	EM(SKB_DROP_REASON_SOCKET_BACKLOG, SOCKET_BACKLOG)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index d3c417119057..cbca8637ba2f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1811,7 +1811,8 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 	return 0;
 }
 
-bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
+bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
+		     enum skb_drop_reason *reason)
 {
 	u32 limit, tail_gso_size, tail_gso_segs;
 	struct skb_shared_info *shinfo;
@@ -1837,6 +1838,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 	if (unlikely(tcp_checksum_complete(skb))) {
 		bh_unlock_sock(sk);
 		trace_tcp_bad_csum(skb);
+		*reason = SKB_DROP_REASON_TCP_CSUM;
 		__TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 		__TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 		return true;
@@ -1925,6 +1927,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 
 	if (unlikely(sk_add_backlog(sk, skb, limit))) {
 		bh_unlock_sock(sk);
+		*reason = SKB_DROP_REASON_SOCKET_BACKLOG;
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPBACKLOGDROP);
 		return true;
 	}
@@ -2133,7 +2136,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	if (!sock_owned_by_user(sk)) {
 		ret = tcp_v4_do_rcv(sk, skb);
 	} else {
-		if (tcp_add_backlog(sk, skb))
+		if (tcp_add_backlog(sk, skb, &drop_reason))
 			goto discard_and_relse;
 	}
 	bh_unlock_sock(sk);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 1262b790b146..abf0ad547858 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1784,7 +1784,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	if (!sock_owned_by_user(sk)) {
 		ret = tcp_v6_do_rcv(sk, skb);
 	} else {
-		if (tcp_add_backlog(sk, skb))
+		if (tcp_add_backlog(sk, skb, &drop_reason))
 			goto discard_and_relse;
 	}
 	bh_unlock_sock(sk);
-- 
2.35.1

