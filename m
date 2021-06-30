Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39773B8892
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 20:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbhF3Sjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 14:39:51 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:33762 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233514AbhF3Sju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 14:39:50 -0400
Received: by mail-io1-f71.google.com with SMTP id i9-20020a0566021349b02904df6556dad4so2565053iov.0
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 11:37:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/AVs9oHqf5mp42OqIZCGa4M29OQT9RBw7MUMCFsEQn0=;
        b=E9VIjeNBHcKL2kYd1d4RtYXP+MKC2kKXFeCvm6f30SGXNnT1oDbpqqYOgKw7VyIZlP
         QIMb3abYI8MzLgrevr0ank1htQe95bHWdNoveHi3RozieLR+/RQ1IEe351FNbc7eesBO
         rzkO5msArQkhDNaFFRkJEmoQe/HQ/1eo/TqyF3aqmx0H8DmqHopzSa2tNHH3Mid0JOr8
         tRbjCQ0IZyvvE8nxtyCFsU1Lm5DMUcgguFMEDP/4vKI1V3UZZwBdVCbLbQvotHXCMO0/
         asdjAN4UQhdX+hjI+oVYCvPkSgo8yHgNQ+zc661P0MsTKD831yXaHHw5JyztV3itA8V8
         wD+g==
X-Gm-Message-State: AOAM532UrwdDZL8fhdr5Ces7fB7K8X6JaGrRFcLLZIh77v/hg6yteLm7
        HQnHbKIh/Fs5CTPjEw5dii6rnd4YIWzTAZeS/L73pPRAl2v3
X-Google-Smtp-Source: ABdhPJzZvR0NYGpXS3+SeZggX9oRZCqPAvFkSzttmjiRa4KtvdZZePDccoA3EO2tRxLo/siE0QTBhoKRFS4/qqnOhrXt1qFzLRvy
MIME-Version: 1.0
X-Received: by 2002:a5d:8d16:: with SMTP id p22mr8920953ioj.90.1625078240745;
 Wed, 30 Jun 2021 11:37:20 -0700 (PDT)
Date:   Wed, 30 Jun 2021 11:37:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000459ea305c6000318@google.com>
Subject: [syzbot] BUG: scheduling while atomic: syz-executor/ADDR
From:   syzbot <syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com>
To:     ardb@kernel.org, bp@alien8.de, dave.hansen@intel.com,
        davem@davemloft.net, herbert@gondor.apana.org.au, hpa@zytor.com,
        jpa@git.mail.kapsi.fi, kan.liang@linux.intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        luto@kernel.org, mingo@redhat.com, netdev@vger.kernel.org,
        peterz@infradead.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ff8744b5 Merge branch '100GbE' of git://git.kernel.org/pub..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=163cc5dc300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7cf9abab1592f017
dashboard link: https://syzkaller.appspot.com/bug?extid=20191dc583eff8602d2d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a81190300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1417f5bfd00000

The issue was bisected to:

commit 2481104fe98d5b016fdd95d649b1235f21e491ba
Author: Ard Biesheuvel <ardb@kernel.org>
Date:   Thu Dec 31 16:41:55 2020 +0000

    crypto: x86/aes-ni-xts - rewrite and drop indirections via glue helper

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=164ee60c300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=154ee60c300000
console output: https://syzkaller.appspot.com/x/log.txt?x=114ee60c300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com
Fixes: 2481104fe98d ("crypto: x86/aes-ni-xts - rewrite and drop indirections via glue helper")

RBP: 00007ffd23488340 R08: 0000000000000000 R09: 00007ffd234884c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000005
R13: 0000000000000000 R14: 00000000004ae018 R15: 0000000000400488
syz-executor607[8444]: segfault at 4b0e48 ip 0000000000408e15 sp 00007ffd234882e0 error 7 in syz-executor607098311[401000+82000]
Code: 0a 00 00 74 08 84 c9 0f 85 46 02 00 00 45 31 e4 0f 1f 44 00 00 64 8b 04 25 18 00 00 00 ba 01 00 00 00 85 c0 0f 85 d5 01 00 00 <0f> b1 15 2c 80 0a 00 4c 8b 33 4d 85 f6 75 3b e9 72 01 00 00 0f 1f
BUG: scheduling while atomic: syz-executor607/8444/0x00000002
no locks held by syz-executor607/8444.
Modules linked in:
Preemption disabled at:
[<ffffffff812aa3e4>] kernel_fpu_begin_mask+0x64/0x260 arch/x86/kernel/fpu/core.c:126
Kernel panic - not syncing: scheduling while atomic
CPU: 1 PID: 8444 Comm: syz-executor607 Not tainted 5.13.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 panic+0x306/0x73d kernel/panic.c:231
 __schedule_bug.cold+0x10c/0x143 kernel/sched/core.c:4880
 schedule_debug kernel/sched/core.c:4909 [inline]
 __schedule+0x19df/0x23e0 kernel/sched/core.c:5038
 schedule+0xcf/0x270 kernel/sched/core.c:5226
 exit_to_user_mode_loop kernel/entry/common.c:163 [inline]
 exit_to_user_mode_prepare+0x14d/0x290 kernel/entry/common.c:209
 irqentry_exit_to_user_mode+0x5/0x40 kernel/entry/common.c:315
 exc_page_fault+0xc6/0x180 arch/x86/mm/fault.c:1534
 asm_exc_page_fault+0x1e/0x30 arch/x86/include/asm/idtentry.h:577
RIP: 0033:0x408e15
Code: 0a 00 00 74 08 84 c9 0f 85 46 02 00 00 45 31 e4 0f 1f 44 00 00 64 8b 04 25 18 00 00 00 ba 01 00 00 00 85 c0 0f 85 d5 01 00 00 <0f> b1 15 2c 80 0a 00 4c 8b 33 4d 85 f6 75 3b e9 72 01 00 00 0f 1f
RSP: 002b:00007ffd234882e0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000004ae108 RCX: 0000000000000001
RDX: 0000000000000001 RSI: 00000000004ae108 RDI: 0000000000000001
RBP: 0000000000000001 R08: 0000000000000000 R09: 00007ffd234884c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000001 R14: 00000000004ae018 R15: 0000000000400488
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
