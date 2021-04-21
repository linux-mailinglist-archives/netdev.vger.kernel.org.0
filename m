Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B29367332
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 21:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238278AbhDUTJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 15:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbhDUTJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 15:09:45 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D8EC06174A;
        Wed, 21 Apr 2021 12:09:12 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id g9so26405240wrx.0;
        Wed, 21 Apr 2021 12:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xJBwDEzVSoyRfxtXVPPyadAETVmcf9I/aTNmjyTTST8=;
        b=XRPX+YeCG2USosgYOq9aO3w6zblvFqn7BWc+M//AGJKMQqPzO3YLCzY6xx1X6BmkIQ
         u47c6hRhJkbTVoOY2SfbGaKydAdPtdyaTe7mHo4yZkWsBurclcK0X0eOHDyEeI9kykst
         PX5WuiK4hiumS7QNztbnqvkB57gr4NMmwNoHtI2r8A0QNZkCB/rMVcu+rwXVPj08qgjv
         UHQlm0AsBfb7UyL0YwQvQAWG/+WN22gSa3iyNL0ve14/WQEOWAiYVb8zgtGcXr1lsqVK
         ZR+YfmY2p/N1XQSJbrSJBfHSgjiSTFmUJH0rxODRlROuXAsiPIakndUWPrXzwMtODqG+
         7+4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xJBwDEzVSoyRfxtXVPPyadAETVmcf9I/aTNmjyTTST8=;
        b=EDVN9pzRmayIUqAO9bJYA1IDvo/TZPz21ynGq7me+bYTwZzCNlQeF8gF6OLiYSNVb4
         vV40BGi9m8HPZWpehiS/8f845WUhARyI+k1i27PTpNDQGvC56spc/4bA5iWAp85HAVKG
         hn8ZWPXaOdzwPDLgXGnIz+NhmTzOLGSDOPeEgGvhFjbHMM4OBm1hZ/t7f/BGdPimaw+g
         d9u+rtjfexnLpVRBM/7yPtF6lpZnkwK599U4fql7WhCAD+Razid3Z0NzqbqnsFmZD72X
         TyLxW7D9qVV4QRz3KP1a7rkh9L69K7R3KRH6vK0nNRVRrddclD6UUQ4I3iXULct5wEhG
         h78Q==
X-Gm-Message-State: AOAM532y9d3DG4GlPz9U/5Vy8ll1pFfrFNKGVRbUaCRMa+07MC62nwxe
        gzZVSJYUVwfI89ndBcx4i2iYKoyFhule4+7aIFs=
X-Google-Smtp-Source: ABdhPJw+2Pt4RLbqBhTePofY4d7kHYxDCrvs4DlnSJcMb8SLt2LA0/QJYmndvaHmEBxPj17oJPN7wVA4uUDh0uZ7mXg=
X-Received: by 2002:a5d:46c7:: with SMTP id g7mr28621434wrs.330.1619032150933;
 Wed, 21 Apr 2021 12:09:10 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a48ad805c06076f0@google.com>
In-Reply-To: <000000000000a48ad805c06076f0@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 21 Apr 2021 15:08:59 -0400
Message-ID: <CADvbK_dUs6HVK_c9P+2N2annxkHSt41Y6X6WhSQ1005SFU-4Rw@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in sctp_do_8_2_transport_strike
To:     syzbot <syzbot+bbe538efd1046586f587@syzkaller.appspotmail.com>,
        "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>,
        "Leppanen, Jere (Nokia - FI/Espoo)" <jere.leppanen@nokia.com>
Cc:     davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander had reported this one.

We probably should move forward with the fix for it.

Thanks.

On Tue, Apr 20, 2021 at 1:10 AM syzbot
<syzbot+bbe538efd1046586f587@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    bf05bf16 Linux 5.12-rc8
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16a00dfed00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9404cfa686df2c05
> dashboard link: https://syzkaller.appspot.com/bug?extid=bbe538efd1046586f587
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+bbe538efd1046586f587@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: use-after-free in sctp_do_8_2_transport_strike.constprop.0+0xa27/0xab0 net/sctp/sm_sideeffect.c:531
> Read of size 4 at addr ffff888024d65154 by task swapper/1/0
>
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.12.0-rc8-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
>  __kasan_report mm/kasan/report.c:399 [inline]
>  kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
>  sctp_do_8_2_transport_strike.constprop.0+0xa27/0xab0 net/sctp/sm_sideeffect.c:531
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1636 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
>  sctp_do_sm+0x114f/0x5120 net/sctp/sm_sideeffect.c:1156
>  sctp_generate_timeout_event+0x1bb/0x3d0 net/sctp/sm_sideeffect.c:295
>  call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1431
>  expire_timers kernel/time/timer.c:1476 [inline]
>  __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1745
>  __run_timers kernel/time/timer.c:1726 [inline]
>  run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1758
>  __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
>  invoke_softirq kernel/softirq.c:221 [inline]
>  __irq_exit_rcu kernel/softirq.c:422 [inline]
>  irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
>  sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
>  </IRQ>
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
> RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
> RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
> RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:137 [inline]
> RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:112 [inline]
> RIP: 0010:acpi_idle_do_entry+0x1c9/0x250 drivers/acpi/processor_idle.c:517
> Code: ed 56 6e f8 84 db 75 ac e8 34 50 6e f8 e8 3f 3f 74 f8 e9 0c 00 00 00 e8 25 50 6e f8 0f 00 2d be a5 c7 00 e8 19 50 6e f8 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 24 58 6e f8 48 85 db
> RSP: 0018:ffffc90000d57d18 EFLAGS: 00000293
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff8880111c54c0 RSI: ffffffff8905a167 RDI: 0000000000000000
> RBP: ffff888141433864 R08: 0000000000000001 R09: 0000000000000001
> R10: ffffffff8179e0c8 R11: 0000000000000000 R12: 0000000000000001
> R13: ffff888141433800 R14: ffff888141433864 R15: ffff888017879004
>  acpi_idle_enter+0x361/0x500 drivers/acpi/processor_idle.c:652
>  cpuidle_enter_state+0x1b1/0xc80 drivers/cpuidle/cpuidle.c:237
>  cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
>  call_cpuidle kernel/sched/idle.c:158 [inline]
>  cpuidle_idle_call kernel/sched/idle.c:239 [inline]
>  do_idle+0x3e1/0x590 kernel/sched/idle.c:300
>  cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:397
>  start_secondary+0x274/0x350 arch/x86/kernel/smpboot.c:272
>  secondary_startup_64_no_verify+0xb0/0xbb
>
> Allocated by task 14433:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_set_track mm/kasan/common.c:46 [inline]
>  set_alloc_info mm/kasan/common.c:427 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:506 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:465 [inline]
>  __kasan_kmalloc+0x99/0xc0 mm/kasan/common.c:515
>  kmalloc include/linux/slab.h:554 [inline]
>  kzalloc include/linux/slab.h:684 [inline]
>  sctp_transport_new+0x8c/0x690 net/sctp/transport.c:96
>  sctp_assoc_add_peer+0x28f/0x1160 net/sctp/associola.c:618
>  sctp_process_init+0x12a/0x2940 net/sctp/sm_make_chunk.c:2345
>  sctp_sf_do_dupcook_a net/sctp/sm_statefuns.c:1800 [inline]
>  sctp_sf_do_5_2_4_dupcook+0x1401/0x2d50 net/sctp/sm_statefuns.c:2200
>  sctp_do_sm+0x179/0x5120 net/sctp/sm_sideeffect.c:1153
>  sctp_assoc_bh_rcv+0x386/0x6c0 net/sctp/associola.c:1048
>  sctp_inq_push+0x1da/0x270 net/sctp/inqueue.c:80
>  sctp_rcv+0xf64/0x2f10 net/sctp/input.c:256
>  sctp6_rcv+0x38/0x60 net/sctp/ipv6.c:1077
>  ip6_protocol_deliver_rcu+0x2e9/0x17f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish+0x7f/0x160 net/ipv6/ip6_input.c:463
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  NF_HOOK include/linux/netfilter.h:295 [inline]
>  ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  NF_HOOK include/linux/netfilter.h:295 [inline]
>  ipv6_rcv+0x28e/0x3c0 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5384
>  __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5498
>  process_backlog+0x232/0x6c0 net/core/dev.c:6366
>  __napi_poll+0xaf/0x440 net/core/dev.c:6913
>  napi_poll net/core/dev.c:6980 [inline]
>  net_rx_action+0x801/0xb40 net/core/dev.c:7067
>  __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
>
> Freed by task 0:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
>  kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
>  ____kasan_slab_free mm/kasan/common.c:360 [inline]
>  ____kasan_slab_free mm/kasan/common.c:325 [inline]
>  __kasan_slab_free+0xf5/0x130 mm/kasan/common.c:367
>  kasan_slab_free include/linux/kasan.h:199 [inline]
>  slab_free_hook mm/slub.c:1562 [inline]
>  slab_free_freelist_hook+0x92/0x210 mm/slub.c:1600
>  slab_free mm/slub.c:3161 [inline]
>  kfree+0xe5/0x7f0 mm/slub.c:4213
>  rcu_do_batch kernel/rcu/tree.c:2559 [inline]
>  rcu_core+0x74a/0x12f0 kernel/rcu/tree.c:2794
>  __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
>
> Last potentially related work creation:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
>  __call_rcu kernel/rcu/tree.c:3039 [inline]
>  call_rcu+0xb1/0x740 kernel/rcu/tree.c:3114
>  sctp_transport_destroy net/sctp/transport.c:167 [inline]
>  sctp_transport_put+0x11d/0x180 net/sctp/transport.c:326
>  sctp_association_free+0x4d4/0x7d0 net/sctp/associola.c:381
>  sctp_cmd_delete_tcb net/sctp/sm_sideeffect.c:930 [inline]
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1318 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
>  sctp_do_sm+0x38b8/0x5120 net/sctp/sm_sideeffect.c:1156
>  sctp_assoc_bh_rcv+0x386/0x6c0 net/sctp/associola.c:1048
>  sctp_inq_push+0x1da/0x270 net/sctp/inqueue.c:80
>  sctp_rcv+0xf64/0x2f10 net/sctp/input.c:256
>  sctp6_rcv+0x38/0x60 net/sctp/ipv6.c:1077
>  ip6_protocol_deliver_rcu+0x2e9/0x17f0 net/ipv6/ip6_input.c:422
>  ip6_input_finish+0x7f/0x160 net/ipv6/ip6_input.c:463
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  NF_HOOK include/linux/netfilter.h:295 [inline]
>  ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:472
>  dst_input include/net/dst.h:458 [inline]
>  ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  NF_HOOK include/linux/netfilter.h:295 [inline]
>  ipv6_rcv+0x28e/0x3c0 net/ipv6/ip6_input.c:297
>  __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5384
>  __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5498
>  process_backlog+0x232/0x6c0 net/core/dev.c:6366
>  __napi_poll+0xaf/0x440 net/core/dev.c:6913
>  napi_poll net/core/dev.c:6980 [inline]
>  net_rx_action+0x801/0xb40 net/core/dev.c:7067
>  __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
>
> Second to last potentially related work creation:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
>  kvfree_call_rcu+0x10e/0x7d0 kernel/rcu/tree.c:3577
>  neigh_destroy+0x3ff/0x5f0 net/core/neighbour.c:858
>  neigh_release include/net/neighbour.h:425 [inline]
>  neigh_cleanup_and_release+0x1fd/0x340 net/core/neighbour.c:103
>  neigh_del net/core/neighbour.c:193 [inline]
>  neigh_remove_one+0x3cf/0x450 net/core/neighbour.c:214
>  neigh_forced_gc net/core/neighbour.c:243 [inline]
>  neigh_alloc net/core/neighbour.c:390 [inline]
>  ___neigh_create+0x1698/0x25c0 net/core/neighbour.c:578
>  ip6_finish_output2+0xf1f/0x1700 net/ipv6/ip6_output.c:114
>  __ip6_finish_output net/ipv6/ip6_output.c:182 [inline]
>  __ip6_finish_output+0x4c1/0xe10 net/ipv6/ip6_output.c:161
>  ip6_finish_output+0x35/0x200 net/ipv6/ip6_output.c:192
>  NF_HOOK_COND include/linux/netfilter.h:290 [inline]
>  ip6_output+0x1e4/0x530 net/ipv6/ip6_output.c:215
>  dst_output include/net/dst.h:448 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ndisc_send_skb+0xa99/0x1750 net/ipv6/ndisc.c:508
>  ndisc_send_ns+0x3a9/0x840 net/ipv6/ndisc.c:650
>  addrconf_dad_work+0xc3f/0x12b0 net/ipv6/addrconf.c:4119
>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>
> The buggy address belongs to the object at ffff888024d65000
>  which belongs to the cache kmalloc-1k of size 1024
> The buggy address is located 340 bytes inside of
>  1024-byte region [ffff888024d65000, ffff888024d65400)
> The buggy address belongs to the page:
> page:ffffea0000935800 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x24d60
> head:ffffea0000935800 order:3 compound_mapcount:0 compound_pincount:0
> flags: 0xfff00000010200(slab|head)
> raw: 00fff00000010200 0000000000000000 0000000f00000001 ffff888010441dc0
> raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff888024d65000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888024d65080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff888024d65100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                  ^
>  ffff888024d65180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888024d65200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
