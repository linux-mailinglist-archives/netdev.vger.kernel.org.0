Return-Path: <netdev+bounces-7528-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CDC1720906
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:21:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A26F11C211F0
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE8091D2DD;
	Fri,  2 Jun 2023 18:21:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C01819E47;
	Fri,  2 Jun 2023 18:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C87DC433AA;
	Fri,  2 Jun 2023 18:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685730074;
	bh=X+6D25ac/ynfkYhL6CVIatM+QSgTz3ZdfLV95/xOw/s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=m8QqKBlwUZ1OdVsi3iL4i/wpx/dFY6BbtHjhKMAoPALO9d9S1Of5z7SZF4QL6sTbP
	 1AkumCJkUSaKm4k7dCVk+lOGEFZdfq22cqjqj27S/pPlmB3p+6xXv2CNvliSMKoASM
	 /hdXoCMRwv6EJy8J6GYtUkCvLB9u0rcyusLTXlpDOf8Lr4f24TWYjjjFg1gay1e8Ak
	 p/JJ9xBOtMt5dIZYwKQ9oFJD8MWj9f1lt6ZhCj0XTqBGpkRKgNx/tS3niGcx/Matut
	 0hwyzJfj74d+iBjmUiHb0LPXzSLbkWfgBPmkBtc2NCOoUpEnhn1N5112VQidBofQtB
	 l46PC2/nl/Dww==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2af189d323fso46352391fa.1;
        Fri, 02 Jun 2023 11:21:14 -0700 (PDT)
X-Gm-Message-State: AC+VfDy6tUtSTkY4WimD0ve8ZiSIIh10ZMJfMY+q87EfuCPbr3gZqly6
	Qk5lO3wACNYGAPPmYAAU39rdvk/Wpx+a3HieDNM=
X-Google-Smtp-Source: ACHHUZ7u+3QRkPB700ZRWSkZS34WuzRLSBXiPs+mDMX8Rtj0TALCowhBg47HVf6nzRS8a/FS2UP95/Ck0Au4nvQTBcE=
X-Received: by 2002:a2e:b55a:0:b0:2b0:59c3:29c9 with SMTP id
 a26-20020a2eb55a000000b002b059c329c9mr217540ljn.6.1685730071990; Fri, 02 Jun
 2023 11:21:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601101257.530867-1-rppt@kernel.org> <ZHjDU/mxE+cugpLj@FVFF77S0Q05N.cambridge.arm.com>
 <ZHjgIH3aX9dCvVZc@moria.home.lan> <ZHm3zUUbwqlsZBBF@FVFF77S0Q05N>
In-Reply-To: <ZHm3zUUbwqlsZBBF@FVFF77S0Q05N>
From: Song Liu <song@kernel.org>
Date: Fri, 2 Jun 2023 11:20:58 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7Euczff_KB70nuH=Hhf2EYHAf=xiQR7mFqVfByhD34XA@mail.gmail.com>
Message-ID: <CAPhsuW7Euczff_KB70nuH=Hhf2EYHAf=xiQR7mFqVfByhD34XA@mail.gmail.com>
Subject: Re: [PATCH 00/13] mm: jit/text allocator
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	"David S. Miller" <davem@davemloft.net>, Dinh Nguyen <dinguyen@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Russell King <linux@armlinux.org.uk>, Steven Rostedt <rostedt@goodmis.org>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Thomas Gleixner <tglx@linutronix.de>, 
	Will Deacon <will@kernel.org>, bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, linux-modules@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, 
	netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org, 
	Puranjay Mohan <puranjay12@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 2, 2023 at 2:35=E2=80=AFAM Mark Rutland <mark.rutland@arm.com> =
wrote:
>
> On Thu, Jun 01, 2023 at 02:14:56PM -0400, Kent Overstreet wrote:
> > On Thu, Jun 01, 2023 at 05:12:03PM +0100, Mark Rutland wrote:
> > > For a while I have wanted to give kprobes its own allocator so that i=
t can work
> > > even with CONFIG_MODULES=3Dn, and so that it doesn't have to waste VA=
 space in
> > > the modules area.
> > >
> > > Given that, I think these should have their own allocator functions t=
hat can be
> > > provided independently, even if those happen to use common infrastruc=
ture.
> >
> > How much memory can kprobes conceivably use? I think we also want to tr=
y
> > to push back on combinatorial new allocators, if we can.
>
> That depends on who's using it, and how (e.g. via BPF).
>
> To be clear, I'm not necessarily asking for entirely different allocators=
, but
> I do thinkg that we want wrappers that can at least pass distinct start+e=
nd
> parameters to a common allocator, and for arm64's modules code I'd expect=
 that
> we'd keep the range falblack logic out of the common allcoator, and just =
call
> it twice.
>
> > > > Several architectures override module_alloc() because of various
> > > > constraints where the executable memory can be located and this cau=
ses
> > > > additional obstacles for improvements of code allocation.
> > > >
> > > > This set splits code allocation from modules by introducing
> > > > jit_text_alloc(), jit_data_alloc() and jit_free() APIs, replaces ca=
ll
> > > > sites of module_alloc() and module_memfree() with the new APIs and
> > > > implements core text and related allocation in a central place.
> > > >
> > > > Instead of architecture specific overrides for module_alloc(), the
> > > > architectures that require non-default behaviour for text allocatio=
n must
> > > > fill jit_alloc_params structure and implement jit_alloc_arch_params=
() that
> > > > returns a pointer to that structure. If an architecture does not im=
plement
> > > > jit_alloc_arch_params(), the defaults compatible with the current
> > > > modules::module_alloc() are used.
> > >
> > > As above, I suspect that each of the callsites should probably be usi=
ng common
> > > infrastructure, but I don't think that a single jit_alloc_arch_params=
() makes
> > > sense, since the parameters for each case may need to be distinct.
> >
> > I don't see how that follows. The whole point of function parameters is
> > that they may be different :)
>
> What I mean is that jit_alloc_arch_params() tries to aggregate common
> parameters, but they aren't actually common (e.g. the actual start+end ra=
nge
> for allocation).
>
> > Can you give more detail on what parameters you need? If the only extra
> > parameter is just "does this allocation need to live close to kernel
> > text", that's not that big of a deal.
>
> My thinking was that we at least need the start + end for each caller. Th=
at
> might be it, tbh.

IIUC, arm64 uses VMALLOC address space for BPF programs. The reason
is each BPF program uses at least 64kB (one page) out of the 128MB
address space. Puranjay Mohan (CC'ed) is working on enabling
bpf_prog_pack for arm64. Once this work is done, multiple BPF programs
will be able to share a page. Will this improvement remove the need to
specify a different address range for BPF programs?

Thanks,
Song

