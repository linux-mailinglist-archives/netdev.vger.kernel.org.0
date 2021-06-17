Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899EA3AAD94
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 09:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFQHcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 03:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhFQHco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 03:32:44 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCBDC06175F
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 00:30:36 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id o21so2457037pll.6
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 00:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=mvyhzqW+Hc4oQ0f08FKYwzVyWbIXfaK4t1+vDnDUCOk=;
        b=GibhX/x+uM2x3TzhevHXGbBTDdeLjjn6DxRjNdeKR4bxTIYM10IR2gCJE91uPnC5ho
         U0IVstLq3SLXPjJH5jolwHXzGCAeyTSKBRGWRetCZ7np0Qhn5Q1mf1RgvuYgVuSb8YPn
         Oma/eEIyrKwHwN90oFC4TtkyptSQHZvBfCA8u/qb0DzOT3eaR37d/F/EyzcJSTg+kSBH
         k/TnB/2tRdt0CqBmKdfFV9XlgldHYSa9uJmlXLEn3BcuBkhzJQooFpTCQu8L8nMulbma
         bvptnko4YI4PtmNj4JUKEb/RhyKepw0tCM91QM6NPIzNYubuwj9AhPDBAJW1ZfOPmJ5z
         ZBFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=mvyhzqW+Hc4oQ0f08FKYwzVyWbIXfaK4t1+vDnDUCOk=;
        b=bgYZAe2sWW+hfvHy3tuaP9jwB9hPyUUelhQAV9ozXTrqhBffsd6Snn0fXDLC+EQRY5
         vrwWScCG7TuzTm9DKQdakqe6xq0ISrrvOgO8aFu0PDgarXxVdrqkeRc6qwLHnG2pWjRr
         WsVy4xCEZ/ki05FKTOk86uK7Wq0cdW5DPkHzW/cRLsZH1QFsazVilo6NKciD0dN9+Q4O
         LGe20B7hwFQiXxmis+BsZNtmx0NkwGInGwkk6f5XJOfaoiptmrntfJKrbrMEGjLEUP3b
         hakrSmY6ieJX1W+mvbUGz//tx3uNSOqhP9EbOtdcGg6Mi4qPX4sBuk7ImUxYFlQRppDf
         iJzg==
X-Gm-Message-State: AOAM5325t4HACNH8lUEEJZtM/9omB1ShbUWgL6JKLx6CZOMoYUCzT3am
        YpTT56lrcynFXeV/E0S6728wqQ==
X-Google-Smtp-Source: ABdhPJwkDCOWBYWMOINPDnKUV4zzf+OjGeMrI3YhRtADr4H4nrZT8adgPi26gK/rHpdQcdsmuMThgg==
X-Received: by 2002:a17:903:2482:b029:fd:696c:1d2b with SMTP id p2-20020a1709032482b02900fd696c1d2bmr3383750plw.24.1623915036012;
        Thu, 17 Jun 2021 00:30:36 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id v7sm4259002pfi.187.2021.06.17.00.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 00:30:35 -0700 (PDT)
Date:   Thu, 17 Jun 2021 00:30:35 -0700 (PDT)
X-Google-Original-Date: Thu, 17 Jun 2021 00:30:33 PDT (-0700)
Subject:     Re: [PATCH] riscv: Ensure BPF_JIT_REGION_START aligned with PMD size
In-Reply-To: <20210616080328.6548e762@xhacker>
CC:     alex@ghiti.fr, schwab@linux-m68k.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, ryabinin.a.a@gmail.com, glider@google.com,
        andreyknvl@gmail.com, dvyukov@google.com, bjorn@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        luke.r.nels@gmail.com, xi.wang@gmail.com,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     jszhang3@mail.ustc.edu.cn
Message-ID: <mhng-042979fe-75f0-4873-8afd-f8c07942f792@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Jun 2021 17:03:28 PDT (-0700), jszhang3@mail.ustc.edu.cn wrote:
> On Tue, 15 Jun 2021 20:54:19 +0200
> Alex Ghiti <alex@ghiti.fr> wrote:
>
>> Hi Jisheng,
>
> Hi Alex,
>
>> 
>> Le 14/06/2021 à 18:49, Jisheng Zhang a écrit :
>> > From: Jisheng Zhang <jszhang@kernel.org>
>> > 
>> > Andreas reported commit fc8504765ec5 ("riscv: bpf: Avoid breaking W^X")
>> > breaks booting with one kind of config file, I reproduced a kernel panic
>> > with the config:
>> > 
>> > [    0.138553] Unable to handle kernel paging request at virtual address ffffffff81201220
>> > [    0.139159] Oops [#1]
>> > [    0.139303] Modules linked in:
>> > [    0.139601] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-rc5-default+ #1
>> > [    0.139934] Hardware name: riscv-virtio,qemu (DT)
>> > [    0.140193] epc : __memset+0xc4/0xfc
>> > [    0.140416]  ra : skb_flow_dissector_init+0x1e/0x82
>> > [    0.140609] epc : ffffffff8029806c ra : ffffffff8033be78 sp : ffffffe001647da0
>> > [    0.140878]  gp : ffffffff81134b08 tp : ffffffe001654380 t0 : ffffffff81201158
>> > [    0.141156]  t1 : 0000000000000002 t2 : 0000000000000154 s0 : ffffffe001647dd0
>> > [    0.141424]  s1 : ffffffff80a43250 a0 : ffffffff81201220 a1 : 0000000000000000
>> > [    0.141654]  a2 : 000000000000003c a3 : ffffffff81201258 a4 : 0000000000000064
>> > [    0.141893]  a5 : ffffffff8029806c a6 : 0000000000000040 a7 : ffffffffffffffff
>> > [    0.142126]  s2 : ffffffff81201220 s3 : 0000000000000009 s4 : ffffffff81135088
>> > [    0.142353]  s5 : ffffffff81135038 s6 : ffffffff8080ce80 s7 : ffffffff80800438
>> > [    0.142584]  s8 : ffffffff80bc6578 s9 : 0000000000000008 s10: ffffffff806000ac
>> > [    0.142810]  s11: 0000000000000000 t3 : fffffffffffffffc t4 : 0000000000000000
>> > [    0.143042]  t5 : 0000000000000155 t6 : 00000000000003ff
>> > [    0.143220] status: 0000000000000120 badaddr: ffffffff81201220 cause: 000000000000000f
>> > [    0.143560] [<ffffffff8029806c>] __memset+0xc4/0xfc
>> > [    0.143859] [<ffffffff8061e984>] init_default_flow_dissectors+0x22/0x60
>> > [    0.144092] [<ffffffff800010fc>] do_one_initcall+0x3e/0x168
>> > [    0.144278] [<ffffffff80600df0>] kernel_init_freeable+0x1c8/0x224
>> > [    0.144479] [<ffffffff804868a8>] kernel_init+0x12/0x110
>> > [    0.144658] [<ffffffff800022de>] ret_from_exception+0x0/0xc
>> > [    0.145124] ---[ end trace f1e9643daa46d591 ]---
>> > 
>> > After some investigation, I think I found the root cause: commit
>> > 2bfc6cd81bd ("move kernel mapping outside of linear mapping") moves
>> > BPF JIT region after the kernel:
>> > 
>> > The &_end is unlikely aligned with PMD size, so the front bpf jit
>> > region sits with part of kernel .data section in one PMD size mapping.
>> > But kernel is mapped in PMD SIZE, when bpf_jit_binary_lock_ro() is
>> > called to make the first bpf jit prog ROX, we will make part of kernel
>> > .data section RO too, so when we write to, for example memset the
>> > .data section, MMU will trigger a store page fault.  
>> 
>> Good catch, we make sure no physical allocation happens between _end and 
>> the next PMD aligned address, but I missed this one.
>> 
>> > 
>> > To fix the issue, we need to ensure the BPF JIT region is PMD size
>> > aligned. This patch acchieve this goal by restoring the BPF JIT region
>> > to original position, I.E the 128MB before kernel .text section.  
>> 
>> But I disagree with your solution: I made sure modules and BPF programs 
>> get their own virtual regions to avoid worst case scenario where one 
>> could allocate all the space and leave nothing to the other (we are 
>> limited to +- 2GB offset). Why don't just align BPF_JIT_REGION_START to 
>> the next PMD aligned address?
>
> Originally, I planed to fix the issue by aligning BPF_JIT_REGION_START, but
> IIRC, BPF experts are adding (or have added) "Calling kernel functions from BPF"
> feature, there's a risk that BPF JIT region is beyond the 2GB of module region:
>
> ------
> module
> ------
> kernel
> ------
> BPF_JIT
>
> So I made this patch finally. In this patch, we let BPF JIT region sit
> between module and kernel.
>
> To address "make sure modules and BPF programs get their own virtual regions",
> what about something as below (applied against this patch)?
>
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 380cd3a7e548..da1158f10b09 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -31,7 +31,7 @@
>  #define BPF_JIT_REGION_SIZE	(SZ_128M)
>  #ifdef CONFIG_64BIT
>  #define BPF_JIT_REGION_START	(BPF_JIT_REGION_END - BPF_JIT_REGION_SIZE)
> -#define BPF_JIT_REGION_END	(MODULES_END)
> +#define BPF_JIT_REGION_END	(PFN_ALIGN((unsigned long)&_start))
>  #else
>  #define BPF_JIT_REGION_START	(PAGE_OFFSET - BPF_JIT_REGION_SIZE)
>  #define BPF_JIT_REGION_END	(VMALLOC_END)
> @@ -40,7 +40,7 @@
>  /* Modules always live before the kernel */
>  #ifdef CONFIG_64BIT
>  #define MODULES_VADDR	(PFN_ALIGN((unsigned long)&_end) - SZ_2G)
> -#define MODULES_END	(PFN_ALIGN((unsigned long)&_start))
> +#define MODULES_END	(BPF_JIT_REGION_END)
>  #endif
>  
>
>
>> 
>> Again, good catch, thanks,
>> 
>> Alex
>> 
>> > 
>> > Reported-by: Andreas Schwab <schwab@linux-m68k.org>
>> > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
>> > ---
>> >   arch/riscv/include/asm/pgtable.h | 5 ++---
>> >   1 file changed, 2 insertions(+), 3 deletions(-)
>> > 
>> > diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
>> > index 9469f464e71a..380cd3a7e548 100644
>> > --- a/arch/riscv/include/asm/pgtable.h
>> > +++ b/arch/riscv/include/asm/pgtable.h
>> > @@ -30,9 +30,8 @@
>> >   
>> >   #define BPF_JIT_REGION_SIZE	(SZ_128M)
>> >   #ifdef CONFIG_64BIT
>> > -/* KASLR should leave at least 128MB for BPF after the kernel */
>> > -#define BPF_JIT_REGION_START	PFN_ALIGN((unsigned long)&_end)
>> > -#define BPF_JIT_REGION_END	(BPF_JIT_REGION_START + BPF_JIT_REGION_SIZE)
>> > +#define BPF_JIT_REGION_START	(BPF_JIT_REGION_END - BPF_JIT_REGION_SIZE)
>> > +#define BPF_JIT_REGION_END	(MODULES_END)
>> >   #else
>> >   #define BPF_JIT_REGION_START	(PAGE_OFFSET - BPF_JIT_REGION_SIZE)
>> >   #define BPF_JIT_REGION_END	(VMALLOC_END)
>> >   

This, when applied onto fixes, is breaking early boot on KASAN 
configurations for me.
