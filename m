Return-Path: <netdev+bounces-11690-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78D86733EE0
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:53:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBEFD281907
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C715231;
	Sat, 17 Jun 2023 06:53:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE86833FD;
	Sat, 17 Jun 2023 06:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C22C433C0;
	Sat, 17 Jun 2023 06:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686984783;
	bh=s5IbUS/R9FUeza7Uno3Hll+WeqZYFms0rCFRllsd4i8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O0jdChYvxLTPBx1BOB1xElON4yTO54jJpqqtDjBH7kzjTk7h8ut1Zvwg88nJSwHD5
	 dR46BC1yX4kfsB9fmhzM3g5FAiBBJ7EopEe68OhToY9ZvFD0H28XYCChSftyR0QUBZ
	 RDI9hk6abzU7ADT2Mp8RObMy225YcvgqAzj8bWooQ/IUkq2S0z3QH97xrM4q9eh/eL
	 W9Ix4DLih/xlZ3Zq9c6AydZXL5tY2UznK8+LjAqeaAIVsE4aQyWtPv0n7kE5DQG+KX
	 YYFIH+XCs7DhkCWkawXBSwV8RH6HWXBuasnHhsf1ZYp1zsYvUdnbybweDJ02yKksNs
	 +4CfHcBEs1MPg==
Date: Sat, 17 Jun 2023 09:52:16 +0300
From: Mike Rapoport <rppt@kernel.org>
To: =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>
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
	Russell King <linux@armlinux.org.uk>, Song Liu <song@kernel.org>,
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
Subject: Re: [PATCH v2 12/12] kprobes: remove dependcy on CONFIG_MODULES
Message-ID: <20230617065216.GS52412@kernel.org>
References: <20230616085038.4121892-1-rppt@kernel.org>
 <20230616085038.4121892-13-rppt@kernel.org>
 <87r0qbmy14.fsf@all.your.base.are.belong.to.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r0qbmy14.fsf@all.your.base.are.belong.to.us>

On Fri, Jun 16, 2023 at 01:44:55PM +0200, Björn Töpel wrote:
> Mike Rapoport <rppt@kernel.org> writes:
> 
> > From: "Mike Rapoport (IBM)" <rppt@kernel.org>
> >
> > kprobes depended on CONFIG_MODULES because it has to allocate memory for
> > code.
> 
> I think you can remove the MODULES dependency from BPF_JIT as well:

Yeah, I think so. Thanks!
 
> --8<--
> diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
> index 2dfe1079f772..fa4587027f8b 100644
> --- a/kernel/bpf/Kconfig
> +++ b/kernel/bpf/Kconfig
> @@ -41,7 +41,6 @@ config BPF_JIT
>         bool "Enable BPF Just In Time compiler"
>         depends on BPF
>         depends on HAVE_CBPF_JIT || HAVE_EBPF_JIT
> -       depends on MODULES
>         help
>           BPF programs are normally handled by a BPF interpreter. This option
>           allows the kernel to generate native code when a program is loaded
> --8<--
> 
> 
> Björn

-- 
Sincerely yours,
Mike.

