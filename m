Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A763D3D06
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235744AbhGWPRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235588AbhGWPRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:17:12 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1408C061575;
        Fri, 23 Jul 2021 08:57:44 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id g76so3073452ybf.4;
        Fri, 23 Jul 2021 08:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eM7oLkbl55Sp+y9u9unsbNhBDcbo6NHdbVU2cI1rMXw=;
        b=jizcHyZzOR+lsQWkbAMJANHGA5XZFmCH4whNVF3heYuXkExvz66pXTJayw/KefJZmX
         PZc2PPS4qaoZsqOZt+frP1W9iwHdoDmWXvHEiXphZiHXQcffU0ucTwls8+EdIIYaJ6O1
         WTvj6iL6Gw9IHfBowMoA7vWTDzXnOIH/85LeVfqDgzswhDVKNVlyEonrMc5KtDyzMRT1
         v0OvZ09QxXtPi130wTLeny8YUNgH1fY8mLSTVrBDPYLrUVp/tRdQ1SWXvDG64zjWwPLd
         jiewSC+lzOOdm1eKamZqIBJ8V5P1eFxYUnDkFZwzxqSeztfIXUEjVqCZ3Y35CBbd3MID
         YpWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eM7oLkbl55Sp+y9u9unsbNhBDcbo6NHdbVU2cI1rMXw=;
        b=NlwxtaxIVgVSuI2Cp7yuZsQ3Dz2iNIk0QZ4Ml7vtARedUsrVIdqm9WJCGXpfd4CjPb
         RDTOX6EqndaukNkMeTaUIjUI5pUwXASfACNcmPqnEsLqQ+FzDrNjwQq93ElgS/06R2za
         MSoyJ/q8YdgvbUVF+QcClbgijD+Dks8oVtDb3a5GjjqdztNCw1ymQ4WPHLfGx9WyHgc5
         ukrBRAz3UqyKFTn27iigyafI6I5j9m4r/hV7I+kbfOHuwPm49k7hWi1SpUMBGyU/IveN
         YBpWOlGEKqUigcycClxFxSpHbLDYIO/nSfOVxLpHyTpFOHiqPPfVnYjFvxTLC2zdluAk
         aKcw==
X-Gm-Message-State: AOAM530WJuIbw8uvBnXCPrsRxu8b46jgNdF+pHCaBSJXe/AaxPbQbLym
        EFqfYcUWCYSpcwk2QEFAZzGmlY9fIy6ibGl1WmQ=
X-Google-Smtp-Source: ABdhPJzdYg4rmxXR67Iu314AWPaWYJjKhpzXjyiuB/FXLNdqMh2UQLFcSqdQZKfMRQAZ8QpW2s97alJJtmZREAB8AWk=
X-Received: by 2002:a25:bd09:: with SMTP id f9mr7340404ybk.27.1627055863976;
 Fri, 23 Jul 2021 08:57:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210721153808.6902-1-quentin@isovalent.com> <20210721153808.6902-4-quentin@isovalent.com>
 <CAEf4BzatvJORZvkz37_XJxvk5+Amr8V8iHq=1_4k_uCz0fE-eQ@mail.gmail.com> <3802e42d-321f-6580-8d6a-f862ac4f62da@isovalent.com>
In-Reply-To: <3802e42d-321f-6580-8d6a-f862ac4f62da@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Jul 2021 08:57:33 -0700
Message-ID: <CAEf4BzZ-a-ZC22iO2fOO3c2HY8iB6MUt0W1gBOoV+V9SnRqARA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/5] tools: replace btf__get_from_id() with btf__load_from_kernel_by_id()
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 2:52 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-07-22 17:48 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > On Wed, Jul 21, 2021 at 8:38 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> Replace the calls to deprecated function btf__get_from_id() with calls
> >> to btf__load_from_kernel_by_id() in tools/ (bpftool, perf, selftests).
> >> Update the surrounding code accordingly (instead of passing a pointer to
> >> the btf struct, get it as a return value from the function). Also make
> >> sure that btf__free() is called on the pointer after use.
> >>
> >> v2:
> >> - Given that btf__load_from_kernel_by_id() has changed since v1, adapt
> >>   the code accordingly instead of just renaming the function. Also add a
> >>   few calls to btf__free() when necessary.
> >>
> >> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> >> Acked-by: John Fastabend <john.fastabend@gmail.com>
> >> ---
> >>  tools/bpf/bpftool/btf.c                      |  8 ++----
> >>  tools/bpf/bpftool/btf_dumper.c               |  6 ++--
> >>  tools/bpf/bpftool/map.c                      | 16 +++++------
> >>  tools/bpf/bpftool/prog.c                     | 29 ++++++++++++++------
> >>  tools/perf/util/bpf-event.c                  | 11 ++++----
> >>  tools/perf/util/bpf_counter.c                | 12 ++++++--
> >>  tools/testing/selftests/bpf/prog_tests/btf.c |  4 ++-
> >>  7 files changed, 51 insertions(+), 35 deletions(-)
> >>
> >
> > [...]
> >
> >> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> >> index 09ae0381205b..12787758ce03 100644
> >> --- a/tools/bpf/bpftool/map.c
> >> +++ b/tools/bpf/bpftool/map.c
> >> @@ -805,12 +805,11 @@ static struct btf *get_map_kv_btf(const struct bpf_map_info *info)
> >>                 }
> >>                 return btf_vmlinux;
> >>         } else if (info->btf_value_type_id) {
> >> -               int err;
> >> -
> >> -               err = btf__get_from_id(info->btf_id, &btf);
> >> -               if (err || !btf) {
> >> +               btf = btf__load_from_kernel_by_id(info->btf_id);
> >> +               if (libbpf_get_error(btf)) {
> >>                         p_err("failed to get btf");
> >> -                       btf = err ? ERR_PTR(err) : ERR_PTR(-ESRCH);
> >> +                       if (!btf)
> >> +                               btf = ERR_PTR(-ESRCH);
> >
> > why not do a simpler (less conditionals)
> >
> > err = libbpf_get_error(btf);
> > if (err) {
> >     btf = ERR_PTR(err);
> > }
> >
> > ?
>
> Because if btf is NULL at this stage, this would change the return value
> from -ESRCH to NULL. This would be problematic in mapdump(), since we
> check this value ("if (IS_ERR(btf))") to detect a failure in
> get_map_kv_btf().

see my reply on previous patch. libbpf_get_error() handles this
transparently regardless of CLEAN_PTRS mode, as long as it is called
right after API call. So the above sample will work as you'd expect,
preserving errors.

>
> I could change that check in mapdump() to use libbpf_get_error()
> instead, but in that case it would similarly change the return value for
> mapdump() (and errno), which I think would be propagated up to main()
> and would return 0 instead of -ESRCH. This does not seem suitable and
> would play badly with batch mode, among other things.
>
> So I'm considering keeping the one additional if.
>
> >
> >>                 }
> >>         }
> >>
> >> @@ -1039,11 +1038,10 @@ static void print_key_value(struct bpf_map_info *info, void *key,
> >>                             void *value)
> >>  {
> >>         json_writer_t *btf_wtr;
> >> -       struct btf *btf = NULL;
> >> -       int err;
> >> +       struct btf *btf;
> >>
> >> -       err = btf__get_from_id(info->btf_id, &btf);
> >> -       if (err) {
> >> +       btf = btf__load_from_kernel_by_id(info->btf_id);
> >> +       if (libbpf_get_error(btf)) {
> >>                 p_err("failed to get btf");
> >>                 return;
> >>         }
> >
> > [...]
> >
> >>
> >>         func_info = u64_to_ptr(info->func_info);
> >> @@ -781,6 +784,8 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
> >>                 kernel_syms_destroy(&dd);
> >>         }
> >>
> >> +       btf__free(btf);
> >> +
> >
> > warrants a Fixes: tag?
>
> I don't mind adding the tags, but do they have any advantage here? My
> understanding is that they tend to be neon signs for backports to stable
> branches, but this patch depends on btf__load_from_kernel_by_id(),
> meaning more patches to pull. I'll see if I can move the btf__free()
> fixes to a separate commit, maybe.

Having Fixes: allows to keep track of where the issue originated. It
doesn't necessarily mean something has to be backported, as far as I
understand. So it's good to do regardless. Splitting fixes into a
separate patch works for me as well, but I don't care all that much
given they are small.
