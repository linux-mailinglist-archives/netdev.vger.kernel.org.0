Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2394C3F6B43
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239294AbhHXVhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238497AbhHXVgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:36:37 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D53C06129E;
        Tue, 24 Aug 2021 14:35:52 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id me10so18847624ejb.11;
        Tue, 24 Aug 2021 14:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fle/cTZNggWURF3rB6Z0CqaoPxK7NUDk4k8IoxtpQ5I=;
        b=Zw9EP6Q0NrWos5kbL1Ea/yL0Hj9Qt5SQjSsdM5C+OdhyAwJE32sLDOAa6+faOkg3zg
         sZ1L6vYvVAB2eIlX+v+IdBYW29M2tgFM3/TVwBAS04YCMVKogvTOMPbIlAuvQ1VQtWSf
         iBk9XlxCF1zcJPrgfQxRFbOcCn5sYa+6jxYQGetguu7w6DdJgTx9dAKbC48H5Qg4V3Vf
         33OZwrLIdZgUcjh2+Qm4iPi9DGlKKG/RMXHSy7/kko+dW/ubSVeKt6cFSK1ioo2g5Hyq
         2f65usG6qiaJ1ecuhELjM28+GfJnr1hD5sfAiVraCpSunEe+TYEDdNk6tRERMep96WAy
         uAkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fle/cTZNggWURF3rB6Z0CqaoPxK7NUDk4k8IoxtpQ5I=;
        b=c3iwA+JgD5e9BvH94zwBMOB5sm7hXU0v0tl3FwhVFPLWoZ6SEGETDamd4dgh9e85Tz
         6dOlCGMpAweCVeekCsdRY4O5ermSRBNmF8Tl/Y9GvmnC5BZpg74Zn0w+TxkyCQjWMP7a
         bzUp6WKcjIhFMNp1/UVRziJLahk6b13t8CelU9KvKtMOd+9YFSkAjLmmZyZiSSbdd/hj
         vncW9qbP/aOXibjpGi2avgYg7qkyD6H50VOpzJZ9pPkd+ZlXGAEc1i2uQY9pijome4pn
         D1UG4Gw41AE6cQPJI43NZhi8HPrDJ6yw/dcKBweEAQbQLsnBUJePG4Oq9QbIFLloLMCu
         IhLw==
X-Gm-Message-State: AOAM530SkyKaTB2RvfkU3ekFfauTjX8hqTAMkG+4oVRuWbdnRLDRzOGT
        W0iU0DGTVkzIRFM7NZL4Bs7d3KzDV8CGUNby
X-Google-Smtp-Source: ABdhPJyzcrwsEfNjhQobNuk9Qw5CDuHfEHWru/T8WjKEQBURNjaabdnPiuHl8fYd6TtVg34BfLP8nQ==
X-Received: by 2002:a17:907:2083:: with SMTP id pv3mr14439471ejb.402.1629840950714;
        Tue, 24 Aug 2021 14:35:50 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:ed0a:7326:fbac:b4c])
        by smtp.gmail.com with ESMTPSA id d16sm12348357edu.8.2021.08.24.14.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 14:35:50 -0700 (PDT)
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
Subject: [RFCv3 14/15] tcp: authopt: Add key selection controls
Date:   Wed, 25 Aug 2021 00:34:47 +0300
Message-Id: <36ba357a7f43a883fe6f470a4b65d16a85553e52.1629840814.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1629840814.git.cdleonard@gmail.com>
References: <cover.1629840814.git.cdleonard@gmail.com>
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
 Documentation/networking/tcp_authopt.rst | 25 ++++++++++
 include/net/tcp_authopt.h                | 10 ++++
 include/uapi/linux/tcp.h                 | 31 ++++++++++++
 net/ipv4/tcp_authopt.c                   | 60 +++++++++++++++++++++++-
 4 files changed, 124 insertions(+), 2 deletions(-)

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
index 61db268f36f8..92d0c2333272 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -36,11 +36,21 @@ struct tcp_authopt_key_info {
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
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 575162e7e281..43df8e3cd4cc 100644
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
index 08ca77f01c46..1a80df739fd2 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -255,17 +255,44 @@ struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct tcp_authopt_info *in
  */
 struct tcp_authopt_key_info *tcp_authopt_select_key(const struct sock *sk,
 						    const struct sock *addr_sk,
 						    u8 *rnextkeyid)
 {
+	struct tcp_authopt_key_info *key, *new_key;
 	struct tcp_authopt_info *info;
 
 	info = rcu_dereference(tcp_sk(sk)->authopt_info);
 	if (!info)
 		return NULL;
 
-	return tcp_authopt_lookup_send(info, addr_sk, -1);
+	key = info->send_key;
+	if (info->flags & TCP_AUTHOPT_FLAG_LOCK_KEYID) {
+		int send_keyid = info->send_keyid;
+
+		if (!key || key->send_id != send_keyid)
+			new_key = tcp_authopt_lookup_send(info, addr_sk, send_keyid);
+	} else {
+		if (!key || key->send_id != info->recv_rnextkeyid)
+			new_key = tcp_authopt_lookup_send(info, addr_sk, info->recv_rnextkeyid);
+	}
+	if (!key && !new_key)
+		new_key = tcp_authopt_lookup_send(info, addr_sk, -1);
+
+	// Change current key.
+	if (key != new_key && new_key) {
+		key = new_key;
+		info->send_key = key;
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
@@ -285,10 +312,12 @@ static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk
 
 	return info;
 }
 
 #define TCP_AUTHOPT_KNOWN_FLAGS ( \
+	TCP_AUTHOPT_FLAG_LOCK_KEYID | \
+	TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID | \
 	TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED)
 
 int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt opt;
@@ -309,10 +338,14 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
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
@@ -326,10 +359,21 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
 	if (!info)
 		return -EINVAL;
 
 	opt->flags = info->flags & TCP_AUTHOPT_KNOWN_FLAGS;
+	/* These keyids might be undefined, for example before connect.
+	 * Reporting zero is not strictly correct because there are no reserved
+	 * values.
+	 */
+	if (info->send_key)
+		opt->send_keyid = info->send_key->send_id;
+	else
+		opt->send_keyid = 0;
+	opt->send_rnextkeyid = info->send_rnextkeyid;
+	opt->recv_keyid = info->recv_keyid;
+	opt->recv_rnextkeyid = info->recv_rnextkeyid;
 
 	return 0;
 }
 
 static void tcp_authopt_key_free_rcu(struct rcu_head *rcu)
@@ -343,10 +387,12 @@ static void tcp_authopt_key_free_rcu(struct rcu_head *rcu)
 static void tcp_authopt_key_del(struct sock *sk,
 				struct tcp_authopt_info *info,
 				struct tcp_authopt_key_info *key)
 {
 	hlist_del_rcu(&key->node);
+	if (info->send_key == key)
+		info->send_key = NULL;
 	atomic_sub(sizeof(*key), &sk->sk_omem_alloc);
 	call_rcu(&key->rcu, tcp_authopt_key_free_rcu);
 }
 
 /* free info and keys but don't touch tp->authopt_info */
@@ -496,10 +542,13 @@ int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct r
 		return -ENOMEM;
 
 	sk_nocaps_add(newsk, NETIF_F_GSO_MASK);
 	new_info->src_isn = tcp_rsk(req)->snt_isn;
 	new_info->dst_isn = tcp_rsk(req)->rcv_isn;
+	new_info->send_keyid = old_info->send_keyid;
+	new_info->send_rnextkeyid = old_info->send_rnextkeyid;
+	new_info->flags = old_info->flags;
 	INIT_HLIST_HEAD(&new_info->head);
 	err = tcp_authopt_clone_keys(newsk, oldsk, new_info, old_info);
 	if (err) {
 		__tcp_authopt_info_free(newsk, new_info);
 		return err;
@@ -1088,11 +1137,11 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp
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
 	if (key->maclen + 4 != opt->len)
@@ -1106,7 +1155,14 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
 		net_info_ratelimited("TCP Authentication Failed\n");
 		return -EINVAL;
 	}
 
+accept:
+	/* Doing this for all valid packets will results in keyids temporarily
+	 * flipping back and forth if packets are reordered or retransmitted.
+	 */
+	info->recv_keyid = opt->keyid;
+	info->recv_rnextkeyid = opt->rnextkeyid;
+
 	return 0;
 }
-- 
2.25.1

