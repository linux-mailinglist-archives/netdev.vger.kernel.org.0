Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B57F20C432
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 22:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgF0U5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 16:57:15 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:38208 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgF0U5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 16:57:14 -0400
Received: by mail-io1-f71.google.com with SMTP id l13so8590394ioj.5
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 13:57:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=5xC+1jVF3EFdPXee+JUcI1eZasghwwzg/7CHmkD9K6E=;
        b=CGl4ZfLB9Ed91zreg4ep2FgxLk/fXN9Q7wocl+roWNyC2A5p0kXVLkLDV86ylr1h2t
         f6Cwai2qBMmiWEcHZ1BGv2+8LsFcbh7rylXYM3XQQ98x/BUm6PLLqM9Q68wrh4ZDlq4e
         JP9e/O1L4SqS88ZL+qxT1M4QZgYGhTyEuEu0qQe3+IWE0av9v18WzZg6Z7wviDnOQOsw
         SL1axkYF4Rci/f3PM/a+5s7TNih9OzApYO1qIZfVwUQfPxo99P1L1cQ2XZPXaTR9UUqB
         avCFV7//6qKrVOTXuKaEMEyzofjxvi5MTtc2tIJ2/e3ocAMnEJVFTEeR9BVuFQC/nnJx
         eCFQ==
X-Gm-Message-State: AOAM530JUPhElSwQJRufTb+OVY8qs+bHYtejDsLruvuVJcapD1e1e8eo
        ZO4Z/s7SC3JkztfQShgTQcQfDqC4dUcNuxkHNkvAXco2w005
X-Google-Smtp-Source: ABdhPJwC0WUoq/eVSmcIFNMSwad5MG1Yo/9RIyJjJ5tZC2biApe7rg9EZWQ+jQafOFyLt3cLG1YdRUB0zamotKn4uS2CwmFf28w5
MIME-Version: 1.0
X-Received: by 2002:a02:c906:: with SMTP id t6mr9964423jao.35.1593291433317;
 Sat, 27 Jun 2020 13:57:13 -0700 (PDT)
Date:   Sat, 27 Jun 2020 13:57:13 -0700
In-Reply-To: <000000000000f728fc05a90ce9c9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e817ba05a91711b0@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in qrtr_endpoint_post
From:   syzbot <syzbot+b8fe393f999a291a9ea6@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    1590a2e1 Merge tag 'acpi-5.8-rc3' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14b2b503100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf3aec367b9ab569
dashboard link: https://syzkaller.appspot.com/bug?extid=b8fe393f999a291a9ea6
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=109e6b55100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13671a3d100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b8fe393f999a291a9ea6@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in qrtr_endpoint_post+0xeeb/0x1010 net/qrtr/qrtr.c:462
Read of size 2 at addr ffff88809de50c48 by task syz-executor531/6806

CPU: 0 PID: 6806 Comm: syz-executor531 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 qrtr_endpoint_post+0xeeb/0x1010 net/qrtr/qrtr.c:462
 qrtr_tun_write_iter+0xf5/0x180 net/qrtr/tun.c:92
 call_write_iter include/linux/fs.h:1907 [inline]
 do_iter_readv_writev+0x567/0x780 fs/read_write.c:694
 do_iter_write+0x188/0x5f0 fs/read_write.c:999
 compat_writev+0x1ea/0x390 fs/read_write.c:1352
 do_compat_pwritev64+0x180/0x1b0 fs/read_write.c:1401
 do_syscall_32_irqs_on+0x3f/0x60 arch/x86/entry/common.c:403
 __do_fast_syscall_32 arch/x86/entry/common.c:448 [inline]
 do_fast_syscall_32+0x7f/0x120 arch/x86/entry/common.c:474
 entry_SYSENTER_compat+0x6d/0x7c arch/x86/entry/entry_64_compat.S:138
RIP: 0023:0xf7f8f569
Code: Bad RIP value.
RSP: 002b:00000000ffda5ffc EFLAGS: 00000292 ORIG_RAX: 000000000000014e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020000440
RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00000000080bb528
RBP: 0000000000000012 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6806:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x17a/0x340 mm/slab.c:3665
 kmalloc include/linux/slab.h:560 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 qrtr_tun_write_iter+0x8a/0x180 net/qrtr/tun.c:83
 call_write_iter include/linux/fs.h:1907 [inline]
 do_iter_readv_writev+0x567/0x780 fs/read_write.c:694
 do_iter_write+0x188/0x5f0 fs/read_write.c:999
 compat_writev+0x1ea/0x390 fs/read_write.c:1352
 do_compat_pwritev64+0x180/0x1b0 fs/read_write.c:1401
 do_syscall_32_irqs_on+0x3f/0x60 arch/x86/entry/common.c:403
 __do_fast_syscall_32 arch/x86/entry/common.c:448 [inline]
 do_fast_syscall_32+0x7f/0x120 arch/x86/entry/common.c:474
 entry_SYSENTER_compat+0x6d/0x7c arch/x86/entry/entry_64_compat.S:138

Freed by task 1:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3757
 tomoyo_path_perm+0x234/0x3f0 security/tomoyo/file.c:842
 security_inode_getattr+0xcf/0x140 security/security.c:1278
 vfs_getattr fs/stat.c:121 [inline]
 vfs_statx+0x170/0x390 fs/stat.c:206
 vfs_lstat include/linux/fs.h:3301 [inline]
 __do_sys_newlstat+0x91/0x110 fs/stat.c:374
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88809de50c40
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 8 bytes inside of
 32-byte region [ffff88809de50c40, ffff88809de50c60)
The buggy address belongs to the page:
page:ffffea0002779400 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88809de50fc1
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea000277e008 ffffea0002761c88 ffff8880aa0001c0
raw: ffff88809de50fc1 ffff88809de50000 000000010000003f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809de50b00: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff88809de50b80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>ffff88809de50c00: fb fb fb fb fc fc fc fc 04 fc fc fc fc fc fc fc
                                              ^
 ffff88809de50c80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff88809de50d00: fb fb fb fb fc fc fc fc 00 01 fc fc fc fc fc fc
==================================================================

