Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8AA23AA94
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgHCQfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:35:21 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:52707 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgHCQfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:35:21 -0400
Received: by mail-il1-f198.google.com with SMTP id u3so9578629ilj.19
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 09:35:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=c5elw8Hy/MXGnQo6DFRKJPG1+OjMNtdWJ9iXEUEThL8=;
        b=WxpOVP9R9e1HOwFlIuDSZkorX3LHhJ79LcdDTncvS0x6NYgEXroTtTv+TDjCxq7Mld
         uWaF929R04WoNQihh3xvjdcWIi1Ry8Mc+w6gYxI9HE7tj/CAJBkktjIiCG9J9i1R5q8n
         mjGmRqA+1wzrbSKLxsRnnq+RdjOP/ADxvbxH1S7DLttbiOVdyd+KSUKspB/xpXhoYbu0
         NOSLEPcUqsgoR4xagx1044xkwhNNyr6BAwPLVebd3Stu/iR3D1VJHpyeTT/W6ZYk6KYk
         nKLAJLJnclq2qkYgDHIqreavUxHAi1HmTsByXK1auUFghBtEw7RynTD0z0H/ZmW+eluR
         Ra9Q==
X-Gm-Message-State: AOAM532ZaNjle5FzL7vWT/S/ZWX+YsZk6AMJxZuSmSQaS6K/FoTbwY2J
        xOBiXCl9sJ5Wv7Mpx6DX8p0IeVSyibqHn9YOZTmKFnMAtxNj
X-Google-Smtp-Source: ABdhPJxAQ4pogqsCFxARBb6YHiCgmG7IXXooic7Fwm6tvqHpmV4bMgnZhBB9mjuMwrT1Za946RlsmSdxfAS3jg35bUPTMHd5xtRd
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1105:: with SMTP id u5mr215403ilk.258.1596472520520;
 Mon, 03 Aug 2020 09:35:20 -0700 (PDT)
Date:   Mon, 03 Aug 2020 09:35:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007ab98a05abfbb9a7@google.com>
Subject: KMSAN: uninit-value in caif_seqpkt_sendmsg
From:   syzbot <syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com>
To:     alexios.zavras@intel.com, allison@lohutok.net, davem@davemloft.net,
        edumazet@google.com, glider@google.com, gregkh@linuxfoundation.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, swinslow@gmail.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    8bbbc5cf kmsan: don't compile memmove
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=11fbfe09e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cd0e9a6b0e555cc3
dashboard link: https://syzkaller.appspot.com/bug?extid=09a5d591c1f98cf5efcb
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150ef74ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170e2109e00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in caif_seqpkt_sendmsg+0x693/0xf60 net/caif/caif_socket.c:542
CPU: 1 PID: 11244 Comm: syz-executor620 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 caif_seqpkt_sendmsg+0x693/0xf60 net/caif/caif_socket.c:542
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2343
 ___sys_sendmsg net/socket.c:2397 [inline]
 __sys_sendmmsg+0x808/0xc90 net/socket.c:2480
 __compat_sys_sendmmsg net/compat.c:656 [inline]
 __do_compat_sys_sendmmsg net/compat.c:663 [inline]
 __se_compat_sys_sendmmsg net/compat.c:660 [inline]
 __ia32_compat_sys_sendmmsg+0x127/0x180 net/compat.c:660
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3c7/0x6e0 arch/x86/entry/common.c:410
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f79d99
Code: 90 e8 0b 00 00 00 f3 90 0f ae e8 eb f9 8d 74 26 00 89 3c 24 c3 90 90 90 90 90 90 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffbf4d6c EFLAGS: 00000292 ORIG_RAX: 0000000000000159
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020007600
RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00000000080bb508
RBP: 0000000000000012 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Local variable ----iovstack.i@__sys_sendmmsg created at:
 ___sys_sendmsg net/socket.c:2388 [inline]
 __sys_sendmmsg+0x6db/0xc90 net/socket.c:2480
 ___sys_sendmsg net/socket.c:2388 [inline]
 __sys_sendmmsg+0x6db/0xc90 net/socket.c:2480
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
