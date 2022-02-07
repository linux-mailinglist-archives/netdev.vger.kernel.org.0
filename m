Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2BB4AB437
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 07:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiBGFrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 00:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350408AbiBGDa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 22:30:58 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4ABC061A73
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 19:30:56 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id e145so16084305yba.12
        for <netdev@vger.kernel.org>; Sun, 06 Feb 2022 19:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L8aIC6tgOZarL2cC+/D8GXNrTHUDoSyxxEE6XQLswz0=;
        b=KD9vqPi6m53rdF82uzQEcGM9EwQf0PZBGKf/UauddQ+rgb25RwwAsc7PhOHtg0ixR6
         /2qonbD1Vf644KGZ7xszAxR4hTUg1MJMuI3RawO/yrCS/PgcC6bCGNMgv0gyZQoTJhPC
         jyrpD9DcwSWWxnkcUQOl4RcZpGQk7NgHXqizn01FlpJ8QtT1FOpXh9+c+5M/iFgZxS6H
         9eKxoIh9nZfLDGVWVOvwZqdfdvmjrTZNqBDAl9Vc/E1iI4VtDbLFIJ6Lcp91qpN3pUxU
         f/FGvx14NNTJXZtswYXPd8WZTkpvT4DoimjKHvXH6SjrjkM885mnCd4WgJDGtybtXyRB
         qYDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L8aIC6tgOZarL2cC+/D8GXNrTHUDoSyxxEE6XQLswz0=;
        b=7ZPBWv52FGpjuelrWkZC4MQvPJEh3mjwZbB0y2Slu0gTt1g3mP9sEh04U2NAigKyPw
         NccRDLseUbIkjv/ISxglYX5Sa+WUmM6He160M4Uc29hVybAdqOaqe4Bv4PXW+n8SrRX/
         hZucfpgm8C68Np48I2pHeUPWwEq0UcBh1Fc3PeU3WUQD9U0m9C5aVMcrOHYe8xe7L2Ul
         ReCX2InacVFl6DkT3CJDZGHJB9ID+Tcyb5IV8+750t1giwJnTQ6djM6sxdAUvPjLoll7
         MR9RJma+/xNpUggpzTmRxy2EU07GegtGStyYdX/o0pkqSy0HxpKWW+TpnOCKF3iCWeX+
         Z6UQ==
X-Gm-Message-State: AOAM533NFxnx10te+ewVoIzdG+S18YHBkWw4jDp2fqsjKJwif3MVuQnn
        r8ppJFbhPMqFteqanCc5EsXjLqoEsHvGe0bJpNkGkA==
X-Google-Smtp-Source: ABdhPJzkpFfkiTlqQSQzp+nJjrE7IDV3yucAZ/Zdxqaztc9yfFyVqznKRRHkLExJGw+98rk2Gblyv2jLsY1J813ixBM=
X-Received: by 2002:a81:e345:: with SMTP id w5mr6827331ywl.32.1644204655621;
 Sun, 06 Feb 2022 19:30:55 -0800 (PST)
MIME-Version: 1.0
References: <20220124202457.3450198-4-eric.dumazet@gmail.com> <20220207030250.GC33412@xsang-OptiPlex-9020>
In-Reply-To: <20220207030250.GC33412@xsang-OptiPlex-9020>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 6 Feb 2022 19:30:44 -0800
Message-ID: <CANn89iLc4=otMLU4x9FKKwe13ozL5WWTY7dFqoYNXDHXhxaRWg@mail.gmail.com>
Subject: Re: [tcp/dccp] f6408a8641: BUG:KASAN:use-after-free_in_inet_twsk_kill
To:     kernel test robot <oliver.sang@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, 0day robot <lkp@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 6, 2022 at 7:03 PM kernel test robot <oliver.sang@intel.com> wrote:
>
>
>
> Greeting,
>
> FYI, we noticed the following commit (built with gcc-9):
>
> commit: f6408a86410131190bc04d3c9b12cae45383cdd4 ("[PATCH net-next 3/6] tcp/dccp: get rid of inet_twsk_purge()")
> url: https://github.com/0day-ci/linux/commits/Eric-Dumazet/netns-speedup-netns-dismantles/20220125-061934
> base: https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git 8aaaf2f3af2ae212428f4db1af34214225f5cec3
> patch link: https://lore.kernel.org/netdev/20220124202457.3450198-4-eric.dumazet@gmail.com
>

Right, and this has been fixed in

commit fbb8295248e1d6f576d444309fcf79356008eac1
Author: Eric Dumazet <edumazet@google.com>
Date:   Wed Jan 26 10:07:14 2022 -0800

    tcp: allocate tcp_death_row outside of struct netns_ipv4
...
    Fixes: 0dad4087a86a ("tcp/dccp: get rid of inet_twsk_purge()")
    Signed-off-by: Eric Dumazet <edumazet@google.com>
    Reported-by: syzbot <syzkaller@googlegroups.com>
    Reported-by: Paolo Abeni <pabeni@redhat.com>
    Tested-by: Paolo Abeni <pabeni@redhat.com>
    Link: https://lore.kernel.org/r/20220126180714.845362-1-eric.dumazet@gmail.com
    Signed-off-by: Jakub Kicinski <kuba@kernel.org>



> in testcase: kernel-selftests
> version: kernel-selftests-x86_64-f050cde9-1_20220127
> with following parameters:
>
>         group: net
>         ucode: 0xe2
>
> test-description: The kernel contains a set of "self tests" under the tools/testing/selftests/ directory. These are intended to be small unit tests to exercise individual code paths in the kernel.
> test-url: https://www.kernel.org/doc/Documentation/kselftest.txt
>
>
> on test machine: 8 threads Intel(R) Core(TM) i7-6770HQ CPU @ 2.60GHz with 32G memory
>
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
>
>
>
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
>
>
> [ 1799.534962][ C0] BUG: KASAN: use-after-free in inet_twsk_kill (net/ipv4/inet_timewait_sock.c:46)
> [ 1799.542232][    C0] Read of size 8 at addr ffff88889835ea80 by task swapper/0/0
> [ 1799.549806][    C0]
> [ 1799.552099][    C0] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G          I       5.16.0-rc8-02293-gf6408a864101 #1
> [ 1799.562554][    C0] Hardware name:  /NUC6i7KYB, BIOS KYSKLi70.86A.0041.2016.0817.1130 08/17/2016
> [ 1799.571654][    C0] Call Trace:
> [ 1799.574923][    C0]  <IRQ>
> [ 1799.577747][ C0] dump_stack_lvl (lib/dump_stack.c:107)
> [ 1799.582294][ C0] print_address_description+0x21/0x140
> [ 1799.588939][ C0] ? inet_twsk_kill (net/ipv4/inet_timewait_sock.c:46)
> [ 1799.593855][ C0] ? inet_twsk_kill (net/ipv4/inet_timewait_sock.c:46)
> [ 1799.598850][ C0] kasan_report.cold (mm/kasan/report.c:434 mm/kasan/report.c:450)
> [ 1799.603906][ C0] ? inet_twsk_kill (net/ipv4/inet_timewait_sock.c:46)
> [ 1799.608942][ C0] ? inet_twsk_kill (net/ipv4/inet_timewait_sock.c:148)
> [ 1799.614060][ C0] inet_twsk_kill (net/ipv4/inet_timewait_sock.c:46)
> [ 1799.619048][ C0] ? inet_twsk_kill (net/ipv4/inet_timewait_sock.c:148)
> [ 1799.624088][ C0] call_timer_fn (arch/x86/include/asm/jump_label.h:27 include/linux/jump_label.h:212 include/trace/events/timer.h:125 kernel/time/timer.c:1422)
> [ 1799.628802][ C0] ? lock_release (kernel/locking/lockdep.c:5315 kernel/locking/lockdep.c:5657)
> [ 1799.633639][ C0] ? del_timer_sync (kernel/time/timer.c:1398)
> [ 1799.638650][ C0] ? lock_downgrade (kernel/locking/lockdep.c:5645)
> [ 1799.643768][ C0] ? inet_twsk_kill (net/ipv4/inet_timewait_sock.c:148)
> [ 1799.648731][ C0] ? lockdep_hardirqs_on_prepare (kernel/locking/lockdep.c:4224 kernel/locking/lockdep.c:4292 kernel/locking/lockdep.c:4244)
> [ 1799.654797][ C0] ? inet_twsk_kill (net/ipv4/inet_timewait_sock.c:148)
> [ 1799.659608][ C0] run_timer_softirq (kernel/time/timer.c:1467 kernel/time/timer.c:1734 kernel/time/timer.c:1710 kernel/time/timer.c:1747)
> [ 1799.664743][ C0] ? call_timer_fn (kernel/time/timer.c:1744)
> [ 1799.669655][ C0] ? __next_base (kernel/time/hrtimer.c:506)
> [ 1799.674329][ C0] ? rcu_read_lock_sched_held (include/linux/lockdep.h:283 kernel/rcu/update.c:125)
> [ 1799.679957][ C0] ? rcu_read_lock_bh_held (kernel/rcu/update.c:120)
> [ 1799.685223][ C0] __do_softirq (arch/x86/include/asm/jump_label.h:27 include/linux/jump_label.h:212 include/trace/events/irq.h:142 kernel/softirq.c:559)
> [ 1799.689695][ C0] irq_exit_rcu (kernel/softirq.c:432 kernel/softirq.c:637 kernel/softirq.c:649)
> [ 1799.694165][ C0] sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1097 (discriminator 14))
> [ 1799.699785][    C0]  </IRQ>
> [ 1799.702672][    C0]  <TASK>
> [ 1799.705613][ C0] asm_sysvec_apic_timer_interrupt (arch/x86/include/asm/idtentry.h:638)
> [ 1799.711800][ C0] RIP: 0010:cpuidle_enter_state (drivers/cpuidle/cpuidle.c:259)
> [ 1799.717839][ C0] Code: 00 00 31 ff e8 47 58 43 fe 80 3c 24 00 74 12 9c 58 f6 c4 02 0f 85 1f 08 00 00 31 ff e8 6f 9c 5b fe e8 aa 0f 71 fe fb 45 85 f6 <0f> 88 90 03 00 00 49 63 ee 48 83 fd 09 0f 87 62 09 00 00 48 8d 44
> All code
> ========
>    0:   00 00                   add    %al,(%rax)
>    2:   31 ff                   xor    %edi,%edi
>    4:   e8 47 58 43 fe          callq  0xfffffffffe435850
>    9:   80 3c 24 00             cmpb   $0x0,(%rsp)
>    d:   74 12                   je     0x21
>    f:   9c                      pushfq
>   10:   58                      pop    %rax
>   11:   f6 c4 02                test   $0x2,%ah
>   14:   0f 85 1f 08 00 00       jne    0x839
>   1a:   31 ff                   xor    %edi,%edi
>   1c:   e8 6f 9c 5b fe          callq  0xfffffffffe5b9c90
>   21:   e8 aa 0f 71 fe          callq  0xfffffffffe710fd0
>   26:   fb                      sti
>   27:   45 85 f6                test   %r14d,%r14d
>   2a:*  0f 88 90 03 00 00       js     0x3c0            <-- trapping instruction
>   30:   49 63 ee                movslq %r14d,%rbp
>   33:   48 83 fd 09             cmp    $0x9,%rbp
>   37:   0f 87 62 09 00 00       ja     0x99f
>   3d:   48                      rex.W
>   3e:   8d                      .byte 0x8d
>   3f:   44                      rex.R
>
> Code starting with the faulting instruction
> ===========================================
>    0:   0f 88 90 03 00 00       js     0x396
>    6:   49 63 ee                movslq %r14d,%rbp
>    9:   48 83 fd 09             cmp    $0x9,%rbp
>    d:   0f 87 62 09 00 00       ja     0x975
>   13:   48                      rex.W
>   14:   8d                      .byte 0x8d
>   15:   44                      rex.R
> [ 1799.738502][    C0] RSP: 0018:ffffffff85007dd8 EFLAGS: 00000202
> [ 1799.744586][    C0] RAX: 00000000012d2f7d RBX: ffffe8ffffa02090 RCX: 1ffffffff0bfa611
> [ 1799.752936][    C0] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff83055f16
> [ 1799.761247][    C0] RBP: 0000000000000004 R08: 0000000000000001 R09: 0000000000000001
> [ 1799.769680][    C0] R10: ffffffff85fd86e7 R11: fffffbfff0bfb0dc R12: ffffffff85a79e80
> [ 1799.778069][    C0] R13: 000001a2fc2052e6 R14: 0000000000000004 R15: 0000000000000000
> [ 1799.782354][ T6832] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
> [ 1799.786409][ C0] ? cpuidle_enter_state (arch/x86/include/asm/irqflags.h:45 arch/x86/include/asm/irqflags.h:80 drivers/cpuidle/cpuidle.c:257)
> [ 1799.799117][ C0] ? cpuidle_enter_state (arch/x86/include/asm/irqflags.h:45 arch/x86/include/asm/irqflags.h:80 drivers/cpuidle/cpuidle.c:257)
> [ 1799.804473][ C0] ? menu_reflect (drivers/cpuidle/governors/menu.c:267)
> [ 1799.809304][ C0] cpuidle_enter (drivers/cpuidle/cpuidle.c:353)
> [ 1799.813795][ C0] do_idle (kernel/sched/idle.c:158 kernel/sched/idle.c:239 kernel/sched/idle.c:306)
> [ 1799.817917][ C0] ? arch_cpu_idle_exit+0xc0/0xc0
> [ 1799.823009][ C0] cpu_startup_entry (kernel/sched/idle.c:402 (discriminator 1))
> [ 1799.827914][ C0] start_kernel (init/main.c:1137)
> [ 1799.832479][ C0] secondary_startup_64_no_verify (arch/x86/kernel/head_64.S:283)
> [ 1799.838530][    C0]  </TASK>
> [ 1799.841584][    C0]
> [ 1799.843870][    C0] Allocated by task 19319:
> [ 1799.848379][ C0] kasan_save_stack (mm/kasan/common.c:38)
> [ 1799.853303][ C0] __kasan_slab_alloc (mm/kasan/common.c:46 mm/kasan/common.c:434 mm/kasan/common.c:467)
> [ 1799.858176][ C0] kmem_cache_alloc (mm/slab.h:520 mm/slub.c:3234 mm/slub.c:3242 mm/slub.c:3247)
> [ 1799.863091][ C0] copy_net_ns (include/linux/slab.h:714 net/core/net_namespace.c:404 net/core/net_namespace.c:459)
> [ 1799.867457][ C0] create_new_namespaces+0x335/0x900
> [ 1799.873494][ C0] unshare_nsproxy_namespaces (kernel/nsproxy.c:226 (discriminator 4))
> [ 1799.879267][ C0] ksys_unshare (kernel/fork.c:3075)
> [ 1799.883868][ C0] __x64_sys_unshare (kernel/fork.c:3144)
> [ 1799.888661][ C0] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> [ 1799.893312][ C0] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113)
> [ 1799.899477][    C0]
> [ 1799.901845][    C0] The buggy address belongs to the object at ffff88889835e600
> [ 1799.901845][    C0]  which belongs to the cache net_namespace of size 6272
> [ 1799.916823][    C0] The buggy address is located 1152 bytes inside of
> [ 1799.916823][    C0]  6272-byte region [ffff88889835e600, ffff88889835fe80)
> [ 1799.930935][    C0] The buggy address belongs to the page:
> [ 1799.936797][    C0] page:0000000041ff24a7 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88889835e600 pfn:0x898358
> [ 1799.948909][    C0] head:0000000041ff24a7 order:3 compound_mapcount:0 compound_pincount:0
> [ 1799.957574][    C0] memcg:ffff8881e9591681
> [ 1799.961926][    C0] flags: 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
> [ 1799.970490][    C0] raw: 0017ffffc0010200 ffffea000a32ac00 dead000000000002 ffff888100bc8c80
> [ 1799.979427][    C0] raw: ffff88889835e600 0000000080050004 00000001ffffffff ffff8881e9591681
> [ 1799.988352][    C0] page dumped because: kasan: bad access detected
> [ 1799.995035][    C0]
> [ 1799.997380][    C0] Memory state around the buggy address:
> [ 1800.003163][    C0]  ffff88889835e980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 1800.011374][    C0]  ffff88889835ea00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 1800.019699][    C0] >ffff88889835ea80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 1800.028007][    C0]                    ^
> [ 1800.032207][    C0]  ffff88889835eb00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 1800.040602][    C0]  ffff88889835eb80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 1800.049061][    C0] ==================================================================
> [ 1800.057470][    C0] Disabling lock debugging due to kernel taint
> [ 1800.364663][  T434] # tx=19158 (1195 MB) txc=0 zc=n
> [ 1800.364686][  T434]
> [ 1800.763181][  T434] # rx=9578 (1195 MB)
> [ 1800.763193][  T434]
> [ 1800.769974][  T434] # ipv6 tcp -z -t 1
> [ 1800.769984][  T434]
> [ 1802.219504][  T434] # tx=17552 (1095 MB) txc=17552 zc=n
> [ 1802.219515][  T434]
> [ 1802.577158][  T434] # rx=8777 (1095 MB)
> [ 1802.577170][  T434]
> [ 1802.583655][  T434] # ok
> [ 1802.583669][  T434]
> [ 1802.697567][T19410] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
> [ 1802.754498][  T434] # ipv4 udp -t 1
> [ 1802.754512][  T434]
> [ 1803.686331][T19410] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
> [ 1804.167573][  T434] # tx=40439 (2523 MB) txc=0 zc=n
> [ 1804.167595][  T434]
> [ 1804.666768][  T434] # rx=40439 (2523 MB)
> [ 1804.666780][  T434]
> [ 1804.673747][  T434] # ipv4 udp -z -t 1
> [ 1804.673755][  T434]
> [ 1806.082032][  T434] # tx=18970 (1183 MB) txc=18970 zc=n
> [ 1806.082049][  T434]
> [ 1806.580275][  T434] # rx=18956 (1182 MB)
> [ 1806.580321][  T434]
> [ 1806.587038][  T434] # ok
> [ 1806.587045][  T434]
> [ 1806.717784][  T100] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
> [ 1806.781443][  T434] # ipv6 udp -t 1
>
>
> To reproduce:
>
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         sudo bin/lkp install job.yaml           # job file is attached in this email
>         bin/lkp split-job --compatible job.yaml # generate the yaml file for lkp run
>         sudo bin/lkp run generated-yaml-file
>
>         # if come across any failure that blocks the test,
>         # please remove ~/.lkp and /lkp dir to run from a clean state.
>
>
>
> ---
> 0DAY/LKP+ Test Infrastructure                   Open Source Technology Center
> https://lists.01.org/hyperkitty/list/lkp@lists.01.org       Intel Corporation
>
> Thanks,
> Oliver Sang
>
