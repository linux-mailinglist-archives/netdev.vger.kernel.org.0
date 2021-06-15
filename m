Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9CB3A7E1A
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 14:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhFOMX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 08:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhFOMXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 08:23:25 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4ED2C061574;
        Tue, 15 Jun 2021 05:21:20 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id m137so18006579oig.6;
        Tue, 15 Jun 2021 05:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hzZxd2nn6fBPdLTgIg79BhOLZB+W6bqdrusiXTazCDo=;
        b=ef2Ff3K8Gyb4OQO1tX7bmyYzrgTQ7vKGnHF5k5N+KW9cDLSwOSDOk2DqZUJioP0NZw
         xfnla+rkAg6coKGhOnwd3UuR01J8ATY4quuU4y3GVAsUWg6V9ch4qrhQkNxzjj7s86Ly
         WdPzAI46/HyCklgmeJaI2RO0xWdHPIkfSckZOpSxm8A73A5UFQICLvgthV+b6F9WXNe7
         r+f8t/tVuJscZ6+DjKwyo+eLP1ntf76/xCa37OtGQaSXJp40Z64v5opEB6OmP5GDjINq
         MPIG+jZuDtFNzvLtEUT2TC2fvQq0tryJYWp5bimnhR9DcbrWVyLYaB0C2pzPzlG3KOoi
         zyCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hzZxd2nn6fBPdLTgIg79BhOLZB+W6bqdrusiXTazCDo=;
        b=k5/ORU++utxkVxzzddbp/c1BUDijIB0G1t/9AX8A0FjnlSpTMQjHP5D8gqubM/zzPL
         Wer8HBvYi98Z9Ufb6/ezOrjj8os1gRjvxQ2F1bjvVN3cuV9+Rm6Vx/GSbkXiDeu7E+4T
         IUnP9E/eA5hdu5RrJ2EC1ay5z+T/QKHWDZ9Fd3vBzu9qnopMR8uXVOPTD9v8yRdW7iEz
         Vf71vijtTLx8qdbpCCwBkGX+JG8UXupDIlpvZciEJbF44d+A15MeKtOv5/cAR/kY+hV6
         74UTnhzxa4MLRc1Jk9BpuTEYsEimwyRuQJQx4uLjtOiiRfc79Qe+E4zZ6Q1emuisjfA/
         D1Xw==
X-Gm-Message-State: AOAM533xw2ml3JhjgWG4f5I0yWuqU8l4ALbmTkucbMXpD3H5ewUQ8pok
        eP9GU807WPg1kQjPlkD812+tz8akplQHbQ7TpOCweNrAOQ==
X-Google-Smtp-Source: ABdhPJw4wL6K5x8A1Buxjqc3v1FPKG59w9YZ5j/vZcHZMZRi9y3lGNa3dwLbUIwu7YPoj8S3bTteY57WYFi1plOMK54=
X-Received: by 2002:a05:6808:610:: with SMTP id y16mr14165219oih.96.1623759680192;
 Tue, 15 Jun 2021 05:21:20 -0700 (PDT)
MIME-Version: 1.0
References: <1623498978-30759-1-git-send-email-zheyuma97@gmail.com> <7ca72971-e072-2489-99cc-3b25e111d333@pensando.io>
In-Reply-To: <7ca72971-e072-2489-99cc-3b25e111d333@pensando.io>
From:   Zheyu Ma <zheyuma97@gmail.com>
Date:   Tue, 15 Jun 2021 20:21:08 +0800
Message-ID: <CAMhUBjnmeS5G4CNFhsV7EVFSfLspNNotd5qP-g8o8OsBx7xd5A@mail.gmail.com>
Subject: Re: [PATCH] net: 3com: 3c59x: add a check against null pointer dereference
To:     Shannon Nelson <snelson@pensando.io>
Cc:     klassert@kernel.org, David Miller <davem@davemloft.net>,
        kuba@kernel.org, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 12:48 AM Shannon Nelson <snelson@pensando.io> wrote:
>
> On 6/12/21 4:56 AM, Zheyu Ma wrote:
> > When the driver is processing the interrupt, it will read the value of
> > the register to determine the status of the device. If the device is in
> > an incorrect state, the driver may mistakenly enter this branch. At this
> > time, the dma buffer has not been allocated, which will result in a null
> > pointer dereference.
> >
> > Fix this by checking whether the buffer is allocated.
> >
> > This log reveals it:
> >
> > BUG: kernel NULL pointer dereference, address: 0000000000000070
> > PGD 0 P4D 0
> > Oops: 0000 [#1] PREEMPT SMP PTI
> > CPU: 5 PID: 0 Comm: swapper/5 Not tainted 5.12.4-g70e7f0549188-dirty #88
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> > RIP: 0010:_vortex_interrupt+0x323/0x670
> > Code: 84 d4 00 00 00 e8 bd e9 60 fe 48 8b 45 d8 48 83 c0 0c 48 89 c6 bf 00 10 00 00 e8 98 d0 f0 fe 48 8b 45 d0 48 8b 80 d8 01 00 00 <8b> 40 70 83 c0 03 89 c0 83 e0 fc 48 89 c2 48 8b 45 d0 48 8b b0 e0
> > RSP: 0018:ffffc900001a4dd0 EFLAGS: 00010046
> > RAX: 0000000000000000 RBX: ffff888115da0580 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: ffffffff81bf710e RDI: 0000000000001000
> > RBP: ffffc900001a4e30 R08: ffff8881008edbc0 R09: 00000000fffffffe
> > R10: 0000000000000001 R11: 00000000a5c81234 R12: ffff8881049530a8
> > R13: 0000000000000000 R14: ffffffff87313288 R15: ffff888108c92000
> > FS:  0000000000000000(0000) GS:ffff88817b200000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000070 CR3: 00000001198c2000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >   <IRQ>
> >   ? _raw_spin_lock_irqsave+0x81/0xa0
> >   vortex_boomerang_interrupt+0x56/0xc10
> >   ? __this_cpu_preempt_check+0x1c/0x20
> >   __handle_irq_event_percpu+0x58/0x3e0
> >   handle_irq_event_percpu+0x3a/0x90
> >   handle_irq_event+0x3e/0x60
> >   handle_fasteoi_irq+0xc7/0x1d0
> >   __common_interrupt+0x84/0x150
> >   common_interrupt+0xb4/0xd0
> >   </IRQ>
> >   asm_common_interrupt+0x1e/0x40
> > RIP: 0010:native_safe_halt+0x17/0x20
> > Code: 07 0f 00 2d 3b 3e 4b 00 f4 5d c3 0f 1f 84 00 00 00 00 00 8b 05 42 a9 72 02 55 48 89 e5 85 c0 7e 07 0f 00 2d 1b 3e 4b 00 fb f4 <5d> c3 cc cc cc cc cc cc cc 0f 1f 44 00 00 55 48 89 e5 e8 92 4a ff
> > RSP: 0018:ffffc900000afe90 EFLAGS: 00000246
> > RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: ffffffff8666cafb RDI: ffffffff865058de
> > RBP: ffffc900000afe90 R08: 0000000000000001 R09: 0000000000000001
> > R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff87313288
> > R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881008ed1c0
> >   default_idle+0xe/0x20
> >   arch_cpu_idle+0xf/0x20
> >   default_idle_call+0x73/0x250
> >   do_idle+0x1f5/0x2d0
> >   cpu_startup_entry+0x1d/0x20
> >   start_secondary+0x11f/0x160
> >   secondary_startup_64_no_verify+0xb0/0xbb
> > Modules linked in:
> > Dumping ftrace buffer:
> >     (ftrace buffer empty)
> > CR2: 0000000000000070
> > ---[ end trace 0735407a540147e1 ]---
> > RIP: 0010:_vortex_interrupt+0x323/0x670
> > Code: 84 d4 00 00 00 e8 bd e9 60 fe 48 8b 45 d8 48 83 c0 0c 48 89 c6 bf 00 10 00 00 e8 98 d0 f0 fe 48 8b 45 d0 48 8b 80 d8 01 00 00 <8b> 40 70 83 c0 03 89 c0 83 e0 fc 48 89 c2 48 8b 45 d0 48 8b b0 e0
> > RSP: 0018:ffffc900001a4dd0 EFLAGS: 00010046
> > RAX: 0000000000000000 RBX: ffff888115da0580 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: ffffffff81bf710e RDI: 0000000000001000
> > RBP: ffffc900001a4e30 R08: ffff8881008edbc0 R09: 00000000fffffffe
> > R10: 0000000000000001 R11: 00000000a5c81234 R12: ffff8881049530a8
> > R13: 0000000000000000 R14: ffffffff87313288 R15: ffff888108c92000
> > FS:  0000000000000000(0000) GS:ffff88817b200000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000070 CR3: 00000001198c2000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Kernel panic - not syncing: Fatal exception in interrupt
> > Dumping ftrace buffer:
> >     (ftrace buffer empty)
> > Kernel Offset: disabled
> > Rebooting in 1 seconds..
> >
> > Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
> > ---
> >   drivers/net/ethernet/3com/3c59x.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
> > index 741c67e546d4..e27901ded7a0 100644
> > --- a/drivers/net/ethernet/3com/3c59x.c
> > +++ b/drivers/net/ethernet/3com/3c59x.c
> > @@ -2300,7 +2300,7 @@ _vortex_interrupt(int irq, struct net_device *dev)
> >               }
> >
> >               if (status & DMADone) {
> > -                     if (ioread16(ioaddr + Wn7_MasterStatus) & 0x1000) {
> > +                     if ((ioread16(ioaddr + Wn7_MasterStatus) & 0x1000) && vp->tx_skb_dma) {
> >                               iowrite16(0x1000, ioaddr + Wn7_MasterStatus); /* Ack the event. */
> >                               dma_unmap_single(vp->gendev, vp->tx_skb_dma, (vp->tx_skb->len + 3) & ~3, DMA_TO_DEVICE);
> >                               pkts_compl++;
>
> This means you won't be ack'ing the event - is this unacknowledged event
> going to cause an issue later?
>

First, I'm not an expert in networking, but from my perspective, I
don't think this will cause a problem. Because when the driver enters
this branch, It means that it thinks that the hardware has already
performed a DMA operation, and the driver only needs to do some
follow-up work, but this is not the case. At this time,
'vp->tx_skb_dma' is still a null pointer, so there is no need for
follow-up work at this time, it is meaningless, and it is appropriate
not to perform any operations at this time.

> If the error is because the buffer doesn't exist, then can you simply
> put the buffer check on the dma_unmap_single() and allow the rest of the
> handling to happen?

The error is not only because the buffer is empty. In fact,
'vp->tx_skb' is also empty at this time, because these two buffers are
allocated in the 'vortex_start_xmit' function at the same time, so
only check in 'dma_unmap_single' is not enough.

Thanks,
Zheyu Ma
