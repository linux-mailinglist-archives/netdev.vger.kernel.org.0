Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA9A169FFB
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgBXI2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:28:51 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:36686 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbgBXI2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 03:28:14 -0500
Received: by mail-il1-f197.google.com with SMTP id d22so17097526ild.3
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 00:28:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Ki7/rIQ43NZNL7i9XZxO5j0m7be84RSH01sLpgV+brk=;
        b=kTcst3sYQcXF7LEXalN6ks24d29alF8vfLmhDFyJzFRIm0WsMEcsgcCSCYFMXRLu77
         jnAaRnllHJ7scs/n09zsWKa/6/D0XGVh6NTeL+7l+Fg1K23MGh36CrZg5yD6CWxFzmIZ
         dYH/4ahgtjYSh9tF/uW6/7VMZShtiKVstcdjvzZfdOcHSZpo5nKABoH3jEqGrcVbCx4H
         DNWBTnQCjc7ggn5GqaVjMQVBwUOPMRVwS6kxaxzFzk9hn3b7/QkG1R2zcHPxwqLiJlBg
         kE3QjOuIn/AVIiuAokDbpZWcMMh7GoBKPyZ/mgG8d6eIojPkML4qp3Np+5bZj6q4zGdh
         fYsQ==
X-Gm-Message-State: APjAAAVjMQMUwbup4bz1Vtyl8N7lLY2OfjZsF6cXvf9vgcKrd2Rxb6oX
        VOLlJhvPcDeQdTpSXhugOrxm4eoxXZCCdoV0P54ANUjBSebU
X-Google-Smtp-Source: APXvYqx6wSbvdhrhgLyvmokd++y+Rr8y2docF4cg58sfgAgwCXjrlPkJ3+tNBtiKM07na6bLEgVBv8Ai9YVKymV9PgGfH/n4Q+Xj
MIME-Version: 1.0
X-Received: by 2002:a02:c787:: with SMTP id n7mr50309193jao.85.1582532894078;
 Mon, 24 Feb 2020 00:28:14 -0800 (PST)
Date:   Mon, 24 Feb 2020 00:28:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ff4686059f4e26ac@google.com>
Subject: general protection fault in smc_ib_remove_dev
From:   syzbot <syzbot+84484ccebdd4e5451d91@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, arvid.brodin@alten.se,
        davem@davemloft.net, hch@lst.de, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        ubraun@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    36a44bcd Merge branch 'bnxt_en-shutdown-and-kexec-kdump-re..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=15b5774ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=768cc3d3e277cc16
dashboard link: https://syzkaller.appspot.com/bug?extid=84484ccebdd4e5451d91
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=100eda7ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11c3fdd9e00000

The bug was bisected to:

commit cbd34da7dc9afd521e0bea5e7d12701f4a9da7c7
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Jul 12 03:57:28 2019 +0000

    mm: move the powerpc hugepd code to mm/gup.c

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15ea4265e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17ea4265e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=13ea4265e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+84484ccebdd4e5451d91@syzkaller.appspotmail.com
Fixes: cbd34da7dc9a ("mm: move the powerpc hugepd code to mm/gup.c")

infiniband syz1: RDMA CMA: cma_listen_on_dev, error -98
netlink: 'syz-executor837': attribute type 1 has an invalid length.
netlink: 21 bytes leftover after parsing attributes in process `syz-executor837'.
general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 9928 Comm: syz-executor837 Not tainted 5.6.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__list_del_entry_valid+0x22/0xf5 lib/list_debug.c:42
Code: 0e fe 48 8b 75 e8 eb b2 48 b8 00 00 00 00 00 fc ff df 55 48 89 e5 41 56 49 89 fe 48 83 c7 08 48 89 fa 41 55 48 c1 ea 03 41 54 <80> 3c 02 00 0f 85 a1 00 00 00 4c 89 f2 4d 8b 66 08 48 b8 00 00 00
RSP: 0018:ffffc900053d7440 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffffffff87b4e490 RCX: ffffffff815c1ba9
RDX: 0000000000000001 RSI: 0000000000000004 RDI: 0000000000000008
RBP: ffffc900053d7458 R08: 0000000000000004 R09: fffff52000a7ae7b
R10: fffff52000a7ae7a R11: 0000000000000003 R12: 0000000000000000
R13: 0000000000000008 R14: 0000000000000000 R15: ffffffff8a98b880
FS:  0000000000ea3880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020003028 CR3: 0000000091874000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __list_del_entry include/linux/list.h:132 [inline]
 list_del_init include/linux/list.h:204 [inline]
 smc_ib_remove_dev+0x52/0x2e0 net/smc/smc_ib.c:578
 remove_client_context+0xc7/0x120 drivers/infiniband/core/device.c:724
 disable_device+0x14c/0x230 drivers/infiniband/core/device.c:1268
 __ib_unregister_device+0x9c/0x190 drivers/infiniband/core/device.c:1435
 ib_unregister_device_and_put+0x5f/0x80 drivers/infiniband/core/device.c:1498
 nldev_dellink+0x222/0x340 drivers/infiniband/core/nldev.c:1568
 rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:195 [inline]
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 rdma_nl_rcv+0x5d9/0x980 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 __sys_sendto+0x262/0x380 net/socket.c:1998
 __do_sys_sendto net/socket.c:2010 [inline]
 __se_sys_sendto net/socket.c:2006 [inline]
 __x64_sys_sendto+0xe1/0x1a0 net/socket.c:2006
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4404d9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffdb793fb28 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004404d9
RDX: 0000000000010a73 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 0000000000000000 R09: 4b6ae4f95a5de35b
R10: 00000000000008c0 R11: 0000000000000246 R12: 0000000000401d60
R13: 0000000000401df0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 79db9bfdece7383f ]---
RIP: 0010:__list_del_entry_valid+0x22/0xf5 lib/list_debug.c:42
Code: 0e fe 48 8b 75 e8 eb b2 48 b8 00 00 00 00 00 fc ff df 55 48 89 e5 41 56 49 89 fe 48 83 c7 08 48 89 fa 41 55 48 c1 ea 03 41 54 <80> 3c 02 00 0f 85 a1 00 00 00 4c 89 f2 4d 8b 66 08 48 b8 00 00 00
RSP: 0018:ffffc900053d7440 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffffffff87b4e490 RCX: ffffffff815c1ba9
RDX: 0000000000000001 RSI: 0000000000000004 RDI: 0000000000000008
RBP: ffffc900053d7458 R08: 0000000000000004 R09: fffff52000a7ae7b
R10: fffff52000a7ae7a R11: 0000000000000003 R12: 0000000000000000
R13: 0000000000000008 R14: 0000000000000000 R15: ffffffff8a98b880
FS:  0000000000ea3880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020003028 CR3: 0000000091874000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
