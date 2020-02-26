Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 503311708CE
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 20:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgBZTTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 14:19:12 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:34075 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgBZTTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 14:19:12 -0500
Received: by mail-il1-f199.google.com with SMTP id l13so992657ils.1
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 11:19:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=rXw747gjK6laOZLMusPdxln3RoHpkV1n+wna4emSCNo=;
        b=Cs9XJpb2CJNAASAe6xCECWpw3AZK1r5WUdJHH2ADw54upSl+P/dO4E2xAtNnZTAh2F
         3er9TbVr+b5Mp0qtUKD8l6q6qVcJPCgZMeM9dTMHXODgdfHL2o9NNNiKuerQEXSs2dbP
         Wc/zMwSeggThX7UgzjPRCB6mN4jLtfh5LgHc/8DkssiuP9rRL46E+8uAAvAAQ/8eOzd3
         +2V28DAWwfbP/XIYCCE1M5xEeJjgUcNfRB3hMuaZ6PcpFaat6t5ZycK9AMn25KKp6ikA
         1vX603hkHdl3rt01F+QTgaxkTJ950nUcZpEWLjAVff1ervrr3T4AeSkqMVSL83KhUc08
         w9Dw==
X-Gm-Message-State: APjAAAUucUri9FSgmqkIJkhUegiQ2e7SSt0nJUnY2kUo9oFBEzm8bPzV
        yTJkmn34SR1MhfaVGpQqYk4MeC3FovJTvo47PKTu7jfcaquO
X-Google-Smtp-Source: APXvYqxYETg5hb0Vg3jTm5C/vjXuwUFlj0v4yYfUDJfkEsDsA/gmXIGXz22eQZ92kqEhvAm8KoLNrKzSzs/R2PAbSr7QGdBzASI6
MIME-Version: 1.0
X-Received: by 2002:a6b:c304:: with SMTP id t4mr148362iof.100.1582744750355;
 Wed, 26 Feb 2020 11:19:10 -0800 (PST)
Date:   Wed, 26 Feb 2020 11:19:10 -0800
In-Reply-To: <0000000000007272b9059bffe6cc@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009d7b30059f7f7a0d@google.com>
Subject: Re: WARNING: refcount bug in j1939_netdev_start (2)
From:   syzbot <syzbot+85d9878b19c94f9019ad@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    f8788d86 Linux 5.6-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12a93c2de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d2e033af114153f
dashboard link: https://syzkaller.appspot.com/bug?extid=85d9878b19c94f9019ad
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137fe929e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+85d9878b19c94f9019ad@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 0 PID: 8790 at lib/refcount.c:25 refcount_warn_saturate+0x147/0x1b0 lib/refcount.c:25
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 8790 Comm: syz-executor.4 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1fb/0x318 lib/dump_stack.c:118
 panic+0x264/0x7a9 kernel/panic.c:221
 __warn+0x209/0x210 kernel/panic.c:582
 report_bug+0x1b6/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 do_error_trap+0xcf/0x1c0 arch/x86/kernel/traps.c:267
 do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:refcount_warn_saturate+0x147/0x1b0 lib/refcount.c:25
Code: c7 ed e2 f0 88 31 c0 e8 d7 2d a8 fd 0f 0b eb a1 e8 0e 68 d6 fd c6 05 c7 31 c5 05 01 48 c7 c7 24 e3 f0 88 31 c0 e8 b9 2d a8 fd <0f> 0b eb 83 e8 f0 67 d6 fd c6 05 aa 31 c5 05 01 48 c7 c7 50 e3 f0
RSP: 0018:ffffc900024e7d00 EFLAGS: 00010246
RAX: 11ed52ed4a02e700 RBX: 0000000000000002 RCX: ffff888097334280
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc900024e7d10 R08: ffffffff81600324 R09: ffffed1015d44592
R10: ffffed1015d44592 R11: 0000000000000000 R12: 1ffff11011de2046
R13: ffff8880a6558000 R14: 0000000000000002 R15: 0000000000000005
 j1939_netdev_start+0x83a/0x920 include/linux/refcount.h:191
 j1939_sk_bind+0x2ae/0xa90 net/can/j1939/socket.c:469
 __sys_bind+0x2bd/0x3a0 net/socket.c:1662
 __do_sys_bind net/socket.c:1673 [inline]
 __se_sys_bind net/socket.c:1671 [inline]
 __x64_sys_bind+0x7a/0x90 net/socket.c:1671
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c449
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f439cc91c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00007f439cc926d4 RCX: 000000000045c449
RDX: 0000000000000018 RSI: 0000000020000240 RDI: 0000000000000005
RBP: 000000000076bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000030 R14: 00000000004c28fe R15: 000000000076bf2c
Kernel Offset: disabled
Rebooting in 86400 seconds..

