Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21599634410
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234643AbiKVSz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbiKVSzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:55:49 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70B08A156
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:55:48 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso12015400wmo.1
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TjLQXh6CP0bu3ylJVW1lqp0iv9ZGwOCitUmVTWM7f24=;
        b=asabgvgZjZSEg11xskqHJkg3F5Xt5qAFKTk90VSv7grWhNbP8hGqtDw0UFtYqeZFqB
         kqVf95FR9eYSguoS+pBS2IeeKZSt+1lpazHQKt7SzCk8+n0ervhX22xnSuAlsN4jQ14s
         znUZIGo1SS3G23ZS3rnwHqNuDRgzZdfOz2wTkF+jM2kocRzi1pEbeiB6hyEYS9pWHblB
         QgK0XdYR7s4K0a+xN7xta54ggnCeqAXRHGskijyQjS3k7yCZOinqyO8ghFbnuMNB7OnH
         uqNJUwWqjkb14X8lx1S0P43uCIfTf+ZGd9RBQOYcGK3sXovfAMJOQNKVcGjPrA+sHAwi
         rE2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TjLQXh6CP0bu3ylJVW1lqp0iv9ZGwOCitUmVTWM7f24=;
        b=G3m2IXf2YrUxUdVJ+BDsW/9hY4ACuAojDcfh0FFoarX2dImN7HHDiPLBhEoqPbV27T
         makFrLPGdNuGRRGPUC5MGI7kcPIxdfGCjqYY3dxzhY0ATjztVhwsLNXj3iHCBjneDhNk
         LUQzagXcv6b/Xf9YS8tkAhy0mDUYMklG5tdVAJ18FREe7BMhSIQw67LSo00UuxKuvau9
         o8rU1o8tvO1mxmpe9SUOoIkeJ9LN/pZoVbPbMOg97cGKemLzUnAzufko5w34Yt2LYh0w
         AkW3W39zRMEvWmhSIA65IXoYnEIEYu1fVJpzPq7Bi282VgzGmam6Ufk1pkjLLsKn7klG
         GS2A==
X-Gm-Message-State: ANoB5pk7t89vpVIAiaZKyyKXUjDR6W+niJ4ECobjKpGA66guoZIXQMja
        rBjQvY+VyZivvUIYIkqKCTXm3w==
X-Google-Smtp-Source: AA0mqf4OrpPFpBv5CI8DTctBhdPyUFsioA1IPtGkc+JVG50NiKC12iES65NEYeCJwNUVfDYyTVa2Eg==
X-Received: by 2002:a05:600c:3108:b0:3c6:bd12:ac68 with SMTP id g8-20020a05600c310800b003c6bd12ac68mr20905077wmo.123.1669143347407;
        Tue, 22 Nov 2022 10:55:47 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb12000000b002365730eae8sm14478044wrr.55.2022.11.22.10.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 10:55:47 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Dmitry Safonov <dima@arista.com>, Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Subject: [PATCH v5 4/5] net/tcp: Do cleanup on tcp_md5_key_copy() failure
Date:   Tue, 22 Nov 2022 18:55:33 +0000
Message-Id: <20221122185534.308643-5-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122185534.308643-1-dima@arista.com>
References: <20221122185534.308643-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the kernel was short on (atomic) memory and failed to allocate it -
don't proceed to creation of request socket. Otherwise the socket would
be unsigned and userspace likely doesn't expect that the TCP is not
MD5-signed anymore.

Signed-off-by: Dmitry Safonov <dima@arista.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/tcp_ipv4.c |  9 ++-------
 net/ipv6/tcp_ipv6.c | 15 ++++++++-------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 776fbc2451bc..6ddfa8e45d03 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1630,13 +1630,8 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	addr = (union tcp_md5_addr *)&newinet->inet_daddr;
 	key = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
 	if (key) {
-		/*
-		 * We're using one, so create a matching key
-		 * on the newsk structure. If we fail to get
-		 * memory, then we end up not copying the key
-		 * across. Shucks.
-		 */
-		tcp_md5_key_copy(newsk, addr, AF_INET, 32, l3index, key);
+		if (tcp_md5_key_copy(newsk, addr, AF_INET, 32, l3index, key))
+			goto put_and_exit;
 		sk_gso_disable(newsk);
 	}
 #endif
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 83304d6a6bd0..21486b4a9774 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1376,13 +1376,14 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	/* Copy over the MD5 key from the original socket */
 	key = tcp_v6_md5_do_lookup(sk, &newsk->sk_v6_daddr, l3index);
 	if (key) {
-		/* We're using one, so create a matching key
-		 * on the newsk structure. If we fail to get
-		 * memory, then we end up not copying the key
-		 * across. Shucks.
-		 */
-		tcp_md5_key_copy(newsk, (union tcp_md5_addr *)&newsk->sk_v6_daddr,
-				 AF_INET6, 128, l3index, key);
+		const union tcp_md5_addr *addr;
+
+		addr = (union tcp_md5_addr *)&newsk->sk_v6_daddr;
+		if (tcp_md5_key_copy(newsk, addr, AF_INET6, 128, l3index, key)) {
+			inet_csk_prepare_forced_close(newsk);
+			tcp_done(newsk);
+			goto out;
+		}
 	}
 #endif
 
-- 
2.38.1

