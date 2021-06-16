Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A0C3A8D42
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 02:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbhFPAM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 20:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhFPAM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 20:12:27 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC82AC061574;
        Tue, 15 Jun 2021 17:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
        Content-Transfer-Encoding; bh=xrXSnNViAas93oJJQqhck+SAOKfnt7nUQ7
        BJjV5e790=; b=OuO33ODIaN0YB4D/lIa2vpsVVA4xRuT//ILI9OOmpqT5WMcC8s
        RLr3TPw3Ioi5n7p2l5CazNU+47RqNJsdfcRohTwI5VjRAH2/6krByjQ0FW+G4hMk
        3QoQXazJVKKhax597HJP5qImN/r/hN01uPC4iQ0Di5cdtDoQsrFE/D3Nk=
Received: from xhacker (unknown [101.86.20.15])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygD3+YEhQclgYtzmAA--.64455S2;
        Wed, 16 Jun 2021 08:09:05 +0800 (CST)
Date:   Wed, 16 Jun 2021 08:03:28 +0800
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
Message-ID: <20210616080328.6548e762@xhacker>
In-Reply-To: <ab536c78-ba1c-c65c-325a-8f9fba6e9d46@ghiti.fr>
References: <20210330022144.150edc6e@xhacker>
        <20210330022521.2a904a8c@xhacker>
        <87o8ccqypw.fsf@igel.home>
        <20210612002334.6af72545@xhacker>
        <87bl8cqrpv.fsf@igel.home>
        <20210614010546.7a0d5584@xhacker>
        <87im2hsfvm.fsf@igel.home>
        <20210615004928.2d27d2ac@xhacker>
        <ab536c78-ba1c-c65c-325a-8f9fba6e9d46@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-CM-TRANSID: LkAmygD3+YEhQclgYtzmAA--.64455S2
X-Coremail-Antispam: 1UD129KBjvJXoW3AFyfWF4Dtry5uw15Aw45GFg_yoW7KF4xpF
        15Jr43GrW8Jryxu340vr90vF1UJa1UAa47JrnrJry8ZF13K3WUZw1FqF13Zr1qqFWxt3Wx
        Kr4qvr4vg3y5CaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkGb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xII
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

On Tue, 15 Jun 2021 20:54:19 +0200
Alex Ghiti <alex@ghiti.fr> wrote:

> Hi Jisheng,

Hi Alex,

>=20
> Le 14/06/2021 =C3=A0 18:49, Jisheng Zhang a =C3=A9crit=C2=A0:
> > From: Jisheng Zhang <jszhang@kernel.org>
> >=20
> > Andreas reported commit fc8504765ec5 ("riscv: bpf: Avoid breaking W^X")
> > breaks booting with one kind of config file, I reproduced a kernel panic
> > with the config:
> >=20
> > [    0.138553] Unable to handle kernel paging request at virtual addres=
s ffffffff81201220
> > [    0.139159] Oops [#1]
> > [    0.139303] Modules linked in:
> > [    0.139601] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-rc5-def=
ault+ #1
> > [    0.139934] Hardware name: riscv-virtio,qemu (DT)
> > [    0.140193] epc : __memset+0xc4/0xfc
> > [    0.140416]  ra : skb_flow_dissector_init+0x1e/0x82
> > [    0.140609] epc : ffffffff8029806c ra : ffffffff8033be78 sp : ffffff=
e001647da0
> > [    0.140878]  gp : ffffffff81134b08 tp : ffffffe001654380 t0 : ffffff=
ff81201158
> > [    0.141156]  t1 : 0000000000000002 t2 : 0000000000000154 s0 : ffffff=
e001647dd0
> > [    0.141424]  s1 : ffffffff80a43250 a0 : ffffffff81201220 a1 : 000000=
0000000000
> > [    0.141654]  a2 : 000000000000003c a3 : ffffffff81201258 a4 : 000000=
0000000064
> > [    0.141893]  a5 : ffffffff8029806c a6 : 0000000000000040 a7 : ffffff=
ffffffffff
> > [    0.142126]  s2 : ffffffff81201220 s3 : 0000000000000009 s4 : ffffff=
ff81135088
> > [    0.142353]  s5 : ffffffff81135038 s6 : ffffffff8080ce80 s7 : ffffff=
ff80800438
> > [    0.142584]  s8 : ffffffff80bc6578 s9 : 0000000000000008 s10: ffffff=
ff806000ac
> > [    0.142810]  s11: 0000000000000000 t3 : fffffffffffffffc t4 : 000000=
0000000000
> > [    0.143042]  t5 : 0000000000000155 t6 : 00000000000003ff
> > [    0.143220] status: 0000000000000120 badaddr: ffffffff81201220 cause=
: 000000000000000f
> > [    0.143560] [<ffffffff8029806c>] __memset+0xc4/0xfc
> > [    0.143859] [<ffffffff8061e984>] init_default_flow_dissectors+0x22/0=
x60
> > [    0.144092] [<ffffffff800010fc>] do_one_initcall+0x3e/0x168
> > [    0.144278] [<ffffffff80600df0>] kernel_init_freeable+0x1c8/0x224
> > [    0.144479] [<ffffffff804868a8>] kernel_init+0x12/0x110
> > [    0.144658] [<ffffffff800022de>] ret_from_exception+0x0/0xc
> > [    0.145124] ---[ end trace f1e9643daa46d591 ]---
> >=20
> > After some investigation, I think I found the root cause: commit
> > 2bfc6cd81bd ("move kernel mapping outside of linear mapping") moves
> > BPF JIT region after the kernel:
> >=20
> > The &_end is unlikely aligned with PMD size, so the front bpf jit
> > region sits with part of kernel .data section in one PMD size mapping.
> > But kernel is mapped in PMD SIZE, when bpf_jit_binary_lock_ro() is
> > called to make the first bpf jit prog ROX, we will make part of kernel
> > .data section RO too, so when we write to, for example memset the
> > .data section, MMU will trigger a store page fault. =20
>=20
> Good catch, we make sure no physical allocation happens between _end and=
=20
> the next PMD aligned address, but I missed this one.
>=20
> >=20
> > To fix the issue, we need to ensure the BPF JIT region is PMD size
> > aligned. This patch acchieve this goal by restoring the BPF JIT region
> > to original position, I.E the 128MB before kernel .text section. =20
>=20
> But I disagree with your solution: I made sure modules and BPF programs=20
> get their own virtual regions to avoid worst case scenario where one=20
> could allocate all the space and leave nothing to the other (we are=20
> limited to +- 2GB offset). Why don't just align BPF_JIT_REGION_START to=20
> the next PMD aligned address?

Originally, I planed to fix the issue by aligning BPF_JIT_REGION_START, but
IIRC, BPF experts are adding (or have added) "Calling kernel functions from=
 BPF"
feature, there's a risk that BPF JIT region is beyond the 2GB of module reg=
ion:

------
module
------
kernel
------
BPF_JIT

So I made this patch finally. In this patch, we let BPF JIT region sit
between module and kernel.

To address "make sure modules and BPF programs get their own virtual region=
s",
what about something as below (applied against this patch)?

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgta=
ble.h
index 380cd3a7e548..da1158f10b09 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -31,7 +31,7 @@
 #define BPF_JIT_REGION_SIZE	(SZ_128M)
 #ifdef CONFIG_64BIT
 #define BPF_JIT_REGION_START	(BPF_JIT_REGION_END - BPF_JIT_REGION_SIZE)
-#define BPF_JIT_REGION_END	(MODULES_END)
+#define BPF_JIT_REGION_END	(PFN_ALIGN((unsigned long)&_start))
 #else
 #define BPF_JIT_REGION_START	(PAGE_OFFSET - BPF_JIT_REGION_SIZE)
 #define BPF_JIT_REGION_END	(VMALLOC_END)
@@ -40,7 +40,7 @@
 /* Modules always live before the kernel */
 #ifdef CONFIG_64BIT
 #define MODULES_VADDR	(PFN_ALIGN((unsigned long)&_end) - SZ_2G)
-#define MODULES_END	(PFN_ALIGN((unsigned long)&_start))
+#define MODULES_END	(BPF_JIT_REGION_END)
 #endif
=20


>=20
> Again, good catch, thanks,
>=20
> Alex
>=20
> >=20
> > Reported-by: Andreas Schwab <schwab@linux-m68k.org>
> > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > ---
> >   arch/riscv/include/asm/pgtable.h | 5 ++---
> >   1 file changed, 2 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/=
pgtable.h
> > index 9469f464e71a..380cd3a7e548 100644
> > --- a/arch/riscv/include/asm/pgtable.h
> > +++ b/arch/riscv/include/asm/pgtable.h
> > @@ -30,9 +30,8 @@
> >  =20
> >   #define BPF_JIT_REGION_SIZE	(SZ_128M)
> >   #ifdef CONFIG_64BIT
> > -/* KASLR should leave at least 128MB for BPF after the kernel */
> > -#define BPF_JIT_REGION_START	PFN_ALIGN((unsigned long)&_end)
> > -#define BPF_JIT_REGION_END	(BPF_JIT_REGION_START + BPF_JIT_REGION_SIZE)
> > +#define BPF_JIT_REGION_START	(BPF_JIT_REGION_END - BPF_JIT_REGION_SIZE)
> > +#define BPF_JIT_REGION_END	(MODULES_END)
> >   #else
> >   #define BPF_JIT_REGION_START	(PAGE_OFFSET - BPF_JIT_REGION_SIZE)
> >   #define BPF_JIT_REGION_END	(VMALLOC_END)
> >  =20


