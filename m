Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C68E5D47E
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfGBQmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:42:47 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34459 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfGBQmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:42:47 -0400
Received: by mail-io1-f66.google.com with SMTP id k8so38599363iot.1;
        Tue, 02 Jul 2019 09:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s0ki2w+XK48wMx0rfPZcn3FzdkHo8iVXQA/GXa6Bu4c=;
        b=IAECKsXa8rZEI59VMz5awc5VBf7XAGhF5HXXpTWE42C3BJYL7wAJ8ml8YQxOB1aGWx
         6R3F81vPc+UbfrgUU+sQN+CWYB/S0JuuKPY1x3G1GdKwuUd+HQrS7pnXL0Vqxj+FNlXY
         9RSp4T/AjEI5EYgCuvnYc8j5/7ap9woZcIKchXO3xm0quZ2y1cOjLbqnu3CIv18J/TFZ
         sKhBS4gER3guwnE9TV9Bc/h/gJ4cogzU9/hN7ghvvYj20O/jNdyJB4QbrDDYaKGYHB6C
         fdiyEgOZYhdG7Zn/dVFYILCzjMpbxq0FY6utmWlsEYGi6EBYGDpefLD95CUVLC0ozJqM
         ec9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s0ki2w+XK48wMx0rfPZcn3FzdkHo8iVXQA/GXa6Bu4c=;
        b=sHEmWjZnyZzyrqRT6DL28nfY2KblrkoPZhuqloED9H379rv/yv2QaOpsXxAKjCRhdC
         HK9HZOS4970x28HJvveSKOiqB3sX9sP/OHJdKFwsIn7OB3C56vb4ChvMZLsaK9VX0LvO
         JnZAT5q4dvu3kdyXf/ccHjmxm5morAtR81eYsjXwH6Gkdw9+bqGfsNgqAf89Qg1xOVC2
         06VfPH2tgwoMOLfoKNuNDCqhYTPaGCR+G4AGxgwD16ORDWv5O4Ujzz1R36IZkbyG894H
         9ufhmdFOcaRzsoN/L4kOe0JFaY/OTZODSuGwMI4hhfgfWHkIe01LqtF6HwBi6sQu9Voc
         j3sg==
X-Gm-Message-State: APjAAAXCzUSysBpdvGNltc1Qp85oEKgKGTMuRSud+GO4lQFiQIVZWlKX
        0eFtJPI9IoXIhKwaU+DeWfqYh4+tTCbscCA63g7xZqoD
X-Google-Smtp-Source: APXvYqxfaZhVcerXp64gVYUn6cRQbkQnUo7+vb2H82DWQPSs22iCHeanWIqOBbvEnqLfpi9ZbBZFk+njYtQL0LsSbe4=
X-Received: by 2002:a5d:8f86:: with SMTP id l6mr5954450iol.97.1562085765720;
 Tue, 02 Jul 2019 09:42:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190702153908.41562-1-iii@linux.ibm.com>
In-Reply-To: <20190702153908.41562-1-iii@linux.ibm.com>
From:   Y Song <ys114321@gmail.com>
Date:   Tue, 2 Jul 2019 09:42:09 -0700
Message-ID: <CAH3MdRUk5x2D9yRuKpGpVuDMFF0JbYeB+Y0Qz6chtPgfm-1vxA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix compiling loop{1,2,3}.c on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 8:40 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> Use PT_REGS_RC(ctx) instead of ctx->rax, which is not present on s390.
>
> Pass -D__TARGET_ARCH_$(ARCH) to selftests in order to choose a proper
> PT_REGS_RC variant.
>
> Fix s930 -> s390 typo.
>
> On s390, provide the forward declaration of struct pt_regs and cast it
> to user_pt_regs in PT_REGS_* macros. This is necessary, because instead
> of the full struct pt_regs, s390 exposes only its first field
> user_pt_regs to userspace, and bpf_helpers.h is used with both userspace
> (in selftests) and kernel (in samples) headers.
>
> On x86, provide userspace versions of PT_REGS_* macros. Unlike s390, x86
> provides struct pt_regs to both userspace and kernel, however, with
> different field names.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>  tools/testing/selftests/bpf/Makefile      |  4 +-
>  tools/testing/selftests/bpf/bpf_helpers.h | 46 +++++++++++++++--------
>  tools/testing/selftests/bpf/progs/loop1.c |  2 +-
>  tools/testing/selftests/bpf/progs/loop2.c |  2 +-
>  tools/testing/selftests/bpf/progs/loop3.c |  2 +-
>  5 files changed, 37 insertions(+), 19 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index d60fee59fbd1..599b320bef65 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -1,5 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  include ../../../../scripts/Kbuild.include
> +include ../../../scripts/Makefile.arch
>
>  LIBDIR := ../../../lib
>  BPFDIR := $(LIBDIR)/bpf
> @@ -138,7 +139,8 @@ CLANG_SYS_INCLUDES := $(shell $(CLANG) -v -E - </dev/null 2>&1 \
>
>  CLANG_FLAGS = -I. -I./include/uapi -I../../../include/uapi \
>               $(CLANG_SYS_INCLUDES) \
> -             -Wno-compare-distinct-pointer-types
> +             -Wno-compare-distinct-pointer-types \
> +             -D__TARGET_ARCH_$(ARCH)
>
>  $(OUTPUT)/test_l4lb_noinline.o: CLANG_FLAGS += -fno-inline
>  $(OUTPUT)/test_xdp_noinline.o: CLANG_FLAGS += -fno-inline
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> index 1a5b1accf091..faf86d83301a 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -312,8 +312,8 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
>  #if defined(__TARGET_ARCH_x86)
>         #define bpf_target_x86
>         #define bpf_target_defined
> -#elif defined(__TARGET_ARCH_s930x)
> -       #define bpf_target_s930x
> +#elif defined(__TARGET_ARCH_s390)
> +       #define bpf_target_s390
>         #define bpf_target_defined
>  #elif defined(__TARGET_ARCH_arm)
>         #define bpf_target_arm
> @@ -338,8 +338,8 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
>  #ifndef bpf_target_defined
>  #if defined(__x86_64__)
>         #define bpf_target_x86
> -#elif defined(__s390x__)
> -       #define bpf_target_s930x

I see in some other places (e.g., bcc) where
macro __s390x__ is also used to indicate a s390 architecture.
Could you explain the difference between __s390__ and
__s390x__?

> +#elif defined(__s390__)
> +       #define bpf_target_s390
>  #elif defined(__arm__)
>         #define bpf_target_arm
>  #elif defined(__aarch64__)
> @@ -355,6 +355,7 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
>
>  #if defined(bpf_target_x86)
>
> +#ifdef __KERNEL__

In samples/bpf/,  __KERNEL__ is defined at clang options and
in selftests/bpf/, the __KERNEL__ is not defined.

I checked x86 pt_regs definition with and without __KERNEL__.
They are identical except some register name difference.
I am wondering whether we can unify into all without
__KERNEL__. Is __KERNEL__ really needed?

>  #define PT_REGS_PARM1(x) ((x)->di)
>  #define PT_REGS_PARM2(x) ((x)->si)
>  #define PT_REGS_PARM3(x) ((x)->dx)
> @@ -365,19 +366,34 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
>  #define PT_REGS_RC(x) ((x)->ax)
>  #define PT_REGS_SP(x) ((x)->sp)
>  #define PT_REGS_IP(x) ((x)->ip)
> +#else
> +#define PT_REGS_PARM1(x) ((x)->rdi)
> +#define PT_REGS_PARM2(x) ((x)->rsi)
> +#define PT_REGS_PARM3(x) ((x)->rdx)
> +#define PT_REGS_PARM4(x) ((x)->rcx)
> +#define PT_REGS_PARM5(x) ((x)->r8)
> +#define PT_REGS_RET(x) ((x)->rsp)
> +#define PT_REGS_FP(x) ((x)->rbp)
> +#define PT_REGS_RC(x) ((x)->rax)
> +#define PT_REGS_SP(x) ((x)->rsp)
> +#define PT_REGS_IP(x) ((x)->rip)
> +#endif
>
> -#elif defined(bpf_target_s390x)
> +#elif defined(bpf_target_s390)
>
> -#define PT_REGS_PARM1(x) ((x)->gprs[2])
> -#define PT_REGS_PARM2(x) ((x)->gprs[3])
> -#define PT_REGS_PARM3(x) ((x)->gprs[4])
> -#define PT_REGS_PARM4(x) ((x)->gprs[5])
> -#define PT_REGS_PARM5(x) ((x)->gprs[6])
> -#define PT_REGS_RET(x) ((x)->gprs[14])
> -#define PT_REGS_FP(x) ((x)->gprs[11]) /* Works only with CONFIG_FRAME_POINTER */
> -#define PT_REGS_RC(x) ((x)->gprs[2])
> -#define PT_REGS_SP(x) ((x)->gprs[15])
> -#define PT_REGS_IP(x) ((x)->psw.addr)
> +/* s390 provides user_pt_regs instead of struct pt_regs to userspace */
> +struct pt_regs;
> +#define PT_REGS_PARM1(x) (((const volatile user_pt_regs *)(x))->gprs[2])
> +#define PT_REGS_PARM2(x) (((const volatile user_pt_regs *)(x))->gprs[3])
> +#define PT_REGS_PARM3(x) (((const volatile user_pt_regs *)(x))->gprs[4])
> +#define PT_REGS_PARM4(x) (((const volatile user_pt_regs *)(x))->gprs[5])
> +#define PT_REGS_PARM5(x) (((const volatile user_pt_regs *)(x))->gprs[6])
> +#define PT_REGS_RET(x) (((const volatile user_pt_regs *)(x))->gprs[14])
> +/* Works only with CONFIG_FRAME_POINTER */
> +#define PT_REGS_FP(x) (((const volatile user_pt_regs *)(x))->gprs[11])
> +#define PT_REGS_RC(x) (((const volatile user_pt_regs *)(x))->gprs[2])
> +#define PT_REGS_SP(x) (((const volatile user_pt_regs *)(x))->gprs[15])
> +#define PT_REGS_IP(x) (((const volatile user_pt_regs *)(x))->psw.addr)

Is user_pt_regs a recent change or has been there for quite some time?
I am asking since bcc did not use user_pt_regs yet.

>
>  #elif defined(bpf_target_arm)
>
> diff --git a/tools/testing/selftests/bpf/progs/loop1.c b/tools/testing/selftests/bpf/progs/loop1.c
> index dea395af9ea9..7cdb7f878310 100644
> --- a/tools/testing/selftests/bpf/progs/loop1.c
> +++ b/tools/testing/selftests/bpf/progs/loop1.c
> @@ -18,7 +18,7 @@ int nested_loops(volatile struct pt_regs* ctx)
>         for (j = 0; j < 300; j++)
>                 for (i = 0; i < j; i++) {
>                         if (j & 1)
> -                               m = ctx->rax;
> +                               m = PT_REGS_RC(ctx);
>                         else
>                                 m = j;
>                         sum += i * m;
> diff --git a/tools/testing/selftests/bpf/progs/loop2.c b/tools/testing/selftests/bpf/progs/loop2.c
> index 0637bd8e8bcf..9b2f808a2863 100644
> --- a/tools/testing/selftests/bpf/progs/loop2.c
> +++ b/tools/testing/selftests/bpf/progs/loop2.c
> @@ -16,7 +16,7 @@ int while_true(volatile struct pt_regs* ctx)
>         int i = 0;
>
>         while (true) {
> -               if (ctx->rax & 1)
> +               if (PT_REGS_RC(ctx) & 1)
>                         i += 3;
>                 else
>                         i += 7;
> diff --git a/tools/testing/selftests/bpf/progs/loop3.c b/tools/testing/selftests/bpf/progs/loop3.c
> index 30a0f6cba080..d727657d51e2 100644
> --- a/tools/testing/selftests/bpf/progs/loop3.c
> +++ b/tools/testing/selftests/bpf/progs/loop3.c
> @@ -16,7 +16,7 @@ int while_true(volatile struct pt_regs* ctx)
>         __u64 i = 0, sum = 0;
>         do {
>                 i++;
> -               sum += ctx->rax;
> +               sum += PT_REGS_RC(ctx);
>         } while (i < 0x100000000ULL);
>         return sum;
>  }
> --
> 2.21.0
>
