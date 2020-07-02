Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0225E212228
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 13:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgGBLYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 07:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbgGBLYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 07:24:34 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FABC08C5C1;
        Thu,  2 Jul 2020 04:24:34 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id h39so13604647ybj.3;
        Thu, 02 Jul 2020 04:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xfLhyiqMmx1NCC5JE+0HxGjF069HkR8d5YN5c8Btfo4=;
        b=C35MPbNLIuMq732j0GgyfPbKMsobyWCOwn8hHThTspTJTptBqeAUt6mGaqyIMGR9V2
         HsSJ261NJD3SHV3RfpzFpUXwPOweaMfL7nq7+hZXfdkcQu5i1D6aetwb6yZHPKG3tdo3
         tGNZGLjbynfhGbRffIQr+Iqd9yDSt3PHobxRTBIAA+mvt3xPxKv7zi966/lA2kKeWicP
         jCB2h3PtY5St3xT4z0H/4zNtcNlP65uXYVpjaDWszEkcdn+SxA0d5yeWriRqjat2wSW8
         b2Niphpig/aYz1+StJenifN6TdoahhJtQtVEr9FPVzfQtIjHWSOt+6F3Sj6DvUNqz7WX
         a5ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xfLhyiqMmx1NCC5JE+0HxGjF069HkR8d5YN5c8Btfo4=;
        b=PwkN0hPZGHAOy87xsEw2962ST0JYe4deqXm9S83hXP1emG55WNeZUTG2cuyFuBF3pW
         ruVVfd1pK9O3yjWOimG+hCaSlvEMM/HdUtlLvCmt3VmomSUoN+0t6K/vTMf0COGGS33u
         kantBzVApyHsAZPWmSoUdlex+QWWW5DPbonAKbsy9oYCogcGoEByVYrT77hMk5sBElQF
         A3tDnLrx4/V+IrAQmQGKTCfOzkLi7hoxapntyKEfBexC+sAVi6S/HpT/TfnOJthk+TLs
         MvNApYDSi/UBH4ktGU09ztv94Y7KqihgKOI9d3xgY2G2A8ET52VhlqalH3xUOyNmtpJ/
         taqA==
X-Gm-Message-State: AOAM531xvMtKhZdU5hJ1ho/14L2ouFR6JBjonJo2xT3PR5GACsvnJL6n
        RfO2bzIPIhGH7YzOJcVBaxl1xzkQnseW+oqc5g==
X-Google-Smtp-Source: ABdhPJy7uwt23VfDJUKKp8sgkdJXhClQkyVpVNzPbbnm1avKdbGjBHHb/mZU/zqx6ie1Cxq5fXFnmu9TQ3SczWuqZo0=
X-Received: by 2002:a05:6902:692:: with SMTP id i18mr50181764ybt.164.1593689073502;
 Thu, 02 Jul 2020 04:24:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200702021646.90347-1-danieltimlee@gmail.com>
 <20200702021646.90347-4-danieltimlee@gmail.com> <CAEf4BzZsx+pkkdjhJt1AHaUy6=B=nqZdpR+TrRrjreNa0GMWug@mail.gmail.com>
In-Reply-To: <CAEf4BzZsx+pkkdjhJt1AHaUy6=B=nqZdpR+TrRrjreNa0GMWug@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Thu, 2 Jul 2020 20:24:17 +0900
Message-ID: <CAEKGpzikhnamOsh=qnmYPJ+6Lr2c4arOdqhuACdHTXmwEF1naQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/4] samples: bpf: refactor BPF map performance
 test with libbpf
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Thu, Jul 2, 2020 at 1:34 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Jul 1, 2020 at 7:17 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > Previously, in order to set the numa_node attribute at the time of map
> > creation using "libbpf", it was necessary to call bpf_create_map_node()
> > directly (bpf_load approach), instead of calling bpf_object_load()
> > that handles everything on its own, including map creation. And because
> > of this problem, this sample had problems with refactoring from bpf_load
> > to libbbpf.
> >
> > However, by commit 1bdb6c9a1c43 ("libbpf: Add a bunch of attribute
> > getters/setters for map definitions"), a helper function which allows
> > the numa_node attribute to be set in the map prior to calling
> > bpf_object_load() has been added.
> >
> > By using libbpf instead of bpf_load, the inner map definition has
> > been explicitly declared with BTF-defined format. And for this reason
> > some logic in fixup_map() was not needed and changed or removed.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  samples/bpf/Makefile             |   2 +-
> >  samples/bpf/map_perf_test_kern.c | 180 +++++++++++++++----------------
> >  samples/bpf/map_perf_test_user.c | 130 +++++++++++++++-------
> >  3 files changed, 181 insertions(+), 131 deletions(-)
> >
>
> [...]
>
> > +struct inner_lru {
> > +       __uint(type, BPF_MAP_TYPE_LRU_HASH);
> > +       __type(key, u32);
> > +       __type(value, long);
> > +       __uint(max_entries, MAX_ENTRIES);
> > +       __uint(map_flags, BPF_F_NUMA_NODE); /* from _user.c, set numa_node to 0 */
> > +} inner_lru_hash_map SEC(".maps");
>
> you can declaratively set numa_node here with __uint(numa_node, 0),
> which is actually a default, but for explicitness it's better
>

It would make _user.c code cleaner, but as you said,
I'll keep with this implementation.

> > +
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
> > +       __uint(max_entries, MAX_NR_CPUS);
> > +       __uint(key_size, sizeof(u32));
> > +       __array(values, struct inner_lru); /* use inner_lru as inner map */
> > +} array_of_lru_hashs SEC(".maps");
> > +
>
> [...]
>
> > -static void fixup_map(struct bpf_map_data *map, int idx)
> > +static void fixup_map(struct bpf_object *obj)
> >  {
> > +       struct bpf_map *map;
> >         int i;
> >
> > -       if (!strcmp("inner_lru_hash_map", map->name)) {
> > -               inner_lru_hash_idx = idx;
> > -               inner_lru_hash_size = map->def.max_entries;
> > -       }
> > +       bpf_object__for_each_map(map, obj) {
> > +               const char *name = bpf_map__name(map);
> >
> > -       if (!strcmp("array_of_lru_hashs", map->name)) {
>
> I'm a bit too lazy right now to figure out exact logic here, but just
> wanted to mention that it is possible to statically set inner map
> elements for array_of_maps and hash_of_maps. Please check
> tools/testing/selftests/bpf/progs/test_btf_map_in_map.c and see if you
> can use this feature to simplify this logic a bit.
>

Thanks for the feedback! But I'm not sure I'm following properly.

If what you are talking about is specifying the inner_map_idx of
array_of_lru_hashes, I've changed it by using the __array() directives
of the BTF-defined MAP.

Since inner_map_idx logic has been replaced with BTF-defined map
definition, the only thing left at here fixup_map() is just resizing map size
with bpf_map__resize.

Thanks for your time and effort for the review.
Daniel

> > -               if (inner_lru_hash_idx == -1) {
> > -                       printf("inner_lru_hash_map must be defined before array_of_lru_hashs\n");
> > -                       exit(1);
> > +               /* Only change the max_entries for the enabled test(s) */
> > +               for (i = 0; i < NR_TESTS; i++) {
> > +                       if (!strcmp(test_map_names[i], name) &&
> > +                           (check_test_flags(i))) {
> > +                               bpf_map__resize(map, num_map_entries);
> > +                               continue;
> > +                       }
> >                 }
> > -               map->def.inner_map_idx = inner_lru_hash_idx;
> > -               array_of_lru_hashs_idx = idx;
> >         }
> >
>
> [...]
