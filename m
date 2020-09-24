Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E29C2765BB
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgIXBLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbgIXBLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:11:24 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8473EC0613CE;
        Wed, 23 Sep 2020 18:11:24 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 67so1116734ybt.6;
        Wed, 23 Sep 2020 18:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ieOIn/PtT6wPpspeOUfOVJEF8SdgPueCo5bXoXjMlKA=;
        b=N/8nVC6q5znO9d09i7BV9qin54ZEtry0CMXUx4OVxiuD4vQv3inyqEBT8E0LJ+SqXt
         sYVqZwYS31qDThxhB3EjA05+bg8d9fLi398xBJN+wREwyNiYBZkZAhi/LngGwUIS6igI
         Aq3ExXbw7hSVg2ILIIFc6+N+hygTy22YJ3FurqqugSO44A2nIxr/r6Fw+8fLsRj2Yl/n
         Gp0Hl4z0anqX3UEA2PyhNPDFDNEqYLeagGqlowKmj3myPsi4WSjLFh48K8IBKXgBWVRE
         Bqxar9pEBIJiFPsVEWlP/wZd7w9Wb28Ye/XU7Sc/jrKrm9StSJvDxNJd+XRXAX7gcVWs
         S9Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ieOIn/PtT6wPpspeOUfOVJEF8SdgPueCo5bXoXjMlKA=;
        b=sqY5r/ZhekkrGWQTMc0u1xFHFT893mQlt7sdfU9LL77I1DfMSVXPOxqm6FEdFc5n3D
         GmfoaNeHiqnCT+0pOnWFDTEXE8XuhHjWg7qfoBHLeZgA4i2goeRxuDTVtPeNYF0lO3OJ
         lETkecEjY48ktCJF3IAtjcvu0omUSIKOV7yddBZ3kZ4emGl7ybz2aYWUMkIPg64CIEJW
         w53ctK5vqZgG3+NNmVk8okAk1jLpVhbhWP5Bh6V02MsO3FKZ4LkmfeK/CUuXSvwp/rmD
         RsGV/uItaELTZZseczD+uFAZVlubiK7gY66b4kElUh3m1zW7jf3On/vr21fBV1+XEbfI
         XH4w==
X-Gm-Message-State: AOAM53017MzyNuCRLhHsBe4P9Zuvvwd4uX3lc5no/VdbHAyi7sIjujnk
        KQLagBoMeggEUepXdfkkiZkxPTiVrNXPbOE/1vBqtTm7/8Q=
X-Google-Smtp-Source: ABdhPJz/msuj+F8hVdNrO6lfBI0L3bU0zD0vz7P6KKwnuhfFmzxPLQn6myilb4YLUmc0tJ6Wu+Wqk/zsVB26MHvhsoU=
X-Received: by 2002:a25:6644:: with SMTP id z4mr3977800ybm.347.1600909883666;
 Wed, 23 Sep 2020 18:11:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200923165401.2284447-1-songliubraving@fb.com>
 <20200923165401.2284447-3-songliubraving@fb.com> <CAEf4BzZ-qPNjDEvviJKHfLD7t7YJ97PdGixGQ_f70AJEg5oVEg@mail.gmail.com>
 <540DD049-B544-4967-8300-E743940FD6FC@fb.com>
In-Reply-To: <540DD049-B544-4967-8300-E743940FD6FC@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 23 Sep 2020 18:11:12 -0700
Message-ID: <CAEf4BzYDsBMmBBtgauqdR9HYDeRG-GbMMTG6FUDbpWgOuU_Ljg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/3] libbpf: introduce bpf_prog_test_run_xattr_opts
To:     Song Liu <songliubraving@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 4:54 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Sep 23, 2020, at 12:31 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Sep 23, 2020 at 9:55 AM Song Liu <songliubraving@fb.com> wrote:
> >>
> >> This API supports new field cpu_plus in bpf_attr.test.
> >>
> >> Acked-by: John Fastabend <john.fastabend@gmail.com>
> >> Signed-off-by: Song Liu <songliubraving@fb.com>
> >> ---
> >> tools/lib/bpf/bpf.c      | 13 ++++++++++++-
> >> tools/lib/bpf/bpf.h      | 11 +++++++++++
> >> tools/lib/bpf/libbpf.map |  1 +
> >> 3 files changed, 24 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> >> index 2baa1308737c8..3228dd60fa32f 100644
> >> --- a/tools/lib/bpf/bpf.c
> >> +++ b/tools/lib/bpf/bpf.c
> >> @@ -684,7 +684,8 @@ int bpf_prog_test_run(int prog_fd, int repeat, void *data, __u32 size,
> >>        return ret;
> >> }
> >>
> >> -int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr)
> >> +int bpf_prog_test_run_xattr_opts(struct bpf_prog_test_run_attr *test_attr,
> >> +                                const struct bpf_prog_test_run_opts *opts)
> >
> > opts are replacement for test_attr, not an addition to it. We chose to
> > use _xattr suffix for low-level APIs previously, but it's already
> > "taken". So I'd suggest to go with just  bpf_prog_test_run_ops and
> > have prog_fd as a first argument and then put all the rest of
> > test_run_attr into opts.
>
> One question on this: from the code, most (if not all) of these xxx_opts
> are used as input only. For example:
>
> LIBBPF_API int bpf_prog_bind_map(int prog_fd, int map_fd,
>                                  const struct bpf_prog_bind_opts *opts);
>
> However, bpf_prog_test_run_attr contains both input and output. Do you
> have any concern we use bpf_prog_test_run_opts for both input and output?
>

I think it should be ok. opts are about passing optional things in a
way that would be backward/forward compatible. Whether it's input
only, output only, or input/output is secondary. We haven't had a need
for output params yet, so this will be the first, but I think it fits
here just fine. Just document it in the struct definition clearly and
that's it. As for the mechanics, we might want to do OPTS_SET() macro,
that will set some fields only if the user provided enough memory to
fir that output parameter. That should work here pretty cleanly,
right?

> Thanks,
> Song
>
>
> > BTW, it's also probably overdue to have a higher-level
> > bpf_program__test_run(), which can re-use the same
> > bpf_prog_test_run_opts options struct. It would be more convenient to
> > use it with libbpf bpf_object/bpf_program APIs.
> >
> >> {
> >>        union bpf_attr attr;
> >>        int ret;
> >> @@ -693,6 +694,11 @@ int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr)
> >>                return -EINVAL;
> >>
> >>        memset(&attr, 0, sizeof(attr));
> >> +       if (opts) {
> >
> > you don't need to check opts for being not NULL, OPTS_VALID handle that already.
> >
> >> +               if (!OPTS_VALID(opts, bpf_prog_test_run_opts))
> >> +                       return -EINVAL;
> >> +               attr.test.cpu_plus = opts->cpu_plus;
> >
> > And here you should use OPTS_GET(), please see other examples in
> > libbpf for proper usage.
> >
> >
> >> +       }
> >>        attr.test.prog_fd = test_attr->prog_fd;
> >>        attr.test.data_in = ptr_to_u64(test_attr->data_in);
> >>        attr.test.data_out = ptr_to_u64(test_attr->data_out);
> >> @@ -712,6 +718,11 @@ int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr)
> >>        return ret;
> >> }
> >>
> >
> > [...]
>
