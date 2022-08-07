Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B7158BA56
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 11:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbiHGJAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 05:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbiHGJAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 05:00:35 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9116171;
        Sun,  7 Aug 2022 02:00:34 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 130so5743753pfv.13;
        Sun, 07 Aug 2022 02:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qni0rYee/HlsJdTHd9Y+kIdaIsYANJdmYzeddwDHiNw=;
        b=VfQz50S8RfV298NAMsS+nYuT0HjQPFM2Hq5XLD8SWew8UXwnd6cgUko+0zb9zSShrB
         ITkHN23L0yQV2jJwq255bo7XArVhXDDb+vbiRC7Nfmb06N0bqqxLb+BDP9rFQQS8hhSs
         5N8WuAlFEQQ1C3hui56D6ow/3HBiBAl8fxc9vuRP7EUZ6zzANdUOJT7pJvne5sr2k5lX
         Spnzp5MxB5ppyCqkX7n7ZPknVn1ySuUj/FUoZXEvNuBr0MVCSuw+469fMAUOXZs2O6rt
         P9J57PXexAPFoJLe0aU+7O8aYqBm5o4ljLINGuaNC4pioN1MqRUNePNKPtRaOjDuccOO
         gddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qni0rYee/HlsJdTHd9Y+kIdaIsYANJdmYzeddwDHiNw=;
        b=0Mld0R6cyJS1xx37/1q8GukdE0Q1q3q0L89JwDT8h2ciFyO6TWgDBqKdthAMvp2ILA
         bhF1WOiILYLOVQutztpyO3VqDH9H2Eu4/GG9UF4wBMcVwzNmJBNmuoidRsTGaamJi+DN
         Qt1gobLuay2hw3ZP0HnFxePuxyxemscs9NX2b+4cumu8IscrG16/4Lpa+61ek1jPITaY
         0xWQ3u8jyehQFhxCodEvINSklS8ah4zEGjeXi03sizJh1OKYuVaSO5t1cPq/0eqCoPn8
         7QtmA/9mQLLNyH+8hh+MLn3sJvns3U5rZsiFdFKOxpIWkibaToSup7uAdJuetdKkWjoW
         kGCw==
X-Gm-Message-State: ACgBeo1BjnmpDMEVPHa2LciMgfj+/U9W7mffbgh5fjRKzTGlavG3Q8MM
        b8df90XjRmWSIxrS5UjNOg/+ZfcoCkgb
X-Google-Smtp-Source: AA6agR6o8zVY6NM0xbsMJ9hAvP/vBEi4bM5/pJPGmSg0qc1NRRl29LxZw0QoIeA7oylI+odM8JYWOA==
X-Received: by 2002:aa7:8e91:0:b0:52d:8ebf:29a4 with SMTP id a17-20020aa78e91000000b0052d8ebf29a4mr14222576pfr.1.1659862833974;
        Sun, 07 Aug 2022 02:00:33 -0700 (PDT)
Received: from bytedance.attlocal.net ([139.177.225.235])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902654e00b0016ed715d244sm6183912pln.300.2022.08.07.02.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Aug 2022 02:00:33 -0700 (PDT)
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
Subject: [PATCH net v2 1/2] vsock: Fix memory leak in vsock_connect()
Date:   Sun,  7 Aug 2022 02:00:11 -0700
Message-Id: <a02c6e7e3135473d254ac97abc603d963ba8f716.1659862577.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804020925.32167-1-yepeilin.cs@gmail.com>
References: <20220804020925.32167-1-yepeilin.cs@gmail.com>
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
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
change since v1:
  - merged with Stefano's patch [1]

[1] https://gitlab.com/sgarzarella/linux/-/commit/2d0f0b9cbbb30d58fdcbca7c1a857fd8f3110d61

Hi Stefano,

About the Fixes: tag, [2] introduced @connect_work, but all it did was
breaking @dwork into two and moving some INIT_DELAYED_WORK()'s, so I don't
think [2] introduced this memory leak?

Since [2] has already been backported to 4.9 and 4.14, I think we can
Fixes: commit d021c344051a ("VSOCK: Introduce VM Sockets"), too, to make
backporting easier?

[2] commit 455f05ecd2b2 ("vsock: split dwork to avoid reinitializations")

Thanks,
Peilin Ye

 net/vmw_vsock/af_vsock.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index f04abf662ec6..fe14f6cbca22 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1391,7 +1391,13 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 			 * timeout fires.
 			 */
 			sock_hold(sk);
-			schedule_delayed_work(&vsk->connect_work, timeout);
+
+			/* If the timeout function is already scheduled,
+			 * reschedule it, then ungrab the socket refcount to
+			 * keep it balanced.
+			 */
+			if (mod_delayed_work(system_wq, &vsk->connect_work, timeout))
+				sock_put(sk);
 
 			/* Skip ahead to preserve error code set above. */
 			goto out_wait;
-- 
2.20.1

