Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDE160C5D7
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 09:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbiJYHvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 03:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiJYHvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 03:51:01 -0400
X-Greylist: delayed 362 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 25 Oct 2022 00:51:00 PDT
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6954F165CBB
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 00:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1666683895;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=pgQLreg96g/LEU9NyOQ4z/xGKlQpe3CPnAfHQW47lRw=;
    b=XixJjdONbrKBSfEGHzivRv1tcc0MVo5cPtzzY8P3H5F1Omv95JrtlDvEklutAetM4L
    lQBad4sYR4nc2w6WBx07stYatmLb/FU44tb9JU5/83DsZ2zra1aOx0mfumGnrpmtPb3o
    bxDGXpCY+4RGMbsMnDbWbqxirvenuo7rp8HmTJ3idWM/5vMqiiEh5U2U/sCPSwmlmKoj
    BwMw8I7Hdy61hz33kotAb/Rc2ZavmI2PF+h3qeA8rqcu3JMvWS/ElnU3G6c27K5FXSta
    6ZnWHNcqB5ExpCe4snqE/Ed/4BXqaRG/hHt1LXa8A+30RJZMYpvBF77bQaRkWQxh7Pp/
    w+pQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytJSr6hfz3Vg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d100::923]
    by smtp.strato.de (RZmta 48.2.0 AUTH)
    with ESMTPSA id Z2b42cy9P7iteLU
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 25 Oct 2022 09:44:55 +0200 (CEST)
Message-ID: <de934bb4-a34c-7e6d-0a33-86566c26353b@hartkopp.net>
Date:   Tue, 25 Oct 2022 09:44:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: WARNING in isotp_tx_timer_handler
To:     Wei Chen <harperchen1110@gmail.com>, mkl@pengutronix.de,
        davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <CAO4mrfe3dG7cMP1V5FLUkw7s+50c9vichigUMQwsxX4M=45QEw@mail.gmail.com>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <CAO4mrfe3dG7cMP1V5FLUkw7s+50c9vichigUMQwsxX4M=45QEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm looking at it.

Best,
Oliver

On 21.10.22 08:45, Wei Chen wrote:
> Dear Linux Developer,
> 
> Recently when using our tool to fuzz kernel, the following crash was triggered:
> 
> HEAD commit: 4fe89d07 Linux v6.0
> git tree: upstream
> compiler: clang 12.0.0
> console output:
> https://drive.google.com/file/d/1uwGcdgsj0b2RQy0dQqiCN5ntcbYpVoKL/view?usp=sharing
> Syzlang reproducer:
> https://drive.google.com/file/d/1sWib_bzKTQCeQOqApX9y1wVJ0C-UdyJP/view?usp=sharing
> kernel config: https://drive.google.com/file/d/1ZHRxVTXHL9mENdAPmQYS1DtgbflZ9XsD/view?usp=sharing
> 
> Unfortunately, I don't have any C reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: Wei Chen <harperchen1110@gmail.com>
> 
> WARNING: CPU: 0 PID: 0 at net/can/isotp.c:910 isotp_tx_timer_handler+0x160/0x270
> Modules linked in:
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.0.0 #35
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:isotp_tx_timer_handler+0x160/0x270 net/can/isotp.c:910
> Code: 01 00 00 00 00 00 48 81 c3 90 09 02 00 31 ed 48 89 df be 01 00
> 00 00 ba 01 00 00 00 31 c9 e8 07 62 2b f8 eb 6e e8 d0 15 4e f8 <0f> 0b
> 31 ed eb 63 e8 c5 15 4e f8 e8 70 75 3e f8 49 89 c6 49 81 c6
> RSP: 0018:ffffc90000007c30 EFLAGS: 00010246
> RAX: ffffffff89390350 RBX: ffff88804c440000 RCX: ffffffff8ccbb940
> RDX: 0000000080000101 RSI: ffffffff8e13dba0 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000005 R09: ffffffff8939023d
> R10: 0000000000000003 R11: ffffffff8ccbb940 R12: 1ffff1100988a0f5
> R13: ffffffff8ccbc360 R14: ffff88804c4507a8 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff88802cc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000564e766615a8 CR3: 000000000cc8e000 CR4: 0000000000750ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>   <IRQ>
>   __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
>   __hrtimer_run_queues+0x50b/0xa60 kernel/time/hrtimer.c:1749
>   hrtimer_run_softirq+0x1b7/0x5d0 kernel/time/hrtimer.c:1766
>   __do_softirq+0x372/0x783 kernel/softirq.c:571
>   __irq_exit_rcu+0xcf/0x150 kernel/softirq.c:650
>   irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
>   sysvec_apic_timer_interrupt+0x91/0xb0 arch/x86/kernel/apic/apic.c:1106
>   </IRQ>
>   <TASK>
>   asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
> RIP: 0010:default_idle+0xb/0x10 arch/x86/kernel/process.c:731
> Code: fe ff ff 44 89 e1 80 e1 07 80 c1 03 38 c1 7c 93 4c 89 e7 e8 07
> f5 a9 f7 eb 89 e8 00 41 fd ff 66 90 0f 00 2d 87 bc 5a 00 fb f4 <c3> 0f
> 1f 40 00 41 57 41 56 53 49 be 00 00 00 00 00 fc ff df 65 48
> RSP: 0018:ffffffff8cc07da8 EFLAGS: 000002c2
> RAX: 2a4c2150f0015f00 RBX: ffffffff8ccbb940 RCX: ffffffff8a2b46ee
> RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffffffff8cc07ed0 R08: dffffc0000000000 R09: ffffed100598693d
> R10: ffffed100598693d R11: 0000000000000000 R12: 1ffffffff1997728
> R13: 1ffffffff1980fca R14: 0000000000000000 R15: dffffc0000000000
>   default_idle_call+0x82/0xc0 kernel/sched/idle.c:109
>   cpuidle_idle_call kernel/sched/idle.c:191 [inline]
>   do_idle+0x215/0x5e0 kernel/sched/idle.c:303
>   cpu_startup_entry+0x15/0x20 kernel/sched/idle.c:400
>   rest_init+0x24f/0x270 init/main.c:727
>   arch_call_rest_init+0xa/0xa
>   start_kernel+0x490/0x536 init/main.c:1138
>   secondary_startup_64_no_verify+0xcf/0xdb
>   </TASK>
> ----------------
> Code disassembly (best guess), 2 bytes skipped:
>     0: ff 44 89 e1           incl   -0x1f(%rcx,%rcx,4)
>     4: 80 e1 07             and    $0x7,%cl
>     7: 80 c1 03             add    $0x3,%cl
>     a: 38 c1                 cmp    %al,%cl
>     c: 7c 93                 jl     0xffffffa1
>     e: 4c 89 e7             mov    %r12,%rdi
>    11: e8 07 f5 a9 f7       callq  0xf7a9f51d
>    16: eb 89                 jmp    0xffffffa1
>    18: e8 00 41 fd ff       callq  0xfffd411d
>    1d: 66 90                 xchg   %ax,%ax
>    1f: 0f 00 2d 87 bc 5a 00 verw   0x5abc87(%rip)        # 0x5abcad
>    26: fb                   sti
>    27: f4                   hlt
> * 28: c3                   retq <-- trapping instruction
>    29: 0f 1f 40 00           nopl   0x0(%rax)
>    2d: 41 57                 push   %r15
>    2f: 41 56                 push   %r14
>    31: 53                   push   %rbx
>    32: 49 be 00 00 00 00 00 movabs $0xdffffc0000000000,%r14
>    39: fc ff df
>    3c: 65                   gs
>    3d: 48                   rex.W
> 
> Best,
> Wei
