Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0140221C2E2
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 08:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgGKGzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 02:55:21 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:33269 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbgGKGzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 02:55:20 -0400
Received: by mail-io1-f72.google.com with SMTP id a12so5020256ioo.0
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 23:55:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=+dz85Sf0hRZ/UgjIsHMdP1g1MRjmFGmwDieydsvrQOk=;
        b=dlfkvTvj7mFh1C5XgFH7nOd+gIsn/Bqn+SAYvFeS3qqD4gIwVo/GLAC0/dzoAt8eNu
         XGggu6oebzmPR7aHb+02FSliDZ0pBuou432k/hQ1KEbck63PFXnddxDQQ9fz/ruqIrcK
         2pyCow2t07/6DYRMwqW2oC2i7WxwkxlKx0Vnklj6dlM6sIJWHt/ivfFyZ7edJPSfiO9X
         iV0FvMLIviFRhw+4YyzQ7siK3+9WUpAE+adOOFetZhdioO3IAKw9h7XpRil+HKoinopw
         7SAQ+XSxdp0vQflfIOTSNjTheyXWRpuxIQKDf5hqQtgBun+Xh7a1NQbtuS/ze7XU3GNJ
         foDw==
X-Gm-Message-State: AOAM533nbUPrelk1h8/l0M2t8vb3B5WX4nV3RlHKWw/NlEbqo7P73Yrw
        rema0oPQ+MBXzn9o7o/leqJqRezG74o9V/Dj32HNy9at3ozZ
X-Google-Smtp-Source: ABdhPJyuoiyF2Hi/zB2jC9J3N7RUUrUrDxIu/t2RdVsun9X1Al2bnspROLoTsGxlWPCV0Wlwsa59jhdZSe131eIfZeqwHwYfVu6W
MIME-Version: 1.0
X-Received: by 2002:a02:9642:: with SMTP id c60mr80203032jai.71.1594450519081;
 Fri, 10 Jul 2020 23:55:19 -0700 (PDT)
Date:   Fri, 10 Jul 2020 23:55:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cd4de605aa24f03c@google.com>
Subject: BUG: stack guard page was hit in no_context
From:   syzbot <syzbot+b344c6786fc0f8409a1c@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, jeyu@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7cc2a8ea Merge tag 'block-5.8-2020-07-01' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15dd7d83100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7be693511b29b338
dashboard link: https://syzkaller.appspot.com/bug?extid=b344c6786fc0f8409a1c
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b344c6786fc0f8409a1c@syzkaller.appspotmail.com

BUG: stack guard page was hit at 000000006422ef1c (stack is 000000009e8a746a..00000000d32e48ea)
kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8234 Comm: kworker/u4:8 Not tainted 5.8.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_purge_orig
RIP: 0010:no_context+0x33/0x9f0 arch/x86/mm/fault.c:584
Code: fc ff df 41 56 41 89 ce 41 55 49 89 f5 41 54 49 89 d4 55 48 89 fd 53 48 8d 9d 88 00 00 00 48 81 ec d0 00 00 00 48 8d 44 24 30 <44> 89 44 24 10 48 c7 44 24 30 b3 8a b5 41 48 c1 e8 03 48 89 04 24
RSP: 0018:ffffc9001642ffe8 EFLAGS: 00010086
RAX: ffffc90016430018 RBX: ffffc90016430280 RCX: 000000000000000b
RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffffc900164301f8
RBP: ffffc900164301f8 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000002 R14: 000000000000000b R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc9001642ffd8 CR3: 0000000025a2b000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __bad_area_nosemaphore+0xa9/0x480 arch/x86/mm/fault.c:789
 do_user_addr_fault+0x783/0xd00 arch/x86/mm/fault.c:1171
 handle_page_fault arch/x86/mm/fault.c:1365 [inline]
 exc_page_fault+0xab/0x170 arch/x86/mm/fault.c:1418
 asm_exc_page_fault+0x1e/0x30 arch/x86/include/asm/idtentry.h:565
RIP: 0010:preempt_schedule_thunk+0x0/0x18 arch/x86/entry/thunk_64.S:40
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <00> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RSP: 0018:ffffc900164302a8 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffc900164305b0 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff83967dab RDI: 0000000000000001
RBP: ffffffff810078f7 R08: ffffffff83ad5e30 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 000000000000000e R14: 0000000000000002 R15: 0000000000000000
 search_module_extables+0xce/0x100 kernel/module.c:4422
 search_exception_tables+0x42/0x50 kernel/extable.c:59
 fixup_exception+0x4b/0xca arch/x86/mm/extable.c:161
 no_context+0xe7/0x9f0 arch/x86/mm/fault.c:599
 __bad_area_nosemaphore+0xa9/0x480 arch/x86/mm/fault.c:789
 do_user_addr_fault+0x783/0xd00 arch/x86/mm/fault.c:1171
 handle_page_fault arch/x86/mm/fault.c:1365 [inline]
 exc_page_fault+0xab/0x170 arch/x86/mm/fault.c:1418
 asm_exc_page_fault+0x1e/0x30 arch/x86/include/asm/idtentry.h:565
RIP: 0010:preempt_schedule_thunk+0x0/0x18 arch/x86/entry/thunk_64.S:40
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <00> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RSP: 0018:ffffc900164305d8 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffc900164308e0 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff83967dab RDI: 0000000000000001
RBP: ffffffff810078f7 R08: ffffffff83ad5e30 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 000000000000000e R14: 0000000000000002 R15: 0000000000000000
 search_module_extables+0xce/0x100 kernel/module.c:4422
 search_exception_tables+0x42/0x50 kernel/extable.c:59
 fixup_exception+0x4b/0xca arch/x86/mm/extable.c:161
 no_context+0xe7/0x9f0 arch/x86/mm/fault.c:599
 __bad_area_nosemaphore+0xa9/0x480 arch/x86/mm/fault.c:789
 do_user_addr_fault+0x783/0xd00 arch/x86/mm/fault.c:1171
 handle_page_fault arch/x86/mm/fault.c:1365 [inline]
 exc_page_fault+0xab/0x170 arch/x86/mm/fault.c:1418
 asm_exc_page_fault+0x1e/0x30 arch/x86/include/asm/idtentry.h:565
RIP: 0010:preempt_schedule_thunk+0x0/0x18 arch/x86/entry/thunk_64.S:40
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <00> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RSP: 0018:ffffc90016430908 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffc90016430c10 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff83967dab RDI: 0000000000000001
RBP: ffffffff810078f7 R08: ffffffff83ad5e30 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 000000000000000e R14: 0000000000000002 R15: 0000000000000000
 search_module_extables+0xce/0x100 kernel/module.c:4422
 search_exception_tables+0x42/0x50 kernel/extable.c:59
 fixup_exception+0x4b/0xca arch/x86/mm/extable.c:161
 no_context+0xe7/0x9f0 arch/x86/mm/fault.c:599
 __bad_area_nosemaphore+0xa9/0x480 arch/x86/mm/fault.c:789
 do_user_addr_fault+0x783/0xd00 arch/x86/mm/fault.c:1171
 handle_page_fault arch/x86/mm/fault.c:1365 [inline]
 exc_page_fault+0xab/0x170 arch/x86/mm/fault.c:1418
 asm_exc_page_fault+0x1e/0x30 arch/x86/include/asm/idtentry.h:565
RIP: 0010:preempt_schedule_thunk+0x0/0x18 arch/x86/entry/thunk_64.S:40
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <00> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RSP: 0018:ffffc90016430c38 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffc90016430f40 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff83967dab RDI: 0000000000000001
RBP: ffffffff810078f7 R08: ffffffff83ad5e30 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 000000000000000e R14: 0000000000000002 R15: 0000000000000000
 search_module_extables+0xce/0x100 kernel/module.c:4422
 search_exception_tables+0x42/0x50 kernel/extable.c:59
 fixup_exception+0x4b/0xca arch/x86/mm/extable.c:161
 no_context+0xe7/0x9f0 arch/x86/mm/fault.c:599
 __bad_area_nosemaphore+0xa9/0x480 arch/x86/mm/fault.c:789
 do_user_addr_fault+0x783/0xd00 arch/x86/mm/fault.c:1171
 handle_page_fault arch/x86/mm/fault.c:1365 [inline]
 exc_page_fault+0xab/0x170 arch/x86/mm/fault.c:1418
 asm_exc_page_fault+0x1e/0x30 arch/x86/include/asm/idtentry.h:565
RIP: 0010:preempt_schedule_thunk+0x0/0x18 arch/x86/entry/thunk_64.S:40
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <00> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RSP: 0018:ffffc90016430f68 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffc90016431270 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff83967dab RDI: 0000000000000001
RBP: ffffffff810078f7 R08: ffffffff83ad5e30 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 000000000000000e R14: 0000000000000002 R15: 0000000000000000
 search_module_extables+0xce/0x100 kernel/module.c:4422
 search_exception_tables+0x42/0x50 kernel/extable.c:59
 fixup_exception+0x4b/0xca arch/x86/mm/extable.c:161
 no_context+0xe7/0x9f0 arch/x86/mm/fault.c:599
 __bad_area_nosemaphore+0xa9/0x480 arch/x86/mm/fault.c:789
 do_user_addr_fault+0x783/0xd00 arch/x86/mm/fault.c:1171
 handle_page_fault arch/x86/mm/fault.c:1365 [inline]
 exc_page_fault+0xab/0x170 arch/x86/mm/fault.c:1418
 asm_exc_page_fault+0x1e/0x30 arch/x86/include/asm/idtentry.h:565
RIP: 0010:preempt_schedule_thunk+0x0/0x18 arch/x86/entry/thunk_64.S:40
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <00> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RSP: 0018:ffffc90016431298 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffc900164315a0 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff83967dab RDI: 0000000000000001
RBP: ffffffff810078f7 R08: ffffffff83ad5e30 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 000000000000000e R14: 0000000000000002 R15: 0000000000000000
 search_module_extables+0xce/0x100 kernel/module.c:4422
 search_exception_tables+0x42/0x50 kernel/extable.c:59
 fixup_exception+0x4b/0xca arch/x86/mm/extable.c:161
 no_context+0xe7/0x9f0 arch/x86/mm/fault.c:599
 __bad_area_nosemaphore+0xa9/0x480 arch/x86/mm/fault.c:789
 do_user_addr_fault+0x783/0xd00 arch/x86/mm/fault.c:1171
 handle_page_fault arch/x86/mm/fault.c:1365 [inline]
 exc_page_fault+0xab/0x170 arch/x86/mm/fault.c:1418
 asm_exc_page_fault+0x1e/0x30 arch/x86/include/asm/idtentry.h:565
RIP: 0010:preempt_schedule_thunk+0x0/0x18 arch/x86/entry/thunk_64.S:40
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <00> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RSP: 0
Lost 828 message(s)!
---[ end trace ec14fcfb6d9859f3 ]---
RIP: 0010:no_context+0x33/0x9f0 arch/x86/mm/fault.c:584
Code: fc ff df 41 56 41 89 ce 41 55 49 89 f5 41 54 49 89 d4 55 48 89 fd 53 48 8d 9d 88 00 00 00 48 81 ec d0 00 00 00 48 8d 44 24 30 <44> 89 44 24 10 48 c7 44 24 30 b3 8a b5 41 48 c1 e8 03 48 89 04 24
RSP: 0018:ffffc9001642ffe8 EFLAGS: 00010086
RAX: ffffc90016430018 RBX: ffffc90016430280 RCX: 000000000000000b
RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffffc900164301f8
RBP: ffffc900164301f8 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000002 R14: 000000000000000b R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc9001642ffd8 CR3: 0000000025a2b000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
