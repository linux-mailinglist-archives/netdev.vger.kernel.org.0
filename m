Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE0B7152119
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 20:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgBDTag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 14:30:36 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37992 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgBDTaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 14:30:35 -0500
Received: by mail-qt1-f194.google.com with SMTP id c24so15288969qtp.5;
        Tue, 04 Feb 2020 11:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UapTR/Swn2AywRKzX/GSR/rd23O04e9h6Fgs9p2msUo=;
        b=o/eOozhV6u7iYKKKZLmW9I9eE+A50S7MONuuj7k/cxVH+dM2FEQTnarK5ohzH6rGvj
         0CgNbVzW529C0KjCozjxar2OsHiNfHWDnX2D253V7ISvOQqErGLlZMwIM+CvfvAk/ETr
         kIN2VYeX2wVepBOg7pBlY3ot6HrDTlJcZar8+SV0kQAuWlb8sPSPR88RhgMETAMeMdzY
         5OSNHeIIxUDDbrEHfmSZ+8Tu9uVC1FThvyOAscXaxa6fYkHHiOzH0GdC3vVlVJ72f7F6
         bWTdyt9dGFRZE3xFNu6izLDDJf4wFBZDkFrHyopiOWXrfO0v+0bih6u0gyOnJ/ksyvBb
         32Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UapTR/Swn2AywRKzX/GSR/rd23O04e9h6Fgs9p2msUo=;
        b=D8/fl8ysVBYsuMreGgoJ6g9oyKGASzItM6bd0laCA9V9ifLJ4BDYo16yX+HOJ89Wx9
         ev4OMGrQz8B3lIo+REwDINOdPyMzimBl60+YChAaY8km6mGwhkE7SRcxe+a5HJWINCET
         /gSbzF5eq1cfIJuWr69oMbDzE1Tgku4JuCHvgcaB8wcFCc58ZDQjYi+dh2YOwSrzy4hq
         SPB8WltlMox/Lw+h6lcbAauddvqOuA7Tk105AaHoPhObtC0SsaQUxn/sHjo7l6TC4xXB
         0iuYu6BjVVcg5+3en8jUv1Sx5gsQAPAeyXwI2tuR+ibNpSlDq+6yPMIi/s4k57edI73i
         t+mA==
X-Gm-Message-State: APjAAAUwGuPR9c796TUq/CO98Ra/ZUbWeVZPmMI7j/5Ex1Mk8Z+CRWwj
        eynK3SgXNoEVQvzqeyB+b0yDzROszrVUQ3YkluE=
X-Google-Smtp-Source: APXvYqzynoTQgpdm/iT9SFNSo/qjNEMHfOmhlVwoEI483RemBJB+ylGnJ7qiC5IrDY/m23437c91LCoT0rOjsfwP7pU=
X-Received: by 2002:ac8:554b:: with SMTP id o11mr30093106qtr.36.1580844634484;
 Tue, 04 Feb 2020 11:30:34 -0800 (PST)
MIME-Version: 1.0
References: <20200128021145.36774-1-palmerdabbelt@google.com>
In-Reply-To: <20200128021145.36774-1-palmerdabbelt@google.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 4 Feb 2020 20:30:23 +0100
Message-ID: <CAJ+HfNh2csyH2xZtGFXW1zwBEW4+bo_E60PWPydJkB6zZTVx3A@mail.gmail.com>
Subject: Re: arm64: bpf: Elide some moves to a0 after calls
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, zlim.lnx@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Shuah Khan <shuah@kernel.org>, Netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jan 2020 at 03:14, Palmer Dabbelt <palmerdabbelt@google.com> wro=
te:
>
> There's four patches here, but only one of them actually does anything.  =
The
> first patch fixes a BPF selftests build failure on my machine and has alr=
eady
> been sent to the list separately.  The next three are just staged such th=
at
> there are some patches that avoid changing any functionality pulled out f=
rom
> the whole point of those refactorings, with two cleanups and then the ide=
a.
>
> Maybe this is an odd thing to say in a cover letter, but I'm not actually=
 sure
> this patch set is a good idea.  The issue of extra moves after calls came=
 up as
> I was reviewing some unrelated performance optimizations to the RISC-V BP=
F JIT.
> I figured I'd take a whack at performing the optimization in the context =
of the
> arm64 port just to get a breath of fresh air, and I'm not convinced I lik=
e the
> results.
>
> That said, I think I would accept something like this for the RISC-V port
> because we're already doing a multi-pass optimization for shrinking funct=
ion
> addresses so it's not as much extra complexity over there.  If we do that=
 we
> should probably start puling some of this code into the shared BPF compil=
er,
> but we're also opening the doors to more complicated BPF JIT optimization=
s.
> Given that the BPF JIT appears to have been designed explicitly to be
> simple/fast as opposed to perform complex optimization, I'm not sure this=
 is a
> sane way to move forward.
>

Obviously I can only speak for myself and the RISC-V JIT, but given
that we already have opened the door for more advanced translations
(branch relaxation e.g.), I think that this makes sense. At the same
time we don't want to go all JVM on the JITs. :-P

> I figured I'd send the patch set out as more of a question than anything =
else.
> Specifically:
>
> * How should I go about measuring the performance of these sort of
>   optimizations?  I'd like to balance the time it takes to run the JIT wi=
th the
>   time spent executing the program, but I don't have any feel for what re=
al BPF
>   programs look like or have any benchmark suite to run.  Is there someth=
ing
>   out there this should be benchmarked against?  (I'd also like to know t=
hat to
>   run those benchmarks on the RISC-V port.)

If you run the selftests 'test_progs' with -v it'll measure/print the
execution time of the programs. I'd say *most* BPF program invokes a
helper (via call). It would be interesting to see, for say the
selftests, how often the optimization can be performed.

> * Is this the sort of thing that makes sense in a BPF JIT?  I guess I've =
just
>   realized I turned "review this patch" into a way bigger rabbit hole tha=
n I
>   really want to go down...
>

I'd say 'yes'. My hunch, and the workloads I've seen, BPF programs are
usually loaded, and then resident for a long time. So, the JIT time is
not super critical. The FB/Cilium folks can definitely provide a
better sample point, than my hunch. ;-)


Bj=C3=B6rn
