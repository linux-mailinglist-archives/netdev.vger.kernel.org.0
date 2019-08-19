Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE5C894C3D
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 20:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbfHSR7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:59:45 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37912 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbfHSR7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 13:59:45 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so9661745wrr.5;
        Mon, 19 Aug 2019 10:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=CuXX/eaXDYLAgDccWkYi0yxUiNmU914Hix0kLzwUtik=;
        b=pbaWq+OV84Fx98IyRD3zoJDFNe39J5QFmsxDrl+IMVG5S6nbR54dk5eU06QkbYsq1S
         3QDZSkcUS707A1mfDztBrdhsqQPcGnkiDmaHOSh51gbDtVWRKXIKSu9uiGirWUgDl/vh
         pcM3zKEE7cATeth4e08RnXzFYVyYU7mxW+U7DOZ7S4rb77gHPjG/3gP4ZPdf9mu7imSD
         27wrgDvq11+lC69vMncvOwHoOmp5n0bpObyaZ8CFId4jQ6H6uKkrHF7x3ICPEshUdOBl
         ovONdsCg3o10iVlNjb4f2hfgofvrNAy0/HqvMeIP993m6kENsJUO4q1vh3DZnwdJq0+A
         zfvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=CuXX/eaXDYLAgDccWkYi0yxUiNmU914Hix0kLzwUtik=;
        b=IETQOcuR15JYRWqSayaB8McMB4JEMlZi8GjqOTaOnZmSmDbkdq0ckS7DaVEpCel0HP
         WMxDS0CB+yQUW0cUIC9C7RKa8AdzeO8RLQBV/mrtt15XXiLrEj6DJ7ORm8//04aXWBK1
         BNA8RfCKuaacEetWemKafHWpCXJCf4wcvnSGhR7pjXbgcOkRZiVch/vMdaJZsjGrvORi
         pMDuhla8aN+HF6ya/BQg0a1PPjS+j/OEcVEnkhvD2LjM6N/6vZld1JpvyA/KpNvEdtWf
         xCGVegQ7rYqYzbsYrhScHH+SE6SQ19ZJHiLpgErTDPMw8i7aWr1GV5quIvos5pXccAVe
         9QdA==
X-Gm-Message-State: APjAAAU5uIaGAGbggynU8iJ6MTx2q1VBh9Do7FxyVptom9ThciKh1jm1
        pVeHM7PgcJeYKdYCPWmZ4IjMsAHTETs3ZDNumdc=
X-Google-Smtp-Source: APXvYqws8qrsFQjqjCSitgABIltDk2Wvltok0zZSC0b7etxSAovgdekR9/Be4GA3x0ceNb6mtn/TJgT8CYbQLhwBxLM=
X-Received: by 2002:a5d:69c8:: with SMTP id s8mr27547794wrw.353.1566237581965;
 Mon, 19 Aug 2019 10:59:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com> <20190812215052.71840-11-ndesaulniers@google.com>
In-Reply-To: <20190812215052.71840-11-ndesaulniers@google.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 19 Aug 2019 19:59:29 +0200
Message-ID: <CA+icZUX=BPPH7rH13OkDzmc1L42hxcWDw+c_G7sf7G8wcHiPAQ@mail.gmail.com>
Subject: Re: [PATCH 11/16] x86: prefer __section from compiler_attributes.h
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     akpm@linux-foundation.org, jpoimboe@redhat.com, yhs@fb.com,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Armijn Hemel <armijn@tjaldur.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Juergen Gross <jgross@suse.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Enrico Weigelt <info@metux.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Hannes Reinecke <hare@suse.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Pu Wen <puwen@hygon.cn>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 11:52 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com> [ Linux v5.3-rc5 ]

Patchset "for-5.3/x86-section-name-escaping":

include/linux/compiler.h: remove unused KENTRY macro
include/linux: prefer __section from compiler_attributes.h
include/asm-generic: prefer __section from compiler_attributes.h
x86: prefer __section from compiler_attributes.h

Thanks.

- Sedat -

> ---
>  arch/x86/include/asm/cache.h       | 2 +-
>  arch/x86/include/asm/intel-mid.h   | 2 +-
>  arch/x86/include/asm/iommu_table.h | 5 ++---
>  arch/x86/include/asm/irqflags.h    | 2 +-
>  arch/x86/include/asm/mem_encrypt.h | 2 +-
>  arch/x86/kernel/cpu/cpu.h          | 3 +--
>  6 files changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/include/asm/cache.h b/arch/x86/include/asm/cache.h
> index abe08690a887..bb9f4bf4ec02 100644
> --- a/arch/x86/include/asm/cache.h
> +++ b/arch/x86/include/asm/cache.h
> @@ -8,7 +8,7 @@
>  #define L1_CACHE_SHIFT (CONFIG_X86_L1_CACHE_SHIFT)
>  #define L1_CACHE_BYTES (1 << L1_CACHE_SHIFT)
>
> -#define __read_mostly __attribute__((__section__(".data..read_mostly")))
> +#define __read_mostly __section(.data..read_mostly)
>
>  #define INTERNODE_CACHE_SHIFT CONFIG_X86_INTERNODE_CACHE_SHIFT
>  #define INTERNODE_CACHE_BYTES (1 << INTERNODE_CACHE_SHIFT)
> diff --git a/arch/x86/include/asm/intel-mid.h b/arch/x86/include/asm/intel-mid.h
> index 8e5af119dc2d..f51f04aefe1b 100644
> --- a/arch/x86/include/asm/intel-mid.h
> +++ b/arch/x86/include/asm/intel-mid.h
> @@ -43,7 +43,7 @@ struct devs_id {
>
>  #define sfi_device(i)                                                          \
>         static const struct devs_id *const __intel_mid_sfi_##i##_dev __used     \
> -       __attribute__((__section__(".x86_intel_mid_dev.init"))) = &i
> +       __section(.x86_intel_mid_dev.init) = &i
>
>  /**
>  * struct mid_sd_board_info - template for SD device creation
> diff --git a/arch/x86/include/asm/iommu_table.h b/arch/x86/include/asm/iommu_table.h
> index 1fb3fd1a83c2..7d190710eb92 100644
> --- a/arch/x86/include/asm/iommu_table.h
> +++ b/arch/x86/include/asm/iommu_table.h
> @@ -50,9 +50,8 @@ struct iommu_table_entry {
>
>  #define __IOMMU_INIT(_detect, _depend, _early_init, _late_init, _finish)\
>         static const struct iommu_table_entry                           \
> -               __iommu_entry_##_detect __used                          \
> -       __attribute__ ((unused, __section__(".iommu_table"),            \
> -                       aligned((sizeof(void *)))))     \
> +               __iommu_entry_##_detect __used __section(.iommu_table)  \
> +               __aligned((sizeof(void *)))                             \
>         = {_detect, _depend, _early_init, _late_init,                   \
>            _finish ? IOMMU_FINISH_IF_DETECTED : 0}
>  /*
> diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
> index 8a0e56e1dcc9..68db90bca813 100644
> --- a/arch/x86/include/asm/irqflags.h
> +++ b/arch/x86/include/asm/irqflags.h
> @@ -9,7 +9,7 @@
>  #include <asm/nospec-branch.h>
>
>  /* Provide __cpuidle; we can't safely include <linux/cpu.h> */
> -#define __cpuidle __attribute__((__section__(".cpuidle.text")))
> +#define __cpuidle __section(.cpuidle.text)
>
>  /*
>   * Interrupt control:
> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 0c196c47d621..db2cd3709148 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -50,7 +50,7 @@ void __init mem_encrypt_free_decrypted_mem(void);
>  bool sme_active(void);
>  bool sev_active(void);
>
> -#define __bss_decrypted __attribute__((__section__(".bss..decrypted")))
> +#define __bss_decrypted __section(.bss..decrypted)
>
>  #else  /* !CONFIG_AMD_MEM_ENCRYPT */
>
> diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
> index c0e2407abdd6..7ff9dc41a603 100644
> --- a/arch/x86/kernel/cpu/cpu.h
> +++ b/arch/x86/kernel/cpu/cpu.h
> @@ -38,8 +38,7 @@ struct _tlb_table {
>
>  #define cpu_dev_register(cpu_devX) \
>         static const struct cpu_dev *const __cpu_dev_##cpu_devX __used \
> -       __attribute__((__section__(".x86_cpu_dev.init"))) = \
> -       &cpu_devX;
> +       __section(.x86_cpu_dev.init) = &cpu_devX;
>
>  extern const struct cpu_dev *const __x86_cpu_dev_start[],
>                             *const __x86_cpu_dev_end[];
> --
> 2.23.0.rc1.153.gdeed80330f-goog
>
