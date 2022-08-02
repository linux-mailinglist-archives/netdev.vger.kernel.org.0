Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9ED587D66
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 15:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbiHBNsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 09:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiHBNs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 09:48:29 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CFE21839;
        Tue,  2 Aug 2022 06:48:26 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id n15so7117198vkk.8;
        Tue, 02 Aug 2022 06:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ZmKXp3nhgE2D+UfRssUidLCX82AvB1pkKLvE94m52nM=;
        b=cFsGXeAX6OZ3JXUeob1jnuC8D2bYX4LOXjGowJF5YwKCoyyXJmUX1ifBcMK6T/xI6J
         +aNKNnkHgfHQ6t75vA+8IUhBErwm4Yf0CWulN0jYQVbh/KgEvWgCglL6FjykcoriTSpS
         cCbuVaJ8IaCV5B9B8ZlbFL1FZI8/rEkoMF+J9ZxBSbPcdG2zl+B+kISHDeKQFm3quCV1
         1SE7sGK4NMjMYVDm350LTOdP4QphlDu9wexlVL9t06POGnzB3Rr+dtSdSnFz2upPOa0c
         /WUAOerxTUMY2YvYZFtUf3vYXxu98PwhBeH8JBAeF85mEH1VJk+jO2TBqrtOMsYjLaW+
         RseA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ZmKXp3nhgE2D+UfRssUidLCX82AvB1pkKLvE94m52nM=;
        b=dahUf7cAQGar7u3CXnI6LGlUct88btuxzEPRnhAYmpTAm2tFWF5s0lJFKgAgpWFIiK
         3mEFnA0sPFjRKk2hEsT3e94fRw9MbrvAeN6utIVG8q60H57vl//R8eC/MxH5boWJa69T
         pDHDqeODogeYVNKxojNB74PqyjnTZQpezXwY3gIw+7TzIAP3GsQnlKOggN9ymWrS+XkC
         UO04vVh04I+9J+x8KNHIKj0hqdR62FEZt61tid3Dady/3Sk2KxE8GLr+pcsn/q7gqlBf
         h4AQ3FQKluOfNYobv1smg8NoXWHTlcxm5jnB12GBSSmQdQM6pk6fBCk8saDdxAX0DoHx
         tDmg==
X-Gm-Message-State: AJIora8BDwieVAA/XjsjXWcuPayYG8Xx3EtKqobYhVFayv8CdI0aAJyM
        +e6yrsuycL+pfSFKhYjcE/mCUz3UPEb3UEoBWb4=
X-Google-Smtp-Source: AGRyM1sEjg9PPG0Wpx+xs70HALb6GM+jC2dSrBAQbYJrVMYEdFRTjtQkdXLqc47ixYmHVQyeWFnOLLyyzjf0SgmUeu0=
X-Received: by 2002:ac5:cd92:0:b0:376:429d:fdcc with SMTP id
 i18-20020ac5cd92000000b00376429dfdccmr7706890vka.41.1659448105829; Tue, 02
 Aug 2022 06:48:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220729152316.58205-1-laoar.shao@gmail.com> <20220729152316.58205-6-laoar.shao@gmail.com>
 <20220802045832.fcgzvkenet7cmvy7@macbook-pro-3.dhcp.thefacebook.com>
In-Reply-To: <20220802045832.fcgzvkenet7cmvy7@macbook-pro-3.dhcp.thefacebook.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 2 Aug 2022 21:47:49 +0800
Message-ID: <CALOAHbBdKkfEJs8e93Bng0BcMvMvPs8kJkiAixrtS=NB8xAM3Q@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 05/15] bpf: Introduce helpers for container
 of struct bpf_map
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

On Tue, Aug 2, 2022 at 12:58 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jul 29, 2022 at 03:23:06PM +0000, Yafang Shao wrote:
> > Currently bpf_map_area_alloc() is used to allocate a container of struct
> > bpf_map or members in this container. To distinguish the map creation
> > and other members, let split it into two different helpers,
> >   - bpf_map_container_alloc()
> >     Used to allocate a container of struct bpf_map, the container is as
> >     follows,
> >       struct bpf_map_container {
> >         struct bpf_map map;  // the map must be the first member
> >         ....
> >       };
> >     Pls. note that the struct bpf_map_contianer is a abstract one, which
> >     can be struct bpf_array, struct bpf_bloom_filter and etc.
> >
> >     In this helper, it will call bpf_map_save_memcg() to init memcg
> >     relevant data in the bpf map. And these data will be cleared in
> >     bpf_map_container_free().
> >
> >   - bpf_map_area_alloc()
> >     Now it is used to allocate the members in a contianer only.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  include/linux/bpf.h  |  4 ++++
> >  kernel/bpf/syscall.c | 56 ++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 60 insertions(+)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 20c26aed7896..2d971b0eb24b 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1634,9 +1634,13 @@ void bpf_map_inc_with_uref(struct bpf_map *map);
> >  struct bpf_map * __must_check bpf_map_inc_not_zero(struct bpf_map *map);
> >  void bpf_map_put_with_uref(struct bpf_map *map);
> >  void bpf_map_put(struct bpf_map *map);
> > +void *bpf_map_container_alloc(u64 size, int numa_node);
> > +void *bpf_map_container_mmapable_alloc(u64 size, int numa_node,
> > +                                    u32 align, u32 offset);
> >  void *bpf_map_area_alloc(u64 size, int numa_node);
> >  void *bpf_map_area_mmapable_alloc(u64 size, int numa_node);
> >  void bpf_map_area_free(void *base);
> > +void bpf_map_container_free(void *base);
> >  bool bpf_map_write_active(const struct bpf_map *map);
> >  void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
> >  int  generic_map_lookup_batch(struct bpf_map *map,
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 83c7136c5788..1a1a81a11b37 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -495,6 +495,62 @@ static void bpf_map_release_memcg(struct bpf_map *map)
> >  }
> >  #endif
> >
> > +/*
> > + * The return pointer is a bpf_map container, as follow,
> > + *   struct bpf_map_container {
> > + *       struct bpf_map map;
> > + *       ...
> > + *   };
> > + *
> > + * It is used in map creation path.
> > + */
> > +void *bpf_map_container_alloc(u64 size, int numa_node)
> > +{
> > +     struct bpf_map *map;
> > +     void *container;
> > +
> > +     container = __bpf_map_area_alloc(size, numa_node, false);
> > +     if (!container)
> > +             return NULL;
> > +
> > +     map = (struct bpf_map *)container;
> > +     bpf_map_save_memcg(map);
> > +
> > +     return container;
> > +}
> > +
> > +void *bpf_map_container_mmapable_alloc(u64 size, int numa_node, u32 align,
> > +                                    u32 offset)
> > +{
> > +     struct bpf_map *map;
> > +     void *container;
> > +     void *ptr;
> > +
> > +     /* kmalloc'ed memory can't be mmap'ed, use explicit vmalloc */
> > +     ptr = __bpf_map_area_alloc(size, numa_node, true);
> > +     if (!ptr)
> > +             return NULL;
> > +
> > +     container = ptr + align - offset;
> > +     map = (struct bpf_map *)container;
> > +     bpf_map_save_memcg(map);
>
> This is very error prone.
> I don't think the container concept is necessary.
> bpf_map_area_alloc() can just take extra memcg_fd argument.
>

Got it. I will change it.

-- 
Regards
Yafang
