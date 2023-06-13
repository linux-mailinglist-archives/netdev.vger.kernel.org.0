Return-Path: <netdev+bounces-10527-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDC0672EDA9
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:09:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96EF6280FEE
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D9553D393;
	Tue, 13 Jun 2023 21:09:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59490174FA;
	Tue, 13 Jun 2023 21:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CA2C433C0;
	Tue, 13 Jun 2023 21:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686690580;
	bh=CnDPIeLogwBWCfXwDFCGYSnn6freMhcPiMKmnauZmK8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZwHrH/UtQy5gtJuV6CZdRxLuHzTaAkiUGIx/JgEU65AMLsBIKZ0sWdlw1vTEQYgdy
	 gSLYt19YIoeRBe5zYzLlgTuRTMMo3kgRmlRYZUwN9+y0DX2gj67q8Dp8pJtQUo0gHp
	 Oy60KuQPQMSSexOGqUQrMmT3Fgb1GBewXzaMMxDEmcoyUN9bNnKzEk/bEsVagentbs
	 IrjokONRoY0TE+yzqvQqq0avTQyKOfbb7gZycLtP7znx6sVR7tnvKBFHLqFKSVwEs2
	 kIA6GPsL9JTaWmKMWc1Wdyo1oerK/huG9zsVu6RfIYfLEAg8ULTJ9IL3DRtm5ddTXF
	 JrMlJp241w1cA==
Date: Wed, 14 Jun 2023 00:09:00 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Song Liu <song@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S. Miller" <davem@davemloft.net>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
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
Subject: Re: [PATCH 00/13] mm: jit/text allocator
Message-ID: <20230613210900.GV52412@kernel.org>
References: <20230601101257.530867-1-rppt@kernel.org>
 <ZHjDU/mxE+cugpLj@FVFF77S0Q05N.cambridge.arm.com>
 <ZHjgIH3aX9dCvVZc@moria.home.lan>
 <ZHm3zUUbwqlsZBBF@FVFF77S0Q05N>
 <20230605092040.GB3460@kernel.org>
 <ZH20XkD74prrdN4u@FVFF77S0Q05N>
 <CAPhsuW7ntn_HpVWdGK_hYVd3zsPEFToBNfmtt0m6K8SwfxJ66Q@mail.gmail.com>
 <20230608184116.GJ52412@kernel.org>
 <ZIi7zmey0w61EG25@moria.home.lan>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZIi7zmey0w61EG25@moria.home.lan>

On Tue, Jun 13, 2023 at 02:56:14PM -0400, Kent Overstreet wrote:
> On Thu, Jun 08, 2023 at 09:41:16PM +0300, Mike Rapoport wrote:
> > On Tue, Jun 06, 2023 at 11:21:59AM -0700, Song Liu wrote:
> > > On Mon, Jun 5, 2023 at 3:09 AM Mark Rutland <mark.rutland@arm.com> wrote:
> > > 
> > > [...]
> > > 
> > > > > > > Can you give more detail on what parameters you need? If the only extra
> > > > > > > parameter is just "does this allocation need to live close to kernel
> > > > > > > text", that's not that big of a deal.
> > > > > >
> > > > > > My thinking was that we at least need the start + end for each caller. That
> > > > > > might be it, tbh.
> > > > >
> > > > > Do you mean that modules will have something like
> > > > >
> > > > >       jit_text_alloc(size, MODULES_START, MODULES_END);
> > > > >
> > > > > and kprobes will have
> > > > >
> > > > >       jit_text_alloc(size, KPROBES_START, KPROBES_END);
> > > > > ?
> > > >
> > > > Yes.
> > > 
> > > How about we start with two APIs:
> > >      jit_text_alloc(size);
> > >      jit_text_alloc_range(size, start, end);
> > > 
> > > AFAICT, arm64 is the only arch that requires the latter API. And TBH, I am
> > > not quite convinced it is needed.
> >  
> > Right now arm64 and riscv override bpf and kprobes allocations to use the
> > entire vmalloc address space, but having the ability to allocate generated
> > code outside of modules area may be useful for other architectures.
> > 
> > Still the start + end for the callers feels backwards to me because the
> > callers do not define the ranges, but rather the architectures, so we still
> > need a way for architectures to define how they want allocate memory for
> > the generated code.
> 
> So, the start + end just comes from the need to keep relative pointers
> under a certain size. I think this could be just a flag, I see no reason
> to expose actual addresses here.

It's the other way around. The start + end comes from the need to restrict
allocation to certain range because of the relative addressing. I don't see
how a flag can help here.

-- 
Sincerely yours,
Mike.

