Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB422590998
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 02:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235630AbiHLAgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 20:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiHLAgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 20:36:00 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CBF8E9AC;
        Thu, 11 Aug 2022 17:35:58 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id b81so9773161vkf.1;
        Thu, 11 Aug 2022 17:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=yuY+CrCHh5iw+dz75cfyoj809nIH6VdKTSl/omRXr5U=;
        b=i1Gul5mNUaGw0nEn45PkbfTZH4+QbO/gOPWf/jsd64c71pMPnEeeHNYaoOOp67Zejt
         HpGF4V+24V8nXoTcVT4SHXmiq4UexxZ3dUGwRBJg3FRuVytPb7PUJNTEblSIDjNBYcEm
         qctERzIXn9FadN5Vl1NFwcOBA/zocktk1pILQr9hFYzS7oPSTmuBt5L9b8rt8NdzSeJ1
         MB7mDKGrpXakXW6dVQDrPuD0mbJUGuSK6LV3+3AzhljRMcXN8tEvhxoWu9NJKdF83ozw
         7vBDnJEq00k1Ftip8T8YRia0E0X2u+O6GMRbmczuYSQw0TTu7taqB6JNwpQGW9+odD7t
         OrJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=yuY+CrCHh5iw+dz75cfyoj809nIH6VdKTSl/omRXr5U=;
        b=vqt0tuhlUPcr2VJkYziosVudaldjJtq3EuA803TizR7IObfk28jMcGZiuyTlr2ykE6
         YlJaDodJSGQIWyvB/1PmDDiUBSWLBwLV3L4nD0li4LdbGaKtHBXrbCD1+M4IJxeoll79
         h0VDJiIPtNbPK85Qe7TOWnp82kLnF0/rZfOQQjn5IMMrnDSVMxwiUlUTlMx4Jf7qLr4C
         SGG9M0ar+FVYaM8nCt7NFpNqcsrXZFWSV6pSs4ncXaaMMmo/BeA6UZ3P1r8cF/+F36sv
         hTsaBE7Zy5hkWWScdwHI7xrRFZWEsSPvToM0m2y/fjPIQiwdpoKnwMdEegNIsRwknm1x
         gOuA==
X-Gm-Message-State: ACgBeo3mBiWxn98kO1MCKFxpGa+gzyaMCx2+MF3k6/Zp1gOvS+ZZ/hT7
        IDNr2aOL6rGRgrWaCFCZEAiEpzeNfSvgVUP3qx8=
X-Google-Smtp-Source: AA6agR4QQq0m0CiuaafU7RoXywD0uAF8KN6aON3rhPKA9cVL1UwhSp9yA8+kuveWfkVWlkakLoLERLQNQcomx6oW5Ec=
X-Received: by 2002:a05:6122:154:b0:377:ebed:7e5d with SMTP id
 r20-20020a056122015400b00377ebed7e5dmr821743vko.41.1660264558090; Thu, 11 Aug
 2022 17:35:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220810151840.16394-1-laoar.shao@gmail.com> <20220810151840.16394-14-laoar.shao@gmail.com>
 <YvUrXLJF6qrGOdjP@P9FQF9L96D.corp.robot.car>
In-Reply-To: <YvUrXLJF6qrGOdjP@P9FQF9L96D.corp.robot.car>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 12 Aug 2022 08:35:19 +0800
Message-ID: <CALOAHbAj7BymBV7KhzxLfMPue8666V+24TOfqG0XTE4euWyR4Q@mail.gmail.com>
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

On Fri, Aug 12, 2022 at 12:16 AM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> On Wed, Aug 10, 2022 at 03:18:38PM +0000, Yafang Shao wrote:
> > Introduce new helper get_obj_cgroup_from_cgroup() to get obj_cgroup from
> > a specific cgroup.
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
>
> This code doesn't make sense to me. What does rcu read lock protect here?

To protect rcu_dereference(memcg->objcg);.
Doesn't it need the read rcu lock ?

-- 
Regards
Yafang
