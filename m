Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FD0413736
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbhIUQSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbhIUQS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:18:26 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4EAC061760;
        Tue, 21 Sep 2021 09:16:57 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id bx4so32131111edb.4;
        Tue, 21 Sep 2021 09:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ic4Q2z9XXXj2OTblSwNtRZqZ4IEMjJyoXrA4GL7zeCA=;
        b=oWL309mheTHbFytAapxA7GimvOxrITtZmSXKY0g6wYgGOBZ0YpN2eK5NcT7Iandiyf
         DVltAYHziAlimAEYvQ+iHrct6EhTrZaoTfPccB28eRoANRJVBccrkKtlZ8OxMA35GJsV
         RgofYY1opsT4NynxO7eaDo+IvkUDR80paAQfH7K8SPn7Phc8w9QTGOIkzIXlbxQTC8A4
         KjBxUp7+Zf0+eMpRwYUsilcZkysF1KlkYZRIdJixC7fn3LA/lu/hLa9M1ePB0aXKFboU
         d20sZpEDJr+pfKduZJ4lG3YSax4FYNw1dZcMEZTIXdyAtU5GbCq34DYzRIFIgxXCY1uV
         gVAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ic4Q2z9XXXj2OTblSwNtRZqZ4IEMjJyoXrA4GL7zeCA=;
        b=Zg4z/sAJZRQoNm4FFwhGPZVw49nFoLE0MqIQI2HPhAEMDciDlHtMeP8PJrbEqX68GH
         AmWcMNN8rOli+yc/2xF37hV53FMqmsJe42Z5X1lVW8EBZCGRA1lffKt0VXDEla4cxj/K
         xnT/gFPNVyRsXVroSAZ7iPkJU7HJu6T6VKq01Lem3QD8CRtIYdEF9erKEXQhWbOBjhK+
         wIrCL8YG83TocS5+6kAHb0IRXQa4Q3j/io1Ra3ydUddcZGgOFVtqmroZbYOIUtirbZUs
         W9D1EABmSs1yI8gXFWkT4V0aUb3V6SC+mYlg4QqwflBVGD2Q1E04EtuxG5uK/sjhZFfy
         Aipg==
X-Gm-Message-State: AOAM533EEdsWm2dZL+cY4xMFmB0hNjimqc837Xeu0gHhzGi5F7qCLo2y
        Wa+Ig6wzWM7GiC0zf1RJqgA=
X-Google-Smtp-Source: ABdhPJw908s/5lTgFu9/PFDjVd1Psu2UWOBiFDtUSTZrDHPATaMq0K6b/ff30xqH3fLmdWLuP/KENQ==
X-Received: by 2002:a50:d9c5:: with SMTP id x5mr26365664edj.37.1632240929696;
        Tue, 21 Sep 2021 09:15:29 -0700 (PDT)
Received: from pinky.lan ([2a04:241e:502:1df0:b065:9bdf:4016:277])
        by smtp.gmail.com with ESMTPSA id kx17sm7674075ejc.51.2021.09.21.09.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:15:29 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
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
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/19] tcp: authopt: Disable via sysctl by default
Date:   Tue, 21 Sep 2021 19:14:51 +0300
Message-Id: <b0abf2b789220708011a862a892c37b0fd76dc25.1632240523.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1632240523.git.cdleonard@gmail.com>
References: <cover.1632240523.git.cdleonard@gmail.com>
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
 net/ipv4/tcp_authopt.c                 | 11 +++++++++++
 4 files changed, 28 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index d91ab28718d4..16e34268ecb4 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -995,10 +995,16 @@ tcp_rx_skb_cache - BOOLEAN
 	on systems with a lot of TCP sockets, since it increases
 	memory usage.
 
 	Default: 0 (disabled)
 
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
index 263f98c3a1a8..422f0034d32b 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -51,10 +51,11 @@ struct tcp_authopt_info {
 	u32 src_isn;
 	u32 dst_isn;
 };
 
 #ifdef CONFIG_TCP_AUTHOPT
+extern int sysctl_tcp_authopt;
 DECLARE_STATIC_KEY_FALSE(tcp_authopt_needed);
 
 void tcp_authopt_free(struct sock *sk, struct tcp_authopt_info *info);
 void tcp_authopt_clear(struct sock *sk);
 int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 4680268f2e59..365466fbca8b 100644
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
@@ -595,10 +596,19 @@ static struct ctl_table ipv4_table[] = {
 		.procname	= "tcp_tx_skb_cache",
 		.data		= &tcp_tx_skb_cache_key.key,
 		.mode		= 0644,
 		.proc_handler	= proc_do_static_key,
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
index 0c32b8fb1d41..41f844d5d49a 100644
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
 /* only for CONFIG_IPV6=m */
 EXPORT_SYMBOL(tcp_authopt_needed);
 
@@ -361,10 +366,12 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	struct tcp_authopt opt;
 	struct tcp_authopt_info *info;
 	int err;
 
 	sock_owned_by_me(sk);
+	if (!sysctl_tcp_authopt)
+		return -EPERM;
 
 	err = _copy_from_sockptr_tolerant((u8*)&opt, sizeof(opt), optval, optlen);
 	if (err)
 		return err;
 
@@ -384,10 +391,12 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_authopt_info *info;
 
 	sock_owned_by_me(sk);
+	if (!sysctl_tcp_authopt)
+		return -EPERM;
 
 	memset(opt, 0, sizeof(*opt));
 	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
 	if (!info)
 		return -ENOENT;
@@ -452,10 +461,12 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	struct tcp_authopt_key_info *key_info, *old_key_info;
 	struct tcp_authopt_alg_imp *alg;
 	int err;
 
 	sock_owned_by_me(sk);
+	if (!sysctl_tcp_authopt)
+		return -EPERM;
 
 	err = _copy_from_sockptr_tolerant((u8*)&opt, sizeof(opt), optval, optlen);
 	if (err)
 		return err;
 
-- 
2.25.1

