Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9583C109EC8
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 14:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfKZNOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 08:14:36 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41304 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfKZNOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 08:14:36 -0500
Received: by mail-qt1-f193.google.com with SMTP id 59so15805245qtg.8;
        Tue, 26 Nov 2019 05:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cpPxka1Pl27l5pcH6nCC6OburpGArFz8nhEvihO8xNg=;
        b=jTCV7l3jNyoKkSnavBxPWKG7xXbsf4keKse9VtmD0UNTC7nV5MSXLWHd0M21Su28JI
         RpeGYfG41qyscMKZaydg8jOFeUnbC8By/o4moFV0MxKGBx+nGucowfb5GB0L3APzWQyq
         9EGHVmXTkopcYKenWF9Wz3O7zkODFY1CUH9T7xHEEj6/BGMC57yPd2rGbwUYdnURqSO5
         rIStZs8MhXX+xgyXc/vzRekBA7FhIvpi4pGN5YfNBQ6vUrw4vlRJJ4OK3E8FoqJMWqBk
         BXvtjClTgFEqzClQ4/ndvqzvyxUVegh0KnhdNNxYGatBtVopF6N0lCOKbsw5MXCnn+aR
         6Y6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cpPxka1Pl27l5pcH6nCC6OburpGArFz8nhEvihO8xNg=;
        b=kDFWXknBSDU+gejcZQxQk1XmiMexRNwh7ZsHNzS6xNotHSrSJocNMxoHJzFhB45sn+
         WkkWv+h6TzO02MvAdeQpNMaD0FbddhE/MYrVM2ds0GBSQ6pi+ZdBhJAavOd04Sf1S0vp
         VKwTMcu6s00iiARQ5H19hkSYLvzO1wHntRc5h0ZSqThYGS9ESPKAHJ9iTo58x717nezG
         RzTtNjDxWYRiysVxyd2IYHfV0FE66i90eokWs7z0mSiy9g8EBqu1VXcyZ3Qlo2T0IrYQ
         PaaR6Pw1uYfVE4WTWgKAv+3Nbp9s/fPgktAUe4SZzhAJgvfw9C+A8hsipTqswZN7uFhy
         7TzQ==
X-Gm-Message-State: APjAAAVF5i2o8tu2nw89QA2CRSZgTCwZEMDL5Z7zaGqUwGv54K/4qBIO
        8yj7U/0SZLrlFpsRJGO7MxdpAdaphVT6iZDTFtU=
X-Google-Smtp-Source: APXvYqzvpjLjGloa05lw3i6I7fgHo/R4gvZ+aD1eq+3S4tCNKb5dQ6Noemh342gMN8vs6C7Xgr0E0nChjCjoOogvPVg=
X-Received: by 2002:ac8:1bed:: with SMTP id m42mr17979158qtk.359.1574774074441;
 Tue, 26 Nov 2019 05:14:34 -0800 (PST)
MIME-Version: 1.0
References: <mhng-0a2f9574-9b23-4f26-ae76-18ed7f2c8533@palmer-si-x1c4>
 <87d0yoizv9.fsf@xps13.shealevy.com> <87zi19gjof.fsf@xps13.shealevy.com>
In-Reply-To: <87zi19gjof.fsf@xps13.shealevy.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 26 Nov 2019 14:14:22 +0100
Message-ID: <CAJ+HfNhoJnGon-L9OwSfrMbmUt1ZPBB_=A8ZFrg1CgEq3ua-Sg@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: Load modules within relative jump range of the
 kernel text.
To:     Shea Levy <shea@shealevy.com>
Cc:     linux-riscv@lists.infradead.org, albert@sifive.com,
        LKML <linux-kernel@vger.kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 May 2018 at 13:22, Shea Levy <shea@shealevy.com> wrote:
>
> Hi Palmer,
>
> Shea Levy <shea@shealevy.com> writes:
>
> > Hi Palmer,
> >
> > Palmer Dabbelt <palmer@sifive.com> writes:
> >
> >> On Sun, 22 Apr 2018 05:53:56 PDT (-0700), shea@shealevy.com wrote:
> >>> Hi Palmer,
> >>>
> >>> Shea Levy <shea@shealevy.com> writes:
> >>>
> >>>> Signed-off-by: Shea Levy <shea@shealevy.com>
> >>>> ---
> >>>>
> >>>> Note that this patch worked in my old modules patchset and seems to =
be
> >>>> working now, but my kernel boot locks up on top of
> >>>> riscv-for-linus-4.17-mw0 and I don't know if it's due to this patch =
or
> >>>> something else that's changed in the mean time.
> >>>>
> >>>> ---
> >>>>  arch/riscv/include/asm/pgtable.h |  9 +++++++++
> >>>>  arch/riscv/kernel/module.c       | 11 +++++++++++
> >>>>  2 files changed, 20 insertions(+)
> >>>>
> >>>> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/a=
sm/pgtable.h
> >>>> index 16301966d65b..b08ded13364a 100644
> >>>> --- a/arch/riscv/include/asm/pgtable.h
> >>>> +++ b/arch/riscv/include/asm/pgtable.h
> >>>> @@ -25,6 +25,7 @@
> >>>>  #include <asm/page.h>
> >>>>  #include <asm/tlbflush.h>
> >>>>  #include <linux/mm_types.h>
> >>>> +#include <linux/sizes.h>
> >>>>
> >>>>  #ifdef CONFIG_64BIT
> >>>>  #include <asm/pgtable-64.h>
> >>>> @@ -425,6 +426,14 @@ static inline void pgtable_cache_init(void)
> >>>>  #define TASK_SIZE VMALLOC_START
> >>>>  #endif
> >>>>
> >>>> +/*
> >>>> + * The module space lives between the addresses given by TASK_SIZE
> >>>> + * and PAGE_OFFSET - it must be within 2G of the kernel text.
> >>>> + */
> >>>> +#define MODULES_SIZE              (SZ_128M)
> >>>> +#define MODULES_VADDR             (PAGE_OFFSET - MODULES_SIZE)
> >>>> +#define MODULES_END               (VMALLOC_END)
> >>>> +
> >>>>  #include <asm-generic/pgtable.h>
> >>>>
> >>>>  #endif /* !__ASSEMBLY__ */
> >>>> diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
> >>>> index 5dddba301d0a..1b382c7de095 100644
> >>>> --- a/arch/riscv/kernel/module.c
> >>>> +++ b/arch/riscv/kernel/module.c
> >>>> @@ -16,6 +16,8 @@
> >>>>  #include <linux/err.h>
> >>>>  #include <linux/errno.h>
> >>>>  #include <linux/moduleloader.h>
> >>>> +#include <linux/vmalloc.h>
> >>>> +#include <asm/pgtable.h>
> >>>>
> >>>>  static int apply_r_riscv_64_rela(struct module *me, u32 *location, =
Elf_Addr v)
> >>>>  {
> >>>> @@ -382,3 +384,12 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const=
 char *strtab,
> >>>>
> >>>>    return 0;
> >>>>  }
> >>>> +
> >>>> +void *module_alloc(unsigned long size)
> >>>> +{
> >>>> +  return __vmalloc_node_range(size, 1, MODULES_VADDR,
> >>>> +                              MODULES_END, GFP_KERNEL,
> >>>> +                              PAGE_KERNEL_EXEC, 0,
> >>>> +                              NUMA_NO_NODE,
> >>>> +                              __builtin_return_address(0));
> >>>> +}
> >>>> --
> >>>> 2.16.2
> >>>
> >>> Any thoughts on this?
> >>
> >> The concept looks good, but does this actually keep the modules within=
 2GiB of
> >> the text if PAGE_OFFSET is large?
> >
> > It's been some time since I wrote this, but I thought PAGE_OFFSET was
> > where the kernel text *started*? So unless the text itself is bigger
> > than 2G - 128 M, in which case we're SOL anyway, it seems like this
> > should work. Is there something better we can do, without a large memor=
y
> > model?
> >
> > Thanks,
> > Shea
>
> Any further thoughts on this?
>
> Thanks,
> Shea

Shea,

Waking up the dead (threads)!

I'm hacking on call improvements for the RISC-V BPF JIT.
module_alloc() is used under the hood of bpf_jit_binary_alloc(), which
in turn is used to allocate the JIT image. The current JIT
implementation has to to "load imm64 + jalr" to call kernel syms,
since the relative offset is >32b. With your patch, I can use regular
jal/auipc+jalr instead. IOW, it would be great if it could be merged.
;-) I'd prefer not having the patch in my BPF JIT series, since that
will go through a different tree than Paul's RV one.

Wdyt about brushing of the dust of the patch, and re-send it?


Thanks!
Bj=C3=B6rn
