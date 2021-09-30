Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5ED841DB18
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351462AbhI3NcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:32:02 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:36740 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351464AbhI3NcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 09:32:00 -0400
Received: by mail-io1-f70.google.com with SMTP id o19-20020a0566022e1300b005d66225622dso5868542iow.3
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 06:30:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=uOUIkwSqXsHUz22QAwCD8teZ8Qa66munAvVJYiu3USM=;
        b=68AWagKGAE9I6MbAfiFL6GHOaZLe1so9dc2EpCnJziWkgm8oUmOj0D/daAJfQTt2E6
         2bjM5DazDWqz+TPvrq9ruTORZRW1XG6EFec6oPyhrdFGcJm0twXI+OP+sq2ld6Jc869j
         LTfmP+LYcjfuDTREqMjx4wx80+CL98Z0nGPP3H+yoG72h0pcTnGQRU+SmeJsczwM1fEi
         woyhMwaEGhe9je5c9y0++94IqP23pMRLVwC8ufTIoeIJmfinrDPjvUqM1xF/Nye3wizD
         T58DyKIKI4J9hmmMl++O9vUaYI1SeJ1laQvERmmnZ4xiN+Ud78JW6Fqnbf7LcebEBr/u
         NNQQ==
X-Gm-Message-State: AOAM530054ydAZQ82Ba3nkOFgjB/ECixuvXFk4LZOS1D+34JqfAlZeqI
        N7lJRx4n9yOqGIxteYEq5MLlbQw1UBHIE4VrmR2UHHnc5ACj
X-Google-Smtp-Source: ABdhPJxuESSAZaVGFwsofN7m0Tto/CFvmTFTzbZlIHl48VOYxeADPGxOgb37gXdyeYCeOiSmyLCk7ODRU580ognkelAkVucPExdV
MIME-Version: 1.0
X-Received: by 2002:a6b:5114:: with SMTP id f20mr3982006iob.97.1633008618003;
 Thu, 30 Sep 2021 06:30:18 -0700 (PDT)
Date:   Thu, 30 Sep 2021 06:30:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000097631805cd367200@google.com>
Subject: [syzbot] WARNING: locking bug in sco_conn_del
From:   syzbot <syzbot+cd697685f3b1d78acd79@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a3b397b4fffb Merge branch 'akpm' (patches from Andrew)
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15c28837300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6826c0a4e4b4e294
dashboard link: https://syzkaller.appspot.com/bug?extid=cd697685f3b1d78acd79
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cd697685f3b1d78acd79@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 0 PID: 7578 at kernel/locking/lockdep.c:203 hlock_class kernel/locking/lockdep.c:203 [inline]
WARNING: CPU: 0 PID: 7578 at kernel/locking/lockdep.c:203 hlock_class kernel/locking/lockdep.c:192 [inline]
WARNING: CPU: 0 PID: 7578 at kernel/locking/lockdep.c:203 check_wait_context kernel/locking/lockdep.c:4688 [inline]
WARNING: CPU: 0 PID: 7578 at kernel/locking/lockdep.c:203 __lock_acquire+0x1344/0x54a0 kernel/locking/lockdep.c:4965
Modules linked in:
CPU: 0 PID: 7578 Comm: syz-executor.4 Not tainted 5.15.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:hlock_class kernel/locking/lockdep.c:203 [inline]
RIP: 0010:hlock_class kernel/locking/lockdep.c:192 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4688 [inline]
RIP: 0010:__lock_acquire+0x1344/0x54a0 kernel/locking/lockdep.c:4965
Code: 08 84 d2 0f 85 f1 3d 00 00 8b 05 3f 72 13 0c 85 c0 0f 85 f4 fd ff ff 48 c7 c6 40 04 8c 89 48 c7 c7 00 f8 8b 89 e8 09 60 97 07 <0f> 0b 31 ed e9 b7 f0 ff ff e8 ae a1 7b 02 85 c0 0f 84 12 fe ff ff
RSP: 0018:ffffc9000a697770 EFLAGS: 00010086
RAX: 0000000000000000 RBX: ffff88802fcf3120 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff815dbd98 RDI: fffff520014d2ee0
RBP: 0000000000001877 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815d5b3e R11: 0000000000000000 R12: ffff88807355c398
R13: ffff88807355b900 R14: 0000000000040000 R15: 0000000000041877
FS:  00007fc7fb487700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1facaf4018 CR3: 000000001ce35000 CR4: 0000000000350ef0
Call Trace:
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 lock_sock_nested+0x2f/0xf0 net/core/sock.c:3183
 lock_sock include/net/sock.h:1612 [inline]
 sco_conn_del+0x12a/0x2b0 net/bluetooth/sco.c:194
 sco_disconn_cfm+0x71/0xb0 net/bluetooth/sco.c:1205
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1518 [inline]
 hci_conn_hash_flush+0x127/0x260 net/bluetooth/hci_conn.c:1608
 hci_dev_do_close+0x57d/0x1130 net/bluetooth/hci_core.c:1793
 hci_rfkill_set_block+0x19c/0x1d0 net/bluetooth/hci_core.c:2233
 rfkill_set_block+0x1f9/0x540 net/rfkill/core.c:344
 rfkill_fop_write+0x267/0x500 net/rfkill/core.c:1268
 do_loop_readv_writev fs/read_write.c:753 [inline]
 do_loop_readv_writev fs/read_write.c:737 [inline]
 do_iter_write+0x4f8/0x710 fs/read_write.c:857
 vfs_writev+0x1aa/0x630 fs/read_write.c:928
 do_writev+0x27f/0x300 fs/read_write.c:971
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fc7fdf10709
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc7fb487188 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 00007fc7fe014f60 RCX: 00007fc7fdf10709
RDX: 0000000000000001 RSI: 0000000020000000 RDI: 0000000000000006
RBP: 00007fc7fdf6acb4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe9a33e8ff R14: 00007fc7fb487300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
