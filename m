Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8247497F01
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242683AbiAXMPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239315AbiAXMOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:14:05 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B1FC061744;
        Mon, 24 Jan 2022 04:13:48 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id m4so20852829ejb.9;
        Mon, 24 Jan 2022 04:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UA1qPOxtgQUi5FzfQC/XaqmXqutO3RUue1aeIf1v4vs=;
        b=iOTz5oYUa7FvyTdIj2XXocN9knQzPg2NIKz5as9F3zqq3x4TF9kOE5v6ASJHs014QL
         tAIz59Gt+I/w6vwz8VRr9n/34Uh1JqrBTsm+9E6WX5ubeL9lyTqmaDg30G6VG2Mww/DT
         7kd+aacdyxnemvIBnTl7XooS+uqf6PVYieg+XLIGQHVT2HQ9Nox/DccVXhbgJfG0ytzB
         nECD8S/3W3u8fKK75Kj9RmVDXhc1d06TiuqMnVQfzTYcHJBg2Nw86RFw37IFWvakjz+/
         0RIk7wkCNJG/QtB/2o53W/2AHvjQq7I/FXxp00qjKaapFSwRgxhYeyvP6E69yAstTaz/
         1IgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UA1qPOxtgQUi5FzfQC/XaqmXqutO3RUue1aeIf1v4vs=;
        b=hRXwjanXuIgWNRUac+WJvRbCoBs/hytohLTRdgsib4AhwhpBf0T5fez+VPeUgg66QX
         x19/vP+OBXFsOZ4PZSvYF6J2wknoIQ45Pr2ccAq8F7n+lFxaUDNTFK+LbTiydTO7YCSF
         DT+DzkQzOVhi6zcDhwMnoqfl2H66ZqFLw8TrVRDW8qVbTf3YDgiYpcGXl686x34cl8yb
         CwDmTxNWq1i9jzb6tly1as1/Tln5gGuu77+Ly0gg0Gc7lVJ1LqrM22PwV5YJNLeTl7b9
         OSJFg5xeoMZM65Nt5ZCUHkdWQlu5ycHeZTLN7uBsYiMFckCellD3MR0bUlNAklTbTyan
         MOug==
X-Gm-Message-State: AOAM531WWVkaT8iRB+ol78c/8AjBZ5Zm8Yb1dJ3x9qN0PrLt85ZSMhOG
        kA4atLPtrwRKpYowIPKRp/g=
X-Google-Smtp-Source: ABdhPJxFc0yomBp7OGNVM6sk8OMYgzocQqB2YRSdT8k2deIyEKcKURbqPS9t0Wgn5wwBiYp5jVQ09w==
X-Received: by 2002:a17:907:7f11:: with SMTP id qf17mr6294118ejc.76.1643026426832;
        Mon, 24 Jan 2022 04:13:46 -0800 (PST)
Received: from ponky.lan ([2a04:241e:502:a09c:a21f:7a9f:9158:4a40])
        by smtp.gmail.com with ESMTPSA id b16sm4847517eja.211.2022.01.24.04.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 04:13:46 -0800 (PST)
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
Subject: [PATCH v5 14/20] tcp: authopt: Add NOSEND/NORECV flags
Date:   Mon, 24 Jan 2022 14:13:00 +0200
Message-Id: <191c35b404095ad2aaec5a97e8ed43c0e8540329.1643026076.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1643026076.git.cdleonard@gmail.com>
References: <cover.1643026076.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add flags to allow marking individual keys and invalid for send or recv.
Making keys assymetric this way is not mentioned in RFC5925 but RFC8177
requires that keys inside a keychain have independent "accept" and
"send" lifetimes.

Flag names are negative so that the default behavior is for keys to be
valid for both send and recv.

Setting both NOSEND and NORECV for a certain peer address can be used on
a listen socket can be used to mean "TCP-AO is required from this peer
but no keys are currently valid".

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/uapi/linux/tcp.h | 4 ++++
 net/ipv4/tcp_authopt.c   | 9 ++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index a7f5f918ed5a..ed27feb93b0e 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -401,16 +401,20 @@ struct tcp_authopt {
  *
  * @TCP_AUTHOPT_KEY_DEL: Delete the key and ignore non-id fields
  * @TCP_AUTHOPT_KEY_EXCLUDE_OPTS: Exclude TCP options from signature
  * @TCP_AUTHOPT_KEY_ADDR_BIND: Key only valid for `tcp_authopt.addr`
  * @TCP_AUTHOPT_KEY_IFINDEX: Key only valid for `tcp_authopt.ifindex`
+ * @TCP_AUTHOPT_KEY_NOSEND: Key invalid for send (expired)
+ * @TCP_AUTHOPT_KEY_NORECV: Key invalid for recv (expired)
  */
 enum tcp_authopt_key_flag {
 	TCP_AUTHOPT_KEY_DEL = (1 << 0),
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS = (1 << 1),
 	TCP_AUTHOPT_KEY_ADDR_BIND = (1 << 2),
 	TCP_AUTHOPT_KEY_IFINDEX = (1 << 3),
+	TCP_AUTHOPT_KEY_NOSEND = (1 << 4),
+	TCP_AUTHOPT_KEY_NORECV = (1 << 5),
 };
 
 /**
  * enum tcp_authopt_alg - Algorithms for TCP Authentication Option
  */
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 3d2c4283923f..331bf3e8b66a 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -363,10 +363,12 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct netns_tcp_aut
 	int l3index = -1;
 
 	hlist_for_each_entry_rcu(key, &net->head, node, 0) {
 		if (send_id >= 0 && key->send_id != send_id)
 			continue;
+		if (key->flags & TCP_AUTHOPT_KEY_NOSEND)
+			continue;
 		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
 			if (!tcp_authopt_key_match_sk_addr(key, addr_sk))
 				continue;
 		if (key->flags & TCP_AUTHOPT_KEY_IFINDEX) {
 			if (l3index < 0)
@@ -612,11 +614,13 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 
 #define TCP_AUTHOPT_KEY_KNOWN_FLAGS ( \
 	TCP_AUTHOPT_KEY_DEL | \
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS | \
 	TCP_AUTHOPT_KEY_ADDR_BIND | \
-	TCP_AUTHOPT_KEY_IFINDEX)
+	TCP_AUTHOPT_KEY_IFINDEX | \
+	TCP_AUTHOPT_KEY_NOSEND | \
+	TCP_AUTHOPT_KEY_NORECV)
 
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt_key opt;
 	struct tcp_authopt_info *info;
@@ -1524,10 +1528,13 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
 
 			if (l3index != key->l3index)
 				continue;
 		}
 		*anykey = true;
+		// If only keys with norecv flag are present still consider that
+		if (key->flags & TCP_AUTHOPT_KEY_NORECV)
+			continue;
 		if (recv_id >= 0 && key->recv_id != recv_id)
 			continue;
 		if (better_key_match(result, key))
 			result = key;
 		else if (result)
-- 
2.25.1

