Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B98E47E5AD
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 16:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349220AbhLWPlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 10:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349012AbhLWPk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 10:40:57 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B2FC0617A1;
        Thu, 23 Dec 2021 07:40:55 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id j21so22920883edt.9;
        Thu, 23 Dec 2021 07:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QbGn+12SmWm9XZSkxI+H9M/uSYS0f/ErlL5WlEkQuTY=;
        b=adsLgII17gxA8WfT3MHq0YtX5IWhIk3It+CB9roewYAaJ6YTFssvKYEv6jG/TFZ1Pi
         GBxoZZRLm+DQNLG0tvZpG/A8vbpbSIn/o2MrOBVNm6zkbtcSLzLI23dGPRWponHAuzJI
         6MYDCpqMccmhE/PVRunZrqFOMHrAtBwhQfr5XW1SyWf03tSkx0Nl750+Yf17VG8r/ufb
         CRKXf4NnWC6X2ioHI0iEYG0OFuDSODjT0muOUySGPh2nGYBN9kC0X0kA4fDmDaUHka7G
         fYN26/RdBGNhQvSX02kNZiYDqJwhNJma6wB7U2pM7uzt875V5vav2XuSj+1apU4NRaR0
         zo/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QbGn+12SmWm9XZSkxI+H9M/uSYS0f/ErlL5WlEkQuTY=;
        b=70xeKX6JwahQNuFKBu0stotyH9GO3Ek6BRkNRzv5933BXb03jwsfrSMFlAygm7PLeF
         bQvPBgM12Fb+ew3ZlH/n4JbpOVa5oNCBd3ADHGYRb+vtZfjxv1tN3qHDZFud1nLff+Vw
         cv0L1ay40btgrxb0a5ld9+vpSYX/nJAlv2Xpbcq9aH0ySDWPusmfk7WXzV1TUEEOJtoX
         lZFlYHTJIEDp3pe4v1ZIkkPSOoLQtsoidbW8qPu1+uIag5JZuTnmySal1ZCTBWXwAd1U
         MAzfg8m1OfHri8XsDXRmx0Hksh8o6eqJASeeLxJ0/9q4mW6QmZvCZz1Vo+za1Uzi8E/G
         P3tA==
X-Gm-Message-State: AOAM531YJZTdmBOWNPGWlV0xEoUgjQfgbjn9pbtF5Pk2H6NnP9hSUhN8
        DH2XOL5k1SVyWucuPVY9RHo=
X-Google-Smtp-Source: ABdhPJyLwLWPO0ernvKv6pby6H04cOtGTdeAie5twflvYJL6MdBAbl7XJ6oS5pS8vUi4NUICM9VUwg==
X-Received: by 2002:a17:907:2be9:: with SMTP id gv41mr2438145ejc.468.1640274054324;
        Thu, 23 Dec 2021 07:40:54 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:7c02:dfc6:b554:ab10])
        by smtp.gmail.com with ESMTPSA id bx6sm2088617edb.78.2021.12.23.07.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 07:40:53 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
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
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 10/19] tcp: authopt: Add support for signing skb-less replies
Date:   Thu, 23 Dec 2021 17:40:05 +0200
Message-Id: <95cd9a5582e868083d742548d35f39eb6584211b.1640273966.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1640273966.git.cdleonard@gmail.com>
References: <cover.1640273966.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is required because tcp ipv4 sometimes sends replies without
allocating a full skb that can be signed by tcp authopt.

Handle this with additional code in tcp authopt.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp_authopt.h |   7 ++
 net/ipv4/tcp_authopt.c    | 144 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 151 insertions(+)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 6e9b5ca22f62..9ee5165388b1 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -115,10 +115,17 @@ static inline struct tcp_authopt_key_info *tcp_authopt_select_key(
 int tcp_authopt_hash(
 		char *hash_location,
 		struct tcp_authopt_key_info *key,
 		struct tcp_authopt_info *info,
 		struct sock *sk, struct sk_buff *skb);
+int tcp_v4_authopt_hash_reply(
+		char *hash_location,
+		struct tcp_authopt_info *info,
+		struct tcp_authopt_key_info *key,
+		__be32 saddr,
+		__be32 daddr,
+		struct tcphdr *th);
 int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct request_sock *req);
 static inline int tcp_authopt_openreq(
 		struct sock *newsk,
 		const struct sock *oldsk,
 		struct request_sock *req)
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index dbe92c87af5a..6803fc39f9b6 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -922,10 +922,72 @@ static int tcp_authopt_get_traffic_key(struct sock *sk,
 out:
 	tcp_authopt_put_kdf_pool(key, pool);
 	return err;
 }
 
+struct tcp_v4_authopt_context_data {
+	__be32 saddr;
+	__be32 daddr;
+	__be16 sport;
+	__be16 dport;
+	__be32 sisn;
+	__be32 disn;
+	__be16 digestbits;
+} __packed;
+
+static int tcp_v4_authopt_get_traffic_key_noskb(struct tcp_authopt_key_info *key,
+						__be32 saddr,
+						__be32 daddr,
+						__be16 sport,
+						__be16 dport,
+						__be32 sisn,
+						__be32 disn,
+						u8 *traffic_key)
+{
+	int err;
+	struct tcp_authopt_alg_pool *pool;
+	struct tcp_v4_authopt_context_data data;
+
+	BUILD_BUG_ON(sizeof(data) != 22);
+
+	pool = tcp_authopt_get_kdf_pool(key);
+	if (IS_ERR(pool))
+		return PTR_ERR(pool);
+
+	err = tcp_authopt_setkey(pool, key);
+	if (err)
+		goto out;
+	err = crypto_ahash_init(pool->req);
+	if (err)
+		goto out;
+
+	// RFC5926 section 3.1.1.1
+	// Separate to keep alignment semi-sane
+	err = crypto_ahash_buf(pool->req, "\x01TCP-AO", 7);
+	if (err)
+		return err;
+	data.saddr = saddr;
+	data.daddr = daddr;
+	data.sport = sport;
+	data.dport = dport;
+	data.sisn = sisn;
+	data.disn = disn;
+	data.digestbits = htons(crypto_ahash_digestsize(pool->tfm) * 8);
+
+	err = crypto_ahash_buf(pool->req, (u8 *)&data, sizeof(data));
+	if (err)
+		goto out;
+	ahash_request_set_crypt(pool->req, NULL, traffic_key, 0);
+	err = crypto_ahash_final(pool->req);
+	if (err)
+		goto out;
+
+out:
+	tcp_authopt_put_kdf_pool(key, pool);
+	return err;
+}
+
 static int crypto_ahash_buf_zero(struct ahash_request *req, int len)
 {
 	u8 zeros[TCP_AUTHOPT_MACLEN] = {0};
 	int buflen, err;
 
@@ -1185,10 +1247,92 @@ int tcp_authopt_hash(char *hash_location,
 	memset(hash_location, 0, TCP_AUTHOPT_MACLEN);
 	return err;
 }
 EXPORT_SYMBOL(tcp_authopt_hash);
 
+/**
+ * tcp_v4_authopt_hash_reply - Hash tcp+ipv4 header without SKB
+ *
+ * @hash_location: output buffer
+ * @info: sending socket's tcp_authopt_info
+ * @key: signing key, from tcp_authopt_select_key.
+ * @saddr: source address
+ * @daddr: destination address
+ * @th: Pointer to TCP header and options
+ */
+int tcp_v4_authopt_hash_reply(char *hash_location,
+			      struct tcp_authopt_info *info,
+			      struct tcp_authopt_key_info *key,
+			      __be32 saddr,
+			      __be32 daddr,
+			      struct tcphdr *th)
+{
+	struct tcp_authopt_alg_pool *pool;
+	u8 macbuf[TCP_AUTHOPT_MAXMACBUF];
+	u8 traffic_key[TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN];
+	__be32 sne = 0;
+	int err;
+
+	/* Call special code path for computing traffic key without skb
+	 * This can be called from tcp_v4_reqsk_send_ack so caching would be
+	 * difficult here.
+	 */
+	err = tcp_v4_authopt_get_traffic_key_noskb(key, saddr, daddr,
+						   th->source, th->dest,
+						   htonl(info->src_isn), htonl(info->dst_isn),
+						   traffic_key);
+	if (err)
+		goto out_err_traffic_key;
+
+	/* Init mac shash */
+	pool = tcp_authopt_get_mac_pool(key);
+	if (IS_ERR(pool))
+		return PTR_ERR(pool);
+	err = crypto_ahash_setkey(pool->tfm, traffic_key, key->alg->traffic_key_len);
+	if (err)
+		goto out_err;
+	err = crypto_ahash_init(pool->req);
+	if (err)
+		return err;
+
+	err = crypto_ahash_buf(pool->req, (u8 *)&sne, 4);
+	if (err)
+		return err;
+
+	err = tcp_authopt_hash_tcp4_pseudoheader(pool, saddr, daddr, th->doff * 4);
+	if (err)
+		return err;
+
+	// TCP header with checksum set to zero. Caller ensures this.
+	if (WARN_ON_ONCE(th->check != 0))
+		goto out_err;
+	err = crypto_ahash_buf(pool->req, (u8 *)th, sizeof(*th));
+	if (err)
+		goto out_err;
+
+	// TCP options
+	err = tcp_authopt_hash_opts(pool, th, (struct tcphdr_authopt *)(hash_location - 4),
+				    !(key->flags & TCP_AUTHOPT_KEY_EXCLUDE_OPTS));
+	if (err)
+		goto out_err;
+
+	ahash_request_set_crypt(pool->req, NULL, macbuf, 0);
+	err = crypto_ahash_final(pool->req);
+	if (err)
+		goto out_err;
+	memcpy(hash_location, macbuf, TCP_AUTHOPT_MACLEN);
+
+	tcp_authopt_put_mac_pool(key, pool);
+	return 0;
+
+out_err:
+	tcp_authopt_put_mac_pool(key, pool);
+out_err_traffic_key:
+	memset(hash_location, 0, TCP_AUTHOPT_MACLEN);
+	return err;
+}
+
 static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
 							    struct sk_buff *skb,
 							    struct netns_tcp_authopt *net,
 							    int recv_id,
 							    bool *anykey)
-- 
2.25.1

