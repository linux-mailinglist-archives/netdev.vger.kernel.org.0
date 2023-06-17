Return-Path: <netdev+bounces-11693-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D9B4733EF2
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65E381C210FF
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84FE2613C;
	Sat, 17 Jun 2023 06:58:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A002E0EA;
	Sat, 17 Jun 2023 06:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9588BC433C0;
	Sat, 17 Jun 2023 06:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686985126;
	bh=9S4P8JW7Aw6+2ZoVDniU5EdIBLc9OdiTvqw3YA9ECf4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nHkTyW+hctadrgmIg2I6LaptKR6YKkmtmdcOS/HSni9feQ5p1DZtCSX6Dnam1slU3
	 FLDQnf/OEx1d4jSPxMmAwLEhSg3dDkigyXgxGzkX1VJc1UJnkk6n01fCEZ0qwx4ELP
	 r6wbjQNoXnPg5HveUgv1zS7owOZuF5kej34YgRIGZdC2tH3sGX0H+MpQa784HSW6mk
	 qjN9Au7ZhvMEPLupJ+gAv5/GudEwZVVlLyNGJFO9CDGv8qdQ0I+Zmw8CDlXcjxb8w/
	 RZuOMQ5h8Q4Z/8VeTux+zm8PEK9dnLGg98fBUnC+4CbpTq0gKeC8d5BMUXJufl+4IU
	 tPAEuFrGSOYnA==
Date: Sat, 17 Jun 2023 09:57:59 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Song Liu <song@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S. Miller" <davem@davemloft.net>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nadav Amit <nadav.amit@gmail.com>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Puranjay Mohan <puranjay12@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Russell King <linux@armlinux.org.uk>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
	bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev, netdev@vger.kernel.org,
	sparclinux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 07/12] arm64, execmem: extend execmem_params for
 generated code definitions
Message-ID: <20230617065759.GT52412@kernel.org>
References: <20230616085038.4121892-1-rppt@kernel.org>
 <20230616085038.4121892-8-rppt@kernel.org>
 <CAPhsuW6BG2oVrGDOpCKyOEvU9fBOboYYhducv96KUBe276Mvng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW6BG2oVrGDOpCKyOEvU9fBOboYYhducv96KUBe276Mvng@mail.gmail.com>

On Fri, Jun 16, 2023 at 01:05:29PM -0700, Song Liu wrote:
> On Fri, Jun 16, 2023 at 1:52 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > From: "Mike Rapoport (IBM)" <rppt@kernel.org>
> >
> > The memory allocations for kprobes on arm64 can be placed anywhere in
> > vmalloc address space and currently this is implemented with an override
> > of alloc_insn_page() in arm64.
> >
> > Extend execmem_params with a range for generated code allocations and
> > make kprobes on arm64 use this extension rather than override
> > alloc_insn_page().
> >
> > Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
> > ---
> >  arch/arm64/kernel/module.c         |  9 +++++++++
> >  arch/arm64/kernel/probes/kprobes.c |  7 -------
> >  include/linux/execmem.h            | 11 +++++++++++
> >  mm/execmem.c                       | 14 +++++++++++++-
> >  4 files changed, 33 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
> > index c3d999f3a3dd..52b09626bc0f 100644
> > --- a/arch/arm64/kernel/module.c
> > +++ b/arch/arm64/kernel/module.c
> > @@ -30,6 +30,13 @@ static struct execmem_params execmem_params = {
> >                         .alignment = MODULE_ALIGN,
> >                 },
> >         },
> > +       .jit = {
> > +               .text = {
> > +                       .start = VMALLOC_START,
> > +                       .end = VMALLOC_END,
> > +                       .alignment = 1,
> > +               },
> > +       },
> >  };
> 
> This is growing fast. :) We have 3 now: text, data, jit. And it will be
> 5 when we split data into rw data, ro data, ro after init data. I wonder
> whether we should still do some type enum here. But we can revisit
> this topic later.

I don't think we'd need 5. Four at most :)

I don't know yet what would be the best way to differentiate RW and RO
data, but ro_after_init surely won't need a new type. It either will be
allocated as RW and then the caller will have to set it RO after
initialization is done, or it will be allocated as RO and the caller will
have to do something like text_poke to update it.
 
> Other than that
> 
> Acked-by: Song Liu <song@kernel.org>

-- 
Sincerely yours,
Mike.

