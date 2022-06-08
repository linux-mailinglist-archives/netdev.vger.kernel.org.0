Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8C25424E3
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbiFHFF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 01:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbiFHFEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 01:04:44 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AAF2F91AF;
        Tue,  7 Jun 2022 19:01:43 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id er5so25167292edb.12;
        Tue, 07 Jun 2022 19:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hEdnGDbCA+kjfc/VIIcZxsDhGurHoaavILbT6X67kyg=;
        b=cQIUjFP+F6YiiIhR2cdRRxWXvb4XMU1iLT7Zb1NhwqnRURCGl3G3NtwJTw4Ghwc/wW
         wWqFkL/DshKNdnuowK6e27tsuGxNULjPY5MoH/eP2HP4MRPSP8eYrUrOx+OzkEDcGDZw
         YWlbUyUO729PqRijuAmSyQEyOCwdlW4q1txqA4jIAx7q6BQG3BD/j8MgUfBawGfNNCNl
         MmJibTV5AON1UlzhvpYzXc7nblm+Ac6oTcOxZdCW6V8aMVPjNo0MtTrFgTzMU/BbVjYc
         0WFTfZkSJk4KzBRCoAm1Pv/3i1+v63xOrqCQ04gYfU0MZkCTGso2GQ9PLWxIQNfzt86n
         QxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hEdnGDbCA+kjfc/VIIcZxsDhGurHoaavILbT6X67kyg=;
        b=vfogoTV4eK4dbJ4/1PQQphTQ8KKnu+C5YcxQEPADGM4+KS3xovULPunjvMudwGHE1M
         iaHNbpWjakqajpDX1tIJGcsXzo76BgX2Dhtiygqd5NML7I0+n8/2pPhVuVv8jdxc9zUJ
         JyW3IPOrOqo4/SC7KTlAl/7YppfxKzmpowrGJsEFvegB83iwRi1UP0s1UTL4n2Vrp/2p
         NzDPKlafABq3JwTsvkOoCwbBASpkL/rZUtvy3KJaY/CSJqYtmHzkebS+iFPBy91HQN3F
         RY06Ras4fyut5K/6D06sr/+twjIrBz+DfZuCymqwKmWVJRKLKZsEdfpBeu8RlWfSyEQ0
         W6SQ==
X-Gm-Message-State: AOAM533Lw8ePrA8p1hnktzE1PzzdjuB3LR1T1CEK10qGq9DL1TQOLAGb
        JS4A3U1FPQIwV9cVAHMLpmVVvVtFKFeLVFxq9lk=
X-Google-Smtp-Source: ABdhPJwuc8VC/RiWW4sM66ztXfWl92bMfnCwuwUheAWuApGkFMr1ZAcWSLjahwZnJ+kHT20IxBvzekzbwF3gOztePxQ=
X-Received: by 2002:a05:6402:3895:b0:430:6a14:8ca3 with SMTP id
 fd21-20020a056402389500b004306a148ca3mr23928805edb.421.1654653701506; Tue, 07
 Jun 2022 19:01:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220606103734.92423-1-kurt@linutronix.de> <CAADnVQJ--oj+iZYXOwB1Rs9Qiy6Ph9HNha9pJyumVom0tiOFgg@mail.gmail.com>
 <875ylc6djv.ffs@tglx> <c166aa47-e404-e6ee-0ec5-0ead1923f412@redhat.com>
In-Reply-To: <c166aa47-e404-e6ee-0ec5-0ead1923f412@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 7 Jun 2022 19:01:29 -0700
Message-ID: <CAADnVQKqo1XfrPO8OYA1VpArKHZotuDjGNtxM0AftUj_R+vU7g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Add BPF-helper for accessing CLOCK_TAI
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 7, 2022 at 12:35 PM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 07/06/2022 11.14, Thomas Gleixner wrote:
> > Alexei,
> >
> > On Mon, Jun 06 2022 at 08:57, Alexei Starovoitov wrote:
> >> On Mon, Jun 6, 2022 at 3:38 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
> >>>
> >>> From: Jesper Dangaard Brouer <brouer@redhat.com>
> >>>
> >>> Commit 3dc6ffae2da2 ("timekeeping: Introduce fast accessor to clock tai")
> >>> introduced a fast and NMI-safe accessor for CLOCK_TAI. Especially in time
> >>> sensitive networks (TSN), where all nodes are synchronized by Precision Time
> >>> Protocol (PTP), it's helpful to have the possibility to generate timestamps
> >>> based on CLOCK_TAI instead of CLOCK_MONOTONIC. With a BPF helper for TAI in
> >>> place, it becomes very convenient to correlate activity across different
> >>> machines in the network.
> >>
> >> That's a fresh feature. It feels risky to bake it into uapi already.
> >
> > What? That's just support for a different CLOCK. What's so risky about
> > it?
>
> I didn't think it was "risky" as this is already exported as:
>   EXPORT_SYMBOL_GPL(ktime_get_tai_fast_ns);
>
> Correct me if I'm wrong, but this simple gives BPF access to CLOCK_TAI
> (see man clock_gettime(2)), right?
> And CLOCK_TAI is not really a new/fresh type of CLOCK.
>
> Especially for networking we need this CLOCK_TAI time as HW LaunchTime
> need this (e.g. see qdisc's sch_etf.c and sch_taprio.c).

I see. I interpreted the commit log that commit 3dc6ffae2da2
introduced TAI into the kernel for the first time.
But it introduced the NMI safe version of it, right?

> >
> >> imo it would be better to annotate tk_core variable in vmlinux BTF.
> >> Then progs will be able to read all possible timekeeper offsets.
> >
> > We are exposing APIs. APIs can be supported, but exposing implementation
> > details creates ABIs of the worst sort because that prevents the kernel
> > from changing the implementation. We've seen the fallout with the recent
> > tracepoint changes already.
>
> Hmm... annotate tk_core variable in vmlinux BTF and letting BPF progs
> access this seems like an unsafe approach and we tempt BPF-developers to
> think other parts are okay to access.

It is safe to access.
Whether garbage will be read it's a different story.

The following works (with lose definition of 'works'):

extern const void tk_core __ksym;

struct timekeeper {
        long long offs_tai;
} __attribute__((preserve_access_index));

struct seqcount_raw_spinlock {
} __attribute__((preserve_access_index));

long get_clock_tai(void)
{
   long long off = 0;
   void *addr = (void *)&tk_core +
      ((bpf_core_type_size(struct seqcount_raw_spinlock) + 7) / 8) * 8 +
      bpf_core_field_offset(struct timekeeper, offs_tai);

   bpf_probe_read_kernel(&off, sizeof(off), addr);
   return bpf_ktime_get_ns() + off;
}

It's ugly, but no kernel changes are necessary.
If you need to access clock_tai you can do so on older kernels too.
Even on android 4.19 kernels.

It's not foolproof. Future kernel changes will break it,
but CO-RE will detect the breakage.
The prog author would have to adjust the prog every time.

People do these kinds of tricks all the time.

Note that above was possible even before CO-RE came to existence.
The first day bpf_probe_read_kernel() became available 8 years ago
the tracing progs could read any kernel memory.
Even earlier kprobes could read it for 10+ years.

And in all those years bpf progs accessing kernel internals
didn't freeze kernel development. bpf progs don't extend
uapi surface unless the changes are in uapi/bpf.h.

Anyway I guess new helper bpf_ktime_get_tai_ns() is ok, since
it's so trivial, but selftest is necessary.
