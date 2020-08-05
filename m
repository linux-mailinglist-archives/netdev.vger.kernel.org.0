Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D9F23C316
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 03:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgHEBil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 21:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgHEBik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 21:38:40 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C08C06174A;
        Tue,  4 Aug 2020 18:38:40 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id a34so17928178ybj.9;
        Tue, 04 Aug 2020 18:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6+uZyxND/e705z2BJrrSR+eq5E0rutVK6A3yMf2U9bQ=;
        b=u1HcNS5DtJRxqEPRRW0jRw44uthXArp0ZH7gKgekC/Kst/wtNFlT9qRGNLQ50DiI+k
         FSTvNBckWjeeIECB8B4PP2zPTZykyWeaBGWg+EXrzOF1gHRHb+TZEfJIiyHQskDWN2q2
         317QV2IVr++h0HqJLhyavIxc6UGRZnyOvo7Qm1DpsP6OTFTkqi/nRwOad5740h9t0Kgp
         ZPAguu8EkoVN6OBpjan02cmajgk4HZSqIyq6VYZrQ4qgglELW3XS6lGHHraR9bfJuYlH
         i6Pz1+SJjaU7OfkzpOb+rqq95F5WmMHMojDuUTDgkB+n+PNm43IYJz4fXEtU8lxNDLSV
         NhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6+uZyxND/e705z2BJrrSR+eq5E0rutVK6A3yMf2U9bQ=;
        b=CoFSe9i0Shnq3B3tJ+ghajqFx4zcjEXPY0msAy/5QlMP08yoKnQ9Hg7IDQMAWeu4t4
         c8SEKneh3yDFGOqT7ji3eLPjgyZzFVynqBqtXRD7qDViTV/qSR3QoYVFG+iTe4UCdBSi
         tJCkflqzgTnkcXLxpwnl4kLoy/7prZX2Fy/Xk1lYksEWxtTJpPgNWFslzpMuyhtBal9z
         V+EafOzePptcn32RujcG6yZ7tXUA2+aRYclT+UhP+6CK0xyFfVHAvhAHyKOkVbWjZnw3
         ALxeUG7doFA2WrWzqW6bHnK0zbMEFR55FjHXUgxnjI6VPO3uXRjYn9Tn8uqYAJZQMNxw
         6/dw==
X-Gm-Message-State: AOAM533LlK4d9dOmgdPy/l7wTGmPkNjtkf/XUvPt8W+pj5l1IVlKa/XO
        o8G9Puhi3w69KPWuu6Q28AfJQPMvw56UcscNhuAeKw==
X-Google-Smtp-Source: ABdhPJwPnvZup7P66a4UCySDlemSAW34C0XGHkBrWfaPqHOMtZNY81rM0rCzEqQ9UKWllMyXDlFjrSFMVPC4izRscsM=
X-Received: by 2002:a25:824a:: with SMTP id d10mr1370701ybn.260.1596591519526;
 Tue, 04 Aug 2020 18:38:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-3-songliubraving@fb.com> <CAEf4BzYp4gO1P+OrY7hGyQjdia3BuSu4DX2_z=UF6RfGNa+gkQ@mail.gmail.com>
 <9C1285C1-ECD6-46BD-BA95-3E9E81C00EF0@fb.com>
In-Reply-To: <9C1285C1-ECD6-46BD-BA95-3E9E81C00EF0@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Aug 2020 18:38:28 -0700
Message-ID: <CAEf4BzYojfFiMn6VeUkxUsdSTdFK0A4MzKQxhCCp_OowkseznQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] libbpf: support BPF_PROG_TYPE_USER programs
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

On Mon, Aug 3, 2020 at 6:18 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Aug 2, 2020, at 6:40 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wrote:
> >>
>
> [...]
>
> >
> >> };
> >>
> >> LIBBPF_API int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr);
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index b9f11f854985b..9ce175a486214 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -6922,6 +6922,7 @@ static const struct bpf_sec_def section_defs[] = {
> >>        BPF_PROG_SEC("lwt_out",                 BPF_PROG_TYPE_LWT_OUT),
> >>        BPF_PROG_SEC("lwt_xmit",                BPF_PROG_TYPE_LWT_XMIT),
> >>        BPF_PROG_SEC("lwt_seg6local",           BPF_PROG_TYPE_LWT_SEG6LOCAL),
> >> +       BPF_PROG_SEC("user",                    BPF_PROG_TYPE_USER),
> >
> > let's do "user/" for consistency with most other prog types (and nice
> > separation between prog type and custom user name)
>
> About "user" vs. "user/", I still think "user" is better.
>
> Unlike kprobe and tracepoint, user prog doesn't use the part after "/".
> This is similar to "perf_event" for BPF_PROG_TYPE_PERF_EVENT, "xdl" for
> BPF_PROG_TYPE_XDP, etc. If we specify "user" here, "user/" and "user/xxx"
> would also work. However, if we specify "user/" here, programs that used
> "user" by accident will fail to load, with a message like:
>
>         libbpf: failed to load program 'user'
>
> which is confusing.

xdp, perf_event and a bunch of others don't enforce it, that's true,
they are a bit of a legacy, unfortunately. But all the recent ones do,
and we explicitly did that for xdp_dev/xdp_cpu, for instance.
Specifying just "user" in the spec would allow something nonsensical
like "userargh", for instance, due to this being treated as a prefix.
There is no harm to require users to do "user/my_prog", though.

Alternatively, we could introduce a new convention in the spec,
something like "user?", which would accept either "user" or
"user/something", but not "user/" nor "userblah". We can try that as
well.

>
> Thanks,
> Song
>
> [...]
>
