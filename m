Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AF7529BE2
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238956AbiEQIMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242560AbiEQIMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:12:02 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88A93CA63;
        Tue, 17 May 2022 01:12:00 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l11so16284541pgt.13;
        Tue, 17 May 2022 01:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g1ch9JUquSiEZY3rT3hSUX6ygAPZRU7aK66mWZEBfMc=;
        b=l677yDNNh9wM4HRRDrc8fmNazcJaTtnExXMIiStTblbYqswMP/1Yb4icbI8+x6S15N
         8i5htd0voQ8OGBSg6AMUd22fcJPWmLrl2z4/pMWE6eadWgvUVoto7ispzDPdwEEmwp9L
         YwrscQlwAPckHiJJD/iV1Ri17RUSmarPkYhWzUceEZlvJ//h/uzoEPIBCSo73v3b0I8F
         hmX1mtUkLnMK9Pzf+9jq6wrBb06BqBJfYiW9GVbc8lBZVC2AHkrH3PXMKSQ3Y4erDCiJ
         Trt5W6P5AT84DMeSRdS0BWFM20ol1VnXOOMNacOTjBaO8bGFNkEgx6yABSljQ55sTXbl
         wS8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g1ch9JUquSiEZY3rT3hSUX6ygAPZRU7aK66mWZEBfMc=;
        b=MNPfE2Lifm/J1ocRPiYEZ5Ti5B/DoavjzALGoliK5R4oibrKUGm5ZkbzclmepiNxVN
         ky7yT3Rv88sT6OxOAa9InFD7bZigKUCc/8M7699D6JzT4NbIz519cZgrsg6UpYIQDZ2S
         XxgWEvRCY4O8M5cf87QUOSXPJ73Zg53lGa9CHAcj1VJEKrqBUdGvxusb8krPBmz6iRUt
         zj9huwyN3wDXq2oZP7xXkF/4Qu93TCXzI1MnD8ogXO2fsacIA1Utk2h3P+Ymy6nVWHNk
         4W1U0uA8HJAlqkibCuhEWhKzUrWGSuAFwjgRgiALltTLGFpxPpdlFfT9xcOm1nVkmmeN
         RyUg==
X-Gm-Message-State: AOAM533i/2kdeGCqosaS59uD8Q6vum7hphLzvn4Q7cdu1uoAEUgEeXOa
        n3OzFU3YOheW+1IT5+lXwSE=
X-Google-Smtp-Source: ABdhPJz2PsC+b5mYRzZkRLbT7AMmFLF8v2YXPSNob5tFcH88kb+tlwa9H+e9nMX8+cwevoL0ITO5yw==
X-Received: by 2002:a65:6b8a:0:b0:3db:7dc5:fec2 with SMTP id d10-20020a656b8a000000b003db7dc5fec2mr17831059pgw.223.1652775120427;
        Tue, 17 May 2022 01:12:00 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id c14-20020a170902c2ce00b0015e8d4eb2easm8336306pla.308.2022.05.17.01.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 01:11:59 -0700 (PDT)
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
Subject: [PATCH net-next v2 3/9] net: sock: introduce sk_stream_kill_queues_reason()
Date:   Tue, 17 May 2022 16:10:02 +0800
Message-Id: <20220517081008.294325-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220517081008.294325-1-imagedong@tencent.com>
References: <20220517081008.294325-1-imagedong@tencent.com>
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

