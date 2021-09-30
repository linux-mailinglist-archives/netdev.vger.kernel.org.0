Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F0B41E2E8
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 22:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348441AbhI3U7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 16:59:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:57628 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhI3U7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 16:59:45 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mW37V-000DIq-1m; Thu, 30 Sep 2021 22:57:33 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mW37U-000FDj-Lu; Thu, 30 Sep 2021 22:57:32 +0200
Subject: Re: [PATCH v4 0/8] bpf powerpc: Add BPF_PROBE_MEM support in powerpc
 JIT compiler
To:     Hari Bathini <hbathini@linux.ibm.com>, naveen.n.rao@linux.ibm.com,
        christophe.leroy@csgroup.eu, mpe@ellerman.id.au, ast@kernel.org
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20210929111855.50254-1-hbathini@linux.ibm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <88b59272-e3f7-30ba-dda0-c4a6b42c0029@iogearbox.net>
Date:   Thu, 30 Sep 2021 22:57:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210929111855.50254-1-hbathini@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26308/Thu Sep 30 11:04:45 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/21 1:18 PM, Hari Bathini wrote:
> Patch #1 & #2 are simple cleanup patches. Patch #3 refactors JIT
> compiler code with the aim to simplify adding BPF_PROBE_MEM support.
> Patch #4 introduces PPC_RAW_BRANCH() macro instead of open coding
> branch instruction. Patch #5 & #7 add BPF_PROBE_MEM support for PPC64
> & PPC32 JIT compilers respectively. Patch #6 & #8 handle bad userspace
> pointers for PPC64 & PPC32 cases respectively.

Michael, are you planning to pick up the series or shall we route via bpf-next?

Thanks,
Daniel

> Changes in v4:
> * Addressed all the review comments from Christophe.
> 
> 
> Hari Bathini (4):
>    bpf powerpc: refactor JIT compiler code
>    powerpc/ppc-opcode: introduce PPC_RAW_BRANCH() macro
>    bpf ppc32: Add BPF_PROBE_MEM support for JIT
>    bpf ppc32: Access only if addr is kernel address
> 
> Ravi Bangoria (4):
>    bpf powerpc: Remove unused SEEN_STACK
>    bpf powerpc: Remove extra_pass from bpf_jit_build_body()
>    bpf ppc64: Add BPF_PROBE_MEM support for JIT
>    bpf ppc64: Access only if addr is kernel address
> 
>   arch/powerpc/include/asm/ppc-opcode.h |   2 +
>   arch/powerpc/net/bpf_jit.h            |  19 +++--
>   arch/powerpc/net/bpf_jit_comp.c       |  72 ++++++++++++++++--
>   arch/powerpc/net/bpf_jit_comp32.c     | 101 ++++++++++++++++++++++----
>   arch/powerpc/net/bpf_jit_comp64.c     |  72 ++++++++++++++----
>   5 files changed, 224 insertions(+), 42 deletions(-)
> 

