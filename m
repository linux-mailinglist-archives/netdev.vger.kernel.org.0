Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6C0598D45
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345670AbiHRUAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345637AbiHRUAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:00:40 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B071ED11DC;
        Thu, 18 Aug 2022 13:00:38 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id j8so5168294ejx.9;
        Thu, 18 Aug 2022 13:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=KU59swmo/I3OH2xUFCnRP0du6LBX/Oj+pYHId7St1eI=;
        b=XKAN6Dms+tQasnnNKE34LvHfmofUTxjt8cv+v9BMqFdCC0YYlQnsXgyKrzD5iffzN1
         6q9QbWNct7l/tt0APY6VPVEhOW+E0X8h9zL8EMJMQJorLy7AF5IUXu+z1S0FB52dT6S4
         cZUnRoRA4gqtPKpPTG14aaw3+fVp+Is5GmNgD7Hd/t/L94CS5xZUCG6DIpJnPiwef5jq
         wIIvKAUqd3s2m64u791rwM6sKbc5ktCsmzr5kbeTyRlCBAzHoDNyNuqAVay3hWuY6uN4
         lrR+tCrpiyr/HfVtZB9Ky/xbO/kA28Tg36m68TCZAXzscBkc0jqJO9oMrZO8n0ll3byG
         LuQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=KU59swmo/I3OH2xUFCnRP0du6LBX/Oj+pYHId7St1eI=;
        b=k1rERaGyrAzZ1/mJ72yHTA5BeEUgW1sBc6FHWxjeBOXhM2thkFFaZgUsA1Uig7SCFO
         GkN/OFeR46up12+Xtj6oeHtY3N4m9WXkv9CznVGkZzi2Ocx5CzNgUzXAL4cSJFEYc/vv
         mk5usyaOoLLJkHmo74O4ZiH3JiY1IQu5M4GU3IV5BuqgkRQsp/LeNdeCNO5vpSGRp7FM
         nH5MtvJTr39DtynQqY/0Ytjoj/CbJjJVWlNmbwszJQaKbk1+HGsqRYQft6CeRzQLWL6x
         0v4OVtDQuiDMu00rLeCQqyP32IoJzxmWfo1QuzXeQoQ8eZrzrEzUjb4cFnxaEArMwSe7
         nL5g==
X-Gm-Message-State: ACgBeo0VDRQvdocOn7fjC9VvkIKr5I97JWOhFKO6YLdblXUqqQW4OuID
        tFIH4+D3Iso9thp9q/YAWqs=
X-Google-Smtp-Source: AA6agR552wcCd12WGzVeEui7CZQIMqP1e/rrbAzE9uYerIEhNMYjmM39wjtLuKoyRSmk++3bm5Ezww==
X-Received: by 2002:a17:907:94d2:b0:73b:f1b0:3b74 with SMTP id dn18-20020a17090794d200b0073bf1b03b74mr2133212ejc.158.1660852837296;
        Thu, 18 Aug 2022 13:00:37 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:00:36 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
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
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 11/26] tcp: authopt: Add support for signing skb-less replies
Date:   Thu, 18 Aug 2022 22:59:45 +0300
Message-Id: <dca57d3d72da44282433094162d2a8298a11b1a8.1660852705.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660852705.git.cdleonard@gmail.com>
References: <cover.1660852705.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 1fa1b968c80c..9bc0f58a78cb 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -114,10 +114,17 @@ static inline struct tcp_authopt_key_info *tcp_authopt_select_key(
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
index 2a216356d280..2af6265041b4 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -944,10 +944,72 @@ static int tcp_authopt_get_traffic_key(struct sock *sk,
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
 
@@ -1214,10 +1276,92 @@ int tcp_authopt_hash(char *hash_location,
 	return err;
 }
 EXPORT_SYMBOL(tcp_authopt_hash);
 
 /**
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
+/*
  * tcp_authopt_lookup_recv - lookup key for receive
  *
  * @sk: Receive socket
  * @skb: Packet, used to compare addr and iface
  * @net: Per-namespace information containing keys
-- 
2.25.1

