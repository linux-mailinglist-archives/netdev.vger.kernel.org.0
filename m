Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28A6580B69
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237813AbiGZGT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237847AbiGZGS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:18:26 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC14E2A97B;
        Mon, 25 Jul 2022 23:16:23 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id c72so13619612edf.8;
        Mon, 25 Jul 2022 23:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TgzYWrC/GzzcSOAmciB9ptuiuFME4j1XZrTyvjcnyJY=;
        b=HQdPE3ByzMMswEAtgvo4aPcFTSMjHDrkxEw8zaDhH5I4qUeqv/RytWklRWd50uZJGh
         y1Kakxvc3rhX4zi6Ni45fd1f254sAvupRDJuzm7STxsfoENPQLYgV43FAlvbQs9vGCPZ
         b+4BF0beqTWuTjZoyDONTVwYzI/cszl/hGDuNXiE/6SRQ5BVE+zXjKau5sma3z8Mum+q
         UD2SmNthsXGIJ6nsigDNx7zjMafkWykEIZKAskVf47mOW0wumdHUHMoswXbIuXPkLAro
         Yc0P1zWKlcTU0ezY+swSov/ZLQ3nT4Ob5L0CJgIb7pSrdg5gsOYhVnmzr3fYX36iRr3b
         ZJIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TgzYWrC/GzzcSOAmciB9ptuiuFME4j1XZrTyvjcnyJY=;
        b=bb1m0NKJWqIqYrJTQdGWE4GW9DIFPY7LDRBYcv+j9hDht34YXF+LgXDmR4sxLnK2u/
         jhS7jCEXru8PJqcj3g9kl0KzK3PW6e5RoDTDOuh7hldifZFlpK0mZGT/xbi4BKgkshcn
         blL8FtJUe3ZQQBV8ArIKGpYxCSeue6KGqn+iFmKsd+mEsjhKzXdUvLrN9NqidUQYzakw
         ipAawvKfrmDQOyqBbl1mr5Dn+4uRZrqzowVw5MghNCjI9zkZrYRyh3MkvHbx0HsDkWe8
         yoyILXRBMoVjVmpiLN/ttc0mLG/X7xeWhD6eVURhldcDUfxAKxz/9l/6f/X5ozDdh7Tn
         ThmA==
X-Gm-Message-State: AJIora/ESXbV3LHhCBlfIwqNd34wpQHrH9xXsy9GIdBQjLJWbnMilIdl
        WLiJmqnbsYMEIPBeb0iaECM=
X-Google-Smtp-Source: AGRyM1tS3tW8ryMCQmJ8v6DOBxTFO7bMroJ1N/k2bQkD0oHy+6eEfaQ/a/CV188zUVxpCxVcHGgrJg==
X-Received: by 2002:aa7:d150:0:b0:43c:864c:51fc with SMTP id r16-20020aa7d150000000b0043c864c51fcmr167417edo.138.1658816183608;
        Mon, 25 Jul 2022 23:16:23 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:16:23 -0700 (PDT)
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
Subject: [PATCH v6 24/26] tcp: authopt: Initial support for TCP_AUTHOPT_FLAG_ACTIVE
Date:   Tue, 26 Jul 2022 09:15:26 +0300
Message-Id: <fc5ec8892c41f91fe70eb3035268274d4382c680.1658815925.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1658815925.git.cdleonard@gmail.com>
References: <cover.1658815925.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This can be used to determine if tcp authentication option is actually
active on the current connection.

TCP Authentication can be enabled but inactive on a socket if keys are
only configured for destinations other than the peer.

A listen socket with authentication enabled will return other sockets
with authentication enabled on accept(). If no key is configured for the
peer of an accepted socket then authentication will be inactive.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/uapi/linux/tcp.h | 13 +++++++++++++
 net/ipv4/tcp_authopt.c   | 22 +++++++++++++++++++---
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index b1063e1e1b9f..5ca8aa9d5e43 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -367,10 +367,23 @@ enum tcp_authopt_flag {
 	 *	Configure behavior of segments with TCP-AO coming from hosts for which no
 	 *	key is configured. The default recommended by RFC is to silently accept
 	 *	such connections.
 	 */
 	TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED = (1 << 2),
+	/**
+	 * @TCP_AUTHOPT_FLAG_ACTIVE: If authentication is active for a specific socket.
+	 *
+	 * TCP Authentication can be enabled but inactive on a socket if keys are
+	 * only configured for destinations other than the peer.
+	 *
+	 * A listen socket with authentication enabled will return other sockets
+	 * with authentication enabled on accept(). If no key is configured for the
+	 * peer of an accepted socket then authentication will be inactive.
+	 *
+	 * This flag is readonly and the value is determined at connection establishment time.
+	 */
+	TCP_AUTHOPT_FLAG_ACTIVE = (1 << 3),
 };
 
 /**
  * struct tcp_authopt - Per-socket options related to TCP Authentication Option
  */
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 1fd665c43b5d..e162e5944ec5 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -545,15 +545,23 @@ static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk
 	rcu_assign_pointer(tp->authopt_info, info);
 
 	return info;
 }
 
-#define TCP_AUTHOPT_KNOWN_FLAGS ( \
+/* Flags fully controlled by user: */
+#define TCP_AUTHOPT_USER_FLAGS ( \
 	TCP_AUTHOPT_FLAG_LOCK_KEYID | \
 	TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID | \
 	TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED)
 
+/* All known flags */
+#define TCP_AUTHOPT_KNOWN_FLAGS ( \
+	TCP_AUTHOPT_FLAG_LOCK_KEYID | \
+	TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID | \
+	TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED | \
+	TCP_AUTHOPT_FLAG_ACTIVE)
+
 /* Like copy_from_sockptr except tolerate different optlen for compatibility reasons
  *
  * If the src is shorter then it's from an old userspace and the rest of dst is
  * filled with zeros.
  *
@@ -618,11 +626,11 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 
 	info = __tcp_authopt_info_get_or_create(sk);
 	if (IS_ERR(info))
 		return PTR_ERR(info);
 
-	info->flags = opt.flags & TCP_AUTHOPT_KNOWN_FLAGS;
+	info->flags = opt.flags & TCP_AUTHOPT_USER_FLAGS;
 	if (opt.flags & TCP_AUTHOPT_FLAG_LOCK_KEYID)
 		info->send_keyid = opt.send_keyid;
 	if (opt.flags & TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID)
 		info->send_rnextkeyid = opt.send_rnextkeyid;
 
@@ -632,10 +640,11 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_authopt_info *info;
 	struct tcp_authopt_key_info *send_key;
+	bool anykey = false;
 	int err;
 
 	memset(opt, 0, sizeof(*opt));
 	sock_owned_by_me(sk);
 	err = check_sysctl_tcp_authopt();
@@ -644,11 +653,18 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 
 	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
 	if (!info)
 		return -ENOENT;
 
-	opt->flags = info->flags & TCP_AUTHOPT_KNOWN_FLAGS;
+	opt->flags = info->flags & TCP_AUTHOPT_USER_FLAGS;
+
+	rcu_read_lock();
+	tcp_authopt_lookup_send(sock_net_tcp_authopt(sk), sk, -1, &anykey);
+	if (anykey)
+		opt->flags |= TCP_AUTHOPT_FLAG_ACTIVE;
+	rcu_read_unlock();
+
 	/* These keyids might be undefined, for example before connect.
 	 * Reporting zero is not strictly correct because there are no reserved
 	 * values.
 	 */
 	send_key = rcu_dereference_check(info->send_key, lockdep_sock_is_held(sk));
-- 
2.25.1

