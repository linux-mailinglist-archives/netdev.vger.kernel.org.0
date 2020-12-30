Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F72E2E7C2B
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 20:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgL3Tg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 14:36:57 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:46564 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgL3Tg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 14:36:57 -0500
Received: by mail-il1-f198.google.com with SMTP id x14so16037643ilg.13
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 11:36:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=8DohtywsOUHdC+Lz+XvnCoMiuFdtvrPE+ayhpr5OuhQ=;
        b=kDSGkQh9fc0cCVvq4Wha+R7PmPIMQPz0ScvFfZeWb4Y5Lw6aeyC9YRq3ZDViIBYVOU
         LH2wCf1xPJibfcHa9yOVfle2i0knW+4wvuqrSxbqhoPvV7LWXS+4iTSnBNjWaYh2O7Eg
         9aruyPbLsa9aSbrcgF2ngdMCR//ALSoGkE64QN3xjKPdBqDQwVSaxSIeymbsNfmAb75m
         8F65Nz83phnGRKVF/AotOQJo21vOa5rH6p0l5svFIapAMCYvRuoma7UmCxvcN6CSRZkQ
         hWCI6QvSMkw51EvReaQqpI1ysR0QEC0n6F7tojfNQnga+UfOfXXhBs2EoIb74Pbpu7XA
         lNFg==
X-Gm-Message-State: AOAM530uqVwvckL/lVWQ255Mrm/XiA+TXeD7+hURy/3ZTzr+bGRDuHsM
        wKrwfvTKt6LLkK1glYzNN9v8Gt6jWVu81lRBPhUJmVl0dSv7
X-Google-Smtp-Source: ABdhPJx2HrtbSylw5/QJ7cd3aUiHiBtIxCRTxy5/a3e4gchAaqEfA9DFZO5O6xQLmFAGPLPH69Wwb8xUNJAoGDAsQzi/QubCLF2a
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17ce:: with SMTP id z14mr52469169ilu.124.1609356975634;
 Wed, 30 Dec 2020 11:36:15 -0800 (PST)
Date:   Wed, 30 Dec 2020 11:36:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d97f4805b7b39e26@google.com>
Subject: general protection fault in dst_dev_put (6)
From:   syzbot <syzbot+0f1d7ae54b1e86cb1b67@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linmiaohe@huawei.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    40f78232 Merge tag 'pci-v5.11-fixes-1' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17310277500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9798d6898fec8a72
dashboard link: https://syzkaller.appspot.com/bug?extid=0f1d7ae54b1e86cb1b67
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0f1d7ae54b1e86cb1b67@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 8482 Comm: syz-fuzzer Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:dst_dev_put+0x1d/0x220 net/core/dst.c:156
Code: a0 b1 fa e9 53 ff ff ff cc cc cc cc cc 41 54 55 53 48 89 fb e8 64 b2 6e fa 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 8b 01 00 00 48 8d 7b 3a 4c 8b 23 48 b8 00 00 00
RSP: 0018:ffffc90000007db8 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 000000000000000f RCX: 0000000000000100
RDX: 0000000000000001 RSI: ffffffff87049d6c RDI: 000000000000000f
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87926f33 R11: 0000000000000001 R12: 0000000000000007
R13: fffffbfff1af7aec R14: 0000607f4607e398 R15: 000000000000000f
FS:  000000c0002a0e90(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c000b37000 CR3: 0000000019e32000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 rt_fibinfo_free_cpus.part.0+0x118/0x180 net/ipv4/fib_semantics.c:202
 rt_fibinfo_free_cpus net/ipv4/fib_semantics.c:194 [inline]
 fib_nh_common_release+0xfb/0x300 net/ipv4/fib_semantics.c:215
 fib6_info_destroy_rcu+0x187/0x210 net/ipv6/ip6_fib.c:174
 rcu_do_batch kernel/rcu/tree.c:2489 [inline]
 rcu_core+0x75d/0xf80 kernel/rcu/tree.c:2723
 __do_softirq+0x2bc/0xa77 kernel/softirq.c:343
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:226 [inline]
 __irq_exit_rcu+0x17f/0x200 kernel/softirq.c:420
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:432
 sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1096
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:628
RIP: 0010:stack_trace_consume_entry+0xd5/0x160 kernel/stacktrace.c:92
Code: 0f 85 92 00 00 00 8d 45 01 89 43 10 48 8b 03 48 8d 2c e8 48 b8 00 00 00 00 00 fc ff df 48 89 ea 48 c1 ea 03 80 3c 02 00 75 5c <48> 89 75 00 8b 43 08 39 43 10 0f 92 c0 48 83 c4 08 5b 5d c3 83 e8
RSP: 0018:ffffc900011ef5d8 EFLAGS: 00000246
RAX: dffffc0000000000 RBX: ffffc900011ef6b0 RCX: 0000000000000000
RDX: 1ffff9200023deeb RSI: ffffffff86f8c6ef RDI: ffffc900011ef6bc
RBP: ffffc900011ef758 R08: ffffffff8e6efcd6 R09: 0000000000000001
R10: fffff5200023deca R11: 0000000000000001 R12: ffffc900011ef6b0
R13: 0000000000000000 R14: ffff88802805c380 R15: 0000000000000280
 arch_stack_walk+0x6d/0xe0 arch/x86/kernel/stacktrace.c:27
 stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:121
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:401 [inline]
 ____kasan_kmalloc.constprop.0+0x7f/0xa0 mm/kasan/common.c:429
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0xae/0x5c0 net/core/skbuff.c:210
 alloc_skb_fclone include/linux/skbuff.h:1149 [inline]
 sk_stream_alloc_skb+0x109/0xc30 net/ipv4/tcp.c:888
 tcp_sendmsg_locked+0xc00/0x2da0 net/ipv4/tcp.c:1310
 tcp_sendmsg+0x2b/0x40 net/ipv4/tcp.c:1459
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:817
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 sock_write_iter+0x289/0x3c0 net/socket.c:999
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:518
 vfs_write+0x7dd/0xa80 fs/read_write.c:605
 ksys_write+0x1ee/0x250 fs/read_write.c:658
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4b117b
Code: ff e9 69 ff ff ff cc cc cc cc cc cc cc cc cc e8 9b c2 f8 ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 28 ff ff ff ff 48 c7 44 24 30
RSP: 002b:000000c000575480 EFLAGS: 00000206 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000c000020800 RCX: 00000000004b117b
RDX: 00000000000000f0 RSI: 000000c00000a200 RDI: 0000000000000006
RBP: 000000c0005754d0 R08: 000000c00000a201 R09: 00000000000000f0
R10: 000000c0002d2900 R11: 0000000000000206 R12: 000000000000011e
R13: 000000c000622000 R14: 000000000000007f R15: ffffffffffff9704
Modules linked in:
---[ end trace ecce8c4927ee85a9 ]---
RIP: 0010:dst_dev_put+0x1d/0x220 net/core/dst.c:156
Code: a0 b1 fa e9 53 ff ff ff cc cc cc cc cc 41 54 55 53 48 89 fb e8 64 b2 6e fa 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 8b 01 00 00 48 8d 7b 3a 4c 8b 23 48 b8 00 00 00
RSP: 0018:ffffc90000007db8 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 000000000000000f RCX: 0000000000000100
RDX: 0000000000000001 RSI: ffffffff87049d6c RDI: 000000000000000f
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87926f33 R11: 0000000000000001 R12: 0000000000000007
R13: fffffbfff1af7aec R14: 0000607f4607e398 R15: 000000000000000f
FS:  000000c0002a0e90(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c000b37000 CR3: 0000000019e32000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
