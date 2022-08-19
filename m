Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D9C59927A
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 03:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242429AbiHSBVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 21:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiHSBVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 21:21:50 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F141FC88B4;
        Thu, 18 Aug 2022 18:21:48 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id j11so1606599vkk.11;
        Thu, 18 Aug 2022 18:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=x+WlY4BSKVFKBcgHLYvbuY4NBBdZIkpvhjCiWa6AJbU=;
        b=N90AWt3Kudge/Xp8O33r141kO5yVImla6A9uZyKqvZPOMvytwEj/oktBy1IoB9eFl3
         VBIq/P1WeQRqWDOxOYfCJmiPO4GFp3SL2IFEhjQztwiURDCcWrdRgxPYF9xZFmBMYPmz
         d55S+BnqKMFHdz8Q58f9IOFjUADp5CjiLVCGapRXEOjF3qoc8DwldBJ1lAtbD6kvIknB
         ElUHGCzzeVNdp8dga4j4nit27hiVv6OA340TyNRAbm9+K1DCarcbA+0M85jBT2IRFn0x
         V4Ad7YqriucrHuTaTGRzby26Rg8iyFBqqz7FlmJI8VQuw2LYVXpZMoh92iPqJFFZjzm0
         VBNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=x+WlY4BSKVFKBcgHLYvbuY4NBBdZIkpvhjCiWa6AJbU=;
        b=thMVHjux7uQqaz9eNlE9ls3T1OzHBvFzouGRwxHyTwJmGUQ+L07JRbU+Da35eMuujG
         SLd34U8BH19f/0QrZxJ222Bzl2p2DqM9yT+qxtU2oda46w7Mm/Z1pQ2UWbxsJ/EvqDa9
         GQ/CYrZ9eonsRFgsoiGmAExy7XkKyTFcWDVe+rs6oTbUjLfsBfeSvHJtUg+L92mDKvll
         NPg1YsKsHMZCMgok4uaDU31dORst2GRxQG86KdwQ26kRfFTa3XMCTe3oQcV2EYNLaF8u
         g2BPKkHN6xgUwcV0rbPskPKummGqV3r+65UaEiXWBANWSaPu3c/X/iWjqU4PcW5UCLaE
         7Jkw==
X-Gm-Message-State: ACgBeo3DMGRRl5UV+pUh6O9Rq/o2lMWH//ODgltGyRF7nEm/8aPz8erx
        HxbTzKChR/rZWMc10exPCXeZjuAMvn0LVpG0owQ=
X-Google-Smtp-Source: AA6agR6PAzXuqdzrwQGMaEaIMftD+9yhgUz9H2/0i37ltB8Htymm8nErBu3DcAgs9eYvMuk8SL+EAz+wMTXPxBqlv7k=
X-Received: by 2002:a1f:251:0:b0:380:d262:4f4f with SMTP id
 78-20020a1f0251000000b00380d2624f4fmr2314419vkc.5.1660872108064; Thu, 18 Aug
 2022 18:21:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220818143118.17733-1-laoar.shao@gmail.com> <20220818143118.17733-11-laoar.shao@gmail.com>
 <CALvZod5GMSiGv9OEhwJfSdXi9B=O-4Nq011pPjNEGf_vDTzhfg@mail.gmail.com>
In-Reply-To: <CALvZod5GMSiGv9OEhwJfSdXi9B=O-4Nq011pPjNEGf_vDTzhfg@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 19 Aug 2022 09:21:11 +0800
Message-ID: <CALOAHbARXHavqaVoSh-nL9DKLiHPvCdmWOZRMMYyeVwTgLrYug@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 10/12] mm, memcg: Add new helper get_obj_cgroup_from_cgroup
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, jolsa@kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Cgroups <cgroups@vger.kernel.org>,
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

On Fri, Aug 19, 2022 at 4:38 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Thu, Aug 18, 2022 at 7:32 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > We want to open a cgroup directory and pass the fd into kernel, and then
> > in the kernel we can charge the allocated memory into the open cgroup if it
> > has valid memory subsystem. In the bpf subsystem, the opened cgroup will
> > be store as a struct obj_cgroup pointer, so a new helper
> > get_obj_cgroup_from_cgroup() is introduced.
> >
> > It also add a comment on why the helper  __get_obj_cgroup_from_memcg()
> > must be protected by rcu read lock.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  include/linux/memcontrol.h |  1 +
> >  mm/memcontrol.c            | 47 ++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 48 insertions(+)
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
> > index 618c366..0409cc4 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2895,6 +2895,14 @@ struct mem_cgroup *mem_cgroup_from_obj(void *p)
> >         return page_memcg_check(folio_page(folio, 0));
> >  }
> >
> > +/*
> > + * Pls. note that the memg->objcg can be freed after it is deferenced,
> > + * that can happen when the memcg is changed from online to offline.
> > + * So this helper must be protected by read rcu lock.
> > + *
> > + * After obj_cgroup_tryget(), it is safe to use the objcg outside of the rcu
> > + * read-side critical section.
> > + */
>
> The comment is too verbose. My suggestion would be to add
> WARN_ON_ONCE(!rcu_read_lock_held()) in the function and if you want to
> add a comment, just say that the caller should have a reference on
> memcg.
>

Sure, I will change it.

> >  static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> >  {
> >         struct obj_cgroup *objcg = NULL;
> > @@ -2908,6 +2916,45 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> >         return objcg;
> >  }
> >
> > +static struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> > +{
> > +       struct obj_cgroup *objcg;
> > +
> > +       if (memcg_kmem_bypass())
> > +               return NULL;
> > +
> > +       rcu_read_lock();
> > +       objcg = __get_obj_cgroup_from_memcg(memcg);
> > +       rcu_read_unlock();
> > +       return objcg;
> > +}
> > +
> > +struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp)
>
> Since this function is exposed to other files, it would be nice to
> have a comment similar to get_mem_cgroup_from_mm() for this function.
> I know other get_obj_cgroup variants do not have such a comment yet
> but let's start with this.
>

Sure, I will add it.

> > +{
> > +       struct cgroup_subsys_state *css;
> > +       struct mem_cgroup *memcg;
> > +       struct obj_cgroup *objcg;
> > +
> > +       rcu_read_lock();
> > +       css = rcu_dereference(cgrp->subsys[memory_cgrp_id]);
> > +       if (!css || !css_tryget_online(css)) {
>
> Any reason to use css_tryget_online() instead of css_tryget()?

Because in this case, the cgroup is from an opened cgroup dir, which
should be online.
But considering this is a generic helper, which may be used by others,
it would be more reasonable to use css_tryget().
I will change it.

-- 
Regards
Yafang
