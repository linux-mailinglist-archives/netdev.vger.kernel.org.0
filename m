Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D87B3F7393
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 13:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfKKMFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 07:05:09 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:43784 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfKKMFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 07:05:07 -0500
Received: by mail-io1-f70.google.com with SMTP id d65so13271837iof.10
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 04:05:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=w6Keuok1ehG5NCdltR+WKRqu0HOKnkFWU+V9KF3Usgo=;
        b=P8MSLrni5BV73BdlQ6fNc6tMp6T17I4h3qmOnANSK1kqCsEwoxJlMkDrUkR6JNGFVS
         4jQ5hhxMoC3f/LkDT/lspN81gVEjKZ1x734GnD+RgzOxdPoWT8YHHXmh66zxLAdrXZnu
         jc1jMFUZJMv6dyiKYquHOrh1zhEmOCg7RnlkW/3vAGiwz3VuYmRaF3RZlN19Av/08Bjy
         9e6wGwPx6pf4ZwBs8HyqyBob1xOQ4/R/ooRSxOxbTwzZIyKkReUmrb4CELiP5BySFiiF
         V7F3iWBM1SziaYNd59YiJ6eb5JUKVuywApSrKQiexj5gU+5fb9UAZ7JH3kBWhid1BTsV
         cJxQ==
X-Gm-Message-State: APjAAAUDiBZ1fGZDjNekmSFr6+i3eSSXHLToJeERCfQyFrg8jglNP56H
        ndGJV/j+meKif5IQUednNil5C4mDLHd3rYoQFN8yFf57wXD7
X-Google-Smtp-Source: APXvYqyGNxoHm5qEhquhgLNmVnuxdWzdo/mULggNwaAXSfOclHHEPGVPdP00z/rDTo2e9m8L5TxlKcjkzTvmXoVJ4F6hHQ8JrpPM
MIME-Version: 1.0
X-Received: by 2002:a6b:cc01:: with SMTP id c1mr9250843iog.7.1573473905580;
 Mon, 11 Nov 2019 04:05:05 -0800 (PST)
Date:   Mon, 11 Nov 2019 04:05:05 -0800
In-Reply-To: <000000000000aae1480596a5632b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000034a246059710f18a@google.com>
Subject: Re: WARNING: refcount bug in j1939_netdev_start
From:   syzbot <syzbot+afd421337a736d6c1ee6@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    9805a683 Merge branch 'x86-urgent-for-linus' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=133de01ce00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=896c87b73c6fcda6
dashboard link: https://syzkaller.appspot.com/bug?extid=afd421337a736d6c1ee6
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d713c6e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+afd421337a736d6c1ee6@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: increment on 0; use-after-free.
WARNING: CPU: 1 PID: 8514 at lib/refcount.c:156  
refcount_inc_checked+0x4b/0x50 lib/refcount.c:156
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 8514 Comm: syz-executor.3 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1fb/0x318 lib/dump_stack.c:118
  panic+0x264/0x7a9 kernel/panic.c:221
  __warn+0x20e/0x210 kernel/panic.c:582
  report_bug+0x1b6/0x2f0 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  do_error_trap+0xd7/0x440 arch/x86/kernel/traps.c:272
  do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:refcount_inc_checked+0x4b/0x50 lib/refcount.c:156
Code: 3d f7 ab 75 05 01 75 08 e8 12 e2 2d fe 5b 5d c3 e8 0a e2 2d fe c6 05  
e1 ab 75 05 01 48 c7 c7 b4 c5 40 88 31 c0 e8 a5 78 00 fe <0f> 0b eb df 90  
55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 10
RSP: 0018:ffff8880816dfd10 EFLAGS: 00010246
RAX: 8358cd98639ffe00 RBX: ffff8880975b50f0 RCX: ffff8880a4010540
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffff8880816dfd18 R08: ffffffff815ca054 R09: ffffed1015d640d2
R10: ffffed1015d640d2 R11: 0000000000000000 R12: ffff88808e820588
R13: dffffc0000000000 R14: ffff88808e820000 R15: 1ffff11011d04047
  j1939_netdev_start+0x47c/0x730 net/can/j1939/main.c:267
  j1939_sk_bind+0x2c0/0xac0 net/can/j1939/socket.c:438
  __sys_bind+0x2c2/0x3a0 net/socket.c:1647
  __do_sys_bind net/socket.c:1658 [inline]
  __se_sys_bind net/socket.c:1656 [inline]
  __x64_sys_bind+0x7a/0x90 net/socket.c:1656
  do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a219
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007efc734cbc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045a219
RDX: 0000000000000018 RSI: 0000000020000240 RDI: 0000000000000005
RBP: 000000000075c070 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007efc734cc6d4
R13: 00000000004c057e R14: 00000000004d2c50 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..

