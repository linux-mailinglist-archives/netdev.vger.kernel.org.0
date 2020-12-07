Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BC52D1A31
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgLGUDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:03:52 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:37247 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbgLGUDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 15:03:52 -0500
Received: by mail-io1-f70.google.com with SMTP id s12so12761342iot.4
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 12:03:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=XMGMPIEBErujLDEv/XhG8es0A2X7wQdMlren4Z/PANs=;
        b=SXAqxQ5a2IhsEzcu7JzR1S0cw+g2l3UxiJ/a1oqAXGGfMA2tqpyUBNhPeDKkjQzg5m
         TS/sLzJaYiojGfqn1QWb++aIetV7uoXlrnu24Fb3k0QtoAqy7nnoUYjigmiaVoKKQf4N
         YlM6VDhbZBO8yU4euYzQQ691IEFTFxdJvOqu17EEs+0vYfXnxOsH/2DNurvFcXWY8Asf
         FJIyqMRtNR9c3snk8Vecc2vvlK/WUwrfN8E9aIOL/KRo1hyEbp12HnedBaBKLVGt36B5
         x38m98MF5J5eF+eGGu1+Ow6WA/w4fsOXieKiwkTUXf48NukkL65htLGJhpfOc1Jv0BrA
         lWCw==
X-Gm-Message-State: AOAM530wqbSWG7tdfIHc/H0Cf+khmASVzbwa+5ynG4LbVfQzfErCkzu3
        tiy75g+QuMVBvPo728ZDqH1WBFDiX5e0ozhgzHOkLUiNOWg5
X-Google-Smtp-Source: ABdhPJzTcO6HdC1HPfBAdo9qmGVdcPBUW/k2i+We0dzvt/EZzDBbvbOZVtuuykvGXpgUi0FP8aosriwNV5mZyRTTk2+r7qY8ypQC
MIME-Version: 1.0
X-Received: by 2002:a5e:a916:: with SMTP id c22mr9051978iod.144.1607371391149;
 Mon, 07 Dec 2020 12:03:11 -0800 (PST)
Date:   Mon, 07 Dec 2020 12:03:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000caabb705b5e550aa@google.com>
Subject: KASAN: vmalloc-out-of-bounds Write in pcpu_freelist_populate
From:   syzbot <syzbot+942085bfb8f7a276af1c@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    34da8721 selftests/bpf: Test bpf_sk_storage_get in tcp ite..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10c3b837500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3cb098ab0334059f
dashboard link: https://syzkaller.appspot.com/bug?extid=942085bfb8f7a276af1c
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+942085bfb8f7a276af1c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: vmalloc-out-of-bounds in pcpu_freelist_push_node kernel/bpf/percpu_freelist.c:33 [inline]
BUG: KASAN: vmalloc-out-of-bounds in pcpu_freelist_populate+0x1fe/0x260 kernel/bpf/percpu_freelist.c:114
Write of size 8 at addr ffffc90119e78020 by task syz-executor.4/27988

CPU: 1 PID: 27988 Comm: syz-executor.4 Not tainted 5.10.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0x5/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 pcpu_freelist_push_node kernel/bpf/percpu_freelist.c:33 [inline]
 pcpu_freelist_populate+0x1fe/0x260 kernel/bpf/percpu_freelist.c:114
 prealloc_init kernel/bpf/hashtab.c:323 [inline]
 htab_map_alloc+0x981/0x1230 kernel/bpf/hashtab.c:507
 find_and_alloc_map kernel/bpf/syscall.c:123 [inline]
 map_create kernel/bpf/syscall.c:829 [inline]
 __do_sys_bpf+0xa81/0x5170 kernel/bpf/syscall.c:4374
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e0f9
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f679c7a7c68 EFLAGS: 00000246
 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e0f9
RDX: 0000000000000040 RSI: 0000000020000040 RDI: 0000000000000000
RBP: 000000000119c068 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119c034
R13: 00007fffd601c75f R14: 00007f679c7a89c0 R15: 000000000119c034


Memory state around the buggy address:
 ffffc90119e77f00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffc90119e77f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>ffffc90119e78000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
                               ^
 ffffc90119e78080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffc90119e78100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
