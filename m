Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A8F3A6C5E
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 18:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbhFNQuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 12:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbhFNQuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 12:50:32 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D135C061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 09:48:29 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id u18so6261836plc.0
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 09:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=CHwO9C6JyrMqrBYpoGco7BPKrb1HtpJuL/+NY4NbA7k=;
        b=aKT04cfSzraWIpTd46uJ1NpyhanzK9S9WobHu5i+zKgD6J4EKw+RRn8m4sDEpDUchK
         BJCzA1Wims8hUD9I9NNFVCeiSjm2iiC1GPgS9vUA56sjDOnoKuWw+J3/TErZkQD3HkxP
         1GBDqNTMhbMIKymgZuamjyvO5YZqX5YZx0kN7N7E13iYcp/tYG72hDEisqNIB3L3fjvW
         oC+MqcluYZ0mcynWV3Ba4n5ZWr2FRzdQTRIeOZ4D3jzmWsy/izjFvtG31SMrJ37/GGGN
         V54Q39nsxOBad+ZFGYAtQUwVlciGtWmBNXygS69Wq99RRkIHpCRY3jHGwIM/ccre/rdP
         9C2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=CHwO9C6JyrMqrBYpoGco7BPKrb1HtpJuL/+NY4NbA7k=;
        b=di9PItZ+n5B/dYJJuDos8Grbu4tABhZZ+/auHq4WyRQoru2xmmSn8zH+ftbIESF07R
         BgQ0F36pVc2MaPsb+OoCYTD0Q/P5F43b/dS99Ga7z3qdKmukAoU9uV/nwpYaVWK9GM8K
         quEvHgovWtXxHpJsh+c0XfnBCVWO1ClZTzl8AI7sleE074a771vIXy+acIKYQBmr46vw
         1l7UZFE6542nzlYd6RLHBXh2ld5k3jcqvBJR6FQcIEDYQZXEnKNvpgseVnzf7MO1hr6j
         2xVCzQkTOgrzvNzuevwFF7VBUWr3+bvT0tbGAP5Hj7oATnd4yRq1HvWyu2u3r3Pz5MLc
         ZbGQ==
X-Gm-Message-State: AOAM532NquSBZ0h+Z2p2AmkJZiZDfL2F01KBZvc4WBgfFSbIs5kpzsTq
        ocp3zTDySyC1Y5RRywKaZuIwRA==
X-Google-Smtp-Source: ABdhPJyEIqHTN7+76IwYyPiWvvNUFbx+DYmGovpqBZKFIzpHWQ6wXtdjYQpMpx+ni+G0UKrPsL6JEA==
X-Received: by 2002:a17:90b:1d02:: with SMTP id on2mr17801120pjb.192.1623689308747;
        Mon, 14 Jun 2021 09:48:28 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id l201sm13133599pfd.183.2021.06.14.09.48.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 09:48:27 -0700 (PDT)
Subject: Re: [PATCH] net: 3com: 3c59x: add a check against null pointer
 dereference
To:     Zheyu Ma <zheyuma97@gmail.com>, klassert@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1623498978-30759-1-git-send-email-zheyuma97@gmail.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <7ca72971-e072-2489-99cc-3b25e111d333@pensando.io>
Date:   Mon, 14 Jun 2021 09:48:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1623498978-30759-1-git-send-email-zheyuma97@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/12/21 4:56 AM, Zheyu Ma wrote:
> When the driver is processing the interrupt, it will read the value of
> the register to determine the status of the device. If the device is in
> an incorrect state, the driver may mistakenly enter this branch. At this
> time, the dma buffer has not been allocated, which will result in a null
> pointer dereference.
>
> Fix this by checking whether the buffer is allocated.
>
> This log reveals it:
>
> BUG: kernel NULL pointer dereference, address: 0000000000000070
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP PTI
> CPU: 5 PID: 0 Comm: swapper/5 Not tainted 5.12.4-g70e7f0549188-dirty #88
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> RIP: 0010:_vortex_interrupt+0x323/0x670
> Code: 84 d4 00 00 00 e8 bd e9 60 fe 48 8b 45 d8 48 83 c0 0c 48 89 c6 bf 00 10 00 00 e8 98 d0 f0 fe 48 8b 45 d0 48 8b 80 d8 01 00 00 <8b> 40 70 83 c0 03 89 c0 83 e0 fc 48 89 c2 48 8b 45 d0 48 8b b0 e0
> RSP: 0018:ffffc900001a4dd0 EFLAGS: 00010046
> RAX: 0000000000000000 RBX: ffff888115da0580 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff81bf710e RDI: 0000000000001000
> RBP: ffffc900001a4e30 R08: ffff8881008edbc0 R09: 00000000fffffffe
> R10: 0000000000000001 R11: 00000000a5c81234 R12: ffff8881049530a8
> R13: 0000000000000000 R14: ffffffff87313288 R15: ffff888108c92000
> FS:  0000000000000000(0000) GS:ffff88817b200000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000070 CR3: 00000001198c2000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <IRQ>
>   ? _raw_spin_lock_irqsave+0x81/0xa0
>   vortex_boomerang_interrupt+0x56/0xc10
>   ? __this_cpu_preempt_check+0x1c/0x20
>   __handle_irq_event_percpu+0x58/0x3e0
>   handle_irq_event_percpu+0x3a/0x90
>   handle_irq_event+0x3e/0x60
>   handle_fasteoi_irq+0xc7/0x1d0
>   __common_interrupt+0x84/0x150
>   common_interrupt+0xb4/0xd0
>   </IRQ>
>   asm_common_interrupt+0x1e/0x40
> RIP: 0010:native_safe_halt+0x17/0x20
> Code: 07 0f 00 2d 3b 3e 4b 00 f4 5d c3 0f 1f 84 00 00 00 00 00 8b 05 42 a9 72 02 55 48 89 e5 85 c0 7e 07 0f 00 2d 1b 3e 4b 00 fb f4 <5d> c3 cc cc cc cc cc cc cc 0f 1f 44 00 00 55 48 89 e5 e8 92 4a ff
> RSP: 0018:ffffc900000afe90 EFLAGS: 00000246
> RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff8666cafb RDI: ffffffff865058de
> RBP: ffffc900000afe90 R08: 0000000000000001 R09: 0000000000000001
> R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff87313288
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881008ed1c0
>   default_idle+0xe/0x20
>   arch_cpu_idle+0xf/0x20
>   default_idle_call+0x73/0x250
>   do_idle+0x1f5/0x2d0
>   cpu_startup_entry+0x1d/0x20
>   start_secondary+0x11f/0x160
>   secondary_startup_64_no_verify+0xb0/0xbb
> Modules linked in:
> Dumping ftrace buffer:
>     (ftrace buffer empty)
> CR2: 0000000000000070
> ---[ end trace 0735407a540147e1 ]---
> RIP: 0010:_vortex_interrupt+0x323/0x670
> Code: 84 d4 00 00 00 e8 bd e9 60 fe 48 8b 45 d8 48 83 c0 0c 48 89 c6 bf 00 10 00 00 e8 98 d0 f0 fe 48 8b 45 d0 48 8b 80 d8 01 00 00 <8b> 40 70 83 c0 03 89 c0 83 e0 fc 48 89 c2 48 8b 45 d0 48 8b b0 e0
> RSP: 0018:ffffc900001a4dd0 EFLAGS: 00010046
> RAX: 0000000000000000 RBX: ffff888115da0580 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff81bf710e RDI: 0000000000001000
> RBP: ffffc900001a4e30 R08: ffff8881008edbc0 R09: 00000000fffffffe
> R10: 0000000000000001 R11: 00000000a5c81234 R12: ffff8881049530a8
> R13: 0000000000000000 R14: ffffffff87313288 R15: ffff888108c92000
> FS:  0000000000000000(0000) GS:ffff88817b200000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000070 CR3: 00000001198c2000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Kernel panic - not syncing: Fatal exception in interrupt
> Dumping ftrace buffer:
>     (ftrace buffer empty)
> Kernel Offset: disabled
> Rebooting in 1 seconds..
>
> Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
> ---
>   drivers/net/ethernet/3com/3c59x.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
> index 741c67e546d4..e27901ded7a0 100644
> --- a/drivers/net/ethernet/3com/3c59x.c
> +++ b/drivers/net/ethernet/3com/3c59x.c
> @@ -2300,7 +2300,7 @@ _vortex_interrupt(int irq, struct net_device *dev)
>   		}
>   
>   		if (status & DMADone) {
> -			if (ioread16(ioaddr + Wn7_MasterStatus) & 0x1000) {
> +			if ((ioread16(ioaddr + Wn7_MasterStatus) & 0x1000) && vp->tx_skb_dma) {
>   				iowrite16(0x1000, ioaddr + Wn7_MasterStatus); /* Ack the event. */
>   				dma_unmap_single(vp->gendev, vp->tx_skb_dma, (vp->tx_skb->len + 3) & ~3, DMA_TO_DEVICE);
>   				pkts_compl++;

This means you won't be ack'ing the event - is this unacknowledged event 
going to cause an issue later?

If the error is because the buffer doesn't exist, then can you simply 
put the buffer check on the dma_unmap_single() and allow the rest of the 
handling to happen?

sln

