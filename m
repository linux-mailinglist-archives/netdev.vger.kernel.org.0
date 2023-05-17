Return-Path: <netdev+bounces-3199-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0542705F44
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:26:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9D761C20EDB
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:26:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93CBA101CA;
	Wed, 17 May 2023 05:23:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D1BD507;
	Wed, 17 May 2023 05:23:13 +0000 (UTC)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9073140D1;
	Tue, 16 May 2023 22:23:02 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1aaf21bb427so3217295ad.1;
        Tue, 16 May 2023 22:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684300982; x=1686892982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XBzXJoALt8kblYyN0yx9KfML90NNLIp7TFuBtKGUqOs=;
        b=c4DfGyflj8xcRYneF2P0WWJNvqCNBEJNLYkwowwYGuePaG1XsJ41Pn4rSG2DxPqng2
         bByT93RKbclp+mv34aZb0UWeZ996q9PldkzX4zMWkXkt8fCj4kwwFxvuF9oPGgK8UAZk
         A/LDfZuQxkn6pIZO0NKg90t0IkJUuUq0XiVWvRvgZGeFUZa8+7mPI+sB1LDoEpwx36nj
         yWHSEMy2s1xcigbAMiMbOV86iAsNkfvT6Etec1IuCUJZ/HqUiSodKLVeC+9UJB4TyLhp
         DeuiJWV2qMHd8Su7E2YUUcAcaG6d3XpQ3zWWEBA8lsBprOCt2SHaxiiyQRxxXvsa9WZW
         TLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684300982; x=1686892982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XBzXJoALt8kblYyN0yx9KfML90NNLIp7TFuBtKGUqOs=;
        b=dhCddVtZ2m2qj2jKnYJnrUW+1SwqM4WyGsgh67EPlm0oEta5BxqM4Uv3SHyQKUnQCB
         mY7oE4fOvFga8szo7Amdb82bOHeGhmBadchLSfvVK2nnj0gCcp8cyY7UxzNEbI2QNkne
         wyjSWzekSCoRVcdcCYqv7s4qFgrhxf+4BMi1eOWLHR96jtyLk6KCcL58nrM+Y8GBP4UJ
         Nred4rdYdOZc0Gz+uSig4YSzkRcukG834I3CHuaZWgX1QssYcoCeE1IKeszjd7GT6j2o
         6EWdBZifpYGJyGc59YBxgEXkUrX7+zqIDN2cyEMBwU9Q8eoefFSFjizJqS3PAxjl6lLB
         ukfQ==
X-Gm-Message-State: AC+VfDzgHFICvry7/jYC/2q3EyTYKbLcleCR/KJHKKc0I1HnWZ+S/rKR
	8EUqJvLZ1prKgAH1yh/qu50=
X-Google-Smtp-Source: ACHHUZ6IgPjR9hDMv1SoL1pdF286slyqLXACcB2C52NaWubWD9iDS/yhdmFFn3dBp+Wbj+iy5OiE+A==
X-Received: by 2002:a17:902:6545:b0:1a9:b91f:63fc with SMTP id d5-20020a170902654500b001a9b91f63fcmr36447354pln.12.1684300982003;
        Tue, 16 May 2023 22:23:02 -0700 (PDT)
Received: from john.lan ([98.97.37.198])
        by smtp.gmail.com with ESMTPSA id n11-20020a17090a2fcb00b0023cfdbb6496sm581779pjm.1.2023.05.16.22.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 22:23:01 -0700 (PDT)
From: John Fastabend <john.fastabend@gmail.com>
To: jakub@cloudflare.com,
	daniel@iogearbox.net
Cc: john.fastabend@gmail.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	edumazet@google.com,
	ast@kernel.org,
	andrii@kernel.org,
	will@isovalent.com
Subject: [PATCH bpf v8 07/13] bpf: sockmap, wake up polling after data copy
Date: Tue, 16 May 2023 22:22:38 -0700
Message-Id: <20230517052244.294755-8-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230517052244.294755-1-john.fastabend@gmail.com>
References: <20230517052244.294755-1-john.fastabend@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When TCP stack has data ready to read sk_data_ready() is called. Sockmap
overwrites this with its own handler to call into BPF verdict program.
But, the original TCP socket had sock_def_readable that would additionally
wake up any user space waiters with sk_wake_async().

Sockmap saved the callback when the socket was created so call the saved
data ready callback and then we can wake up any epoll() logic waiting
on the read.

Note we call on 'copied >= 0' to account for returning 0 when a FIN is
received because we need to wake up user for this as well so they
can do the recvmsg() -> 0 and detect the shutdown.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index bcd45a99a3db..08be5f409fb8 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1199,12 +1199,21 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 static void sk_psock_verdict_data_ready(struct sock *sk)
 {
 	struct socket *sock = sk->sk_socket;
+	int copied;
 
 	trace_sk_data_ready(sk);
 
 	if (unlikely(!sock || !sock->ops || !sock->ops->read_skb))
 		return;
-	sock->ops->read_skb(sk, sk_psock_verdict_recv);
+	copied = sock->ops->read_skb(sk, sk_psock_verdict_recv);
+	if (copied >= 0) {
+		struct sk_psock *psock;
+
+		rcu_read_lock();
+		psock = sk_psock(sk);
+		psock->saved_data_ready(sk);
+		rcu_read_unlock();
+	}
 }
 
 void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock)
-- 
2.33.0


