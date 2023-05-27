Return-Path: <netdev+bounces-5867-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB8B571338F
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 11:02:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B3092818E5
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 09:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 390491C04;
	Sat, 27 May 2023 09:02:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DE320FB
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 09:02:12 +0000 (UTC)
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39621E3
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 02:02:10 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-3f51ea3a062so61131cf.1
        for <netdev@vger.kernel.org>; Sat, 27 May 2023 02:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685178129; x=1687770129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x4mYc+5P7xLv/3nDjP8/NukFC/EP2kNlXAJ8peaiKoM=;
        b=Ngr68t0OybRZlznOAZcG4RmjJl5s292ixJ0IWNI1+ds18AsEkT6daf/2TEyv6bUF/g
         Owc/XDS2vBH0dXVZ+08SfZrbyJDdHawRmpMMfphpwvvfYUHGbIeSUTEDWVXd9e+rpS4x
         HR150XJcifJ+ZjseUu0oiLR4/8ICWuURPcHzkqPHlfcyXCIAfco8exUN6aWHN6c9I8w1
         ryicADFlY5JAjhwBOmSrFCFHn2EuY6APWP3Iohg5OFcq5ca43gNSnBEfIOn7gyjU9A+m
         fDhe0G0EjSBCvtNUofxe0FwZhQPYMcWFNOrh/ddRY79ffNG31Tbg9myejA6XEDJrTCEo
         byxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685178129; x=1687770129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x4mYc+5P7xLv/3nDjP8/NukFC/EP2kNlXAJ8peaiKoM=;
        b=PQYPa6wZ+dBkAU2d8zvrwK0PNNOzMab6PiMQRW59MAT5RpzDk9zDwPkcp+lp0aoHKG
         1RtEoGjjVfadyCfCDtoUW9y1K4q06pIZQ0hg26dkKXP0w7Romo00ylz89YcJdpbKC+cq
         ag8FQOHRN3tXzIct521mYLCjUi+Ii3tmzB7bck2CAW/NmtBQPKijQOFkna9Ww+P4cq0V
         q9kIhCKVXorYLFVUzeNam0006yeu6dBmOE81RlVInx5wkiTzJ+RLLfyXRyAfr0uCHy0Q
         JlI7oAK/4D+GCLjoQ3qOhYCvPDyYaTytgT88SghoqNRh0YmiDvvSeiRUN4blhzRzWhd+
         NBQA==
X-Gm-Message-State: AC+VfDwQTJCuGYqAzFUw10V2Bz5BmSnC1k5jSkQeIIrlxuSoJuSBzGlD
	rWfHjvaA0+kIZ4JZT0qZ+ogVgT8kPRXHmgAjLP3oJPL3dW8rJ9DiTk9jhw==
X-Google-Smtp-Source: ACHHUZ7pB8UxTMgbgOeUbvVYCMmnpqS58LanaGmRiPvPWVG//rvDvjmu7Hw9WyN7YO1lIVm84uEjgHOa+C3eZ8QQiR4=
X-Received: by 2002:ac8:5808:0:b0:3ee:d8fe:6f5c with SMTP id
 g8-20020ac85808000000b003eed8fe6f5cmr78560qtg.1.1685178129083; Sat, 27 May
 2023 02:02:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230527085100.4114825-1-gaoxingwang1@huawei.com>
In-Reply-To: <20230527085100.4114825-1-gaoxingwang1@huawei.com>
From: Eric Dumazet <edumazet@google.com>
Date: Sat, 27 May 2023 11:01:57 +0200
Message-ID: <CANn89iLzMBJE31VBL3jtu-ojdoAYwV_KLo1Qo+L6LWZ+5UKMtg@mail.gmail.com>
Subject: Re: ip6_gre: paninc in ip6gre_header
To: gaoxingwang <gaoxingwang1@huawei.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net, 
	dsahern@kernel.org, yoshfuji@linux-ipv6.org, pabeni@redhat.com, 
	liaichun@huawei.com, yanan@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 27, 2023 at 10:51=E2=80=AFAM gaoxingwang <gaoxingwang1@huawei.c=
om> wrote:
>
> Hello:
>   I am doing some fuzz test for kernel, the following crash was triggered=
.
>   My kernel version is 5.10.0.Have you encountered similar problems?
>   If there is a fix, please let me know.
>   Thank you very much.

Please do not report fuzzer tests on old kernels.

Yes, there is a fix already.

Make sure to use at least v5.10.180

Thanks.

>
> skbuff: skb_under_panic: text:ffffffff8ad94c6b len:-2047924812 put:-20479=
24888 head:ffff888034c9c000 data:ffff887faeda9bf8 tail:0x1ac end:0xec0 dev:=
team1
> ------------[ cut here ]------------
> kernel BUG at net/core/skbuff.c:110!
> invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 1 PID: 1546 Comm: syz-fuzzer Not tainted 5.10.0 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubunt=
u1.1 04/01/2014
> RIP: 0010:skb_panic+0x171/0x183 net/core/skbuff.c:110
> Code: f5 4c 8b 4c 24 10 41 56 8b 4b 70 45 89 e8 4c 89 e2 41 57 48 89 ee 4=
8 c7 c7 20 f2 2d 8e ff 74 24 10 ff 74 24 20 e8 da 59 62 ff <0f> 0b 48 c7 c7=
 00 2f 5e 92 48 83 c4 20 e8 cb 6f 6d ff e8 9c c5 5b
> RSP: 0000:ffff8880bcc096f0 EFLAGS: 00010282
> RAX: 0000000000000099 RBX: ffff88801e080f00 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff815ffb62 RDI: ffffed10179812d0
> RBP: ffffffff8e2df720 R08: 0000000000000099 R09: ffffed1017981267
> R10: ffff8880bcc09337 R11: ffffed1017981266 R12: ffffffff8ad94c6b
> R13: 0000000085ef2568 R14: ffff888062b8c000 R15: 0000000000000ec0
> FS:  000000c01741c490(0000) GS:ffff8880bcc00000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000c021635000 CR3: 000000001fdb6000 CR4: 0000000000150ee0
> Call Trace:
>  <IRQ>
>  skb_under_panic net/core/skbuff.c:120 [inline]
>  skb_push.cold+0x24/0x24 net/core/skbuff.c:1942
>  ip6gre_header+0xcb/0xaf0 net/ipv6/ip6_gre.c:1380
>  dev_hard_header include/linux/netdevice.h:3210 [inline]
>  neigh_connected_output+0x2a4/0x400 net/core/neighbour.c:1541
>  neigh_output include/net/neighbour.h:524 [inline]
>  ip6_finish_output2+0xa20/0x1d20 net/ipv6/ip6_output.c:145
>  __ip6_finish_output net/ipv6/ip6_output.c:210 [inline]
>  __ip6_finish_output+0x35d/0x920 net/ipv6/ip6_output.c:189
>  ip6_finish_output+0x38/0x1c0 net/ipv6/ip6_output.c:220
>  NF_HOOK_COND include/linux/netfilter.h:293 [inline]
>  ip6_output+0x1cc/0x400 net/ipv6/ip6_output.c:243
>  dst_output include/net/dst.h:453 [inline]
>  NF_HOOK include/linux/netfilter.h:304 [inline]
>  mld_sendpack+0x5ca/0xb80 net/ipv6/mcast.c:1679
>  mld_send_cr net/ipv6/mcast.c:1975 [inline]
>  mld_ifc_timer_expire+0x3c0/0x810 net/ipv6/mcast.c:2474
>  call_timer_fn+0x3f/0x200 kernel/time/timer.c:1414
>  expire_timers+0x21c/0x3b0 kernel/time/timer.c:1459
>  __run_timers kernel/time/timer.c:1753 [inline]
>  run_timer_softirq+0x2ad/0x7f0 kernel/time/timer.c:1766
>  __do_softirq+0x19b/0x612 kernel/softirq.c:322
>  asm_call_irq_on_stack+0x12/0x20
>  </IRQ>
>  __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
>  run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
>  do_softirq_own_stack+0x37/0x50 arch/x86/kernel/irq_64.c:77
>  invoke_softirq kernel/softirq.c:417 [inline]
>  __irq_exit_rcu kernel/softirq.c:447 [inline]
>  irq_exit_rcu+0x1a2/0x240 kernel/softirq.c:459
>  sysvec_apic_timer_interrupt+0x36/0x80 arch/x86/kernel/apic/apic.c:1116
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.=
h:635
> RIP: 0033:0x41e83e
> Code: 44 89 c1 45 89 d5 41 d3 ea 41 0f ba e2 04 0f 83 ec 00 00 00 48 89 4=
4 24 58 41 0f a3 cd 0f 83 87 00 00 00 4e 8d 14 20 4d 8b 12 <66> 90 4d 85 d2=
 74 79 4d 89 d5 4d 29 e2 4c 39 d2 77 6e 89 4c 24 3c
> RSP: 002b:000000c002629e88 EFLAGS: 00000207
> RAX: 0000000000000008 RBX: 000000c000041698 RCX: 0000000000000001
> RDX: 0000000000000040 RSI: 0000000000203002 RDI: 000000c0205f4800
> RBP: 000000c002629f10 R08: 0000000000000001 R09: 00007f954fcd92d0
> R10: 000000c00350bee0 R11: 00007f954fe52fff R12: 000000c0090c5a00
> R13: 00000000000000fa R14: 000000c007b66ea0 R15: ffffffffffffffff
> Modules linked in:
> kernel fault(0x1) notification starting on CPU 1
> kernel fault(0x1) notification finished on CPU 1
> ---[ end trace 854b3d6f97989351 ]---
> RIP: 0010:skb_panic+0x171/0x183 net/core/skbuff.c:110
> Code: f5 4c 8b 4c 24 10 41 56 8b 4b 70 45 89 e8 4c 89 e2 41 57 48 89 ee 4=
8 c7 c7 20 f2 2d 8e ff 74 24 10 ff 74 24 20 e8 da 59 62 ff <0f> 0b 48 c7 c7=
 00 2f 5e 92 48 83 c4 20 e8 cb 6f 6d ff e8 9c c5 5b
> RSP: 0000:ffff8880bcc096f0 EFLAGS: 00010282
> RAX: 0000000000000099 RBX: ffff88801e080f00 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff815ffb62 RDI: ffffed10179812d0
> RBP: ffffffff8e2df720 R08: 0000000000000099 R09: ffffed1017981267
> R10: ffff8880bcc09337 R11: ffffed1017981266 R12: ffffffff8ad94c6b
> R13: 0000000085ef2568 R14: ffff888062b8c000 R15: 0000000000000ec0
> FS:  000000c01741c490(0000) GS:ffff8880bcc00000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000c021635000 CR3: 000000001fdb6000 CR4: 0000000000150ee0

