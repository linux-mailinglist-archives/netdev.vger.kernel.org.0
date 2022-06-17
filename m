Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A6D54F4D9
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381551AbiFQKGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381548AbiFQKGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:06:12 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73EC69CDA;
        Fri, 17 Jun 2022 03:06:08 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d129so3658191pgc.9;
        Fri, 17 Jun 2022 03:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GmjrKEQYPgZPTRJ4jJxsOeeTsxk0UvR5BruchnIbbJc=;
        b=Enz4V2596oes7IbJYm70KLIeo5JzCNIU54ba9Nm1Z4dJzp+wClwJBdffn+wj9gRuCm
         nC2tpQEcignXLDOXxgR3t+ohF7jTjzy4KQROJ3V3owzYe8SE4i46+w9SGubMow5mqDJ3
         ntLrJY+Bz6FzRGt8RTMJJvJ0YOZ2aKhYXkGscIjYQ+kRfEB0wjEqAvDrxfyuO6e2yBVb
         zvHcYBxsvkpVnQXJqVzI1fseh4CR0JlvzzNLcxYbbRHcGYPwSebvbZ30DPxnK3516iQG
         mB1JXJhXDDB+i7lnqTGh5gUUIjpHCiSdZKWrB0ziMmhwu1zqZ6FGzVQpGG/ch9FNO11A
         NM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GmjrKEQYPgZPTRJ4jJxsOeeTsxk0UvR5BruchnIbbJc=;
        b=NEBhVY//0xLLTm1O6MLq+ljveSn0bx0X7goNGmZOVKZve+G1LnoeDk7RiOuR2TerW1
         sMlTbPn8ARETrjm63+uEYY9/BhN3E4Ka258ZM4OQwLos4w9w3swDEyObTu9RyjRwh+Hn
         65W1EsZBqZXcb9V4CWAuhjNqeWfSvnApqexnjfgaYWnTa8YmXc4Yq6kXymfZMUepWtiq
         SUH0sbbAj32xKt4BN1sWyRiZhZCzmPycFzv38eFlazwkxShtoMKk/MQnrqZL5WisnYks
         kaN9xt4zk6Es4uz+LTNzwNDq927bgLvjaMqku679Gj4OPwkFnzs/ZrfoZvSnhYZlXP9B
         GbNw==
X-Gm-Message-State: AJIora8Wdll8pzGHQbtqrvBiTNnNcTQRvIXRRnq5sx7dn7T0m+LMe+ZE
        6D7XlHTTs2XEMBngfpNJP/A=
X-Google-Smtp-Source: AGRyM1slAtqEO/HbfBYWwj2l3NgjEhIZniAjvVXkYVrnISCJ1/u+NqE5wWeluDl1GyZxAxNz9hVI1A==
X-Received: by 2002:a05:6a00:9a1:b0:51b:c452:34a9 with SMTP id u33-20020a056a0009a100b0051bc45234a9mr9332454pfg.34.1655460368357;
        Fri, 17 Jun 2022 03:06:08 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.10])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902f7ca00b001621ce92196sm3126210plw.86.2022.06.17.03.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:06:07 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: [PATCH net-next v4 3/8] net: sock: introduce sk_stream_kill_queues_reason()
Date:   Fri, 17 Jun 2022 18:05:09 +0800
Message-Id: <20220617100514.7230-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220617100514.7230-1-imagedong@tencent.com>
References: <20220617100514.7230-1-imagedong@tencent.com>
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

Introduce the function sk_stream_kill_queues_reason() and make the
origin sk_stream_kill_queues() an inline call to it.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/net/sock.h | 8 +++++++-
 net/core/stream.c  | 7 ++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 657873e2d90f..208c87807f23 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1139,12 +1139,18 @@ int sk_stream_wait_connect(struct sock *sk, long *timeo_p);
 int sk_stream_wait_memory(struct sock *sk, long *timeo_p);
 void sk_stream_wait_close(struct sock *sk, long timeo_p);
 int sk_stream_error(struct sock *sk, int flags, int err);
-void sk_stream_kill_queues(struct sock *sk);
+void sk_stream_kill_queues_reason(struct sock *sk,
+				  enum skb_drop_reason reason);
 void sk_set_memalloc(struct sock *sk);
 void sk_clear_memalloc(struct sock *sk);
 
 void __sk_flush_backlog(struct sock *sk);
 
+static inline void sk_stream_kill_queues(struct sock *sk)
+{
+	sk_stream_kill_queues_reason(sk, SKB_DROP_REASON_NOT_SPECIFIED);
+}
+
 static inline bool sk_flush_backlog(struct sock *sk)
 {
 	if (unlikely(READ_ONCE(sk->sk_backlog.tail))) {
diff --git a/net/core/stream.c b/net/core/stream.c
index 06b36c730ce8..a562b23a1a6e 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -190,10 +190,11 @@ int sk_stream_error(struct sock *sk, int flags, int err)
 }
 EXPORT_SYMBOL(sk_stream_error);
 
-void sk_stream_kill_queues(struct sock *sk)
+void sk_stream_kill_queues_reason(struct sock *sk,
+				  enum skb_drop_reason reason)
 {
 	/* First the read buffer. */
-	__skb_queue_purge(&sk->sk_receive_queue);
+	__skb_queue_purge_reason(&sk->sk_receive_queue, reason);
 
 	/* Next, the write queue. */
 	WARN_ON(!skb_queue_empty(&sk->sk_write_queue));
@@ -209,4 +210,4 @@ void sk_stream_kill_queues(struct sock *sk)
 	 * have gone away, only the net layer knows can touch it.
 	 */
 }
-EXPORT_SYMBOL(sk_stream_kill_queues);
+EXPORT_SYMBOL(sk_stream_kill_queues_reason);
-- 
2.36.1

