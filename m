Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA283DADE1
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 22:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbhG2Uoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 16:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233236AbhG2Uob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 16:44:31 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7896C061765
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 13:44:25 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id a93so12338783ybi.1
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 13:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2sP7soCDPCFQt2pnuoVxt8FZcjMCtbC6GMQgGr1t7Nw=;
        b=0XA39dCwvCOfATZkke+fRvQAroXs//4yqjqWeh5k9X2CL4vlGh+u+3NokWhMobTn/w
         8Y+BH3EmcD+jYSWaKYoLBjVQK0aaSdnkO0lVP3aRyJzhX+p1BTSPa7huwhHWhq8YvPqP
         fRuTgAz3Y8YG5b8ZPgU/66OfvSWKpsRPSXT3kjJaX+0LXZFwCGstPV7/2tJe3GldfUGL
         fn9rUm4QlRAVcG/nrG8DLGkpb1aUOOEnx0Td2pTgzViycrQ9ZdcXxR3b68VottyiT+nq
         96Hwm0FPsVhfROs3aYnNTAtUIviU9yqStUWU2QKjXIYRKSSVo9OiipHFwiBxaBiU+Cy2
         CGtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2sP7soCDPCFQt2pnuoVxt8FZcjMCtbC6GMQgGr1t7Nw=;
        b=FoV1dNhmFPdfQm/N8cKlqBarrbbiMlPgiurY/IVui4qg/LAl5bcOKY9C7SmrBVHFW7
         ZBSnVgzZ7YyWC2qPRx3PgHWpcghM8gKEr/Zk8ahAQtiRzM0spsrJbnTNc1c3ca1x4PMT
         uR/1F464tufHzB04BS63uQy7IzbwgiaXu6y4oQXRGnUJUREWKrTYuglKhlnl1d927m37
         f6/uVwEATgyHbUOaXNzpFHeQNecKsbZDbTC6iH8wAGupswKS+IOe9WJrBjsL4x5zzIir
         Is1POIrSk4iNsjPYUSmN74gWRiM9mfJ9m7a8TC/kYnbIshWHD8J5PtBPSiwohil5QPWb
         CNjg==
X-Gm-Message-State: AOAM531YzNqdWSwx6j00bMehtzHPhYICno9kJgFxo+OL/AKICwN5JoiR
        j3iGWzUieYj6UjI41j0ztDUbSEXwp+zgdMUuliwK20vOAvLybB5g
X-Google-Smtp-Source: ABdhPJz1z65a9tj3XyGDOAuJwku1urGEbjBVYDpLqHN5DE/ZPx9EXillEOoyAxtHV+I0hX+96KLlU87L7fQIAWZshiw=
X-Received: by 2002:a25:380c:: with SMTP id f12mr9576334yba.208.1627591464938;
 Thu, 29 Jul 2021 13:44:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-15-johan.almbladh@anyfinetworks.com> <1483fad6-709a-50f5-4b8e-358ad2848dfe@fb.com>
In-Reply-To: <1483fad6-709a-50f5-4b8e-358ad2848dfe@fb.com>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Thu, 29 Jul 2021 22:44:14 +0200
Message-ID: <CAM1=_QT_5A=WBk9gzZCxtsL52DnLbG=W-5EphzikzvYhV59iwQ@mail.gmail.com>
Subject: Re: [PATCH 14/14] bpf/tests: Add tail call test suite
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 4:56 AM Yonghong Song <yhs@fb.com> wrote:
> > +static __init int prepare_tail_call_tests(struct bpf_array **pprogs)
> > +{
> > +     struct bpf_array *progs;
> > +     int ntests = ARRAY_SIZE(tail_call_tests);
> > +     int which, err;
>
> reverse christmas tree?

Will do.

> > +
> > +     /* Allocate the table of programs to be used for tall calls */
> > +     progs = kzalloc(sizeof(*progs) + (ntests + 1) * sizeof(progs->ptrs[0]),
> > +                     GFP_KERNEL);
> > +     if (!progs)
> > +             goto out_nomem;
> > +
> > +     /* Create all eBPF programs and populate the table */
> > +     for (which = 0; which < ntests; which++) {
> > +             struct tail_call_test *test = &tail_call_tests[which];
> > +             struct bpf_prog *fp;
> > +             int len, i;
> > +
> > +             /* Compute the number of program instructions */
> > +             for (len = 0; len < MAX_INSNS; len++) {
> > +                     struct bpf_insn *insn = &test->insns[len];
> > +
> > +                     if (len < MAX_INSNS - 1 &&
> > +                         insn->code == (BPF_LD | BPF_DW | BPF_IMM))
> > +                             len++;
> > +                     if (insn->code == 0)
> > +                             break;
> > +             }
> > +
> > +             /* Allocate and initialize the program */
> > +             fp = bpf_prog_alloc(bpf_prog_size(len), 0);
> > +             if (!fp)
> > +                     goto out_nomem;
> > +
> > +             fp->len = len;
> > +             fp->type = BPF_PROG_TYPE_SOCKET_FILTER;
> > +             fp->aux->stack_depth = test->stack_depth;
> > +             memcpy(fp->insnsi, test->insns, len * sizeof(struct bpf_insn));
> > +
> > +             /* Relocate runtime tail call offsets and addresses */
> > +             for (i = 0; i < len; i++) {
> > +                     struct bpf_insn *insn = &fp->insnsi[i];
> > +                     int target;
> > +
> > +                     if (insn->imm != TAIL_CALL_MARKER)
> > +                             continue;
> > +
> > +                     switch (insn->code) {
> > +                     case BPF_LD | BPF_DW | BPF_IMM:
> > +                             if (insn->dst_reg == R2) {
>
> Looks like the above condition is not needed. It is always true.
>
> > +                                     insn[0].imm = (u32)(long)progs;
> > +                                     insn[1].imm = ((u64)(long)progs) >> 32;
> > +                             }
> > +                             break;
> > +
> > +                     case BPF_ALU | BPF_MOV | BPF_K:
> > +                     case BPF_ALU64 | BPF_MOV | BPF_K:
>
> case BPF_ALU64 | BPF_MOV | BPF_K is not needed.
>
> > +                             if (insn->off == TAIL_CALL_NULL)
> > +                                     target = ntests;
> > +                             else
> > +                                     target = which + insn->off;
> > +                             if (insn->dst_reg == R3)
>
> the same here, insn->dst_reg == R3 is not needed. It is always true.

I added the register checks to further restrict the cases when
rewriting is done, but it might be more clear if the instruction is
always rewritten whenever the tail call marker is set. I can remove
the unnecessary conditions.

> I suggest to set insn->off = 0. Otherwise, it is an illegal insn.
> We won't issue here because we didn't invoke verifier. It is still
> good to make the insn legel.

I agree. Fixing it.
