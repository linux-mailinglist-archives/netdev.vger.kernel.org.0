Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E1A4E5CE0
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 02:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345859AbiCXBnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 21:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241733AbiCXBnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 21:43:04 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5F992D26
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 18:41:32 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2e5969bdf31so36656897b3.8
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 18:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dkz9ZRVS+nRHJtc9MLa3dbGlHTYZCC9MEJOOMvqLmio=;
        b=FpaSXwv7nY704lM4lXoFwypZSa9MMUSqkWimagng1EmivUzGuQRMOnAQR/LIHSjA2C
         ntqlvijW96MMsU3t+rXyYpvCFc4cFlmvjJJLQcfpDE/x/KDg7s+n+MK6VyoeLVwuUFn5
         6gXBvlQpF9kaIkqZ6uQ3u5rm+4kUMuJL7jiZh/VX85bXHystKtxPN7Ysk/vpkRcEXhEd
         g5dB1MAVmq0O8dHS4dwHN2bCm11TkQE4PzKPsUiUoD2pi3U+n+Gdo5ltfg4m+pJqHcLW
         FJIvAIwzJjP1l99G2Ur30LBnHBFX4auEagom3OfVXTK8ZszQJUxpe6U5CSrS7GonaHiY
         hlvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dkz9ZRVS+nRHJtc9MLa3dbGlHTYZCC9MEJOOMvqLmio=;
        b=NP0LkGs5E3MezA2TSC+J4CK8OCSjTpiv6taRtypUl7lPPIsvPlGNun8g+fG0Qhv1q6
         rH7suLKfv13lZNgh5VTcxhTTXpMr+3TaBdQlxHxBFyn5wJpmv3AdTLrHVnL65jmlTfxW
         /1HadLCEXA+5OrF9XwwrqgslzgvxeNtUd2oq/u/zexahJF74xr4n9Dn8OwE9zpkwV+LE
         SXEpT7z+bcpFV3qvIXZzLZ5qocn2FtJCfGSDu1xGYaSIHOZ5R7HPQ4MsEKadodE7V7MX
         gnQ0F2h55ArVxGjcvDAo3AzwCq31Q4nCRKP/nAPH7FILvlgDI+n6UomRqQDrMv78+Rae
         eMKg==
X-Gm-Message-State: AOAM532zXgPJAjmX0HDDnBONwlzWPJ6ZHe41M9fMzsWFe1+ntQltqnpx
        zyqX19InED0ITXzBEAFBRYMA7pCRrHgwb8HSKSrqdA==
X-Google-Smtp-Source: ABdhPJyjNutITyLnHUHPb5Ijg9ZyH4hdOT11T4BUaziz/+zYGx6o4xMuLwd9Od66XZP1MLkigQoRY35jftUfrQA7aUQ=
X-Received: by 2002:a81:4f87:0:b0:2e5:dc8f:b4e with SMTP id
 d129-20020a814f87000000b002e5dc8f0b4emr2644515ywb.467.1648086091136; Wed, 23
 Mar 2022 18:41:31 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000acf1e405daebb7c7@google.com>
In-Reply-To: <000000000000acf1e405daebb7c7@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 23 Mar 2022 18:41:20 -0700
Message-ID: <CANn89iKMWp3o7ZS9dL+6GgWR-tr2rOvMKdKxb1=aDmhLB7mFrw@mail.gmail.com>
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in __tcp_transmit_skb
To:     syzbot <syzbot+090d23ddbd5cd185c2e0@syzkaller.appspotmail.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 5:13 PM syzbot
<syzbot+090d23ddbd5cd185c2e0@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    36c2e31ad25b net: geneve: add missing netlink policy and s..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=17c308a5700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4a15e2288cf165c9
> dashboard link: https://syzkaller.appspot.com/bug?extid=090d23ddbd5cd185c2e0
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=171eadbd700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12cacda3700000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+090d23ddbd5cd185c2e0@syzkaller.appspotmail.com
>

AF_SMC does not handle TCP_REPAIR properly.

Look at commit d9e4c129181004e ("mptcp: only admit explicitly
supported sockopt") for an equivalent bug/fix.


> BUG: kernel NULL pointer dereference, address: 0000000000000000
> #PF: supervisor instruction fetch in kernel mode
> #PF: error_code(0x0010) - not-present page
> PGD 13fd5067 P4D 13fd5067 PUD 77ebc067 PMD 0
> Oops: 0010 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 7423 Comm: syz-executor720 Not tainted 5.17.0-rc8-syzkaller-02803-g36c2e31ad25b #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
> RSP: 0018:ffffc900001d0a60 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: ffff88801e00cd10 RCX: 0000000000000100
> RDX: 1ffff11003c019a3 RSI: ffff8880155c5c80 RDI: ffff888014bac800
> RBP: ffff888014bac800 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff87bccdc7 R11: 0000000000000000 R12: ffff8880155c5c80
> R13: 0000000000000000 R14: ffff888014bacf60 R15: ffff88807527012c
> FS:  000055555733b3c0(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 00000000757b0000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <IRQ>
>  __tcp_transmit_skb+0x1098/0x38b0 net/ipv4/tcp_output.c:1371
>  tcp_transmit_skb net/ipv4/tcp_output.c:1420 [inline]
>  tcp_xmit_probe_skb+0x28c/0x320 net/ipv4/tcp_output.c:4006
>  tcp_write_wakeup+0x1bd/0x610 net/ipv4/tcp_output.c:4059
>  tcp_send_probe0+0x44/0x560 net/ipv4/tcp_output.c:4074
>  tcp_probe_timer net/ipv4/tcp_timer.c:398 [inline]
>  tcp_write_timer_handler+0x9ed/0xbc0 net/ipv4/tcp_timer.c:626
>  tcp_write_timer+0xa2/0x2b0 net/ipv4/tcp_timer.c:642
>  call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
>  expire_timers kernel/time/timer.c:1466 [inline]
>  __run_timers.part.0+0x67c/0xa30 kernel/time/timer.c:1734
>  __run_timers kernel/time/timer.c:1715 [inline]
>  run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
>  __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
>  invoke_softirq kernel/softirq.c:432 [inline]
>  __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
>  irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
>  sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
> RIP: 0010:lock_acquire+0x1ef/0x510 kernel/locking/lockdep.c:5607
> Code: e4 a4 7e 83 f8 01 0f 85 b4 02 00 00 9c 58 f6 c4 02 0f 85 9f 02 00 00 48 83 7c 24 08 00 74 01 fb 48 b8 00 00 00 00 00 fc ff df <48> 01 c3 48 c7 03 00 00 00 00 48 c7 43 08 00 00 00 00 48 8b 84 24
> RSP: 0018:ffffc90002eaf888 EFLAGS: 00000206
> RAX: dffffc0000000000 RBX: 1ffff920005d5f13 RCX: 5ad5b746ce328923
> RDX: 1ffff1100e5374eb RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8fe0c947
> R10: fffffbfff1fc1928 R11: 0000000000000001 R12: 0000000000000002
> R13: 0000000000000000 R14: ffffffff8bb84ca0 R15: 0000000000000000
>  rcu_lock_acquire include/linux/rcupdate.h:268 [inline]
>  rcu_read_lock include/linux/rcupdate.h:694 [inline]
>  fib_lookup.constprop.0+0x8f/0x460 include/net/ip_fib.h:377
>  ip_route_output_key_hash_rcu+0xf54/0x2c80 net/ipv4/route.c:2737
>  ip_route_output_key_hash+0x183/0x2f0 net/ipv4/route.c:2627
>  __ip_route_output_key include/net/route.h:127 [inline]
>  ip_route_output_flow+0x23/0x150 net/ipv4/route.c:2857
>  ip_route_newports include/net/route.h:343 [inline]
>  tcp_v4_connect+0x12a5/0x1d00 net/ipv4/tcp_ipv4.c:283
>  __inet_stream_connect+0x8cf/0xed0 net/ipv4/af_inet.c:660
>  inet_stream_connect+0x53/0xa0 net/ipv4/af_inet.c:724
>  smc_connect+0x230/0x450 net/smc/af_smc.c:1522
>  __sys_connect_file+0x155/0x1a0 net/socket.c:1900
>  __sys_connect+0x161/0x190 net/socket.c:1917
>  __do_sys_connect net/socket.c:1927 [inline]
>  __se_sys_connect net/socket.c:1924 [inline]
>  __x64_sys_connect+0x6f/0xb0 net/socket.c:1924
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f23b4ec0889
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffce8f74658 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
> RAX: ffffffffffffffda RBX: 00007ffce8f746b0 RCX: 00007f23b4ec0889
> RDX: 0000000000000010 RSI: 00000000200001c0 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 000000000000cf1c R09: 000000000000cf1c
> R10: 0000000000000004 R11: 0000000000000246 R12: 00007ffce8f746a0
> R13: 000000000000cf1c R14: 00007ffce8f7469c R15: 431bde82d7b634db
>  </TASK>
> Modules linked in:
> CR2: 0000000000000000
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
> RSP: 0018:ffffc900001d0a60 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: ffff88801e00cd10 RCX: 0000000000000100
> RDX: 1ffff11003c019a3 RSI: ffff8880155c5c80 RDI: ffff888014bac800
> RBP: ffff888014bac800 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff87bccdc7 R11: 0000000000000000 R12: ffff8880155c5c80
> R13: 0000000000000000 R14: ffff888014bacf60 R15: ffff88807527012c
> FS:  000055555733b3c0(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 00000000757b0000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>    0:   e4 a4                   in     $0xa4,%al
>    2:   7e 83                   jle    0xffffff87
>    4:   f8                      clc
>    5:   01 0f                   add    %ecx,(%rdi)
>    7:   85 b4 02 00 00 9c 58    test   %esi,0x589c0000(%rdx,%rax,1)
>    e:   f6 c4 02                test   $0x2,%ah
>   11:   0f 85 9f 02 00 00       jne    0x2b6
>   17:   48 83 7c 24 08 00       cmpq   $0x0,0x8(%rsp)
>   1d:   74 01                   je     0x20
>   1f:   fb                      sti
>   20:   48 b8 00 00 00 00 00    movabs $0xdffffc0000000000,%rax
>   27:   fc ff df
> * 2a:   48 01 c3                add    %rax,%rbx <-- trapping instruction
>   2d:   48 c7 03 00 00 00 00    movq   $0x0,(%rbx)
>   34:   48 c7 43 08 00 00 00    movq   $0x0,0x8(%rbx)
>   3b:   00
>   3c:   48                      rex.W
>   3d:   8b                      .byte 0x8b
>   3e:   84                      .byte 0x84
>   3f:   24                      .byte 0x24
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
