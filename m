Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E5A3ABA97
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 19:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhFQR0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbhFQR0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 13:26:12 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF2D8C061574;
        Thu, 17 Jun 2021 10:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
        Content-Transfer-Encoding; bh=zuggjvpts9K1MPrpdIvHo11IpZU+3fBBgN
        vj3uKB8go=; b=LC9c56KAMRzyY6jF6tJrrnm2AP/BU+w6jaBqnDueL7/gLpcyX9
        YOyOIZE7seDq9O7BfrTIWe5yLV/wxWf2dMQn1BnztGRz3go7kojU4um1t2OedugQ
        DAgzKaVCn3kszuOIhJH1e19K83fKJbTuDFASqheNLE5Xc9rJN40uvcPh0=
Received: from xhacker (unknown [101.86.20.15])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygBn1JTphMtgHwD3AA--.17025S2;
        Fri, 18 Jun 2021 01:22:50 +0800 (CST)
Date:   Fri, 18 Jun 2021 01:17:12 +0800
From:   Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
To:     Alex Ghiti <alex@ghiti.fr>
Cc:     Andreas Schwab <schwab@linux-m68k.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] riscv: Ensure BPF_JIT_REGION_START aligned with PMD
 size
Message-ID: <20210618011712.2bbacb27@xhacker>
In-Reply-To: <4cdb1261-6474-8ae6-7a92-a3be81ce8cb5@ghiti.fr>
References: <20210330022144.150edc6e@xhacker>
        <20210330022521.2a904a8c@xhacker>
        <87o8ccqypw.fsf@igel.home>
        <20210612002334.6af72545@xhacker>
        <87bl8cqrpv.fsf@igel.home>
        <20210614010546.7a0d5584@xhacker>
        <87im2hsfvm.fsf@igel.home>
        <20210615004928.2d27d2ac@xhacker>
        <ab536c78-ba1c-c65c-325a-8f9fba6e9d46@ghiti.fr>
        <20210616080328.6548e762@xhacker>
        <4cdb1261-6474-8ae6-7a92-a3be81ce8cb5@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-CM-TRANSID: LkAmygBn1JTphMtgHwD3AA--.17025S2
X-Coremail-Antispam: 1UD129KBjvJXoWxtFW7Wr4xXrWkKFW3XFy3XFb_yoW7tFy8pF
        15JF43KrW8Jr1UAryIv34Yvr1Utw1UAa47WrnrJr95AF15Kr1UZr10qrW7ur1qqry8C3Wx
        Krs0yrs2yFWUCaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkGb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwV
        C2z280aVCY1x0267AKxVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
        Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJV
        W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkI
        wI1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07b5sjbUUU
        UU=
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Jun 2021 09:23:04 +0200
Alex Ghiti <alex@ghiti.fr> wrote:

> Le 16/06/2021 =C3=A0 02:03, Jisheng Zhang a =C3=A9crit=C2=A0:
> > On Tue, 15 Jun 2021 20:54:19 +0200
> > Alex Ghiti <alex@ghiti.fr> wrote:
> >  =20
> >> Hi Jisheng, =20
> >=20
> > Hi Alex,
> >  =20
> >>
> >> Le 14/06/2021 =C3=A0 18:49, Jisheng Zhang a =C3=A9crit=C2=A0: =20
> >>> From: Jisheng Zhang <jszhang@kernel.org>
> >>>
> >>> Andreas reported commit fc8504765ec5 ("riscv: bpf: Avoid breaking W^X=
")
> >>> breaks booting with one kind of config file, I reproduced a kernel pa=
nic
> >>> with the config:
> >>>
> >>> [    0.138553] Unable to handle kernel paging request at virtual addr=
ess ffffffff81201220
> >>> [    0.139159] Oops [#1]
> >>> [    0.139303] Modules linked in:
> >>> [    0.139601] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-rc5-d=
efault+ #1
> >>> [    0.139934] Hardware name: riscv-virtio,qemu (DT)
> >>> [    0.140193] epc : __memset+0xc4/0xfc
> >>> [    0.140416]  ra : skb_flow_dissector_init+0x1e/0x82
> >>> [    0.140609] epc : ffffffff8029806c ra : ffffffff8033be78 sp : ffff=
ffe001647da0
> >>> [    0.140878]  gp : ffffffff81134b08 tp : ffffffe001654380 t0 : ffff=
ffff81201158
> >>> [    0.141156]  t1 : 0000000000000002 t2 : 0000000000000154 s0 : ffff=
ffe001647dd0
> >>> [    0.141424]  s1 : ffffffff80a43250 a0 : ffffffff81201220 a1 : 0000=
000000000000
> >>> [    0.141654]  a2 : 000000000000003c a3 : ffffffff81201258 a4 : 0000=
000000000064
> >>> [    0.141893]  a5 : ffffffff8029806c a6 : 0000000000000040 a7 : ffff=
ffffffffffff
> >>> [    0.142126]  s2 : ffffffff81201220 s3 : 0000000000000009 s4 : ffff=
ffff81135088
> >>> [    0.142353]  s5 : ffffffff81135038 s6 : ffffffff8080ce80 s7 : ffff=
ffff80800438
> >>> [    0.142584]  s8 : ffffffff80bc6578 s9 : 0000000000000008 s10: ffff=
ffff806000ac
> >>> [    0.142810]  s11: 0000000000000000 t3 : fffffffffffffffc t4 : 0000=
000000000000
> >>> [    0.143042]  t5 : 0000000000000155 t6 : 00000000000003ff
> >>> [    0.143220] status: 0000000000000120 badaddr: ffffffff81201220 cau=
se: 000000000000000f
> >>> [    0.143560] [<ffffffff8029806c>] __memset+0xc4/0xfc
> >>> [    0.143859] [<ffffffff8061e984>] init_default_flow_dissectors+0x22=
/0x60
> >>> [    0.144092] [<ffffffff800010fc>] do_one_initcall+0x3e/0x168
> >>> [    0.144278] [<ffffffff80600df0>] kernel_init_freeable+0x1c8/0x224
> >>> [    0.144479] [<ffffffff804868a8>] kernel_init+0x12/0x110
> >>> [    0.144658] [<ffffffff800022de>] ret_from_exception+0x0/0xc
> >>> [    0.145124] ---[ end trace f1e9643daa46d591 ]---
> >>>
> >>> After some investigation, I think I found the root cause: commit
> >>> 2bfc6cd81bd ("move kernel mapping outside of linear mapping") moves
> >>> BPF JIT region after the kernel:
> >>>
> >>> The &_end is unlikely aligned with PMD size, so the front bpf jit
> >>> region sits with part of kernel .data section in one PMD size mapping.
> >>> But kernel is mapped in PMD SIZE, when bpf_jit_binary_lock_ro() is
> >>> called to make the first bpf jit prog ROX, we will make part of kernel
> >>> .data section RO too, so when we write to, for example memset the
> >>> .data section, MMU will trigger a store page fault. =20
> >>
> >> Good catch, we make sure no physical allocation happens between _end a=
nd
> >> the next PMD aligned address, but I missed this one.
> >> =20
> >>>
> >>> To fix the issue, we need to ensure the BPF JIT region is PMD size
> >>> aligned. This patch acchieve this goal by restoring the BPF JIT region
> >>> to original position, I.E the 128MB before kernel .text section. =20
> >>
> >> But I disagree with your solution: I made sure modules and BPF programs
> >> get their own virtual regions to avoid worst case scenario where one
> >> could allocate all the space and leave nothing to the other (we are
> >> limited to +- 2GB offset). Why don't just align BPF_JIT_REGION_START to
> >> the next PMD aligned address? =20
> >=20
> > Originally, I planed to fix the issue by aligning BPF_JIT_REGION_START,=
 but
> > IIRC, BPF experts are adding (or have added) "Calling kernel functions =
from BPF"
> > feature, there's a risk that BPF JIT region is beyond the 2GB of module=
 region:
> >=20
> > ------
> > module
> > ------
> > kernel
> > ------
> > BPF_JIT
> >=20
> > So I made this patch finally. In this patch, we let BPF JIT region sit
> > between module and kernel.
> >  =20
>=20
>  From what I read in the lwn article, I'm not sure BPF programs can call=
=20
> module functions, can someone tell us if it is possible? Or planned?

What about module call BPF program? this case also wants the 2GB address li=
mit.

>=20
> > To address "make sure modules and BPF programs get their own virtual re=
gions",
> > what about something as below (applied against this patch)?
> >=20
> > diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/=
pgtable.h
> > index 380cd3a7e548..da1158f10b09 100644
> > --- a/arch/riscv/include/asm/pgtable.h
> > +++ b/arch/riscv/include/asm/pgtable.h
> > @@ -31,7 +31,7 @@
> >   #define BPF_JIT_REGION_SIZE	(SZ_128M)
> >   #ifdef CONFIG_64BIT
> >   #define BPF_JIT_REGION_START	(BPF_JIT_REGION_END - BPF_JIT_REGION_SIZ=
E)
> > -#define BPF_JIT_REGION_END	(MODULES_END)
> > +#define BPF_JIT_REGION_END	(PFN_ALIGN((unsigned long)&_start))
> >   #else
> >   #define BPF_JIT_REGION_START	(PAGE_OFFSET - BPF_JIT_REGION_SIZE)
> >   #define BPF_JIT_REGION_END	(VMALLOC_END)
> > @@ -40,7 +40,7 @@
> >   /* Modules always live before the kernel */
> >   #ifdef CONFIG_64BIT
> >   #define MODULES_VADDR	(PFN_ALIGN((unsigned long)&_end) - SZ_2G)
> > -#define MODULES_END	(PFN_ALIGN((unsigned long)&_start))
> > +#define MODULES_END	(BPF_JIT_REGION_END)
> >   #endif
> >  =20
> >  =20
>=20
> In case it is possible, I would let the vmalloc allocator handle the=20
> case where modules steal room from BPF: I would then not implement the=20
> above but rather your first patch.
>=20
> And do not forget to modify Documentation/riscv/vm-layout.rst=20
> accordingly and remove the comment "/* KASLR should leave at least 128MB=
=20
> for BPF after the kernel */"

Thanks for the comments

