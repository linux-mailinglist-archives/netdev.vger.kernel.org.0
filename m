Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E45A216242
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 01:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgGFX12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 19:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgGFX11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 19:27:27 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA06C061755;
        Mon,  6 Jul 2020 16:27:27 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id e13so36548400qkg.5;
        Mon, 06 Jul 2020 16:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nk596EgdTx9bruearQGvPUmGFW9uDd9pIjVlQVe/Js0=;
        b=dvrjiAUwG+gXKGyCpiUhFHadrl/yilQk2vh22k6+SiiAkO7xbT0yaU/Nh6t0aMX9uN
         p6tpVpJ+iSoefLzR5m32Vzrd9dnYUBOshZbQ1V0yeuT1w7RAzK92TEdit8XAfuuGLSju
         O0o6VJrDzXh6SVWjM3vfUpU21277cya4EgxQ3xsJeOTLZCz9LPdNCDVAP2CVuhDBS/Ov
         zDOStIt3yVREP9KXTDTpdXJ1KKRI2yGF4VbXMQS8m86i8wlmgyXgB7vhf9B99xxcqswy
         81mE7BHaI5jYzFKjMvxOiwDxHB38/IrCDyoEA+4gZatSUCMq7Bgqkfchq+u/SpKFyJd0
         0mAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nk596EgdTx9bruearQGvPUmGFW9uDd9pIjVlQVe/Js0=;
        b=Vhezmf75RYPgJrLxPQBEfTM8ZwJCZT2ip+brGf/POoIL6isKY9D6NgSPKMlgPf7GK3
         UZo0/etxVoySLaY+bWtcanucD/hjmY165RolJ+XgG/WPL3uYTTkiVE3UxWp3iSbNOPIw
         rVywgbJ/SL1YwdkJuXyYOkT0cndpuLlUcNKZn5UXMWP+iVov0zUG9Z/8Zk70PTZFTK4Y
         YCmxKMsjL2PWATwByhAKRK0gs/IQY1NRyXW7+3KqmKgixPE/6aWPm+F+ociUN3q4nBoA
         5ggy+Hh8xzIomSAhJLB7lJtkPDxgMvI9m22Vbh0ztWQzzatWHkEMgYFWOVkslwJmAGAA
         Qb+A==
X-Gm-Message-State: AOAM530m4F+BH+5mTtH8wzcBYpxund6qdUUtwcXiXIm0GvJBwaAkneCd
        O8VrbJClQG0g8Uci3S+WeZ6zvokB1ExNwIbJ1uU=
X-Google-Smtp-Source: ABdhPJxJEep0+I4j2/z3whYbec9TQKWHRMmS9g76q9mHwHSdRx4mkMNNYiFi/36xQ71irGQ+nDGe9KLott3rH1Su8Pc=
X-Received: by 2002:a37:270e:: with SMTP id n14mr47509015qkn.92.1594078046950;
 Mon, 06 Jul 2020 16:27:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200702021646.90347-1-danieltimlee@gmail.com>
 <20200702021646.90347-4-danieltimlee@gmail.com> <CAEf4BzZsx+pkkdjhJt1AHaUy6=B=nqZdpR+TrRrjreNa0GMWug@mail.gmail.com>
 <CAEKGpzikhnamOsh=qnmYPJ+6Lr2c4arOdqhuACdHTXmwEF1naQ@mail.gmail.com>
In-Reply-To: <CAEKGpzikhnamOsh=qnmYPJ+6Lr2c4arOdqhuACdHTXmwEF1naQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Jul 2020 16:27:15 -0700
Message-ID: <CAEf4BzZS945fhRCCv8gNjJpTAbtCdH3XMChRw7so7F2PPJgJDw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/4] samples: bpf: refactor BPF map performance
 test with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 4:24 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> On Thu, Jul 2, 2020 at 1:34 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Jul 1, 2020 at 7:17 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > >
> > > Previously, in order to set the numa_node attribute at the time of map
> > > creation using "libbpf", it was necessary to call bpf_create_map_node()
> > > directly (bpf_load approach), instead of calling bpf_object_load()
> > > that handles everything on its own, including map creation. And because
> > > of this problem, this sample had problems with refactoring from bpf_load
> > > to libbbpf.
> > >
> > > However, by commit 1bdb6c9a1c43 ("libbpf: Add a bunch of attribute
> > > getters/setters for map definitions"), a helper function which allows
> > > the numa_node attribute to be set in the map prior to calling
> > > bpf_object_load() has been added.
> > >
> > > By using libbpf instead of bpf_load, the inner map definition has
> > > been explicitly declared with BTF-defined format. And for this reason
> > > some logic in fixup_map() was not needed and changed or removed.
> > >
> > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > > ---
> > >  samples/bpf/Makefile             |   2 +-
> > >  samples/bpf/map_perf_test_kern.c | 180 +++++++++++++++----------------
> > >  samples/bpf/map_perf_test_user.c | 130 +++++++++++++++-------
> > >  3 files changed, 181 insertions(+), 131 deletions(-)
> > >
> >
> > [...]
> >
> > > +struct inner_lru {
> > > +       __uint(type, BPF_MAP_TYPE_LRU_HASH);
> > > +       __type(key, u32);
> > > +       __type(value, long);
> > > +       __uint(max_entries, MAX_ENTRIES);
> > > +       __uint(map_flags, BPF_F_NUMA_NODE); /* from _user.c, set numa_node to 0 */
> > > +} inner_lru_hash_map SEC(".maps");
> >
> > you can declaratively set numa_node here with __uint(numa_node, 0),
> > which is actually a default, but for explicitness it's better
> >
>
> It would make _user.c code cleaner, but as you said,
> I'll keep with this implementation.

I meant to do __uint(numa_node, 0) declaratively, even if it's a bit
redundant (because default value is already zero).

user-space bpf_program__numa_node() is inferior for such a simple
static use case.

>
> > > +
> > > +struct {
> > > +       __uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
> > > +       __uint(max_entries, MAX_NR_CPUS);
> > > +       __uint(key_size, sizeof(u32));
> > > +       __array(values, struct inner_lru); /* use inner_lru as inner map */
> > > +} array_of_lru_hashs SEC(".maps");
> > > +
> >
> > [...]
> >
> > > -static void fixup_map(struct bpf_map_data *map, int idx)
> > > +static void fixup_map(struct bpf_object *obj)
> > >  {
> > > +       struct bpf_map *map;
> > >         int i;
> > >
> > > -       if (!strcmp("inner_lru_hash_map", map->name)) {
> > > -               inner_lru_hash_idx = idx;
> > > -               inner_lru_hash_size = map->def.max_entries;
> > > -       }
> > > +       bpf_object__for_each_map(map, obj) {
> > > +               const char *name = bpf_map__name(map);
> > >
> > > -       if (!strcmp("array_of_lru_hashs", map->name)) {
> >
> > I'm a bit too lazy right now to figure out exact logic here, but just
> > wanted to mention that it is possible to statically set inner map
> > elements for array_of_maps and hash_of_maps. Please check
> > tools/testing/selftests/bpf/progs/test_btf_map_in_map.c and see if you
> > can use this feature to simplify this logic a bit.
> >
>
> Thanks for the feedback! But I'm not sure I'm following properly.
>
> If what you are talking about is specifying the inner_map_idx of
> array_of_lru_hashes, I've changed it by using the __array() directives
> of the BTF-defined MAP.
>
> Since inner_map_idx logic has been replaced with BTF-defined map
> definition, the only thing left at here fixup_map() is just resizing map size
> with bpf_map__resize.

Ok, as I said, a bit too lazy to try to figure out the entire logic of
this sample. My point was to check if static initialization of
ARRAY_OF_MAPS/HASH_OF_MAPS elements is doable. If not, it's fine as is
as well.

>
> Thanks for your time and effort for the review.
> Daniel
>
> > > -               if (inner_lru_hash_idx == -1) {
> > > -                       printf("inner_lru_hash_map must be defined before array_of_lru_hashs\n");
> > > -                       exit(1);
> > > +               /* Only change the max_entries for the enabled test(s) */
> > > +               for (i = 0; i < NR_TESTS; i++) {
> > > +                       if (!strcmp(test_map_names[i], name) &&
> > > +                           (check_test_flags(i))) {
> > > +                               bpf_map__resize(map, num_map_entries);
> > > +                               continue;
> > > +                       }
> > >                 }
> > > -               map->def.inner_map_idx = inner_lru_hash_idx;
> > > -               array_of_lru_hashs_idx = idx;
> > >         }
> > >
> >
> > [...]
