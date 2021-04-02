Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2B6352F85
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 21:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236274AbhDBTIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 15:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhDBTIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 15:08:37 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692F3C0613E6;
        Fri,  2 Apr 2021 12:08:34 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so4979066pjq.5;
        Fri, 02 Apr 2021 12:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vcm2XPETRMJjxtPIhb8l7WsmDGD0aL+j1F2VkszeHMY=;
        b=QwMqkvMGpzoYLScjb2eWKSZOcGpOfoS8hsC2umnqUN5lDsZIbX/jDksX9FA8ofOJUk
         shDzBwMXVR36lmB2hI4vPsmBLJYvD6TafUPEeAOattB9bgGjwfbzbsX3Al1y1n1hXywe
         SYpQ4VWbDruyeDdA7O+BVdRb7+gH/E+1m82RVKUlETRlNlP7l5p90yO5H9l5a4DKVbjJ
         MHS+vNpfwHeg1JthhvS0ngFqEZ8AyuuywAaaykwx61Db8yFJgWidIHNooCgJSTxdsSyK
         zbDmwDmPvFHAJ5DBATc72PApHgJJ6i64GPwXp3PHJ9pUBsBAQpW3+mf0noYGHvFGaq+o
         Cvrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vcm2XPETRMJjxtPIhb8l7WsmDGD0aL+j1F2VkszeHMY=;
        b=UufKBqmPVE9ruYEyk5jXK8lO1KeEzuyo2UdkvBwGpNF7rbceiBCLMAwnOSbjDjXq/C
         LBVcyU59Un4TYLeXoAJDLYGBiYH/BcHexSSOcNP9vZRxW+vyzCRHvk4/lu1TAs7Nyq99
         3Z30huyamdNAjhQPV6G6lTtOXouyFg8VxBNmhYsOOhVcLGcvLxkHXocdijYaS9+F/gQS
         VqVxSRL1X2hRwCbnYRke3EfFL586KEG3DQP5brZf6ZJ9UnNze7AH//oKBJYIHWgu+tf5
         9vde67ESKDD7m+/rnDZGf+dY5GVqte32d129zCW640lDMu+gotS9z/dsmZs8N5hR7qvN
         TuHw==
X-Gm-Message-State: AOAM530lRlZ+hKUpKO30ffQlMqIOU7OKs78DVKy9YFWzMcR9qXg5PlEx
        axUwia5+NvMcMGngl7QIFFc876n5DKOwyxwnNgY=
X-Google-Smtp-Source: ABdhPJzKgq2UBdFcOaBRjhDgSv/tOVjFmYljVJd/mLC+tnRMXE61rsTfiIXhJ1+vNo/l4+a7pjo0sigQzcMyfADrKAM=
X-Received: by 2002:a17:90a:a08c:: with SMTP id r12mr434461pjp.231.1617390513993;
 Fri, 02 Apr 2021 12:08:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <B42B247A-4D0B-4DE9-B4D3-0C452472532D@fb.com> <CAM_iQpW-cuiYsPsu4mYZxZ1Oixffu2pV1TFg1c+eg9XT3wWwPQ@mail.gmail.com>
 <E0D5B076-A726-4845-8F12-640BAA853525@fb.com> <CAM_iQpWdO7efdcA2ovDsOF9XLhWJGgd6Be5qq0=xLphVBRE_Gw@mail.gmail.com>
 <93BBD473-7E1C-4A6E-8BB7-12E63D4799E8@fb.com>
In-Reply-To: <93BBD473-7E1C-4A6E-8BB7-12E63D4799E8@fb.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 2 Apr 2021 12:08:23 -0700
Message-ID: <CAM_iQpXEuxwQvT9FNqDa7y5kNpknA4xMNo_973ncy3iYaF-NTA@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Song Liu <songliubraving@fb.com>
Cc:     "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>,
        "duanxiongchun@bytedance.com" <duanxiongchun@bytedance.com>,
        "wangdongdong.6@bytedance.com" <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 2, 2021 at 10:57 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Apr 2, 2021, at 10:34 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Thu, Apr 1, 2021 at 1:17 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Apr 1, 2021, at 10:28 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >>>
> >>> On Wed, Mar 31, 2021 at 11:38 PM Song Liu <songliubraving@fb.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>>> On Mar 31, 2021, at 9:26 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >>>>>
> >>>>> From: Cong Wang <cong.wang@bytedance.com>
> >>>>>
> >>>>> (This patch is still in early stage and obviously incomplete. I am sending
> >>>>> it out to get some high-level feedbacks. Please kindly ignore any coding
> >>>>> details for now and focus on the design.)
> >>>>
> >>>> Could you please explain the use case of the timer? Is it the same as
> >>>> earlier proposal of BPF_MAP_TYPE_TIMEOUT_HASH?
> >>>>
> >>>> Assuming that is the case, I guess the use case is to assign an expire
> >>>> time for each element in a hash map; and periodically remove expired
> >>>> element from the map.
> >>>>
> >>>> If this is still correct, my next question is: how does this compare
> >>>> against a user space timer? Will the user space timer be too slow?
> >>>
> >>> Yes, as I explained in timeout hashmap patchset, doing it in user-space
> >>> would require a lot of syscalls (without batching) or copying (with batching).
> >>> I will add the explanation here, in case people miss why we need a timer.
> >>
> >> How about we use a user space timer to trigger a BPF program (e.g. use
> >> BPF_PROG_TEST_RUN on a raw_tp program); then, in the BPF program, we can
> >> use bpf_for_each_map_elem and bpf_map_delete_elem to scan and update the
> >> map? With this approach, we only need one syscall per period.
> >
> > Interesting, I didn't know we can explicitly trigger a BPF program running
> > from user-space. Is it for testing purposes only?
>
> This is not only for testing. We will use this in perf (starting in 5.13).
>
> /* currently in Arnaldo's tree, tools/perf/util/bpf_counter.c: */
>
> /* trigger the leader program on a cpu */
> static int bperf_trigger_reading(int prog_fd, int cpu)
> {
>         DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
>                             .ctx_in = NULL,
>                             .ctx_size_in = 0,
>                             .flags = BPF_F_TEST_RUN_ON_CPU,
>                             .cpu = cpu,
>                             .retval = 0,
>                 );
>
>         return bpf_prog_test_run_opts(prog_fd, &opts);
> }
>
> test_run also passes return value (retval) back to user space, so we and
> adjust the timer interval based on retval.

This is really odd, every name here contains a "test" but it is not for testing
purposes. You probably need to rename/alias it. ;)

So, with this we have to get a user-space daemon running just to keep
this "timer" alive. If I want to run it every 1ms, it means I have to issue
a syscall BPF_PROG_TEST_RUN every 1ms. Even with a timer fd, we
still need poll() and timerfd_settime(). This is a considerable overhead
for just a single timer.

With current design, user-space can just exit after installing the timer,
either it can adjust itself or other eBPF code can adjust it, so the per
timer overhead is the same as a kernel timer.

The visibility to other BPF code is important for the conntrack case,
because each time we get an expired item during a lookup, we may
want to schedule the GC timer to run sooner. At least this would give
users more freedom to decide when to reschedule the timer.

Thanks.
