Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FFD451D8C
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348429AbhKPAbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345793AbhKOT3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:21 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A00C0BC9AE
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:13 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 200so15411474pga.1
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y8eHQYgHoIXIRLHiUQPADGg65tG82iTRKS/mqPl2NDw=;
        b=DI5sGUbbNb7Vo836n0dxW2T3Q7G3YNZpbLtoG0Y7Tg33KxhhdCq1Bj8IIXKrYuFJNJ
         wZ0TcydFGopW4HXChJT9pwqWPzx6bQq4u2zPgHlFxvVJNx/2BJ1F1de2ipHe5sW2GHHi
         njmCRvzCF1dssZEDx5p96U2ysK0VSFpeiM4ZV1cFZlT56F0NDz6x6aHvZqtSd38PznRm
         0lhMVrN49c0fhT3+2UeTd5pYV8x5gvhK2rpcAsXeabWCR5ZFfM4usIG8uVNtS+OVJrj4
         9WrBwr5yjyibFrWnATPPxF0cAfs40m7UZuxhHPvxJ+/J4jcJF6XaAEoEo/9jJt5myLcj
         D9QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y8eHQYgHoIXIRLHiUQPADGg65tG82iTRKS/mqPl2NDw=;
        b=y2LaLbiL57spNeKBNibmybeMwAPYKfcrgcJRzl5ZtTzy+vXsd4/rXVxxhccJh833KW
         bTQH9tid/55BFUa9Fw5ojJuCHbys0pTKsfDl9isCTC6PDmq34bcvyO2+BGWY1MzYj/XD
         nLUuNmDIuvdFDy/89bFBi8pQnzwr74q+3o5CpFUP3JfxRSfiRznCLLWj+7A7z9z8uqiV
         vUNgiPoRRM8Oofz3hVbq0SIIkR9/GmnwFNKifJ5Zo3KLYEn1zf8uZaAmAA9J2S7ZHCmL
         zDgGR4COpPgvdXtAcUKplBbHZdZHQXEsrIfD13vGzkwq86gy40T4kEfhKPqAEB6fOiLL
         bK1g==
X-Gm-Message-State: AOAM531idUAShpWqJQTtLGkVpd8ZztIP+dNjdL9E9EC2Vucegu/tAHC5
        WxSOm3W5QAytIgY9fllyCzg=
X-Google-Smtp-Source: ABdhPJyMUkImlILcmvr3q/PiVh7pHMzAWxF1iHxMjo4EjxTEv6WMo4gvm8BB7UMjPWjO2jCjhygVLw==
X-Received: by 2002:aa7:8019:0:b0:44d:d761:6f79 with SMTP id j25-20020aa78019000000b0044dd7616f79mr35452759pfi.3.1637002992605;
        Mon, 15 Nov 2021 11:03:12 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:12 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 09/20] net: forward_alloc_get depends on CONFIG_MPTCP
Date:   Mon, 15 Nov 2021 11:02:38 -0800
Message-Id: <20211115190249.3936899-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

(struct proto)->sk_forward_alloc is currently only used by MPTCP.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 2333ab08178903533cbc2dc1415a0de9545aa6db..cb97c448472aa5af3055916df844cbe422578190 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1206,7 +1206,9 @@ struct proto {
 	unsigned int		inuse_idx;
 #endif
 
+#if IS_ENABLED(CONFIG_MPTCP)
 	int			(*forward_alloc_get)(const struct sock *sk);
+#endif
 
 	bool			(*stream_memory_free)(const struct sock *sk, int wake);
 	bool			(*sock_is_readable)(struct sock *sk);
@@ -1295,10 +1297,11 @@ INDIRECT_CALLABLE_DECLARE(bool tcp_stream_memory_free(const struct sock *sk, int
 
 static inline int sk_forward_alloc_get(const struct sock *sk)
 {
-	if (!sk->sk_prot->forward_alloc_get)
-		return sk->sk_forward_alloc;
-
-	return sk->sk_prot->forward_alloc_get(sk);
+#if IS_ENABLED(CONFIG_MPTCP)
+	if (sk->sk_prot->forward_alloc_get)
+		return sk->sk_prot->forward_alloc_get(sk);
+#endif
+	return sk->sk_forward_alloc;
 }
 
 static inline bool __sk_stream_memory_free(const struct sock *sk, int wake)
-- 
2.34.0.rc1.387.gb447b232ab-goog

