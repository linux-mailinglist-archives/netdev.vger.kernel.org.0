Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E711DAC83
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgETHqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgETHqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 03:46:37 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01699C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 00:46:37 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id a10so514043ybc.3
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 00:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GcskknYh95Rq/Z6Azk62iLDMqUdVtj6gS2U77ZaIoIU=;
        b=O44tJvlv/WeGAb2EUW5U1b7mccht+alKed3ccPJygFxfgOiFTPk1FratyivkGc09Lv
         xuzcQDqx5Hgm7ZErC5Ll1kGXoT8P4VVHw2p3iW54tOUCLs9CpnclbpknkrOPV24VSlU8
         8wM2T9eqOBFTanPK5rnk4LgPYPh3A7PxoiRB+LYZH1PxDB41pN1I8QZSzz1UT02PB29S
         FjvcxIKv5zbe9M1/LHogO3Ebj+KEt43IIO0zhchKc2GKE3vBi+nJAUELFit5FR/l2A4Y
         WYHNbIuCWPW8qutZwXV/iekANN7iMF5zJZu9FWhBbj+NHjs7eUbFUsYfOb/oRT3x4FVC
         xh1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GcskknYh95Rq/Z6Azk62iLDMqUdVtj6gS2U77ZaIoIU=;
        b=b9FM3vZpg+yZfrj4+s2Fpg3EOJrYRvjyoVAS2JatG5BVjSYqqgLSlflCOJ1S4tlQM8
         caiV0CCVoqkpKNR3VAY7xx4M2nf739gUyRrnCHDALqVao0bb+IU7g724zYecKUHZGInt
         1x+i+GP4S6Z9zb62/aP6x0ek9qIk8RzmNA8OtB4YplCV9aGi+DgpDxQ6G6CqkrKHpDfw
         ZDnhe+z7UIL/Gnpioq9WEkMZxEM6DONuwzWfSnjqNgC6Nq/0grzYAxdFXMQJYSjQIemn
         2zuapLDzvSlE7V2DQK0N6B9WZVnd+jhGJ2aQFvI6ggMe72q1gujgu5sgDXHoKQ7wXeDJ
         fdmA==
X-Gm-Message-State: AOAM530+m7Z2VuFBNVRBJsMDTa6nU4ryUX2C9Rs85JAVAv6ki2x5j2MJ
        g8jCcHcl1ERaU+T7azXj6ELJSqeXYodH5BxzBQafFg==
X-Google-Smtp-Source: ABdhPJwGvKZvdPEjgUaNjoxgTzneBcLyd71wFjTYqOE86+SlBKa4uqcqVAnujdHK89IgJTKnEatAb+OEoATUC4Gc+x0=
X-Received: by 2002:a25:7cc1:: with SMTP id x184mr5135676ybc.403.1589960793022;
 Wed, 20 May 2020 00:46:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200508053629.210324-1-irogers@google.com> <20200508053629.210324-13-irogers@google.com>
 <20200509002518.GF3538@tassilo.jf.intel.com> <CAP-5=fWYO2e9yVPuXGVKZ7TBP4PP6MjyEFiSd+20DOxYSLC--w@mail.gmail.com>
 <20200509024019.GI3538@tassilo.jf.intel.com>
In-Reply-To: <20200509024019.GI3538@tassilo.jf.intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Wed, 20 May 2020 00:46:22 -0700
Message-ID: <CAP-5=fVPh0og6CmjM4G1bDGB_S+Sp4v_4WM3r5XqwQPbk7ASdg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 12/14] perf metricgroup: order event groups by size
To:     Andi Kleen <ak@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 7:40 PM Andi Kleen <ak@linux.intel.com> wrote:
>
> > > I'm not sure if size is that great an heuristic. The dedup algorithm should
> > > work in any case even if you don't order by size, right?
> >
> > Consider two metrics:
> >  - metric 1 with events {A,B}
> >  - metric 2 with events {A,B,C,D}
> > If the list isn't sorted then as the matching takes the first group
> > with all the events, metric 1 will match {A,B} and metric 2 {A,B,C,D}.
> > If the order is sorted to {A,B,C,D},{A,B} then metric 1 matches within
> > the {A,B,C,D} group as does metric 2. The events in metric 1 aren't
> > used and are removed.
>
> Ok. It's better for the longer metric if they stay together.
>
> >
> > The dedup algorithm is very naive :-)
>
> I guess what matters is that it gives reasonable results on the current
> metrics. I assume it does?
>
> How much deduping is happening if you run all metrics?

Hi Andi,

I included this data in the latest cover-letter:
https://lore.kernel.org/lkml/20200520072814.128267-1-irogers@google.com/

> For toplev on my long term todo list was to compare it against
> a hopefully better schedule generated by or-tools, but I never
> got around to coding that up.
>
> -Andi

Agreed, and this relates to your comments about doing the algorithm as
a separate pass outside of find_evsel_group. For that, I don't
disagree but would like to land what we have and then follow up with
improvements.

Thanks,
Ian
