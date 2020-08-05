Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3D423C51F
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 07:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgHEFc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 01:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgHEFc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 01:32:28 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD2DC06174A;
        Tue,  4 Aug 2020 22:32:28 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id x2so3009536ybf.12;
        Tue, 04 Aug 2020 22:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YpGNJNneul98XnDqtT/QOJSJMgZK2bW7XIvn25SXzww=;
        b=jKh3PsYXTI3jIWEPnkM/9wg9S/WKW84o/bLlQ+DoSG91WAcBjwj1HqBEKRSJ03DNEW
         zSrdlPvqHTdJWKNEOU0gPZlvWCWLK0bMMhEn+UKWxcg60YF2mj/ioufn+WQECpGiZkcf
         J8uuNREAjFLAsg2gPsB9PhETWS4QhIxDvnlyEB8eJRg+SuuK5K0ZNVgQQ9FE1CFTg8Fs
         umeJvsQsOyNDg3Oa/tlLmZGU9h8k1bY3Ij9Kai9U1bTnJwiYykj1EoGVeN8avgnfF+mu
         NkNQKthajBr0cbqNr6DJK5D/EDHF7UQ6eIqx7VbKpM0lXrg6kFSdl8bh0KfYnO7179O6
         2QpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YpGNJNneul98XnDqtT/QOJSJMgZK2bW7XIvn25SXzww=;
        b=oR1hvVhAJF2o4AYagq6fYIOqm6R6bBu5nFjm5JBm2fZXZ/LpBU5sLaCRG20s4VAZHe
         w+/gBWWMT67oGb2K/yMNZ5C8NAsorCokETyXNcoIS0J1VZ1Bw71LumstxS8h4cyzoAjE
         F/kTLsFaN12+QBKk5tV9ylqqgpP0lRnr7VUjttvhvl0yDyEBWo4/87+5ALw3B14weGBJ
         9KMalPAXmoQjuCmXKleLDxhnnq/+lDCEJQj0ioy+Ma/sqPKxZWqfM0GzjaWRHh0Ad/+B
         QEgIdWKvT2z53NkgcryDHiI/4k1apqbWI4ljfWhN6oV+AXvZdYEEUxzmdbChdv3I/F4Q
         K7YQ==
X-Gm-Message-State: AOAM530Cl/v2WeHM5guQCS5oowihsYt2aVUt7gRXQPYEtUKydJYHENxQ
        Ukva484ya6KOGDB+ZHAFoTwZX50shsieg3n7Xx8=
X-Google-Smtp-Source: ABdhPJwv8UB4Ke8FuDz2mBp8GMRbaVgBf3OBkslwhaH3lQk0dyChp26o3LhsZOer9JWm2/Dk47hC1VxWcf/tAwNv0U4=
X-Received: by 2002:a25:84cd:: with SMTP id x13mr2272267ybm.425.1596605547454;
 Tue, 04 Aug 2020 22:32:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-3-songliubraving@fb.com> <CAEf4BzYp4gO1P+OrY7hGyQjdia3BuSu4DX2_z=UF6RfGNa+gkQ@mail.gmail.com>
 <9C1285C1-ECD6-46BD-BA95-3E9E81C00EF0@fb.com> <CAEf4BzYojfFiMn6VeUkxUsdSTdFK0A4MzKQxhCCp_OowkseznQ@mail.gmail.com>
 <5BC1D7AD-32C1-4CDC-BA99-F4DABE61EEA3@fb.com>
In-Reply-To: <5BC1D7AD-32C1-4CDC-BA99-F4DABE61EEA3@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Aug 2020 22:32:16 -0700
Message-ID: <CAEf4BzbbCZmijrU4vfkmq2PFsMMFG+xz9qR1e4wfrdm6tF4_hA@mail.gmail.com>
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

On Tue, Aug 4, 2020 at 8:59 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Aug 4, 2020, at 6:38 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Aug 3, 2020 at 6:18 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Aug 2, 2020, at 6:40 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >>>
> >>> On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wrote:
> >>>>
> >>
> >> [...]
> >>
> >>>
> >>>> };
> >>>>
> >>>> LIBBPF_API int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr);
> >>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >>>> index b9f11f854985b..9ce175a486214 100644
> >>>> --- a/tools/lib/bpf/libbpf.c
> >>>> +++ b/tools/lib/bpf/libbpf.c
> >>>> @@ -6922,6 +6922,7 @@ static const struct bpf_sec_def section_defs[] = {
> >>>>       BPF_PROG_SEC("lwt_out",                 BPF_PROG_TYPE_LWT_OUT),
> >>>>       BPF_PROG_SEC("lwt_xmit",                BPF_PROG_TYPE_LWT_XMIT),
> >>>>       BPF_PROG_SEC("lwt_seg6local",           BPF_PROG_TYPE_LWT_SEG6LOCAL),
> >>>> +       BPF_PROG_SEC("user",                    BPF_PROG_TYPE_USER),
> >>>
> >>> let's do "user/" for consistency with most other prog types (and nice
> >>> separation between prog type and custom user name)
> >>
> >> About "user" vs. "user/", I still think "user" is better.
> >>
> >> Unlike kprobe and tracepoint, user prog doesn't use the part after "/".
> >> This is similar to "perf_event" for BPF_PROG_TYPE_PERF_EVENT, "xdl" for
> >> BPF_PROG_TYPE_XDP, etc. If we specify "user" here, "user/" and "user/xxx"
> >> would also work. However, if we specify "user/" here, programs that used
> >> "user" by accident will fail to load, with a message like:
> >>
> >>        libbpf: failed to load program 'user'
> >>
> >> which is confusing.
> >
> > xdp, perf_event and a bunch of others don't enforce it, that's true,
> > they are a bit of a legacy,
>
> I don't see w/o "/" is a legacy thing. BPF_PROG_TYPE_STRUCT_OPS just uses
> "struct_ops".
>
> > unfortunately. But all the recent ones do,
> > and we explicitly did that for xdp_dev/xdp_cpu, for instance.
> > Specifying just "user" in the spec would allow something nonsensical
> > like "userargh", for instance, due to this being treated as a prefix.
> > There is no harm to require users to do "user/my_prog", though.
>
> I don't see why allowing "userargh" is a problem. Failing "user" is
> more confusing. We can probably improve that by a hint like:
>
>     libbpf: failed to load program 'user', do you mean "user/"?
>
> But it is pretty silly. "user/something_never_used" also looks weird.

"userargh" is terrible, IMO. It's a different identifier that just
happens to have the first 4 letters matching "user" program type.
There must be either a standardized separator (which happens to be
'/') or none. See the suggestion below.
>
> > Alternatively, we could introduce a new convention in the spec,
> > something like "user?", which would accept either "user" or
> > "user/something", but not "user/" nor "userblah". We can try that as
> > well.
>
> Again, I don't really understand why allowing "userblah" is a problem.
> We already have "xdp", "xdp_devmap/", and "xdp_cpumap/", they all work
> fine so far.

Right, we have "xdp_devmap/" and "xdp_cpumap/", as you say. I haven't
seen so much pushback against trailing forward slash with those ;)

But anyways, as part of deprecating APIs and preparing libbpf for 1.0
release over this half, I think I'm going to emit warnings for names
like "prog_type_whatever" or "prog_typeevenworse", etc. And asking
users to normalize section names to either "prog_type" or
"prog_type/something/here", whichever makes sense for a specific
program type. Right now libbpf doesn't allow two separate BPF programs
with the same section name, so enforcing strict "user" is limiting to
users. We are going to lift that restriction pretty soon, though. But
for now, please stick with what we've been doing lately and mark it as
"user/", later we'll allow just "user" as well.

>
> Thanks,
> Song
