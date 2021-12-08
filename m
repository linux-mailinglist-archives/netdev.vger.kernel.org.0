Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF4B46D287
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhLHLnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbhLHLm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:42:57 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC096C0698DB;
        Wed,  8 Dec 2021 03:38:16 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id g14so7310824edb.8;
        Wed, 08 Dec 2021 03:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YFVlragDCWioyuewm1BB0pdEY6+OlUg53bCND+dh3mU=;
        b=gfg4Q0F/fDMd0HDGtyy8TlqTl0nrd7f8zQZjzHKcVfiveQJgcZZsE+x1Z5D2GBFpMI
         XNkFiaBug/mKWDqMPY0GbP3F2SP3cXVN1QrClYd6wds26h9QkFgatxHjzTNTtp+TqP6d
         oMMqIrJR42CP4pjEwo4YlUd+SVX70MZ6OxyGc098i7v5FqVdUZRvdNsXhbZPXdNS9OzM
         /LNsJMT0hh/yXLNjcMV4CtcFUJjSSng0VVV/96P08vjhGB/7LBt8CWqqjvXBQZmV4C6X
         FU7PZVar3+1F9xXIyfua74yHCUKDq6V/Eq+njNn662CBNlbjJe5Q5Rsjo7qLrYvI4wrI
         12Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YFVlragDCWioyuewm1BB0pdEY6+OlUg53bCND+dh3mU=;
        b=eiLrmglL3Hd/y8/Fl8nq1ktZHE4Igbn462v4uXsIZEGMeAVB1pTfEVnQPZhI285g1Z
         G6ApnIt4AqH/F/zNdj7PQJolTTkht19F8IAE3uhamXOqmbeLtqVHGI7L822LpPazqxw9
         Det2jNwuxWnT37FneZj6BuaWZfGMamY7UeoJ/irXQRTkH7LUUqhS0eTjwhzar4biWzod
         ROQAI/SeyZVy+Gg23NJeifdg21CzhVnRGujiarPy/pMTDIY+VK1a246Nlo0LT738cOoO
         NyhDdvmFShlE1JL473bW2Ed6TyOnlPVAMeqbRMb2y+OYIcsXRQpjTNyESU5XqHr60+qk
         6FkQ==
X-Gm-Message-State: AOAM530NLRAGiTk1iAmEvS/2ffkOWhbF6HkRNPpenPTcCKhEfiCfnGXY
        t0QEN7E7adREeIIZ1r713UQ=
X-Google-Smtp-Source: ABdhPJyPvDZrcSj4nEQnvkmOcVWAX1Fj9Uh03KjVeqY2DFbLLSfTsW9BzJSCp2XQQKiOy96xBH3vxQ==
X-Received: by 2002:a05:6402:51c6:: with SMTP id r6mr18414342edd.365.1638963494643;
        Wed, 08 Dec 2021 03:38:14 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:3c9f:e05b:4dff:43ba])
        by smtp.gmail.com with ESMTPSA id g11sm1883810edz.53.2021.12.08.03.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 03:38:14 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/18] tcp: authopt: Add support for signing skb-less replies
Date:   Wed,  8 Dec 2021 13:37:25 +0200
Message-Id: <bddc70a04dcf8b6018f5ed433785413c70b19552.1638962992.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1638962992.git.cdleonard@gmail.com>
References: <cover.1638962992.git.cdleonard@gmail.com>
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
index d5d344d599f7..411e7a0bdd43 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -111,10 +111,17 @@ static inline struct tcp_authopt_key_info *tcp_authopt_select_key(
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
index f1213c7db63b..a4f3eac20b29 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -935,10 +935,72 @@ static int tcp_authopt_get_traffic_key(struct sock *sk,
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
 
@@ -1198,10 +1260,92 @@ int tcp_authopt_hash(char *hash_location,
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
 							    struct tcp_authopt_info *info,
 							    int recv_id,
 							    bool *anykey)
-- 
2.25.1

