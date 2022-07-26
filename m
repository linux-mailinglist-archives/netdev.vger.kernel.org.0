Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB90581ADA
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 22:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239886AbiGZUQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 16:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239721AbiGZUQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 16:16:21 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A62326FE
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:16:12 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id q18so11190722wrx.8
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=pdEmRQDkktxyj133IoEXqOneVb48tak5Ed7jC2tmPss=;
        b=NoSqp+M8tdLz1sYdFPgF7sEQXLSNybM3qMMiMI+8XdUdNnT/1ziUDTfJOPtzM2pf7B
         60eDbGh5QPE2+3VRM5/liw90GlJa4dRAWD35fnQU46tW6uTxxrgvQzAkvdyK7YDJ2BLL
         S3yc9XpH15mLCEnOqP5tHgO4eztj0vRCO/Lc/AY/QTEDwvOWN66UwOj7wv9/l0cdHWwH
         Z1elrL0lZEiHkoxXg3msEDCkqQxfTT0XD+8ar1CJzEgclE0dYP0wH9K0jeeflUXT27Ct
         S51HGosABXnq1obGhEZfcrAIwK2QXaf24/I71b2B99nO+tCN3RNfD/A+47RYIDlq+xYO
         I1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=pdEmRQDkktxyj133IoEXqOneVb48tak5Ed7jC2tmPss=;
        b=7EWeraUsa1qRVyaIVhL2B0nkJjUjh5tCZBJht+ifj+j2JryCgzM7EetHzhornPAvxJ
         NwUx9MOpDwuFpKaLeiG38wrRc3xw7Uk/JxH2ULnBfGKgEUbxpamS2ZBU8ee0VgWdls77
         NDMibz4eKMjhup6cc89DurLmDr+4b9a9LmITWxfs5dIXMJe84SLhoxnmKKFu8DdlK6Tj
         LbUOZjETKYWM0M0S+LMLUErGtGxDcSb3619aCvaMhzhoSRdhO3t8iFBwQgk0PtaRaetR
         s5oODOUckWzAfW1UGZ0SGMp7oyJmGOqfXdwy0KEveumflVtdCc+k0Pzf4GHYHyALzAIE
         9QOA==
X-Gm-Message-State: AJIora/49jRUdAOQujuC5/rlRicPA1JVwXpb40mxg5l/N/7q4z63/kT1
        CNvmKnwiL5vd1HFwiqDgZ1ATdA==
X-Google-Smtp-Source: AGRyM1uQRBcHLiZ1Y9LPpdW7z50O+MQLPM9/unZYKIWc040bRCMVRnpd/+MrBgLnu3o3KKE4D15qKg==
X-Received: by 2002:a5d:5581:0:b0:20f:fc51:7754 with SMTP id i1-20020a5d5581000000b0020ffc517754mr12412279wrv.413.1658866571059;
        Tue, 26 Jul 2022 13:16:11 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c3b0600b003a320e6f011sm28073wms.1.2022.07.26.13.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 13:16:10 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 3/6] net/tcp: Separate tcp_md5sig_info allocation into tcp_md5sig_info_add()
Date:   Tue, 26 Jul 2022 21:15:57 +0100
Message-Id: <20220726201600.1715505-4-dima@arista.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220726201600.1715505-1-dima@arista.com>
References: <20220726201600.1715505-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to allocate tcp_md5sig_info, that will help later to
do/allocate things when info allocated, once per socket.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/ipv4/tcp_ipv4.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 0c83780dc9bf..55e4092209a5 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1152,6 +1152,24 @@ struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
 }
 EXPORT_SYMBOL(tcp_v4_md5_lookup);
 
+static int tcp_md5sig_info_add(struct sock *sk, gfp_t gfp)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_md5sig_info *md5sig;
+
+	if (rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk)))
+		return 0;
+
+	md5sig = kmalloc(sizeof(*md5sig), gfp);
+	if (!md5sig)
+		return -ENOMEM;
+
+	sk_gso_disable(sk);
+	INIT_HLIST_HEAD(&md5sig->head);
+	rcu_assign_pointer(tp->md5sig_info, md5sig);
+	return 0;
+}
+
 /* This can be called on a newly created socket, from other files */
 int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		   int family, u8 prefixlen, int l3index, u8 flags,
@@ -1182,17 +1200,11 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		return 0;
 	}
 
+	if (tcp_md5sig_info_add(sk, gfp))
+		return -ENOMEM;
+
 	md5sig = rcu_dereference_protected(tp->md5sig_info,
 					   lockdep_sock_is_held(sk));
-	if (!md5sig) {
-		md5sig = kmalloc(sizeof(*md5sig), gfp);
-		if (!md5sig)
-			return -ENOMEM;
-
-		sk_gso_disable(sk);
-		INIT_HLIST_HEAD(&md5sig->head);
-		rcu_assign_pointer(tp->md5sig_info, md5sig);
-	}
 
 	key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
 	if (!key)
-- 
2.36.1

