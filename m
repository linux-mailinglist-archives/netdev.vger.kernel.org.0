Return-Path: <netdev+bounces-1272-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 163B86FD27C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 00:17:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63C8D2812A4
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 22:17:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5648619E46;
	Tue,  9 May 2023 22:16:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CDB19E43
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 22:16:22 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511093A96
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:16:20 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f315712406so225563635e9.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 15:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1683670579; x=1686262579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5EJY8QyVbpJhiPPm5kdYZASszxMCuGSjGBPUFVMUXvI=;
        b=FcjLRwJPwp06s9w82pX/hEkZrz5VOfCVr8glc6TOnWPf+LMM++AznMYK87XQS5co7y
         +4+YmedtGpd3XT+lF2S5FOOFzFcD1jLk/tEjfMVh5b5X9Lup1KkvIQRepDVQ7GHSYrJN
         rZNg3MXT522o93w68sSY3QzKK1RRscQorcBZXU2gEddOWpJt+W10X/6Pg7Anh1MbDD07
         nFjJWAnW6d3kc1vddRzE5N9cipB5louiR7A4DfMMh58WzS38lnfV6v/WOgdTspHz6t3Y
         +TvoKX6KWNt07ETKyePmGCg2deRczsaKd5qPyQqWPq7feqFebU6KbWBtXfO4KPLjFTGM
         qruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683670579; x=1686262579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5EJY8QyVbpJhiPPm5kdYZASszxMCuGSjGBPUFVMUXvI=;
        b=ixlEFr/QJxEpEXDS9YHqvJnuTbWtMEsN5Q5s3DRPR5ZQmEGvDH6mB9WhoJ6B519P/X
         zE9wrYOzvh1+RoQQtMmdaT7YH/3/2s0oOxyl0RYP2tYCy2A23LnTg0cVlw5GN7j0YYZN
         9N4XOgGxPUxR1Umx15+GigU6MphbPO3ViRAN0+dfNZUZri8CDewfB/qeAJj0IohpA5pt
         Y/1UvwPKhAEafolQP95+xVLSB1eW05siOdWzxeqAfqOAfRxsB1ubYZZMMYrZEyMntu3n
         BNFi77ldQoEoLhw3EqrXhuynP91GHNxm6pqUPNsFQ6bHjs/UJrMtLNlMf0TOI59jLDHC
         GFDw==
X-Gm-Message-State: AC+VfDwb2Ev+q4y7hhbNp/AhOw56R8XX2z0YoO6cxNpoeueTOduGFe9M
	ugWk4AxKvFDTRhMLEMmuRVMXrg==
X-Google-Smtp-Source: ACHHUZ4oKL1FJ8j955YZRxPMmcgVnkpvDuwo1LJcxMsaqA/A4/rFsAnUsMPungai8eg5gPgvvfbQNA==
X-Received: by 2002:adf:f2ca:0:b0:307:8b6f:dcf1 with SMTP id d10-20020adff2ca000000b003078b6fdcf1mr8185594wrp.25.1683670578783;
        Tue, 09 May 2023 15:16:18 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id t25-20020a7bc3d9000000b003f42d3111b8sm2052888wmj.30.2023.05.09.15.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 15:16:18 -0700 (PDT)
From: Dmitry Safonov <dima@arista.com>
To: linux-kernel@vger.kernel.org,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <dima@arista.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>,
	netdev@vger.kernel.org
Subject: [RFC 3/5] net/tcp-md5: Verify inbound segments on twsk
Date: Tue,  9 May 2023 23:16:06 +0100
Message-Id: <20230509221608.2569333-4-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230509221608.2569333-1-dima@arista.com>
References: <20230509221608.2569333-1-dima@arista.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

It seems rare for BGP to have twsk socket and quite unlikely on server
side, in addition I don't see any major concern of destroying twsk early
by unsigned segments.
But on the other hand, it seems better not to change TCP state by
unsigned inbound segments and fixing this seems not hard.
So, lets avoid replying or doing any TCP state changes as long as the
segments weren't verified.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h   |  7 ++++---
 net/ipv4/tcp_ipv4.c |  9 +++++++--
 net/ipv6/tcp_ipv6.c | 10 ++++++++--
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index e127fc685ca6..db13dc7558f4 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1705,12 +1705,16 @@ extern struct static_key_false_deferred tcp_md5_needed;
 struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 					   const union tcp_md5_addr *addr,
 					   int family);
+
+#define tcp_twsk_md5_key(twsk)	((twsk)->tw_md5_key)
 static inline struct tcp_md5sig_key *
 tcp_md5_do_lookup(const struct sock *sk, int l3index,
 		  const union tcp_md5_addr *addr, int family)
 {
 	if (!static_branch_unlikely(&tcp_md5_needed.key))
 		return NULL;
+	if (unlikely(sk->sk_state == TCP_TIME_WAIT))
+		return tcp_twsk_md5_key(tcp_twsk(sk));
 	return __tcp_md5_do_lookup(sk, l3index, addr, family);
 }
 
@@ -1718,9 +1722,6 @@ enum skb_drop_reason
 tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 		     const void *saddr, const void *daddr,
 		     int family, int dif, int sdif);
-
-
-#define tcp_twsk_md5_key(twsk)	((twsk)->tw_md5_key)
 #else
 static inline struct tcp_md5sig_key *
 tcp_md5_do_lookup(const struct sock *sk, int l3index,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b1056a4af60f..f5b870943dcb 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -676,7 +676,7 @@ static bool tcp_v4_md5_sign_reset(struct net *net, const struct sock *sk,
 		return !!hash_location;
 
 	rcu_read_lock();
-	if (sk && sk_fullsock(sk)) {
+	if (sk && sk->sk_state != TCP_NEW_SYN_RECV) {
 		const union tcp_md5_addr *addr;
 		int l3index;
 
@@ -2195,8 +2195,13 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	goto discard_it;
 
 do_time_wait:
-	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb)) {
+	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
 		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
+	else
+		drop_reason = tcp_inbound_md5_hash(sk, skb,
+						   &iph->saddr, &iph->daddr,
+						   AF_INET, dif, sdif);
+	if (drop_reason) {
 		inet_twsk_put(inet_twsk(sk));
 		goto discard_it;
 	}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 574398a89970..3756a43367a3 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -987,7 +987,7 @@ static int tcp_v6_md5_lookup_reset_key(struct net *net, const struct sock *sk,
 	if (!static_branch_unlikely(&tcp_md5_needed.key))
 		return !!hash_location;
 
-	if (sk && sk_fullsock(sk)) {
+	if (sk && sk->sk_state != TCP_NEW_SYN_RECV) {
 		/* sdif set, means packet ingressed via a device
 		 * in an L3 domain and inet_iif is set to it.
 		 */
@@ -1795,8 +1795,14 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	goto discard_it;
 
 do_time_wait:
-	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
+	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
 		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
+	else
+		drop_reason = tcp_inbound_md5_hash(sk, skb,
+						   &hdr->saddr, &hdr->daddr,
+						   AF_INET6, dif, sdif);
+
+	if (drop_reason) {
 		inet_twsk_put(inet_twsk(sk));
 		goto discard_it;
 	}
-- 
2.40.0


