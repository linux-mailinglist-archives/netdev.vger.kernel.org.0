Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 753E91121E9
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 04:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfLDDpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 22:45:08 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:52829 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfLDDpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 22:45:08 -0500
Received: by mail-io1-f69.google.com with SMTP id e124so4089227iof.19
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 19:45:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ybWV5ERE2DFFaXeFE6rBJTbeTy1J3ud09wZZavV8FC8=;
        b=URYy9WZyOfYXmGfgT13TJUOjMi5DcedYe6r/ldF7JFekaPT0mj+O84xHa+QJNeBwhu
         tMMDVgqZ0eTgfIb3D+Rtod3z3Ymv2y/8ZrMkdwfByVyUQfDr+A7xYFOewbHwN1KhDSpF
         AHEUygWyL65ENbv6oDsz+JSqcrkLcCmz+p2EsqBbDPPbU/+n3F+J2ebvZbPEczAFhtf5
         b6FsdU83P9LBEPof1+sN6hsMjptFSs3r7BQT89nx/MhnXPE2Ig72FGkZ739sImSt0sWT
         F+YB5cfQ1kxgU6ieHOob/85D4Vxt2OKqL6JCEvpyXIqALw2CVISdLgXQhriNbl4wOa4H
         ObHA==
X-Gm-Message-State: APjAAAVsU5LUmF4h9y4nnqfT0ul0M1+hW5GRoDPsfZuzTA+DQPZbRfIm
        qMe2H4X2CgvO7t0BhfXgvMOa0UlkzI1O+XvMexzQzIjqFUbm
X-Google-Smtp-Source: APXvYqxtt4ikt2dqLQsg3nRKS4nKfvjThwSLubcbtBlgQg0k6rxaj1SOfgc0nk89IVYO/OwyKXv8rxT3+6rVbdy6L20yAzYfpfTk
MIME-Version: 1.0
X-Received: by 2002:a5e:8f04:: with SMTP id c4mr684206iok.50.1575431107219;
 Tue, 03 Dec 2019 19:45:07 -0800 (PST)
Date:   Tue, 03 Dec 2019 19:45:07 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008399d40598d8a34d@google.com>
Subject: KASAN: vmalloc-out-of-bounds Write in pcpu_alloc
From:   syzbot <syzbot+59b7daa4315e07a994f1@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, kafai@fb.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b3c424eb sch_cake: Add missing NLA policy entry TCA_CAKE_S..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=129c042ae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7d8ab2e0e09c2a82
dashboard link: https://syzkaller.appspot.com/bug?extid=59b7daa4315e07a994f1
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=140df641e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147dcc2ae00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+59b7daa4315e07a994f1@syzkaller.appspotmail.com

RBP: 00007fff1c60f370 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
R13: 0000000000000003 R14: 00007fff1c60f370 R15: 0000000000000000
==================================================================
BUG: KASAN: vmalloc-out-of-bounds in memset include/linux/string.h:365  
[inline]
BUG: KASAN: vmalloc-out-of-bounds in pcpu_alloc+0x589/0x1380  
mm/percpu.c:1734
Write of size 32768 at addr ffffe8ffff800000 by task syz-executor940/9026

CPU: 1 PID: 9026 Comm: syz-executor940 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0x5/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:638
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
  memset+0x24/0x40 mm/kasan/common.c:107
  memset include/linux/string.h:365 [inline]
  pcpu_alloc+0x589/0x1380 mm/percpu.c:1734
  __alloc_percpu_gfp+0x28/0x30 mm/percpu.c:1783
  prealloc_init kernel/bpf/hashtab.c:154 [inline]
  htab_map_alloc+0xdb9/0x11c0 kernel/bpf/hashtab.c:378
  find_and_alloc_map kernel/bpf/syscall.c:123 [inline]
  map_create kernel/bpf/syscall.c:654 [inline]
  __do_sys_bpf+0x478/0x37b0 kernel/bpf/syscall.c:3012
  __se_sys_bpf kernel/bpf/syscall.c:2989 [inline]
  __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:2989
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441b99
Code: e8 ec 03 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 1b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff1c60f318 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441b99
RDX: 000000000000003c RSI: 0000000020000380 RDI: 0000000000000000
RBP: 00007fff1c60f370 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
R13: 0000000000000003 R14: 00007fff1c60f370 R15: 0000000000000000


Memory state around the buggy address:
BUG: unable to handle page fault for address: fffff91fffefffe0
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffe6067 P4D 21ffe6067 PUD aa56b067 PMD aa56c067 PTE 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9026 Comm: syz-executor940 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:memcpy_erms+0x6/0x10 arch/x86/lib/memcpy_64.S:56
Code: cc cc cc cc eb 1e 0f 1f 00 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 f3  
48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 <f3> a4 c3 0f 1f  
80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38 fe
RSP: 0018:ffffc90001fa7990 EFLAGS: 00010082
RAX: ffffc90001fa799c RBX: fffff91fffefffe0 RCX: 0000000000000010
RDX: 0000000000000010 RSI: fffff91fffefffe0 RDI: ffffc90001fa799c
RBP: ffffc90001fa79f0 R08: ffff888091714400 R09: fffff520003f4f38
R10: fffff520003f4f37 R11: ffffc90001fa79be R12: fffff91ffff00000
R13: 0000200000000000 R14: 00000000fffffffe R15: ffff88821fffd100
FS:  0000000000d10880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffff91fffefffe0 CR3: 0000000099ba1000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __kasan_report.cold+0x30/0x41 mm/kasan/report.c:508
  kasan_report+0x12/0x20 mm/kasan/common.c:638
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
  memset+0x24/0x40 mm/kasan/common.c:107
  memset include/linux/string.h:365 [inline]
  pcpu_alloc+0x589/0x1380 mm/percpu.c:1734
  __alloc_percpu_gfp+0x28/0x30 mm/percpu.c:1783
  prealloc_init kernel/bpf/hashtab.c:154 [inline]
  htab_map_alloc+0xdb9/0x11c0 kernel/bpf/hashtab.c:378
  find_and_alloc_map kernel/bpf/syscall.c:123 [inline]
  map_create kernel/bpf/syscall.c:654 [inline]
  __do_sys_bpf+0x478/0x37b0 kernel/bpf/syscall.c:3012
  __se_sys_bpf kernel/bpf/syscall.c:2989 [inline]
  __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:2989
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441b99
Code: e8 ec 03 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 1b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff1c60f318 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441b99
RDX: 000000000000003c RSI: 0000000020000380 RDI: 0000000000000000
RBP: 00007fff1c60f370 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
R13: 0000000000000003 R14: 00007fff1c60f370 R15: 0000000000000000
Modules linked in:
CR2: fffff91fffefffe0
---[ end trace 28e1dfa4887d81a1 ]---
RIP: 0010:memcpy_erms+0x6/0x10 arch/x86/lib/memcpy_64.S:56
Code: cc cc cc cc eb 1e 0f 1f 00 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 f3  
48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 <f3> a4 c3 0f 1f  
80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38 fe
RSP: 0018:ffffc90001fa7990 EFLAGS: 00010082
RAX: ffffc90001fa799c RBX: fffff91fffefffe0 RCX: 0000000000000010
RDX: 0000000000000010 RSI: fffff91fffefffe0 RDI: ffffc90001fa799c
RBP: ffffc90001fa79f0 R08: ffff888091714400 R09: fffff520003f4f38
R10: fffff520003f4f37 R11: ffffc90001fa79be R12: fffff91ffff00000
R13: 0000200000000000 R14: 00000000fffffffe R15: ffff88821fffd100
FS:  0000000000d10880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffff91fffefffe0 CR3: 0000000099ba1000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
