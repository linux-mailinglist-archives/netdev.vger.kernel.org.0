Return-Path: <netdev+bounces-11534-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C626B7337F1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08BE5281830
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 395DA1DCB6;
	Fri, 16 Jun 2023 18:14:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D1019E69;
	Fri, 16 Jun 2023 18:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE44C43391;
	Fri, 16 Jun 2023 18:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686939285;
	bh=BGYZV1Km+8ZgDrE9neT/E0fU3u3ixvSh8AYCC3TbmE4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MRdJy0RgrSJF59KF/EC7N3hN4NM7JkZeq3KagnV0DWy1PIpTqhhanwN+rGe8zgC2V
	 MRnDgp8J0NexGL29v4Mucemw/3yZahpXPMUqiEhZDo6PLZ3uYpYsxd3ZL1fbGvwWwe
	 p/R8vyd2pT+khqUskQVZmRQf+jE0REJ8n2qSSkUm6kasMtDdPJCEzuxpbIe8qI0/Ui
	 gBxANtpHkUielBt2ehqqh3PqnGUAKKbbWba+orljx4X0xezuIPakLsTrSk3Gr6J6ZG
	 8yTxdvadfsX9qXvWVMaa8ZKkExpaD1sIFaCwY2WSngDPZW1skSPKVqWoP3yaiF1YJ9
	 Nln3oL3E93qMg==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-4f62b512fe2so1433702e87.1;
        Fri, 16 Jun 2023 11:14:45 -0700 (PDT)
X-Gm-Message-State: AC+VfDxwQUWCu6tmRoI+BsvqbJNP5p7Fj2QoKu4gc46NnqER1XFteijC
	BIY2SecOEQhYFc9tPP49acRIW8YocA8eJ488Vkw=
X-Google-Smtp-Source: ACHHUZ76yiO622Uh9+9rKEsm8ImEC4jXzUaBUsNUHgrPnEQ5V1l0GL/PgIuvK/efbFnHaYtpj3eltn1zagg/5cT90Eo=
X-Received: by 2002:a19:ab11:0:b0:4f3:bbfe:db4e with SMTP id
 u17-20020a19ab11000000b004f3bbfedb4emr1747329lfe.56.1686939283176; Fri, 16
 Jun 2023 11:14:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230616085038.4121892-1-rppt@kernel.org> <20230616085038.4121892-2-rppt@kernel.org>
In-Reply-To: <20230616085038.4121892-2-rppt@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 16 Jun 2023 11:14:31 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4nDne7L=Qh142w+dMX2pqM_4k+SZSB=QBJ8ruG_j8dug@mail.gmail.com>
Message-ID: <CAPhsuW4nDne7L=Qh142w+dMX2pqM_4k+SZSB=QBJ8ruG_j8dug@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] nios2: define virtual address space for modules
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
> nios2 uses kmalloc() to implement module_alloc() because CALL26/PCREL26
> cannot reach all of vmalloc address space.
>
> Define module space as 32MiB below the kernel base and switch nios2 to
> use vmalloc for module allocations.
>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
> Acked-by: Dinh Nguyen <dinguyen@kernel.org>

Acked-by: Song Liu <song@kernel.org>


> ---
>  arch/nios2/include/asm/pgtable.h |  5 ++++-
>  arch/nios2/kernel/module.c       | 19 ++++---------------
>  2 files changed, 8 insertions(+), 16 deletions(-)
>
> diff --git a/arch/nios2/include/asm/pgtable.h b/arch/nios2/include/asm/pg=
table.h
> index 0f5c2564e9f5..0073b289c6a4 100644
> --- a/arch/nios2/include/asm/pgtable.h
> +++ b/arch/nios2/include/asm/pgtable.h
> @@ -25,7 +25,10 @@
>  #include <asm-generic/pgtable-nopmd.h>
>
>  #define VMALLOC_START          CONFIG_NIOS2_KERNEL_MMU_REGION_BASE
> -#define VMALLOC_END            (CONFIG_NIOS2_KERNEL_REGION_BASE - 1)
> +#define VMALLOC_END            (CONFIG_NIOS2_KERNEL_REGION_BASE - SZ_32M=
 - 1)
> +
> +#define MODULES_VADDR          (CONFIG_NIOS2_KERNEL_REGION_BASE - SZ_32M=
)
> +#define MODULES_END            (CONFIG_NIOS2_KERNEL_REGION_BASE - 1)
>
>  struct mm_struct;
>
> diff --git a/arch/nios2/kernel/module.c b/arch/nios2/kernel/module.c
> index 76e0a42d6e36..9c97b7513853 100644
> --- a/arch/nios2/kernel/module.c
> +++ b/arch/nios2/kernel/module.c
> @@ -21,23 +21,12 @@
>
>  #include <asm/cacheflush.h>
>
> -/*
> - * Modules should NOT be allocated with kmalloc for (obvious) reasons.
> - * But we do it for now to avoid relocation issues. CALL26/PCREL26 canno=
t reach
> - * from 0x80000000 (vmalloc area) to 0xc00000000 (kernel) (kmalloc retur=
ns
> - * addresses in 0xc0000000)
> - */
>  void *module_alloc(unsigned long size)
>  {
> -       if (size =3D=3D 0)
> -               return NULL;
> -       return kmalloc(size, GFP_KERNEL);
> -}
> -
> -/* Free memory returned from module_alloc */
> -void module_memfree(void *module_region)
> -{
> -       kfree(module_region);
> +       return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
> +                                   GFP_KERNEL, PAGE_KERNEL_EXEC,
> +                                   VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
> +                                   __builtin_return_address(0));
>  }
>
>  int apply_relocate_add(Elf32_Shdr *sechdrs, const char *strtab,
> --
> 2.35.1
>

