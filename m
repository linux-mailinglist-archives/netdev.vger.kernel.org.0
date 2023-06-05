Return-Path: <netdev+bounces-7851-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CDBA0721CCB
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 06:06:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6262328112A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 04:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DFBD1FD3;
	Mon,  5 Jun 2023 04:06:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C191C04;
	Mon,  5 Jun 2023 04:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8398BC433AA;
	Mon,  5 Jun 2023 04:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685937961;
	bh=WtI1jY3mnr9zb4/0mcezfP7YgsPqPtpWRWa72DAZTTg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uxKGktXNqn49bEfc54rxrLont7pLs83GyZuzAufBwsGBjuGMKdcRP/bEdwYmfXXxU
	 WvxTYj5OfeXmTt5HLnDLwPgr67Lkt70CP1EvdU2veiDINIXLIDAS+iKL+CqrOBDxNc
	 W/VQJXu20GHLghTy7G8UfIn1gM+F5ueXv0na8lU8CSN0FmokvQ65P4mX8K8i05YG/W
	 fPh72tKYwA3H59nPmnDH3bp9qH5k5y+9C+A7tg1dtcxIc9fAAEgtE2WRW9gNO+56RG
	 rnpEhaZc8TsRLxnuELVYU2NxAebO69dROiM74lzh42BNKszJ2YPFsTB9bCrjTQGdS0
	 SNLJmYWsBwYSA==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2b1adf27823so35252641fa.2;
        Sun, 04 Jun 2023 21:06:01 -0700 (PDT)
X-Gm-Message-State: AC+VfDwCe4FyYQHbfZPYf7I4NNzADGVq13v4+AW1jwl6kw8WPAgC6a/m
	tGJRzUBMrz7zFnv4A85zkg5CkI3mcMK886mx3dE=
X-Google-Smtp-Source: ACHHUZ5GrSEK3PQNTobRaaPR4GI9Q/dG/dH9vtDqov4NPtsLbAuvSoOBGIqnwRO1u3fwexaWyE5OrfsdUvjgUci7FZk=
X-Received: by 2002:a2e:2419:0:b0:2ad:d6cd:efdd with SMTP id
 k25-20020a2e2419000000b002add6cdefddmr3089294ljk.32.1685937959380; Sun, 04
 Jun 2023 21:05:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601101257.530867-1-rppt@kernel.org> <ZHjDU/mxE+cugpLj@FVFF77S0Q05N.cambridge.arm.com>
 <ZHjgIH3aX9dCvVZc@moria.home.lan> <ZHm3zUUbwqlsZBBF@FVFF77S0Q05N>
 <CAPhsuW7Euczff_KB70nuH=Hhf2EYHAf=xiQR7mFqVfByhD34XA@mail.gmail.com>
 <ZHzRxE5V6YzGVsHy@moria.home.lan> <CAPhsuW7iEDa44jxc_7Cj4KnVhtct-UTO2JtVK-U7o2ynn2iX8Q@mail.gmail.com>
 <ZH0EseWI9F1n9yJx@moria.home.lan>
In-Reply-To: <ZH0EseWI9F1n9yJx@moria.home.lan>
From: Song Liu <song@kernel.org>
Date: Sun, 4 Jun 2023 21:05:47 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7S40xCz_e0fdimfC+ybO=kvMg3SSzTd1s4qiOcvmJJcA@mail.gmail.com>
Message-ID: <CAPhsuW7S40xCz_e0fdimfC+ybO=kvMg3SSzTd1s4qiOcvmJJcA@mail.gmail.com>
Subject: Re: [PATCH 00/13] mm: jit/text allocator
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
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
	netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org, 
	Puranjay Mohan <puranjay12@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 4, 2023 at 2:40=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Sun, Jun 04, 2023 at 02:22:30PM -0700, Song Liu wrote:
> > On Sun, Jun 4, 2023 at 11:02=E2=80=AFAM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > >
> > > On Fri, Jun 02, 2023 at 11:20:58AM -0700, Song Liu wrote:
> > > > IIUC, arm64 uses VMALLOC address space for BPF programs. The reason
> > > > is each BPF program uses at least 64kB (one page) out of the 128MB
> > > > address space. Puranjay Mohan (CC'ed) is working on enabling
> > > > bpf_prog_pack for arm64. Once this work is done, multiple BPF progr=
ams
> > > > will be able to share a page. Will this improvement remove the need=
 to
> > > > specify a different address range for BPF programs?
> > >
> > > Can we please stop working on BPF specific sub page allocation and fo=
cus
> > > on doing this in mm/? This never should have been in BPF in the first
> > > place.
> >
> > That work is mostly independent of the allocator work we are discussing=
 here.
> > The goal Puranjay's work is to enable the arm64 BPF JIT engine to use a
> > ROX allocator. The allocator could be the bpf_prog_pack allocator, or j=
italloc,
> > or module_alloc_type. Puranjay is using bpf_prog_alloc for now. But onc=
e
> > jitalloc or module_alloc_type (either one) is merged, we will migrate B=
PF
> > JIT engines (x86_64 and arm64) to the new allocator and then tear down
> > bpf_prog_pack.
> >
> > Does this make sense?
>
> Yeah, as long as that's the plan. Maybe one of you could tell us what
> issues were preventing prog_pack from being used in the first place, it
> might be relevant - this is the time to get the new allocator API right.

The JIT engine does a lot of writes. Instead of doing many text_poke(),
we are using a temporary RW write buffer, and then do text_poke_copy()
at the end. To make this work, we need the JIT engine to be able to
handle an RW temporary buffer and an RO final memory region. There
is nothing preventing prog_pack to work. It is just we need to do the
work.

Thanks,
Song

