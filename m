Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C85698389
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjBOSg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjBOSfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:35:41 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862533D08E
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:34:16 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id r18so14004420wmq.5
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r/VQdnYH46NbMmrwTqXavV51eMfPPXfb2u0jtaKfOjg=;
        b=Yiq3R37biK810S5TAiBmFo8HNfk5kQaEbA5+6uUJhgy4SgzaAn1Yumborg2N1P9WxY
         Z3filyZsmT48aMDJHWPgDAmv+0fQ3/evZ1QOJm/04LA45ucfQDkKMvGgs8KYX39N4RUB
         r51Fh9biGSvT2xF/zcbhcYc5fN96dyOHdXnW1aLkWMQlV5ehFyn29VEWFepV0+hE+O4U
         BLvzHWSkKXkWwjaFBWd3ieQWdbZ/0oyKuGKc/lNcxXKkfXxlrYUpPmrCtQ6+fTEDJnyq
         Ha3s/mFlbdcT30iEktCGZi+sRZDSzCNIcxML9sMpm7mYaKFy5Y5LLybv/lIW2BA/MK9m
         BCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r/VQdnYH46NbMmrwTqXavV51eMfPPXfb2u0jtaKfOjg=;
        b=FLCvB/TfDe8XwVc8CdleTqZYGHw3PmoFFKcdqeo0ukwO79E2TXPfc3hjUE9uxdG3P4
         IJkuKjaIbsXSUQehbgjRvHWgOUz6/Rj4CSOLMO+wbsvXtUNlBkdxSsopqNaqPCV/v0KQ
         XFuMbdjCa7q0xa7syXzXR+eN2+kHo5f4psM451Y9aKLEz11ok5aUpxr9NlbK/kELQ7zC
         nQtduwksJdNr1AYgm1UeMJHrpCDjC1c4AYpkZb8orJIuRbVqtnoAz2P1qVqsMIctrICI
         Dnl6Ta2xvlMI6NzSuw8v+tHlfvvuLfgvwikp+1pZh21zMR8gHYqLju8b7TcXz1aQK+kH
         0bOg==
X-Gm-Message-State: AO0yUKVwzIJ1LqhfK0a9Ft/lkjYRY49p/jH6fJinvEqOGzsf4X0KX/Ta
        9hf8+wNfQSK/uvuKor/Qbqp7WQ==
X-Google-Smtp-Source: AK7set/HiDnjESjdB4vTKqqqGD3B1Bzkha9ua8A+lj79URxSOOtKu2fnXD12F97dZ8MEyecBkfrTaA==
X-Received: by 2002:a05:600c:340a:b0:3df:e752:35ca with SMTP id y10-20020a05600c340a00b003dfe75235camr3357626wmp.32.1676486056072;
        Wed, 15 Feb 2023 10:34:16 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s9-20020a05600c45c900b003e00c9888besm3196306wmo.30.2023.02.15.10.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 10:34:15 -0800 (PST)
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
Subject: [PATCH v4 18/21] net/tcp: Add getsockopt(TCP_AO_GET)
Date:   Wed, 15 Feb 2023 18:33:32 +0000
Message-Id: <20230215183335.800122-19-dima@arista.com>
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

Introduce getsockopt() that let user get TCP-AO keys and their
properties from a socket. A user can provide a filter to match
a specific key to be dumped or TCP_AO_GET_ALL flag may be used to dump
all keys in one syscall.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp_ao.h     |   1 +
 include/uapi/linux/tcp.h |  20 ++++
 net/ipv4/tcp.c           |  11 ++
 net/ipv4/tcp_ao.c        | 228 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 260 insertions(+)

diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 01cdba46591c..04e3bcee05f7 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -172,6 +172,7 @@ void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp);
 int tcp_ao_cache_traffic_keys(const struct sock *sk, struct tcp_ao_info *ao,
 			      struct tcp_ao_key *ao_key);
 bool tcp_ao_ignore_icmp(struct sock *sk, int type, int code);
+int tcp_ao_get_mkts(struct sock *sk, sockptr_t optval, sockptr_t optlen);
 enum skb_drop_reason tcp_inbound_ao_hash(struct sock *sk,
 			const struct sk_buff *skb, unsigned short int family,
 			const struct request_sock *req,
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 323ee886634f..eaf77c0a4425 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -132,6 +132,7 @@ enum {
 #define TCP_AO			38	/* (Add/Set MKT) */
 #define TCP_AO_DEL		39	/* (Delete MKT) */
 #define TCP_AO_MOD		40	/* (Modify MKT) */
+#define TCP_AO_GET		41	/* (Get MKTs) */
 
 #define TCP_REPAIR_ON		1
 #define TCP_REPAIR_OFF		0
@@ -364,6 +365,10 @@ struct tcp_diag_md5sig {
 #define TCP_AO_CMDF_NEXT	(1 << 1)	/* Only checks field rcvid */
 #define TCP_AO_CMDF_ACCEPT_ICMP	(1 << 2)	/* Accept incoming ICMPs */
 
+#define TCP_AO_GET_CURR		TCP_AO_CMDF_CURR
+#define TCP_AO_GET_NEXT		TCP_AO_CMDF_NEXT
+#define TCP_AO_GET_ALL		(1 << 2)
+
 struct tcp_ao { /* setsockopt(TCP_AO) */
 	struct __kernel_sockaddr_storage tcpa_addr;
 	char	tcpa_alg_name[64];
@@ -398,6 +403,21 @@ struct tcp_ao_mod { /* setsockopt(TCP_AO_MOD) */
 	__u8	tcpa_rnext;
 } __attribute__((aligned(8)));
 
+struct tcp_ao_getsockopt { /* getsockopt(TCP_AO_GET) */
+	struct __kernel_sockaddr_storage addr;
+	char	alg_name[64];
+	__u8	key[TCP_AO_MAXKEYLEN];
+	__u32	nkeys;
+	__u16	flags;
+	__u8	sndid;
+	__u8	rcvid;
+	__u8	prefix;
+	__u8	maclen;
+	__u8	keyflags;
+	__u8	keylen;
+	__s32	ifindex;
+} __attribute__((aligned(8)));
+
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d59e7422a481..7c71e4299a60 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4391,6 +4391,17 @@ int do_tcp_getsockopt(struct sock *sk, int level,
 			err = -EFAULT;
 		return err;
 	}
+#endif
+#ifdef CONFIG_TCP_AO
+	case TCP_AO_GET: {
+		int err;
+
+		sockopt_lock_sock(sk);
+		err = tcp_ao_get_mkts(sk, optval, optlen);
+		sockopt_release_sock(sk);
+
+		return err;
+	}
 #endif
 	default:
 		return -ENOPROTOOPT;
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index d335023a1619..1cfcfab3e093 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1505,6 +1505,8 @@ static inline bool tcp_ao_mkt_overlap_v6(struct tcp_ao *cmd,
 	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT | TCP_AO_CMDF_ACCEPT_ICMP)
 #define TCP_AO_CMDF_DEL_VALID						\
 	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT)
+#define TCP_AO_GETF_VALID						\
+	(TCP_AO_GET_ALL | TCP_AO_GET_CURR | TCP_AO_GET_NEXT)
 
 static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 			  sockptr_t optval, int optlen)
@@ -1788,3 +1790,229 @@ int tcp_v4_parse_ao(struct sock *sk, int cmd, sockptr_t optval, int optlen)
 	return tcp_parse_ao(sk, cmd, AF_INET, optval, optlen);
 }
 
+/* tcp_ao_copy_mkts_to_user(ao_info, optval, optlen)
+ *
+ * @ao_info:	struct tcp_ao_info on the socket that
+ *		socket getsockopt(TCP_AO_GET) is executed on
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
+ * If TCP_AO_GET_ALL is set in "flags", then all keys in the socket are
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
+	struct tcp_ao_getsockopt opt_in;
+	struct tcp_ao_getsockopt opt_out;
+	int user_len;
+	unsigned int max_keys;	/* maximum number of keys to copy to user */
+	u32 copied_keys;	/* keys copied to user so far */
+	int matched_keys;	/* keys from ao_info matched so far */
+	int bytes_to_write;	/* number of bytes to write to user level */
+	struct tcp_ao_key *key;
+	struct sockaddr_in *sin;   /* (struct sockaddr_in *)&opt_in.addr */
+	struct sockaddr_in6 *sin6; /* (struct sockaddr_in6 *)&opt_in.addr */
+	struct in6_addr *addr6;    /* &sin6->sin6_addr */
+	__kernel_sa_family_t ss_family;
+	union tcp_ao_addr *addr;
+	size_t out_offset = 0;
+	int optlen_out;
+	u8 prefix_in;
+	u16 port = 0;
+	bool copy_all, copy_current, copy_next;
+	int err;
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
+	if (opt_in.reserved != 0)
+		return -EINVAL;
+
+	ss_family = opt_in.addr.ss_family;
+
+	BUILD_BUG_ON(TCP_AO_GET_ALL & (TCP_AO_GET_CURR | TCP_AO_GET_NEXT));
+	if (opt_in.flags & ~TCP_AO_GETF_VALID)
+		return -EINVAL;
+
+	max_keys = opt_in.nkeys;
+	copy_all = !!(opt_in.flags & TCP_AO_GET_ALL);
+	copy_current = !!(opt_in.flags & TCP_AO_GET_CURR);
+	copy_next = !!(opt_in.flags & TCP_AO_GET_NEXT);
+
+	if (!(copy_all || copy_current || copy_next)) {
+		prefix_in = opt_in.prefix;
+
+		switch (ss_family) {
+		case AF_INET: {
+			sin = (struct sockaddr_in *)&opt_in.addr;
+			port = sin->sin_port;
+			addr = (union tcp_ao_addr *)&sin->sin_addr;
+
+			if (prefix_in > 32)
+				return -EINVAL;
+
+			if (sin->sin_addr.s_addr == INADDR_ANY &&
+			    prefix_in != 0)
+				return -EINVAL;
+
+			break;
+		}
+		case AF_INET6: {
+			sin6 = (struct sockaddr_in6 *)&opt_in.addr;
+			addr = (union tcp_ao_addr *)&sin6->sin6_addr;
+			addr6 = &sin6->sin6_addr;
+			port = sin6->sin6_port;
+
+			if (prefix_in != 0) {
+				if (ipv6_addr_v4mapped(addr6)) {
+					__be32 addr4 = addr6->s6_addr32[3];
+
+					if (prefix_in > 32 ||
+					    addr4 == INADDR_ANY)
+						return -EINVAL;
+				} else {
+					if (ipv6_addr_any(addr6) ||
+					    prefix_in > 128)
+						return -EINVAL;
+				}
+			} else if (!ipv6_addr_any(addr6)) {
+				return -EINVAL;
+			}
+
+			break;
+		}
+		default:
+			return -EAFNOSUPPORT;
+		}
+	}
+
+	bytes_to_write = min(user_len, (int)sizeof(struct tcp_ao_getsockopt));
+	copied_keys = 0;
+	matched_keys = 0;
+
+	hlist_for_each_entry_rcu(key, &ao_info->head, node) {
+		if (copy_all)
+			goto match;
+
+		if (copy_current || copy_next) {
+			if (copy_current && key == ao_info->current_key)
+				goto match;
+			if (copy_next && key == ao_info->rnext_key)
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
+		if (copied_keys >= max_keys)
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
+		opt_out.flags = 0;
+		if (key == ao_info->current_key)
+			opt_out.flags |= TCP_AO_GET_CURR;
+		if (key == ao_info->rnext_key)
+			opt_out.flags |= TCP_AO_GET_NEXT;
+		opt_out.nkeys = 0;
+		opt_out.maclen = key->maclen;
+		opt_out.keylen = key->keylen;
+		memcpy(&opt_out.key, key->key, key->keylen);
+		tcp_sigpool_algo(key->tcp_sigpool_id, opt_out.alg_name, 64);
+
+		/* Copy key to user */
+		if (copy_to_sockptr_offset(optval, out_offset,
+					   &opt_out, bytes_to_write))
+			return -EFAULT;
+		out_offset += user_len;
+		copied_keys++;
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
-- 
2.39.1

