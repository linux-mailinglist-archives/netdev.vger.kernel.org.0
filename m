Return-Path: <netdev+bounces-11550-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1346E733884
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:56:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F232E1C2100F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A3C31DCA8;
	Fri, 16 Jun 2023 18:56:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DA4101F6;
	Fri, 16 Jun 2023 18:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0600CC433CA;
	Fri, 16 Jun 2023 18:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686941784;
	bh=TiK/t/XTSx2fh8UkKw1baZqCETUm1DZqQZdzQBTpc/g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DR8ZwzCHVtydoaaxjVYJNAWu/EazGdygIZ9Srkd4r4zGNu0UV5wrYj4MX5arzEodp
	 UNvhvBrh5U4xGmDl5sewm5lcUokl1lD7VTeAPUPHyzYKCOX5F7Je9AJgJ0HqJqpHT2
	 dLMHymuA0MzirGgPHvlvL6U36HV4H2mHBFM4sA3+uLQ6uro16QwzRETHZvWuu01q0L
	 oEQm2Ghzu8fuJWG7gSLOHi6X72YNM+NGXR0jzbSIhti31b9mqhQFKwVaQG4h1o8jl3
	 sPN9LHTye4cTeZayTOrwNQq2w+QcnqfrU6lZ/h2mtxqSWd8YF98VAdngnnwpTSEIq6
	 2Cv/9seiufkYQ==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2b34ac4b6e8so14417851fa.3;
        Fri, 16 Jun 2023 11:56:23 -0700 (PDT)
X-Gm-Message-State: AC+VfDzYuAZcLOCMG9gxJLJk5d7+npTPr693R2ZIBJxFSaFSsBVz1CnI
	48m7nnhCmgGxGu0KlGNg75W592/tozMEEC1sXZc=
X-Google-Smtp-Source: ACHHUZ5T8e7wpuuhOjnmCbHsB2+OgDZlJJ7sUOEWS0dN9xCa2iZ6+8btSZBMXNDx9vhO1lFKVvsg0dPvz5VmaKvg8Zw=
X-Received: by 2002:a2e:80c2:0:b0:2b2:f9c8:6ad1 with SMTP id
 r2-20020a2e80c2000000b002b2f9c86ad1mr2553844ljg.42.1686941782011; Fri, 16 Jun
 2023 11:56:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230616085038.4121892-1-rppt@kernel.org> <20230616085038.4121892-6-rppt@kernel.org>
In-Reply-To: <20230616085038.4121892-6-rppt@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 16 Jun 2023 11:56:09 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7qEEbyEBUPETHxMj+Kusow5zTk3Q4cRNo0qV+quUsZNA@mail.gmail.com>
Message-ID: <CAPhsuW7qEEbyEBUPETHxMj+Kusow5zTk3Q4cRNo0qV+quUsZNA@mail.gmail.com>
Subject: Re: [PATCH v2 05/12] modules, execmem: drop module_alloc
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	"David S. Miller" <davem@davemloft.net>, Dinh Nguyen <dinguyen@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Luis Chamberlain <mcgrof@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nadav Amit <nadav.amit@gmail.com>, "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Puranjay Mohan <puranjay12@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Russell King <linux@armlinux.org.uk>, 
	Steven Rostedt <rostedt@goodmis.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>, bpf@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-mm@kvack.org, linux-modules@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, 
	netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 16, 2023 at 1:51=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> From: "Mike Rapoport (IBM)" <rppt@kernel.org>
>
> Define default parameters for address range for code allocations using
> the current values in module_alloc() and make execmem_text_alloc() use
> these defaults when an architecure does not supply its specific
> parameters.
>
> With this, execmem_text_alloc() implements memory allocation in a way
> compatible with module_alloc() and can be used as a replacement for
> module_alloc().
>
> Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>

Acked-by: Song Liu <song@kernel.org>

> ---
>  include/linux/execmem.h      |  8 ++++++++
>  include/linux/moduleloader.h | 12 ------------
>  kernel/module/main.c         |  7 -------
>  mm/execmem.c                 | 12 ++++++++----
>  4 files changed, 16 insertions(+), 23 deletions(-)
>
> diff --git a/include/linux/execmem.h b/include/linux/execmem.h
> index 68b2bfc79993..b9a97fcdf3c5 100644
> --- a/include/linux/execmem.h
> +++ b/include/linux/execmem.h
> @@ -4,6 +4,14 @@
>
>  #include <linux/types.h>
>
> +#if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && =
\
> +               !defined(CONFIG_KASAN_VMALLOC)
> +#include <linux/kasan.h>
> +#define MODULE_ALIGN (PAGE_SIZE << KASAN_SHADOW_SCALE_SHIFT)
> +#else
> +#define MODULE_ALIGN PAGE_SIZE
> +#endif
> +
>  /**
>   * struct execmem_range - definition of a memory range suitable for code=
 and
>   *                       related data allocations
> diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
> index b3374342f7af..4321682fe849 100644
> --- a/include/linux/moduleloader.h
> +++ b/include/linux/moduleloader.h
> @@ -25,10 +25,6 @@ int module_frob_arch_sections(Elf_Ehdr *hdr,
>  /* Additional bytes needed by arch in front of individual sections */
>  unsigned int arch_mod_section_prepend(struct module *mod, unsigned int s=
ection);
>
> -/* Allocator used for allocating struct module, core sections and init
> -   sections.  Returns NULL on failure. */
> -void *module_alloc(unsigned long size);
> -
>  /* Determines if the section name is an init section (that is only used =
during
>   * module loading).
>   */
> @@ -113,12 +109,4 @@ void module_arch_cleanup(struct module *mod);
>  /* Any cleanup before freeing mod->module_init */
>  void module_arch_freeing_init(struct module *mod);
>
> -#if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && =
\
> -               !defined(CONFIG_KASAN_VMALLOC)
> -#include <linux/kasan.h>
> -#define MODULE_ALIGN (PAGE_SIZE << KASAN_SHADOW_SCALE_SHIFT)
> -#else
> -#define MODULE_ALIGN PAGE_SIZE
> -#endif
> -
>  #endif
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index 43810a3bdb81..b445c5ad863a 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -1600,13 +1600,6 @@ static void free_modinfo(struct module *mod)
>         }
>  }
>
> -void * __weak module_alloc(unsigned long size)
> -{
> -       return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
> -                       GFP_KERNEL, PAGE_KERNEL_EXEC, VM_FLUSH_RESET_PERM=
S,
> -                       NUMA_NO_NODE, __builtin_return_address(0));
> -}
> -
>  bool __weak module_init_section(const char *name)
>  {
>         return strstarts(name, ".init");
> diff --git a/mm/execmem.c b/mm/execmem.c
> index 2fe36dcc7bdf..a67acd75ffef 100644
> --- a/mm/execmem.c
> +++ b/mm/execmem.c
> @@ -59,9 +59,6 @@ void *execmem_text_alloc(size_t size)
>         unsigned long fallback_end =3D execmem_params.modules.text.fallba=
ck_end;
>         bool kasan =3D execmem_params.modules.flags & EXECMEM_KASAN_SHADO=
W;
>
> -       if (!execmem_params.modules.text.start)
> -               return module_alloc(size);
> -
>         return execmem_alloc(size, start, end, align, pgprot,
>                              fallback_start, fallback_end, kasan);
>  }
> @@ -108,8 +105,15 @@ void __init execmem_init(void)
>  {
>         struct execmem_params *p =3D execmem_arch_params();
>
> -       if (!p)
> +       if (!p) {
> +               p =3D &execmem_params;
> +               p->modules.text.start =3D VMALLOC_START;
> +               p->modules.text.end =3D VMALLOC_END;
> +               p->modules.text.pgprot =3D PAGE_KERNEL_EXEC;
> +               p->modules.text.alignment =3D 1;
> +
>                 return;
> +       }
>
>         if (!execmem_validate_params(p))
>                 return;
> --
> 2.35.1
>

