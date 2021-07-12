Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C1C3C43A7
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 07:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhGLF4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 01:56:14 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39582 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhGLF4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 01:56:11 -0400
Received: by mail-io1-f69.google.com with SMTP id v2-20020a5d94020000b02905058dc6c376so11006652ion.6
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 22:53:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=rucIRG+rJM2kAVtylvEaboYRDE8LJ59FJGFLr5vx5ME=;
        b=evMEvQGGPkr4ixO0MPyGTKmTb6jWnF5DYTQh0TUbfhrU2PN/HkiE5CwTbqL9Gk7Vn3
         z5Z3Iqe2LpMixnkTY0iSs+vlp6ae7OIzY4MRwjxC77KpB9NS0m92q/s5j5l+rwVz8IV/
         X1bGcCU8VnTvC+SgdEed2gc8gtZ1MRvO05i1t3gsnT9ZHvSkGpCex+c96YYe0MLxiE5O
         TVvnV9reGnhZBM48/XuYJePW9HG89EYkVz1gwAt1YhKMCQGKKvVnBmaGFRSSlEE0MJ51
         lTB97BL94Op2Qcjb1XxI4goihVa+2GZb+39KrE/Nk2RDbklfQ02cUTJqUEkL5VRsKXZx
         PnDw==
X-Gm-Message-State: AOAM531ZB8l8G/Y6S8UtpYjHC7QfwctjSzPhkorYEsDJlVzRiiPKRkBp
        YuVeLadHw/69J5cmpHSCbk4yOCFF/tEls+lruLjkuHuBHvGf
X-Google-Smtp-Source: ABdhPJzTc2q7sGI6Ya7YCEATLlXLaPWbWV0mQggZmhOVApyk8rfRsqtnvbnjtZdWzbnol7ASaWdJ/HGfg7dspf0MBUps7Bo1Txxl
MIME-Version: 1.0
X-Received: by 2002:a5d:974f:: with SMTP id c15mr36598921ioo.190.1626069203437;
 Sun, 11 Jul 2021 22:53:23 -0700 (PDT)
Date:   Sun, 11 Jul 2021 22:53:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000404a4a05c6e6bd4c@google.com>
Subject: [syzbot] WARNING: refcount bug in l2cap_sock_kill
From:   syzbot <syzbot+845954aabaa368d3ef45@syzkaller.appspotmail.com>
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

HEAD commit:    5e437416 Merge branch 'dsa-mv88e6xxx-topaz-fixes'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=112445d8300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4cb84363d46e9fc3
dashboard link: https://syzkaller.appspot.com/bug?extid=845954aabaa368d3ef45

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+845954aabaa368d3ef45@syzkaller.appspotmail.com

refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 8496 at lib/refcount.c:28 refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Modules linked in:
CPU: 1 PID: 8496 Comm: syz-executor.5 Tainted: G        W         5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Code: e9 db fe ff ff 48 89 df e8 0c 90 e8 fd e9 8a fe ff ff e8 32 f1 a2 fd 48 c7 c7 a0 25 e3 89 c6 05 84 0c 84 09 01 e8 ec c0 0b 05 <0f> 0b e9 af fe ff ff 0f 1f 84 00 00 00 00 00 41 56 41 55 41 54 55
RSP: 0018:ffffc9000178fa88 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801a591c40 RSI: ffffffff815d7235 RDI: fffff520002f1f43
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815d109e R11: 0000000000000000 R12: ffff88806ca9b080
R13: dffffc0000000000 R14: ffff88806977c4b8 R15: 0000000000000067
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f516584b718 CR3: 000000002e987000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __refcount_sub_and_test include/linux/refcount.h:283 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 sock_put include/net/sock.h:1812 [inline]
 l2cap_sock_kill+0x153/0x240 net/bluetooth/l2cap_sock.c:1227
 l2cap_conn_del+0x3fc/0x7b0 net/bluetooth/l2cap_core.c:1900
 l2cap_disconn_cfm net/bluetooth/l2cap_core.c:8177 [inline]
 l2cap_disconn_cfm+0x95/0xd0 net/bluetooth/l2cap_core.c:8170
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1500 [inline]
 hci_conn_hash_flush+0x127/0x260 net/bluetooth/hci_conn.c:1608
 hci_dev_do_close+0x528/0x1130 net/bluetooth/hci_core.c:1778
 hci_unregister_dev+0x263/0x1130 net/bluetooth/hci_core.c:4019
 vhci_release+0x70/0xe0 drivers/bluetooth/hci_vhci.c:340
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xbd4/0x2a50 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: Unable to access opcode bytes at RIP 0x4665af.
RSP: 002b:00007fff2d0a39f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000000007d0 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000043
RBP: 0000000000000000 R08: 0000000000000014 R09: 00000000000007d0
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004bfe04
R13: 0000000000000000 R14: 0000000000000009 R15: 00007fff2d0a3bf0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
