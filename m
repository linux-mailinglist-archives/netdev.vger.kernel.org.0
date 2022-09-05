Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB435ACBEF
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237286AbiIEHHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237084AbiIEHGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:06:32 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A423F1F5;
        Mon,  5 Sep 2022 00:06:27 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id nc14so15128368ejc.4;
        Mon, 05 Sep 2022 00:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=9rF3YSJc7bXDmqpfKkrhBZzvU5UvoIG4YushIn8blt4=;
        b=OuTGf9cJ+acYi7RyiguQc11gIw3gipW+7eqdRAGmPZ19BP1+yo0eVx9OwHW44yMCsX
         p1U0IyTbKxfei7fQcndo8HbHF6YU2bwiYBpC88T7ywEMy6TjY1qgyQ1Ji3qdsFe8Ng4g
         SaIMclyjDoOve/hXwgZFGUZNSjfMec32nSWuX1PxlnAec6Cct9qtP3IhcxOmmKwlaeG4
         rzUd8C3afkCIqJgPnuARX+V746yzx2fyU7ncW+d/2pqTMF1f0FAqbvsvFXWaSGimzH5L
         oshgx1CQdCP4S3JIOZskk0I5FC2y/PFCFSeVU93ICCVmybl0LDHJyaSvJRHk5gitTqu7
         Ai4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=9rF3YSJc7bXDmqpfKkrhBZzvU5UvoIG4YushIn8blt4=;
        b=Dg1xVkcH3MDBgeqLCoE9CFe7Jai7P0y8ZORD3ytwuWxAAM9da97bGH9I991MeYUx2x
         H9/I9aUd7Q5bttPpm20rRPDOwYYUsuXoZlFKIlq1y9OihLEx+c7IdyvTFAaLXV7pvKzb
         XESKmahUIbzxQWh/i82qKQgJ/mYCivVRn84iSGYMgLf5RSWJ8Ljvov+z5XieZS3HCQdO
         EwTKlDdVeTFd84+k5qzMagbSNqFCMvqLurYtlDbUrxY7M4ZJQ+xieWdhHbFfIwcTcbLL
         jbaVyuDGBTv5KCQlzkVkAwu5pjukacoatUlJNMI30E8fEeudCpqqE6JTSkifVEhylUb6
         1GTA==
X-Gm-Message-State: ACgBeo0lEqFUPhDkxlcJW1Izu3JPQJAr7OsPfJagCtzS9qTjwq6Ut3ij
        dV275H9sRd1eHHu/CMeitkY=
X-Google-Smtp-Source: AA6agR4xFkV7rEoP/OsXwoLTGKpCbh7LKy816jeN71z5+rgNvr+OL2dtnW1fPEFFGDiP3tUhG3U+LQ==
X-Received: by 2002:a17:907:7d91:b0:731:7ecb:1e5b with SMTP id oz17-20020a1709077d9100b007317ecb1e5bmr34788829ejc.78.1662361586494;
        Mon, 05 Sep 2022 00:06:26 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:40ec:9f50:387:3cfb])
        by smtp.gmail.com with ESMTPSA id n27-20020a056402515b00b0043cf2e0ce1csm5882775edd.48.2022.09.05.00.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 00:06:26 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 08/26] tcp: authopt: Disable via sysctl by default
Date:   Mon,  5 Sep 2022 10:05:44 +0300
Message-Id: <298e4e87ce3a822b4217b309438483959082e6bb.1662361354.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662361354.git.cdleonard@gmail.com>
References: <cover.1662361354.git.cdleonard@gmail.com>
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

This is mainly intended to protect against local privilege escalations
through a rarely used feature so it is deliberately not namespaced.

Enforcement is only at the setsockopt level, this should be enough to
ensure that the tcp_authopt_needed static key never turns on.

No effort is made to handle disabling when the feature is already in
use.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/ip-sysctl.rst |  6 ++++
 include/net/tcp_authopt.h              |  1 +
 net/ipv4/sysctl_net_ipv4.c             | 39 ++++++++++++++++++++++++++
 net/ipv4/tcp_authopt.c                 | 25 +++++++++++++++++
 4 files changed, 71 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index a759872a2883..41be0e69d767 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1038,10 +1038,16 @@ tcp_challenge_ack_limit - INTEGER
 	Note that this per netns rate limit can allow some side channel
 	attacks and probably should not be enabled.
 	TCP stack implements per TCP socket limits anyway.
 	Default: INT_MAX (unlimited)
 
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
index 7ad34a6987ec..1f5020b790dd 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -80,10 +80,11 @@ struct tcphdr_authopt {
 };
 
 #ifdef CONFIG_TCP_AUTHOPT
 DECLARE_STATIC_KEY_FALSE(tcp_authopt_needed_key);
 #define tcp_authopt_needed (static_branch_unlikely(&tcp_authopt_needed_key))
+extern int sysctl_tcp_authopt;
 void tcp_authopt_free(struct sock *sk, struct tcp_authopt_info *info);
 void tcp_authopt_clear(struct sock *sk);
 int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
 int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key);
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 5490c285668b..908a3ef15b47 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -17,10 +17,11 @@
 #include <net/udp.h>
 #include <net/cipso_ipv4.h>
 #include <net/ping.h>
 #include <net/protocol.h>
 #include <net/netevent.h>
+#include <net/tcp_authopt.h>
 
 static int tcp_retr1_max = 255;
 static int ip_local_port_range_min[] = { 1, 1 };
 static int ip_local_port_range_max[] = { 65535, 65535 };
 static int tcp_adv_win_scale_min = -31;
@@ -413,10 +414,37 @@ static int proc_fib_multipath_hash_fields(struct ctl_table *table, int write,
 
 	return ret;
 }
 #endif
 
+#ifdef CONFIG_TCP_AUTHOPT
+static int proc_tcp_authopt(struct ctl_table *ctl,
+			    int write, void *buffer, size_t *lenp,
+			    loff_t *ppos)
+{
+	int val = sysctl_tcp_authopt;
+	struct ctl_table tmp = {
+		.data = &val,
+		.mode = ctl->mode,
+		.maxlen = sizeof(val),
+		.extra1 = SYSCTL_ZERO,
+		.extra2 = SYSCTL_ONE,
+	};
+	int err;
+
+	err = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+	if (err)
+		return err;
+	if (sysctl_tcp_authopt && !val) {
+		net_warn_ratelimited("Enabling TCP Authentication Option is permanent\n");
+		return -EINVAL;
+	}
+	sysctl_tcp_authopt = val;
+	return 0;
+}
+#endif
+
 static struct ctl_table ipv4_table[] = {
 	{
 		.procname	= "tcp_max_orphans",
 		.data		= &sysctl_tcp_max_orphans,
 		.maxlen		= sizeof(int),
@@ -524,10 +552,21 @@ static struct ctl_table ipv4_table[] = {
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
+		.proc_handler	= proc_tcp_authopt,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
 	{ }
 };
 
 static struct ctl_table ipv4_net_table[] = {
 	/* tcp_max_tw_buckets must be first in this table. */
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 4f7cbe1e17f3..9d02da8d6964 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -4,10 +4,15 @@
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <linux/kref.h>
 #include <crypto/hash.h>
 
+/* This is mainly intended to protect against local privilege escalations through
+ * a rarely used feature so it is deliberately not namespaced.
+ */
+int sysctl_tcp_authopt;
+
 /* This is enabled when first struct tcp_authopt_info is allocated and never released */
 DEFINE_STATIC_KEY_FALSE(tcp_authopt_needed_key);
 EXPORT_SYMBOL(tcp_authopt_needed_key);
 
 /* All current algorithms have a mac length of 12 but crypto API digestsize can be larger */
@@ -437,17 +442,30 @@ static int _copy_from_sockptr_tolerant(u8 *dst,
 		memset(dst + srclen, 0, dstlen - srclen);
 
 	return err;
 }
 
+static int check_sysctl_tcp_authopt(void)
+{
+	if (!sysctl_tcp_authopt) {
+		net_warn_ratelimited("TCP Authentication Option disabled by sysctl.\n");
+		return -EPERM;
+	}
+
+	return 0;
+}
+
 int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt opt;
 	struct tcp_authopt_info *info;
 	int err;
 
 	sock_owned_by_me(sk);
+	err = check_sysctl_tcp_authopt();
+	if (err)
+		return err;
 
 	err = _copy_from_sockptr_tolerant((u8 *)&opt, sizeof(opt), optval, optlen);
 	if (err)
 		return err;
 
@@ -465,13 +483,17 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 
 int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_authopt_info *info;
+	int err;
 
 	memset(opt, 0, sizeof(*opt));
 	sock_owned_by_me(sk);
+	err = check_sysctl_tcp_authopt();
+	if (err)
+		return err;
 
 	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
 	if (!info)
 		return -ENOENT;
 
@@ -493,10 +515,13 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
 	struct tcp_authopt_alg_imp *alg;
 	int err;
 
 	sock_owned_by_me(sk);
+	err = check_sysctl_tcp_authopt();
+	if (err)
+		return err;
 	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	err = _copy_from_sockptr_tolerant((u8 *)&opt, sizeof(opt), optval, optlen);
 	if (err)
-- 
2.25.1

