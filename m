Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965C340EEDF
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 03:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242444AbhIQBkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 21:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242423AbhIQBj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 21:39:59 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2879AC061764
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 18:38:38 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id f22so12533695qkm.5
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 18:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/TpARtOiukxm9KcDE9LGiMBmRMbHgYJxAgEUpeRwtF8=;
        b=F9mWWxhR8CvhQc3bB/XO27BPD32iq6WPas2nEsp+eVTOGKwdKBdH0Mj6WD17KN6KMh
         XvXohjCDvi6E/d7CdMjsEzLdqR/bri4JTFZ7dZzq9vO+uM6NeNH+E/wMlpzt5QxIOpX/
         nWnhxnK8XCUTQuVDis60zP8tweUXxradu9rdLYF5Tb8RNDHLeiYJzlYvutbMuKFG+G3v
         aoVqWJ7BFcoOfhOQyUx0vHXuGN2Pqbv7+Q2tysWZVpMsumlyOlkZVjyjCqdZBRJ7iWi4
         0RGVikRPfrDZsj/0hs1H+HJnaSh7/tAKdv8p2yZej0GOuT6e+M/0Sky3UERN4pE57279
         abjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/TpARtOiukxm9KcDE9LGiMBmRMbHgYJxAgEUpeRwtF8=;
        b=H2jVPvn+tyKXQwU5Rne4JMf1HZqMfvxV8XA9gcYXxSdOG7F7GMLxWdLkv2EsxOH+QU
         94+8qnn7QtuxgRdI/gqNrRsqL3977RYbSqYmO0apgCUSsLyxJRDk8i8CtcY9k6oDzxRt
         smmxSkkUSgk3wDXEcWlkkL+JKiue2wl9LmCHrEc3YO5tAJbvVU5gAe5sNdGeI5BfYez7
         fvO/7J6ghgTUkWnN99nxLXeooBJlGqUr5vKN3V0Peocq4nBescSapYYkfovZpEE4249C
         7QMnn7sQRG8TDtnAZBzgguwq3klx8QavLXltxta/k3D/tyn0r89q8/Agn15CIyutC6fN
         MJQw==
X-Gm-Message-State: AOAM533ych8RsnYERgdFy5p85YZYGP5Gj30qMJcIG0ClRtzJ1VCN7/it
        o75Did5QBdCQX6RLwwMbtHmXUNMEtrf1Lhzu/Fk5bB1o/Lxmdg==
X-Google-Smtp-Source: ABdhPJweDHuOKBDk0CWkDfcs2TF1VC38roGNwtgcB6Glq0GidXYg5ggQDv7DqY46vzZWVKciWcF27OI4uRbPt1bcT/U=
X-Received: by 2002:a25:afd3:: with SMTP id d19mr10695675ybj.78.1631842716888;
 Thu, 16 Sep 2021 18:38:36 -0700 (PDT)
MIME-Version: 1.0
References: <CACkBjsb5gtv5q8XdvL0QkK19GmifydqZ9MrvaAjG7m0YveWKOQ@mail.gmail.com>
In-Reply-To: <CACkBjsb5gtv5q8XdvL0QkK19GmifydqZ9MrvaAjG7m0YveWKOQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 16 Sep 2021 18:38:25 -0700
Message-ID: <CANn89i+Q+qTtexsu4HgmPEnZu09uu7o+tW_vZ-CftZocCji0OQ@mail.gmail.com>
Subject: Re: WARNING in skb_try_coalesce
To:     Hao Sun <sunhao.th@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 6:35 PM Hao Sun <sunhao.th@gmail.com> wrote:
>
> Hello,
>
> When using Healer to fuzz the latest Linux kernel, the following crash
> was triggered.
>

This is a known problem, caused by recent changes from Vasily Averin.

Thanks

> HEAD commit: ff1ffd71d5f0 Merge tag 'hyperv-fixes-signed-20210915
> git tree: upstream
> console output:
> https://drive.google.com/file/d/108QvdldUg5-0Gc1q1OiJA4HqGmTTFK7a/view?usp=sharing
> kernel config: https://drive.google.com/file/d/1zXpDhs-IdE7tX17B7MhaYP0VGUfP6m9B/view?usp=sharing
>
> Sorry, I don't have a reproducer for this crash, hope the symbolized
> report can help.
> If you fix this issue, please add the following tag to the commit:
> Reported-by: Hao Sun <sunhao.th@gmail.com>
>
> ------------[ cut here ]------------
> WARNING: CPU: 3 PID: 0 at net/core/skbuff.c:5412
> skb_try_coalesce+0x11c6/0x1570 net/core/skbuff.c:5412
> Modules linked in:
> CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.15.0-rc1+ #6
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:skb_try_coalesce+0x11c6/0x1570 net/core/skbuff.c:5412
> Code: 00 48 c1 e0 2a 48 c1 ea 03 80 3c 02 00 0f 85 50 01 00 00 49 8b
> 84 24 c8 00 00 00 48 89 44 24 50 e9 4f f5 ff ff e8 4a b6 62 fa <0f> 0b
> e9 6c f9 ff ff e8 3e b6 62 fa 48 8b 44 24 78 48 8d 70 ff 48
> RSP: 0018:ffffc900008a0368 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 00000000fffffea8 RCX: ffff888100159c80
> RDX: 0000000000000000 RSI: ffff888100159c80 RDI: 0000000000000002
> RBP: ffff88801a2b3400 R08: ffffffff87139896 R09: 00000000fffffea8
> R10: 0000000000000004 R11: ffffed1002fdfa89 R12: ffff88802be90780
> R13: ffff888017595ac0 R14: ffff88802be907fe R15: 0000000000000028
> FS:  0000000000000000(0000) GS:ffff888135d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055b9f8f7c488 CR3: 0000000111612000 CR4: 0000000000350ee0
> DR0: 00000000200002c0 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> Call Trace:
>  <IRQ>
>  tcp_try_coalesce net/ipv4/tcp_input.c:4642 [inline]
>  tcp_try_coalesce+0x393/0x920 net/ipv4/tcp_input.c:4621
>  tcp_queue_rcv+0x8a/0x710 net/ipv4/tcp_input.c:4905
>  tcp_data_queue+0xb78/0x49e0 net/ipv4/tcp_input.c:5016
>  tcp_rcv_established+0x944/0x2040 net/ipv4/tcp_input.c:5928
>  tcp_v4_do_rcv+0x65e/0xb20 net/ipv4/tcp_ipv4.c:1694
>  tcp_v4_rcv+0x37b4/0x4580 net/ipv4/tcp_ipv4.c:2087
>  ip_protocol_deliver_rcu+0xa7/0xed0 net/ipv4/ip_input.c:204
>  ip_local_deliver_finish+0x207/0x370 net/ipv4/ip_input.c:231
>  NF_HOOK include/linux/netfilter.h:307 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip_local_deliver+0x1c5/0x4e0 net/ipv4/ip_input.c:252
>  dst_input include/net/dst.h:460 [inline]
>  ip_rcv_finish+0x1da/0x2f0 net/ipv4/ip_input.c:429
>  NF_HOOK include/linux/netfilter.h:307 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip_rcv+0xcd/0x3b0 net/ipv4/ip_input.c:540
>  deliver_skb net/core/dev.c:2212 [inline]
>  deliver_ptype_list_skb net/core/dev.c:2227 [inline]
>  __netif_receive_skb_core+0x179d/0x3940 net/core/dev.c:5392
>  __netif_receive_skb_one_core+0xae/0x180 net/core/dev.c:5434
>  __netif_receive_skb+0x24/0x1c0 net/core/dev.c:5550
>  process_backlog+0x223/0x770 net/core/dev.c:6427
>  __napi_poll+0xb3/0x630 net/core/dev.c:6982
>  napi_poll net/core/dev.c:7049 [inline]
>  net_rx_action+0x823/0xbc0 net/core/dev.c:7136
>  __do_softirq+0x1d7/0x93b kernel/softirq.c:558
>  invoke_softirq kernel/softirq.c:432 [inline]
>  __irq_exit_rcu kernel/softirq.c:636 [inline]
>  irq_exit_rcu+0xf2/0x130 kernel/softirq.c:648
>  sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
>  </IRQ>
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
> RIP: 0010:default_idle+0xb/0x10 arch/x86/kernel/process.c:717
> Code: 3b 5f 88 f8 e9 6f fe ff ff e8 31 5f 88 f8 e9 3d fe ff ff e8 f7
> 30 fd ff cc cc cc cc cc cc cc eb 07 0f 00 2d a7 bf 50 00 fb f4 <c3> 0f
> 1f 40 00 41 54 be 08 00 00 00 53 65 48 8b 1c 25 40 f0 01 00
> RSP: 0018:ffffc90000777de0 EFLAGS: 00000206
> RAX: 000000000090b2d1 RBX: 0000000000000003 RCX: ffffffff8932aef2
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000003 R08: 0000000000000001 R09: ffffed1026ba6542
> R10: ffff888135d32a0b R11: ffffed1026ba6541 R12: 0000000000000003
> R13: 0000000000000003 R14: ffffffff8d6dbbd0 R15: 0000000000000000
>  default_idle_call+0xc4/0x420 kernel/sched/idle.c:112
>  cpuidle_idle_call kernel/sched/idle.c:194 [inline]
>  do_idle+0x3f9/0x570 kernel/sched/idle.c:306
>  cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:403
>  start_secondary+0x227/0x2f0 arch/x86/kernel/smpboot.c:270
>  secondary_startup_64_no_verify+0xb0/0xbb
> ----------------
> Code disassembly (best guess):
>    0: 3b 5f 88              cmp    -0x78(%rdi),%ebx
>    3: f8                    clc
>    4: e9 6f fe ff ff        jmpq   0xfffffe78
>    9: e8 31 5f 88 f8        callq  0xf8885f3f
>    e: e9 3d fe ff ff        jmpq   0xfffffe50
>   13: e8 f7 30 fd ff        callq  0xfffd310f
>   18: cc                    int3
>   19: cc                    int3
>   1a: cc                    int3
>   1b: cc                    int3
>   1c: cc                    int3
>   1d: cc                    int3
>   1e: cc                    int3
>   1f: eb 07                jmp    0x28
>   21: 0f 00 2d a7 bf 50 00 verw   0x50bfa7(%rip)        # 0x50bfcf
>   28: fb                    sti
>   29: f4                    hlt
> * 2a: c3                    retq <-- trapping instruction
>   2b: 0f 1f 40 00          nopl   0x0(%rax)
>   2f: 41 54                push   %r12
>   31: be 08 00 00 00        mov    $0x8,%esi
>   36: 53                    push   %rbx
>   37: 65 48 8b 1c 25 40 f0 mov    %gs:0x1f040,%rbx
>   3e: 01 00
