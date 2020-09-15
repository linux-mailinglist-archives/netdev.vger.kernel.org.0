Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F71B26A665
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 15:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgIONjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 09:39:16 -0400
Received: from mail-il1-f205.google.com ([209.85.166.205]:55595 "EHLO
        mail-il1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgIONbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 09:31:22 -0400
Received: by mail-il1-f205.google.com with SMTP id a15so2547506ilb.22
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 06:31:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=R6F5UwQzAqDsyMJgAvZ/3rO3cWoUQC8/oKLPsHRwguc=;
        b=bvAaqV5iX0oH+6re10b4QxyxetoK7ZDOknSP4NsSVktTet9RBuZDsTO0Dv3td9qtbG
         DnzRHdXPwqg6NDEm0rEjYK0Yb33PogRE+QJyt0vY9Sf50NVcLFSKH6t+blRNyEM1c2iW
         7n2wX0Ym/CI33NKRmUo+SQBMjhfkqs1TcwqXSNqdPQcaG9B/onNoniS4l7eml2kNSUgE
         A8lnM0WMCHef2DcEP/ztroIPofFNf7mv5p81vEb3iHKs0sQMVwTzKO6oc6xLpSvAssTR
         d88wYBJQZxEFdbptcmQXHwD4oq+EEgATpJt44LymMrjxqJscNnVr/DNypSJDA+2aT2Ag
         oIJg==
X-Gm-Message-State: AOAM530Qq6Qdir1tvck+a80orU0EvJhrTe3Pn3Z32da9veG+E/SSjN8R
        kJvVcWGl+Jdk4QUToNAb8tZGR3smRWkG4p6hWzYhYBrYq6jR
X-Google-Smtp-Source: ABdhPJwAKx8EF28Y9V+TVQekJ8oBefFslpQdi9lYC3LczdnKT1IsaLOgwmuIWHylfceSwqiGxiK+LUVEPoYRxTp5ILkO3E71BDZ7
MIME-Version: 1.0
X-Received: by 2002:a92:c049:: with SMTP id o9mr15837733ilf.193.1600176140989;
 Tue, 15 Sep 2020 06:22:20 -0700 (PDT)
Date:   Tue, 15 Sep 2020 06:22:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000763b8805af5a0a39@google.com>
Subject: WARNING: refcount bug in pde_put
From:   syzbot <syzbot+7e016eb6104c62c4ac86@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    581cb3a2 Merge tag 'f2fs-for-5.9-rc5' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17796c01900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a9075b36a6ae26c9
dashboard link: https://syzkaller.appspot.com/bug?extid=7e016eb6104c62c4ac86
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7e016eb6104c62c4ac86@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 455 at lib/refcount.c:28 refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 455 Comm: syz-executor.5 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x347/0x7c0 kernel/panic.c:231
 __warn.cold+0x20/0x46 kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Code: e9 db fe ff ff 48 89 df e8 5c dd 18 fe e9 8a fe ff ff e8 f2 d6 d8 fd 48 c7 c7 60 dc 93 88 c6 05 bd 0c 12 07 01 e8 e1 d7 a9 fd <0f> 0b e9 af fe ff ff 0f 1f 84 00 00 00 00 00 41 56 41 55 41 54 55
RSP: 0018:ffffc900118af8a8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff815db9a7 RDI: fffff52002315f07
RBP: 0000000000000003 R08: 0000000000000001 R09: ffff8880ae6318e7
R10: 0000000000000000 R11: 0000000035353454 R12: ffff888000101c84
R13: ffff888000101d38 R14: dffffc0000000000 R15: fffffbfff151600c
 refcount_sub_and_test include/linux/refcount.h:274 [inline]
 refcount_dec_and_test include/linux/refcount.h:294 [inline]
 pde_put+0x178/0x1e0 fs/proc/generic.c:659
 remove_proc_entry+0x1de/0x460 fs/proc/generic.c:703
 ipmr_net_exit+0x75/0x100 net/ipv4/ipmr.c:3089
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:186
 setup_net+0x502/0x850 net/core/net_namespace.c:364
 copy_net_ns+0x2cf/0x5e0 net/core/net_namespace.c:482
 create_new_namespaces+0x3f6/0xb10 kernel/nsproxy.c:110
 copy_namespaces+0x385/0x470 kernel/nsproxy.c:179
 copy_process+0x294b/0x6920 kernel/fork.c:2072
 _do_fork+0xe8/0xb10 kernel/fork.c:2428
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2545
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d5b9
Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f2e23071c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 0000000000001fc0 RCX: 000000000045d5b9
RDX: 9999999999999999 RSI: 0000000000000000 RDI: 00000000e1004d7c
RBP: 000000000118cf90 R08: ffffffffffffffff R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 000000000169fb6f R14: 00007f2e230729c0 R15: 000000000118cf4c
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
