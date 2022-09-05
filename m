Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C661C5ACCB8
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237220AbiIEHIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237225AbiIEHHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:07:20 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448353AE59;
        Mon,  5 Sep 2022 00:06:48 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id m1so10078046edb.7;
        Mon, 05 Sep 2022 00:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=rvqEL5OxaTFmYPLu+pnYkWPJP4Nqo1vdHMNuF2F+zuY=;
        b=L4Q0EwQIscNdSh9aCEXhb00qMsm2KR9w92e1pobm1WnEt3HFG/vTKVvJ2o5x+Xz51l
         GdKOhAglPOKmxJ6ig9/Y9Ev2cUA1s/JUANT9J+RnUNUHtaxdOCgprcS+nPu00Ob0IW7D
         gcyRQB6/ALbNGBG1gxRuCGk6Yn78/barNPReX41oB52UcYJn1jusM4ioB/l/JAUlKV1D
         GkAHcdq/n52NXtL82lpwxb7eZF1WXqdhFDf3I9cZgRGXQ4YbAHhNFhIL3/7bIukrzqOC
         BU/DV5IpwZcxWutyn0qXH0gVUrpQbRLsJN+sKKlVsC3QMDaSbh5Wd3ph52eFtHZUAzfQ
         Kabg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=rvqEL5OxaTFmYPLu+pnYkWPJP4Nqo1vdHMNuF2F+zuY=;
        b=wN4YQ0l2sERqZcc0UY/57oCzaBgOn3+EZnmC2uoOp1RtrDZnbByTSrHJDiUynjsj1C
         4imgehsk2vJ6Uo6gdsWjmQg8UFNqszN2fsvighMWKzfYcpMD3Od/XydsxUqNzzObGh8/
         bWPGjcOUP2R3Cdvhqrh44/cjz/WjVlcdUMPp3TDcEUA6Djz1mGtGgPWYnEK6rNvvv/tF
         CwbxaaE1hJVtIDtMX/krhbHf/EVj+CYlkyoP2STlKCMdoz7DSmOMbH3wYPYMHDLzCdON
         VGe57mCF+54ZVWba+FMnDzi4aA+XPLsiEUs3ywBfJDAni+JjwPmGOQwFEr8XOI7+RKcY
         QzVQ==
X-Gm-Message-State: ACgBeo3SQDj/q99zgPWHtYm2l8P1Gh+rZyCtV7tfkniTgrAqnCOcaPQO
        uAi6uK6XwxGlQ+QnoQCYONU=
X-Google-Smtp-Source: AA6agR6vn/U5li0N/7raOj6o3RRU0uJEsKOR3LE0NEN2VSRxzGBijrdX37rZ45sQJcSChHGtMK67Qg==
X-Received: by 2002:a05:6402:1712:b0:44d:db03:46f2 with SMTP id y18-20020a056402171200b0044ddb0346f2mr6662090edu.260.1662361606682;
        Mon, 05 Sep 2022 00:06:46 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:40ec:9f50:387:3cfb])
        by smtp.gmail.com with ESMTPSA id n27-20020a056402515b00b0043cf2e0ce1csm5882775edd.48.2022.09.05.00.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 00:06:46 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
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
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 18/26] tcp: authopt: Add v4mapped ipv6 address support
Date:   Mon,  5 Sep 2022 10:05:54 +0300
Message-Id: <2830d885ea3ab71db10a5ca7f28e1c5556e32d43.1662361354.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662361354.git.cdleonard@gmail.com>
References: <cover.1662361354.git.cdleonard@gmail.com>
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
index 6db06e1edcc7..28c10a916fb3 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -324,27 +324,30 @@ static bool tcp_authopt_key_match_skb_addr(struct tcp_authopt_key_info *key,
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
@@ -353,10 +356,16 @@ static bool tcp_authopt_key_match_sk_addr(struct tcp_authopt_key_info *key,
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
@@ -1475,14 +1484,20 @@ static int __tcp_authopt_calc_mac(struct sock *sk,
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

