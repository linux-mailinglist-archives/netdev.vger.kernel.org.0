Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C34413751
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbhIUQTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbhIUQSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:18:40 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1399C061575;
        Tue, 21 Sep 2021 09:17:09 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id eg28so53600344edb.1;
        Tue, 21 Sep 2021 09:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tn4CP0rVaPBCvAa1AgJpDJmjYYuaun+JN2VJXULQEUA=;
        b=PplHb97KK0YpRW+4V+pSfbmFVxwSeVGHIpgptNQgAf/kL3vRQda4R0IpqH/Ypy7/AP
         Bc1V2G4vtYXlwWXlrMslzdVwT2DMUVWLLJ0bPUqhkEGxusP1ATbO23UPwWhqzoUfMdGo
         EIx025OkPm+UxzfuZRQbePSCuVHZgdRzsAINMMLUq/jMkh7cuwfBRrJL7seKn/Cp5W1W
         CTEyNoLU3KjcoXLRxQZmFa4CMbFRsSCXk/fYhofPdOTdLJrGnSymBXtyFMES+JW+Nyg8
         wGTqFMqXO1JTUFOf5DAS3YltvDyzlm9uPtOK2NG/rJnnoFBBDGqOR0IANUt2+EM461Wa
         FUGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tn4CP0rVaPBCvAa1AgJpDJmjYYuaun+JN2VJXULQEUA=;
        b=uF52XMbstMsBPEpiC2Q5YWQPZp5Aos9kA3rwZJeEZW0fviw5YA7Kj2pXHBYDknjxI/
         UvU1QdUaQvmCOPfuM5TlQaMgSUDr9R3OsL8XI0cgrGfE64nyfHASn5TaNrTBTCjwXXWU
         fS66IGGCzS/S3CgAb5ZPjPn6ar39EOg+KQxBB7wCI77ElvIliVNAWo/tYenWkNFdAKwL
         dFVZhsobT7hBijse8SvSZNlBfSiE5wTWDISKJZCrm+9IW0Q293vbp/X9VIFpvIcHr7Nn
         DInIuFOF3qP8oL54zNqUE9ggj0LWTsrqQ2zrDwhxMSxGLlNSOYIDt/nE2HvCft5ckQ/j
         ea7w==
X-Gm-Message-State: AOAM530nrGe07h42PEwtSqUSOnYhSoZhl3RKdR37K9qdrW5uRe7WAq1A
        0W48xg42Q7ZGT13UHogvE0M=
X-Google-Smtp-Source: ABdhPJy7x5BquSLn2axABT7ln/2JxDM53KIIbdLKZXjE++QbzVTDUQG6dr4Qa5NTgAfczj061HnQaQ==
X-Received: by 2002:a05:6402:2913:: with SMTP id ee19mr35884241edb.332.1632240935288;
        Tue, 21 Sep 2021 09:15:35 -0700 (PDT)
Received: from pinky.lan ([2a04:241e:502:1df0:b065:9bdf:4016:277])
        by smtp.gmail.com with ESMTPSA id kx17sm7674075ejc.51.2021.09.21.09.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:15:34 -0700 (PDT)
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
Subject: [PATCH 11/19] tcp: authopt: Add support for signing skb-less replies
Date:   Tue, 21 Sep 2021 19:14:54 +0300
Message-Id: <7301a3b6ce1c5c282f10c2cc45a1409dee8abd86.1632240523.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1632240523.git.cdleonard@gmail.com>
References: <cover.1632240523.git.cdleonard@gmail.com>
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
 net/ipv4/tcp_authopt.c    | 147 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 154 insertions(+)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 422f0034d32b..b012eaaf416f 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -81,10 +81,17 @@ static inline struct tcp_authopt_key_info *tcp_authopt_select_key(
 }
 int tcp_authopt_hash(
 		char *hash_location,
 		struct tcp_authopt_key_info *key,
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
index 41f844d5d49a..756182401a3b 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -798,10 +798,74 @@ static int tcp_authopt_get_traffic_key(struct sock *sk,
 out:
 	tcp_authopt_put_kdf_shash(key, kdf_tfm);
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
+static int tcp_v4_authopt_get_traffic_key_noskb(
+		struct tcp_authopt_key_info *key,
+		__be32 saddr,
+		__be32 daddr,
+		__be16 sport,
+		__be16 dport,
+		__be32 sisn,
+		__be32 disn,
+		u8 *traffic_key)
+{
+	int err;
+	struct crypto_shash *kdf_tfm;
+	SHASH_DESC_ON_STACK(desc, kdf_tfm);
+	struct tcp_v4_authopt_context_data data;
+	BUILD_BUG_ON(sizeof(data) != 22);
+
+	kdf_tfm = tcp_authopt_get_kdf_shash(key);
+	if (IS_ERR(kdf_tfm))
+		return PTR_ERR(kdf_tfm);
+
+	err = tcp_authopt_setkey(kdf_tfm, key);
+	if (err)
+		goto out;
+
+	desc->tfm = kdf_tfm;
+	err = crypto_shash_init(desc);
+	if (err)
+		goto out;
+
+	// RFC5926 section 3.1.1.1
+	// Separate to keep alignment semi-sane
+	err = crypto_shash_update(desc, "\x01TCP-AO", 7);
+	if (err)
+		return err;
+	data.saddr = saddr;
+	data.daddr = daddr;
+	data.sport = sport;
+	data.dport = dport;
+	data.sisn = sisn;
+	data.disn = disn;
+	data.digestbits = htons(crypto_shash_digestsize(desc->tfm) * 8);
+
+	err = crypto_shash_update(desc, (u8*)&data, sizeof(data));
+	if (err)
+		goto out;
+	err = crypto_shash_final(desc, traffic_key);
+	if (err)
+		goto out;
+
+out:
+	tcp_authopt_put_kdf_shash(key, kdf_tfm);
+	return err;
+}
+
 static int crypto_shash_update_zero(struct shash_desc *desc, int len)
 {
 	u8 zero = 0;
 	int i, err;
 
@@ -1122,10 +1186,93 @@ int tcp_authopt_hash(char *hash_location,
 	memcpy(hash_location, macbuf, TCP_AUTHOPT_MACLEN);
 
 	return 0;
 }
 
+/**
+ * tcp_v4_authopt_hash_hdr - Hash tcp+ipv4 header without SKB
+ *
+ * The key must come from tcp_authopt_select_key.
+ */
+int tcp_v4_authopt_hash_reply(char *hash_location,
+			      struct tcp_authopt_info *info,
+			      struct tcp_authopt_key_info *key,
+			      __be32 saddr,
+			      __be32 daddr,
+			      struct tcphdr *th)
+{
+	struct crypto_shash *mac_tfm;
+	u8 macbuf[TCP_AUTHOPT_MAXMACBUF];
+	u8 traffic_key[TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN];
+	SHASH_DESC_ON_STACK(desc, tfm);
+	__be32 sne = 0;
+	int err;
+
+	/* Call special code path for computing traffic key without skb
+	 * This can be called from tcp_v4_reqsk_send_ack so caching would be
+	 * difficult here.
+	 */
+	err = tcp_v4_authopt_get_traffic_key_noskb(
+			key,
+			saddr,
+			daddr,
+			th->source,
+			th->dest,
+			htonl(info->src_isn),
+			htonl(info->dst_isn),
+			traffic_key);
+	if (err)
+		goto out_err_traffic_key;
+
+	/* Init mac shash */
+	mac_tfm = tcp_authopt_get_mac_shash(key);
+	if (IS_ERR(mac_tfm))
+		return PTR_ERR(mac_tfm);
+	err = crypto_shash_setkey(mac_tfm, traffic_key, key->alg->traffic_key_len);
+	if (err)
+		goto out_err;
+
+	desc->tfm = mac_tfm;
+	err = crypto_shash_init(desc);
+	if (err)
+		return err;
+
+	err = crypto_shash_update(desc, (u8 *)&sne, 4);
+	if (err)
+		return err;
+
+	err = tcp_authopt_hash_tcp4_pseudoheader(desc, saddr, daddr, th->doff * 4);
+	if (err)
+		return err;
+
+	// TCP header with checksum set to zero. Caller ensures this.
+	if (WARN_ON_ONCE(th->check != 0))
+		goto out_err;
+	err = crypto_shash_update(desc, (u8 *)th, sizeof(*th));
+	if (err)
+		goto out_err;
+
+	// TCP options
+	err = tcp_authopt_hash_opts(desc, th, !(key->flags & TCP_AUTHOPT_KEY_EXCLUDE_OPTS));
+	if (err)
+		goto out_err;
+
+	err = crypto_shash_final(desc, macbuf);
+	if (err)
+		goto out_err;
+	memcpy(hash_location, macbuf, TCP_AUTHOPT_MACLEN);
+
+	tcp_authopt_put_mac_shash(key, mac_tfm);
+	return 0;
+
+out_err:
+	tcp_authopt_put_mac_shash(key, mac_tfm);
+out_err_traffic_key:
+	memset(hash_location, 0, TCP_AUTHOPT_MACLEN);
+	return err;
+}
+
 static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
 							    struct sk_buff *skb,
 							    struct tcp_authopt_info *info,
 							    int recv_id)
 {
-- 
2.25.1

