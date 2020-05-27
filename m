Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7501C1E394B
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 08:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgE0GcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 02:32:16 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:54641 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728488AbgE0GcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 02:32:14 -0400
Received: by mail-io1-f69.google.com with SMTP id t23so16272123iog.21
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 23:32:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=TBULOzo9LvPNBBFzoyQ5veFCaN1iX98z2o5DjaAetdA=;
        b=Gk094da1XKmAXfr63XikKk7u/dRhl7UJi5qIN6BWr9bDnj4AZKQ9MmMTaMf21Wl2cI
         qrebfqsjDoA8U/LWJt0g1HYSGRJcbp+B7C6TS5gEBk1MxuQHUSYQzHGlqaay99SrNjVr
         hU6MGMovI/uel0CcYcgsRe8fVq9M3nAiQyKVKonwE7X54lQmHvlI69LkroOj5qPLnA9A
         Bl6pGn+ksFGCpzXkxnnGqwkpvxg9FZQTlq5EzJHgbNAd57UPy2o7mwOrIz1cVCnGCtHQ
         kbtITdxSyM4RucoIdrVPG4nVo+DtZhH2chDOkBI0cpyuDxd3wxJNbPhraWnBqzdNJtXJ
         7W+Q==
X-Gm-Message-State: AOAM530z0C7amfKftG2BwnPvZ0GnaD7rutbvYi+MnXQA8j+zCQuqhVSE
        nhRU85jvYRpUzmnwtKS/LhS41eb1aQW+2G8uEgi0gEFoBF3m
X-Google-Smtp-Source: ABdhPJyYJEpcLX5oo8J+/efKSjBWc4bjDOyL/rkzrGYcq72ZC1hPRfHDDix2aA5lsr5Cw51U9Dk4rFtthu9sN/E7+ztmTbPFy1He
MIME-Version: 1.0
X-Received: by 2002:a92:d6cc:: with SMTP id z12mr4189533ilp.179.1590561131732;
 Tue, 26 May 2020 23:32:11 -0700 (PDT)
Date:   Tue, 26 May 2020 23:32:11 -0700
In-Reply-To: <000000000000e0b6be05a42f555e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004024d505a69b5f0b@google.com>
Subject: Re: KMSAN: uninit-value in bpf_skb_load_helper_32
From:   syzbot <syzbot+ae94def68efda6a4be52@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, glider@google.com,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    94bc4cd0 net: bpf: kmsan: disable CONFIG_BPF_JIT under KMSAN
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=149b3d4a100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=86e4f8af239686c6
dashboard link: https://syzkaller.appspot.com/bug?extid=ae94def68efda6a4be52
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12fc37aa100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14fce3a1100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ae94def68efda6a4be52@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in ____bpf_skb_load_helper_32 net/core/filter.c:238 [inline]
BUG: KMSAN: uninit-value in bpf_skb_load_helper_32+0xee/0x2d0 net/core/filter.c:232
CPU: 1 PID: 8814 Comm: sshd Not tainted 5.7.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 ____bpf_skb_load_helper_32 net/core/filter.c:238 [inline]
 bpf_skb_load_helper_32+0xee/0x2d0 net/core/filter.c:232
 ___bpf_prog_run+0x214d/0x97a0 kernel/bpf/core.c:1516
 __bpf_prog_run32+0x101/0x170 kernel/bpf/core.c:1681
 bpf_dispatcher_nop_func include/linux/bpf.h:545 [inline]
 bpf_prog_run_pin_on_cpu include/linux/filter.h:599 [inline]
 bpf_prog_run_clear_cb include/linux/filter.h:721 [inline]
 run_filter net/packet/af_packet.c:2012 [inline]
 packet_rcv+0x70f/0x2160 net/packet/af_packet.c:2085
 deliver_skb net/core/dev.c:2168 [inline]
 dev_queue_xmit_nit+0x862/0x1270 net/core/dev.c:2238
 xmit_one net/core/dev.c:3473 [inline]
 dev_hard_start_xmit+0x20f/0xab0 net/core/dev.c:3493
 sch_direct_xmit+0x512/0x18b0 net/sched/sch_generic.c:314
 qdisc_restart net/sched/sch_generic.c:377 [inline]
 __qdisc_run+0x15ec/0x3350 net/sched/sch_generic.c:385
 qdisc_run include/net/pkt_sched.h:134 [inline]
 __dev_xmit_skb net/core/dev.c:3668 [inline]
 __dev_queue_xmit+0x23b7/0x3b20 net/core/dev.c:4021
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4085
 neigh_hh_output include/net/neighbour.h:499 [inline]
 neigh_output include/net/neighbour.h:508 [inline]
 ip_finish_output2+0x20fd/0x2610 net/ipv4/ip_output.c:228
 __ip_finish_output+0xaa7/0xd80 net/ipv4/ip_output.c:306
 ip_finish_output+0x166/0x410 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x593/0x680 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:435 [inline]
 ip_local_out net/ipv4/ip_output.c:125 [inline]
 __ip_queue_xmit+0x1b5c/0x21a0 net/ipv4/ip_output.c:530
 ip_queue_xmit+0xcc/0xf0 include/net/ip.h:237
 __tcp_transmit_skb+0x4221/0x6090 net/ipv4/tcp_output.c:1238
 tcp_transmit_skb net/ipv4/tcp_output.c:1254 [inline]
 tcp_write_xmit+0x30e1/0xb470 net/ipv4/tcp_output.c:2517
 __tcp_push_pending_frames+0x124/0x4e0 net/ipv4/tcp_output.c:2693
 tcp_push+0x6fa/0x8a0 net/ipv4/tcp.c:725
 tcp_sendmsg_locked+0x5d89/0x6d00 net/ipv4/tcp.c:1403
 tcp_sendmsg+0xb2/0x100 net/ipv4/tcp.c:1433
 inet_sendmsg+0x178/0x2e0 net/ipv4/af_inet.c:807
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 sock_write_iter+0x606/0x6d0 net/socket.c:1004
 call_write_iter include/linux/fs.h:1907 [inline]
 new_sync_write fs/read_write.c:484 [inline]
 __vfs_write+0xa5a/0xca0 fs/read_write.c:497
 vfs_write+0x444/0x8e0 fs/read_write.c:559
 ksys_write+0x267/0x450 fs/read_write.c:612
 __do_sys_write fs/read_write.c:624 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:621
 __x64_sys_write+0x4a/0x70 fs/read_write.c:621
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:297
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f155876b970
Code: 73 01 c3 48 8b 0d 28 d5 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 99 2d 2c 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 7e 9b 01 00 48 89 04 24
RSP: 002b:00007ffc12f70e38 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000034 RCX: 00007f155876b970
RDX: 0000000000000034 RSI: 000055fc293bc0a4 RDI: 0000000000000003
RBP: 000055fc293ad0b0 R08: 00007ffc12fb4080 R09: 0000000000000070
R10: 000000000000006f R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffc12f70ecf R14: 000055fc27f2fbe7 R15: 0000000000000003

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 __msan_chain_origin+0x50/0x90 mm/kmsan/kmsan_instr.c:165
 ___bpf_prog_run+0x6c80/0x97a0 kernel/bpf/core.c:1391
 __bpf_prog_run32+0x101/0x170 kernel/bpf/core.c:1681
 bpf_dispatcher_nop_func include/linux/bpf.h:545 [inline]
 bpf_prog_run_pin_on_cpu include/linux/filter.h:599 [inline]
 bpf_prog_run_clear_cb include/linux/filter.h:721 [inline]
 run_filter net/packet/af_packet.c:2012 [inline]
 packet_rcv+0x70f/0x2160 net/packet/af_packet.c:2085
 deliver_skb net/core/dev.c:2168 [inline]
 dev_queue_xmit_nit+0x862/0x1270 net/core/dev.c:2238
 xmit_one net/core/dev.c:3473 [inline]
 dev_hard_start_xmit+0x20f/0xab0 net/core/dev.c:3493
 sch_direct_xmit+0x512/0x18b0 net/sched/sch_generic.c:314
 qdisc_restart net/sched/sch_generic.c:377 [inline]
 __qdisc_run+0x15ec/0x3350 net/sched/sch_generic.c:385
 qdisc_run include/net/pkt_sched.h:134 [inline]
 __dev_xmit_skb net/core/dev.c:3668 [inline]
 __dev_queue_xmit+0x23b7/0x3b20 net/core/dev.c:4021
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4085
 neigh_hh_output include/net/neighbour.h:499 [inline]
 neigh_output include/net/neighbour.h:508 [inline]
 ip_finish_output2+0x20fd/0x2610 net/ipv4/ip_output.c:228
 __ip_finish_output+0xaa7/0xd80 net/ipv4/ip_output.c:306
 ip_finish_output+0x166/0x410 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x593/0x680 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:435 [inline]
 ip_local_out net/ipv4/ip_output.c:125 [inline]
 __ip_queue_xmit+0x1b5c/0x21a0 net/ipv4/ip_output.c:530
 ip_queue_xmit+0xcc/0xf0 include/net/ip.h:237
 __tcp_transmit_skb+0x4221/0x6090 net/ipv4/tcp_output.c:1238
 tcp_transmit_skb net/ipv4/tcp_output.c:1254 [inline]
 tcp_write_xmit+0x30e1/0xb470 net/ipv4/tcp_output.c:2517
 __tcp_push_pending_frames+0x124/0x4e0 net/ipv4/tcp_output.c:2693
 tcp_push+0x6fa/0x8a0 net/ipv4/tcp.c:725
 tcp_sendmsg_locked+0x5d89/0x6d00 net/ipv4/tcp.c:1403
 tcp_sendmsg+0xb2/0x100 net/ipv4/tcp.c:1433
 inet_sendmsg+0x178/0x2e0 net/ipv4/af_inet.c:807
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 sock_write_iter+0x606/0x6d0 net/socket.c:1004
 call_write_iter include/linux/fs.h:1907 [inline]
 new_sync_write fs/read_write.c:484 [inline]
 __vfs_write+0xa5a/0xca0 fs/read_write.c:497
 vfs_write+0x444/0x8e0 fs/read_write.c:559
 ksys_write+0x267/0x450 fs/read_write.c:612
 __do_sys_write fs/read_write.c:624 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:621
 __x64_sys_write+0x4a/0x70 fs/read_write.c:621
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:297
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 __msan_chain_origin+0x50/0x90 mm/kmsan/kmsan_instr.c:165
 ___bpf_prog_run+0x6cbe/0x97a0 kernel/bpf/core.c:1391
 __bpf_prog_run32+0x101/0x170 kernel/bpf/core.c:1681
 bpf_dispatcher_nop_func include/linux/bpf.h:545 [inline]
 bpf_prog_run_pin_on_cpu include/linux/filter.h:599 [inline]
 bpf_prog_run_clear_cb include/linux/filter.h:721 [inline]
 run_filter net/packet/af_packet.c:2012 [inline]
 packet_rcv+0x70f/0x2160 net/packet/af_packet.c:2085
 deliver_skb net/core/dev.c:2168 [inline]
 dev_queue_xmit_nit+0x862/0x1270 net/core/dev.c:2238
 xmit_one net/core/dev.c:3473 [inline]
 dev_hard_start_xmit+0x20f/0xab0 net/core/dev.c:3493
 sch_direct_xmit+0x512/0x18b0 net/sched/sch_generic.c:314
 qdisc_restart net/sched/sch_generic.c:377 [inline]
 __qdisc_run+0x15ec/0x3350 net/sched/sch_generic.c:385
 qdisc_run include/net/pkt_sched.h:134 [inline]
 __dev_xmit_skb net/core/dev.c:3668 [inline]
 __dev_queue_xmit+0x23b7/0x3b20 net/core/dev.c:4021
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4085
 neigh_hh_output include/net/neighbour.h:499 [inline]
 neigh_output include/net/neighbour.h:508 [inline]
 ip_finish_output2+0x20fd/0x2610 net/ipv4/ip_output.c:228
 __ip_finish_output+0xaa7/0xd80 net/ipv4/ip_output.c:306
 ip_finish_output+0x166/0x410 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x593/0x680 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:435 [inline]
 ip_local_out net/ipv4/ip_output.c:125 [inline]
 __ip_queue_xmit+0x1b5c/0x21a0 net/ipv4/ip_output.c:530
 ip_queue_xmit+0xcc/0xf0 include/net/ip.h:237
 __tcp_transmit_skb+0x4221/0x6090 net/ipv4/tcp_output.c:1238
 tcp_transmit_skb net/ipv4/tcp_output.c:1254 [inline]
 tcp_write_xmit+0x30e1/0xb470 net/ipv4/tcp_output.c:2517
 __tcp_push_pending_frames+0x124/0x4e0 net/ipv4/tcp_output.c:2693
 tcp_push+0x6fa/0x8a0 net/ipv4/tcp.c:725
 tcp_sendmsg_locked+0x5d89/0x6d00 net/ipv4/tcp.c:1403
 tcp_sendmsg+0xb2/0x100 net/ipv4/tcp.c:1433
 inet_sendmsg+0x178/0x2e0 net/ipv4/af_inet.c:807
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 sock_write_iter+0x606/0x6d0 net/socket.c:1004
 call_write_iter include/linux/fs.h:1907 [inline]
 new_sync_write fs/read_write.c:484 [inline]
 __vfs_write+0xa5a/0xca0 fs/read_write.c:497
 vfs_write+0x444/0x8e0 fs/read_write.c:559
 ksys_write+0x267/0x450 fs/read_write.c:612
 __do_sys_write fs/read_write.c:624 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:621
 __x64_sys_write+0x4a/0x70 fs/read_write.c:621
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:297
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 __msan_chain_origin+0x50/0x90 mm/kmsan/kmsan_instr.c:165
 ___bpf_prog_run+0x6c64/0x97a0 kernel/bpf/core.c:1391
 __bpf_prog_run32+0x101/0x170 kernel/bpf/core.c:1681
 bpf_dispatcher_nop_func include/linux/bpf.h:545 [inline]
 bpf_prog_run_pin_on_cpu include/linux/filter.h:599 [inline]
 bpf_prog_run_clear_cb include/linux/filter.h:721 [inline]
 run_filter net/packet/af_packet.c:2012 [inline]
 packet_rcv+0x70f/0x2160 net/packet/af_packet.c:2085
 deliver_skb net/core/dev.c:2168 [inline]
 dev_queue_xmit_nit+0x862/0x1270 net/core/dev.c:2238
 xmit_one net/core/dev.c:3473 [inline]
 dev_hard_start_xmit+0x20f/0xab0 net/core/dev.c:3493
 sch_direct_xmit+0x512/0x18b0 net/sched/sch_generic.c:314
 qdisc_restart net/sched/sch_generic.c:377 [inline]
 __qdisc_run+0x15ec/0x3350 net/sched/sch_generic.c:385
 qdisc_run include/net/pkt_sched.h:134 [inline]
 __dev_xmit_skb net/core/dev.c:3668 [inline]
 __dev_queue_xmit+0x23b7/0x3b20 net/core/dev.c:4021
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4085
 neigh_hh_output include/net/neighbour.h:499 [inline]
 neigh_output include/net/neighbour.h:508 [inline]
 ip_finish_output2+0x20fd/0x2610 net/ipv4/ip_output.c:228
 __ip_finish_output+0xaa7/0xd80 net/ipv4/ip_output.c:306
 ip_finish_output+0x166/0x410 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x593/0x680 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:435 [inline]
 ip_local_out net/ipv4/ip_output.c:125 [inline]
 __ip_queue_xmit+0x1b5c/0x21a0 net/ipv4/ip_output.c:530
 ip_queue_xmit+0xcc/0xf0 include/net/ip.h:237
 __tcp_transmit_skb+0x4221/0x6090 net/ipv4/tcp_output.c:1238
 tcp_transmit_skb net/ipv4/tcp_output.c:1254 [inline]
 tcp_write_xmit+0x30e1/0xb470 net/ipv4/tcp_output.c:2517
 __tcp_push_pending_frames+0x124/0x4e0 net/ipv4/tcp_output.c:2693
 tcp_push+0x6fa/0x8a0 net/ipv4/tcp.c:725
 tcp_sendmsg_locked+0x5d89/0x6d00 net/ipv4/tcp.c:1403
 tcp_sendmsg+0xb2/0x100 net/ipv4/tcp.c:1433
 inet_sendmsg+0x178/0x2e0 net/ipv4/af_inet.c:807
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 sock_write_iter+0x606/0x6d0 net/socket.c:1004
 call_write_iter include/linux/fs.h:1907 [inline]
 new_sync_write fs/read_write.c:484 [inline]
 __vfs_write+0xa5a/0xca0 fs/read_write.c:497
 vfs_write+0x444/0x8e0 fs/read_write.c:559
 ksys_write+0x267/0x450 fs/read_write.c:612
 __do_sys_write fs/read_write.c:624 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:621
 __x64_sys_write+0x4a/0x70 fs/read_write.c:621
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:297
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Local variable ----regs@__bpf_prog_run32 created at:
 __bpf_prog_run32+0x87/0x170 kernel/bpf/core.c:1681
 __bpf_prog_run32+0x87/0x170 kernel/bpf/core.c:1681
=====================================================

