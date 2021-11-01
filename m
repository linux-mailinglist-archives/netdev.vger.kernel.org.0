Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD26C441E8F
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbhKAQjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbhKAQiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:13 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BFAC061714;
        Mon,  1 Nov 2021 09:35:39 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w15so66412613edc.9;
        Mon, 01 Nov 2021 09:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6XjFwTZJAXBS5ig6cJtvUyJCDN7+Qz6UkUJ2uO4/Ktc=;
        b=mQAHa9q2BVVuhWSh7J9ud3rXccRlUIm6dVcftCbK+fnnCOYJn3YEPdbJP7vkUOXWE3
         PPk0EZ3u8iday/wRKju2/nWIInKHo08NE+khYut3l54Qz5jqeP/Y70dXz923EIbwpd8b
         m8J5iWzWKE9TfoCe13ju45PA8aru7C+KbqhNP6l4cYerXg9+XKn2s+B2+bb2dZYVCjet
         AiEADa8KcjHTCIoTOgKv9GCCWuizQiVT9MNFFa7LG92Eb7pKuYpD36GyF8k9WUOh6wiI
         t7sKGBUmfvhcESEfxlPl7eV8MO0QwxZa28LORIBqEEYr/QlICUo0CWt7QnflY6JIXu5u
         eWiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6XjFwTZJAXBS5ig6cJtvUyJCDN7+Qz6UkUJ2uO4/Ktc=;
        b=JzORaYfEw+NH4OXfLCV3xgUbJNpZ1d/iHSkch2Xe5XS+/1nEU0b1/90pucKG3EtT7r
         D1BhuVOk7TiaMm5DbWfUiICftlvoNeyb0eT4VZmXMGn6YGIdtYmIGT2+k/VSYmQIMTnq
         tL4Z5hLOMylSHwtUVO0vi2NRGD5TbiK+V6cxZnsyNjDASK7X+Gz3L1W+9dn9OFc9RSKH
         aajBhYJjqXGjN3TLLRna63nPZJcM8Cy9go/nPEUM0dhthsOLos+iq4lwmS35EVmGJxaq
         mOz9RVq9wmHJyp+MqVGacP2xcwRusW1y9dB7m3Ah3MnzLfcJXEHmhc9FQQk1zZErNDKl
         2cwQ==
X-Gm-Message-State: AOAM532dTERnzeIWvXGurJZH7pfKay5RT1viHl78VlEFnxicMy586YNF
        7dUeBChziQx4p7wOryD5iSI=
X-Google-Smtp-Source: ABdhPJwHjmEmXN3qss1kGSQ4GY4gy7khpDLdzpsGpXXWRbieZhf04tFxmL8C46Q/Udj0+E7KXGUPZw==
X-Received: by 2002:a05:6402:158:: with SMTP id s24mr42841743edu.189.1635784538298;
        Mon, 01 Nov 2021 09:35:38 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:35:37 -0700 (PDT)
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
Subject: [PATCH v2 06/25] tcp: authopt: Compute packet signatures
Date:   Mon,  1 Nov 2021 18:34:41 +0200
Message-Id: <5245f35901015acc6a41d1da92deb96f3e593b7c.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Computing tcp authopt packet signatures is a two step process:

* traffic key is computed based on tcp 4-tuple, initial sequence numbers
and the secret key.
* packet mac is computed based on traffic key and content of individual
packets.

The traffic key could be cached for established sockets but it is not.

A single code path exists for ipv4/ipv6 and input/output. This keeps the
code short but slightly slower due to lots of conditionals.

On output we read remote IP address from socket members on output, we
can't use skb network header because it's computed after TCP options.

On input we read remote IP address from skb network headers, we can't
use socket binding members because those are not available for SYN.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_authopt.c | 510 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 510 insertions(+)

diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 5455a9ecfe6b..1fd98d67ec10 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -425,5 +425,515 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	memcpy(&key_info->addr, &opt.addr, sizeof(key_info->addr));
 	hlist_add_head_rcu(&key_info->node, &info->head);
 
 	return 0;
 }
+
+static int tcp_authopt_get_isn(struct sock *sk,
+			       struct sk_buff *skb,
+			       int input,
+			       __be32 *sisn,
+			       __be32 *disn)
+{
+	struct tcp_authopt_info *authopt_info;
+	struct tcphdr *th = tcp_hdr(skb);
+
+	/* special cases for SYN and SYN/ACK */
+	if (th->syn && !th->ack) {
+		*sisn = th->seq;
+		*disn = 0;
+		return 0;
+	}
+	if (th->syn && th->ack) {
+		*sisn = th->seq;
+		*disn = htonl(ntohl(th->ack_seq) - 1);
+		return 0;
+	}
+
+	/* Fetching authopt_info like this should be safe because authopt_info
+	 * is never released intil the socket is being closed
+	 *
+	 * tcp_timewait_sock is handled but not tcp_request_sock.
+	 * for the synack case sk should be the listen socket.
+	 */
+	rcu_read_lock();
+	if (unlikely(sk->sk_state == TCP_NEW_SYN_RECV)) {
+		/* should never happen, sk should be the listen socket */
+		authopt_info = NULL;
+		WARN_ONCE(1, "TCP-AO can't sign with request sock\n");
+		return -EINVAL;
+	} else if (sk->sk_state == TCP_LISTEN) {
+		/* Signature computation for non-syn packet on a listen
+		 * socket is not possible because we lack the initial
+		 * sequence numbers.
+		 *
+		 * Input segments that are not matched by any request,
+		 * established or timewait socket will get here. These
+		 * are not normally sent by peers.
+		 *
+		 * Their signature might be valid but we don't have
+		 * enough state to determine that. TCP-MD5 can attempt
+		 * to validate and reply with a signed RST because it
+		 * doesn't care about ISNs.
+		 *
+		 * Reporting an error from signature code causes the
+		 * packet to be discarded which is good.
+		 */
+		if (input) {
+			/* Assume this is an ACK to a SYN/ACK
+			 * This will incorrectly report "failed
+			 * signature" for segments without a connection.
+			 */
+			*sisn = htonl(ntohl(th->seq) - 1);
+			*disn = htonl(ntohl(th->ack_seq) - 1);
+			rcu_read_unlock();
+			return 0;
+		}
+		/* This would be an internal bug. */
+		authopt_info = NULL;
+		WARN_ONCE(1, "TCP-AO can't sign non-syn from TCP_LISTEN sock\n");
+		return -EINVAL;
+	} else if (sk->sk_state == TCP_TIME_WAIT) {
+		authopt_info = tcp_twsk(sk)->tw_authopt_info;
+	} else {
+		authopt_info = rcu_dereference(tcp_sk(sk)->authopt_info);
+	}
+	if (!authopt_info) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	/* Initial sequence numbers for ESTABLISHED connections from info */
+	if (input) {
+		*sisn = htonl(authopt_info->dst_isn);
+		*disn = htonl(authopt_info->src_isn);
+	} else {
+		*sisn = htonl(authopt_info->src_isn);
+		*disn = htonl(authopt_info->dst_isn);
+	}
+	rcu_read_unlock();
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
+	__be16 digestbits = htons(crypto_shash_digestsize(desc->tfm) * 8);
+
+	// RFC5926 section 3.1.1.1
+	err = crypto_shash_update(desc, "\x01TCP-AO", 7);
+	if (err)
+		return err;
+
+	/* Addresses from packet on input and from sk_common on output
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
+	err = tcp_authopt_get_isn(sk, skb, input, &sisn, &disn);
+	if (err)
+		return err;
+	err = crypto_shash_update(desc, (u8 *)&sisn, 4);
+	if (err)
+		return err;
+	err = crypto_shash_update(desc, (u8 *)&disn, 4);
+	if (err)
+		return err;
+	err = crypto_shash_update(desc, (u8 *)&digestbits, 2);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/* Convert a variable-length key to a 16-byte fixed-length key for AES-CMAC
+ * This is described in RFC5926 section 3.1.1.2
+ */
+static int aes_setkey_derived(struct crypto_shash *tfm, u8 *key, size_t keylen)
+{
+	static const u8 zeros[16] = {0};
+	u8 derived_key[16];
+	int err;
+
+	if (WARN_ON_ONCE(crypto_shash_digestsize(tfm) != 16))
+		return -EINVAL;
+	err = crypto_shash_setkey(tfm, zeros, sizeof(zeros));
+	if (err)
+		return err;
+	err = crypto_shash_tfm_digest(tfm, key, keylen, derived_key);
+	if (err)
+		return err;
+	return crypto_shash_setkey(tfm, derived_key, sizeof(derived_key));
+}
+
+static int tcp_authopt_setkey(struct crypto_shash *tfm, struct tcp_authopt_key_info *key)
+{
+	if (key->alg_id == TCP_AUTHOPT_ALG_AES_128_CMAC_96 && key->keylen != 16)
+		return aes_setkey_derived(tfm, key->key, key->keylen);
+	else
+		return crypto_shash_setkey(tfm, key->key, key->keylen);
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
+	err = tcp_authopt_shash_traffic_key(desc, sk, skb, input, ipv6);
+	if (err)
+		goto out;
+
+	err = crypto_shash_final(desc, traffic_key);
+	if (err)
+		goto out;
+
+out:
+	tcp_authopt_put_kdf_shash(key, kdf_tfm);
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
+	__be32 buf[2];
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
+/* __tcp_authopt_calc_mac - Compute packet MAC using key
+ *
+ * The macbuf output buffer must be large enough to fit the digestsize of the
+ * underlying transform before truncation.
+ * This means TCP_AUTHOPT_MAXMACBUF, not TCP_AUTHOPT_MACLEN
+ */
+static int __tcp_authopt_calc_mac(struct sock *sk,
+				  struct sk_buff *skb,
+				  struct tcp_authopt_key_info *key,
+				  bool input,
+				  char *macbuf)
+{
+	struct crypto_shash *mac_tfm;
+	u8 traffic_key[TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN];
+	int err;
+	bool ipv6 = (sk->sk_family != AF_INET);
+
+	if (sk->sk_family != AF_INET && sk->sk_family != AF_INET6)
+		return -EINVAL;
+
+	err = tcp_authopt_get_traffic_key(sk, skb, key, input, ipv6, traffic_key);
+	if (err)
+		return err;
+
+	mac_tfm = tcp_authopt_get_mac_shash(key);
+	if (IS_ERR(mac_tfm))
+		return PTR_ERR(mac_tfm);
+	err = crypto_shash_setkey(mac_tfm, traffic_key, key->alg->traffic_key_len);
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
+
+out:
+	tcp_authopt_put_mac_shash(key, mac_tfm);
+	return err;
+}
-- 
2.25.1

