Return-Path: <netdev+bounces-10913-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C970D730B2C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:10:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 852E32815C3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8695B156CC;
	Wed, 14 Jun 2023 23:10:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEA7156C8
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:10:01 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CCA2695
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:09:59 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f8d176396bso11947575e9.2
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1686784198; x=1689376198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3rl4FSD4EKf5+kERYAHkd5kR5jLpzWtrJiZ0tVBw9VE=;
        b=X+qXjAlsUvh9yrJc/bkdG9AkToaGI1OoaFa7WEjS/SQGWWAL52lglAuE3Li/VSC1Rs
         2IEeFr5T+6CrMej6Mo1t1ckc3mXB3oqL9j/8u3y2YIlPLAaP0b17xp4HmyCdUgQck/KB
         XEMyh6JfxlcJlaKvyHm0v2hpUA0JGdhP3Y4L5mw30LMhnXviYlUy4og5JMdwePX6z1oT
         gj56DmIPby488Nc+eR/lz++C3fx1MVR0UwZX0cxJn2CaRva2zcR0mAJzYl40IRgk9oYd
         Z/jUnLBLt8OVGTsaYzprILSGt3h0EjppFC9LBUygrjeZjfPTfJf+njIUJXyvi8zmC5OZ
         iclA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686784198; x=1689376198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3rl4FSD4EKf5+kERYAHkd5kR5jLpzWtrJiZ0tVBw9VE=;
        b=ELz0hMEk/1CGav2tQ278DHa+BrK6xzs7DsSRcRvCBey8Vcxh5TLPaOxmWRcQB6pWNr
         KlbibPtY09GyM1uBeFYS7qwpdZPagaN7d+8w9RDDDPNv0SLf/DQKcsSfXFwHHGVA19sB
         vgAaKHOvC4XX5fJS9LSsOGtDkq7l9SoaOgKK1pbFKTdjxgaYX8grKyzoUv90v5qwYd3h
         pYz8E25DbL+qeJ8KtFS+/I3nSNOVNOBrOBYbRbJAR2abhHSG1wAwFX5Yy9ZHDnJec6S4
         z4EzLiK+8kUAQ736ReQpzQzaA9x+HOrrQ5LBGelfqX7+mBv+iFwhvTtpNNLqZ4LSYUbb
         jURg==
X-Gm-Message-State: AC+VfDypQKL1vd1gR0e3FECockCadtxyibUycJ/99owQ1RSDKyf4CYTR
	DsFj6HTUg6hK9vLU0U2dkeYO1w==
X-Google-Smtp-Source: ACHHUZ4BGB6HcZSLnZ2jk9SOMM7n3aUR5p9bbSLc//yAJbLBTIaqy/LoDF7bJ2oLLjO+6pF4LYP5KQ==
X-Received: by 2002:a05:600c:211:b0:3f7:ed1e:5a21 with SMTP id 17-20020a05600c021100b003f7ed1e5a21mr13108541wmi.38.1686784197966;
        Wed, 14 Jun 2023 16:09:57 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s12-20020a7bc38c000000b003f7ba52eeccsm18725261wmj.7.2023.06.14.16.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 16:09:57 -0700 (PDT)
From: Dmitry Safonov <dima@arista.com>
To: David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
	Dmitry Safonov <dima@arista.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Bob Gilligan <gilligan@arista.com>,
	Dan Carpenter <error27@gmail.com>,
	David Laight <David.Laight@aculab.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Donald Cassidy <dcassidy@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Ivan Delalande <colona@arista.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>,
	netdev@vger.kernel.org
Subject: [PATCH v7 02/22] net/tcp: Add TCP-AO config and structures
Date: Thu, 15 Jun 2023 00:09:27 +0100
Message-Id: <20230614230947.3954084-3-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230614230947.3954084-1-dima@arista.com>
References: <20230614230947.3954084-1-dima@arista.com>
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
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Introduce new kernel config option and common structures as well as
helpers to be used by TCP-AO code.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/tcp.h      |  9 +++-
 include/net/tcp.h        |  8 +---
 include/net/tcp_ao.h     | 96 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/tcp.h |  2 +
 net/ipv4/Kconfig         | 13 ++++++
 5 files changed, 120 insertions(+), 8 deletions(-)
 create mode 100644 include/net/tcp_ao.h

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index b4c08ac86983..673b32e47c30 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -435,13 +435,18 @@ struct tcp_sock {
 	bool	syn_smc;	/* SYN includes SMC */
 #endif
 
-#ifdef CONFIG_TCP_MD5SIG
-/* TCP AF-Specific parts; only used by MD5 Signature support so far */
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
+/* TCP AF-Specific parts; only used by TCP-AO/MD5 Signature support so far */
 	const struct tcp_sock_af_ops	*af_specific;
 
+#ifdef CONFIG_TCP_MD5SIG
 /* TCP MD5 Signature Option information */
 	struct tcp_md5sig_info	__rcu *md5sig_info;
 #endif
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info	__rcu *ao_info;
+#endif
+#endif
 
 /* TCP fastopen related information */
 	struct tcp_fastopen_request *fastopen_req;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 81134a70c9ba..c3f1eb550cf1 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -37,6 +37,7 @@
 #include <net/snmp.h>
 #include <net/ip.h>
 #include <net/tcp_states.h>
+#include <net/tcp_ao.h>
 #include <net/inet_ecn.h>
 #include <net/dst.h>
 #include <net/mptcp.h>
@@ -1621,12 +1622,7 @@ static inline void tcp_clear_all_retrans_hints(struct tcp_sock *tp)
 	tp->retransmit_skb_hint = NULL;
 }
 
-union tcp_md5_addr {
-	struct in_addr  a4;
-#if IS_ENABLED(CONFIG_IPV6)
-	struct in6_addr	a6;
-#endif
-};
+#define tcp_md5_addr tcp_ao_addr
 
 /* - key database */
 struct tcp_md5sig_key {
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
new file mode 100644
index 000000000000..234ae371043b
--- /dev/null
+++ b/include/net/tcp_ao.h
@@ -0,0 +1,96 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _TCP_AO_H
+#define _TCP_AO_H
+
+#define TCP_AO_MAX_HASH_SIZE	64
+#define TCP_AO_KEY_ALIGN	1
+#define __tcp_ao_key_align __aligned(TCP_AO_KEY_ALIGN)
+
+union tcp_ao_addr {
+	struct in_addr  a4;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct in6_addr	a6;
+#endif
+};
+
+struct tcp_ao_hdr {
+	u8	kind;
+	u8	length;
+	u8	keyid;
+	u8	rnext_keyid;
+};
+
+struct tcp_ao_key {
+	struct hlist_node	node;
+	union tcp_ao_addr	addr;
+	u8			key[TCP_AO_MAXKEYLEN] __tcp_ao_key_align;
+	unsigned int		tcp_sigpool_id;
+	u16			port;
+	u8			prefixlen;
+	u8			family;
+	u8			keylen;
+	u8			keyflags;
+	u8			sndid;
+	u8			rcvid;
+	u8			maclen;
+	u8			digest_size;
+	struct rcu_head		rcu;
+	u8			traffic_keys[];
+};
+
+static inline u8 *rcv_other_key(struct tcp_ao_key *key)
+{
+	return key->traffic_keys;
+}
+
+static inline u8 *snd_other_key(struct tcp_ao_key *key)
+{
+	return key->traffic_keys + key->digest_size;
+}
+
+static inline int tcp_ao_maclen(const struct tcp_ao_key *key)
+{
+	return key->maclen;
+}
+
+static inline int tcp_ao_sizeof_key(const struct tcp_ao_key *key)
+{
+	return sizeof(struct tcp_ao_key) + (TCP_AO_MAX_HASH_SIZE << 1);
+}
+
+static inline int tcp_ao_len(const struct tcp_ao_key *key)
+{
+	return tcp_ao_maclen(key) + sizeof(struct tcp_ao_hdr);
+}
+
+static inline unsigned int tcp_ao_digest_size(struct tcp_ao_key *key)
+{
+	return key->digest_size;
+}
+
+struct tcp_ao_info {
+	/* List of tcp_ao_key's */
+	struct hlist_head	head;
+	/* current_key and rnext_key aren't maintained on listen sockets.
+	 * Their purpose is to cache keys on established connections,
+	 * saving needless lookups. Never dereference any of them from
+	 * listen sockets.
+	 * ::current_key may change in RX to the key that was requested by
+	 * the peer, please use READ_ONCE()/WRITE_ONCE() in order to avoid
+	 * load/store tearing.
+	 * Do the same for ::rnext_key, if you don't hold socket lock
+	 * (it's changed only by userspace request in setsockopt()).
+	 */
+	struct tcp_ao_key	*current_key;
+	struct tcp_ao_key	*rnext_key;
+	u32			flags;
+	__be32			lisn;
+	__be32			risn;
+	u32			snd_sne;
+	u32			snd_sne_seq;
+	u32			rcv_sne;
+	u32			rcv_sne_seq;
+	struct rcu_head		rcu;
+};
+
+#endif /* _TCP_AO_H */
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 879eeb0a084b..5655bfe28b8d 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -348,6 +348,8 @@ struct tcp_diag_md5sig {
 	__u8	tcpm_key[TCP_MD5SIG_MAXKEYLEN];
 };
 
+#define TCP_AO_MAXKEYLEN	80
+
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 89e2ab023272..2bcda91462c8 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -744,6 +744,19 @@ config DEFAULT_TCP_CONG
 config TCP_SIGPOOL
 	tristate
 
+config TCP_AO
+	bool "TCP: Authentication Option (RFC5925)"
+	select CRYPTO
+	select TCP_SIGPOOL
+	depends on 64BIT # seq-number extension needs WRITE_ONCE(u64)
+	help
+	  TCP-AO specifies the use of stronger Message Authentication Codes (MACs),
+	  protects against replays for long-lived TCP connections, and
+	  provides more details on the association of security with TCP
+	  connections than TCP MD5 (See RFC5925)
+
+	  If unsure, say N.
+
 config TCP_MD5SIG
 	bool "TCP: MD5 Signature Option support (RFC2385)"
 	select CRYPTO
-- 
2.40.0


