Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6024F75DF
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 08:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240990AbiDGGYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 02:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241020AbiDGGYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 02:24:00 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479F21F6237;
        Wed,  6 Apr 2022 23:21:56 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so5216167pjk.4;
        Wed, 06 Apr 2022 23:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qIQAXIraFBo7pp9F+UKiJewbp52XCbv0LyD3lJdVZ6Q=;
        b=gEedZBPxVf7D2He4oUQ7Kmh59QVd9sD/7AU5O55/vRm09Px+34OduFUK8lUZ0NkEUg
         Z50Q6EjWk4SD+YUnCJdE3bTvgUrvExZRRn+/mxcLTb3DGA57t8NYTYEj5ptePHAZuhn/
         bNOfsOwFH7BkcbIQbea1+FZVIQi65sqAhHg2/0A6nOCySWli1zJ9Bxgo7z2dSAfEUDLo
         U7xi5Qdz/oXoKqUZVcgHChtOH04RUYhnb8NisDc3Wb7fOSjHZzXKbvWB3+XMcKeRUWRi
         WFb/IScqFFqfsHhCnisQSEDfxNioQ6wAdKiDvpjtm2ExDLLwTVe7CPwD0TZn/R2+Ba9z
         AQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qIQAXIraFBo7pp9F+UKiJewbp52XCbv0LyD3lJdVZ6Q=;
        b=qYV5AuDSF/EOF4Iur1YLcdwfra+MrfY/kP6MFijdBgJMFt7anQlUskNZNt4tzCsIcn
         Ho4xjbkua/HyEDHlW27mPxOei9nQgdb+mqLiVDcZBybX5jXmmvvhExLPuALKacjVVHTJ
         AFrieLlN8nYmY8wl3MZPV5BWUentExaRfhv0MKMCZ8EHyHRh8w1aB2tcuFT52Si30t31
         UpgBVeR7DEoaTDAYSdrGW1Gm6e9po86jxw/GZsxkiyEgRP8SaMUI499FOahwhdp/iPdn
         u2KTDqxN0tSqZJMM+tkpj1YE+NKMV2eF0BZwwaEZF4qdtx+lVdEr0z9eqUyf5AFhm0VN
         f9lg==
X-Gm-Message-State: AOAM531C5LUJNMsRkwytSvd1OwjX+LWQppdIJ4bn59LCiJQKqCo/rg4y
        A162sb3sQSmpcMmzuWj3Uc4=
X-Google-Smtp-Source: ABdhPJxRK9fYIDIA1/razN1poHLxz5XFZ0QtPpUUs7d3rBRM8YFikT09NIFIUC850TYNhWapRJ4E+Q==
X-Received: by 2002:a17:902:c94a:b0:156:ae43:4023 with SMTP id i10-20020a170902c94a00b00156ae434023mr12143321pla.115.1649312516054;
        Wed, 06 Apr 2022 23:21:56 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.118])
        by smtp.gmail.com with ESMTPSA id k92-20020a17090a4ce500b001ca69b5c034sm7522829pjh.46.2022.04.06.23.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 23:21:55 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, xeb@mail.ru,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, benbjiang@tencent.com
Subject: [PATCH RESEND net-next v5 1/4] net: sock: introduce sock_queue_rcv_skb_reason()
Date:   Thu,  7 Apr 2022 14:20:49 +0800
Message-Id: <20220407062052.15907-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407062052.15907-1-imagedong@tencent.com>
References: <20220407062052.15907-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

In order to report the reasons of skb drops in 'sock_queue_rcv_skb()',
introduce the function 'sock_queue_rcv_skb_reason()'.

As the return value of 'sock_queue_rcv_skb()' is used as the error code,
we can't make it as drop reason and have to pass extra output argument.
'sock_queue_rcv_skb()' is used in many places, so we can't change it
directly.

Introduce the new function 'sock_queue_rcv_skb_reason()' and make
'sock_queue_rcv_skb()' an inline call to it.

Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/net/sock.h |  9 ++++++++-
 net/core/sock.c    | 30 ++++++++++++++++++++++++------
 2 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index c4b91fc19b9c..1a988e605f09 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2392,7 +2392,14 @@ int __sk_queue_drop_skb(struct sock *sk, struct sk_buff_head *sk_queue,
 			void (*destructor)(struct sock *sk,
 					   struct sk_buff *skb));
 int __sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
-int sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
+
+int sock_queue_rcv_skb_reason(struct sock *sk, struct sk_buff *skb,
+			      enum skb_drop_reason *reason);
+
+static inline int sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
+{
+	return sock_queue_rcv_skb_reason(sk, skb, NULL);
+}
 
 int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb);
 struct sk_buff *sock_dequeue_err_skb(struct sock *sk);
diff --git a/net/core/sock.c b/net/core/sock.c
index 1180a0cb0110..2cae991f817e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -503,17 +503,35 @@ int __sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(__sock_queue_rcv_skb);
 
-int sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
+int sock_queue_rcv_skb_reason(struct sock *sk, struct sk_buff *skb,
+			      enum skb_drop_reason *reason)
 {
+	enum skb_drop_reason drop_reason;
 	int err;
 
 	err = sk_filter(sk, skb);
-	if (err)
-		return err;
-
-	return __sock_queue_rcv_skb(sk, skb);
+	if (err) {
+		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
+		goto out;
+	}
+	err = __sock_queue_rcv_skb(sk, skb);
+	switch (err) {
+	case -ENOMEM:
+		drop_reason = SKB_DROP_REASON_SOCKET_RCVBUFF;
+		break;
+	case -ENOBUFS:
+		drop_reason = SKB_DROP_REASON_PROTO_MEM;
+		break;
+	default:
+		drop_reason = SKB_NOT_DROPPED_YET;
+		break;
+	}
+out:
+	if (reason)
+		*reason = drop_reason;
+	return err;
 }
-EXPORT_SYMBOL(sock_queue_rcv_skb);
+EXPORT_SYMBOL(sock_queue_rcv_skb_reason);
 
 int __sk_receive_skb(struct sock *sk, struct sk_buff *skb,
 		     const int nested, unsigned int trim_cap, bool refcounted)
-- 
2.35.1

