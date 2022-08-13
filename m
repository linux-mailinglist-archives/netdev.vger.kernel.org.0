Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6B95917BC
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 02:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbiHMAHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 20:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiHMAHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 20:07:45 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB445C9EB;
        Fri, 12 Aug 2022 17:07:41 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id j2so2316336vsp.1;
        Fri, 12 Aug 2022 17:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=e/GEPoh9oXwaicH1mqU0UxtQs3rb9zpYq6pzE3gMamU=;
        b=fI8PvmX9/t2PLgbwoyuy/E4fAMPOov0xE5a7OjGy1WUFHEUxwBcNvvqD5gSGVhNgOK
         WZw3lzfQQbHfVe/0Qj0NW4OPEGEgpST591KZOPILFcg+sqpKgN0t5MBjxK4tyAD/q4Lj
         jYCms26OXy4IHggn8pSfZFxRnAWvWI7Hd0dNIjAwzZLlX3bz+1tkMIrMO4RZcom9RklK
         xQ2xolwtYqrIeEOBL3tL/OTJkhg8kxtJk12IBEeDnKuGQZ6HXGmYTHY59ORJhR5EwtLT
         gIA0+1VDanZTFu0PZ9dsoj+ehsEartf/DGCZPFSZhYqTJV9VRPoUt4M2MC2+M2m6o8iv
         0bSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=e/GEPoh9oXwaicH1mqU0UxtQs3rb9zpYq6pzE3gMamU=;
        b=H3dOLXhiAgOOYfg6sUPNDsDzNfTn1FoPEex2pRWZM8WnGutmmUXiAzXt4nVF59qQJR
         HU92ZGUYsYGBDbV+cDMmn+c0j15XHIY45b68S3wvy+hO/z17ZxWON691LIZYNXrgA9MG
         ft+gbFFV1PQf5ibEDObPKv+r22JnyD24pYm/Stk7oGBrmFdbXssRIEVs3llFaNvHgv/L
         Oe3Q8LtJHYH33DLXYcY93/EvFtXzPfI6RCZ8jh9VYYT3FPy3PNlFsy2BBthy8CnGTiun
         6DhXjwEPo/hEKiVnMAOlQwvPPl5rNqCwRgajGb1SXuRugIbhMXOb582GWNC3hLs1v+vL
         xXzA==
X-Gm-Message-State: ACgBeo3zDVEhFbwn1PMfickt9e3nspwOnRvdjavCqlhnlJPlIO+6j3ge
        ZAV8W08ZYq0GC6+tKw4NeeWwoZ87n8oETvSGGzI=
X-Google-Smtp-Source: AA6agR6wxzw7R/QR4+tJWTD/bsN3E+UUPFlZUz6BEsv1/PilpMzsEYhAEcNJpaQv5Ng+IURcAxZqkfJ8+uoYx7n08b8=
X-Received: by 2002:a05:6102:441c:b0:378:fcdd:d951 with SMTP id
 df28-20020a056102441c00b00378fcddd951mr2920620vsb.22.1660349261002; Fri, 12
 Aug 2022 17:07:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220810151840.16394-1-laoar.shao@gmail.com> <20220810151840.16394-14-laoar.shao@gmail.com>
 <20220812165756.dxaqy3go567prr5s@google.com>
In-Reply-To: <20220812165756.dxaqy3go567prr5s@google.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 13 Aug 2022 08:07:04 +0800
Message-ID: <CALOAHbDti1h+T8fWxRHs-ZoE6wacChhe7vfPZaooPutJodFkcw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 13/15] mm, memcg: Add new helper get_obj_cgroup_from_cgroup
To:     Shakeel Butt <shakeelb@google.com>
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
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 13, 2022 at 12:57 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Wed, Aug 10, 2022 at 03:18:38PM +0000, Yafang Shao wrote:
> > Introduce new helper get_obj_cgroup_from_cgroup() to get obj_cgroup from
> > a specific cgroup.
>
> Can you please add couple of lines on why you need objcg?
>

Sure. will update in the next version.

> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  include/linux/memcontrol.h |  1 +
> >  mm/memcontrol.c            | 41 +++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 42 insertions(+)
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 2f0a611..901a921 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -1713,6 +1713,7 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
> >  int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
> >  void __memcg_kmem_uncharge_page(struct page *page, int order);
> >
> > +struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp);
> >  struct obj_cgroup *get_obj_cgroup_from_current(void);
> >  struct obj_cgroup *get_obj_cgroup_from_page(struct page *page);
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 618c366..762cffa 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2908,6 +2908,47 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> >       return objcg;
> >  }
> >
> > +static struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> > +{
> > +     struct obj_cgroup *objcg;
> > +
> > +     if (memcg_kmem_bypass())
> > +             return NULL;
> > +
> > +     rcu_read_lock();
> > +     objcg = __get_obj_cgroup_from_memcg(memcg);
> > +     rcu_read_unlock();
> > +     return objcg;
> > +}
> > +
> > +struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp)
> > +{
> > +     struct cgroup_subsys_state *css;
> > +     struct mem_cgroup *memcg;
> > +     struct obj_cgroup *objcg;
> > +
> > +     rcu_read_lock();
> > +     css = rcu_dereference(cgrp->subsys[memory_cgrp_id]);
> > +     if (!css || !css_tryget_online(css)) {
> > +             rcu_read_unlock();
> > +             cgroup_put(cgrp);
> > +             return ERR_PTR(-EINVAL);
> > +     }
> > +     rcu_read_unlock();
> > +     cgroup_put(cgrp);
>
> The above put seems out of place and buggy.
>

Thanks for pointing it out.
The cgroup_put should be used in bpf_map_save_memcg().
I will update it.

-- 
Regards
Yafang
