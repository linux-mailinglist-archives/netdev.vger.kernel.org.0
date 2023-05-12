Return-Path: <netdev+bounces-2283-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B773B700FBF
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 22:29:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67149281D55
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 20:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E94D14287;
	Fri, 12 May 2023 20:23:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAE52106C
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 20:23:48 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07605B93
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:23:45 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f315712406so334656575e9.0
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1683923024; x=1686515024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=grGYcygrN64epBs8iwiJz9lWKzw3WCoSHtx93r+Bs2w=;
        b=Knr8YiHH8W5SJQJH+OR8Wfz4896IURN/fX18VaAUL9Jg6BCQ8IbGltJaa7ZUvCW4Kh
         B81RBhmCr+hKxR8tK1vM7mqHareOljmii9KCXUwNs+mlyS7aKGkR4/GdR3ggphlvsHlz
         2s+vhNi45V4QhU1GIHjSbVANlixd90BrcynmvEzYwB9E+Dsu1yT3qsvhAWf0yuNunFs2
         98fC1mWPxJHM9a+BZSuhdoICYODTw7Y5KZRrkVZB6608bSvUrtq5tXmP6WuToqmoGb6S
         0b8LDjRtPK5JH91EeBSX0faHA+yoGYQocUyyn+1Qvoa2oUDJ01pVIsfEaFGj2r37C1FN
         kMgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683923024; x=1686515024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=grGYcygrN64epBs8iwiJz9lWKzw3WCoSHtx93r+Bs2w=;
        b=X+m3cxyFrZuPN37gL30Y8Fo7/lRPWuz0zq5C20IjRs6AD3AJVtq5OEhqh5Irosx3Hm
         LFmcabsRfA3Xbya09VldPZ9XLLdoh4buUgms9S+QVO8dmRXeX1ts2o/6riam+b2GPdI6
         LufGP+bXSfteeu8YAj6PStuApc3lFNl9t1AuMMaNGZntH5yKQIxTWNqwf5nchn7fdYpi
         uUA7BDiA2BKw/DTespuzDT61mH8m5M3TvvKXc0O4rnL1Nzv3Q+AdmoFgoPBKCfOjIj1u
         ivQA/fDemmYXnp+pB0x4tkG1NfARvBKrqO9ZBSv0vn1LbbFCvMo5XGNg0jjfrTdrv0bz
         5agg==
X-Gm-Message-State: AC+VfDx2g+8BEKCPTHBcn7ovflBsy5CzM2UFnT8Ue4FW2JIDcEeu4+Kj
	4sLgoW+FNBEZB706zrTOt/iGPg==
X-Google-Smtp-Source: ACHHUZ6Tt2fP65wBF+by00EbmshTp634Cuq2pd5jRBrxBacwTJZF0Xp4rxTDQj8hKp6z5tRHZIa2Qw==
X-Received: by 2002:a05:600c:3792:b0:3f1:6ead:e396 with SMTP id o18-20020a05600c379200b003f16eade396mr17143654wmr.17.1683923024045;
        Fri, 12 May 2023 13:23:44 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n9-20020a05600c294900b003f423508c6bsm17304527wmd.44.2023.05.12.13.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 13:23:43 -0700 (PDT)
From: Dmitry Safonov <dima@arista.com>
To: linux-kernel@vger.kernel.org,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <dima@arista.com>,
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
	netdev@vger.kernel.org
Subject: [PATCH v6 18/21] net/tcp: Add TCP-AO getsockopt()s
Date: Fri, 12 May 2023 21:23:08 +0100
Message-Id: <20230512202311.2845526-19-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230512202311.2845526-1-dima@arista.com>
References: <20230512202311.2845526-1-dima@arista.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Introduce getsockopt(TCP_AO_GET_KEYS) that lets a user get TCP-AO keys
and their properties from a socket. The user can provide a filter
to match the specific key to be dumped or ::get_all = 1 may be
used to dump all keys in one syscall.

Add another getsockopt(TCP_AO_INFO) for providing per-socket/per-ao_info
stats: packet counters, Current_key/RNext_key and flags like
::ao_required and ::accept_icmps.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp_ao.h     |  12 ++
 include/uapi/linux/tcp.h |  63 ++++++--
 net/ipv4/tcp.c           |  13 ++
 net/ipv4/tcp_ao.c        | 301 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 375 insertions(+), 14 deletions(-)

diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index a99521b78147..d1dcda8f81be 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -177,6 +177,8 @@ void tcp_ao_destroy_sock(struct sock *sk, bool twsk);
 u32 tcp_ao_compute_sne(u32 sne, u32 seq, u32 new_seq);
 void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp);
 bool tcp_ao_ignore_icmp(struct sock *sk, int type, int code);
+int tcp_ao_get_mkts(struct sock *sk, sockptr_t optval, sockptr_t optlen);
+int tcp_ao_get_sock_info(struct sock *sk, sockptr_t optval, sockptr_t optlen);
 enum skb_drop_reason tcp_inbound_ao_hash(struct sock *sk,
 			const struct sk_buff *skb, unsigned short int family,
 			const struct request_sock *req,
@@ -286,6 +288,16 @@ static inline void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw,
 static inline void tcp_ao_connect_init(struct sock *sk)
 {
 }
+
+static int tcp_ao_get_mkts(struct sock *sk, sockptr_t optval, sockptr_t optlen)
+{
+	return -ENOPROTOOPT;
+}
+
+static int tcp_ao_get_sock_info(struct sock *sk, sockptr_t optval, sockptr_t optlen)
+{
+	return -ENOPROTOOPT;
+}
 #endif
 
 #if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 3275ade3293a..1109093bbb24 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -131,7 +131,8 @@ enum {
 
 #define TCP_AO_ADD_KEY		38	/* Add/Set MKT */
 #define TCP_AO_DEL_KEY		39	/* Delete MKT */
-#define TCP_AO_INFO		40	/* Modify TCP-AO per-socket options */
+#define TCP_AO_INFO		40	/* Set/list TCP-AO per-socket options */
+#define TCP_AO_GET_KEYS		41	/* List MKT(s) */
 
 #define TCP_REPAIR_ON		1
 #define TCP_REPAIR_OFF		0
@@ -392,21 +393,55 @@ struct tcp_ao_del { /* setsockopt(TCP_AO_DEL_KEY) */
 	__u8	keyflags;		/* see TCP_AO_KEYF_ */
 } __attribute__((aligned(8)));
 
-struct tcp_ao_info_opt { /* setsockopt(TCP_AO_INFO) */
-	__u32   set_current	:1,	/* corresponding ::current_key */
-		set_rnext	:1,	/* corresponding ::rnext */
-		ao_required	:1,	/* don't accept non-AO connects */
-		set_counters	:1,	/* set/clear ::pkt_* counters */
-		accept_icmps	:1,	/* accept incoming ICMPs */
+struct tcp_ao_info_opt { /* setsockopt(TCP_AO_INFO), getsockopt(TCP_AO_INFO) */
+	/* Here 'in' is for setsockopt(), 'out' is for getsockopt() */
+	__u32   set_current	:1,	/* in/out: corresponding ::current_key */
+		set_rnext	:1,	/* in/out: corresponding ::rnext */
+		ao_required	:1,	/* in/out: don't accept non-AO connects */
+		set_counters	:1,	/* in: set/clear ::pkt_* counters */
+		accept_icmps	:1,	/* in/out: accept incoming ICMPs */
 		reserved	:27;	/* must be 0 */
 	__u16	reserved2;		/* padding, must be 0 */
-	__u8	current_key;		/* KeyID to set as Current_key */
-	__u8	rnext;			/* KeyID to set as Rnext_key */
-	__u64	pkt_good;		/* verified segments */
-	__u64	pkt_bad;		/* failed verification */
-	__u64	pkt_key_not_found;	/* could not find a key to verify */
-	__u64	pkt_ao_required;	/* segments missing TCP-AO sign */
-	__u64	pkt_dropped_icmp;	/* ICMPs that were ignored */
+	__u8	current_key;		/* in/out: KeyID of Current_key */
+	__u8	rnext;			/* in/out: keyid of RNext_key */
+	__u64	pkt_good;		/* in/out: verified segments */
+	__u64	pkt_bad;		/* in/out: failed verification */
+	__u64	pkt_key_not_found;	/* in/out: could not find a key to verify */
+	__u64	pkt_ao_required;	/* in/out: segments missing TCP-AO sign */
+	__u64	pkt_dropped_icmp;	/* in/out: ICMPs that were ignored */
+} __attribute__((aligned(8)));
+
+struct tcp_ao_getsockopt { /* getsockopt(TCP_AO_GET_KEYS) */
+	struct __kernel_sockaddr_storage addr;	/* in/out: dump keys for peer
+						 * with this address/prefix
+						 */
+	char	alg_name[64];		/* out: crypto hash algorithm */
+	__u8	key[TCP_AO_MAXKEYLEN];
+	__u32	nkeys;			/* in: size of the userspace buffer
+					 * @optval, measured in @optlen - the
+					 * sizeof(struct tcp_ao_getsockopt)
+					 * out: number of keys that matched
+					 */
+	__u16   is_current	:1,	/* in: match and dump Current_key,
+					 * out: the dumped key is Current_key
+					 */
+
+		is_rnext	:1,	/* in: match and dump RNext_key,
+					 * out: the dumped key is RNext_key
+					 */
+		get_all		:1,	/* in: dump all keys */
+		reserved	:13;	/* padding, must be 0 */
+	__u8	sndid;			/* in/out: dump keys with SendID */
+	__u8	rcvid;			/* in/out: dump keys with RecvID */
+	__u8	prefix;			/* in/out: dump keys with address/prefix */
+	__u8	maclen;			/* out: key's length of authentication
+					 * code (hash)
+					 */
+	__u8	keyflags;		/* in/out: see TCP_AO_KEYF_ */
+	__u8	keylen;			/* out: length of ::key */
+	__s32	ifindex;		/* in/out: L3 dev index for VRF */
+	__u64	pkt_good;		/* out: verified segments */
+	__u64	pkt_bad;		/* out: segments that failed verification */
 } __attribute__((aligned(8)));
 
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 77956937ada8..f613f011f2c8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4396,6 +4396,19 @@ int do_tcp_getsockopt(struct sock *sk, int level,
 		return err;
 	}
 #endif
+	case TCP_AO_GET_KEYS:
+	case TCP_AO_INFO: {
+		int err;
+
+		sockopt_lock_sock(sk);
+		if (optname == TCP_AO_GET_KEYS)
+			err = tcp_ao_get_mkts(sk, optval, optlen);
+		else
+			err = tcp_ao_get_sock_info(sk, optval, optlen);
+		sockopt_release_sock(sk);
+
+		return err;
+	}
 	default:
 		return -ENOPROTOOPT;
 	}
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 890f48a97490..b71f69afd409 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1724,3 +1724,304 @@ int tcp_v4_parse_ao(struct sock *sk, int cmd, sockptr_t optval, int optlen)
 	return tcp_parse_ao(sk, cmd, AF_INET, optval, optlen);
 }
 
+/* tcp_ao_copy_mkts_to_user(ao_info, optval, optlen)
+ *
+ * @ao_info:	struct tcp_ao_info on the socket that
+ *		socket getsockopt(TCP_AO_GET_KEYS) is executed on
+ * @optval:	pointer to array of tcp_ao_getsockopt structures in user space.
+ *		Must be != NULL.
+ * @optlen:	pointer to size of tcp_ao_getsockopt structure.
+ *		Must be != NULL.
+ *
+ * Return value: 0 on success, a negative error number otherwise.
+ *
+ * optval points to an array of tcp_ao_getsockopt structures in user space.
+ * optval[0] is used as both input and output to getsockopt. It determines
+ * which keys are returned by the kernel.
+ * optval[0].nkeys is the size of the array in user space. On return it contains
+ * the number of keys matching the search criteria.
+ * If tcp_ao_getsockopt::get_all is set, then all keys in the socket are
+ * returned, otherwise only keys matching <addr, prefix, sndid, rcvid>
+ * in optval[0] are returned.
+ * optlen is also used as both input and output. The user provides the size
+ * of struct tcp_ao_getsockopt in user space, and the kernel returns the size
+ * of the structure in kernel space.
+ * The size of struct tcp_ao_getsockopt may differ between user and kernel.
+ * There are three cases to consider:
+ *  * If usize == ksize, then keys are copied verbatim.
+ *  * If usize < ksize, then the userspace has passed an old struct to a
+ *    newer kernel. The rest of the trailing bytes in optval[0]
+ *    (ksize - usize) are interpreted as 0 by the kernel.
+ *  * If usize > ksize, then the userspace has passed a new struct to an
+ *    older kernel. The trailing bytes unknown to the kernel (usize - ksize)
+ *    are checked to ensure they are zeroed, otherwise -E2BIG is returned.
+ * On return the kernel fills in min(usize, ksize) in each entry of the array.
+ * The layout of the fields in the user and kernel structures is expected to
+ * be the same (including in the 32bit vs 64bit case).
+ */
+static int tcp_ao_copy_mkts_to_user(struct tcp_ao_info *ao_info,
+				    sockptr_t optval, sockptr_t optlen)
+{
+	struct tcp_ao_getsockopt opt_in, opt_out;
+	struct tcp_ao_key *key, *current_key;
+	bool do_address_matching = true;
+	union tcp_ao_addr *addr = NULL;
+	unsigned int max_keys;	/* maximum number of keys to copy to user */
+	size_t out_offset = 0;
+	size_t bytes_to_write;	/* number of bytes to write to user level */
+	int err, user_len;
+	u32 matched_keys;	/* keys from ao_info matched so far */
+	int optlen_out;
+	u16 port = 0;
+
+	if (copy_from_sockptr(&user_len, optlen, sizeof(int)))
+		return -EFAULT;
+
+	if (user_len <= 0)
+		return -EINVAL;
+
+	memset(&opt_in, 0, sizeof(struct tcp_ao_getsockopt));
+	err = copy_struct_from_sockptr(&opt_in, sizeof(opt_in),
+				       optval, user_len);
+	if (err < 0)
+		return err;
+
+	if (opt_in.pkt_good || opt_in.pkt_bad)
+		return -EINVAL;
+
+	if (opt_in.reserved != 0)
+		return -EINVAL;
+
+	max_keys = opt_in.nkeys;
+
+	if (opt_in.get_all || opt_in.is_current || opt_in.is_rnext) {
+		if (opt_in.get_all && (opt_in.is_current || opt_in.is_rnext))
+			return -EINVAL;
+		do_address_matching = false;
+	}
+
+	switch (opt_in.addr.ss_family) {
+	case AF_INET: {
+		struct sockaddr_in *sin;
+		__be32 mask;
+
+		sin = (struct sockaddr_in *)&opt_in.addr;
+		port = sin->sin_port;
+		addr = (union tcp_ao_addr *)&sin->sin_addr;
+
+		if (opt_in.prefix > 32)
+			return -EINVAL;
+
+		if (sin->sin_addr.s_addr == INADDR_ANY &&
+		    opt_in.prefix != 0)
+			return -EINVAL;
+
+		mask = inet_make_mask(opt_in.prefix);
+		if (sin->sin_addr.s_addr & ~mask)
+			return -EINVAL;
+
+		break;
+	}
+	case AF_INET6: {
+		struct sockaddr_in6 *sin6;
+		struct in6_addr *addr6;
+
+		sin6 = (struct sockaddr_in6 *)&opt_in.addr;
+		addr = (union tcp_ao_addr *)&sin6->sin6_addr;
+		addr6 = &sin6->sin6_addr;
+		port = sin6->sin6_port;
+
+		/* We don't have to change family and @addr here if
+		 * ipv6_addr_v4mapped() like in key adding:
+		 * tcp_ao_key_cmp() does it. Do the sanity checks though.
+		 */
+		if (opt_in.prefix != 0) {
+			if (ipv6_addr_v4mapped(addr6)) {
+				__be32 mask, addr4 = addr6->s6_addr32[3];
+
+				if (opt_in.prefix > 32 ||
+				    addr4 == INADDR_ANY)
+					return -EINVAL;
+				mask = inet_make_mask(opt_in.prefix);
+				if (addr4 & ~mask)
+					return -EINVAL;
+			} else {
+				struct in6_addr pfx;
+
+				if (ipv6_addr_any(addr6) ||
+				    opt_in.prefix > 128)
+					return -EINVAL;
+
+				ipv6_addr_prefix(&pfx, addr6, opt_in.prefix);
+				if (ipv6_addr_cmp(&pfx, addr6))
+					return -EINVAL;
+			}
+		} else if (!ipv6_addr_any(addr6)) {
+			return -EINVAL;
+		}
+		break;
+	}
+	case 0:
+		if (!do_address_matching)
+			break;
+		fallthrough;
+	default:
+		return -EAFNOSUPPORT;
+	}
+
+	if (!do_address_matching) {
+		/* We could just ignore those, but let's do stricter checks */
+		if (addr || port)
+			return -EINVAL;
+		if (opt_in.prefix || opt_in.sndid || opt_in.rcvid)
+			return -EINVAL;
+	}
+
+	bytes_to_write = min_t(int, user_len, sizeof(struct tcp_ao_getsockopt));
+	matched_keys = 0;
+	/* May change in RX, while we're dumping, pre-fetch it */
+	current_key = READ_ONCE(ao_info->current_key);
+
+	hlist_for_each_entry_rcu(key, &ao_info->head, node) {
+		if (opt_in.get_all)
+			goto match;
+
+		if (opt_in.is_current || opt_in.is_rnext) {
+			if (opt_in.is_current && key == current_key)
+				goto match;
+			if (opt_in.is_rnext && key == ao_info->rnext_key)
+				goto match;
+			continue;
+		}
+
+		if (tcp_ao_key_cmp(key, addr, opt_in.prefix,
+				   opt_in.addr.ss_family,
+				   opt_in.sndid, opt_in.rcvid, port) != 0)
+			continue;
+match:
+		matched_keys++;
+		if (matched_keys > max_keys)
+			continue;
+
+		memset(&opt_out, 0, sizeof(struct tcp_ao_getsockopt));
+
+		if (key->family == AF_INET) {
+			struct sockaddr_in *sin_out = (struct sockaddr_in *)&opt_out.addr;
+
+			sin_out->sin_family = key->family;
+			sin_out->sin_port = ntohs(key->port);
+			memcpy(&sin_out->sin_addr, &key->addr, sizeof(struct in_addr));
+		} else {
+			struct sockaddr_in6 *sin6_out = (struct sockaddr_in6 *)&opt_out.addr;
+
+			sin6_out->sin6_family = key->family;
+			sin6_out->sin6_port = ntohs(key->port);
+			memcpy(&sin6_out->sin6_addr, &key->addr, sizeof(struct in6_addr));
+		}
+		opt_out.sndid = key->sndid;
+		opt_out.rcvid = key->rcvid;
+		opt_out.prefix = key->prefixlen;
+		opt_out.keyflags = key->keyflags;
+		opt_out.is_current = (key == current_key);
+		opt_out.is_rnext = (key == ao_info->rnext_key);
+		opt_out.nkeys = 0;
+		opt_out.maclen = key->maclen;
+		opt_out.keylen = key->keylen;
+		opt_out.pkt_good = atomic64_read(&key->pkt_good);
+		opt_out.pkt_bad = atomic64_read(&key->pkt_bad);
+		memcpy(&opt_out.key, key->key, key->keylen);
+		tcp_sigpool_algo(key->tcp_sigpool_id, opt_out.alg_name, 64);
+
+		/* Copy key to user */
+		if (copy_to_sockptr_offset(optval, out_offset,
+					   &opt_out, bytes_to_write))
+			return -EFAULT;
+		out_offset += user_len;
+	}
+
+	optlen_out = (int)sizeof(struct tcp_ao_getsockopt);
+	if (copy_to_sockptr(optlen, &optlen_out, sizeof(int)))
+		return -EFAULT;
+
+	out_offset = offsetof(struct tcp_ao_getsockopt, nkeys);
+	if (copy_to_sockptr_offset(optval, out_offset,
+				   &matched_keys, sizeof(u32)))
+		return -EFAULT;
+
+	return 0;
+}
+
+int tcp_ao_get_mkts(struct sock *sk, sockptr_t optval, sockptr_t optlen)
+{
+	struct tcp_ao_info *ao_info;
+	u32 state;
+
+	/* Check socket state */
+	state = (1 << sk->sk_state) &
+		(TCPF_CLOSE | TCPF_ESTABLISHED | TCPF_LISTEN);
+	if (!state)
+		return -ESOCKTNOSUPPORT;
+
+	/* Check ao_info */
+	ao_info = rcu_dereference_protected(tcp_sk(sk)->ao_info,
+					    lockdep_sock_is_held(sk));
+	if (!ao_info)
+		return -ENOENT;
+
+	return tcp_ao_copy_mkts_to_user(ao_info, optval, optlen);
+}
+
+int tcp_ao_get_sock_info(struct sock *sk, sockptr_t optval, sockptr_t optlen)
+{
+	struct tcp_ao_info_opt out, in = {};
+	struct tcp_ao_key *current_key;
+	struct tcp_ao_info *ao;
+	int err, len;
+
+	if (copy_from_sockptr(&len, optlen, sizeof(int)))
+		return -EFAULT;
+
+	if (len <= 0)
+		return -EINVAL;
+
+	/* Copying this "in" only to check ::reserved, ::reserved2,
+	 * that may be needed to extend (struct tcp_ao_info_opt) and
+	 * what getsockopt() provides in future.
+	 */
+	err = copy_struct_from_sockptr(&in, sizeof(in), optval, len);
+	if (err)
+		return err;
+
+	if (in.reserved != 0 || in.reserved2 != 0)
+		return -EINVAL;
+
+	ao = rcu_dereference_protected(tcp_sk(sk)->ao_info,
+				       lockdep_sock_is_held(sk));
+	if (!ao)
+		return -ENOENT;
+
+	memset(&out, 0, sizeof(out));
+	out.ao_required		= ao->ao_required;
+	out.accept_icmps	= ao->accept_icmps;
+	out.pkt_good		= atomic64_read(&ao->counters.pkt_good);
+	out.pkt_bad		= atomic64_read(&ao->counters.pkt_bad);
+	out.pkt_key_not_found	= atomic64_read(&ao->counters.key_not_found);
+	out.pkt_ao_required	= atomic64_read(&ao->counters.ao_required);
+	out.pkt_dropped_icmp	= atomic64_read(&ao->counters.dropped_icmp);
+
+	current_key = READ_ONCE(ao->current_key);
+	if (current_key) {
+		out.set_current = 1;
+		out.current_key = current_key->sndid;
+	}
+	if (ao->rnext_key) {
+		out.set_rnext = 1;
+		out.rnext = ao->rnext_key->rcvid;
+	}
+
+	if (copy_to_sockptr(optval, &out, min_t(int, len, sizeof(out))))
+		return -EFAULT;
+
+	return 0;
+}
+
-- 
2.40.0


