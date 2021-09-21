Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6AE41373C
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbhIUQSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234416AbhIUQS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:18:26 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D049C061756;
        Tue, 21 Sep 2021 09:16:57 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id u27so4133598edi.9;
        Tue, 21 Sep 2021 09:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hq6EJ6+PaDYa/zKF18KShOfqfhtkH5ip+hcAHx5j5P0=;
        b=kpZn5ZdOFnExjoFSxQwegqyMLBa+XUJ3np4fFOAPU3mhUu3yz45SekJrjsxZn/6dIB
         5/97WyzG83cNN4CddS07lUcXwoMne89HGM3YInEqGep7iG/7Ks72hUrm52GFQjqKysmM
         4nAjzDI+ulhpbZ9lA4EeJ1McwjuSCyJPaBHy+ntN4LC/vjiFK746p1KoBL69J9D3Buwo
         jki7jHSVYRs5vNuGfjqqwYqhO4w8XU1IC5FXSCosm+Db8TJuCSX4sST+/be2ruViaZkQ
         HaOWWpYQVcNhQ21FP1G/pHQy3CdKQ+LTaZ6GcKVpEddXMDmWYIyeBRohT33IxGpCT07s
         3sMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hq6EJ6+PaDYa/zKF18KShOfqfhtkH5ip+hcAHx5j5P0=;
        b=7wdAndfsvPzMcRRpCFe/Zu2cIUjZmpR4lb28FHtB+rGSOCik5tm7q7BO+IoTSuO1ls
         kSLkI4BjNGgfMInupjdKP1U6JW/DlYzOkdqMv7LfQjskTdtIRD0dTXT6FiE3WQgkC9lR
         LqOMFW290MvX4TfiWSyWeK135enxOYml7pdTLfB7mUx9FZvqU3RBvdzGvNKdaxfRZhlT
         HEh2KuHqXmWc75/G+ExYT5QPmYRbwKfX3a/GsH1YxhVNFpsg2cnj+sDwgSEwOMORw1H7
         UmbYztAhiDiQD9rQEeo+z7YSnJOUU/RTPguJlt5TKF01d/EjFTKkC39IGIEMJZh5tc/Q
         jfDg==
X-Gm-Message-State: AOAM532eRcZXyhoX9dQ6Pl90bEgx5FHxX4DLtXv2YgnOB4WiFRYTzhDf
        Ar4x8eoIyx/PBWqK+/qcVbY=
X-Google-Smtp-Source: ABdhPJwFXzzsnDS5s7fbNQPE8fG7teKsuuJiIgCbhKI/b/CWLERzk+9Pp1IyR3ot88xcJR/LPFFiHQ==
X-Received: by 2002:a17:906:3699:: with SMTP id a25mr35644117ejc.452.1632240948296;
        Tue, 21 Sep 2021 09:15:48 -0700 (PDT)
Received: from pinky.lan ([2a04:241e:502:1df0:b065:9bdf:4016:277])
        by smtp.gmail.com with ESMTPSA id kx17sm7674075ejc.51.2021.09.21.09.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:15:47 -0700 (PDT)
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
Subject: [PATCH 18/19] tcp: authopt: Add key selection controls
Date:   Tue, 21 Sep 2021 19:15:01 +0300
Message-Id: <c62f2408f12b0e045b1daaedecf612be21550c3e.1632240523.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1632240523.git.cdleonard@gmail.com>
References: <cover.1632240523.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RFC requires that TCP can report the keyid and rnextkeyid values
being sent or received, implement this via getsockopt values.

The RFC also requires that user can select the sending key and that the
sending key is automatically switched based on rnextkeyid. These
requirements can conflict so we implement both and add a flag which
specifies if user or peer request takes priority.

Also add an option to control rnextkeyid explicitly from userspace.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/tcp_authopt.rst | 25 ++++++
 include/net/tcp_authopt.h                | 15 +++-
 include/uapi/linux/tcp.h                 | 31 ++++++++
 net/ipv4/tcp_authopt.c                   | 98 +++++++++++++++++++++++-
 net/ipv4/tcp_ipv4.c                      |  2 +-
 net/ipv6/tcp_ipv6.c                      |  2 +-
 6 files changed, 166 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/tcp_authopt.rst b/Documentation/networking/tcp_authopt.rst
index 484f66f41ad5..cded87a70d05 100644
--- a/Documentation/networking/tcp_authopt.rst
+++ b/Documentation/networking/tcp_authopt.rst
@@ -35,10 +35,35 @@ Keys can be bound to remote addresses in a way that is similar to TCP_MD5.
 
 RFC5925 requires that key ids do not overlap when tcp identifiers (addr/port)
 overlap. This is not enforced by linux, configuring ambiguous keys will result
 in packet drops and lost connections.
 
+Key selection
+-------------
+
+On getsockopt(TCP_AUTHOPT) information is provided about keyid/rnextkeyid in
+the last send packet and about the keyid/rnextkeyd in the last valid received
+packet.
+
+By default the sending keyid is selected to match the "rnextkeyid" value sent
+by the remote side. If that keyid is not available (or for new connections) a
+random matching key is selected.
+
+If the `TCP_AUTHOPT_LOCK_KEYID` is set then the sending key is selected by the
+`tcp_authopt.send_local_id` field and rnextkeyid is ignored. If no key with
+local_id == send_local_id is configured then a random matching key is
+selected.
+
+The current sending key is cached in the socket and will not change unless
+requested by remote rnextkeyid or by setsockopt.
+
+The rnextkeyid value sent on the wire is usually the recv_id of the current
+key used for sending. If the TCP_AUTHOPT_LOCK_RNEXTKEY flag is set in
+`tcp_authopt.flags` the value of `tcp_authopt.send_rnextkeyid` is send
+instead.  This can be used to implement smooth rollover: the peer will switch
+its keyid to the received rnextkeyid when it is available.
+
 ABI Reference
 =============
 
 .. kernel-doc:: include/uapi/linux/tcp.h
    :identifiers: tcp_authopt tcp_authopt_flag tcp_authopt_key tcp_authopt_key_flag tcp_authopt_alg
diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index b012eaaf416f..c7d6a51fa5c5 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -45,11 +45,21 @@ struct tcp_authopt_key_info {
  */
 struct tcp_authopt_info {
 	/** @head: List of tcp_authopt_key_info */
 	struct hlist_head head;
 	struct rcu_head rcu;
+	/**
+	 * @send_keyid - Current key used for sending, cached.
+	 *
+	 * Once a key is found it only changes by user or remote request.
+	 */
+	struct tcp_authopt_key_info *send_key;
 	u32 flags;
+	u8 send_keyid;
+	u8 send_rnextkeyid;
+	u8 recv_keyid;
+	u8 recv_rnextkeyid;
 	u32 src_isn;
 	u32 dst_isn;
 };
 
 #ifdef CONFIG_TCP_AUTHOPT
@@ -63,21 +73,22 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key);
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen);
 struct tcp_authopt_key_info *__tcp_authopt_select_key(
 		const struct sock *sk,
 		struct tcp_authopt_info *info,
 		const struct sock *addr_sk,
-		u8 *rnextkeyid);
+		u8 *rnextkeyid,
+		bool locked);
 static inline struct tcp_authopt_key_info *tcp_authopt_select_key(
 		const struct sock *sk,
 		const struct sock *addr_sk,
 		u8 *rnextkeyid)
 {
 	if (static_branch_unlikely(&tcp_authopt_needed)) {
 		struct tcp_authopt_info *info = rcu_dereference(tcp_sk(sk)->authopt_info);
 
 		if (info)
-			return __tcp_authopt_select_key(sk, info, addr_sk, rnextkeyid);
+			return __tcp_authopt_select_key(sk, info, addr_sk, rnextkeyid, true);
 	}
 	return NULL;
 }
 int tcp_authopt_hash(
 		char *hash_location,
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index c68ecd617774..6357966bada9 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -346,10 +346,24 @@ struct tcp_diag_md5sig {
 
 /**
  * enum tcp_authopt_flag - flags for `tcp_authopt.flags`
  */
 enum tcp_authopt_flag {
+	/**
+	 * @TCP_AUTHOPT_FLAG_LOCK_KEYID: keyid controlled by sockopt
+	 *
+	 * If this is set `tcp_authopt.send_keyid` is used to determined sending
+	 * key. Otherwise a key with send_id == recv_rnextkeyid is preferred.
+	 */
+	TCP_AUTHOPT_FLAG_LOCK_KEYID = (1 << 0),
+	/**
+	 * @TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID: Override rnextkeyid from userspace
+	 *
+	 * If this is set then `tcp_authopt.send_rnextkeyid` is sent on outbound
+	 * packets. Other the recv_id of the current sending key is sent.
+	 */
+	TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID = (1 << 1),
 	/**
 	 * @TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED:
 	 *	Configure behavior of segments with TCP-AO coming from hosts for which no
 	 *	key is configured. The default recommended by RFC is to silently accept
 	 *	such connections.
@@ -361,10 +375,27 @@ enum tcp_authopt_flag {
  * struct tcp_authopt - Per-socket options related to TCP Authentication Option
  */
 struct tcp_authopt {
 	/** @flags: Combination of &enum tcp_authopt_flag */
 	__u32	flags;
+	/**
+	 * @send_keyid: `tcp_authopt_key.send_id` of preferred send key
+	 *
+	 * This is only used if `TCP_AUTHOPT_FLAG_LOCK_KEYID` is set.
+	 */
+	__u8	send_keyid;
+	/**
+	 * @send_rnextkeyid: The rnextkeyid to send in packets
+	 *
+	 * This is controlled by the user iff TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID is
+	 * set. Otherwise rnextkeyid is the recv_id of the current key.
+	 */
+	__u8	send_rnextkeyid;
+	/** @recv_keyid: A recently-received keyid value. Only for getsockopt. */
+	__u8	recv_keyid;
+	/** @recv_rnextkeyid: A recently-received rnextkeyid value. Only for getsockopt. */
+	__u8	recv_rnextkeyid;
 };
 
 /**
  * enum tcp_authopt_key_flag - flags for `tcp_authopt.flags`
  *
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 756182401a3b..550ca6bec1ec 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -289,18 +289,75 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct tcp_authopt_i
  * addr_sk is the sock used for comparing daddr, it is only different from sk in
  * the synack case.
  *
  * Result is protected by RCU and can't be stored, it may only be passed to
  * tcp_authopt_hash and only under a single rcu_read_lock.
+ *
+ * If locked is false then we're not holding the socket lock. This happens for
+ * some timewait and reset cases.
  */
 struct tcp_authopt_key_info *__tcp_authopt_select_key(
 		const struct sock *sk,
 		struct tcp_authopt_info *info,
 		const struct sock *addr_sk,
-		u8 *rnextkeyid)
+		u8 *rnextkeyid,
+		bool locked)
 {
-	return tcp_authopt_lookup_send(info, addr_sk, -1);
+	struct tcp_authopt_key_info *key, *new_key = NULL;
+
+	/* Listen sockets don't refer to any specific connection so we don't try
+	 * to keep using the same key and ignore any received keyids.
+	 */
+	if (sk->sk_state == TCP_LISTEN) {
+		int send_keyid = -1;
+		if (info->flags & TCP_AUTHOPT_FLAG_LOCK_KEYID)
+			send_keyid = info->send_keyid;
+		key = tcp_authopt_lookup_send(info, addr_sk, send_keyid);
+		if (key)
+			*rnextkeyid = key->recv_id;
+
+		return key;
+	}
+
+	if (locked)
+		key = rcu_dereference_protected(info->send_key, lockdep_sock_is_held(sk));
+	else
+		key = rcu_dereference(info->send_key);
+
+	/* Try to keep the same sending key unless user or peer requires a different key
+	 * User request (via TCP_AUTHOPT_FLAG_LOCK_KEYID) always overrides peer request.
+	 */
+	if (info->flags & TCP_AUTHOPT_FLAG_LOCK_KEYID) {
+		int send_keyid = info->send_keyid;
+
+		if (!key || key->send_id != send_keyid)
+			new_key = tcp_authopt_lookup_send(info, addr_sk, send_keyid);
+	} else {
+		if (!key || key->send_id != info->recv_rnextkeyid)
+			new_key = tcp_authopt_lookup_send(info, addr_sk, info->recv_rnextkeyid);
+	}
+	/* If no key found with specific send_id try anything else. */
+	if (!key && !new_key)
+		new_key = tcp_authopt_lookup_send(info, addr_sk, -1);
+
+	/* Update current key only if we hold the socket lock, otherwise we might
+	 * store a pointer that goes stale
+	 */
+	if (new_key && key != new_key) {
+		key = new_key;
+		if (locked)
+			rcu_assign_pointer(info->send_key, key);
+	}
+
+	if (key) {
+		if (info->flags & TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID)
+			*rnextkeyid = info->send_rnextkeyid;
+		else
+			*rnextkeyid = info->send_rnextkeyid = key->recv_id;
+	}
+
+	return key;
 }
 
 static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -322,10 +379,12 @@ static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk
 
 	return info;
 }
 
 #define TCP_AUTHOPT_KNOWN_FLAGS ( \
+	TCP_AUTHOPT_FLAG_LOCK_KEYID | \
+	TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID | \
 	TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED)
 
 /* Like copy_from_sockopt except tolerate different optlen for compatibility reasons
  *
  * If the src is shorter then it's from an old userspace and the rest of dst is
@@ -381,18 +440,23 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	info = __tcp_authopt_info_get_or_create(sk);
 	if (IS_ERR(info))
 		return PTR_ERR(info);
 
 	info->flags = opt.flags & TCP_AUTHOPT_KNOWN_FLAGS;
+	if (opt.flags & TCP_AUTHOPT_FLAG_LOCK_KEYID)
+		info->send_keyid = opt.send_keyid;
+	if (opt.flags & TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID)
+		info->send_rnextkeyid = opt.send_rnextkeyid;
 
 	return 0;
 }
 
 int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_authopt_info *info;
+	struct tcp_authopt_key_info *send_key;
 
 	sock_owned_by_me(sk);
 	if (!sysctl_tcp_authopt)
 		return -EPERM;
 
@@ -400,10 +464,21 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
 	if (!info)
 		return -ENOENT;
 
 	opt->flags = info->flags & TCP_AUTHOPT_KNOWN_FLAGS;
+	/* These keyids might be undefined, for example before connect.
+	 * Reporting zero is not strictly correct because there are no reserved
+	 * values.
+	 */
+	if ((send_key = rcu_dereference_check(info->send_key, lockdep_sock_is_held(sk))))
+		opt->send_keyid = send_key->send_id;
+	else
+		opt->send_keyid = 0;
+	opt->send_rnextkeyid = info->send_rnextkeyid;
+	opt->recv_keyid = info->recv_keyid;
+	opt->recv_rnextkeyid = info->recv_rnextkeyid;
 
 	return 0;
 }
 
 /* Free key nicely, for living sockets */
@@ -411,10 +486,12 @@ static void tcp_authopt_key_del(struct sock *sk,
 				struct tcp_authopt_info *info,
 				struct tcp_authopt_key_info *key)
 {
 	sock_owned_by_me(sk);
 	hlist_del_rcu(&key->node);
+	if (rcu_dereference_protected(info->send_key, lockdep_sock_is_held(sk)) == key)
+		rcu_assign_pointer(info->send_key, NULL);
 	atomic_sub(sizeof(*key), &sk->sk_omem_alloc);
 	kfree_rcu(key, rcu);
 }
 
 /* Free info and keys.
@@ -1332,11 +1409,11 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
 			net_info_ratelimited("TCP Authentication Unexpected: Rejected\n");
 			return -EINVAL;
 		} else {
 			net_info_ratelimited("TCP Authentication Unexpected: Accepted\n");
-			return 0;
+			goto accept;
 		}
 	}
 
 	/* bad inbound key len */
 	if (TCPOLEN_AUTHOPT_OUTPUT != opt->len)
@@ -1350,9 +1427,24 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
 		net_info_ratelimited("TCP Authentication Failed\n");
 		return -EINVAL;
 	}
 
+accept:
+	/* Doing this for all valid packets will results in keyids temporarily
+	 * flipping back and forth if packets are reordered or retransmitted
+	 * but keys should eventually stabilize.
+	 *
+	 * This is connection-specific so don't store for listen sockets.
+	 *
+	 * We could store rnextkeyid from SYN in a request sock and use it for
+	 * the SYNACK but we don't.
+	 */
+	if (sk->sk_state != TCP_LISTEN) {
+		info->recv_keyid = opt->keyid;
+		info->recv_rnextkeyid = opt->rnextkeyid;
+	}
+
 	return 1;
 }
 /* only for CONFIG_IPV6=m */
 EXPORT_SYMBOL(__tcp_authopt_inbound_check);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 2d5fbe7690aa..6b44bf0ca053 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -661,11 +661,11 @@ static int tcp_v4_authopt_handle_reply(
 		info = tcp_twsk(sk)->tw_authopt_info;
 	else
 		info = tcp_sk(sk)->authopt_info;
 	if (!info)
 		return 0;
-	key_info = __tcp_authopt_select_key(sk, info, sk, &rnextkeyid);
+	key_info = __tcp_authopt_select_key(sk, info, sk, &rnextkeyid, false);
 	if (!key_info)
 		return 0;
 	*optptr = htonl((TCPOPT_AUTHOPT << 24) |
 			(TCPOLEN_AUTHOPT_OUTPUT << 16) |
 			(key_info->send_id << 8) |
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index d922219af20e..3dcf0ba4a215 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -914,11 +914,11 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 			authopt_info = tcp_twsk(sk)->tw_authopt_info;
 		else
 			authopt_info = rcu_dereference(tcp_sk(sk)->authopt_info);
 
 		if (authopt_info) {
-			authopt_key_info = __tcp_authopt_select_key(sk, authopt_info, sk, &authopt_rnextkeyid);
+			authopt_key_info = __tcp_authopt_select_key(sk, authopt_info, sk, &authopt_rnextkeyid, false);
 			if (authopt_key_info) {
 				tot_len += TCPOLEN_AUTHOPT_OUTPUT;
 				/* Don't use MD5 */
 				key = NULL;
 			}
-- 
2.25.1

