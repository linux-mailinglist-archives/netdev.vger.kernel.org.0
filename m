Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423A63ABAB0
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 19:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhFQRfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbhFQRfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 13:35:40 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 47287C061574;
        Thu, 17 Jun 2021 10:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
        Content-Transfer-Encoding; bh=2WqF3xlPdjlb7DNjB4HbqU0LlDMvIWnKuW
        lsbQskrk8=; b=DEf7GGPw3c3zu5n5HzmKg3as3RSUDzFlCRmmqQRVKyQlhOP8ZI
        4EuFN4UiyoT7PcRr924jrwO2PeoimMFqEKa77Snha5XUpnwIfNRMyNLkGDqfLDRA
        a1xay2+5i3xzOAEDpnV2ACS//0uicAsNzlyIzGxBsn/Z2PyzmlKWPtF80=
Received: from xhacker (unknown [101.86.20.15])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygC3vIhQh8tgAw73AA--.5293S2;
        Fri, 18 Jun 2021 01:33:05 +0800 (CST)
Date:   Fri, 18 Jun 2021 01:27:31 +0800
From:   Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
To:     Alex Ghiti <alex@ghiti.fr>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>, schwab@linux-m68k.org,
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
Subject: Re: [PATCH] riscv: Ensure BPF_JIT_REGION_START aligned with PMD
 size
Message-ID: <20210618012731.345657bf@xhacker>
In-Reply-To: <50ebc99c-f0a2-b4ea-fc9b-cd93a8324697@ghiti.fr>
References: <mhng-042979fe-75f0-4873-8afd-f8c07942f792@palmerdabbelt-glaptop>
        <ae256a5d-70ac-3a5f-ca55-5e4210a0624c@ghiti.fr>
        <50ebc99c-f0a2-b4ea-fc9b-cd93a8324697@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-CM-TRANSID: LkAmygC3vIhQh8tgAw73AA--.5293S2
X-Coremail-Antispam: 1UD129KBjvJXoWxtFW7Wr13tr1fAryfGw15Jwb_yoWDJrWkpr
        1kJFW3GrWrtr1kXry2qry5CryUtw1UAasFqr1DJa4rAFsrKF1jqr1jqFy29rnFqF4xA3W2
        yr4DJrsIv345Aw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkKb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4
        vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40E
        FcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr
        0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY
        04v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU5Vmh7
        UUUUU==
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Jun 2021 16:18:54 +0200
Alex Ghiti <alex@ghiti.fr> wrote:

> Le 17/06/2021 =C3=A0 10:09, Alex Ghiti a =C3=A9crit=C2=A0:
> > Le 17/06/2021 =C3=A0 09:30, Palmer Dabbelt a =C3=A9crit=C2=A0: =20
> >> On Tue, 15 Jun 2021 17:03:28 PDT (-0700), jszhang3@mail.ustc.edu.cn=20
> >> wrote: =20
> >>> On Tue, 15 Jun 2021 20:54:19 +0200
> >>> Alex Ghiti <alex@ghiti.fr> wrote:
> >>> =20
> >>>> Hi Jisheng, =20
> >>>
> >>> Hi Alex,
> >>> =20
> >>>>
> >>>> Le 14/06/2021 =C3=A0 18:49, Jisheng Zhang a =C3=A9crit=C2=A0: =20
> >>>> > From: Jisheng Zhang <jszhang@kernel.org> =20
> >>>> > > Andreas reported commit fc8504765ec5 ("riscv: bpf: Avoid  =20
> >>>> breaking W^X") =20
> >>>> > breaks booting with one kind of config file, I reproduced a kernel=
  =20
> >>>> panic =20
> >>>> > with the config: =20
> >>>> > > [=C2=A0=C2=A0=C2=A0 0.138553] Unable to handle kernel paging req=
uest at virtual  =20
> >>>> address ffffffff81201220 =20
> >>>> > [=C2=A0=C2=A0=C2=A0 0.139159] Oops [#1]
> >>>> > [=C2=A0=C2=A0=C2=A0 0.139303] Modules linked in:
> >>>> > [=C2=A0=C2=A0=C2=A0 0.139601] CPU: 0 PID: 1 Comm: swapper/0 Not ta=
inted  =20
> >>>> 5.13.0-rc5-default+ #1 =20
> >>>> > [=C2=A0=C2=A0=C2=A0 0.139934] Hardware name: riscv-virtio,qemu (DT)
> >>>> > [=C2=A0=C2=A0=C2=A0 0.140193] epc : __memset+0xc4/0xfc
> >>>> > [=C2=A0=C2=A0=C2=A0 0.140416]=C2=A0 ra : skb_flow_dissector_init+0=
x1e/0x82
> >>>> > [=C2=A0=C2=A0=C2=A0 0.140609] epc : ffffffff8029806c ra : ffffffff=
8033be78 sp :  =20
> >>>> ffffffe001647da0 =20
> >>>> > [=C2=A0=C2=A0=C2=A0 0.140878]=C2=A0 gp : ffffffff81134b08 tp : fff=
fffe001654380 t0 :  =20
> >>>> ffffffff81201158 =20
> >>>> > [=C2=A0=C2=A0=C2=A0 0.141156]=C2=A0 t1 : 0000000000000002 t2 : 000=
0000000000154 s0 :  =20
> >>>> ffffffe001647dd0 =20
> >>>> > [=C2=A0=C2=A0=C2=A0 0.141424]=C2=A0 s1 : ffffffff80a43250 a0 : fff=
fffff81201220 a1 :  =20
> >>>> 0000000000000000 =20
> >>>> > [=C2=A0=C2=A0=C2=A0 0.141654]=C2=A0 a2 : 000000000000003c a3 : fff=
fffff81201258 a4 :  =20
> >>>> 0000000000000064 =20
> >>>> > [=C2=A0=C2=A0=C2=A0 0.141893]=C2=A0 a5 : ffffffff8029806c a6 : 000=
0000000000040 a7 :  =20
> >>>> ffffffffffffffff =20
> >>>> > [=C2=A0=C2=A0=C2=A0 0.142126]=C2=A0 s2 : ffffffff81201220 s3 : 000=
0000000000009 s4 :  =20
> >>>> ffffffff81135088 =20
> >>>> > [=C2=A0=C2=A0=C2=A0 0.142353]=C2=A0 s5 : ffffffff81135038 s6 : fff=
fffff8080ce80 s7 :  =20
> >>>> ffffffff80800438 =20
> >>>> > [=C2=A0=C2=A0=C2=A0 0.142584]=C2=A0 s8 : ffffffff80bc6578 s9 : 000=
0000000000008 s10:  =20
> >>>> ffffffff806000ac =20
> >>>> > [=C2=A0=C2=A0=C2=A0 0.142810]=C2=A0 s11: 0000000000000000 t3 : fff=
ffffffffffffc t4 :  =20
> >>>> 0000000000000000 =20
> >>>> > [=C2=A0=C2=A0=C2=A0 0.143042]=C2=A0 t5 : 0000000000000155 t6 : 000=
00000000003ff
> >>>> > [=C2=A0=C2=A0=C2=A0 0.143220] status: 0000000000000120 badaddr: ff=
ffffff81201220  =20
> >>>> cause: 000000000000000f =20
> >>>> > [=C2=A0=C2=A0=C2=A0 0.143560] [<ffffffff8029806c>] __memset+0xc4/0=
xfc
> >>>> > [=C2=A0=C2=A0=C2=A0 0.143859] [<ffffffff8061e984>]  =20
> >>>> init_default_flow_dissectors+0x22/0x60 =20
> >>>> > [=C2=A0=C2=A0=C2=A0 0.144092] [<ffffffff800010fc>] do_one_initcall=
+0x3e/0x168
> >>>> > [=C2=A0=C2=A0=C2=A0 0.144278] [<ffffffff80600df0>] kernel_init_fre=
eable+0x1c8/0x224
> >>>> > [=C2=A0=C2=A0=C2=A0 0.144479] [<ffffffff804868a8>] kernel_init+0x1=
2/0x110
> >>>> > [=C2=A0=C2=A0=C2=A0 0.144658] [<ffffffff800022de>] ret_from_except=
ion+0x0/0xc
> >>>> > [=C2=A0=C2=A0=C2=A0 0.145124] ---[ end trace f1e9643daa46d591 ]---=
 =20
> >>>> > > After some investigation, I think I found the root cause: commit=
 =20
> >>>> > 2bfc6cd81bd ("move kernel mapping outside of linear mapping") moves
> >>>> > BPF JIT region after the kernel: =20
> >>>> > > The &_end is unlikely aligned with PMD size, so the front bpf ji=
t =20
> >>>> > region sits with part of kernel .data section in one PMD size  =20
> >>>> mapping. =20
> >>>> > But kernel is mapped in PMD SIZE, when bpf_jit_binary_lock_ro() is
> >>>> > called to make the first bpf jit prog ROX, we will make part of  =
=20
> >>>> kernel =20
> >>>> > .data section RO too, so when we write to, for example memset the
> >>>> > .data section, MMU will trigger a store page fault. =20
> >>>> Good catch, we make sure no physical allocation happens between _end=
=20
> >>>> and the next PMD aligned address, but I missed this one.
> >>>> =20
> >>>> > > To fix the issue, we need to ensure the BPF JIT region is PMD si=
ze =20
> >>>> > aligned. This patch acchieve this goal by restoring the BPF JIT  =
=20
> >>>> region =20
> >>>> > to original position, I.E the 128MB before kernel .text section. =
=20
> >>>> But I disagree with your solution: I made sure modules and BPF=20
> >>>> programs get their own virtual regions to avoid worst case scenario=
=20
> >>>> where one could allocate all the space and leave nothing to the=20
> >>>> other (we are limited to +- 2GB offset). Why don't just align=20
> >>>> BPF_JIT_REGION_START to the next PMD aligned address? =20
> >>>
> >>> Originally, I planed to fix the issue by aligning=20
> >>> BPF_JIT_REGION_START, but
> >>> IIRC, BPF experts are adding (or have added) "Calling kernel=20
> >>> functions from BPF"
> >>> feature, there's a risk that BPF JIT region is beyond the 2GB of=20
> >>> module region:
> >>>
> >>> ------
> >>> module
> >>> ------
> >>> kernel
> >>> ------
> >>> BPF_JIT
> >>>
> >>> So I made this patch finally. In this patch, we let BPF JIT region sit
> >>> between module and kernel.
> >>>
> >>> To address "make sure modules and BPF programs get their own virtual=
=20
> >>> regions",
> >>> what about something as below (applied against this patch)?
> >>>
> >>> diff --git a/arch/riscv/include/asm/pgtable.h=20
> >>> b/arch/riscv/include/asm/pgtable.h
> >>> index 380cd3a7e548..da1158f10b09 100644
> >>> --- a/arch/riscv/include/asm/pgtable.h
> >>> +++ b/arch/riscv/include/asm/pgtable.h
> >>> @@ -31,7 +31,7 @@
> >>> =C2=A0#define BPF_JIT_REGION_SIZE=C2=A0=C2=A0=C2=A0 (SZ_128M)
> >>> =C2=A0#ifdef CONFIG_64BIT
> >>> =C2=A0#define BPF_JIT_REGION_START=C2=A0=C2=A0=C2=A0 (BPF_JIT_REGION_=
END -=20
> >>> BPF_JIT_REGION_SIZE)
> >>> -#define BPF_JIT_REGION_END=C2=A0=C2=A0=C2=A0 (MODULES_END)
> >>> +#define BPF_JIT_REGION_END=C2=A0=C2=A0=C2=A0 (PFN_ALIGN((unsigned lo=
ng)&_start))
> >>> =C2=A0#else
> >>> =C2=A0#define BPF_JIT_REGION_START=C2=A0=C2=A0=C2=A0 (PAGE_OFFSET - B=
PF_JIT_REGION_SIZE)
> >>> =C2=A0#define BPF_JIT_REGION_END=C2=A0=C2=A0=C2=A0 (VMALLOC_END)
> >>> @@ -40,7 +40,7 @@
> >>> =C2=A0/* Modules always live before the kernel */
> >>> =C2=A0#ifdef CONFIG_64BIT
> >>> =C2=A0#define MODULES_VADDR=C2=A0=C2=A0=C2=A0 (PFN_ALIGN((unsigned lo=
ng)&_end) - SZ_2G)
> >>> -#define MODULES_END=C2=A0=C2=A0=C2=A0 (PFN_ALIGN((unsigned long)&_st=
art))
> >>> +#define MODULES_END=C2=A0=C2=A0=C2=A0 (BPF_JIT_REGION_END)
> >>> =C2=A0#endif
> >>>
> >>>
> >>> =20
> >>>>
> >>>> Again, good catch, thanks,
> >>>>
> >>>> Alex
> >>>> =20
> >>>> > > Reported-by: Andreas Schwab <schwab@linux-m68k.org> =20
> >>>> > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> >>>> > ---
> >>>> >=C2=A0=C2=A0 arch/riscv/include/asm/pgtable.h | 5 ++---
> >>>> >=C2=A0=C2=A0 1 file changed, 2 insertions(+), 3 deletions(-) =20
> >>>> > > diff --git a/arch/riscv/include/asm/pgtable.h  =20
> >>>> b/arch/riscv/include/asm/pgtable.h =20
> >>>> > index 9469f464e71a..380cd3a7e548 100644
> >>>> > --- a/arch/riscv/include/asm/pgtable.h
> >>>> > +++ b/arch/riscv/include/asm/pgtable.h
> >>>> > @@ -30,9 +30,8 @@ =20
> >>>> > >=C2=A0=C2=A0 #define BPF_JIT_REGION_SIZE=C2=A0=C2=A0=C2=A0 (SZ_12=
8M) =20
> >>>> >=C2=A0=C2=A0 #ifdef CONFIG_64BIT
> >>>> > -/* KASLR should leave at least 128MB for BPF after the kernel */
> >>>> > -#define BPF_JIT_REGION_START=C2=A0=C2=A0=C2=A0 PFN_ALIGN((unsigne=
d long)&_end)
> >>>> > -#define BPF_JIT_REGION_END=C2=A0=C2=A0=C2=A0 (BPF_JIT_REGION_STAR=
T +  =20
> >>>> BPF_JIT_REGION_SIZE) =20
> >>>> > +#define BPF_JIT_REGION_START=C2=A0=C2=A0=C2=A0 (BPF_JIT_REGION_EN=
D -  =20
> >>>> BPF_JIT_REGION_SIZE) =20
> >>>> > +#define BPF_JIT_REGION_END=C2=A0=C2=A0=C2=A0 (MODULES_END)
> >>>> >=C2=A0=C2=A0 #else
> >>>> >=C2=A0=C2=A0 #define BPF_JIT_REGION_START=C2=A0=C2=A0=C2=A0 (PAGE_O=
FFSET - BPF_JIT_REGION_SIZE)
> >>>> >=C2=A0=C2=A0 #define BPF_JIT_REGION_END=C2=A0=C2=A0=C2=A0 (VMALLOC_=
END)
> >>>> >  =20
> >>
> >> This, when applied onto fixes, is breaking early boot on KASAN=20
> >> configurations for me. =20

I can reproduce this issue.

> >=20
> > Not surprising, I took a shortcut when initializing KASAN for modules,=
=20
> > kernel and BPF:
> >=20
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kasan_populate(kasan_mem_to=
_shadow((const void *)MODULES_VADDR),
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kasan_mem_t=
o_shadow((const void=20
> > *)BPF_JIT_REGION_END));
> >=20
> > The kernel is then not covered, I'm taking a look at how to fix that=20
> > properly.
> > =20
>=20
> The following based on "riscv: Introduce structure that group all=20
> variables regarding kernel mapping" fixes the issue:
>=20
> diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
> index 9daacae93e33..2a45ea909e7f 100644
> --- a/arch/riscv/mm/kasan_init.c
> +++ b/arch/riscv/mm/kasan_init.c
> @@ -199,9 +199,12 @@ void __init kasan_init(void)
>                  kasan_populate(kasan_mem_to_shadow(start),=20
> kasan_mem_to_shadow(end));
>          }
>=20
> -       /* Populate kernel, BPF, modules mapping */
> +       /* Populate BPF and modules mapping: modules mapping encompasses=
=20
> BPF mapping */
>          kasan_populate(kasan_mem_to_shadow((const void *)MODULES_VADDR),
> -                      kasan_mem_to_shadow((const void=20
> *)BPF_JIT_REGION_END));
> +                      kasan_mem_to_shadow((const void *)MODULES_END));
> +       /* Populate kernel mapping */
> +       kasan_populate(kasan_mem_to_shadow((const void=20
> *)kernel_map.virt_addr),
> +                      kasan_mem_to_shadow((const void=20
> *)kernel_map.virt_addr + kernel_map.size));
>
If this patch works, maybe we can still use one kasan_populate() to cover
kernel, bpf, and module:

        kasan_populate(kasan_mem_to_shadow((const void *)MODULES_VADDR),
-                      kasan_mem_to_shadow((const void *)BPF_JIT_REGION_END=
));
+                      kasan_mem_to_shadow((const void *)MODULES_VADDR + SZ=
_2G));

However, both can't solve the early boot hang issue. I'm not sure what's mi=
ssing.

I applied your patch on rc6 + solution below "replace kernel_map.virt_addr =
with kernel_virt_addr and
kernel_map.size with load_sz"


Thanks
=20
>=20
> Without the mentioned patch, replace kernel_map.virt_addr with=20
> kernel_virt_addr and kernel_map.size with load_sz. Note that load_sz was=
=20
> re-exposed in v6 of the patchset "Map the kernel with correct=20
> permissions the first time".
>=20

