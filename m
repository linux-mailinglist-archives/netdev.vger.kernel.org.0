Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4939462D754
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239509AbiKQJoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239458AbiKQJok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:44:40 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1FF70A2C
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:44:36 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id z15-20020a5e860f000000b006c09237cc06so633593ioj.21
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:44:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yOzA7M0oRphYe//oQSb1IcRXYVhgj1pWdcuWOkc9NWA=;
        b=tHX/lXOVDj2RXJGCbxPehXbm6lijBYZgbva/ZkiWRzfqCW+YzU1BfSW1oJw0L4j9hX
         9gNS25b8cNEr7jg0vnHyMd3rw6TSYfexIh8wlqPhrOOshp7cs2KVtWvMVcoL4ZgeyRiU
         bJFOL7BEDLrsOjsI9AHiq1n0i98/yFr7ETO5+iVxRzZmNktg66h1us0dBSOod5n5IUxd
         arOO+HGecYC8jOQ0nKJHuOEDiHtmQDdPDPCPutDh8a7xYDBe/X5XPJja93wVo0MF6B/s
         fsrgzmmFtytLnWTg3MJoz14HfHblwGb9RiTOTrScVOf8QyhrOn7AfQHcGKliPVALO439
         F31Q==
X-Gm-Message-State: ANoB5pn71PQvQH5cbqjKtznUtNf+X9OyREuiF1zAFoIsaWUeNQYHaHu/
        RDI1qGDwUVpS4o1ql0TCkgQUX4z17jBVYuGJGUt69WGgBgyZ
X-Google-Smtp-Source: AA0mqf6UyC7bRuAKwSImKs0Pwjqp16JhTbNgQiBrjpj83ru60WsMM4F8uJm9aQDTTA6S6SvCOlNB4AiDwrfcaEncVGKyo34Jhy8B
MIME-Version: 1.0
X-Received: by 2002:a6b:5904:0:b0:6af:ed54:1c81 with SMTP id
 n4-20020a6b5904000000b006afed541c81mr990843iob.106.1668678275800; Thu, 17 Nov
 2022 01:44:35 -0800 (PST)
Date:   Thu, 17 Nov 2022 01:44:35 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dfa31e05eda76f75@google.com>
Subject: [syzbot] inconsistent lock state in l2tp_tunnel_register
From:   syzbot <syzbot+50680ced9e98a61f7698@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jakub@cloudflare.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, tparkin@katalix.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    064bc7312bd0 netdevsim: Fix memory leak of nsim_dev->fa_co..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=11d00c31880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a33ac7bbc22a8c35
dashboard link: https://syzkaller.appspot.com/bug?extid=50680ced9e98a61f7698
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0634e1c0e4cb/disk-064bc731.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fe1039d2de22/vmlinux-064bc731.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5a0d673875fa/bzImage-064bc731.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+50680ced9e98a61f7698@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
6.1.0-rc4-syzkaller-00212-g064bc7312bd0 #0 Not tainted
--------------------------------
inconsistent {IN-SOFTIRQ-R} -> {SOFTIRQ-ON-W} usage.
syz-executor.4/5661 [HC0[0]:SC0[0]:HE1:SE1] takes:
ffff88807356fbb8 (clock-AF_INET6){+++-}-{2:2}, at: l2tp_tunnel_register+0x126/0x1210 net/l2tp/l2tp_core.c:1477
{IN-SOFTIRQ-R} state was registered at:
  lock_acquire kernel/locking/lockdep.c:5668 [inline]
  lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
  __raw_read_lock_bh include/linux/rwlock_api_smp.h:176 [inline]
  _raw_read_lock_bh+0x3f/0x70 kernel/locking/spinlock.c:252
  rds_tcp_write_space+0x29/0x690 net/rds/tcp_send.c:184
  tcp_new_space net/ipv4/tcp_input.c:5471 [inline]
  tcp_check_space+0x11b/0x810 net/ipv4/tcp_input.c:5490
  tcp_data_snd_check net/ipv4/tcp_input.c:5499 [inline]
  tcp_rcv_established+0x93e/0x2230 net/ipv4/tcp_input.c:6007
  tcp_v6_do_rcv+0x814/0x13c0 net/ipv6/tcp_ipv6.c:1502
  tcp_v6_rcv+0x2ea6/0x3840 net/ipv6/tcp_ipv6.c:1761
  ip6_protocol_deliver_rcu+0x2df/0x1950 net/ipv6/ip6_input.c:439
  ip6_input_finish+0x150/0x2c0 net/ipv6/ip6_input.c:484
  NF_HOOK include/linux/netfilter.h:302 [inline]
  NF_HOOK include/linux/netfilter.h:296 [inline]
  ip6_input+0xa0/0xd0 net/ipv6/ip6_input.c:493
  dst_input include/net/dst.h:455 [inline]
  ip6_rcv_finish net/ipv6/ip6_input.c:79 [inline]
  NF_HOOK include/linux/netfilter.h:302 [inline]
  NF_HOOK include/linux/netfilter.h:296 [inline]
  ipv6_rcv+0x250/0x380 net/ipv6/ip6_input.c:309
  __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5489
  __netif_receive_skb+0x1f/0x1c0 net/core/dev.c:5603
  process_backlog+0x3e4/0x810 net/core/dev.c:5931
  __napi_poll+0xb8/0x770 net/core/dev.c:6498
  napi_poll net/core/dev.c:6565 [inline]
  net_rx_action+0xa00/0xde0 net/core/dev.c:6676
  __do_softirq+0x1fb/0xadc kernel/softirq.c:571
  do_softirq.part.0+0xde/0x130 kernel/softirq.c:472
  do_softirq kernel/softirq.c:464 [inline]
  __local_bh_enable_ip+0x106/0x130 kernel/softirq.c:396
  local_bh_enable include/linux/bottom_half.h:33 [inline]
  rcu_read_unlock_bh include/linux/rcupdate.h:808 [inline]
  ip6_finish_output2+0x5be/0x1530 net/ipv6/ip6_output.c:135
  __ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
  ip6_finish_output+0x694/0x1170 net/ipv6/ip6_output.c:206
  NF_HOOK_COND include/linux/netfilter.h:291 [inline]
  ip6_output+0x1f1/0x540 net/ipv6/ip6_output.c:227
  dst_output include/net/dst.h:445 [inline]
  NF_HOOK include/linux/netfilter.h:302 [inline]
  NF_HOOK include/linux/netfilter.h:296 [inline]
  ip6_xmit+0x11f7/0x1c60 net/ipv6/ip6_output.c:343
  inet6_csk_xmit+0x3b5/0x6d0 net/ipv6/inet6_connection_sock.c:135
  __tcp_transmit_skb+0x1967/0x3800 net/ipv4/tcp_output.c:1402
  __tcp_send_ack.part.0+0x3a7/0x760 net/ipv4/tcp_output.c:3986
  __tcp_send_ack net/ipv4/tcp_output.c:3992 [inline]
  tcp_send_ack+0x81/0xa0 net/ipv4/tcp_output.c:3992
  __tcp_ack_snd_check+0x156/0x9c0 net/ipv4/tcp_input.c:5524
  tcp_ack_snd_check net/ipv4/tcp_input.c:5570 [inline]
  tcp_rcv_established+0x992/0x2230 net/ipv4/tcp_input.c:6008
  tcp_v6_do_rcv+0x814/0x13c0 net/ipv6/tcp_ipv6.c:1502
  sk_backlog_rcv include/net/sock.h:1109 [inline]
  __release_sock+0x133/0x3b0 net/core/sock.c:2906
  release_sock+0x58/0x1b0 net/core/sock.c:3462
  inet_wait_for_connect net/ipv4/af_inet.c:598 [inline]
  __inet_stream_connect+0x757/0xed0 net/ipv4/af_inet.c:690
  inet_stream_connect+0x57/0xa0 net/ipv4/af_inet.c:729
  mptcp_connect+0x4b2/0x8c0 net/mptcp/protocol.c:3573
  __inet_stream_connect+0x69e/0xed0 net/ipv4/af_inet.c:665
  mptcp_stream_connect+0xb0/0x110 net/mptcp/protocol.c:3657
  __sys_connect_file+0x153/0x1a0 net/socket.c:1976
  __sys_connect+0x165/0x1a0 net/socket.c:1993
  __do_sys_connect net/socket.c:2003 [inline]
  __se_sys_connect net/socket.c:2000 [inline]
  __x64_sys_connect+0x73/0xb0 net/socket.c:2000
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
irq event stamp: 189
hardirqs last  enabled at (189): [<ffffffff81567925>] raw_spin_rq_unlock_irq kernel/sched/sched.h:1366 [inline]
hardirqs last  enabled at (189): [<ffffffff81567925>] finish_lock_switch kernel/sched/core.c:4950 [inline]
hardirqs last  enabled at (189): [<ffffffff81567925>] finish_task_switch.isra.0+0x2b5/0xc80 kernel/sched/core.c:5068
hardirqs last disabled at (188): [<ffffffff89f2e55f>] __schedule+0x28df/0x53f0 kernel/sched/core.c:6402
softirqs last  enabled at (164): [<ffffffff88f0411b>] rcu_read_unlock_bh include/linux/rcupdate.h:804 [inline]
softirqs last  enabled at (164): [<ffffffff88f0411b>] l2tp_tunnel_get+0x3fb/0x750 net/l2tp/l2tp_core.c:219
softirqs last disabled at (162): [<ffffffff88f03e6d>] rcu_read_unlock include/linux/rcupdate.h:767 [inline]
softirqs last disabled at (162): [<ffffffff88f03e6d>] net_generic include/net/netns/generic.h:48 [inline]
softirqs last disabled at (162): [<ffffffff88f03e6d>] l2tp_pernet net/l2tp/l2tp_core.c:125 [inline]
softirqs last disabled at (162): [<ffffffff88f03e6d>] l2tp_tunnel_get+0x14d/0x750 net/l2tp/l2tp_core.c:207

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(clock-AF_INET6);
  <Interrupt>
    lock(clock-AF_INET6);

 *** DEADLOCK ***

1 lock held by syz-executor.4/5661:
 #0: ffff88804d331130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1721 [inline]
 #0: ffff88804d331130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: pppol2tp_connect+0xadc/0x1a10 net/l2tp/l2tp_ppp.c:675

stack backtrace:
CPU: 1 PID: 5661 Comm: syz-executor.4 Not tainted 6.1.0-rc4-syzkaller-00212-g064bc7312bd0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_usage_bug kernel/locking/lockdep.c:222 [inline]
 valid_state kernel/locking/lockdep.c:3975 [inline]
 mark_lock_irq kernel/locking/lockdep.c:4184 [inline]
 mark_lock.part.0.cold+0x3a/0xd8 kernel/locking/lockdep.c:4634
 mark_lock kernel/locking/lockdep.c:4598 [inline]
 mark_usage kernel/locking/lockdep.c:4547 [inline]
 __lock_acquire+0x893/0x56d0 kernel/locking/lockdep.c:5009
 lock_acquire kernel/locking/lockdep.c:5668 [inline]
 lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
 __raw_write_lock include/linux/rwlock_api_smp.h:209 [inline]
 _raw_write_lock+0x2e/0x40 kernel/locking/spinlock.c:300
 l2tp_tunnel_register+0x126/0x1210 net/l2tp/l2tp_core.c:1477
 pppol2tp_connect+0xcdc/0x1a10 net/l2tp/l2tp_ppp.c:723
 __sys_connect_file+0x153/0x1a0 net/socket.c:1976
 __sys_connect+0x165/0x1a0 net/socket.c:1993
 __do_sys_connect net/socket.c:2003 [inline]
 __se_sys_connect net/socket.c:2000 [inline]
 __x64_sys_connect+0x73/0xb0 net/socket.c:2000
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f043de8b639
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f043ec50168 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 00007f043dfabf80 RCX: 00007f043de8b639
RDX: 000000000000002e RSI: 0000000020000040 RDI: 0000000000000003
RBP: 00007f043dee6ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc987e1cdf R14: 00007f043ec50300 R15: 0000000000022000
 </TASK>
BUG: sleeping function called from invalid context at include/linux/percpu-rwsem.h:49
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5661, name: syz-executor.4
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 PID: 5661 Comm: syz-executor.4 Not tainted 6.1.0-rc4-syzkaller-00212-g064bc7312bd0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 __might_resched.cold+0x222/0x26b kernel/sched/core.c:9890
 percpu_down_read include/linux/percpu-rwsem.h:49 [inline]
 cpus_read_lock+0x1b/0x140 kernel/cpu.c:310
 static_key_slow_inc+0x12/0x20 kernel/jump_label.c:158
 udp_tunnel_encap_enable include/net/udp_tunnel.h:187 [inline]
 setup_udp_tunnel_sock+0x43d/0x550 net/ipv4/udp_tunnel_core.c:81
 l2tp_tunnel_register+0xc51/0x1210 net/l2tp/l2tp_core.c:1509
 pppol2tp_connect+0xcdc/0x1a10 net/l2tp/l2tp_ppp.c:723
 __sys_connect_file+0x153/0x1a0 net/socket.c:1976
 __sys_connect+0x165/0x1a0 net/socket.c:1993
 __do_sys_connect net/socket.c:2003 [inline]
 __se_sys_connect net/socket.c:2000 [inline]
 __x64_sys_connect+0x73/0xb0 net/socket.c:2000
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f043de8b639
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f043ec50168 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 00007f043dfabf80 RCX: 00007f043de8b639
RDX: 000000000000002e RSI: 0000000020000040 RDI: 0000000000000003
RBP: 00007f043dee6ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc987e1cdf R14: 00007f043ec50300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
