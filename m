Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A145FA13A
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 17:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJJPii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 11:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiJJPii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 11:38:38 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E40471BF9;
        Mon, 10 Oct 2022 08:38:33 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id k2so25726179ejr.2;
        Mon, 10 Oct 2022 08:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JsuMjhs+MgihkzMBVcqrltQP1hvZ675h8QTvnBZuxEE=;
        b=kDMwTT+Rj5hxx1lZbEUEtlfS6ukzhNrwf6nUd79f4T9FSu5l6X0LjA2fZWQFUQrAY+
         2qH3H+ZJatgwWwrRorX/xqPy8ygn07Z1B7tNbCopToadNG5fRbtLtLVvh7QT5D1zuYOA
         QNVuovmubRzuQh65LU2im/RzMjVvXCKHO7d/nTSiIx+KrxFnvQTXAlGgOrlm/fyfMFVp
         YmcEJPON90u2GYj4spnikpRyd6DXEwP4wres4UjZ+ksKl22yoHsqBYoV6U1qOZSTsQ2x
         Hzkhn0wOKU7XXMXwj5vBYXAaZMhcKJPvR8E2hpXBkHltOH1Oec12QSjaNTD33rTnf/CO
         /gYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JsuMjhs+MgihkzMBVcqrltQP1hvZ675h8QTvnBZuxEE=;
        b=bKD1nE/tVK8kHX/gon3TETLglPuiOGDuVNzw1wrPr/1wngnwTN4gkWbORfislTae9t
         S+9luU/kybimLT/c2U6Uzr57e1GA0QUfg7AitcNOwHO5nvZlG2M7qsVMfLda+TOh8/lz
         HoptaxVh16JgbXQBqATkhVpXHJDZEW2JxYJK/OONduIWv1SYDAUf8CFt+BLds2kTSxHv
         CFXoZcwKsE4fzm6nfl1U5122qz3bzclGWMyFKBXDwrU/f88GgjfvIjGBKsnhHYDPGqGR
         b8Fv+RIOrP8Dprwp5NfvzM4G1XtxNDp588knBQnrN0M/J/zW7RjCkZ8AQlM8crOLIqpr
         w8Jw==
X-Gm-Message-State: ACrzQf3kZLusftlaDuvirQaPQLnxtSAPuyqeMQUKG3K35Q6D3elgoSPF
        MpE6llM21Jbdeh22fG/7tme3v68v76d1hObEdTzmBkvR2w+ShA==
X-Google-Smtp-Source: AMsMyM58pkBmUY7F4411V5D2meYesnsY6fT61KQY/XKUqSt592qflVaY7wNVxFaW+w33GGuxsbZRoefkpdOKPHXxvwo=
X-Received: by 2002:a17:907:2c75:b0:78d:c201:e9aa with SMTP id
 ib21-20020a1709072c7500b0078dc201e9aamr2789950ejc.235.1665416311890; Mon, 10
 Oct 2022 08:38:31 -0700 (PDT)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Mon, 10 Oct 2022 23:37:55 +0800
Message-ID: <CAO4mrfctv+6_iBjhALswxUTpbFGzj+NGnVnj-5ezwnPRHYCWFA@mail.gmail.com>
Subject: INFO: rcu detected stall in net_rx_action
To:     davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, bigeasy@linutronix.de, imagedong@tencent.com,
        petrm@nvidia.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
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

HEAD commit: 64570fbc14f8 Linux 5.15-rc5
git tree: upstream
compiler: clang 12.0.0
console output:
https://drive.google.com/file/d/1BOhVEmi3RPIxx-F0LMLsgflaj0r0MyKv/view?usp=sharing
kernel config: https://drive.google.com/file/d/1lNwvovjLNrcuyFGrg05IoSmgO5jaKBBJ/view?usp=sharing

Unfortunately, I don't have any reproducer for this crash yet.

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 0-...!: (88 ticks this GP) idle=4c5/1/0x4000000000000000
softirq=42739/42739 fqs=1
(t=15633 jiffies g=62957 q=125)
rcu: rcu_preempt kthread starved for 15193 jiffies! g62957 f0x0
RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: Unless rcu_preempt kthread gets sufficient CPU time, OOM is now
expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27696 pid:   14
ppid:     2 flags:0x00004000
Call Trace:
 __schedule+0xc1a/0x11e0
 schedule+0x14b/0x210
 schedule_timeout+0x1b4/0x310
 rcu_gp_fqs_loop+0x1fd/0x770
 rcu_gp_kthread+0xa5/0x340
 kthread+0x419/0x510
 ret_from_fork+0x1f/0x30
rcu: Stack dump where RCU GP kthread last ran:
NMI backtrace for cpu 0
CPU: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 5.15.0-rc5+ #14
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl+0x1d8/0x2c4
 nmi_cpu_backtrace+0x452/0x480
 nmi_trigger_cpumask_backtrace+0x1a3/0x330
 rcu_check_gp_kthread_starvation+0x1f9/0x270
 rcu_sched_clock_irq+0x1de4/0x2bc0
 update_process_times+0x1ab/0x220
 tick_sched_timer+0x2a0/0x440
 __hrtimer_run_queues+0x51a/0xae0
 hrtimer_interrupt+0x3c9/0x1130
 __sysvec_apic_timer_interrupt+0xf9/0x280
 sysvec_apic_timer_interrupt+0x8c/0xb0
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20
RIP: 0010:e1000_clean+0x15ad/0x40b0
Code: c5 c8 04 00 00 4c 89 eb 48 c1 eb 03 42 80 3c 23 00 74 08 4c 89
ef e8 a2 2c 65 fc 49 8b 45 00 b9 9d 00 00 00 89 88 d0 00 00 00 <42> 80
3c 23 00 74 08 4c 89 ef e8 84 2c 65 fc 49 8b 45 00 8b 40 08
RSP: 0018:ffffc90000707840 EFLAGS: 00000246
RAX: ffffc900065c0000 RBX: 1ffff1100371f229 RCX: 000000000000009d
RDX: 0000000000000100 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90000707ac8 R08: ffffffff856f35c6 R09: ffffed100371f2a7
R10: ffffed100371f2a7 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff88801b8f9148 R14: 0000000000004e20 R15: 1ffff920000e0f2c
 __napi_poll+0xbd/0x550
 net_rx_action+0x67b/0xfc0
 __do_softirq+0x372/0x783
 run_ksoftirqd+0xa2/0x100
 smpboot_thread_fn+0x570/0xa20
 kthread+0x419/0x510
 ret_from_fork+0x1f/0x30
NMI backtrace for cpu 0
CPU: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 5.15.0-rc5+ #14
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl+0x1d8/0x2c4
 nmi_cpu_backtrace+0x452/0x480
 nmi_trigger_cpumask_backtrace+0x1a3/0x330
 rcu_dump_cpu_stacks+0x22d/0x390
 rcu_sched_clock_irq+0x1de9/0x2bc0
 update_process_times+0x1ab/0x220
 tick_sched_timer+0x2a0/0x440
 __hrtimer_run_queues+0x51a/0xae0
 hrtimer_interrupt+0x3c9/0x1130
 __sysvec_apic_timer_interrupt+0xf9/0x280
 sysvec_apic_timer_interrupt+0x8c/0xb0
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20
RIP: 0010:e1000_clean+0x15ad/0x40b0
Code: c5 c8 04 00 00 4c 89 eb 48 c1 eb 03 42 80 3c 23 00 74 08 4c 89
ef e8 a2 2c 65 fc 49 8b 45 00 b9 9d 00 00 00 89 88 d0 00 00 00 <42> 80
3c 23 00 74 08 4c 89 ef e8 84 2c 65 fc 49 8b 45 00 8b 40 08
RSP: 0018:ffffc90000707840 EFLAGS: 00000246
RAX: ffffc900065c0000 RBX: 1ffff1100371f229 RCX: 000000000000009d
RDX: 0000000000000100 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90000707ac8 R08: ffffffff856f35c6 R09: ffffed100371f2a7
R10: ffffed100371f2a7 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff88801b8f9148 R14: 0000000000004e20 R15: 1ffff920000e0f2c
 __napi_poll+0xbd/0x550
 net_rx_action+0x67b/0xfc0
 __do_softirq+0x372/0x783
 run_ksoftirqd+0xa2/0x100
 smpboot_thread_fn+0x570/0xa20
 kthread+0x419/0x510
 ret_from_fork+0x1f/0x30
----------------
Code disassembly (best guess), 1 bytes skipped:
   0: c8 04 00 00          enterq $0x4,$0x0
   4: 4c 89 eb              mov    %r13,%rbx
   7: 48 c1 eb 03          shr    $0x3,%rbx
   b: 42 80 3c 23 00        cmpb   $0x0,(%rbx,%r12,1)
  10: 74 08                je     0x1a
  12: 4c 89 ef              mov    %r13,%rdi
  15: e8 a2 2c 65 fc        callq  0xfc652cbc
  1a: 49 8b 45 00          mov    0x0(%r13),%rax
  1e: b9 9d 00 00 00        mov    $0x9d,%ecx
  23: 89 88 d0 00 00 00    mov    %ecx,0xd0(%rax)
* 29: 42 80 3c 23 00        cmpb   $0x0,(%rbx,%r12,1) <-- trapping instruction
  2e: 74 08                je     0x38
  30: 4c 89 ef              mov    %r13,%rdi
  33: e8 84 2c 65 fc        callq  0xfc652cbc
  38: 49 8b 45 00          mov    0x0(%r13),%rax
  3c: 8b 40 08              mov    0x8(%rax),%eax

Best,
Wei
