Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F62C58EF5E
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbiHJPX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233306AbiHJPXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:23:06 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2C0868BA;
        Wed, 10 Aug 2022 08:22:15 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id v128so15464076vsb.10;
        Wed, 10 Aug 2022 08:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=7vVjYn0qbQXlEf1XUPeTDG40okHOT4p3e3w8q34NKiM=;
        b=IHMVtxVYWinUl/RK/Fe3qGTB+k+2KIiWZPfmvetTD9XGTOPvddVQrwTnd9pJmpRFSO
         yjMh2XWdaDnH1dNFMf3/1t9+8irlDnZVY+w1Hf+QToVT5nIXMxDW16S7As7zTfIn1MUw
         B2+KcUNgEwZYaRm4UPkjCWexdMOSFnmB3wczD0zFyd4o0tNQhRTQAgd7q1vILtC+xVsN
         zMeK7//rrHEL37hEB5ewIO8OKz19Duwn3Etbr8J2Ud+wjIayD7y5wh/TzWHY/8513VuI
         fY/uXLi+Sa9rb70ayY1HI5inZofQZfwIZqxawIHIeZEctUlFB2SCatLwy3u49q+q91gl
         y/pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=7vVjYn0qbQXlEf1XUPeTDG40okHOT4p3e3w8q34NKiM=;
        b=MIiBoK//b/BCnQbZlPKZgko0OczIeZnn6+KwhLBpUXVqFfxCcWW7ckj+Lhp+KW7X/a
         KqQl1isrmWrsZtkGC9gMMPtLgHjp10oP6qKnTcDyJaboNzNPu5H9qc/P9FZ7TCPATi+3
         WQcHzrjW5cHR0l8Smj3fCykRrXTTNGcsm50Zoa5bYneY9yXGMI/pbH5nm/+wgemYZp1c
         fyaTLb4RO6LIHIaQvz/xdePeXRzWdyCDTC7DuC2QbE4jm0Umt/oZAcB4SA4K024FykJs
         r8xbKpB0Xn1fO1ODptlHpMKmkWjZCFUQaRvt4g9s0y8crUiAvAs39Ntb2SyAYCAd3sam
         gWsw==
X-Gm-Message-State: ACgBeo02fjOxGkwAO4deuUKcmVSc+dOp8DCW3dbarW8T2Cxdk2xoLPRZ
        3v7l6UdY+hggq5kBPlXBjd+AL4NUCFjeXSzGsTc=
X-Google-Smtp-Source: AA6agR4u7ldJovC+p7bFao3Dfs+soL+j9/e3rCwR+E2Llr7X3CaGbM8Eyr7fIFVj0cDY/ciKEsNSQVn07An5tF7Tmrc=
X-Received: by 2002:a05:6102:3ec1:b0:358:70a1:3c28 with SMTP id
 n1-20020a0561023ec100b0035870a13c28mr10990885vsv.11.1660144933775; Wed, 10
 Aug 2022 08:22:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220810151322.16163-1-laoar.shao@gmail.com>
In-Reply-To: <20220810151322.16163-1-laoar.shao@gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Wed, 10 Aug 2022 23:21:33 +0800
Message-ID: <CALOAHbDwNRAn3kZ_H51NFbTXL4rZpVLNaCJoM8J0nB17wgrfTg@mail.gmail.com>
Subject: Re: [PATCH 00/15] bpf: Introduce selectable memcg for bpf map
To:     Alexei Starovoitov <ast@kernel.org>,
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
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
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

On Wed, Aug 10, 2022 at 11:13 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> On our production environment, we may load, run and pin bpf programs and
> maps in containers. For example, some of our networking bpf programs and
> maps are loaded and pinned by a process running in a container on our
> k8s environment. In this container, there're also running some other
> user applications which watch the networking configurations from remote
> servers and update them on this local host, log the error events, monitor
> the traffic, and do some other stuffs. Sometimes we may need to update
> these user applications to a new release, and in this update process we
> will destroy the old container and then start a new genration. In order not
> to interrupt the bpf programs in the update process, we will pin the bpf
> programs and maps in bpffs. That is the background and use case on our
> production environment.
>
> After switching to memcg-based bpf memory accounting to limit the bpf
> memory, some unexpected issues jumped out at us.
> 1. The memory usage is not consistent between the first generation and
> new generations.
> 2. After the first generation is destroyed, the bpf memory can't be
> limited if the bpf maps are not preallocated, because they will be
> reparented.
>
> This patchset tries to resolve these issues by introducing an
> independent memcg to limit the bpf memory.
>
> In the bpf map creation, we can assign a specific memcg instead of using
> the current memcg.  That makes it flexible in containized environment.
> For example, if we want to limit the pinned bpf maps, we can use below
> hierarchy,
>
>     Shared resources              Private resources
>
>      bpf-memcg                      k8s-memcg
>      /        \                     /
> bpf-bar-memcg bpf-foo-memcg   srv-foo-memcg
>                   |               /        \
>                (charged)     (not charged) (charged)
>                   |           /              \
>                   |          /                \
>           bpf-foo-{progs, maps}              srv-foo
>
> srv-foo loads and pins bpf-foo-{progs, maps}, but they are charged to an
> independent memcg (bpf-foo-memcg) instead of srv-foo's memcg
> (srv-foo-memcg).
>
> Pls. note that there may be no process in bpf-foo-memcg, that means it
> can be rmdir-ed by root user currently. Meanwhile we don't forcefully
> destroy a memcg if it doesn't have any residents. So this hierarchy is
> acceptible.
>
> In order to make the memcg of bpf maps seletectable, this patchset
> introduces some memory allocation wrappers to allocate map related
> memory. In these wrappers, it will get the memcg from the map and then
> charge the allocated pages or objs.
>
> Currenly it only supports for bpf map, and we can extend it to bpf prog
> as well. It only supports for cgroup2 now, but we can make an additional
> change in cgroup_get_from_fd() to support it for cgroup1.
>
> The observebility can also be supported in the next step, for example,
> showing the bpf map's memcg by 'bpftool map show' or even showing which
> maps are charged to a specific memcg by 'bpftool cgroup show'.
> Furthermore, we may also show an accurate memory size of a bpf map
> instead of an estimated memory size in 'bpftool map show' in the future.
>
> RFC->v1:
> - get rid of bpf_map container wrapper (Alexei)
> - add the new field into the end of struct (Alexei)
> - get rid of BPF_F_SELECTABLE_MEMCG (Alexei)
> - save memcg in bpf_map_init_from_attr
> - introduce bpf_ringbuf_pages_{alloc,free} and keep them inside
>   kernel/bpf/ringbuf.c  (Andrii)
>
> Yafang Shao (15):
>   bpf: Remove unneeded memset in queue_stack_map creation
>   bpf: Use bpf_map_area_free instread of kvfree
>   bpf: Make __GFP_NOWARN consistent in bpf map creation
>   bpf: Use bpf_map_area_alloc consistently on bpf map creation
>   bpf: Fix incorrect mem_cgroup_put
>   bpf: Define bpf_map_{get,put}_memcg for !CONFIG_MEMCG_KMEM
>   bpf: Call bpf_map_init_from_attr() immediately after map creation
>   bpf: Save memcg in bpf_map_init_from_attr()
>   bpf: Use scoped-based charge in bpf_map_area_alloc
>   bpf: Introduce new helpers bpf_ringbuf_pages_{alloc,free}
>   bpf: Use bpf_map_kzalloc in arraymap
>   bpf: Use bpf_map_kvcalloc in bpf_local_storage
>   mm, memcg: Add new helper get_obj_cgroup_from_cgroup
>   bpf: Add return value for bpf_map_init_from_attr
>   bpf: Introduce selectable memcg for bpf map
>
>  include/linux/bpf.h            |  43 ++++++++++++-
>  include/linux/memcontrol.h     |  11 ++++
>  include/uapi/linux/bpf.h       |   1 +
>  kernel/bpf/arraymap.c          |  34 ++++++-----
>  kernel/bpf/bloom_filter.c      |  11 +++-
>  kernel/bpf/bpf_local_storage.c |  17 ++++--
>  kernel/bpf/bpf_struct_ops.c    |  19 +++---
>  kernel/bpf/cpumap.c            |  17 ++++--
>  kernel/bpf/devmap.c            |  30 ++++++----
>  kernel/bpf/hashtab.c           |  26 ++++----
>  kernel/bpf/local_storage.c     |  12 ++--
>  kernel/bpf/lpm_trie.c          |  12 +++-
>  kernel/bpf/offload.c           |  12 ++--
>  kernel/bpf/queue_stack_maps.c  |  13 ++--
>  kernel/bpf/reuseport_array.c   |  11 +++-
>  kernel/bpf/ringbuf.c           | 104 ++++++++++++++++++++++----------
>  kernel/bpf/stackmap.c          |  13 ++--
>  kernel/bpf/syscall.c           | 133 ++++++++++++++++++++++++++++-------------
>  mm/memcontrol.c                |  41 +++++++++++++
>  net/core/sock_map.c            |  30 ++++++----
>  net/xdp/xskmap.c               |  12 +++-
>  tools/include/uapi/linux/bpf.h |   1 +
>  tools/lib/bpf/bpf.c            |   3 +-
>  tools/lib/bpf/bpf.h            |   3 +-
>  tools/lib/bpf/gen_loader.c     |   2 +-
>  tools/lib/bpf/libbpf.c         |   2 +
>  tools/lib/bpf/skel_internal.h  |   2 +-
>  27 files changed, 436 insertions(+), 179 deletions(-)
>
> --
> 1.8.3.1
>

Ah, this series is incomplete.
Pls see the update one.
https://lore.kernel.org/bpf/20220810151840.16394-1-laoar.shao@gmail.com/T/#t

--
Regards
Yafang
