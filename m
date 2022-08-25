Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDD85A1A2D
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243585AbiHYUSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243738AbiHYUSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:18:40 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76916C00E4;
        Thu, 25 Aug 2022 13:18:38 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id y3so15321371ejc.1;
        Thu, 25 Aug 2022 13:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=/wAzSpEar0tnjz3cYUT0PFrSua+S+lk5KgYTwyq9c6E=;
        b=M/xQKVhP0x1VvdlzwWLO1uakI0BYZ8J+0hmZzlYfwi80I+n9VbfCt2zquJj30Hmhsp
         Kt5rK5BkTILh4Xjj8RxthAMZNweQtye2NkI1iK5YM0JCbVPfdo7NNwRggerCsG9UlPpu
         cP6Dip7DYfGrN5+eHRrgrxw4O+rfL0uecdVvNDaW71ZRL8XDUvyy7OOVHriG0p22MgA6
         7HdrjwFc20NHsvTb1VNmmvQO2j39UwRT0mMFPggzd5DrP0Gtg2dgSDUbbPUjWovERs6u
         QVFuZVkPfVdX64Xzu1wgVca/6vslsSfZCD0FPpswcYsoUo+D7gM+2X1hy4m6R+KSvmw2
         6zMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=/wAzSpEar0tnjz3cYUT0PFrSua+S+lk5KgYTwyq9c6E=;
        b=VlzFtzxaV64/+Up2eXhdRXXLFITLjaK6qx29Ecxc5/+VDttE6m3J+vxKm82GU68dJq
         5qEJ+YIFtWx+N1FGLQux0rZH8dthYXnwG18o0QUrmscHztzIB2S2xbFlPdBRI1gjvq1b
         Tp6de71ShInuGbsTvD0WM32BSGwFseKc012gGmOrYjooHrsync5ArWirqSVm8llItLrj
         Plv4Pdcerz+gac4VN23JlwWHhmisKeirkJkXaBP7RJqwHBK3NH4OKqN58NpHL5fqFi5e
         xU6t01yoETYkS8EYzmFIWPVJ8RkTu73xSGmeEI5hzbO/ggcoGQLNVo96yE1iKkZ8s9+E
         gVgQ==
X-Gm-Message-State: ACgBeo2kp7vHmASmQmDBsigJ+Du7simUjRQeLjNc9p/R8/1cO8azAcEi
        H1dtESXrcF7gqk80djGmY3CNr2ErDLOgKAjlJkc=
X-Google-Smtp-Source: AA6agR6qceS4wWeX/ryTaNZ0OPbdIzfxJV6aztyc0sDTWig5qzQIXRQpzSJOCsrrPiejEcv1DjzMaM+nNSafWlt7aW0=
X-Received: by 2002:a17:907:2bdb:b0:73d:d7af:c133 with SMTP id
 gv27-20020a1709072bdb00b0073dd7afc133mr2245999ejc.545.1661458716960; Thu, 25
 Aug 2022 13:18:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220824030031.1013441-1-haoluo@google.com> <20220824030031.1013441-2-haoluo@google.com>
In-Reply-To: <20220824030031.1013441-2-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 25 Aug 2022 13:18:25 -0700
Message-ID: <CAEf4BzYfA5uzSVsRXJXKnUQFSD1Wmk29VPge-iEO+Los3e2VOg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 1/5] bpf: Introduce cgroup iter
To:     Hao Luo <haoluo@google.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>, Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
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

On Tue, Aug 23, 2022 at 8:01 PM Hao Luo <haoluo@google.com> wrote:
>
> Cgroup_iter is a type of bpf_iter. It walks over cgroups in four modes:
>
>  - walking a cgroup's descendants in pre-order.
>  - walking a cgroup's descendants in post-order.
>  - walking a cgroup's ancestors.
>  - process only the given cgroup.
>
> When attaching cgroup_iter, one can set a cgroup to the iter_link
> created from attaching. This cgroup is passed as a file descriptor
> or cgroup id and serves as the starting point of the walk. If no
> cgroup is specified, the starting point will be the root cgroup v2.
>
> For walking descendants, one can specify the order: either pre-order or
> post-order. For walking ancestors, the walk starts at the specified
> cgroup and ends at the root.
>
> One can also terminate the walk early by returning 1 from the iter
> program.
>
> Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> program is called with cgroup_mutex held.
>
> Currently only one session is supported, which means, depending on the
> volume of data bpf program intends to send to user space, the number
> of cgroups that can be walked is limited. For example, given the current
> buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> cgroup, assuming PAGE_SIZE is 4kb, the total number of cgroups that can
> be walked is 512. This is a limitation of cgroup_iter. If the output
> data is larger than the kernel buffer size, after all data in the
> kernel buffer is consumed by user space, the subsequent read() syscall
> will signal EOPNOTSUPP. In order to work around, the user may have to
> update their program to reduce the volume of data sent to output. For
> example, skip some uninteresting cgroups. In future, we may extend
> bpf_iter flags to allow customizing buffer size.
>
> Acked-by: Yonghong Song <yhs@fb.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>  include/linux/bpf.h                           |   8 +
>  include/uapi/linux/bpf.h                      |  30 ++
>  kernel/bpf/Makefile                           |   3 +
>  kernel/bpf/cgroup_iter.c                      | 284 ++++++++++++++++++
>  tools/include/uapi/linux/bpf.h                |  30 ++
>  .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
>  6 files changed, 357 insertions(+), 2 deletions(-)
>  create mode 100644 kernel/bpf/cgroup_iter.c
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 39bd36359c1e..dc9bf5e95ebf 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -48,6 +48,7 @@ struct mem_cgroup;
>  struct module;
>  struct bpf_func_state;
>  struct ftrace_ops;
> +struct cgroup;
>
>  extern struct idr btf_idr;
>  extern spinlock_t btf_idr_lock;
> @@ -1730,7 +1731,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
>         int __init bpf_iter_ ## target(args) { return 0; }
>
>  struct bpf_iter_aux_info {
> +       /* for map_elem iter */
>         struct bpf_map *map;
> +
> +       /* for cgroup iter */
> +       struct {
> +               struct cgroup *start; /* starting cgroup */
> +               enum bpf_cgroup_iter_order order;
> +       } cgroup;
>  };
>
>  typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 934a2a8beb87..1c4e1c583880 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -87,10 +87,29 @@ struct bpf_cgroup_storage_key {
>         __u32   attach_type;            /* program attach type (enum bpf_attach_type) */
>  };
>
> +enum bpf_cgroup_iter_order {
> +       BPF_ITER_ORDER_UNSPEC = 0,
> +       BPF_ITER_SELF_ONLY,             /* process only a single object. */
> +       BPF_ITER_DESCENDANTS_PRE,       /* walk descendants in pre-order. */
> +       BPF_ITER_DESCENDANTS_POST,      /* walk descendants in post-order. */
> +       BPF_ITER_ANCESTORS_UP,          /* walk ancestors upward. */
> +};

just skimming through this, I noticed that we have "enum
bpf_cgroup_iter_order" (good, I like) but BPF_ITER_xxx with no CGROUP
part in it (not good, don't like :). All the enumerator names have
global visibility, so it would probably be best for them to be
CGROUP-specific and roughly match the enum name itself:
BPF_CGROUP_ITER_SELF_ONLY, etc?

> +
>  union bpf_iter_link_info {
>         struct {
>                 __u32   map_fd;
>         } map;
> +       struct {
> +               enum bpf_cgroup_iter_order order;
> +
> +               /* At most one of cgroup_fd and cgroup_id can be non-zero. If
> +                * both are zero, the walk starts from the default cgroup v2
> +                * root. For walking v1 hierarchy, one should always explicitly
> +                * specify cgroup_fd.
> +                */
> +               __u32   cgroup_fd;
> +               __u64   cgroup_id;
> +       } cgroup;
>  };

[...]
