Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2631E46C7F0
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 00:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236960AbhLGXGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 18:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhLGXGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 18:06:04 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F582C061574;
        Tue,  7 Dec 2021 15:02:34 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id y68so1652353ybe.1;
        Tue, 07 Dec 2021 15:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E0MROj/9M0lfA9s5iqecs5qJKTZZYi5IBbURyWPvtBM=;
        b=LGiR/HaB6a1dkNBiopBrQ4JQoq0w1FCORUly0Pf2aKTzymuHeosbkilTpVx97r01uZ
         7vt35dzMqANkiDomRDYNSS9sVb0+6WgjTyX+59T1RJiZecq79pjYhnFfmIbLn3BjeI5k
         ZV7glV/Q79jeD3vbEJXSWkgIod8X+g2FIW063kZh6ytE1E0wz4O82hLqabnECQOdLydY
         QjqBkqiajiP9/5N6I7YuxtCAB0JAP0z7YZ7qiAIbYdeuzZEl+PWtrkieNMrFwhbyXrqO
         QNUr+BsNSspk/3NFW3P9nO9cVEy4x0AQAI/+UL+Ynd3z5l08ime4AkTe1a5JWYEFuOHp
         +9HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E0MROj/9M0lfA9s5iqecs5qJKTZZYi5IBbURyWPvtBM=;
        b=vv8YvROkfjiUiy8QsI//lBFZqCpSc+MTs5M0UVc61PNY5VhKqxRBc7FjiNxLIUprkT
         ru4CV9lgsvue/Xf93JOhBZG1f65K2P3yv8v0klAT7UtvwinOzEmQHmmmZPv4i6eXFo8R
         5cgUi7GkieFqzIe+jX/a0jxDnUrH3QTx1D/twnUKmSMPnfw89isz0tD5WkkeeCD59X7B
         DLNpTOjoMuxZgJo4UPllYD35UBxeeYVNLqM1JSy6AZva0sQF9PV4bfUM+OLymYatI6f5
         q/FAurarv4AycLWtkm8w/PUDTolNWRuLLY1mloFGJ5wQCHVkhDr0dnzBVqPXztEBeg+a
         HiYA==
X-Gm-Message-State: AOAM530q9E/XLAQP0glSif3Xt/1RXZryKYT4GRQqZM0SlMB5vESh6Ejq
        9E5iSOfRVPRzviOEkyCD7kl8Uco3UPfnEWiJSvc=
X-Google-Smtp-Source: ABdhPJxFnyDhYRww4PqXmIvKNIJ9jGbDyovlVBchrpMM3GHvMiKtrfysuuE7sXvwdLVIlh86u5etyR5MsoCyxL0dGjk=
X-Received: by 2002:a25:cf46:: with SMTP id f67mr52509020ybg.362.1638918153258;
 Tue, 07 Dec 2021 15:02:33 -0800 (PST)
MIME-Version: 1.0
References: <20211206230811.4131230-1-song@kernel.org> <CAEf4BzbaBcySm3bVumBTrkHMmVDWEVxckdVKvUk=4j9HhSsmBA@mail.gmail.com>
 <3221CDA7-F2EF-404A-9289-14F9DF6D01DA@fb.com> <CAEf4BzbN17eviD18-_C2UN+P5gMm4vFXVrdLd9UHx0ev+gJsjw@mail.gmail.com>
 <08EB4596-7788-4570-B0B0-DE3B710BBDD8@fb.com>
In-Reply-To: <08EB4596-7788-4570-B0B0-DE3B710BBDD8@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 7 Dec 2021 15:02:22 -0800
Message-ID: <CAEf4BzaCioWRGktgk1TvdyaB-zF_6Hyj+67j7DzPzTLGqkigYg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] perf/bpf_counter: use bpf_map_create instead of bpf_create_map
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 6, 2021 at 10:30 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Dec 6, 2021, at 9:13 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
> >
> > On Mon, Dec 6, 2021 at 8:32 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Dec 6, 2021, at 6:37 PM, Andrii Nakryiko <andrii.nakryiko@gmail.co=
m> wrote:
> >>>
> >>> On Mon, Dec 6, 2021 at 3:08 PM Song Liu <song@kernel.org> wrote:
> >>>>
> >>>> bpf_create_map is deprecated. Replace it with bpf_map_create.
> >>>>
> >>>> Fixes: 992c4225419a ("libbpf: Unify low-level map creation APIs w/ n=
ew bpf_map_create()")
> >>>
> >>> This is not a bug fix, it's an improvement. So I don't think "Fixes: =
"
> >>> is warranted here, tbh.
> >>
> >> I got compilation errors before this change, like
> >>
> >> util/bpf_counter.c: In function =E2=80=98bperf_lock_attr_map=E2=80=99:
> >> util/bpf_counter.c:323:3: error: =E2=80=98bpf_create_map=E2=80=99 is d=
eprecated: libbpf v0.7+: use bpf_map_create() instead [-Werror=3Ddeprecated=
-declarations]
> >>   map_fd =3D bpf_create_map(BPF_MAP_TYPE_HASH,
> >>   ^~~~~~
> >> In file included from util/bpf_counter.h:7,
> >>                 from util/bpf_counter.c:15:
> >> /data/users/songliubraving/kernel/linux-git/tools/lib/bpf/bpf.h:91:16:=
 note: declared here
> >> LIBBPF_API int bpf_create_map(enum bpf_map_type map_type, int key_size=
,
> >>                ^~~~~~~~~~~~~~
> >> cc1: all warnings being treated as errors
> >> make[4]: *** [/data/users/songliubraving/kernel/linux-git/tools/build/=
Makefile.build:96: util/bpf_counter.o] Error 1
> >> make[4]: *** Waiting for unfinished jobs....
> >> make[3]: *** [/data/users/songliubraving/kernel/linux-git/tools/build/=
Makefile.build:139: util] Error 2
> >> make[2]: *** [Makefile.perf:665: perf-in.o] Error 2
> >> make[1]: *** [Makefile.perf:240: sub-make] Error 2
> >> make: *** [Makefile:70: all] Error 2
> >>
> >
> > Hmm.. is util/bpf_counter.h guarded behind some Makefile arguments?
> > I've sent #pragma temporary workarounds just a few days ago ([0]), but
> > this one didn't come up during the build.
> >
> >  [0] https://patchwork.kernel.org/project/netdevbpf/patch/2021120300464=
0.2455717-1-andrii@kernel.org/
>
> I guess the default build test doesn't enable BUILD_BPF_SKEL?

I see, right, I think I already asked about that before :( Is it
possible to set Makefile such that it will do BUILD_BPF_SKEL=3D1 if
Clang version is recent enough and other conditions are satisfied
(unless overridden or something)?

>
> >
> >> Do we plan to remove bpf_create_map in the future? If not, we can prob=
ably just
> >> add '#pragma GCC diagnostic ignored "-Wdeprecated-declarations"' can c=
all it done?
> >
> > Yes, it will be removed in a few libbpf releases when we switch to the
> > 1.0 version. So suppressing a warning is a temporary work-around.
> >
> >>
> >>>
> >>>> Signed-off-by: Song Liu <song@kernel.org>
> >>>> ---
> >>>> tools/perf/util/bpf_counter.c | 4 ++--
> >>>> 1 file changed, 2 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_cou=
nter.c
> >>>> index c17d4a43ce065..ed150a9b3a0c0 100644
> >>>> --- a/tools/perf/util/bpf_counter.c
> >>>> +++ b/tools/perf/util/bpf_counter.c
> >>>> @@ -320,10 +320,10 @@ static int bperf_lock_attr_map(struct target *=
target)
> >>>>       }
> >>>>
> >>>>       if (access(path, F_OK)) {
> >>>> -               map_fd =3D bpf_create_map(BPF_MAP_TYPE_HASH,
> >>>> +               map_fd =3D bpf_map_create(BPF_MAP_TYPE_HASH, NULL,
> >>>
> >>> I think perf is trying to be linkable with libbpf as a shared library=
,
> >>> so on some older versions of libbpf bpf_map_create() won't be (yet)
> >>> available. So to make this work, I think you'll need to define your
> >>> own weak bpf_map_create function that will use bpf_create_map().
> >>
> >> Hmm... I didn't know the plan to link libbpf as shared library. In thi=
s case,
> >> maybe the #pragma solution is preferred?
> >
> > See "perf tools: Add more weak libbpf functions" sent by Jiri not so
> > long ago about what they did with some other used APIs that are now
> > marked deprecated.
>
> Do you mean something like this?
>
> int __weak
> bpf_map_create(enum bpf_map_type map_type,
>                const char *map_name __maybe_unused,
>                __u32 key_size,
>                __u32 value_size,
>                __u32 max_entries,
>                const struct bpf_map_create_opts *opts __maybe_unused)
> {
> #pragma GCC diagnostic push
> #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
>         return bpf_create_map(map_type, key_size, value_size, max_entries=
, 0);
> #pragma GCC diagnostic pop
> }
>
> I guess this won't work when bpf_create_map() is eventually removed, as
> __weak function are still compiled, no?

Yes and yes. I'm not sure what would be perf's plan w.r.t. libbpf 1.0,
we'll need to work together to figure this out. At some point perf
will need to say that the minimum version of supported libbpf is v0.6
or something and just assume all those newer APIs are there (no need
to bump it all the way to libbpf 1.0, btw).

>
> Thanks,
> Song
