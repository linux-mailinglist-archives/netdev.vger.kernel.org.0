Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C4861033A
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237138AbiJ0Usd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236527AbiJ0UrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:47:25 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D394F923CC
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:44:22 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id a14so4174347wru.5
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yVvKx6rttXZkca0HaXrdqXjpHWYJcjtHtNTSTvO7FpY=;
        b=Ia827T2aSIcWAOc+9BbUNG5ygdPexvYQeIwBE+pbBwjvFfz8I3ze6DxS/XSWVhO6cP
         6KF5wtBa5QTeLS+9OEBRSdXzNw/E4lu/nqVz/nEGQ4WbP9NtSpvx1W3lghxYnZOpJPid
         tEVncbxb/wY2VEAkbPbcd6sFHRQHu/XjN4zDc/jQQv/1OepfvZgW0HhUKPI9k3vS0hqN
         nRvRlqD+U6ow38DSTktGGmateeUnXNyiO5HtsK5wmoYVLrqkc/DyAio5hFMZakxz06v6
         /gtO1dKCBd96BUWM3BLf0Wk7DP7OuEDAF/viGY006CRVTYsfzB7CEfDG5a2o/zabwNfz
         cjjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yVvKx6rttXZkca0HaXrdqXjpHWYJcjtHtNTSTvO7FpY=;
        b=X6M1YyaZrvKhm9H73NHUeJoIrbN3NQjNpK0UMGw6bwMt9Siw7P4miTjfR0yYQ1up/7
         T28Rx0HJstckcQLS+KkJNTjcZHhTm1r9TB8Uzlj8Izs5zfxJ92RajToW1BUysxwc6PaP
         XCZlIp6GOZ+eopaclq+dz914zRWrV1fCzX9M9OgPrUhfZMUAu68l8Cwesq1NrcG3nism
         Uc615qhhibckdVmQqiGMlvSxevComZ7ihwl+7VpF4sGaYXHH/b6yMXxYWDQ/y2gMQMMs
         1q4RnrzwMBjR0wsUWFkXsQ2wMrTV6NfNaM6vFX0QlYkCSW7vY8GTVRCWPqbPWDOcnhKW
         /WBA==
X-Gm-Message-State: ACrzQf0W2X8Aqtwbs1NNAgJmE6c9PPsgFb9WYGYTSCTRWxtj4/bCf4CG
        AYFnLMcKujHYQigzv6wT36eIsg==
X-Google-Smtp-Source: AMsMyM55XJR71DgHzmialAs0tN1phVZkJa0x01m6S86iT9hD+TFygCM3efrE837m2EMAHy8kSsjhVQ==
X-Received: by 2002:a5d:4f12:0:b0:22e:3920:a09c with SMTP id c18-20020a5d4f12000000b0022e3920a09cmr32216682wru.95.1666903462413;
        Thu, 27 Oct 2022 13:44:22 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:44:22 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 18/36] net/tcp: Add TCP-AO segments counters
Date:   Thu, 27 Oct 2022 21:43:29 +0100
Message-Id: <20221027204347.529913-19-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027204347.529913-1-dima@arista.com>
References: <20221027204347.529913-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 include/net/tcp.h         |  9 ++++++++-
 include/net/tcp_ao.h      | 10 ++++++++++
 include/uapi/linux/snmp.h |  4 ++++
 net/ipv4/proc.c           |  4 ++++
 net/ipv4/tcp_ao.c         | 25 ++++++++++++++++++++++---
 6 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 1359b15a53f3..bd92bb1a0d94 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -148,17 +148,24 @@ enum skb_drop_reason {
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
index 454401452a93..72a1fe015c57 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2548,8 +2548,15 @@ tcp_inbound_hash(struct sock *sk, const struct request_sock *req,
 		 * always at least one current_key.
 		 */
 #ifdef CONFIG_TCP_AO
-		if (unlikely(tcp_ao_do_lookup(sk, saddr, family, -1, -1, 0)))
+		if (unlikely(tcp_ao_do_lookup(sk, saddr, family, -1, -1, 0))) {
+			struct tcp_ao_info *ao_info;
+
+			ao_info = rcu_dereference_check(tcp_sk(sk)->ao_info,
+					lockdep_sock_is_held(sk));
+			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOREQUIRED);
+			atomic64_inc(&ao_info->counters.ao_required);
 			return SKB_DROP_REASON_TCP_AONOTFOUND;
+		}
 #endif
 		if (unlikely(tcp_md5_do_lookup(sk, l3index, saddr, family))) {
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 5eb4ae84b333..cc9925644118 100644
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
 
@@ -78,6 +87,7 @@ struct tcp_ao_info {
 	 */
 	struct tcp_ao_key	*volatile current_key;
 	struct tcp_ao_key	*rnext_key;
+	struct tcp_ao_counters	counters;
 	u8			ao_flags;
 	__be32			lisn;
 	__be32			risn;
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 4d7470036a8b..f09119db8b40 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -292,6 +292,10 @@ enum
 	LINUX_MIB_TCPDSACKIGNOREDDUBIOUS,	/* TCPDSACKIgnoredDubious */
 	LINUX_MIB_TCPMIGRATEREQSUCCESS,		/* TCPMigrateReqSuccess */
 	LINUX_MIB_TCPMIGRATEREQFAILURE,		/* TCPMigrateReqFailure */
+	LINUX_MIB_TCPAOREQUIRED,		/* TCPAORequired */
+	LINUX_MIB_TCPAOBAD,			/* TCPAOBad */
+	LINUX_MIB_TCPAOKEYNOTFOUND,		/* TCPAOKeyNotFound */
+	LINUX_MIB_TCPAOGOOD,			/* TCPAOGood */
 	__LINUX_MIB_MAX
 };
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 5386f460bd20..689957a81553 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -297,6 +297,10 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPDSACKIgnoredDubious", LINUX_MIB_TCPDSACKIGNOREDDUBIOUS),
 	SNMP_MIB_ITEM("TCPMigrateReqSuccess", LINUX_MIB_TCPMIGRATEREQSUCCESS),
 	SNMP_MIB_ITEM("TCPMigrateReqFailure", LINUX_MIB_TCPMIGRATEREQFAILURE),
+	SNMP_MIB_ITEM("TCPAORequired", LINUX_MIB_TCPAOREQUIRED),
+	SNMP_MIB_ITEM("TCPAOBad", LINUX_MIB_TCPAOBAD),
+	SNMP_MIB_ITEM("TCPAOKeyNotFound", LINUX_MIB_TCPAOKEYNOTFOUND),
+	SNMP_MIB_ITEM("TCPAOGood", LINUX_MIB_TCPAOGOOD),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 93bba5e791dd..cdd4e4ed69cf 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -222,6 +222,8 @@ static struct tcp_ao_key *tcp_ao_copy_key(struct sock *sk,
 	*new_key = *key;
 	INIT_HLIST_NODE(&new_key->node);
 	crypto_pool_add(new_key->crypto_pool_id);
+	atomic64_set(&new_key->pkt_good, 0);
+	atomic64_set(&new_key->pkt_bad, 0);
 
 	return new_key;
 }
@@ -702,14 +704,25 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
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
 
@@ -729,8 +742,10 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 	u32 sne = 0;
 
 	info = rcu_dereference(tcp_sk(sk)->ao_info);
-	if (!info)
+	if (!info) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
 		return SKB_DROP_REASON_TCP_AOUNEXPECTED;
+	}
 
 	/* Fast-path */
 	/* TODO: fix fastopen and simultaneous open (TCPF_SYN_RECV) */
@@ -821,6 +836,8 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 				  traffic_key, phash, sne);
 
 key_not_found:
+	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
+	atomic64_inc(&info->counters.key_not_found);
 	return SKB_DROP_REASON_TCP_AOKEYNOTFOUND;
 }
 
@@ -1497,6 +1514,8 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 	key->keyflags	= cmd.tcpa_keyflags;
 	key->sndid	= cmd.tcpa_sndid;
 	key->rcvid	= cmd.tcpa_rcvid;
+	atomic64_set(&key->pkt_good, 0);
+	atomic64_set(&key->pkt_bad, 0);
 
 	ret = tcp_ao_parse_crypto(&cmd, key);
 	if (ret < 0)
-- 
2.38.1

