Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E63446B21F
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 06:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhLGFRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 00:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbhLGFRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 00:17:02 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114DFC061746;
        Mon,  6 Dec 2021 21:13:33 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id y68so37739779ybe.1;
        Mon, 06 Dec 2021 21:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Kql1bBy1EgzVpsU/JwDkrMwOYaTG3KOCNskyPvT29v0=;
        b=aLFhZdnZO5XIQF+AKgvGJSAmziQaa34WBCy3z5C/gPlNAgn4VyUP07KrdzczsfP0Nb
         Y4c2ZU7udNStoUAcRg8sWUfWicbnOZkXD1aA6pZvK7d+aTq9uHLDoIKS+Uh4OzrK/zRX
         BnIzYnZNVYsJMLU7z+8sKH87qfm9R7ubFPk+oGjL/Liirl5y9j/mVxRM5e0vhWPnFUly
         3Rko9KL4E0FUTyP1VA9LGHVUcigBdBLiLkW5x1TaHGa8Vuail7+K6Core0odCdAp/rOv
         8KOFSHw5P/xY7xNYbxeqDSmSBdM6lnZFrBG+kptH3OTIKWO/Y0ekg2Fzr/eT5Y9QV0G+
         qqyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Kql1bBy1EgzVpsU/JwDkrMwOYaTG3KOCNskyPvT29v0=;
        b=yl0Zdgi/vFqjXnrNyyL1iixJhLXxSLR0W0GblZPH9GO3nxGJiCV/HZaq2HsiOHTZVT
         bpD9BGFuVJtfs5k5A2yN19pZket2GH51s/jWOKEGsBHzIB3DK6gPiiJfid8aV2Kd//+S
         apr6FUXgbH4ZJiuT5GSUS9rT2dp1zb2HyEzCZT3y2DWznX1QDhyIcn8jZmBauSi7unMH
         ezgIq9eZQ9GGztyYDQKxHGYJR7n1/jVr0DcBb7PfX9PD4dWqZBlLN6LDQM/qAMkKTgFW
         EsZCnJxiKlVbWb1xRoMCIDyEQ8KrUHQzyvOX84oCA+VPzRpymfKkrLuXCC27KTzYTHL+
         /9mQ==
X-Gm-Message-State: AOAM5308+DWAR4WtUKRtcnBCgLiE+sjCIYNVA8h/+6NO1ipCc/hfzImw
        DsadtC+dIRDRFCdHeyDsCI3ScKs7MlcVQZBF68whKrTKgwZdbQ==
X-Google-Smtp-Source: ABdhPJxrmSbihGZEgETtrdNrlJPNMgiScKrO2WuWpaF7Tq412qlyNjHI4iy6tXltxxIDfGFmp6QGXK2A5udNOYx6DYM=
X-Received: by 2002:a25:abaa:: with SMTP id v39mr47903087ybi.367.1638854011809;
 Mon, 06 Dec 2021 21:13:31 -0800 (PST)
MIME-Version: 1.0
References: <20211206230811.4131230-1-song@kernel.org> <CAEf4BzbaBcySm3bVumBTrkHMmVDWEVxckdVKvUk=4j9HhSsmBA@mail.gmail.com>
 <3221CDA7-F2EF-404A-9289-14F9DF6D01DA@fb.com>
In-Reply-To: <3221CDA7-F2EF-404A-9289-14F9DF6D01DA@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Dec 2021 21:13:20 -0800
Message-ID: <CAEf4BzbN17eviD18-_C2UN+P5gMm4vFXVrdLd9UHx0ev+gJsjw@mail.gmail.com>
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

On Mon, Dec 6, 2021 at 8:32 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Dec 6, 2021, at 6:37 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
> >
> > On Mon, Dec 6, 2021 at 3:08 PM Song Liu <song@kernel.org> wrote:
> >>
> >> bpf_create_map is deprecated. Replace it with bpf_map_create.
> >>
> >> Fixes: 992c4225419a ("libbpf: Unify low-level map creation APIs w/ new=
 bpf_map_create()")
> >
> > This is not a bug fix, it's an improvement. So I don't think "Fixes: "
> > is warranted here, tbh.
>
> I got compilation errors before this change, like
>
> util/bpf_counter.c: In function =E2=80=98bperf_lock_attr_map=E2=80=99:
> util/bpf_counter.c:323:3: error: =E2=80=98bpf_create_map=E2=80=99 is depr=
ecated: libbpf v0.7+: use bpf_map_create() instead [-Werror=3Ddeprecated-de=
clarations]
>    map_fd =3D bpf_create_map(BPF_MAP_TYPE_HASH,
>    ^~~~~~
> In file included from util/bpf_counter.h:7,
>                  from util/bpf_counter.c:15:
> /data/users/songliubraving/kernel/linux-git/tools/lib/bpf/bpf.h:91:16: no=
te: declared here
>  LIBBPF_API int bpf_create_map(enum bpf_map_type map_type, int key_size,
>                 ^~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
> make[4]: *** [/data/users/songliubraving/kernel/linux-git/tools/build/Mak=
efile.build:96: util/bpf_counter.o] Error 1
> make[4]: *** Waiting for unfinished jobs....
> make[3]: *** [/data/users/songliubraving/kernel/linux-git/tools/build/Mak=
efile.build:139: util] Error 2
> make[2]: *** [Makefile.perf:665: perf-in.o] Error 2
> make[1]: *** [Makefile.perf:240: sub-make] Error 2
> make: *** [Makefile:70: all] Error 2
>

Hmm.. is util/bpf_counter.h guarded behind some Makefile arguments?
I've sent #pragma temporary workarounds just a few days ago ([0]), but
this one didn't come up during the build.

  [0] https://patchwork.kernel.org/project/netdevbpf/patch/20211203004640.2=
455717-1-andrii@kernel.org/

> Do we plan to remove bpf_create_map in the future? If not, we can probabl=
y just
> add '#pragma GCC diagnostic ignored "-Wdeprecated-declarations"' can call=
 it done?

Yes, it will be removed in a few libbpf releases when we switch to the
1.0 version. So suppressing a warning is a temporary work-around.

>
> >
> >> Signed-off-by: Song Liu <song@kernel.org>
> >> ---
> >> tools/perf/util/bpf_counter.c | 4 ++--
> >> 1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_count=
er.c
> >> index c17d4a43ce065..ed150a9b3a0c0 100644
> >> --- a/tools/perf/util/bpf_counter.c
> >> +++ b/tools/perf/util/bpf_counter.c
> >> @@ -320,10 +320,10 @@ static int bperf_lock_attr_map(struct target *ta=
rget)
> >>        }
> >>
> >>        if (access(path, F_OK)) {
> >> -               map_fd =3D bpf_create_map(BPF_MAP_TYPE_HASH,
> >> +               map_fd =3D bpf_map_create(BPF_MAP_TYPE_HASH, NULL,
> >
> > I think perf is trying to be linkable with libbpf as a shared library,
> > so on some older versions of libbpf bpf_map_create() won't be (yet)
> > available. So to make this work, I think you'll need to define your
> > own weak bpf_map_create function that will use bpf_create_map().
>
> Hmm... I didn't know the plan to link libbpf as shared library. In this c=
ase,
> maybe the #pragma solution is preferred?

See "perf tools: Add more weak libbpf functions" sent by Jiri not so
long ago about what they did with some other used APIs that are now
marked deprecated.

>
> Thanks,
> Song
>
