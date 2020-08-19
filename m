Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE4224A268
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 17:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgHSPEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 11:04:36 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:53639 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbgHSPE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 11:04:26 -0400
Received: by mail-il1-f197.google.com with SMTP id o18so16946512ill.20
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 08:04:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=VDNiVmoVHM/EAgrPMdZuxSNbn4Cv7QjczVTKlAQSEmk=;
        b=EgsZNHiERZnZ56BAMebb/iIWXpHFQWDPBqvGh3uCpzfzxGF3uFBwPb9865MB6WVrvA
         uh2zMFhSaAGLKCKv51GeO5lnFD/sPMPlqPStwyX6BQ45DnFPcgdCQ7f0ikPxhRUmJqpH
         EC8TytdHN5T/sgemDS5YozY8a4lLuHtvSPoAQ7zh7hZRufFkr8Ocimy2+newWGnRoUtZ
         GR4lmDUg6V1EzdoT0EA5o9M3W5G17539K8+4ZSWOxOqUR7GcVN+Q+dyIud/FWgUc59Vm
         XWof4IKbZLa3FkuxEV75CHjiZjqVBsNOpjWUFe3S+jTiXN8PJxNO/rg1/HGT6woWO7f/
         dtIA==
X-Gm-Message-State: AOAM5311DXPj0QrkeaRgyhh8AH/bfAENPZ/tzQM2ZuMtgimXUtMJD837
        RBq2bQvMU8fRIyys7LVcPgwTgSXsju5Uy3wR+UsibjGCI5Jn
X-Google-Smtp-Source: ABdhPJzeo74koGhSSSorznRH6H8AtESLASRNC7zQ8Md7nTE1JsONxbQConiM86dPAk4WOiflAjYv1YIace83+WiDrjid6uQT0mQE
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1614:: with SMTP id x20mr23864466jas.92.1597849465083;
 Wed, 19 Aug 2020 08:04:25 -0700 (PDT)
Date:   Wed, 19 Aug 2020 08:04:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c560bd05ad3c5187@google.com>
Subject: WARNING in rtnl_dellink
From:   syzbot <syzbot+b3b5c64f4880403edd36@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        hawk@kernel.org, jiri@mellanox.com, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4ca0d9ac bonding: show saner speed for broadcast mode
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=13c21516900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c89856ae5fc8b6
dashboard link: https://syzkaller.appspot.com/bug?extid=b3b5c64f4880403edd36
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119f99f6900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10fe8fbe900000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11516872900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13516872900000
console output: https://syzkaller.appspot.com/x/log.txt?x=15516872900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b3b5c64f4880403edd36@syzkaller.appspotmail.com

bond1 (unregistering): Released all slaves
------------[ cut here ]------------
WARNING: CPU: 0 PID: 7280 at net/core/dev.c:9304 rollback_registered_many+0xecd/0x1210 net/core/dev.c:9304
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 7280 Comm: syz-executor543 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x4a kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:rollback_registered_many+0xecd/0x1210 net/core/dev.c:9304
Code: 0a 1b 00 00 48 c7 c6 40 d7 fe 88 48 c7 c7 80 d7 fe 88 c6 05 b6 e1 71 04 01 e8 71 18 0a fb 0f 0b e9 13 fc ff ff e8 d3 14 39 fb <0f> 0b e9 ea fb ff ff e8 c7 14 39 fb 0f 0b e9 29 fc ff ff e8 3b 25
RSP: 0018:ffffc90002df7290 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 00000000a650bd01 RCX: ffffffff863b3396
RDX: ffff8880874fc540 RSI: ffffffff863b37ad RDI: 0000000000000001
RBP: ffff8880a5edef80 R08: 0000000000000000 R09: ffffffff8a7e4067
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: ffff8880925b0000 R14: dffffc0000000000 R15: ffff8880a5edef80
 unregister_netdevice_many.part.0+0x1a/0x2f0 net/core/dev.c:10426
 unregister_netdevice_many+0x36/0x50 net/core/dev.c:10425
 rtnl_delete_link net/core/rtnetlink.c:3055 [inline]
 rtnl_dellink+0x34a/0xa60 net/core/rtnetlink.c:3107
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x44b1a9
Code: e8 9c 14 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 4b 05 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8155c28d98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006e7a58 RCX: 000000000044b1a9
RDX: 0000000000000000 RSI: 00000000200002c0 RDI: 0000000000000009
RBP: 00000000006e7a50 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006e7a5c
R13: 0000000000000000 R14: 0000000000000000 R15: 068500100000003c
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
