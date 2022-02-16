Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55784B7EF4
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245406AbiBPD4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 22:56:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343713AbiBPDzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 22:55:50 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1AEF65F5;
        Tue, 15 Feb 2022 19:55:39 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id b8so1307745pjb.4;
        Tue, 15 Feb 2022 19:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EZoukMGiWXk1HvbuQEBDTM8Ki/Xg0Kqyx/8NN8gbO9E=;
        b=EVm+tVf2ob8Bd6hyOZxaiciBkLNRKhy/EBpSFT+cBRzIH7Ri8w6Jh7P6eZ37/+I3O9
         EkF1aAtMePZh9l5I3yPqlV5jT7Wa0wH0SiD8X2W68NQS+G/yGhx4PG37DDbpif2/9LGQ
         4wwpC7mmMzAWkJsJvc+jKCaqF9YI21IUG8RyHi2RQ7MGIvOWsDeZJtHrEZy+yJiFHZ0I
         mhY1ocLYU6tXr7jRCq0AHyagEISi42OpHnhcHuQyR8TynzbztdGrnfeKGsJeipgXQPJA
         a5SlmUYU9KIPByXXjChd3Nc336TJpjYIV3IJVttfUg63I0xOyxzzcvabmQ/Z2rYZIO71
         1f9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EZoukMGiWXk1HvbuQEBDTM8Ki/Xg0Kqyx/8NN8gbO9E=;
        b=eQm0frnsuP3jJvZ8i8QFhR93XglmKcjBEl7BQlLz784psR8J5wuek9xyxVNFLbGCx1
         jFawQdsk6E/zJLYKVB9Y0vxp+n+SuZXw0TYyu6DnZD+nKGAx8OCVVoORgP3HKcoiNAT3
         2Nu4GeFKf84kpbNE2c6dKYbsOSZv8d5isWvV4fHTpmOOpuOMmsUWfYxNEbG8q0tMi7wI
         EHjsYF7h6jhpAlNcL4MfQyGM2rPZVv+hVMW7r/M16+2QEgIQvwaanL4e88tMZ8aKZflC
         YloYqpsmXWQikeSqmjiL7Q3EwsYVhtpCTPykTOnsRITedxVZhAxIUhm24pfEZbzGGsyu
         5VKQ==
X-Gm-Message-State: AOAM5301iJvmV9Vhhe4gdYrFt762TZyZoOYmxOCtQtNOBqvGhFpyM0sy
        YNOFRXRYh15plXatkcHJt8s=
X-Google-Smtp-Source: ABdhPJyU9BV6vwbfISPw6NBlVM3EGCGhdymUXNk1IdlFwiV0htoID4GvR7obIfHk4OFOMp5UuTcJ0A==
X-Received: by 2002:a17:90a:3e4e:b0:1b9:bda3:10f5 with SMTP id t14-20020a17090a3e4e00b001b9bda310f5mr744386pjm.112.1644983739080;
        Tue, 15 Feb 2022 19:55:39 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.gmail.com with ESMTPSA id nn16sm19099668pjb.2.2022.02.15.19.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 19:55:38 -0800 (PST)
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
Subject: [PATCH net-next 6/9] net: tcp: use kfree_skb_reason() for tcp_v{4,6}_do_rcv()
Date:   Wed, 16 Feb 2022 11:54:23 +0800
Message-Id: <20220216035426.2233808-7-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220216035426.2233808-1-imagedong@tencent.com>
References: <20220216035426.2233808-1-imagedong@tencent.com>
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
 net/ipv4/tcp_ipv4.c | 5 ++++-
 net/ipv6/tcp_ipv6.c | 4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 15ef1bcff84f..036b855c1b14 100644
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
index 15090fe5af90..4d4af9b15c83 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1476,6 +1476,7 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 {
 	struct ipv6_pinfo *np = tcp_inet6_sk(sk);
 	struct sk_buff *opt_skb = NULL;
+	enum skb_drop_reason reason;
 	struct tcp_sock *tp;
 
 	/* Imagine: socket is IPv6. IPv4 packet arrives,
@@ -1563,9 +1564,10 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
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

