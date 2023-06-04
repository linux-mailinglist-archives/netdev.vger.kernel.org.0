Return-Path: <netdev+bounces-7818-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50514721A6C
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 23:50:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 783111C20A42
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 21:50:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BDA911C95;
	Sun,  4 Jun 2023 21:50:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E891569F
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 21:50:08 +0000 (UTC)
X-Greylist: delayed 591 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 04 Jun 2023 14:50:05 PDT
Received: from out-22.mta0.migadu.com (out-22.mta0.migadu.com [91.218.175.22])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BDADA
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 14:50:05 -0700 (PDT)
Date: Sun, 4 Jun 2023 17:40:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685914810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Et8ABs17Zkfn2mGnERyKGLy92viAhCiNpbl07PFjtnE=;
	b=lJmPSA5rKs24/0LEEceFQVOeSXhUoE0+fis7PHaMYfcE2LZdC95JDmW0A61ctvzkYppcPe
	W9mzvDnQ++G15OC4MG7fFAFeLDHkLYUk7wWialJK1ki4sRZ8GoqzW1U3lBIfZIfX0tb2f2
	f+19wUtFVDPjGlYI9R+Uk+lqqtnlv4Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Song Liu <song@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Mike Rapoport <rppt@kernel.org>,
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
	sparclinux@vger.kernel.org, x86@kernel.org,
	Puranjay Mohan <puranjay12@gmail.com>
Subject: Re: [PATCH 00/13] mm: jit/text allocator
Message-ID: <ZH0EseWI9F1n9yJx@moria.home.lan>
References: <20230601101257.530867-1-rppt@kernel.org>
 <ZHjDU/mxE+cugpLj@FVFF77S0Q05N.cambridge.arm.com>
 <ZHjgIH3aX9dCvVZc@moria.home.lan>
 <ZHm3zUUbwqlsZBBF@FVFF77S0Q05N>
 <CAPhsuW7Euczff_KB70nuH=Hhf2EYHAf=xiQR7mFqVfByhD34XA@mail.gmail.com>
 <ZHzRxE5V6YzGVsHy@moria.home.lan>
 <CAPhsuW7iEDa44jxc_7Cj4KnVhtct-UTO2JtVK-U7o2ynn2iX8Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW7iEDa44jxc_7Cj4KnVhtct-UTO2JtVK-U7o2ynn2iX8Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 02:22:30PM -0700, Song Liu wrote:
> On Sun, Jun 4, 2023 at 11:02 AM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Fri, Jun 02, 2023 at 11:20:58AM -0700, Song Liu wrote:
> > > IIUC, arm64 uses VMALLOC address space for BPF programs. The reason
> > > is each BPF program uses at least 64kB (one page) out of the 128MB
> > > address space. Puranjay Mohan (CC'ed) is working on enabling
> > > bpf_prog_pack for arm64. Once this work is done, multiple BPF programs
> > > will be able to share a page. Will this improvement remove the need to
> > > specify a different address range for BPF programs?
> >
> > Can we please stop working on BPF specific sub page allocation and focus
> > on doing this in mm/? This never should have been in BPF in the first
> > place.
> 
> That work is mostly independent of the allocator work we are discussing here.
> The goal Puranjay's work is to enable the arm64 BPF JIT engine to use a
> ROX allocator. The allocator could be the bpf_prog_pack allocator, or jitalloc,
> or module_alloc_type. Puranjay is using bpf_prog_alloc for now. But once
> jitalloc or module_alloc_type (either one) is merged, we will migrate BPF
> JIT engines (x86_64 and arm64) to the new allocator and then tear down
> bpf_prog_pack.
> 
> Does this make sense?

Yeah, as long as that's the plan. Maybe one of you could tell us what
issues were preventing prog_pack from being used in the first place, it
might be relevant - this is the time to get the new allocator API right.

