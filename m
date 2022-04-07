Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E9B4F893F
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 00:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbiDGWKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 18:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiDGWKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 18:10:49 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2D64E3B7
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 15:08:26 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id g16-20020a05660226d000b00638d8e1828bso4493741ioo.13
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 15:08:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=FcnDF7Pwv/fxekIgcMUqQ2gFtdJTzyL5GThXsIFoAJY=;
        b=BMTHoFjZZ4TBvbEUjuKK/7pKTm4yamh5prMwtVu1+NryI+SF8Wc2sotjjtrZiHfOBD
         aGC6n2N70UPxdItszCrofhDpV/w1sxg3vizF2+k860/p0vZGK+j0sI6p2SMMntiUWpUq
         hrijj+XbYXzkdb3dYqgGaRZIk2g0mzZXQ1a92yKZkbqFuWqChv8ABDFPuE0GTUY9vYo6
         2nv0Pq5d2Hdqrd4FSkDUKOtqa5HaPPC4qqJTeAJ19YWrVfUJSnyYktEO9EtsKhgwCmzr
         69kXjvCiMcH7ahhMI4DC6iSxjb+jxCsch6scg8OZn7D37M2dCHfxLUZ3ExdviPM/R3cq
         KJrA==
X-Gm-Message-State: AOAM5328FMMIx6PwIQPqv1A/IctWkJ1sbWMWlX+TOaBAHczlYlwobwJI
        yDSZcxBS46jQwUnp1qndxrcVN9ZAbEBaFo4Hc/dotCx/iuvo
X-Google-Smtp-Source: ABdhPJwAO4bCNZbC4W05yLKUBMWrrXBkaSfvdAGp0T4arlEyORp2fDsYByKQD5NC/O/3quotb4zGZh8FVtf1smxEPxQg+W66ftO8
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1809:b0:2ca:869a:6518 with SMTP id
 a9-20020a056e02180900b002ca869a6518mr267183ilv.178.1649369306112; Thu, 07 Apr
 2022 15:08:26 -0700 (PDT)
Date:   Thu, 07 Apr 2022 15:08:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000098289005dc17b71b@google.com>
Subject: [syzbot] possible deadlock in sco_conn_del
From:   syzbot <syzbot+b825d87fe2d043e3e652@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    696206280c5e Add linux-next specific files for 20220404
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12c57ff5700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5eb81244dbc8d9b7
dashboard link: https://syzkaller.appspot.com/bug?extid=b825d87fe2d043e3e652
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b825d87fe2d043e3e652@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.18.0-rc1-next-20220404-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.4/21629 is trying to acquire lock:
ffff88801acb3130 (sk_lock-AF_BLUETOOTH-BTPROTO_SCO){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1682 [inline]
ffff88801acb3130 (sk_lock-AF_BLUETOOTH-BTPROTO_SCO){+.+.}-{0:0}, at: sco_conn_del+0x131/0x2c0 net/bluetooth/sco.c:197

but task is already holding lock:
ffffffff8d76e388 (hci_cb_list_lock){+.+.}-{3:3}, at: hci_disconn_cfm include/net/bluetooth/hci_core.h:1576 [inline]
ffffffff8d76e388 (hci_cb_list_lock){+.+.}-{3:3}, at: hci_conn_hash_flush+0xda/0x260 net/bluetooth/hci_conn.c:1458

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (hci_cb_list_lock){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:600 [inline]
       __mutex_lock+0x12f/0x12f0 kernel/locking/mutex.c:733
       hci_connect_cfm include/net/bluetooth/hci_core.h:1561 [inline]
       hci_remote_features_evt+0x62b/0xa20 net/bluetooth/hci_event.c:3736
       hci_event_func net/bluetooth/hci_event.c:6890 [inline]
       hci_event_packet+0x7c1/0xf60 net/bluetooth/hci_event.c:6939
       hci_rx_work+0x522/0xd60 net/bluetooth/hci_core.c:3819
       process_one_work+0x996/0x1610 kernel/workqueue.c:2289
       worker_thread+0x665/0x1080 kernel/workqueue.c:2436
       kthread+0x2e9/0x3a0 kernel/kthread.c:376
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

-> #1 (&hdev->lock){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:600 [inline]
       __mutex_lock+0x12f/0x12f0 kernel/locking/mutex.c:733
       sco_sock_connect+0x1eb/0xa80 net/bluetooth/sco.c:593
       __sys_connect_file+0x14f/0x190 net/socket.c:1900
       __sys_connect+0x161/0x190 net/socket.c:1917
       __do_sys_connect net/socket.c:1927 [inline]
       __se_sys_connect net/socket.c:1924 [inline]
       __x64_sys_connect+0x6f/0xb0 net/socket.c:1924
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (sk_lock-AF_BLUETOOTH-BTPROTO_SCO){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3096 [inline]
       check_prevs_add kernel/locking/lockdep.c:3219 [inline]
       validate_chain kernel/locking/lockdep.c:3834 [inline]
       __lock_acquire+0x2abe/0x5660 kernel/locking/lockdep.c:5060
       lock_acquire kernel/locking/lockdep.c:5672 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5637
       lock_sock_nested+0x36/0xf0 net/core/sock.c:3312
       lock_sock include/net/sock.h:1682 [inline]
       sco_conn_del+0x131/0x2c0 net/bluetooth/sco.c:197
       sco_disconn_cfm+0x71/0xb0 net/bluetooth/sco.c:1379
       hci_disconn_cfm include/net/bluetooth/hci_core.h:1579 [inline]
       hci_conn_hash_flush+0x127/0x260 net/bluetooth/hci_conn.c:1458
       hci_dev_close_sync+0x567/0x1140 net/bluetooth/hci_sync.c:4121
       hci_dev_do_close+0x32/0x70 net/bluetooth/hci_core.c:553
       hci_unregister_dev+0x1d0/0x550 net/bluetooth/hci_core.c:2687
       vhci_release+0x7c/0xf0 drivers/bluetooth/hci_vhci.c:568
       __fput+0x277/0x9d0 fs/file_table.c:317
       task_work_run+0xdd/0x1a0 kernel/task_work.c:164
       exit_task_work include/linux/task_work.h:37 [inline]
       do_exit+0xaff/0x2a00 kernel/exit.c:795
       do_group_exit+0xd2/0x2f0 kernel/exit.c:925
       __do_sys_exit_group kernel/exit.c:936 [inline]
       __se_sys_exit_group kernel/exit.c:934 [inline]
       __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:934
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

Chain exists of:
  sk_lock-AF_BLUETOOTH-BTPROTO_SCO --> &hdev->lock --> hci_cb_list_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(hci_cb_list_lock);
                               lock(&hdev->lock);
                               lock(hci_cb_list_lock);
  lock(sk_lock-AF_BLUETOOTH-BTPROTO_SCO);

 *** DEADLOCK ***

3 locks held by syz-executor.4/21629:
 #0: ffff88801e84d048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close+0x2a/0x70 net/bluetooth/hci_core.c:551
 #1: ffff88801e84c078 (&hdev->lock){+.+.}-{3:3}, at: hci_dev_close_sync+0x26d/0x1140 net/bluetooth/hci_sync.c:4108
 #2: ffffffff8d76e388 (hci_cb_list_lock){+.+.}-{3:3}, at: hci_disconn_cfm include/net/bluetooth/hci_core.h:1576 [inline]
 #2: ffffffff8d76e388 (hci_cb_list_lock){+.+.}-{3:3}, at: hci_conn_hash_flush+0xda/0x260 net/bluetooth/hci_conn.c:1458

stack backtrace:
CPU: 1 PID: 21629 Comm: syz-executor.4 Not tainted 5.18.0-rc1-next-20220404-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2176
 check_prev_add kernel/locking/lockdep.c:3096 [inline]
 check_prevs_add kernel/locking/lockdep.c:3219 [inline]
 validate_chain kernel/locking/lockdep.c:3834 [inline]
 __lock_acquire+0x2abe/0x5660 kernel/locking/lockdep.c:5060
 lock_acquire kernel/locking/lockdep.c:5672 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5637
 lock_sock_nested+0x36/0xf0 net/core/sock.c:3312
 lock_sock include/net/sock.h:1682 [inline]
 sco_conn_del+0x131/0x2c0 net/bluetooth/sco.c:197
 sco_disconn_cfm+0x71/0xb0 net/bluetooth/sco.c:1379
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1579 [inline]
 hci_conn_hash_flush+0x127/0x260 net/bluetooth/hci_conn.c:1458
 hci_dev_close_sync+0x567/0x1140 net/bluetooth/hci_sync.c:4121
 hci_dev_do_close+0x32/0x70 net/bluetooth/hci_core.c:553
 hci_unregister_dev+0x1d0/0x550 net/bluetooth/hci_core.c:2687
 vhci_release+0x7c/0xf0 drivers/bluetooth/hci_vhci.c:568
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:37 [inline]
 do_exit+0xaff/0x2a00 kernel/exit.c:795
 do_group_exit+0xd2/0x2f0 kernel/exit.c:925
 __do_sys_exit_group kernel/exit.c:936 [inline]
 __se_sys_exit_group kernel/exit.c:934 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:934
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f677aa89049
Code: Unable to access opcode bytes at RIP 0x7f677aa8901f.
RSP: 002b:00007ffc2aa139c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000064 RCX: 00007f677aa89049
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 00007f677aae225c R08: 000000000000000c R09: 00005555561573b8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000016
R13: 00007ffc2aa14ca0 R14: 00005555561573b8 R15: 00007ffc2aa15da0
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
