Return-Path: <netdev+bounces-1271-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F9E6FD27A
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 00:17:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A294D281164
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 22:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD621953A;
	Tue,  9 May 2023 22:16:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77A01952F
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 22:16:21 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F113A88
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:16:19 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f41dceb93bso26395845e9.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 15:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1683670578; x=1686262578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TNaNVg3b0b9p/yqj32LHesflwoL6NjpvZvYZ6iwGQ4U=;
        b=M7PTN/jPtZaCbndrgKXB5fUCiuP/OVHWsN+jZdRGTMrM92yC/uBuA2QYkvFzTEhkgy
         a8lC+CIRThgZOMqbBUhknW9IB1HHR7iRUa64Eunab591Iahlk2tzjuEI5L4cDcYj4oA4
         2JWmYcEBwsrPQE/8sTHxNUeBh3n618jO2ybsjbQdXiIeKcC5RNHNPK5Gn49bsx0BFGbv
         nyEdnlNxhDL2arE8+9mn41l+RC+anZPWyzKH8iAsyg/EPbD/YrHzxW8dqMtT+nX0BHYw
         ZYsQcxIt2tYSetXfh29BtDqXLzGEfSuhvtzL5WhBbV2wgKDUOaa123gVyZBNHGAQUyEf
         KCwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683670578; x=1686262578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TNaNVg3b0b9p/yqj32LHesflwoL6NjpvZvYZ6iwGQ4U=;
        b=fAt8/R+zFSTIif/4vaK8zUYC9IcKwpybAMvJFcBRX1SlOvLdFQvLaUUnyvcVEqThAB
         XDTbiFfL3ouMG09LXTDCJ9INS+zlTk7MYA6W2QWcgVkPmN2OdZDIFqOPL25k34qbF/oH
         LB9Hm7fRUuAHoMq9sdf6H0lXKP/AstDeXSM2Ha8ea9iLz3BQf4CdP9rEx65lHFFiDEZJ
         xokIW4KUSBOnD/qChun3beofBselMkyPLlR8Sbte2XtQzM+I4qgFLHfxElXfAw7G7Fp6
         NE6UvVBV0ezuAiitb+8yRfRbZQEOSB03YltjpiTIXRaTcY1iooP/k7BQFDFzpOaEnZiU
         2Jqg==
X-Gm-Message-State: AC+VfDzQBDFDJXXre6aGDo6+0ddTThdx8QB5huMhFW6ygd55NmUb40AY
	7cYPGGBnPVwKwSObnZSeCPaEJw==
X-Google-Smtp-Source: ACHHUZ72PpzNWq8SWA6TsHvvINJ8EjbBBRkPnspE4OoKvfr3prJsNXhmoxE9wTRql5V7Jz8yi5i9hw==
X-Received: by 2002:a7b:c8d9:0:b0:3f4:2174:b284 with SMTP id f25-20020a7bc8d9000000b003f42174b284mr6687645wml.28.1683670577699;
        Tue, 09 May 2023 15:16:17 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id t25-20020a7bc3d9000000b003f42d3111b8sm2052888wmj.30.2023.05.09.15.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 15:16:17 -0700 (PDT)
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
Subject: [PATCH 2/5] net/tcp: Use tcp_v6_md5_hash_skb() instead of .calc_md5_hash()
Date: Tue,  9 May 2023 23:16:05 +0100
Message-Id: <20230509221608.2569333-3-dima@arista.com>
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
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Using af-specific callback requires the socket to be full (struct tcp_sock).
Using tcp_v6_md5_hash_skb() instead, depending on passed family
parameter makes it possible to use it for non-full sockets as well (if
key-lookup succeeds). Next commit uses tcp_inbound_md5_hash() to verify
segments on twsk.
This seems quite safe to do, as pre-commit 7bbb765b7349 ("net/tcp: Merge
TCP-MD5 inbound callbacks") ip-version-specific functions
tcp_v{4,6}_inbound_md5_hash were calling
tcp_v4_md5_hash_skb()/tcp_v6_md5_hash_skb().

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h   | 11 +++++++++++
 net/ipv4/tcp.c      |  9 +++------
 net/ipv6/tcp_ipv6.c |  6 ++----
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 04a31643cda3..e127fc685ca6 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1676,6 +1676,17 @@ struct tcp_md5sig_pool {
 /* - functions */
 int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 			const struct sock *sk, const struct sk_buff *skb);
+#if IS_ENABLED(CONFIG_IPV6)
+int tcp_v6_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
+			const struct sock *sk, const struct sk_buff *skb);
+#else
+static inline int tcp_v6_md5_hash_skb(char *md5_hash,
+			const struct tcp_md5sig_key *key,
+			const struct sock *sk, const struct sk_buff *skb)
+{
+	return -EPROTONOSUPPORT;
+}
+#endif
 int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		   int family, u8 prefixlen, int l3index, u8 flags,
 		   const u8 *newkey, u8 newkeylen);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 20db115c38c4..c1897a039ff5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4570,7 +4570,6 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	const __u8 *hash_location = NULL;
 	struct tcp_md5sig_key *hash_expected;
 	const struct tcphdr *th = tcp_hdr(skb);
-	const struct tcp_sock *tp = tcp_sk(sk);
 	int genhash, l3index;
 	u8 newhash[16];
 
@@ -4601,13 +4600,11 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	 * IPv4-mapped case.
 	 */
 	if (family == AF_INET)
-		genhash = tcp_v4_md5_hash_skb(newhash,
-					      hash_expected,
+		genhash = tcp_v4_md5_hash_skb(newhash, hash_expected,
 					      NULL, skb);
 	else
-		genhash = tp->af_specific->calc_md5_hash(newhash,
-							 hash_expected,
-							 NULL, skb);
+		genhash = tcp_v6_md5_hash_skb(newhash, hash_expected,
+					      NULL, skb);
 
 	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 42792bc5b9bf..574398a89970 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -732,10 +732,8 @@ static int tcp_v6_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
 	return 1;
 }
 
-static int tcp_v6_md5_hash_skb(char *md5_hash,
-			       const struct tcp_md5sig_key *key,
-			       const struct sock *sk,
-			       const struct sk_buff *skb)
+int tcp_v6_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
+			const struct sock *sk, const struct sk_buff *skb)
 {
 	const struct in6_addr *saddr, *daddr;
 	struct tcp_md5sig_pool *hp;
-- 
2.40.0


