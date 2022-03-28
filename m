Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8438F4E8D51
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 06:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237910AbiC1E3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 00:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238018AbiC1E3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 00:29:49 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02DE266A;
        Sun, 27 Mar 2022 21:28:09 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o13so11282668pgc.12;
        Sun, 27 Mar 2022 21:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qIQAXIraFBo7pp9F+UKiJewbp52XCbv0LyD3lJdVZ6Q=;
        b=BCp0xQ0zlTJZQznGp5nEETwTxEdB9zngsw3YA75Z3u1/sLn5lpygNiH56OUmgfYFIm
         3qd9WXfEQxSEQo1jaHVaK1Mzs96a6R2C1c23yxbpTPkrwaSB5YKU/WLmoBTgrw8Ca2Ye
         omxS7HXULlEGd7T4hZ2Q2V2BkIxEewxsFoIt80fDOhAMBbOZD87yRiiribYnB6+lC6LA
         sFKV9edcWKfR8UCK8w8GLtXjnZNo5oCvEeq7QW8uc2As4JJ1HcbR04mB4u6mJePEu27F
         oAi6ZGmfTOH+z7coIRRDLrPp9vHcQS162ivuIILQT9U2H3+24w4qurcEXg8nGF+3tgl3
         JptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qIQAXIraFBo7pp9F+UKiJewbp52XCbv0LyD3lJdVZ6Q=;
        b=ojvqoCou5ld1cwBXd18NtHYyrBS8CHfhDJvRAqs8jJM/2YrnFJh4Y/y3ccjY9X9Ym/
         G0S7kD2jH+pHcPy8BfXBEV3h29MU2TG6U81aSxQx4Igb5RVb9/Du8fG7xPSrw+iv0wDA
         Uusp/1SrmBpRpdS6zkZZNBlk7/+YC1g5nf+YUWIkCoxykB3rvn/eGSQJqDFs5RwcTfu5
         +E1ne6nHZOqZAudZ87qDRyehxGtKDZdrU27sUZ3ny69JQObd6UPumv0jTLPng8uXJ1PY
         U5HuSYFRAHh9cjzRkzAExfthQLPaI6Hmk8dfYaETDPTjbIgZdgieekfF5Ianq69gMrao
         7kJQ==
X-Gm-Message-State: AOAM531uf0cwxYxztIFIGHYOlIjyY0ouLjzpD/bvytYPUWD9D7kl2aBn
        xWIsqhlyjT/fUHUwbTO//DY=
X-Google-Smtp-Source: ABdhPJxF3+nte71DCrVFZJgKnLbhh0u5xorUEOl43uns+o6ckCGx2EWx4Rl5FLNhUWrION1zu5fq2Q==
X-Received: by 2002:a63:5502:0:b0:382:a7c2:66d3 with SMTP id j2-20020a635502000000b00382a7c266d3mr9076063pgb.560.1648441689201;
        Sun, 27 Mar 2022 21:28:09 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id o27-20020a63731b000000b0038232af858esm11317715pgc.65.2022.03.27.21.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 21:28:08 -0700 (PDT)
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
Subject: [PATCH net-next v5 1/4] net: sock: introduce sock_queue_rcv_skb_reason()
Date:   Mon, 28 Mar 2022 12:27:34 +0800
Message-Id: <20220328042737.118812-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220328042737.118812-1-imagedong@tencent.com>
References: <20220328042737.118812-1-imagedong@tencent.com>
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

