Return-Path: <netdev+bounces-4495-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C0C570D1EF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:59:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1CFA81C20C1A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9721BE56;
	Tue, 23 May 2023 02:56:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B668BE51;
	Tue, 23 May 2023 02:56:34 +0000 (UTC)
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E5CCA;
	Mon, 22 May 2023 19:56:33 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-52867360efcso4810329a12.2;
        Mon, 22 May 2023 19:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684810593; x=1687402593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XBzXJoALt8kblYyN0yx9KfML90NNLIp7TFuBtKGUqOs=;
        b=Ls+m6uOOIDU+FT3L2QdEQtpoE5XiZ2P4uTg2bVncevjxAu6c5Rdzxi2EEJhWuWiwy+
         4FthRw4PoJKtM2nAAqibBUJEmx5/qghQuyD48WRYzcb/UxFVVTFv6ZKoXjrlkScWk3rH
         ZgFvv9GnwZgU5i/XTfq3LRxWKQI2OSY/5YKJURYwn6Zyqg+R/0Qy/Vs8M3ueziLUj1iM
         v2u4dAng8dbedsiK4Nk7p1IFgT6+yyie/Rao44AH7GhPJqLiQKWzPvHUPP/AopXqR5im
         l8Qu3LtPFQ3wTO1ucK13JILrVsGq0ZJnQkkK++8pUERtBtNCj8+B0TLd0DjP9ZzVLKgF
         JPYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684810593; x=1687402593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XBzXJoALt8kblYyN0yx9KfML90NNLIp7TFuBtKGUqOs=;
        b=e/FugwQjJ5dhOB5LlBzzHzYefP+8f2hFu8H7hpZcZ09l5zF1EXDqmX8K/EuR82eSA1
         5aMLLR7q28mny+uv1TxeVkcXR31YdPb0jr/pZRigs7XvgYqe8ad7Lj51Z3pQKsfLpZhF
         UYrDOTvlVLjrHpb0E4XrI4J7IMR3xwHN0UqorMACXqwvyi3HtRF6kYCsfxg6V6/iGMD1
         tXH7qJzXZAhIlqC9xhSwKpAE0DenRFJcoTn2oQ8JNa/uxNXCqfcCsMVyW1FbWvIC0lP6
         VPXF3cb9msm4nX7gjABkkvUQ7av0SOC/ZEKjHRsKi/x2t25jMGRV2QJ5O5YgEjMTNUFq
         Eb9A==
X-Gm-Message-State: AC+VfDy8yQECouS5hHDcVtDbvQRmzpFu+2rBQC+tK1GysBQJYpPPAr6C
	olnPMTKNwRcsPAa8vc0mm08=
X-Google-Smtp-Source: ACHHUZ7UqV7K7I/N0ZTuv0Jf7e64lHNCAyDM41sIuiYDhKqFsGDM2+VL4Wmu1gKJJYGDQhkpgMKY1Q==
X-Received: by 2002:a17:902:e752:b0:1af:cd00:d4e4 with SMTP id p18-20020a170902e75200b001afcd00d4e4mr904144plf.47.1684810592809;
        Mon, 22 May 2023 19:56:32 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:82a6:5b19:9c99:3aad])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902748a00b001a67759f9f8sm5508285pll.106.2023.05.22.19.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 19:56:32 -0700 (PDT)
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
Subject: [PATCH bpf v10 07/14] bpf: sockmap, wake up polling after data copy
Date: Mon, 22 May 2023 19:56:11 -0700
Message-Id: <20230523025618.113937-8-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230523025618.113937-1-john.fastabend@gmail.com>
References: <20230523025618.113937-1-john.fastabend@gmail.com>
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


