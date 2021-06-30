Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7798E3B8829
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 20:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhF3SJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 14:09:54 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:56169 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbhF3SJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 14:09:53 -0400
Received: by mail-io1-f72.google.com with SMTP id i13-20020a5d88cd0000b02904e5ab8bdc6cso2412341iol.22
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 11:07:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/N0igB5XioROVmxu3rw/cYh2TT/weJAfNRahEGQcMnQ=;
        b=J0zSC4lx6xYvvs11QMIi77HzBoZTgcsRyRPVBuPHbrszjGcWKRJke0gB/9XAetXvU5
         R0dFY8s2b3A2WxyO1nxH24qZ9TqOL7cAM89wvWB2dlOavDBwUQKUVVLCjEiekbikqBWs
         vTGnbTkHq5lfE7qRdGN49PnHXFPyqweFnfLjyXy/L5Ov1dsSdEPnWwGcUTqI4XYM1Ek7
         VkCSCYBHsF/pi0fH9BtHdftQOGDt/77UkAubfe+lZdTRpuIY2m/k1P9WtxaAh5lvdLVi
         jof9dZm1m5YEeb54iTeWxB56DaB+nV0SE+uekSu6h+OHTmIC/NlxrEN2JKWuftXwjmgI
         gf8w==
X-Gm-Message-State: AOAM532eYL8rRI0ai+E8bkxHElQMTI/72+6OSROMjKC2r6LEaWz2FE39
        XArRQ9vqxIJMNaWDPkiyVFOzQUz93nEvZfUn2oQkEiDSOQrL
X-Google-Smtp-Source: ABdhPJx+LDRN4fObwmGBMTJ4FmR6AnmqocOdfB6/ETiVPpW6p+R0iJjEYhjCLfFFAg68UCjGuCO7j4M8E8o723Z1LyYn7GI5MyVb
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2433:: with SMTP id g19mr8930362iob.100.1625076444401;
 Wed, 30 Jun 2021 11:07:24 -0700 (PDT)
Date:   Wed, 30 Jun 2021 11:07:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000033930805c5ff98b5@google.com>
Subject: [syzbot] BUG: sleeping function called from invalid context in __fput
From:   syzbot <syzbot+ecdd08539833605a9399@syzkaller.appspotmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ff8744b5 Merge branch '100GbE' of git://git.kernel.org/pub..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1338e88c300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7cf9abab1592f017
dashboard link: https://syzkaller.appspot.com/bug?extid=ecdd08539833605a9399

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ecdd08539833605a9399@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at fs/file_table.c:264
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 8392, name: syz-executor.2
no locks held by syz-executor.2/8392.
Preemption disabled at:
[<ffffffff812aa3e4>] kernel_fpu_begin_mask+0x64/0x260 arch/x86/kernel/fpu/core.c:126
CPU: 1 PID: 8392 Comm: syz-executor.2 Not tainted 5.13.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:8337
 __fput+0xf9/0x920 fs/file_table.c:264
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 get_signal+0x1ba2/0x2150 kernel/signal.c:2608
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:789
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x180/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x47/0xb0 arch/x86/entry/common.c:57
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff928e9e188 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: fffffffffffffff4 RBX: 000000000056bf80 RCX: 00000000004665d9
RDX: 0000000000000001 RSI: 0000000020001f40 RDI: 0000000000000004
RBP: 00007ff928e9e1d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffdfbf7c36f R14: 00007ff928e9e300 R15: 0000000000022000
note: syz-executor.2[8392] exited with preempt_count 1


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
