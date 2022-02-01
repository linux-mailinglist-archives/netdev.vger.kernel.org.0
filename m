Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8DE4A5706
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 06:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbiBAFkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 00:40:19 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:34372 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiBAFkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 00:40:18 -0500
Received: by mail-io1-f69.google.com with SMTP id b4-20020a05660214c400b00632eb8bff25so6237408iow.1
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 21:40:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=1m+jI4c4S9z+N6mXChlR9RZT6vvZARLaqK6ttNYGkXk=;
        b=8BPJoXNYzMeAOIf+9lNxzqcU07rKB/Pfvbqs2Paoi2+xmBK7pw8AsWAk6QEgu2e7ES
         n6FRGimDDwhJ6Umq7tDJF2Dabnqyqkn7xzWGPa81RfCbWd0rBMn0eM2hWsCWp1OOZr4b
         b9YiuC/qQREFJ27rD1o3NJaFHyiNPymsODETcWc3r2StW3ubl+hSZ+GqzK9E46h8y+Ng
         HP0MI+AQkRiFcNqkENi2Zf18zSZW0WMwddtGFRc4qp8hTK/YW7IO2htkYBqurojHxkCA
         rr99NAP8DvIj3myWnozdgHQUIbyRiFRXOCWJtM5LrHGDabUb1U4GZ0JnzbrhdgRo6DWG
         tKIg==
X-Gm-Message-State: AOAM532yRL/vkVnHBRABvw9pLqAyX0lAaWrK7DBdQF055qwDcoQHENP+
        JYHhiu55pSyzBVdhYOJ8WFZdCXOojDEMG/+l0KnbqkEXvX56
X-Google-Smtp-Source: ABdhPJzaaoz19EjlZxMINeCMVpTSZ+wpBF77leShEXgm3xpaNWQBj3ypv0S22DYdchPyZsjbmN0o/mCYxEHnpsZYrpCeVlsU03iB
MIME-Version: 1.0
X-Received: by 2002:a02:2420:: with SMTP id f32mr11735192jaa.305.1643694017647;
 Mon, 31 Jan 2022 21:40:17 -0800 (PST)
Date:   Mon, 31 Jan 2022 21:40:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000a9b7d05d6ee565f@google.com>
Subject: [syzbot] KASAN: vmalloc-out-of-bounds Write in ringbuf_map_alloc
From:   syzbot <syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    887a333c44eb Add linux-next specific files for 20220131
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=106ea200700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a9a7db1ff785d5c0
dashboard link: https://syzkaller.appspot.com/bug?extid=5ad567a418794b9b5983
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: vmalloc-out-of-bounds in bpf_ringbuf_area_alloc kernel/bpf/ringbuf.c:110 [inline]
BUG: KASAN: vmalloc-out-of-bounds in bpf_ringbuf_alloc kernel/bpf/ringbuf.c:133 [inline]
BUG: KASAN: vmalloc-out-of-bounds in ringbuf_map_alloc kernel/bpf/ringbuf.c:172 [inline]
BUG: KASAN: vmalloc-out-of-bounds in ringbuf_map_alloc+0x725/0x7b0 kernel/bpf/ringbuf.c:148
Write of size 8 at addr ffffc9001653a078 by task syz-executor.2/9141

CPU: 0 PID: 9141 Comm: syz-executor.2 Not tainted 5.17.0-rc2-next-20220131-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xf/0x3e0 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 bpf_ringbuf_area_alloc kernel/bpf/ringbuf.c:110 [inline]
 bpf_ringbuf_alloc kernel/bpf/ringbuf.c:133 [inline]
 ringbuf_map_alloc kernel/bpf/ringbuf.c:172 [inline]
 ringbuf_map_alloc+0x725/0x7b0 kernel/bpf/ringbuf.c:148
 find_and_alloc_map kernel/bpf/syscall.c:128 [inline]
 map_create kernel/bpf/syscall.c:863 [inline]
 __sys_bpf+0xc0f/0x5f10 kernel/bpf/syscall.c:4622
 __do_sys_bpf kernel/bpf/syscall.c:4744 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4742 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4742
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fab8b037059
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fab89fac168 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007fab8b149f60 RCX: 00007fab8b037059
RDX: 0000000000000048 RSI: 0000000020000440 RDI: 0000000000000000
RBP: 00007fab8b09108d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff1a45415f R14: 00007fab89fac300 R15: 0000000000022000
 </TASK>


Memory state around the buggy address:
 ffffc90016539f00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffc90016539f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>ffffc9001653a000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
                                                                ^
 ffffc9001653a080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffc9001653a100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
