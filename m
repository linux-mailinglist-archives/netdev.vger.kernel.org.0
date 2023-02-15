Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44BB5698396
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjBOSgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjBOSf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:35:59 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D573CE36
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:34:21 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id z13so14022463wmp.2
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=56glGZIk8DVndoPnOZ1LZxON4qiQryUzSa5rkzkLnEg=;
        b=huUU9RDP0P7/VshnMi4S5ttTvf/I/uZ4K7cuNgNSvhPw2NrPpJZre4lUkHyJ9yKCcP
         uEy4NGXG65aUXB3RkWbliA/hp1IelN3EMwJPpVluEr770+UOMZNX9eStUu+xj+R2ZUZv
         vEmSOQANluxMs+nIDzQF62zRp1/iRYk8gVTf5gNA+a5TCcV/xBQzIqoOhTTLjKZ1Kno4
         Sr6nYKbJORzqkgAMwzk+G2ULXpuP467gCUUoZaHawBxrkmhnZ6/8ZGnop6yRNFqTbhsJ
         hNl0mrgiL6MBdcWJuT3NvZEeZYWIiU3Y4l1KN4xEDM4tj49XPVf/0GjZmLdDdysDAURn
         +muw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=56glGZIk8DVndoPnOZ1LZxON4qiQryUzSa5rkzkLnEg=;
        b=d/4OyMOdOGYr2cWVJb1M6EzKstF0ZIJgMyZwfmedAMAYHohTJQH+OyLa1PBruviz6t
         p6y2J1mZuitOkwbrbP/mWqFeNKYrWSH6wLvpCCGzFJz9g8oKW2YdKdz3GTifpCePjZR0
         xL37jGu/83qbP361vfI0FH2UgDAJHXwAgCR7tofiXeXb+ZQD5AvLzEheOyf8zp8FDj8r
         a+IzDcjVcFs5U/PYTjyIGPp8X3leEYN49gnnWRSl8LJApYgonOV2bpzcH+AKjdmNH5mZ
         bUi1MJKjwagzyEC0oFWmrM2Ro+4zpa8/eBhSqcJkUynHZ4Jq/z0ch4sH3KitLbHQ2UlD
         jcNg==
X-Gm-Message-State: AO0yUKUaTjoO9q2kHSoj8EYpd3NO0AJ04nqAgETSN6x2t9n8PFiuuZd/
        7u06qMWudjajeARbulqHaABcQQ==
X-Google-Smtp-Source: AK7set/VplH0NpwRvnAxScYqRmef+4VYSIg31Kn173o5XBfy2gj0x5nEYNsrIwqSZmi6Zc/VKlYuyg==
X-Received: by 2002:a05:600c:244e:b0:3df:57aa:db52 with SMTP id 14-20020a05600c244e00b003df57aadb52mr2919390wmr.4.1676486061170;
        Wed, 15 Feb 2023 10:34:21 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s9-20020a05600c45c900b003e00c9888besm3196306wmo.30.2023.02.15.10.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 10:34:20 -0800 (PST)
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
        netdev@vger.kernel.org
Subject: [PATCH v4 21/21] net/tcp-ao: Wire up l3index to TCP-AO
Date:   Wed, 15 Feb 2023 18:33:35 +0000
Message-Id: <20230215183335.800122-22-dima@arista.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215183335.800122-1-dima@arista.com>
References: <20230215183335.800122-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly how TCP_MD5SIG_FLAG_IFINDEX works for TCP-MD5,
TCP_AO_KEYF_IFINDEX is an AO-key flag that binds that MKT to a specified
by tcpa_ifinndex L3 interface. Similarly, without this flag the key will
work in the default VRF l3index = 0 for connections.
To prevent AO-keys from overlapping, it's restricted to add key B for a
socket that has key A, which have the same sndid/rcvid and one of
the following is true:
- !(A.keyflags & TCP_AO_KEYF_IFINDEX) or !(B.keyflags & TCP_AO_KEYF_IFINDEX)
  so that any key is non-bound to a VRF
- A.l3index == B.l3index
  both want to work for the same VRF

Additionally, it's restricted to match TCP-MD5 keys for the same peer
the following way:
|--------------|--------------------|----------------|---------------|
|              | MD5 key without    |     MD5 key    |    MD5 key    |
|              |     l3index        |    l3index=0   |   l3index=N   |
|--------------|--------------------|----------------|---------------|
|  TCP-AO key  |                    |                |               |
|  without     |       reject       |    reject      |   reject      |
|  l3index     |                    |                |               |
|--------------|--------------------|----------------|---------------|
|  TCP-AO key  |                    |                |               |
|  l3index=0   |       reject       |    reject      |   allow       |
|--------------|--------------------|----------------|---------------|
|  TCP-AO key  |                    |                |               |
|  l3index=N   |       reject       |    allow       |   reject      |
|--------------|--------------------|----------------|---------------|

This is done with the help of tcp_md5_do_lookup_any_l3index() to reject
adding AO key without TCP_AO_KEYF_IFINDEX if there's TCP-MD5 in any VRF.
This is important for case where sysctl_tcp_l3mdev_accept = 1
Similarly, for TCP-AO lookups tcp_ao_do_lookup() may be used with
l3index < 0, so that __tcp_ao_key_cmp() will match TCP-AO key in any VRF.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h     |  10 +--
 include/net/tcp_ao.h  |  17 +++--
 net/ipv4/syncookies.c |   6 +-
 net/ipv4/tcp_ao.c     | 162 +++++++++++++++++++++++++++++++-----------
 net/ipv4/tcp_ipv4.c   |  18 +++--
 net/ipv6/syncookies.c |   5 +-
 net/ipv6/tcp_ao.c     |  20 +++---
 net/ipv6/tcp_ipv6.c   |  24 +++++--
 8 files changed, 181 insertions(+), 81 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 7b1d8b05e3bc..1576c5a1f154 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2607,7 +2607,8 @@ tcp_inbound_hash(struct sock *sk, const struct request_sock *req,
 		 * always at least one current_key.
 		 */
 #ifdef CONFIG_TCP_AO
-		if (unlikely(tcp_ao_do_lookup(sk, saddr, family, -1, -1, 0))) {
+		if (unlikely(tcp_ao_do_lookup(sk, l3index, saddr,
+					      family, -1, -1, 0))) {
 			struct tcp_ao_info *ao_info;
 
 			ao_info = rcu_dereference_check(tcp_sk(sk)->ao_info,
@@ -2615,20 +2616,21 @@ tcp_inbound_hash(struct sock *sk, const struct request_sock *req,
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOREQUIRED);
 			atomic64_inc(&ao_info->counters.ao_required);
 			tcp_hash_fail("AO hash is required, but not found",
-					family, skb, "");
+				      family, skb, "L3 index %d", l3index);
 			return SKB_DROP_REASON_TCP_AONOTFOUND;
 		}
 #endif
 		if (unlikely(tcp_md5_do_lookup(sk, l3index, saddr, family))) {
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
-			tcp_hash_fail("MD5 Hash not found", family, skb, "");
+			tcp_hash_fail("MD5 Hash not found",
+				      family, skb, "L3 index %d", l3index);
 			return SKB_DROP_REASON_TCP_MD5NOTFOUND;
 		}
 		return SKB_NOT_DROPPED_YET;
 	}
 
 	if (aoh)
-		return tcp_inbound_ao_hash(sk, skb, family, req, aoh);
+		return tcp_inbound_ao_hash(sk, skb, family, req, l3index, aoh);
 
 	return tcp_inbound_md5_hash(sk, skb, saddr, daddr, family,
 				    l3index, md5_location);
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 253cf2719aed..b783af572c02 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -33,6 +33,7 @@ struct tcp_ao_key {
 	union tcp_ao_addr	addr;
 	u8			key[TCP_AO_MAXKEYLEN] __tcp_ao_key_align;
 	unsigned int		tcp_sigpool_id;
+	int			l3index;
 	u16			port;
 	u8			prefixlen;
 	u8			family;
@@ -177,9 +178,9 @@ bool tcp_ao_ignore_icmp(struct sock *sk, int type, int code);
 int tcp_ao_get_mkts(struct sock *sk, sockptr_t optval, sockptr_t optlen);
 enum skb_drop_reason tcp_inbound_ao_hash(struct sock *sk,
 			const struct sk_buff *skb, unsigned short int family,
-			const struct request_sock *req,
+			const struct request_sock *req, int l3index,
 			const struct tcp_ao_hdr *aoh);
-struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
+struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk, int l3index,
 				    const union tcp_ao_addr *addr,
 				    int family, int sndid, int rcvid, u16 port);
 int tcp_ao_hash_hdr(unsigned short family, char *ao_hash,
@@ -224,9 +225,6 @@ int tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 				 __be32 disn, bool send);
 int tcp_v6_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
 			   struct request_sock *req);
-struct tcp_ao_key *tcp_v6_ao_do_lookup(const struct sock *sk,
-				       const struct in6_addr *addr,
-				       int sndid, int rcvid);
 struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
 				    struct sock *addr_sk,
 				    int sndid, int rcvid);
@@ -245,12 +243,12 @@ void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb);
 void tcp_ao_connect_init(struct sock *sk);
 void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
 		      struct tcp_request_sock *treq,
-		      unsigned short int family);
+		      unsigned short int family, int l3index);
 #else /* CONFIG_TCP_AO */
 
 static inline void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
 		      struct tcp_request_sock *treq,
-		      unsigned short int family)
+		      unsigned short int family, int l3index)
 {
 }
 
@@ -261,13 +259,14 @@ static inline bool tcp_ao_ignore_icmp(struct sock *sk, int type, int code)
 
 static inline enum skb_drop_reason tcp_inbound_ao_hash(struct sock *sk,
 		const struct sk_buff *skb, unsigned short int family,
-		const struct request_sock *req, const struct tcp_ao_hdr *aoh)
+		const struct request_sock *req, int l3index,
+		const struct tcp_ao_hdr *aoh)
 {
 	return SKB_NOT_DROPPED_YET;
 }
 
 static inline struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
-		const union tcp_ao_addr *addr,
+		int l3index, const union tcp_ao_addr *addr,
 		int family, int sndid, int rcvid, u16 port)
 {
 	return NULL;
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 9e3d7083af7d..a994a3405a67 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -337,6 +337,7 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	struct rtable *rt;
 	__u8 rcv_wscale;
 	struct flowi4 fl4;
+	int l3index;
 	u32 tsoff = 0;
 
 	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies) ||
@@ -394,13 +395,14 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	treq->snt_synack	= 0;
 	treq->tfo_listener	= false;
 
-	tcp_ao_syncookie(sk, skb, treq, AF_INET);
-
 	if (IS_ENABLED(CONFIG_SMC))
 		ireq->smc_ok = 0;
 
 	ireq->ir_iif = inet_request_bound_dev_if(sk, skb);
 
+	l3index = l3mdev_master_ifindex_by_index(sock_net(sk), ireq->ir_iif);
+	tcp_ao_syncookie(sk, skb, treq, AF_INET, l3index);
+
 	/* We throwed the options of the initial SYN away, so we hope
 	 * the ACK carries the same options again (see RFC1122 4.2.3.8)
 	 */
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index adb25e42f64a..b58aad7a47a7 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -146,7 +146,7 @@ static inline int ipv4_prefix_cmp(const struct in_addr *addr1,
 	return ((addr1->s_addr & mask) > (addr2->s_addr & mask)) ? 1 : -1;
 }
 
-static int __tcp_ao_key_cmp(const struct tcp_ao_key *key,
+static int __tcp_ao_key_cmp(const struct tcp_ao_key *key, int l3index,
 			    const union tcp_ao_addr *addr, u8 prefixlen,
 			    int family, int sndid, int rcvid, u16 port)
 {
@@ -156,6 +156,10 @@ static int __tcp_ao_key_cmp(const struct tcp_ao_key *key,
 		return (key->rcvid > rcvid) ? 1 : -1;
 	if (port != 0 && key->port != 0 && port != key->port)
 		return (key->port > port) ? 1 : -1;
+	if (l3index >= 0 && (key->keyflags & TCP_AO_KEYF_IFINDEX)) {
+		if (key->l3index != l3index)
+			return (key->l3index > l3index) ? 1 : -1;
+	}
 
 	if (family == AF_UNSPEC)
 		return 0;
@@ -180,7 +184,7 @@ static int __tcp_ao_key_cmp(const struct tcp_ao_key *key,
 	return -1;
 }
 
-static int tcp_ao_key_cmp(const struct tcp_ao_key *key,
+static int tcp_ao_key_cmp(const struct tcp_ao_key *key, int l3index,
 			  const union tcp_ao_addr *addr, u8 prefixlen,
 			  int family, int sndid, int rcvid, u16 port)
 {
@@ -188,14 +192,16 @@ static int tcp_ao_key_cmp(const struct tcp_ao_key *key,
 	if (family == AF_INET6 && ipv6_addr_v4mapped(&addr->a6)) {
 		__be32 addr4 = addr->a6.s6_addr32[3];
 
-		return __tcp_ao_key_cmp(key, (union tcp_ao_addr *)&addr4,
+		return __tcp_ao_key_cmp(key, l3index,
+					(union tcp_ao_addr *)&addr4,
 					prefixlen, AF_INET, sndid, rcvid, port);
 	}
 #endif
-	return __tcp_ao_key_cmp(key, addr, prefixlen, family, sndid, rcvid, port);
+	return __tcp_ao_key_cmp(key, l3index, addr,
+				prefixlen, family, sndid, rcvid, port);
 }
 
-struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
+struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk, int l3index,
 				    const union tcp_ao_addr *addr,
 				    int family, int sndid, int rcvid, u16 port)
 {
@@ -211,7 +217,7 @@ struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 		return NULL;
 
 	hlist_for_each_entry_rcu(key, &ao->head, node) {
-		if (!tcp_ao_key_cmp(key, addr, key->prefixlen,
+		if (!tcp_ao_key_cmp(key, l3index, addr, key->prefixlen,
 				    family, sndid, rcvid, port))
 			return key;
 	}
@@ -690,41 +696,46 @@ struct tcp_ao_key *tcp_v4_ao_lookup_rsk(const struct sock *sk,
 					struct request_sock *req,
 					int sndid, int rcvid)
 {
-	union tcp_ao_addr *addr =
-			(union tcp_ao_addr *)&inet_rsk(req)->ir_rmt_addr;
+	struct inet_request_sock *ireq = inet_rsk(req);
+	union tcp_ao_addr *addr = (union tcp_ao_addr *)&ireq->ir_rmt_addr;
+	int l3index = l3mdev_master_ifindex_by_index(sock_net(sk), ireq->ir_iif);
 
-	return tcp_ao_do_lookup(sk, addr, AF_INET, sndid, rcvid, 0);
+	return tcp_ao_do_lookup(sk, l3index, addr, AF_INET, sndid, rcvid, 0);
 }
 
 struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 				    int sndid, int rcvid)
 {
 	union tcp_ao_addr *addr = (union tcp_ao_addr *)&addr_sk->sk_daddr;
+	int l3index = l3mdev_master_ifindex_by_index(sock_net(sk),
+						     addr_sk->sk_bound_dev_if);
 
-	return tcp_ao_do_lookup(sk, addr, AF_INET, sndid, rcvid, 0);
+	return tcp_ao_do_lookup(sk, l3index, addr, AF_INET, sndid, rcvid, 0);
 }
 
 static struct tcp_ao_key *tcp_ao_inbound_lookup(unsigned short int family,
 		const struct sock *sk, const struct sk_buff *skb,
-		int sndid, int rcvid)
+		int sndid, int rcvid, int l3index)
 {
 	if (family == AF_INET) {
 		const struct iphdr *iph = ip_hdr(skb);
 
-		return tcp_ao_do_lookup(sk, (union tcp_ao_addr *)&iph->saddr,
-				AF_INET, sndid, rcvid, 0);
+		return tcp_ao_do_lookup(sk, l3index,
+					(union tcp_ao_addr *)&iph->saddr,
+					AF_INET, sndid, rcvid, 0);
 	} else {
 		const struct ipv6hdr *iph = ipv6_hdr(skb);
 
-		return tcp_ao_do_lookup(sk, (union tcp_ao_addr *)&iph->saddr,
-				AF_INET6, sndid, rcvid, 0);
+		return tcp_ao_do_lookup(sk, l3index,
+					(union tcp_ao_addr *)&iph->saddr,
+					AF_INET6, sndid, rcvid, 0);
 	}
 }
 
 /* Returns maclen of requested key if found */
 void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
 		      struct tcp_request_sock *treq,
-		      unsigned short int family)
+		      unsigned short int family, int l3index)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
 	const struct tcp_ao_hdr *aoh;
@@ -739,7 +750,7 @@ void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
 	if (!aoh)
 		return;
 
-	key = tcp_ao_inbound_lookup(family, sk, skb, -1, aoh->keyid);
+	key = tcp_ao_inbound_lookup(family, sk, skb, -1, aoh->keyid, l3index);
 	if (!key)
 		/* Key not found, continue without TCP-AO */
 		return;
@@ -753,7 +764,7 @@ static enum skb_drop_reason
 tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
 		   unsigned short int family, struct tcp_ao_info *info,
 		   const struct tcp_ao_hdr *aoh, struct tcp_ao_key *key,
-		   u8 *traffic_key, u8 *phash, u32 sne)
+		   u8 *traffic_key, u8 *phash, u32 sne, int l3index)
 {
 	unsigned char newhash[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
 	u8 maclen = aoh->length - sizeof(struct tcp_ao_hdr);
@@ -764,7 +775,8 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
 		atomic64_inc(&info->counters.pkt_bad);
 		atomic64_inc(&key->pkt_bad);
 		tcp_hash_fail("AO hash wrong length", family, skb,
-			      " %u != %d", maclen, tcp_ao_maclen(key));
+			      " %u != %d L3index: %d", maclen,
+			      tcp_ao_maclen(key), l3index);
 		return SKB_DROP_REASON_TCP_AOFAILURE;
 	}
 
@@ -775,7 +787,8 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOBAD);
 		atomic64_inc(&info->counters.pkt_bad);
 		atomic64_inc(&key->pkt_bad);
-		tcp_hash_fail("AO hash mismatch", family, skb, "");
+		tcp_hash_fail("AO hash mismatch", family, skb,
+			      " L3index: %d", l3index);
 		return SKB_DROP_REASON_TCP_AOFAILURE;
 	}
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOGOOD);
@@ -787,7 +800,7 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
 enum skb_drop_reason
 tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 		    unsigned short int family, const struct request_sock *req,
-		    const struct tcp_ao_hdr *aoh)
+		    int l3index, const struct tcp_ao_hdr *aoh)
 {
 	u8 key_buf[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
 	const struct tcphdr *th = tcp_hdr(skb);
@@ -802,7 +815,7 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 	if (!info) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
 		tcp_hash_fail("AO key not found", family, skb,
-			      " keyid: %u", aoh->keyid);
+			      " keyid: %u L3index: %d", aoh->keyid, l3index);
 		return SKB_DROP_REASON_TCP_AOUNEXPECTED;
 	}
 
@@ -836,7 +849,7 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 		/* Established socket, traffic key are cached */
 		traffic_key = rcv_other_key(key);
 		err = tcp_ao_verify_hash(sk, skb, family, info, aoh, key,
-					 traffic_key, phash, sne);
+					 traffic_key, phash, sne, l3index);
 		if (err)
 			return err;
 		/* Key rotation: the peer asks us to use new key (RNext) */
@@ -856,7 +869,7 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 	 * - request sockets would race on those key pointers
 	 * - tcp_ao_del_cmd() allows async key removal
 	 */
-	key = tcp_ao_inbound_lookup(family, sk, skb, -1, aoh->keyid);
+	key = tcp_ao_inbound_lookup(family, sk, skb, -1, aoh->keyid, l3index);
 	if (!key)
 		goto key_not_found;
 
@@ -894,13 +907,13 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 	traffic_key = key_buf;
 	tcp_ao_calc_key_skb(key, traffic_key, skb, sisn, disn, family);
 	return tcp_ao_verify_hash(sk, skb, family, info, aoh, key,
-				  traffic_key, phash, sne);
+				  traffic_key, phash, sne, l3index);
 
 key_not_found:
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
 	atomic64_inc(&info->counters.key_not_found);
 	tcp_hash_fail("Requested by the peer AO key id not found",
-		      family, skb, "");
+		      family, skb, " L3index: %d", l3index);
 	return SKB_DROP_REASON_TCP_AOKEYNOTFOUND;
 }
 
@@ -927,7 +940,7 @@ void tcp_ao_connect_init(struct sock *sk)
 	struct tcp_ao_key *key;
 	struct tcp_sock *tp = tcp_sk(sk);
 	union tcp_ao_addr *addr;
-	int family;
+	int family, l3index;
 
 	ao_info = rcu_dereference_protected(tp->ao_info,
 					    lockdep_sock_is_held(sk));
@@ -944,9 +957,11 @@ void tcp_ao_connect_init(struct sock *sk)
 #endif
 	else
 		return;
+	l3index = l3mdev_master_ifindex_by_index(sock_net(sk),
+						 sk->sk_bound_dev_if);
 
 	hlist_for_each_entry_rcu(key, &ao_info->head, node) {
-		if (tcp_ao_key_cmp(key, addr, key->prefixlen, family,
+		if (tcp_ao_key_cmp(key, l3index, addr, key->prefixlen, family,
 				   -1, -1, sk->sk_dport) == 0)
 			continue;
 
@@ -1010,7 +1025,7 @@ int tcp_ao_copy_all_matching(const struct sock *sk, struct sock *newsk,
 	struct hlist_node *key_head;
 	union tcp_ao_addr *addr;
 	bool match = false;
-	int ret = -ENOMEM;
+	int l3index, ret = -ENOMEM;
 
 	ao = rcu_dereference(tcp_sk(sk)->ao_info);
 	if (!ao)
@@ -1036,9 +1051,11 @@ int tcp_ao_copy_all_matching(const struct sock *sk, struct sock *newsk,
 		ret = -EAFNOSUPPORT;
 		goto free_ao;
 	}
+	l3index = l3mdev_master_ifindex_by_index(sock_net(newsk),
+						 newsk->sk_bound_dev_if);
 
 	hlist_for_each_entry_rcu(key, &ao->head, node) {
-		if (tcp_ao_key_cmp(key, addr, key->prefixlen, family,
+		if (tcp_ao_key_cmp(key, l3index, addr, key->prefixlen, family,
 				   -1, -1, 0))
 			continue;
 
@@ -1352,6 +1369,11 @@ static bool tcp_ao_mkt_overlap_v4(struct tcp_ao *cmd,
 		if (key->sndid != sndid && key->rcvid != rcvid)
 			continue;
 
+		if (key->keyflags & TCP_AO_KEYF_IFINDEX &&
+		    cmd->tcpa_keyflags & TCP_AO_KEYF_IFINDEX &&
+		    key->l3index != cmd->tcpa_ifindex)
+			continue;
+
 		key_addr = key->addr.a4.s_addr;
 		mask = inet_make_mask(min(prefix, key->prefixlen));
 
@@ -1462,6 +1484,11 @@ static bool tcp_ao_mkt_overlap_v6(struct tcp_ao *cmd,
 		if (key->sndid != sndid && key->rcvid != rcvid)
 			continue;
 
+		if (key->keyflags & TCP_AO_KEYF_IFINDEX &&
+		    cmd->tcpa_keyflags & TCP_AO_KEYF_IFINDEX &&
+		    key->l3index != cmd->tcpa_ifindex)
+			continue;
+
 		key_addr = &key->addr.a6;
 
 		if (v4_mapped) {
@@ -1515,23 +1542,24 @@ static inline bool tcp_ao_mkt_overlap_v6(struct tcp_ao *cmd,
 }
 #endif
 
-#define TCP_AO_KEYF_ALL		(TCP_AO_KEYF_EXCLUDE_OPT)
+#define TCP_AO_KEYF_ALL (TCP_AO_KEYF_IFINDEX | TCP_AO_KEYF_EXCLUDE_OPT)
 #define TCP_AO_CMDF_ADDMOD_VALID					\
 	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT | TCP_AO_CMDF_ACCEPT_ICMP)
 #define TCP_AO_CMDF_DEL_VALID						\
 	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT | TCP_AO_CMDF_DEL_ASYNC)
 #define TCP_AO_GETF_VALID						\
 	(TCP_AO_GET_ALL | TCP_AO_GET_CURR | TCP_AO_GET_NEXT)
+#define TCP_AO_GET_KEYF_VALID	(TCP_AO_KEYF_IFINDEX)
 
 static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 			  sockptr_t optval, int optlen)
 {
 	struct tcp_ao_info *ao_info;
+	int ret, size, l3index = 0;
 	union tcp_md5_addr *addr;
 	struct tcp_ao_key *key;
 	bool first = false;
 	struct tcp_ao cmd;
-	int ret, size;
 	u16 port;
 
 	if (optlen < sizeof(cmd))
@@ -1560,9 +1588,33 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 	if (cmd.tcpa_keyflags & ~TCP_AO_KEYF_ALL)
 		return -EINVAL;
 
+	/* For cmd.tcp_ifindex = 0 the key will apply to the default VRF */
+	if (cmd.tcpa_keyflags & TCP_AO_KEYF_IFINDEX && cmd.tcpa_ifindex) {
+		struct net_device *dev;
+
+		rcu_read_lock();
+		dev = dev_get_by_index_rcu(sock_net(sk), cmd.tcpa_ifindex);
+		if (dev && netif_is_l3_master(dev))
+			l3index = dev->ifindex;
+		rcu_read_unlock();
+
+		if (!dev || !l3index)
+			return -EINVAL;
+	}
+
 	/* Don't allow keys for peers that have a matching TCP-MD5 key */
-	if (tcp_md5_do_lookup_any_l3index(sk, addr, family))
-		return -EKEYREJECTED;
+	if (cmd.tcpa_keyflags & TCP_AO_KEYF_IFINDEX) {
+		/* Non-_exact version of tcp_md5_do_lookup() will
+		 * as well match keys that aren't bound to a specific VRF
+		 * (that will make them match AO key with
+		 * sysctl_tcp_l3dev_accept = 1
+		 */
+		if (tcp_md5_do_lookup(sk, l3index, addr, family))
+			return -EKEYREJECTED;
+	} else {
+		if (tcp_md5_do_lookup_any_l3index(sk, addr, family))
+			return -EKEYREJECTED;
+	}
 
 	ao_info = rcu_dereference_protected(tcp_sk(sk)->ao_info,
 					    lockdep_sock_is_held(sk));
@@ -1602,6 +1654,7 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 	key->keyflags	= cmd.tcpa_keyflags;
 	key->sndid	= cmd.tcpa_sndid;
 	key->rcvid	= cmd.tcpa_rcvid;
+	key->l3index	= l3index;
 	atomic64_set(&key->pkt_good, 0);
 	atomic64_set(&key->pkt_bad, 0);
 
@@ -1692,17 +1745,17 @@ static int tcp_ao_delete_key(struct sock *sk, struct tcp_ao_key *key,
 	return err;
 }
 
+#define TCP_AO_DEL_KEYF_ALL (TCP_AO_KEYF_IFINDEX)
 static int tcp_ao_del_cmd(struct sock *sk, unsigned short int family,
 			  sockptr_t optval, int optlen)
 {
+	int err, addr_len, l3index = 0;
 	struct tcp_ao_info *ao_info;
 	struct tcp_ao_key *key;
 	struct tcp_ao_del cmd;
-	int err;
 	union tcp_md5_addr *addr;
 	__u8 prefix;
 	__be16 port;
-	int addr_len;
 
 	if (optlen < sizeof(cmd))
 		return -EINVAL;
@@ -1714,9 +1767,26 @@ static int tcp_ao_del_cmd(struct sock *sk, unsigned short int family,
 	if (cmd.tcpa_flags & ~TCP_AO_CMDF_DEL_VALID)
 		return -EINVAL;
 
+	if (cmd.tcpa_keyflags & ~TCP_AO_DEL_KEYF_ALL)
+		return -EINVAL;
+
 	if (cmd.reserved != 0)
 		return -EINVAL;
 
+	/* For cmd.tcp_ifindex = 0 the key will apply to the default VRF */
+	if (cmd.tcpa_keyflags & TCP_AO_KEYF_IFINDEX && cmd.tcpa_ifindex) {
+		struct net_device *dev;
+
+		rcu_read_lock();
+		dev = dev_get_by_index_rcu(sock_net(sk), cmd.tcpa_ifindex);
+		if (dev && netif_is_l3_master(dev))
+			l3index = dev->ifindex;
+		rcu_read_unlock();
+
+		if (!dev || !l3index)
+			return -EINVAL;
+	}
+
 	ao_info = rcu_dereference_protected(tcp_sk(sk)->ao_info,
 					    lockdep_sock_is_held(sk));
 	if (!ao_info)
@@ -1762,6 +1832,13 @@ static int tcp_ao_del_cmd(struct sock *sk, unsigned short int family,
 		    memcmp(addr, &key->addr, addr_len))
 			continue;
 
+		if ((cmd.tcpa_keyflags & TCP_AO_KEYF_IFINDEX) !=
+				(key->keyflags & TCP_AO_KEYF_IFINDEX))
+			continue;
+
+		if (key->l3index != l3index)
+			continue;
+
 		return tcp_ao_delete_key(sk, key, ao_info, &cmd);
 	}
 	return -ENOENT;
@@ -1878,7 +1955,7 @@ static int tcp_ao_copy_mkts_to_user(struct tcp_ao_info *ao_info,
 	u8 prefix_in;
 	u16 port = 0;
 	bool copy_all, copy_current, copy_next;
-	int err;
+	int err, l3index;
 
 	if (copy_from_sockptr(&user_len, optlen, sizeof(int)))
 		return -EFAULT;
@@ -1892,19 +1969,21 @@ static int tcp_ao_copy_mkts_to_user(struct tcp_ao_info *ao_info,
 	if (err < 0)
 		return err;
 
-	if (opt_in.reserved != 0)
-		return -EINVAL;
-
 	ss_family = opt_in.addr.ss_family;
 
 	BUILD_BUG_ON(TCP_AO_GET_ALL & (TCP_AO_GET_CURR | TCP_AO_GET_NEXT));
 	if (opt_in.flags & ~TCP_AO_GETF_VALID)
 		return -EINVAL;
+	if (opt_in.keyflags & ~TCP_AO_GET_KEYF_VALID)
+		return -EINVAL;
+	if (opt_in.ifindex < 0)
+		return -EINVAL;
 
 	max_keys = opt_in.nkeys;
 	copy_all = !!(opt_in.flags & TCP_AO_GET_ALL);
 	copy_current = !!(opt_in.flags & TCP_AO_GET_CURR);
 	copy_next = !!(opt_in.flags & TCP_AO_GET_NEXT);
+	l3index = (opt_in.keyflags & TCP_AO_KEYF_IFINDEX) ? opt_in.ifindex : -1;
 
 	if (!(copy_all || copy_current || copy_next)) {
 		prefix_in = opt_in.prefix;
@@ -1969,7 +2048,7 @@ static int tcp_ao_copy_mkts_to_user(struct tcp_ao_info *ao_info,
 			continue;
 		}
 
-		if (tcp_ao_key_cmp(key, addr, opt_in.prefix,
+		if (tcp_ao_key_cmp(key, l3index, addr, opt_in.prefix,
 				   opt_in.addr.ss_family,
 				   opt_in.sndid, opt_in.rcvid, port) != 0)
 			continue;
@@ -2005,6 +2084,7 @@ static int tcp_ao_copy_mkts_to_user(struct tcp_ao_info *ao_info,
 		opt_out.nkeys = 0;
 		opt_out.maclen = key->maclen;
 		opt_out.keylen = key->keylen;
+		opt_out.ifindex = key->l3index;
 		memcpy(&opt_out.key, key->key, key->keylen);
 		tcp_sigpool_algo(key->tcp_sigpool_id, opt_out.alg_name, 64);
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 64a81f1dd4d4..c1dcfc70930a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1093,6 +1093,7 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 	struct tcp_ao_key *ao_key = NULL;
 	const union tcp_md5_addr *addr;
 	u8 keyid = 0;
+	int l3index;
 #ifdef CONFIG_TCP_AO
 	u8 traffic_key[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
 	const struct tcp_ao_hdr *aoh;
@@ -1106,6 +1107,7 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 	u32 seq = (sk->sk_state == TCP_LISTEN) ? tcp_rsk(req)->snt_isn + 1 :
 					     tcp_sk(sk)->snd_nxt;
 	addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
+	l3index = tcp_v4_sdif(skb) ? inet_iif(skb) : 0;
 
 	if (tcp_rsk_used_ao(req)) {
 #ifdef CONFIG_TCP_AO
@@ -1116,11 +1118,11 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 		if (!aoh)
 			return;
 
-		ao_key = tcp_ao_do_lookup(sk, addr, AF_INET,
+		ao_key = tcp_ao_do_lookup(sk, l3index, addr, AF_INET,
 					  aoh->rnext_keyid, -1, 0);
 		if (unlikely(!ao_key)) {
 			/* Send ACK with any matching MKT for the peer */
-			ao_key = tcp_ao_do_lookup(sk, addr,
+			ao_key = tcp_ao_do_lookup(sk, l3index, addr,
 						  AF_INET, -1, -1, 0);
 			/* Matching key disappeared (user removed the key?)
 			 * let the handshake timeout.
@@ -1139,9 +1141,6 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 		tcp_v4_ao_calc_key_rsk(ao_key, traffic_key, req);
 #endif
 	} else {
-		int l3index;
-
-		l3index = tcp_v4_sdif(skb) ? inet_iif(skb) : 0;
 		md5_key = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
 	}
 	/* RFC 7323 2.3
@@ -1497,6 +1496,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	struct tcp_md5sig cmd;
 	struct sockaddr_in *sin = (struct sockaddr_in *)&cmd.tcpm_addr;
 	const union tcp_md5_addr *addr;
+	bool l3flag = false;
 	u8 prefixlen = 32;
 	int l3index = 0;
 	u8 flags;
@@ -1523,6 +1523,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	    cmd.tcpm_flags & TCP_MD5SIG_FLAG_IFINDEX) {
 		struct net_device *dev;
 
+		l3flag = true;
 		rcu_read_lock();
 		dev = dev_get_by_index_rcu(sock_net(sk), cmd.tcpm_ifindex);
 		if (dev && netif_is_l3_master(dev))
@@ -1545,8 +1546,11 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
 		return -EINVAL;
 
-	/* Don't allow keys for peers that have a matching TCP-AO key */
-	if (tcp_ao_do_lookup(sk, addr, AF_INET, -1, -1, 0))
+	/* Don't allow keys for peers that have a matching TCP-AO key.
+	 * See the comment in tcp_ao_add_cmd()
+	 */
+	if (tcp_ao_do_lookup(sk, l3flag ? l3index : -1, addr,
+			     AF_INET, -1, -1, 0))
 		return -EKEYREJECTED;
 
 	return tcp_md5_do_add(sk, addr, AF_INET, prefixlen, l3index, flags,
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index ad7a8caa7b2a..500f6ed3b8cf 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -140,6 +140,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	struct dst_entry *dst;
 	__u8 rcv_wscale;
 	u32 tsoff = 0;
+	int l3index;
 
 	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies) ||
 	    !th->ack || th->rst)
@@ -214,7 +215,9 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	treq->snt_isn = cookie;
 	treq->ts_off = 0;
 	treq->txhash = net_tx_rndhash();
-	tcp_ao_syncookie(sk, skb, treq, AF_INET6);
+
+	l3index = l3mdev_master_ifindex_by_index(sock_net(sk), ireq->ir_iif);
+	tcp_ao_syncookie(sk, skb, treq, AF_INET6, l3index);
 
 	if (IS_ENABLED(CONFIG_SMC))
 		ireq->smc_ok = 0;
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
index 77dfa706349c..ac24721b6b76 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -77,30 +77,28 @@ int tcp_v6_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
 			htonl(tcp_rsk(req)->rcv_isn));
 }
 
-struct tcp_ao_key *tcp_v6_ao_do_lookup(const struct sock *sk,
-				       const struct in6_addr *addr,
-				       int sndid, int rcvid)
-{
-	return tcp_ao_do_lookup(sk, (union tcp_ao_addr *)addr, AF_INET6,
-				sndid, rcvid, 0);
-}
-
 struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
 				    struct sock *addr_sk,
 				    int sndid, int rcvid)
 {
 	struct in6_addr *addr = &addr_sk->sk_v6_daddr;
+	int l3index = l3mdev_master_ifindex_by_index(sock_net(sk),
+						     addr_sk->sk_bound_dev_if);
 
-	return tcp_v6_ao_do_lookup(sk, addr, sndid, rcvid);
+	return tcp_ao_do_lookup(sk, l3index, (union tcp_ao_addr *)addr,
+				AF_INET6, sndid, rcvid, 0);
 }
 
 struct tcp_ao_key *tcp_v6_ao_lookup_rsk(const struct sock *sk,
 					struct request_sock *req,
 					int sndid, int rcvid)
 {
-	struct in6_addr *addr = &inet_rsk(req)->ir_v6_rmt_addr;
+	struct inet_request_sock *ireq = inet_rsk(req);
+	struct in6_addr *addr = &ireq->ir_v6_rmt_addr;
+	int l3index = l3mdev_master_ifindex_by_index(sock_net(sk), ireq->ir_iif);
 
-	return tcp_v6_ao_do_lookup(sk, addr, sndid, rcvid);
+	return tcp_ao_do_lookup(sk, l3index, (union tcp_ao_addr *)addr,
+				AF_INET6, sndid, rcvid, 0);
 }
 
 int tcp_v6_ao_hash_pseudoheader(struct tcp_sigpool *hp,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 5c5c8509a6e2..b71bb2cde63b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -606,6 +606,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 	struct tcp_md5sig cmd;
 	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)&cmd.tcpm_addr;
 	union tcp_ao_addr *addr;
+	bool l3flag = false;
 	int l3index = 0;
 	u8 prefixlen;
 	u8 flags;
@@ -635,6 +636,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 	    cmd.tcpm_flags & TCP_MD5SIG_FLAG_IFINDEX) {
 		struct net_device *dev;
 
+		l3flag = true;
 		rcu_read_lock();
 		dev = dev_get_by_index_rcu(sock_net(sk), cmd.tcpm_ifindex);
 		if (dev && netif_is_l3_master(dev))
@@ -663,8 +665,11 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 	if (ipv6_addr_v4mapped(&sin6->sin6_addr)) {
 		addr = (union tcp_md5_addr *)&sin6->sin6_addr.s6_addr32[3];
 
-		/* Don't allow keys for peers that have a matching TCP-AO key */
-		if (tcp_ao_do_lookup(sk, addr, AF_INET, -1, -1, 0))
+		/* Don't allow keys for peers that have a matching TCP-AO key.
+		 * See the comment in tcp_ao_add_cmd()
+		 */
+		if (tcp_ao_do_lookup(sk, l3flag ? l3index : -1, addr,
+				     AF_INET, -1, -1, 0))
 			return -EKEYREJECTED;
 		return tcp_md5_do_add(sk, addr,
 				      AF_INET, prefixlen, l3index, flags,
@@ -673,8 +678,11 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 
 	addr = (union tcp_md5_addr *)&sin6->sin6_addr;
 
-	/* Don't allow keys for peers that have a matching TCP-AO key */
-	if (tcp_ao_do_lookup(sk, addr, AF_INET6, -1, -1, 0))
+	/* Don't allow keys for peers that have a matching TCP-AO key.
+	 * See the comment in tcp_ao_add_cmd()
+	 */
+	if (tcp_ao_do_lookup(sk, l3flag ? l3index : -1, addr,
+			     AF_INET6, -1, -1, 0))
 		return -EKEYREJECTED;
 
 	return tcp_md5_do_add(sk, addr, AF_INET6, prefixlen, l3index, flags,
@@ -1260,10 +1268,14 @@ static void tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			return;
 		if (!aoh)
 			return;
-		ao_key = tcp_v6_ao_do_lookup(sk, addr, aoh->rnext_keyid, -1);
+		ao_key = tcp_ao_do_lookup(sk, l3index,
+					  (union tcp_ao_addr *)addr, AF_INET6,
+					  aoh->rnext_keyid, -1, 0);
 		if (unlikely(!ao_key)) {
 			/* Send ACK with any matching MKT for the peer */
-			ao_key = tcp_v6_ao_do_lookup(sk, addr, -1, -1);
+			ao_key = tcp_ao_do_lookup(sk, l3index,
+						  (union tcp_ao_addr *)addr,
+						  AF_INET6, -1, -1, 0);
 			/* Matching key disappeared (user removed the key?)
 			 * let the handshake timeout.
 			 */
-- 
2.39.1

