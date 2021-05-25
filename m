Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629AF3909DD
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 21:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhEYTtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 15:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbhEYTtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 15:49:11 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B580AC061574;
        Tue, 25 May 2021 12:47:40 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id o18so7040245ybc.8;
        Tue, 25 May 2021 12:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sTYN+8SqG2RGBqoSV7w+w17JB1NhOulyR0vbBWb1CRc=;
        b=hgoOnq2JUlX3uaO7fVG+ppb4uuFJzdtV1eWWJWP6MEkF5BZl5/saOSO10dkjPUH3dX
         bAaNEigiDAEdgNONOyoe2YEhVIR+vfR8oSOQYGq2rKHfT2SnrFOLoK9hq/Ff8gKuT1Oz
         C/B1SuI8wz2c85+oV0D4g8JqIHuGYChBXQ7ZtMNf8U4LFZjEq8Idb97eGMSmGi3f3WWo
         H7MtR/+F8ESCFWwCERPP78bUWOdhSCdkvK0gjHEyN1qnw5/kQD7yotBbm8uSHl/4Ha6w
         rHQAmTZFIodjG6o9uLR256Io27UnT9wz4OBD88m+uPj4+Y9Qlw4VNWxjBPCIMXZzsSlV
         05QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sTYN+8SqG2RGBqoSV7w+w17JB1NhOulyR0vbBWb1CRc=;
        b=dKiF+H549beS4RgiE4+bSLf3iWPKEQUAvWlPB2d3VNs3r0pS+s9xSDctN22yi0TjTO
         ro4lkuDHjH97xPBwH82LI1CcYSt4Ph3zCrNtyRWiOYMs2ft2WJKaChr8PzUnlZTVqEij
         GxclQAZR0sXnxtGZ0ky7WEe4CjN+b0pRG6u9qcmP5lAC4d41fKDQxJkHNOV3r9aDV54+
         kAXIdk5/Dj+P3Qtvd09NtsjiYKR9o3S2VqEDHvXwexJP1SljKpc4gBnVq9wgblDUeX3o
         0j094YDKqLiaVxoemHrY5hilFlfbErRKUtBxK0S7jgk5SCQodhvSPDvz9DV5JT6QSCO9
         vaOw==
X-Gm-Message-State: AOAM530RK1BVb6ecHhx5rNaOxmRMh1NQlbkmTOTR9O5Natkt3L+JHd+M
        ochBDHuL0zctMtNDyACpLrjBoyq9dnSK5C3oNRX5iGt7
X-Google-Smtp-Source: ABdhPJxcrG+ChvQY54LAI1DHSAUkuvWwz8netKiWYKqTKpP1S5rtjOYLNmuPvbivoqM9CEgkSKCEPVEm/U2xBoO66Aw=
X-Received: by 2002:a25:7246:: with SMTP id n67mr44782688ybc.510.1621972059940;
 Tue, 25 May 2021 12:47:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <CACAyw9-7dPx1vLNQeYP9Zqx=OwNcd2t1VK3XGD_aUZZG-twrOg@mail.gmail.com>
 <CAADnVQLqa6skQKsUK=LO5JDZr8xM_rwZPOgA1F39UQRim1P8vw@mail.gmail.com>
 <CAEf4Bza2cupmVZZRx4yWOQBQ7fnaw5pwCQJx9j1HWp=0eUiA1A@mail.gmail.com> <CAM_iQpXn8KyLtApiJOkjKfrhadeG-j0Z+QOBS6SFJjs1as0ZQg@mail.gmail.com>
In-Reply-To: <CAM_iQpXn8KyLtApiJOkjKfrhadeG-j0Z+QOBS6SFJjs1as0ZQg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 25 May 2021 12:47:28 -0700
Message-ID: <CAEf4BzbzviuM2xXAc_v8vf=KO1F1q1iy3Jmzrb8ZdF_3Vo22QA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 10:22 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, May 24, 2021 at 12:13 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > I second the use of BPF_PROG_TEST_RUN (a.k.a. BPF_PROG_RUN now) to
> > "mirror" such APIs to user-space. We have so much BPF-side
>
> Except the expiration time is stored in user-space too if you just
> use user-space timers to trigger BPF_PROG_TEST_RUN.
> Modifying expiration based on its current value in timer callbacks
> is very common. For example in conntrack use case, we want the
> GC timer to run sooner in the next run if we get certain amount of
> expired items in current run.

I'm not entirely sure what all this means, sorry. My general point is
that instead of doing bpf() syscall with a new custom command (e.g.,
BPF_TIMER_UPDATE), you can just fire your custom BPF program with
BPF_TEST_RUN. You can pass custom timeouts or any other
user-space-provided settings either through global variables, custom
maps, or directly as a context. So you have full control over what
should be set when and why, we just avoid adding tons of custom bpf()
syscall commands for every single feature.

>
>
> > functionality and APIs that reflecting all of that with special
> > user-space-facing BPF commands is becoming quite impractical. E.g., a
> > long time ago there was a proposal to add commands to push data to BPF
> > ringbuf from user-space for all kinds of testing scenarios. We never
> > did that because no one bothered enough, but now I'd advocate that a
> > small custom BPF program that is single-shot through BPF_PROG_RUN is a
> > better way to do this. Similarly for timers and whatever other
> > functionality. By doing everything from BPF program we also side-step
> > potential subtle differences in semantics between BPF-side and
> > user-space-side.
>
> I am confused about what you are saying, because we can already
> trigger BPF_PROG_RUN with a user-space timer for a single shot,
> with the current kernel, without any modification. So this sounds like
> you are against adding any timer on the eBPF side, but on the other
> hand, you are secoding to Alexei's patch... I am completely lost.

I'm arguing against adding more custom commands to bpf() syscall. And
I was talking about triggering BPF program directly from user-space
with BPF_PROG_TEST_RUN/BPF_PROG_RUN command, not through some timers.

>
> Very clearly, whatever you described as "single shot" is not what we
> want from any perspective.

I'm not sure we are even talking about the same things, so I doubt
"clearly" in this case.

>
> Thanks.
