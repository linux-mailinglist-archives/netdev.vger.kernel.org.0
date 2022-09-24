Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12495E8D4F
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 16:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbiIXOZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 10:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiIXOZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 10:25:33 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0323846C;
        Sat, 24 Sep 2022 07:25:31 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id z25so4440215lfr.2;
        Sat, 24 Sep 2022 07:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=jRKeU7D5aZgqxcjhpKNi6s8l4B1Pu/W+vLp64/SXJ2k=;
        b=UpNAHeRltGJnNUYU6IN+U1QlRe0AbcVc4toc+QBqstl7xLFBtoVNVlln1qx7x6FHxq
         rzY/D8LfF8p4hcesvrFXHhGlDSwavN4UvN0Wf7LEkbN6RSQ4f3v1Spc+hnP3SMOd28s3
         lnPp5Fie6yB/oSzot5F4zNN7C871LEqZ5grBwldPWgx3HhBMNzb+f6edYQXL1ri9oZ0S
         Go4e9VTTw0+XaHP7aG0MvZJjlbheySZtr3aSZogGWCrLGK0YX5Eeil5Dasn8Sf6dIobv
         FKQG9KNOV2QdrzCjAv9xJCHfHZdSwEXrmDHKT2LfmqnahX+L+U2ulngUzqfy0WZSoING
         bk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=jRKeU7D5aZgqxcjhpKNi6s8l4B1Pu/W+vLp64/SXJ2k=;
        b=tPpqwUndzrcOGpreC0ceRv/VfRgZwbtcnAYVrGZkDUR/i3KXtoRDueN0TyCwXwKB30
         RIpQ4+GwypnZmJXDuei3M6KvIkLAVpuydQ+t5AsJEVhsjIj76+Gz7hz+Ok3xjfMXPoiS
         Hd9d+jQ2iqEpfLRJH3pdpt1zzlhFkwRm+wclyriMPIvSmUjcs2OUK41u2y8B29KefNge
         1uKDuyQLBS7+RET+Cu3lDH8H3PnLVgDkUZl9ffMTXbtD3MtZZGRNXpPwcjCeYwYElwHj
         Xj+Qank0OJIvfKoP9Jc548DaWmbNmzUWeRX8jYsEAnRJUXjItnjZx9OlCshuvt9wr/Dl
         dQ/Q==
X-Gm-Message-State: ACrzQf2ZfhD302JVGlat297jBdmdU6tDorVVuaLagAz1dYL3QOt6CNJR
        fT+Kh54+R7geWJnXWQEmqq2xAkLoFzzJDS5htHo=
X-Google-Smtp-Source: AMsMyM5mi/XOOzWUJh5158inAtWdLBfxcxDHHgcvsLaTz0IhKhNVd6IYu367qB1zcyRs2jUK93uUOFjSKv49EhHqRbE=
X-Received: by 2002:a05:6512:2254:b0:498:f454:ec9a with SMTP id
 i20-20020a056512225400b00498f454ec9amr5457526lfu.58.1664029529792; Sat, 24
 Sep 2022 07:25:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220921170002.29557-1-laoar.shao@gmail.com> <20220921170002.29557-11-laoar.shao@gmail.com>
 <Yy53cgcwx+hTll4R@slm.duckdns.org>
In-Reply-To: <Yy53cgcwx+hTll4R@slm.duckdns.org>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 24 Sep 2022 22:24:52 +0800
Message-ID: <CALOAHbBHXALOZaqxJfpmE8KFsuwBuZ3BVpQhrtUZ=m7FFpWkVA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 10/10] bpf, memcg: Add new item bpf into memory.stat
To:     Tejun Heo <tj@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 24, 2022 at 11:20 AM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Wed, Sep 21, 2022 at 05:00:02PM +0000, Yafang Shao wrote:
> > A new item 'bpf' is introduced into memory.stat, then we can get the memory
> > consumed by bpf. Currently only the memory of bpf-map is accounted.
> > The accouting of this new item is implemented with scope-based accouting,
> > which is similar to set_active_memcg(). In this scope, the memory allocated
> > will be accounted or unaccounted to a specific item, which is specified by
> > set_active_memcg_item().
>
> Imma let memcg folks comment on the implementation. Hmm... I wonder how this
> would tie in with the BPF memory allocator Alexei is working on.
>

BPF memory allocator is already in bpf-next [1].
It uses the same way to charge bpf memory into memcg, see also
get_memcg() in the BPF memory allocator, so it has been supported in
this patchset.

[1]. https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=274052a2b0ab9f380ce22b19ff80a99b99ecb198

> > The result in cgroup v1 as follows,
> >       $ cat /sys/fs/cgroup/memory/foo/memory.stat | grep bpf
> >       bpf 109056000
> >       total_bpf 109056000
> > After the map is removed, the counter will become zero again.
> >         $ cat /sys/fs/cgroup/memory/foo/memory.stat | grep bpf
> >         bpf 0
> >         total_bpf 0
> >
> > The 'bpf' may not be 0 after the bpf-map is destroyed, because there may be
> > cached objects.
>
> What's the difference between bpf and total_bpf? Where's total_bpf
> implemented?

Ah, the total_* items are cgroup1-specific items. They also include
the descendants' memory.
This patchset supports both cgroup1 and cgroup2.

> It doesn't seem to be anywhere. Please also update
> Documentation/admin-guide/cgroup-v2.rst.
>

Sure, I will update the Document.

> > Note that there's no kmemcg in root memory cgroup, so the item 'bpf' will
> > be always 0 in root memory cgroup. If a bpf-map is charged into root memcg
> > directly, its memory size will not be accounted, so the 'total_bpf' can't
> > be used to monitor system-wide bpf memory consumption yet.
>
> So, system-level accounting is usually handled separately as it's most
> likely that we'd want the same stat at the system level even when cgroup is
> not implemented. Here, too, it'd make sense to first implement system level
> bpf memory usage accounting, expose that through /proc/meminfo and then use
> the same source for root level cgroup stat.
>

Sure, I will do it first. Thanks for your suggestion.

-- 
Regards
Yafang
