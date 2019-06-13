Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F18844BCF
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 21:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbfFMTLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 15:11:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfFMTLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 15:11:25 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DA9A3307D866;
        Thu, 13 Jun 2019 19:11:16 +0000 (UTC)
Received: from treble (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EC1719C67;
        Thu, 13 Jun 2019 19:11:14 +0000 (UTC)
Date:   Thu, 13 Jun 2019 14:11:12 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 8/9] x86/bpf: Convert asm comments to AT&T syntax
Message-ID: <20190613191112.hinquqrdzl7u2lrt@treble>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <77fe02f7d575091b06f68f8eed256da94aee653f.1560431531.git.jpoimboe@redhat.com>
 <E8372F56-269A-48A4-B80B-14FA664F8D41@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E8372F56-269A-48A4-B80B-14FA664F8D41@fb.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 13 Jun 2019 19:11:25 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 06:52:24PM +0000, Song Liu wrote:
> > @@ -403,11 +403,11 @@ static void emit_mov_imm64(u8 **pprog, u32 dst_reg,
> > 		 * For emitting plain u32, where sign bit must not be
> > 		 * propagated LLVM tends to load imm64 over mov32
> > 		 * directly, so save couple of bytes by just doing
> > -		 * 'mov %eax, imm32' instead.
> > +		 * 'mov imm32, %eax' instead.
> > 		 */
> > 		emit_mov_imm32(&prog, false, dst_reg, imm32_lo);
> > 	} else {
> > -		/* movabsq %rax, imm64 */
> > +		/* movabs imm64, %rax */
> 
> 		^^^^^ Should this be moveabsq? 

Not for AT&T syntax:

~ $ cat test.S
movabs $0x1111111111111111, %rax
~ $ as test.S
~ $ objdump -d a.out

a.out:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <.text>:
   0:	48 b8 11 11 11 11 11 	movabs $0x1111111111111111,%rax
   7:	11 11 11

-- 
Josh
