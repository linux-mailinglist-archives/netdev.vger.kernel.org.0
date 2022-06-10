Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05535545ABB
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346208AbiFJDpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239311AbiFJDox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:44:53 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866F937F912;
        Thu,  9 Jun 2022 20:44:52 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id o6-20020a17090a0a0600b001e2c6566046so1129693pjo.0;
        Thu, 09 Jun 2022 20:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GmjrKEQYPgZPTRJ4jJxsOeeTsxk0UvR5BruchnIbbJc=;
        b=CQgeL72vUPpt+QhX/573LxrK6q6bh9PS+by6UFO4zShednyrlRuPYM1efYxqjoYvts
         AwT5cbpjJ41hqa+R7Fhx+uKU2KapffVNSQaaP0OanPmqx5JuOqNnAUz0abWMBKdrpmRp
         biyOCuU1pW8tX6lGRMLOZ+H9kz3QQ9Bb6Cl/yXP3lpICbEwz5xXkI+EHFDwwgpJ02uRB
         5CP70lCSrNMaOjCjbWlGIQG3KmRitwdTY//dg222QZUqr/loopTyiagIvOP4SnKIg9Y1
         +7dbb+oXEpflWfdvKJBO57M9/7wJyDw7rgMK2R2PGKPtuIFSmrQh7HiI8vDKtGfphl/4
         IcRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GmjrKEQYPgZPTRJ4jJxsOeeTsxk0UvR5BruchnIbbJc=;
        b=kTZjBsKJwQZoN8upYgCNJgyFyROHuBQIq9ka250ZIgTD4ru71WL/HL96UgxGlkeUaS
         LgyQnnxwV8iSqrdLGmzsGg+smyKUFRAh+Rx302rSXgLf+PEM3p9+CprTKrnIjrSta+ti
         uJ+XKaGPHZPwn0ym76ZjIV5bhs4MnjG2F/zqWHXp/XS0MdGtZZOSQmx18M34ATcBmU0e
         becsTCkLuIQgFM1TKX0XREht9WhUsuEsQWRpoUY6gIEFMDj4kh/AklGGYAIyRE/WiWsz
         9BtFTGj6NXzsRQOcJ6hdJRVHMO8Kh3gZ15Qd8Pn49V/B2gAYoEW8JT4Y3gd7z0JdkPF6
         8SgQ==
X-Gm-Message-State: AOAM532zI+s2IQPSgu+URqsrh94M8D2aej5vn6pg81afQedzggffYJng
        R4pH8q3bygKVhavig5dMWX4=
X-Google-Smtp-Source: ABdhPJxzAU+PuPbIhoN42pBXo1oJVG8BBuM/qPiVn38TuJN55d4DT0CFf3Qko6LGylSlZU1PMda5cA==
X-Received: by 2002:a17:903:2485:b0:161:da96:1701 with SMTP id p5-20020a170903248500b00161da961701mr43282206plw.58.1654832692069;
        Thu, 09 Jun 2022 20:44:52 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id u30-20020a63b55e000000b003fc136f9a7dsm5908368pgo.38.2022.06.09.20.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 20:44:51 -0700 (PDT)
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
Subject: [PATCH net-next v3 2/9] net: sock: introduce sk_stream_kill_queues_reason()
Date:   Fri, 10 Jun 2022 11:41:57 +0800
Message-Id: <20220610034204.67901-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220610034204.67901-1-imagedong@tencent.com>
References: <20220610034204.67901-1-imagedong@tencent.com>
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

