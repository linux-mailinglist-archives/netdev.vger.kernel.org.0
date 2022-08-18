Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B7A598997
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345266AbiHRRBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345379AbiHRRAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:00:37 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8510C7F86
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:25 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k16so2407769wrx.11
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Dq/USFzCEiBZjj7h90jqqSbylHQnOyq/ohhBdXrYBkE=;
        b=Pp4E+0wt84lr0sV/UxkwTyy8lIjy09e2G7EItQDW3xH1FoIU/ODBYD9sTyIuXjNx3D
         QCsNPn8t5YNYLfW2qTIzYJ8dEdO9cjbiQdM6LztlnzwkvmpoiZaFHCTDtV2ynaUFbko6
         U1IKsThOdGKx+WJq8xIgab0nLNesxV8KplrEQm+N+wqIkS77OTmY65dlDQosxnD+G/Ww
         EtX7anRpRWtYRj6lshQK+WQmI1UlFlQbR/nHFb/I6S5mJCFlpc5FBB708/9ew6eSo3kv
         lSi1eX961HXKrWfOR7qpig4wpe6fazoVjjdRTttHvwmw/Kd5isHvI9Cr7GKXyFpovs7M
         Nx1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Dq/USFzCEiBZjj7h90jqqSbylHQnOyq/ohhBdXrYBkE=;
        b=P1VDLIXYV/3f9T0taqDERrV/F6BoKzDeU07K1SIDc9YRWb8qRb65sINZOtarakAgC1
         CMpNEPRnn78CqPBnJx8CD0ita3tLDqezsibp+IvoXhGts43HFRClUAD2qSHjnT/NM1kl
         HnPIu2a5kqJKO5w6Zmt9JnFlD58sCeX4rEGBg4Nf9tAtqxKKmobhooahNB1aK+j6/rTZ
         c6RYvQq8iEZkLgSztYN716rFQzV8fHK4GWluH2PjP1LsWxPjOrYeb99623ROaOO2lga/
         iYNXaM9VnDEr6hUVqWLviSUUwQAQ5d3rkCPR80oJZB2gfGG/q4TYd5RfsLJhVxKKHjBp
         szWg==
X-Gm-Message-State: ACgBeo1Qsq3XB12hrjn3F32TpJggXo2clwjZ2rf9uknntt0YTUqph5UX
        aHDyF4MgluzLszNFP6pJMxxR6Q==
X-Google-Smtp-Source: AA6agR5lyK0/ZHEwMHBnjsOetJ4vQgTERbZ6jK1kKGjvfSTNEVZ52IWPBUd1kRip4S196O+kJen08A==
X-Received: by 2002:a5d:6b12:0:b0:21f:1568:c7e1 with SMTP id v18-20020a5d6b12000000b0021f1568c7e1mr2151720wrw.532.1660842025030;
        Thu, 18 Aug 2022 10:00:25 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:24 -0700 (PDT)
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
Subject: [PATCH 08/31] net/tcp: Introduce TCP_AO setsockopt()s
Date:   Thu, 18 Aug 2022 17:59:42 +0100
Message-Id: <20220818170005.747015-9-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818170005.747015-1-dima@arista.com>
References: <20220818170005.747015-1-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Add 3 setsockopt()s:
1. to add a new Master Key Tuple (MKT) on a socket
2. to delete present MKT from a socket
3. to change flags of an MKT

Userspace has to introduce keys on every socket it wants to use TCP-AO
option on, similarly to TCP_MD5SIG/TCP_MD5SIG_EXT.
RFC5925 prohibits definition of MKTs that would match the same peer,
so do sanity checks on the data provided by userspace. Be as
conservative as possible, including refusal of defining MKT on
an established connection with no AO, removing the key in-use and etc.

(1) and (2) are to be used by userspace key manager to add/remove keys.
(3) main purpose is to set rnext_key, which (as prescribed by RFC5925)
is the key id that will be requested in TCP-AO header from the peer to
sign their segments with.

At this moment the life of ao_info ends in tcp_v4_destroy_sock().

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/sockptr.h  |  23 ++
 include/net/tcp.h        |   6 +
 include/net/tcp_ao.h     |  15 +
 include/uapi/linux/tcp.h |  35 ++
 net/ipv4/Makefile        |   1 +
 net/ipv4/tcp.c           |  17 +
 net/ipv4/tcp_ao.c        | 828 +++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c      |   8 +-
 net/ipv6/Makefile        |   1 +
 net/ipv6/tcp_ao.c        |  20 +
 net/ipv6/tcp_ipv6.c      |  14 +-
 11 files changed, 965 insertions(+), 3 deletions(-)
 create mode 100644 net/ipv4/tcp_ao.c
 create mode 100644 net/ipv6/tcp_ao.c

diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
index d45902fb4cad..f42575ffda53 100644
--- a/include/linux/sockptr.h
+++ b/include/linux/sockptr.h
@@ -55,6 +55,29 @@ static inline int copy_from_sockptr(void *dst, sockptr_t src, size_t size)
 	return copy_from_sockptr_offset(dst, src, 0, size);
 }
 
+static inline int copy_struct_from_sockptr(void *dst, size_t ksize,
+		sockptr_t src, size_t usize)
+{
+	size_t size = min(ksize, usize);
+	size_t rest = max(ksize, usize) - size;
+
+	if (!sockptr_is_kernel(src))
+		return copy_struct_from_user(dst, ksize, src.user, size);
+
+	if (usize < ksize) {
+		memset(dst + size, 0, rest);
+	} else if (usize > ksize) {
+		char *p = src.kernel;
+
+		while (rest--) {
+			if (*p++)
+				return -E2BIG;
+		}
+	}
+	memcpy(dst, src.kernel, size);
+	return 0;
+}
+
 static inline int copy_to_sockptr_offset(sockptr_t dst, size_t offset,
 		const void *src, size_t size)
 {
diff --git a/include/net/tcp.h b/include/net/tcp.h
index b4b009094bf6..278d0ab81796 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2054,6 +2054,12 @@ struct tcp_sock_af_ops {
 				     sockptr_t optval,
 				     int optlen);
 #endif
+#ifdef CONFIG_TCP_AO
+	int			(*ao_parse)(struct sock *sk,
+					    int optname,
+					    sockptr_t optval,
+					    int optlen);
+#endif
 };
 
 struct tcp_request_sock_ops {
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 39b3fc31e5a1..6d0d30e5542b 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -87,4 +87,19 @@ struct tcp_ao_info {
 	u32			rcv_sne_seq;
 };
 
+#ifdef CONFIG_TCP_AO
+int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
+		 sockptr_t optval, int optlen);
+void tcp_ao_destroy_sock(struct sock *sk);
+/* ipv4 specific functions */
+int tcp_v4_parse_ao(struct sock *sk, int optname, sockptr_t optval, int optlen);
+/* ipv6 specific functions */
+int tcp_v6_parse_ao(struct sock *sk, int cmd,
+		    sockptr_t optval, int optlen);
+#else
+static inline void tcp_ao_destroy_sock(struct sock *sk)
+{
+}
+#endif
+
 #endif /* _TCP_AO_H */
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 849bbf2d3c38..5369458ae89f 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -129,6 +129,9 @@ enum {
 
 #define TCP_TX_DELAY		37	/* delay outgoing packets by XX usec */
 
+#define TCP_AO			38	/* (Add/Set MKT) */
+#define TCP_AO_DEL		39	/* (Delete MKT) */
+#define TCP_AO_MOD		40	/* (Modify MKT) */
 
 #define TCP_REPAIR_ON		1
 #define TCP_REPAIR_OFF		0
@@ -344,6 +347,38 @@ struct tcp_diag_md5sig {
 
 #define TCP_AO_MAXKEYLEN	80
 
+#define TCP_AO_CMDF_CURR	(1 << 0)	/* Only checks field sndid */
+#define TCP_AO_CMDF_NEXT	(1 << 1)	/* Only checks field rcvid */
+
+struct tcp_ao { /* setsockopt(TCP_AO) */
+	struct __kernel_sockaddr_storage tcpa_addr;
+	char	tcpa_alg_name[64];
+	__u16	tcpa_flags;
+	__u8	tcpa_prefix;
+	__u8	tcpa_sndid;
+	__u8	tcpa_rcvid;
+	__u8	tcpa_maclen;
+	__u8	tcpa_keyflags;
+	__u8	tcpa_keylen;
+	__u8	tcpa_key[TCP_AO_MAXKEYLEN];
+} __attribute__((aligned(8)));
+
+struct tcp_ao_del { /* setsockopt(TCP_AO_DEL) */
+	struct __kernel_sockaddr_storage tcpa_addr;
+	__u16	tcpa_flags;
+	__u8	tcpa_prefix;
+	__u8	tcpa_sndid;
+	__u8	tcpa_rcvid;
+	__u8	tcpa_current;
+	__u8	tcpa_rnext;
+} __attribute__((aligned(8)));
+
+struct tcp_ao_mod { /* setsockopt(TCP_AO_MOD) */
+	__u16	tcpa_flags;
+	__u8	tcpa_current;
+	__u8	tcpa_rnext;
+} __attribute__((aligned(8)));
+
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index bbdd9c44f14e..6d0b3e228b8a 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -67,6 +67,7 @@ obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
 		      xfrm4_output.o xfrm4_protocol.o
+obj-$(CONFIG_TCP_AO) += tcp_ao.o
 
 ifeq ($(CONFIG_BPF_JIT),y)
 obj-$(CONFIG_BPF_SYSCALL) += bpf_tcp_ca.o
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7c54b47e848f..85854b8afc47 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3704,6 +3704,23 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		__tcp_sock_set_quickack(sk, val);
 		break;
 
+#ifdef CONFIG_TCP_AO
+	case TCP_AO:
+	case TCP_AO_DEL:
+	case TCP_AO_MOD: {
+		u32 state = (1 << sk->sk_state) &
+			    (TCPF_CLOSE | TCPF_ESTABLISHED | TCPF_LISTEN);
+
+		if (!state || (state == TCPF_ESTABLISHED &&
+			       !rcu_dereference_protected(tcp_sk(sk)->ao_info,
+						lockdep_sock_is_held(sk))))
+			err = -EINVAL;
+		else
+			err = tp->af_specific->ao_parse(sk, optname, optval,
+							optlen);
+		break;
+	}
+#endif
 #ifdef CONFIG_TCP_MD5SIG
 	case TCP_MD5SIG:
 	case TCP_MD5SIG_EXT:
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
new file mode 100644
index 000000000000..7f53417ebdf7
--- /dev/null
+++ b/net/ipv4/tcp_ao.c
@@ -0,0 +1,828 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * INET		An implementation of the TCP Authentication Option (TCP-AO).
+ *		See RFC5925.
+ *
+ * Authors:	Dmitry Safonov <dima@arista.com>
+ *		Francesco Ruggeri <fruggeri@arista.com>
+ *		Salam Noureddine <noureddine@arista.com>
+ */
+#define pr_fmt(fmt) "TCP: " fmt
+
+#include <linux/inetdevice.h>
+#include <linux/tcp.h>
+#include <crypto/pool.h>
+
+#include <net/tcp.h>
+#include <net/ipv6.h>
+
+struct tcp_ao_key *tcp_ao_do_lookup_rcvid(struct sock *sk, u8 keyid)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_ao_key *key;
+	struct tcp_ao_info *ao;
+
+	ao = rcu_dereference_check(tp->ao_info, lockdep_sock_is_held(sk));
+
+	if (!ao)
+		return NULL;
+
+	hlist_for_each_entry_rcu(key, &ao->head, node) {
+		if (key->rcvid == keyid)
+			return key;
+	}
+	return NULL;
+}
+
+struct tcp_ao_key *tcp_ao_do_lookup_sndid(const struct sock *sk, u8 keyid)
+{
+	struct tcp_ao_key *key;
+	struct tcp_ao_info *ao;
+
+	ao = rcu_dereference_check(tcp_sk(sk)->ao_info,
+				   lockdep_sock_is_held(sk));
+	if (!ao)
+		return NULL;
+
+	hlist_for_each_entry_rcu(key, &ao->head, node) {
+		if (key->sndid == keyid)
+			return key;
+	}
+	return NULL;
+}
+
+static inline int ipv4_prefix_cmp(const struct in_addr *addr1,
+				  const struct in_addr *addr2,
+				  unsigned int prefixlen)
+{
+	__be32 mask = inet_make_mask(prefixlen);
+
+	if ((addr1->s_addr & mask) == (addr2->s_addr & mask))
+		return 0;
+	return ((addr1->s_addr & mask) > (addr2->s_addr & mask)) ? 1 : -1;
+}
+
+static int __tcp_ao_key_cmp(const struct tcp_ao_key *key,
+			    const union tcp_ao_addr *addr, u8 prefixlen,
+			    int family, int sndid, int rcvid, u16 port)
+{
+	if (sndid >= 0 && key->sndid != sndid)
+		return (key->sndid > sndid) ? 1 : -1;
+	if (rcvid >= 0 && key->rcvid != rcvid)
+		return (key->rcvid > rcvid) ? 1 : -1;
+	if (port != 0 && key->port != 0 && port != key->port)
+		return (key->port > port) ? 1 : -1;
+
+	if (family == AF_UNSPEC)
+		return 0;
+	if (key->family != family)
+		return (key->family > family) ? 1 : -1;
+
+	if (family == AF_INET) {
+		if (key->addr.a4.s_addr == INADDR_ANY)
+			return 0;
+		if (addr->a4.s_addr == INADDR_ANY)
+			return 0;
+		return ipv4_prefix_cmp(&key->addr.a4, &addr->a4, prefixlen);
+	} else {
+		if (ipv6_addr_any(&key->addr.a6) || ipv6_addr_any(&addr->a6))
+			return 0;
+		if (ipv6_prefix_equal(&key->addr.a6, &addr->a6, prefixlen))
+			return 0;
+		return memcmp(&key->addr.a6, &addr->a6, prefixlen);
+	}
+}
+
+int tcp_ao_key_cmp(const struct tcp_ao_key *key,
+		   const union tcp_ao_addr *addr, u8 prefixlen,
+		   int family, int sndid, int rcvid, u16 port)
+{
+	if (family == AF_INET6 && ipv6_addr_v4mapped(&addr->a6)) {
+		__be32 addr4 = addr->a6.s6_addr32[3];
+
+		return __tcp_ao_key_cmp(key, (union tcp_ao_addr *)&addr4,
+					prefixlen, AF_INET, sndid, rcvid, port);
+	}
+	return __tcp_ao_key_cmp(key, addr, prefixlen, family, sndid, rcvid, port);
+}
+
+struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
+				    const union tcp_ao_addr *addr,
+				    int family, int sndid, int rcvid, u16 port)
+{
+	struct tcp_ao_key *key;
+	struct tcp_ao_info *ao;
+
+	ao = rcu_dereference_check(tcp_sk(sk)->ao_info,
+				   lockdep_sock_is_held(sk));
+	if (!ao)
+		return NULL;
+
+	hlist_for_each_entry_rcu(key, &ao->head, node) {
+		if (!tcp_ao_key_cmp(key, addr, key->prefixlen,
+				    family, sndid, rcvid, port))
+			return key;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(tcp_ao_do_lookup);
+
+static struct tcp_ao_info *tcp_ao_alloc_info(gfp_t flags,
+		struct tcp_ao_info *cloned_from)
+{
+	struct tcp_ao_info *ao;
+
+	ao = kzalloc(sizeof(*ao), flags);
+	if (!ao)
+		return NULL;
+	INIT_HLIST_HEAD(&ao->head);
+
+	if (cloned_from)
+		ao->ao_flags = cloned_from->ao_flags;
+	return ao;
+}
+
+void tcp_ao_link_mkt(struct tcp_ao_info *ao, struct tcp_ao_key *mkt)
+{
+	hlist_add_head_rcu(&mkt->node, &ao->head);
+}
+
+static void tcp_ao_key_free_rcu(struct rcu_head *head)
+{
+	struct tcp_ao_key *key = container_of(head, struct tcp_ao_key, rcu);
+
+	crypto_pool_release(key->crypto_pool_id);
+	kfree(key);
+}
+
+void tcp_ao_destroy_sock(struct sock *sk)
+{
+	struct tcp_ao_info *ao;
+	struct tcp_ao_key *key;
+	struct hlist_node *n;
+
+	ao = rcu_dereference_protected(tcp_sk(sk)->ao_info, 1);
+	tcp_sk(sk)->ao_info = NULL;
+
+	if (!ao)
+		return;
+
+	hlist_for_each_entry_safe(key, n, &ao->head, node) {
+		hlist_del_rcu(&key->node);
+		atomic_sub(tcp_ao_sizeof_key(key), &sk->sk_omem_alloc);
+		call_rcu(&key->rcu, tcp_ao_key_free_rcu);
+	}
+
+	kfree_rcu(ao, rcu);
+}
+
+static int tcp_ao_current_rnext(struct sock *sk, u16 tcpa_flags,
+				u8 tcpa_sndid, u8 tcpa_rcvid)
+{
+	struct tcp_ao_info *ao_info;
+	struct tcp_ao_key *key;
+
+	ao_info = rcu_dereference_protected(tcp_sk(sk)->ao_info,
+					    lockdep_sock_is_held(sk));
+	if ((tcpa_flags & (TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT)) && !ao_info)
+		return -EINVAL;
+
+	if (tcpa_flags & TCP_AO_CMDF_CURR) {
+		key = tcp_ao_do_lookup_sndid(sk, tcpa_sndid);
+		if (!key)
+			return -ENOENT;
+		if (ao_info->current_key != key)
+			WRITE_ONCE(ao_info->current_key, key);
+	}
+
+	if (tcpa_flags & TCP_AO_CMDF_NEXT) {
+		key = tcp_ao_do_lookup_rcvid(sk, tcpa_rcvid);
+		if (!key)
+			return -ENOENT;
+		if (ao_info->rnext_key != key)
+			WRITE_ONCE(ao_info->rnext_key, key);
+	}
+
+	return 0;
+}
+
+static int tcp_ao_verify_port(struct sock *sk, u16 port)
+{
+	struct inet_sock *inet = inet_sk(sk);
+
+	if (port != 0) /* FIXME */
+		return -EINVAL;
+
+	/* Check that MKT port is consistent with socket */
+	if (port != 0 && inet->inet_dport != 0 && port != inet->inet_dport)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int tcp_ao_verify_ipv4(struct sock *sk, struct tcp_ao *cmd,
+			      union tcp_md5_addr **addr, u16 *port)
+{
+	struct sockaddr_in *sin = (struct sockaddr_in *)&cmd->tcpa_addr;
+	struct inet_sock *inet = inet_sk(sk);
+
+	if (sin->sin_family != AF_INET)
+		return -EINVAL;
+
+	if (tcp_ao_verify_port(sk, ntohs(sin->sin_port)))
+		return -EINVAL;
+
+	/* Check prefix and trailing 0's in addr */
+	if (cmd->tcpa_prefix != 0) {
+		__be32 mask;
+
+		if (sin->sin_addr.s_addr == INADDR_ANY)
+			return -EINVAL;
+		if (cmd->tcpa_prefix > 32)
+			return -EINVAL;
+
+		mask = inet_make_mask(cmd->tcpa_prefix);
+		if (sin->sin_addr.s_addr & ~mask)
+			return -EINVAL;
+
+		/* Check that MKT address is consistent with socket */
+		if (inet->inet_daddr != INADDR_ANY &&
+		    (inet->inet_daddr & mask) != sin->sin_addr.s_addr)
+			return -EINVAL;
+	} else {
+		if (sin->sin_addr.s_addr != INADDR_ANY)
+			return -EINVAL;
+	}
+
+	*addr = (union tcp_md5_addr *)&sin->sin_addr;
+	*port = ntohs(sin->sin_port);
+	return 0;
+}
+
+static int tcp_ao_verify_ipv6(struct sock *sk, struct tcp_ao *cmd,
+			      union tcp_md5_addr **paddr, u16 *port,
+			      unsigned short int *family)
+{
+	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)&cmd->tcpa_addr;
+	struct in6_addr *addr = &sin6->sin6_addr;
+	u8 prefix = cmd->tcpa_prefix;
+
+	if (sin6->sin6_family != AF_INET6)
+		return -EINVAL;
+	/* Not supposed to happen: here from af-specific callback */
+	if (WARN_ON_ONCE(!sk_fullsock(sk)))
+		return -EINVAL;
+
+	if (tcp_ao_verify_port(sk, ntohs(sin6->sin6_port)))
+		return -EINVAL;
+
+	/* Check prefix and trailing 0's in addr */
+	if (cmd->tcpa_prefix != 0 && ipv6_addr_v4mapped(addr)) {
+		__be32 addr4 = addr->s6_addr32[3];
+		__be32 mask;
+
+		if (prefix > 32 || addr4 == INADDR_ANY)
+			return -EINVAL;
+
+		mask = inet_make_mask(prefix);
+		if (addr4 & ~mask)
+			return -EINVAL;
+
+		/* Check that MKT address is consistent with socket */
+		if (!ipv6_addr_any(&sk->sk_v6_daddr)) {
+			__be32 daddr4 = sk->sk_v6_daddr.s6_addr32[3];
+
+			if (!ipv6_addr_v4mapped(&sk->sk_v6_daddr))
+				return -EINVAL;
+			if ((daddr4 & mask) != addr4)
+				return -EINVAL;
+		}
+
+		*paddr = (union tcp_md5_addr *)&addr->s6_addr32[3];
+		*family = AF_INET;
+		*port = ntohs(sin6->sin6_port);
+		return 0;
+	} else if (cmd->tcpa_prefix != 0) {
+		struct in6_addr pfx;
+
+		if (ipv6_addr_any(addr) || prefix > 128)
+			return -EINVAL;
+
+		ipv6_addr_prefix(&pfx, addr, prefix);
+		if (ipv6_addr_cmp(&pfx, addr))
+			return -EINVAL;
+
+		/* Check that MKT address is consistent with socket */
+		if (!ipv6_addr_any(&sk->sk_v6_daddr) &&
+		    !ipv6_prefix_equal(&sk->sk_v6_daddr, addr, prefix))
+
+			return -EINVAL;
+	} else {
+		if (!ipv6_addr_any(addr))
+			return -EINVAL;
+	}
+
+	*paddr = (union tcp_md5_addr *)addr;
+	*port = ntohs(sin6->sin6_port);
+	return 0;
+}
+
+static int tcp_ao_parse_crypto(struct tcp_ao *cmd, struct tcp_ao_key *key)
+{
+	unsigned int syn_tcp_option_space;
+	struct crypto_pool_ahash hp;
+	bool is_kdf_aes_128_cmac = false;
+	struct crypto_ahash *tfm;
+	int err, pool_id;
+
+	/* Force null-termination of tcpa_alg_name */
+	cmd->tcpa_alg_name[ARRAY_SIZE(cmd->tcpa_alg_name) - 1] = '\0';
+
+	/* RFC5926, 3.1.1.2. KDF_AES_128_CMAC */
+	if (!strcmp("cmac(aes128)", cmd->tcpa_alg_name)) {
+		strcpy(cmd->tcpa_alg_name, "cmac(aes)");
+		is_kdf_aes_128_cmac = (cmd->tcpa_keylen != 16);
+	}
+
+	key->maclen = cmd->tcpa_maclen ?: 12; /* 12 is the default in RFC5925 */
+
+	/* Check: maclen + tcp-ao header <= (MAX_TCP_OPTION_SPACE - mss
+	 *					- tstamp - wscale - sackperm),
+	 * see tcp_syn_options(), tcp_synack_options(), commit 33ad798c924b.
+	 *
+	 * In order to allow D-SACK with TCP-AO, the header size should be:
+	 * (MAX_TCP_OPTION_SPACE - TCPOLEN_TSTAMP_ALIGNED
+	 *			- TCPOLEN_SACK_BASE_ALIGNED
+	 *			- 2 * TCPOLEN_SACK_PERBLOCK) = 8 (maclen = 4),
+	 * see tcp_established_options().
+	 *
+	 * RFC5925, 2.2:
+	 * Typical MACs are 96-128 bits (12-16 bytes), but any length
+	 * that fits in the header of the segment being authenticated
+	 * is allowed.
+	 *
+	 * RFC5925, 7.6:
+	 * TCP-AO continues to consume 16 bytes in non-SYN segments,
+	 * leaving a total of 24 bytes for other options, of which
+	 * the timestamp consumes 10.  This leaves 14 bytes, of which 10
+	 * are used for a single SACK block. When two SACK blocks are used,
+	 * such as to handle D-SACK, a smaller TCP-AO MAC would be required
+	 * to make room for the additional SACK block (i.e., to leave 18
+	 * bytes for the D-SACK variant of the SACK option) [RFC2883].
+	 * Note that D-SACK is not supportable in TCP MD5 in the presence
+	 * of timestamps, because TCP MD5’s MAC length is fixed and too
+	 * large to leave sufficient option space.
+	 */
+	syn_tcp_option_space = MAX_TCP_OPTION_SPACE;
+	syn_tcp_option_space -= TCPOLEN_TSTAMP_ALIGNED;
+	syn_tcp_option_space -= TCPOLEN_WSCALE_ALIGNED;
+	syn_tcp_option_space -= TCPOLEN_SACKPERM_ALIGNED;
+	if (tcp_ao_len(key) > syn_tcp_option_space)
+		return -EMSGSIZE;
+
+	key->keylen = cmd->tcpa_keylen;
+	memcpy(key->key, cmd->tcpa_key, cmd->tcpa_keylen);
+
+	pool_id = crypto_pool_alloc_ahash(cmd->tcpa_alg_name);
+	if (pool_id < 0)
+		return pool_id;
+
+	if (is_kdf_aes_128_cmac) {
+		err = crypto_pool_reserve_scratch(16);
+		if (err)
+			goto err_free_pool;
+	}
+
+	err = crypto_pool_get(pool_id, (struct crypto_pool *)&hp);
+	if (err)
+		goto err_free_pool;
+
+	tfm = crypto_ahash_reqtfm(hp.req);
+	if (crypto_ahash_alignmask(tfm) > TCP_AO_KEY_ALIGN) {
+		err = -EOPNOTSUPP;
+		goto err_put_pool;
+	}
+
+	if (is_kdf_aes_128_cmac) {
+		void *scratch = hp.base.scratch;
+		struct scatterlist sg;
+
+		/* Using zero-key of 16 bytes as described in RFC5926 */
+		memset(scratch, 0, 16);
+		sg_init_one(&sg, cmd->tcpa_key, cmd->tcpa_keylen);
+
+		err = crypto_ahash_setkey(tfm, scratch, 16);
+		if (err)
+			goto err_put_pool;
+
+		err = crypto_ahash_init(hp.req);
+		if (err)
+			goto err_put_pool;
+
+		ahash_request_set_crypt(hp.req, &sg, key->key, cmd->tcpa_keylen);
+		err = crypto_ahash_update(hp.req);
+		if (err)
+			goto err_put_pool;
+
+		err |= crypto_ahash_final(hp.req);
+		if (err)
+			goto err_put_pool;
+		key->keylen = 16;
+	}
+
+	err = crypto_ahash_setkey(tfm, key->key, key->keylen);
+	if (err)
+		goto err_put_pool;
+
+	key->digest_size = crypto_ahash_digestsize(tfm);
+	crypto_pool_put();
+
+	err = crypto_pool_reserve_scratch(sizeof(struct tcphdr) +
+					  sizeof(struct tcp_ao_hdr) +
+					  key->digest_size);
+	if (err)
+		goto err_free_pool;
+
+	if (key->digest_size > TCP_AO_MAX_HASH_SIZE) {
+		err = -ENOBUFS;
+		goto err_free_pool;
+	}
+	if (key->maclen > key->digest_size) {
+		err = -EINVAL;
+		goto err_free_pool;
+	}
+
+	key->crypto_pool_id = pool_id;
+	return 0;
+
+err_put_pool:
+	crypto_pool_put();
+err_free_pool:
+	crypto_pool_release(pool_id);
+	return err;
+}
+
+/* tcp_ao_mkt_overlap_v4() assumes cmd already went through tcp_ao_verify_ipv4.
+ * RFC5925 3.1 The IDs of MKTs MUST NOT overlap where their TCP connection
+ * identifiers overlap.
+ */
+static bool tcp_ao_mkt_overlap_v4(struct tcp_ao *cmd,
+				  struct tcp_ao_info *ao_info)
+{
+	struct sockaddr_in *sin = (struct sockaddr_in *)&cmd->tcpa_addr;
+	__be32 addr = sin->sin_addr.s_addr;
+	__u8 prefix = cmd->tcpa_prefix;
+	__u16 port = ntohs(sin->sin_port);
+	__u8 sndid = cmd->tcpa_sndid;
+	__u8 rcvid = cmd->tcpa_rcvid;
+	struct tcp_ao_key *key;
+
+	/* Check for TCP connection identifiers overlap */
+
+	hlist_for_each_entry_rcu(key, &ao_info->head, node) {
+		__be32 key_addr;
+		__be32 mask;
+
+		/* Check for overlapping ids */
+		if (key->sndid != sndid && key->rcvid != rcvid)
+			continue;
+
+		key_addr = key->addr.a4.s_addr;
+		mask = inet_make_mask(min(prefix, key->prefixlen));
+
+		/* Check for overlapping addresses */
+		if (addr == INADDR_ANY || key_addr == INADDR_ANY ||
+		    (addr & mask) == (key_addr & mask)) {
+			/* Check for overlapping ports */
+			if (port == 0 || key->port == 0 || port == key->port)
+				return true;
+		}
+	}
+
+	return false;
+}
+
+/* tcp_ao_mkt_overlap_v6() assumes cmd already went through tcp_ao_verify_ipv6.
+ * RFC5925 3.1 The IDs of MKTs MUST NOT overlap where their TCP connection
+ * identifiers overlap.
+ */
+static bool tcp_ao_mkt_overlap_v6(struct tcp_ao *cmd,
+				  struct tcp_ao_info *ao_info)
+{
+	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)&cmd->tcpa_addr;
+	struct in6_addr *addr = &sin6->sin6_addr;
+	bool v4_mapped = ipv6_addr_v4mapped(addr);
+	__u8 prefix = cmd->tcpa_prefix;
+	__u16 port = ntohs(sin6->sin6_port);
+	__u8 sndid = cmd->tcpa_sndid;
+	__u8 rcvid = cmd->tcpa_rcvid;
+	struct tcp_ao_key *key;
+	__be32 addr4 = v4_mapped ? addr->s6_addr32[3] : 0;
+
+	hlist_for_each_entry_rcu(key, &ao_info->head, node) {
+		struct in6_addr pfx, key_pfx;
+		struct in6_addr *key_addr;
+		int min_prefixlen;
+
+		/* Check for overlapping ids */
+		if (key->sndid != sndid && key->rcvid != rcvid)
+			continue;
+
+		key_addr = &key->addr.a6;
+
+		if (v4_mapped) {
+			__be32 key_addr4;
+			__be32 mask;
+
+			if (!ipv6_addr_v4mapped(key_addr))
+				continue;
+
+			key_addr4 = key_addr->s6_addr32[3];
+			mask = inet_make_mask(min(prefix, key->prefixlen));
+
+			/* Check for overlapping addresses */
+			if (addr4 == INADDR_ANY || key_addr4 == INADDR_ANY ||
+			    (addr4 & mask) == (key_addr4 & mask)) {
+				/* Check for overlapping ports */
+				if (port == 0 || key->port == 0 ||
+				    port == key->port)
+					return true;
+			}
+		} else {
+			min_prefixlen = min(prefix, key->prefixlen);
+			ipv6_addr_prefix(&pfx, addr, min_prefixlen);
+			ipv6_addr_prefix(&key_pfx, key_addr, min_prefixlen);
+
+			/* Check for overlapping addresses */
+			if (ipv6_addr_any(addr) || ipv6_addr_any(key_addr) ||
+			    !ipv6_addr_cmp(&pfx, &key_pfx)) {
+				/* Check for overlapping ports */
+				if (port == 0 || key->port == 0 ||
+				    port == key->port)
+					return true;
+			}
+		}
+	}
+
+	return false;
+}
+
+#define TCP_AO_KEYF_ALL		(0)
+#define TCP_AO_CMDF_ADDMOD_VALID					\
+	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT)
+#define TCP_AO_CMDF_DEL_VALID						\
+	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT)
+
+static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
+			  sockptr_t optval, int optlen)
+{
+	struct tcp_ao_info *ao_info;
+	union tcp_md5_addr *addr;
+	struct tcp_ao_key *key;
+	bool first = false;
+	struct tcp_ao cmd;
+	int ret, size;
+	u16 port;
+
+	if (optlen < sizeof(cmd))
+		return -EINVAL;
+
+	ret = copy_struct_from_sockptr(&cmd, sizeof(cmd), optval, optlen);
+	if (ret)
+		return ret;
+
+	if (cmd.tcpa_keylen > TCP_AO_MAXKEYLEN)
+		return -EINVAL;
+
+	if (cmd.tcpa_flags & ~TCP_AO_CMDF_ADDMOD_VALID)
+		return -EINVAL;
+
+	if (family == AF_INET)
+		ret = tcp_ao_verify_ipv4(sk, &cmd, &addr, &port);
+	else
+		ret = tcp_ao_verify_ipv6(sk, &cmd, &addr, &port, &family);
+	if (ret)
+		return ret;
+
+	if (cmd.tcpa_keyflags & ~TCP_AO_KEYF_ALL)
+		return -EINVAL;
+
+	ao_info = rcu_dereference_protected(tcp_sk(sk)->ao_info,
+					    lockdep_sock_is_held(sk));
+
+	if (!ao_info) {
+		ao_info = tcp_ao_alloc_info(GFP_KERNEL, NULL);
+		if (!ao_info)
+			return -ENOMEM;
+		first = true;
+	} else {
+		if (family == AF_INET) {
+			if (tcp_ao_mkt_overlap_v4(&cmd, ao_info))
+				return -EEXIST;
+		} else {
+			if (tcp_ao_mkt_overlap_v6(&cmd, ao_info))
+				return -EEXIST;
+		}
+	}
+
+	/* TODO: We should add twice the key->diget_size instead of the max
+	 * so rework this in a way to know the digest_size before allocating
+	 * the tcp_ao_key struct.
+	 */
+	size = sizeof(struct tcp_ao_key) + (TCP_AO_MAX_HASH_SIZE << 1);
+	key = sock_kmalloc(sk, size, GFP_KERNEL);
+	if (!key) {
+		ret = -ENOMEM;
+		goto err_free_ao;
+	}
+
+	INIT_HLIST_NODE(&key->node);
+	memcpy(&key->addr, addr, (family == AF_INET) ? sizeof(struct in_addr) :
+						       sizeof(struct in6_addr));
+	key->port	= port;
+	key->prefixlen	= cmd.tcpa_prefix;
+	key->family	= family;
+	key->keyflags	= cmd.tcpa_keyflags;
+	key->sndid	= cmd.tcpa_sndid;
+	key->rcvid	= cmd.tcpa_rcvid;
+
+	ret = tcp_ao_parse_crypto(&cmd, key);
+	if (ret < 0)
+		goto err_free_sock;
+
+	tcp_ao_link_mkt(ao_info, key);
+	if (first) {
+		sk_gso_disable(sk);
+		rcu_assign_pointer(tcp_sk(sk)->ao_info, ao_info);
+	}
+
+	/* Can't fail: the key with sndid/rcvid was just added */
+	WARN_ON_ONCE(tcp_ao_current_rnext(sk, cmd.tcpa_flags,
+					  cmd.tcpa_sndid, cmd.tcpa_rcvid));
+	return 0;
+
+err_free_sock:
+	atomic_sub(tcp_ao_sizeof_key(key), &sk->sk_omem_alloc);
+	kfree(key);
+err_free_ao:
+	if (first)
+		kfree(ao_info);
+	return ret;
+}
+
+static int tcp_ao_delete_key(struct sock *sk, struct tcp_ao_key *key,
+		struct tcp_ao_info *ao_info, struct tcp_ao_del *cmd)
+{
+	int err;
+
+	hlist_del_rcu(&key->node);
+
+	/* At this moment another CPU could have looked this key up
+	 * while it was unlinked from the list. Wait for RCU grace period,
+	 * after which the key is off-list and can't be looked up again;
+	 * the rx path [just before RCU came] might have used it and set it
+	 * as current_key (very unlikely).
+	 */
+	synchronize_rcu();
+	err = tcp_ao_current_rnext(sk, cmd->tcpa_flags,
+				   cmd->tcpa_current, cmd->tcpa_rnext);
+	if (err)
+		goto add_key;
+
+	if (unlikely(READ_ONCE(ao_info->current_key) == key ||
+			       READ_ONCE(ao_info->rnext_key) == key)) {
+		err = -EBUSY;
+		goto add_key;
+	}
+
+	atomic_sub(tcp_ao_sizeof_key(key), &sk->sk_omem_alloc);
+	call_rcu(&key->rcu, tcp_ao_key_free_rcu);
+
+	return 0;
+add_key:
+	hlist_add_head_rcu(&key->node, &ao_info->head);
+	return err;
+}
+
+static int tcp_ao_del_cmd(struct sock *sk, unsigned short int family,
+			  sockptr_t optval, int optlen)
+{
+	struct tcp_ao_info *ao_info;
+	struct tcp_ao_key *key;
+	struct tcp_ao_del cmd;
+	int err;
+	union tcp_md5_addr *addr;
+	__u8 prefix;
+	__be16 port;
+	int addr_len;
+
+	if (optlen < sizeof(cmd))
+		return -EINVAL;
+
+	err = copy_struct_from_sockptr(&cmd, sizeof(cmd), optval, optlen);
+	if (err)
+		return err;
+
+	if (cmd.tcpa_flags & ~TCP_AO_CMDF_DEL_VALID)
+		return -EINVAL;
+
+	ao_info = rcu_dereference_protected(tcp_sk(sk)->ao_info,
+					    lockdep_sock_is_held(sk));
+	if (!ao_info)
+		return -ENOENT;
+
+	if (family == AF_INET) {
+		struct sockaddr_in *sin = (struct sockaddr_in *)&cmd.tcpa_addr;
+
+		addr = (union tcp_md5_addr *)&sin->sin_addr;
+		addr_len = sizeof(struct in_addr);
+		port = ntohs(sin->sin_port);
+	} else {
+		struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)&cmd.tcpa_addr;
+		struct in6_addr *addr6 = &sin6->sin6_addr;
+
+		if (ipv6_addr_v4mapped(addr6)) {
+			addr = (union tcp_md5_addr *)&addr6->s6_addr32[3];
+			addr_len = sizeof(struct in_addr);
+			family = AF_INET;
+		} else {
+			addr = (union tcp_md5_addr *)addr6;
+			addr_len = sizeof(struct in6_addr);
+		}
+		port = ntohs(sin6->sin6_port);
+	}
+	prefix = cmd.tcpa_prefix;
+
+	/* We could choose random present key here for current/rnext
+	 * but that's less predictable. Let's be strict and don't
+	 * allow removing a key that's in use. RFC5925 doesn't
+	 * specify how-to coordinate key removal, but says:
+	 * "It is presumed that an MKT affecting a particular
+	 * connection cannot be destroyed during an active connection"
+	 */
+	hlist_for_each_entry_rcu(key, &ao_info->head, node) {
+		if (cmd.tcpa_sndid != key->sndid ||
+		    cmd.tcpa_rcvid != key->rcvid)
+			continue;
+
+		if (family != key->family ||
+		    prefix != key->prefixlen ||
+		    port != key->port ||
+		    memcmp(addr, &key->addr, addr_len))
+			continue;
+
+		return tcp_ao_delete_key(sk, key, ao_info, &cmd);
+	}
+	return -ENOENT;
+}
+
+static int tcp_ao_mod_cmd(struct sock *sk, unsigned short int family,
+			  sockptr_t optval, int optlen)
+{
+	struct tcp_ao_info *ao_info;
+	struct tcp_ao_mod cmd;
+	int err;
+
+	if (optlen < sizeof(cmd))
+		return -EINVAL;
+
+	err = copy_struct_from_sockptr(&cmd, sizeof(cmd), optval, optlen);
+	if (err)
+		return err;
+
+	if (cmd.tcpa_flags & ~TCP_AO_CMDF_ADDMOD_VALID)
+		return -EINVAL;
+
+	ao_info = rcu_dereference_protected(tcp_sk(sk)->ao_info,
+					    lockdep_sock_is_held(sk));
+	if (!ao_info)
+		return -ENOENT;
+	/* TODO: make tcp_ao_current_rnext() and flags set atomic */
+	return tcp_ao_current_rnext(sk, cmd.tcpa_flags,
+			cmd.tcpa_current, cmd.tcpa_rnext);
+}
+
+int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
+		 sockptr_t optval, int optlen)
+{
+	if (WARN_ON_ONCE(family != AF_INET && family != AF_INET6))
+		return -EOPNOTSUPP;
+
+	switch (cmd) {
+	case TCP_AO:
+		return tcp_ao_add_cmd(sk, family, optval, optlen);
+	case TCP_AO_DEL:
+		return tcp_ao_del_cmd(sk, family, optval, optlen);
+	case TCP_AO_MOD:
+		return tcp_ao_mod_cmd(sk, family, optval, optlen);
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+}
+
+int tcp_v4_parse_ao(struct sock *sk, int cmd, sockptr_t optval, int optlen)
+{
+	return tcp_parse_ao(sk, cmd, AF_INET, optval, optlen);
+}
+
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6bafe7429902..755154523ffc 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2231,11 +2231,16 @@ const struct inet_connection_sock_af_ops ipv4_specific = {
 };
 EXPORT_SYMBOL(ipv4_specific);
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 static const struct tcp_sock_af_ops tcp_sock_ipv4_specific = {
+#ifdef CONFIG_TCP_MD5SIG
 	.md5_lookup		= tcp_v4_md5_lookup,
 	.calc_md5_hash		= tcp_v4_md5_hash_skb,
 	.md5_parse		= tcp_v4_parse_md5_keys,
+#endif
+#ifdef CONFIG_TCP_AO
+	.ao_parse		= tcp_v4_parse_ao,
+#endif
 };
 #endif
 
@@ -2301,6 +2306,7 @@ void tcp_v4_destroy_sock(struct sock *sk)
 		rcu_assign_pointer(tp->md5sig_info, NULL);
 	}
 #endif
+	tcp_ao_destroy_sock(sk);
 
 	/* Clean up a referenced TCP bind bucket. */
 	if (inet_csk(sk)->icsk_bind_hash)
diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index 3036a45e8a1e..68a991499e63 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -53,3 +53,4 @@ ifneq ($(CONFIG_IPV6),)
 obj-$(CONFIG_NET_UDP_TUNNEL) += ip6_udp_tunnel.o
 obj-y += mcast_snoop.o
 endif
+obj-$(CONFIG_TCP_AO) += tcp_ao.o
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
new file mode 100644
index 000000000000..f9f242a7e0f2
--- /dev/null
+++ b/net/ipv6/tcp_ao.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * INET		An implementation of the TCP Authentication Option (TCP-AO).
+ *		See RFC5925.
+ *
+ * Authors:	Dmitry Safonov <dima@arista.com>
+ *		Francesco Ruggeri <fruggeri@arista.com>
+ *		Salam Noureddine <noureddine@arista.com>
+ */
+#include <linux/tcp.h>
+#include <crypto/pool.h>
+
+#include <net/tcp.h>
+#include <net/ipv6.h>
+
+int tcp_v6_parse_ao(struct sock *sk, int cmd,
+		    sockptr_t optval, int optlen)
+{
+	return tcp_parse_ao(sk, cmd, AF_INET6, optval, optlen);
+}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index f75569f889e7..741cbeb52117 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1883,11 +1883,16 @@ const struct inet_connection_sock_af_ops ipv6_specific = {
 	.mtu_reduced	   = tcp_v6_mtu_reduced,
 };
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 static const struct tcp_sock_af_ops tcp_sock_ipv6_specific = {
+#ifdef CONFIG_TCP_MD5SIG
 	.md5_lookup	=	tcp_v6_md5_lookup,
 	.calc_md5_hash	=	tcp_v6_md5_hash_skb,
 	.md5_parse	=	tcp_v6_parse_md5_keys,
+#endif
+#ifdef CONFIG_TCP_AO
+	.ao_parse	=	tcp_v6_parse_ao,
+#endif
 };
 #endif
 
@@ -1909,11 +1914,16 @@ static const struct inet_connection_sock_af_ops ipv6_mapped = {
 	.mtu_reduced	   = tcp_v4_mtu_reduced,
 };
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 static const struct tcp_sock_af_ops tcp_sock_ipv6_mapped_specific = {
+#ifdef CONFIG_TCP_MD5SIG
 	.md5_lookup	=	tcp_v4_md5_lookup,
 	.calc_md5_hash	=	tcp_v4_md5_hash_skb,
 	.md5_parse	=	tcp_v6_parse_md5_keys,
+#endif
+#ifdef CONFIG_TCP_AO
+	.ao_parse	=	tcp_v6_parse_ao,
+#endif
 };
 #endif
 
-- 
2.37.2

