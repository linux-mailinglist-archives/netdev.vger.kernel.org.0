Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF135241EE8
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 19:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgHKRGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 13:06:41 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:55113 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728862AbgHKRGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 13:06:19 -0400
Received: by mail-io1-f71.google.com with SMTP id z25so10189545ioh.21
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 10:06:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=3Vhix2QlrP7+/gWO8RD9Xb0nh1rKeNHswNvEEXVVggk=;
        b=Wh1UrAKAq+FTtWbx6QXgwhCaOddsvXQwFqsYfCmgv88b/DXv67vqDNNt1zF2zTgpvr
         dAbtk9WjS0afGvjYKnm1FQ5JrP/oXspu9sZeJxv7Kps5swPh07t/ZalU54CfBabgMJKZ
         4xUyy8q94r4WElMmHp+njA9nH57iUenesWy1bGE24Uimzf7BTTQK5x/XluLvSq3DCk7+
         Ioc0CW1QXSSYZ7Aj8RnPp5GD6fN3uTPoe4d98pHyX8zW5p4KC7jCRruRHbmkQZ242Odi
         WRw+HwZoRHspE+Ntp/xcIfft5EiWh+wAHbXy0LVemd6V3xiToGgKLYeaLpN590BxTpo1
         mMhw==
X-Gm-Message-State: AOAM532wLjiUGzJwFOILRSzZRr+ad78AqPGo4DoVxsMlr0fIjfCaK1S9
        fQcm9cXU/TwiLL20GX72S7cLO6Rv7bTlW9bh5usIJgPIP5OI
X-Google-Smtp-Source: ABdhPJya4bXun/+NQ/qES9zRA+AQVNLy2Qz0OtAXqkV8v7oBezDW3rOulXZRMs+qHM9W8AjOsCoLdjJMu7AGJQaCF65y00BA+kfB
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2246:: with SMTP id o6mr23227895ioo.35.1597165577561;
 Tue, 11 Aug 2020 10:06:17 -0700 (PDT)
Date:   Tue, 11 Aug 2020 10:06:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e5ea9e05ac9d16c1@google.com>
Subject: memory leak in do_seccomp
From:   syzbot <syzbot+3ad9614a12f80994c32e@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        keescook@chromium.org, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, luto@amacapital.net,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, wad@chromium.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    449dc8c9 Merge tag 'for-v5.9' of git://git.kernel.org/pub/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15d816c2900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4810fa4a53b3aa2c
dashboard link: https://syzkaller.appspot.com/bug?extid=3ad9614a12f80994c32e
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=153d30e2900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3ad9614a12f80994c32e@syzkaller.appspotmail.com

2020/08/09 00:29:47 executed programs: 3
BUG: memory leak
unreferenced object 0xffff88811310ea80 (size 96):
  comm "syz-executor.0", pid 6688, jiffies 4294954707 (age 12.810s)
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 30 e0 00 00 c9 ff ff  .........0......
  backtrace:
    [<0000000073bb6e7d>] kmalloc include/linux/slab.h:554 [inline]
    [<0000000073bb6e7d>] kzalloc include/linux/slab.h:666 [inline]
    [<0000000073bb6e7d>] seccomp_prepare_filter kernel/seccomp.c:562 [inline]
    [<0000000073bb6e7d>] seccomp_prepare_user_filter kernel/seccomp.c:604 [inline]
    [<0000000073bb6e7d>] seccomp_set_mode_filter kernel/seccomp.c:1535 [inline]
    [<0000000073bb6e7d>] do_seccomp+0x2ec/0xd40 kernel/seccomp.c:1649
    [<00000000658618a4>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<00000000b8258e4d>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffffc90000e03000 (size 4096):
  comm "syz-executor.0", pid 6688, jiffies 4294954707 (age 12.810s)
  hex dump (first 32 bytes):
    01 00 03 00 00 00 00 00 00 00 00 00 05 00 00 00  ................
    2d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  -...............
  backtrace:
    [<000000003b6a39af>] __vmalloc_node_range+0x2e1/0x3c0 mm/vmalloc.c:2520
    [<00000000eee59e12>] __vmalloc_node mm/vmalloc.c:2552 [inline]
    [<00000000eee59e12>] __vmalloc+0x49/0x50 mm/vmalloc.c:2566
    [<000000006e13ac2a>] bpf_prog_alloc_no_stats+0x32/0x100 kernel/bpf/core.c:85
    [<00000000cff3572c>] bpf_prog_alloc+0x1c/0xb0 kernel/bpf/core.c:111
    [<000000003222ffa9>] bpf_prog_create_from_user+0x5f/0x2a0 net/core/filter.c:1409
    [<00000000baa576ae>] seccomp_prepare_filter kernel/seccomp.c:567 [inline]
    [<00000000baa576ae>] seccomp_prepare_user_filter kernel/seccomp.c:604 [inline]
    [<00000000baa576ae>] seccomp_set_mode_filter kernel/seccomp.c:1535 [inline]
    [<00000000baa576ae>] do_seccomp+0x32e/0xd40 kernel/seccomp.c:1649
    [<00000000658618a4>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<00000000b8258e4d>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888113bc1c00 (size 1024):
  comm "syz-executor.0", pid 6688, jiffies 4294954707 (age 12.810s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000000466b245>] kmalloc include/linux/slab.h:554 [inline]
    [<000000000466b245>] kzalloc include/linux/slab.h:666 [inline]
    [<000000000466b245>] bpf_prog_alloc_no_stats+0x73/0x100 kernel/bpf/core.c:89
    [<00000000cff3572c>] bpf_prog_alloc+0x1c/0xb0 kernel/bpf/core.c:111
    [<000000003222ffa9>] bpf_prog_create_from_user+0x5f/0x2a0 net/core/filter.c:1409
    [<00000000baa576ae>] seccomp_prepare_filter kernel/seccomp.c:567 [inline]
    [<00000000baa576ae>] seccomp_prepare_user_filter kernel/seccomp.c:604 [inline]
    [<00000000baa576ae>] seccomp_set_mode_filter kernel/seccomp.c:1535 [inline]
    [<00000000baa576ae>] do_seccomp+0x32e/0xd40 kernel/seccomp.c:1649
    [<00000000658618a4>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<00000000b8258e4d>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881154cb860 (size 32):
  comm "syz-executor.0", pid 6688, jiffies 4294954707 (age 12.810s)
  hex dump (first 32 bytes):
    01 00 73 74 65 6d 64 2d 00 5c d6 19 81 88 ff ff  ..stemd-.\......
    65 72 76 69 63 65 00 00 00 00 00 00 00 00 00 00  ervice..........
  backtrace:
    [<00000000561d65d4>] kmalloc include/linux/slab.h:554 [inline]
    [<00000000561d65d4>] bpf_prog_store_orig_filter+0x33/0xa0 net/core/filter.c:1131
    [<000000005d9b7cd2>] bpf_prog_create_from_user+0xda/0x2a0 net/core/filter.c:1422
    [<00000000baa576ae>] seccomp_prepare_filter kernel/seccomp.c:567 [inline]
    [<00000000baa576ae>] seccomp_prepare_user_filter kernel/seccomp.c:604 [inline]
    [<00000000baa576ae>] seccomp_set_mode_filter kernel/seccomp.c:1535 [inline]
    [<00000000baa576ae>] do_seccomp+0x32e/0xd40 kernel/seccomp.c:1649
    [<00000000658618a4>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<00000000b8258e4d>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888119d65c00 (size 32):
  comm "syz-executor.0", pid 6688, jiffies 4294954707 (age 12.810s)
  hex dump (first 32 bytes):
    06 00 00 00 fb ff ff 7f 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000ad603142>] kmemdup+0x23/0x50 mm/util.c:127
    [<0000000001d3eabf>] kmemdup include/linux/string.h:479 [inline]
    [<0000000001d3eabf>] bpf_prog_store_orig_filter+0x5e/0xa0 net/core/filter.c:1138
    [<000000005d9b7cd2>] bpf_prog_create_from_user+0xda/0x2a0 net/core/filter.c:1422
    [<00000000baa576ae>] seccomp_prepare_filter kernel/seccomp.c:567 [inline]
    [<00000000baa576ae>] seccomp_prepare_user_filter kernel/seccomp.c:604 [inline]
    [<00000000baa576ae>] seccomp_set_mode_filter kernel/seccomp.c:1535 [inline]
    [<00000000baa576ae>] do_seccomp+0x32e/0xd40 kernel/seccomp.c:1649
    [<00000000658618a4>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<00000000b8258e4d>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881131ecb00 (size 96):
  comm "syz-executor.0", pid 6688, jiffies 4294954707 (age 12.810s)
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    80 ea 10 13 81 88 ff ff 00 b0 d8 00 00 c9 ff ff  ................
  backtrace:
    [<0000000073bb6e7d>] kmalloc include/linux/slab.h:554 [inline]
    [<0000000073bb6e7d>] kzalloc include/linux/slab.h:666 [inline]
    [<0000000073bb6e7d>] seccomp_prepare_filter kernel/seccomp.c:562 [inline]
    [<0000000073bb6e7d>] seccomp_prepare_user_filter kernel/seccomp.c:604 [inline]
    [<0000000073bb6e7d>] seccomp_set_mode_filter kernel/seccomp.c:1535 [inline]
    [<0000000073bb6e7d>] do_seccomp+0x2ec/0xd40 kernel/seccomp.c:1649
    [<00000000658618a4>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<00000000b8258e4d>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811310e400 (size 96):
  comm "syz-executor.0", pid 6702, jiffies 4294955242 (age 7.460s)
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 50 e1 00 00 c9 ff ff  .........P......
  backtrace:
    [<0000000073bb6e7d>] kmalloc include/linux/slab.h:554 [inline]
    [<0000000073bb6e7d>] kzalloc include/linux/slab.h:666 [inline]
    [<0000000073bb6e7d>] seccomp_prepare_filter kernel/seccomp.c:562 [inline]
    [<0000000073bb6e7d>] seccomp_prepare_user_filter kernel/seccomp.c:604 [inline]
    [<0000000073bb6e7d>] seccomp_set_mode_filter kernel/seccomp.c:1535 [inline]
    [<0000000073bb6e7d>] do_seccomp+0x2ec/0xd40 kernel/seccomp.c:1649
    [<00000000658618a4>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<00000000b8258e4d>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
