Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF6259B3D2
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 14:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiHUM6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 08:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiHUM57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 08:57:59 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACD416586;
        Sun, 21 Aug 2022 05:57:57 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id p18so7725936plr.8;
        Sun, 21 Aug 2022 05:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ClDyou4gGsGQygKcng/+QxuCvSmLH/T0LzzWygeLDxo=;
        b=DzldWQk3w9CMSvh7wXhDSN2aWrVFsSkaBRGf4hK4iF8emTltMf6t9vv/FAHY7jMDtu
         el0UZKoheRtu+4Voxc4ucu9UeGmKyi36kc1ikmO3qZeg/IDmqUXbgu2+JIO5SYvgDsDV
         whKmYSSy4uCsEljwlCehrxkdvcU6yFnAz1DKRRGqEpCIzE0GDAtbEPqOMID3va+luviN
         jArWd8Y8HWPBo1CuVbX7o/n5GclujeIVWDaHTS/Hoe+Qom6y2Bu+4u7n0WnhO4/TU5fd
         xZ4A7e7akZ3DQmvbwVLiAQm3bhRqzJOUUzacClaY+nc7bmurtMaSveF/FlownKYUmxk6
         y9Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ClDyou4gGsGQygKcng/+QxuCvSmLH/T0LzzWygeLDxo=;
        b=ws3eKOWqZZji1OuaXIoDq4ZHV9Ydl9EOkJQzrOsAki21oG3+I0XWFfAqBVRGe3bCw/
         DkO64WqCEn51L/eNifur6DOyn6KiXEe+ZE9PqIVS52VLi03Kz5aip7MjDBmvKvYbzA7Q
         oWyUf09Luctwg8v8OwzZYthUMxyqduKzl13PnYJ2lorM7I8nDiIYKUSEUVb60yB0D8p1
         2+5Y5nGGWVu56l816c+fEIPpxdbci7XK4KdDncBRp0jEnyhxJ9/l2ksjctwo10iuGtRQ
         GpqjXVICONxiAcR1paYNHZwKLLFJbYTmaX4eK7HWGh1cBf9haaZhK/jysfk2vROmXASB
         UHjg==
X-Gm-Message-State: ACgBeo3EjlmLBrdMCEkAmiwBc3/5F/cJDNr7Eg70MlYA+1PsAqXnxSqL
        bWthtHn+pLdzsCJECvQE7tU=
X-Google-Smtp-Source: AA6agR5zia5vYqSnvV68J6GwqVaSGboCXGZgtlbolLgoa4BnlG/hWEgaBeCsm/Hs81I1xoN/q9BBAg==
X-Received: by 2002:a17:903:1246:b0:171:5033:85c with SMTP id u6-20020a170903124600b001715033085cmr15798412plh.146.1661086677425;
        Sun, 21 Aug 2022 05:57:57 -0700 (PDT)
Received: from localhost ([36.112.204.208])
        by smtp.gmail.com with ESMTPSA id iw11-20020a170903044b00b0016d150c6c6dsm6374211plb.45.2022.08.21.05.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 05:57:57 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        paskripkin@gmail.com, skhan@linuxfoundation.org,
        18801353760@163.com, Hawkins Jiawei <yin31149@gmail.com>
Subject: [PATCH] rxrpc: fix bad unlock balance in rxrpc_do_sendmsg
Date:   Sun, 21 Aug 2022 20:57:50 +0800
Message-Id: <20220821125751.4185-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <000000000000ce327f05d537ebf7@google.com>
References: <000000000000ce327f05d537ebf7@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller reports bad unlock balance bug as follows:
------------[ cut here ]------------
WARNING: bad unlock balance detected!
syz-executor.0/4094 is trying to release lock (&call->user_mutex) at:
[<ffffffff87c1d8d1>] rxrpc_do_sendmsg+0x851/0x1110 net/rxrpc/sendmsg.c:754
but there are no more locks to release!

other info that might help us debug this:
no locks held by syz-executor.0/4094.

stack backtrace:
[...]
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x57/0x7d lib/dump_stack.c:106
 print_unlock_imbalance_bug include/trace/events/lock.h:69 [inline]
 __lock_release kernel/locking/lockdep.c:5333 [inline]
 lock_release.cold+0x49/0x4e kernel/locking/lockdep.c:5686
 __mutex_unlock_slowpath+0x99/0x5e0 kernel/locking/mutex.c:907
 rxrpc_do_sendmsg+0x851/0x1110 net/rxrpc/sendmsg.c:754
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xab/0xe0 net/socket.c:734
 ____sys_sendmsg+0x5c2/0x7a0 net/socket.c:2485
 ___sys_sendmsg+0xdb/0x160 net/socket.c:2539
 __sys_sendmsg+0xc3/0x160 net/socket.c:2568
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
 [...]
 </TASK>
------------------------------------

When kernel wants to send a message through an RxRPC socket in
rxrpc_do_sendmsg(), kernel should hold the call->user_mutex lock,
or it will triggers bug when releasing this lock before returning
from rxrpc_do_sendmsg().

Yet the problem is that during rxrpc_do_sendmsg(), kernel may call
rxrpc_wait_for_tx_window_intr() to wait for space to appear in the
tx queue or a signal to occur. When kernel fails the
mutex_lock_interruptible(), kernel will returns from the
rxrpc_wait_for_tx_window_intr() without acquiring the mutex lock, then
triggers bug when releasing the mutex lock in rxrpc_do_sendmsg().

This patch solves it by acquiring the call->user_mutex lock, when
kernel fails the mutex_lock_interruptible() before returning from
the rxrpc_wait_for_tx_window_intr().

Reported-and-tested-by: syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
---
 net/rxrpc/sendmsg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 1d38e279e2ef..e13043d357d5 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -53,8 +53,10 @@ static int rxrpc_wait_for_tx_window_intr(struct rxrpc_sock *rx,
 		trace_rxrpc_transmit(call, rxrpc_transmit_wait);
 		mutex_unlock(&call->user_mutex);
 		*timeo = schedule_timeout(*timeo);
-		if (mutex_lock_interruptible(&call->user_mutex) < 0)
+		if (mutex_lock_interruptible(&call->user_mutex) < 0) {
+			mutex_lock(&call->user_mutex);
 			return sock_intr_errno(*timeo);
+		}
 	}
 }
 
-- 
2.25.1

