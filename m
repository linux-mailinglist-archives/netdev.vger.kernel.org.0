Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8360A6759FB
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 17:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjATQap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 11:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjATQan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 11:30:43 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367D75FFF
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 08:30:05 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id l14-20020a056e02066e00b0030bff7a1841so4076561ilt.23
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 08:30:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B2p7MpVUpBtVLJmXNTd9D6MvB8cOHwIRNVQLP6X0jY4=;
        b=ZrrLrY8FL43ThjGAHUN2W2ccILjA1FBOqEzcajaiHEyhdz06arV4+eYRBvRtCIrj1k
         u1Y3UCS2iwbttzTlb2fl/jn+Rzd7Z/iPmM2qkw5gmZxaHnUtCB+LWHQVHmtKrtCDBvll
         SpeR53csqpkMjKtQN2bnZYel2K/wRGtGBvhlLi6CJWc0dPQrtiISxyA0yaB2zGQktET0
         cMGQSSkAEClJnsEeKbWN+3HvOYdO+MY9QS9Pl/9fzSuRv7kaNECQBbmsK1JR9Z2bg8Ra
         blfCmsqp0FsGRP71mYexIsfBgF/0R7hfP9+5rktDu5SyLuyODvhs3jlQiXYgFEj7Kj6C
         CLEw==
X-Gm-Message-State: AFqh2kpW7PUEsb+oPAnQwPgJ6sWp/6oU++LxGZ1Ej37d0XHE0Qpxi83Y
        qUq309oNIma8vGeGGM3ywFsU7u2WqivFIZ8RbnWq03J7birg
X-Google-Smtp-Source: AMrXdXuncck+O7UwU3Iv++5VzRnleVcmh0QYc7PQCcg8c92S15JORDT8nQ21WGjCcAmTFVe3bry6eiHDFHd2rA9zJV6V/b3gUFL6
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d99:b0:30f:11bc:cc6e with SMTP id
 h25-20020a056e021d9900b0030f11bccc6emr1524212ila.87.1674232130203; Fri, 20
 Jan 2023 08:28:50 -0800 (PST)
Date:   Fri, 20 Jan 2023 08:28:50 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006477b305f2b48b58@google.com>
Subject: [syzbot] possible deadlock in rfcomm_dlc_exists
From:   syzbot <syzbot+b69a625d06e8ece26415@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, yangyingliang@huawei.com
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

HEAD commit:    c12e2e5b76b2 Add linux-next specific files for 20230116
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=154e0046480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ef6b6ac6c6c96c0e
dashboard link: https://syzkaller.appspot.com/bug?extid=b69a625d06e8ece26415
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4fb49204daa9/disk-c12e2e5b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7b02ca8eacc0/vmlinux-c12e2e5b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/94539232cf54/bzImage-c12e2e5b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b69a625d06e8ece26415@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.2.0-rc4-next-20230116-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.2/27510 is trying to acquire lock:
ffffffff8e322188 (rfcomm_mutex){+.+.}-{3:3}, at: rfcomm_dlc_exists+0x58/0x190 net/bluetooth/rfcomm/core.c:542

but task is already holding lock:
ffffffff8e3270c8 (rfcomm_ioctl_mutex){+.+.}-{3:3}, at: rfcomm_create_dev net/bluetooth/rfcomm/tty.c:484 [inline]
ffffffff8e3270c8 (rfcomm_ioctl_mutex){+.+.}-{3:3}, at: rfcomm_dev_ioctl+0x8a2/0x1c00 net/bluetooth/rfcomm/tty.c:587

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (rfcomm_ioctl_mutex){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:603 [inline]
       __mutex_lock+0x12f/0x1350 kernel/locking/mutex.c:747
       rfcomm_create_dev net/bluetooth/rfcomm/tty.c:484 [inline]
       rfcomm_dev_ioctl+0x8a2/0x1c00 net/bluetooth/rfcomm/tty.c:587
       rfcomm_sock_ioctl+0xb7/0xe0 net/bluetooth/rfcomm/sock.c:880
       sock_do_ioctl+0xcc/0x230 net/socket.c:1194
       sock_ioctl+0x1f8/0x680 net/socket.c:1311
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:870 [inline]
       __se_sys_ioctl fs/ioctl.c:856 [inline]
       __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #2 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}:
       lock_sock_nested+0x3a/0xf0 net/core/sock.c:3470
       lock_sock include/net/sock.h:1725 [inline]
       rfcomm_sk_state_change+0x6d/0x3a0 net/bluetooth/rfcomm/sock.c:73
       __rfcomm_dlc_close+0x1b1/0x890 net/bluetooth/rfcomm/core.c:489
       rfcomm_dlc_close+0x1e9/0x240 net/bluetooth/rfcomm/core.c:520
       __rfcomm_sock_close+0x17a/0x2f0 net/bluetooth/rfcomm/sock.c:220
       rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:912
       rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:933
       __sock_release+0xcd/0x280 net/socket.c:651
       sock_close+0x1c/0x20 net/socket.c:1390
       __fput+0x27c/0xa90 fs/file_table.c:321
       task_work_run+0x16f/0x270 kernel/task_work.c:179
       get_signal+0x1c7/0x24f0 kernel/signal.c:2635
       arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
       exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
       exit_to_user_mode_prepare+0x11f/0x240 kernel/entry/common.c:204
       __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
       syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
       do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #1 (&d->lock){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:603 [inline]
       __mutex_lock+0x12f/0x1350 kernel/locking/mutex.c:747
       __rfcomm_dlc_close+0x15d/0x890 net/bluetooth/rfcomm/core.c:487
       rfcomm_dlc_close+0x1e9/0x240 net/bluetooth/rfcomm/core.c:520
       __rfcomm_sock_close+0x17a/0x2f0 net/bluetooth/rfcomm/sock.c:220
       rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:912
       rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:933
       __sock_release+0xcd/0x280 net/socket.c:651
       sock_close+0x1c/0x20 net/socket.c:1390
       __fput+0x27c/0xa90 fs/file_table.c:321
       task_work_run+0x16f/0x270 kernel/task_work.c:179
       get_signal+0x1c7/0x24f0 kernel/signal.c:2635
       arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
       exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
       exit_to_user_mode_prepare+0x11f/0x240 kernel/entry/common.c:204
       __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
       syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
       do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #0 (rfcomm_mutex){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3107 [inline]
       check_prevs_add kernel/locking/lockdep.c:3226 [inline]
       validate_chain kernel/locking/lockdep.c:3841 [inline]
       __lock_acquire+0x2a9d/0x5780 kernel/locking/lockdep.c:5073
       lock_acquire.part.0+0x11c/0x350 kernel/locking/lockdep.c:5690
       __mutex_lock_common kernel/locking/mutex.c:603 [inline]
       __mutex_lock+0x12f/0x1350 kernel/locking/mutex.c:747
       rfcomm_dlc_exists+0x58/0x190 net/bluetooth/rfcomm/core.c:542
       __rfcomm_create_dev net/bluetooth/rfcomm/tty.c:414 [inline]
       rfcomm_create_dev net/bluetooth/rfcomm/tty.c:485 [inline]
       rfcomm_dev_ioctl+0x966/0x1c00 net/bluetooth/rfcomm/tty.c:587
       rfcomm_sock_ioctl+0xb7/0xe0 net/bluetooth/rfcomm/sock.c:880
       sock_do_ioctl+0xcc/0x230 net/socket.c:1194
       sock_ioctl+0x1f8/0x680 net/socket.c:1311
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:870 [inline]
       __se_sys_ioctl fs/ioctl.c:856 [inline]
       __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

other info that might help us debug this:

Chain exists of:
  rfcomm_mutex --> sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM --> rfcomm_ioctl_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(rfcomm_ioctl_mutex);
                               lock(sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM);
                               lock(rfcomm_ioctl_mutex);
  lock(rfcomm_mutex);

 *** DEADLOCK ***

2 locks held by syz-executor.2/27510:
 #0: ffff88804d0ad130 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1725 [inline]
 #0: ffff88804d0ad130 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: rfcomm_sock_ioctl+0xaa/0xe0 net/bluetooth/rfcomm/sock.c:879
 #1: ffffffff8e3270c8 (rfcomm_ioctl_mutex){+.+.}-{3:3}, at: rfcomm_create_dev net/bluetooth/rfcomm/tty.c:484 [inline]
 #1: ffffffff8e3270c8 (rfcomm_ioctl_mutex){+.+.}-{3:3}, at: rfcomm_dev_ioctl+0x8a2/0x1c00 net/bluetooth/rfcomm/tty.c:587

stack backtrace:
CPU: 1 PID: 27510 Comm: syz-executor.2 Not tainted 6.2.0-rc4-next-20230116-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2187
 check_prev_add kernel/locking/lockdep.c:3107 [inline]
 check_prevs_add kernel/locking/lockdep.c:3226 [inline]
 validate_chain kernel/locking/lockdep.c:3841 [inline]
 __lock_acquire+0x2a9d/0x5780 kernel/locking/lockdep.c:5073
 lock_acquire.part.0+0x11c/0x350 kernel/locking/lockdep.c:5690
 __mutex_lock_common kernel/locking/mutex.c:603 [inline]
 __mutex_lock+0x12f/0x1350 kernel/locking/mutex.c:747
 rfcomm_dlc_exists+0x58/0x190 net/bluetooth/rfcomm/core.c:542
 __rfcomm_create_dev net/bluetooth/rfcomm/tty.c:414 [inline]
 rfcomm_create_dev net/bluetooth/rfcomm/tty.c:485 [inline]
 rfcomm_dev_ioctl+0x966/0x1c00 net/bluetooth/rfcomm/tty.c:587
 rfcomm_sock_ioctl+0xb7/0xe0 net/bluetooth/rfcomm/sock.c:880
 sock_do_ioctl+0xcc/0x230 net/socket.c:1194
 sock_ioctl+0x1f8/0x680 net/socket.c:1311
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7efe0208c0c9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007efe02d1a168 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007efe021ac120 RCX: 00007efe0208c0c9
RDX: 0000000020000100 RSI: 00000000400452c8 RDI: 0000000000000008
RBP: 00007efe020e7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe7923c9af R14: 00007efe02d1a300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
