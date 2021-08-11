Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0370B3E9A28
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 23:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhHKVDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 17:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhHKVDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 17:03:42 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C188EC061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 14:03:18 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id bj40so6648622oib.6
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 14:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cilium-io.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wd6T0rEySA9LtvGGXNP1hlrCZYYYrgF6pB+h/IUB6C8=;
        b=RlErA+tHdrMSqMClvTsJUgbvXB0rV7ky8wdTbS5Q0sW6EjVMsmbX4s+yIaznjrtBx3
         4jokUKJ8seIjWdzi6B6Osq0xzbkF91l9CxHNG6CLjlG+EqoBuUaDwU+n/BOA/iOizqS5
         +5x7M0ibB8Ft+iKeJMNPEpGdVnFB8fPOSFoIfj6WoRs7ZBo8vTiLeAZFqVD4bNlu9g+1
         FBLO4dCe4JsQVVNpRV1sqsKMTXDtxFZ3/V486QfgcXkdKQXVrHAt3L2rRlOiQyyISYFb
         c3QsRHtj/uLuuT5yaJnWVzWbQpx22MyONirLcXhOjZekJf1kL975amhnmKWekCNuFeU7
         fSBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wd6T0rEySA9LtvGGXNP1hlrCZYYYrgF6pB+h/IUB6C8=;
        b=jlWuw89gAp7FKFQSoJRlWQ4NXscs8qm0+SrRh4BEw1ILSCgpe3cR9VC5yXgp07UDoG
         NTcBVKrwyZZ4WlqRcvdQwUR8zdsVQRIVgIfoWd3HiB+uTEmtZCSotZa2GB4OTcrcbspm
         Wb2AEYpI8jBVrwlfbxpRKRvGwotA0ILDOK4UHT5DLad/lpTun6NSnpsKYJrDc/M6eRA5
         qdKSCCBqToCD7vCEN0UHL6uaZCSossVIytGpTLNKSeHHVDQq6CGEL/KL4LFuItAnrub/
         2QQ8WOY5quYplnoC7OaKGhxZoLfdKxQTtn975t7y7sUFZk1k+sjgglhtN6LAUelp/ibg
         56ig==
X-Gm-Message-State: AOAM530RJWT1um4xTWrMq9i6mQWZMUCDmuKZq/jTQo/YrOujmUqGq1hP
        /vFeEvuPKgk0zt8OQCkoBM7Jpm+fOcGJUgwWhg8FHA==
X-Google-Smtp-Source: ABdhPJzkHC2RzO8iBfAGGt3BqvnWFv2/4EzL/x8hdCnM69LLaLAkIyNDeHmOmlKNPvGssx6opPcx97/0mWeZLv2/8a0=
X-Received: by 2002:a54:488c:: with SMTP id r12mr8583818oic.111.1628715798125;
 Wed, 11 Aug 2021 14:03:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210402192823.bqwgipmky3xsucs5@ast-mbp> <20210402234500.by3wigegeluy5w7j@ast-mbp>
 <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
 <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com>
 <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
 <CAM_iQpVtxgZNeqh4_Pqftc3D163JnRvP3AZRuFrYNeyWLgVBVA@mail.gmail.com>
 <CAADnVQLFehCeQRbwEQ9VM-=Y3V3es2Ze8gFPs6cZHwNH0Ct7vw@mail.gmail.com>
 <CAM_iQpWDhoY_msU=AowHFq3N3OuQpvxd2ADP_Z+gxBfGduhrPA@mail.gmail.com>
 <20210427020159.hhgyfkjhzjk3lxgs@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpVE4XG7SPAVBmV2UtqUANg3X-1ngY7COYC03NrT6JkZ+g@mail.gmail.com>
 <CAADnVQK9BgguVorziWgpMktLHuPCgEaKa4fz-KCfhcZtT46teQ@mail.gmail.com>
 <CAM_iQpWBrxuT=Y3CbhxYpE5a+QSk-O=Vj4euegggXAAKTHRBqw@mail.gmail.com>
 <CAOftzPh0cj_XRES8mrNWnyKFZDLpRez09NAofmu1F1JAZf43Cw@mail.gmail.com>
 <ac30da98-97cd-c105-def8-972a8ec573d6@mojatatu.com> <e51f235e-f5b7-be64-2340-8e7575d69145@mojatatu.com>
 <CAM_iQpX=Qk6GjxB=saTpbo4Oc1KBxK2tU5N==HO_LimiOEtoDA@mail.gmail.com>
In-Reply-To: <CAM_iQpX=Qk6GjxB=saTpbo4Oc1KBxK2tU5N==HO_LimiOEtoDA@mail.gmail.com>
From:   Joe Stringer <joe@cilium.io>
Date:   Wed, 11 Aug 2021 14:03:07 -0700
Message-ID: <CADa=RyyuVD5r9_95HTj_-hPq4AjN1RgrGcZsJssRjYfajY=6hQ@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Joe Stringer <joe@cilium.io>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi folks, apparently I never clicked 'send' on this email, but if you
wanted to continue the discussion I had some questions and thoughts.

This is also an interesting enough topic that it may be worth
considering to submit for the upcoming LPC Networking & BPF track
(submission deadline is this Friday August 13, Conference dates 20-24
September).

On Thu, May 13, 2021 at 7:53 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, May 13, 2021 at 11:46 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> >
> > On 2021-05-12 6:43 p.m., Jamal Hadi Salim wrote:
> >
> > >
> > > Will run some tests tomorrow to see the effect of batching vs nobatch
> > > and capture cost of syscalls and cpu.
> > >
> >
> > So here are some numbers:
> > Processor: Intel(R) Xeon(R) Gold 6230R CPU @ 2.10GHz
> > This machine is very similar to where a real deployment
> > would happen.
> >
> > Hyperthreading turned off so we can dedicate the core to the
> > dumping process and Performance mode on, so no frequency scaling
> > meddling.
> > Tests were ran about 3 times each. Results eye-balled to make
> > sure deviation was reasonable.
> > 100% of the one core was used just for dumping during each run.
>
> I checked with Cilium users here at Bytedance, they actually observed
> 100% CPU usage too.

Thanks for the feedback. Can you provide further details? For instance,

* Which version of Cilium?
* How long do you observe this 100% CPU usage?
* What size CT map is in use?
* How frequently do you intend for CT GC to run? (Do you use the
default settings or are they mismatched with your requirements for
some reason? If so can we learn more about the requirements/why?)
* Do you have a threshold in mind that would be sufficient?

If necessary we can take these discussions off-list if the details are
sensitive but I'd prefer to continue the discussion here to have some
public examples we can discuss & use to motivate future discussions.
We can alternatively move the discussion to a Cilium GitHub issue if
the tradeoffs are more about the userspace implementation rather than
the kernel specifics, though I suspect some of the folks here would
also like to follow along so I don't want to exclude the list from the
discussion.

FWIW I'm not inherently against a timer, in fact I've wondered for a
while what kind of interesting things we could build with such
support. At the same time, connection tracking entry management is a
nuanced topic and it's easy to fix an issue in one area only to
introduce a problem in another area.

> >
> > bpftool does linear retrieval whereas our tool does batch dumping.
> > bpftool does print the dumped results, for our tool we just count
> > the number of entries retrieved (cost would have been higher if
> > we actually printed). In any case in the real setup there is
> > a processing cost which is much higher.
> >
> > Summary is: the dumping is problematic costwise as the number of
> > entries increase. While batching does improve things it doesnt
> > solve our problem (Like i said we have upto 16M entries and most
> > of the time we are dumping useless things)
>
> Thank you for sharing these numbers! Hopefully they could convince
> people here to accept the bpf timer. I will include your use case and
> performance number in my next update.

Yes, Thanks Jamal for the numbers. It's very interesting, clearly
batch dumping is far more efficient and we should enhance bpftool to
take advantage of it where applicable.

> Like i said we have upto 16M entries and most
> of the time we are dumping useless things)

I'm curious if there's a more intelligent way to figure out this
'dumping useless things' aspect? I can see how timers would eliminate
the cycles spent on the syscall aspect of this entirely (in favor of
the timer handling logic which I'd guess is cheaper), but at some
point if you're running certain logic on every entry in a map then of
course it will scale linearly.

The use case is different for the CT problem we discussed above, but
if I look at the same question for the CT case, this is why I find LRU
useful - rather than firing off a number of timers linear on the size
of the map, the eviction logic is limited to the map insert rate,
which itself can be governed and ratelimited by logic running in eBPF.
The scan of the map then becomes less critical, so it can be run less
frequently and alleviate the CPU usage question that way.
