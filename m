Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21CA58E0EF
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 22:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344707AbiHIUUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 16:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344820AbiHIUU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 16:20:27 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E04A26560
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 13:20:23 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id a19-20020a921a13000000b002df8a28c30dso8655229ila.9
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 13:20:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=GjwkUBQVLBkyBVl8NOlueWl7PztptrAWkcGw0ntA7Bk=;
        b=SqYiyyiTJSNckiOyhfLdIp3FdiiBGrNwgV8IILOMtcuA407xnGjVJBD+iIxO+u50eT
         nvD2IbowKFAydrlUf7BxP4697qpDDA8f91nab9ij7zMoC2WvpCym0Aan1UNPuLtve3ht
         4z2jHVoiPi3OgidcT2Phf2LAPA+SkJ6SLqVg3Kmd5k7a31iskkOwZnr3uLAXLD/ABAPN
         bVG1JqDOLWu2Cw6XNNVUcIwu0w3DzLgxZ2OneyKdTT4DUzeI2g9zbnBOVyGNlvH2Niwt
         Z18+tuxyIwMXEYF48fkwkpOAbcrZJ0V45Ph93jV6sh+dgyY2JGu5aus5OdJOMHaAf1xY
         iMVQ==
X-Gm-Message-State: ACgBeo2uftTbRH3jPtOaX+MMSPB7l2u+SonwWUZPg+UfZ8oCXN7S26gl
        NTEjCM4J7EbJWB81MN9upS98TgpoFL5jHgBcP59LpQWT2Dln
X-Google-Smtp-Source: AA6agR6k1qWKJFcjVwwhU3XAEXY8YdAUv5UtNbUZuvjRh+GZz9k8T5VuPkdK6vcsb5A8tlE4dXdBEWpBO/qKoHmmxxYvFUlh9Wy7
MIME-Version: 1.0
X-Received: by 2002:a5d:9582:0:b0:684:3e74:70 with SMTP id a2-20020a5d9582000000b006843e740070mr8293486ioo.8.1660076422947;
 Tue, 09 Aug 2022 13:20:22 -0700 (PDT)
Date:   Tue, 09 Aug 2022 13:20:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007d6f2105e5d4a94e@google.com>
Subject: [syzbot] possible deadlock in sk_diag_fill (4)
From:   syzbot <syzbot+ed5155f1684f6cab8abc@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kuniyu@amazon.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    cb71b93c2dc3 Add linux-next specific files for 20220628
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17f69c12080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=badbc1adb2d582eb
dashboard link: https://syzkaller.appspot.com/bug?extid=ed5155f1684f6cab8abc
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ed5155f1684f6cab8abc@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.19.0-rc4-next-20220628-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.3/3509 is trying to acquire lock:
ffff8880765fae70 (&u->lock/1){+.+.}-{2:2}, at: sk_diag_dump_icons net/unix/diag.c:87 [inline]
ffff8880765fae70 (&u->lock/1){+.+.}-{2:2}, at: sk_diag_fill+0xaaf/0x10d0 net/unix/diag.c:155

but task is already holding lock:
ffff8880765fe9e8 (rlock-AF_UNIX){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:360 [inline]
ffff8880765fe9e8 (rlock-AF_UNIX){+.+.}-{2:2}, at: sk_diag_dump_icons net/unix/diag.c:69 [inline]
ffff8880765fe9e8 (rlock-AF_UNIX){+.+.}-{2:2}, at: sk_diag_fill+0x9c3/0x10d0 net/unix/diag.c:155

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (rlock-AF_UNIX){+.+.}-{2:2}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
       skb_queue_tail+0x21/0x140 net/core/skbuff.c:3371
       unix_dgram_sendmsg+0xf5a/0x1b60 net/unix/af_unix.c:2015
       sock_sendmsg_nosec net/socket.c:714 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:734
       io_send+0x26b/0x780 io_uring/net.c:266
       io_issue_sqe+0x15e/0xd20 io_uring/io_uring.c:1601
       io_queue_sqe io_uring/io_uring.c:1778 [inline]
       io_submit_sqe io_uring/io_uring.c:2036 [inline]
       io_submit_sqes+0x9a6/0x1ec0 io_uring/io_uring.c:2147
       __do_sys_io_uring_enter+0xb85/0x1eb0 io_uring/io_uring.c:3087
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x46/0xb0

-> #0 (&u->lock/1){+.+.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:3095 [inline]
       check_prevs_add kernel/locking/lockdep.c:3214 [inline]
       validate_chain kernel/locking/lockdep.c:3829 [inline]
       __lock_acquire+0x2abe/0x5660 kernel/locking/lockdep.c:5053
       lock_acquire kernel/locking/lockdep.c:5665 [inline]
       lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5630
       _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:378
       sk_diag_dump_icons net/unix/diag.c:87 [inline]
       sk_diag_fill+0xaaf/0x10d0 net/unix/diag.c:155
       sk_diag_dump net/unix/diag.c:193 [inline]
       unix_diag_dump+0x3a9/0x640 net/unix/diag.c:217
       netlink_dump+0x541/0xc20 net/netlink/af_netlink.c:2275
       __netlink_dump_start+0x647/0x900 net/netlink/af_netlink.c:2380
       netlink_dump_start include/linux/netlink.h:245 [inline]
       unix_diag_handler_dump net/unix/diag.c:315 [inline]
       unix_diag_handler_dump+0x5c2/0x830 net/unix/diag.c:304
       __sock_diag_cmd net/core/sock_diag.c:235 [inline]
       sock_diag_rcv_msg+0x31a/0x440 net/core/sock_diag.c:266
       netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
       sock_diag_rcv+0x26/0x40 net/core/sock_diag.c:277
       netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
       netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
       netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
       sock_sendmsg_nosec net/socket.c:714 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:734
       sock_no_sendpage+0xff/0x140 net/core/sock.c:3162
       kernel_sendpage.part.0+0x1d5/0x700 net/socket.c:3564
       kernel_sendpage net/socket.c:3561 [inline]
       sock_sendpage+0xdf/0x140 net/socket.c:1054
       pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
       splice_from_pipe_feed fs/splice.c:418 [inline]
       __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
       splice_from_pipe fs/splice.c:597 [inline]
       generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
       do_splice_from fs/splice.c:767 [inline]
       do_splice+0xb57/0x1920 fs/splice.c:1079
       __do_splice+0x134/0x250 fs/splice.c:1144
       __do_sys_splice fs/splice.c:1350 [inline]
       __se_sys_splice fs/splice.c:1332 [inline]
       __x64_sys_splice+0x198/0x250 fs/splice.c:1332
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x46/0xb0

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(rlock-AF_UNIX);
                               lock(&u->lock/1);
                               lock(rlock-AF_UNIX);
  lock(&u->lock/1);

 *** DEADLOCK ***

6 locks held by syz-executor.3/3509:
 #0: ffff888074fac468 (&pipe->mutex/1){+.+.}-{3:3}, at: pipe_lock_nested fs/pipe.c:82 [inline]
 #0: ffff888074fac468 (&pipe->mutex/1){+.+.}-{3:3}, at: pipe_lock+0x5a/0x70 fs/pipe.c:90
 #1: ffffffff8d5aef88 (sock_diag_mutex){+.+.}-{3:3}, at: sock_diag_rcv+0x17/0x40 net/core/sock_diag.c:276
 #2: ffffffff8d5af108 (sock_diag_table_mutex){+.+.}-{3:3}, at: __sock_diag_cmd net/core/sock_diag.c:230 [inline]
 #2: ffffffff8d5af108 (sock_diag_table_mutex){+.+.}-{3:3}, at: sock_diag_rcv_msg+0x19b/0x440 net/core/sock_diag.c:266
 #3: ffff88801d907678 (nlk_cb_mutex-SOCK_DIAG){+.+.}-{3:3}, at: netlink_dump+0xae/0xc20 net/netlink/af_netlink.c:2223
 #4: ffff888046a7a798 (&net->unx.table.locks[i]){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:360 [inline]
 #4: ffff888046a7a798 (&net->unx.table.locks[i]){+.+.}-{2:2}, at: unix_diag_dump+0x1b4/0x640 net/unix/diag.c:211
 #5: ffff8880765fe9e8 (rlock-AF_UNIX){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:360 [inline]
 #5: ffff8880765fe9e8 (rlock-AF_UNIX){+.+.}-{2:2}, at: sk_diag_dump_icons net/unix/diag.c:69 [inline]
 #5: ffff8880765fe9e8 (rlock-AF_UNIX){+.+.}-{2:2}, at: sk_diag_fill+0x9c3/0x10d0 net/unix/diag.c:155

stack backtrace:
CPU: 1 PID: 3509 Comm: syz-executor.3 Not tainted 5.19.0-rc4-next-20220628-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3095 [inline]
 check_prevs_add kernel/locking/lockdep.c:3214 [inline]
 validate_chain kernel/locking/lockdep.c:3829 [inline]
 __lock_acquire+0x2abe/0x5660 kernel/locking/lockdep.c:5053
 lock_acquire kernel/locking/lockdep.c:5665 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5630
 _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:378
 sk_diag_dump_icons net/unix/diag.c:87 [inline]
 sk_diag_fill+0xaaf/0x10d0 net/unix/diag.c:155
 sk_diag_dump net/unix/diag.c:193 [inline]
 unix_diag_dump+0x3a9/0x640 net/unix/diag.c:217
 netlink_dump+0x541/0xc20 net/netlink/af_netlink.c:2275
 __netlink_dump_start+0x647/0x900 net/netlink/af_netlink.c:2380
 netlink_dump_start include/linux/netlink.h:245 [inline]
 unix_diag_handler_dump net/unix/diag.c:315 [inline]
 unix_diag_handler_dump+0x5c2/0x830 net/unix/diag.c:304
 __sock_diag_cmd net/core/sock_diag.c:235 [inline]
 sock_diag_rcv_msg+0x31a/0x440 net/core/sock_diag.c:266
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
 sock_diag_rcv+0x26/0x40 net/core/sock_diag.c:277
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 sock_no_sendpage+0xff/0x140 net/core/sock.c:3162
 kernel_sendpage.part.0+0x1d5/0x700 net/socket.c:3564
 kernel_sendpage net/socket.c:3561 [inline]
 sock_sendpage+0xdf/0x140 net/socket.c:1054
 pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 do_splice+0xb57/0x1920 fs/splice.c:1079
 __do_splice+0x134/0x250 fs/splice.c:1144
 __do_sys_splice fs/splice.c:1350 [inline]
 __se_sys_splice fs/splice.c:1332 [inline]
 __x64_sys_splice+0x198/0x250 fs/splice.c:1332
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f94a7089209
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f94a8105168 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
RAX: ffffffffffffffda RBX: 00007f94a719bf60 RCX: 00007f94a7089209
RDX: 0000000000000005 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00007f94a70e3161 R08: 0000000080000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd5cb777cf R14: 00007f94a8105300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
