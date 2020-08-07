Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D07023E5D2
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 04:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgHGC03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 22:26:29 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:41442 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgHGC01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 22:26:27 -0400
Received: by mail-il1-f199.google.com with SMTP id l6so343183ilf.8
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 19:26:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=P4HaL8fuExeVT2ON4Wu7436r4YukaeyETCtLgx2utNk=;
        b=S70eOde6IUREzUjlpgKUbYpr/VeSqbeuPVjpGvFzPIFDwQGQDLHF7LO5IW0APhVl7B
         dJjrJsDDu80WTeKkwIhrW8yDqS8sW62rymqv34fkTljYL58wgDZY1E2IdIKFd4wImMyM
         mVJ7btwbvHMavcH3tQICRbelhsVeU07+2KSo+2re9qv3ozCbbUEDIXh2Q4f7LBAAnEWi
         CAxIY8JKPq1j+jr73LG8zHRxBBfBWczX+k7VGjRw5Yl4ymKJWCiGppq2e/FuJL73Ik6y
         R2whAJrNrWpFY6t+VLHvM01qT+aRdqOB6zmbjFRpPregnj6FTE+t7hLc/tpCZnxg+vJB
         Hkgg==
X-Gm-Message-State: AOAM533h4ZaWQMQwCEZ4r1NlUi8WmF70vg9u1yBLvGf9ylaNUFqGnx+y
        PPxYjcr/6sLVvr079cHwRvR8QMcpJw6sDG+AgMFfuL/nIcMl
X-Google-Smtp-Source: ABdhPJxC+84P4eA4etCMj8bj2rNpwjY7+2e8369KBCiLW0ybXGFHpcCp84efsiZ87C3C9o/rgJ/W/0ZmK9AIsZ8STNyY0l/N0nb5
MIME-Version: 1.0
X-Received: by 2002:a6b:8b10:: with SMTP id n16mr2168652iod.11.1596767185982;
 Thu, 06 Aug 2020 19:26:25 -0700 (PDT)
Date:   Thu, 06 Aug 2020 19:26:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e8d94d05ac40540a@google.com>
Subject: WARNING: refcount bug in bt_accept_dequeue
From:   syzbot <syzbot+6048aa700d088954b0fc@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    47ec5303 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1083e7ec900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e0c783f658542f35
dashboard link: https://syzkaller.appspot.com/bug?extid=6048aa700d088954b0fc
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11c227dc900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6048aa700d088954b0fc@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 1 PID: 3805 at lib/refcount.c:25 refcount_warn_saturate+0x13d/0x1a0 lib/refcount.c:25
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 3805 Comm: krfcommd Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:231
 __warn+0x227/0x250 kernel/panic.c:600
 report_bug+0x1b1/0x2e0 lib/bug.c:198
 handle_bug+0x42/0x80 arch/x86/kernel/traps.c:235
 exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:255
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:refcount_warn_saturate+0x13d/0x1a0 lib/refcount.c:25
Code: c7 93 1e 15 89 31 c0 e8 71 0c a9 fd 0f 0b eb a3 e8 88 66 d7 fd c6 05 97 4d ed 05 01 48 c7 c7 ca 1e 15 89 31 c0 e8 53 0c a9 fd <0f> 0b eb 85 e8 6a 66 d7 fd c6 05 7a 4d ed 05 01 48 c7 c7 f6 1e 15
RSP: 0018:ffffc90001997b80 EFLAGS: 00010246
RAX: b5077223a4630100 RBX: 0000000000000002 RCX: ffff88809902e380
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: 0000000000000002 R08: ffffffff815dffd9 R09: ffffed1015d262c0
R10: ffffed1015d262c0 R11: 0000000000000000 R12: ffff88808df4b4b8
R13: ffff88808df4b080 R14: 0000000000000000 R15: dffffc0000000000
 refcount_add include/linux/refcount.h:205 [inline]
 refcount_inc include/linux/refcount.h:241 [inline]
 sock_hold include/net/sock.h:692 [inline]
 bt_accept_dequeue+0x34e/0x560 net/bluetooth/af_bluetooth.c:206
 l2cap_sock_accept+0x21c/0x430 net/bluetooth/l2cap_sock.c:332
 kernel_accept+0x143/0x410 net/socket.c:3569
 rfcomm_accept_connection net/bluetooth/rfcomm/core.c:1931 [inline]
 rfcomm_process_sessions+0x1c5/0xc540 net/bluetooth/rfcomm/core.c:1990
 rfcomm_run+0x3b5/0x900 net/bluetooth/rfcomm/core.c:2086
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
