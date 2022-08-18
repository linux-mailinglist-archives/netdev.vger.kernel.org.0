Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7696A5989F4
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345315AbiHRRDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345231AbiHRRA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:00:56 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F051DC2EBA
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:47 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id e20so1938481wri.13
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=iVbJUPjT1DQbISQ2LcniAEoL1U+YxrD/O962fTHv2S0=;
        b=N+Rk8D6+rkvejAUXREba+bpSaqDvZydR6lHT44pggi3thtq9BclbvzmcJ0uRocrB4L
         bDv6pSWoQapBvDpLxSxRD1AJAM3iy4neZXtgcyj7l9EVpcjKy588sueowyWzswrM/UcZ
         DCwfXxhVI0Htpr2GIxpuPkiVJPXyahAjytbIHGdFtGSAGcLxQsx67neHzb45yswzLBVF
         e4iqtQ8SnGRzdaSPMeDX5BbVGuiql4FtOmDD0j7lC4aUIM0WjGsvdIMU6blOn0UQIXzT
         QxQyVTh3xn5wpKci+9gpHZn/8luRzlvpKbycGpK9VaeLzKvtaiAQ+o+E6OiC0x294e99
         9xqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=iVbJUPjT1DQbISQ2LcniAEoL1U+YxrD/O962fTHv2S0=;
        b=MqPSKq7md5qjQog9aNFF3DPnqSxMkUDMqDi2TPeKTgzGCtt7YJjMKsF2CEXfCGh8ug
         RT16Oy0AzzyGUTIwT/xFqNfQob6uidCe9Y6rYj6VkXsbdq0ZPBTiDahmlvOoXWwyWZBZ
         O9YdFDyNBHfYIkwAqSs67Fen8g5r3ga9HIg2xeSb5PCFAcFBh+JFTJvDzQ9fdEhUrIXZ
         sBdwLM6WfAQPhfRpC4XeNCZENrgWDe7BOa7t+0dYA/dlfO5e/OAWTy/TO0pKzF1sffR9
         u6LGarKTeUU/NGSdLjSlpGzQ3a6s324SeFhl4YN/AgyUbFvLl7IDbuLKCZrQ6mTZJRVW
         V76A==
X-Gm-Message-State: ACgBeo2gnSlCKCQ8HhkpMdV2OvJrJe5AZ+5Q5iVjfBAX2raQD69/Suiz
        0xRoDjJfBee4dP9HZ7aUSGjlgQ==
X-Google-Smtp-Source: AA6agR7RMR2ob98gixb0r3CwoI0GrpxAoNzORRLkVCxuxDeSdHvWk7oC3tcrtTw+b9fccSNteDSifA==
X-Received: by 2002:a05:6000:1f0e:b0:221:6dd6:a2a3 with SMTP id bv14-20020a0560001f0e00b002216dd6a2a3mr2186446wrb.574.1660842047374;
        Thu, 18 Aug 2022 10:00:47 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:46 -0700 (PDT)
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
Subject: [PATCH 23/31] net/tcp: Add getsockopt(TCP_AO_GET)
Date:   Thu, 18 Aug 2022 17:59:57 +0100
Message-Id: <20220818170005.747015-24-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818170005.747015-1-dima@arista.com>
References: <20220818170005.747015-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 include/uapi/linux/tcp.h |  19 ++++
 net/ipv4/tcp.c           |  11 ++
 net/ipv4/tcp_ao.c        | 223 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 254 insertions(+)

diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 743a910ba508..b5088d4c5587 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -174,6 +174,7 @@ void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp);
 int tcp_ao_cache_traffic_keys(const struct sock *sk, struct tcp_ao_info *ao,
 			      struct tcp_ao_key *ao_key);
 bool tcp_ao_ignore_icmp(struct sock *sk, int type, int code);
+int tcp_ao_get_mkts(struct sock *sk, char __user *optval, int __user *optlen);
 enum skb_drop_reason tcp_inbound_ao_hash(struct sock *sk,
 			const struct sk_buff *skb, unsigned short int family,
 			const struct request_sock *req,
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index b60933ee2a27..453187d21da8 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -132,6 +132,7 @@ enum {
 #define TCP_AO			38	/* (Add/Set MKT) */
 #define TCP_AO_DEL		39	/* (Delete MKT) */
 #define TCP_AO_MOD		40	/* (Modify MKT) */
+#define TCP_AO_GET		41	/* (Get MKTs) */
 
 #define TCP_REPAIR_ON		1
 #define TCP_REPAIR_OFF		0
@@ -353,6 +354,10 @@ struct tcp_diag_md5sig {
 #define TCP_AO_CMDF_NEXT	(1 << 1)	/* Only checks field rcvid */
 #define TCP_AO_CMDF_ACCEPT_ICMP	(1 << 2)	/* Accept incoming ICMPs */
 
+#define TCP_AO_GET_CURR		TCP_AO_CMDF_CURR
+#define TCP_AO_GET_NEXT		TCP_AO_CMDF_NEXT
+#define TCP_AO_GET_ALL		(1 << 2)
+
 struct tcp_ao { /* setsockopt(TCP_AO) */
 	struct __kernel_sockaddr_storage tcpa_addr;
 	char	tcpa_alg_name[64];
@@ -382,6 +387,20 @@ struct tcp_ao_mod { /* setsockopt(TCP_AO_MOD) */
 	__u8	tcpa_rnext;
 } __attribute__((aligned(8)));
 
+struct tcp_ao_getsockopt { /* getsockopt(TCP_AO_GET) */
+	struct __kernel_sockaddr_storage addr;
+	__u8	sndid;
+	__u8	rcvid;
+	__u32	nkeys;
+	char	alg_name[64];
+	__u16	flags;
+	__u8	prefix;
+	__u8	maclen;
+	__u8	keyflags;
+	__u8	keylen;
+	__u8	key[TCP_AO_MAXKEYLEN];
+} __attribute__((aligned(8)));
+
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 3ef9d69fa561..aa5ce2c738f0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4376,6 +4376,17 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 			err = -EFAULT;
 		return err;
 	}
+#endif
+#ifdef CONFIG_TCP_AO
+	case TCP_AO_GET: {
+		int err;
+
+		lock_sock(sk);
+		err = tcp_ao_get_mkts(sk, optval, optlen);
+		release_sock(sk);
+
+		return err;
+	}
 #endif
 	default:
 		return -ENOPROTOOPT;
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 6e18a8cdee90..5ab16b857c29 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1423,6 +1423,8 @@ static bool tcp_ao_mkt_overlap_v6(struct tcp_ao *cmd,
 	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT | TCP_AO_CMDF_ACCEPT_ICMP)
 #define TCP_AO_CMDF_DEL_VALID						\
 	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT)
+#define TCP_AO_GETF_VALID						\
+	(TCP_AO_GET_ALL | TCP_AO_GET_CURR | TCP_AO_GET_NEXT)
 
 static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 			  sockptr_t optval, int optlen)
@@ -1699,3 +1701,224 @@ int tcp_v4_parse_ao(struct sock *sk, int cmd, sockptr_t optval, int optlen)
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
+int tcp_ao_copy_mkts_to_user(struct tcp_ao_info *ao_info,
+			     char __user *optval, int __user *optlen)
+{
+	struct tcp_ao_getsockopt opt_in;
+	struct tcp_ao_getsockopt opt_out;
+	struct tcp_ao_getsockopt __user *optval_in;
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
+	int optlen_out;
+	u8 prefix_in;
+	u16 port = 0;
+	bool copy_all, copy_current, copy_next;
+	int err;
+
+	if (get_user(user_len, optlen))
+		return -EFAULT;
+
+	if (user_len <= 0)
+		return -EINVAL;
+
+	memset(&opt_in, 0, sizeof(struct tcp_ao_getsockopt));
+	err = copy_struct_from_user(&opt_in, sizeof(struct tcp_ao_getsockopt),
+				    optval, user_len);
+	if (err < 0)
+		return err;
+
+	optval_in = (struct tcp_ao_getsockopt __user *)optval;
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
+			return -EINVAL;
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
+		crypto_pool_algo(key->crypto_pool_id, opt_out.alg_name, 64);
+
+		/* Copy key to user */
+		if (copy_to_user(optval, &opt_out, bytes_to_write))
+			return -EFAULT;
+		optval += user_len;
+		copied_keys++;
+	}
+
+	optlen_out = (int)sizeof(struct tcp_ao_getsockopt);
+	if (copy_to_user(optlen, &optlen_out, sizeof(int)))
+		return -EFAULT;
+
+	if (copy_to_user(&optval_in->nkeys, &matched_keys, sizeof(u32)))
+		return -EFAULT;
+
+	return 0;
+}
+
+int tcp_ao_get_mkts(struct sock *sk, char __user *optval, int __user *optlen)
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
2.37.2

