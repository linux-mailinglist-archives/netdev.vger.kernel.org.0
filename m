Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E55C588192
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 20:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbiHBSBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 14:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236495AbiHBSBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 14:01:18 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B893952E72;
        Tue,  2 Aug 2022 11:00:36 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id x21so5869805edd.3;
        Tue, 02 Aug 2022 11:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=vO5hgMzI+coOSrp2y/fWYCc218cnkzevyj6TeH11mt4=;
        b=VqrXVaDI52+h2LUnTF6CnnhoWopzvSvj1Iu/INZSsQrzBn7lYYkd1cFJ7wGzw+qiH9
         YrMuwtZnDp3R5z4LRZep7EQbyTqn3HthOPqlU/8fbzi1dTioONh2//QBQJrYcj6SQLJX
         baxNoRukjPf4sK8m7EluWaj41SRX/86OTVW5twg+stgrFFsDcn5XxdBmbRNsWCUj4jUr
         lvnjwTs7HeWbBMJ0WbsLxJK2jrNfmTAzNICT6SKBYzBuo7KRIB+Oq4Do4Hcrns8nsAEI
         tFc9F3yIb0Ps0E6n+APg0x1ECezSR4YMKAEKfacw7bLntc49qx4aixCK9Q3G4ypkEiEd
         /W+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=vO5hgMzI+coOSrp2y/fWYCc218cnkzevyj6TeH11mt4=;
        b=nP0wyG7CaDm+DGUBr9PHWKE4DYAzlR9uJRLLJvrJ/n+Xa//mTOCIGdrsByc7uQv5bX
         LibuLY0GUNwhJGV8B1FRd4keqP9iT4zNItwfBwOcq1drljOdy72D/fMWwuAPqexT7e49
         2LLQPHzVMfPMC11fEL+GNbG10sxRLUZNsxvWspd3mb9m9srcBXrUdJDTlATYWRKZi12v
         DoZ0JxJgXBiWb34TQFcJBPO+P4cIig7yQDhba1oaeN/KFHQJzftYVU01FfRF863NnO5h
         era8qLYsKSE2uATQzrV9M/sJ1y2i0iKNy4b4MzTK/LBPZ37MsTWDW7ZOMeg+gSjvUyj7
         iAKA==
X-Gm-Message-State: ACgBeo0eXv5NyncVWPfVXJJkzw7O+DY53573tfFBkmgmjF1u/QyCuDtF
        fPLh4kegkceui9KBNmc+Y4BK/Qyqy1fsN5YZlXA=
X-Google-Smtp-Source: AA6agR4CKtnPkH9+24H8Et3DYwOKCI8BqD/iHXTQOO9DU2ch3YV/nCogRAJSdv3ACzNsvmBg830ZRQZ8vFac3So0j0w=
X-Received: by 2002:aa7:de18:0:b0:43d:30e2:d22b with SMTP id
 h24-20020aa7de18000000b0043d30e2d22bmr19541667edv.224.1659463234782; Tue, 02
 Aug 2022 11:00:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220729152316.58205-1-laoar.shao@gmail.com> <20220729152316.58205-11-laoar.shao@gmail.com>
 <CAEf4BzZR41_JcQMvBfqB_7rcRZW97cJ_0WfWh7uh4Tt==A6zXw@mail.gmail.com> <CALOAHbBqF31ExUKJ3yFA-zrRRHErWSEHCiPbUMi36WCTRm0j+g@mail.gmail.com>
In-Reply-To: <CALOAHbBqF31ExUKJ3yFA-zrRRHErWSEHCiPbUMi36WCTRm0j+g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 2 Aug 2022 11:00:23 -0700
Message-ID: <CAEf4BzYfpLG3X5b=stNBfX2KU1JOvFRucvQC_vUmg2yVK3JZ=Q@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 10/15] bpf: Use bpf_map_pages_alloc in ringbuf
To:     Yafang Shao <laoar.shao@gmail.com>
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

On Tue, Aug 2, 2022 at 6:31 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> On Tue, Aug 2, 2022 at 7:17 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Jul 29, 2022 at 8:23 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> > >
> > > Introduce new helper bpf_map_pages_alloc() for this memory allocation.
> > >
> > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > ---
> > >  include/linux/bpf.h  |  4 ++++
> > >  kernel/bpf/ringbuf.c | 27 +++++++++------------------
> > >  kernel/bpf/syscall.c | 41 +++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 54 insertions(+), 18 deletions(-)
> > >
> >
> > [...]
> >
> > >         /* Each data page is mapped twice to allow "virtual"
> > >          * continuous read of samples wrapping around the end of ring
> > > @@ -95,16 +95,10 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(struct bpf_map *map,
> > >         if (!pages)
> > >                 return NULL;
> > >
> > > -       for (i = 0; i < nr_pages; i++) {
> > > -               page = alloc_pages_node(numa_node, flags, 0);
> > > -               if (!page) {
> > > -                       nr_pages = i;
> > > -                       goto err_free_pages;
> > > -               }
> > > -               pages[i] = page;
> > > -               if (i >= nr_meta_pages)
> > > -                       pages[nr_data_pages + i] = page;
> > > -       }
> > > +       ptr = bpf_map_pages_alloc(map, pages, nr_meta_pages, nr_data_pages,
> > > +                                 numa_node, flags, 0);
> > > +       if (!ptr)
> >
> > bpf_map_pages_alloc() has some weird and confusing interface. It fills
> > out pages (second argument) and also returns pages as void *. Why not
> > just return int error (0 or -ENOMEM)? You are discarding this ptr
> > anyways.
> >
>
> I will change it.
>
> >
> > But also thinking some more, bpf_map_pages_alloc() is very ringbuf
> > specific (which other map will have exactly the same meaning for
> > nr_meta_pages and nr_data_pages, where we also allocate 2 *
> > nr_data_pages, etc).
> >
> > I don't think it makes sense to expose it as a generic internal API.
> > Why not keep all that inside kernel/bpf/ringbuf.c instead?
> >
>
> Right, it is used in ringbuf.c only currently. I will keep it inside ringbuf.c.
>

In such case you might as well put pages = bpf_map_area_alloc(); part
into this function and return struct page ** as a result, so that
everything related to pages is handled as a single unit. And then
bpf_map_pages_free() will free not just each individual page, but also
struct page*[] array.

Also please call it something ringbuf specific, e.g.,
bpf_ringbuf_pages_{alloc,free}()?

>
> --
> Regards
> Yafang
