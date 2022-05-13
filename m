Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2665269AA
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383453AbiEMS4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383469AbiEMS4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:56:14 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80986C0DA
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:56:08 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id p8so8424980pfh.8
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1eVW6kVW/vGRNhMVNOqzUJcLuY6jXULfLVuE7Ejkm8I=;
        b=TQ+rh0C4qL2yBrrhDpjW6U+pmT/+rOn3u89TsXUCCq2oeMw57GrtpiGTtuFUrmwwjF
         maxpvcBhMGpYW5FQ36VYW0tESGYykReN8lck4XxiyMAlUx2IJNl+z8kblgbUSKveKbtL
         L/Ejv524NhkuOvxirfoS/CdpfNe/LBU9OrLpdGjw+7apvFxF7fJsQAoT/kOAf+j3R429
         tHkeRvGQzc9ReL7G7dlZKSCBtwdqXVlgQzMMPmMoY3PNZ2n8xscTCS/4LcuvjWOFML5q
         RlhR7dt/tDsJ9g4glDDHCPRT039Yt0YIIboRLSRPQsqTKs6bFgDntT8n7BiLE+rEHsLx
         DDsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1eVW6kVW/vGRNhMVNOqzUJcLuY6jXULfLVuE7Ejkm8I=;
        b=HSHWKok5y+yXXkEBiNuOEMxsA4M/TEnNkfmEZrSpvWzlT0cVmy+uHYrp+KyEgV1sWY
         0/21gZBR/Mb3h27PtNDewK9UmGxMySd5xcM3sppqc7U17U2XMEysSoC/pd5mGven22g2
         KONzXCXSfgqud4jggzrQoygl9rurxWgWGMAZt51bPfkpcYsXqKEBFyR+KdrwRir4sJMg
         G1xAuF9ueq6qoMInmr3KBmEsnUcJjBFTV8/UZALWiSHkJLg4jFNHwioDT8s8OeH2Dnri
         ekWVfczcJb3V8tRt6OLycYk4b8lBvC2afG6eiZRYHVNG3Tfds1vmkptwPNYoh4ZkVl+S
         v5yg==
X-Gm-Message-State: AOAM530n+QX7o0KvM/PUQ9GOdBm2oOoODFzApCHIt8YyBQOAGyWPXUrT
        5+HqbOMdxTafusIzbHHcHZY=
X-Google-Smtp-Source: ABdhPJxrfNM3wXFQ9Rh3eg8eJj6ifdkwTN6lMYA4rEwbITmYGpdrwv3mHvuGNly86csev8EHtQJOvA==
X-Received: by 2002:a63:5510:0:b0:3db:8bb3:6059 with SMTP id j16-20020a635510000000b003db8bb36059mr4964316pgb.328.1652468168237;
        Fri, 13 May 2022 11:56:08 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c10200b0015e8d4eb2absm2159537pli.245.2022.05.13.11.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:56:07 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH v2 net-next 10/10] inet: rename INET_MATCH()
Date:   Fri, 13 May 2022 11:55:50 -0700
Message-Id: <20220513185550.844558-11-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513185550.844558-1-eric.dumazet@gmail.com>
References: <20220513185550.844558-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

This is no longer a macro, but an inlined function.

INET_MATCH() -> inet_match()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Suggested-by: Olivier Hartkopp <socketcan@hartkopp.net>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/inet_hashtables.h | 2 +-
 net/ipv4/inet_hashtables.c    | 8 ++++----
 net/ipv4/udp.c                | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 59d72024ad1d6fe34342309191b46fbb247b125b..ebfa3df6f8dc365b4ce5f4c4fb573c37193492ab 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -267,7 +267,7 @@ static inline struct sock *inet_lookup_listener(struct net *net,
 				   ((__force __u64)(__be32)(__saddr)))
 #endif /* __BIG_ENDIAN */
 
-static inline bool INET_MATCH(struct net *net, const struct sock *sk,
+static inline bool inet_match(struct net *net, const struct sock *sk,
 			      const __addrpair cookie, const __portpair ports,
 			      int dif, int sdif)
 {
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index acec83ef8220025f129194dee83c3a465bf3915e..87354e20009a6e03c9efdca9c0b51dea17ad71d5 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -373,10 +373,10 @@ struct sock *__inet_lookup_established(struct net *net,
 	sk_nulls_for_each_rcu(sk, node, &head->chain) {
 		if (sk->sk_hash != hash)
 			continue;
-		if (likely(INET_MATCH(net, sk, acookie, ports, dif, sdif))) {
+		if (likely(inet_match(net, sk, acookie, ports, dif, sdif))) {
 			if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
 				goto out;
-			if (unlikely(!INET_MATCH(net, sk, acookie,
+			if (unlikely(!inet_match(net, sk, acookie,
 						 ports, dif, sdif))) {
 				sock_gen_put(sk);
 				goto begin;
@@ -426,7 +426,7 @@ static int __inet_check_established(struct inet_timewait_death_row *death_row,
 		if (sk2->sk_hash != hash)
 			continue;
 
-		if (likely(INET_MATCH(net, sk2, acookie, ports, dif, sdif))) {
+		if (likely(inet_match(net, sk2, acookie, ports, dif, sdif))) {
 			if (sk2->sk_state == TCP_TIME_WAIT) {
 				tw = inet_twsk(sk2);
 				if (twsk_unique(sk, sk2, twp))
@@ -492,7 +492,7 @@ static bool inet_ehash_lookup_by_sk(struct sock *sk,
 		if (esk->sk_hash != sk->sk_hash)
 			continue;
 		if (sk->sk_family == AF_INET) {
-			if (unlikely(INET_MATCH(net, esk, acookie,
+			if (unlikely(inet_match(net, esk, acookie,
 						ports, dif, sdif))) {
 				return true;
 			}
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 53342ce17172722d51a5db34ca9f1d5c61fb82de..aa9f2ec3dc4681f767e8be9d580096ba8b439327 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2563,7 +2563,7 @@ static struct sock *__udp4_lib_demux_lookup(struct net *net,
 	struct sock *sk;
 
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
-		if (INET_MATCH(net, sk, acookie, ports, dif, sdif))
+		if (inet_match(net, sk, acookie, ports, dif, sdif))
 			return sk;
 		/* Only check first socket in chain */
 		break;
-- 
2.36.0.550.gb090851708-goog

