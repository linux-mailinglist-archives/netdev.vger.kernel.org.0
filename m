Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE056102EC
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbiJ0UoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236552AbiJ0UoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:44:01 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AA57173C
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:44:01 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v1so4145731wrt.11
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mqJckVrQg7Ntll0dZ6IL+1cA9p9Fyu8BflY8RBnW50o=;
        b=adksfXU+IhKWZkTCsv/Jcv4ToprOrvbwTBksLrI9oR+mVHGGcv2M+bzWDg6c3Ei0LL
         YIDu6kSyWeVF1gxECYDffcL+Gm66Tiow7qbitsojkjI6rNtCXi8rjSgDZ/7GYuGQ29Ga
         bdHtqQrdJqgNW5QLmAjWCqndg+pHDaCwhajmklTkWp46KOZb720UmH6+b6mrPcP5tUlS
         vmh1nXjO5l26AiTBzQDW43ew8nwJ3kObZfz8tYr9oFNv2FC6V8Eu/daou6yxzUY5ImYb
         De2OexjjNkF1d7lW4nu9vveS3ONmHaH8CSus/o+4VGJbqmOoae7gTjO8NmsyJa7AsERN
         skJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mqJckVrQg7Ntll0dZ6IL+1cA9p9Fyu8BflY8RBnW50o=;
        b=33+vvEEvucQocjPWb8cOEmbmY8bWETx7planq5HwyM0gk4T75LghbfIxpWPxm1KBH4
         yvqW6F6zAJvL/qgXPU9EpIdwEMzQjiPMc8UTNFnvIlNPqtd2ZkEdaVqPlro7nGlxoYy8
         as2kNrKiSxqLvTgjCtBFMA25AshgOyXIExsAjUxGX4VoJBe/kNH5ar41qxl5Aka9Eu2I
         hAQEJjNntSZkIrCdEH7IZyPPKMQSLZha5LmJwBp2w0Y3Aadi18ExTy0eYayxMUS/SCoa
         rdAe4kcZOwzZjRij62JRW89P8VbXR4OmJzkWuHQavihzUe6bDqGrhu+cwnxVdpIHin2E
         yhzA==
X-Gm-Message-State: ACrzQf1K81DGyxvnQW8zekIvpBRhE9kaW4VG0EdfOqWahuHeY1fZd2jQ
        hnsDsBMT+l6a92I6Q7Nd9olZ7w==
X-Google-Smtp-Source: AMsMyM7ufBiXSUdy6XA2PSxE6SbX0e3VGqoCT3nF6lUpJF9Ii1Vt9YuHAtQ+Zj0E3hZOb8dRT0BRiw==
X-Received: by 2002:adf:f98a:0:b0:236:677c:2407 with SMTP id f10-20020adff98a000000b00236677c2407mr17998847wrr.578.1666903439683;
        Thu, 27 Oct 2022 13:43:59 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:43:59 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 03/36] net/tcp: Separate tcp_md5sig_info allocation into tcp_md5sig_info_add()
Date:   Thu, 27 Oct 2022 21:43:14 +0100
Message-Id: <20221027204347.529913-4-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027204347.529913-1-dima@arista.com>
References: <20221027204347.529913-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 87d440f47a70..fae80b1a1796 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1172,6 +1172,24 @@ struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
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
@@ -1202,17 +1220,11 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
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
2.38.1

