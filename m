Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5A54550EC
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 00:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235546AbhKQXMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 18:12:19 -0500
Received: from www62.your-server.de ([213.133.104.62]:54978 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhKQXMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 18:12:19 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mnU35-000DUb-EN; Thu, 18 Nov 2021 00:09:03 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mnU35-000DpZ-32; Thu, 18 Nov 2021 00:09:03 +0100
Subject: Re: [PATCH 1/2] bpf, docs: prune all references to "internal BPF"
To:     Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20211115130715.121395-1-hch@lst.de>
 <20211115130715.121395-2-hch@lst.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1bb1c024-55a0-b9bf-8aa1-2bfd7a3c367d@iogearbox.net>
Date:   Thu, 18 Nov 2021 00:09:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211115130715.121395-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26356/Wed Nov 17 10:26:25 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/21 2:07 PM, Christoph Hellwig wrote:
> The eBPF name has completely taken over from eBPF in general usage, so
> prune all remaining references to "internal BPF".
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   Documentation/networking/filter.rst | 22 +++++++++++-----------
>   arch/arm/net/bpf_jit_32.c           |  2 +-
>   arch/arm64/net/bpf_jit_comp.c       |  2 +-
>   arch/sparc/net/bpf_jit_comp_64.c    |  2 +-
>   arch/x86/net/bpf_jit_comp.c         |  2 +-
>   kernel/bpf/core.c                   |  4 ++--
>   net/core/filter.c                   | 11 +++++------
>   7 files changed, 22 insertions(+), 23 deletions(-)
> 
[...]
> diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
> index eeb6dc0ecf463..a00821e820019 100644
> --- a/arch/arm/net/bpf_jit_32.c
> +++ b/arch/arm/net/bpf_jit_32.c
> @@ -163,7 +163,7 @@ static const s8 bpf2a32[][2] = {
>   	[BPF_REG_9] = {STACK_OFFSET(BPF_R9_HI), STACK_OFFSET(BPF_R9_LO)},
>   	/* Read only Frame Pointer to access Stack */
>   	[BPF_REG_FP] = {STACK_OFFSET(BPF_FP_HI), STACK_OFFSET(BPF_FP_LO)},
> -	/* Temporary Register for internal BPF JIT, can be used
> +	/* Temporary Register for eBPF JIT, can be used

Thanks for the cleanup! For the code occurrences with 'internal BPF', I would
just drop the term 'internal' so it's only 'BPF' which is consistent with the
rest in the kernel. Usually eBPF is implied given all the old cBPF stuff is
translated to it anyway. Bit confusing, but that's where it converged over the
years in the kernel including git log. eBPF vs cBPF unless it's explicitly
intended to be called out (like in the filter.rst docs).

>   	 * for constant blindings and others.
>   	 */
>   	[TMP_REG_1] = {ARM_R7, ARM_R6},
[...]
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 2405e39d800fe..355aa51899d62 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1891,7 +1891,7 @@ static void bpf_prog_select_func(struct bpf_prog *fp)
>   
>   /**
>    *	bpf_prog_select_runtime - select exec runtime for BPF program
> - *	@fp: bpf_prog populated with internal BPF program
> + *	@fp: bpf_prog populated with eBPF program
>    *	@err: pointer to error variable
>    *
>    * Try to JIT eBPF program, if JIT is not available, use interpreter.
> @@ -2300,7 +2300,7 @@ static void bpf_prog_free_deferred(struct work_struct *work)
>   	}
>   }
>   
> -/* Free internal BPF program */
> +/* Free eBPF program */

nit: We can probably just drop that comment since it's not very useful anyway
and already implied by the function name.

>   void bpf_prog_free(struct bpf_prog *fp)
>   {
>   	struct bpf_prog_aux *aux = fp->aux;
> diff --git a/net/core/filter.c b/net/core/filter.c
> index e471c9b096705..634e21647fe30 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -1242,10 +1242,9 @@ static struct bpf_prog *bpf_migrate_filter(struct bpf_prog *fp)
>   	int err, new_len, old_len = fp->len;
>   	bool seen_ld_abs = false;
>   
> -	/* We are free to overwrite insns et al right here as it
> -	 * won't be used at this point in time anymore internally
> -	 * after the migration to the internal BPF instruction
> -	 * representation.
> +	/* We are free to overwrite insns et al right here as itwon't be used at

nit: itwon't

> +	 * this point in time anymore internally after the migration to the eBPF
> +	 * instruction representation.> diff --git a/Documentation/networking/filter.rst b/Documentation/networking/filter.rst
