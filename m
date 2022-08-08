Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F16258CD4C
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 20:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243990AbiHHSFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 14:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243854AbiHHSFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 14:05:19 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089E810C1;
        Mon,  8 Aug 2022 11:05:18 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o3-20020a17090a0a0300b001f7649cd317so2213903pjo.0;
        Mon, 08 Aug 2022 11:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZbLrnLtwu2sUASVZtr1avkLgUbGCKkScbBilSB2wV4E=;
        b=g2qWbHHd1FXZIKUtYFs2WlBkZHff24nK4BN4Aj8C5hk1GbGp0HdKFP5HPQKDA781lP
         naJOwJVf2UJrbIyid9reQzwM6Xfai0MqsBjc3mERpgrw4oy1CyJ+KCka68DwBbrxejyG
         26uO8Y+BUOmnp2K+/aXKpGhDlXL58xiJk0HkUaXtuvCJur9txplAwGFOLwaV+YsVSUUd
         y3sIJsp+dc8SQ8dChsdw9vy15iksMEPm91m4Vzq8o+obvJ5+JOeT/OWM/NrNjV7LAK70
         J2kSKkAQSrRnsHhcbdsoGyuPY29monns2UAdG2NmIp/18pDrDRiDS6vHs/swOHauVt4R
         E1rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZbLrnLtwu2sUASVZtr1avkLgUbGCKkScbBilSB2wV4E=;
        b=uc7VdJnVhFuLiS9EsNY6uCT1rbP7W9GlCcUu0nKZllxAeFbuIgbinvJD2ZFITdcf+Q
         /h0+RqU6Vr32LU71uZRsaXXPJlXvBKosl7q6LmStW8EqT5ABggxfq0n1fCD+dMiQhamH
         pkwl8xn+66EyKvuCM+6qdVdmPkickP78jOCL2W73gXQrhnIwdSzUqnhm4RQsL1PDnZgI
         j+6qWEVw5iEvTn5oKJB8JsSHSANqO4C7VWs/7bZ0UrlcsN7gwMrvUPy4o1KtciYjIePJ
         ej4rdBT4rFEO4S/w3WRZIRYe8lfUGGGXykEWruE7vAOXaMd1PtLAqZ2hq9UwTwzLeiqp
         USVA==
X-Gm-Message-State: ACgBeo3MseMp9yhmL/gqokHumMCI5Mz9CA7OeLCi7FhmKS4lJVC7zpgX
        Qp0dmekT97N50PbI9hr6GA==
X-Google-Smtp-Source: AA6agR7y2gI499OEqa3RlPhHvk7vUB6xVNEkbFjS1UzUSBoI2Zh4wg2YBjp4+DxPp/Rp/xCbbj0gKQ==
X-Received: by 2002:a17:902:ecc7:b0:16e:ff60:4286 with SMTP id a7-20020a170902ecc700b0016eff604286mr18867545plh.28.1659981917503;
        Mon, 08 Aug 2022 11:05:17 -0700 (PDT)
Received: from bytedance.bytedance.net ([74.199.177.246])
        by smtp.gmail.com with ESMTPSA id a8-20020a170902ecc800b0016c5306917fsm9251785plh.53.2022.08.08.11.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 11:05:17 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        George Zhang <georgezhang@vmware.com>,
        Dmitry Torokhov <dtor@vmware.com>,
        Andy King <acking@vmware.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net v3 1/2] vsock: Fix memory leak in vsock_connect()
Date:   Mon,  8 Aug 2022 11:04:47 -0700
Message-Id: <fd0dc1aa3a78df22d64de59333e1d47ee60ed3e8.1659981325.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <a02c6e7e3135473d254ac97abc603d963ba8f716.1659862577.git.peilin.ye@bytedance.com>
References: <a02c6e7e3135473d254ac97abc603d963ba8f716.1659862577.git.peilin.ye@bytedance.com>
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

From: Peilin Ye <peilin.ye@bytedance.com>

An O_NONBLOCK vsock_connect() request may try to reschedule
@connect_work.  Imagine the following sequence of vsock_connect()
requests:

  1. The 1st, non-blocking request schedules @connect_work, which will
     expire after 200 jiffies.  Socket state is now SS_CONNECTING;

  2. Later, the 2nd, blocking request gets interrupted by a signal after
     a few jiffies while waiting for the connection to be established.
     Socket state is back to SS_UNCONNECTED, but @connect_work is still
     pending, and will expire after 100 jiffies.

  3. Now, the 3rd, non-blocking request tries to schedule @connect_work
     again.  Since @connect_work is already scheduled,
     schedule_delayed_work() silently returns.  sock_hold() is called
     twice, but sock_put() will only be called once in
     vsock_connect_timeout(), causing a memory leak reported by syzbot:

  BUG: memory leak
  unreferenced object 0xffff88810ea56a40 (size 1232):
    comm "syz-executor756", pid 3604, jiffies 4294947681 (age 12.350s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      28 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  (..@............
    backtrace:
      [<ffffffff837c830e>] sk_prot_alloc+0x3e/0x1b0 net/core/sock.c:1930
      [<ffffffff837cbe22>] sk_alloc+0x32/0x2e0 net/core/sock.c:1989
      [<ffffffff842ccf68>] __vsock_create.constprop.0+0x38/0x320 net/vmw_vsock/af_vsock.c:734
      [<ffffffff842ce8f1>] vsock_create+0xc1/0x2d0 net/vmw_vsock/af_vsock.c:2203
      [<ffffffff837c0cbb>] __sock_create+0x1ab/0x2b0 net/socket.c:1468
      [<ffffffff837c3acf>] sock_create net/socket.c:1519 [inline]
      [<ffffffff837c3acf>] __sys_socket+0x6f/0x140 net/socket.c:1561
      [<ffffffff837c3bba>] __do_sys_socket net/socket.c:1570 [inline]
      [<ffffffff837c3bba>] __se_sys_socket net/socket.c:1568 [inline]
      [<ffffffff837c3bba>] __x64_sys_socket+0x1a/0x20 net/socket.c:1568
      [<ffffffff84512815>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
      [<ffffffff84512815>] do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
      [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae
  <...>

Use mod_delayed_work() instead: if @connect_work is already scheduled,
reschedule it, and undo sock_hold() to keep the reference count
balanced.

Reported-and-tested-by: syzbot+b03f55bf128f9a38f064@syzkaller.appspotmail.com
Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Co-developed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
change since v2:
  - wrapped long line (Stefano)

change since v1:
  - merged with Stefano's patch [1]

[1] https://gitlab.com/sgarzarella/linux/-/commit/2d0f0b9cbbb30d58fdcbca7c1a857fd8f3110d61

 net/vmw_vsock/af_vsock.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index f04abf662ec6..4d68681f5abe 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1391,7 +1391,14 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 			 * timeout fires.
 			 */
 			sock_hold(sk);
-			schedule_delayed_work(&vsk->connect_work, timeout);
+
+			/* If the timeout function is already scheduled,
+			 * reschedule it, then ungrab the socket refcount to
+			 * keep it balanced.
+			 */
+			if (mod_delayed_work(system_wq, &vsk->connect_work,
+					     timeout))
+				sock_put(sk);
 
 			/* Skip ahead to preserve error code set above. */
 			goto out_wait;
-- 
2.20.1

