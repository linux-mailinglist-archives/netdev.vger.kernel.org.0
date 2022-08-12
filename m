Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8935917B0
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 01:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbiHLX5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 19:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiHLX5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 19:57:33 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4B774368;
        Fri, 12 Aug 2022 16:57:32 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id m67so2262489vsc.12;
        Fri, 12 Aug 2022 16:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=MeYInUQzfSsWm4MDFB8EAiQR9dV69NKtPMF/+GmU3iY=;
        b=MEXEaE6E4+d47+wZBUtJ0+EFnhJO1lregEyMWFfn4t7I5kwQN8VF8nvwVs0vOvQrmw
         IkYx8UkGnJwTBwAdthWSHRIiFCcoU5rbBu3Pvx60IjVL+5OeXjYlxzKiXi+qSIXH3Wbt
         HhrgRvTgLNYtydMYmw+VlGEEDb3RvQQ0zJMA7Nu+NEhvITm99dsIJ9/94kzUa+qBBTtO
         o5k99KWYMPWhxiYnmbgceQ/k0t1oNIsIte1umCWVpP7/Nk/VeBmL23sUekaxwL8T9dhp
         +GGZ6YvINgevRY+02dZpT76v6uuWN1AtjIseb+SsJY3UspYKvparReJgO5PiRKKs2xXf
         5ZOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=MeYInUQzfSsWm4MDFB8EAiQR9dV69NKtPMF/+GmU3iY=;
        b=5OAvNKOAsw/4SGnIrn7Z73IoBuViriXsvwKbKhQhswOwel9Mp/HiLAWouDaJ336161
         O9sMpN1rRXopl4In/cnUbuyw5nfiX2sgHcm1i5J8pPLP2xXU+DWFF1YJuI/xnb+2PQW5
         zMCFzeQpg47+RiZjQhax7N7QdoxrXh+HuvEYJXbuWH7+aDMqw6gu2o1MqO5tCUEipeWa
         UmQJzj1Muo1PO4m2DKtYuCsprjOu2bYrDwH2QDhPke+vjGnZ2Pc+2GWyzMv4uXyIZxt6
         w4A2ivTBB/Hvd0ZOFfH8VBCrbG6LZFkMxP8MNINUc2j04n3HGqZ1S1iEZ1/IlU7o3M5l
         syTA==
X-Gm-Message-State: ACgBeo20ABhvxmZNOW1XsJJ0kN33celduH3x+dCrgdtWwci4pLyN7PII
        sl8412H7lpR35FUy5M0hoSYTRMVsH1CQKi0+zCU=
X-Google-Smtp-Source: AA6agR5Zya9iooJwbDf2yPIqfoEWB92eH9GN+9ThnyaWxFKx90q0scS4L2I2612aPP8vvXSr6ijAaYdPe7mVld97RGo=
X-Received: by 2002:a05:6102:3ec1:b0:358:70a1:3c28 with SMTP id
 n1-20020a0561023ec100b0035870a13c28mr2879758vsv.11.1660348651742; Fri, 12 Aug
 2022 16:57:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220810151840.16394-1-laoar.shao@gmail.com> <20220810151840.16394-14-laoar.shao@gmail.com>
 <YvUrXLJF6qrGOdjP@P9FQF9L96D.corp.robot.car> <CALOAHbAj7BymBV7KhzxLfMPue8666V+24TOfqG0XTE4euWyR4Q@mail.gmail.com>
 <YvaQhLk06MHQJWHB@P9FQF9L96D.corp.robot.car>
In-Reply-To: <YvaQhLk06MHQJWHB@P9FQF9L96D.corp.robot.car>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 13 Aug 2022 07:56:54 +0800
Message-ID: <CALOAHbBh4=yxX5c2_TK8-uf14KKg=Vp1NoHAEZGxS2wAxCnZWA@mail.gmail.com>
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

On Sat, Aug 13, 2022 at 1:40 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> On Fri, Aug 12, 2022 at 08:35:19AM +0800, Yafang Shao wrote:
> > On Fri, Aug 12, 2022 at 12:16 AM Roman Gushchin
> > <roman.gushchin@linux.dev> wrote:
> > >
> > > On Wed, Aug 10, 2022 at 03:18:38PM +0000, Yafang Shao wrote:
> > > > Introduce new helper get_obj_cgroup_from_cgroup() to get obj_cgroup from
> > > > a specific cgroup.
> > > >
> > > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > > ---
> > > >  include/linux/memcontrol.h |  1 +
> > > >  mm/memcontrol.c            | 41 +++++++++++++++++++++++++++++++++++++++++
> > > >  2 files changed, 42 insertions(+)
> > > >
> > > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > > index 2f0a611..901a921 100644
> > > > --- a/include/linux/memcontrol.h
> > > > +++ b/include/linux/memcontrol.h
> > > > @@ -1713,6 +1713,7 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
> > > >  int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
> > > >  void __memcg_kmem_uncharge_page(struct page *page, int order);
> > > >
> > > > +struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp);
> > > >  struct obj_cgroup *get_obj_cgroup_from_current(void);
> > > >  struct obj_cgroup *get_obj_cgroup_from_page(struct page *page);
> > > >
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index 618c366..762cffa 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -2908,6 +2908,47 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> > > >       return objcg;
> > > >  }
> > > >
> > > > +static struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> > > > +{
> > > > +     struct obj_cgroup *objcg;
> > > > +
> > > > +     if (memcg_kmem_bypass())
> > > > +             return NULL;
> > > > +
> > > > +     rcu_read_lock();
> > > > +     objcg = __get_obj_cgroup_from_memcg(memcg);
> > > > +     rcu_read_unlock();
> > > > +     return objcg;
> > >
> > > This code doesn't make sense to me. What does rcu read lock protect here?
> >
> > To protect rcu_dereference(memcg->objcg);.
> > Doesn't it need the read rcu lock ?
>
> No, it's not how rcu works. Please, take a look at the docs here:
> https://docs.kernel.org/RCU/whatisRCU.html#whatisrcu .
> In particular, it describes this specific case very well.
>
> In 2 words, you don't protect the rcu_dereference() call, you protect the pointer

I just copied and pasted rcu_dereference(memcg->objcg) there to make it clear.
Actually it protects memcg->objcg, doesn't it ?

> you get, cause it's valid only inside the rcu read section. After rcu_read_unlock()
> it might point at a random data, because the protected object can be already freed.
>

Are you sure?
Can't the obj_cgroup_tryget(objcg) prevent it from being freed ?

-- 
Regards
Yafang
