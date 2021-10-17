Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E519430B8F
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 20:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344447AbhJQSnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 14:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbhJQSnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 14:43:22 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23D1C06161C;
        Sun, 17 Oct 2021 11:41:12 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id t2so37086477wrb.8;
        Sun, 17 Oct 2021 11:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f6TkSbcH2BKx7iP1yF8fC6HBPqah8EiSlbRDJRCBac0=;
        b=nKQx5YkY/bedfKwpSYa6BjgM+axPatnaUYO51+siK2QwxZZejuxVc9MUVDE6Ol7Kud
         X42lSsN4w5dOpY/hYuspG/bb6xhZ8RA3EwE3YbWHjZqFvSnDS9iHQ3pBF63a33vRuolH
         i/X3l/hK39wxKiw9pX2UDHjCini8ylSnO2AqHwhBVohUQpy1MwqNbrrT0XMKmjmGv5fm
         ymnsz/+e8Dvp80r0P9xw26b3ouSm7xSqxw13IGQTdsBgjWykmlYJoyf5yREerDJ4iLJz
         GmfTEckui3NIew74jj/ciE/Sb77Go2NUtwS5AQLshriORbyaAqRWkr0jbR42GyyYJxiG
         8anw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f6TkSbcH2BKx7iP1yF8fC6HBPqah8EiSlbRDJRCBac0=;
        b=YSkT8rlmhP1qpnuAbUd9JL6aALIS9+lFwQwTWreWyk2yMTOY4jVpKNw/wp0AzSxyL/
         oTy9Qboph6fZDKPSmE0baSVVhBLwwWO59eVVvoWGROTJA/UE2JblMceA8zfJ6RPipRta
         0aV+ZD+tFnapCxtojEAdHSQ9mhY9PhOqhTkmkON0sSGJBvYsPBxgDBodjRDBwl5dQ4Pi
         kUst21Ke35RRNy3V9Fmjz9OuPeDeR+ieueEFhjhyUCPA7i831t25ff31wWb8vyUfa8Cl
         3YjuMjt8qjrZw+aR+swpcDIpHda/fsQElVPN438vGbimtwqHuXUWSTtljLL1FOP0tT0o
         e9gw==
X-Gm-Message-State: AOAM533vZANsSMc1vIFG8q1CvbUzkIwfB0r9L8+arYjELtMc1Rec8ICs
        Lmz9TEUiQqqXFiehy+iSuyoPbwvYCGTyc7ov1eo=
X-Google-Smtp-Source: ABdhPJz7hlNaZTJKNllskYTCSezHB/riljgVQfD8tKSUTnVhYyuoDZ2Rxh1laMHCcC4o8sqPdezYybmWE0eXdlVwr6g=
X-Received: by 2002:a5d:64c5:: with SMTP id f5mr29543687wri.321.1634496071080;
 Sun, 17 Oct 2021 11:41:11 -0700 (PDT)
MIME-Version: 1.0
References: <20211015155241.237726-1-tongtiangen@huawei.com>
In-Reply-To: <20211015155241.237726-1-tongtiangen@huawei.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Sun, 17 Oct 2021 20:40:59 +0200
Message-ID: <CAJ+HfNhcdVR19s+0CAoX4_r-3EPRzAAV-691DJGtx+WJcM3LgQ@mail.gmail.com>
Subject: Re: [PATCH -next] riscv/eBPF: Add BPF exception tables
To:     Tong Tiangen <tongtiangen@huawei.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
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

Firstly, thanks a lot for working on the exception fixup handling!

Specific comments below, but first some generic input.

For the subject, please use "riscv, bpf" or "riscv: bpf:" instead of
"riscv/eBPF:", and target the bpf-next tree (details in
Documentation/bpf/bpf_devel_QA.rst).

Also, it would be really nice if the RISC-V 32b support got the same
fixup love! ;-)

I haven't taken the code for a spin/selftest run yet, but I'll try to
do it this week!

Subjective style input: Please use the full 100 chars lines, now that
we can! ;-)

On Fri, 15 Oct 2021 at 17:37, Tong Tiangen <tongtiangen@huawei.com> wrote:
>
> When a tracing BPF program attempts to read memory without using the
> bpf_probe_read() helper, the verifier marks the load instruction with
> the BPF_PROBE_MEM flag. Since the riscv JIT does not currently recognize
> this flag it falls back to the interpreter.
>
> Add support for BPF_PROBE_MEM, by appending an exception table to the
> BPF program. If the load instruction causes a data abort, the fixup
> infrastructure finds the exception table and fixes up the fault, by
> clearing the destination register and jumping over the faulting
> instruction.
>
> A more generic solution would add a "handler" field to the table entry.
>

So, would it make sense to add a handler field, to be more consistent
with say, x86?

This code is heavily based on the ARM64 one. Would a "handler", make
the ARM64 code simpler as well?

> The same issue in ARM64 is fixed in:
> commit 800834285361 ("bpf, arm64: Add BPF exception tables"),
>
> Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
> Tested-by: Pu Lehui <pulehui@huawei.com>
> ---
>  arch/riscv/include/asm/Kbuild    |   1 -
>  arch/riscv/include/asm/extable.h |  49 ++++++++
>  arch/riscv/include/asm/uaccess.h |  13 ---
>  arch/riscv/mm/extable.c          |  13 ++-
>  arch/riscv/net/bpf_jit.h         |   1 +
>  arch/riscv/net/bpf_jit_comp64.c  | 187 +++++++++++++++++++++++++------
>  arch/riscv/net/bpf_jit_core.c    |  18 ++-
>  7 files changed, 222 insertions(+), 60 deletions(-)
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
> index 000000000000..8a52cdd122de
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

RISC-V uses the generic exception_table_entry (linux/extable.h), so I
don't see why it should be redefined here, without any
changes.

I'd suggest that instead of creating a new extable.h, simply fold the
changes directly in the mm/except.c. More on that below.

Unless, the "handler field" route is taken. Then, the new
exception_table_entry should go here.

> +#ifdef CONFIG_BPF_JIT
> +static inline bool in_bpf_jit(struct pt_regs *regs)
> +{
> +       if (!IS_ENABLED(CONFIG_BPF_JIT))
> +               return false;
> +
> +       return regs->epc >=3D BPF_JIT_REGION_START &&
> +               regs->epc < BPF_JIT_REGION_END;

Nit/FYI: 100 char lines is OK nowadays! ;-)

> +}
> +
> +int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
> +                             struct pt_regs *regs);
> +#else /* !CONFIG_BPF_JIT */
> +static inline bool in_bpf_jit(struct pt_regs *regs)
> +{
> +       return 0;
> +}
> +
> +static inline
> +int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
> +                             struct pt_regs *regs)
> +{
> +       return 0;
> +}
> +#endif /* !CONFIG_BPF_JIT */
> +
> +struct pt_regs;
> +extern int fixup_exception(struct pt_regs *regs);
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

...and don't remove this...

>  #define __LSW  0
>  #define __MSW  1
>
> diff --git a/arch/riscv/mm/extable.c b/arch/riscv/mm/extable.c
> index 2fc729422151..f8055c6d0f32 100644
> --- a/arch/riscv/mm/extable.c
> +++ b/arch/riscv/mm/extable.c
> @@ -16,9 +16,12 @@ int fixup_exception(struct pt_regs *regs)
>         const struct exception_table_entry *fixup;
>
>         fixup =3D search_exception_tables(regs->epc);
> -       if (fixup) {
> -               regs->epc =3D fixup->fixup;
> -               return 1;
> -       }
> -       return 0;
> +       if (!fixup)
> +               return 0;
> +
> +       if (in_bpf_jit(regs))
> +               return rv_bpf_fixup_exception(fixup, regs);
> +

...instead add the definition of in_bpf_jit() here, and the
CONFIG_BPF_JIT around the "if (in_bpf_jit()...)"

> +       regs->epc =3D fixup->fixup;
> +       return 1;
>  }
> diff --git a/arch/riscv/net/bpf_jit.h b/arch/riscv/net/bpf_jit.h
> index 75c1e9996867..82f717cc98f7 100644
> --- a/arch/riscv/net/bpf_jit.h
> +++ b/arch/riscv/net/bpf_jit.h
> @@ -71,6 +71,7 @@ struct rv_jit_context {
>         int ninsns;
>         int epilogue_offset;
>         int *offset;            /* BPF to RV */
> +       int exentry_idx;

I'd prefer if this would be named "nexentries" or something, so it's
more consistent with "ninsns", clear that "this is number of extable
entries".

>         unsigned long flags;
>         int stack_size;
>  };
> diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_com=
p64.c
> index 3af4131c22c7..97411d43785e 100644
> --- a/arch/riscv/net/bpf_jit_comp64.c
> +++ b/arch/riscv/net/bpf_jit_comp64.c
> @@ -5,6 +5,7 @@
>   *
>   */
>
> +#include <linux/bitfield.h>
>  #include <linux/bpf.h>
>  #include <linux/filter.h>
>  #include "bpf_jit.h"
> @@ -27,6 +28,21 @@ static const int regmap[] =3D {
>         [BPF_REG_AX] =3D  RV_REG_T0,
>  };
>
> +static const int pt_regmap[] =3D {
> +       [RV_REG_A5] =3D offsetof(struct pt_regs, a5),
> +       [RV_REG_A0] =3D offsetof(struct pt_regs, a0),
> +       [RV_REG_A1] =3D offsetof(struct pt_regs, a1),
> +       [RV_REG_A2] =3D offsetof(struct pt_regs, a2),
> +       [RV_REG_A3] =3D offsetof(struct pt_regs, a3),
> +       [RV_REG_A4] =3D offsetof(struct pt_regs, a4),
> +       [RV_REG_S1] =3D offsetof(struct pt_regs, s1),
> +       [RV_REG_S2] =3D offsetof(struct pt_regs, s2),
> +       [RV_REG_S3] =3D offsetof(struct pt_regs, s3),
> +       [RV_REG_S4] =3D offsetof(struct pt_regs, s4),
> +       [RV_REG_S5] =3D offsetof(struct pt_regs, s5),
> +       [RV_REG_T0] =3D offsetof(struct pt_regs, t0),
> +};
> +
>  enum {
>         RV_CTX_F_SEEN_TAIL_CALL =3D       0,
>         RV_CTX_F_SEEN_CALL =3D            RV_REG_RA,
> @@ -440,6 +456,71 @@ static int emit_call(bool fixed, u64 addr, struct rv=
_jit_context *ctx)
>         return 0;
>  }
>
> +#define BPF_FIXUP_OFFSET_MASK   GENMASK(26, 0)
> +#define BPF_FIXUP_REG_MASK      GENMASK(31, 27)
> +
> +int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
> +                               struct pt_regs *regs)
> +{
> +       off_t offset =3D FIELD_GET(BPF_FIXUP_OFFSET_MASK, ex->fixup);
> +       int regs_offset =3D FIELD_GET(BPF_FIXUP_REG_MASK, ex->fixup);
> +
> +       *(unsigned long *)((unsigned char *)regs + pt_regmap[regs_offset]=
) =3D 0;
> +       regs->epc =3D (unsigned long)&ex->fixup - offset;
> +
> +       return 1;
> +}
> +
> +/* For accesses to BTF pointers, add an entry to the exception table */
> +static int add_exception_handler(const struct bpf_insn *insn,
> +                                struct rv_jit_context *ctx,
> +                                int dst_reg, int insn_len)
> +{
> +       off_t offset;
> +       unsigned long pc;
> +       struct exception_table_entry *ex;
> +

Nit: Please use reverse xmas tree sorting (longest lines first).

[...]


Cheers,
Bj=C3=B6rn
