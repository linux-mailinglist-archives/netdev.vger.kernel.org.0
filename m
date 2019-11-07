Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57936F3BF7
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfKGXJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:09:27 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33430 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfKGXJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:09:27 -0500
Received: by mail-pl1-f194.google.com with SMTP id ay6so2686354plb.0;
        Thu, 07 Nov 2019 15:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Vc0fqV1ezWUbXPBwQA5N1XJIJO+2HVZ72my/Bi5VgB0=;
        b=VdFasjcyg2zFHVJUsW1JcjltbmNY2lnprxzggbgrnJ9sZWqoa0BdZJ31ugm6gS0zSi
         1lX9ZViuHByrjKgJcpIpFC378CbHDLNtZw1kegfJnMfIgbn8x9ozpo5rESdDFf99ig1b
         dVbn8EDus1idQTsHOSc1sCqwm64XWxB3frwmaMlyxYMuefNg4FZLy3D+ZRlK8PnlYbaQ
         PR7IMrs2OZK29Sw6UsoBbMQuuJ9jYEB8Adm08UrKEi3tG/JAVMkMZqWM6Gj6+jgD3I6V
         O114jd6sr7DuQxLXEc1h7lw7rsyF86V7VsxlvveMIHr8qVhQVBm316sbqTKw4ZhWasiu
         tAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Vc0fqV1ezWUbXPBwQA5N1XJIJO+2HVZ72my/Bi5VgB0=;
        b=ErOn8HWdIdLXwXl7oysh8ok/u4+Y1NAN4J+eBd3tkRLJtc1MmiyEBXd//J1zZgZg+8
         juRiwcbQa/euitSin6xUdFBjgIupyXZ7WV5pl6nYxVOGwFwAIZErAsa90skEDIv3TJ0W
         tPMz2A/AZ6nkd+5D6cRwZv4qprOUMWPM29xvorpBWJdIYaRyKpOjXkrzZtsARDeqozq+
         huKvLH1IvlXEk9PPVaaneKBfW+RtHyS6phHE3ncZBQSiZyhTIYj9LF1/vUgAVYbHCMHM
         i4iDwrUS1EMaLTA5W/jAVpmIqJDmAyfMD6ki2q8LNcevKLPqiB5rdHe9or6YznWYA+TE
         lX0g==
X-Gm-Message-State: APjAAAUy8j746zCi/NGop5Bwa7xnX9IC0YNh+sOjU6ColVN7HLlupboz
        TQ197kcV8mtmTsCFYKQilftq7AbR
X-Google-Smtp-Source: APXvYqwmCVD5oTp9DZc66/TmiBgvCxI36gCeaMkhqKkRJrH06jLKon/+DRWKTsHM5vY5sZ3IxI4/Ug==
X-Received: by 2002:a17:90a:db05:: with SMTP id g5mr8983971pjv.5.1573168166751;
        Thu, 07 Nov 2019 15:09:26 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:d046])
        by smtp.gmail.com with ESMTPSA id p7sm3743061pjp.4.2019.11.07.15.09.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 15:09:25 -0800 (PST)
Date:   Thu, 7 Nov 2019 15:09:24 -0800
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
Message-ID: <20191107230923.knpejhp6fbyzioxi@ast-mbp.dhcp.thefacebook.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-4-ast@kernel.org>
 <5967F93A-235B-447E-9B70-E7768998B718@fb.com>
 <20191107225553.vnnos6nblxlwx24a@ast-mbp.dhcp.thefacebook.com>
 <FABEB3EB-2AC4-43F8-984B-EFD1DA621A3E@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FABEB3EB-2AC4-43F8-984B-EFD1DA621A3E@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 11:07:21PM +0000, Song Liu wrote:
> 
> 
> > On Nov 7, 2019, at 2:55 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > 
> > On Thu, Nov 07, 2019 at 10:37:19PM +0000, Song Liu wrote:
> >> 
> >> 
> >>> On Nov 6, 2019, at 9:46 PM, Alexei Starovoitov <ast@kernel.org> wrote:
> >>> 
> >> 
> >> [...]
> >> 
> >>> 
> >>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> >>> Acked-by: Andrii Nakryiko <andriin@fb.com>
> >>> ---
> >>> arch/x86/net/bpf_jit_comp.c | 227 ++++++++++++++++++++++++++++++--
> >>> include/linux/bpf.h         |  98 ++++++++++++++
> >>> include/uapi/linux/bpf.h    |   2 +
> >>> kernel/bpf/Makefile         |   1 +
> >>> kernel/bpf/btf.c            |  77 ++++++++++-
> >>> kernel/bpf/core.c           |   1 +
> >>> kernel/bpf/syscall.c        |  53 +++++++-
> >>> kernel/bpf/trampoline.c     | 252 ++++++++++++++++++++++++++++++++++++
> >>> kernel/bpf/verifier.c       |  39 ++++++
> >>> 9 files changed, 732 insertions(+), 18 deletions(-)
> >>> create mode 100644 kernel/bpf/trampoline.c
> >>> 
> >>> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> >>> index 8631d3bd637f..44169e8bffc0 100644
> >>> --- a/arch/x86/net/bpf_jit_comp.c
> >>> +++ b/arch/x86/net/bpf_jit_comp.c
> >>> @@ -98,6 +98,7 @@ static int bpf_size_to_x86_bytes(int bpf_size)
> >>> 
> >>> /* Pick a register outside of BPF range for JIT internal work */
> >>> #define AUX_REG (MAX_BPF_JIT_REG + 1)
> >>> +#define X86_REG_R9 (MAX_BPF_JIT_REG + 2)
> >>> 
> >>> /*
> >>> * The following table maps BPF registers to x86-64 registers.
> >>> @@ -123,6 +124,7 @@ static const int reg2hex[] = {
> >>> 	[BPF_REG_FP] = 5, /* RBP readonly */
> >>> 	[BPF_REG_AX] = 2, /* R10 temp register */
> >>> 	[AUX_REG] = 3,    /* R11 temp register */
> >>> +	[X86_REG_R9] = 1, /* R9 register, 6th function argument */
> >> 
> >> We should update the comment above this:
> >> 
> >> * Also x86-64 register R9 is unused. ...
> > 
> > good point. fixed.
> > 
> >>> +	/* One half of the page has active running trampoline.
> >>> +	 * Another half is an area for next trampoline.
> >>> +	 * Make sure the trampoline generation logic doesn't overflow.
> >>> +	 */
> >>> +	if (WARN_ON_ONCE(prog - (u8 *)image > PAGE_SIZE / 2 - BPF_INSN_SAFETY))
> >>> +		return -EFAULT;
> >> 
> >> Given max number of args, can we catch this error at compile time? 
> > 
> > I don't see how to do that. I was thinking about having fake __init function
> > that would call it with flags that can generate the longest trampoline, but
> > it's not fool proof either.
> > So I've added a test for it instead. See patch 10.
> > 
> >>> +
> >>> +static int bpf_trampoline_update(struct bpf_prog *prog)
> >> 
> >> Seems argument "prog" is not used at all? 
> > 
> > like one below ? ;)
> e... I was really dumb... sorry..
> 
> Maybe we should just pass the tr in? 

that would be imbalanced.

> > 
> >>> +{
> >>> +	struct bpf_trampoline *tr = prog->aux->trampoline;
> >>> +	void *old_image = tr->image + ((tr->selector + 1) & 1) * PAGE_SIZE/2;
> >>> +	void *new_image = tr->image + (tr->selector & 1) * PAGE_SIZE/2;
> >>> +	if (err)
> >>> +		goto out;
> >>> +	tr->selector++;
> >> 
> >> Shall we do selector-- for unlink?
> > 
> > It's a bit flip. I think it would be more confusing with --
> 
> Right.. Maybe should use int instead of u64 for selector? 

No, since int can overflow.

