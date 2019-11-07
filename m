Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54405F3BF2
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfKGXHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:07:43 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36237 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfKGXHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:07:42 -0500
Received: by mail-pl1-f194.google.com with SMTP id d7so766711pls.3;
        Thu, 07 Nov 2019 15:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KLMsuk2IfcLSb6uFSFGFwzCHGEFZsKBCFd+9/Vb9lqg=;
        b=OhkDOjXUBfj6xtTa3mCj+2FI1SNAjXdfG3zteJFEmJbO1FNUw4XnRmU4nb+f/fyFd6
         sl4Aw9zv60M0+TUqxRCbYNBY6diRMxlouYWWSXGu6FhBPjIOCFnW7Zb3Sdm1kufZwnv2
         5P02PK4jz0YB1x621uwLTA5Xw1Ll0ORbzMZWUl5LQAdWb7bL8biiJcUoiCESSvuERjc4
         y1ekOpOEVfcL2YH3LzB1X/Or9NXBwJXKRJRR/9Ivmp37pcckByD8x3+/KNU29Md6nLtq
         MpuWj0zRNtJx2dnD56fh+zRTzHZxnNDyumhv8k76Ca0u+GVvIFktF62IUgE8aSJDrFDf
         GOLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KLMsuk2IfcLSb6uFSFGFwzCHGEFZsKBCFd+9/Vb9lqg=;
        b=JjxRNUqR4IZSm0o06MTD83VPpAgQzrtATDn1d0sVtY0km2+GyT7L1hY/ad2mw63lSC
         pYSyY0mXhvqtHN14ZVg8K7cl9hUgIBEPRgtsDmI8vpYJB+2iSMCpgKWO6PyceM/WGGPn
         O8g5auC4Bw+QB1SKyV7/+VLgJg0KsuI//7LeLfN1YYYqWFVbMvmKDPAr/CJP5bB+xxCU
         s0gVnH9RphHLUciWRMyici7P4WgWaB4VDAGK35/0SpXdnyuqp/qRjYVjfzXFvoopOS2t
         oFUSE230kKx8CUDtweSvAwRcgEMMTzRpJT9YuSKjngvFKW1q766ewviW7CHam3lkrfPV
         5dGA==
X-Gm-Message-State: APjAAAVNmRl3eeuxCZWC+f0sE0P6aA5qQ+WH1mFeYg0nFfLbPiD6NuPz
        xDOHJ9GfuJqLXaWm8VbBFU4=
X-Google-Smtp-Source: APXvYqwfYhOLvcfz+AZRvow2WfawQlwKTWPsaVGHez+PEImpiT+zcMkeWzAjgfXMEnGcmqmuw1XblA==
X-Received: by 2002:a17:90a:23cd:: with SMTP id g71mr8758003pje.124.1573168061875;
        Thu, 07 Nov 2019 15:07:41 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:d046])
        by smtp.gmail.com with ESMTPSA id d4sm3283989pjs.9.2019.11.07.15.07.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 15:07:41 -0800 (PST)
Date:   Thu, 7 Nov 2019 15:07:39 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 04/17] libbpf: Add support to attach to
 fentry/fexit tracing progs
Message-ID: <20191107230738.u33hnfzahccurob3@ast-mbp.dhcp.thefacebook.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-5-ast@kernel.org>
 <693CECA2-5588-43AD-9AC9-CF5AF30C4589@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <693CECA2-5588-43AD-9AC9-CF5AF30C4589@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 10:51:41PM +0000, Song Liu wrote:
> 
> 
> > On Nov 6, 2019, at 9:46 PM, Alexei Starovoitov <ast@kernel.org> wrote:
> > 
> > Teach libbpf to recognize tracing programs types and attach them to
> > fentry/fexit.
> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> 
> With nit below:
> 
> > ---
> > tools/include/uapi/linux/bpf.h |  2 ++
> > tools/lib/bpf/libbpf.c         | 61 +++++++++++++++++++++++++++++-----
> > tools/lib/bpf/libbpf.h         |  5 +++
> > tools/lib/bpf/libbpf.map       |  2 ++
> > 4 files changed, 61 insertions(+), 9 deletions(-)
> > 
> 
> [...]
> 
> > 
> > /* Accessors of bpf_program */
> > struct bpf_program;
> > @@ -248,6 +251,8 @@ LIBBPF_API struct bpf_link *
> > bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
> > 				   const char *tp_name);
> > 
> > +LIBBPF_API struct bpf_link *
> > +bpf_program__attach_trace(struct bpf_program *prog);
> > struct bpf_insn;
> 
> attach_trace is not very clear. I guess we cannot call it 
> attach_ftrace? Maybe we call it attach_fentry and attach_fexit
> (two names pointing to same function)? 

bpf_program__attach_trace() can attach all BPF_PROG_TYPE_TRACING.
Which today are:
        BPF_TRACE_RAW_TP,
        BPF_TRACE_FENTRY,
        BPF_TRACE_FEXIT,
There will be more BPF_TRACE_* enum bpf_attach_type in the future.
I considered naming it bpf_program__attach_tracing(), but it's uglier
and longer.

