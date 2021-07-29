Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BAC3DA335
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 14:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbhG2MeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 08:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237205AbhG2MeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 08:34:16 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A66C0613C1
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 05:34:13 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id z18so9933382ybg.8
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 05:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MplWlIomYwR6GQ19oZ8mzVYKlE7ap1pKYKeHoDUIdDY=;
        b=hMnyDUUlHxw2jMkUQmbHEEqfuKXyR0pXCQ9nh24JH+ZSlSmEmg9JU8FlNxbGnYFbYI
         c8bjV+2PR+X+XX4nCgUZiHgVf01mWWZ5ybAFZvZ0z//ba+PVj2c55zmeT9zX4UeplUJE
         THcsR4ZUvNiaUbo2UBBitsTMZ8HHIXAIDooWPOw+CKEVME4Xq9EIQQnRe4hfClWbHd4U
         aUeklQleY51Rnzs0kWKznCrr6FdVBfIcsoM8nRRv/WFacdXAI6/7vO3xE+aYvHU27DKB
         2t3R0btci3Et4YZ2wgu8r1wZlzgf8HIB6SZxGFkXjx1oVzuouywCCJP2sFMVZ82g+UcG
         suqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MplWlIomYwR6GQ19oZ8mzVYKlE7ap1pKYKeHoDUIdDY=;
        b=eWw73CMSqRfILGo1FqaP39ZhSX9/fFSXnp3z4RbcG6yu2Gb3TTZEXwkhzBKLcup6LD
         68TkuppT6jLhYetMOY78Op1isaV7YljHpldt+rkcL7kODO9NLbc2/PMS1mExHxbA5DNg
         g6Uem9QN8z2nPiWA3h1xEH9LPyQKov4t+5AG6T1tSbjWP58//JCPI2RMG79fdK+p/kkc
         HqaFY6zVRPZmKLSABUoDgWVb2XjdSTaEAar45v9tVBFgchzJN8wzs+CAX4eoQELklt+Z
         I3ZPcNNHNR9KREHfbU4IcPvkJUhJC56kXibR8y5dH1BTiLREYRxUA4bHfVzpTuyn1pmG
         lRBA==
X-Gm-Message-State: AOAM531FC7BAKkSE0Zab9mod4vDTh9zIPU0PLjbI0fqg/RyxhkBAbX1Z
        aRHypFVK4oAavP84LbZbAniMR48tTYIM9Brv42YAHQ==
X-Google-Smtp-Source: ABdhPJyP11nsZxPa7I5u98VukcU3bgfBQbCphQavtQwrbdOlpFPLjmA9Rh5GDYTacpOtZWC44LohGizR42s7bXPfHnU=
X-Received: by 2002:a25:380c:: with SMTP id f12mr6768909yba.208.1627562053201;
 Thu, 29 Jul 2021 05:34:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-7-johan.almbladh@anyfinetworks.com> <b134e3bc-a9f7-6c4f-21fe-8d5068ac029e@fb.com>
In-Reply-To: <b134e3bc-a9f7-6c4f-21fe-8d5068ac029e@fb.com>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Thu, 29 Jul 2021 14:34:02 +0200
Message-ID: <CAM1=_QQJ+uYXuU_nOVb3djW-G8wJs4Azz36pXk8mO3vQBuVouQ@mail.gmail.com>
Subject: Re: [PATCH 06/14] bpf/tests: Add more BPF_LSH/RSH/ARSH tests for ALU64
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 1:30 AM Yonghong Song <yhs@fb.com> wrote:
> > @@ -4139,6 +4139,106 @@ static struct bpf_test tests[] = {
> >               { },
> >               { { 0, 0x80000000 } },
> >       },
> > +     {
> > +             "ALU64_LSH_X: Shift < 32, low word",
> > +             .u.insns_int = {
> > +                     BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
> > +                     BPF_ALU32_IMM(BPF_MOV, R1, 12),
> > +                     BPF_ALU64_REG(BPF_LSH, R0, R1),
> > +                     BPF_EXIT_INSN(),
> > +             },
> > +             INTERNAL,
> > +             { },
> > +             { { 0, 0xbcdef000 } }
>
> In bpf_test struct, the result is defined as __u32
>          struct {
>                  int data_size;
>                  __u32 result;
>          } test[MAX_SUBTESTS];
>
> But the above result 0xbcdef000 does not really capture the bpf program
> return value, which should be 0x3456789abcdef000.
> Can we change "result" type to __u64 so the result truly captures the
> program return value?

This was also my though at first, but I don't think that is possible.
As I understand it, the eBPF functions have the prototype int
func(struct *ctx). While the context pointer will have a different
size on 32-bit and 64-bit architectures, the return value will always
be 32 bits on most, or all, platforms.

> We have several other similar cases for the rest of this patch.

I have used two ways to check the full 64-bit result in such cases.

1) Load the expected result as a 64-bit value in a register. Then jump
conditionally if the result matches this value or not. The jump
destinations each set a distinct value in R0, which is finally
examined as the result.

2) Run the test twice. The first one returns the low 32-bits of R0.
The second adds a 32-bit right shift to return the high 32 bits.

When I first wrote the tests I tried to use as few complex
instructions not under test as possible, in order to test each
instruction in isolation. Since the 32-bit right shift is a much
simpler operation than conditional jumps, at least in the 32-bit MIPS
JIT, I chose method (2) for most of the tests. Existing tests seem to
use method (1), so in some cases I used that instead when adding more
tests of the same operation. The motivation for the simple one-by-one
tests is mainly convenience and better diagnostics during JIT
development. Both methods (1) and (2) are equally valid of course.

By the way, thanks a lot for the review, Yonghong!

Johan
