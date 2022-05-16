Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8E1527C7B
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 05:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239774AbiEPDqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 23:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239757AbiEPDp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 23:45:58 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C812B35AA6;
        Sun, 15 May 2022 20:45:51 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ev18so2621080pjb.4;
        Sun, 15 May 2022 20:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L8DV2QTltNNfOYY2o7h+L8W3d2Gl7hrJLKqnA2rfXww=;
        b=nJMXcmO2zEiTMB1byTj841TWMLulQu414VVfH/81gAXxyJMoR9UT6hVKkL5C1XfbqH
         aREMqV9iByp5aAgLqbcC7WIw4MR+k0yGvmH+Q4N5BgRTgG0LVkv5tzzOnnyxY0mLN6X6
         ki7h7/Ggb+LtJtPMZuRKdDIa8GD4EojKcuGgnqXCpshfYJSUs89MU5R1o3sBHhh2fTRI
         zFxD4OcFFmvsic/bKBPVydR3Mxu+3Jk/nTciwVSm3sQptvnBLPWLstpzPx3nwL+sL2Z/
         iB1ti2YxlpIdiP60tzaR4s7L7Xw/E/NiZFShjZA96/HtLhm31eGRpiSlhFFLmnKHcTW3
         t2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L8DV2QTltNNfOYY2o7h+L8W3d2Gl7hrJLKqnA2rfXww=;
        b=pRNmt56YnGg/xq4rXMG6PMomVUdeAGSTWO7L0G3iHySqK+UG8Bi8EXmpKOmIGq+BBw
         uDXfSctp+jPMsOXKIWHJRtk6AwA5vRkmVVxUPAXj3NPo4s9A5AXKEib3Fv2icozwxHKW
         5KP/MUviQqOgnwq/hRdZvJj1TZQpMc7dXuCwRfiYDZ7WsPeztPcZFVsD7FfVd93PDNXX
         mfKCmzLY9jaozd/MBMKqiQzhy86psQgTSEI0ZDEQ7N11XZ4E0wzGJr0hi/1UNWWoT0WU
         71pcGXOrO8tig/HdrmKD8YAQHazkKqrPJAn3js5W1d2U5CMGKnnH3PL6jVy/1O2PuCwA
         UG/A==
X-Gm-Message-State: AOAM533ASoCo4cHYBtFwK4Xermm5Ee0Y8CMn2uGVCr3A8pWhxEgA24Jy
        1M0kmh3nfNmGoL4eSp1bI8E=
X-Google-Smtp-Source: ABdhPJzQdCHcTBdYFTuCGuQBHTUINfvnLDK5X19ltQd4qrSW4TGYocAEnZRUftBHZwYoSNAl2E+gjA==
X-Received: by 2002:a17:90b:4a01:b0:1dc:b062:da0e with SMTP id kk1-20020a17090b4a0100b001dcb062da0emr17296879pjb.87.1652672751322;
        Sun, 15 May 2022 20:45:51 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.24])
        by smtp.gmail.com with ESMTPSA id x184-20020a6286c1000000b0050dc762819bsm5636854pfd.117.2022.05.15.20.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 20:45:50 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 3/9] net: sock: introduce sk_stream_kill_queues_reason()
Date:   Mon, 16 May 2022 11:45:13 +0800
Message-Id: <20220516034519.184876-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516034519.184876-1-imagedong@tencent.com>
References: <20220516034519.184876-1-imagedong@tencent.com>
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

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/net/sock.h | 8 +++++++-
 net/core/stream.c  | 7 ++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 73063c88a249..085838ce70d5 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1128,12 +1128,18 @@ int sk_stream_wait_connect(struct sock *sk, long *timeo_p);
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

