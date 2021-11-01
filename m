Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66299441E78
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhKAQil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbhKAQi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:27 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D52C061220;
        Mon,  1 Nov 2021 09:35:51 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id w1so12368994edd.10;
        Mon, 01 Nov 2021 09:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=milzkF1m5zxvSIl79nXaZIe8ZA7L4vAOc37O1pzjxRo=;
        b=R/scQEdVU7QzVzAohymAe9fVLgkJLIUH3vuirmx0qEBWiwnUzdNa3JS1qVBApwb+aj
         qso7Cnsv7PjcumA9tQrO3RTl2YRjwnp0HFQE4sQrhoJakWPwBkRjnG825GLkNkJEqGwZ
         Ces7qgvi2xP7f5pAbnpxqF8j4rDCKjhz5iRZ08c7qxQsc+yUnI1k6jP5n/+JLcig3CVl
         IEK82Qr4c5GFYe7kmmr+cl096h7P+LjOlwLY5FW9DcTTr4jPQcnIXLDAB34Sy6Xd6+HS
         fswNuNI6RiBSwFgHjqcRRcnpxzlJ+NkrZ9Zl5zMPUwmsvacmlwKhxBAUX+ejOFewq+Uh
         442w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=milzkF1m5zxvSIl79nXaZIe8ZA7L4vAOc37O1pzjxRo=;
        b=LtoHEgd+2WwocQHop2hd1/Kg5qI15SmzDOPmULdf7ZbyOPxM4sqw1kJqGJBdzRJu5Q
         21EAU5uUfBwz+nO8gmLRIW/Ofu66hUgerHb3YDyx8Y6X98EVbZeZM15IjIpEPCYRd/pE
         rIACOmgUbZ6AivBiEKru0OiOPs2XY1d/tNe3L7OPpfpY65Vz8GqUobNUibs5kNLrVyi8
         BN89kAJMyH9xdQy4DKs59kHabFRhQTTlCh/5aeINv+YMOA4VC6YgMhh+d3F6dPO4xPq/
         JqQXoKnPagKefpilFoi29kgdZbetTCvmHv1zr+SdX0T5cdY5pxkI2NXP6p/oUAQM6GyL
         aHrg==
X-Gm-Message-State: AOAM5330AmvgEvh3Oet64Ek+OuVw+Rm/IwspUiaYKi2adO4SuRllH41C
        rq/ryl09a233PbUgQzV6GUA=
X-Google-Smtp-Source: ABdhPJzfJruF1u3tkaV/lGK46vHolf2zWRPWhvgVOYS6WwSZBbBXp/fFrEvT4eO6mA4wyKOdVwKI1g==
X-Received: by 2002:a17:907:3e8a:: with SMTP id hs10mr11897159ejc.58.1635784550511;
        Mon, 01 Nov 2021 09:35:50 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:35:49 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
Subject: [PATCH v2 13/25] tcp: authopt: Add support for signing skb-less replies
Date:   Mon,  1 Nov 2021 18:34:48 +0200
Message-Id: <23d0934b85fa00e8f2aa8ebb1af3005fbed5b347.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
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
index 7360bda20f97..ae7d6a1eab8d 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -101,10 +101,17 @@ static inline struct tcp_authopt_key_info *tcp_authopt_select_key(
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
index c9d201d8f7a7..aef63e35b56f 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -799,10 +799,74 @@ static int tcp_authopt_get_traffic_key(struct sock *sk,
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
+	struct crypto_shash *kdf_tfm;
+	SHASH_DESC_ON_STACK(desc, kdf_tfm);
+	struct tcp_v4_authopt_context_data data;
+
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
+	err = crypto_shash_update(desc, (u8 *)&data, sizeof(data));
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
 
@@ -1205,10 +1269,93 @@ int tcp_authopt_hash(char *hash_location,
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
+	err = tcp_v4_authopt_get_traffic_key_noskb(key, saddr, daddr,
+						   th->source, th->dest,
+						   htonl(info->src_isn), htonl(info->dst_isn),
+						   traffic_key);
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

