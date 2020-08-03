Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1611239E9F
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 07:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgHCFKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 01:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgHCFKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 01:10:43 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448C1C06174A;
        Sun,  2 Aug 2020 22:10:43 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id q3so62203ybp.7;
        Sun, 02 Aug 2020 22:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DBnDjn7vidDkpVU0WID8k/kuqtUn/mEBKE1Jn9YiCUg=;
        b=iTzcJA1Rs9SjWutqGbiB+/Y0adyCk2lZYULEWoM72kmyroik/YInYByz8zbeXPTc2d
         PUYBq7kt5w2/uAFTAPM18+T3g46xAnBmK+Sstq7z/wNM3p0Lt4x+9gzfPSc6ozLRUM2t
         RkM9McdeoAOskWcHTcfhFTVx4K4pVTHrkULcKpIIPUkVe8TZReL53NxCF3aXxfGa4M/0
         jlHUQ8sz364daT82VFZulbY7KBPWoNC4U1+sBPYDQvnxJ5q6GrmcVWnEtLyXYUqB/nNZ
         8HTkVSBir0Rv0JdVnEhgnVIFGGR0+M/SYBc1Dz4tKE/kEM/ppLHBCbPtOFDv2Gzovb2O
         mc6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DBnDjn7vidDkpVU0WID8k/kuqtUn/mEBKE1Jn9YiCUg=;
        b=b3Z4pdrfdizo/Npro1bRHTLZXTA6sv0Q7xc6N1Ube4bVsRJM1TalGXXIHShURgfmAt
         QOXVlpL9djl1ghr5TW/KnIbZ2MU9wvO85Gx2TIFVAg5DA6gpEdOhhfWfq/Jvw708VhcB
         a5s5Iyff04+WMkciTNTLI/NG1ZcGnsaeengDeV++aNMnTB1HW9CF14KLRq+CSP/4qKep
         G/ulzhuUkARy7xkH9CPBcjPGcH+FHEHbZAybsWAOQC08AKuJGN8iC569BotTrfhaeGe4
         JO2U/WGUihQH2OvltIwNnq/CSW3JXasEijick39O3fONQmvK9J6gfzyjwCx10Zzq4P2m
         wcOg==
X-Gm-Message-State: AOAM530pBb0MXtGACz7ZL1qAflB2eDDXi/rHUFjLKZ37AmgkE5O4XjQV
        kvt/lj3utzhMBPa9v9Z3WfvtNVmcbwBRDOQ3AIeEqw==
X-Google-Smtp-Source: ABdhPJwfJPzl0UAnoeSqc1osBwiX9FKTTAbT0YGrLhc9JTx14iQc9uqlfxFP9HZDVcii6S7DtIxIKshpbeBvEpLuwDw=
X-Received: by 2002:a25:d84a:: with SMTP id p71mr24748708ybg.347.1596431442552;
 Sun, 02 Aug 2020 22:10:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-6-songliubraving@fb.com> <CAEf4BzaP4TGF7kcmZRAKsy=oWPpFA6sUGFkctpGz-fPp+YuSOQ@mail.gmail.com>
 <DDCD362E-21D3-46BF-90A6-8F3221CBB54E@fb.com>
In-Reply-To: <DDCD362E-21D3-46BF-90A6-8F3221CBB54E@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 2 Aug 2020 22:10:31 -0700
Message-ID: <CAEf4BzY5RYMM6w8wn3qEB3AsuKWv-TMaD5NVFj=YqbCW4DLjqA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: add benchmark for uprobe vs. user_prog
To:     Song Liu <songliubraving@fb.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Xu <dlxu@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 2, 2020 at 9:47 PM Song Liu <songliubraving@fb.com> wrote:
>
>
> > On Aug 2, 2020, at 6:51 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wrote:
> >>
> >> Add a benchmark to compare performance of
> >>  1) uprobe;
> >>  2) user program w/o args;
> >>  3) user program w/ args;
> >>  4) user program w/ args on random cpu.
> >>
> >
> > Can you please add it to the existing benchmark runner instead, e.g.,
> > along the other bench_trigger benchmarks? No need to re-implement
> > benchmark setup. And also that would also allow to compare existing
> > ways of cheaply triggering a program vs this new _USER program?
>
> Will try.
>
> >
> > If the performance is not significantly better than other ways, do you
> > think it still makes sense to add a new BPF program type? I think
> > triggering KPROBE/TRACEPOINT from bpf_prog_test_run() would be very
> > nice, maybe it's possible to add that instead of a new program type?
> > Either way, let's see comparison with other program triggering
> > mechanisms first.
>
> Triggering KPROBE and TRACEPOINT from bpf_prog_test_run() will be useful.
> But I don't think they can be used instead of user program, for a couple
> reasons. First, KPROBE/TRACEPOINT may be triggered by other programs
> running in the system, so user will have to filter those noise out in
> each program. Second, it is not easy to specify CPU for KPROBE/TRACEPOINT,
> while this feature could be useful in many cases, e.g. get stack trace
> on a given CPU.
>

Right, it's not as convenient with KPROBE/TRACEPOINT as with the USER
program you've added specifically with that feature in mind. But if
you pin user-space thread on the needed CPU and trigger kprobe/tp,
then you'll get what you want. As for the "noise", see how
bench_trigger() deals with that: it records thread ID and filters
everything not matching. You can do the same with CPU ID. It's not as
automatic as with a special BPF program type, but still pretty simple,
which is why I'm still deciding (for myself) whether USER program type
is necessary :)


> Thanks,
> Song
