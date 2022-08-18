Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8997598D28
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345661AbiHRUAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345494AbiHRUAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:00:34 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3C7D11CF;
        Thu, 18 Aug 2022 13:00:33 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b16so3208105edd.4;
        Thu, 18 Aug 2022 13:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=9+tjht34D1dlDj0OddUS2R2tL5a9PSfhOIZtSRRjUmM=;
        b=ELG95gd7G6ZaYTjtrhjPCa/Oq+V9x2JkI7cajsnimepCHr0NSQIgxotbL1ZNsOBhfP
         Obac/HElACsaKnTLmwGgWKY+tiqvMW5eFVc04EmfD4TtSvb8PL9yJqZ3TVwuX6vYNfXs
         ESmbJ3CA2zzYlfAmzWC8+8DQyUEFphuHcp2ajGsTRXXKmoP56wLWo/P2bY5wEq7BMyry
         HteB+pe/ZjZMghF1dRp/TAW6xs1KudRFKSkhZtyMnQLYYnqXNeP6NiWOxnPUMb/7AJJe
         /iY/ZqXjCS4pihCCFUzM4dqIGgQ3bGsxb09NCD5upxz3eg6FyXRzEwIy/h0cDzezhFKh
         sGDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=9+tjht34D1dlDj0OddUS2R2tL5a9PSfhOIZtSRRjUmM=;
        b=a4Lc1r1MbrN08h4FUjNCoDFX4pWDrzUi1V8Z+PjD1EjPz4Gdz0iEOCmL8Gy091Xlo3
         piKAJc9vDphsf+t1beaYX8DLPAE+GjheA8oHYRt5GpvHfdhAS675A/Bz8NiBP0lMC/9d
         2A3DEZv55VR9UxsJF+5czH5qD86WC/U5opOAIuDgLwaGYR3A5bCOKI5kp+oulQIcsSEp
         ZpMDejFgcQFF02g0IXkRigvRlm4V6ZTJUAhI9aq25OTtkAPVVhYqp/T6XQAWLErTq9y9
         qCruq3i+1VIXeK21X5/HB9B9XR6+er1xHOyho9DfUFtfi/Qyrt2/HW0Q/z/I0ozwgM2+
         pF5w==
X-Gm-Message-State: ACgBeo3yPnwmwwWuhHPgB42Yej/YG74bpugOv8ijget4p8NebtNog2aC
        qFVsQiswx+TrMGwItQSLROqsQptoLxs=
X-Google-Smtp-Source: AA6agR62/JxiiT5oWYVCKQNZl7LBh+4w+pL3qoaJi9vm0oCo422DAOOJA/KSfhBjxFwCG8dScIirag==
X-Received: by 2002:a05:6402:2691:b0:43d:ba10:854b with SMTP id w17-20020a056402269100b0043dba10854bmr3375892edd.158.1660852831602;
        Thu, 18 Aug 2022 13:00:31 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:00:31 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 08/26] tcp: authopt: Disable via sysctl by default
Date:   Thu, 18 Aug 2022 22:59:42 +0300
Message-Id: <8f9a90263b025f586cc31fba09d7cd9c9d58b2e5.1660852705.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660852705.git.cdleonard@gmail.com>
References: <cover.1660852705.git.cdleonard@gmail.com>
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
index 56cd4ea059b2..234d0a4217f6 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1035,10 +1035,16 @@ tcp_limit_output_bytes - INTEGER
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
index 9215a8377e4d..c470fce52f78 100644
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
@@ -441,17 +446,30 @@ static int _copy_from_sockptr_tolerant(u8 *dst,
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
 
@@ -469,13 +487,17 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 
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
 
@@ -497,10 +519,13 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
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

