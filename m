Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC753AD363
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 22:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhFRUJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 16:09:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58858 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229768AbhFRUJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 16:09:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624046831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nF7w/bRMF9yLough+lpnUI5zPdwvtiS+Mg2nsdKHrg4=;
        b=RCH4DjFX855WKsucOYiV8s2leugfucquhlja1W2dlyXQyH/WOOByPeKbJfc+XdKDl1lP6V
        bqgY/F7Y06E4/89RE6LLop2rsvQXJ33OZ825JqMmJhS8NqL1aDHJnjhwaxazrDMF2tES/8
        2UIT8W02pDZhay1xY03d7xQkh1Q5bBA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-pAru88fnNqKtReNJ6dSmEg-1; Fri, 18 Jun 2021 16:07:10 -0400
X-MC-Unique: pAru88fnNqKtReNJ6dSmEg-1
Received: by mail-ed1-f69.google.com with SMTP id y16-20020a0564024410b0290394293f6816so4249180eda.20
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 13:07:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nF7w/bRMF9yLough+lpnUI5zPdwvtiS+Mg2nsdKHrg4=;
        b=hXLDkKY1oVHEB6ANnYE0MrTOo5/CeXfS+Cxhh/VLQBxNOJo1J/6+rje0fwHOqS6hS9
         EJxtvioV0S1UPASESsL/tu+sNfnUB/JtPXqmMj+aYDl8+Y7ExM/JAteCFQAKXxMykZcN
         oo56bUnt9juH/STopvXs8n9KCz0SJurXFtjcytpSOCPEtUTXi/ecfhMtK/t2ahP+SKTU
         hYGBBxDHvcDPQpoCvKqigHmCB+Z7jRhhCFVRhTbhdpOKJ9F+Wu7bqg0xp4o0PHX+0m6u
         DB7V53q9fWmFZvcc7odog5bBHdmSp3Hp86VTzOWRFjKOIj5e7yzyhV+dq13tIylQHCJH
         8RcQ==
X-Gm-Message-State: AOAM533lmbqsqb03yo+MD4K9NtxMDpycYwFwsnyFi/CoCmaGPGn7EYUK
        F1VMzgqCIUDPRNpHucksr0Dwe3hbwZIq2oWegNfYsVog9dKCJzyA0cG5hk/I9aauWMkRsp4Lv41
        G04MEG3cHIdOx7BDC
X-Received: by 2002:a17:906:1c84:: with SMTP id g4mr12260381ejh.99.1624046829132;
        Fri, 18 Jun 2021 13:07:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymURQ+JwV7b+V1F2pnphqLC6Cl2Klj4s5lxuDVf5+VvgJ417d5EIiqn/XBcMZgoEQ/LFVyKw==
X-Received: by 2002:a17:906:1c84:: with SMTP id g4mr12260367ejh.99.1624046828988;
        Fri, 18 Jun 2021 13:07:08 -0700 (PDT)
Received: from krava ([37.188.132.65])
        by smtp.gmail.com with ESMTPSA id yh11sm1402145ejb.16.2021.06.18.13.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 13:07:08 -0700 (PDT)
Date:   Fri, 18 Jun 2021 22:07:04 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next] bpf, x86: Remove unused cnt increase from EMIT
 macro
Message-ID: <YMz86IxKqoXGErAW@krava>
References: <20210616133400.315039-1-jolsa@kernel.org>
 <08876866-c004-ede7-6657-10a15f51f6d8@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08876866-c004-ede7-6657-10a15f51f6d8@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 01:04:08PM +0200, Daniel Borkmann wrote:
> On 6/16/21 3:34 PM, Jiri Olsa wrote:
> > Removing unused cnt increase from EMIT macro together
> > with cnt declarations. This was introduced in commit [1]
> > to ensure proper code generation. But that code was
> > removed in commit [2] and this extra code was left in.
> > 
> > [1] b52f00e6a715 ("x86: bpf_jit: implement bpf_tail_call() helper")
> > [2] ebf7d1f508a7 ("bpf, x64: rework pro/epilogue and tailcall handling in JIT")
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >   arch/x86/net/bpf_jit_comp.c | 39 ++++++++++---------------------------
> >   1 file changed, 10 insertions(+), 29 deletions(-)
> > 
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index 2a2e290fa5d8..19715542cd9c 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -31,7 +31,7 @@ static u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
> >   }
> >   #define EMIT(bytes, len) \
> > -	do { prog = emit_code(prog, bytes, len); cnt += len; } while (0)
> > +	do { prog = emit_code(prog, bytes, len); } while (0)
> >   #define EMIT1(b1)		EMIT(b1, 1)
> >   #define EMIT2(b1, b2)		EMIT((b1) + ((b2) << 8), 2)
> > @@ -239,7 +239,6 @@ struct jit_context {
> >   static void push_callee_regs(u8 **pprog, bool *callee_regs_used)
> >   {
> >   	u8 *prog = *pprog;
> > -	int cnt = 0;
> >   	if (callee_regs_used[0])
> >   		EMIT1(0x53);         /* push rbx */
> > @@ -255,7 +254,6 @@ static void push_callee_regs(u8 **pprog, bool *callee_regs_used)
> >   static void pop_callee_regs(u8 **pprog, bool *callee_regs_used)
> >   {
> >   	u8 *prog = *pprog;
> > -	int cnt = 0;
> >   	if (callee_regs_used[3])
> >   		EMIT2(0x41, 0x5F);   /* pop r15 */
> > @@ -303,7 +301,6 @@ static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf,
> 
> nit: In emit_prologue() we also have cnt that we could just replace with X86_PATCH_SIZE
> directly as well.

right, will send v2

thanks,
jirka

> 
> >   static int emit_patch(u8 **pprog, void *func, void *ip, u8 opcode)
> >   {
> >   	u8 *prog = *pprog;
> 
> Otherwise, lgtm.
> 
> Thanks,
> Daniel
> 

