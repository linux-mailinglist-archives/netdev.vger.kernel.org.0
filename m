Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83006233FC6
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731578AbgGaHMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:12:21 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:48577 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731478AbgGaHMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 03:12:20 -0400
Received: by mail-io1-f70.google.com with SMTP id r9so20416329ioa.15
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 00:12:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=aUxtjOcPerbND18bxBEjQf9gmIKV1xAykagpo6fUrVc=;
        b=ktoSb36fvja7m7ftwepT3kTk+MzlDzXNwgK6qSxblGWtPUVSlg6D853dSJuDxk+iv/
         MaNB0GaturzDhr3m684Cw04UnjLVPwIfBSYYnbo0PPsRvtn5Fsr8KZEcnUMXKcDBJ6uY
         Hboe39MjKgTlaxXCm7oO37AnPYv7nkrNqSJWi/GoRp3KibydlddfMsUoWinj3jKe6DUS
         Ngr8iJhMts0w9IISwMkKTOantrJZYIp3AnLcuzkutYDt38LGjIBERW1hjO1h1v/A9JF1
         b5kXiAykj6Ezjm/PpJwDVAYcGa69wf+d4XsSqZZWrimK5KoSRDt4zotNBFkr9bq/Iue+
         QyWw==
X-Gm-Message-State: AOAM531MKIEIHiFenPXF9oO4zmkU79XF9TTd6n1PTwRRyipC9HJw2Twn
        5heIDB5q9IO8yLryiQpAv6b5BG6tz8dFuPFD3WUOHeOhr7TK
X-Google-Smtp-Source: ABdhPJylYBmtTMj+meBKHLbrJXtzcC43diPy8s7xPYd5B+a0CBWJ4PZN8ExMFN6VtFCSa/DTE+WckzQ6Y2R+yJkIUms08ExWtSed
MIME-Version: 1.0
X-Received: by 2002:a92:aa49:: with SMTP id j70mr2425358ili.107.1596179539202;
 Fri, 31 Jul 2020 00:12:19 -0700 (PDT)
Date:   Fri, 31 Jul 2020 00:12:19 -0700
In-Reply-To: <000000000000ea90600598c9b089@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006e9b7805abb782d0@google.com>
Subject: Re: possible deadlock in __dev_queue_xmit (3)
From:   syzbot <syzbot+3b165dac15094065651e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    27a2145d ibmvnic: Fix IRQ mapping disposal in error path
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=10587750900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ca6448d2af2ba351
dashboard link: https://syzkaller.appspot.com/bug?extid=3b165dac15094065651e
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b6f360900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e40f82900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3b165dac15094065651e@syzkaller.appspotmail.com

batman_adv: batadv0: Interface activated: batadv_slave_1
============================================
WARNING: possible recursive locking detected
5.8.0-rc6-syzkaller #0 Not tainted
--------------------------------------------
syz-executor763/6837 is trying to acquire lock:
ffff88809422c498 (_xmit_ETHER#2){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:353 [inline]
ffff88809422c498 (_xmit_ETHER#2){+.-.}-{2:2}, at: __netif_tx_lock include/linux/netdevice.h:4085 [inline]
ffff88809422c498 (_xmit_ETHER#2){+.-.}-{2:2}, at: __dev_queue_xmit+0x215e/0x2d60 net/core/dev.c:4127

but task is already holding lock:
ffff88808e198498 (_xmit_ETHER#2){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:353 [inline]
ffff88808e198498 (_xmit_ETHER#2){+.-.}-{2:2}, at: __netif_tx_lock include/linux/netdevice.h:4085 [inline]
ffff88808e198498 (_xmit_ETHER#2){+.-.}-{2:2}, at: sch_direct_xmit+0x25c/0xc00 net/sched/sch_generic.c:311

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(_xmit_ETHER#2);
  lock(_xmit_ETHER#2);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

11 locks held by syz-executor763/6837:
 #0: ffffffff89bc11c0 (rcu_read_lock){....}-{1:2}, at: l3mdev_l3_out include/net/l3mdev.h:179 [inline]
 #0: ffffffff89bc11c0 (rcu_read_lock){....}-{1:2}, at: l3mdev_ip6_out include/net/l3mdev.h:200 [inline]
 #0: ffffffff89bc11c0 (rcu_read_lock){....}-{1:2}, at: rawv6_send_hdrinc net/ipv6/raw.c:677 [inline]
 #0: ffffffff89bc11c0 (rcu_read_lock){....}-{1:2}, at: rawv6_sendmsg+0x1dda/0x38f0 net/ipv6/raw.c:944
 #1: ffffffff89bc1160 (rcu_read_lock_bh){....}-{1:2}, at: lwtunnel_xmit_redirect include/net/lwtunnel.h:92 [inline]
 #1: ffffffff89bc1160 (rcu_read_lock_bh){....}-{1:2}, at: ip6_finish_output2+0x190/0x17b0 net/ipv6/ip6_output.c:103
 #2: ffffffff89bc1160 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1da/0x2d60 net/core/dev.c:4066
 #3: ffff8880942ed258 (&sch->seqlock){+...}-{2:2}, at: spin_trylock include/linux/spinlock.h:363 [inline]
 #3: ffff8880942ed258 (&sch->seqlock){+...}-{2:2}, at: qdisc_run_begin include/net/sch_generic.h:159 [inline]
 #3: ffff8880942ed258 (&sch->seqlock){+...}-{2:2}, at: qdisc_run include/net/pkt_sched.h:128 [inline]
 #3: ffff8880942ed258 (&sch->seqlock){+...}-{2:2}, at: __dev_xmit_skb net/core/dev.c:3747 [inline]
 #3: ffff8880942ed258 (&sch->seqlock){+...}-{2:2}, at: __dev_queue_xmit+0x1310/0x2d60 net/core/dev.c:4100
 #4: ffff8880942ed148 (dev->qdisc_running_key ?: &qdisc_running_key){+...}-{0:0}, at: neigh_resolve_output net/core/neighbour.c:1489 [inline]
 #4: ffff8880942ed148 (dev->qdisc_running_key ?: &qdisc_running_key){+...}-{0:0}, at: neigh_resolve_output+0x3fe/0x6a0 net/core/neighbour.c:1469
 #5: ffff88808e198498 (_xmit_ETHER#2){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:353 [inline]
 #5: ffff88808e198498 (_xmit_ETHER#2){+.-.}-{2:2}, at: __netif_tx_lock include/linux/netdevice.h:4085 [inline]
 #5: ffff88808e198498 (_xmit_ETHER#2){+.-.}-{2:2}, at: sch_direct_xmit+0x25c/0xc00 net/sched/sch_generic.c:311
 #6: ffffffff89bc11c0 (rcu_read_lock){....}-{1:2}, at: icmpv6_send+0x0/0x210 net/ipv6/ip6_icmp.c:31
 #7: ffff88809202d820 (k-slock-AF_INET6){+...}-{2:2}, at: spin_trylock include/linux/spinlock.h:363 [inline]
 #7: ffff88809202d820 (k-slock-AF_INET6){+...}-{2:2}, at: icmpv6_xmit_lock net/ipv6/icmp.c:117 [inline]
 #7: ffff88809202d820 (k-slock-AF_INET6){+...}-{2:2}, at: icmp6_send+0xe82/0x2660 net/ipv6/icmp.c:538
 #8: ffffffff89bc11c0 (rcu_read_lock){....}-{1:2}, at: icmp6_send+0x1453/0x2660 net/ipv6/icmp.c:598
 #9: ffffffff89bc1160 (rcu_read_lock_bh){....}-{1:2}, at: lwtunnel_xmit_redirect include/net/lwtunnel.h:92 [inline]
 #9: ffffffff89bc1160 (rcu_read_lock_bh){....}-{1:2}, at: ip6_finish_output2+0x190/0x17b0 net/ipv6/ip6_output.c:103
 #10: ffffffff89bc1160 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1da/0x2d60 net/core/dev.c:4066

stack backtrace:
CPU: 0 PID: 6837 Comm: syz-executor763 Not tainted 5.8.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_deadlock_bug kernel/locking/lockdep.c:2391 [inline]
 check_deadlock kernel/locking/lockdep.c:2432 [inline]
 validate_chain kernel/locking/lockdep.c:3202 [inline]
 __lock_acquire.cold+0x178/0x3f8 kernel/locking/lockdep.c:4380
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:4959
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:353 [inline]
 __netif_tx_lock include/linux/netdevice.h:4085 [inline]
 __dev_queue_xmit+0x215e/0x2d60 net/core/dev.c:4127
 neigh_resolve_output net/core/neighbour.c:1489 [inline]
 neigh_resolve_output+0x3fe/0x6a0 net/core/neighbour.c:1469
 neigh_output include/net/neighbour.h:509 [inline]
 ip6_finish_output2+0x8b6/0x17b0 net/ipv6/ip6_output.c:117
 __ip6_finish_output net/ipv6/ip6_output.c:143 [inline]
 __ip6_finish_output+0x447/0xab0 net/ipv6/ip6_output.c:128
 ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x1db/0x520 net/ipv6/ip6_output.c:176
 dst_output include/net/dst.h:443 [inline]
 ip6_local_out+0xaf/0x1a0 net/ipv6/output_core.c:179
 ip6_send_skb+0xb7/0x340 net/ipv6/ip6_output.c:1865
 ip6_push_pending_frames+0xbd/0xe0 net/ipv6/ip6_output.c:1885
 icmpv6_push_pending_frames+0x294/0x470 net/ipv6/icmp.c:304
 icmp6_send+0x1cec/0x2660 net/ipv6/icmp.c:617
 icmpv6_send+0xde/0x210 net/ipv6/ip6_icmp.c:43
 ip6_link_failure+0x26/0x500 net/ipv6/route.c:2668
 dst_link_failure include/net/dst.h:426 [inline]
 ip_tunnel_xmit+0x15cc/0x2ac3 net/ipv4/ip_tunnel.c:822
 erspan_xmit+0x1109/0x2760 net/ipv4/ip_gre.c:704
 __netdev_start_xmit include/linux/netdevice.h:4611 [inline]
 netdev_start_xmit include/linux/netdevice.h:4625 [inline]
 xmit_one net/core/dev.c:3556 [inline]
 dev_hard_start_xmit+0x193/0x950 net/core/dev.c:3572
 sch_direct_xmit+0x2ea/0xc00 net/sched/sch_generic.c:313
 qdisc_restart net/sched/sch_generic.c:376 [inline]
 __qdisc_run+0x4b9/0x1630 net/sched/sch_generic.c:384
 qdisc_run include/net/pkt_sched.h:134 [inline]
 qdisc_run include/net/pkt_sched.h:126 [inline]
 __dev_xmit_skb net/core/dev.c:3747 [inline]
 __dev_queue_xmit+0x1456/0x2d60 net/core/dev.c:4100
 neigh_resolve_output net/core/neighbour.c:1489 [inline]
 neigh_resolve_output+0x3fe/0x6a0 net/core/neighbour.c:1469
 neigh_output include/net/neighbour.h:509 [inline]
 ip6_finish_output2+0x8b6/0x17b0 net/ipv6/ip6_output.c:117
 __ip6_finish_output net/ipv6/ip6_output.c:143 [inline]
 __ip6_finish_output+0x447/0xab0 net/ipv6/ip6_output.c:128
 ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x1db/0x520 net/ipv6/ip6_output.c:176
 dst_output include/net/dst.h:443 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 rawv6_send_hdrinc net/ipv6/raw.c:687 [inline]
 rawv6_sendmsg+0x2008/0x38f0 net/ipv6/raw.c:944
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:814
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 sock_write_iter+0x28c/0x3c0 net/socket.c:999
 call_write_iter include/linux/fs.h:1908 [inline]
 new_sync_write+0x422/0x650 fs/read_write.c:503
 vfs_write+0x59d/0x6b0 fs/read_write.c:578
 ksys_write+0x1ee/0x250 fs/read_write.c:631
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x449119
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b 0e fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd62fa0718 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007ffd62fa0780 RCX: 0000000000449119
RDX: 0000000000000028 RSI: 0000000020000140 RDI: 0000000000000005
RBP: 0000000000000000 R08: 00000000000000ff R09: 00000000000000ff
R10: 00000000000000ff R11: 0000000000000246 R12: 0000000000000004
R13: 0000000000000003 R14: 0000000001d2f850 R15: 0000000000000001

