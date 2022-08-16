Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCBC5953EE
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbiHPHf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiHPHey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:34:54 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F5D13E980;
        Mon, 15 Aug 2022 21:17:22 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id fy5so16778431ejc.3;
        Mon, 15 Aug 2022 21:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=j/gGIYHVvGXD1yDEp46mElKYaYYPTYLmXjRKXScf7hY=;
        b=VNUa8f0PEtm55xS3sXA1K8l77VMtcbnvYrI2gLVUGAt4pR2iZK0FqWrxO6A/c7VLog
         mPNy+vUcwyoF/j7hNHJ9J9dyAsVHZMf1qa+C3oXPOuR3Yv8QEK2pYWex27VgW3f326n8
         52LdK4pl/jK14F/2eJo/SjdWz1uhtNFgJtmm/wD3YTHUcI+nJmAZ4jLw4rsfAcMrcYry
         L1DZ40JETewL88nD23C6xxL2BaXI5MMBf5bzOGLi9tSxfEKSU/yB2ZTdZ0RR7RdUTqYQ
         I5kiXHvQXwmqzdq5ol9LFZnqxaIHntzerAsgcSoLDk3/ikf96lr5DrHI1DV2RTAUUNVA
         tWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=j/gGIYHVvGXD1yDEp46mElKYaYYPTYLmXjRKXScf7hY=;
        b=bTHj0RvbHp2dryS1QnVMy2cE6SOg7mNpbnwbBp8m6YZvVHk9tC7gXaJq7DvVcYVPn5
         P+jNkM5Cbe/+1nv2e3FQY+3nuoRI+QfsgeRkEK0KwFUXRcX2vfki1UVmfvkZ900oI9a/
         qME+a3nlguyMGS/TCyl6G8+emnOx3VW/0QUXlMhFMK5mwfwQGqGp5jzJhUFhORTPDVyA
         furycWjG0ZHOh5SyuVASxOUj8UxNTHouupSButI5SDrWreovBy1GXMSPMBW6D1/xQZ/X
         FC7XNtqFFVyzUvKbpCVxiKJy+BmTBtjOiJEggxNaanumVQCoKcHt2slXacMyPT2l36gR
         71DA==
X-Gm-Message-State: ACgBeo3tLStL/i0iK3CJtOItqKEFf9aYPaCMSgmfa21pB9hyVkEdGUsN
        0OfXjex0OgkXPefx/b1KJTlRA49/3SG1MWfUbjE=
X-Google-Smtp-Source: AA6agR4Pc7RTOfp1eRXZAZ9HubHNje1ReGflkyRL5oIA20j6Ou5SpIhoPv5ZRBuWmw0GfKAvQlZ1aKs/Qf74Gv7izGE=
X-Received: by 2002:a17:907:6e22:b0:731:152:2504 with SMTP id
 sd34-20020a1709076e2200b0073101522504mr12582106ejc.545.1660623440628; Mon, 15
 Aug 2022 21:17:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220812202802.3774257-1-haoluo@google.com> <20220812202802.3774257-2-haoluo@google.com>
In-Reply-To: <20220812202802.3774257-2-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Aug 2022 21:17:09 -0700
Message-ID: <CAEf4BzbuD+vLzxVkXpiX=yKu2WbHLrekrZS8hx2TWU04m0h-kA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 1/5] bpf: Introduce cgroup iter
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
        Michal Koutny <mkoutny@suse.com>,
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

On Fri, Aug 12, 2022 at 1:28 PM Hao Luo <haoluo@google.com> wrote:
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
>  include/uapi/linux/bpf.h                      |  35 +++
>  kernel/bpf/Makefile                           |   3 +
>  kernel/bpf/cgroup_iter.c                      | 283 ++++++++++++++++++
>  tools/include/uapi/linux/bpf.h                |  35 +++
>  .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
>  6 files changed, 366 insertions(+), 2 deletions(-)
>  create mode 100644 kernel/bpf/cgroup_iter.c
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index a627a02cf8ab..ecb8c61178a1 100644
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
> +               int order;

why not using enum as a type here?

> +       } cgroup;
>  };
>
>  typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 7d1e2794d83e..bc3c901b9f70 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -87,10 +87,34 @@ struct bpf_cgroup_storage_key {
>         __u32   attach_type;            /* program attach type (enum bpf_attach_type) */
>  };
>
> +enum bpf_iter_order {
> +       BPF_ITER_DESCENDANTS_PRE = 0,   /* walk descendants in pre-order. */
> +       BPF_ITER_DESCENDANTS_POST,      /* walk descendants in post-order. */
> +       BPF_ITER_ANCESTORS_UP,          /* walk ancestors upward. */
> +       BPF_ITER_SELF_ONLY,             /* process only a single object. */
> +};
> +
>  union bpf_iter_link_info {
>         struct {
>                 __u32   map_fd;
>         } map;
> +       struct {
> +               /* Users must specify order using one of the following values:
> +                *  - BPF_ITER_DESCENDANTS_PRE
> +                *  - BPF_ITER_DESCENDANTS_POST
> +                *  - BPF_ITER_ANCESTORS_UP
> +                *  - BPF_ITER_SELF_ONLY
> +                */
> +               __u32   order;

same, we just declared the UAPI enum above, why not specify that this
is that enum here?

> +
> +               /* At most one of cgroup_fd and cgroup_id can be non-zero. If
> +                * both are zero, the walk starts from the default cgroup v2
> +                * root. For walking v1 hierarchy, one should always explicitly
> +                * specify cgroup_fd.
> +                */
> +               __u32   cgroup_fd;
> +               __u64   cgroup_id;

for my own education, does root cgroup has cgroup_id == 0?

> +       } cgroup;
>  };
>

[...]
