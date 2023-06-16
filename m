Return-Path: <netdev+bounces-11407-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F129473303A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:45:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACBF02816F0
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 962C414A8F;
	Fri, 16 Jun 2023 11:45:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A65BA23;
	Fri, 16 Jun 2023 11:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29582C433C8;
	Fri, 16 Jun 2023 11:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686915898;
	bh=SBlkM7J7cvJwutjgEGnThrak9ds+eyJewMFlSVnYUvs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=dr7CzoJHNGeu3w3PgQKLWgVwS9T8cogmFWxroVNKHQZDVRo1UlUd3ic6QqjbwPyzL
	 OrTkekqfG41TcJ3iuPiKUyrB43uuzPMT/0N+uNrFSxpmmBrDSUdTB52vLORYSlSGYC
	 zBPrNwFYpqJ6pHwJkfuoCJg83QW4DoAAZMoW7rg5cWa/X5mOB3ohe76UHlwkbmHF3A
	 /s/K3g9D3SAsQdF/x03HA66saxLvv2vv83w0xLa5tpsgpmppcvsyNqXALWojA66hpv
	 A4m1rairPJ1Asf5I3bxm4yZMgl9hnWw00dt40QPDw754Cvio4MJWVbW7zmCUuCnxMU
	 OmX7v0eMaso5Q==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Christophe Leroy <christophe.leroy@csgroup.eu>,
 "David S. Miller" <davem@davemloft.net>, Dinh Nguyen
 <dinguyen@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, Helge Deller
 <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, Kent Overstreet
 <kent.overstreet@linux.dev>, Luis Chamberlain <mcgrof@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Mike Rapoport <rppt@kernel.org>, Nadav Amit <nadav.amit@gmail.com>,
 "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Puranjay Mohan <puranjay12@gmail.com>, Rick
 Edgecombe <rick.p.edgecombe@intel.com>, Russell King
 <linux@armlinux.org.uk>, Song Liu <song@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-modules@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 loongarch@lists.linux.dev, netdev@vger.kernel.org,
 sparclinux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 12/12] kprobes: remove dependcy on CONFIG_MODULES
In-Reply-To: <20230616085038.4121892-13-rppt@kernel.org>
References: <20230616085038.4121892-1-rppt@kernel.org>
 <20230616085038.4121892-13-rppt@kernel.org>
Date: Fri, 16 Jun 2023 13:44:55 +0200
Message-ID: <87r0qbmy14.fsf@all.your.base.are.belong.to.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mike Rapoport <rppt@kernel.org> writes:

> From: "Mike Rapoport (IBM)" <rppt@kernel.org>
>
> kprobes depended on CONFIG_MODULES because it has to allocate memory for
> code.

I think you can remove the MODULES dependency from BPF_JIT as well:

--8<--
diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index 2dfe1079f772..fa4587027f8b 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -41,7 +41,6 @@ config BPF_JIT
        bool "Enable BPF Just In Time compiler"
        depends on BPF
        depends on HAVE_CBPF_JIT || HAVE_EBPF_JIT
-       depends on MODULES
        help
          BPF programs are normally handled by a BPF interpreter. This opti=
on
          allows the kernel to generate native code when a program is loaded
--8<--


Bj=C3=B6rn

