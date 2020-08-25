Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB35252429
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 01:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgHYX1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 19:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgHYX1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 19:27:23 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09B9C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:27:22 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id h19so176709ljg.13
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4aOowIVQKsAzoG/P7qB+XM1QLU3nXt4GRb8Wo9/pT9s=;
        b=MivpLulGK4Df48K69jSdRc8nfiLb1OWc2/wR1DW9HP1UG9qr6eck3TpeDaRdIaIjdG
         rxm5jZM11EHi+oItPdIngPTflqJTW525HxxUOW32sq5Gory52QXBrrZD+9XtLvW2iAQy
         6IlL8dhtXq8YuUQhq57cX2xfGeb+y7uEVCIGil0nToLklCaDAbCqy1RMsFiLN0B0qYK1
         uk9yDHbHzMTVF8FdqTUhmw5BWyLbgq5Bsa6Hrwi5mcRMCo8mBoeOAqeWHfKqU8P/tyS1
         IVYPdEA4R1k0Yj70tBH82ddD4ZTizX6+qLjNd4E2c/qlhsZDbLCznDNPJD/e4ZHNU/fq
         nDYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4aOowIVQKsAzoG/P7qB+XM1QLU3nXt4GRb8Wo9/pT9s=;
        b=IaUcjVLHc4/MnDTOlj8+BoqlIrLqdjeh3iuloW5J7yC6AwBko+ONGbBWLbRSNECQgN
         L/QcytAe8ssVxx5CaaDASZpGVIv+Dee12pVglXXYKPeGoGdNBkaifrbpSdR8PaDZblXk
         lkS/99zLf+W1zORoZQp/+Aj1sYgkqVM7Rsq6L0iGpOX5GIuLV0eXP3spbRekNy1Zd3ft
         WBlhJLj6FugYNwGjKpRpxZ85pcgpiEUrMCW97tQAFXYyVFod8gvDIZeVzdl6RvM7cQQh
         wBp6HzVxpXAbZkxfZZe8rG9WSUOirsVJb+XNKLsTTH+hLBv7iAHJkR84j8vMXcR14hIr
         7Hpw==
X-Gm-Message-State: AOAM532kVsPvZ/vTkJbwVkXA4cN48Q3pxzvLTxuPl+DDLu3RSZO1O0Je
        GAG0pDkfVnqE3jvjGRRkJy8H5dU13DFvd3PVRWH5Jg==
X-Google-Smtp-Source: ABdhPJwOL01yVem6yxTF35XI/WnXhkpj83kmMggS8kPiQlIzw7frhGlHAbXcxnwtMKqkWQ2mxYEgWoZt/di+VkJ6PAs=
X-Received: by 2002:a2e:5d8:: with SMTP id 207mr5279398ljf.58.1598398040350;
 Tue, 25 Aug 2020 16:27:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200821150134.2581465-1-guro@fb.com> <20200821150134.2581465-4-guro@fb.com>
In-Reply-To: <20200821150134.2581465-4-guro@fb.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Tue, 25 Aug 2020 16:27:09 -0700
Message-ID: <CALvZod70cywN0-HCXUPfyLN1vQdOBb46uCRk5E3NkOTDeWcEtg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 03/30] bpf: memcg-based memory accounting for
 bpf maps
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 8:01 AM Roman Gushchin <guro@fb.com> wrote:
>
> This patch enables memcg-based memory accounting for memory allocated
> by __bpf_map_area_alloc(), which is used by most map types for
> large allocations.
>
> If a map is updated from an interrupt context, and the update
> results in memory allocation, the memory cgroup can't be determined
> from the context of the current process. To address this case,
> bpf map preserves a pointer to the memory cgroup of the process,
> which created the map. This memory cgroup is charged for allocations
> from interrupt context.
>
> Following patches in the series will refine the accounting for
> some map types.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>
> ---
>  include/linux/bpf.h  |  4 ++++
>  kernel/bpf/helpers.c | 37 ++++++++++++++++++++++++++++++++++++-
>  kernel/bpf/syscall.c | 27 ++++++++++++++++++++++++++-
>  3 files changed, 66 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index a9b7185a6b37..b5f178afde94 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -34,6 +34,7 @@ struct btf_type;
>  struct exception_table_entry;
>  struct seq_operations;
>  struct bpf_iter_aux_info;
> +struct mem_cgroup;
>
>  extern struct idr btf_idr;
>  extern spinlock_t btf_idr_lock;
> @@ -138,6 +139,9 @@ struct bpf_map {
>         u32 btf_value_type_id;
>         struct btf *btf;
>         struct bpf_map_memory memory;
> +#ifdef CONFIG_MEMCG_KMEM
> +       struct mem_cgroup *memcg;
> +#endif
>         char name[BPF_OBJ_NAME_LEN];
>         u32 btf_vmlinux_value_type_id;
>         bool bypass_spec_v1;
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index be43ab3e619f..f8ce7bc7003f 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -14,6 +14,7 @@
>  #include <linux/jiffies.h>
>  #include <linux/pid_namespace.h>
>  #include <linux/proc_ns.h>
> +#include <linux/sched/mm.h>
>
>  #include "../../lib/kstrtox.h"
>
> @@ -41,11 +42,45 @@ const struct bpf_func_proto bpf_map_lookup_elem_proto = {
>         .arg2_type      = ARG_PTR_TO_MAP_KEY,
>  };
>
> +#ifdef CONFIG_MEMCG_KMEM
> +static __always_inline int __bpf_map_update_elem(struct bpf_map *map, void *key,
> +                                                void *value, u64 flags)
> +{
> +       struct mem_cgroup *old_memcg;
> +       bool in_interrupt;
> +       int ret;
> +
> +       /*
> +        * If update from an interrupt context results in a memory allocation,
> +        * the memory cgroup to charge can't be determined from the context
> +        * of the current task. Instead, we charge the memory cgroup, which
> +        * contained a process created the map.
> +        */
> +       in_interrupt = in_interrupt();
> +       if (in_interrupt)
> +               old_memcg = memalloc_use_memcg(map->memcg);
> +

The memcg_kmem_bypass() will bypass all __GFP_ACCOUNT allocations even
before looking at current->active_memcg, so, this patch will be a
noop.

> +       ret = map->ops->map_update_elem(map, key, value, flags);
> +
> +       if (in_interrupt)
> +               memalloc_use_memcg(old_memcg);
> +
> +       return ret;
> +}
> +#else
> +static __always_inline int __bpf_map_update_elem(struct bpf_map *map, void *key,
> +                                                void *value, u64 flags)
> +{
> +       return map->ops->map_update_elem(map, key, value, flags);
> +}
> +#endif
> +
>  BPF_CALL_4(bpf_map_update_elem, struct bpf_map *, map, void *, key,
>            void *, value, u64, flags)
>  {
>         WARN_ON_ONCE(!rcu_read_lock_held());
> -       return map->ops->map_update_elem(map, key, value, flags);
> +
> +       return __bpf_map_update_elem(map, key, value, flags);
>  }
>
>  const struct bpf_func_proto bpf_map_update_elem_proto = {
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 689d736b6904..683614c17a95 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -29,6 +29,7 @@
>  #include <linux/bpf_lsm.h>
>  #include <linux/poll.h>
>  #include <linux/bpf-netns.h>
> +#include <linux/memcontrol.h>
>
>  #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
>                           (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
> @@ -275,7 +276,7 @@ static void *__bpf_map_area_alloc(u64 size, int numa_node, bool mmapable)
>          * __GFP_RETRY_MAYFAIL to avoid such situations.
>          */
>
> -       const gfp_t gfp = __GFP_NOWARN | __GFP_ZERO;
> +       const gfp_t gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_ACCOUNT;
>         unsigned int flags = 0;
>         unsigned long align = 1;
>         void *area;
> @@ -452,6 +453,27 @@ void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock)
>                 __release(&map_idr_lock);
>  }
>
> +#ifdef CONFIG_MEMCG_KMEM
> +static void bpf_map_save_memcg(struct bpf_map *map)
> +{
> +       map->memcg = get_mem_cgroup_from_mm(current->mm);
> +}
> +
> +static void bpf_map_release_memcg(struct bpf_map *map)
> +{
> +       mem_cgroup_put(map->memcg);
> +}
> +
> +#else
> +static void bpf_map_save_memcg(struct bpf_map *map)
> +{
> +}
> +
> +static void bpf_map_release_memcg(struct bpf_map *map)
> +{
> +}
> +#endif
> +
>  /* called from workqueue */
>  static void bpf_map_free_deferred(struct work_struct *work)
>  {
> @@ -463,6 +485,7 @@ static void bpf_map_free_deferred(struct work_struct *work)
>         /* implementation dependent freeing */
>         map->ops->map_free(map);
>         bpf_map_charge_finish(&mem);
> +       bpf_map_release_memcg(map);
>  }
>
>  static void bpf_map_put_uref(struct bpf_map *map)
> @@ -869,6 +892,8 @@ static int map_create(union bpf_attr *attr)
>         if (err)
>                 goto free_map_sec;
>
> +       bpf_map_save_memcg(map);
> +
>         err = bpf_map_new_fd(map, f_flags);
>         if (err < 0) {
>                 /* failed to allocate fd.
> --
> 2.26.2
>
