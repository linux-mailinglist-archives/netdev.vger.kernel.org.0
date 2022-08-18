Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA39598E2B
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344916AbiHRUjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242745AbiHRUi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:38:58 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C68ECAC91
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 13:38:56 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id c24so2149413pgg.11
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 13:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Vo2GoUiFJBInyE5nywoyw7Q4fF2jDGsYcZyTxVixXAU=;
        b=ktky7FG85SxQIN4nGPoPElDkKx88mLw3wSOhoBHn8jWxmqe2yK7ncp+Bvvmn3V1grt
         xycIcVChwKblGXinRAJLXpbtxlEjIKSqD/gfD7MXe5l/OKOsrowL6Ss2Uil39tMwNijq
         h8C6FsiCfRg6+Ich5pcuI9uenN/PdX8W/zx6Vu0QeCmi7mLqOD1N1DKpQufzqdkfYgr/
         3RDPWbSm3132FBjqfq4UABa0uRjMtIfp6x59xTSFr4oMmeviIFqtsfyCJWBgTDXycx+9
         CczUWh9fST9eB10UZP8a+azRrx7Xe87VKBrQmCRd6EqAJ67mifIYmVGbG5/P+gfvMjci
         Fm1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Vo2GoUiFJBInyE5nywoyw7Q4fF2jDGsYcZyTxVixXAU=;
        b=2xldC9O1J8Na7+f6Myu+6hVwMQVw8n3dF90P+BBjO7JX/x4CXTHhWcPWvcw3kbkt/O
         3kZnqObaybpIrsj8G38jpxJVkVvX4eNL7loAjG8ky7Nf3t0VetlByWR9ypJZ7VMge4XZ
         N/NDMK4KksoR9lhAytqYcdPUENpyWW4kEuZULmF4kr7T9LEVU9CG7NGmk3RJELqAaz/g
         Y2wQgKqILcbBvwJ8vfVbSH/TmNr2HV+zvptjdm0nzcyqV490pcL0Gj26PY3wvmHxNHE2
         KbB6tpE7hFS6gnJqO+Hicwrw+Rg8jFDj9DL1Jbaz6lucLNhs4/P+zy1EOH+7ONxLLLBt
         KNZQ==
X-Gm-Message-State: ACgBeo2OVGuaaY+vEq95+Nf0m+xDXFzmt7/Z8mCZRfGXfF3ClrZIFCBx
        LeyyQg5uDNV0MJLx9eLND8LK/suu7ZpFN5/1FLMr8Q==
X-Google-Smtp-Source: AA6agR4dwGmH7QSsDsC7mKd8PkI8InMbAr1OecRWQCqs1PDnSEI/ToevnauSqWVcuaAWqSQa2jJ3U7ZSQt1lvDyFpGc=
X-Received: by 2002:a63:5f8e:0:b0:429:c286:4ef7 with SMTP id
 t136-20020a635f8e000000b00429c2864ef7mr3579505pgb.166.1660855135926; Thu, 18
 Aug 2022 13:38:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220818143118.17733-1-laoar.shao@gmail.com> <20220818143118.17733-11-laoar.shao@gmail.com>
In-Reply-To: <20220818143118.17733-11-laoar.shao@gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 18 Aug 2022 13:38:44 -0700
Message-ID: <CALvZod5GMSiGv9OEhwJfSdXi9B=O-4Nq011pPjNEGf_vDTzhfg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 10/12] mm, memcg: Add new helper get_obj_cgroup_from_cgroup
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 7:32 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> We want to open a cgroup directory and pass the fd into kernel, and then
> in the kernel we can charge the allocated memory into the open cgroup if it
> has valid memory subsystem. In the bpf subsystem, the opened cgroup will
> be store as a struct obj_cgroup pointer, so a new helper
> get_obj_cgroup_from_cgroup() is introduced.
>
> It also add a comment on why the helper  __get_obj_cgroup_from_memcg()
> must be protected by rcu read lock.
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  include/linux/memcontrol.h |  1 +
>  mm/memcontrol.c            | 47 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 48 insertions(+)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 2f0a611..901a921 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1713,6 +1713,7 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
>  int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
>  void __memcg_kmem_uncharge_page(struct page *page, int order);
>
> +struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp);
>  struct obj_cgroup *get_obj_cgroup_from_current(void);
>  struct obj_cgroup *get_obj_cgroup_from_page(struct page *page);
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 618c366..0409cc4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2895,6 +2895,14 @@ struct mem_cgroup *mem_cgroup_from_obj(void *p)
>         return page_memcg_check(folio_page(folio, 0));
>  }
>
> +/*
> + * Pls. note that the memg->objcg can be freed after it is deferenced,
> + * that can happen when the memcg is changed from online to offline.
> + * So this helper must be protected by read rcu lock.
> + *
> + * After obj_cgroup_tryget(), it is safe to use the objcg outside of the rcu
> + * read-side critical section.
> + */

The comment is too verbose. My suggestion would be to add
WARN_ON_ONCE(!rcu_read_lock_held()) in the function and if you want to
add a comment, just say that the caller should have a reference on
memcg.

>  static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
>  {
>         struct obj_cgroup *objcg = NULL;
> @@ -2908,6 +2916,45 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
>         return objcg;
>  }
>
> +static struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> +{
> +       struct obj_cgroup *objcg;
> +
> +       if (memcg_kmem_bypass())
> +               return NULL;
> +
> +       rcu_read_lock();
> +       objcg = __get_obj_cgroup_from_memcg(memcg);
> +       rcu_read_unlock();
> +       return objcg;
> +}
> +
> +struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp)

Since this function is exposed to other files, it would be nice to
have a comment similar to get_mem_cgroup_from_mm() for this function.
I know other get_obj_cgroup variants do not have such a comment yet
but let's start with this.

> +{
> +       struct cgroup_subsys_state *css;
> +       struct mem_cgroup *memcg;
> +       struct obj_cgroup *objcg;
> +
> +       rcu_read_lock();
> +       css = rcu_dereference(cgrp->subsys[memory_cgrp_id]);
> +       if (!css || !css_tryget_online(css)) {

Any reason to use css_tryget_online() instead of css_tryget()?
