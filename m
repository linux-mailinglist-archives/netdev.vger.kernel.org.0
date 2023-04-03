Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427206D539F
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbjDCVgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbjDCVft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:35:49 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAD14C37
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:34:45 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h17so30769957wrt.8
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 14:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1680557685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qmwS1QrrKSmbhWoPZZnkTVrFEwBMoimpXuDDMnPLyPg=;
        b=R4jjOiL6R6ZsQXFdbeCCcz6qPO8kJJGF/zGDtObpQruMyPGyzlKDNlKeiraRIFw+Di
         PB4xdwGuQP5OUO+Yy0MuNOPnoC9IH7L+43t85VS+hQVWZo5WJfyRKSNZl2CxgSTavXK4
         9xtTHQd2wyL7f2eHmkKwyC3OQv/e/dbNS/kD/aMjHGeshyd5gBqbhrZXpD+MAWp0Jpsg
         hQnRFgzuki+oTnv1D3MfGKvQc+BNBqr/4m1YbCNY2yUYUrlCMhBbrc54Ue++1RXUJcDN
         jMZdRM+zLz3yYTfTc2+XRRvuewaOBAz4DAYZy1T4TXo/jQSDnKceoafEKS3gi7ORZjZA
         gqow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680557685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qmwS1QrrKSmbhWoPZZnkTVrFEwBMoimpXuDDMnPLyPg=;
        b=cXZ1H1PY9PKWNU5AlaZERY5E5jLKXWseiARev1SvMz4MMjvDrew+q/Yl8pIStY3xpu
         VxTT5go7uMAhMO5vDAuPe5Nn3ofASeTKAHpAMxNzQq0ny7XDdxoRupDNwJY7aQToV776
         nrtAgwxD6LTSsSW4qUyH/tvklMJGGPSIKcF/22mFRk6i2b7AtgOVWIEb3g0HR+jpmVsd
         51YJIztO0bTcD2x/d850XLJtfc+6PBcF0MxffNrGXkKQeRTO5SzFSmaVJdI66MiFt1kF
         yEqPD0iBJn9e1Q2nFmgke608W8G2ZplzxFPXuDvtD37D/knkIjOTt6oafjnR51TPAnAD
         S6BQ==
X-Gm-Message-State: AAQBX9dBmIHfG/6aTnCko2VxmCWSBTBnLcRnBYjkL+CnImr7kmA2i8Je
        4dPWN0NG8u0Rvlxs72GqZNenww==
X-Google-Smtp-Source: AKy350YPbgRU+s16zjjjRBQl7UKOrWT9B1bMzzYx3ByakOdj8YFgEz02hz0THDOtFpPKzRdVSN2FnA==
X-Received: by 2002:adf:ef4a:0:b0:2c7:ae57:5acc with SMTP id c10-20020adfef4a000000b002c7ae575accmr4937wrp.26.1680557685339;
        Mon, 03 Apr 2023 14:34:45 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id o5-20020a5d4a85000000b002c3f9404c45sm10682740wrq.7.2023.04.03.14.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 14:34:45 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <error27@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>
Subject: [PATCH v5 13/21] net/tcp: Add TCP-AO segments counters
Date:   Mon,  3 Apr 2023 22:34:12 +0100
Message-Id: <20230403213420.1576559-14-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403213420.1576559-1-dima@arista.com>
References: <20230403213420.1576559-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce segment counters that are useful for troubleshooting/debugging
as well as for writing tests.
Now there are global snmp counters as well as per-socket and per-key.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/dropreason.h  | 15 +++++++++++----
 include/net/tcp.h         | 11 ++++++++---
 include/net/tcp_ao.h      | 10 ++++++++++
 include/uapi/linux/snmp.h |  4 ++++
 include/uapi/linux/tcp.h  |  8 +++++++-
 net/ipv4/proc.c           |  4 ++++
 net/ipv4/tcp_ao.c         | 33 +++++++++++++++++++++++++++++----
 net/ipv4/tcp_ipv4.c       |  2 +-
 net/ipv6/tcp_ipv6.c       |  4 ++--
 9 files changed, 76 insertions(+), 15 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 36e878babcd1..4635b8eaa0a2 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -160,17 +160,24 @@ enum skb_drop_reason {
 	 */
 	SKB_DROP_REASON_TCP_MD5FAILURE,
 	/**
-	 * @SKB_DROP_REASON_TCP_AONOTFOUND: no TCP-AO hash and one was expected
+	 * @SKB_DROP_REASON_TCP_AONOTFOUND: no TCP-AO hash and one was expected,
+	 * corresponding to LINUX_MIB_TCPAOREQUIRED
 	 */
 	SKB_DROP_REASON_TCP_AONOTFOUND,
 	/**
 	 * @SKB_DROP_REASON_TCP_AOUNEXPECTED: TCP-AO hash is present and it
-	 * was not expected.
+	 * was not expected, corresponding to LINUX_MIB_TCPAOKEYNOTFOUND
 	 */
 	SKB_DROP_REASON_TCP_AOUNEXPECTED,
-	/** @SKB_DROP_REASON_TCP_AOKEYNOTFOUND: TCP-AO key is unknown */
+	/**
+	 * @SKB_DROP_REASON_TCP_AOKEYNOTFOUND: TCP-AO key is unknown,
+	 * corresponding to LINUX_MIB_TCPAOKEYNOTFOUND
+	 */
 	SKB_DROP_REASON_TCP_AOKEYNOTFOUND,
-	/** @SKB_DROP_REASON_TCP_AOFAILURE: TCP-AO hash is wrong */
+	/**
+	 * @SKB_DROP_REASON_TCP_AOFAILURE: TCP-AO hash is wrong,
+	 * corresponding to LINUX_MIB_TCPAOBAD
+	 */
 	SKB_DROP_REASON_TCP_AOFAILURE,
 	/**
 	 * @SKB_DROP_REASON_SOCKET_BACKLOG: failed to add skb to socket backlog (
diff --git a/include/net/tcp.h b/include/net/tcp.h
index ae70497e4443..45343a0a128c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2568,7 +2568,7 @@ static inline int tcp_parse_auth_options(const struct tcphdr *th,
 }
 
 static inline bool tcp_ao_required(struct sock *sk, const void *saddr,
-				   int family)
+				   int family, bool stat_inc)
 {
 #ifdef CONFIG_TCP_AO
 	struct tcp_ao_info *ao_info;
@@ -2580,8 +2580,13 @@ static inline bool tcp_ao_required(struct sock *sk, const void *saddr,
 		return false;
 
 	ao_key = tcp_ao_do_lookup(sk, saddr, family, -1, -1, 0);
-	if (ao_info->ao_required || ao_key)
+	if (ao_info->ao_required || ao_key) {
+		if (stat_inc) {
+			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOREQUIRED);
+			atomic64_inc(&ao_info->counters.ao_required);
+		}
 		return true;
+	}
 #endif
 	return false;
 }
@@ -2619,7 +2624,7 @@ tcp_inbound_hash(struct sock *sk, const struct request_sock *req,
 		 * the last key is impossible to remove, so there's
 		 * always at least one current_key.
 		 */
-		if (tcp_ao_required(sk, saddr, family))
+		if (tcp_ao_required(sk, saddr, family, true))
 			return SKB_DROP_REASON_TCP_AONOTFOUND;
 		if (unlikely(tcp_md5_do_lookup(sk, l3index, saddr, family))) {
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index fe2f4f62f917..bd67e3680a2b 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -20,6 +20,13 @@ struct tcp_ao_hdr {
 	u8	rnext_keyid;
 };
 
+struct tcp_ao_counters {
+	atomic64_t	pkt_good;
+	atomic64_t	pkt_bad;
+	atomic64_t	key_not_found;
+	atomic64_t	ao_required;
+};
+
 struct tcp_ao_key {
 	struct hlist_node	node;
 	union tcp_ao_addr	addr;
@@ -35,6 +42,8 @@ struct tcp_ao_key {
 	u8			maclen;
 	u8			digest_size;
 	struct rcu_head		rcu;
+	atomic64_t		pkt_good;
+	atomic64_t		pkt_bad;
 	u8			traffic_keys[];
 };
 
@@ -83,6 +92,7 @@ struct tcp_ao_info {
 	 */
 	struct tcp_ao_key	*current_key;
 	struct tcp_ao_key	*rnext_key;
+	struct tcp_ao_counters	counters;
 	u32			ao_required	:1,
 				__unused	:31;
 	__be32			lisn;
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 26f33a4c253d..06ddf4cd295c 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -296,6 +296,10 @@ enum
 	LINUX_MIB_TCPMIGRATEREQSUCCESS,		/* TCPMigrateReqSuccess */
 	LINUX_MIB_TCPMIGRATEREQFAILURE,		/* TCPMigrateReqFailure */
 	LINUX_MIB_TCPPLBREHASH,			/* TCPPLBRehash */
+	LINUX_MIB_TCPAOREQUIRED,		/* TCPAORequired */
+	LINUX_MIB_TCPAOBAD,			/* TCPAOBad */
+	LINUX_MIB_TCPAOKEYNOTFOUND,		/* TCPAOKeyNotFound */
+	LINUX_MIB_TCPAOGOOD,			/* TCPAOGood */
 	__LINUX_MIB_MAX
 };
 
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 250e0ce2cc38..3fe0612ec59a 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -391,9 +391,15 @@ struct tcp_ao_info_opt { /* setsockopt(TCP_AO_INFO) */
 	__u32   set_current	:1,	/* corresponding ::current_key */
 		set_rnext	:1,	/* corresponding ::rnext */
 		ao_required	:1,	/* don't accept non-AO connects */
-		reserved	:29;	/* must be 0 */
+		set_counters	:1,	/* set/clear ::pkt_* counters */
+		reserved	:28;	/* must be 0 */
+	__u16	reserved2;		/* padding, must be 0 */
 	__u8	current_key;		/* KeyID to set as Current_key */
 	__u8	rnext;			/* KeyID to set as Rnext_key */
+	__u64	pkt_good;		/* verified segments */
+	__u64	pkt_bad;		/* failed verification */
+	__u64	pkt_key_not_found;	/* could not find a key to verify */
+	__u64	pkt_ao_required;	/* segments missing TCP-AO sign */
 } __attribute__((aligned(8)));
 
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index eaf1d3113b62..3f643cd29cfe 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -298,6 +298,10 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPMigrateReqSuccess", LINUX_MIB_TCPMIGRATEREQSUCCESS),
 	SNMP_MIB_ITEM("TCPMigrateReqFailure", LINUX_MIB_TCPMIGRATEREQFAILURE),
 	SNMP_MIB_ITEM("TCPPLBRehash", LINUX_MIB_TCPPLBREHASH),
+	SNMP_MIB_ITEM("TCPAORequired", LINUX_MIB_TCPAOREQUIRED),
+	SNMP_MIB_ITEM("TCPAOBad", LINUX_MIB_TCPAOBAD),
+	SNMP_MIB_ITEM("TCPAOKeyNotFound", LINUX_MIB_TCPAOKEYNOTFOUND),
+	SNMP_MIB_ITEM("TCPAOGood", LINUX_MIB_TCPAOGOOD),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 74f707bcca63..8fec1af5ebd7 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -194,6 +194,8 @@ static struct tcp_ao_key *tcp_ao_copy_key(struct sock *sk,
 	*new_key = *key;
 	INIT_HLIST_NODE(&new_key->node);
 	tcp_sigpool_get(new_key->tcp_sigpool_id);
+	atomic64_set(&new_key->pkt_good, 0);
+	atomic64_set(&new_key->pkt_bad, 0);
 
 	return new_key;
 }
@@ -665,14 +667,25 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
 	u8 maclen = aoh->length - sizeof(struct tcp_ao_hdr);
 	const struct tcphdr *th = tcp_hdr(skb);
 
-	if (maclen != tcp_ao_maclen(key))
+	if (maclen != tcp_ao_maclen(key)) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOBAD);
+		atomic64_inc(&info->counters.pkt_bad);
+		atomic64_inc(&key->pkt_bad);
 		return SKB_DROP_REASON_TCP_AOFAILURE;
+	}
 
 	/* XXX: make it per-AF callback? */
 	tcp_ao_hash_skb(family, newhash, key, sk, skb, traffic_key,
 			(phash - (u8 *)th), sne);
-	if (memcmp(phash, newhash, maclen))
+	if (memcmp(phash, newhash, maclen)) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOBAD);
+		atomic64_inc(&info->counters.pkt_bad);
+		atomic64_inc(&key->pkt_bad);
 		return SKB_DROP_REASON_TCP_AOFAILURE;
+	}
+	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOGOOD);
+	atomic64_inc(&info->counters.pkt_good);
+	atomic64_inc(&key->pkt_good);
 	return SKB_NOT_DROPPED_YET;
 }
 
@@ -691,8 +704,10 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 	u32 sne = 0;
 
 	info = rcu_dereference(tcp_sk(sk)->ao_info);
-	if (!info)
+	if (!info) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
 		return SKB_DROP_REASON_TCP_AOUNEXPECTED;
+	}
 
 	if (unlikely(th->syn)) {
 		sisn = th->seq;
@@ -787,6 +802,8 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 				  traffic_key, phash, sne);
 
 key_not_found:
+	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
+	atomic64_inc(&info->counters.key_not_found);
 	return SKB_DROP_REASON_TCP_AOKEYNOTFOUND;
 }
 EXPORT_SYMBOL_GPL(tcp_inbound_ao_hash);
@@ -1343,6 +1360,8 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 	key->keyflags	= cmd.keyflags;
 	key->sndid	= cmd.sndid;
 	key->rcvid	= cmd.rcvid;
+	atomic64_set(&key->pkt_good, 0);
+	atomic64_set(&key->pkt_bad, 0);
 
 	ret = tcp_ao_parse_crypto(&cmd, key);
 	if (ret < 0)
@@ -1554,7 +1573,7 @@ static int tcp_ao_info_cmd(struct sock *sk, unsigned short int family,
 			return -EINVAL;
 	}
 
-	if (cmd.reserved != 0)
+	if (cmd.reserved != 0 || cmd.reserved2 != 0)
 		return -EINVAL;
 
 	ao_info = rcu_dereference_protected(tcp_sk(sk)->ao_info,
@@ -1588,6 +1607,12 @@ static int tcp_ao_info_cmd(struct sock *sk, unsigned short int family,
 			goto out;
 		}
 	}
+	if (cmd.set_counters) {
+		atomic64_set(&ao_info->counters.pkt_good, cmd.pkt_good);
+		atomic64_set(&ao_info->counters.pkt_bad, cmd.pkt_bad);
+		atomic64_set(&ao_info->counters.key_not_found, cmd.pkt_key_not_found);
+		atomic64_set(&ao_info->counters.ao_required, cmd.pkt_ao_required);
+	}
 
 	ao_info->ao_required = cmd.ao_required;
 	if (new_current)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 63cd29d7e487..9f1c0ae0ba8c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1546,7 +1546,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	/* Don't allow keys for peers that have a matching TCP-AO key.
 	 * See the comment in tcp_ao_add_cmd()
 	 */
-	if (tcp_ao_required(sk, addr, AF_INET))
+	if (tcp_ao_required(sk, addr, AF_INET, false))
 		return -EKEYREJECTED;
 
 	return tcp_md5_do_add(sk, addr, AF_INET, prefixlen, l3index, flags,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 1e86b05a3b54..87fa80e20eba 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -663,7 +663,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 		/* Don't allow keys for peers that have a matching TCP-AO key.
 		 * See the comment in tcp_ao_add_cmd()
 		 */
-		if (tcp_ao_required(sk, addr, AF_INET))
+		if (tcp_ao_required(sk, addr, AF_INET, false))
 			return -EKEYREJECTED;
 		return tcp_md5_do_add(sk, addr,
 				      AF_INET, prefixlen, l3index, flags,
@@ -675,7 +675,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 	/* Don't allow keys for peers that have a matching TCP-AO key.
 	 * See the comment in tcp_ao_add_cmd()
 	 */
-	if (tcp_ao_required(sk, addr, AF_INET6))
+	if (tcp_ao_required(sk, addr, AF_INET6, false))
 		return -EKEYREJECTED;
 
 	return tcp_md5_do_add(sk, addr, AF_INET6, prefixlen, l3index, flags,
-- 
2.40.0

