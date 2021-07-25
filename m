Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE02A3D4E5D
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 17:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhGYPSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 11:18:55 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:40678 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhGYPSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 11:18:54 -0400
Received: by mail-il1-f197.google.com with SMTP id y6-20020a92d0c60000b029020757e7bf9fso3540679ila.7
        for <netdev@vger.kernel.org>; Sun, 25 Jul 2021 08:59:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wzNrsxtn9JCSe5puGyPKBo5plRJ8+W+s12Wnu02BBeE=;
        b=Zm0I+7XPGsY/0E+TiRXVuCXI7mmWt4tdNcqt0eFVXpXzriqHQeloWc/FRzWAUNGpX4
         Jkihss4LkdBlwYYntPxX1jO/00U0WpdaBEvTPU0zPXUomECRIyjAsGRi5sVMBPszYOLL
         SuGrdtkG12kCjTaQV+K7JWnptLjjYdLq2LhNNq1rekocuPKE4jsalPtmPttOgsS98r9+
         XrsE5I3vRUY5yPtP8htOH+QKdG/+0SnB+U5Jwcf6MnqQBCy/pcg5D6Zz8vx2ndhu6kOy
         jZz0MxTJUFMKHZ4+I6uu9V29qhh7QG4tqiftS85ieKabDuZ02N3ZK6paBbm/OZ8SefRc
         WeUw==
X-Gm-Message-State: AOAM533VdXz0QThky7Tq90hrXEwlIMbUfAK0rZJvdz1fqq/n0Zx/Udo1
        op8MON/M2nPMx2uE5POLmiHYZPorIwP+asKRnvn6J077Aj0B
X-Google-Smtp-Source: ABdhPJwgfB5+7N9VIhxhwXZD2TncIf3jizRAN+7Qda+YQiQFwrqw3fxedyk1E8Div/9iF1hv1lEU27MxloWiHQmaS1PicDgVdg3I
MIME-Version: 1.0
X-Received: by 2002:a02:9508:: with SMTP id y8mr12657702jah.28.1627228764967;
 Sun, 25 Jul 2021 08:59:24 -0700 (PDT)
Date:   Sun, 25 Jul 2021 08:59:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000081183b05c7f4b8c5@google.com>
Subject: [syzbot] bpf-next test error: BUG: sleeping function called from
 invalid context in stack_depot_save
From:   syzbot <syzbot+f5087f6afc6f49d80566@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    807b8f0e24e6 Merge branch 'libbpf: btf typed data dumping ..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17ccd0d4300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=da140227e4f25b17
dashboard link: https://syzkaller.appspot.com/bug?extid=f5087f6afc6f49d80566
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f5087f6afc6f49d80566@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at mm/page_alloc.c:5167
in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 8437, name: syz-fuzzer
INFO: lockdep is turned off.
irq event stamp: 0
hardirqs last  enabled at (0): [<0000000000000000>] 0x0
hardirqs last disabled at (0): [<ffffffff8143fb5d>] copy_process+0x1dcd/0x7510 kernel/fork.c:2061
softirqs last  enabled at (0): [<ffffffff8143fb9e>] copy_process+0x1e0e/0x7510 kernel/fork.c:2065
softirqs last disabled at (0): [<0000000000000000>] 0x0
CPU: 1 PID: 8437 Comm: syz-fuzzer Tainted: G        W         5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:9154
 prepare_alloc_pages+0x3da/0x580 mm/page_alloc.c:5167
 __alloc_pages+0x12f/0x500 mm/page_alloc.c:5363
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
 stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
 save_stack+0x15e/0x1e0 mm/page_owner.c:120
 __set_page_owner+0x50/0x290 mm/page_owner.c:181
 prep_new_page mm/page_alloc.c:2433 [inline]
 __alloc_pages_bulk+0x8b9/0x1870 mm/page_alloc.c:5301
 alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
 vm_area_alloc_pages mm/vmalloc.c:2793 [inline]
 __vmalloc_area_node mm/vmalloc.c:2863 [inline]
 __vmalloc_node_range+0x39d/0x960 mm/vmalloc.c:2966
 __vmalloc_node mm/vmalloc.c:3015 [inline]
 vzalloc+0x67/0x80 mm/vmalloc.c:3085
 n_tty_open+0x16/0x170 drivers/tty/n_tty.c:1848
 tty_ldisc_open+0x9b/0x110 drivers/tty/tty_ldisc.c:449
 tty_ldisc_setup+0x90/0x100 drivers/tty/tty_ldisc.c:776
 tty_init_dev.part.0+0x1f4/0x610 drivers/tty/tty_io.c:1453
 tty_init_dev+0x5b/0x80 drivers/tty/tty_io.c:1419
 ptmx_open drivers/tty/pty.c:834 [inline]
 ptmx_open+0x112/0x360 drivers/tty/pty.c:800
 chrdev_open+0x266/0x770 fs/char_dev.c:414
 do_dentry_open+0x4c8/0x11d0 fs/open.c:826
 do_open fs/namei.c:3374 [inline]
 path_openat+0x1c23/0x27f0 fs/namei.c:3507
 do_filp_open+0x1aa/0x400 fs/namei.c:3534
 do_sys_openat2+0x16d/0x420 fs/open.c:1204
 do_sys_open fs/open.c:1220 [inline]
 __do_sys_openat fs/open.c:1236 [inline]
 __se_sys_openat fs/open.c:1231 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1231
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4af20a
Code: e8 3b 82 fb ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 4c 8b 54 24 28 4c 8b 44 24 30 4c 8b 4c 24 38 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 40 ff ff ff ff 48 c7 44 24 48
RSP: 002b:000000c0002ff3f8 EFLAGS: 00000216 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 000000c00001e800 RCX: 00000000004af20a
RDX: 0000000000000000 RSI: 000000c0001a98d0 RDI: ffffffffffffff9c
RBP: 000000c0002ff470 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000216 R12: 000000000000018e
R13: 000000000000018d R14: 0000000000000200 R15: 000000c0002aa000
can: request_module (can-proto-0) failed.
can: request_module (can-proto-0) failed.
can: request_module (can-proto-0) failed.


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
