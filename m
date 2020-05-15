Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CD11D5BCD
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgEOVrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727867AbgEOVrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 17:47:42 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5911C05BD09
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 14:47:41 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id s37so1848971ybe.13
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 14:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tS+3CNMGEUW08GWKVNnTCx8encgyi37BKeJukWELzNc=;
        b=et/afkD6oOQ8yPirs/ovFayPyCKLRWPBJUWQfo6mBaGP/VgeItYGcmmiMuFdkQ6diZ
         lp2UAYZh47m0f2FWyEAfMlk4lqL+Wr0b0qd5sPjrOwqaSqmM0AbXME4ySzcO9tEgap7Y
         xiRN17Nh1zlxP4xm6W9+lMzqt5ruP2vFDCIT8O1B969Sf+eEAjWKn+0e8BMhjNvVimnP
         61i1EQ4/Wp6WC4QfNVm8DxLjYZghfSRzNiY4gQtihWRYH10r0WFXg69IQPatUG9UKUaR
         cagIPuLbrusA2+bourPD0q/2aJK8T8FtidKLadBqUvR6y/kPO08+8NvBAN+sPJnI7KRi
         3fDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tS+3CNMGEUW08GWKVNnTCx8encgyi37BKeJukWELzNc=;
        b=sKMaVT8TZE2TsN7HiuYVxn/qvKm6K0PX+gbjsOdOEX0B03V+q8SKwyQ+9jxoiddFnZ
         irkiP3TS1Bbmb/Y0bCviRbgQ/gY/gTBPrTWoMP5Bh2domCPkcA71DoRsaq3UvRKNEKOa
         NIEaS1SZFKBBL+6JjedVNha3TAcBCiKbxQ1rvREeSul4cXeRIdg3ip8cPLZHgrJIGzEK
         2Q1QlNJEhkzDPQmb2RcctBJy5mEd9IJU0gh9/DV7mP6kk7oHhpy2wn72cYgJEBJVrVLh
         dr4c14jumW0/NsfXD+UlQxRQAajLQXl5Zy7YG82gdlHYaZUDYW142Ye1qaQL/ugP1oqg
         p5Mw==
X-Gm-Message-State: AOAM531qZLsgA8jd/cUKAWML658iQa8GQPro5xeOiF9mJua7GuGThXJY
        e2GI+MpUsobi6gHmni+34z/P3wHqWKJnqwXdTMNPnw==
X-Google-Smtp-Source: ABdhPJyM9orvNlQicAfnrlZkcpeDb6FoYRrmyCqPxtKl7R3aimfxalhbrMVLLt0N1/ukrAhCjRtDKdjh/3N4+YwP+TM=
X-Received: by 2002:a25:c08b:: with SMTP id c133mr8940904ybf.286.1589579260905;
 Fri, 15 May 2020 14:47:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200515165007.217120-1-irogers@google.com> <20200515170036.GA10230@kernel.org>
 <CAEf4BzZ5=_yu1kL77n+Oc0K9oaDi4J=c+7CV8D0AXs2hBxhNbw@mail.gmail.com> <5ebf0748.1c69fb81.f8310.eef3@mx.google.com>
In-Reply-To: <5ebf0748.1c69fb81.f8310.eef3@mx.google.com>
From:   Ian Rogers <irogers@google.com>
Date:   Fri, 15 May 2020 14:47:29 -0700
Message-ID: <CAP-5=fWX6nD72Fn7dBS3Mrd_wy9iqkGKnfhHPxcqC_oNfKPZQA@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] Copy hashmap to tools/perf/util, use in perf expr
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 2:19 PM <arnaldo.melo@gmail.com> wrote:
>
> <bpf@vger.kernel.org>,Stephane Eranian <eranian@google.com>
> From: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> Message-ID: <79BCBAF7-BF5F-4556-A923-56E9D82FB570@gmail.com>
>
>
>
> On May 15, 2020 4:42:46 PM GMT-03:00, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >On Fri, May 15, 2020 at 10:01 AM Arnaldo Carvalho de Melo
> ><arnaldo.melo@gmail.com> wrote:
> >>
> >> Em Fri, May 15, 2020 at 09:50:00AM -0700, Ian Rogers escreveu:
> >> > Perf's expr code currently builds an array of strings then removes
> >> > duplicates. The array is larger than necessary and has recently
> >been
> >> > increased in size. When this was done it was commented that a
> >hashmap
> >> > would be preferable.
> >> >
> >> > libbpf has a hashmap but libbpf isn't currently required to build
> >> > perf. To satisfy various concerns this change copies libbpf's
> >hashmap
> >> > into tools/perf/util, it then adds a check in perf that the two are
> >in
> >> > sync.
> >> >
> >> > Andrii's patch to hashmap from bpf-next is brought into this set to
> >> > fix issues with hashmap__clear.
> >> >
> >> > Two minor changes to libbpf's hashmap are made that remove an
> >unused
> >> > dependency and fix a compiler warning.
> >>
> >> Andrii/Alexei/Daniel, what do you think about me merging these fixes
> >in my
> >> perf-tools-next branch?
> >
> >I'm ok with the idea, but it's up to maintainers to coordinate this :)
>
> Good to know, do I'll take all patches except the ones touching libppf, will just make sure the copy is done with the patches applied.
>
> At some point they'll land in libbpf and the warning from check_headers.sh will be resolved.

So tools/perf/util's hashmap will be ahead of libbpf's, as without the
fixes the perf build is broken by Werror. This will cause
check_headers to warn in perf builds, which would usually mean our
header was older than the source one, but in this case it means the
opposite, we're waiting for the libbpf patches to merge. Aside from
some interim warnings everything will resolve itself and Arnaldo
avoids landing patches in libbpf that can interfere with bpf-next.

It takes some getting your head around but sounds good to me :-) I
think the only workable alternatives would be to explore having a
single version of the code in some kind of shared libhashmap or to
implement another hashmap in libapi. I'd like to get the rest of this
work unblocked and so it'd be nice to land this and we can always
refactor later - I like Arnaldo's plan. Can a bpf maintainer make sure
the hashmap changes get pulled into bpf-next?

Thanks!
Ian

> Thanks,
>
> - Arnaldo
>
> --
> Sent from my Android device with K-9 Mail. Please excuse my brevity.
