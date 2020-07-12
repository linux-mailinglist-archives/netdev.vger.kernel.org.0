Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C1021CA8F
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 19:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgGLRJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 13:09:19 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:47546 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728844AbgGLRJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 13:09:18 -0400
Received: by mail-io1-f71.google.com with SMTP id d22so1176438iom.14
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 10:09:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Yw72Y/dPha6dHvTp53M8GYTZT11pIsw/90iuY03eMJI=;
        b=gxL1XywIQL+6rR8x7eoxQjxT9rrVZHyXnwyH3YrWB21heMay6h7OFC1qLt63hD/F/D
         pOuqh4qWXeII5h1YqxhwCuxgO1Yaq/SwyBafeHWnbQZ52+Ns8xfWaRyRNzOfHzKBPiHG
         9s1RyDFWybwkd3tBnn+rPXBAjYCS2gVq4bKQG0B7nYon7LdmZYTGU0vTni6XrAARaA6f
         TV8rNoW4cmEIY6f7S07Di1r8G6i1GTZa237auk6OVum4Kg2ndWaudzAlopZzQUeceLL8
         KSklNCjiAjj3Y0ClW54137JeEv2Nac8nY/oECARzQd9nP2pCkTZvWwP0QrnR7piEjKbp
         IeBg==
X-Gm-Message-State: AOAM531X4EgUbDmwUszTPI+uVfVjEly7N1seL3xGwbONcyJ3ciohRerB
        22n108YI2jIlOYS1X1PZRVx+RezLakATvM7SSuUUrDoZjtMn
X-Google-Smtp-Source: ABdhPJy1J+iM3TsWri9oqL/HigR5IMR4FFaNI4Eb9H0bjlox0GrWTqLa7z0a0hEFqIg1egEJA0B7f19WFWYF4q0ATy+0hnBpwaqH
MIME-Version: 1.0
X-Received: by 2002:a02:2401:: with SMTP id f1mr86680188jaa.66.1594573757391;
 Sun, 12 Jul 2020 10:09:17 -0700 (PDT)
Date:   Sun, 12 Jul 2020 10:09:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000060a7a405aa41a24b@google.com>
Subject: stack segment fault in stack_depot_save
From:   syzbot <syzbot+e85270bd0e2619ac6b0d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@gmail.com, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        liuhangbin@gmail.com, mcroce@redhat.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7cc2a8ea Merge tag 'block-5.8-2020-07-01' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17e8af2f100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7be693511b29b338
dashboard link: https://syzkaller.appspot.com/bug?extid=e85270bd0e2619ac6b0d
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e85270bd0e2619ac6b0d@syzkaller.appspotmail.com

stack segment: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 6449 Comm: syz-executor.1 Not tainted 5.8.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:find_stack lib/stackdepot.c:185 [inline]
RIP: 0010:stack_depot_save+0x109/0x400 lib/stackdepot.c:257
Code: 00 41 89 df 41 81 e7 ff ff 0f 00 4a 8b 2c fd 40 72 be 8c 48 85 ed 75 12 e9 b0 00 00 00 48 8b 6d 00 48 85 ed 0f 84 a3 00 00 00 <39> 5d 08 75 ee 44 3b 6d 0c 75 e8 31 c0 48 8b 74 c5 18 49 39 34 c4
RSP: 0018:ffffc900000070e0 EFLAGS: 00010202
RAX: 00000000715ca103 RBX: 00000000a18ac32b RCX: 0000000000000b20
RDX: 00000000e46675f4 RSI: 0000000000000003 RDI: 000000003e87a82a
RBP: 0777777007777770 R08: 00000000597d27c0 R09: ffff88802b206908
R10: fffffbfff155cb29 R11: 0000000000000000 R12: ffffc90000007130
R13: 0000000000000012 R14: 0000000000000012 R15: 00000000000ac32b
FS:  00007fbec16d5700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33629000 CR3: 0000000097e89000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 save_stack+0x32/0x40 mm/kasan/common.c:50
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x17a/0x340 mm/slab.c:3665
 kmalloc include/linux/slab.h:560 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 neigh_alloc net/core/neighbour.c:399 [inline]
 ___neigh_create+0x1320/0x2500 net/core/neighbour.c:577
 ip6_finish_output2+0xe3c/0x17b0 net/ipv6/ip6_output.c:114
 __ip6_finish_output net/ipv6/ip6_output.c:143 [inline]
 __ip6_finish_output+0x447/0xab0 net/ipv6/ip6_output.c:128
 ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x1db/0x520 net/ipv6/ip6_output.c:176
 dst_output include/net/dst.h:435 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_xmit+0x1258/0x1e80 net/ipv6/ip6_output.c:280
 sctp_v6_xmit+0x339/0x650 net/sctp/ipv6.c:217
 sctp_packet_transmit+0x20d7/0x3240 net/sctp/output.c:629
 sctp_outq_flush_transports net/sctp/outqueue.c:1147 [inline]
 sctp_outq_flush+0x2b7/0x2380 net/sctp/outqueue.c:1195
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x4d0/0x4d80 net/sctp/sm_sideeffect.c:1156
 sctp_generate_heartbeat_event+0x214/0x450 net/sctp/sm_sideeffect.c:391
 call_timer_fn+0x1ac/0x760 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers.part.0+0x54c/0xa20 kernel/time/timer.c:1773
 __run_timers kernel/time/timer.c:1745 [inline]
 run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1786
 __do_softirq+0x34c/0xa60 kernel/softirq.c:292
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x111/0x170 arch/x86/kernel/irq_64.c:77
 do_softirq kernel/softirq.c:337 [inline]
 do_softirq+0x16b/0x1e0 kernel/softirq.c:324
 __local_bh_enable_ip+0x1f8/0x250 kernel/softirq.c:189
 lock_sock include/net/sock.h:1576 [inline]
 sctp_recvmsg+0x94/0xb00 net/sctp/socket.c:2111
 inet_recvmsg+0x121/0x5d0 net/ipv4/af_inet.c:845
 sock_recvmsg_nosec net/socket.c:886 [inline]
 ____sys_recvmsg+0x561/0x640 net/socket.c:2573
 ___sys_recvmsg+0x127/0x200 net/socket.c:2617
 do_recvmmsg+0x24d/0x6d0 net/socket.c:2715
 __sys_recvmmsg net/socket.c:2794 [inline]
 __do_sys_recvmmsg net/socket.c:2817 [inline]
 __se_sys_recvmmsg net/socket.c:2810 [inline]
 __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2810
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cb29
Code: Bad RIP value.
RSP: 002b:00007fbec16d4c78 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 00000000004fc860 RCX: 000000000045cb29
RDX: 00000000ffffff1f RSI: 0000000020000100 RDI: 0000000000000003
RBP: 000000000078c040 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000008c7 R14: 00000000004cbb2f R15: 00007fbec16d56d4
Modules linked in:
---[ end trace bf70b9b157f9c631 ]---
RIP: 0010:find_stack lib/stackdepot.c:185 [inline]
RIP: 0010:stack_depot_save+0x109/0x400 lib/stackdepot.c:257
Code: 00 41 89 df 41 81 e7 ff ff 0f 00 4a 8b 2c fd 40 72 be 8c 48 85 ed 75 12 e9 b0 00 00 00 48 8b 6d 00 48 85 ed 0f 84 a3 00 00 00 <39> 5d 08 75 ee 44 3b 6d 0c 75 e8 31 c0 48 8b 74 c5 18 49 39 34 c4
RSP: 0018:ffffc900000070e0 EFLAGS: 00010202
RAX: 00000000715ca103 RBX: 00000000a18ac32b RCX: 0000000000000b20
RDX: 00000000e46675f4 RSI: 0000000000000003 RDI: 000000003e87a82a
RBP: 0777777007777770 R08: 00000000597d27c0 R09: ffff88802b206908
R10: fffffbfff155cb29 R11: 0000000000000000 R12: ffffc90000007130
R13: 0000000000000012 R14: 0000000000000012 R15: 00000000000ac32b
FS:  00007fbec16d5700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33629000 CR3: 0000000097e89000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
