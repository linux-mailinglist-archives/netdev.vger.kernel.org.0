Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E088587D5E
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 15:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235977AbiHBNrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 09:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234046AbiHBNrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 09:47:41 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA89018E13;
        Tue,  2 Aug 2022 06:47:39 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id 125so14590669vsx.7;
        Tue, 02 Aug 2022 06:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=r0gY8IDHBQw9zV+tm+wIldwERHTU2a9jVP4S6o+Vte4=;
        b=J/efUqCYkkHHwLdVoM8ZLUajg0xrGGY1WhxJCO7QQ9ZGLZjbteoD1BajhDJn43PcBR
         5tipzx9Pug+5//1e53CnvMWHxBvpd0rKVpc8/niitWMYjDlxBi5kB9YnIAFbcaud1wn8
         eyEKxfC89VvKaAze52JeiN6tegMoWJf0TidKrRbhHCoYQ/W3mHIdq3AUvZiZsmU1c+4f
         Bl5FAtdoiGfF9Dpct+ycw2Kb4YaP/JINPTbuk2XHkFhHEW7305Ca6p1DTTKYM8fTRho8
         v4eNLKLeX0gEd9VSuK5TZIGE3fXk8qLljyH8aRrOdAWCm4feRM9r2J2ofYVOjjjXV+Zw
         GFiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=r0gY8IDHBQw9zV+tm+wIldwERHTU2a9jVP4S6o+Vte4=;
        b=KppOu/dvlW0NtyroKUmjByYs8eVweVgPx0HbQCFyb4IVz2yshbbVpx75C5tWABcpBD
         /UQcPSapnpoiAh+hDSd4+xdpfCNgm09zDVTG131RtpqOHk3vO6XOCbq1PcNPeqDCdPdP
         ZE6bpNgNr5vtB+CG9DkMUkB5AeSqSwe3kNy/8FrYTvQrERWvAUYF/zhr4vy/AAP/wrxV
         toYFtXxXzsB1hYtRrpT7vFALp1S6FK3vQLPLjpbHSHe1H32nJ/drs/GTa7DRKH/t9GGg
         NFvxyWs+wj6+XS4x5+Z4AzqokQ/glTOaSMCl6DtqLUtdUFHO5xQsEB+RAan1J8QKjclb
         Xh7g==
X-Gm-Message-State: ACgBeo0bozsJzcJR7r4Ua9VhBe7GL7Ghq7l9MfCf2xU3/TuP7iupSXs1
        3DvtsAa9VnQKLsGHhdT8gKqWERJF1Iij6o7wN/4=
X-Google-Smtp-Source: AA6agR4FIozwmF8WXJkvqaJsLvMa6V6YF2nj3uO403m3sxZU6AWbs4TsOYQV/stQMyWl40OOSZqPZFA2NMJhpmaF/hE=
X-Received: by 2002:a05:6102:750:b0:381:feef:d966 with SMTP id
 v16-20020a056102075000b00381feefd966mr4212270vsg.35.1659448058860; Tue, 02
 Aug 2022 06:47:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220729152316.58205-1-laoar.shao@gmail.com> <20220729152316.58205-16-laoar.shao@gmail.com>
 <20220802045531.6oi2pt3fyjhotmjo@macbook-pro-3.dhcp.thefacebook.com>
In-Reply-To: <20220802045531.6oi2pt3fyjhotmjo@macbook-pro-3.dhcp.thefacebook.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 2 Aug 2022 21:47:02 +0800
Message-ID: <CALOAHbDZq89ATv5pK4FAX9-DYOWZjFJPtJ8fAYL1zhuS2c1D9w@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 15/15] bpf: Introduce selectable memcg for
 bpf map
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, jolsa@kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 2, 2022 at 12:55 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jul 29, 2022 at 03:23:16PM +0000, Yafang Shao wrote:
> > A new member memcg_fd is introduced into bpf attr of BPF_MAP_CREATE
> > command, which is the fd of an opened cgroup directory. In this cgroup,
> > the memory subsystem must be enabled. This value is valid only when
> > BPF_F_SELECTABLE_MEMCG is set in map_flags. Once the kernel get the
> > memory cgroup from this fd, it will set this memcg into bpf map, then
> > all the subsequent memory allocation of this map will be charge to the
> > memcg.
> >
> > The map creation paths in libbpf are also changed consequently.
> >
> > Currently it is only supported for cgroup2 directory.
> >
> > The usage of this new member as follows,
> >       struct bpf_map_create_opts map_opts = {
> >               .sz = sizeof(map_opts),
> >               .map_flags = BPF_F_SELECTABLE_MEMCG,
> >       };
> >       int memcg_fd, int map_fd;
> >       int key, value;
> >
> >       memcg_fd = open("/cgroup2", O_DIRECTORY);
> >       if (memcg_fd < 0) {
> >               perror("memcg dir open");
> >               return -1;
> >       }
> >
> >       map_opts.memcg_fd = memcg_fd;
> >       map_fd = bpf_map_create(BPF_MAP_TYPE_HASH, "map_for_memcg",
> >                               sizeof(key), sizeof(value),
> >                               1024, &map_opts);
> >       if (map_fd <= 0) {
> >               perror("map create");
> >               return -1;
> >       }
>
> Overall the api extension makes sense.
> The flexibility of selecting memcg is useful.
>

Thanks!

> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  include/uapi/linux/bpf.h       |  2 ++
> >  kernel/bpf/syscall.c           | 47 ++++++++++++++++++++++++++--------
> >  tools/include/uapi/linux/bpf.h |  2 ++
> >  tools/lib/bpf/bpf.c            |  1 +
> >  tools/lib/bpf/bpf.h            |  3 ++-
> >  tools/lib/bpf/libbpf.c         |  2 ++
> >  6 files changed, 46 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index d5fc1ea70b59..a6e02c8be924 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -1296,6 +1296,8 @@ union bpf_attr {
> >                                                  * struct stored as the
> >                                                  * map value
> >                                                  */
> > +             __s32   memcg_fd;       /* selectable memcg */
> > +             __s32   :32;            /* hole */
>
> new fields cannot be inserted in the middle of uapi struct.
>

There's a "#define BPF_MAP_CREATE_LAST_FIELD map_extra" in
kernel/bpf/syscall.c, and thus I thought it may have some special
meaning, so I put the new field above it.
Now that it doesn't have any special meaning, I will change it as you suggested.

> >               /* Any per-map-type extra fields
> >                *
> >                * BPF_MAP_TYPE_BLOOM_FILTER - the lowest 4 bits indicate the
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 6401cc417fa9..9900e2b87315 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -402,14 +402,30 @@ void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock)
> >  }
> >
> >  #ifdef CONFIG_MEMCG_KMEM
> > -static void bpf_map_save_memcg(struct bpf_map *map)
> > +static int bpf_map_save_memcg(struct bpf_map *map, union bpf_attr *attr)
> >  {
> > -     /* Currently if a map is created by a process belonging to the root
> > -      * memory cgroup, get_obj_cgroup_from_current() will return NULL.
> > -      * So we have to check map->objcg for being NULL each time it's
> > -      * being used.
> > -      */
> > -     map->objcg = get_obj_cgroup_from_current();
> > +     struct obj_cgroup *objcg;
> > +     struct cgroup *cgrp;
> > +
> > +     if (attr->map_flags & BPF_F_SELECTABLE_MEMCG) {
>
> The flag is unnecessary. Just add memcg_fd to the end of attr and use != 0
> as a condition that it should be used instead of get_obj_cgroup_from_current().
> There are other parts of bpf uapi that have similar fd handling logic.
>

Right. There's a ensure_good_fd() to make the fd a positive number.
I will change it.

> > +             cgrp = cgroup_get_from_fd(attr->memcg_fd);
> > +             if (IS_ERR(cgrp))
> > +                     return -EINVAL;
> > +
> > +             objcg = get_obj_cgroup_from_cgroup(cgrp);
> > +             if (IS_ERR(objcg))
> > +                     return PTR_ERR(objcg);
> > +     } else {
> > +             /* Currently if a map is created by a process belonging to the root
> > +              * memory cgroup, get_obj_cgroup_from_current() will return NULL.
> > +              * So we have to check map->objcg for being NULL each time it's
> > +              * being used.
> > +              */
> > +             objcg = get_obj_cgroup_from_current();
> > +     }
> > +
> > +     map->objcg = objcg;
> > +     return 0;
> >  }
> >
> >  static void bpf_map_release_memcg(struct bpf_map *map)
> > @@ -485,8 +501,9 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
> >  }
> >
> >  #else
> > -static void bpf_map_save_memcg(struct bpf_map *map)
> > +static int bpf_map_save_memcg(struct bpf_map *map, union bpf_attr *attr)
> >  {
> > +     return 0;
> >  }
> >
> >  static void bpf_map_release_memcg(struct bpf_map *map)
> > @@ -530,13 +547,18 @@ void *bpf_map_container_alloc(union bpf_attr *attr, u64 size, int numa_node)
>
> High level uapi struct should not be passed into low level helper like this.
> Pls pass memcg_fd instead.
>

Sure, I will do it.

-- 
Regards
Yafang
