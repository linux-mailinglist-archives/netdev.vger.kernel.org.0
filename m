Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F115E8310
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiIWUNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbiIWUNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:13:35 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB3F122045
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:32 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id bq9so1580424wrb.4
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=MYKT0h8wna+In3CWoRnFDJEPwOLiWuSC2WUQ9onj+sI=;
        b=ZlgHXEBAPA4ziKJaATNYmpXIbuoHlcsla0sq6NHYvrV9iqro7BTyZNp10CKckYmPDg
         ojHeW1wrwfvoQ6eA4ZNOtD2QdCR/0hR847V9tGvIvKXmu7zyPB5BWZk7jugRG18qkum0
         ZMuTM7556QiHJubeztrxXHK7QMEwF/fhOKL42ceFLXnayXpaep+XnLe758u15Ib17ejz
         IbIuLEAEsL5JVMXVpJMAaXDmp268l1QukDk0N01y2nVzfiIEH2wd8+BHLADbWiIGcS8v
         gbMOeHMAhfcmLQmLO6MdvG2U21fMVoKClXDXIQ/AFogj6HF8qNhBuprAeh+LnLEWqqB7
         n64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=MYKT0h8wna+In3CWoRnFDJEPwOLiWuSC2WUQ9onj+sI=;
        b=FdUP/XJu3G6IUHOfZZxoZkty5j3ZosDhR9fpfr0e9FbhiyN4Jk4ewfKwFmLO/on+Pd
         XbjXLC06cTpvcntBZRGfyKC54xH8/ujVDNLmK7PD/8olG7R21o9qHTeDQjWpYKoNl/6z
         SSMp9mqNT2u0t5saek81yy6p+EuQLk4LJN0SqN2eu528nTp2/1sLcGKkhr9NJqEsC3Ue
         JJAAMjnsvJVPCghQEm+tPfX0o4dZU/nTf2pOo85N3LO7hmmr5/k+tYaXKU5BWLzYm6L8
         xk05EYtFEZPPRBTCiKv02f6nekItkC11FeLvdij26IMur8qFDfUUxgAlRd9y6NFCkcbq
         k53Q==
X-Gm-Message-State: ACrzQf2aPj6ey0TAKFmFtXFRJtR67go+PUwwxFV/wVx0gnV7gcag6nQ5
        KNeUi4ZQ+M7u90sWvbosVylm/g==
X-Google-Smtp-Source: AMsMyM7XQLXK/eoxLxTCmkBDr6Ni3+fRsc4Xsrm6A2YjmzZ50PAC+bO1il178um6tDS5+gvuwRdf9g==
X-Received: by 2002:a5d:69ca:0:b0:228:dd17:9534 with SMTP id s10-20020a5d69ca000000b00228dd179534mr6600701wrw.652.1663964011367;
        Fri, 23 Sep 2022 13:13:31 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:13:30 -0700 (PDT)
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
Subject: [PATCH v2 03/35] net/tcp: Separate tcp_md5sig_info allocation into tcp_md5sig_info_add()
Date:   Fri, 23 Sep 2022 21:12:47 +0100
Message-Id: <20220923201319.493208-4-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
References: <20220923201319.493208-1-dima@arista.com>
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
---
 net/ipv4/tcp_ipv4.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5b019ba2b9d2..cbcf5367afb3 100644
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

