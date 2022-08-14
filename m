Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7136591D9A
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 04:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiHNCgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 22:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiHNCgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 22:36:33 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202061BE94;
        Sat, 13 Aug 2022 19:36:30 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id 67so4343420vsv.2;
        Sat, 13 Aug 2022 19:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=CRrhz0BEyIQHXQS7Ebb+dZKjXFqlcQTdj6VUIrrnwgc=;
        b=ftDvrBkguzbQ/2XyYFCtxaMeZSyG6ASkh0ukfmZpJkaUjIurT935qNLWskNEagEKUO
         eAhSQQ6MHAEjrmmb753yJmoPqgV4BUf55SDaE0mvKMoLnNLqO2+/+b3eprUZmFPPOJB7
         aRuCEGm0YL9t4M65uUCjHNhf/quKNJmjuZqfPvTL+EJO16D7I3f4tJbHEI4A0oNT7aMA
         16sWo4E3+a6uMqMV71ED17WRM71pYSMy+BoUoGfaBjzZn6YIqMfV5me1MASAjIxzcTZe
         uCYosMs/l7zv8Qri8c6fXcQWHn/z9EzE647USr1P/kYs8jwB0wBu41gtYg2X5FP8lRSv
         YQ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=CRrhz0BEyIQHXQS7Ebb+dZKjXFqlcQTdj6VUIrrnwgc=;
        b=iYan4EMnCh5bZAgQL1WI/RAa/BF4xX2wg9AzcIr/djvxmDRyX0yA0qeOBQCtWUoVWY
         K5sInGYC5wrxcDjS6aI819uivdPQCYRT4+vSxquUXlommUb4q1QKRctAvkY7c+TJaq2m
         JXRKDQIsCJ2GjdYSBHLQQ+V/+1uQxtMrFXSAKn69Yij+LElYYwX/2+2fNdLK/g/m+eWb
         HMVBIDJYDBbqshCm+k2nQIHkqN7aJFeHwI71RNIaCL1ukR8ECu1BDL498oNpO0M+7lQk
         YnJeLby2Va1XNCyHm3hqVsT2sxQA1CXKhve2lgGxlmOQh2TqUeAivEDVVdaFe2mwZa1S
         j7Mw==
X-Gm-Message-State: ACgBeo2MRGs8MCWMehRB1HXuNzNGafWC0aTvR8Z3P29hA/laXDTFxC4j
        r9pK1mz8mCz3YJ+kXr6MY3sDnJzPNA/dG2uMyv0=
X-Google-Smtp-Source: AA6agR6xP+37xYYP/oJC40vFFtEp6SLwnBUAkGWFgSWjlaZv0tT4Jc+Drnc7QA0/YU0vEzbn/ZuaQfUQGqoPH65fG+U=
X-Received: by 2002:a05:6102:2753:b0:38a:a86f:6ac5 with SMTP id
 p19-20020a056102275300b0038aa86f6ac5mr3471172vsu.80.1660444589209; Sat, 13
 Aug 2022 19:36:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220810151840.16394-1-laoar.shao@gmail.com> <20220810151840.16394-14-laoar.shao@gmail.com>
 <YvUrXLJF6qrGOdjP@P9FQF9L96D.corp.robot.car> <CALOAHbAj7BymBV7KhzxLfMPue8666V+24TOfqG0XTE4euWyR4Q@mail.gmail.com>
 <YvaQhLk06MHQJWHB@P9FQF9L96D.corp.robot.car> <CALOAHbBh4=yxX5c2_TK8-uf14KKg=Vp1NoHAEZGxS2wAxCnZWA@mail.gmail.com>
 <YvftrF7GmqMjvAa+@P9FQF9L96D.corp.robot.car>
In-Reply-To: <YvftrF7GmqMjvAa+@P9FQF9L96D.corp.robot.car>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sun, 14 Aug 2022 10:35:52 +0800
Message-ID: <CALOAHbDgdpx9ZPsqzfxs3grGhKBhN=zVOtjKRd=mJfT6NLGP_Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 13/15] mm, memcg: Add new helper get_obj_cgroup_from_cgroup
To:     Roman Gushchin <roman.gushchin@linux.dev>
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
        Shakeel Butt <shakeelb@google.com>,
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

On Sun, Aug 14, 2022 at 2:30 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> On Sat, Aug 13, 2022 at 07:56:54AM +0800, Yafang Shao wrote:
> > On Sat, Aug 13, 2022 at 1:40 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> > >
> > > On Fri, Aug 12, 2022 at 08:35:19AM +0800, Yafang Shao wrote:
> > > > On Fri, Aug 12, 2022 at 12:16 AM Roman Gushchin
> > > > <roman.gushchin@linux.dev> wrote:
> > > > >
> > > > > On Wed, Aug 10, 2022 at 03:18:38PM +0000, Yafang Shao wrote:
> > > > > > Introduce new helper get_obj_cgroup_from_cgroup() to get obj_cgroup from
> > > > > > a specific cgroup.
> > > > > >
> > > > > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > > > > ---
> > > > > >  include/linux/memcontrol.h |  1 +
> > > > > >  mm/memcontrol.c            | 41 +++++++++++++++++++++++++++++++++++++++++
> > > > > >  2 files changed, 42 insertions(+)
> > > > > >
> > > > > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > > > > index 2f0a611..901a921 100644
> > > > > > --- a/include/linux/memcontrol.h
> > > > > > +++ b/include/linux/memcontrol.h
> > > > > > @@ -1713,6 +1713,7 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
> > > > > >  int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
> > > > > >  void __memcg_kmem_uncharge_page(struct page *page, int order);
> > > > > >
> > > > > > +struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp);
> > > > > >  struct obj_cgroup *get_obj_cgroup_from_current(void);
> > > > > >  struct obj_cgroup *get_obj_cgroup_from_page(struct page *page);
> > > > > >
> > > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > > index 618c366..762cffa 100644
> > > > > > --- a/mm/memcontrol.c
> > > > > > +++ b/mm/memcontrol.c
> > > > > > @@ -2908,6 +2908,47 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> > > > > >       return objcg;
> > > > > >  }
> > > > > >
> > > > > > +static struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> > > > > > +{
> > > > > > +     struct obj_cgroup *objcg;
> > > > > > +
> > > > > > +     if (memcg_kmem_bypass())
> > > > > > +             return NULL;
> > > > > > +
> > > > > > +     rcu_read_lock();
> > > > > > +     objcg = __get_obj_cgroup_from_memcg(memcg);
> > > > > > +     rcu_read_unlock();
> > > > > > +     return objcg;
> > > > >
> > > > > This code doesn't make sense to me. What does rcu read lock protect here?
> > > >
> > > > To protect rcu_dereference(memcg->objcg);.
> > > > Doesn't it need the read rcu lock ?
> > >
> > > No, it's not how rcu works. Please, take a look at the docs here:
> > > https://docs.kernel.org/RCU/whatisRCU.html#whatisrcu .
> > > In particular, it describes this specific case very well.
> > >
> > > In 2 words, you don't protect the rcu_dereference() call, you protect the pointer
> >
> > I just copied and pasted rcu_dereference(memcg->objcg) there to make it clear.
> > Actually it protects memcg->objcg, doesn't it ?
> >
> > > you get, cause it's valid only inside the rcu read section. After rcu_read_unlock()
> > > it might point at a random data, because the protected object can be already freed.
> > >
> >
> > Are you sure?
> > Can't the obj_cgroup_tryget(objcg) prevent it from being freed ?
>
> Ok, now I see where it comes from. You copy-pasted it from get_obj_cgroup_from_current()?
> There rcu read lock section protects memcg, not objcg.

Could you pls explain in detail why we should protect memcg instead of objcg ?
Why does the memcg need the read rcu lock ?

> In your case you don't need it, because memcg is passed as a parameter to the function,
> so it's the duty of the caller to ensure the lifetime of memcg.
>

I'm still a bit confused. See below,

objcg = rcu_dereference(memcg->objcg);
percpu_ref_tryget(&objcg->refcnt);    <<<< what if the objcg is freed
before this operation ??


-- 
Regards
Yafang
