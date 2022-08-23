Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3316C59EB5F
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 20:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbiHWSsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 14:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbiHWSr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 14:47:58 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CB911987D;
        Tue, 23 Aug 2022 10:12:08 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id w13so7742194pgq.7;
        Tue, 23 Aug 2022 10:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=0dpf/dFnqvSQXULZAry29j8dtTwD0KWxL5BSj6ts5Eg=;
        b=jPA0pd6oBq/PlYVNpLQ9tMeqI8Cl/RJ/N4NznoWBcbRKYwoxkVxka1Sk0FPVwrEnYI
         /GyffhqFtgl2rq2elMxo4z7MCqh06Fg1Altta7JAOjfvoRvA7SSFCSrKDM1wGwV+g8XU
         bgULlxeBQvY5EcitXG3qWm8yQF8lZEJ5BT9gLQyMylaZSMD4ZeBs+Xe9tix31zKKLisN
         AqhRdPNbVN3cUBI75KK7sswjahStF79rglUYO1N6liKUCQqGNEf3oLBDGg3z+doG33+x
         lkAtTf8jByCkCVMtUS46l3gTKafDUPsim16HzhcHYjSk74ngCm35DzpOKaGeL1MWJYWQ
         WhyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=0dpf/dFnqvSQXULZAry29j8dtTwD0KWxL5BSj6ts5Eg=;
        b=rhttXXmNKab+GkyuK0TQ+OZz5AQeTJ65fZiMcfO60m4iclYpXgO+J8HWWYEU/wpKUN
         XCkrNjD4+2sLmqXbVORf1unYqE+OULLpXvV2nRl0LsMCq3cn2k05nuIt68GvuxbT/fx3
         OwJtcNt3TKmkgD7aiZytPh+xUwO/o4OhW4ad2p9VxyyZpaO3G2LdISG9FrPWjBN6LeK5
         wf5oy/RGxtj1EZbzD+FmeIFHAJoxylUVJ0XxGl52BnVUGxTgAUXqdnfRY+TLhSKZEYax
         +hYORI1NFrj9+aM05eTMEJ4lZLxKe2YN27l/tHJ3S4oAT0SqzgAB7M4BwCsnEmLo60Jt
         nO5g==
X-Gm-Message-State: ACgBeo03TPtUUqdQh1PNP4pUQNR3ENG92TmYwFbap6fuVrlo5ZFuAktn
        Q4tBXZwli9Oz7ZDQ16vvGJQ=
X-Google-Smtp-Source: AA6agR7wA709oFtQr9hdf8uPUHazGF3ozzzdNXJhU9DXJWsUBfdMhreZ5l/XmDnWA2ec1x+YCyrhJw==
X-Received: by 2002:a65:6949:0:b0:41c:cb9d:3d1f with SMTP id w9-20020a656949000000b0041ccb9d3d1fmr21233337pgq.334.1661274727099;
        Tue, 23 Aug 2022 10:12:07 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id o4-20020a63e344000000b0041d6d37deb5sm9502946pgj.81.2022.08.23.10.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 10:12:06 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 23 Aug 2022 07:12:05 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yafang Shao <laoar.shao@gmail.com>
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
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Yosry Ahmed <yosryahmed@google.com>,
        Dan Schatzberg <schatzberg.dan@gmail.com>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: [RFD RESEND] cgroup: Persistent memory usage tracking
Message-ID: <YwUKZWXbqzfy0w4o@slm.duckdns.org>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
 <Yv67MRQLPreR9GU5@slm.duckdns.org>
 <Yv6+HlEzpNy8y5kT@slm.duckdns.org>
 <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA@mail.gmail.com>
 <Yv/DK+AGlMeBGkF1@slm.duckdns.org>
 <CALOAHbCvUxQn5Zkp2FJ+eL1VgjeRSq1xQhzdiY87C1Cbib-nig@mail.gmail.com>
 <YwNold0GMOappUxc@slm.duckdns.org>
 <CALOAHbBTR-07La=-KPehFab0WDY4V6LovXbrhLXOqKDurHD-9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbBTR-07La=-KPehFab0WDY4V6LovXbrhLXOqKDurHD-9g@mail.gmail.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, Aug 23, 2022 at 07:08:17PM +0800, Yafang Shao wrote:
> On Mon, Aug 22, 2022 at 7:29 PM Tejun Heo <tj@kernel.org> wrote:
> > [1] Can this be solved by layering the instance cgroups under persistent
> >     entity cgroup?
>
> Below is some background of kubernetes.
> In kubernetes, a pod is organized as follows,
> 
>                pod
>                |- Container
>                |- Container
> 
> IOW, it is a two-layer unit, or a two-layer instance.
> The cgroup dir of the pod is named with a UUID assigned by kubernetes-apiserver.
> Once the old pod is destroyed (that can happen when the user wants to
> update their service), the new pod will have a different UUID.
> That said, different instances will have different cgroup dir.
> 
> If we want to introduce a  persistent entity cgroup, we have to make
> it a three-layer unit.
> 
>            persistent-entity
>            |- pod
>                  |- Container
>                  |- Container
> 
> There will be some issues,
> 1.  The kuber-apiserver must maintain the persistent-entity on each host.
>      It needs a great refactor and the compatibility is also a problem
> per my discussion with kubernetes experts.

This is gonna be true for anybody. The basic strategy here should be
defining a clear boundary between system agent and applications so that
individual applications, even when they build their own subhierarchy
internally, aren't affected by system level hierarchy configuration changes.
systemd is already like that with clear delegation boundary. Our (fb)
container management is like that too. So, while this requires some
reorganization from the agent side, things like this don't create huge
backward compatbility issues involving applications. I have no idea about
k8s, so the situation may differ but in the long term at least, it'd be a
good idea to build in similar conceptual separation even if it stays with
cgroup1.

> 2.  How to do the monitor?
>      If there's only one pod under this persistent-entity, we can
> easily get the memory size of  shared resources by:
>          Sizeof(shared-resources) = Sizeof(persistent-entity) - Sizeof(pod)
>     But what if it has N pods and N is dynamically changed ?

There should only be one live pod instance inside the pod's persistent
cgroup, so the calculation doesn't really change.

> 3.  What if it has more than one shared resource?
>      For example, pod-foo has two shared resources A and B, pod-bar
> has two shared resources A and C, and another pod has two shared
> resources B and C.
>      How to deploy them?
>      Pls, note that we can introduce multiple-layer persistent-entity,
> but which one should be the parent ?
> 
> So from my perspective, it is almost impossible.

Yeah, this is a different problem and cgroup has never been good at tracking
resources shared across multiple groups. There is always tension between
overhead, complexity and accuracy and the tradeoff re. resource sharing has
almost always been towards the former two.

Naming specific resources and designating them as being shared and
accounting them commonly somehow does make sense as an approach as we get to
avoid the biggest headaches (e.g. how to split a page cache page?) and maybe
it can even be claimed that a lot of use cases which may want cross-group
sharing can be sufficiently served by such approach.

That said, it still has to be balanced against other factors. For example,
memory pressure caused by the shared resources should affect all
participants in the sharing group in terms of both memory and IO, which
means that they'll have to stay within a nested subtree structure. This does
restrict overlapping partial sharing that you described above but the goal
is finding a reasonable tradeoff, so something has to give.

> > b. Memory is disassociated rather than just reparented on cgroup destruction
> >    and get re-charged to the next first user. This is attractive in that it
> >    doesn't require any userspace changes; however, I'm not sure how this
> >    would work for non-pageable memory usages such as bpf maps. How would we
> >    detect the next first usage?
> >
> 
> JFYI, There is a reuse path for the bpf map, see my previous RFC[1].
> [1] https://lore.kernel.org/bpf/20220619155032.32515-1-laoar.shao@gmail.com/

I'm not a big fan of explicit recharging. It's too hairy to use requiring
mixing system level hierarchy configuration knoweldge with in-application
resource handling. There should be clear isolation between the two. This is
also what leads to namespace and visibility issues. Ideally, these should be
handled by structuring the resource hierarchay correctly from the get-go.

...
> > b. Let userspace specify which cgroup to charge for some of constructs like
> >    tmpfs and bpf maps. The key problems with this approach are
> >
> >    1. How to grant/deny what can be charged where. We must ensure that a
> >       descendant can't move charges up or across the tree without the
> >       ancestors allowing it.
> >
> 
> We can add restrictions to check which memcg can be selected
> (regarding the selectable memcg).
> But I think it may be too early to do the restrictions, as only the
> privileged user can set it.
> It is the sys admin's responsbility to select a proper memcg.
> That said, the selectable memcg is not going south.

I generally tend towards shaping interfaces more carefully. We can of course
add a do-whatever-you-want interface and declare that it's for root only but
even that becomes complicated with things like userns as we're finding out
in different areas, but again, nothing is free and approaches like that
often bring more longterm headaches than the problems they solve.

> >    2. How to specify the cgroup to charge. While specifying the target
> >       cgroup directly might seem like an obvious solution, it has a couple
> >       rather serious problems. First, if the descendant is inside a cgroup
> >       namespace, it might be able to see the target cgroup at all.
> 
> It is not a problem. Just sharing our practice below.
> $ docker run -tid --privileged    \
>                       --mount
> type=bind,source=/sys/fs/bpf,target=/sys/fs/bpf    \
>                       --mount
> type=bind,source=/sys/fs/cgroup/memory/bpf,target=/bpf-memcg    \
>                       docker-image
> 
> The bind-mount can make it work.

Not mount namespace. cgroup namespace which is used to isolate the cgroup
subtree that's visible to each container. Please take a look at
cgroup_namespaces(7).

> >  Second,
> >       it's an interface which is likely to cause misunderstandings on how it
> >       can be used. It's too broad an interface.
> >
> 
> As I said above, we just need some restrictions or guidance if that is
> desired now.

I'm really unlikely to go down that path because as I said before I believe
that that's a road to long term headaches and already creates immediate
problems in terms of how it'd interact with other resources. No matter what
approach we may choose, it has to work with the existing resource hierarchy.
Otherwise, we end up in a situation where we have to split accounting and
control of other controllers too which makes little sense for non-memory
controllers (not that it's great for memory in the first place).

Thanks.

-- 
tejun
