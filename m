Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CF14527FF
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 03:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241486AbhKPCwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 21:52:22 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:57033 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356309AbhKPCuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 21:50:20 -0500
Received: by mail-il1-f197.google.com with SMTP id h14-20020a056e021d8e00b002691dcecdbaso11739918ila.23
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 18:47:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=DHz4tYl7fmFr21ztJVimAN7NjI6wBKI+gvZVUU1J4Fc=;
        b=ZZ8fdeymkQPRUa0pPDav+SxRI98MBPEYeaiEAnF6dixQTWPRU7QcWuywc6rJNGuKry
         we++GXMuLkvugW68q4r/i1Z1tV3DdTeXwPdYRKgR/1j+OIFevApF8OsKzROiL5QpClpn
         ODF/1IEzTlDkK7b7M7dQiMujLQXaJaUiG+LUuEvkhhzREwzFhPT9JvRD4/OH5ocat54/
         +c9MWPDdKWZDHsHJBojhKe+x0sqFgemfncb3rsHxYDpm3fK2JITmQrYNhrZdchez4zzf
         UElvZWT0b5tUjqDcaf5sUlrF+t2EphsKHnIRaqmAopA444YJrGAnKRtEYnCZbO8Dtuah
         tlFQ==
X-Gm-Message-State: AOAM531jsiDobgqc3F8fzsRXQWynBZ2lYkr85DHjuDgNA3FXYhdKtjYQ
        zPv1jBYgCkeBtMJT8MhDI3xbdT89X8joK4K6BHLnWBG39yrb
X-Google-Smtp-Source: ABdhPJwn76R14uPMgDJvWEqy3Z5Fo+P1OY81YVX4+dP+6QBLaeYoXkp8z60PC2jcROikO4vB1PfWeK8W+2pDkagPj43ABNnD/SGw
MIME-Version: 1.0
X-Received: by 2002:a92:c5cc:: with SMTP id s12mr2351600ilt.239.1637030842559;
 Mon, 15 Nov 2021 18:47:22 -0800 (PST)
Date:   Mon, 15 Nov 2021 18:47:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000db71f005d0def148@google.com>
Subject: [syzbot] INFO: trying to register non-static key in nr_release
From:   syzbot <syzbot+877d38583024775941be@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ca2ef2d9f2aa Merge tag 'kcsan.2021.11.11a' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15860f8ab00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcce4e862d74e466
dashboard link: https://syzkaller.appspot.com/bug?extid=877d38583024775941be
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+877d38583024775941be@syzkaller.appspotmail.com

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 1 PID: 6116 Comm: syz-executor.0 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 assign_lock_key kernel/locking/lockdep.c:951 [inline]
 register_lock_class+0xf79/0x10c0 kernel/locking/lockdep.c:1263
 __lock_acquire+0x105/0x54a0 kernel/locking/lockdep.c:4906
 lock_acquire kernel/locking/lockdep.c:5637 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
 __raw_write_lock_bh include/linux/rwlock_api_smp.h:201 [inline]
 _raw_write_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:324
 sock_orphan include/net/sock.h:1968 [inline]
 nr_release+0xc2/0x450 net/netrom/af_netrom.c:521
 __sock_release+0xcd/0x280 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1314
 __fput+0x286/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xc14/0x2b40 kernel/exit.c:832
 do_group_exit+0x125/0x310 kernel/exit.c:929
 get_signal+0x47d/0x2220 kernel/signal.c:2830
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f53b3d53ae9
Code: Unable to access opcode bytes at RIP 0x7f53b3d53abf.
RSP: 002b:00007f53b1287218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f53b3e670e8 RCX: 00007f53b3d53ae9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f53b3e670e8
RBP: 00007f53b3e670e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f53b3e670ec
R13: 00007fff58d6162f R14: 00007f53b1287300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
