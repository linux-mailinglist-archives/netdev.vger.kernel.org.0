Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC3C4DE786
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 12:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242740AbiCSLIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 07:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238479AbiCSLIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 07:08:47 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16292B5EDC
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 04:07:26 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id w25-20020a6bd619000000b00640ddd0ad11so6861730ioa.2
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 04:07:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=e6y/LMkwBzzvBIIX2ItukUDPj61hyG5GWzpzFijhnT0=;
        b=NzWrorE2of7mBUgG6MJwIPGwxfiio51S0DAhM8lUy2VGa3b2+l+081zTXNNhWy3LU2
         fm3Uq1IN0oGiqG476AYtx/xSn+DbDQ2AP5jvmoXPZhubeNERaBI8WatCmVNaLzvnHt0H
         S1XMwtFoQQgYzS0aYfjzeuuyGWG87upOaLgJUBsbneo8hx9vVmVvkJZS1eOPpruI48rG
         MimMz6VcjldAnonUkHW1zJt9v1AOqFQ4ytJOD3LkJmVLB16ZAgwj8Nhtm2CoosqWXBCx
         3CZGBaLBMA30lD90Szux5Pu2APbNxFGx9HdebVxmZN68RlTojlt5CMvfm85LfbD2nY3u
         VvBg==
X-Gm-Message-State: AOAM533rSZ5BZ0srdQYXqr/qRS2cg6iwaEXwRzsTP8kjYpGA/LSJq8t/
        tpMqknw+JbrWGctsc+Tc2aAt/22q1J6I+h9S5OXR8qKJO+FU
X-Google-Smtp-Source: ABdhPJwsdfIpFuPQQFSEQD3CO0Lgpzlm84lgfuzIq6ygO+yqJ+etGk3z4zQUDvTkouvcWqzZivuaP7/djDBIJCU2wzDHK3G1Fthc
MIME-Version: 1.0
X-Received: by 2002:a5e:8d15:0:b0:645:c856:e84a with SMTP id
 m21-20020a5e8d15000000b00645c856e84amr6340646ioj.84.1647688046048; Sat, 19
 Mar 2022 04:07:26 -0700 (PDT)
Date:   Sat, 19 Mar 2022 04:07:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af7f9905da904400@google.com>
Subject: [syzbot] KASAN: use-after-free Read in dst_destroy
From:   syzbot <syzbot+736f4a4f98b21dba48f0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yajun.deng@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d96657dc9238 Merge branch 'macvlan-uaf'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15517703700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=71e1d45d16ac39db
dashboard link: https://syzkaller.appspot.com/bug?extid=736f4a4f98b21dba48f0
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+736f4a4f98b21dba48f0@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in dst_destroy+0x3c7/0x400 net/core/dst.c:118
Read of size 8 at addr ffff888014d8a3f0 by task swapper/0/0

CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.17.0-rc7-syzkaller-02443-gd96657dc9238 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x336 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 dst_destroy+0x3c7/0x400 net/core/dst.c:118
 rcu_do_batch kernel/rcu/tree.c:2527 [inline]
 rcu_core+0x7b1/0x1820 kernel/rcu/tree.c:2778
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:130 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:116 [inline]
RIP: 0010:acpi_idle_do_entry+0x1c6/0x250 drivers/acpi/processor_idle.c:556
Code: 89 de e8 9d 8a 24 f8 84 db 75 ac e8 14 88 24 f8 e8 ef c5 2a f8 eb 0c e8 08 88 24 f8 0f 00 2d c1 83 bd 00 e8 fc 87 24 f8 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 d7 8b 24 f8 48 85 db
RSP: 0018:ffffffff8b807d60 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffffffff8b8bc6c0 RSI: ffffffff895438a4 RDI: 0000000000000000
RBP: ffff888011a7c864 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff817efeb8 R11: 0000000000000000 R12: 0000000000000001
R13: ffff888011a7c800 R14: ffff888011a7c864 R15: ffff88801822d004
 acpi_idle_enter+0x361/0x500 drivers/acpi/processor_idle.c:692
 cpuidle_enter_state+0x1b1/0xc80 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:158 [inline]
 cpuidle_idle_call kernel/sched/idle.c:239 [inline]
 do_idle+0x3e8/0x590 kernel/sched/idle.c:306
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:403
 start_kernel+0x47f/0x4a0 init/main.c:1140
 secondary_startup_64_no_verify+0xc3/0xcb
 </TASK>

Allocated by task 3627:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 __kasan_slab_alloc+0x90/0xc0 mm/kasan/common.c:469
 kasan_slab_alloc include/linux/kasan.h:260 [inline]
 slab_post_alloc_hook mm/slab.h:732 [inline]
 slab_alloc_node mm/slub.c:3230 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 kmem_cache_alloc+0x271/0x4b0 mm/slub.c:3243
 kmem_cache_zalloc include/linux/slab.h:704 [inline]
 net_alloc net/core/net_namespace.c:403 [inline]
 copy_net_ns+0x125/0x760 net/core/net_namespace.c:458
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3058
 __do_sys_unshare kernel/fork.c:3129 [inline]
 __se_sys_unshare kernel/fork.c:3127 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3127
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
 insert_work+0x48/0x370 kernel/workqueue.c:1368
 __queue_work+0x5ca/0xf30 kernel/workqueue.c:1534
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1461 [inline]
 __run_timers.part.0+0x4a6/0xa30 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0x152/0x1d0 kernel/time/timer.c:1749
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558

The buggy address belongs to the object at ffff888014d89b80
 which belongs to the cache net_namespace of size 6784
The buggy address is located 2160 bytes inside of
 6784-byte region [ffff888014d89b80, ffff888014d8b600)
The buggy address belongs to the page:
page:ffffea0000536200 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888014d8d280 pfn:0x14d88
head:ffffea0000536200 order:3 compound_mapcount:0 compound_pincount:0
memcg:ffff8880739c0d01
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888010dd4288 ffffea0001312608 ffff888010dd33c0
raw: ffff888014d8d280 0000000000040000 00000001ffffffff ffff8880739c0d01
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3625, ts 119623685583, free_ts 119620670893
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4165
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2271
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0x27f/0x3c0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0xbe1/0x12b0 mm/slub.c:3018
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3105
 slab_alloc_node mm/slub.c:3196 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 kmem_cache_alloc+0x3cb/0x4b0 mm/slub.c:3243
 kmem_cache_zalloc include/linux/slab.h:704 [inline]
 net_alloc net/core/net_namespace.c:403 [inline]
 copy_net_ns+0x125/0x760 net/core/net_namespace.c:458
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3058
 __do_sys_unshare kernel/fork.c:3129 [inline]
 __se_sys_unshare kernel/fork.c:3127 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3127
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1352 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1404
 free_unref_page_prepare mm/page_alloc.c:3325 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3404
 __unfreeze_partials+0x320/0x340 mm/slub.c:2536
 qlink_free mm/kasan/quarantine.c:157 [inline]
 qlist_free_all+0x6d/0x160 mm/kasan/quarantine.c:176
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:283
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:446
 kasan_slab_alloc include/linux/kasan.h:260 [inline]
 slab_post_alloc_hook mm/slab.h:732 [inline]
 slab_alloc_node mm/slub.c:3230 [inline]
 kmem_cache_alloc_node+0x2c3/0x4f0 mm/slub.c:3266
 __alloc_skb+0x215/0x340 net/core/skbuff.c:414
 alloc_skb include/linux/skbuff.h:1300 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1189 [inline]
 netlink_sendmsg+0x98f/0xe00 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 __sys_sendto+0x21c/0x320 net/socket.c:2040
 __do_sys_sendto net/socket.c:2052 [inline]
 __se_sys_sendto net/socket.c:2048 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2048
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff888014d8a280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888014d8a300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888014d8a380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff888014d8a400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888014d8a480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
----------------
Code disassembly (best guess):
   0:	89 de                	mov    %ebx,%esi
   2:	e8 9d 8a 24 f8       	callq  0xf8248aa4
   7:	84 db                	test   %bl,%bl
   9:	75 ac                	jne    0xffffffb7
   b:	e8 14 88 24 f8       	callq  0xf8248824
  10:	e8 ef c5 2a f8       	callq  0xf82ac604
  15:	eb 0c                	jmp    0x23
  17:	e8 08 88 24 f8       	callq  0xf8248824
  1c:	0f 00 2d c1 83 bd 00 	verw   0xbd83c1(%rip)        # 0xbd83e4
  23:	e8 fc 87 24 f8       	callq  0xf8248824
  28:	fb                   	sti
  29:	f4                   	hlt
* 2a:	9c                   	pushfq <-- trapping instruction
  2b:	5b                   	pop    %rbx
  2c:	81 e3 00 02 00 00    	and    $0x200,%ebx
  32:	fa                   	cli
  33:	31 ff                	xor    %edi,%edi
  35:	48 89 de             	mov    %rbx,%rsi
  38:	e8 d7 8b 24 f8       	callq  0xf8248c14
  3d:	48 85 db             	test   %rbx,%rbx


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
