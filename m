Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF838214E94
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 20:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgGESlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 14:41:21 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:37988 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgGESlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 14:41:20 -0400
Received: by mail-il1-f200.google.com with SMTP id c12so23617739ilf.5
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 11:41:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wwEam32TmxH45e9sLjA3XeLOu5dFb4Fi6bFCRKi5JYw=;
        b=jJCm6RBEQPN7deNThgF6kbCl6okhpqg2fJBeiQHHZHdAINT9P8u77IXMbq2LUQVEJn
         8uhsYBpcL4lgZyY/WNRlhwvJk5QCqVEgJ1k76HcweZR0uwU/6c68ZDE+NXnlRd/F0r/v
         sBP0mteRh7fabXURxMN4J6r5Kdrg5WEhgjPZzOt9m3IWHe8h0gsQDm1crmp03V9Bm3aq
         lWAdb34V+N7iXwLaFqxv4Xt6JPj4TYXNX8ITN+LA7bbvlv6GHhJw4qm7gJJgSBPSJK7H
         WUEltR7UFnC8315O4n7PGgRRAeDfwliQRZOmeszUII/b+TLoWa2VhGyfyaS63kk9qKvY
         RCIg==
X-Gm-Message-State: AOAM5309sU9MhjL/J7Qptbj+TQPZn38oKuxV0iUpzRE5AYvYaYkwlFA7
        iSXAt8+cUwpyHjsi0TTT0GUVPvbClno4ESbK4Uxr5k1QXtt7
X-Google-Smtp-Source: ABdhPJyx4TFwKSNypIjQEOlcBOSjN8j+FzwTS1I52dhkPmJTXGgkqmNZurlrxqIgQJw++74hijOceMDZ7OHK315H+Vhwfw5Lfxmz
MIME-Version: 1.0
X-Received: by 2002:a5d:8f0b:: with SMTP id f11mr22021918iof.200.1593974479552;
 Sun, 05 Jul 2020 11:41:19 -0700 (PDT)
Date:   Sun, 05 Jul 2020 11:41:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a2851c05a9b61ad8@google.com>
Subject: general protection fault in __btf_resolve_helper_id
From:   syzbot <syzbot+ee09bda7017345f1fbe6@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9e50b94b Add linux-next specific files for 20200703
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10327e6d100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f99cc0faa1476ed6
dashboard link: https://syzkaller.appspot.com/bug?extid=ee09bda7017345f1fbe6
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d9e39b100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b597d3100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ee09bda7017345f1fbe6@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000009: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000048-0x000000000000004f]
CPU: 0 PID: 6799 Comm: syz-executor682 Not tainted 5.8.0-rc3-next-20200703-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__btf_resolve_helper_id+0x149/0xb10 kernel/bpf/btf.c:4102
Code: 80 3c 03 00 0f 85 dd 08 00 00 48 8b 05 70 46 0a 0b 48 8d 78 48 48 89 04 24 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 50 09 00 00 48 8b 04 24 31 ff
RSP: 0018:ffffc90001637378 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 1ffffffff1926068 RCX: ffffffff816aa4b6
RDX: 0000000000000009 RSI: ffffffff8188bcb1 RDI: 0000000000000048
RBP: ffffffff818ba3d0 R08: ffffc900016373e4 R09: ffffc90001637670
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff888096648260 R15: ffff888096648000
FS:  0000000000cc2880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000282 CR3: 00000000a6dbe000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 btf_resolve_helper_id+0x10c/0x1c0 kernel/bpf/btf.c:4164
 check_helper_call+0x1641/0x5650 kernel/bpf/verifier.c:4721
 do_check kernel/bpf/verifier.c:8938 [inline]
 do_check_common+0x7253/0xc2d0 kernel/bpf/verifier.c:10574
 do_check_main kernel/bpf/verifier.c:10640 [inline]
 bpf_check+0x857f/0xce51 kernel/bpf/verifier.c:11093
 bpf_prog_load+0xdaf/0x1b50 kernel/bpf/syscall.c:2194
 __do_sys_bpf+0x1edf/0x4b10 kernel/bpf/syscall.c:4112
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:367
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440379
Code: Bad RIP value.
RSP: 002b:00007ffee37aa6d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440379
RDX: 0000000000000048 RSI: 0000000020000080 RDI: 0000000000000005
RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000401c00
R13: 0000000000401c90 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace d5a7c4fec6f343c9 ]---
RIP: 0010:__btf_resolve_helper_id+0x149/0xb10 kernel/bpf/btf.c:4102
Code: 80 3c 03 00 0f 85 dd 08 00 00 48 8b 05 70 46 0a 0b 48 8d 78 48 48 89 04 24 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 50 09 00 00 48 8b 04 24 31 ff
RSP: 0018:ffffc90001637378 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 1ffffffff1926068 RCX: ffffffff816aa4b6
RDX: 0000000000000009 RSI: ffffffff8188bcb1 RDI: 0000000000000048
RBP: ffffffff818ba3d0 R08: ffffc900016373e4 R09: ffffc90001637670
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff888096648260 R15: ffff888096648000
FS:  0000000000cc2880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000282 CR3: 00000000a6dbe000 CR4: 00000000001506f0
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
