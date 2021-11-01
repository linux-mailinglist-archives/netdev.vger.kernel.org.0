Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1881F441E64
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbhKAQiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbhKAQiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:18 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2E3C061764;
        Mon,  1 Nov 2021 09:35:44 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id z20so66625584edc.13;
        Mon, 01 Nov 2021 09:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RmHVS7Eq+vaOp7+GRIKxaKy7LMv75f9ozhcptpjvtP4=;
        b=dKioVMCXODRAcb+mi+Bd17gh15NZDEDUki8dML12N/971Z3kAYG+jzqSfzYPeVQUYW
         h7tUXtW7A5f9cGm6ULZdgEE8WmdJhCi1+QX8ZzMwfYCGn80OC4SNEcU45aYonS1xB8b9
         sa9d6vhKYL3rWXWh7HYTH0YOSSWUchDEWsMXPEjY/vMLer4CqQXwuFBJdH9mtdj9HANl
         HfyZyo1472EqrJ9Qw+1vb5Qp9Lc2UAlkyeHLDcCAq57uOqHaKiJoWDlzIsXNIDUQH2vU
         /zv98UfloGVRzJV70e7KYJu6C4Ex/CcpoTeX5os1V8mIzolY96fSF3GkbV/TIQtOMvnU
         wEFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RmHVS7Eq+vaOp7+GRIKxaKy7LMv75f9ozhcptpjvtP4=;
        b=Phw/UWPlv/mMtoQOzA5BOdlFkWylc/JsHfRIuyBu4+q7HWGTJAq4FwPcIPHNoGLqDX
         Httdq6Z0EN9gyX0YWA+ypYQwLrePZ2BMNLHhX9UwJJLOtDJHVEkiREGj8ayWuNoC6Svj
         ZkORbm2OveGXZxaxkPEI9bL1iVeJN56UEUoAnuUpVfUGFIRexf8VBQmC4BCuuNd/4Spo
         8wP0LI7sqjo6wkvDU2FFvpFmjvMxuBo5q+qD5zw5t8JZCOemMDifEcJgDrE/tjDoU5jg
         PqBlMg+sph+Dyxv2jcp4YaGYgfzZrGAbWchtFvGcVRIm841LU2ZUeK1SH7uMmYJd98wx
         MKZw==
X-Gm-Message-State: AOAM532OT0lvsfXk37L2X7zT4mgpgr7ToVGyvrnWKAYvtWduZRGkMQ1f
        90jzUXwWTNbIh22hPu5nNSs=
X-Google-Smtp-Source: ABdhPJydlcqjMqxzyKzb+8AGYTQcGqBapguFfb1WTzt4tv1N+I0c7RtJi6ffd80fGNHwv9fZc4alyw==
X-Received: by 2002:a17:906:660b:: with SMTP id b11mr37836198ejp.427.1635784543415;
        Mon, 01 Nov 2021 09:35:43 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:35:42 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/25] tcp: authopt: Disable via sysctl by default
Date:   Mon,  1 Nov 2021 18:34:44 +0200
Message-Id: <137399b962131c278acbfa5446a3b6d59aa0547b.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is mainly intended to protect against local privilege escalations
through a rarely used feature so it is deliberately not namespaced.

Enforcement is only at the setsockopt level, this should be enough to
ensure that the tcp_authopt_needed static key never turns on.

No effort is made to handle disabling when the feature is already in
use.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/ip-sysctl.rst |  6 ++++++
 include/net/tcp_authopt.h              |  1 +
 net/ipv4/sysctl_net_ipv4.c             | 10 ++++++++++
 net/ipv4/tcp_authopt.c                 | 13 ++++++++++++-
 4 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 16b8bf72feaf..3f00681f73d7 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -987,10 +987,16 @@ tcp_limit_output_bytes - INTEGER
 tcp_challenge_ack_limit - INTEGER
 	Limits number of Challenge ACK sent per second, as recommended
 	in RFC 5961 (Improving TCP's Robustness to Blind In-Window Attacks)
 	Default: 1000
 
+tcp_authopt - BOOLEAN
+	Enable the TCP Authentication Option (RFC5925), a replacement for TCP
+	MD5 Signatures (RFC2835).
+
+	Default: 0
+
 UDP variables
 =============
 
 udp_l3mdev_accept - BOOLEAN
 	Enabling this option allows a "global" bound socket to work
diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 8bb76128ed11..a505db1dd67b 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -65,10 +65,11 @@ struct tcp_authopt_info {
 	/** @dst_isn: Remote Initial Sequence Number */
 	u32 dst_isn;
 };
 
 #ifdef CONFIG_TCP_AUTHOPT
+extern int sysctl_tcp_authopt;
 DECLARE_STATIC_KEY_FALSE(tcp_authopt_needed);
 
 void tcp_authopt_free(struct sock *sk, struct tcp_authopt_info *info);
 void tcp_authopt_clear(struct sock *sk);
 int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 97eb54774924..cc34de6e4817 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -17,10 +17,11 @@
 #include <net/udp.h>
 #include <net/cipso_ipv4.h>
 #include <net/ping.h>
 #include <net/protocol.h>
 #include <net/netevent.h>
+#include <net/tcp_authopt.h>
 
 static int two = 2;
 static int three __maybe_unused = 3;
 static int four = 4;
 static int thousand = 1000;
@@ -583,10 +584,19 @@ static struct ctl_table ipv4_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_douintvec_minmax,
 		.extra1		= &sysctl_fib_sync_mem_min,
 		.extra2		= &sysctl_fib_sync_mem_max,
 	},
+#ifdef CONFIG_TCP_AUTHOPT
+	{
+		.procname	= "tcp_authopt",
+		.data		= &sysctl_tcp_authopt,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
 	{ }
 };
 
 static struct ctl_table ipv4_net_table[] = {
 	{
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 5e80e5e5e36e..7c49dcce7d24 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -3,10 +3,15 @@
 #include <linux/kernel.h>
 #include <net/tcp.h>
 #include <net/tcp_authopt.h>
 #include <crypto/hash.h>
 
+/* This is mainly intended to protect against local privilege escalations through
+ * a rarely used feature so it is deliberately not namespaced.
+ */
+int sysctl_tcp_authopt;
+
 /* This is enabled when first struct tcp_authopt_info is allocated and never released */
 DEFINE_STATIC_KEY_FALSE(tcp_authopt_needed);
 EXPORT_SYMBOL(tcp_authopt_needed);
 
 /* All current algorithms have a mac length of 12 but crypto API digestsize can be larger */
@@ -360,10 +365,12 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	struct tcp_authopt opt;
 	struct tcp_authopt_info *info;
 	int err;
 
 	sock_owned_by_me(sk);
+	if (!sysctl_tcp_authopt)
+		return -EPERM;
 
 	err = _copy_from_sockptr_tolerant((u8 *)&opt, sizeof(opt), optval, optlen);
 	if (err)
 		return err;
 
@@ -382,13 +389,15 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_authopt_info *info;
 
+	memset(opt, 0, sizeof(*opt));
 	sock_owned_by_me(sk);
+	if (!sysctl_tcp_authopt)
+		return -EPERM;
 
-	memset(opt, 0, sizeof(*opt));
 	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
 	if (!info)
 		return -ENOENT;
 
 	opt->flags = info->flags & TCP_AUTHOPT_KNOWN_FLAGS;
@@ -451,10 +460,12 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	struct tcp_authopt_key_info *key_info, *old_key_info;
 	struct tcp_authopt_alg_imp *alg;
 	int err;
 
 	sock_owned_by_me(sk);
+	if (!sysctl_tcp_authopt)
+		return -EPERM;
 
 	err = _copy_from_sockptr_tolerant((u8 *)&opt, sizeof(opt), optval, optlen);
 	if (err)
 		return err;
 
-- 
2.25.1

