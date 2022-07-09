Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E748F56C607
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 04:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiGICrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 22:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiGICrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 22:47:19 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D86A78211;
        Fri,  8 Jul 2022 19:47:17 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-10bffc214ffso883702fac.1;
        Fri, 08 Jul 2022 19:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6BGKZlQ2XgPXargm2Wo7BrmlFidyoAhj3y0XxGiXJm0=;
        b=JykCDruTogaWu6LLxNnu8Hd8UnhoJw4HRRvDIpLjJ3ArGe9cb7eNVrYGXxOlZhf9HH
         pNklBJZxZ9Gy29spJTJqCHrIDxvRTBr1RSvwrqhV9UE9qvzQsf6Z4GN885ZZHNiRFmmA
         fqLPZ4oaPvYSZINiq45OiSReXqi+isfQ/BkcqEqqNnRaFEqMj/H2x5c/dnWhmUS9UCjr
         XxUmLujFcDkNylO/H6/dwgjdP2R3DweSb3MShtbRT6m4DfROYxmJy0w9YxTlnic5PNKc
         C8UNMkn6QSIyAaxy9mHISrYyUojjBYxmmPBqNeMbgBpD/+Bbux/0oH011IRwfZae8dPq
         J04Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6BGKZlQ2XgPXargm2Wo7BrmlFidyoAhj3y0XxGiXJm0=;
        b=LoNeawgfiTLmTfnjjtI7P5Gj9KqGHSR0YY5AjEJynqSTgOuiYH5MFI8N1RwwIRL2+A
         JiBBRu0lleUnBqsRwykabJxlS6QxcvPjzz/DhpZEoVlPoRkUN+PQFEdp9i+g4x6o6LoI
         X6km3bQ/5I8hlQJzeJt13oYl5DGVLdfv0Sb3ASwAQ7CqBb97QNgyXdoAThjPAXiZKNJT
         nJ7H1o9naglli0aMtOz3Cmzf9EzRkVardM0hjo041QliPQM9fP6QgSpKb1RUyvXP2VTb
         gBUhA4cfonYvBr+0pH8kpNSrDSvls+L979dKhu9RXNrtGGerMIlgUGthu8codgNjIzFV
         DmaA==
X-Gm-Message-State: AJIora++Q235eP20/mXjr7NQKr8tMKBnDd7WqUfnjF7aa0himvzr5Emm
        1rQ/qgTR3zTwqDhzQ6JChDU93iqCdSbM8q1j7EFoNw==
X-Google-Smtp-Source: AGRyM1vEOmXQ0e6DzN+O8R9g1l8g+u86gRu6KOjY6pNieru/kNk84RuiD7FmFu2uEYfiHCgH1y6KvA==
X-Received: by 2002:a05:6870:c0ce:b0:10c:4d83:8e15 with SMTP id e14-20020a056870c0ce00b0010c4d838e15mr1624440oad.137.1657334836236;
        Fri, 08 Jul 2022 19:47:16 -0700 (PDT)
Received: from ubuntu.lan ([136.175.179.221])
        by smtp.gmail.com with ESMTPSA id u65-20020acaab44000000b0032eb81e352asm274880oie.38.2022.07.08.19.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 19:47:15 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com
Cc:     andrii@kernel.org, ast@kernel.org, borisp@nvidia.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, guwen@linux.alibaba.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kgraul@linux.ibm.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        skhan@linuxfoundation.org, 18801353760@163.com,
        paskripkin@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH] smc: fix refcount bug in sk_psock_get (2)
Date:   Sat,  9 Jul 2022 10:46:59 +0800
Message-Id: <20220709024659.6671-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <00000000000026328205e08cdbeb@google.com>
References: <00000000000026328205e08cdbeb@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: hawk <18801353760@163.com>

Syzkaller reportes refcount bug as follows:
------------[ cut here ]------------
refcount_t: saturated; leaking memory.
WARNING: CPU: 1 PID: 3605 at lib/refcount.c:19 refcount_warn_saturate+0xf4/0x1e0 lib/refcount.c:19
Modules linked in:
CPU: 1 PID: 3605 Comm: syz-executor208 Not tainted 5.18.0-syzkaller-03023-g7e062cda7d90 #0
...
Call Trace:
 <TASK>
 __refcount_add_not_zero include/linux/refcount.h:163 [inline]
 __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
 refcount_inc_not_zero include/linux/refcount.h:245 [inline]
 sk_psock_get+0x3bc/0x410 include/linux/skmsg.h:439
 tls_data_ready+0x6d/0x1b0 net/tls/tls_sw.c:2091
 tcp_data_ready+0x106/0x520 net/ipv4/tcp_input.c:4983
 tcp_data_queue+0x25f2/0x4c90 net/ipv4/tcp_input.c:5057
 tcp_rcv_state_process+0x1774/0x4e80 net/ipv4/tcp_input.c:6659
 tcp_v4_do_rcv+0x339/0x980 net/ipv4/tcp_ipv4.c:1682
 sk_backlog_rcv include/net/sock.h:1061 [inline]
 __release_sock+0x134/0x3b0 net/core/sock.c:2849
 release_sock+0x54/0x1b0 net/core/sock.c:3404
 inet_shutdown+0x1e0/0x430 net/ipv4/af_inet.c:909
 __sys_shutdown_sock net/socket.c:2331 [inline]
 __sys_shutdown_sock net/socket.c:2325 [inline]
 __sys_shutdown+0xf1/0x1b0 net/socket.c:2343
 __do_sys_shutdown net/socket.c:2351 [inline]
 __se_sys_shutdown net/socket.c:2349 [inline]
 __x64_sys_shutdown+0x50/0x70 net/socket.c:2349
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
 </TASK>

syzbot is try to setup TLS on a SMC socket.

During SMC fallback process in connect syscall, kernel will sets the
smc->sk.sk_socket->file->private_data to smc->clcsock
in smc_switch_to_fallback(), and set smc->clcsock->sk_user_data
to origin smc in smc_fback_replace_callbacks().

When syzbot makes a setsockopt syscall, its argument sockfd
actually points to smc->clcsock, which is not a smc_sock type,
So it won't call smc_setsockopt() in setsockopt syscall,
instead it will call do_tcp_setsockopt() to setup TLS, which
bypasses the fixes 734942cc4ea6, its content is shown as below
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index be3e80b3e27f1..5eff7cccceffc 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -2161,6 +2161,9 @@ static int smc_setsockopt(struct socket *sock,
> 			int level, int optname,
>  	struct smc_sock *smc;
>  	int val, rc;
>
> +	if (level == SOL_TCP && optname == TCP_ULP)
> +		return -EOPNOTSUPP;
> +
>  	smc = smc_sk(sk);
>
>  	/* generic setsockopts reaching us here always apply to the
> @@ -2185,7 +2188,6 @@ static int smc_setsockopt(struct socket *sock,
>			int level, int optname,
>  	if (rc || smc->use_fallback)
>  		goto out;
>  	switch (optname) {
> -	case TCP_ULP:
>  	case TCP_FASTOPEN:
>  	case TCP_FASTOPEN_CONNECT:
>  	case TCP_FASTOPEN_KEY:
> --

Later, sk_psock_get() will treat the smc->clcsock->sk_user_data
as sk_psock type, which triggers the refcnt warning.

So Just disallow this setup in do_tcp_setsockopt() is OK,
by checking whether sk_user_data points to a SMC socket.

Reported-and-tested-by: syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com
Signed-off-by: hawk <18801353760@163.com>
---
 net/ipv4/tcp.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9984d23a7f3e..a1e6cab2c748 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3395,10 +3395,23 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 	}
 	case TCP_ULP: {
 		char name[TCP_ULP_NAME_MAX];
+		struct sock *smc_sock;
 
 		if (optlen < 1)
 			return -EINVAL;
 
+		/* SMC sk_user_data may be treated as psock,
+		 * which triggers a refcnt warning.
+		 */
+		rcu_read_lock();
+		smc_sock = rcu_dereference_sk_user_data(sk);
+		if (level == SOL_TCP && smc_sock &&
+		    smc_sock->__sk_common.skc_family == AF_SMC) {
+			rcu_read_unlock();
+			return -EOPNOTSUPP;
+		}
+		rcu_read_unlock();
+
 		val = strncpy_from_sockptr(name, optval,
 					min_t(long, TCP_ULP_NAME_MAX - 1,
 					      optlen));
-- 
2.25.1

