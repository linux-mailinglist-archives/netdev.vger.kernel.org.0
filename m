Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13CB1598D5D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345689AbiHRUFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345577AbiHRUD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:03:27 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D75D21F1;
        Thu, 18 Aug 2022 13:01:01 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b16so3209874edd.4;
        Thu, 18 Aug 2022 13:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Ki8Tb6h/GA93lfWkA9/GxrL5UA6iXNtk3ho9LHUmi7E=;
        b=gMoSTzy1S/qZofk4JIO+AdeVq6YC3CyQNHP5eJ8V9QeAsEllWhWe2uRx9A/yiODdWi
         UmObTGdrkpCcCY8mRB6Ai2C79M9ofanKRhChffFMhOldJtxx4E57XSmcUHu1Ew5FvqZY
         HpjB4jyfWmd4U5iMdAZSzZf0zTh4c3NI4GXU13IXTbD7T17WuSga+sfklRUlnx1cONNG
         +Q8/eLtsIPfO6GmhGdGsWDA/WRKwETT3Jqb7pc7cAwcEOp+BdJmV0FwC+V1kHHQ3dCFl
         jKDkp3JYQNxI3gUDNgEfCayRDqWid3xj/mpLwvQAyNvWtoyANNZgt3ebYvMFNnf9wi7s
         JHjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Ki8Tb6h/GA93lfWkA9/GxrL5UA6iXNtk3ho9LHUmi7E=;
        b=KhKq8x3D4HqhHQCm/HVPg/isY0imv9SX92MrmC4EmXLpIT43oyqjRY73XOZJ8ziBwL
         18UsJcws4efj0kYCtmF4dpJMrETURIVHXSCGb9xdJTlLSNgu/4RgMf69a17Rv6yUtB6r
         5GF60kODYnnsVLzIy4+sz4uG92T7977486PRv4T2RtBlthoIBjlYx8n1RaYLQQrke1FM
         lKkzdCHfaXuTMD5N1tSuA3/+Ynxvdvyeo7R0WnnVLsZTpquG2ixLFdeamy8+dtOddSb3
         5lFcEa4s6mMcP1pWdPLF202IDUHyFTLWsOExJOHOQ8aJBjda5spW6XWCdBnZteGttV6E
         pgSQ==
X-Gm-Message-State: ACgBeo1b4u6EGuhLC3hqi7EOwfIEnnflkl1L6umthvfxKnkTLKPD4pzs
        ECtU34dDDGTYI0zqAoPBGDY=
X-Google-Smtp-Source: AA6agR6vrUflY2f6MFmpTYBK0yXgF9ovbJaMs3S3v8Af+u3UdsHiDVMV4WRHwjOYjMYiglj6Acc05Q==
X-Received: by 2002:aa7:d354:0:b0:43d:7c64:3383 with SMTP id m20-20020aa7d354000000b0043d7c643383mr3506105edr.148.1660852861503;
        Thu, 18 Aug 2022 13:01:01 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:01:01 -0700 (PDT)
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
Subject: [PATCH v7 24/26] tcp: authopt: Initial support for TCP_AUTHOPT_FLAG_ACTIVE
Date:   Thu, 18 Aug 2022 22:59:58 +0300
Message-Id: <90190ecf8d995e662e43da21f33147ffcb4e5ad5.1660852705.git.cdleonard@gmail.com>
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
index 9aa3aea25a97..bbdc5f68ab56 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -554,15 +554,23 @@ static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk
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
@@ -627,11 +635,11 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 
 	info = __tcp_authopt_info_get_or_create(sk);
 	if (IS_ERR(info))
 		return PTR_ERR(info);
 
-	info->flags = opt.flags & TCP_AUTHOPT_KNOWN_FLAGS;
+	info->flags = opt.flags & TCP_AUTHOPT_USER_FLAGS;
 	if (opt.flags & TCP_AUTHOPT_FLAG_LOCK_KEYID)
 		info->send_keyid = opt.send_keyid;
 	if (opt.flags & TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID)
 		info->send_rnextkeyid = opt.send_rnextkeyid;
 
@@ -641,10 +649,11 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
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
@@ -653,11 +662,18 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 
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

