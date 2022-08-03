Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27865588CF2
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 15:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237878AbiHCN2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 09:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235432AbiHCN2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 09:28:38 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F2C1400D;
        Wed,  3 Aug 2022 06:28:37 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id x125so17781664vsb.13;
        Wed, 03 Aug 2022 06:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=d4CMEGQnU+S9ZYP05NLfCafbO2suR8T26hcKhvZuoaw=;
        b=ZvIb+0C1qehTMi24B7yGhqa99SBgp/GVNYmrBlByJqiMvXiYYacZsVBTgeRmFfKrE7
         Kcp2l/7ydf4FNWFsiBoBzFU1jLiyfPzseMEePRWYD/GvsjvLl41mEAJTUfE9BQgZYb85
         Z2GBA+uAYNixhh2ZmCyzOqfI9BUNGYRQu/GZwl/H5PmlKdhXldqe2U+BsEPdAGKalc7X
         k9vDr9/a1zOae6c+iHFnCBfc9YVPHtdVp2UqwPRvU5m+mSNaAeyiyj+Dno2nKCv4D60A
         jdcrvZEnxqipK1g4h5sCiC21eN3NLMDvK7m6fsF/yJkoU2hhHiFuZtrM+Ucv+SnGb0iH
         mvMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=d4CMEGQnU+S9ZYP05NLfCafbO2suR8T26hcKhvZuoaw=;
        b=oTwLb55Et88EwgPSMyA9Lr2JR1xNuReJd8/N+FJvfYh0zaq37Pb3+8THBv0nr+f+TF
         Bnro5ynt2vbnSq13Hyk6ZTp6g1UPLoOqWCIBwDl+oqjk8p5noi6iT2Qv3pqDJux92nAH
         u5G2Ypltp0pP6wicjph3u/yjBwdZhKNs036nfiy2yQGn92DiKMh4RO/JyPpvrPRtv7aN
         VQ+HAf1eqHyLeRGARJHTUX7cnCNzq78DQOTCYP8bdc3k3AkHsaV/bqkxJfSvOVenMjPK
         OfqQGRDqBZWVfGiFvKJiwkzWSsH2Q9wSZCsgDnonZrodyxgmBbXyQOqPUmRv/wXlkk5u
         xRAQ==
X-Gm-Message-State: ACgBeo1NhEeK0EeYMIHGrx+uDpbnz61oh6zfLWc5fH0Xi9RatOX7FUFJ
        zR8C/KqT+MYPNtYYiy5a1O8ZWBkPYhjmeMxT3pM=
X-Google-Smtp-Source: AA6agR7fssyMEPL+0GEoOPDewD5mH1gILM/Q0lLDfqi9TugsYxRKmx7COVHqe1jBD5Wr3DA8T//+hr0gSeSsFEpRPy4=
X-Received: by 2002:a05:6102:441c:b0:378:fcdd:d951 with SMTP id
 df28-20020a056102441c00b00378fcddd951mr7831366vsb.22.1659533316066; Wed, 03
 Aug 2022 06:28:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220729152316.58205-1-laoar.shao@gmail.com> <20220729152316.58205-11-laoar.shao@gmail.com>
 <CAEf4BzZR41_JcQMvBfqB_7rcRZW97cJ_0WfWh7uh4Tt==A6zXw@mail.gmail.com>
 <CALOAHbBqF31ExUKJ3yFA-zrRRHErWSEHCiPbUMi36WCTRm0j+g@mail.gmail.com> <CAEf4BzYfpLG3X5b=stNBfX2KU1JOvFRucvQC_vUmg2yVK3JZ=Q@mail.gmail.com>
In-Reply-To: <CAEf4BzYfpLG3X5b=stNBfX2KU1JOvFRucvQC_vUmg2yVK3JZ=Q@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Wed, 3 Aug 2022 21:27:59 +0800
Message-ID: <CALOAHbBaQh38htnVg7sXrBEeCghe3RYL514xAqi_DhuHbOXMyw@mail.gmail.com>
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

On Wed, Aug 3, 2022 at 2:00 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Aug 2, 2022 at 6:31 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > On Tue, Aug 2, 2022 at 7:17 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Fri, Jul 29, 2022 at 8:23 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> > > >
> > > > Introduce new helper bpf_map_pages_alloc() for this memory allocation.
> > > >
> > > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > > ---
> > > >  include/linux/bpf.h  |  4 ++++
> > > >  kernel/bpf/ringbuf.c | 27 +++++++++------------------
> > > >  kernel/bpf/syscall.c | 41 +++++++++++++++++++++++++++++++++++++++++
> > > >  3 files changed, 54 insertions(+), 18 deletions(-)
> > > >
> > >
> > > [...]
> > >
> > > >         /* Each data page is mapped twice to allow "virtual"
> > > >          * continuous read of samples wrapping around the end of ring
> > > > @@ -95,16 +95,10 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(struct bpf_map *map,
> > > >         if (!pages)
> > > >                 return NULL;
> > > >
> > > > -       for (i = 0; i < nr_pages; i++) {
> > > > -               page = alloc_pages_node(numa_node, flags, 0);
> > > > -               if (!page) {
> > > > -                       nr_pages = i;
> > > > -                       goto err_free_pages;
> > > > -               }
> > > > -               pages[i] = page;
> > > > -               if (i >= nr_meta_pages)
> > > > -                       pages[nr_data_pages + i] = page;
> > > > -       }
> > > > +       ptr = bpf_map_pages_alloc(map, pages, nr_meta_pages, nr_data_pages,
> > > > +                                 numa_node, flags, 0);
> > > > +       if (!ptr)
> > >
> > > bpf_map_pages_alloc() has some weird and confusing interface. It fills
> > > out pages (second argument) and also returns pages as void *. Why not
> > > just return int error (0 or -ENOMEM)? You are discarding this ptr
> > > anyways.
> > >
> >
> > I will change it.
> >
> > >
> > > But also thinking some more, bpf_map_pages_alloc() is very ringbuf
> > > specific (which other map will have exactly the same meaning for
> > > nr_meta_pages and nr_data_pages, where we also allocate 2 *
> > > nr_data_pages, etc).
> > >
> > > I don't think it makes sense to expose it as a generic internal API.
> > > Why not keep all that inside kernel/bpf/ringbuf.c instead?
> > >
> >
> > Right, it is used in ringbuf.c only currently. I will keep it inside ringbuf.c.
> >
>
> In such case you might as well put pages = bpf_map_area_alloc(); part
> into this function and return struct page ** as a result, so that
> everything related to pages is handled as a single unit. And then
> bpf_map_pages_free() will free not just each individual page, but also
> struct page*[] array.
>

Good suggestion. I will do it.

> Also please call it something ringbuf specific, e.g.,
> bpf_ringbuf_pages_{alloc,free}()?
>

It Makes sense to me.

-- 
Regards
Yafang
