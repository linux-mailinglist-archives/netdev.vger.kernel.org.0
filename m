Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E12587D21
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 15:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236643AbiHBNb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 09:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233142AbiHBNb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 09:31:57 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8166917584;
        Tue,  2 Aug 2022 06:31:52 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id m67so6976441vsc.12;
        Tue, 02 Aug 2022 06:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=9gprTQRjUhTM4eoJepnmz+nTG4q6JfCebIgS1oAjgwU=;
        b=WsFSaQ0R9QxYxMnzDFZdkA8WUEjIn3E7audy21Bm54MVjFyX7JZtf1A8KcqUHCDt7U
         bZAn7toPyVdW5q/bKe7gYj0Dk8Bk2j6SUXKOOMaweItxHhoHgDqLQeAXSG4PsaU0+xcc
         2TyH/ruXzF+N+565tAeMZgQC90MemwYTRhLPH668JKmzz9dhG8x/SB4iJXKyxrIlMuPw
         +PhzKUSNcva/u6IJoqAM+aFbYAgMJc7j57L82HH4F2F1bDpkLsAVxmOp6X3oAiAFZaov
         kR7sU4UfsQd8XLIVJ20bFYf6Fa3S5JGmxOxzRINBQHQylcSEYuL1RUG9ifRZj5R4FVno
         2FJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=9gprTQRjUhTM4eoJepnmz+nTG4q6JfCebIgS1oAjgwU=;
        b=behn9SZclu/Fm+Lwg4HHx52crFBzG/715ooFMpYNvwgN8HvtwY5//XwxHgsRaHqSFc
         IeXtKX/cTw0Ig2RZqCfWSiQt6S743It7VMCZ0AEoVtzHy4UUgbF7OuYhFRv03oILyPsg
         AS1RKJF4CA2dx1RDX7m4NTsf5+eTR5CI3FtmXxD4nZodbUduQe850kfm4TtZ16q3uSTB
         ZFYGU5f7KGk1fxB+5O3QEj85Y/vXyg+cw/Hts8HdzJ+dnDUlDlAwJPCJqNuf/FxQyFLy
         tVImNoHJaDfW5/RmjdycpNoajSxyqFgS5Gscx8yBEbcHDW8kbUK9etZx5Q8IPi0bUqFZ
         mv8Q==
X-Gm-Message-State: AJIora/Od7ehWbPmXUk5awRJv2cwfNCzfc1+FINH0cxW83TOpg/fdrY9
        NgoSDs29xb6vn2klxfL7tpJVJ5xLUgRn2aNhkd4=
X-Google-Smtp-Source: AGRyM1sB28TCJySSRg2dx30CTcTN8Y8SobsgdYSPL86qGc/CsIF5/pgoTjeoYVakke50BccLXowOmL606283XKZsDEk=
X-Received: by 2002:a05:6102:3ec1:b0:358:70a1:3c28 with SMTP id
 n1-20020a0561023ec100b0035870a13c28mr7380469vsv.11.1659447111600; Tue, 02 Aug
 2022 06:31:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220729152316.58205-1-laoar.shao@gmail.com> <20220729152316.58205-11-laoar.shao@gmail.com>
 <CAEf4BzZR41_JcQMvBfqB_7rcRZW97cJ_0WfWh7uh4Tt==A6zXw@mail.gmail.com>
In-Reply-To: <CAEf4BzZR41_JcQMvBfqB_7rcRZW97cJ_0WfWh7uh4Tt==A6zXw@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 2 Aug 2022 21:31:15 +0800
Message-ID: <CALOAHbBqF31ExUKJ3yFA-zrRRHErWSEHCiPbUMi36WCTRm0j+g@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 10/15] bpf: Use bpf_map_pages_alloc in ringbuf
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Tue, Aug 2, 2022 at 7:17 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Jul 29, 2022 at 8:23 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > Introduce new helper bpf_map_pages_alloc() for this memory allocation.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  include/linux/bpf.h  |  4 ++++
> >  kernel/bpf/ringbuf.c | 27 +++++++++------------------
> >  kernel/bpf/syscall.c | 41 +++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 54 insertions(+), 18 deletions(-)
> >
>
> [...]
>
> >         /* Each data page is mapped twice to allow "virtual"
> >          * continuous read of samples wrapping around the end of ring
> > @@ -95,16 +95,10 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(struct bpf_map *map,
> >         if (!pages)
> >                 return NULL;
> >
> > -       for (i = 0; i < nr_pages; i++) {
> > -               page = alloc_pages_node(numa_node, flags, 0);
> > -               if (!page) {
> > -                       nr_pages = i;
> > -                       goto err_free_pages;
> > -               }
> > -               pages[i] = page;
> > -               if (i >= nr_meta_pages)
> > -                       pages[nr_data_pages + i] = page;
> > -       }
> > +       ptr = bpf_map_pages_alloc(map, pages, nr_meta_pages, nr_data_pages,
> > +                                 numa_node, flags, 0);
> > +       if (!ptr)
>
> bpf_map_pages_alloc() has some weird and confusing interface. It fills
> out pages (second argument) and also returns pages as void *. Why not
> just return int error (0 or -ENOMEM)? You are discarding this ptr
> anyways.
>

I will change it.

>
> But also thinking some more, bpf_map_pages_alloc() is very ringbuf
> specific (which other map will have exactly the same meaning for
> nr_meta_pages and nr_data_pages, where we also allocate 2 *
> nr_data_pages, etc).
>
> I don't think it makes sense to expose it as a generic internal API.
> Why not keep all that inside kernel/bpf/ringbuf.c instead?
>

Right, it is used in ringbuf.c only currently. I will keep it inside ringbuf.c.


-- 
Regards
Yafang
