Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F5E3E4BC8
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 20:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhHISDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 14:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234517AbhHISDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 14:03:06 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB0AC061799
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 11:02:45 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id z128so31099429ybc.10
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 11:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wCA9J5vu8WLyWv9M/eqcckDReH23YeoLV3Y1DChmo+o=;
        b=wI98ACsWg4xT9Gglnk4ST7e3TMDTVgxBvNZuzy/hd8dali5RgRFoi+KATnBUvm5TVR
         ZFRS+Qmv7DC36yD/dDwOSLr7OLCNfD4iPcr5uRXRhwsCDz1RHNrirtJ67tCADtZdPJxa
         8uIkYtcOT0BGVT6Hp7PcynYqjKBjgVYap8Cs8BShzeJqifHlvmo35DPf8ZTdJAkGCsXy
         qnlGTMHoSbRbfObgr9nh1Orb+b+GgB0BzsoOOiVaRw3j/Ldv/+cAFnJuuWPIbLmBu7Jb
         5TnHKY7IenANhEYHmGMbiBr15smw6uTQWqrkpi1OeA1iKXo5OENoG4oDY8tJeAY1uejR
         C4iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wCA9J5vu8WLyWv9M/eqcckDReH23YeoLV3Y1DChmo+o=;
        b=RafeFuECyHvOFvXLtRhaTUtudxja/qg2RyJ+0/Dna9KhK1bgFzU2uh+VoeAxRZoIZ7
         lr8nZCmIT9nTWRSkDwm0UmdDKT1jilZmjSzoNAsoVD+hnclP1U5qqe3EOlMfOWMf1BbG
         Hm5IqbWpvlBhqcMnsbgPNeg8NC3BnRjx8WArhTkRJNaWYjTD0pPMFGuGgnuv0l1g07zJ
         nDC5FMSnJh0oayzibncomMCACTUpUjtC2wuRA+ykQOA7O9rLKL8dxmY9QvyrNe3Yb+sL
         lDi4U66TcExQYp9pqEVX/9m5zE0wnun+vX4g+BpL9TOXUiz1ETMl2G94hR10JYJasRyb
         7CGw==
X-Gm-Message-State: AOAM533/QVjmu6aHJU015pS7AREVVuyatHhXBCjVaGfBtd6ODhq+7a9N
        dUqfTpyntR3FbCzdKmTrkL0hw4z5HzlMSCGUdBHBpw==
X-Google-Smtp-Source: ABdhPJysW4mSdUWt1+hMvXh8Mh1uscgcXzXmr7qPvNtu/L+54sFiSyytNvFuO91P8+7yYO8Zg2qEJUSn05lyaYVYIhM=
X-Received: by 2002:a5b:587:: with SMTP id l7mr32608213ybp.208.1628532164602;
 Mon, 09 Aug 2021 11:02:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210809093437.876558-1-johan.almbladh@anyfinetworks.com>
 <20210809093437.876558-8-johan.almbladh@anyfinetworks.com> <bab35321-9142-c51d-7244-438fc5a0efb9@iogearbox.net>
In-Reply-To: <bab35321-9142-c51d-7244-438fc5a0efb9@iogearbox.net>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Mon, 9 Aug 2021 20:02:33 +0200
Message-ID: <CAM1=_QRs3p+u3+QeJXdv8y=dP6NVKYLhozJeR0U6pOY4cqOUCg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 7/7] x86: bpf: Fix comments on tail call count limiting
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        illusionist.neo@gmail.com, zlim.lnx@gmail.com,
        Paul Burton <paulburton@kernel.org>,
        naveen.n.rao@linux.ibm.com, sandipan@linux.ibm.com,
        Luke Nelson <luke.r.nels@gmail.com>, bjorn@kernel.org,
        iii@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        davem@davemloft.net, udknight@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 9, 2021 at 5:42 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 8/9/21 11:34 AM, Johan Almbladh wrote:
> > Before, the comments in the 32-bit eBPF JIT claimed that up to
> > MAX_TAIL_CALL_CNT + 1 tail calls were allowed, when in fact the
> > implementation was using the correct limit of MAX_TAIL_CALL_CNT.
> > Now, the comments are in line with what the code actually does.
> >
> > Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> > ---
> >   arch/x86/net/bpf_jit_comp32.c | 6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
> > index 3bfda5f502cb..8db9ab11abda 100644
> > --- a/arch/x86/net/bpf_jit_comp32.c
> > +++ b/arch/x86/net/bpf_jit_comp32.c
> > @@ -1272,7 +1272,7 @@ static void emit_epilogue(u8 **pprog, u32 stack_depth)
> >    * ... bpf_tail_call(void *ctx, struct bpf_array *array, u64 index) ...
> >    *   if (index >= array->map.max_entries)
> >    *     goto out;
> > - *   if (++tail_call_cnt > MAX_TAIL_CALL_CNT)
> > + *   if (tail_call_cnt++ >= MAX_TAIL_CALL_CNT)
> >    *     goto out;
> >    *   prog = array->ptrs[index];
> >    *   if (prog == NULL)
> > @@ -1307,7 +1307,7 @@ static void emit_bpf_tail_call(u8 **pprog)
> >       EMIT2(IA32_JBE, jmp_label(jmp_label1, 2));
> >
> >       /*
> > -      * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
> > +      * if (tail_call_cnt >= MAX_TAIL_CALL_CNT)
> >        *     goto out;
> >        */
> >       lo = (u32)MAX_TAIL_CALL_CNT;
> > @@ -1321,7 +1321,7 @@ static void emit_bpf_tail_call(u8 **pprog)
> >       /* cmp ecx,lo */
> >       EMIT3(0x83, add_1reg(0xF8, IA32_ECX), lo);
> >
> > -     /* ja out */
> > +     /* jae out */
> >       EMIT2(IA32_JAE, jmp_label(jmp_label1, 2));
>
> You have me confused here ... b61a28cf11d6 ("bpf: Fix off-by-one in tail call count
> limiting") from bpf-next says '[interpreter is now] in line with the behavior of the
> x86 JITs'. From the latter I assumed you implicitly refer to x86-64. Which one did you
> test specifically wrt the prior statement?

I tested both the 64-bit and the 32-bit JITs with QEMU. Both passed,
meaning that the tail call recursion stopped after 32 tail calls.
However, the comments in the code indicated that it would allow one
more call, and also said JA when it actually emitted JAE. This patch
merely fixes the comments in the 32-bit JIT to match the code.

> It looks like x86-64 vs x86-32 differ:
>
>    [...]
>    EMIT2_off32(0x8B, 0x85, tcc_off);         /* mov eax, dword ptr [rbp - tcc_off] */
>    EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
>    EMIT2(X86_JA, OFFSET2);                   /* ja out */
>    EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
>    EMIT2_off32(0x89, 0x85, tcc_off);         /* mov dword ptr [rbp - tcc_off], eax */
>    [...]
>
> So it's ja vs jae ... unless I need more coffee? ;)

Yes, the x86-64 JIT is different. It also pass the test, but I do find
the code and comments a bit confusing too. Since it pass the test, and
the top-level comment correctly states the stop condition as
++tail_call_cnt > MAX_TAIL_CALL_CNT, I left it at that.

On a side note, I see that the x86-64 JIT also has a direct tail call
code path which the other JITs don't seem to have. The tail call test
only checks the indirect tail call code path.

>
> >       /* add eax,0x1 */
> >
>
