Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3085476569
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 23:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhLOWH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 17:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbhLOWHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 17:07:55 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA9DC061401
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 14:07:55 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id f20so23457493qtb.4
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 14:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s9ph+hPb4AnD3MZGi/I9+wvXsLJ+pA2TlSve7ohKzlg=;
        b=j0dGpBC7vI8/UddeVghIOmCTb18fj23Y0bvJmOL3zIosGtr7VASQEBbfNTvEVr++ye
         a7Bn+Y4P1P1SbSo1oV+hq1ty7T1PrmEoDFOy/D98nS/eqrw7GcB43hntkJxpij6rsn94
         uiepjqeX3EQez69h0ecxdSLwKT8ak0GU6T/M5tR5Cn+etr0Gr1711IDdaR/3YGw1fO2l
         ZNEhdKg2w5xT3/xgwsGxnaq5FG3rzYCMcN0tSM/wVPLrA+CHrALjGjud/S6KCixDW9HR
         qYGj2axQ4xEpDTNLtakY6uloJLJzelG96lIwGxC/AUhZrmkhv2vPBnNN4LhccEE+3Utu
         3EvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s9ph+hPb4AnD3MZGi/I9+wvXsLJ+pA2TlSve7ohKzlg=;
        b=oTsyc1TAZAoQd76PIC9QR5lz+Hf6zCro3zAkPIacJ5YHSYBIp6ZLmy1kwOKLHp1Su5
         uGP8IpAI0cdAiQZAbHYYddjV2clmexoueVGafqOC96LWwg/I6pHPuBbc7riJQIJKsz5j
         IbLq9DAKJqX4D7MNxHwc21HCdlM8KUvHnXsQXD4kHQVfORJJ3Tn+66DjQCgiyTHrAmQp
         GisePW/sLaEWfu1K96JaEBmY3mWE2mLotTBlUUPpBywVBN7zW2REp7usC1btgyKgnDg1
         H5mHNg3YKypk/3AfH67F8VI01KJJfAhtVwmOlSEagJcBiZEgMmnLy1Mu2VFQ+YTNIsX9
         cInA==
X-Gm-Message-State: AOAM531JuEDD5721F0mPMEupJR1jlfVGLdGD3MI9qtl6Q3LmELL3WyTt
        jWh3tYHuSfeDemlVe02C3cpo0awOdB7UubSbpa2F9w==
X-Google-Smtp-Source: ABdhPJwhv+ujTitjbYs7vUs8AvA5UBtLp0JJyGcrvg86ld4+8fS0QjFgRBxSH9wdD55G7ub/LVzGkcw5bdwwbLbBQTQ=
X-Received: by 2002:a05:622a:1c6:: with SMTP id t6mr14249037qtw.211.1639606073982;
 Wed, 15 Dec 2021 14:07:53 -0800 (PST)
MIME-Version: 1.0
References: <462ce9402621f5e32f08cc8acbf3d9da4d7d69ca.1639579508.git.asml.silence@gmail.com>
 <Yboc/G18R1Vi1eQV@google.com> <b2af633d-aaae-d0c5-72f9-0688b76b4505@gmail.com>
 <Ybom69OyOjsR7kmZ@google.com> <634c2c87-84c9-0254-3f12-7d993037495c@gmail.com>
 <Yboy2WwaREgo95dy@google.com> <e729a63a-cded-da9c-3860-a90013b87e2d@gmail.com>
 <CAKH8qBv+GsPz3JTTmLZ+Q2iMSC3PS+bE1xOLbxZyjfno7hqpSA@mail.gmail.com> <92f69969-42dc-204a-4138-16fdaaebb78d@gmail.com>
In-Reply-To: <92f69969-42dc-204a-4138-16fdaaebb78d@gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 15 Dec 2021 14:07:43 -0800
Message-ID: <CAKH8qBuZxBen871AWDK1eDcxJenK7UkSQCZQsHCPhk6nk9e=Ng@mail.gmail.com>
Subject: Re: [PATCH v3] cgroup/bpf: fast path skb BPF filtering
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 11:55 AM Pavel Begunkov <asml.silence@gmail.com> wr=
ote:
>
> On 12/15/21 19:15, Stanislav Fomichev wrote:
> > On Wed, Dec 15, 2021 at 10:54 AM Pavel Begunkov <asml.silence@gmail.com=
> wrote:
> >>
> >> On 12/15/21 18:24, sdf@google.com wrote:
> >>> On 12/15, Pavel Begunkov wrote:
> >>>> On 12/15/21 17:33, sdf@google.com wrote:
> >>>>> On 12/15, Pavel Begunkov wrote:
> >>>>>> On 12/15/21 16:51, sdf@google.com wrote:
> >>>>>>> On 12/15, Pavel Begunkov wrote:
> >>>>>>>> =EF=BF=BD /* Wrappers for __cgroup_bpf_run_filter_skb() guarded =
by cgroup_bpf_enabled. */
> >>>>>>>> =EF=BF=BD #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk, skb)=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
 \
> >>>>>>>> =EF=BF=BD ({=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD \
> >>>>>>>> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD int __ret =3D 0;=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD \
> >>>>>>>> -=EF=BF=BD=EF=BF=BD=EF=BF=BD if (cgroup_bpf_enabled(CGROUP_INET_=
INGRESS))=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD \
> >>>>>>>> +=EF=BF=BD=EF=BF=BD=EF=BF=BD if (cgroup_bpf_enabled(CGROUP_INET_=
INGRESS) && sk &&=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD \
> >>>>>>>> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
 CGROUP_BPF_TYPE_ENABLED((sk), CGROUP_INET_INGRESS))=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD \
> >>>>>>>
> >>>>>>> Why not add this __cgroup_bpf_run_filter_skb check to
> >>>>>>> __cgroup_bpf_run_filter_skb? Result of sock_cgroup_ptr() is alrea=
dy there
> >>>>>>> and you can use it. Maybe move the things around if you want
> >>>>>>> it to happen earlier.
> >>>>>
> >>>>>> For inlining. Just wanted to get it done right, otherwise I'll lik=
ely be
> >>>>>> returning to it back in a few months complaining that I see measur=
able
> >>>>>> overhead from the function call :)
> >>>>>
> >>>>> Do you expect that direct call to bring any visible overhead?
> >>>>> Would be nice to compare that inlined case vs
> >>>>> __cgroup_bpf_prog_array_is_empty inside of __cgroup_bpf_run_filter_=
skb
> >>>>> while you're at it (plus move offset initialization down?).
> >>>
> >>>> Sorry but that would be waste of time. I naively hope it will be vis=
ible
> >>>> with net at some moment (if not already), that's how it was with io_=
uring,
> >>>> that's what I see in the block layer. And in anyway, if just one inl=
ined
> >>>> won't make a difference, then 10 will.
> >>>
> >>> I can probably do more experiments on my side once your patch is
> >>> accepted. I'm mostly concerned with getsockopt(TCP_ZEROCOPY_RECEIVE).
> >>> If you claim there is visible overhead for a direct call then there
> >>> should be visible benefit to using CGROUP_BPF_TYPE_ENABLED there as
> >>> well.
> >>
> >> Interesting, sounds getsockopt might be performance sensitive to
> >> someone.
> >>
> >> FWIW, I forgot to mention that for testing tx I'm using io_uring
> >> (for both zc and not) with good submission batching.
> >
> > Yeah, last time I saw 2-3% as well, but it was due to kmalloc, see
> > more details in 9cacf81f8161, it was pretty visible under perf.
> > That's why I'm a bit skeptical of your claims of direct calls being
> > somehow visible in these 2-3% (even skb pulls/pushes are not 2-3%?).
>
> migrate_disable/enable together were taking somewhat in-between
> 1% and 1.5% in profiling, don't remember the exact number. The rest
> should be from rcu_read_lock/unlock() in BPF_PROG_RUN_ARRAY_CG_FLAGS()
> and other extra bits on the way.

You probably have a preemptiple kernel and preemptible rcu which most
likely explains why you see the overhead and I won't (non-preemptible
kernel in our env, rcu_read_lock is essentially a nop, just a compiler
barrier).

> I'm skeptical I'll be able to measure inlining one function,
> variability between boots/runs is usually greater and would hide it.

Right, that's why I suggested to mirror what we do in set/getsockopt
instead of the new extra CGROUP_BPF_TYPE_ENABLED. But I'll leave it up
to you, Martin and the rest.
