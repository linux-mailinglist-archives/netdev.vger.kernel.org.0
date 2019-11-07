Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D577DF3BD3
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfKGWz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:55:58 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36058 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfKGWz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:55:58 -0500
Received: by mail-pg1-f194.google.com with SMTP id k13so2910421pgh.3;
        Thu, 07 Nov 2019 14:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J293tw8bq2htqxRBo29h5G6Xx/f4qBI6NvHqoa3psYE=;
        b=onzPuPpEb4E8aO0zqCLZ4jclD051dBLPrsmzw607ntcW21ojcIQKYY0Cni9RY+NNI+
         X51FyUaLBBFYUt8iN722XMjGuaYGcIao0F8kjYbbkoykMdyPN30PdOWaEdGUmT9jYun/
         3htdzR6o0S2qvwIkhbDtxCxK2xG4cZ9690XbFbSDWFYI2ipdk0aggCuWpEfk4IVNFPGh
         FP0wB24/4e55yXYmDbme3IoAJQvynBijwuaF3qNyNSbz8qwj/QfUvpfWUrv8LgPIYYEr
         qFp+NEuw6JnA8f3nKwHicdh/RBgcGGZYEaqvHa8Vuht+2d/0AF7AMa88er1x4dINz5X+
         iVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J293tw8bq2htqxRBo29h5G6Xx/f4qBI6NvHqoa3psYE=;
        b=hs3Xb4EKpDY/0JZcGSryRvf6YkaPQByC5RBqOL3RMyeSnL9RZe91BkEsy42AvrQtS7
         SFNHLtOoqlogZ1qcYFpDSPlPRN/hyTI5OpFHzNQac/beIXcj4JbwpejuNR2gX6I4yhzF
         /eXdcybQUsbVn1/GlBCdKLTxMGLp01nkbHTdVZepr9K+viASCgMtkj7qogZ0hoZ2Dl+5
         PihmLQhyfBGz9ZxEBuxH2Z07pj4HT720Ap2vE5wpDc+9p4E4pXSas2B4pzVT5UyacFY/
         5vt/I0isCgI5bZ9Lp4TlBOoV321dcKXMt3u1b3VQdVnFLwAuWVjCpm7NGu+7jeXMzpXN
         YXyw==
X-Gm-Message-State: APjAAAVPVZ1jj0yIInFCkqpzI0eekx4oUdXFxc9SVOnJ6J5E3Scb6sUc
        HOxjlj6aa/RmHn8hLB8EihM=
X-Google-Smtp-Source: APXvYqzxevMA8D1Vm3+YzZOmP/PFech/qkYka8ii1jbGmehlsxLX1cs55W6SJAqGiibiQIVxv6a8PA==
X-Received: by 2002:a63:fc16:: with SMTP id j22mr7787321pgi.35.1573167357047;
        Thu, 07 Nov 2019 14:55:57 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:d046])
        by smtp.gmail.com with ESMTPSA id y24sm4666242pfr.116.2019.11.07.14.55.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 14:55:56 -0800 (PST)
Date:   Thu, 7 Nov 2019 14:55:54 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 03/17] bpf: Introduce BPF trampoline
Message-ID: <20191107225553.vnnos6nblxlwx24a@ast-mbp.dhcp.thefacebook.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-4-ast@kernel.org>
 <5967F93A-235B-447E-9B70-E7768998B718@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5967F93A-235B-447E-9B70-E7768998B718@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 10:37:19PM +0000, Song Liu wrote:
> 
> 
> > On Nov 6, 2019, at 9:46 PM, Alexei Starovoitov <ast@kernel.org> wrote:
> > 
> 
> [...]
> 
> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> > arch/x86/net/bpf_jit_comp.c | 227 ++++++++++++++++++++++++++++++--
> > include/linux/bpf.h         |  98 ++++++++++++++
> > include/uapi/linux/bpf.h    |   2 +
> > kernel/bpf/Makefile         |   1 +
> > kernel/bpf/btf.c            |  77 ++++++++++-
> > kernel/bpf/core.c           |   1 +
> > kernel/bpf/syscall.c        |  53 +++++++-
> > kernel/bpf/trampoline.c     | 252 ++++++++++++++++++++++++++++++++++++
> > kernel/bpf/verifier.c       |  39 ++++++
> > 9 files changed, 732 insertions(+), 18 deletions(-)
> > create mode 100644 kernel/bpf/trampoline.c
> > 
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index 8631d3bd637f..44169e8bffc0 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -98,6 +98,7 @@ static int bpf_size_to_x86_bytes(int bpf_size)
> > 
> > /* Pick a register outside of BPF range for JIT internal work */
> > #define AUX_REG (MAX_BPF_JIT_REG + 1)
> > +#define X86_REG_R9 (MAX_BPF_JIT_REG + 2)
> > 
> > /*
> >  * The following table maps BPF registers to x86-64 registers.
> > @@ -123,6 +124,7 @@ static const int reg2hex[] = {
> > 	[BPF_REG_FP] = 5, /* RBP readonly */
> > 	[BPF_REG_AX] = 2, /* R10 temp register */
> > 	[AUX_REG] = 3,    /* R11 temp register */
> > +	[X86_REG_R9] = 1, /* R9 register, 6th function argument */
> 
> We should update the comment above this:
> 
>  * Also x86-64 register R9 is unused. ...

good point. fixed.

> > +	/* One half of the page has active running trampoline.
> > +	 * Another half is an area for next trampoline.
> > +	 * Make sure the trampoline generation logic doesn't overflow.
> > +	 */
> > +	if (WARN_ON_ONCE(prog - (u8 *)image > PAGE_SIZE / 2 - BPF_INSN_SAFETY))
> > +		return -EFAULT;
> 
> Given max number of args, can we catch this error at compile time? 

I don't see how to do that. I was thinking about having fake __init function
that would call it with flags that can generate the longest trampoline, but
it's not fool proof either.
So I've added a test for it instead. See patch 10.

> > +
> > +static int bpf_trampoline_update(struct bpf_prog *prog)
> 
> Seems argument "prog" is not used at all? 

like one below ? ;)

> > +{
> > +	struct bpf_trampoline *tr = prog->aux->trampoline;
> > +	void *old_image = tr->image + ((tr->selector + 1) & 1) * PAGE_SIZE/2;
> > +	void *new_image = tr->image + (tr->selector & 1) * PAGE_SIZE/2;
> > +	if (err)
> > +		goto out;
> > +	tr->selector++;
> 
> Shall we do selector-- for unlink?

It's a bit flip. I think it would be more confusing with --

