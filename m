Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691E75ACC57
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237492AbiIEHJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237242AbiIEHHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:07:21 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64283F30B;
        Mon,  5 Sep 2022 00:06:55 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id t5so10046675edc.11;
        Mon, 05 Sep 2022 00:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=zwKc0hZ/RS5ediE0iHZCUgdJkXpSnKaQNGWUmrVNhXI=;
        b=gZcLC4d0E6HMZFnzGb07F8Mz7kFKUl4ZYUZvE/r3l/CPBU5QRyjukD/6TkZYdjdHvW
         gtVoUk8lH3YJvUp3iSa+6WJuWx0Df5A3e4+66YuMbC019t4pEtJy3fkFDSihlj0vDreU
         LQnuZO5n9sDr1EK/PctJ5/BS0/Cu4aaQkNES55X9EyjW1RYXHdWfEibaym743AB4EB9Y
         9UE1IlaogyTnOVfl+1+NXNk23xFeP8QxybMQ8SpsKF/s6xhvLTmw3KBV8YeBjptZct+C
         11N7TcXVXVU8XoHBchSBXyOeTU6K5NXKFpbGMaYMeddVYHw4UNCZhw9kEbT/6UeDjp6u
         K0aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=zwKc0hZ/RS5ediE0iHZCUgdJkXpSnKaQNGWUmrVNhXI=;
        b=5oWxPGOTlIYFwidjEyGuocNH9zpjVTMQU5Owi4OxNp1AuTcJVl5j5OeBGeIPQ3A0DQ
         Fv/eiQXkL3YFOZwSe+5eftdQODKSio2vpfzhoaq26Jf5xCTz2t3YWLREqDWT4jVFQgh3
         jd5YLkm07g1xG/dMtDGE9qY3mVd3uxwdJOJLyamWqkh0A9y/d1jT5Q1HSj9X5Wh8FwO0
         pZRMIfm906Q8B1pocaSXuMc3dTA/33upd4E2AoUSSBx/aa+B+bAmoFgenCyqxjJo9kL/
         JkGW0pud+4N09u2nixUG/T4mVt0G0ouL/rHTGblT8O02tjYXQ7qf1SmQs5aqt7CDpc6B
         MRIg==
X-Gm-Message-State: ACgBeo3Rk/19p6/hkYD9f2hObK14RDxB0hXO0MQThzDdhtVDOlHCL9qK
        7IaNqoolGNnZmU1HoLOIAVU=
X-Google-Smtp-Source: AA6agR4E9bmp1vgEb0NUKl/K/f79iVfIaOK5XUGy/nHkqeK7PcABgFW40rRGdUHx6ELi7Sopf0daZw==
X-Received: by 2002:a05:6402:3203:b0:435:5a48:daa9 with SMTP id g3-20020a056402320300b004355a48daa9mr32316461eda.304.1662361614425;
        Mon, 05 Sep 2022 00:06:54 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:40ec:9f50:387:3cfb])
        by smtp.gmail.com with ESMTPSA id n27-20020a056402515b00b0043cf2e0ce1csm5882775edd.48.2022.09.05.00.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 00:06:53 -0700 (PDT)
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
Subject: [PATCH v8 22/26] tcp: authopt: Initial support for TCP_AUTHOPT_FLAG_ACTIVE
Date:   Mon,  5 Sep 2022 10:05:58 +0300
Message-Id: <58d2b2a3083364024e8f105d79be21923f945bb6.1662361354.git.cdleonard@gmail.com>
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
index 4c3b1aef9976..ff8b53f4209d 100644
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
index a141439d9ebe..b4158b430b79 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -617,15 +617,23 @@ static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk
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
@@ -690,11 +698,11 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 
 	info = __tcp_authopt_info_get_or_create(sk);
 	if (IS_ERR(info))
 		return PTR_ERR(info);
 
-	info->flags = opt.flags & TCP_AUTHOPT_KNOWN_FLAGS;
+	info->flags = opt.flags & TCP_AUTHOPT_USER_FLAGS;
 	if (opt.flags & TCP_AUTHOPT_FLAG_LOCK_KEYID)
 		info->user_pref_send_keyid = opt.send_keyid;
 	if (opt.flags & TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID)
 		info->send_rnextkeyid = opt.send_rnextkeyid;
 
@@ -703,10 +711,11 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 
 int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_authopt_info *info;
+	bool anykey = false;
 	int err;
 
 	memset(opt, 0, sizeof(*opt));
 	sock_owned_by_me(sk);
 	err = check_sysctl_tcp_authopt();
@@ -715,11 +724,18 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 
 	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
 	if (!info)
 		return -ENOENT;
 
-	opt->flags = info->flags & TCP_AUTHOPT_KNOWN_FLAGS;
+	opt->flags = info->flags & TCP_AUTHOPT_USER_FLAGS;
+
+	rcu_read_lock();
+	tcp_authopt_lookup_send(sock_net_tcp_authopt(sk), sk, -1, NULL, &anykey);
+	if (anykey)
+		opt->flags |= TCP_AUTHOPT_FLAG_ACTIVE;
+	rcu_read_unlock();
+
 	/* These keyids might be undefined, for example before connect.
 	 * Reporting zero is not strictly correct because there are no reserved
 	 * values.
 	 */
 	opt->send_keyid = info->send_keyid;
-- 
2.25.1

