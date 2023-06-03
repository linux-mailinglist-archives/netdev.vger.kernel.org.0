Return-Path: <netdev+bounces-7724-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92B6372130F
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 23:12:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19D9C1C20A7F
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 21:12:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89C4B101C6;
	Sat,  3 Jun 2023 21:12:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72672FC1B;
	Sat,  3 Jun 2023 21:12:06 +0000 (UTC)
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD72BB;
	Sat,  3 Jun 2023 14:12:04 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2b1adf27823so24651281fa.2;
        Sat, 03 Jun 2023 14:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685826722; x=1688418722;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ywQUs5Fiz0nF2jpbvNI9hUxAw7fBwSlpxtNbhNWOdKQ=;
        b=RDS3HF6Dzg4udc+gzR1ge+A8FipEjdhBSdULq7dQD2UyV6dgjBvuZgGerD6vUs2YSm
         VDnqI9KNtr2Dk7Dcagvb3z7MHB6yFn9dZVHE0avEHhNOnZSxu+haoNYcH+DbvcdZqhp2
         V/2FcSs+Og/LSo+4chvosoksvs7WCJCCw38bmEWjYWWbCKP1NNCl8K5ura9Sf0w8P5PP
         7V+264OxyeQzdq0h0Oa1oSNUiGbjJiqkYN3172ascXs+vGBmB8K0oc564ajmaECysFRA
         O+qDRdpmwpV7013SWgjBPZmxYgAbk4/aYxoKzE2wIVyrPNGanFSOTGWVNORuh+LwDAsi
         f1HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685826722; x=1688418722;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ywQUs5Fiz0nF2jpbvNI9hUxAw7fBwSlpxtNbhNWOdKQ=;
        b=SZAv6c4aEnU02IE7CLZ8gHKXfgocaKwfYW8xNd2Tg/U1hiMdCbDyTdnyJKJWLdF8ur
         XOhFxx1ebz7Lr31gpWiQqqRKDaMWm52AIObIoJN6WI1Opuw9KJFVc2+Li0rDlq48b8bj
         q4NBELVRWYCT1NIASZ5e3PBIM7Rf2BBWdtCUfXfl3okBybupaDrXU6/UwoXgYCIFLW8n
         c5gBt8WdPpHBwvW0fYwQmpH4BNp4eUDJ9mpGoSC26M+syKgzeu5J3CTrkxbFwK5axm29
         xLN/1/Zy77TSFQ1jfumRsDF6xf7Ay56Wn3gR09WrHFHVqt/GQfrm/uOUzBdUC3qpDV6p
         96mg==
X-Gm-Message-State: AC+VfDyWAOA4NWGVIe6Bpj+KGKL7Pzyu89UrESEMkJhez6irL3NDAsud
	xfJ/GYLxQIU96go4dlO2vG78Kb1TVV0DCpPgt75j0KwXfjTzXHnjND0=
X-Google-Smtp-Source: ACHHUZ7QpjsIySl/XiT4DfbanAj3JM5KVAqgA/T1nohoUOzVT96eBA8GwqXTmRgv+kLRpCQJ8cFP5VM7V3QLXDceJ3I=
X-Received: by 2002:a2e:88d6:0:b0:2a7:b986:3481 with SMTP id
 a22-20020a2e88d6000000b002a7b9863481mr1909233ljk.41.1685826722179; Sat, 03
 Jun 2023 14:12:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601101257.530867-1-rppt@kernel.org> <ZHjDU/mxE+cugpLj@FVFF77S0Q05N.cambridge.arm.com>
 <ZHjgIH3aX9dCvVZc@moria.home.lan> <ZHm3zUUbwqlsZBBF@FVFF77S0Q05N> <CAPhsuW7Euczff_KB70nuH=Hhf2EYHAf=xiQR7mFqVfByhD34XA@mail.gmail.com>
In-Reply-To: <CAPhsuW7Euczff_KB70nuH=Hhf2EYHAf=xiQR7mFqVfByhD34XA@mail.gmail.com>
From: Puranjay Mohan <puranjay12@gmail.com>
Date: Sat, 3 Jun 2023 23:11:51 +0200
Message-ID: <CANk7y0jtFA4sKgh2o2gAydLNzOxfZ0r3LVRuzzTGS8Qv0BuJGg@mail.gmail.com>
Subject: Re: [PATCH 00/13] mm: jit/text allocator
To: Song Liu <song@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, "David S. Miller" <davem@davemloft.net>, 
	Dinh Nguyen <dinguyen@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, 
	Huacai Chen <chenhuacai@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Russell King <linux@armlinux.org.uk>, 
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 8:21=E2=80=AFPM Song Liu <song@kernel.org> wrote:
>
> On Fri, Jun 2, 2023 at 2:35=E2=80=AFAM Mark Rutland <mark.rutland@arm.com=
> wrote:
> >
> > On Thu, Jun 01, 2023 at 02:14:56PM -0400, Kent Overstreet wrote:
> > > On Thu, Jun 01, 2023 at 05:12:03PM +0100, Mark Rutland wrote:
> > > > For a while I have wanted to give kprobes its own allocator so that=
 it can work
> > > > even with CONFIG_MODULES=3Dn, and so that it doesn't have to waste =
VA space in
> > > > the modules area.
> > > >
> > > > Given that, I think these should have their own allocator functions=
 that can be
> > > > provided independently, even if those happen to use common infrastr=
ucture.
> > >
> > > How much memory can kprobes conceivably use? I think we also want to =
try
> > > to push back on combinatorial new allocators, if we can.
> >
> > That depends on who's using it, and how (e.g. via BPF).
> >
> > To be clear, I'm not necessarily asking for entirely different allocato=
rs, but
> > I do thinkg that we want wrappers that can at least pass distinct start=
+end
> > parameters to a common allocator, and for arm64's modules code I'd expe=
ct that
> > we'd keep the range falblack logic out of the common allcoator, and jus=
t call
> > it twice.
> >
> > > > > Several architectures override module_alloc() because of various
> > > > > constraints where the executable memory can be located and this c=
auses
> > > > > additional obstacles for improvements of code allocation.
> > > > >
> > > > > This set splits code allocation from modules by introducing
> > > > > jit_text_alloc(), jit_data_alloc() and jit_free() APIs, replaces =
call
> > > > > sites of module_alloc() and module_memfree() with the new APIs an=
d
> > > > > implements core text and related allocation in a central place.
> > > > >
> > > > > Instead of architecture specific overrides for module_alloc(), th=
e
> > > > > architectures that require non-default behaviour for text allocat=
ion must
> > > > > fill jit_alloc_params structure and implement jit_alloc_arch_para=
ms() that
> > > > > returns a pointer to that structure. If an architecture does not =
implement
> > > > > jit_alloc_arch_params(), the defaults compatible with the current
> > > > > modules::module_alloc() are used.
> > > >
> > > > As above, I suspect that each of the callsites should probably be u=
sing common
> > > > infrastructure, but I don't think that a single jit_alloc_arch_para=
ms() makes
> > > > sense, since the parameters for each case may need to be distinct.
> > >
> > > I don't see how that follows. The whole point of function parameters =
is
> > > that they may be different :)
> >
> > What I mean is that jit_alloc_arch_params() tries to aggregate common
> > parameters, but they aren't actually common (e.g. the actual start+end =
range
> > for allocation).
> >
> > > Can you give more detail on what parameters you need? If the only ext=
ra
> > > parameter is just "does this allocation need to live close to kernel
> > > text", that's not that big of a deal.
> >
> > My thinking was that we at least need the start + end for each caller. =
That
> > might be it, tbh.
>
> IIUC, arm64 uses VMALLOC address space for BPF programs. The reason
> is each BPF program uses at least 64kB (one page) out of the 128MB
> address space. Puranjay Mohan (CC'ed) is working on enabling
> bpf_prog_pack for arm64. Once this work is done, multiple BPF programs
> will be able to share a page. Will this improvement remove the need to
> specify a different address range for BPF programs?

Hi,
Thanks for adding me to the conversation.

The ARM64 BPF JIT used to allocate the memory using module_alloc but it
was not optimal because BPF programs and modules were sharing the 128 MB
module region. This was fixed by
91fc957c9b1d ("arm64/bpf: don't allocate BPF JIT programs in module memory"=
)
It created a dedicated 128 MB region set aside for BPF programs.

But 128MB could get exhausted especially where PAGE_SIZE is 64KB - one
page is needed per program. This restriction was removed by
b89ddf4cca43 ("arm64/bpf: Remove 128MB limit for BPF JIT programs")

So, currently BPF programs are using a full page from vmalloc (4 KB,
16 KB, or 64 KB).
This wastes memory and also causes iTLB pressure. Enabling bpf_prog_pack
for ARM64 would fix it. I am doing some final tests and will send the patch=
es in
1-2 days.

Thanks,
Puranjay

