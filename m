Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC785ACC24
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237346AbiIEHIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237218AbiIEHHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:07:19 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EF73ED43;
        Mon,  5 Sep 2022 00:06:46 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z8so10092964edb.6;
        Mon, 05 Sep 2022 00:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=8HE4vy0cwAiXsIwN4u+IddIRU0Ym6Oy0B0zKWU5Vbf0=;
        b=Y5g0krKCjYTXU/zL/yIpMqQAhbjuM1jTN+GcZzFZjqFwQ+Z18clFlUyEYjPF7UY16P
         oz0B8Jas6v0A0ChvlAQHyq5y+gyrHmvr9pKQCTmwc21niDJg3XjAuOU9vBeYVMkQoCA6
         wG6yNQHcDccPufKTZOKV+noapgn3FVPEbQKO3YExJR+vn+ScG3QepvJF2z7Zkfzl9a+I
         oVFsINo34Yoikq4WbF9O5TtYAv4W2o8Ywr1JXjzP9uOZiYUCuz4XmJ4gfK6YY+SbTpns
         FHe3n1QYyoYMKz4r83MZG1+DMhHJxhxxywuw18XPhyTGv6RzYdoi4tmRE1d/3CG9XsxE
         /rSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=8HE4vy0cwAiXsIwN4u+IddIRU0Ym6Oy0B0zKWU5Vbf0=;
        b=ZyRWtGUM93FJRdCRP8EedpRvtWzBDyyLqrmNjt1d++Li/Mx6QX3EgwSVowunZ6oxmY
         +8P2VVSHn8j8h2nbFjaSFWW7ElYc64EwYzbC8zFs2joNy3SKk+Kq5ONEneMSPtyaHXtv
         ygmrHSWp6T8bOibaaC24l3IIW9icI33M3SL3gRd4FqiWh0Z073oj0udabHZwvSUxDDII
         IE6rGLkjlBpQ80sROEgG4UU4C8QHraf/SsXDJEtsdbiVG6wHXBq6Kz1ANPqtychUHsjf
         NoNqRGECGkWRxYJHWTYEY3sbSflsTiTTRKcGKn/PHitTzxbWhcGWjVUXVI1wYTFFsYOA
         WzIA==
X-Gm-Message-State: ACgBeo2cNlP4/nOItpFY10TpQN7SsiKLCJbkx7DliwhXLSAnTzs+DrpI
        BEzC+qFSFQzKGe/3hUNlQUY=
X-Google-Smtp-Source: AA6agR50Vl8+r9/QBVhNXdSXHBTfuFAspg7pgPz6gLZQ5pR0LARKBDE//6Xi8RFtXF1Der6uhz3hEw==
X-Received: by 2002:a05:6402:1818:b0:44e:66db:e401 with SMTP id g24-20020a056402181800b0044e66dbe401mr4914392edy.346.1662361604578;
        Mon, 05 Sep 2022 00:06:44 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:40ec:9f50:387:3cfb])
        by smtp.gmail.com with ESMTPSA id n27-20020a056402515b00b0043cf2e0ce1csm5882775edd.48.2022.09.05.00.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 00:06:44 -0700 (PDT)
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
Subject: [PATCH v8 17/26] tcp: authopt: Add key selection controls
Date:   Mon,  5 Sep 2022 10:05:53 +0300
Message-Id: <33382ee57f4ae34061d0a04065ceaa2585e89fb5.1662361354.git.cdleonard@gmail.com>
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

The RFC requires that TCP can report the keyid and rnextkeyid values
being sent or received, implement this via getsockopt values.

The RFC also requires that user can select the sending key and that the
sending key is automatically switched based on rnextkeyid. These
requirements can conflict so we implement both and add a flag which
specifies if user or peer request takes priority.

Also add an option to control rnextkeyid explicitly from userspace.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/tcp_authopt.rst |  32 +++++
 include/net/tcp_authopt.h                |  32 +++++
 include/uapi/linux/tcp.h                 |  31 +++++
 net/ipv4/tcp_authopt.c                   | 167 +++++++++++++++++++++--
 4 files changed, 254 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/tcp_authopt.rst b/Documentation/networking/tcp_authopt.rst
index d0191d0c6c02..5631750cc3f7 100644
--- a/Documentation/networking/tcp_authopt.rst
+++ b/Documentation/networking/tcp_authopt.rst
@@ -44,10 +44,42 @@ new flags.
 
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
+By default the sending keyid is selected to match the rnextkeyid value sent by
+the remote side, visible as recv_rnextkeyid in getsockopt. If that keyid is not
+available then the valid key with the longest send validity time is used, and
+otherwise ties are broken by preferring lowest numeric send_id.
+
+If the ``TCP_AUTHOPT_LOCK_KEYID`` flag is set then the sending key is selected
+by the `tcp_authopt.send_local_id` field and recv_rnextkeyid is ignored. If no
+key with local_id == send_local_id is valid then the same default is used
+as for missing recv_rnextkeyid.
+
+The rnextkeyid value sent on the wire is the recv_id of the valid key with the
+longest recv validity time, and otherwise ties are broken by preferring lowest
+numeric recv_id.
+
+If the TCP_AUTHOPT_LOCK_RNEXTKEY flag is set in `tcp_authopt.flags` the value of
+`tcp_authopt.send_rnextkeyid` is sent instead.
+
+The default key selection behavior is designed to implement key rollover in a
+way that is compatible with existing vendors without needing userspace key
+management. It also tries to behave predictably in all scenarios therefore it
+breaks ties by numeric IDs.
+
+A userspace daemon can use the "lock" flags to implement different key
+management and key rotation policies.
+
 ABI Reference
 =============
 
 .. kernel-doc:: include/uapi/linux/tcp.h
    :identifiers: tcp_authopt tcp_authopt_flag tcp_authopt_key tcp_authopt_key_flag tcp_authopt_alg
diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 6ef893e75ee4..759b6d71fe86 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -83,10 +83,42 @@ struct tcp_authopt_info {
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
+	 * TCP_AUTHOPT_FLAG_LOCK_KEYID, otherwise we try to match recv_rnextkeyid.
+	 *
+	 * This is the "currently effective" value from the last packet.
+	 */
+	u8 send_keyid;
+	/**
+	 * @user_pref_send_keyid: Preferred keyid requested by userspace
+	 */
+	u8 user_pref_send_keyid;
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
 };
 
 /* TCP authopt as found in header */
 struct tcphdr_authopt {
 	u8 num;
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 52e6293048f5..4c3b1aef9976 100644
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
index 2bb7b2356e50..6db06e1edcc7 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -392,24 +392,85 @@ static bool better_key_match(struct tcp_authopt_key_info *old, struct tcp_authop
 		return true;
 
 	return false;
 }
 
+static int better_key_match_for_send(struct tcp_authopt_key_info *old,
+				     struct tcp_authopt_key_info *new)
+{
+	if (better_key_match(old, new))
+		return 1;
+
+	/* For keys with expiration dates prefer the one with longest lifetime */
+	if ((new->flags & TCP_AUTHOPT_KEY_SEND_LIFETIME_END) != 0 &&
+	    (old->flags & TCP_AUTHOPT_KEY_SEND_LIFETIME_END) == 0)
+		return -1;
+	if ((new->flags & TCP_AUTHOPT_KEY_SEND_LIFETIME_END) == 0 &&
+	    (old->flags & TCP_AUTHOPT_KEY_SEND_LIFETIME_END) != 0)
+		return 1;
+	if (old->flags & TCP_AUTHOPT_KEY_SEND_LIFETIME_END &&
+	    new->flags & TCP_AUTHOPT_KEY_SEND_LIFETIME_END) {
+		if (new->send_lifetime_end > old->send_lifetime_end)
+			return 1;
+		if (new->send_lifetime_end < old->send_lifetime_end)
+			return -1;
+	}
+
+	if (new->send_id != old->send_id)
+		return !!(old->send_id - new->send_id);
+
+	return 0;
+}
+
+static int better_rnextkey(struct tcp_authopt_key_info *old, struct tcp_authopt_key_info *new)
+{
+	if (better_key_match(old, new))
+		return 1;
+
+	/* For keys with expiration dates prefer the one with longest lifetime */
+	if ((new->flags & TCP_AUTHOPT_KEY_RECV_LIFETIME_END) != 0 &&
+	    (old->flags & TCP_AUTHOPT_KEY_RECV_LIFETIME_END) == 0)
+		return -1;
+	if ((new->flags & TCP_AUTHOPT_KEY_RECV_LIFETIME_END) == 0 &&
+	    (old->flags & TCP_AUTHOPT_KEY_RECV_LIFETIME_END) != 0)
+		return 1;
+	if (old->flags & TCP_AUTHOPT_KEY_RECV_LIFETIME_END &&
+	    new->flags & TCP_AUTHOPT_KEY_RECV_LIFETIME_END) {
+		if (new->recv_lifetime_end > old->recv_lifetime_end)
+			return 1;
+		if (new->recv_lifetime_end < old->recv_lifetime_end)
+			return -1;
+	}
+
+	/* Break ties by numeric ID */
+	if (new->recv_id != old->recv_id)
+		return !!(old->recv_id - new->recv_id);
+
+	return 0;
+}
+
 /**
  * tcp_authopt_lookup_send - lookup key for sending
  *
  * @net: Per-namespace information containing keys
  * @addr_sk: Socket used for destination address lookup
+ * @pref_send_id: Preferred send_id. If >= 0 then prefer keys that match
+ * @rnextkeyid: Output pointer to preferred rnextkeyid
+ * @anykey: Set to true if any keys are present for the peer
  *
  * If anykey is false then authentication is not required for peer.
  *
  * If anykey is true but no key was found then all our keys must be expired and sending should fail.
  */
 static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct netns_tcp_authopt *net,
-							    const struct sock *addr_sk)
+							    const struct sock *addr_sk,
+							    int pref_send_id,
+							    u8 *rnextkeyid,
+							    bool *anykey)
 {
 	struct tcp_authopt_key_info *result = NULL;
+	struct tcp_authopt_key_info *rnext_result = NULL;
 	struct tcp_authopt_key_info *key;
 	time64_t now = ktime_get_real_seconds();
 	int l3index = -1;
 
 	hlist_for_each_entry_rcu(key, &net->head, node, 0) {
@@ -421,16 +482,35 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct netns_tcp_aut
 				l3index = l3mdev_master_ifindex_by_index(sock_net(addr_sk),
 									 addr_sk->sk_bound_dev_if);
 			if (l3index != key->l3index)
 				continue;
 		}
-		if (!key_valid_for_send(key, now))
-			continue;
-		if (better_key_match(result, key))
-			result = key;
-		else if (result)
-			net_warn_ratelimited("ambiguous tcp authentication keys configured for send\n");
+		if (anykey)
+			*anykey = true;
+
+		if (rnextkeyid &&
+		    key_valid_for_recv(key, now) &&
+		    better_rnextkey(rnext_result, key) > 0)
+			rnext_result = key;
+
+		if (key_valid_for_send(key, now)) {
+			if (pref_send_id >= 0 && result &&
+			    key->send_id != pref_send_id &&
+			    result->send_id == pref_send_id)
+				continue;
+			if (better_key_match_for_send(result, key) > 0)
+				result = key;
+			else if (result)
+				net_warn_ratelimited("ambiguous tcp authentication keys configured for send\n");
+		}
+	}
+
+	if (rnextkeyid) {
+		if (rnext_result)
+			*rnextkeyid = rnext_result->recv_id;
+		else
+			*rnextkeyid = 0;
 	}
 
 	return result;
 }
 
@@ -442,19 +522,59 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct netns_tcp_aut
  * @addr_sk: socket used for address lookup. Same as sk except for synack case
  * @rnextkeyid: value of rnextkeyid caller should write in packet
  *
  * Result is protected by RCU and can't be stored, it may only be passed to
  * tcp_authopt_hash and only under a single rcu_read_lock.
+ *
+ * Returns NULL if no key is required or ERR_PTR(-ENOKEY) if key is required but
+ * none is currently valid.
  */
 struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 						      struct tcp_authopt_info *info,
 						      const struct sock *addr_sk,
 						      u8 *rnextkeyid)
 {
+	struct tcp_authopt_key_info *key;
 	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
+	bool anykey = false;
+	int pref_send_id;
+
+	/* Listen sockets don't refer to any specific connection so we don't try
+	 * to keep using the same key and ignore any received keyids.
+	 */
+	if (sk->sk_state == TCP_LISTEN) {
+		if (info->flags & TCP_AUTHOPT_FLAG_LOCK_KEYID)
+			pref_send_id = info->user_pref_send_keyid;
+		else
+			pref_send_id = -1;
+		key = tcp_authopt_lookup_send(net, addr_sk, pref_send_id, rnextkeyid, &anykey);
+
+		return key;
+	}
+
+	/* Try to keep the same sending key unless user or peer requires a different key
+	 * User request (via TCP_AUTHOPT_FLAG_LOCK_KEYID) always overrides peer request.
+	 */
+	if (info->flags & TCP_AUTHOPT_FLAG_LOCK_KEYID)
+		pref_send_id = info->user_pref_send_keyid;
+	else
+		pref_send_id = info->recv_rnextkeyid;
 
-	return tcp_authopt_lookup_send(net, addr_sk);
+	key = tcp_authopt_lookup_send(net, addr_sk, pref_send_id, rnextkeyid, &anykey);
+
+	if (!key)
+		return NULL;
+
+	info->send_keyid = key->send_id;
+	if (rnextkeyid) {
+		if (info->flags & TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID)
+			*rnextkeyid = info->send_rnextkeyid;
+		else
+			info->send_rnextkeyid = *rnextkeyid;
+	}
+
+	return key;
 }
 EXPORT_SYMBOL(__tcp_authopt_select_key);
 
 static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk)
 {
@@ -476,10 +596,12 @@ static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk
 
 	return info;
 }
 
 #define TCP_AUTHOPT_KNOWN_FLAGS ( \
+	TCP_AUTHOPT_FLAG_LOCK_KEYID | \
+	TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID | \
 	TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED)
 
 /* Like copy_from_sockptr except tolerate different optlen for compatibility reasons
  *
  * If the src is shorter then it's from an old userspace and the rest of dst is
@@ -547,10 +669,14 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	info = __tcp_authopt_info_get_or_create(sk);
 	if (IS_ERR(info))
 		return PTR_ERR(info);
 
 	info->flags = opt.flags & TCP_AUTHOPT_KNOWN_FLAGS;
+	if (opt.flags & TCP_AUTHOPT_FLAG_LOCK_KEYID)
+		info->user_pref_send_keyid = opt.send_keyid;
+	if (opt.flags & TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID)
+		info->send_rnextkeyid = opt.send_rnextkeyid;
 
 	return 0;
 }
 
 int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
@@ -568,10 +694,18 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
 	if (!info)
 		return -ENOENT;
 
 	opt->flags = info->flags & TCP_AUTHOPT_KNOWN_FLAGS;
+	/* These keyids might be undefined, for example before connect.
+	 * Reporting zero is not strictly correct because there are no reserved
+	 * values.
+	 */
+	opt->send_keyid = info->send_keyid;
+	opt->send_rnextkeyid = info->send_rnextkeyid;
+	opt->recv_keyid = info->recv_keyid;
+	opt->recv_rnextkeyid = info->recv_rnextkeyid;
 
 	return 0;
 }
 
 #define TCP_AUTHOPT_KEY_KNOWN_FLAGS ( \
@@ -1571,10 +1705,25 @@ static void print_tcpao_notice(const char *msg, struct sk_buff *skb)
 	} else {
 		WARN_ONCE(1, "%s unknown IP version\n", msg);
 	}
 }
 
+static void save_inbound_key_info(
+		struct tcp_authopt_info *info,
+		struct tcphdr_authopt *opt)
+{
+	/* Doing this for all valid packets will results in keyids temporarily
+	 * flipping back and forth if packets are reordered or retransmitted
+	 * but keys should eventually stabilize.
+	 *
+	 * This is connection-specific so don't store for listen sockets.
+	 *
+	 */
+	info->recv_keyid = opt->keyid;
+	info->recv_rnextkeyid = opt->rnextkeyid;
+}
+
 /**
  * __tcp_authopt_inbound_check - Check inbound TCP authentication option
  *
  * @sk: Receive socket. For the SYN_RECV state this must be the request_sock, not the listener
  * @skb: Input Packet
@@ -1617,10 +1766,11 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb,
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
 			print_tcpao_notice("TCP Authentication Unexpected: Rejected", skb);
 			return -SKB_DROP_REASON_TCP_AOUNEXPECTED;
 		}
 		print_tcpao_notice("TCP Authentication Unexpected: Accepted", skb);
+		save_inbound_key_info(info, opt);
 		return 0;
 	}
 	if (opt && !key) {
 		/* Keys are configured for peer but with different keyid than packet */
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
@@ -1640,10 +1790,11 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb,
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
 		print_tcpao_notice("TCP Authentication Failed", skb);
 		return -SKB_DROP_REASON_TCP_AOFAILURE;
 	}
 
+	save_inbound_key_info(info, opt);
 	return 1;
 }
 EXPORT_SYMBOL(__tcp_authopt_inbound_check);
 
 static int tcp_authopt_init_net(struct net *full_net)
-- 
2.25.1

