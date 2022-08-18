Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCB159898C
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345225AbiHRRAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345326AbiHRRA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:00:28 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D133CCAC80
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:19 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id v7-20020a1cac07000000b003a6062a4f81so2898207wme.1
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=xSHEKKWkN852PeSeoo9ORaeQTI8EOweWE++J7xZUzqQ=;
        b=UYE0G8c63YZhL5AL11H6DPfD/fLeTPP7tteq56sbhxy43WK3NTk6AoI2rgcEqhf0Sm
         qBWbR+bRdQiU6AeCOvKVb9FfQqGRtnpcnCmPSJluxSKE5JCdF2wKeAB8cKpPkosMZdyG
         PDHxTT7wnAsm9RBXeLzN7ZQ6jB8mO/rnKLXLE60zBZWXyb2DgSIZrYuwmgFviepdgJ59
         SG6qQLhcQuI+CoiJD0PbBRCqYyN9rwFVp/E8CRpFVgJ7g4s+k6zyssSS7Bn9yxaLxBkc
         FxGS81bXRsugW7QfwQ0EL/UY4RCeIHlEhctma0lgwyfUzP39dR4LY8zfZHXX2YltvaOJ
         qQPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=xSHEKKWkN852PeSeoo9ORaeQTI8EOweWE++J7xZUzqQ=;
        b=RUjVyYHv2ItB1aACS+oECs25OxI9CN18fSyThBpQ4BkEUjkMuUiyU9dHp2UHP0hv6w
         KXc8Cbgj9ApoGoWlTaTiHiHcahvmKqN/2zM6tWTS4WR/8EKFq+oEEUQReAYza3eR5WuO
         nCbR/xK+3McYPF5U3pMrRN9DGWPvsEXhNDhYZX9u2FDCJGVCW33FuO7jNLaEcb+XCJSh
         Ecc12HeEhP5FqRah+CahDL8HG01Gcs72UaAhgGWdooLJIbpFkHgBcyH+xvLaF+ldDADh
         iO501cdeHgTsJcDPcok9hlXGIpcNx01TTsBJFW5iC9QadK9O2DFiHxq/mkOmSZzOhzNb
         BvXQ==
X-Gm-Message-State: ACgBeo1+ciGzyu23fCxYnwlZavafSAM17/Z/cycWfG8EoBJPG25P7KLh
        ZL+EBFhf60Q1+lBgdzPuoTuSQQ==
X-Google-Smtp-Source: AA6agR4OFtLFcq8eExbn7fg8jNUpt8XDTqihJ0k0SNAEUte+cLKR6kHRNsvx+gk10kswPzzAP3iW/Q==
X-Received: by 2002:a1c:7907:0:b0:3a5:a965:95e6 with SMTP id l7-20020a1c7907000000b003a5a96595e6mr5740748wme.75.1660842017436;
        Thu, 18 Aug 2022 10:00:17 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:17 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
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
Subject: [PATCH 03/31] net/tcp: Separate tcp_md5sig_info allocation into tcp_md5sig_info_add()
Date:   Thu, 18 Aug 2022 17:59:37 +0100
Message-Id: <20220818170005.747015-4-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818170005.747015-1-dima@arista.com>
References: <20220818170005.747015-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
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
2.37.2

