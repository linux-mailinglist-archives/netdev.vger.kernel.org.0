Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C686598D3C
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345776AbiHRUBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345707AbiHRUA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:00:59 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C97D1252;
        Thu, 18 Aug 2022 13:00:49 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id r4so3196193edi.8;
        Thu, 18 Aug 2022 13:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=fz9Xip6fpIPpoxcQh0P3hfzdJJCoggTYnPWhhC9vYvU=;
        b=nMk9xygbf27n1rhKi7t1bO6wpN9z1t7wyfYjUZ/AiDS5/QIECI2qwbr2YdpO5jklnn
         uwCxDSeVQNL0SfZMFeTKet/PGIiu2WcgBgONy3qSVMSHwBnTrLafwQW7704+KzWql5b8
         tkRyY0UkIAhot0hkGrnMgiVb+tDCaMgTkxSL0sNebQTBct2kRRXJ5SgyGUbwWLipArrj
         6oq8moc4pwvWUUkPWJStzPi6R3MCLlzsOjA7AtaheS6JZneWuH6CKY1spLpuIaFwUq3B
         1daEiBkjSRqy8LJ+q7OUolDcPm0wVMLva7EoyW+IWuSfkSkbt1aagb+Vbqlc5TU+zG5c
         1aVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=fz9Xip6fpIPpoxcQh0P3hfzdJJCoggTYnPWhhC9vYvU=;
        b=yZ3yvXFIP8L4t8XdD1YgujzMDjIugtl6qS0alc8MsCgmNeukEYL6hl/uywjs7sE7uU
         HqiCCX21xs4EjRdWakubMN+9On/oSIeFLzzy2BFMr5/h8TZlk3db+LksBnifnnYsksjY
         xiE2N8OzKuoCPe+FdaBgu6krUNQZ8KTeYRFIKoVP2Xv2muEHj8SWy+C3c6/26e1PrBAb
         in1dqCSIRJln38A7qhxKkJD/bQKM7YwJHJT4xaTwLnGvC+bimF4hKOWVtFEiNaDc+Ysw
         zN1MyWEH9xu3KJZy+Lns49z9lgdW/VJthBuR/IpM60coQb8RMLVvzoBplJoIpK+hDd3v
         yAbQ==
X-Gm-Message-State: ACgBeo1aqKfLfRyxPSwAjJfPwYgIdfpEfsOE7yMvER5ljKoE24Ig7ba3
        tltENmq7g3ORNAc9J8UNz3I=
X-Google-Smtp-Source: AA6agR6iwY9x8kl12nTZWk9P4D9Gn3eriM1icEnUb9iLvVsR1p40fCQWfJ4mWEu4Q09ingtDm9+R0g==
X-Received: by 2002:a05:6402:4414:b0:434:f58c:ee2e with SMTP id y20-20020a056402441400b00434f58cee2emr3432413eda.362.1660852848372;
        Thu, 18 Aug 2022 13:00:48 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:00:47 -0700 (PDT)
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
Subject: [PATCH v7 17/26] tcp: authopt: Add v4mapped ipv6 address support
Date:   Thu, 18 Aug 2022 22:59:51 +0300
Message-Id: <bdc3b4ca5eaec66d113f9740e43914174c38e5cc.1660852705.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660852705.git.cdleonard@gmail.com>
References: <cover.1660852705.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keys that are added with v4mapped ipv6 addresses will now be used for
ipv4 packets. This outward behavior is similar to how MD5 support
currently works.

The implementation is different - v4mapped keys are still stored with
ipv6 addresses.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_authopt.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 0b6cbd6f5491..06f8df1d80c9 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -301,27 +301,30 @@ static bool tcp_authopt_key_match_skb_addr(struct tcp_authopt_key_info *key,
 		struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
 
 		return ipv6_prefix_equal(&ip6h->saddr,
 					 &key_addr->sin6_addr,
 					 key->prefixlen);
+	} else if (keyaf == AF_INET6 && iph->version == 4) {
+		struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
+
+		/* handle ipv6-mapped-ipv4-addresses */
+		if (ipv6_addr_v4mapped(&key_addr->sin6_addr)) {
+			__be32 mask = inet_make_mask(key->prefixlen);
+			__be32 ipv4 = key_addr->sin6_addr.s6_addr32[3];
+
+			return (ipv4 & mask) == ipv4;
+		}
 	}
 
-	/* This actually happens with ipv6-mapped-ipv4-addresses
-	 * IPv6 listen sockets will be asked to validate ipv4 packets.
-	 */
 	return false;
 }
 
 static bool tcp_authopt_key_match_sk_addr(struct tcp_authopt_key_info *key,
 					  const struct sock *addr_sk)
 {
 	u16 keyaf = key->addr.ss_family;
 
-	/* This probably can't happen even with ipv4-mapped-ipv6 */
-	if (keyaf != addr_sk->sk_family)
-		return false;
-
 	if (keyaf == AF_INET) {
 		struct sockaddr_in *key_addr = (struct sockaddr_in *)&key->addr;
 		__be32 mask = inet_make_mask(key->prefixlen);
 
 		return (addr_sk->sk_daddr & mask) == key_addr->sin_addr.s_addr;
@@ -330,10 +333,16 @@ static bool tcp_authopt_key_match_sk_addr(struct tcp_authopt_key_info *key,
 		struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
 
 		return ipv6_prefix_equal(&addr_sk->sk_v6_daddr,
 					 &key_addr->sin6_addr,
 					 key->prefixlen);
+	} else if (keyaf == AF_INET6 && addr_sk->sk_family == AF_INET) {
+		struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
+		__be32 mask = inet_make_mask(key->prefixlen);
+		__be32 ipv4 = key_addr->sin6_addr.s6_addr32[3];
+
+		return (addr_sk->sk_daddr & mask) == ipv4;
 #endif
 	}
 
 	return false;
 }
@@ -1399,14 +1408,20 @@ static int __tcp_authopt_calc_mac(struct sock *sk,
 				  char *macbuf)
 {
 	struct tcp_authopt_alg_pool *mac_pool;
 	u8 traffic_key[TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN];
 	int err;
-	bool ipv6 = (sk->sk_family != AF_INET);
+	bool ipv6;
 
-	if (sk->sk_family != AF_INET && sk->sk_family != AF_INET6)
-		return -EINVAL;
+#if IS_ENABLED(CONFIG_IPV6)
+	if (input)
+		ipv6 = (skb->protocol == htons(ETH_P_IPV6));
+	else
+		ipv6 = (sk->sk_family == AF_INET6) && !ipv6_addr_v4mapped(&sk->sk_v6_daddr);
+#else
+	ipv6 = false;
+#endif
 
 	err = tcp_authopt_get_traffic_key(sk, skb, key, info, input, ipv6, traffic_key);
 	if (err)
 		return err;
 
-- 
2.25.1

