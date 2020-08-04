Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8237323BD94
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 17:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgHDPwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 11:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgHDPwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 11:52:01 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80533C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 08:52:01 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 74so12303686pfx.13
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 08:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aowvfWQEuQHfChiIRoooHXu3Lh6IP8SU4zj8LBkWsU8=;
        b=aIMO921N6eJ2c4lAiCc/KqjWDWb1aJaadaYvcwk6e7CM8cyUjyhT9vveXM7gAvo8yL
         Il5eff9fOYghFcN6wF5KcibC2a2ZHm0LCKz/Kw0azKhn8BGnSiEghkc0oOeiscry1aMq
         8BIPPud9A+vRdL6sCKha6fdgEGu+UyJFEaKPaCnvAhuC3rZjdNvhpkc3m6HPr0fVml3P
         XcNBJqZo9W3/ZBQEuxCmvH1r8dwsQfQtsTGdnQ2G1dN7IFP+1Ju6uuIF5ydUV0WHBOp5
         maNfvMTclg/7qwBw67uVwF8pwOHksQizHyhxo5VyXDOtcpC6FC0IIDZ38APhMNRgp1gN
         Hvaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aowvfWQEuQHfChiIRoooHXu3Lh6IP8SU4zj8LBkWsU8=;
        b=gdQeTqGkQ8IZjuUNjfK0F//IODzlB9LemK5YA0FB8azKKWAErakf4UW6GjT8tHg/PP
         AvVdsD53QfFhzOngZ0jE0NGEJP6eJdoWafbaEa34oUu8nuZ7sQpqbW7vcaiRm0obKZtV
         xNhhimjyM1OmVYqtFEqUDyXheWwqr3vOc89SUG3pW6LWXXI6DldDVPuC6/A5LC1LEtqE
         9hPktTfBlXCi3GItjxcKzfkvgbPfgWQSho6okImjS0pV/bryemNfEKLCpLwIpV/lvKm1
         +7XtYO7lQz1KjfwksspK3wPplrfsAXdO8tqNDE29qsbs+5+4OLptS02LW43f1h3SYQzb
         YzAA==
X-Gm-Message-State: AOAM5329RNA5BMYBPovg6lu4pJlLb+gv3dJnzSJfPhUghcKUwU0a8lGO
        bkl0sSUbw6Es+U2wvsbQdRZTagLtNYQ=
X-Google-Smtp-Source: ABdhPJxC/oPNQ0mwBeDVMFYxjXvrx8/VpgUBbS6ehcbgkRWyLOMEPAHoBrPxLIxxuTNcZz8BlfM9qA==
X-Received: by 2002:aa7:9241:: with SMTP id 1mr22344616pfp.188.1596556320751;
        Tue, 04 Aug 2020 08:52:00 -0700 (PDT)
Received: from [192.168.0.16] ([97.115.152.79])
        by smtp.gmail.com with ESMTPSA id o2sm23371163pfh.160.2020.08.04.08.51.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 08:52:00 -0700 (PDT)
Subject: Re: [ovs-discuss] Double free in recent kernels after memleak fix
To:     =?UTF-8?B?Sm9oYW4gS27DtsO2cw==?= <jknoos@google.com>,
        bugs@openvswitch.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Netdev <netdev@vger.kernel.org>
Cc:     joel@joelfernandes.org
References: <CA+Sh73MJhqs7PBk6OV2AhzVjYvE1foUQUnwP5DwWR44LHZRZ9w@mail.gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <58be64c5-9ae4-95ff-629e-f55e47ff020b@gmail.com>
Date:   Tue, 4 Aug 2020 08:51:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CA+Sh73MJhqs7PBk6OV2AhzVjYvE1foUQUnwP5DwWR44LHZRZ9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/3/2020 12:01 PM, Johan Knöös via discuss wrote:
> Hi Open vSwitch contributors,
> 
> We have found openvswitch is causing double-freeing of memory. The
> issue was not present in kernel version 5.5.17 but is present in
> 5.6.14 and newer kernels.
> 
> After reverting the RCU commits below for debugging, enabling
> slub_debug, lockdep, and KASAN, we see the warnings at the end of this
> email in the kernel log (the last one shows the double-free). When I
> revert 50b0e61b32ee890a75b4377d5fbe770a86d6a4c1 ("net: openvswitch:
> fix possible memleak on destroy flow-table"), the symptoms disappear.
> While I have a reliable way to reproduce the issue, I unfortunately
> don't yet have a process that's amenable to sharing. Please take a
> look.
> 
> 189a6883dcf7 rcu: Remove kfree_call_rcu_nobatch()
> 77a40f97030b rcu: Remove kfree_rcu() special casing and lazy-callback handling
> e99637becb2e rcu: Add support for debug_objects debugging for kfree_rcu()
> 0392bebebf26 rcu: Add multiple in-flight batches of kfree_rcu() work
> 569d767087ef rcu: Make kfree_rcu() use a non-atomic ->monitor_todo
> a35d16905efc rcu: Add basic support for kfree_rcu() batching
> 
> Thanks,
> Johan Knöös

Let's add the author of the patch you reverted and the Linux netdev
mailing list.

- Greg

> 
> Traces:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 30 PID: 0 at net/openvswitch/flow_table.c:272
> table_instance_flow_free+0x2fd/0x340 [openvswitch]
> Modules linked in: ...
> CPU: 30 PID: 0 Comm: swapper/30 Tainted: G            E     5.6.14+ #18
> Hardware name: ...
> RIP: 0010:table_instance_flow_free+0x2fd/0x340 [openvswitch]
> Code: c1 fa 1f 48 c1 e8 20 29 d0 41 39 c7 0f 8f 95 fe ff ff 48 83 c4
> 10 48 89 ef d1 fe 5b 5d 41 5c 41 5d 41 5e 41 5f e9 33 fb ff ff <0f> 0b
> e9 59 fe ff ff 0f 0b e8 65 f1 fe ff 85 c0 0f 85 9b fe ff ff
> RSP: 0018:ffff888c3e589da8 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff889f954ee580 RCX: dffffc0000000000
> RDX: 0000000000000007 RSI: 0000000000000003 RDI: 0000000000000246
> RBP: ffff888c295150a0 R08: ffffffff9297f341 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff889f1ed55000
> R13: ffff888b72efa020 R14: ffff888c24209480 R15: ffff888b731bb6f8
> FS:  0000000000000000(0000) GS:ffff888c3e580000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000733feb8a700 CR3: 0000000ba726e004 CR4: 00000000003606e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <IRQ>
> table_instance_destroy+0xf9/0x1b0 [openvswitch]
> ? new_vport+0xb0/0xb0 [openvswitch]
> destroy_dp_rcu+0x12/0x50 [openvswitch]
> rcu_core+0x34d/0x9b0
> ? rcu_all_qs+0x90/0x90
> ? rcu_read_lock_sched_held+0xa5/0xc0
> ? rcu_read_lock_bh_held+0xc0/0xc0
> ? run_rebalance_domains+0x11d/0x140
> __do_softirq+0x128/0x55c
> irq_exit+0x101/0x110
> smp_apic_timer_interrupt+0xfd/0x2f0
> apic_timer_interrupt+0xf/0x20
> </IRQ>
> RIP: 0010:cpuidle_enter_state+0xda/0x5d0
> Code: 80 7c 24 10 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 be 04
> 00 00 31 ff e8 c2 1a 7a ff e8 9d 4d 84 ff fb 66 0f 1f 44 00 00 <45> 85
> ed 0f 88 b6 03 00 00 4d 63 f5 4b 8d 04 76 4e 8d 3c f5 00 00
> RSP: 0018:ffff888103f07d58 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
> RAX: 0000000000000000 RBX: ffff888c3e5c1800 RCX: dffffc0000000000
> RDX: 0000000000000007 RSI: 0000000000000006 RDI: ffff888103ec88d4
> RBP: ffffffff945a3940 R08: ffffffff92982042 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
> R13: 0000000000000002 R14: 00000000000000d0 R15: ffffffff945a3a10
> ? lockdep_hardirqs_on+0x182/0x260
> ? cpuidle_enter_state+0xd3/0x5d0
> cpuidle_enter+0x3c/0x60
> do_idle+0x36a/0x450
> ? arch_cpu_idle_exit+0x40/0x40
> cpu_startup_entry+0x19/0x20
> start_secondary+0x21f/0x290
> ? set_cpu_sibling_map+0xcb0/0xcb0
> secondary_startup_64+0xa4/0xb0
> irq event stamp: 1626911
> hardirqs last  enabled at (1626910): [<ffffffff929c0227>] __call_rcu+0x1b7/0x3b0
> hardirqs last disabled at (1626911): [<ffffffff92804552>]
> trace_hardirqs_off_thunk+0x1a/0x1c
> softirqs last  enabled at (1626882): [<ffffffff928df0d5>] irq_enter+0x75/0x80
> softirqs last disabled at (1626883): [<ffffffff928df1e1>] irq_exit+0x101/0x110
> ---[ end trace 8dc48dec48bb79c0 ]---
> 
> 
> -------------------------------------------------------------------------------
> 
> 
> =============================
> WARNING: suspicious RCU usage
> 5.6.14+ #18 Tainted: G        W   E
> -----------------------------
> net/openvswitch/flow_table.c:239 suspicious rcu_dereference_protected() usage!
> \x0aother info that might help us debug this:\x0a
> \x0arcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by swapper/30/0:
> #0: ffffffff94315e00 (rcu_callback){....}, at: rcu_core+0x395/0x9b0
> \x0astack backtrace:
> CPU: 30 PID: 0 Comm: swapper/30 Tainted: G        W   E     5.6.14+ #18
> Hardware name: ...
> Call Trace:
> <IRQ>
> dump_stack+0xb8/0x110
> table_instance_flow_free+0x332/0x340 [openvswitch]
> table_instance_destroy+0xf9/0x1b0 [openvswitch]
> ? new_vport+0xb0/0xb0 [openvswitch]
> destroy_dp_rcu+0x12/0x50 [openvswitch]
> rcu_core+0x34d/0x9b0
> ? rcu_all_qs+0x90/0x90
> ? rcu_read_lock_sched_held+0xa5/0xc0
> ? rcu_read_lock_bh_held+0xc0/0xc0
> ? run_rebalance_domains+0x11d/0x140
> __do_softirq+0x128/0x55c
> irq_exit+0x101/0x110
> smp_apic_timer_interrupt+0xfd/0x2f0
> apic_timer_interrupt+0xf/0x20
> </IRQ>
> RIP: 0010:cpuidle_enter_state+0xda/0x5d0
> Code: 80 7c 24 10 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 be 04
> 00 00 31 ff e8 c2 1a 7a ff e8 9d 4d 84 ff fb 66 0f 1f 44 00 00 <45> 85
> ed 0f 88 b6 03 00 00 4d 63 f5 4b 8d 04 76 4e 8d 3c f5 00 00
> RSP: 0018:ffff888103f07d58 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
> RAX: 0000000000000000 RBX: ffff888c3e5c1800 RCX: dffffc0000000000
> RDX: 0000000000000007 RSI: 0000000000000006 RDI: ffff888103ec88d4
> RBP: ffffffff945a3940 R08: ffffffff92982042 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
> R13: 0000000000000002 R14: 00000000000000d0 R15: ffffffff945a3a10
> ? lockdep_hardirqs_on+0x182/0x260
> ? cpuidle_enter_state+0xd3/0x5d0
> cpuidle_enter+0x3c/0x60
> do_idle+0x36a/0x450
> ? arch_cpu_idle_exit+0x40/0x40
> cpu_startup_entry+0x19/0x20
> start_secondary+0x21f/0x290
> ? set_cpu_sibling_map+0xcb0/0xcb0
> secondary_startup_64+0xa4/0xb0
> 
> 
> -------------------------------------------------------------------------------
> 
> 
> ================================
> WARNING: inconsistent lock state
> 5.6.14+ #18 Tainted: G        W   E
> --------------------------------
> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> swapper/30/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
> ffffffff943e24c0 (fs_reclaim){+.?.}, at: fs_reclaim_acquire.part.0+0x5/0x30
> {SOFTIRQ-ON-W} state was registered at:
>   lock_acquire+0xe5/0x1f0
>   fs_reclaim_acquire.part.0+0x25/0x30
>   kmem_cache_alloc_trace+0x30/0x2d0
>   alloc_workqueue_attrs+0x29/0xc0
>   workqueue_init+0x4e/0x3c5
>   kernel_init_freeable+0x16a/0x350
>   kernel_init+0xd/0x116
>   ret_from_fork+0x3a/0x50
> irq event stamp: 1629166
> hardirqs last  enabled at (1629166): [<ffffffff929c0227>] __call_rcu+0x1b7/0x3b0
> hardirqs last disabled at (1629165): [<ffffffff929c0129>] __call_rcu+0xb9/0x3b0
> softirqs last  enabled at (1626882): [<ffffffff928df0d5>] irq_enter+0x75/0x80
> softirqs last disabled at (1626883): [<ffffffff928df1e1>] irq_exit+0x101/0x110
> \x0aother info that might help us debug this:
> Possible unsafe locking scenario:\x0a
>        CPU0
>        ----
>   lock(fs_reclaim);
>   <Interrupt>
>     lock(fs_reclaim);
> \x0a *** DEADLOCK ***\x0a
> 1 lock held by swapper/30/0:
> #0: ffffffff94315e00 (rcu_callback){....}, at: rcu_core+0x395/0x9b0
> \x0astack backtrace:
> CPU: 30 PID: 0 Comm: swapper/30 Tainted: G        W   E     5.6.14+ #18
> Hardware name: ...
> Call Trace:
> <IRQ>
> dump_stack+0xb8/0x110
> mark_lock+0x7ee/0x9d0
> ? check_usage_backwards+0x230/0x230
> __lock_acquire+0xb84/0x2650
> ? lockdep_hardirqs_on+0x182/0x260
> ? lockdep_hardirqs_on+0x260/0x260
> ? debug_object_deactivate+0x210/0x210
> ? trace_hardirqs_on_thunk+0x1a/0x1c
> lock_acquire+0xe5/0x1f0
> ? fs_reclaim_acquire.part.0+0x5/0x30
> ? tbl_mask_array_realloc+0x38/0x1d0 [openvswitch]
> fs_reclaim_acquire.part.0+0x25/0x30
> ? fs_reclaim_acquire.part.0+0x5/0x30
> __kmalloc+0x4d/0x320
> tbl_mask_array_realloc+0x38/0x1d0 [openvswitch]
> ? table_instance_flow_free+0x2ba/0x340 [openvswitch]
> table_instance_destroy+0xf9/0x1b0 [openvswitch]
> ? new_vport+0xb0/0xb0 [openvswitch]
> destroy_dp_rcu+0x12/0x50 [openvswitch]
> rcu_core+0x34d/0x9b0
> ? rcu_all_qs+0x90/0x90
> ? rcu_read_lock_sched_held+0xa5/0xc0
> ? rcu_read_lock_bh_held+0xc0/0xc0
> ? run_rebalance_domains+0x11d/0x140
> __do_softirq+0x128/0x55c
> irq_exit+0x101/0x110
> smp_apic_timer_interrupt+0xfd/0x2f0
> apic_timer_interrupt+0xf/0x20
> </IRQ>
> RIP: 0010:cpuidle_enter_state+0xda/0x5d0
> Code: 80 7c 24 10 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 be 04
> 00 00 31 ff e8 c2 1a 7a ff e8 9d 4d 84 ff fb 66 0f 1f 44 00 00 <45> 85
> ed 0f 88 b6 03 00 00 4d 63 f5 4b 8d 04 76 4e 8d 3c f5 00 00
> RSP: 0018:ffff888103f07d58 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
> RAX: 0000000000000000 RBX: ffff888c3e5c1800 RCX: dffffc0000000000
> RDX: 0000000000000007 RSI: 0000000000000006 RDI: ffff888103ec88d4
> RBP: ffffffff945a3940 R08: ffffffff92982042 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
> R13: 0000000000000002 R14: 00000000000000d0 R15: ffffffff945a3a10
> ? lockdep_hardirqs_on+0x182/0x260
> ? cpuidle_enter_state+0xd3/0x5d0
> cpuidle_enter+0x3c/0x60
> do_idle+0x36a/0x450
> ? arch_cpu_idle_exit+0x40/0x40
> cpu_startup_entry+0x19/0x20
> start_secondary+0x21f/0x290
> ? set_cpu_sibling_map+0xcb0/0xcb0
> secondary_startup_64+0xa4/0xb0
> 
> 
> -------------------------------------------------------------------------------
> 
> 
> ------------[ cut here ]------------
> ODEBUG: activate active (active state 1) object type: rcu_head hint: 0x0
> WARNING: CPU: 30 PID: 0 at lib/debugobjects.c:485 debug_print_object+0xc6/0xe0
> Modules linked in: ...
> CPU: 30 PID: 0 Comm: swapper/30 Tainted: G        W   E     5.6.14+ #18
> Hardware name: ...
> RIP: 0010:debug_print_object+0xc6/0xe0
> Code: dd 20 6c 52 94 e8 3a 0a cf ff 4d 89 f1 49 89 e8 44 89 e1 48 8b
> 14 dd 20 6c 52 94 4c 89 ee 48 c7 c7 40 7f c4 93 e8 84 fd 98 ff <0f> 0b
> 5b 83 05 04 89 86 01 01 5d 41 5c 41 5d 41 5e 41 5f c3 66 0f
> RSP: 0018:ffff888c3e589c38 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
> RDX: 1ffff11187cb5415 RSI: 0000000000000008 RDI: ffffed1187cb1379
> RBP: ffffffff93aca380 R08: 0000000000000001 R09: ffffed1187cb6691
> R10: ffffed1187cb6690 R11: ffff888c3e5b3487 R12: 0000000000000001
> R13: ffffffff93c48600 R14: 0000000000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff888c3e580000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000733feb8a700 CR3: 0000000ba726e004 CR4: 00000000003606e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <IRQ>
> debug_object_activate+0x2b8/0x300
> ? debug_object_assert_init+0x220/0x220
> ? kasan_unpoison_shadow+0x33/0x40
> __call_rcu+0x34/0x3b0
> ? __kasan_kmalloc.constprop.0+0xc2/0xd0
> tbl_mask_array_realloc+0x170/0x1d0 [openvswitch]
> table_instance_destroy+0xf9/0x1b0 [openvswitch]
> ? new_vport+0xb0/0xb0 [openvswitch]
> destroy_dp_rcu+0x12/0x50 [openvswitch]
> rcu_core+0x34d/0x9b0
> ? rcu_all_qs+0x90/0x90
> ? rcu_read_lock_sched_held+0xa5/0xc0
> ? rcu_read_lock_bh_held+0xc0/0xc0
> ? run_rebalance_domains+0x11d/0x140
> __do_softirq+0x128/0x55c
> irq_exit+0x101/0x110
> smp_apic_timer_interrupt+0xfd/0x2f0
> apic_timer_interrupt+0xf/0x20
> </IRQ>
> RIP: 0010:cpuidle_enter_state+0xda/0x5d0
> Code: 80 7c 24 10 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 be 04
> 00 00 31 ff e8 c2 1a 7a ff e8 9d 4d 84 ff fb 66 0f 1f 44 00 00 <45> 85
> ed 0f 88 b6 03 00 00 4d 63 f5 4b 8d 04 76 4e 8d 3c f5 00 00
> RSP: 0018:ffff888103f07d58 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
> RAX: 0000000000000000 RBX: ffff888c3e5c1800 RCX: dffffc0000000000
> RDX: 0000000000000007 RSI: 0000000000000006 RDI: ffff888103ec88d4
> RBP: ffffffff945a3940 R08: ffffffff92982042 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
> R13: 0000000000000002 R14: 00000000000000d0 R15: ffffffff945a3a10
> ? lockdep_hardirqs_on+0x182/0x260
> ? cpuidle_enter_state+0xd3/0x5d0
> cpuidle_enter+0x3c/0x60
> do_idle+0x36a/0x450
> ? arch_cpu_idle_exit+0x40/0x40
> cpu_startup_entry+0x19/0x20
> start_secondary+0x21f/0x290
> ? set_cpu_sibling_map+0xcb0/0xcb0
> secondary_startup_64+0xa4/0xb0
> irq event stamp: 1629166
> hardirqs last  enabled at (1629166): [<ffffffff929c0227>] __call_rcu+0x1b7/0x3b0
> hardirqs last disabled at (1629165): [<ffffffff929c0129>] __call_rcu+0xb9/0x3b0
> softirqs last  enabled at (1626882): [<ffffffff928df0d5>] irq_enter+0x75/0x80
> softirqs last disabled at (1626883): [<ffffffff928df1e1>] irq_exit+0x101/0x110
> ---[ end trace 8dc48dec48bb79f0 ]---
> 
> 
> -------------------------------------------------------------------------------
> 
> 
> ------------[ cut here ]------------
> __call_rcu(): Double-freed CB 00000000111691a8->0x0()!!!
> WARNING: CPU: 30 PID: 0 at kernel/rcu/tree.c:2594 __call_rcu+0x20f/0x3b0
> Modules linked in: ...
> CPU: 30 PID: 0 Comm: swapper/30 Tainted: G        W   E     5.6.14+ #18
> Hardware name: ...
> RIP: 0010:__call_rcu+0x20f/0x3b0
> Code: 5e 41 5f e9 03 59 0d 00 48 89 ef c6 05 5d 2e dc 01 01 e8 94 33
> 27 00 48 8b 53 08 48 89 de 48 c7 c7 20 bf ac 93 e8 eb 26 f1 ff <0f> 0b
> e9 4b fe ff ff e8 05 fd ff ff e9 21 ff ff ff 0f 0b e9 fe fd
> RSP: 0018:ffff888c3e589d58 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff888bd345e200 RCX: 0000000000000000
> RDX: 1ffff11187cb5415 RSI: 0000000000000008 RDI: ffffed1187cb139d
> RBP: ffff888bd345e208 R08: 0000000000000001 R09: ffffed1187cb6691
> R10: ffffed1187cb6690 R11: ffff888c3e5b3487 R12: 0000000000000000
> R13: 0000000000000001 R14: ffff888107e06618 R15: ffff888bd345e2f8
> FS:  0000000000000000(0000) GS:ffff888c3e580000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000733feb8a700 CR3: 0000000ba726e004 CR4: 00000000003606e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <IRQ>
> ? __kasan_kmalloc.constprop.0+0xc2/0xd0
> tbl_mask_array_realloc+0x170/0x1d0 [openvswitch]
> table_instance_destroy+0xf9/0x1b0 [openvswitch]
> ? new_vport+0xb0/0xb0 [openvswitch]
> destroy_dp_rcu+0x12/0x50 [openvswitch]
> rcu_core+0x34d/0x9b0
> ? rcu_all_qs+0x90/0x90
> ? rcu_read_lock_sched_held+0xa5/0xc0
> ? rcu_read_lock_bh_held+0xc0/0xc0
> ? run_rebalance_domains+0x11d/0x140
> __do_softirq+0x128/0x55c
> irq_exit+0x101/0x110
> smp_apic_timer_interrupt+0xfd/0x2f0
> apic_timer_interrupt+0xf/0x20
> </IRQ>
> RIP: 0010:cpuidle_enter_state+0xda/0x5d0
> Code: 80 7c 24 10 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 be 04
> 00 00 31 ff e8 c2 1a 7a ff e8 9d 4d 84 ff fb 66 0f 1f 44 00 00 <45> 85
> ed 0f 88 b6 03 00 00 4d 63 f5 4b 8d 04 76 4e 8d 3c f5 00 00
> RSP: 0018:ffff888103f07d58 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
> RAX: 0000000000000000 RBX: ffff888c3e5c1800 RCX: dffffc0000000000
> RDX: 0000000000000007 RSI: 0000000000000006 RDI: ffff888103ec88d4
> RBP: ffffffff945a3940 R08: ffffffff92982042 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
> R13: 0000000000000002 R14: 00000000000000d0 R15: ffffffff945a3a10
> ? lockdep_hardirqs_on+0x182/0x260
> ? cpuidle_enter_state+0xd3/0x5d0
> cpuidle_enter+0x3c/0x60
> do_idle+0x36a/0x450
> ? arch_cpu_idle_exit+0x40/0x40
> cpu_startup_entry+0x19/0x20
> start_secondary+0x21f/0x290
> ? set_cpu_sibling_map+0xcb0/0xcb0
> secondary_startup_64+0xa4/0xb0
> irq event stamp: 1629166
> hardirqs last  enabled at (1629166): [<ffffffff929c0227>] __call_rcu+0x1b7/0x3b0
> hardirqs last disabled at (1629165): [<ffffffff929c0129>] __call_rcu+0xb9/0x3b0
> softirqs last  enabled at (1626882): [<ffffffff928df0d5>] irq_enter+0x75/0x80
> softirqs last disabled at (1626883): [<ffffffff928df1e1>] irq_exit+0x101/0x110
> ---[ end trace 8dc48dec48bb79f2 ]---
> _______________________________________________
> discuss mailing list
> discuss@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-discuss
> 
