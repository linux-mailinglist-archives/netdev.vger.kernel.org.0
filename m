Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C1643F4CD
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 04:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhJ2CKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 22:10:50 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:47642 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbhJ2CKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 22:10:49 -0400
Received: by mail-io1-f72.google.com with SMTP id m8-20020a0566022e8800b005de532f3f54so5563659iow.14
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 19:08:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=AbAsAY+NQim6nqAPnS6cs+YFjX1oysde05Mzx0ubgY0=;
        b=s400qx/2eD4q2K0Xr79JsKcKlfp3sInLH6uQmeDAdONV8wXCxrQKTOERophRR1jnjg
         o6XGGcrnMoOoHn4yO9sIHgB0VhRMVcRV5o894OR0E/mTw+ziluxnY6GSC9oJp/s8PNds
         2w0qFekeZzsRdPeywdqptbBTWRe5OwNFD8LwrkGkjafKsrtnCsM4aj81Kmyvfrzz4b39
         LukURjtD5SKkalpzhjbfN1guNjFKcIE9Wh/p/OCR7SPhMdkdAQK8bY9EdEnSyEmzZGd7
         nFh1qGxYonWbgHkUI/v6Xcp9B2kd5Bpbd3I7ftKVrB28GA17fX0Nu8axaj9w8W6aGQCt
         coCg==
X-Gm-Message-State: AOAM531suKbvwlx4Nis37ePrcs+vOgCrlGv9X6f6uwsOPtptNSxtzQyU
        Cral8LM30/dIUTnUHAnSjM5NzzmsldmX4/CGfZU9MPcsKhF0
X-Google-Smtp-Source: ABdhPJwnrDUnruMJiH1CtZv24KDTZxyBjhRSwbOBzh6IFiy/JQ5XIvUzZTcExPiagsyuFIzIy39NySADIeSGElGqrcPwti71fAnd
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2d92:: with SMTP id k18mr5960862iow.130.1635473301860;
 Thu, 28 Oct 2021 19:08:21 -0700 (PDT)
Date:   Thu, 28 Oct 2021 19:08:21 -0700
In-Reply-To: <000000000000f2771905a46374fe@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000032743205cf744dfa@google.com>
Subject: Re: [syzbot] possible deadlock in sch_direct_xmit (2)
From:   syzbot <syzbot+e18ac85757292b7baf96@syzkaller.appspotmail.com>
To:     administracion@diocesisdeleon.org, davem@davemloft.net,
        hdanton@sina.com, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    35392da51b1a Revert "net: hns3: fix pause config problem a..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=108cede2b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ca74db36f5f0f1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=e18ac85757292b7baf96
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d2f204b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112f3f6cb00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e18ac85757292b7baf96@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.15.0-rc6-syzkaller #0 Not tainted
--------------------------------------------
syz-executor023/6539 is trying to acquire lock:
ffff88801c693398 (_xmit_ETHER#2){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:363 [inline]
ffff88801c693398 (_xmit_ETHER#2){+.-.}-{2:2}, at: __netif_tx_lock include/linux/netdevice.h:4405 [inline]
ffff88801c693398 (_xmit_ETHER#2){+.-.}-{2:2}, at: sch_direct_xmit+0x30f/0xbc0 net/sched/sch_generic.c:340

but task is already holding lock:
ffff88801d04fc98 (_xmit_ETHER#2){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:363 [inline]
ffff88801d04fc98 (_xmit_ETHER#2){+.-.}-{2:2}, at: __netif_tx_lock include/linux/netdevice.h:4405 [inline]
ffff88801d04fc98 (_xmit_ETHER#2){+.-.}-{2:2}, at: sch_direct_xmit+0x30f/0xbc0 net/sched/sch_generic.c:340

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(_xmit_ETHER#2);
  lock(_xmit_ETHER#2);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

7 locks held by syz-executor023/6539:
 #0: ffffffff8b981ac0 (rcu_read_lock_bh){....}-{1:2}, at: lwtunnel_xmit_redirect include/net/lwtunnel.h:95 [inline]
 #0: ffffffff8b981ac0 (rcu_read_lock_bh){....}-{1:2}, at: ip_finish_output2+0x28b/0x2140 net/ipv4/ip_output.c:207
 #1: ffffffff8b981ac0 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1d5/0x36e0 net/core/dev.c:4143
 #2: ffff88801a4f5258 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+...}-{2:2}, at: spin_trylock include/linux/spinlock.h:373 [inline]
 #2: ffff88801a4f5258 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+...}-{2:2}, at: qdisc_run_begin include/net/sch_generic.h:173 [inline]
 #2: ffff88801a4f5258 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+...}-{2:2}, at: __dev_xmit_skb net/core/dev.c:3796 [inline]
 #2: ffff88801a4f5258 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+...}-{2:2}, at: __dev_queue_xmit+0x1222/0x36e0 net/core/dev.c:4177
 #3: ffff88801d04fc98 (_xmit_ETHER#2){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:363 [inline]
 #3: ffff88801d04fc98 (_xmit_ETHER#2){+.-.}-{2:2}, at: __netif_tx_lock include/linux/netdevice.h:4405 [inline]
 #3: ffff88801d04fc98 (_xmit_ETHER#2){+.-.}-{2:2}, at: sch_direct_xmit+0x30f/0xbc0 net/sched/sch_generic.c:340
 #4: ffffffff8b981ac0 (rcu_read_lock_bh){....}-{1:2}, at: lwtunnel_xmit_redirect include/net/lwtunnel.h:95 [inline]
 #4: ffffffff8b981ac0 (rcu_read_lock_bh){....}-{1:2}, at: ip_finish_output2+0x28b/0x2140 net/ipv4/ip_output.c:207
 #5: ffffffff8b981ac0 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1d5/0x36e0 net/core/dev.c:4143
 #6: ffff88807762e258 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+...}-{2:2}, at: spin_trylock include/linux/spinlock.h:373 [inline]
 #6: ffff88807762e258 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+...}-{2:2}, at: qdisc_run_begin include/net/sch_generic.h:173 [inline]
 #6: ffff88807762e258 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+...}-{2:2}, at: __dev_xmit_skb net/core/dev.c:3796 [inline]
 #6: ffff88807762e258 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+...}-{2:2}, at: __dev_queue_xmit+0x1222/0x36e0 net/core/dev.c:4177

stack backtrace:
CPU: 0 PID: 6539 Comm: syz-executor023 Not tainted 5.15.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_deadlock_bug kernel/locking/lockdep.c:2944 [inline]
 check_deadlock kernel/locking/lockdep.c:2987 [inline]
 validate_chain kernel/locking/lockdep.c:3776 [inline]
 __lock_acquire.cold+0x149/0x3ab kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:363 [inline]
 __netif_tx_lock include/linux/netdevice.h:4405 [inline]
 sch_direct_xmit+0x30f/0xbc0 net/sched/sch_generic.c:340
 __dev_xmit_skb net/core/dev.c:3809 [inline]
 __dev_queue_xmit+0x1489/0x36e0 net/core/dev.c:4177
 neigh_resolve_output net/core/neighbour.c:1492 [inline]
 neigh_resolve_output+0x50e/0x820 net/core/neighbour.c:1472
 neigh_output include/net/neighbour.h:510 [inline]
 ip_finish_output2+0x813/0x2140 net/ipv4/ip_output.c:221
 __ip_finish_output net/ipv4/ip_output.c:299 [inline]
 __ip_finish_output+0x396/0x640 net/ipv4/ip_output.c:281
 ip_finish_output+0x32/0x200 net/ipv4/ip_output.c:309
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x196/0x310 net/ipv4/ip_output.c:423
 dst_output include/net/dst.h:450 [inline]
 ip_local_out+0xaf/0x1a0 net/ipv4/ip_output.c:126
 iptunnel_xmit+0x628/0xa50 net/ipv4/ip_tunnel_core.c:82
 ip_tunnel_xmit+0x10a6/0x2b60 net/ipv4/ip_tunnel.c:810
 erspan_xmit+0x7e2/0x29c0 net/ipv4/ip_gre.c:712
 __netdev_start_xmit include/linux/netdevice.h:4988 [inline]
 netdev_start_xmit include/linux/netdevice.h:5002 [inline]
 xmit_one net/core/dev.c:3582 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3598
 sch_direct_xmit+0x19f/0xbc0 net/sched/sch_generic.c:342
 __dev_xmit_skb net/core/dev.c:3809 [inline]
 __dev_queue_xmit+0x1489/0x36e0 net/core/dev.c:4177
 neigh_resolve_output net/core/neighbour.c:1492 [inline]
 neigh_resolve_output+0x50e/0x820 net/core/neighbour.c:1472
 neigh_output include/net/neighbour.h:510 [inline]
 ip_finish_output2+0x813/0x2140 net/ipv4/ip_output.c:221
 __ip_finish_output net/ipv4/ip_output.c:299 [inline]
 __ip_finish_output+0x396/0x640 net/ipv4/ip_output.c:281
 ip_finish_output+0x32/0x200 net/ipv4/ip_output.c:309
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x196/0x310 net/ipv4/ip_output.c:423
 dst_output include/net/dst.h:450 [inline]
 ip_local_out net/ipv4/ip_output.c:126 [inline]
 ip_send_skb+0xd4/0x260 net/ipv4/ip_output.c:1555
 udp_send_skb+0x6cd/0x11a0 net/ipv4/udp.c:967
 udp_sendmsg+0x1bad/0x2740 net/ipv4/udp.c:1254
 udpv6_sendmsg+0x14f6/0x2c40 net/ipv6/udp.c:1360
 inet6_sendmsg+0x99/0xe0 net/ipv6/af_inet6.c:643
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x331/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmmsg+0x195/0x470 net/socket.c:2549
 __do_sys_sendmmsg net/socket.c:2578 [inline]
 __se_sys_sendmmsg net/socket.c:2575 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2575
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f728d0d9aa9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffda2643b88 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f728d0d9aa9
RDX: 0000000000000001 RSI: 0000000020004d8

