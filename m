Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD53229F2D
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 20:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732081AbgGVSWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 14:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731944AbgGVSWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 14:22:44 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4CDC0619DC;
        Wed, 22 Jul 2020 11:22:44 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a14so1730265pfi.2;
        Wed, 22 Jul 2020 11:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7oX+Ui6Om/fIjYvfDxV2/4AZHvhi7NBOu1a0cZDb96s=;
        b=UR1CnosOGT0n6sc0mNa5OXUU9mC4UZo9f3JTepr3rk4R1d+ACyr95dQbS5pJF13kpm
         fue0Th0pbW4NW3D5buzPmmOQbxXoxiEUHanOnEivqnGNxV/sH94ylMb3QwPCKH4ShLqu
         AsjSoWG9fQ5CjYemIBFh6EZO6SnwviC4ipvG0Z6lTL8Gd8Oso/FORba0BlbDpLGiNKb7
         hZwZpIhC4MxUcKxkXgfZUbGZPpCYbHaa3KXBS4CT37nW0HIAOY288Vq2qY0a38ukoDCD
         7TfNxDpeDLRt9YHzJb4FU1gAQsPbmHMKeWEnCooJpXdImW1DKu/SJsmtK0PXjrXt1dlc
         Tnfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7oX+Ui6Om/fIjYvfDxV2/4AZHvhi7NBOu1a0cZDb96s=;
        b=YLu1A+w9DfB3XvhyXEzFV1uB9A8dFSAm4EnN/1PU2ELKRJ3lZ6m/mPpeijZURVvHpt
         lrKxlZCHVtwkjboxU459zHqWN6T+uA9SpdHWgWb2Lq+FaE+tJjuK7DjDAzBBy4BnQZCJ
         2cd6FOEnFmmxk5PcgMn0Z/QmbHwFRfIdyH3mi92V1Yhs1MTDzKF1Y07stNXHw1c4NnX3
         fQgbFZ6RXJxlThrrT+i2gzmZw9GHkrpCJemZQ5OnmYRjn2fS5/08Enj+8dFBnf3ZPDf+
         mzh0zt6jC4sm8ETl2qvIUWPnRySMA5yCYGng3jtcY7XaIAK4Gma6I8zKnrWaAWKRENaG
         4ErQ==
X-Gm-Message-State: AOAM530vzg2QgiOybzPmlualR2StKSr1awRcASg5+xO2jhlAZgtuahXm
        fZ2F0BXz9P65300+kq5gsxjO7pby
X-Google-Smtp-Source: ABdhPJw3fR8L+Q2k1yAFoLNVKKtbcm1jpJf3BKHBN9Vi0OSPQK43x3ovEVLKmRw+L02lZhprAJJWNA==
X-Received: by 2002:a62:1801:: with SMTP id 1mr845788pfy.242.1595442163507;
        Wed, 22 Jul 2020 11:22:43 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id gn5sm369103pjb.23.2020.07.22.11.22.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 11:22:42 -0700 (PDT)
Subject: Re: INFO: rcu detected stall in seq_read (2)
To:     syzbot <syzbot+c28b5fee66fd3b7f766e@syzkaller.appspotmail.com>,
        a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org, corbet@lwn.net,
        davem@davemloft.net, fweisbec@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        mingo@kernel.org, netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vasundhara-v.volam@broadcom.com
References: <000000000000b217d105ab0b8ae4@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <435c3097-9174-f45b-b9bb-42bc377e43e2@gmail.com>
Date:   Wed, 22 Jul 2020 11:22:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <000000000000b217d105ab0b8ae4@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/22/20 11:02 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4fa640dc Merge tag 'vfio-v5.8-rc7' of git://github.com/awi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=145cac30900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f87a5e4232fdb267
> dashboard link: https://syzkaller.appspot.com/bug?extid=c28b5fee66fd3b7f766e
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e23ac8900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1198c440900000
> 
> The issue was bisected to:
> 
> commit 53e233ea2fa9fa7e2405e95070981f327d90e519
> Author: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> Date:   Thu Oct 4 05:43:52 2018 +0000
> 
>     devlink: Add Documentation/networking/devlink-params-bnxt.txt

Probably bogus bisection.

This rather looks like a bug in taprio packet scheduler.



> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15e22b94900000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=17e22b94900000
> console output: https://syzkaller.appspot.com/x/log.txt?x=13e22b94900000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c28b5fee66fd3b7f766e@syzkaller.appspotmail.com
> Fixes: 53e233ea2fa9 ("devlink: Add Documentation/networking/devlink-params-bnxt.txt")
> 
> hrtimer: interrupt took 6305559 ns
> rcu: INFO: rcu_preempt self-detected stall on CPU
> rcu: 	1-...!: (1 GPs behind) idle=91e/1/0x4000000000000000 softirq=10105/10107 fqs=1 
> 	(t=18319 jiffies g=8905 q=457)
> NMI backtrace for cpu 1
> CPU: 1 PID: 4008 Comm: systemd-journal Not tainted 5.8.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>  nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
>  nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
>  trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
>  rcu_dump_cpu_stacks+0x194/0x1cf kernel/rcu/tree_stall.h:320
>  print_cpu_stall kernel/rcu/tree_stall.h:553 [inline]
>  check_cpu_stall kernel/rcu/tree_stall.h:627 [inline]
>  rcu_pending kernel/rcu/tree.c:3489 [inline]
>  rcu_sched_clock_irq.cold+0x5b3/0xccc kernel/rcu/tree.c:2504
>  update_process_times+0x25/0x60 kernel/time/timer.c:1737
>  tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:176
>  tick_sched_timer+0x108/0x290 kernel/time/tick-sched.c:1320
>  __run_hrtimer kernel/time/hrtimer.c:1520 [inline]
>  __hrtimer_run_queues+0x1d5/0xfc0 kernel/time/hrtimer.c:1584
>  hrtimer_interrupt+0x32a/0x930 kernel/time/hrtimer.c:1646
>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1080 [inline]
>  __sysvec_apic_timer_interrupt+0x142/0x5e0 arch/x86/kernel/apic/apic.c:1097
>  asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
>  </IRQ>
>  __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
>  run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
>  sysvec_apic_timer_interrupt+0xe0/0x120 arch/x86/kernel/apic/apic.c:1091
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:585
> RIP: 0010:format_decode+0x0/0xad0 lib/vsprintf.c:2329
> Code: c7 c7 10 05 af 8a be 10 00 00 00 e8 5a c3 46 00 48 c7 c7 20 78 0d 8a e9 6e f2 e2 fd 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 <41> 57 41 56 41 55 41 54 55 48 89 f5 53 48 bb 00 00 00 00 00 fc ff
> RSP: 0018:ffffc90001077a10 EFLAGS: 00000293
> RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffffffff83b0a497
> RDX: ffff888093224040 RSI: ffffc90001077a80 RDI: ffffffff884e6293
> RBP: ffffffff884e6293 R08: 0000000000000001 R09: ffff8880952a63d1
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880952a63d2
> R13: ffffffff884e6293 R14: 0000000000000025 R15: ffffc90001077b30
>  vsnprintf+0x155/0x14f0 lib/vsprintf.c:2572
>  seq_vprintf fs/seq_file.c:379 [inline]
>  seq_printf+0x195/0x240 fs/seq_file.c:394
>  proc_pid_status+0x1c6d/0x24b0 fs/proc/array.c:424
>  proc_single_show+0x116/0x1e0 fs/proc/base.c:766
>  seq_read+0x432/0x1070 fs/seq_file.c:208
>  vfs_read+0x1df/0x520 fs/read_write.c:479
>  ksys_read+0x12d/0x250 fs/read_write.c:607
>  do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x7f0fc43d9910
> Code: Bad RIP value.
> RSP: 002b:00007ffdcb193978 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 000055b1476b96f0 RCX: 00007f0fc43d9910
> RDX: 0000000000000800 RSI: 000055b1476b8b00 RDI: 0000000000000013
> RBP: 00007f0fc4694440 R08: 00007f0fc4697fc8 R09: 0000000000000410
> R10: 000055b1476b96f0 R11: 0000000000000246 R12: 0000000000000800
> R13: 0000000000000d68 R14: 000055b1476b8b00 R15: 00007f0fc4693900
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 
