Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5251403957
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 14:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351605AbhIHMBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 08:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351620AbhIHMBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 08:01:18 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEBBC061575
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 05:00:09 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id v10so3003869ybq.7
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 05:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T+AMg1zReI19HE1EuOLUMNbMBpP5wSIb6Z66e1lZ3D4=;
        b=tm/eqPDhxCGiURJ1qqV2KFyTAmGihGSF+FdWVRTqbnxTJwRMuk0+vV8+DT6lj8vdBs
         DK7S0oUVi8UDU+1BpsnQ3ZD7nJKmA0IY8YKeVi3OBXwdiE/PZ5HseqV5Rfw9ayJM8Had
         VngCfa1ybKwVTqf68icm4mCptTFW6flyk+trIrKyJYiCuJMV6jJagnVNRrw/s0vxNPrK
         +1bSBVa+xFJZ2E6jdiGmm2eWC7Xu5eG2od+hwsFq1R1bPb97Er3a+UXIYf4pMFFjUgT+
         r0UE2L3VS6ynVEB08j7E8PgpfnuM3NJSEPW6mnLdjHzAq/AVO9xKtVKPfcCJo9w97NyN
         AWiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T+AMg1zReI19HE1EuOLUMNbMBpP5wSIb6Z66e1lZ3D4=;
        b=EcYs+klbxcBqUmq/wlXPV8IWunk7ik+eoh/5tUcAatl+r2EmPdgl14qsVRGVg8Kfb6
         0XgNLaW6lYQNBotOnuRbmNSENrU+b2FaHJAm7lsjRCR+tkTWd6/ZpTCpiq/iC4VScWEj
         XnIYmHTmPyw4gg/ZfR9PA832acy2C4+HjC/hxWJUlWPNnrWnajvhZ7qAj9MfcQumpUgs
         hd0X4+S6VHvD9E/INY5H2i+/Aa5AUMgYGFocvxuRw6c903BaPoqoHXx6w0FQryKHaRHR
         G4aaAxlmuwyUW9T6xRD8qe+Ra/kVWqyg4ROhGhH/GUuzaL7TuMN/mf6hRrVVtCQafCfV
         O8Dw==
X-Gm-Message-State: AOAM530Ckjf/0e9lX7ykBXTbfJh2bSM12ZJV11V1jl9r1RrcTElBiM7L
        dOARAyPWXso7zbrfWTGq3vESgM975NyhclCcciQHiA==
X-Google-Smtp-Source: ABdhPJyyIINtQshUJv8qJXYHxa3CYRVsideSszvqho1ZSvcoXn9YpdFX6NJwmkVTEoVZvdZ6+zDbyugkJMNKCukzzsE=
X-Received: by 2002:a25:c006:: with SMTP id c6mr4406654ybf.480.1631102409145;
 Wed, 08 Sep 2021 05:00:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
 <20210907222339.4130924-14-johan.almbladh@anyfinetworks.com>
 <fe04c10b5991a5fb0656fe272c137a73ec7d2472.camel@linux.ibm.com>
 <CAM1=_QTC077YiaJ_7x=ooq2HyKhYFEPt_C04y1uo4tNEyGioFA@mail.gmail.com> <b464eff1-4cdf-47f7-07f7-d1343e8dd2f7@iogearbox.net>
In-Reply-To: <b464eff1-4cdf-47f7-07f7-d1343e8dd2f7@iogearbox.net>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Wed, 8 Sep 2021 13:59:58 +0200
Message-ID: <CAM1=_QQNqWLOi4ZNXTj=kc=t3tvPcJR=7FkhCkjB5tEr+d70zA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 13/13] bpf/tests: Add tail call limit test
 with external function call
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 8, 2021 at 1:46 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 9/8/21 12:53 PM, Johan Almbladh wrote:
> > On Wed, Sep 8, 2021 at 12:10 PM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
> >> On Wed, 2021-09-08 at 00:23 +0200, Johan Almbladh wrote:
> >>> This patch adds a tail call limit test where the program also emits
> >>> a BPF_CALL to an external function prior to the tail call. Mainly
> >>> testing that JITed programs preserve its internal register state, for
> >>> example tail call count, across such external calls.
> >>>
> >>> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> >>> ---
> >>>   lib/test_bpf.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++---
> >>>   1 file changed, 48 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> >>> index 7475abfd2186..6e45b4da9841 100644
> >>> --- a/lib/test_bpf.c
> >>> +++ b/lib/test_bpf.c
> >>> @@ -12259,6 +12259,20 @@ static struct tail_call_test tail_call_tests[]
> >>> = {
> >>>                  },
> >>>                  .result = MAX_TAIL_CALL_CNT + 1,
> >>>          },
> >>> +       {
> >>> +               "Tail call count preserved across function calls",
> >>> +               .insns = {
> >>> +                       BPF_ALU64_IMM(BPF_ADD, R1, 1),
> >>> +                       BPF_STX_MEM(BPF_DW, R10, R1, -8),
> >>> +                       BPF_CALL_REL(0),
> >>> +                       BPF_LDX_MEM(BPF_DW, R1, R10, -8),
> >>> +                       BPF_ALU32_REG(BPF_MOV, R0, R1),
> >>> +                       TAIL_CALL(0),
> >>> +                       BPF_EXIT_INSN(),
> >>> +               },
> >>> +               .stack_depth = 8,
> >>> +               .result = MAX_TAIL_CALL_CNT + 1,
> >>> +       },
> >>>          {
> >>>                  "Tail call error path, NULL target",
> >>>                  .insns = {
> >>
> >> There seems to be a problem with BPF_CALL_REL(0) on s390, since it
> >> assumes that test_bpf_func and __bpf_call_base are within +-2G of
> >> each other, which is not (yet) the case.
> >
> > The idea with this test is to mess up a JITed program's internal state
> > if it does not properly save/restore those regs. I would like to keep
> > the test in some form, but I do see the problem here.
> >
> > Another option could perhaps be to skip this test at runtime if the
> > computed offset is outside +-2G. If the offset is greater than that it
> > does not fit into the 32-bit BPF immediate field, and must therefore
> > be skipped. This would work for other archs too.
>
> Sounds reasonable as a work-around/to move forward.

I'll do this and prepare a v3 then.

>
> > Yet another solution would be call one or several bpf helpers instead.
> > As I understand it, they should always be located within this range,
> > otherwise they would not be callable from a BPF program. The reason I
> > did not do this was because I found helpers that don't require any
> > context to be too simple. Ideally one would want to call something
> > that uses pretty much all available caller-saved CPU registers. I
> > figured snprintf would be complex/nasty enough for this purpose.
>
> Potentially bpf_csum_diff() could also be a candidate, and fairly
> straight forward to set up from raw asm.

Thanks, I will take a look at it.

>
> >> I can't think of a good fix, so how about something like this?
> >>
> >> --- a/lib/test_bpf.c
> >> +++ b/lib/test_bpf.c
> >> @@ -12257,6 +12257,7 @@ static struct tail_call_test tail_call_tests[]
> >> = {
> >>                  },
> >>                  .result = MAX_TAIL_CALL_CNT + 1,
> >>          },
> >> +#ifndef __s390__
> >>          {
> >>                  "Tail call count preserved across function calls",
> >>                  .insns = {
> >> @@ -12271,6 +12272,7 @@ static struct tail_call_test tail_call_tests[]
> >> = {
> >>                  .stack_depth = 8,
> >>                  .result = MAX_TAIL_CALL_CNT + 1,
> >>          },
> >> +#endif
> >>          {
> >>                  "Tail call error path, NULL target",
> >>                  .insns = {
> >>
> >> [...]
> >>
>
