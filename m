Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF20F6102FC
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbiJ0UoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236893AbiJ0UoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:44:22 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B07592589
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:44:06 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id k8so4192960wrh.1
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tx4iE3mqN7DCr9Gvb0u5N1VFE5hSDH0Bo2werB0KHqI=;
        b=k/PqpZoEJSu3wMUA6lPEaH88OBn0IqxNQfwO/2dDSQ+1EcR22Qg34IPOk63pQcxTlY
         g2GjidiGSLKBI0OBRwrz9lIAOerZjca92TFAR2ca4Fjbu5ZuZgRug902F3LgLCo6qSbt
         M1le4bcsFsq/NrGwroXAqyGIiIErdhlA7i/TdPXjd83fsl6GNslOp67DTt5Ak2o5Kxc9
         vZ8YIR3ByEVGYG+2OYhAKZFJrFa42EvIt24MV0hKSnrSVlzCg8kV1ufd93tUxgtQlCIx
         cv4I4DLBFVVo6FS7SNxweD4eWm8jDvOOT3ERxFHSBwgA5xoLaIrSBCr1Gu/Xaw3KS54k
         eXgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tx4iE3mqN7DCr9Gvb0u5N1VFE5hSDH0Bo2werB0KHqI=;
        b=OhtArDzaB3KZtSrw/Ssrbz3l7uDR46ER6N15feOuqf2fhfViY4w9cshsdC2aGIrN2v
         h2dTAcPU8vwKhbaAmnVehT4eIdBh6E3G4SNVbs21iZjM2rU1nfBocPViaTCmTIZvdKg5
         aLLKe1KXAgMeqoBcHDrkE33eWyeGozhocF401WyldO4c+74qOgid+CZW7eZpefNFQ3wV
         krTakGcxvLCU+1aOBMTuXlt0eeLsaEvwM+YiafvJxhTWJyh862oCa6hiIJnH1yUTBEag
         dPlIi//L9oSeSLNsMG9C4Cvx3zk6b7XgCKPrnkDlf2vw5TYhsmtzwMkkrsH0ZtqRc+yq
         hBhQ==
X-Gm-Message-State: ACrzQf24AN7hQGL/bnIB+ni8297BnrShCKRjPXl+Rkk7byrWCOrgkzrI
        JYSWuhtQE3AXLTeGf3rUAo6Dew==
X-Google-Smtp-Source: AMsMyM4ssOcJNh0i5IJBtAtszTpkSoBGAqeg5vcYzmvVp0UgUym6nlNFgCiBwnX0xmpjrZqx+B/OAg==
X-Received: by 2002:adf:e510:0:b0:235:de50:72ff with SMTP id j16-20020adfe510000000b00235de5072ffmr25535605wrm.100.1666903445792;
        Thu, 27 Oct 2022 13:44:05 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:44:05 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
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
Subject: [PATCH v3 07/36] tcp: Add TCP-AO config and structures
Date:   Thu, 27 Oct 2022 21:43:18 +0100
Message-Id: <20221027204347.529913-8-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027204347.529913-1-dima@arista.com>
References: <20221027204347.529913-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 include/net/tcp_ao.h     | 90 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/tcp.h |  2 +
 net/ipv4/Kconfig         | 12 ++++++
 5 files changed, 113 insertions(+), 8 deletions(-)
 create mode 100644 include/net/tcp_ao.h

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 41b1da621a45..fd248875b0a9 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -434,13 +434,18 @@ struct tcp_sock {
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
index 03dbe1940fec..3395a925dc6e 100644
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
@@ -1615,12 +1616,7 @@ static inline void tcp_clear_all_retrans_hints(struct tcp_sock *tp)
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
index 000000000000..39b3fc31e5a1
--- /dev/null
+++ b/include/net/tcp_ao.h
@@ -0,0 +1,90 @@
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
+	unsigned int		crypto_pool_id;
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
+	struct hlist_head	head;
+	struct rcu_head		rcu;
+	/* current_key and rnext_key aren't maintained on listen sockets.
+	 * Their purpose is to cache keys on established connections,
+	 * saving needless lookups. Never dereference any of them from
+	 * listen sockets.
+	 */
+	struct tcp_ao_key	*volatile current_key;
+	struct tcp_ao_key	*rnext_key;
+	u8			ao_flags;
+	__be32			lisn;
+	__be32			risn;
+	u32			snd_sne;
+	u32			snd_sne_seq;
+	u32			rcv_sne;
+	u32			rcv_sne_seq;
+};
+
+#endif /* _TCP_AO_H */
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 8fc09e8638b3..849bbf2d3c38 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -342,6 +342,8 @@ struct tcp_diag_md5sig {
 	__u8	tcpm_key[TCP_MD5SIG_MAXKEYLEN];
 };
 
+#define TCP_AO_MAXKEYLEN	80
+
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index c341864e4398..4a78f3e0199e 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -731,6 +731,18 @@ config DEFAULT_TCP_CONG
 	default "bbr" if DEFAULT_BBR
 	default "cubic"
 
+config TCP_AO
+	bool "TCP: Authentication Option (RFC5925)"
+	select CRYPTO
+	select CRYPTO_POOL
+	depends on 64BIT # seq-number extension needs WRITE_ONCE(u64)
+	default y
+	help
+	  TCP-AO specifies the use of stronger Message Authentication Codes (MACs),
+	  protects against replays for long-lived TCP connections, and
+	  provides more details on the association of security with TCP
+	  connections than TCP MD5 (See RFC5925)
+
 config TCP_MD5SIG
 	bool "TCP: MD5 Signature Option support (RFC2385)"
 	select CRYPTO_POOL
-- 
2.38.1

