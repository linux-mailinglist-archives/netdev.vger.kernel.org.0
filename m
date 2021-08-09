Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85693E4E98
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236643AbhHIVgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236431AbhHIVgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:36:20 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE604C0617A0;
        Mon,  9 Aug 2021 14:35:58 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id cf5so26817612edb.2;
        Mon, 09 Aug 2021 14:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PUqAlLNH4YeN3rVIdjP870cOs6LUxkdfXIiMuoP0+Is=;
        b=oWevK1wL/j6cgww4o6hyzrDD8dQCrAS/y+o0EtOyWjOY7BDIMroOQybLqmpJOB8SCf
         a9asCYzcjAq6uS2WqwsIzMnnyIO6ahqNwb9f2BiNthsZOMfu5oZbIp/lpkT7nRUb1xW/
         4Kmdw/kGfNzGR4XdKbUy/XgfWkAE5BfgpP0HmQHllzau+CPx/ZE+ZuK4DNyvAahdxZlN
         oOyARjtNX/ux7Tp2G43J8CLgJw29JtoQJHtzGFre/nxsdu/jg294EwN5zVX2ZJ5VLrl+
         qXAYw9Yh4RwHcdqW8B+oGwrvbHUon6FB1aeJvXSLXm1ukET7z00unSqf3zWjgFZy0CRe
         PhaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PUqAlLNH4YeN3rVIdjP870cOs6LUxkdfXIiMuoP0+Is=;
        b=QGebICGeRXc1NGwEK056vCjPuOp/ZQWp35kbeNk7qNCIoIZMwbY/bIxwycEY3RzANJ
         IDNcPC86FJ13IdWwTDriRy74LwoL0bzkHHY47RPa9+z+mELY2JubsEqpl4T2x0D2FvB1
         HULTrLkGEcCqQHhk9vGVNgW85PSJPKP8IP6Q3fg/kplpZOV5gxb5Hf8+tT2SS41cnHzG
         zYJ/78+s1vKl+KX06z+1/XK261NRYiSwtc4n4w9stDK7oLkn+wZyNptw03attuU2GMa7
         udRtSoghKzSA6Ee7lj3/95hKuO10KWZaVWKpuAc0BG6L9g4E1CVvWpV+rzbJjtXOMHp8
         6ofw==
X-Gm-Message-State: AOAM5308O0FekEM2QBWR505SLVvcR7EsriSJri+7EMIGKDRcL5/btLVf
        Ele6ZrH4nj2SZU3G3gswtvE=
X-Google-Smtp-Source: ABdhPJxs98lcTKdbiwlj5KLON0kuBiZw2trNEBqNZK3t2eFbjUMnnmEgPj3MFH5bCJ5rRCoh7EWN3A==
X-Received: by 2002:a05:6402:424c:: with SMTP id g12mr446165edb.121.1628544956484;
        Mon, 09 Aug 2021 14:35:56 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:688d:23e:82c6:84aa])
        by smtp.gmail.com with ESMTPSA id v24sm5542932edt.41.2021.08.09.14.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 14:35:56 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Ahern <dsahern@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFCv2 6/9] tcp: authopt: Add key selection controls
Date:   Tue, 10 Aug 2021 00:35:35 +0300
Message-Id: <a9b759f952e548cdde5720ab99781c6d35e5931f.1628544649.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1628544649.git.cdleonard@gmail.com>
References: <cover.1628544649.git.cdleonard@gmail.com>
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
 Documentation/networking/tcp_authopt.rst | 25 +++++++++++
 include/net/tcp_authopt.h                |  8 ++++
 include/uapi/linux/tcp.h                 | 31 +++++++++++++
 net/ipv4/tcp_authopt.c                   | 57 ++++++++++++++++++++++--
 4 files changed, 117 insertions(+), 4 deletions(-)

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
index 28ebc77473a4..759635346874 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -25,11 +25,19 @@ struct tcp_authopt_key_info {
 
 /* Per-socket information regarding tcp_authopt */
 struct tcp_authopt_info {
 	/* List of tcp_authopt_key_info */
 	struct hlist_head head;
+	/* Current send_key, cached.
+	 * Once a key is found it only changes by user or remote request.
+	 */
+	struct tcp_authopt_key_info *send_key;
 	u32 flags;
+	u32 local_send_id;
+	u8 send_rnextkeyid;
+	u8 recv_keyid;
+	u8 recv_rnextkeyid;
 	u32 src_isn;
 	u32 dst_isn;
 	struct rcu_head rcu;
 };
 
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index bc47664156eb..c04f5166ab33 100644
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
+	 * If this is set `tcp_authopt.local_send_id` is used to determined sending
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
+	 * @local_send_id: `tcp_authopt_key.local_id` of preferred send key
+	 *
+	 * This is only used if `TCP_AUTHOPT_FLAG_LOCK_KEYID` is set
+	 */
+	__u32	local_send_id;
+	/**
+	 * @send_rnextkeyid: The rnextkeyid to send in packets
+	 *
+	 * This is controlled by the user iff TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID is
+	 * set. Otherwise rnextkeyid is the recv_id of the current key
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
index 493461e46460..40412d9ea04e 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -215,17 +215,44 @@ struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct tcp_authopt_info *in
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
+		int local_send_id = info->local_send_id;
+
+		if (local_send_id && (!key || key->local_id != local_send_id))
+			new_key = __tcp_authopt_key_info_lookup(sk, info, local_send_id);
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
@@ -262,11 +289,17 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 
 	info = __tcp_authopt_info_get_or_create(sk);
 	if (IS_ERR(info))
 		return PTR_ERR(info);
 
-	info->flags = opt.flags & TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED);
+	info->flags = opt.flags &
+		(TCP_AUTHOPT_FLAG_LOCK_KEYID |
+		TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID |
+		TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED);
+	info->local_send_id = opt.local_send_id;
+	if (opt.flags & TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID)
+		info->send_rnextkeyid = opt.send_rnextkeyid;
 
 	return 0;
 }
 
 int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
@@ -277,11 +310,17 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 	WARN_ON(!lockdep_sock_is_held(sk));
 	memset(opt, 0, sizeof(*opt));
 	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
 	if (!info)
 		return -EINVAL;
-	opt->flags = info->flags & TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED;
+	if (info->send_key)
+		opt->local_send_id = info->send_key->local_id;
+	else
+		opt->local_send_id = 0;
+	opt->send_rnextkeyid = info->send_rnextkeyid;
+	opt->recv_keyid = info->recv_keyid;
+	opt->recv_rnextkeyid = info->recv_rnextkeyid;
 
 	return 0;
 }
 
 static void tcp_authopt_key_free_rcu(struct rcu_head *rcu)
@@ -295,10 +334,12 @@ static void tcp_authopt_key_free_rcu(struct rcu_head *rcu)
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
@@ -440,10 +481,11 @@ int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct r
 		return -ENOMEM;
 
 	sk_nocaps_add(newsk, NETIF_F_GSO_MASK);
 	new_info->src_isn = tcp_rsk(req)->snt_isn;
 	new_info->dst_isn = tcp_rsk(req)->rcv_isn;
+	new_info->local_send_id = old_info->local_send_id;
 	INIT_HLIST_HEAD(&new_info->head);
 	err = tcp_authopt_clone_keys(newsk, oldsk, new_info, old_info);
 	if (err) {
 		__tcp_authopt_info_free(newsk, new_info);
 		return err;
@@ -1016,11 +1058,11 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp
 		if (info->flags & TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED) {
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
@@ -1033,7 +1075,14 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp
 	if (memcmp(macbuf, opt->mac, key->maclen)) {
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

