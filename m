Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7ED4953F2
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 19:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbiATSQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 13:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243921AbiATSQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 13:16:13 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF12C06161C
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 10:16:13 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id x22so24761562lfd.10
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 10:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J9x2NG+LgE4kaD5UG5LUL0GB0NdPSyzMtwcN6xwlv9c=;
        b=UuAosnS4uZq9DoXlhTBm4j5l2w1d3uzS1YTDRfj9LBQyPwlz6lHwa3/ypLEr5zmS7k
         pt/lZDx7hlGBC3crCBzVwmp8t2ixX5/2a0nkfDSp4Kru+pSVPKZtUWhqQYcVdiN5HiUO
         WpBGKcJpqU7V4pg5PTUGwatPlL+giv/QcjBc3qGRjWYM34j4EdkN+kNyDOqhr54G64ry
         WWzRfIpb+bYWwx/wBMHhTNpDyimr/Mld0kgdo/BCjycjgRXREiZ8gzJzne/VND60di8c
         b3wv3kQRT+j0JNBpWPwbhpQzAdrDopXsBMpjb7d3wS2tLfFVQDndXur5qLVBLLAmStJt
         nU+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J9x2NG+LgE4kaD5UG5LUL0GB0NdPSyzMtwcN6xwlv9c=;
        b=DmmhRLHt8fGVZ+tcxW5GETZcYzJwidLtAUUOdzMvlyzHjwgi0QIQGA2nPBGENAjsLB
         3/IseZ7UDKO7x/JJ0KMOQy9NLJefIpeRIsLM3VfUzyBGQlJeXT2OFmfsuKZQC/ozRpIj
         VdRF/WZSpPkjF4+UD/ZMgRg+yR40s69r/+uFRfHl/BKmGYOC4FhAsCeM/fcIyaAnRQx6
         HtPsUfJmWuWDKzKAHH2VmTnopSMyS8rZPCMG3Wd45IB1jBh810u4obS66cikAQls8Igj
         2uvCfIWyuKJmtz13cBjlHq+cVet71NXfjfHlUT7lIy8Rr3tkHSuWLnZF+MT7xp2zY9Ge
         i3gQ==
X-Gm-Message-State: AOAM531ELnsQS4OC4eda9AShNtuX/WPI+qlgqgKlKda3fVbCXcHhNIAz
        KCeE9sPPq0ct3vay2GiVyVub45cj8jS4CCUqhks6DA==
X-Google-Smtp-Source: ABdhPJybBrwpc3UAc6Gu9IhMW/l96xRVYL7rrYuA41iXQZChzao9yTwmwptotwP66Tm7Frroc0/+6+Z/W8qqzY+Uz2w=
X-Received: by 2002:a05:6512:130f:: with SMTP id x15mr242448lfu.587.1642702571197;
 Thu, 20 Jan 2022 10:16:11 -0800 (PST)
MIME-Version: 1.0
References: <20211118192130.48b8f04c@xhacker> <20211118192651.605d0c80@xhacker>
In-Reply-To: <20211118192651.605d0c80@xhacker>
From:   Mayuresh Chitale <mchitale@ventanamicro.com>
Date:   Thu, 20 Jan 2022 23:45:34 +0530
Message-ID: <CAN37VV6vfee+T18UkbDLe1ts87+Zvg25oQR1+VJD3e6SJFPPiA@mail.gmail.com>
Subject: Re: [PATCH 11/12] riscv: extable: add a dedicated uaccess handler
To:     Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Tong Tiangen <tongtiangen@huawei.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jisheng,

Just wanted to inform you that this patch breaks the writev02 test
case in LTP and if it is reverted then the test passes. If we run the
test through strace then we see that the test hangs and following is
the last line printed by strace:

"writev(3, [{iov_base=0x7fff848a6000, iov_len=8192}, {iov_base=NULL,
iov_len=0}]"

Thanks,
Mayuresh.


On Thu, Nov 18, 2021 at 5:05 PM Jisheng Zhang <jszhang3@mail.ustc.edu.cn> wrote:
>
> From: Jisheng Zhang <jszhang@kernel.org>
>
> Inspired by commit 2e77a62cb3a6("arm64: extable: add a dedicated
> uaccess handler"), do similar to riscv to add a dedicated uaccess
> exception handler to update registers in exception context and
> subsequently return back into the function which faulted, so we remove
> the need for fixups specialized to each faulting instruction.
>
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> ---
>  arch/riscv/include/asm/asm-extable.h | 23 +++++++++
>  arch/riscv/include/asm/futex.h       | 23 +++------
>  arch/riscv/include/asm/uaccess.h     | 74 +++++++++-------------------
>  arch/riscv/mm/extable.c              | 27 ++++++++++
>  4 files changed, 78 insertions(+), 69 deletions(-)
>
> diff --git a/arch/riscv/include/asm/asm-extable.h b/arch/riscv/include/asm/asm-extable.h
> index 1b1f4ffd8d37..14be0673f5b5 100644
> --- a/arch/riscv/include/asm/asm-extable.h
> +++ b/arch/riscv/include/asm/asm-extable.h
> @@ -5,6 +5,7 @@
>  #define EX_TYPE_NONE                   0
>  #define EX_TYPE_FIXUP                  1
>  #define EX_TYPE_BPF                    2
> +#define EX_TYPE_UACCESS_ERR_ZERO       3
>
>  #ifdef __ASSEMBLY__
>
> @@ -23,7 +24,9 @@
>
>  #else /* __ASSEMBLY__ */
>
> +#include <linux/bits.h>
>  #include <linux/stringify.h>
> +#include <asm/gpr-num.h>
>
>  #define __ASM_EXTABLE_RAW(insn, fixup, type, data)     \
>         ".pushsection   __ex_table, \"a\"\n"            \
> @@ -37,6 +40,26 @@
>  #define _ASM_EXTABLE(insn, fixup)      \
>         __ASM_EXTABLE_RAW(#insn, #fixup, __stringify(EX_TYPE_FIXUP), "0")
>
> +#define EX_DATA_REG_ERR_SHIFT  0
> +#define EX_DATA_REG_ERR                GENMASK(4, 0)
> +#define EX_DATA_REG_ZERO_SHIFT 5
> +#define EX_DATA_REG_ZERO       GENMASK(9, 5)
> +
> +#define EX_DATA_REG(reg, gpr)                                          \
> +       "((.L__gpr_num_" #gpr ") << " __stringify(EX_DATA_REG_##reg##_SHIFT) ")"
> +
> +#define _ASM_EXTABLE_UACCESS_ERR_ZERO(insn, fixup, err, zero)          \
> +       __DEFINE_ASM_GPR_NUMS                                           \
> +       __ASM_EXTABLE_RAW(#insn, #fixup,                                \
> +                         __stringify(EX_TYPE_UACCESS_ERR_ZERO),        \
> +                         "("                                           \
> +                           EX_DATA_REG(ERR, err) " | "                 \
> +                           EX_DATA_REG(ZERO, zero)                     \
> +                         ")")
> +
> +#define _ASM_EXTABLE_UACCESS_ERR(insn, fixup, err)                     \
> +       _ASM_EXTABLE_UACCESS_ERR_ZERO(insn, fixup, err, zero)
> +
>  #endif /* __ASSEMBLY__ */
>
>  #endif /* __ASM_ASM_EXTABLE_H */
> diff --git a/arch/riscv/include/asm/futex.h b/arch/riscv/include/asm/futex.h
> index 2e15e8e89502..fc8130f995c1 100644
> --- a/arch/riscv/include/asm/futex.h
> +++ b/arch/riscv/include/asm/futex.h
> @@ -21,20 +21,14 @@
>
>  #define __futex_atomic_op(insn, ret, oldval, uaddr, oparg)     \
>  {                                                              \
> -       uintptr_t tmp;                                          \
>         __enable_user_access();                                 \
>         __asm__ __volatile__ (                                  \
>         "1:     " insn "                                \n"     \
>         "2:                                             \n"     \
> -       "       .section .fixup,\"ax\"                  \n"     \
> -       "       .balign 4                               \n"     \
> -       "3:     li %[r],%[e]                            \n"     \
> -       "       jump 2b,%[t]                            \n"     \
> -       "       .previous                               \n"     \
> -               _ASM_EXTABLE(1b, 3b)                            \
> +       _ASM_EXTABLE_UACCESS_ERR(1b, 2b, %[r])                  \
>         : [r] "+r" (ret), [ov] "=&r" (oldval),                  \
> -         [u] "+m" (*uaddr), [t] "=&r" (tmp)                    \
> -       : [op] "Jr" (oparg), [e] "i" (-EFAULT)                  \
> +         [u] "+m" (*uaddr)                                     \
> +       : [op] "Jr" (oparg)                                     \
>         : "memory");                                            \
>         __disable_user_access();                                \
>  }
> @@ -96,15 +90,10 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
>         "2:     sc.w.aqrl %[t],%z[nv],%[u]              \n"
>         "       bnez %[t],1b                            \n"
>         "3:                                             \n"
> -       "       .section .fixup,\"ax\"                  \n"
> -       "       .balign 4                               \n"
> -       "4:     li %[r],%[e]                            \n"
> -       "       jump 3b,%[t]                            \n"
> -       "       .previous                               \n"
> -               _ASM_EXTABLE(1b, 4b)                    \
> -               _ASM_EXTABLE(2b, 4b)                    \
> +               _ASM_EXTABLE_UACCESS_ERR(1b, 3b, %[r])  \
> +               _ASM_EXTABLE_UACCESS_ERR(2b, 3b, %[r])  \
>         : [r] "+r" (ret), [v] "=&r" (val), [u] "+m" (*uaddr), [t] "=&r" (tmp)
> -       : [ov] "Jr" (oldval), [nv] "Jr" (newval), [e] "i" (-EFAULT)
> +       : [ov] "Jr" (oldval), [nv] "Jr" (newval)
>         : "memory");
>         __disable_user_access();
>
> diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
> index 40e6099af488..a4716c026386 100644
> --- a/arch/riscv/include/asm/uaccess.h
> +++ b/arch/riscv/include/asm/uaccess.h
> @@ -81,22 +81,14 @@ static inline int __access_ok(unsigned long addr, unsigned long size)
>
>  #define __get_user_asm(insn, x, ptr, err)                      \
>  do {                                                           \
> -       uintptr_t __tmp;                                        \
>         __typeof__(x) __x;                                      \
>         __asm__ __volatile__ (                                  \
>                 "1:\n"                                          \
> -               "       " insn " %1, %3\n"                      \
> +               "       " insn " %1, %2\n"                      \
>                 "2:\n"                                          \
> -               "       .section .fixup,\"ax\"\n"               \
> -               "       .balign 4\n"                            \
> -               "3:\n"                                          \
> -               "       li %0, %4\n"                            \
> -               "       li %1, 0\n"                             \
> -               "       jump 2b, %2\n"                          \
> -               "       .previous\n"                            \
> -                       _ASM_EXTABLE(1b, 3b)                    \
> -               : "+r" (err), "=&r" (__x), "=r" (__tmp)         \
> -               : "m" (*(ptr)), "i" (-EFAULT));                 \
> +               _ASM_EXTABLE_UACCESS_ERR_ZERO(1b, 2b, %0, %1)   \
> +               : "+r" (err), "=&r" (__x)                       \
> +               : "m" (*(ptr)));                                \
>         (x) = __x;                                              \
>  } while (0)
>
> @@ -108,27 +100,18 @@ do {                                                              \
>  do {                                                           \
>         u32 __user *__ptr = (u32 __user *)(ptr);                \
>         u32 __lo, __hi;                                         \
> -       uintptr_t __tmp;                                        \
>         __asm__ __volatile__ (                                  \
>                 "1:\n"                                          \
> -               "       lw %1, %4\n"                            \
> +               "       lw %1, %3\n"                            \
>                 "2:\n"                                          \
> -               "       lw %2, %5\n"                            \
> +               "       lw %2, %4\n"                            \
>                 "3:\n"                                          \
> -               "       .section .fixup,\"ax\"\n"               \
> -               "       .balign 4\n"                            \
> -               "4:\n"                                          \
> -               "       li %0, %6\n"                            \
> -               "       li %1, 0\n"                             \
> -               "       li %2, 0\n"                             \
> -               "       jump 3b, %3\n"                          \
> -               "       .previous\n"                            \
> -                       _ASM_EXTABLE(1b, 4b)                    \
> -                       _ASM_EXTABLE(2b, 4b)                    \
> -               : "+r" (err), "=&r" (__lo), "=r" (__hi),        \
> -                       "=r" (__tmp)                            \
> -               : "m" (__ptr[__LSW]), "m" (__ptr[__MSW]),       \
> -                       "i" (-EFAULT));                         \
> +               _ASM_EXTABLE_UACCESS_ERR_ZERO(1b, 3b, %0, %1)   \
> +               _ASM_EXTABLE_UACCESS_ERR_ZERO(2b, 3b, %0, %1)   \
> +               : "+r" (err), "=&r" (__lo), "=r" (__hi)         \
> +               : "m" (__ptr[__LSW]), "m" (__ptr[__MSW]))       \
> +       if (err)                                                \
> +               __hi = 0;                                       \
>         (x) = (__typeof__(x))((__typeof__((x)-(x)))(            \
>                 (((u64)__hi << 32) | __lo)));                   \
>  } while (0)
> @@ -216,21 +199,14 @@ do {                                                              \
>
>  #define __put_user_asm(insn, x, ptr, err)                      \
>  do {                                                           \
> -       uintptr_t __tmp;                                        \
>         __typeof__(*(ptr)) __x = x;                             \
>         __asm__ __volatile__ (                                  \
>                 "1:\n"                                          \
> -               "       " insn " %z3, %2\n"                     \
> +               "       " insn " %z2, %1\n"                     \
>                 "2:\n"                                          \
> -               "       .section .fixup,\"ax\"\n"               \
> -               "       .balign 4\n"                            \
> -               "3:\n"                                          \
> -               "       li %0, %4\n"                            \
> -               "       jump 2b, %1\n"                          \
> -               "       .previous\n"                            \
> -                       _ASM_EXTABLE(1b, 3b)                    \
> -               : "+r" (err), "=r" (__tmp), "=m" (*(ptr))       \
> -               : "rJ" (__x), "i" (-EFAULT));                   \
> +               _ASM_EXTABLE_UACCESS_ERR(1b, 2b, %0)            \
> +               : "+r" (err), "=m" (*(ptr))                     \
> +               : "rJ" (__x));                                  \
>  } while (0)
>
>  #ifdef CONFIG_64BIT
> @@ -244,22 +220,16 @@ do {                                                              \
>         uintptr_t __tmp;                                        \
>         __asm__ __volatile__ (                                  \
>                 "1:\n"                                          \
> -               "       sw %z4, %2\n"                           \
> +               "       sw %z3, %1\n"                           \
>                 "2:\n"                                          \
> -               "       sw %z5, %3\n"                           \
> +               "       sw %z4, %2\n"                           \
>                 "3:\n"                                          \
> -               "       .section .fixup,\"ax\"\n"               \
> -               "       .balign 4\n"                            \
> -               "4:\n"                                          \
> -               "       li %0, %6\n"                            \
> -               "       jump 3b, %1\n"                          \
> -               "       .previous\n"                            \
> -                       _ASM_EXTABLE(1b, 4b)                    \
> -                       _ASM_EXTABLE(2b, 4b)                    \
> -               : "+r" (err), "=r" (__tmp),                     \
> +               _ASM_EXTABLE_UACCESS_ERR(1b, 3b, %0)            \
> +               _ASM_EXTABLE_UACCESS_ERR(2b, 3b, %0)            \
> +               : "+r" (err),                                   \
>                         "=m" (__ptr[__LSW]),                    \
>                         "=m" (__ptr[__MSW])                     \
> -               : "rJ" (__x), "rJ" (__x >> 32), "i" (-EFAULT)); \
> +               : "rJ" (__x), "rJ" (__x >> 32));                \
>  } while (0)
>  #endif /* CONFIG_64BIT */
>
> diff --git a/arch/riscv/mm/extable.c b/arch/riscv/mm/extable.c
> index 91e52c4bb33a..05978f78579f 100644
> --- a/arch/riscv/mm/extable.c
> +++ b/arch/riscv/mm/extable.c
> @@ -7,10 +7,12 @@
>   */
>
>
> +#include <linux/bitfield.h>
>  #include <linux/extable.h>
>  #include <linux/module.h>
>  #include <linux/uaccess.h>
>  #include <asm/asm-extable.h>
> +#include <asm/ptrace.h>
>
>  static inline unsigned long
>  get_ex_fixup(const struct exception_table_entry *ex)
> @@ -25,6 +27,29 @@ static bool ex_handler_fixup(const struct exception_table_entry *ex,
>         return true;
>  }
>
> +static inline void regs_set_gpr(struct pt_regs *regs, unsigned int offset,
> +                               unsigned long val)
> +{
> +       if (unlikely(offset > MAX_REG_OFFSET))
> +               return;
> +
> +       if (!offset)
> +               *(unsigned long *)((unsigned long)regs + offset) = val;
> +}
> +
> +static bool ex_handler_uaccess_err_zero(const struct exception_table_entry *ex,
> +                                       struct pt_regs *regs)
> +{
> +       int reg_err = FIELD_GET(EX_DATA_REG_ERR, ex->data);
> +       int reg_zero = FIELD_GET(EX_DATA_REG_ZERO, ex->data);
> +
> +       regs_set_gpr(regs, reg_err, -EFAULT);
> +       regs_set_gpr(regs, reg_zero, 0);
> +
> +       regs->epc = get_ex_fixup(ex);
> +       return true;
> +}
> +
>  bool fixup_exception(struct pt_regs *regs)
>  {
>         const struct exception_table_entry *ex;
> @@ -38,6 +63,8 @@ bool fixup_exception(struct pt_regs *regs)
>                 return ex_handler_fixup(ex, regs);
>         case EX_TYPE_BPF:
>                 return ex_handler_bpf(ex, regs);
> +       case EX_TYPE_UACCESS_ERR_ZERO:
> +               return ex_handler_uaccess_err_zero(ex, regs);
>         }
>
>         BUG();
> --
> 2.33.0
>
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
