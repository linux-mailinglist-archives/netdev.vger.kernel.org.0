Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9402323AB
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 19:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgG2RsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 13:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgG2RsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 13:48:13 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2A0C061794;
        Wed, 29 Jul 2020 10:48:13 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id ed14so11267025qvb.2;
        Wed, 29 Jul 2020 10:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KLov+zHRwCIC5dmTzJG4jUY2DEz0vF5YAWPCuEXipCY=;
        b=Vw4wTblo7xPLb8AX+1v0epllbl48lPuFT40OiUuie6YFtL/leiZoCcDQHoh4CU0yAz
         y38+K1sdewtCyhgla+hqRJVVQtLdDiNexi69yCXIyevEaxkSyopHQITX1rb7KC+0LsbH
         3htCk3sq4+JqwSl/xuJYSutVMy1jxgLRj27R748PFC/8Nhdako2CXXWadOQIEPUtYRoS
         tq+DSGjTiiF3fnlKcbh9cnE9f/g05B3DfRcGWX4Ry2Y3JVZkXd3FbJkdz0NgXUrxWsFe
         QdFlKPGCj/yZWK4jMsYyF4L++oaZneceEtXyp8g+3THWqOdlsDx9P5SX8wsv9di+4mc6
         DHQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KLov+zHRwCIC5dmTzJG4jUY2DEz0vF5YAWPCuEXipCY=;
        b=furOzCggikVMiHf/i9OV02zQTKEd4WpCNPjgXdQxbwfqpOJC4DuwN3aT+dnNcNlCUE
         UmgU/4Zk8clJ5mB7RsarBNFMZ9NK2yDkLQyoX4XUjI/omgH1z2bZd8h/bx/c35DEVzuK
         dK+l0khr3exsqe2bhfeXN4lwS65Ue25q8uqYJAaA4iE62bHTFuHtYkabkYlJu+QMdbQF
         2IHSeh6F8p6O5/oqcxDkB7BYjKIHYZ0c2usPdTpWf/LglZw31vLE13VxkoRO/7UsitaC
         s0tsTypARuXhZnzKRZU/Y0HUbnBx7NvicuP5p5V7JaN5stp94mumfIU0uCHA1soH2kgC
         vkBA==
X-Gm-Message-State: AOAM530SV9CpVuwdTuHclX1Et8Rw4MpbHhzLcJPlqdyl0kBoiR2BhnEf
        pasURzg/fTVICBGsh4kpSv+egENlSjrGmKND5gU=
X-Google-Smtp-Source: ABdhPJzdYOC78Mao1Zvw7purKveWY01VJjJxxKFefer0drau5rKfTQFnz1rDzot0Em+BMTnuo85l3SOeaNdYkBP54W4=
X-Received: by 2002:a0c:bf4f:: with SMTP id b15mr31968009qvj.224.1596044892184;
 Wed, 29 Jul 2020 10:48:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200729040913.2815687-1-andriin@fb.com> <20200729040913.2815687-2-andriin@fb.com>
 <87k0ymwg2b.fsf@cloudflare.com>
In-Reply-To: <87k0ymwg2b.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Jul 2020 10:48:01 -0700
Message-ID: <CAEf4BzYagTebczsojJJfn0viy07dhRUq3oysezEO_LSYSuwfRQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf 2/2] selftests/bpf: extend map-in-map selftest to
 detect memory leaks
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 7:29 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Wed, Jul 29, 2020 at 06:09 AM CEST, Andrii Nakryiko wrote:
> > Add test validating that all inner maps are released properly after skeleton
> > is destroyed. To ensure determinism, trigger kernel-side synchronize_rcu()
> > before checking map existence by their IDs.
> >
> > Acked-by: Song Liu <songliubraving@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  .../selftests/bpf/prog_tests/btf_map_in_map.c | 124 ++++++++++++++++--
> >  1 file changed, 110 insertions(+), 14 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> > index f7ee8fa377ad..f6eee3fb933c 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> > @@ -5,10 +5,60 @@
> >
> >  #include "test_btf_map_in_map.skel.h"
> >
> > +static int duration;
> > +
> > +static __u32 bpf_map_id(struct bpf_map *map)
> > +{
> > +     struct bpf_map_info info;
> > +     __u32 info_len = sizeof(info);
> > +     int err;
> > +
> > +     memset(&info, 0, info_len);
> > +     err = bpf_obj_get_info_by_fd(bpf_map__fd(map), &info, &info_len);
> > +     if (err)
> > +             return 0;
> > +     return info.id;
> > +}
> > +
> > +/*
> > + * Trigger synchronize_cpu() in kernel.
>
> Nit: synchronize_*r*cu().

welp, yeah

>
> > + *
> > + * ARRAY_OF_MAPS/HASH_OF_MAPS lookup/update operations trigger
> > + * synchronize_rcu(), if looking up/updating non-NULL element. Use this fact
> > + * to trigger synchronize_cpu(): create map-in-map, create a trivial ARRAY
> > + * map, update map-in-map with ARRAY inner map. Then cleanup. At the end, at
> > + * least one synchronize_rcu() would be called.
> > + */
>
> That's a cool trick. I'm a bit confused by "looking up/updating non-NULL
> element". It looks like you're updating an element that is NULL/unset in
> the code below. What am I missing?

I was basically trying to say that it has to be a successful lookup or
update. For lookup that means looking up non-NULL (existing) entry.
For update -- setting valid inner map FD.

Not sure fixing this and typo above is worth it to post v5.

>
> > +static int kern_sync_rcu(void)
> > +{
> > +     int inner_map_fd, outer_map_fd, err, zero = 0;
> > +
> > +     inner_map_fd = bpf_create_map(BPF_MAP_TYPE_ARRAY, 4, 4, 1, 0);
> > +     if (CHECK(inner_map_fd < 0, "inner_map_create", "failed %d\n", -errno))
> > +             return -1;
> > +
> > +     outer_map_fd = bpf_create_map_in_map(BPF_MAP_TYPE_ARRAY_OF_MAPS, NULL,
> > +                                          sizeof(int), inner_map_fd, 1, 0);
> > +     if (CHECK(outer_map_fd < 0, "outer_map_create", "failed %d\n", -errno)) {
> > +             close(inner_map_fd);
> > +             return -1;
> > +     }
> > +
> > +     err = bpf_map_update_elem(outer_map_fd, &zero, &inner_map_fd, 0);
> > +     if (err)
> > +             err = -errno;
> > +     CHECK(err, "outer_map_update", "failed %d\n", err);
> > +     close(inner_map_fd);
> > +     close(outer_map_fd);
> > +     return err;
> > +}
> > +

[...]

trimming's good ;)
