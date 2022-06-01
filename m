Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9B253AC17
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 19:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355926AbiFARjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 13:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236698AbiFARjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 13:39:22 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF92F8A32F;
        Wed,  1 Jun 2022 10:39:21 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id t25so3933463lfg.7;
        Wed, 01 Jun 2022 10:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H6svHWI5VNrkMMb+5NDwNaMjRozk+3HNFT3dS0gG1KQ=;
        b=CQN0YBYcDHUdErI/wo3pFwGt8L5+TCyc76m1vxbwAGgmLgGRj/iUn3Ku0s/rEDPnbm
         325JjOsguX4XV7O4kZFRo2MgB9/9WTs6dpYwbp0+Jqx8L+iSMBpYHzCvuP9soYaiQ6UC
         SaAsFtWBoeiWnZZ1t9V/jEDMNDPI/aP+LhETeiY9cJa4+PXP3+70gX0bmRFvUAqgWJC4
         FbLIXQ+Q4WexKI9JnwPzer9UGPc3WaICu5wDDudtYMnpTWCnRTLw1+a2p2zxne2TaSZz
         PTB3O/etJK8YhfRWtqX6YvE1aypJrUtEV4aooxlCpGLKkG/CQwNPJweJJTanmFu2ZjOp
         4HwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H6svHWI5VNrkMMb+5NDwNaMjRozk+3HNFT3dS0gG1KQ=;
        b=CbJD+9As3L7w2Lmfr4a14IytdinaxNxgCrd1pAw36A4kK9YRzXTc/u/vO9JlAXq8P4
         gy0jl8mRcAH42o3F9qktb889imtmu0Tyq2tWHecjFFdmShJJvOPHTHcwB9wNNRUJ2ngN
         qp92ol9i0PKiywYVNuJDVegkWrWUnmIFd0uq/DDhC9Tc1X3bxaGti63DrdYIjkgzKBKO
         KkGObxGAGMOHAeqP4jmEOkKu1JJ9SQedHNOqLSQoitZINCfdHl/fGGjJDRK9LrdGEtu2
         QnsGauqnaPlqHoi3DRCaFPl5trGyZpwbVRyge3gyhZBacyHtWbos5/kwa4flQ9GnLVjz
         kMSQ==
X-Gm-Message-State: AOAM5322MCMIPTRy9V4YfprXmVJccAZe7FpkcB8Ch3rf1MEaqcjCqpmi
        Q6AfedGTW5AwJsGRSnMFBLpOsXLVvIh/j6UiVJg=
X-Google-Smtp-Source: ABdhPJz4CTWuqBUCSMC9rIBvuCZvZxz1T+TCWnAQ8KQ8sV0N8dx6RKTji7EPbnZAq/QgQXjvkzLetXfhsDJCP/kN8Vg=
X-Received: by 2002:a05:6512:68e:b0:477:cc29:f92 with SMTP id
 t14-20020a056512068e00b00477cc290f92mr395399lfe.408.1654105159864; Wed, 01
 Jun 2022 10:39:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzbK9zgetgE1yKkCANTZqizUrXgamJa2X0f0XmzQUdFrCQ@mail.gmail.com>
 <YntnRixbfQ1HCm9T@krava> <Ynv+7iaaAbyM38B6@kernel.org> <CAEf4BzaQsF31f3WuU32wDCzo6bw7eY8E9zF6Lo218jfw-VQmcA@mail.gmail.com>
 <YoTAhC+6j4JshqN8@krava> <YoYj6cb0aPNN/olH@krava> <CAEf4Bzaa60kZJbWT0xAqcDMyXBzbg98ShuizJAv7x+8_3X0ZBg@mail.gmail.com>
 <Yokk5XRxBd72fqoW@kernel.org> <Yos8hq3NmBwemoJw@krava> <CAEf4BzYRJj8sXjYs2ioz6Qq7L2UshZDi4Kt0XLsLtwQSGCpAzg@mail.gmail.com>
 <YoyXRij2LaxxTicC@krava>
In-Reply-To: <YoyXRij2LaxxTicC@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Jun 2022 10:39:08 -0700
Message-ID: <CAEf4Bzbxo7_dbBzjeBu8FeB6MFBpgqn1Cwq_om-mGuz-gJH6CA@mail.gmail.com>
Subject: Re: [PATCHv2 0/3] perf tools: Fix prologue generation
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
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

On Tue, May 24, 2022 at 1:28 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Mon, May 23, 2022 at 03:43:10PM -0700, Andrii Nakryiko wrote:
> > On Mon, May 23, 2022 at 12:49 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> > >
> > > On Sat, May 21, 2022 at 02:44:05PM -0300, Arnaldo Carvalho de Melo wrote:
> > > > Em Fri, May 20, 2022 at 02:46:49PM -0700, Andrii Nakryiko escreveu:
> > > > > On Thu, May 19, 2022 at 4:03 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> > > > > > On Wed, May 18, 2022 at 11:46:44AM +0200, Jiri Olsa wrote:
> > > > > > > On Tue, May 17, 2022 at 03:02:53PM -0700, Andrii Nakryiko wrote:
> > > > > > > > Jiri, libbpf v0.8 is out, can you please re-send your perf patches?
> > > >
> > > > > > > yep, just made new fedora package.. will resend the perf changes soon
> > > >
> > > > > > fedora package is on the way, but I'll need perf/core to merge
> > > > > > the bpf_program__set_insns change.. Arnaldo, any idea when this
> > > > > > could happen?
> > > >
> > > > > Can we land these patches through bpf-next to avoid such complicated
> > > > > cross-tree dependencies? As I started removing libbpf APIs I also
> > > > > noticed that perf is still using few other deprecated APIs:
> > > > >   - bpf_map__next;
> > > > >   - bpf_program__next;
> > > > >   - bpf_load_program;
> > > > >   - btf__get_from_id;
> > >
> > > these were added just to bypass the time window when they were not
> > > available in the package, so can be removed now (in the patch below)
> > >
> > > >
> > > > > It's trivial to fix up, but doing it across few trees will delay
> > > > > libbpf work as well.
> > > >
> > > > > So let's land this through bpf-next, if Arnaldo doesn't mind?
> > > >
> > > > Yeah, that should be ok, the only consideration is that I'm submitting
> > > > this today to Linus:
> > > >
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/commit/?h=tmp.perf/urgent&id=0ae065a5d265bc5ada13e350015458e0c5e5c351
> > > >
> > > > To address this:
> > > >
> > > > https://lore.kernel.org/linux-perf-users/f0add43b-3de5-20c5-22c4-70aff4af959f@scylladb.com/
> > >
> > > ok, we can do that via bpf-next, but of course there's a problem ;-)
> > >
> > > perf/core already has dependency commit [1]
> > >
> > > so either we wait for perf/core and bpf-next/master to sync or:
> > >
> > >   - perf/core reverts [1] and
> > >   - bpf-next/master takes [1] and the rest
> > >
> > > I have the changes ready if you guys are ok with that
> >
> > So, if I understand correctly, with merge window open bpf-next/master
> > will get code from perf/core soon when we merge tip back in. So we can
> > wait for that to happen and not revert anything.
> >
> > So please add the below patch to your series and resend once tip is
> > merged into bpf-next? Thanks!
>
> ok

Hm.. Ok, so I don't see your patches in tip yet. I see them in
perf/core only. Which means things won't happen naturally soon. How
should we proceed? I'm sitting on a pile of patches removing a lot of
code from libbpf and I'd rather get it out soon, but I can't because
of them breaking perf in bpf-next without Jiri's changes.

Arnaldo, what's your suggestion? Can we land remaining Jiri's patches
into perf/core and then you can create a tag for us to merge into
bpf-next, so that we avoid any conflicts later? Would that work? I
think we did something like that with other trees (e.g., RCU), when we
had dependencies like this before.

Thoughts?

>
> jirka
