Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42B860704C
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 08:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiJUGpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 02:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiJUGpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 02:45:49 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C24181C83;
        Thu, 20 Oct 2022 23:45:47 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ot12so4898299ejb.1;
        Thu, 20 Oct 2022 23:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UsP6BA8242iuA6asJSMHNVclQ4lpHkn1NjFDmAKWmkM=;
        b=hkRUOS6LIIMe3DJHptGpld7ztBTrrDRtgDBhqLNnHyeKwSx4SWUtE/LDRqhv50NeXW
         C7tygAprsv0R0pLn8QIc46UjwXd7bcSEBBW0ViCNgx4xNlMTUwm45MYGXQATK9fpOh7h
         6r0QepuzZk3fyZ6XJRSiBbQ8gWSnOUGpsIBZd8wZCPeZFPGoYwI5ELuzebAl/zL88yWV
         zW+IobqbxgOWOm79i0t/GweVIZVCECw+c4HN1zAgZKA4Zgtt3Yby90AhZxs+sUpGf2lc
         UPTsOqw62lyXk+jHrvNVFv2AtwD70trlV+ylz3bwQ6Ba/46/kFj8/ulOt/xlf0DxJ79s
         pH6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UsP6BA8242iuA6asJSMHNVclQ4lpHkn1NjFDmAKWmkM=;
        b=RtoPSu8BrMFonq32XuFQwfmMhZT3rfRuOFmNpAOyjkgE5+7jf9Ocqdwe9yu9ruzws9
         zTYcE4EhJ7Dkr9mHUFbUbz66KrfaSJSW4IkkcG2pgHeGFr6M+MCKHVv/+2Mxl2n5i4B9
         FKjd9qCmL0PFzoq6fzb5jpoKC7YapkrI2WDuAYad4RZKOwiiJqtTunriCyZvuUxl/s3F
         SUY2ZI7Fk48OyFtkZLzKHQ4vvo6/8JmtbAd+0zb603Ai6OzUhvkLDP2wIrCMw38bVH0k
         bGKO55j5W0EBuoILylQf/9mMx+xio1bte2pbLw/JtpLOZEfmnU9A93m68HdhZlKyiGYS
         yxqg==
X-Gm-Message-State: ACrzQf0Zj0Bw3T5kznLoZx8oQkQmvejC6V0lirzRVbndO8QFs3yaakRn
        +S14rouWFyUPPYjlRLsmCS1rPfcDH108yOknk5g=
X-Google-Smtp-Source: AMsMyM5tmmxQ3IxC5PHRlD6ynHeOQX6lKutwP0ff+pOfxpD1GM2NIzXNMiFisOSNfr9bBmTO4/5MU1qycDdKpA4VCLg=
X-Received: by 2002:a17:907:2d06:b0:78d:50db:130e with SMTP id
 gs6-20020a1709072d0600b0078d50db130emr14178681ejc.371.1666334745803; Thu, 20
 Oct 2022 23:45:45 -0700 (PDT)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Fri, 21 Oct 2022 14:45:13 +0800
Message-ID: <CAO4mrfe3dG7cMP1V5FLUkw7s+50c9vichigUMQwsxX4M=45QEw@mail.gmail.com>
Subject: WARNING in isotp_tx_timer_handler
To:     socketcan@hartkopp.net, mkl@pengutronix.de, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux Developer,

Recently when using our tool to fuzz kernel, the following crash was triggered:

HEAD commit: 4fe89d07 Linux v6.0
git tree: upstream
compiler: clang 12.0.0
console output:
https://drive.google.com/file/d/1uwGcdgsj0b2RQy0dQqiCN5ntcbYpVoKL/view?usp=sharing
Syzlang reproducer:
https://drive.google.com/file/d/1sWib_bzKTQCeQOqApX9y1wVJ0C-UdyJP/view?usp=sharing
kernel config: https://drive.google.com/file/d/1ZHRxVTXHL9mENdAPmQYS1DtgbflZ9XsD/view?usp=sharing

Unfortunately, I don't have any C reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

WARNING: CPU: 0 PID: 0 at net/can/isotp.c:910 isotp_tx_timer_handler+0x160/0x270
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.0.0 #35
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:isotp_tx_timer_handler+0x160/0x270 net/can/isotp.c:910
Code: 01 00 00 00 00 00 48 81 c3 90 09 02 00 31 ed 48 89 df be 01 00
00 00 ba 01 00 00 00 31 c9 e8 07 62 2b f8 eb 6e e8 d0 15 4e f8 <0f> 0b
31 ed eb 63 e8 c5 15 4e f8 e8 70 75 3e f8 49 89 c6 49 81 c6
RSP: 0018:ffffc90000007c30 EFLAGS: 00010246
RAX: ffffffff89390350 RBX: ffff88804c440000 RCX: ffffffff8ccbb940
RDX: 0000000080000101 RSI: ffffffff8e13dba0 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000005 R09: ffffffff8939023d
R10: 0000000000000003 R11: ffffffff8ccbb940 R12: 1ffff1100988a0f5
R13: ffffffff8ccbc360 R14: ffff88804c4507a8 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88802cc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000564e766615a8 CR3: 000000000cc8e000 CR4: 0000000000750ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <IRQ>
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x50b/0xa60 kernel/time/hrtimer.c:1749
 hrtimer_run_softirq+0x1b7/0x5d0 kernel/time/hrtimer.c:1766
 __do_softirq+0x372/0x783 kernel/softirq.c:571
 __irq_exit_rcu+0xcf/0x150 kernel/softirq.c:650
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x91/0xb0 arch/x86/kernel/apic/apic.c:1106
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
RIP: 0010:default_idle+0xb/0x10 arch/x86/kernel/process.c:731
Code: fe ff ff 44 89 e1 80 e1 07 80 c1 03 38 c1 7c 93 4c 89 e7 e8 07
f5 a9 f7 eb 89 e8 00 41 fd ff 66 90 0f 00 2d 87 bc 5a 00 fb f4 <c3> 0f
1f 40 00 41 57 41 56 53 49 be 00 00 00 00 00 fc ff df 65 48
RSP: 0018:ffffffff8cc07da8 EFLAGS: 000002c2
RAX: 2a4c2150f0015f00 RBX: ffffffff8ccbb940 RCX: ffffffff8a2b46ee
RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffffff8cc07ed0 R08: dffffc0000000000 R09: ffffed100598693d
R10: ffffed100598693d R11: 0000000000000000 R12: 1ffffffff1997728
R13: 1ffffffff1980fca R14: 0000000000000000 R15: dffffc0000000000
 default_idle_call+0x82/0xc0 kernel/sched/idle.c:109
 cpuidle_idle_call kernel/sched/idle.c:191 [inline]
 do_idle+0x215/0x5e0 kernel/sched/idle.c:303
 cpu_startup_entry+0x15/0x20 kernel/sched/idle.c:400
 rest_init+0x24f/0x270 init/main.c:727
 arch_call_rest_init+0xa/0xa
 start_kernel+0x490/0x536 init/main.c:1138
 secondary_startup_64_no_verify+0xcf/0xdb
 </TASK>
----------------
Code disassembly (best guess), 2 bytes skipped:
   0: ff 44 89 e1           incl   -0x1f(%rcx,%rcx,4)
   4: 80 e1 07             and    $0x7,%cl
   7: 80 c1 03             add    $0x3,%cl
   a: 38 c1                 cmp    %al,%cl
   c: 7c 93                 jl     0xffffffa1
   e: 4c 89 e7             mov    %r12,%rdi
  11: e8 07 f5 a9 f7       callq  0xf7a9f51d
  16: eb 89                 jmp    0xffffffa1
  18: e8 00 41 fd ff       callq  0xfffd411d
  1d: 66 90                 xchg   %ax,%ax
  1f: 0f 00 2d 87 bc 5a 00 verw   0x5abc87(%rip)        # 0x5abcad
  26: fb                   sti
  27: f4                   hlt
* 28: c3                   retq <-- trapping instruction
  29: 0f 1f 40 00           nopl   0x0(%rax)
  2d: 41 57                 push   %r15
  2f: 41 56                 push   %r14
  31: 53                   push   %rbx
  32: 49 be 00 00 00 00 00 movabs $0xdffffc0000000000,%r14
  39: fc ff df
  3c: 65                   gs
  3d: 48                   rex.W

Best,
Wei
