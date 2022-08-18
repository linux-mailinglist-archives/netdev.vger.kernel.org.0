Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3138E5989C9
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345422AbiHRRC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345445AbiHRRAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:00:51 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CD4C9E88
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:40 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k16so2408625wrx.11
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Vl3yGL/PUaCIxre193KL2lb6Hcy5Glf78MX+zPmFUzs=;
        b=Ie4SYam5PwhmHTZToBLLVZBDuFDHvvr32ZMUj4Q2syjfZlxLvU3X8grU2uxi4H+7+X
         TuLsYtHOTvEFIor/cOf3rI7hXWWxs+XGfLsGan85GUfF/2fbFx3LkOPW7wx3t5KfjIWr
         HSzQcvNHW06PcQG/DbDlMXnsDa2JuL5kaEX69Hlzs4DDa/QJmJJsyn3wzyMSYUlzQ0Fm
         VEdegkikb2njM2vu57PTUvTyCKpRUYzOM/c9eZg0S8G97Lo3DUg7sP3NvYRVlNxlDynx
         F6yjl2byasM02fdi2FlNaiGejGGpBUlOs1N8LPbig5RRFq8CHQvyCR3MHERZ/IHMlOeI
         S2bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Vl3yGL/PUaCIxre193KL2lb6Hcy5Glf78MX+zPmFUzs=;
        b=vnhI7hYzqZ0vdBRuQRWu0cyrivKN1zjX6C1OV5/aPtIu1r1gWx4j7PkKPSa2pjFnyk
         i9/wkf3F/I566aJulA4qsrp7Fq/TbdnIeMHhDLxGvzlAWD0xSirvz/SQ3LbPTjRi3+Oq
         Fhb7xbOMy391kLn1EmL3PmzoVkWQmDCZigEDky4iwXxcp6oah3EYpRvMVI1mw5R3ixxl
         KjwSUSQ5bNIOQQhTF+NX7yzhZt8fx3v9G6v2mTX8rSPCriSqz4YWte2eCopG5zM9vZzQ
         7zankU4swAgHgP6+u7UI21mYX3wGPC9HvxCaAYhqE5G5NX3M2mNeah1qLTU429VOmuNe
         bPRg==
X-Gm-Message-State: ACgBeo1JWKuwA0RtuOEQ64Ay0+RtUXvcnQmZUpqvjJ19v9z2g58RNS/p
        JlR5kf2R97Hh71KfgKhJzB+InQ==
X-Google-Smtp-Source: AA6agR6+5D0a9Xx14dQ7kPxF8PcZW9AFWmJ5SzJa/C+s7AY/zMXSCcX3So4yeHtKzO9g0xeou5lbzw==
X-Received: by 2002:a05:6000:18a2:b0:221:7db8:de02 with SMTP id b2-20020a05600018a200b002217db8de02mr2162370wri.132.1660842040330;
        Thu, 18 Aug 2022 10:00:40 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:39 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
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
Subject: [PATCH 18/31] net/tcp: Add TCP-AO segments counters
Date:   Thu, 18 Aug 2022 17:59:52 +0100
Message-Id: <20220818170005.747015-19-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818170005.747015-1-dima@arista.com>
References: <20220818170005.747015-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index b4906323b9a7..dd90cca282eb 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -81,17 +81,24 @@ enum skb_drop_reason {
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
index 2e75c542e7ed..94573219f58d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2538,8 +2538,15 @@ tcp_inbound_hash(struct sock *sk, const struct request_sock *req,
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
index 7cb802de49ba..dbeaa7d4e212 100644
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
index 0088a4c64d77..1b5a078adcf1 100644
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
index 10cd6af3c45f..3a33733a714d 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -216,6 +216,8 @@ struct tcp_ao_key *tcp_ao_copy_key(struct sock *sk, struct tcp_ao_key *key)
 	*new_key = *key;
 	INIT_HLIST_NODE(&new_key->node);
 	crypto_pool_add(new_key->crypto_pool_id);
+	atomic64_set(&new_key->pkt_good, 0);
+	atomic64_set(&new_key->pkt_bad, 0);
 
 	return new_key;
 }
@@ -656,14 +658,25 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
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
 
@@ -683,8 +696,10 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 	u32 sne;
 
 	info = rcu_dereference(tcp_sk(sk)->ao_info);
-	if (!info)
+	if (!info) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
 		return SKB_DROP_REASON_TCP_AOUNEXPECTED;
+	}
 
 	/* Fast-path */
 	/* TODO: fix fastopen and simultaneous open (TCPF_SYN_RECV) */
@@ -763,6 +778,8 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 				  traffic_key, phash, sne);
 
 key_not_found:
+	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
+	atomic64_inc(&info->counters.key_not_found);
 	return SKB_DROP_REASON_TCP_AOKEYNOTFOUND;
 }
 
@@ -1416,6 +1433,8 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 	key->keyflags	= cmd.tcpa_keyflags;
 	key->sndid	= cmd.tcpa_sndid;
 	key->rcvid	= cmd.tcpa_rcvid;
+	atomic64_set(&key->pkt_good, 0);
+	atomic64_set(&key->pkt_bad, 0);
 
 	ret = tcp_ao_parse_crypto(&cmd, key);
 	if (ret < 0)
-- 
2.37.2

