Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDD34B6AE6
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237192AbiBOLbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:31:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237187AbiBOLbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:31:31 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B503108BDD;
        Tue, 15 Feb 2022 03:31:19 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id j4so12863810plj.8;
        Tue, 15 Feb 2022 03:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4mL7mLVT3JQWo1KYz/axuOVYLZG4n3zDx8r/aWnHrQ8=;
        b=b/77wzRD1mVw0wflJFwy3LjpfPeSHa889rp1wccFpGmeIGS50WLq+z3D2GjyI3Vq8Y
         Bl3/CyDJrKx8p4NlzxieUzy8D3Hpo5EXyDWINDz+dj5KCf4l9+gYzhzGFbeiIxk1tK7+
         ItYueAkjDo1pLwM6/XqZgSj+6VLaNSHtx5n7WOjRoLoKfhJfoSYMsQ4zhYwZzzVM2HwP
         yJ6Q4gQjrBwQ+o3uOzAEPIqmYPEdO4mtteu1lGZRXCcuHQn9urFwVzNYiMGir053fk+Y
         47/N/jnlBHt9d/qQ998MLsRcCwMiyxp6+fYo5vcO1dj1Yi2yakXtjFKJTaKTH6ntBqKc
         +8zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4mL7mLVT3JQWo1KYz/axuOVYLZG4n3zDx8r/aWnHrQ8=;
        b=hETLc45/b2xkVHKOHHVaM0D+XtB4pPy7ZDHk0Xklrgs7jSoj/f0FBUfvrVifydCo8n
         fzixKLkWbz+ZRoK0WPiGgMBFFF+Wj+DSQyr9uRFlkFEUwliRUi6kKHIXIVpDMR97fM9M
         zaW7gGtJhLXYS3kuOHvEgl17TH7PYNgcDthL3fF2L6hID8E9zh5WPMQc6bqkydbHAT9i
         YoBuKcmOxSadiETEFOcAA0iLXa0ve1lrjIiQJkD+rZ6fc+snmjAcI5YfWXazG0uhY4MB
         O8R5JDvcMzl9vsIPkQ11LiAGjfjodn7XLu0HBZRkWfwYNd0CuwEzJR3XN3MNLVlY9r1J
         DvPQ==
X-Gm-Message-State: AOAM533L3XB7nCmmN1uThsH5zq3FNvl6d2KqI+GsO0sQuiRrW3lsfi/f
        9hD4on6CaSIcxLtEoW1iT6M=
X-Google-Smtp-Source: ABdhPJzh16XH32BGyBRkmZGNbIMIDVoyblKCMxYlQsJXqDI/aSXVD3m/WhuucsvWOeOXeBeUMB6fww==
X-Received: by 2002:a17:902:ced1:: with SMTP id d17mr3699617plg.37.1644924678996;
        Tue, 15 Feb 2022 03:31:18 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:31:18 -0800 (PST)
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
Subject: [PATCH net-next 05/19] net: tcp: add skb drop reasons to tcp_add_backlog()
Date:   Tue, 15 Feb 2022 19:27:58 +0800
Message-Id: <20220215112812.2093852-6-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215112812.2093852-1-imagedong@tencent.com>
References: <20220215112812.2093852-1-imagedong@tencent.com>
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

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 4 ++++
 include/net/tcp.h          | 3 ++-
 include/trace/events/skb.h | 1 +
 net/ipv4/tcp_ipv4.c        | 7 +++++--
 net/ipv6/tcp_ipv6.c        | 2 +-
 5 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index aea46b38cffa..9a4424ceb7cb 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -353,6 +353,10 @@ enum skb_drop_reason {
 						 * expecting one
 						 */
 	SKB_DROP_REASON_TCP_MD5FAILURE,	/* MD5 hash and its wrong */
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
index 3e7ab605dddc..15ef1bcff84f 100644
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
index dfefbc1eac5d..15090fe5af90 100644
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
2.34.1

