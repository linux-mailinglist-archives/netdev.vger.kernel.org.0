Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7264431F7
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 16:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhKBPsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 11:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbhKBPr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 11:47:59 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F647C061714;
        Tue,  2 Nov 2021 08:45:24 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id v127so15929074wme.5;
        Tue, 02 Nov 2021 08:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oIykopvcWEmxVEkfNC3dgfAMuhJk89I9yxZdFrfrLyY=;
        b=NXwFLg3whNd+9Nkioovkzccugez6vLSyVeaz69yv0iI5DOvqAMuZCSP9hMD6h2nfES
         HPBxphhkGTHJxUKAED7L+nz4JnTpuFpHC88feWNsztuGjud5NdCc5PngvHdUhJkC+gms
         bBm72Jb0sp8hxtV5OttEq6BWZTzkux5i0jxaTZknB4yNttAe971OdzxOSqAvX1ZJaS59
         NREcJfVNjGf8RtuNF/RrCXB03KJZ4PtK3cqTtv3MQ6KZgz8o3WPJhmPuDUNOC8d4Qc3A
         SyGme9gy2AqqIwYH2qexyLHWLRXzEXYurvchicvoMOGQ+U6Ifec11/QCxIxpxtlaL5Pp
         taaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oIykopvcWEmxVEkfNC3dgfAMuhJk89I9yxZdFrfrLyY=;
        b=rl67bb/io0d6Qlx631/03U8EooTdxGqV3gVP9biT2rVU5nlwGOL7UFsxDP2fkxDeMj
         vvdMj8eSupoTIAtZdNjNUb1i/fPHDMLfB5K9UEX1Jb2s7p378cV56RI6ppiiB5UAqzCA
         kz6VitJM+Ru06T2mzfiA+UJjhnlUHQpVp0oQFsGkiaYnE/GOgVlrRJsTUvHR/X3n5Jtx
         GnS9joeQoBPOFDk8HyetsWwUs0ocYy0mgh0MNc/EiW9fx8TurCa1BtwBr22QsMmHdJ/J
         wM0dc0Hh1c9nhE2ISR+xL5WfrsSJFuPcv0zZqF8JHlng1ilMQM7+T2NXXB6KqIWIpuI7
         jkdw==
X-Gm-Message-State: AOAM530J95EE7b846PS0hXXU0Ydvi2QSbLcmrnuQ2uBzusA0ysXGR9hg
        xINA/nSNPA+vqpYNQhNbXb0vO4HRmVeAOMF+q/c=
X-Google-Smtp-Source: ABdhPJxAxEXiUc4bHDnuL0cSFIkXN1ocKgHMUC217BwCqZkTrK6N7aYrgCy28CWNVRnHAMN0n/S0eZaVCql16BNd/E8=
X-Received: by 2002:a1c:740e:: with SMTP id p14mr7923263wmc.109.1635867923171;
 Tue, 02 Nov 2021 08:45:23 -0700 (PDT)
MIME-Version: 1.0
References: <20211102145642.724820-1-tongtiangen@huawei.com>
In-Reply-To: <20211102145642.724820-1-tongtiangen@huawei.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 2 Nov 2021 16:45:11 +0100
Message-ID: <CAJ+HfNg1Ki=1Zc+ThW-ynvtDo5=fNAUK-XV08-icz-nY9CNoUQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] riscv, bpf: fix some compiler error
To:     Tong Tiangen <tongtiangen@huawei.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Nov 2021 at 15:40, Tong Tiangen <tongtiangen@huawei.com> wrote:
>
> This patch fix two compile errors:
> 1. when CONFIG_BPF_JIT and CONFIG_ARCH_32I is open, There is the followin=
g
> compiler error:
>   error: undefined symbol: rv_bpf_fixup_exception
>

Good catch for the RV32!

> 2. when CONFIG_BPF_JIT and CONFIG_ARCH_64I is open, There is the followin=
g
> compiler error (W=3D1):
>   error: no previous prototype for 'rv_bpf_fixup_exception'
>
> In this patch, asm/extable.h is introduced,  the rv_bpf_fixup_exception
> function declaration is added to this file. in addition, the definition o=
f
> exception_table_entry is moved from asm-generic/extable.h to this file.
>

This is way too complicated. More below.

> Fixes: 252c765bd764 ("riscv, bpf: Add BPF exception tables")
> Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
> ---
>  arch/riscv/include/asm/Kbuild    |  1 -
>  arch/riscv/include/asm/extable.h | 49 ++++++++++++++++++++++++++++++++
>  arch/riscv/include/asm/uaccess.h | 13 ---------
>  arch/riscv/mm/extable.c          |  8 +-----
>  4 files changed, 50 insertions(+), 21 deletions(-)
>  create mode 100644 arch/riscv/include/asm/extable.h
>
> diff --git a/arch/riscv/include/asm/Kbuild b/arch/riscv/include/asm/Kbuil=
d
> index 445ccc97305a..57b86fd9916c 100644
> --- a/arch/riscv/include/asm/Kbuild
> +++ b/arch/riscv/include/asm/Kbuild
> @@ -1,6 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
>  generic-y +=3D early_ioremap.h
> -generic-y +=3D extable.h
>  generic-y +=3D flat.h
>  generic-y +=3D kvm_para.h
>  generic-y +=3D user.h
> diff --git a/arch/riscv/include/asm/extable.h b/arch/riscv/include/asm/ex=
table.h
> new file mode 100644
> index 000000000000..aa0332b053fb
> --- /dev/null
> +++ b/arch/riscv/include/asm/extable.h
> @@ -0,0 +1,49 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ASM_EXTABLE_H
> +#define __ASM_EXTABLE_H
> +
> +/*
> + * The exception table consists of pairs of addresses: the first is the
> + * address of an instruction that is allowed to fault, and the second is
> + * the address at which the program should continue.  No registers are
> + * modified, so it is entirely up to the continuation code to figure out
> + * what to do.
> + *
> + * All the routines below use bits of fixup code that are out of line
> + * with the main instruction path.  This means when everything is well,
> + * we don't even have to jump over them.  Further, they do not intrude
> + * on our cache or tlb entries.
> + */
> +struct exception_table_entry {
> +       unsigned long insn, fixup;
> +};
> +
> +struct pt_regs;
> +int fixup_exception(struct pt_regs *regs);
> +
> +#if defined(CONFIG_MMU)
> +static inline bool rv_in_bpf_jit(struct pt_regs *regs)
> +{
> +       if (!IS_ENABLED(CONFIG_BPF_JIT) || !IS_ENABLED(CONFIG_64BIT))
> +               return false;
> +
> +       return regs->epc >=3D BPF_JIT_REGION_START && regs->epc < BPF_JIT=
_REGION_END;
> +}
> +#else
> +static inline bool rv_in_bpf_jit(struct pt_regs *regs)
> +{
> +       return false;
> +}
> +#endif
> +
> +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_64BIT)
> +int rv_bpf_fixup_exception(const struct exception_table_entry *ex, struc=
t pt_regs *regs);
> +#else
> +static inline int rv_bpf_fixup_exception(const struct exception_table_en=
try *ex,
> +                                        struct pt_regs *regs)
> +{
> +       return 0;
> +}
> +#endif
> +
> +#endif
> diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/ua=
ccess.h
> index f314ff44c48d..96ea91dc0e9c 100644
> --- a/arch/riscv/include/asm/uaccess.h
> +++ b/arch/riscv/include/asm/uaccess.h
> @@ -56,19 +56,6 @@ static inline int __access_ok(unsigned long addr, unsi=
gned long size)
>         return size <=3D TASK_SIZE && addr <=3D TASK_SIZE - size;
>  }
>
> -/*
> - * The exception table consists of pairs of addresses: the first is the
> - * address of an instruction that is allowed to fault, and the second is
> - * the address at which the program should continue.  No registers are
> - * modified, so it is entirely up to the continuation code to figure out
> - * what to do.
> - *
> - * All the routines below use bits of fixup code that are out of line
> - * with the main instruction path.  This means when everything is well,
> - * we don't even have to jump over them.  Further, they do not intrude
> - * on our cache or tlb entries.
> - */
> -
>  #define __LSW  0
>  #define __MSW  1
>
> diff --git a/arch/riscv/mm/extable.c b/arch/riscv/mm/extable.c
> index 18bf338303b6..264f465db5bb 100644
> --- a/arch/riscv/mm/extable.c
> +++ b/arch/riscv/mm/extable.c
> @@ -11,10 +11,6 @@
>  #include <linux/module.h>
>  #include <linux/uaccess.h>
>
> -#ifdef CONFIG_BPF_JIT
> -int rv_bpf_fixup_exception(const struct exception_table_entry *ex, struc=
t pt_regs *regs);
> -#endif
> -
>  int fixup_exception(struct pt_regs *regs)
>  {
>         const struct exception_table_entry *fixup;
> @@ -23,10 +19,8 @@ int fixup_exception(struct pt_regs *regs)
>         if (!fixup)
>                 return 0;
>
> -#ifdef CONFIG_BPF_JIT
> -       if (regs->epc >=3D BPF_JIT_REGION_START && regs->epc < BPF_JIT_RE=
GION_END)
> +       if (rv_in_bpf_jit(regs))
>                 return rv_bpf_fixup_exception(fixup, regs);
> -#endif
>

The only changes that are needed are:
1. Simply gate with CONFIG_BPF_JIT && CONFIG_ARCH_RV64I, instead of of
CONFIG_BPF_JIT

2. Forward declaration of the rv_bpf_fixup_exception() in bpf_jit_comp64.c.


Bj=C3=B6rn
