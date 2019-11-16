Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B27C4FE8F5
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 01:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfKPAB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 19:01:28 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:37682 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfKPAB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 19:01:28 -0500
Received: by mail-qv1-f68.google.com with SMTP id s18so4458510qvr.4;
        Fri, 15 Nov 2019 16:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=14b3kdiFt7KGRqWtA7BSS3n76oZM9Gd1ShnBfNhJNlA=;
        b=Uk3odKo/i8GQNzZydSHpMdNJ1RWpiOwoPdUElnakkphFEPsD4IpU6nKWRSwqCZXxDK
         52apn8ia4YY4UtUNzkAsYtPUzzkPxRhOsvMyUJiLloDuS7+S76VVBZlmj/VOPiZOWCpt
         eAPkh45Upa76OhEtcHAVi8AEVz5YGjpYtW64VThdl7X+M/0vRg1rpdMr0/K2gVChq/LP
         0siBlh4NtD5ZjHrqEc0wyQM1ZhbLsuvX1qwKmUfwADcm7w71v2SuN3QGHIuxYFgsQDi7
         jqNetEcSsPZS19AMTXnQjBwaPKtPT0O+yY6NQ4ZCY0fnJTHNmy7LcWSrOLkqF1Y7k7sD
         JL8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=14b3kdiFt7KGRqWtA7BSS3n76oZM9Gd1ShnBfNhJNlA=;
        b=FooHZgLWxF1CPDgGSGUPLU+eisVD438Bdc4szbFLNNoA7czDLl4abbZIp2xNaGdvcn
         DBKd5SYIZ3BWP4zNxAFmyTtcjfVoV8Mo/xlQPDqm89tkw/3oljJIj1BCYf7IaXGOWssO
         7kva9D1jS2nVjzvcMy27gEQUmdmZN6kVuGJQoMfZQYK+KK0jK0Xh+D/QoIlHHbAeze0E
         i+wrGp17i0ofdYqdnzH7ztVVbBKhMh6dK5OX42BKy/bbLEeOTp7Pu9daqvKw/mIV1N1G
         yzJdowR60mitED7YvIq0wzZ/wkZyjW9+gtrNL+z2nsghDl2HtWrTKXVhR6xwDNQng7Cb
         Yhpg==
X-Gm-Message-State: APjAAAWerSV24kXKEbdmG0PJLENx1v8Ega23Fgy5J5+fXj5uJk5z83jw
        WKa2JLPjJBIGIg8tSV9eYDvvXUlmQlUcZgYjtnE=
X-Google-Smtp-Source: APXvYqzjMRh5zz7LEYzaU+/zIVQiR+MaZh9BCix8WLbw79+tnBYSyjDETu0L3EZmcV8ebaIVbDn8T6GnhYy8vQvyWFI=
X-Received: by 2002:ad4:558e:: with SMTP id e14mr2546486qvx.247.1573862486621;
 Fri, 15 Nov 2019 16:01:26 -0800 (PST)
MIME-Version: 1.0
References: <cover.1573779287.git.daniel@iogearbox.net> <d2364bbaca1569b04e2434d8b58a458f21c685ef.1573779287.git.daniel@iogearbox.net>
 <CAEf4BzZau9d-feGEsOu617b7cd2aSfmmSi2TgwZbf4XZGBHASg@mail.gmail.com> <17b06848-c0e0-e766-912e-e11f85de9eca@iogearbox.net>
In-Reply-To: <17b06848-c0e0-e766-912e-e11f85de9eca@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 15 Nov 2019 16:01:15 -0800
Message-ID: <CAEf4BzZ_e+uriKecarWRu9QJQS6N9hWyy=EKu++_crhpEjs0Tw@mail.gmail.com>
Subject: Re: [PATCH rfc bpf-next 1/8] bpf, x86: generalize and extend
 bpf_arch_text_poke for direct jumps
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 3:42 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 11/16/19 12:22 AM, Andrii Nakryiko wrote:
> > On Thu, Nov 14, 2019 at 5:04 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>
> >> Add BPF_MOD_{NOP_TO_JUMP,JUMP_TO_JUMP,JUMP_TO_NOP} patching for x86
> >> JIT in order to be able to patch direct jumps or nop them out. We need
> >> this facility in order to patch tail call jumps and in later work also
> >> BPF static keys.
> >>
> >> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> >> ---
> >
> > just naming nits, looks good otherwise
> >
> >>   arch/x86/net/bpf_jit_comp.c | 64 ++++++++++++++++++++++++++-----------
> >>   include/linux/bpf.h         |  6 ++++
> >>   2 files changed, 52 insertions(+), 18 deletions(-)
> >>
> >> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> >> index 2e586f579945..66921f2aeece 100644
> >> --- a/arch/x86/net/bpf_jit_comp.c
> >> +++ b/arch/x86/net/bpf_jit_comp.c
> >> @@ -203,8 +203,9 @@ struct jit_context {
> >>   /* Maximum number of bytes emitted while JITing one eBPF insn */
> >>   #define BPF_MAX_INSN_SIZE      128
> >>   #define BPF_INSN_SAFETY                64
> >> -/* number of bytes emit_call() needs to generate call instruction */
> >> -#define X86_CALL_SIZE          5
> >> +
> >> +/* Number of bytes emit_patchable() needs to generate instructions */
> >> +#define X86_PATCHABLE_SIZE     5
> >>
> >>   #define PROLOGUE_SIZE          25
> >>
> >> @@ -215,7 +216,7 @@ struct jit_context {
> >>   static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
> >>   {
> >>          u8 *prog = *pprog;
> >> -       int cnt = X86_CALL_SIZE;
> >> +       int cnt = X86_PATCHABLE_SIZE;
> >>
> >>          /* BPF trampoline can be made to work without these nops,
> >>           * but let's waste 5 bytes for now and optimize later
> >> @@ -480,64 +481,91 @@ static void emit_stx(u8 **pprog, u32 size, u32 dst_reg, u32 src_reg, int off)
> >>          *pprog = prog;
> >>   }
> >>
> >> -static int emit_call(u8 **pprog, void *func, void *ip)
> >> +static int emit_patchable(u8 **pprog, void *func, void *ip, u8 b1)
> >
> > I'd strongly prefer opcode instead of b1 :) also would emit_patch() be
> > a terrible name?
>
> Hmm, been using b1 since throughout the JIT we use u8 b1/b2/b3/.. for our
> EMIT*() macros to denote the encoding positions. So I thought it would be
> more conventional, but could also change to op if preferred.

Well, I've been looking through text_poke_bp() recently, that one
consistently used opcode terminology. See for yourself, the function
is small, so it not too confusing to figure out what it really is.

>
> >>   {
> >>          u8 *prog = *pprog;
> >>          int cnt = 0;
> >>          s64 offset;
> >>
> >
> > [...]
> >
> >>          case BPF_MOD_CALL_TO_NOP:
> >> -               if (memcmp(ip, old_insn, X86_CALL_SIZE))
> >> +       case BPF_MOD_JUMP_TO_NOP:
> >> +               if (memcmp(ip, old_insn, X86_PATCHABLE_SIZE))
> >>                          goto out;
> >> -               text_poke_bp(ip, ideal_nops[NOP_ATOMIC5], X86_CALL_SIZE, NULL);
> >> +               text_poke_bp(ip, ideal_nops[NOP_ATOMIC5], X86_PATCHABLE_SIZE,
> >
> > maybe keep it shorter with X86_PATCH_SIZE?
>
> Sure, then X86_PATCH_SIZE and emit_patch() it is.
>
> >> +                            NULL);
> >>                  break;
> >>          }
> >>          ret = 0;
> >
> > [...]
> >
>
