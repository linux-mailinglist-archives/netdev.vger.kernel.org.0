Return-Path: <netdev+bounces-7816-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 15973721A37
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 23:22:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CF62281115
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 21:22:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93213111B6;
	Sun,  4 Jun 2023 21:22:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F75569F;
	Sun,  4 Jun 2023 21:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18A3C43321;
	Sun,  4 Jun 2023 21:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685913764;
	bh=M3qa4JrCJfL3BlNTay6Yo1EjRS0Ncm+BgXInegps46U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=b7/fXotn0pQEscndihWizAxU7LQa5dSl44a9/klsWVyS0lxz/8hzxSa2IZZsjsxfX
	 r+NUkhYWfR+U4pM6AYQOSE7NKbAlOja0TNvz5m0DUEI1zWFDSIkNTecITt/pEkmEGw
	 J/i1EcDni6ZWXfMClgL03G31hjpaAYBpUerxaCwWdNhFcQlLqMtUbQhIMCbcYDNWvU
	 UhGMgdB0T5xWi5hDLtX6T9Luh2uONUrqL+9je7Lg6uu0df3kWNPuh+zhJ8FFH8haNG
	 M5E3S5UelWImxtKzuetFx71eO1My6o4ugA9ZPA9fKjM0HrHilfHJ2bhtk0fdh1FBN/
	 wGD7X3O1e8t2w==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-4f3bb61f860so5149594e87.3;
        Sun, 04 Jun 2023 14:22:44 -0700 (PDT)
X-Gm-Message-State: AC+VfDxPRQv9LPH+gR49jUNVeDka5bPlr4WCUILKiHBOPdZDcuLUpbkO
	Y+kgMj/azhGCcAPpQsuQ+MbuNYJhaG5+NhiALjA=
X-Google-Smtp-Source: ACHHUZ60WLRim/NZBMM58ZYdg3/lDfHnTA86A+7CXA+1QyWmoNPWXKyb36vAONlyven1Wz2rt1eY822fjimBjrUI6Ak=
X-Received: by 2002:ac2:5d6c:0:b0:4f2:4df1:f071 with SMTP id
 h12-20020ac25d6c000000b004f24df1f071mr4227167lft.51.1685913762272; Sun, 04
 Jun 2023 14:22:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601101257.530867-1-rppt@kernel.org> <ZHjDU/mxE+cugpLj@FVFF77S0Q05N.cambridge.arm.com>
 <ZHjgIH3aX9dCvVZc@moria.home.lan> <ZHm3zUUbwqlsZBBF@FVFF77S0Q05N>
 <CAPhsuW7Euczff_KB70nuH=Hhf2EYHAf=xiQR7mFqVfByhD34XA@mail.gmail.com> <ZHzRxE5V6YzGVsHy@moria.home.lan>
In-Reply-To: <ZHzRxE5V6YzGVsHy@moria.home.lan>
From: Song Liu <song@kernel.org>
Date: Sun, 4 Jun 2023 14:22:30 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7iEDa44jxc_7Cj4KnVhtct-UTO2JtVK-U7o2ynn2iX8Q@mail.gmail.com>
Message-ID: <CAPhsuW7iEDa44jxc_7Cj4KnVhtct-UTO2JtVK-U7o2ynn2iX8Q@mail.gmail.com>
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

On Sun, Jun 4, 2023 at 11:02=E2=80=AFAM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Fri, Jun 02, 2023 at 11:20:58AM -0700, Song Liu wrote:
> > IIUC, arm64 uses VMALLOC address space for BPF programs. The reason
> > is each BPF program uses at least 64kB (one page) out of the 128MB
> > address space. Puranjay Mohan (CC'ed) is working on enabling
> > bpf_prog_pack for arm64. Once this work is done, multiple BPF programs
> > will be able to share a page. Will this improvement remove the need to
> > specify a different address range for BPF programs?
>
> Can we please stop working on BPF specific sub page allocation and focus
> on doing this in mm/? This never should have been in BPF in the first
> place.

That work is mostly independent of the allocator work we are discussing her=
e.
The goal Puranjay's work is to enable the arm64 BPF JIT engine to use a
ROX allocator. The allocator could be the bpf_prog_pack allocator, or jital=
loc,
or module_alloc_type. Puranjay is using bpf_prog_alloc for now. But once
jitalloc or module_alloc_type (either one) is merged, we will migrate BPF
JIT engines (x86_64 and arm64) to the new allocator and then tear down
bpf_prog_pack.

Does this make sense?

Thanks,
Song

