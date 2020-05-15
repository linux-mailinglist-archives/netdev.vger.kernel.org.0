Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7BC1D5299
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 16:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgEOOxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 10:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726341AbgEOOxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 10:53:46 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A41FC061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 07:53:46 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id c2so1262414ybi.7
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 07:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vCsP/Fi9p7wcfV9Mclr35lTEASR77uNfvxlH1mBaMZ8=;
        b=rrJyTzWWBuvekmQCoKhKmu9E97sL1HhZfILkia5nrfYwCg8ZLbfuyE0cE5KyG0i8mi
         49NKzHaM4i8z/KAZ1EtFqNyXCHgp0MCk4VmC/ZmGrGX3azcg51jkYwMIztSY11ezfoQi
         lO0UCTySbozI2VRa0/XIx8acfh1lQMpFHkABYNBgpVm+ZxJOAwWqnZMt4g3/7725Gmvu
         Xzv4mLy09jg+ygfm1QgXHpN2m2JwqHDETeVWlxGLmmfI328oAwJGG0s5YzwBKgKwiCwJ
         GXLy8pTziiQv/Ra8jTYOXe5W8dLl9Z/XwjMLefN72eS9jaksgbYtUmakaE5LD0PJM4R0
         S0pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vCsP/Fi9p7wcfV9Mclr35lTEASR77uNfvxlH1mBaMZ8=;
        b=PYt134vcKeD7GxCjCzPQMbPHcsTETUkY3ntkbIwIEhcKFAebocDuxjmBAPuNX36Rgh
         wFB+KaR0WalOM+vKezRekFvSdZ1VCdgwvZ8/yKQ5fTFr3SRe1D4wP869032OHBQSCMoI
         Gf0PpriZCS7PqSIV0JpkCyxqGW+PSdTmWRhf12puIckxJ1Nw53i8vTAcOyRj+rLaoKAV
         Mzn9gZNYH7b4I4YcqqORdTEv05lIm9DpCYBvMVWQ4FZHLKnPWsB/tg3FhEqIPoccsSmU
         jQzxMN3hqVxA8btZV6FRAQqhgzjfeDutlBGK1xRp/KGBWpsm9rtUFMhjBCFKdNAttUyw
         evXg==
X-Gm-Message-State: AOAM530sorXNnwWc00DaDLm660X1OthskfR4pZ9YOZbgF5fyM6VJDp6L
        iH484WR19Zb6w2b5x2lG5MvB2HcOdu+uUzOg6Na+YQ==
X-Google-Smtp-Source: ABdhPJw8jSkyMc5FSVgVToRMpPNdgOeX63z4+lZHo7PCQvk9iYtRCIfB6vIzmcoO/DF8X/yJdxNNjWzN9tqb8+vsbbU=
X-Received: by 2002:a25:4446:: with SMTP id r67mr6029617yba.41.1589554425260;
 Fri, 15 May 2020 07:53:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200515065624.21658-1-irogers@google.com> <20200515065624.21658-5-irogers@google.com>
 <20200515091707.GC3511648@krava> <20200515142917.GT5583@kernel.org>
In-Reply-To: <20200515142917.GT5583@kernel.org>
From:   Ian Rogers <irogers@google.com>
Date:   Fri, 15 May 2020 07:53:33 -0700
Message-ID: <CAP-5=fXtXgnb4nrVtsoxQ6vj8YtzPicFsad6+jB5UUFqMzg4mw@mail.gmail.com>
Subject: Re: [PATCH 4/8] libbpf hashmap: Localize static hashmap__* symbols
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 7:29 AM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Fri, May 15, 2020 at 11:17:07AM +0200, Jiri Olsa escreveu:
> > On Thu, May 14, 2020 at 11:56:20PM -0700, Ian Rogers wrote:
> > > Localize the hashmap__* symbols in libbpf.a. To allow for a version in
> > > libapi.
> > >
> > > Before:
> > > $ nm libbpf.a
> > > ...
> > > 000000000002088a t hashmap_add_entry
> > > 000000000001712a t hashmap__append
> > > 0000000000020aa3 T hashmap__capacity
> > > 000000000002099c T hashmap__clear
> > > 00000000000208b3 t hashmap_del_entry
> > > 0000000000020fc1 T hashmap__delete
> > > 0000000000020f29 T hashmap__find
> > > 0000000000020c6c t hashmap_find_entry
> > > 0000000000020a61 T hashmap__free
> > > 0000000000020b08 t hashmap_grow
> > > 00000000000208dd T hashmap__init
> > > 0000000000020d35 T hashmap__insert
> > > 0000000000020ab5 t hashmap_needs_to_grow
> > > 0000000000020947 T hashmap__new
> > > 0000000000000775 t hashmap__set
> > > 00000000000212f8 t hashmap__set
> > > 0000000000020a91 T hashmap__size
> > > ...
> > >
> > > After:
> > > $ nm libbpf.a
> > > ...
> > > 000000000002088a t hashmap_add_entry
> > > 000000000001712a t hashmap__append
> > > 0000000000020aa3 t hashmap__capacity
> > > 000000000002099c t hashmap__clear
> > > 00000000000208b3 t hashmap_del_entry
> > > 0000000000020fc1 t hashmap__delete
> > > 0000000000020f29 t hashmap__find
> > > 0000000000020c6c t hashmap_find_entry
> > > 0000000000020a61 t hashmap__free
> > > 0000000000020b08 t hashmap_grow
> > > 00000000000208dd t hashmap__init
> > > 0000000000020d35 t hashmap__insert
> > > 0000000000020ab5 t hashmap_needs_to_grow
> > > 0000000000020947 t hashmap__new
> > > 0000000000000775 t hashmap__set
> > > 00000000000212f8 t hashmap__set
> > > 0000000000020a91 t hashmap__size
> > > ...
> >
> > I think this will break bpf selftests which use hashmap,
> > we need to find some other way to include this
> >
> > either to use it from libbpf directly, or use the api version
> > only if the libbpf is not compiled in perf, we could use
> > following to detect that:
> >
> >       CFLAGS += -DHAVE_LIBBPF_SUPPORT
> >       $(call detected,CONFIG_LIBBPF)
>
> And have it in tools/perf/util/ instead?
>
>
> - Arnaldo

*sigh*

$ make -C tools/testing/selftests/bpf test_hashmap
make: Entering directory
'/usr/local/google/home/irogers/kernel-trees/kernel.org/tip/tools/testing/s
elftests/bpf'
 BINARY   test_hashmap
/usr/bin/ld: /tmp/ccEGGNw5.o: in function `test_hashmap_generic':
/usr/local/google/home/irogers/kernel-trees/kernel.org/tip/tools/testing/selftests/bpf/test_hashmap.
c:61: undefined reference to `hashmap__new'
...

My preference was to make hashmap a sharable API in tools, to benefit
not just perf but say things like libsymbol, libperf, etc. Moving it
into perf and using conditional compilation is kinda gross but having
libbpf tests depend on libapi also isn't ideal I guess. It is tempting
to just cut a hashmap from fresh cloth to avoid this and to share
among tools/. I don't know if the bpf folks have opinions?

I'll do a v2 using conditional compilation to see how bad it looks.

Thanks,
Ian
