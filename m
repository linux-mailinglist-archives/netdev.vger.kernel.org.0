Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1098C297E78
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 22:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764481AbgJXUhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 16:37:10 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:45126 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764444AbgJXUhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 16:37:09 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Oct 2020 16:37:08 EDT
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 2B2AC72CCE7;
        Sat, 24 Oct 2020 23:30:41 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 10D974A4A16;
        Sat, 24 Oct 2020 23:30:41 +0300 (MSK)
Date:   Sat, 24 Oct 2020 23:30:40 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     bpf@vger.kernel.org, Will Deacon <will@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>
Cc:     "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: tools/bpf: Compilation issue on powerpc: unknown type name
 '__vector128'
Message-ID: <20201024203040.4cjxnxrdy6qx557c@altlinux.org>
References: <20201023230641.xomukhg3zrhtuxez@altlinux.org>
 <20201024082319.GA24131@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20201024082319.GA24131@altlinux.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding netdev and PowerPC maintainers JFYI.

On Sat, Oct 24, 2020 at 11:23:19AM +0300, Dmitry V. Levin wrote:
> Hi,
> 
> On Sat, Oct 24, 2020 at 02:06:41AM +0300, Vitaly Chikunov wrote:
> > Hi,
> > 
> > Commit f143c11bb7b9 ("tools: bpf: Use local copy of headers including
> > uapi/linux/filter.h") introduces compilation issue on powerpc:
> >  
> >   builder@powerpc64le:~/linux$ make -C tools/bpf V=1
> >   make: Entering directory '/usr/src/linux/tools/bpf'
> >   gcc -Wall -O2 -D__EXPORTED_HEADERS__ -I/usr/src/linux/tools/include/uapi -I/usr/src/linux/tools/include -DDISASM_FOUR_ARGS_SIGNATURE -c -o bpf_dbg.o /usr/src/linux/tools/bpf/bpf_dbg.c
> >   In file included from /usr/include/asm/sigcontext.h:14,
> > 		   from /usr/include/bits/sigcontext.h:30,
> > 		   from /usr/include/signal.h:291,
> > 		   from /usr/src/linux/tools/bpf/bpf_dbg.c:51:
> >   /usr/include/asm/elf.h:160:9: error: unknown type name '__vector128'
> >     160 | typedef __vector128 elf_vrreg_t;
> > 	|         ^~~~~~~~~~~
> >   make: *** [Makefile:67: bpf_dbg.o] Error 1
> >   make: Leaving directory '/usr/src/linux/tools/bpf'
> 
> __vector128 is defined in arch/powerpc/include/uapi/asm/types.h;
> while include/uapi/linux/types.h does #include <asm/types.h>,
> tools/include/uapi/linux/types.h doesn't, resulting to this
> compilation error.

This is too puzzling to fix portably.

Thanks,

> 
> 
> -- 
> ldv
