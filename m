Return-Path: <netdev+bounces-3806-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1652D708EA1
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 06:10:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 024031C20C58
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 04:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05B9A3D3A8;
	Fri, 19 May 2023 04:07:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED19663E;
	Fri, 19 May 2023 04:07:16 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC5410DF;
	Thu, 18 May 2023 21:07:14 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64d2e8a842cso373861b3a.3;
        Thu, 18 May 2023 21:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684469234; x=1687061234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XBzXJoALt8kblYyN0yx9KfML90NNLIp7TFuBtKGUqOs=;
        b=pCkLWdLdLf43X8acqSlsVDpZz2RLcsFRbMF+ARDRkjFtXiPzFs0jfDpgMl+YwRVKKG
         w4zCdeev1UtxUEqKNPQAEPRWOG+rgBVouPdgq1mtFqXgKRDvO32h4TsAxGAqmigyguxw
         keATIiys4vGJ3Dg/FTSJQ2cYzY+20aszCLd/ua1mloSysgf0d1s8kMszTpu3o7J1wILO
         cRzYhITYX5zDHR+zq2Ccj3Lwa2bIV23W93NN9HwFenBiWivUQm0UH3hEeYlmBNgC/MGc
         a0I7skUqPAR4XHXqWRZJ7E8AqgtHIkQ11193HrGvgvRPCJgSqRgKnXoFvyWnJfyr1AN+
         ZufQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684469234; x=1687061234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XBzXJoALt8kblYyN0yx9KfML90NNLIp7TFuBtKGUqOs=;
        b=MubpphvavlTfKZHrG9mMdESQL4B4tHIox4CWliGmgXNjZD9/5pPHKVX0R+5O3QdMMx
         3g5Ln4UW0yL+jNuQNyLgHD6/Y3GotNdH3JLFn8uCJ1dkIuo0YQ44c3nrl0oPDH7vy3K0
         FJ05YpBTZ8CdwC8lVz3CgvZLvlcYxCWfxk0lyb3Id9A7yS3DfSR0uIy2nGwXuEpdCpWT
         vgzSrfA4guu6FhU4sUjOIWqsRVNebuVtr14Fvnjt+lDKnDK/SgCUYmwbEdlm0h+enAgK
         +YORcTQ00UTCE2Pga0DXk/Ww4IylDQ/OJ7BBSj+R1S7HdNdNzap/5yvzyTgpslCCi0pM
         S+WA==
X-Gm-Message-State: AC+VfDz/wCp6f09yrGeCK4NgcoFTnbzGNepfiU2OtMe67Eot3HFU89+B
	8V4nZZf0ZOR2Iu9+tgB1CX0=
X-Google-Smtp-Source: ACHHUZ7sPty9TFUj87sxflk5CxnHO18e2GTA95ySkkbN7PVTn/uq0qwl2julFX5eE8MsgmV+kVweTQ==
X-Received: by 2002:a05:6a00:1703:b0:63f:1eb3:824b with SMTP id h3-20020a056a00170300b0063f1eb3824bmr1800762pfc.17.1684469233748;
        Thu, 18 May 2023 21:07:13 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:706:628a:e6ce:c8a9])
        by smtp.gmail.com with ESMTPSA id x11-20020aa784cb000000b00625d84a0194sm434833pfn.107.2023.05.18.21.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 21:07:13 -0700 (PDT)
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
Subject: [PATCH bpf v9 07/14] bpf: sockmap, wake up polling after data copy
Date: Thu, 18 May 2023 21:06:52 -0700
Message-Id: <20230519040659.670644-8-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230519040659.670644-1-john.fastabend@gmail.com>
References: <20230519040659.670644-1-john.fastabend@gmail.com>
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


