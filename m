Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1299B16A031
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgBXIi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:38:27 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:50811 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbgBXIiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 03:38:14 -0500
Received: by mail-io1-f69.google.com with SMTP id e13so14193236iob.17
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 00:38:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=EZ7jDUHxaFXpH3SIZZeA1xwvBDqCFzmxRKIrCIr4NWU=;
        b=RmR0fEQLqn6axqJBYfWJq8rOEfPtxoNzR8AYayKU8W1VTioAycyDuGTO+1c/107ZDz
         hJgHsrACjC2zd9ZbgqMeICIdYQ8141paM2t+FrnH6G4Iy18rKb2rVIz8o3dP1TtOkrg4
         UE8F2FWOiS7mnhRPXtLNNc939B3OCWX/Ecz3nYY5ZTRc3XvvABZJwEDG7Bt6d5WI12z/
         dAB2SwyxjnNcgjG2w6RoRT2uGFDaQ7fnF36YGmYu2CsBxp0TZA5p3HLCbIzfjJOnbCNM
         rSUy5yniFp8zqzcmbgllclGPVkqyIHrivmGUT0hMeXB1+5399J9T/jdYl8fow76/lLz8
         DmCA==
X-Gm-Message-State: APjAAAV7JMsafEPLqoFedNosG3WJ+/NBmmdtMQYDipXrMCtT2QwAT5UD
        AeTufgmr0pKpO6Ox07naMjKoQQejI51p03e85kthqLKqZr5l
X-Google-Smtp-Source: APXvYqxEdgdbJHGcOIAGha4yJb07y3J6Ie8VKae3Oi3/LyjLw+wYFUqWmtCrHhh0v0m/eTDzuz3QmZbAPb8QOC+ciYMzNJ8zbGu9
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1301:: with SMTP id h1mr48375829iov.5.1582533493950;
 Mon, 24 Feb 2020 00:38:13 -0800 (PST)
Date:   Mon, 24 Feb 2020 00:38:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c0910e059f4e4a82@google.com>
Subject: KMSAN: uninit-value in br_dev_xmit
From:   syzbot <syzbot+18c8b623c66fc198c493@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, davem@davemloft.net,
        glider@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    8bbbc5cf kmsan: don't compile memmove
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=14d9a3d9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cd0e9a6b0e555cc3
dashboard link: https://syzkaller.appspot.com/bug?extid=18c8b623c66fc198c493
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
userspace arch: i386

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+18c8b623c66fc198c493@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in br_dev_xmit+0x99a/0x1730 net/bridge/br_device.c:64
CPU: 0 PID: 14704 Comm: syz-executor.1 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 br_dev_xmit+0x99a/0x1730 net/bridge/br_device.c:64
 __netdev_start_xmit include/linux/netdevice.h:4524 [inline]
 netdev_start_xmit include/linux/netdevice.h:4538 [inline]
 xmit_one net/core/dev.c:3470 [inline]
 dev_hard_start_xmit+0x531/0xab0 net/core/dev.c:3486
 __dev_queue_xmit+0x37de/0x4220 net/core/dev.c:4063
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4096
 __bpf_tx_skb net/core/filter.c:2061 [inline]
 __bpf_redirect_common net/core/filter.c:2100 [inline]
 __bpf_redirect+0x11d5/0x1440 net/core/filter.c:2107
 ____bpf_clone_redirect net/core/filter.c:2140 [inline]
 bpf_clone_redirect+0x466/0x620 net/core/filter.c:2112
 bpf_prog_a481c1313990ee2c+0x5e0/0x1000
 bpf_dispatcher_nopfunc include/linux/bpf.h:521 [inline]
 bpf_test_run+0x60c/0xe50 net/bpf/test_run.c:48
 bpf_prog_test_run_skb+0xcab/0x24a0 net/bpf/test_run.c:388
 bpf_prog_test_run kernel/bpf/syscall.c:2572 [inline]
 __do_sys_bpf+0xa684/0x13510 kernel/bpf/syscall.c:3414
 __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
 __ia32_sys_bpf+0xdb/0x120 kernel/bpf/syscall.c:3355
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3c7/0x6e0 arch/x86/entry/common.c:410
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f79d99
Code: 90 e8 0b 00 00 00 f3 90 0f ae e8 eb f9 8d 74 26 00 89 3c 24 c3 90 90 90 90 90 90 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f5d740cc EFLAGS: 00000296 ORIG_RAX: 0000000000000165
RAX: ffffffffffffffda RBX: 000000000000000a RCX: 0000000020000140
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:82
 slab_alloc_node mm/slub.c:2793 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4401
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 pskb_expand_head+0x20b/0x1b00 net/core/skbuff.c:1629
 skb_ensure_writable+0x3ea/0x490 net/core/skbuff.c:5453
 __bpf_try_make_writable net/core/filter.c:1635 [inline]
 bpf_try_make_writable net/core/filter.c:1641 [inline]
 bpf_try_make_head_writable net/core/filter.c:1649 [inline]
 ____bpf_clone_redirect net/core/filter.c:2134 [inline]
 bpf_clone_redirect+0x251/0x620 net/core/filter.c:2112
 bpf_prog_a481c1313990ee2c+0x5e0/0x1000
 bpf_dispatcher_nopfunc include/linux/bpf.h:521 [inline]
 bpf_test_run+0x60c/0xe50 net/bpf/test_run.c:48
 bpf_prog_test_run_skb+0xcab/0x24a0 net/bpf/test_run.c:388
 bpf_prog_test_run kernel/bpf/syscall.c:2572 [inline]
 __do_sys_bpf+0xa684/0x13510 kernel/bpf/syscall.c:3414
 __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
 __ia32_sys_bpf+0xdb/0x120 kernel/bpf/syscall.c:3355
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3c7/0x6e0 arch/x86/entry/common.c:410
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
