Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E992662637F
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 22:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbiKKVXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 16:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234246AbiKKVXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 16:23:33 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E085E0C9
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 13:23:32 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id k8so7986552wrh.1
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 13:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CbvR8VuafE8eZOle2gcxzJnLTEWWuPtnJ8HojgPG8FI=;
        b=f3iG1K2eNxwKyTPazHAOoXdjfhkFgLqsHQrlV3DO0qQzhPY2nNSYzOltjYBsMJqnwf
         N0PMbUSz284yXm4U3DwFlcT8UmZaYrN9GbKfycF1ANn1MHkigxIQNyvid4+g8yhWsWSw
         cvYgVzl7Dl23sZ6+RzSwn4vDmKWDOE9tQw0Fjq6YcwX8Tmm8LnMYbKsVC00lIfKUQFJn
         WM1qs7H8Or0Oiardk5Y6KQeesrnwngCuqE8mv2YOQG5X2Df23Q/OgVGJQqB89GVmx572
         zIMGqOr7cI1LbD73t6uC0zLOsoCO4bn2G2BqJXPlhox0WC2ym1Or4BCpc/QuqposuCnm
         4vxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CbvR8VuafE8eZOle2gcxzJnLTEWWuPtnJ8HojgPG8FI=;
        b=kw5m/EDO7tk6LkltRmBudXC1s0DOSIK08GyaEzvfx8XScaSt7P7nBWNOo5wtUBxh0B
         meyADtRdfPicvnq6rkExSlsZ8EWhSINA2WisMWnFbCH7ExIZZpFn85OyvkQOapKgmn7L
         6anQp247alMm77DCUOsm2+9KInO/aYmJN+oHxzX3WeYZV5u2O80i1/P86UX7cfV3nTST
         wkIaduN3sKdsjwPnkvu+tm14Vyz8w9ccOp/n3XbWOAUuOC+L+zBtEJrtnSz2ILEvEGxx
         kO7nAN2pSDoNZgQi0kovsF+0qQai4v9DmL/pku0D4DZjdysG/fE5EI8bW46UJRg1J5+A
         cqsA==
X-Gm-Message-State: ANoB5pm3W/67AtFQ0q8D65b8b3p+PVL3jGnq4aAg2j7dLin93QOILZxH
        SLfx4RPgiBlBJoX2YSlW/iatQQ==
X-Google-Smtp-Source: AA0mqf4Um6FP2tvkVQX8p5z0+5awYzTA+3i5kGqNSR6er7zA7Rj1YrkkvI4pNCIwc7918zmf839yvg==
X-Received: by 2002:adf:f4c9:0:b0:236:562b:f67a with SMTP id h9-20020adff4c9000000b00236562bf67amr2216064wrp.562.1668201810780;
        Fri, 11 Nov 2022 13:23:30 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n18-20020a7bcbd2000000b003cf9bf5208esm9423281wmi.19.2022.11.11.13.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 13:23:30 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Subject: [PATCH v3 2/3] net/tcp: Separate tcp_md5sig_info allocation into tcp_md5sig_info_add()
Date:   Fri, 11 Nov 2022 21:23:19 +0000
Message-Id: <20221111212320.1386566-3-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221111212320.1386566-1-dima@arista.com>
References: <20221111212320.1386566-1-dima@arista.com>
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

