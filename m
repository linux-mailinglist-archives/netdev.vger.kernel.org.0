Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4B3698369
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjBOSfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjBOSec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:34:32 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8209C3D936
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:34:08 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id az4-20020a05600c600400b003dff767a1f1so2237537wmb.2
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=scP6JjSblAzGBLe2yEjZOn4CG1v0Zg3RQofDKm7H7+s=;
        b=URH7MH+zWLa/MN+LHkXZGeiFXnRj5UKNCpgejx5r+akTD0JqycgdZIgXR1jC+fPPFM
         w2adUhfoks6q04HzkuWudrHkgS4PlJIMGSd7r1z/UXO66VhWa51+EHy4nT8mBkV4Trt4
         wZDvXxJ1iDEKETe2TY0ttDYIUSHkDde08KZPLe1pooqUtNik72FyTn0ElGA0diWpouiO
         CCAkAissJY7jnyqiJlKZObCMujDP9hyc6ZfhwBKISdpAWDKaAAN7O5fvx96TKdGHttv5
         Y/HsXq8EGjyP0g53X7wxO2aIG++dEq7X7K7d/f/k8QpUYvA58w6QF2OCntvr6taX1STj
         jo6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=scP6JjSblAzGBLe2yEjZOn4CG1v0Zg3RQofDKm7H7+s=;
        b=fONx4I4uvPoUWtuVyi3jUjkq/akE+rOPDb3aK+j1YgOar9cTf6Fqvn5K2ziLYI7muq
         h/L1jSyOAUkXNtAGuGPxDW4FK+yWG1370edfr3xLWby7iGGOxpryergi2yUyGAZ55avk
         wsrRj+jWzeUDgQMk/tDQNptONTke3KglC0Z9M565cTChUjM3csH8wl2HkwADhG905H14
         1CrSS/23Fo1cmj3/Bwj6T1a8ZkCuC3A1ihV5dPcF5DriEyc/eBqU3W+aOZD4ZGzzuvkA
         7BPrZQSzzEAGa0trvoAO0ljzhkM1xFZUGG6AGev3dq23KxXn9YfurI+wn3pI1bu4VIz3
         NKZA==
X-Gm-Message-State: AO0yUKUtu//cpuANxe+up+N2fy6uZOlxUEGa4QWGeRtLEf7EkRSRJanA
        EA3oEkLfM4gq3jD9K/I7QYMyiw==
X-Google-Smtp-Source: AK7set8yEsbmevqHD3PTB3f2JRhGaeA2+J0XMleUSbM20wITzAseh2FsGWNhNgJjKVb4jFwDyG3fgg==
X-Received: by 2002:a05:600c:4d15:b0:3dc:5937:35a2 with SMTP id u21-20020a05600c4d1500b003dc593735a2mr2854190wmp.9.1676486046773;
        Wed, 15 Feb 2023 10:34:06 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s9-20020a05600c45c900b003e00c9888besm3196306wmo.30.2023.02.15.10.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 10:34:06 -0800 (PST)
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
        Dan Carpenter <dan.carpenter@oracle.com>,
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
Subject: [PATCH v4 13/21] net/tcp: Add TCP-AO segments counters
Date:   Wed, 15 Feb 2023 18:33:27 +0000
Message-Id: <20230215183335.800122-14-dima@arista.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215183335.800122-1-dima@arista.com>
References: <20230215183335.800122-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
 include/net/tcp.h         |  9 ++++++++-
 include/net/tcp_ao.h      | 10 ++++++++++
 include/uapi/linux/snmp.h |  4 ++++
 net/ipv4/proc.c           |  4 ++++
 net/ipv4/tcp_ao.c         | 25 ++++++++++++++++++++++---
 6 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 848f4c5ab609..36b2e513ab25 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -153,17 +153,24 @@ enum skb_drop_reason {
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
index 3825b1352014..ff1680611530 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2600,8 +2600,15 @@ tcp_inbound_hash(struct sock *sk, const struct request_sock *req,
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
index fbd4e2f6afff..07d05bb49e46 100644
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
index 6600cb0164c2..55176bf83320 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -293,6 +293,10 @@ enum
 	LINUX_MIB_TCPMIGRATEREQSUCCESS,		/* TCPMigrateReqSuccess */
 	LINUX_MIB_TCPMIGRATEREQFAILURE,		/* TCPMigrateReqFailure */
 	LINUX_MIB_TCPPLBREHASH,			/* TCPPLBRehash */
+	LINUX_MIB_TCPAOREQUIRED,		/* TCPAORequired */
+	LINUX_MIB_TCPAOBAD,			/* TCPAOBad */
+	LINUX_MIB_TCPAOKEYNOTFOUND,		/* TCPAOKeyNotFound */
+	LINUX_MIB_TCPAOGOOD,			/* TCPAOGood */
 	__LINUX_MIB_MAX
 };
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index f88daace9de3..a4e012afd378 100644
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
index d541bc136ae7..d34ff3682cf8 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -186,6 +186,8 @@ static struct tcp_ao_key *tcp_ao_copy_key(struct sock *sk,
 	*new_key = *key;
 	INIT_HLIST_NODE(&new_key->node);
 	tcp_sigpool_get(new_key->tcp_sigpool_id);
+	atomic64_set(&new_key->pkt_good, 0);
+	atomic64_set(&new_key->pkt_bad, 0);
 
 	return new_key;
 }
@@ -687,14 +689,25 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
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
 
@@ -713,8 +726,10 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 	u32 sne = 0;
 
 	info = rcu_dereference(tcp_sk(sk)->ao_info);
-	if (!info)
+	if (!info) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
 		return SKB_DROP_REASON_TCP_AOUNEXPECTED;
+	}
 
 	if (unlikely(th->syn)) {
 		sisn = th->seq;
@@ -807,6 +822,8 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 				  traffic_key, phash, sne);
 
 key_not_found:
+	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
+	atomic64_inc(&info->counters.key_not_found);
 	return SKB_DROP_REASON_TCP_AOKEYNOTFOUND;
 }
 
@@ -1501,6 +1518,8 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 	key->keyflags	= cmd.tcpa_keyflags;
 	key->sndid	= cmd.tcpa_sndid;
 	key->rcvid	= cmd.tcpa_rcvid;
+	atomic64_set(&key->pkt_good, 0);
+	atomic64_set(&key->pkt_bad, 0);
 
 	ret = tcp_ao_parse_crypto(&cmd, key);
 	if (ret < 0)
-- 
2.39.1

