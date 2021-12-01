Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07F94654BE
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 19:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351984AbhLASJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244633AbhLASJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:09:37 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03267C061574;
        Wed,  1 Dec 2021 10:06:16 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id e136so65792036ybc.4;
        Wed, 01 Dec 2021 10:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nDftlED1JHWOwIY0c1q3Lh3qalRW5ur7uVqjd0m0XaU=;
        b=q6A1D0TqJIoooMjygBBmSpTrEJWJvBonr2SU6p7OlmKLfe0YJgoCqXkrmZx4dZg+lq
         z73EIn6A/C9MncVTamd8wBadF/tsDBl3rSCLENF5y/5rI1Cn/GO5ValAO1fapcLVn1JU
         iXCOxLzrLmCemizhfVmKKDAmOF1sLjmomO1NAoCExkS2n+nbGXrxlRCgfcLoOtNDRUIx
         UDdBQVK5WLu0vAW0m0Gmn28yeS90HuzVCyRQiOZmpayMdIUoN1QXztHIklwaa5IYwnsk
         CWM/XtNNHm5U1Y4SPw7TYNeqi4KRCKPsBUCOhYXGIY+pf9D58MolV0wPf582/aO9MRon
         7x5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nDftlED1JHWOwIY0c1q3Lh3qalRW5ur7uVqjd0m0XaU=;
        b=OndLgWzG4a3r66rmULvVhZYORGaDy4Ob/tZ4xfJ9KfFgGu65PN+ouhJa2D0f+9btc4
         NdFxlQaLdtgtYQ77cYO7kmf1v212RgBtt/sRPwUUANZVemB9GprPZYyMLVEuCaX85aE4
         7Ktp5qcn5Vabx8GUFijS9dbH7vEl78VDkmqLaj8LYWtcLR8f+UpklcWxY9axte4pVbWN
         R9c2AsV1wZmC/ZrWwHNcUb/NQgdDdCrlDQpIznWMccrCCGYEuh2Rk1N7sMb6AV9/RkAs
         GwtRuOAQkGnhyoCLFiXh8Kle/stqHRx2AsNg9qQGh+Vc9H9y4noOW63e3abVF+AtEfJT
         8cJQ==
X-Gm-Message-State: AOAM532MODd4QJWAhULUYgYCXvtPGnusVth1H7N85I3yQWJISG/jKMfI
        29huikBfW0bEL3wg9I0wq9SAYnk8sEQ5k6Hh4yU=
X-Google-Smtp-Source: ABdhPJypBu7Aiw9YJv/mYNCu3Km6mxYSw370MDJoJFxL4MNaCSUzfN5mqpzyin5rWFzC4JN3zkP3zYsOAZHrQCANR5E=
X-Received: by 2002:a25:54e:: with SMTP id 75mr8846537ybf.393.1638381974946;
 Wed, 01 Dec 2021 10:06:14 -0800 (PST)
MIME-Version: 1.0
References: <20211019144655.3483197-1-maximmi@nvidia.com> <20211019144655.3483197-10-maximmi@nvidia.com>
 <CACAyw9_MT-+n_b1pLYrU+m6OicgRcndEBiOwb5Kc1w0CANd_9A@mail.gmail.com>
 <87y26nekoc.fsf@toke.dk> <1901a631-25c0-158d-b37f-df6d23d8e8ab@nvidia.com>
 <103c5154-cc29-a5ab-3c30-587fc0fbeae2@fb.com> <1b9b3c40-f933-59c3-09e6-aa6c3dda438f@nvidia.com>
 <68a63a77-f856-1690-cb60-327fc753b476@fb.com> <3e673e1a-2711-320b-f0be-2432cf4bbe9c@nvidia.com>
 <f08fa9aa-8b0d-8217-1823-2830b2b2587c@fb.com> <cbd2e655-8113-e719-4b9d-b3987c398b04@nvidia.com>
 <ce2d9407-b141-6647-939f-0f679157fdf7@fb.com> <0a958197-67ab-8773-3611-f8156ebdb9e0@nvidia.com>
 <4f895364-a546-c7dd-b6d2-2a80628f2d9a@fb.com>
In-Reply-To: <4f895364-a546-c7dd-b6d2-2a80628f2d9a@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Dec 2021 10:06:04 -0800
Message-ID: <CAEf4Bzajt1Q-aYD1uecd9crtKcOxNe0_XsNcJ8VPX4fJ+D8JtA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 09/10] bpf: Add a helper to issue timestamp
 cookies in XDP
To:     Yonghong Song <yhs@fb.com>
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>, Tariq Toukan <tariqt@nvidia.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 10:40 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 11/29/21 9:51 AM, Maxim Mikityanskiy wrote:
> > On 2021-11-26 19:07, Yonghong Song wrote:
> >>
> >>
> >> On 11/26/21 8:50 AM, Maxim Mikityanskiy wrote:
> >>> On 2021-11-26 07:43, Yonghong Song wrote:
> >>>>
> >>>>
> >>>> On 11/25/21 6:34 AM, Maxim Mikityanskiy wrote:
> >>>>> On 2021-11-09 09:11, Yonghong Song wrote:
> >>>>>>
> >>>>>>
> >>>>>> On 11/3/21 7:02 AM, Maxim Mikityanskiy wrote:
> >>>>>>> On 2021-11-03 04:10, Yonghong Song wrote:
> >>>>>>>>
> >>>>>>>>
> >>>>>>>> On 11/1/21 4:14 AM, Maxim Mikityanskiy wrote:
> >>>>>>>>> On 2021-10-20 19:16, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >>>>>>>>>> Lorenz Bauer <lmb@cloudflare.com> writes:
> >>>>>>>>>>
> >>>>>>>>>>>> +bool cookie_init_timestamp_raw(struct tcphdr *th, __be32
> >>>>>>>>>>>> *tsval, __be32 *tsecr)
> >>>>>>>>>>>
> >>>>>>>>>>> I'm probably missing context, Is there something in this
> >>>>>>>>>>> function that
> >>>>>>>>>>> means you can't implement it in BPF?
> >>>>>>>>>>
> >>>>>>>>>> I was about to reply with some other comments but upon closer
> >>>>>>>>>> inspection
> >>>>>>>>>> I ended up at the same conclusion: this helper doesn't seem to
> >>>>>>>>>> be needed
> >>>>>>>>>> at all?
> >>>>>>>>>
> >>>>>>>>> After trying to put this code into BPF (replacing the
> >>>>>>>>> underlying ktime_get_ns with ktime_get_mono_fast_ns), I
> >>>>>>>>> experienced issues with passing the verifier.
> >>>>>>>>>
> >>>>>>>>> In addition to comparing ptr to end, I had to add checks that
> >>>>>>>>> compare ptr to data_end, because the verifier can't deduce that
> >>>>>>>>> end <=3D data_end. More branches will add a certain slowdown (n=
ot
> >>>>>>>>> measured).
> >>>>>>>>>
> >>>>>>>>> A more serious issue is the overall program complexity. Even
> >>>>>>>>> though the loop over the TCP options has an upper bound, and
> >>>>>>>>> the pointer advances by at least one byte every iteration, I
> >>>>>>>>> had to limit the total number of iterations artificially. The
> >>>>>>>>> maximum number of iterations that makes the verifier happy is
> >>>>>>>>> 10. With more iterations, I have the following error:
> >>>>>>>>>
> >>>>>>>>> BPF program is too large. Processed 1000001 insn
> >>>>>>>>>
> >>>>>>>>>                         processed 1000001 insns (limit 1000000)
> >>>>>>>>> max_states_per_insn 29 total_states 35489 peak_states 596
> >>>>>>>>> mark_read 45
> >>>>>>>>>
> >>>>>>>>> I assume that BPF_COMPLEXITY_LIMIT_INSNS (1 million) is the
> >>>>>>>>> accumulated amount of instructions that the verifier can
> >>>>>>>>> process in all branches, is that right? It doesn't look
> >>>>>>>>> realistic that my program can run 1 million instructions in a
> >>>>>>>>> single run, but it might be that if you take all possible flows
> >>>>>>>>> and add up the instructions from these flows, it will exceed 1
> >>>>>>>>> million.
> >>>>>>>>>
> >>>>>>>>> The limitation of maximum 10 TCP options might be not enough,
> >>>>>>>>> given that valid packets are permitted to include more than 10
> >>>>>>>>> NOPs. An alternative of using bpf_load_hdr_opt and calling it
> >>>>>>>>> three times doesn't look good either, because it will be about
> >>>>>>>>> three times slower than going over the options once. So maybe
> >>>>>>>>> having a helper for that is better than trying to fit it into B=
PF?
> >>>>>>>>>
> >>>>>>>>> One more interesting fact is the time that it takes for the
> >>>>>>>>> verifier to check my program. If it's limited to 10 iterations,
> >>>>>>>>> it does it pretty fast, but if I try to increase the number to
> >>>>>>>>> 11 iterations, it takes several minutes for the verifier to
> >>>>>>>>> reach 1 million instructions and print the error then. I also
> >>>>>>>>> tried grouping the NOPs in an inner loop to count only 10 real
> >>>>>>>>> options, and the verifier has been running for a few hours
> >>>>>>>>> without any response. Is it normal?
> >>>>>>>>
> >>>>>>>> Maxim, this may expose a verifier bug. Do you have a reproducer
> >>>>>>>> I can access? I would like to debug this to see what is the root
> >>>>>>>> case. Thanks!
> >>>>>>>
> >>>>>>> Thanks, I appreciate your help in debugging it. The reproducer is
> >>>>>>> based on the modified XDP program from patch 10 in this series.
> >>>>>>> You'll need to apply at least patches 6, 7, 8 from this series to
> >>>>>>> get new BPF helpers needed for the XDP program (tell me if that's
> >>>>>>> a problem, I can try to remove usage of new helpers, but it will
> >>>>>>> affect the program length and may produce different results in
> >>>>>>> the verifier).
> >>>>>>>
> >>>>>>> See the C code of the program that passes the verifier (compiled
> >>>>>>> with clang version 12.0.0-1ubuntu1) in the bottom of this email.
> >>>>>>> If you increase the loop boundary from 10 to at least 11 in
> >>>>>>> cookie_init_timestamp_raw(), it fails the verifier after a few
> >>>>>>> minutes.
> >>>>>>
> >>>>>> I tried to reproduce with latest llvm (llvm-project repo),
> >>>>>> loop boundary 10 is okay and 11 exceeds the 1M complexity limit.
> >>>>>> For 10,
> >>>>>> the number of verified instructions is 563626 (more than 0.5M) so
> >>>>>> it is
> >>>>>> totally possible that one more iteration just blows past the limit=
.
> >>>>>
> >>>>> So, does it mean that the verifying complexity grows exponentially
> >>>>> with increasing the number of loop iterations (options parsed)?
> >>>>
> >>>> Depending on verification time pruning results, it is possible
> >>>> slightly increase number of branches could result quite some (2x,
> >>>> 4x, etc.) of
> >>>> to-be-verified dynamic instructions.
> >>>
> >>> Is it at least theoretically possible to make this coefficient below
> >>> 2x? I.e. write a loop, so that adding another iteration will not
> >>> double the number of verified instructions, but will have a smaller
> >>> increase?
> >>>
> >>> If that's not possible, then it looks like BPF can't have loops
> >>> bigger than ~19 iterations (2^20 > 1M), and this function is not
> >>> implementable in BPF.
> >>
> >> This is the worst case. As I mentioned pruning plays a huge role in
> >> verification. Effective pruning can add little increase of dynamic
> >> instructions say from 19 iterations to 20 iterations. But we have
> >> to look at verifier log to find out whether pruning is less effective =
or
> >> something else... Based on my experience, in most cases, pruning is
> >> quite effective. But occasionally it is not... You can look at
> >> verifier.c file to roughly understand how pruning work.
> >>
> >> Not sure whether in this case it is due to less effective pruning or
> >> inherently we just have to go through all these dynamic instructions
> >> for verification.
> >>
> >>>
> >>>>>
> >>>>> Is it a good enough reason to keep this code as a BPF helper,
> >>>>> rather than trying to fit it into the BPF program?
> >>>>
> >>>> Another option is to use global function, which is verified separate=
ly
> >>>> from the main bpf program.
> >>>
> >>> Simply removing __always_inline didn't change anything. Do I need to
> >>> make any other changes? Will it make sense to call a global function
> >>> in a loop, i.e. will it increase chances to pass the verifier?
> >>
> >> global function cannot be static function. You can try
> >> either global function inside the loop or global function
> >> containing the loop. It probably more effective to put loops
> >> inside the global function. You have to do some experiments
> >> to see which one is better.
> >
> > Sorry for a probably noob question, but how can I pass data_end to a
> > global function? I'm getting this error:
> >
> > Validating cookie_init_timestamp_raw() func#1...
> > arg#4 reference type('UNKNOWN ') size cannot be determined: -22
> > processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0
> > peak_states 0 mark_read 0
> >
> > When I removed data_end, I got another one:
> >
> > ; opcode =3D ptr[0];
> > 969: (71) r8 =3D *(u8 *)(r0 +0)
> >   R0=3Dmem(id=3D0,ref_obj_id=3D0,off=3D20,imm=3D0)
> > R1=3Dmem(id=3D0,ref_obj_id=3D0,off=3D0,umin_value=3D4,umax_value=3D60,v=
ar_off=3D(0x0;
> > 0x3f),s32_min_value=3D0,s32_max_value=3D63,u32_max_value=3D63)
> >   R2=3DinvP0 R3=3DinvP0 R4=3Dmem_or_null(id=3D6,ref_obj_id=3D0,off=3D0,=
imm=3D0)
> > R5=3DinvP0 R6=3Dmem_or_null(id=3D5,ref_obj_id=3D0,off=3D0,imm=3D0)
> > R7=3Dmem(id=3D0,ref_obj_id=3D0,off=3D0,imm=3D0) R10=3Dfp0 fp
> > -8=3D00000000 fp-16=3DinvP15
> > invalid access to memory, mem_size=3D20 off=3D20 size=3D1
> > R0 min value is outside of the allowed memory range
> > processed 20 insns (limit 1000000) max_states_per_insn 0 total_states 2
> > peak_states 2 mark_read 1
> >
> > It looks like pointers to the context aren't supported:
> >
> > https://www.spinics.net/lists/bpf/msg34907.html
> >
> >  > test_global_func11 - check that CTX pointer cannot be passed
> >
> > What is the standard way to pass packet data to a global function?
>
> Since global function is separately verified, you need to pass the 'ctx'
> to the global function and do the 'data_end' check again in the global
> function. This will incur some packet re-parsing overhead similar to
> tail calls.

Now that the bpf_loop() helper landed, it's another option for doing
repeated work. Please see [0].

  [0] https://patchwork.kernel.org/project/netdevbpf/list/?series=3D587497&=
state=3D*

>
> >
> > Thanks,
> > Max
> >
> >>>
> >>>>>
> >>>>>>
> >>>>>>> If you apply this tiny change, it fails the verifier after about
> >>>>>>> 3 hours:
> >>>>>>>
> >>>> [...]
> >>>
> >
