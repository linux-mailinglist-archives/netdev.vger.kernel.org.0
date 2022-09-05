Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00825ACC67
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237321AbiIEHII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235591AbiIEHHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:07:18 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473313F1C5;
        Mon,  5 Sep 2022 00:06:44 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id q21so2438024edc.9;
        Mon, 05 Sep 2022 00:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=KvP0u0ResPLfXDH4D9VK2zxPHaE8ZP8SwZv5XZHzmLg=;
        b=m2vCq4CqSjMv0UpmAnF2NmTCXNNS+ia8UggiAQc+bUbK/iGut8kC3vLg8Qu2fiRdYR
         g739ZCz/pKRv9sXLDf+THsuFLza+qn66YA2INxYS+dTK76hPnChZW5oMz/bggit1cw7c
         SS7nwL+YJ53bLQb11QLh77ZkORXBp7U5JVJ9+DHweaQPkgnGT7kLdjAEEGt3JxvqGc7l
         RrDeugmuHIVbP/KwjLS7tbSp4OJ36UQuVrxLbdMFSPTh0SRapJbvYbl04rqZmzvY7If7
         +ml/ecCYjkMV2Uaujc7cIlPcDqP1dbsRraraA3pSYzx2Vljv5Xw56coSAtRli9QcM+oq
         F06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=KvP0u0ResPLfXDH4D9VK2zxPHaE8ZP8SwZv5XZHzmLg=;
        b=hNWwMTC3hOQimYGXnThZBvr+sCdET5PlJUA1COO1aAXHX35CHWgOh321tj3p1h8KZc
         0lxTZBGg6wkkG72bqC1TRl7nhv0trDy3aX2IMV9QQ8eUsIIN0DndGOzRVDsdXUDs8wfz
         k4O+2wrwtDot60WkMBGOHO4WhdLQp+IwNdi9A+L/nuyQpSns3EwSrk7/QjKHnTHkZIwD
         MeSthvflAedX/TyDV1Vmxxi3ZXDyLi6O7Y6qeyMjxvOPUdTEmdc4QUTsiLPF/CDthz4M
         blqreKGDGYF6s1zB//XfWwy88cgg8GmoO3NTVAN2OQFC8nRi7gjdOePS/aY7UO1z82SS
         FVdw==
X-Gm-Message-State: ACgBeo1eq61KuamjOF4YE+RhJfQ6bHPDTAWE7k2i2jv5+LetAHPNuMbm
        P4hhOKN8z1oA8aDgMaK55lg=
X-Google-Smtp-Source: AA6agR4GLh0bzd/3JbKDdU6CViBjXruSNiseLJ4j9XsT7x255t4J8J2XZFPpkdW+PH3xajGRwo/E2A==
X-Received: by 2002:a05:6402:2b98:b0:43e:107:183d with SMTP id fj24-20020a0564022b9800b0043e0107183dmr42152437edb.366.1662361602589;
        Mon, 05 Sep 2022 00:06:42 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:40ec:9f50:387:3cfb])
        by smtp.gmail.com with ESMTPSA id n27-20020a056402515b00b0043cf2e0ce1csm5882775edd.48.2022.09.05.00.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 00:06:42 -0700 (PDT)
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
Subject: [PATCH v8 16/26] tcp: authopt: Add send/recv lifetime support
Date:   Mon,  5 Sep 2022 10:05:52 +0300
Message-Id: <c6945ec39cb040be8a60e1da1e7ad15d95df5c08.1662361354.git.cdleonard@gmail.com>
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

These fields are modeled on RFC8177. This allows the kernel to handle
key expiration internally instead of relying on userspace changing the
NORECV/NOSEND flags on a timer.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp_authopt.h |  9 +++++++++
 include/uapi/linux/tcp.h  | 21 ++++++++++++++++++++-
 net/ipv4/tcp_authopt.c    | 39 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 6260c3ef6864..6ef893e75ee4 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -53,10 +53,19 @@ struct tcp_authopt_key_info {
 	int prefixlen;
 	/** @addr: Same as &tcp_authopt_key.addr */
 	struct sockaddr_storage addr;
 	/** @alg: Algorithm implementation matching alg_id */
 	struct tcp_authopt_alg_imp *alg;
+	/** @alg: Algorithm implementation matching alg_id */
+	/** @send_lifetime_begin: Beginning of send lifetime */
+	u64 send_lifetime_begin;
+	/** @send_lifetime_end: End of send lifetime */
+	u64 send_lifetime_end;
+	/** @recv_lifetime_begin: Beginning of recv lifetime */
+	u64 recv_lifetime_begin;
+	/** @recv_lifetime_end: End of recv lifetime */
+	u64 recv_lifetime_end;
 };
 
 /**
  * struct tcp_authopt_info - Per-socket information regarding tcp_authopt
  *
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 274ddfefd6de..52e6293048f5 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -373,20 +373,28 @@ struct tcp_authopt {
  * @TCP_AUTHOPT_KEY_ADDR_BIND: Key only valid for `tcp_authopt.addr`
  * @TCP_AUTHOPT_KEY_IFINDEX: Key only valid for `tcp_authopt.ifindex`
  * @TCP_AUTHOPT_KEY_NOSEND: Key invalid for send (expired)
  * @TCP_AUTHOPT_KEY_NORECV: Key invalid for recv (expired)
  * @TCP_AUTHOPT_KEY_PREFIXLEN: Valid value in `tcp_authopt.prefixlen`, otherwise
- * match full address length
+ * always match full address length
+ * @TCP_AUTHOPT_KEY_SEND_LIFETIME_BEGIN: Valid value in `tcp_authopt.send_lifetime_begin`
+ * @TCP_AUTHOPT_KEY_SEND_LIFETIME_END: Valid value in `tcp_authopt.send_lifetime_end`
+ * @TCP_AUTHOPT_KEY_RECV_LIFETIME_BEGIN: Valid value in `tcp_authopt.recv_lifetime_begin`
+ * @TCP_AUTHOPT_KEY_RECV_LIFETIME_END: Valid value in `tcp_authopt.recv_lifetime_end`
  */
 enum tcp_authopt_key_flag {
 	TCP_AUTHOPT_KEY_DEL = (1 << 0),
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS = (1 << 1),
 	TCP_AUTHOPT_KEY_ADDR_BIND = (1 << 2),
 	TCP_AUTHOPT_KEY_IFINDEX = (1 << 3),
 	TCP_AUTHOPT_KEY_NOSEND = (1 << 4),
 	TCP_AUTHOPT_KEY_NORECV = (1 << 5),
 	TCP_AUTHOPT_KEY_PREFIXLEN = (1 << 6),
+	TCP_AUTHOPT_KEY_SEND_LIFETIME_BEGIN = (1 << 7),
+	TCP_AUTHOPT_KEY_SEND_LIFETIME_END = (1 << 8),
+	TCP_AUTHOPT_KEY_RECV_LIFETIME_BEGIN = (1 << 9),
+	TCP_AUTHOPT_KEY_RECV_LIFETIME_END = (1 << 10),
 };
 
 /**
  * enum tcp_authopt_alg - Algorithms for TCP Authentication Option
  */
@@ -408,10 +416,13 @@ enum tcp_authopt_alg {
  * - recv_id
  * - addr (iff TCP_AUTHOPT_KEY_ADDR_BIND)
  *
  * RFC5925 requires that key ids must not overlap for the same TCP connection.
  * This is not enforced by linux.
+ *
+ * Key validity times are optional. When specified they are interpreted as "wall
+ * time" and compared to CLOCK_REALTIME.
  */
 struct tcp_authopt_key {
 	/** @flags: Combination of &enum tcp_authopt_key_flag */
 	__u32	flags;
 	/** @send_id: keyid value for send */
@@ -444,10 +455,18 @@ struct tcp_authopt_key {
 	 *
 	 * Without the TCP_AUTHOPT_KEY_PREFIXLEN flag this is ignored and a full
 	 * address match is performed.
 	 */
 	int	prefixlen;
+	/** @send_lifetime_begin: Beginning of send lifetime */
+	__u64	send_lifetime_begin;
+	/** @send_lifetime_end: End of send lifetime */
+	__u64	send_lifetime_end;
+	/** @recv_lifetime_begin: Beginning of recv lifetime */
+	__u64	recv_lifetime_begin;
+	/** @recv_lifetime_end: End of recv lifetime */
+	__u64	recv_lifetime_end;
 };
 
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index daeecb64c89e..2bb7b2356e50 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -242,10 +242,33 @@ void tcp_authopt_clear(struct sock *sk)
 	if (info) {
 		tcp_authopt_free(sk, info);
 		tcp_sk(sk)->authopt_info = NULL;
 	}
 }
+
+static bool key_valid_for_send(struct tcp_authopt_key_info *key, ktime_t now)
+{
+	if (key->flags & TCP_AUTHOPT_KEY_NOSEND)
+		return false;
+	if (key->flags & TCP_AUTHOPT_KEY_SEND_LIFETIME_BEGIN && now < key->send_lifetime_begin)
+		return false;
+	if (key->flags & TCP_AUTHOPT_KEY_SEND_LIFETIME_END && now > key->send_lifetime_end)
+		return false;
+	return true;
+}
+
+static bool key_valid_for_recv(struct tcp_authopt_key_info *key, ktime_t now)
+{
+	if (key->flags & TCP_AUTHOPT_KEY_NORECV)
+		return false;
+	if (key->flags & TCP_AUTHOPT_KEY_RECV_LIFETIME_BEGIN && now < key->recv_lifetime_begin)
+		return false;
+	if (key->flags & TCP_AUTHOPT_KEY_RECV_LIFETIME_END && now > key->recv_lifetime_end)
+		return false;
+	return true;
+}
+
 /* checks that ipv4 or ipv6 addr matches. */
 static bool ipvx_addr_match(struct sockaddr_storage *a1,
 			    struct sockaddr_storage *a2)
 {
 	if (a1->ss_family != a2->ss_family)
@@ -384,10 +407,11 @@ static bool better_key_match(struct tcp_authopt_key_info *old, struct tcp_authop
 static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct netns_tcp_authopt *net,
 							    const struct sock *addr_sk)
 {
 	struct tcp_authopt_key_info *result = NULL;
 	struct tcp_authopt_key_info *key;
+	time64_t now = ktime_get_real_seconds();
 	int l3index = -1;
 
 	hlist_for_each_entry_rcu(key, &net->head, node, 0) {
 		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
 			if (!tcp_authopt_key_match_sk_addr(key, addr_sk))
@@ -397,11 +421,11 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct netns_tcp_aut
 				l3index = l3mdev_master_ifindex_by_index(sock_net(addr_sk),
 									 addr_sk->sk_bound_dev_if);
 			if (l3index != key->l3index)
 				continue;
 		}
-		if (key->flags & TCP_AUTHOPT_KEY_NOSEND)
+		if (!key_valid_for_send(key, now))
 			continue;
 		if (better_key_match(result, key))
 			result = key;
 		else if (result)
 			net_warn_ratelimited("ambiguous tcp authentication keys configured for send\n");
@@ -555,11 +579,15 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS | \
 	TCP_AUTHOPT_KEY_ADDR_BIND | \
 	TCP_AUTHOPT_KEY_IFINDEX | \
 	TCP_AUTHOPT_KEY_PREFIXLEN | \
 	TCP_AUTHOPT_KEY_NOSEND | \
-	TCP_AUTHOPT_KEY_NORECV)
+	TCP_AUTHOPT_KEY_NORECV | \
+	TCP_AUTHOPT_KEY_SEND_LIFETIME_BEGIN | \
+	TCP_AUTHOPT_KEY_SEND_LIFETIME_END | \
+	TCP_AUTHOPT_KEY_RECV_LIFETIME_BEGIN | \
+	TCP_AUTHOPT_KEY_RECV_LIFETIME_END)
 
 static bool ipv6_addr_is_prefix(struct in6_addr *addr, int plen)
 {
 	struct in6_addr copy;
 
@@ -690,10 +718,14 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	key_info->keylen = opt.keylen;
 	memcpy(key_info->key, opt.key, opt.keylen);
 	memcpy(&key_info->addr, &opt.addr, sizeof(key_info->addr));
 	key_info->l3index = l3index;
 	key_info->prefixlen = prefixlen;
+	key_info->send_lifetime_begin = opt.send_lifetime_begin;
+	key_info->send_lifetime_end = opt.send_lifetime_end;
+	key_info->recv_lifetime_begin = opt.recv_lifetime_begin;
+	key_info->recv_lifetime_end = opt.recv_lifetime_end;
 	hlist_add_head_rcu(&key_info->node, &net->head);
 	mutex_unlock(&net->mutex);
 
 	return 0;
 }
@@ -1480,10 +1512,11 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
 							    bool *anykey)
 {
 	struct tcp_authopt_key_info *result = NULL;
 	struct tcp_authopt_key_info *key;
 	int l3index = -1;
+	time64_t now = ktime_get_real_seconds();
 
 	*anykey = false;
 	/* multiple matches will cause occasional failures */
 	hlist_for_each_entry_rcu(key, &net->head, node, 0) {
 		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND &&
@@ -1504,11 +1537,11 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
 			if (l3index != key->l3index)
 				continue;
 		}
 		*anykey = true;
 		// If only keys with norecv flag are present still consider that
-		if (key->flags & TCP_AUTHOPT_KEY_NORECV)
+		if (!key_valid_for_recv(key, now))
 			continue;
 		if (recv_id >= 0 && key->recv_id != recv_id)
 			continue;
 		if (better_key_match(result, key))
 			result = key;
-- 
2.25.1

