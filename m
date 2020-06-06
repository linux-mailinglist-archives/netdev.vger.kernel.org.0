Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7971F0614
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 12:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgFFKVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 06:21:21 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:53110 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728684AbgFFKVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 06:21:15 -0400
Received: by mail-io1-f72.google.com with SMTP id p8so7419651ios.19
        for <netdev@vger.kernel.org>; Sat, 06 Jun 2020 03:21:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=5llyKwgac1RV4GHcH6sNotvtbMJH/GHvawCDDDtVVVY=;
        b=K19/8NELCASPXJZWkeofbaB8bJdA8ZV7PnXs90G+A083D6DaIIO8/eZ1VsiZE3eYb/
         LBx7tteLjBXGu1Y2BF3dfPYQg7MAcQbCunqAbL2PvqW92gonSQ7J70vQc1nn6eUki7LE
         0Elkck5+HFsdbhHEDNoPLPBkMrtzXGypmBp6dq6Q7G1IhAPA5xyVQZb5VSmm2wjbUeMq
         VSNM4H41psqeF5w0Fzml1He8GtIUp4uIiaJdNo/0EecXeYEH3J12hSqsr/Gv0IcmGv4M
         2VCM2+zJPyparCrOgLN6eF31E38e56ZxeFfMT8xGyxHcw2vMRBV/mrbGqOU61KxpkuaY
         G2/w==
X-Gm-Message-State: AOAM532ysz/YqcShewraEmolwoPm8haO7Pj8J5nCOIIKQFI1i6we51Ng
        6157QHx3zWH7LCM+Jo1O2sySMiE4XCT9sbgA4Yn9xQkt4wN1
X-Google-Smtp-Source: ABdhPJy2wQdSX4U9JnHz3jgAq+SYVz2kyDq20YwgfCwPYUHc2n7KidBmNInXz5IBNXh7+Yczxa8nJJ0TymHJbsxhL/VZwm8r8WZC
MIME-Version: 1.0
X-Received: by 2002:a02:958e:: with SMTP id b14mr12940395jai.126.1591438874365;
 Sat, 06 Jun 2020 03:21:14 -0700 (PDT)
Date:   Sat, 06 Jun 2020 03:21:14 -0700
In-Reply-To: <000000000000c54420059e4f08ff@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c9d3c205a767bc10@google.com>
Subject: Re: WARNING in dev_change_net_namespace
From:   syzbot <syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@gmail.com,
        ebiederm@xmission.com, edumazet@google.com, eric.dumazet@gmail.com,
        hawk@kernel.org, jiri@mellanox.com, johannes.berg@intel.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10112212100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=be4578b3f1083656
dashboard link: https://syzkaller.appspot.com/bug?extid=830c6dbfc71edc4f0b8f
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12032832100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com

RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000006
R13: 0000000000000a04 R14: 00000000004cce0c R15: 00007f9ea16a16d4
------------[ cut here ]------------
WARNING: CPU: 1 PID: 8201 at net/core/dev.c:10239 dev_change_net_namespace+0x15bb/0x1710 net/core/dev.c:10239
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 8201 Comm: syz-executor.0 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:221
 __warn+0x209/0x210 kernel/panic.c:582
 report_bug+0x1ac/0x2d0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:105 [inline]
 do_error_trap+0xca/0x1c0 arch/x86/kernel/traps.c:197
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:216
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:dev_change_net_namespace+0x15bb/0x1710 net/core/dev.c:10239
Code: 5f 00 03 01 48 c7 c7 2c 28 e9 88 48 c7 c6 6f 6d 07 89 ba a8 27 00 00 31 c0 e8 c1 76 de fa 0f 0b e9 f5 ea ff ff e8 85 b0 0c fb <0f> 0b e9 fb fd ff ff e8 79 b0 0c fb 0f 0b e9 1b fe ff ff e8 6d b0
RSP: 0018:ffffc9000a3f7160 EFLAGS: 00010293
RAX: ffffffff8667f2ab RBX: 00000000fffffff4 RCX: ffff88808f6d43c0
RDX: 0000000000000000 RSI: 00000000fffffff4 RDI: 0000000000000000
RBP: ffffc9000a3f7270 R08: ffffffff8667f096 R09: ffffed1015d270fc
R10: ffffed1015d270fc R11: 0000000000000000 R12: ffff8880888600b8
R13: ffff888088860b90 R14: dffffc0000000000 R15: dffffc0000000000
 do_setlink+0x196/0x3900 net/core/rtnetlink.c:2510
 __rtnl_newlink net/core/rtnetlink.c:3273 [inline]
 rtnl_newlink+0x1509/0x1c00 net/core/rtnetlink.c:3398
 rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2439
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45ca69
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f9ea16a0c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000500f80 RCX: 000000000045ca69
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000006
R13: 0000000000000a04 R14: 00000000004cce0c R15: 00007f9ea16a16d4
Kernel Offset: disabled
Rebooting in 86400 seconds..

