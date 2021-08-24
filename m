Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E02A3F6B0E
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbhHXVgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235316AbhHXVgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:36:11 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CE6C0613C1;
        Tue, 24 Aug 2021 14:35:26 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id i21so5941127ejd.2;
        Tue, 24 Aug 2021 14:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X5Apuv2cyt0MITmcIM7M4objA2kYP9T31JBKiEBK3jU=;
        b=GMGc9WI1IO6ZCLu7N2eROZXp2bwOHPI1Z40Dq19JmBcZ4hnTggyamsW84TjSjkglHJ
         ICgXi6qDJEfbHAPeka6WHJDl2xl7D3YZB7tDhhVR71VXx6m/xqT3vHCZhTrxexFA97rO
         lSFrp29uFN6gPhjVgwme4K1AGcUMUeROaQ9jobEk56BSlQV+AMygQZUR8w5fpZ6mdiJx
         3DApKE24lGdmvxwGHCd5xXvAjRFOFF04MthFxSr6aaUXaiOh0gnTUwhVd66u3r3A09qX
         VQx8w2gvbA+3Qf1P9V7CRnHvQ7uGWdLBIgTXdyL0c2/Oq0vlZ+59oI1wZUsA6wBnKzLc
         S8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X5Apuv2cyt0MITmcIM7M4objA2kYP9T31JBKiEBK3jU=;
        b=VX3/81h8TWRPIMybi5oowgbvK6tRYORXS6St/q1oDMpa7/2J1QoYaxxtyXaCHTplKO
         ixXIune04l9EduWD5vzTU7uOgSOeHzm0OAFQHigtPW71fGqw9wOUjH4t/fwok9FRuUHu
         ii9OGgHl5Pow5FOdOrkcX+H+1bLggAVeXuWzzE49T77wmj1DDf6m+mXmEERhpUdtDGE1
         /8Swa1F8DAGSFdOlg/MWO4J6dTuXpqRhoCCxbZWdemhaZl7fR82n8RrVVamZD7jBsbUX
         NhP3wNpvOMQKO1UwJuXqZiWcjWLlquajgNR1bt6xEQrfXtOdqlSilSgGWpIgoJLrx94j
         CxAw==
X-Gm-Message-State: AOAM53090GHi08GQl0MF5b3NfWdWG7fLcYyWpVmuJH9Ga0wgmnXoEV5k
        CsMG6YzEWjxgP6yVnBFyldo=
X-Google-Smtp-Source: ABdhPJxnPyZtZkY6ekgkxjMPTKwMUt9r0RIr+J7EhR/LQgYRvKudMUQdE0fWlQvRR9lW6BHyz+0hbw==
X-Received: by 2002:a17:906:c246:: with SMTP id bl6mr43553403ejb.80.1629840925089;
        Tue, 24 Aug 2021 14:35:25 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:ed0a:7326:fbac:b4c])
        by smtp.gmail.com with ESMTPSA id d16sm12348357edu.8.2021.08.24.14.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 14:35:24 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFCv3 01/15] tcp: authopt: Initial support and key management
Date:   Wed, 25 Aug 2021 00:34:34 +0300
Message-Id: <090898ac6f3345ec02999858c65c2ebb8cd274a8.1629840814.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1629840814.git.cdleonard@gmail.com>
References: <cover.1629840814.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds support to add and remove keys but does not use them
further.

Similar to tcp md5 a single pointer to a struct tcp_authopt_info* struct
is added to struct tcp_sock, this avoids increasing memory usage. The
data structures related to tcp_authopt are initialized on setsockopt and
only freed on socket close.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/linux/tcp.h       |   6 +
 include/net/tcp.h         |   1 +
 include/net/tcp_authopt.h |  65 +++++++++++
 include/uapi/linux/tcp.h  |  79 ++++++++++++++
 net/ipv4/Kconfig          |  14 +++
 net/ipv4/Makefile         |   1 +
 net/ipv4/tcp.c            |  27 +++++
 net/ipv4/tcp_authopt.c    | 223 ++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c       |   2 +
 9 files changed, 418 insertions(+)
 create mode 100644 include/net/tcp_authopt.h
 create mode 100644 net/ipv4/tcp_authopt.c

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 48d8a363319e..cfddfc720b00 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -140,10 +140,12 @@ struct tcp_request_sock {
 static inline struct tcp_request_sock *tcp_rsk(const struct request_sock *req)
 {
 	return (struct tcp_request_sock *)req;
 }
 
+struct tcp_authopt_info;
+
 struct tcp_sock {
 	/* inet_connection_sock has to be the first member of tcp_sock */
 	struct inet_connection_sock	inet_conn;
 	u16	tcp_header_len;	/* Bytes of tcp header to send		*/
 	u16	gso_segs;	/* Max number of segs per GSO packet	*/
@@ -403,10 +405,14 @@ struct tcp_sock {
 
 /* TCP MD5 Signature Option information */
 	struct tcp_md5sig_info	__rcu *md5sig_info;
 #endif
 
+#ifdef CONFIG_TCP_AUTHOPT
+	struct tcp_authopt_info	__rcu *authopt_info;
+#endif
+
 /* TCP fastopen related information */
 	struct tcp_fastopen_request *fastopen_req;
 	/* fastopen_rsk points to request_sock that resulted in this big
 	 * socket. Used to retransmit SYNACKs etc.
 	 */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 3166dc15d7d6..bb76554e8fe5 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -182,10 +182,11 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 #define TCPOPT_WINDOW		3	/* Window scaling */
 #define TCPOPT_SACK_PERM        4       /* SACK Permitted */
 #define TCPOPT_SACK             5       /* SACK Block */
 #define TCPOPT_TIMESTAMP	8	/* Better RTT estimations/PAWS */
 #define TCPOPT_MD5SIG		19	/* MD5 Signature (RFC2385) */
+#define TCPOPT_AUTHOPT		29	/* Auth Option (RFC5925) */
 #define TCPOPT_MPTCP		30	/* Multipath TCP (RFC6824) */
 #define TCPOPT_FASTOPEN		34	/* Fast open (RFC7413) */
 #define TCPOPT_EXP		254	/* Experimental */
 /* Magic number to be after the option value for sharing TCP
  * experimental options. See draft-ietf-tcpm-experimental-options-00.txt
diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
new file mode 100644
index 000000000000..b4277112b506
--- /dev/null
+++ b/include/net/tcp_authopt.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _LINUX_TCP_AUTHOPT_H
+#define _LINUX_TCP_AUTHOPT_H
+
+#include <uapi/linux/tcp.h>
+
+/**
+ * struct tcp_authopt_key_info - Representation of a Master Key Tuple as per RFC5925
+ *
+ * Key structure lifetime is only protected by RCU so readers needs to hold a
+ * single rcu_read_lock until they're done with the key.
+ */
+struct tcp_authopt_key_info {
+	struct hlist_node node;
+	struct rcu_head rcu;
+	/* Local identifier */
+	u32 local_id;
+	u32 flags;
+	/* Wire identifiers */
+	u8 send_id, recv_id;
+	u8 alg_id;
+	u8 keylen;
+	u8 key[TCP_AUTHOPT_MAXKEYLEN];
+	struct sockaddr_storage addr;
+};
+
+/**
+ * struct tcp_authopt_info - Per-socket information regarding tcp_authopt
+ *
+ * This is lazy-initialized in order to avoid increasing memory usage for
+ * regular TCP sockets. Once created it is only destroyed on socket close.
+ */
+struct tcp_authopt_info {
+	/** @head: List of tcp_authopt_key_info */
+	struct hlist_head head;
+	struct rcu_head rcu;
+	u32 flags;
+	u32 src_isn;
+	u32 dst_isn;
+};
+
+#ifdef CONFIG_TCP_AUTHOPT
+void tcp_authopt_clear(struct sock *sk);
+int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
+int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key);
+int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen);
+#else
+static inline int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
+{
+	return -ENOPROTOOPT;
+}
+static inline int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key)
+{
+	return -ENOPROTOOPT;
+}
+static inline void tcp_authopt_clear(struct sock *sk)
+{
+}
+static inline int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
+{
+	return -ENOPROTOOPT;
+}
+#endif
+
+#endif /* _LINUX_TCP_AUTHOPT_H */
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 8fc09e8638b3..575162e7e281 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -126,10 +126,12 @@ enum {
 #define TCP_INQ			36	/* Notify bytes available to read as a cmsg on read */
 
 #define TCP_CM_INQ		TCP_INQ
 
 #define TCP_TX_DELAY		37	/* delay outgoing packets by XX usec */
+#define TCP_AUTHOPT		38	/* TCP Authentication Option (RFC5925) */
+#define TCP_AUTHOPT_KEY		39	/* TCP Authentication Option Key (RFC5925) */
 
 
 #define TCP_REPAIR_ON		1
 #define TCP_REPAIR_OFF		0
 #define TCP_REPAIR_OFF_NO_WP	-1	/* Turn off without window probes */
@@ -340,10 +342,87 @@ struct tcp_diag_md5sig {
 	__u16	tcpm_keylen;
 	__be32	tcpm_addr[4];
 	__u8	tcpm_key[TCP_MD5SIG_MAXKEYLEN];
 };
 
+/**
+ * enum tcp_authopt_flag - flags for `tcp_authopt.flags`
+ */
+enum tcp_authopt_flag {
+	/**
+	 * @TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED:
+	 *	Configure behavior of segments with TCP-AO coming from hosts for which no
+	 *	key is configured. The default recommended by RFC is to silently accept
+	 *	such connections.
+	 */
+	TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED = (1 << 2),
+};
+
+/**
+ * struct tcp_authopt - Per-socket options related to TCP Authentication Option
+ */
+struct tcp_authopt {
+	/** @flags: Combination of &enum tcp_authopt_flag */
+	__u32	flags;
+};
+
+/**
+ * enum tcp_authopt_key_flag - flags for `tcp_authopt.flags`
+ *
+ * @TCP_AUTHOPT_KEY_DEL: Delete the key by local_id and ignore all other fields.
+ * @TCP_AUTHOPT_KEY_EXCLUDE_OPTS: Exclude TCP options from signature.
+ * @TCP_AUTHOPT_KEY_ADDR_BIND: Key only valid for `tcp_authopt.addr`
+ */
+enum tcp_authopt_key_flag {
+	TCP_AUTHOPT_KEY_DEL = (1 << 0),
+	TCP_AUTHOPT_KEY_EXCLUDE_OPTS = (1 << 1),
+	TCP_AUTHOPT_KEY_ADDR_BIND = (1 << 2),
+};
+
+/**
+ * enum tcp_authopt_alg - Algorithms for TCP Authentication Option
+ */
+enum tcp_authopt_alg {
+	TCP_AUTHOPT_ALG_HMAC_SHA_1_96 = 1,
+	TCP_AUTHOPT_ALG_AES_128_CMAC_96 = 2,
+};
+
+/* for TCP_AUTHOPT_KEY socket option */
+#define TCP_AUTHOPT_MAXKEYLEN	80
+
+/**
+ * struct tcp_authopt_key - TCP Authentication KEY
+ *
+ * Key are identified by the combination of:
+ * - send_id
+ * - recv_id
+ * - addr (iff TCP_AUTHOPT_KEY_ADDR_BIND)
+ *
+ * RFC5925 requires that key ids must not overlap for the same TCP connection.
+ * This is not enforced by linux.
+ */
+struct tcp_authopt_key {
+	/** @flags: Combination of &enum tcp_authopt_key_flag */
+	__u32	flags;
+	/** @send_id: keyid value for send */
+	__u8	send_id;
+	/** @recv_id: keyid value for receive */
+	__u8	recv_id;
+	/** @alg: One of &enum tcp_authopt_alg */
+	__u8	alg;
+	/** @keylen: Length of the key buffer */
+	__u8	keylen;
+	/** @key: Secret key */
+	__u8	key[TCP_AUTHOPT_MAXKEYLEN];
+	/**
+	 * @addr: Key is only valid for this address
+	 *
+	 * Ignored unless TCP_AUTHOPT_KEY_ADDR_BIND flag is set
+	 */
+	struct __kernel_sockaddr_storage addr;
+};
+
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
 struct tcp_zerocopy_receive {
 	__u64 address;		/* in: address of mapping */
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 87983e70f03f..6459f4ea6f1d 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -740,5 +740,19 @@ config TCP_MD5SIG
 	  RFC2385 specifies a method of giving MD5 protection to TCP sessions.
 	  Its main (only?) use is to protect BGP sessions between core routers
 	  on the Internet.
 
 	  If unsure, say N.
+
+config TCP_AUTHOPT
+	bool "TCP: Authentication Option support (RFC5925)"
+	select CRYPTO
+	select CRYPTO_SHA1
+	select CRYPTO_HMAC
+	select CRYPTO_AES
+	select CRYPTO_CMAC
+	help
+	  RFC5925 specifies a new method of giving protection to TCP sessions.
+	  Its intended use is to protect BGP sessions between core routers
+	  on the Internet. It obsoletes TCP MD5 (RFC2385) but is incompatible.
+
+	  If unsure, say N.
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index bbdd9c44f14e..d336f32ce177 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -59,10 +59,11 @@ obj-$(CONFIG_TCP_CONG_NV) += tcp_nv.o
 obj-$(CONFIG_TCP_CONG_VENO) += tcp_veno.o
 obj-$(CONFIG_TCP_CONG_SCALABLE) += tcp_scalable.o
 obj-$(CONFIG_TCP_CONG_LP) += tcp_lp.o
 obj-$(CONFIG_TCP_CONG_YEAH) += tcp_yeah.o
 obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
+obj-$(CONFIG_TCP_AUTHOPT) += tcp_authopt.o
 obj-$(CONFIG_NET_SOCK_MSG) += tcp_bpf.o
 obj-$(CONFIG_BPF_SYSCALL) += udp_bpf.o
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f931def6302e..fd90e80afa2c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -271,10 +271,11 @@
 
 #include <net/icmp.h>
 #include <net/inet_common.h>
 #include <net/tcp.h>
 #include <net/mptcp.h>
+#include <net/tcp_authopt.h>
 #include <net/xfrm.h>
 #include <net/ip.h>
 #include <net/sock.h>
 
 #include <linux/uaccess.h>
@@ -3573,10 +3574,16 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 	case TCP_MD5SIG:
 	case TCP_MD5SIG_EXT:
 		err = tp->af_specific->md5_parse(sk, optname, optval, optlen);
 		break;
 #endif
+	case TCP_AUTHOPT:
+		err = tcp_set_authopt(sk, optval, optlen);
+		break;
+	case TCP_AUTHOPT_KEY:
+		err = tcp_set_authopt_key(sk, optval, optlen);
+		break;
 	case TCP_USER_TIMEOUT:
 		/* Cap the max time in ms TCP will retry or probe the window
 		 * before giving up and aborting (ETIMEDOUT) a connection.
 		 */
 		if (val < 0)
@@ -4219,10 +4226,30 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		if (!err && copy_to_user(optval, &zc, len))
 			err = -EFAULT;
 		return err;
 	}
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	case TCP_AUTHOPT: {
+		struct tcp_authopt info;
+
+		if (get_user(len, optlen))
+			return -EFAULT;
+
+		lock_sock(sk);
+		tcp_get_authopt_val(sk, &info);
+		release_sock(sk);
+
+		len = min_t(unsigned int, len, sizeof(info));
+		if (put_user(len, optlen))
+			return -EFAULT;
+		if (copy_to_user(optval, &info, len))
+			return -EFAULT;
+		return 0;
+	}
+#endif
+
 	default:
 		return -ENOPROTOOPT;
 	}
 
 	if (put_user(len, optlen))
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
new file mode 100644
index 000000000000..f6dddc5775ff
--- /dev/null
+++ b/net/ipv4/tcp_authopt.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/kernel.h>
+#include <net/tcp.h>
+#include <net/tcp_authopt.h>
+#include <crypto/hash.h>
+#include <trace/events/tcp.h>
+
+/* checks that ipv4 or ipv6 addr matches. */
+static bool ipvx_addr_match(struct sockaddr_storage *a1,
+			    struct sockaddr_storage *a2)
+{
+	if (a1->ss_family != a2->ss_family)
+		return false;
+	if (a1->ss_family == AF_INET && memcmp(
+			&((struct sockaddr_in *)a1)->sin_addr,
+			&((struct sockaddr_in *)a2)->sin_addr,
+			sizeof(struct in_addr)))
+		return false;
+	if (a1->ss_family == AF_INET6 && memcmp(
+			&((struct sockaddr_in6 *)a1)->sin6_addr,
+			&((struct sockaddr_in6 *)a2)->sin6_addr,
+			sizeof(struct in6_addr)))
+		return false;
+	return true;
+}
+
+static bool tcp_authopt_key_match_exact(struct tcp_authopt_key_info *info,
+					struct tcp_authopt_key *key)
+{
+	if (info->send_id != key->send_id)
+		return false;
+	if (info->recv_id != key->recv_id)
+		return false;
+	if ((info->flags & TCP_AUTHOPT_KEY_ADDR_BIND) != (key->recv_id & TCP_AUTHOPT_KEY_ADDR_BIND))
+		return false;
+	if (info->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
+		if (!ipvx_addr_match(&info->addr, &key->addr))
+			return false;
+
+	return true;
+}
+
+static struct tcp_authopt_key_info *tcp_authopt_key_lookup_exact(const struct sock *sk,
+								 struct tcp_authopt_info *info,
+								 struct tcp_authopt_key *ukey)
+{
+	struct tcp_authopt_key_info *key_info;
+
+	hlist_for_each_entry_rcu(key_info, &info->head, node, lockdep_sock_is_held(sk))
+		if (tcp_authopt_key_match_exact(key_info, ukey))
+			return key_info;
+
+	return NULL;
+}
+
+static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_authopt_info *info;
+
+	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
+	if (info)
+		return info;
+
+	info = kmalloc(sizeof(*info), GFP_KERNEL | __GFP_ZERO);
+	if (!info)
+		return ERR_PTR(-ENOMEM);
+
+	sk_nocaps_add(sk, NETIF_F_GSO_MASK);
+	INIT_HLIST_HEAD(&info->head);
+	rcu_assign_pointer(tp->authopt_info, info);
+
+	return info;
+}
+
+#define TCP_AUTHOPT_KNOWN_FLAGS ( \
+	TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED)
+
+int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
+{
+	struct tcp_authopt opt;
+	struct tcp_authopt_info *info;
+
+	sock_owned_by_me(sk);
+
+	/* If userspace optlen is too short fill the rest with zeros */
+	if (optlen > sizeof(opt))
+		return -EINVAL;
+	memset(&opt, 0, sizeof(opt));
+	if (copy_from_sockptr(&opt, optval, optlen))
+		return -EFAULT;
+
+	if (opt.flags & ~TCP_AUTHOPT_KNOWN_FLAGS)
+		return -EINVAL;
+
+	info = __tcp_authopt_info_get_or_create(sk);
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+
+	info->flags = opt.flags & TCP_AUTHOPT_KNOWN_FLAGS;
+
+	return 0;
+}
+
+int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_authopt_info *info;
+
+	sock_owned_by_me(sk);
+
+	memset(opt, 0, sizeof(*opt));
+	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
+	if (!info)
+		return -EINVAL;
+
+	opt->flags = info->flags & TCP_AUTHOPT_KNOWN_FLAGS;
+
+	return 0;
+}
+
+static void tcp_authopt_key_del(struct sock *sk,
+				struct tcp_authopt_info *info,
+				struct tcp_authopt_key_info *key)
+{
+	hlist_del_rcu(&key->node);
+	atomic_sub(sizeof(*key), &sk->sk_omem_alloc);
+	kfree_rcu(key, rcu);
+}
+
+/* free info and keys but don't touch tp->authopt_info */
+static void __tcp_authopt_info_free(struct sock *sk, struct tcp_authopt_info *info)
+{
+	struct hlist_node *n;
+	struct tcp_authopt_key_info *key;
+
+	hlist_for_each_entry_safe(key, n, &info->head, node)
+		tcp_authopt_key_del(sk, info, key);
+	kfree_rcu(info, rcu);
+}
+
+/* free everything and clear tcp_sock.authopt_info to NULL */
+void tcp_authopt_clear(struct sock *sk)
+{
+	struct tcp_authopt_info *info;
+
+	info = rcu_dereference_protected(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
+	if (info) {
+		__tcp_authopt_info_free(sk, info);
+		tcp_sk(sk)->authopt_info = NULL;
+	}
+}
+
+#define TCP_AUTHOPT_KEY_KNOWN_FLAGS ( \
+	TCP_AUTHOPT_KEY_DEL | \
+	TCP_AUTHOPT_KEY_EXCLUDE_OPTS | \
+	TCP_AUTHOPT_KEY_ADDR_BIND)
+
+int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
+{
+	struct tcp_authopt_key opt;
+	struct tcp_authopt_info *info;
+	struct tcp_authopt_key_info *key_info;
+
+	sock_owned_by_me(sk);
+
+	/* If userspace optlen is too short fill the rest with zeros */
+	if (optlen > sizeof(opt))
+		return -EINVAL;
+	memset(&opt, 0, sizeof(opt));
+	if (copy_from_sockptr(&opt, optval, optlen))
+		return -EFAULT;
+
+	if (opt.flags & ~TCP_AUTHOPT_KEY_KNOWN_FLAGS)
+		return -EINVAL;
+
+	if (opt.keylen > TCP_AUTHOPT_MAXKEYLEN)
+		return -EINVAL;
+
+	/* Delete is a special case: */
+	if (opt.flags & TCP_AUTHOPT_KEY_DEL) {
+		info = rcu_dereference_check(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
+		if (!info)
+			return -ENOENT;
+		key_info = tcp_authopt_key_lookup_exact(sk, info, &opt);
+		if (!key_info)
+			return -ENOENT;
+		tcp_authopt_key_del(sk, info, key_info);
+		return 0;
+	}
+
+	/* check key family */
+	if (opt.flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
+		if (sk->sk_family != opt.addr.ss_family)
+			return -EINVAL;
+	}
+
+	/* Initialize tcp_authopt_info if not already set */
+	info = __tcp_authopt_info_get_or_create(sk);
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+
+	/* If an old key exists with exact ID then remove and replace.
+	 * RCU-protected readers might observe both and pick any.
+	 */
+	key_info = tcp_authopt_key_lookup_exact(sk, info, &opt);
+	if (key_info)
+		tcp_authopt_key_del(sk, info, key_info);
+	key_info = sock_kmalloc(sk, sizeof(*key_info), GFP_KERNEL | __GFP_ZERO);
+	if (!key_info)
+		return -ENOMEM;
+	key_info->flags = opt.flags & TCP_AUTHOPT_KEY_KNOWN_FLAGS;
+	key_info->send_id = opt.send_id;
+	key_info->recv_id = opt.recv_id;
+	key_info->alg_id = opt.alg;
+	key_info->keylen = opt.keylen;
+	memcpy(key_info->key, opt.key, opt.keylen);
+	memcpy(&key_info->addr, &opt.addr, sizeof(key_info->addr));
+	hlist_add_head_rcu(&key_info->node, &info->head);
+
+	return 0;
+}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 2e62e0d6373a..1348615c7576 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -60,10 +60,11 @@
 
 #include <net/net_namespace.h>
 #include <net/icmp.h>
 #include <net/inet_hashtables.h>
 #include <net/tcp.h>
+#include <net/tcp_authopt.h>
 #include <net/transp_v6.h>
 #include <net/ipv6.h>
 #include <net/inet_common.h>
 #include <net/timewait_sock.h>
 #include <net/xfrm.h>
@@ -2256,10 +2257,11 @@ void tcp_v4_destroy_sock(struct sock *sk)
 		tcp_clear_md5_list(sk);
 		kfree_rcu(rcu_dereference_protected(tp->md5sig_info, 1), rcu);
 		tp->md5sig_info = NULL;
 	}
 #endif
+	tcp_authopt_clear(sk);
 
 	/* Clean up a referenced TCP bind bucket. */
 	if (inet_csk(sk)->icsk_bind_hash)
 		inet_put_port(sk);
 
-- 
2.25.1

