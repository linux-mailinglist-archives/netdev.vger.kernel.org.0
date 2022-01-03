Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB9B483552
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbiACRHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:07:24 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:49725 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiACRHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:07:23 -0500
Received: by mail-il1-f197.google.com with SMTP id r12-20020a056e0219cc00b002b52dee3ee1so14509517ill.16
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 09:07:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5kB4JwrWnI9ddxNMVXxtodJTq/JfLyUnW8oK2aRYGM0=;
        b=JfhUNvefn4B8Buij/jxNuU9O9WLnNMvXEkgvpYLB7EFhzXIf5tRGLSp7W40giT15Wq
         L6ZutBm1FP8Ul8gjuC+rkgfpwXanYeC8noxEyMiRU52mjRnmYDbGLiGhM/zMQroDHyhy
         hJxYARsg10BKQ87b9JtTpcpDwAx8Qq9rpvqEPqxKeVjesuwGcyax0PmM72tJiFbSx6sE
         /MeVBvAqyF0Pe4d9WG4cPxvL/M9wdp40pboE51B5K2TFGy8N1vW/u6EY+7LRVDffHwfd
         +Aw21hCch6qeXz6dDN7FYUYVYfaN73URpm8JdcQAqpX1/3nzyuViYgYUaBcv7kpniu+N
         a21g==
X-Gm-Message-State: AOAM530s6XB/2S21Urcouewa7ZQ1RchA65pa9Ung/X1eW2EPwVMWTJYf
        L5lMG58GbjumRkkPOneViGNUi6CpurlF6idFguvvrrj2p86O
X-Google-Smtp-Source: ABdhPJzDaqlybMEylt1i1tatamne0ctP939e4BrjyCLYoCA+3JkBDf3Kt8suaCD9R+y7uDJ9ZxRjeYMBzEgzyukahBBsOk0xn101
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18ca:: with SMTP id s10mr21423744ilu.305.1641229642239;
 Mon, 03 Jan 2022 09:07:22 -0800 (PST)
Date:   Mon, 03 Jan 2022 09:07:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d2127105d4b08da5@google.com>
Subject: [syzbot] WARNING: ODEBUG bug in hci_release_dev
From:   syzbot <syzbot+c10c909f9ddcd29c11ac@syzkaller.appspotmail.com>
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

HEAD commit:    438645193e59 Merge tag 'pinctrl-v5.16-3' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=101babebb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=48863e33ecce99a5
dashboard link: https://syzkaller.appspot.com/bug?extid=c10c909f9ddcd29c11ac
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c10c909f9ddcd29c11ac@syzkaller.appspotmail.com

ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x90 kernel/workqueue.c:1624
WARNING: CPU: 1 PID: 13508 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 1 PID: 13508 Comm: syz-executor.3 Not tainted 5.16.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd c0 37 05 8a 4c 89 ee 48 c7 c7 c0 2b 05 8a e8 9f 20 22 05 <0f> 0b 83 05 95 c9 b1 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc90002c2fa40 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff88801c483a00 RSI: ffffffff815f1258 RDI: fffff52000585f3a
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815eaffe R11: 0000000000000000 R12: ffffffff89adf5e0
R13: ffffffff8a053200 R14: ffffffff81660770 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9cd44481b8 CR3: 000000001838d000 CR4: 0000000000350ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Call Trace:
 <TASK>
 __debug_check_no_obj_freed lib/debugobjects.c:992 [inline]
 debug_check_no_obj_freed+0x301/0x420 lib/debugobjects.c:1023
 slab_free_hook mm/slub.c:1698 [inline]
 slab_free_freelist_hook+0xeb/0x1c0 mm/slub.c:1749
 slab_free mm/slub.c:3513 [inline]
 kfree+0xf6/0x560 mm/slub.c:4561
 hci_release_dev+0x7a8/0xb70 net/bluetooth/hci_core.c:3970
 bt_host_release+0x73/0x90 net/bluetooth/hci_sysfs.c:88
 device_release+0x9f/0x240 drivers/base/core.c:2230
 kobject_cleanup lib/kobject.c:705 [inline]
 kobject_release lib/kobject.c:736 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:753
 put_device+0x1b/0x30 drivers/base/core.c:3501
 vhci_release+0x78/0xe0 drivers/bluetooth/hci_vhci.c:463
 __fput+0x286/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xc14/0x2b40 kernel/exit.c:832
 do_group_exit+0x125/0x310 kernel/exit.c:929
 __do_sys_exit_group kernel/exit.c:940 [inline]
 __se_sys_exit_group kernel/exit.c:938 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:938
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7ff4b88fee99
Code: Unable to access opcode bytes at RIP 0x7ff4b88fee6f.
RSP: 002b:00007ffd58ed1578 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000064 RCX: 00007ff4b88fee99
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 00007ff4b89581e4 R08: 000000000000000c R09: 0000555556f033bc
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000016
R13: 00007ffd58ed2850 R14: 0000555556f033bc R15: 00007ffd58ed3950
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
