Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72466898A7
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 13:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbjBCM3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 07:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbjBCM3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 07:29:48 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943704C0E0
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 04:29:45 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id a2-20020a5d89c2000000b00717a8ac548cso2925279iot.9
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 04:29:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yERkx5bziu5VqlvGT7Faw7LHPFRS1Cl+oqB0mWyLm0o=;
        b=0LI/j//cAL7fpmIrBFZbbs6KNUxQa5pKxNaT5rH+gB+s5d2eQ6mGWjNZfSvWdLsfhE
         f2kx/JkLhmWE0pT6CtBDxKwMIzu/2MYC2haBWg6EQjHxK/rV2jg48MV3edbk4TT1sdp8
         QDjkmt/fsPNhb+zYzjSACtXcBSQ8jRqtgvT4LxyrSFLUfvGiv5qLcefbZzLhQVEqyK5e
         6EQh/jn/plcXJhtEOIjokQ1F6teh95lbWJ6UGR5zNazTMsTUe8757hb/v9+F89NGiDzc
         o4on+GppeiH2VuF3PVdjDs/Im+1XpaYgqAYGF35uf5ccZeznqTUBnO9HtFnZkslk3rZ1
         /Aqg==
X-Gm-Message-State: AO0yUKUayRavTNosuxfZmCimfmNbFKjaSgI3rAys+RXFTexv0DnTLT1d
        aeuRRmSq+4QgvQ6rYxGwOP8YQ45Az/BAW8gfU2HSnQ9+tqVG
X-Google-Smtp-Source: AK7set8/thlj1odS2M/eaRF5MjlZwn3M1cnGkM0qiDCZ/sqAUq+uTf0YHANFORGSzSzC2yc+bUr98L/uwMhCfShIjaLcRSZltEbc
MIME-Version: 1.0
X-Received: by 2002:a5e:8918:0:b0:720:33b0:ae4c with SMTP id
 k24-20020a5e8918000000b0072033b0ae4cmr2223892ioj.51.1675427384857; Fri, 03
 Feb 2023 04:29:44 -0800 (PST)
Date:   Fri, 03 Feb 2023 04:29:44 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001f1d0405f3cad6ad@google.com>
Subject: [syzbot] possible deadlock in skb_queue_tail (5)
From:   syzbot <syzbot+99002eea79449bad3ce2@syzkaller.appspotmail.com>
To:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, kuniyu@amazon.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9f266ccaa2f5 Merge tag 'for_linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1541069d480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ea31c071c6f587a3
dashboard link: https://syzkaller.appspot.com/bug?extid=99002eea79449bad3ce2
compiler:       Debian clang version 13.0.1-6~deb11u1, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0090b16a705b/disk-9f266cca.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a0c7d645ecdd/vmlinux-9f266cca.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f4cf91e16423/bzImage-9f266cca.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+99002eea79449bad3ce2@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.2.0-rc6-syzkaller-00050-g9f266ccaa2f5 #0 Not tainted
------------------------------------------------------
syz-executor.2/21497 is trying to acquire lock:
ffff88807b9559e8 (rlock-AF_UNIX){+.+.}-{2:2}, at: skb_queue_tail+0x32/0x120 net/core/skbuff.c:3572

but task is already holding lock:
ffff88807b955e80 (&u->lock/1){+.+.}-{2:2}, at: unix_dgram_sendmsg+0xf80/0x2170 net/unix/af_unix.c:2058

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&u->lock/1){+.+.}-{2:2}:
       lock_acquire+0x1a7/0x400 kernel/locking/lockdep.c:5668
       _raw_spin_lock_nested+0x2d/0x40 kernel/locking/spinlock.c:378
       sk_diag_dump_icons net/unix/diag.c:87 [inline]
       sk_diag_fill+0x6d4/0xfb0 net/unix/diag.c:157
       sk_diag_dump net/unix/diag.c:196 [inline]
       unix_diag_dump+0x3f3/0x660 net/unix/diag.c:220
       netlink_dump+0x659/0xcd0 net/netlink/af_netlink.c:2296
       __netlink_dump_start+0x542/0x710 net/netlink/af_netlink.c:2401
       netlink_dump_start include/linux/netlink.h:294 [inline]
       unix_diag_handler_dump+0x1c3/0x900 net/unix/diag.c:319
       sock_diag_rcv_msg+0xd8/0x400
       netlink_rcv_skb+0x1f0/0x470 net/netlink/af_netlink.c:2574
       sock_diag_rcv+0x26/0x40 net/core/sock_diag.c:280
       netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
       netlink_unicast+0x7e7/0x9c0 net/netlink/af_netlink.c:1365
       netlink_sendmsg+0x9b3/0xcd0 net/netlink/af_netlink.c:1942
       sock_sendmsg_nosec net/socket.c:714 [inline]
       sock_sendmsg net/socket.c:734 [inline]
       sock_write_iter+0x3d4/0x540 net/socket.c:1108
       do_iter_write+0x6f0/0xc50 fs/read_write.c:861
       vfs_writev fs/read_write.c:934 [inline]
       do_writev+0x27a/0x470 fs/read_write.c:977
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #0 (rlock-AF_UNIX){+.+.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:3097 [inline]
       check_prevs_add kernel/locking/lockdep.c:3216 [inline]
       validate_chain+0x184a/0x6470 kernel/locking/lockdep.c:3831
       __lock_acquire+0x1292/0x1f60 kernel/locking/lockdep.c:5055
       lock_acquire+0x1a7/0x400 kernel/locking/lockdep.c:5668
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0xd1/0x120 kernel/locking/spinlock.c:162
       skb_queue_tail+0x32/0x120 net/core/skbuff.c:3572
       unix_dgram_sendmsg+0x15d0/0x2170 net/unix/af_unix.c:2081
       sock_sendmsg_nosec net/socket.c:714 [inline]
       sock_sendmsg net/socket.c:734 [inline]
       ____sys_sendmsg+0x597/0x8e0 net/socket.c:2476
       ___sys_sendmsg net/socket.c:2530 [inline]
       __sys_sendmmsg+0x3d7/0x770 net/socket.c:2616
       __do_sys_sendmmsg net/socket.c:2645 [inline]
       __se_sys_sendmmsg net/socket.c:2642 [inline]
       __x64_sys_sendmmsg+0x9c/0xb0 net/socket.c:2642
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&u->lock/1);
                               lock(rlock-AF_UNIX);
                               lock(&u->lock/1);
  lock(rlock-AF_UNIX);

 *** DEADLOCK ***

1 lock held by syz-executor.2/21497:
 #0: ffff88807b955e80 (&u->lock/1){+.+.}-{2:2}, at: unix_dgram_sendmsg+0xf80/0x2170 net/unix/af_unix.c:2058

stack backtrace:
CPU: 1 PID: 21497 Comm: syz-executor.2 Not tainted 6.2.0-rc6-syzkaller-00050-g9f266ccaa2f5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e3/0x2d0 lib/dump_stack.c:106
 check_noncircular+0x2f9/0x3b0 kernel/locking/lockdep.c:2177
 check_prev_add kernel/locking/lockdep.c:3097 [inline]
 check_prevs_add kernel/locking/lockdep.c:3216 [inline]
 validate_chain+0x184a/0x6470 kernel/locking/lockdep.c:3831
 __lock_acquire+0x1292/0x1f60 kernel/locking/lockdep.c:5055
 lock_acquire+0x1a7/0x400 kernel/locking/lockdep.c:5668
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0xd1/0x120 kernel/locking/spinlock.c:162
 skb_queue_tail+0x32/0x120 net/core/skbuff.c:3572
 unix_dgram_sendmsg+0x15d0/0x2170 net/unix/af_unix.c:2081
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0x597/0x8e0 net/socket.c:2476
 ___sys_sendmsg net/socket.c:2530 [inline]
 __sys_sendmmsg+0x3d7/0x770 net/socket.c:2616
 __do_sys_sendmmsg net/socket.c:2645 [inline]
 __se_sys_sendmmsg net/socket.c:2642 [inline]
 __x64_sys_sendmmsg+0x9c/0xb0 net/socket.c:2642
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f9f4ca8c0c9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9f4b5fe168 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f9f4cbabf80 RCX: 00007f9f4ca8c0c9
RDX: 0000000000000318 RSI: 00000000200bd000 RDI: 0000000000000004
RBP: 00007f9f4cae7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff14604ccf R14: 00007f9f4b5fe300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
