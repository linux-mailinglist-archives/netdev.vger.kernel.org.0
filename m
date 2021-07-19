Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF7D3CD3CF
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 13:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbhGSKo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 06:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236373AbhGSKoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 06:44:24 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A163BC061574;
        Mon, 19 Jul 2021 03:36:03 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id oz7so24265573ejc.2;
        Mon, 19 Jul 2021 04:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WB84PyJbr7MRLrghjAinXRkF8K7Ntiypx9rRfQvm5yo=;
        b=jiPcwDgP7xv+bcucNN3x6BzC4wA1FQHp241Zvyxr6rBg8Km5KgOkP+vcadJ8X1oWja
         B6ZvWV/SdvZnm7xkvM4gzyT9pH9pMk2kFxEj9H0i0J5rsDgVhwgIRI4GudkA1JV+uws2
         xgKVtqzTyL0JLgZubyVAwcCm5iEmg2NRVDfHHVYuF4IogN6Rh4y+0YonjRODXa8dgsnV
         8laqBl1QG5AROftOwzW0C/kJAh+xJCbaxF0GOJL/nJ9dufASn5LPbpBKGaG3aaQI/ra8
         2+fQbx18hwkI+1TJxIq/bejWlaar3lc4uh+STlH8s6KRwfo24zAyqwW68cXL0yE+MUnJ
         Q//g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WB84PyJbr7MRLrghjAinXRkF8K7Ntiypx9rRfQvm5yo=;
        b=jnXUJXGnoSoF+nKwhIOjhXUjxeb9jBsvaZC78p9KTm0YK3zm5veqEXzaPw0zu08fxO
         vqsh06HP4/PCnV2A05o+dgEi68jlKz3tQP1TIzhXIN431DcS0gRi3ofgyvN3T9fznLv4
         x3p3zkhak21hB77YlmWsxCOVIiAR/Kncxc+Pv8359OXtctqPedLhM5Y02UaOZay0nYW3
         qRX0I8JamVELgPP0gCdCtzXrboTbqp15kC9sn1Qa1Ga3ITmtwdqMAedqgGonQbykEVH4
         qPuWfqoXgVJ5ok99XMvZWQUjVvsGMvc928D1gAUdGAp/gTDOOtbg2eJYCM1aiMn080GH
         lrrA==
X-Gm-Message-State: AOAM533+SwH8qnkrzBZjILXNcFlYzQsLLDjOSVdlXlSqrEvuwvyejC3C
        s2CEz8Jk/kRuYusy9aJNmdJfW3wB72BwJ9Wk
X-Google-Smtp-Source: ABdhPJw6SpvshJVIJm4x/yFIXlcsdfyXhZWoCX+TytuvnHYzVDkvphNSDE7qOY6NPCDQbr/j6mkCdw==
X-Received: by 2002:a17:906:69b:: with SMTP id u27mr27061012ejb.338.1626693901016;
        Mon, 19 Jul 2021 04:25:01 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:ad2a:8960:561b:ebb9])
        by smtp.gmail.com with ESMTPSA id hb43sm5721117ejc.93.2021.07.19.04.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 04:25:00 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC] tcp: Initial support for RFC5925 auth option
Date:   Mon, 19 Jul 2021 14:24:46 +0300
Message-Id: <01383a8751e97ef826ef2adf93bfde3a08195a43.1626693859.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is similar to TCP MD5 in functionality but it's sufficiently
different that userspace interface and wire formats are incompatible.
Compared to TCP-MD5 more algorithms are supported and multiple keys can
be used on the same connection but there is still no negotiation
mechanism.

Expected use-case is protecting long-duration BGP/LDP connections
between routers using pre-shared keys.

This is an early version which focuses on getting the correct
signature bits on the wire in a way that can interoperate with other
implementations. Major issues still need to be solved:

 * Lockdep warnings (incorrect context for initializing shash)
 * Support for aes-128-cmac-96
 * Binding keys to addresses and/or interfaces similar to md5
 * Sequence Number Extension

A small test suite is here: https://github.com/cdleonard/tcp-authopt-test
The tests work by establishing loopback TCP connections, capturing
packets with scapy and validating signatures.

Changes for yabgp are here:
https://github.com/cdleonard/yabgp/commits/tcp_authopt
The patched version of yabgp can establish a BGP session protected by
TCP Authentication Option with a Cisco IOS-XR router.

I'm especially interested in feedback regarding ABI and testing.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>

---

Allocating shash requires user context but holding a struct tfm in
tcp_authopt_key_info allocated by tcp_set_authopt_key doesn't work
because when a server handshake is succesful the server socket needs to
copy the keys of the listen socket in softirq context.

Sharing the crypto_shash tfm between listen and server sockets doesn't
work well either because keys for each connection (and each syn packet)
are different and the hmac or cmac key is per-tfm rather than per
shash_desc. The server sockets would need locking to access their shared
tfm.

Simplest solution would be to allocate one shash for each CPU and borrow
it for each hashing operation. TCP-MD5 allocates one ahash globally but
that can't work for hmac/cmac because of setkey.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/linux/tcp.h       |   6 +
 include/net/tcp.h         |   1 +
 include/net/tcp_authopt.h | 103 ++++++
 include/uapi/linux/snmp.h |   1 +
 include/uapi/linux/tcp.h  |  40 +++
 net/ipv4/Kconfig          |  14 +
 net/ipv4/Makefile         |   1 +
 net/ipv4/proc.c           |   1 +
 net/ipv4/tcp.c            |   7 +
 net/ipv4/tcp_authopt.c    | 718 ++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_input.c      |  17 +
 net/ipv4/tcp_ipv4.c       |   5 +
 net/ipv4/tcp_minisocks.c  |   2 +
 net/ipv4/tcp_output.c     |  65 +++-
 14 files changed, 980 insertions(+), 1 deletion(-)
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
index 17df9b047ee4..767611fd5ec3 100644
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
index 000000000000..aaab5c955984
--- /dev/null
+++ b/include/net/tcp_authopt.h
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _LINUX_TCP_AUTHOPT_H
+#define _LINUX_TCP_AUTHOPT_H
+
+#include <uapi/linux/tcp.h>
+
+/* Representation of a Master Key Tuple as per RFC5925 */
+struct tcp_authopt_key_info {
+	struct hlist_node node;
+	/* Local identifier */
+	u32 local_id;
+	u32 flags;
+	/* Wire identifiers */
+	u8 send_id, recv_id;
+	u8 alg;
+	u8 keylen;
+	u8 key[TCP_AUTHOPT_MAXKEYLEN];
+	u8 maclen;
+	u8 traffic_key_len;
+	struct rcu_head rcu;
+};
+
+/* Per-socket information regarding tcp_authopt */
+struct tcp_authopt_info {
+	struct hlist_head head;
+	u32 local_send_id;
+	u32 src_isn;
+	u32 dst_isn;
+	u8 rnextkeyid;
+	struct rcu_head rcu;
+};
+
+#ifdef CONFIG_TCP_AUTHOPT
+struct tcp_authopt_key_info *tcp_authopt_key_info_lookup(struct sock *sk, int key_id);
+void tcp_authopt_clear(struct sock *sk);
+int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
+int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen);
+int tcp_authopt_hash(
+		char *hash_location,
+		struct tcp_authopt_key_info *key,
+		struct sock *sk, struct sk_buff *skb);
+int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct request_sock *req);
+static inline int tcp_authopt_openreq(
+		struct sock *newsk,
+		const struct sock *oldsk,
+		struct request_sock *req)
+{
+	if (!rcu_dereference(tcp_sk(oldsk)->authopt_info))
+		return 0;
+	else
+		return __tcp_authopt_openreq(newsk, oldsk, req);
+}
+int __tcp_authopt_inbound_check(
+		struct sock *sk,
+		struct sk_buff *skb,
+		struct tcp_authopt_info *info);
+static inline int tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb)
+{
+	struct tcp_authopt_info *info = rcu_dereference(tcp_sk(sk)->authopt_info);
+
+	if (info)
+		return __tcp_authopt_inbound_check(sk, skb, info);
+	else
+		return 0;
+}
+#else
+static inline struct tcp_authopt_key_info *tcp_authopt_key_info_lookup(
+		struct sock *sk,
+		int key_id)
+{
+	return NULL;
+}
+static inline int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
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
+static inline int tcp_authopt_hash(
+		char *hash_location,
+		struct tcp_authopt_key_info *key,
+		struct sock *sk, struct sk_buff *skb)
+{
+	return -EINVAL;
+}
+static inline int tcp_authopt_openreq(struct sock *newsk,
+				      const struct sock *oldsk,
+				      struct request_sock *req)
+{
+	return 0;
+}
+static inline int tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb)
+{
+	return 0;
+}
+#endif
+
+#endif /* _LINUX_TCP_AUTHOPT_H */
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 904909d020e2..1d96030889a1 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -290,10 +290,11 @@ enum
 	LINUX_MIB_TCPDUPLICATEDATAREHASH,	/* TCPDuplicateDataRehash */
 	LINUX_MIB_TCPDSACKRECVSEGS,		/* TCPDSACKRecvSegs */
 	LINUX_MIB_TCPDSACKIGNOREDDUBIOUS,	/* TCPDSACKIgnoredDubious */
 	LINUX_MIB_TCPMIGRATEREQSUCCESS,		/* TCPMigrateReqSuccess */
 	LINUX_MIB_TCPMIGRATEREQFAILURE,		/* TCPMigrateReqFailure */
+	LINUX_MIB_TCPAUTHOPTFAILURE,		/* TCPAuthOptFailure */
 	__LINUX_MIB_MAX
 };
 
 /* linux Xfrm mib definitions */
 enum
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 8fc09e8638b3..30b8ad769871 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -126,10 +126,12 @@ enum {
 #define TCP_INQ			36	/* Notify bytes available to read as a cmsg on read */
 
 #define TCP_CM_INQ		TCP_INQ
 
 #define TCP_TX_DELAY		37	/* delay outgoing packets by XX usec */
+#define TCP_AUTHOPT			38	/* TCP Authentication Option (RFC2385) */
+#define TCP_AUTHOPT_KEY		39	/* TCP Authentication Option update key (RFC2385) */
 
 
 #define TCP_REPAIR_ON		1
 #define TCP_REPAIR_OFF		0
 #define TCP_REPAIR_OFF_NO_WP	-1	/* Turn off without window probes */
@@ -340,10 +342,48 @@ struct tcp_diag_md5sig {
 	__u16	tcpm_keylen;
 	__be32	tcpm_addr[4];
 	__u8	tcpm_key[TCP_MD5SIG_MAXKEYLEN];
 };
 
+/* for TCP_AUTHOPT socket option */
+#define TCP_AUTHOPT_MAXKEYLEN	80
+
+#define TCP_AUTHOPT_ALG_HMAC_SHA_1_96		1
+#define TCP_AUTHOPT_ALG_AES_128_CMAC_96		2
+
+/* Per-socket options */
+struct tcp_authopt {
+	/* No flags currently defined */
+	__u32	flags;
+	/* local_id of preferred output key */
+	__u32	local_send_id;
+};
+
+/* Delete the key by local_id and ignore all fields */
+#define TCP_AUTHOPT_KEY_DEL		(1 << 0)
+/* Exclude TCP options from signature */
+#define TCP_AUTHOPT_KEY_EXCLUDE_OPTS	(1 << 1)
+
+/* Per-key options
+ * Each key is identified by a non-zero local_id which is managed by the application.
+ */
+struct tcp_authopt_key {
+	/* Mix of TCP_AUTHOPT_KEY_ flags */
+	__u32	flags;
+	/* Local identifier */
+	__u32	local_id;
+	/* SendID on the network */
+	__u8	send_id;
+	/* RecvID on the network */
+	__u8	recv_id;
+	/* One of the TCP_AUTHOPT_ALG_* constant */
+	__u8	alg;
+	/* Length of the key buffer */
+	__u8	keylen;
+	__u8	key[TCP_AUTHOPT_MAXKEYLEN];
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
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index b0d3a09dc84e..61dd06f8389c 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -295,10 +295,11 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TcpDuplicateDataRehash", LINUX_MIB_TCPDUPLICATEDATAREHASH),
 	SNMP_MIB_ITEM("TCPDSACKRecvSegs", LINUX_MIB_TCPDSACKRECVSEGS),
 	SNMP_MIB_ITEM("TCPDSACKIgnoredDubious", LINUX_MIB_TCPDSACKIGNOREDDUBIOUS),
 	SNMP_MIB_ITEM("TCPMigrateReqSuccess", LINUX_MIB_TCPMIGRATEREQSUCCESS),
 	SNMP_MIB_ITEM("TCPMigrateReqFailure", LINUX_MIB_TCPMIGRATEREQFAILURE),
+	SNMP_MIB_ITEM("TCPAuthOptFailure", LINUX_MIB_TCPAUTHOPTFAILURE),
 	SNMP_MIB_SENTINEL
 };
 
 static void icmpmsg_put_line(struct seq_file *seq, unsigned long *vals,
 			     unsigned short *type, int count)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8cb44040ec68..3c29bb579d27 100644
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
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
new file mode 100644
index 000000000000..40ee83fc0afe
--- /dev/null
+++ b/net/ipv4/tcp_authopt.c
@@ -0,0 +1,718 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/kernel.h>
+#include <net/tcp.h>
+#include <net/tcp_authopt.h>
+#include <crypto/hash.h>
+#include <trace/events/tcp.h>
+
+/* All current algorithms have a mac length of 12 but crypto API digestsize can be larger */
+#define TCP_AUTHOPT_MAXMACBUF	20
+#define TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN	20
+
+struct tcp_authopt_key_info *__tcp_authopt_key_info_lookup(struct sock *sk,
+							   struct tcp_authopt_info *info,
+							   int key_id)
+{
+	struct tcp_authopt_key_info *key;
+
+	hlist_for_each_entry_rcu(key, &info->head, node, lockdep_sock_is_held(sk))
+		if (key->local_id == key_id)
+			return key;
+
+	return NULL;
+}
+
+struct tcp_authopt_key_info *tcp_authopt_key_info_lookup(struct sock *sk, int key_id)
+{
+	struct tcp_authopt_info *info;
+	struct tcp_authopt_key_info *key;
+
+	info = rcu_dereference_check(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
+	if (!info)
+		return NULL;
+
+	hlist_for_each_entry_rcu(key, &info->head, node, lockdep_sock_is_held(sk))
+		if (key->local_id == key_id)
+			return key;
+
+	return NULL;
+}
+
+int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_authopt opt;
+	struct tcp_authopt_info *info;
+
+	if (optlen < sizeof(opt))
+		return -EINVAL;
+
+	WARN_ON(!lockdep_sock_is_held(sk));
+	if (copy_from_sockptr(&opt, optval, sizeof(opt)))
+		return -EFAULT;
+
+	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
+	if (!info) {
+		info = kmalloc(sizeof(*info), GFP_KERNEL | __GFP_ZERO);
+		if (!info)
+			return -ENOMEM;
+
+		sk_nocaps_add(sk, NETIF_F_GSO_MASK);
+		INIT_HLIST_HEAD(&info->head);
+		rcu_assign_pointer(tp->authopt_info, info);
+	}
+	info->local_send_id = opt.local_send_id;
+
+	return 0;
+}
+
+static void tcp_authopt_key_del(struct sock *sk, struct tcp_authopt_key_info *key)
+{
+	hlist_del_rcu(&key->node);
+	atomic_sub(sizeof(*key), &sk->sk_omem_alloc);
+	kfree_rcu(key, rcu);
+}
+
+/* free info and keys but don't touch tp->authopt_info */
+void __tcp_authopt_info_free(struct sock *sk, struct tcp_authopt_info *info)
+{
+	struct hlist_node *n;
+	struct tcp_authopt_key_info *key;
+
+	hlist_for_each_entry_safe(key, n, &info->head, node)
+		tcp_authopt_key_del(sk, key);
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
+int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
+{
+	struct tcp_authopt_key opt;
+	struct tcp_authopt_info *info;
+	struct tcp_authopt_key_info *key_info;
+	u8 traffic_key_len, maclen;
+
+	if (optlen < sizeof(opt))
+		return -EINVAL;
+
+	if (copy_from_sockptr(&opt, optval, sizeof(opt)))
+		return -EFAULT;
+
+	if (opt.keylen > TCP_AUTHOPT_MAXKEYLEN)
+		return -EINVAL;
+
+	if (opt.local_id == 0)
+		return -EINVAL;
+
+	/* must set authopt before setting keys */
+	info = rcu_dereference_protected(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
+	if (!info)
+		return -EINVAL;
+
+	if (opt.flags & TCP_AUTHOPT_KEY_DEL) {
+		key_info = __tcp_authopt_key_info_lookup(sk, info, opt.local_id);
+		if (!key_info)
+			return -ENOENT;
+		tcp_authopt_key_del(sk, key_info);
+		return 0;
+	}
+
+	/* check the algorithm */
+	if (opt.alg == TCP_AUTHOPT_ALG_HMAC_SHA_1_96) {
+		traffic_key_len = 20;
+		maclen = 12;
+	} else if (opt.alg == TCP_AUTHOPT_ALG_AES_128_CMAC_96) {
+		traffic_key_len = 16;
+		maclen = 12;
+	} else {
+		return -EINVAL;
+	}
+
+	/* If an old value exists for same local_id it is deleted */
+	key_info = __tcp_authopt_key_info_lookup(sk, info, opt.local_id);
+	if (key_info)
+		tcp_authopt_key_del(sk, key_info);
+	key_info = sock_kmalloc(sk, sizeof(*key_info), GFP_KERNEL | __GFP_ZERO);
+	if (!key_info)
+		return -ENOMEM;
+	key_info->local_id = opt.local_id;
+	key_info->flags = opt.flags & TCP_AUTHOPT_KEY_EXCLUDE_OPTS;
+	key_info->send_id = opt.send_id;
+	key_info->recv_id = opt.recv_id;
+	key_info->alg = opt.alg;
+	key_info->keylen = opt.keylen;
+	memcpy(key_info->key, opt.key, opt.keylen);
+	key_info->maclen = maclen;
+	key_info->traffic_key_len = traffic_key_len;
+	hlist_add_head_rcu(&key_info->node, &info->head);
+
+	return 0;
+}
+
+static int tcp_authopt_clone_keys(struct sock *newsk,
+				  const struct sock *oldsk,
+				  struct tcp_authopt_info *new_info,
+				  struct tcp_authopt_info *old_info)
+{
+	struct tcp_authopt_key_info *old_key;
+	struct tcp_authopt_key_info *new_key;
+
+	hlist_for_each_entry_rcu(old_key, &old_info->head, node, lockdep_sock_is_held(sk)) {
+		new_key = sock_kmalloc(newsk, sizeof(*new_key), GFP_KERNEL);
+		if (!new_key)
+			return -ENOMEM;
+		memcpy(new_key, old_key, sizeof(*new_key));
+		hlist_add_head_rcu(&new_key->node, &new_info->head);
+	}
+
+	return 0;
+}
+
+/** Called to create accepted sockets.
+ *
+ *  Need to copy authopt info from listen socket.
+ */
+int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct request_sock *req)
+{
+	struct tcp_authopt_info *old_info;
+	struct tcp_authopt_info *new_info;
+	int err;
+
+	old_info = rcu_dereference(tcp_sk(oldsk)->authopt_info);
+	if (!old_info)
+		return 0;
+
+	new_info = kmalloc(sizeof(*new_info), GFP_KERNEL | __GFP_ZERO);
+	if (!new_info)
+		return -ENOMEM;
+
+	sk_nocaps_add(newsk, NETIF_F_GSO_MASK);
+	new_info->src_isn = tcp_rsk(req)->snt_isn;
+	new_info->dst_isn = tcp_rsk(req)->rcv_isn;
+	new_info->local_send_id = old_info->local_send_id;
+	INIT_HLIST_HEAD(&new_info->head);
+	err = tcp_authopt_clone_keys(newsk, oldsk, new_info, old_info);
+	if (err) {
+		__tcp_authopt_info_free(newsk, new_info);
+		return err;
+	}
+	rcu_assign_pointer(tcp_sk(newsk)->authopt_info, new_info);
+
+	return 0;
+}
+
+/* feed traffic key into shash */
+static int tcp_authopt_shash_traffic_key(struct shash_desc *desc,
+					 struct sock *sk,
+					 struct sk_buff *skb,
+					 bool input,
+					 bool ipv6)
+{
+	struct tcphdr *th = tcp_hdr(skb);
+	int err;
+	__be32 sisn, disn;
+
+	// RFC5926 section 3.1.1.1
+	err = crypto_shash_update(desc, "\x01TCP-AO", 7);
+	if (err)
+		return err;
+
+	/* Addresses from packet on input and from socket on output
+	 * This is because on output MAC is computed before prepending IP header
+	 */
+	if (input) {
+		if (ipv6)
+			err = crypto_shash_update(desc, (u8 *)&ipv6_hdr(skb)->saddr, 32);
+		else
+			err = crypto_shash_update(desc, (u8 *)&ip_hdr(skb)->saddr, 8);
+		if (err)
+			return err;
+	} else {
+		if (ipv6) {
+			struct in6_addr *saddr;
+			struct in6_addr *daddr;
+
+			saddr = &sk->sk_v6_rcv_saddr;
+			daddr = &sk->sk_v6_daddr;
+			err = crypto_shash_update(desc, (u8 *)&sk->sk_v6_rcv_saddr, 16);
+			if (err)
+				return err;
+			err = crypto_shash_update(desc, (u8 *)&sk->sk_v6_daddr, 16);
+			if (err)
+				return err;
+		} else {
+			err = crypto_shash_update(desc, (u8 *)&sk->sk_rcv_saddr, 4);
+			if (err)
+				return err;
+			err = crypto_shash_update(desc, (u8 *)&sk->sk_daddr, 4);
+			if (err)
+				return err;
+		}
+	}
+
+	/* TCP ports from header */
+	err = crypto_shash_update(desc, (u8 *)&th->source, 4);
+	if (err)
+		return err;
+
+	/* special cases for SYN and SYN/ACK */
+	if (th->syn && !th->ack) {
+		sisn = th->seq;
+		disn = 0;
+	} else if (th->syn && th->ack) {
+		sisn = th->seq;
+		disn = htonl(ntohl(th->ack_seq) - 1);
+	} else {
+		struct tcp_authopt_info *authopt_info = rcu_dereference(tcp_sk(sk)->authopt_info);
+		/* authopt was removed from under us, maybe socket deleted? */
+		/* should pass this as an argument instead */
+		if (!authopt_info)
+			return -EINVAL;
+		/* Initial sequence numbers for ESTABLISHED connections from info */
+		if (input) {
+			sisn = htonl(authopt_info->dst_isn);
+			disn = htonl(authopt_info->src_isn);
+		} else {
+			sisn = htonl(authopt_info->src_isn);
+			disn = htonl(authopt_info->dst_isn);
+		}
+	}
+
+	err = crypto_shash_update(desc, (u8 *)&sisn, 4);
+	if (err)
+		return err;
+	err = crypto_shash_update(desc, (u8 *)&disn, 4);
+	if (err)
+		return err;
+
+	/* This hardcodes sha1 digestsize in bits: */
+	err = crypto_shash_update(desc, "\x00\xa0", 2);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int tcp_authopt_get_traffic_key(struct sock *sk,
+				       struct sk_buff *skb,
+				       struct tcp_authopt_key_info *key,
+				       bool input,
+				       bool ipv6,
+				       u8 *traffic_key)
+{
+	SHASH_DESC_ON_STACK(desc, kdf_tfm);
+	struct crypto_shash *kdf_tfm;
+	int err;
+
+	if (key->alg == TCP_AUTHOPT_ALG_HMAC_SHA_1_96)
+		kdf_tfm = crypto_alloc_shash("hmac(sha1)", 0, 0);
+	else
+		return -EINVAL;
+	if (IS_ERR(kdf_tfm))
+		return PTR_ERR(kdf_tfm);
+	if (WARN_ON(crypto_shash_digestsize(kdf_tfm) != key->traffic_key_len)) {
+		err = -ENOBUFS;
+		goto out;
+	}
+
+	err = crypto_shash_setkey(kdf_tfm, key->key, key->keylen);
+	if (err)
+		goto out;
+
+	desc->tfm = kdf_tfm;
+	err = crypto_shash_init(desc);
+	if (err)
+		goto out;
+
+	err = tcp_authopt_shash_traffic_key(desc, sk, skb, input, ipv6);
+	if (err)
+		goto out;
+
+	err = crypto_shash_final(desc, traffic_key);
+	if (err)
+		goto out;
+	//printk("traffic_key: %*phN\n", 20, traffic_key);
+
+out:
+	crypto_free_shash(kdf_tfm);
+	return err;
+}
+
+static int crypto_shash_update_zero(struct shash_desc *desc, int len)
+{
+	u8 zero = 0;
+	int i, err;
+
+	for (i = 0; i < len; ++i) {
+		err = crypto_shash_update(desc, &zero, 1);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int tcp_authopt_hash_tcp4_pseudoheader(struct shash_desc *desc,
+					      __be32 saddr,
+					      __be32 daddr,
+					      int nbytes)
+{
+	struct tcp4_pseudohdr phdr = {
+		.saddr = saddr,
+		.daddr = daddr,
+		.pad = 0,
+		.protocol = IPPROTO_TCP,
+		.len = htons(nbytes)
+	};
+	return crypto_shash_update(desc, (u8 *)&phdr, sizeof(phdr));
+}
+
+static int tcp_authopt_hash_tcp6_pseudoheader(struct shash_desc *desc,
+					      struct in6_addr *saddr,
+					      struct in6_addr *daddr,
+					      u32 plen)
+{
+	int err;
+	u32 buf[2];
+
+	buf[0] = htonl(plen);
+	buf[1] = htonl(IPPROTO_TCP);
+
+	err = crypto_shash_update(desc, (u8 *)saddr, sizeof(*saddr));
+	if (err)
+		return err;
+	err = crypto_shash_update(desc, (u8 *)daddr, sizeof(*daddr));
+	if (err)
+		return err;
+	return crypto_shash_update(desc, (u8 *)&buf, sizeof(buf));
+}
+
+/* TCP authopt as found in header */
+struct tcphdr_authopt {
+	u8 num;
+	u8 len;
+	u8 keyid;
+	u8 rnextkeyid;
+	u8 mac[0];
+};
+
+/* Find TCP_AUTHOPT in header.
+ *
+ * Returns pointer to TCP_AUTHOPT or NULL if not found.
+ */
+static u8 *tcp_authopt_find_option(struct tcphdr *th)
+{
+	int length = (th->doff << 2) - sizeof(*th);
+	u8 *ptr = (u8 *)(th + 1);
+
+	while (length >= 2) {
+		int opcode = *ptr++;
+		int opsize;
+
+		switch (opcode) {
+		case TCPOPT_EOL:
+			return NULL;
+		case TCPOPT_NOP:
+			length--;
+			continue;
+		default:
+			if (length < 2)
+				return NULL;
+			opsize = *ptr++;
+			if (opsize < 2)
+				return NULL;
+			if (opsize > length)
+				return NULL;
+			if (opcode == TCPOPT_AUTHOPT)
+				return ptr - 2;
+		}
+		ptr += opsize - 2;
+		length -= opsize;
+	}
+	return NULL;
+}
+
+/** Hash tcphdr options.
+ *  If include_options is false then only the TCPOPT_AUTHOPT option itself is hashed
+ *  Maybe we could skip option parsing by assuming the AUTHOPT header is at hash_location-4?
+ */
+static int tcp_authopt_hash_opts(struct shash_desc *desc,
+				 struct tcphdr *th,
+				 bool include_options)
+{
+	int err;
+	/* start of options */
+	u8 *tcp_opts = (u8 *)(th + 1);
+	/* end of options */
+	u8 *tcp_data = ((u8 *)th) + th->doff * 4;
+	/* pointer to TCPOPT_AUTHOPT */
+	u8 *authopt_ptr = tcp_authopt_find_option(th);
+	u8 authopt_len;
+
+	if (!authopt_ptr)
+		return -EINVAL;
+	authopt_len = *(authopt_ptr + 1);
+
+	if (include_options) {
+		err = crypto_shash_update(desc, tcp_opts, authopt_ptr - tcp_opts + 4);
+		if (err)
+			return err;
+		err = crypto_shash_update_zero(desc, authopt_len - 4);
+		if (err)
+			return err;
+		err = crypto_shash_update(desc,
+					  authopt_ptr + authopt_len,
+					  tcp_data - (authopt_ptr + authopt_len));
+		if (err)
+			return err;
+	} else {
+		err = crypto_shash_update(desc, authopt_ptr, 4);
+		if (err)
+			return err;
+		err = crypto_shash_update_zero(desc, authopt_len - 4);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int skb_shash_frags(struct shash_desc *desc,
+			   struct sk_buff *skb)
+{
+	struct sk_buff *frag_iter;
+	int err, i;
+
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		skb_frag_t *f = &skb_shinfo(skb)->frags[i];
+		u32 p_off, p_len, copied;
+		struct page *p;
+		u8 *vaddr;
+
+		skb_frag_foreach_page(f, skb_frag_off(f), skb_frag_size(f),
+				      p, p_off, p_len, copied) {
+			vaddr = kmap_atomic(p);
+			err = crypto_shash_update(desc, vaddr + p_off, p_len);
+			kunmap_atomic(vaddr);
+			if (err)
+				return err;
+		}
+	}
+
+	skb_walk_frags(skb, frag_iter) {
+		err = skb_shash_frags(desc, frag_iter);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int tcp_authopt_hash_packet(struct crypto_shash *tfm,
+				   struct sock *sk,
+				   struct sk_buff *skb,
+				   bool input,
+				   bool ipv6,
+				   bool include_options,
+				   u8 *macbuf)
+{
+	struct tcphdr *th = tcp_hdr(skb);
+	SHASH_DESC_ON_STACK(desc, tfm);
+	int err;
+
+	/* NOTE: SNE unimplemented */
+	__be32 sne = 0;
+
+	desc->tfm = tfm;
+	err = crypto_shash_init(desc);
+	if (err)
+		return err;
+
+	err = crypto_shash_update(desc, (u8 *)&sne, 4);
+	if (err)
+		return err;
+
+	if (ipv6) {
+		struct in6_addr *saddr;
+		struct in6_addr *daddr;
+
+		if (input) {
+			saddr = &ipv6_hdr(skb)->saddr;
+			daddr = &ipv6_hdr(skb)->daddr;
+		} else {
+			saddr = &sk->sk_v6_rcv_saddr;
+			daddr = &sk->sk_v6_daddr;
+		}
+		err = tcp_authopt_hash_tcp6_pseudoheader(desc, saddr, daddr, skb->len);
+		if (err)
+			return err;
+	} else {
+		__be32 saddr;
+		__be32 daddr;
+
+		if (input) {
+			saddr = ip_hdr(skb)->saddr;
+			daddr = ip_hdr(skb)->daddr;
+		} else {
+			saddr = sk->sk_rcv_saddr;
+			daddr = sk->sk_daddr;
+		}
+		err = tcp_authopt_hash_tcp4_pseudoheader(desc, saddr, daddr, skb->len);
+		if (err)
+			return err;
+	}
+
+	// TCP header with checksum set to zero
+	{
+		struct tcphdr hashed_th = *th;
+
+		hashed_th.check = 0;
+		err = crypto_shash_update(desc, (u8 *)&hashed_th, sizeof(hashed_th));
+		if (err)
+			return err;
+	}
+
+	// TCP options
+	err = tcp_authopt_hash_opts(desc, th, include_options);
+	if (err)
+		return err;
+
+	// Rest of SKB->data
+	err = crypto_shash_update(desc, (u8 *)th + th->doff * 4, skb_headlen(skb) - th->doff * 4);
+	if (err)
+		return err;
+
+	err = skb_shash_frags(desc, skb);
+	if (err)
+		return err;
+
+	return crypto_shash_final(desc, macbuf);
+}
+
+int __tcp_authopt_calc_mac(struct sock *sk,
+			   struct sk_buff *skb,
+			   struct tcp_authopt_key_info *key,
+			   bool input,
+			   char *macbuf)
+{
+	struct crypto_shash *mac_tfm;
+	u8 traffic_key[TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN];
+	int err;
+	bool ipv6 = (sk->sk_family != AF_INET);
+
+	if (sk->sk_family != AF_INET && sk->sk_family != AF_INET6)
+		return -EINVAL;
+	if (WARN_ON(key->traffic_key_len > sizeof(traffic_key)))
+		return -ENOBUFS;
+
+	err = tcp_authopt_get_traffic_key(sk, skb, key, input, ipv6, traffic_key);
+	if (err)
+		return err;
+
+	if (key->alg == TCP_AUTHOPT_ALG_HMAC_SHA_1_96)
+		mac_tfm = crypto_alloc_shash("hmac(sha1)", 0, 0);
+	else
+		return -EINVAL;
+	if (IS_ERR(mac_tfm))
+		return PTR_ERR(mac_tfm);
+	if (crypto_shash_digestsize(mac_tfm) > TCP_AUTHOPT_MAXMACBUF) {
+		err = -EINVAL;
+		goto out;
+	}
+	err = crypto_shash_setkey(mac_tfm, traffic_key, key->traffic_key_len);
+	if (err)
+		goto out;
+
+	err = tcp_authopt_hash_packet(mac_tfm,
+				      sk,
+				      skb,
+				      input,
+				      ipv6,
+				      !(key->flags & TCP_AUTHOPT_KEY_EXCLUDE_OPTS),
+				      macbuf);
+	//printk("mac: %*phN\n", key->maclen, macbuf);
+
+out:
+	crypto_free_shash(mac_tfm);
+	return err;
+}
+
+int tcp_authopt_hash(char *hash_location,
+		     struct tcp_authopt_key_info *key,
+		     struct sock *sk,
+		     struct sk_buff *skb)
+{
+	/* MAC inside option is truncated to 12 bytes but crypto API needs output
+	 * buffer to be large enough so we use a buffer on the stack.
+	 */
+	u8 macbuf[TCP_AUTHOPT_MAXMACBUF];
+	int err;
+
+	if (WARN_ON(key->maclen > sizeof(macbuf)))
+		return -ENOBUFS;
+
+	err = __tcp_authopt_calc_mac(sk, skb, key, false, macbuf);
+	if (err) {
+		memset(hash_location, 0, key->maclen);
+		return err;
+	}
+	memcpy(hash_location, macbuf, key->maclen);
+
+	return 0;
+}
+
+static struct tcp_authopt_key_info *tcp_authopt_inbound_key_lookup(struct sock *sk,
+								   struct tcp_authopt_info *info,
+								   u8 recv_id)
+{
+	struct tcp_authopt_key_info *key;
+
+	/* multiple matches will cause occasional failures */
+	hlist_for_each_entry_rcu(key, &info->head, node, 0)
+		if (key->recv_id == recv_id)
+			return key;
+
+	return NULL;
+}
+
+int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp_authopt_info *info)
+{
+	struct tcphdr *th = (struct tcphdr *)skb_transport_header(skb);
+	struct tcphdr_authopt *opt = (struct tcphdr_authopt *)tcp_authopt_find_option(th);
+	struct tcp_authopt_key_info *key;
+	u8 macbuf[16];
+	int err;
+
+	/* wrong, should reject if missing key: */
+	if (!opt)
+		return 0;
+
+	key = tcp_authopt_inbound_key_lookup(sk, info, opt->keyid);
+	/* bad inbound key len */
+	if (key->maclen + 4 != opt->len)
+		return -EINVAL;
+
+	err = __tcp_authopt_calc_mac(sk, skb, key, true, macbuf);
+	if (err)
+		return err;
+
+	if (memcmp(macbuf, opt->mac, key->maclen)) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
+		net_info_ratelimited("TCP Authentication Failed\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 149ceb5c94ff..9cd540c42d3f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -70,10 +70,11 @@
 #include <linux/sysctl.h>
 #include <linux/kernel.h>
 #include <linux/prefetch.h>
 #include <net/dst.h>
 #include <net/tcp.h>
+#include <net/tcp_authopt.h>
 #include <net/inet_common.h>
 #include <linux/ipsec.h>
 #include <asm/unaligned.h>
 #include <linux/errqueue.h>
 #include <trace/events/tcp.h>
@@ -5935,18 +5936,34 @@ void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb)
 	if (!icsk->icsk_ca_initialized)
 		tcp_init_congestion_control(sk);
 	tcp_init_buffer_space(sk);
 }
 
+static void tcp_authopt_finish_connect(struct sock *sk, struct sk_buff *skb)
+{
+#ifdef CONFIG_TCP_AUTHOPT
+	struct tcp_authopt_info *info;
+
+	info = rcu_dereference_protected(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
+	if (!info)
+		return;
+
+	info->src_isn = ntohl(tcp_hdr(skb)->ack_seq) - 1;
+	info->dst_isn = ntohl(tcp_hdr(skb)->seq);
+#endif
+}
+
 void tcp_finish_connect(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
 	tcp_set_state(sk, TCP_ESTABLISHED);
 	icsk->icsk_ack.lrcvtime = tcp_jiffies32;
 
+	tcp_authopt_finish_connect(sk, skb);
+
 	if (skb) {
 		icsk->icsk_af_ops->sk_rx_dst_set(sk, skb);
 		security_inet_conn_established(sk, skb);
 		sk_mark_napi_id(sk, skb);
 	}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b9dc2d6197be..b0e25c6d40eb 100644
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
@@ -2059,10 +2060,13 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		goto discard_and_relse;
 
 	if (tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))
 		goto discard_and_relse;
 
+	if (tcp_authopt_inbound_check(sk, skb))
+		goto discard_and_relse;
+
 	nf_reset_ct(skb);
 
 	if (tcp_filter(sk, skb))
 		goto discard_and_relse;
 	th = (const struct tcphdr *)skb->data;
@@ -2256,10 +2260,11 @@ void tcp_v4_destroy_sock(struct sock *sk)
 		tcp_clear_md5_list(sk);
 		kfree_rcu(rcu_dereference_protected(tp->md5sig_info, 1), rcu);
 		tp->md5sig_info = NULL;
 	}
 #endif
+	tcp_authopt_clear(sk);
 
 	/* Clean up a referenced TCP bind bucket. */
 	if (inet_csk(sk)->icsk_bind_hash)
 		inet_put_port(sk);
 
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 0a4f3f16140a..4d7d86547b0e 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -24,10 +24,11 @@
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 #include <linux/workqueue.h>
 #include <linux/static_key.h>
 #include <net/tcp.h>
+#include <net/tcp_authopt.h>
 #include <net/inet_common.h>
 #include <net/xfrm.h>
 #include <net/busy_poll.h>
 
 static bool tcp_in_window(u32 seq, u32 end_seq, u32 s_win, u32 e_win)
@@ -539,10 +540,11 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 #ifdef CONFIG_TCP_MD5SIG
 	newtp->md5sig_info = NULL;	/*XXX*/
 	if (newtp->af_specific->md5_lookup(sk, newsk))
 		newtp->tcp_header_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
+	tcp_authopt_openreq(newsk, sk, req);
 	if (skb->len >= TCP_MSS_DEFAULT + newtp->tcp_header_len)
 		newicsk->icsk_ack.last_seg_size = skb->len - newtp->tcp_header_len;
 	newtp->rx_opt.mss_clamp = req->mss;
 	tcp_ecn_openreq_child(newtp, req);
 	newtp->fastopen_req = NULL;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 29553fce8502..2a680acca73d 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -37,10 +37,11 @@
 
 #define pr_fmt(fmt) "TCP: " fmt
 
 #include <net/tcp.h>
 #include <net/mptcp.h>
+#include <net/tcp_authopt.h>
 
 #include <linux/compiler.h>
 #include <linux/gfp.h>
 #include <linux/module.h>
 #include <linux/static_key.h>
@@ -411,10 +412,11 @@ static inline bool tcp_urg_mode(const struct tcp_sock *tp)
 
 #define OPTION_SACK_ADVERTISE	(1 << 0)
 #define OPTION_TS		(1 << 1)
 #define OPTION_MD5		(1 << 2)
 #define OPTION_WSCALE		(1 << 3)
+#define OPTION_AUTHOPT		(1 << 4)
 #define OPTION_FAST_OPEN_COOKIE	(1 << 8)
 #define OPTION_SMC		(1 << 9)
 #define OPTION_MPTCP		(1 << 10)
 
 static void smc_options_write(__be32 *ptr, u16 *options)
@@ -435,16 +437,21 @@ static void smc_options_write(__be32 *ptr, u16 *options)
 struct tcp_out_options {
 	u16 options;		/* bit field of OPTION_* */
 	u16 mss;		/* 0 to disable */
 	u8 ws;			/* window scale, 0 to disable */
 	u8 num_sack_blocks;	/* number of SACK blocks to include */
-	u8 hash_size;		/* bytes in hash_location */
 	u8 bpf_opt_len;		/* length of BPF hdr option */
+#ifdef CONFIG_TCP_AUTHOPT
+	u8 authopt_rnextkeyid;
+#endif
 	__u8 *hash_location;	/* temporary pointer, overloaded */
 	__u32 tsval, tsecr;	/* need to include OPTION_TS */
 	struct tcp_fastopen_cookie *fastopen_cookie;	/* Fast open cookie */
 	struct mptcp_out_options mptcp;
+#ifdef CONFIG_TCP_AUTHOPT
+	struct tcp_authopt_key_info *authopt_key;
+#endif
 };
 
 static void mptcp_options_write(__be32 *ptr, const struct tcp_sock *tp,
 				struct tcp_out_options *opts)
 {
@@ -617,10 +624,24 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
 		/* overload cookie hash location */
 		opts->hash_location = (__u8 *)ptr;
 		ptr += 4;
 	}
 
+#ifdef CONFIG_TCP_AUTHOPT
+	if (unlikely(OPTION_AUTHOPT & options)) {
+		struct tcp_authopt_key_info *key = opts->authopt_key;
+
+		WARN_ON(!key);
+		*ptr++ = htonl((TCPOPT_AUTHOPT << 24) | ((4 + key->maclen) << 16) |
+			       (key->send_id << 8) | opts->authopt_rnextkeyid);
+		/* overload cookie hash location */
+		opts->hash_location = (__u8 *)ptr;
+		/* maclen is currently always 12 but try to align nicely anyway. */
+		ptr += (key->maclen + 3) / 4;
+	}
+#endif
+
 	if (unlikely(opts->mss)) {
 		*ptr++ = htonl((TCPOPT_MSS << 24) |
 			       (TCPOLEN_MSS << 16) |
 			       opts->mss);
 	}
@@ -752,10 +773,37 @@ static void mptcp_set_option_cond(const struct request_sock *req,
 			}
 		}
 	}
 }
 
+static int tcp_authopt_init_options(const struct sock *sk,
+				    struct tcp_out_options *opts)
+{
+#ifdef CONFIG_TCP_AUTHOPT
+	struct tcp_authopt_info *info;
+	struct tcp_authopt_key_info *key;
+
+	info = rcu_dereference_check(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
+
+	if (!info)
+		return 0;
+
+	if (!info->local_send_id)
+		return 0;
+
+	key = tcp_authopt_key_info_lookup((struct sock *)sk, info->local_send_id);
+	if (key) {
+		opts->options |= OPTION_AUTHOPT;
+		opts->authopt_key = key;
+		opts->authopt_rnextkeyid = info->rnextkeyid;
+		return 4 + key->maclen;
+	}
+#endif
+
+	return 0;
+}
+
 /* Compute TCP options for SYN packets. This is not the final
  * network wire format yet.
  */
 static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 				struct tcp_out_options *opts,
@@ -774,10 +822,11 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 			opts->options |= OPTION_MD5;
 			remaining -= TCPOLEN_MD5SIG_ALIGNED;
 		}
 	}
 #endif
+	remaining -= tcp_authopt_init_options(sk, opts);
 
 	/* We always get an MSS option.  The option bytes which will be seen in
 	 * normal data packets should timestamps be used, must be in the MSS
 	 * advertised.  But we subtract them from tp->mss_cache so that
 	 * calculations in tcp_sendmsg are simpler etc.  So account for this
@@ -862,10 +911,11 @@ static unsigned int tcp_synack_options(const struct sock *sk,
 		 */
 		if (synack_type != TCP_SYNACK_COOKIE)
 			ireq->tstamp_ok &= !ireq->sack_ok;
 	}
 #endif
+	remaining -= tcp_authopt_init_options(sk, opts);
 
 	/* We always send an MSS option. */
 	opts->mss = mss;
 	remaining -= TCPOLEN_MSS_ALIGNED;
 
@@ -930,10 +980,11 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 			opts->options |= OPTION_MD5;
 			size += TCPOLEN_MD5SIG_ALIGNED;
 		}
 	}
 #endif
+	size += tcp_authopt_init_options(sk, opts);
 
 	if (likely(tp->rx_opt.tstamp_ok)) {
 		opts->options |= OPTION_TS;
 		opts->tsval = skb ? tcp_skb_timestamp(skb) + tp->tsoffset : 0;
 		opts->tsecr = tp->rx_opt.ts_recent;
@@ -1365,10 +1416,17 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 		sk_nocaps_add(sk, NETIF_F_GSO_MASK);
 		tp->af_specific->calc_md5_hash(opts.hash_location,
 					       md5, sk, skb);
 	}
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	if (opts.authopt_key) {
+		sk_nocaps_add(sk, NETIF_F_GSO_MASK);
+		err = tcp_authopt_hash(opts.hash_location, opts.authopt_key, sk, skb);
+		WARN_ON(err); // FIXME
+	}
+#endif
 
 	/* BPF prog is the last one writing header option */
 	bpf_skops_write_hdr_opt(sk, skb, NULL, NULL, 0, &opts);
 
 	INDIRECT_CALL_INET(icsk->icsk_af_ops->send_check,
@@ -3602,10 +3660,15 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	if (md5)
 		tcp_rsk(req)->af_specific->calc_md5_hash(opts.hash_location,
 					       md5, req_to_sk(req), skb);
 	rcu_read_unlock();
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	/* If signature fails we do nothing */
+	if (opts.authopt_key)
+		tcp_authopt_hash(opts.hash_location, opts.authopt_key, req_to_sk(req), skb);
+#endif
 
 	bpf_skops_write_hdr_opt((struct sock *)sk, skb, req, syn_skb,
 				synack_type, &opts);
 
 	skb->skb_mstamp_ns = now;

base-commit: 0d6835ffe50c9c1f098b5704394331710b67af48
-- 
2.25.1

