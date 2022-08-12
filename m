Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858CC591476
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 18:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbiHLQ6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 12:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236184AbiHLQ6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 12:58:00 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2720B0B0B
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 09:57:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k16-20020a252410000000b006718984ef63so1145362ybk.3
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 09:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=R06lrdYIFgbYGZQBaMs5Tz+QLWy1uP4VRkuAR/ckZ+8=;
        b=n0KhhCoQu6+2K3yOqGNXdch+D7V/Ekevc0fxste8wMmkb/8TnpmAihLvGSc0h1JtTd
         EwOFd05EA2wEgAJJDxWuWP5Z7BT1V8+1XAGlKTK4GwzcPc4DVz3UcYP/ifg9/fkZOf6J
         Xef4us85cJv9lI9o/D4w0JcMWY0vro6AXCpzcNhQCZha2oEUMZKyH7osWxxBFHaqZfFI
         cKvz3GaE+lku7a6/CLOHGohAA5rgahXSQs2PV6OG5eaMz7kE2gDKIXOYiN4FcshygkIf
         susCJqBwnuX+JZEl4tAvq0mimSVUrmysEY4GP8JEcPKix7AIF0OPcbgX86u/sTGQeLt9
         i4OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=R06lrdYIFgbYGZQBaMs5Tz+QLWy1uP4VRkuAR/ckZ+8=;
        b=pS+1wzZ/wFQS6+KvWRb0rWw5Z8s9W2nXblgmo2qcKKoUO1V8dqeBWp92+LWQAUOpbm
         RK1pqpMzkrBgXY+g2KMZKydwQtK1Fc4twyOVMR7EH2kg/EkLUlyERt+WJ7OH4Epr4hl9
         LJaRh9wxUTOU0xUmmrb+bzmVvYf+YD2TU+78Gfm017n25eE/XjmJfIfPeaUU3aaYTUMQ
         PutgpD0Fs/SeP7MQmMeJmVAK3MSbzAC7lhqdOql2O9ojxLDd1okh018AX+r7mUC6ZohQ
         aRLIwuVotjHU0nvYuzZ7YterT5k/lDaQyuDO1TAsDYZys0v7P9I1FvqTFvJ1uxmemWOC
         KsQQ==
X-Gm-Message-State: ACgBeo29qRvjejd33wOtF3JKBUDhv7WCqz7kzuJzq+Slx/LMlr/i5ckU
        1AkgOHlBVdbYtgoo6JYYWsAJ0oxir+8szg==
X-Google-Smtp-Source: AA6agR5eA3zKFSyDylTwjia5RJoC02zN57hFsDAYzxC+KdxlNVOXC54p8q8MygnauAQw7PY7YjFbWWcHGb2j0Q==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:28b])
 (user=shakeelb job=sendgmr) by 2002:a81:5d07:0:b0:329:8fb8:779 with SMTP id
 r7-20020a815d07000000b003298fb80779mr4720036ywb.77.1660323479019; Fri, 12 Aug
 2022 09:57:59 -0700 (PDT)
Date:   Fri, 12 Aug 2022 16:57:56 +0000
In-Reply-To: <20220810151840.16394-14-laoar.shao@gmail.com>
Message-Id: <20220812165756.dxaqy3go567prr5s@google.com>
Mime-Version: 1.0
References: <20220810151840.16394-1-laoar.shao@gmail.com> <20220810151840.16394-14-laoar.shao@gmail.com>
Subject: Re: [PATCH bpf-next 13/15] mm, memcg: Add new helper get_obj_cgroup_from_cgroup
From:   Shakeel Butt <shakeelb@google.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev,
        songmuchun@bytedance.com, akpm@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 03:18:38PM +0000, Yafang Shao wrote:
> Introduce new helper get_obj_cgroup_from_cgroup() to get obj_cgroup from
> a specific cgroup.

Can you please add couple of lines on why you need objcg?

> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  include/linux/memcontrol.h |  1 +
>  mm/memcontrol.c            | 41 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+)
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
> index 618c366..762cffa 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2908,6 +2908,47 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
>  	return objcg;
>  }
>  
> +static struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> +{
> +	struct obj_cgroup *objcg;
> +
> +	if (memcg_kmem_bypass())
> +		return NULL;
> +
> +	rcu_read_lock();
> +	objcg = __get_obj_cgroup_from_memcg(memcg);
> +	rcu_read_unlock();
> +	return objcg;
> +}
> +
> +struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp)
> +{
> +	struct cgroup_subsys_state *css;
> +	struct mem_cgroup *memcg;
> +	struct obj_cgroup *objcg;
> +
> +	rcu_read_lock();
> +	css = rcu_dereference(cgrp->subsys[memory_cgrp_id]);
> +	if (!css || !css_tryget_online(css)) {
> +		rcu_read_unlock();
> +		cgroup_put(cgrp);
> +		return ERR_PTR(-EINVAL);
> +	}
> +	rcu_read_unlock();
> +	cgroup_put(cgrp);

The above put seems out of place and buggy.

> +
> +	memcg = mem_cgroup_from_css(css);
> +	if (!memcg) {
> +		css_put(css);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	objcg = get_obj_cgroup_from_memcg(memcg);
> +	css_put(css);
> +
> +	return objcg;
> +}
> +
>  __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
>  {
>  	struct obj_cgroup *objcg = NULL;
> -- 
> 1.8.3.1
> 
