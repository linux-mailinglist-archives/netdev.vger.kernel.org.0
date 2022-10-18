Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5DC6603346
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 21:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiJRTUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 15:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJRTUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 15:20:01 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AE933419
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 12:19:54 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id 8so9340692qka.1
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 12:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BUDZV+anbDpvXzCf37543h9sYjwTmnDTYhyA4NXTpv4=;
        b=cROKZnZI0L2SGarRuzleR7wKNlEGoxIAxlJL7kO7iODX/scdBa5UitMRyLR/5GfVAa
         8SCl2vGfEYUzO+ScICZATNAqh2B9YFOgd2lq5710EQGTfr6YlVAAnmKKStEqIVNBrVvN
         jtRSke7a7emicPRv5CVkfefLpYJlqXYm0qQw0/7vKEXcCh4eysKj4v+GUG7sEp7uo8/g
         JvhjHzFYfp+1ym+0H2OtFV8uIRonRiQ3YOxZH5cgxIOVXjkpmb1kTD2UBcXKFzOvDAYT
         PcYidvsG3dVQcWJVPdbFfZ2koOn8iT+FCetgg7lGhBXX5ZHFbzNsqGavfhfbU1KUcJLc
         Li2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BUDZV+anbDpvXzCf37543h9sYjwTmnDTYhyA4NXTpv4=;
        b=iYVDOcUaP2R6XdrEM4aVCpbLV96bi32H7v3hJv+6rCvjB2cItGbvQnDM+QMbxvXbIg
         46UXPicV0BMCJGDBIXsUiIRobw9BHMIpW4KkNUD5x2SgP7PYaaYalzUltAYjmuyQYd/9
         9prSptAjAVZWqkme0FlNdQAdIiqPw904RirctT2LpD0hOnYTQ1DKGn4HH2+8/9jWPK2B
         LssqWhZMjow/rNbLGHXhkM1eEWPjX6sO1/1SJZ5PkFQ92kJt8iXduGmKjWfp52FrJUb6
         wG6SqtyAQzP0dRjTqdfD4fcPwRNAum7he99SCo3Q2ut+osgMYk4xONGEivpDj9qFNejk
         CnxQ==
X-Gm-Message-State: ACrzQf2HKukm2WAISb6EHLFpeYAyqoH2rXZLM05AtbYWrBZKdXuVAjVA
        umCyt1pUAbwB3j9gufdvYKpxNfngdtoiBA==
X-Google-Smtp-Source: AMsMyM7P04yVON6r2O2ji1jfQvClcBNM7bdJkGeaIPXjbA6XuOPfltyFX3p8Ky0MxYlv9F+cMKRGbg==
X-Received: by 2002:a05:620a:150b:b0:6ee:8d04:f70 with SMTP id i11-20020a05620a150b00b006ee8d040f70mr3020274qkk.101.1666120792238;
        Tue, 18 Oct 2022 12:19:52 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c25-20020ac81119000000b003996aa171b9sm2385074qtj.97.2022.10.18.12.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 12:19:51 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
Subject: [PATCH net] tipc: fix a null-ptr-deref in tipc_topsrv_accept
Date:   Tue, 18 Oct 2022 15:19:50 -0400
Message-Id: <4eee264380c409c61c6451af1059b7fb271a7e7b.1666120790.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found a crash in tipc_topsrv_accept:

  KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
  Workqueue: tipc_rcv tipc_topsrv_accept
  RIP: 0010:kernel_accept+0x22d/0x350 net/socket.c:3487
  Call Trace:
   <TASK>
   tipc_topsrv_accept+0x197/0x280 net/tipc/topsrv.c:460
   process_one_work+0x991/0x1610 kernel/workqueue.c:2289
   worker_thread+0x665/0x1080 kernel/workqueue.c:2436
   kthread+0x2e4/0x3a0 kernel/kthread.c:376
   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

It was caused by srv->listener that might be set to null by
tipc_topsrv_stop() in net .exit whereas it's still used in
tipc_topsrv_accept() worker.

srv->listener is protected by srv->idr_lock in tipc_topsrv_stop(), so add
a check for srv->listener under srv->idr_lock in tipc_topsrv_accept() to
avoid the null-ptr-deref. To ensure the lsock is not released during the
tipc_topsrv_accept(), move sock_release() after tipc_topsrv_work_stop()
where it's waiting until the tipc_topsrv_accept worker to be done.

Note that sk_callback_lock is used to protect sk->sk_user_data instead of
srv->listener, and it should check srv in tipc_topsrv_listener_data_ready()
instead. This also ensures that no more tipc_topsrv_accept worker will be
started after tipc_conn_close() is called in tipc_topsrv_stop() where it
sets sk->sk_user_data to null.

Fixes: 0ef897be12b8 ("tipc: separate topology server listener socket from subcsriber sockets")
Reported-by: syzbot+c5ce866a8d30f4be0651@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/topsrv.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 14fd05fd6107..d92ec92f0b71 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -450,12 +450,19 @@ static void tipc_conn_data_ready(struct sock *sk)
 static void tipc_topsrv_accept(struct work_struct *work)
 {
 	struct tipc_topsrv *srv = container_of(work, struct tipc_topsrv, awork);
-	struct socket *lsock = srv->listener;
-	struct socket *newsock;
+	struct socket *newsock, *lsock;
 	struct tipc_conn *con;
 	struct sock *newsk;
 	int ret;
 
+	spin_lock_bh(&srv->idr_lock);
+	if (!srv->listener) {
+		spin_unlock_bh(&srv->idr_lock);
+		return;
+	}
+	lsock = srv->listener;
+	spin_unlock_bh(&srv->idr_lock);
+
 	while (1) {
 		ret = kernel_accept(lsock, &newsock, O_NONBLOCK);
 		if (ret < 0)
@@ -489,7 +496,7 @@ static void tipc_topsrv_listener_data_ready(struct sock *sk)
 
 	read_lock_bh(&sk->sk_callback_lock);
 	srv = sk->sk_user_data;
-	if (srv->listener)
+	if (srv)
 		queue_work(srv->rcv_wq, &srv->awork);
 	read_unlock_bh(&sk->sk_callback_lock);
 }
@@ -699,8 +706,9 @@ static void tipc_topsrv_stop(struct net *net)
 	__module_get(lsock->sk->sk_prot_creator->owner);
 	srv->listener = NULL;
 	spin_unlock_bh(&srv->idr_lock);
-	sock_release(lsock);
+
 	tipc_topsrv_work_stop(srv);
+	sock_release(lsock);
 	idr_destroy(&srv->conn_idr);
 	kfree(srv);
 }
-- 
2.31.1

