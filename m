Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B13EFD1FB
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 01:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfKOAa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 19:30:29 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44939 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfKOAa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 19:30:29 -0500
Received: by mail-pg1-f193.google.com with SMTP id f19so4835039pgk.11;
        Thu, 14 Nov 2019 16:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=sDha34YrgBlsdela6AIpAyFg7qDyyE5Z+PMSeNCg550=;
        b=ENaYMt1xyJYD8sEN4QHRtuVPBih7FvFEBdCzHAoHVd/OW43fzHADkPyRFjF28ZYYHJ
         cfhdBKb0/ug7Y0yypvyzhHbNKXlY/PnedS1e3QOxu7CXljpr6cCHGkKXNNQ42lcVlyd+
         lMvTzpzLg/gUNiew+BtCK9wi180kLbHeRy/EBNzyPrDPjmDDJWpxlP4GjKzrAgMWjfgm
         kcNyL7LTiySdq2qL8f+3Ux0ITFuvvP1I1vMuA8E6Fiv4GKdgNauytWJ/36aLrL9CLR5c
         LmkWSRFWcU6oe8vA0aPcMzaLJMhg74HWR9gbMWG+792YbG0e28yO0oNjGkztNlCKiBxB
         JCqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=sDha34YrgBlsdela6AIpAyFg7qDyyE5Z+PMSeNCg550=;
        b=WuW7kiI8b+vat8/S6sFbkKbQby7kLnLsJMNJFj2Y/NtlVmOiNfc11jSa0dVTo+TnyD
         6xUptSzExzC47o2a/xiwZFWD+qTjHclP6FpSJ1jIE/P086CM83O05JOh2cPgZTuTWuYV
         Qbfnem0cFWMDOrBYGFc7EWZgPccPySu9S3w4AbFm4a2vG8wA33o2Jh6bD8nyB1umOgbJ
         XTt8C7fsaTR9eH3aanTc3+acAN2G+wwoxn4O0KoVW9S0vRjAit5FlrRfxawc8k25unJM
         /wJJANIFeMi7kRqjqx3ygPBBiM3zktBGw6elgMecELHXJ/eqYWL/Yqlh4YY85mVSuHjd
         9LEg==
X-Gm-Message-State: APjAAAXVPkANXlZDCZSrNplgEP+kDNBvPI/L283hv4U0P39Xl0Zpn8++
        Xp+/De/ql93ESLYvv+YtItU=
X-Google-Smtp-Source: APXvYqy+7Yx+mkOdiVw0TriGYZtRnY+QAieX3NEClr3w2Y4MpKv58mXheafj8+03OdZjR9NjsZ+K4A==
X-Received: by 2002:a63:ec03:: with SMTP id j3mr2993349pgh.212.1573777828476;
        Thu, 14 Nov 2019 16:30:28 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::6ab4])
        by smtp.gmail.com with ESMTPSA id w5sm8717133pfd.31.2019.11.14.16.30.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 16:30:27 -0800 (PST)
Date:   Thu, 14 Nov 2019 16:30:26 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: introduce BPF dispatcher
Message-ID: <20191115003024.h7eg2kbve23jmzqn@ast-mbp.dhcp.thefacebook.com>
References: <20191113204737.31623-1-bjorn.topel@gmail.com>
 <20191113204737.31623-3-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191113204737.31623-3-bjorn.topel@gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 09:47:35PM +0100, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> The BPF dispatcher builds on top of the BPF trampoline ideas;
> Introduce bpf_arch_text_poke() and (re-)use the BPF JIT generate
> code. The dispatcher builds a dispatch table for XDP programs, for
> retpoline avoidance. The table is a simple binary search model, so
> lookup is O(log n). Here, the dispatch table is limited to four
> entries (for laziness reason -- only 1B relative jumps :-P). If the
> dispatch table is full, it will fallback to the retpoline path.
> 
> An example: A module/driver allocates a dispatcher. The dispatcher is
> shared for all netdevs. Each netdev allocate a slot in the dispatcher
> and a BPF program. The netdev then uses the dispatcher to call the
> correct program with a direct call (actually a tail-call).
> 
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> ---
>  arch/x86/net/bpf_jit_comp.c |  96 ++++++++++++++++++
>  kernel/bpf/Makefile         |   1 +
>  kernel/bpf/dispatcher.c     | 197 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 294 insertions(+)
>  create mode 100644 kernel/bpf/dispatcher.c
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 28782a1c386e..d75aebf508b8 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -10,10 +10,12 @@
>  #include <linux/if_vlan.h>
>  #include <linux/bpf.h>
>  #include <linux/memory.h>
> +#include <linux/sort.h>
>  #include <asm/extable.h>
>  #include <asm/set_memory.h>
>  #include <asm/nospec-branch.h>
>  #include <asm/text-patching.h>
> +#include <asm/asm-prototypes.h>
>  
>  static u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
>  {
> @@ -1471,6 +1473,100 @@ int arch_prepare_bpf_trampoline(void *image, struct btf_func_model *m, u32 flags
>  	return 0;
>  }
>  
> +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_RETPOLINE)
> +
> +/* Emits the dispatcher. Id lookup is limited to BPF_DISPATCHER_MAX,
> + * so it'll fit into PAGE_SIZE/2. The lookup is binary search: O(log
> + * n).
> + */
> +static int emit_bpf_dispatcher(u8 **pprog, int a, int b, u64 *progs,
> +			       u8 *fb)
> +{
> +	u8 *prog = *pprog, *jg_reloc;
> +	int pivot, err, cnt = 0;
> +	s64 jmp_offset;
> +
> +	if (a == b) {
> +		emit_mov_imm64(&prog, BPF_REG_0,	/* movabs func,%rax */
> +			       progs[a] >> 32,
> +			       (progs[a] << 32) >> 32);

Could you try optimizing emit_mov_imm64() to recognize s32 ?
iirc there was a single x86 insns that could move and sign extend.
That should cut down on bytecode size and probably make things a bit faster?
Another alternative is compare lower 32-bit only, since on x86-64 upper 32
should be ~0 anyway for bpf prog pointers.
Looking at bookkeeping code, I think I should be able to generalize bpf
trampoline a bit and share the code for bpf dispatch.
Could you also try aligning jmp target a bit by inserting nops?
Some x86 cpus are sensitive to jmp target alignment. Even without considering
JCC bug it could be helpful. Especially since we're talking about XDP/AF_XDP
here that will be pushing millions of calls through bpf dispatch.

