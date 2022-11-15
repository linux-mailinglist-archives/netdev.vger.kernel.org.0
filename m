Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C4D62A3E4
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 22:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238654AbiKOVUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 16:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbiKOVTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 16:19:51 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2904222BE1
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 13:19:46 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id a14so26564151wru.5
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 13:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CbvR8VuafE8eZOle2gcxzJnLTEWWuPtnJ8HojgPG8FI=;
        b=So8k6c4YUMYle8Ql/rzA3xQ5ONAF2vFeIa6jwrybulTP13y/R3ALP9iTxURI6rMu6K
         ZIyS+KTc8uBbD4SJ/rVRGyi71ryjisJwpfc9gslhHK5FvC5NCBr0UJswTDAWAsMnc9fh
         tCuecNekzJkN3dZuHBa+Ce2pqo+Y8bRl4d26M/C4I/NrGZxRnqGdLdzEBK4Cp2sdfl23
         MFyDAZaCvFLAhK1o953S6zagd00CG4fVMo/lLTsXr1FufWFd4J5fgw7uzphBOHvb2+OO
         NdLg7MRgSYitg/HwlWdd0Y76wIdRrO95Laa30A+hut7EAcrJQMTqL6hJ1rgHzMNyjsam
         5YLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CbvR8VuafE8eZOle2gcxzJnLTEWWuPtnJ8HojgPG8FI=;
        b=M4z/9B7XbZDCgn3VyfD5lnk1iy1zowTtB/K1vDGnYuF/5QJ2nviz4Ht2xNQBjoe+LV
         Xon/ObsMvIGMu7Mrjrr+ijZuL8cz9n9FggI9XNdRCh6pe31nICogpc5MbOo+baiVQP0A
         OwE0rMS+dL1je1DstNhwL5vKPezwQbOkganZTianzTNhIHoDjrPOQSlAfogSoH6wsu2Z
         KYAyvu5GZatiwGvYcNUiOmClhOyihg90mvoVz70tJFCYUiBSouPrwPadCACw+rl/V2mI
         M35Q0ohx5AaMGMRNgOaaDuT1R9+Rf6h/pG3XJUSv5bxhLDjvWHZSsjsGEKg83+5I3mUg
         ewMQ==
X-Gm-Message-State: ANoB5pkZY15b3jMO4/nxfKP59TzS/n8flOfQn/Oj/rQXUDAAQHqH8vbl
        hT+JcHuVQ6RcyXgkXTd6jKvE/Q==
X-Google-Smtp-Source: AA0mqf4C0ZYwK4qMyUW2YR0vkq76wmJKPm94WV0z55/QLyGfvJuFncg2LYImZwYKD80rqFdMIIPTBw==
X-Received: by 2002:a5d:4d49:0:b0:235:470e:a9f3 with SMTP id a9-20020a5d4d49000000b00235470ea9f3mr11679576wru.263.1668547155798;
        Tue, 15 Nov 2022 13:19:15 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n41-20020a05600c502900b003c65c9a36dfsm17201487wmr.48.2022.11.15.13.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 13:19:15 -0800 (PST)
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
Subject: [PATCH v4 2/5] net/tcp: Separate tcp_md5sig_info allocation into tcp_md5sig_info_add()
Date:   Tue, 15 Nov 2022 21:19:02 +0000
Message-Id: <20221115211905.1685426-3-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221115211905.1685426-1-dima@arista.com>
References: <20221115211905.1685426-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to allocate tcp_md5sig_info, that will help later to
do/allocate things when info allocated, once per socket.

Signed-off-by: Dmitry Safonov <dima@arista.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
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

