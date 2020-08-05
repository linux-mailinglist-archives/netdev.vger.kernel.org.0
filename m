Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F1C23C63E
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 08:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgHEGya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 02:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgHEGya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 02:54:30 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E72C06174A;
        Tue,  4 Aug 2020 23:54:29 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id x2so3103762ybf.12;
        Tue, 04 Aug 2020 23:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xTEd3nRic+QB5ggRL63Pqwitnac1w25gtRmCK8xAnw4=;
        b=ebgdB1vqchfAykMJvcS6HR3qnKAXivBJAkoLEAsfzModXNNyJ/DnIVqUt0Oc6aCLmx
         yj6yHtZgJWyYDcjJsOZdWBVK74iijBWtRf/03km7fc8af+BSAeGP4K5Iak/Lf2DozuvR
         w2gFFyP999cB36wVrrboDChhrQiITWFRfVvFczX+Wf+UwsSvjNEXEpNUB0yaa196Nocq
         lGDpiPbs31+nLEW/N34LICSvf26cds8iAkvV6rmINARkA5P2IbVuLLA06JeMQJY0g9zK
         H3uPF+RVLpQh2JPZTqWj+1EjJw1LJyAXHcJno4bmor0OjCOtrNyAIlmS5Fro32l6TrlG
         vhwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xTEd3nRic+QB5ggRL63Pqwitnac1w25gtRmCK8xAnw4=;
        b=KGeQSLD8Pxl7g7IfJrf0w3ow5VAHC7tu9A4yQa4zxyduFsyIoY8kvfTexYWCnivsch
         Vo2WUCMkDoWbpXuUxiCfzRa3RP3THqrCA3auXH7GvLA9g7mz0iYH1wZ97OzCpeXB7+Rc
         YDL2KObiCgjsbitDJilnDh/EfV9PPnuf/0ZETHhE37W0u4+9QGn2tGSEQIvHNVQQVvDg
         GmHg/pOBMk3TuB4A7P6DoK6EYvUVlOAAaD2fjhNvDtwJgUhIGuiIyqcIfdOLxjQRZiCT
         OV5SIirUceVdX1CtO0dw2bo6H4QlozanHAj8zSJAxblamNYb5wYju0gfdWWLKmQzgh5+
         qcTA==
X-Gm-Message-State: AOAM531kCfdwNqmJNcTM/g8Zsi6be++lGH9mDyruSKB+zfuNZIw7Mc4U
        dSm33udDUFT5mLN/zgc8fmYlBVfO8J8RANS5tSw=
X-Google-Smtp-Source: ABdhPJwG64UwA4tapOtTIu5DZTpK85i681anKVYYWCnv86aGdIppK3OxafxHP0/fIf6TxmPZq5UVyFyvBlh3uT6zUGM=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr2539928ybq.27.1596610468393;
 Tue, 04 Aug 2020 23:54:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-3-songliubraving@fb.com> <CAEf4BzYp4gO1P+OrY7hGyQjdia3BuSu4DX2_z=UF6RfGNa+gkQ@mail.gmail.com>
 <9C1285C1-ECD6-46BD-BA95-3E9E81C00EF0@fb.com> <CAEf4BzYojfFiMn6VeUkxUsdSTdFK0A4MzKQxhCCp_OowkseznQ@mail.gmail.com>
 <5BC1D7AD-32C1-4CDC-BA99-F4DABE61EEA3@fb.com> <CAEf4BzbbCZmijrU4vfkmq2PFsMMFG+xz9qR1e4wfrdm6tF4_hA@mail.gmail.com>
 <4DB698F2-BC51-4E96-BC3B-F478BE9AE106@fb.com>
In-Reply-To: <4DB698F2-BC51-4E96-BC3B-F478BE9AE106@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Aug 2020 23:54:16 -0700
Message-ID: <CAEf4Bza4KXkVov=UwouryG5JcqYQ=9mDG8nBoWmb97rv+_yqTw@mail.gmail.com>
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

On Tue, Aug 4, 2020 at 11:26 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Aug 4, 2020, at 10:32 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Aug 4, 2020 at 8:59 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Aug 4, 2020, at 6:38 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >>>
> >>> On Mon, Aug 3, 2020 at 6:18 PM Song Liu <songliubraving@fb.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>>> On Aug 2, 2020, at 6:40 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >>>>>
> >>>>> On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wrote:
> >>>>>>
> >>>>
> >>>> [...]
> >>>>
> >>>>>
> >>>>>> };
> >>>>>>
> >>>>>> LIBBPF_API int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr);
> >>>>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >>>>>> index b9f11f854985b..9ce175a486214 100644
> >>>>>> --- a/tools/lib/bpf/libbpf.c
> >>>>>> +++ b/tools/lib/bpf/libbpf.c
> >>>>>> @@ -6922,6 +6922,7 @@ static const struct bpf_sec_def section_defs[] = {
> >>>>>>      BPF_PROG_SEC("lwt_out",                 BPF_PROG_TYPE_LWT_OUT),
> >>>>>>      BPF_PROG_SEC("lwt_xmit",                BPF_PROG_TYPE_LWT_XMIT),
> >>>>>>      BPF_PROG_SEC("lwt_seg6local",           BPF_PROG_TYPE_LWT_SEG6LOCAL),
> >>>>>> +       BPF_PROG_SEC("user",                    BPF_PROG_TYPE_USER),
> >>>>>
> >>>>> let's do "user/" for consistency with most other prog types (and nice
> >>>>> separation between prog type and custom user name)
> >>>>
> >>>> About "user" vs. "user/", I still think "user" is better.
> >>>>
> >>>> Unlike kprobe and tracepoint, user prog doesn't use the part after "/".
> >>>> This is similar to "perf_event" for BPF_PROG_TYPE_PERF_EVENT, "xdl" for
> >>>> BPF_PROG_TYPE_XDP, etc. If we specify "user" here, "user/" and "user/xxx"
> >>>> would also work. However, if we specify "user/" here, programs that used
> >>>> "user" by accident will fail to load, with a message like:
> >>>>
> >>>>       libbpf: failed to load program 'user'
> >>>>
> >>>> which is confusing.
> >>>
> >>> xdp, perf_event and a bunch of others don't enforce it, that's true,
> >>> they are a bit of a legacy,
> >>
> >> I don't see w/o "/" is a legacy thing. BPF_PROG_TYPE_STRUCT_OPS just uses
> >> "struct_ops".
> >>
> >>> unfortunately. But all the recent ones do,
> >>> and we explicitly did that for xdp_dev/xdp_cpu, for instance.
> >>> Specifying just "user" in the spec would allow something nonsensical
> >>> like "userargh", for instance, due to this being treated as a prefix.
> >>> There is no harm to require users to do "user/my_prog", though.
> >>
> >> I don't see why allowing "userargh" is a problem. Failing "user" is
> >> more confusing. We can probably improve that by a hint like:
> >>
> >>    libbpf: failed to load program 'user', do you mean "user/"?
> >>
> >> But it is pretty silly. "user/something_never_used" also looks weird.
> >
> > "userargh" is terrible, IMO. It's a different identifier that just
> > happens to have the first 4 letters matching "user" program type.
> > There must be either a standardized separator (which happens to be
> > '/') or none. See the suggestion below.
>
> We have no problem deal with "a different identifier that just happens
> to have the first letters matching", like xdp vs. xdp_devmap and
> xdp_cpumap, right?
>

xdp vs xdp_devmap is an entirely different thing. We deal with it by
checking xdp_devmap first. What I'm saying is that user can do
"xdpomg" and libbpf would be happy (today). And I don't think that's
good. But further, if someone does something like "xdp_devmap_omg",
guess which program type will be inferred? Hint: not xdp_devmap and
libbpf won't report an error either. All because "xdp" is so lax
today.

> >>
> >>> Alternatively, we could introduce a new convention in the spec,
> >>> something like "user?", which would accept either "user" or
> >>> "user/something", but not "user/" nor "userblah". We can try that as
> >>> well.
> >>
> >> Again, I don't really understand why allowing "userblah" is a problem.
> >> We already have "xdp", "xdp_devmap/", and "xdp_cpumap/", they all work
> >> fine so far.
> >
> > Right, we have "xdp_devmap/" and "xdp_cpumap/", as you say. I haven't
> > seen so much pushback against trailing forward slash with those ;)
>
> I haven't seen any issue with old "perf_event", "xdp" and new "struct_ops"
> either.
>
> >
> > But anyways, as part of deprecating APIs and preparing libbpf for 1.0
> > release over this half, I think I'm going to emit warnings for names
> > like "prog_type_whatever" or "prog_typeevenworse", etc. And asking
> > users to normalize section names to either "prog_type" or
> > "prog_type/something/here", whichever makes sense for a specific
> > program type.
>
> Exactly, "user" makes sense here; while "kprobe/__set_task_comm" makes
> sense for kprobe.

Right, but "userblah" doesn't. It would be great if you could help
make what I described above become true. But at least don't make it
worse by allowing unrestricted "user" prefix. I'm OK with strict
"user" or "user/blah", I'm not OK with "userblah", I'm sorry.

>
> > Right now libbpf doesn't allow two separate BPF programs
> > with the same section name, so enforcing strict "user" is limiting to
> > users. We are going to lift that restriction pretty soon, though. But
> > for now, please stick with what we've been doing lately and mark it as
> > "user/", later we'll allow just "user" as well.
>
> Since we would allow "user" later, why we have to reject it for now?

Because libbpf is dumb in that regard today? And instead of migrating
users later, I want to prevent users making bad choices right now.
Then relax it, if necessary. Alternatively, we can fix up libbpf logic
before the USER program type lands.

> Imagine the user just compiled and booted into a new kernel with user
> program support; and then got the following message:
>
>         libbpf: failed to load program 'user'
>
> If I were the user, I would definitely question whether the kernel was
> correct...

That's also bad, and again, we can make libbpf better. I think moving
forward any non-recognized BPF program type should be reported by
libbpf as an error. But we can't do it right now, we have to have a
period in which users will get a chance to update their BPF programs.
This will have to happen over few libbpf releases at least. So please
join in on the fun of fixing stuff like this.
