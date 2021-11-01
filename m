Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A51D441E97
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhKAQj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233043AbhKAQig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:36 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5629C06120E;
        Mon,  1 Nov 2021 09:36:02 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id f8so44726902edy.4;
        Mon, 01 Nov 2021 09:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QeygJsk0YuSCRY6UPIohlTYGoBePHWMopfgrHqugwK8=;
        b=OGUzgYI01hRpoVvzy78m4yFrsiMqQ5VZszkAQRUTV1MnWLcgGxzSRWwRklUGUxyEHG
         r4b5uN3dXyBGQ/We18eLl4CguKWqgs8Ae3k+DK5zuf5K2c12GfspFj7i7GGM7obGT3qW
         xF1O8r4TUNks1W1V1O8O0itbUFSXd9cj8SkGW1TPRYsmq8Jf1wU2LXLifFN8/FH6AbYO
         RJ0cCaPoiY1Y/jorq8v9wtSjcaxjawPHJoSTj/VFIBZ8MVbowWR5Irtlo2F9NFWXXow0
         loSjzkBazwiH3umN8nDEbfDeKetJNRRMuDVHu3oNFK4nqkR8Vlh2CnvpT+WTl9+l24Hq
         gQng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QeygJsk0YuSCRY6UPIohlTYGoBePHWMopfgrHqugwK8=;
        b=FikzYxbsgz/VhvnvSEVtIw8tlTC+dQdR8cfaCKnDlKlrPai4qyXHqVNwOR1SbgFAsS
         dmA2fvwljhoufEJCIrS+KiQeWlt4oQKqE6u5XVlDwt/WEFeEg7oVCvJfnnwvTkkM+pO0
         OfLcuA8S3DYy82osAHlszi+X3PLClIholC3BvvCbEfOysWwjcVXwsN93QG12seyaz2Pc
         ne9xRPwXPTJyUQ1Bus+4UJXQHobVTbEyuC+uQ7ZPxzTr7oPPn5t4kepIt83gXTVe2Rcy
         h6WPHuFSBdK5ptnkYKikoUGwpEdxcWoO+BLEsko2iQKLiGVQZYv/iY6r2zv3K3KVI6ac
         Lu4g==
X-Gm-Message-State: AOAM532MZmsSdL6CyW4C0Y5q6xDZpr0JIanC9HjcNaTjhEgPKUFXZoIj
        OwOJwOukXSR2LtKPELHnwvxl7Tjr/F+dopFQ
X-Google-Smtp-Source: ABdhPJy93Wp6HMAXes+RtXmMBtKQx+E4HaMcPgkTWQJOI2z9FhjMa5aQbG7ZYmk3A16qlOqwfTeZDw==
X-Received: by 2002:a50:9d8e:: with SMTP id w14mr42286094ede.74.1635784561355;
        Mon, 01 Nov 2021 09:36:01 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:36:00 -0700 (PDT)
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
Subject: [PATCH v2 19/25] tcp: authopt: Add key selection controls
Date:   Mon,  1 Nov 2021 18:34:54 +0200
Message-Id: <2dc569c0d60c80c26aafcaa201ba5b5ec53ce6bd.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
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
 include/net/tcp_authopt.h                | 38 ++++++++-
 include/uapi/linux/tcp.h                 | 31 ++++++++
 net/ipv4/tcp_authopt.c                   | 98 +++++++++++++++++++++++-
 net/ipv4/tcp_ipv4.c                      |  2 +-
 net/ipv6/tcp_ipv6.c                      |  3 +-
 6 files changed, 190 insertions(+), 7 deletions(-)

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
index ae7d6a1eab8d..9341e10ef542 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -66,10 +66,43 @@ struct tcp_authopt_info {
 	u32 dst_isn;
 	/** @rcv_sne: Recv-side Sequence Number Extension tracking tcp_sock.rcv_nxt */
 	u32 rcv_sne;
 	/** @snd_sne: Send-side Sequence Number Extension tracking tcp_sock.snd_nxt */
 	u32 snd_sne;
+
+	/**
+	 * @send_keyid: keyid currently being sent
+	 *
+	 * This is controlled by userspace by userspace if
+	 * TCP_AUTHOPT_FLAG_LOCK_KEYID, otherwise we try to match recv_rnextkeyid
+	 */
+	u8 send_keyid;
+	/**
+	 * @send_rnextkeyid: rnextkeyid currently being sent
+	 *
+	 * This is controlled by userspace if TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID is set
+	 */
+	u8 send_rnextkeyid;
+	/**
+	 * @recv_keyid: last keyid received from remote
+	 *
+	 * This is reported to userspace but has no other special behavior attached.
+	 */
+	u8 recv_keyid;
+	/**
+	 * @recv_rnextkeyid: last rnextkeyid received from remote
+	 *
+	 * Linux tries to honor this unless TCP_AUTHOPT_FLAG_LOCK_KEYID is set
+	 */
+	u8 recv_rnextkeyid;
+
+	/**
+	 * @send_key: Current key used for sending, cached.
+	 *
+	 * Once a key is found it only changes by user or remote request.
+	 */
+	struct tcp_authopt_key_info *send_key;
 };
 
 #ifdef CONFIG_TCP_AUTHOPT
 extern int sysctl_tcp_authopt;
 DECLARE_STATIC_KEY_FALSE(tcp_authopt_needed);
@@ -81,22 +114,23 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key);
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
 		struct tcp_authopt_info **info,
 		u8 *rnextkeyid)
 {
 	if (static_branch_unlikely(&tcp_authopt_needed)) {
 		*info = rcu_dereference(tcp_sk(sk)->authopt_info);
 
 		if (*info)
-			return __tcp_authopt_select_key(sk, *info, addr_sk, rnextkeyid);
+			return __tcp_authopt_select_key(sk, *info, addr_sk, rnextkeyid, true);
 	}
 	return NULL;
 }
 int tcp_authopt_hash(
 		char *hash_location,
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 76d7be6b27f4..e02176390519 100644
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
index aef63e35b56f..a02fe0d14b63 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -285,20 +285,76 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct tcp_authopt_i
  *
  * @sk: socket
  * @info: socket's tcp_authopt_info
  * @addr_sk: socket used for address lookup. Same as sk except for synack case
  * @rnextkeyid: value of rnextkeyid caller should write in packet
+ * @locked: If we're holding the socket lock. This is false for some timewait and reset cases
  *
  * Result is protected by RCU and can't be stored, it may only be passed to
  * tcp_authopt_hash and only under a single rcu_read_lock.
  */
 struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 						      struct tcp_authopt_info *info,
 						      const struct sock *addr_sk,
-						      u8 *rnextkeyid)
+						      u8 *rnextkeyid,
+						      bool locked)
 {
-	return tcp_authopt_lookup_send(info, addr_sk, -1);
+	struct tcp_authopt_key_info *key, *new_key = NULL;
+
+	/* Listen sockets don't refer to any specific connection so we don't try
+	 * to keep using the same key and ignore any received keyids.
+	 */
+	if (sk->sk_state == TCP_LISTEN) {
+		int send_keyid = -1;
+
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
 EXPORT_SYMBOL(__tcp_authopt_select_key);
 
 static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk)
 {
@@ -321,10 +377,12 @@ static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk
 
 	return info;
 }
 
 #define TCP_AUTHOPT_KNOWN_FLAGS ( \
+	TCP_AUTHOPT_FLAG_LOCK_KEYID | \
+	TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID | \
 	TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED)
 
 /* Like copy_from_sockopt except tolerate different optlen for compatibility reasons
  *
  * If the src is shorter then it's from an old userspace and the rest of dst is
@@ -381,18 +439,23 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
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
 
 	memset(opt, 0, sizeof(*opt));
 	sock_owned_by_me(sk);
 	if (!sysctl_tcp_authopt)
 		return -EPERM;
@@ -400,10 +463,22 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
 	if (!info)
 		return -ENOENT;
 
 	opt->flags = info->flags & TCP_AUTHOPT_KNOWN_FLAGS;
+	/* These keyids might be undefined, for example before connect.
+	 * Reporting zero is not strictly correct because there are no reserved
+	 * values.
+	 */
+	send_key = rcu_dereference_check(info->send_key, lockdep_sock_is_held(sk));
+	if (send_key)
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
@@ -1439,11 +1516,11 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
 			print_tcpao_notice("TCP Authentication Unexpected: Rejected", skb);
 			return -EINVAL;
 		}
 		print_tcpao_notice("TCP Authentication Unexpected: Accepted", skb);
-		return 0;
+		goto accept;
 	}
 
 	/* bad inbound key len */
 	if (opt->len != TCPOLEN_AUTHOPT_OUTPUT)
 		return -EINVAL;
@@ -1456,8 +1533,23 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
 		print_tcpao_notice("TCP Authentication Failed", skb);
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
 EXPORT_SYMBOL(__tcp_authopt_inbound_check);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 21971f5fa40e..2165b95ff7ed 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -664,11 +664,11 @@ static int tcp_v4_authopt_handle_reply(const struct sock *sk,
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
index 68f9545e4347..bb21f11f4246 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -920,11 +920,12 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 		else
 			authopt_info = rcu_dereference(tcp_sk(sk)->authopt_info);
 
 		if (authopt_info) {
 			authopt_key_info = __tcp_authopt_select_key(sk, authopt_info, sk,
-								    &authopt_rnextkeyid);
+								    &authopt_rnextkeyid,
+								    false);
 			if (authopt_key_info) {
 				tot_len += TCPOLEN_AUTHOPT_OUTPUT;
 				/* Don't use MD5 */
 				key = NULL;
 			}
-- 
2.25.1

