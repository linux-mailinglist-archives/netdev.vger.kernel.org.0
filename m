Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F5859C7CE
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 21:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237757AbiHVTDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 15:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237579AbiHVTDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:03:05 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F8321BF
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:03:00 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id 190so3973869vsz.7
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=jv+84JyfncJ9PWKscAyePDT4xWJE+JsigBsGVay/has=;
        b=Dbh+nJE/9yYILFKAZ2eV/+FIT6aPqZOp0Ds/8iUgYR9lGja15u+/YB5JRVGd5Q6zGy
         9upRxXjpV2tgND6xZCFY1/wrcNoO+tV4uuxJShYhRaEBwKevYgVijioxu+Xjh8RgBy6r
         /PEj/7gV32v+SeL7QUkO1AHknV3dYmapUJQZm/krWJDia4gxD3gQGZOA1KYCRitFKeeB
         5efHoZfxSVL3WTr3xbdYPQSPDbz2jmP04b76n7eSGZ+V1Eo/P88fz25zpeDLypaMFcsH
         X2KbnMZYOHLLKtaPteqeZ7wlH4U7M8eLqdihz+ZH0U0/MgLsg2szjHni6dVB31Of1jEJ
         6BxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=jv+84JyfncJ9PWKscAyePDT4xWJE+JsigBsGVay/has=;
        b=6PdgSi61sCAYyjnpKaJ6MscBR+WOwaoiCbOC1ly9eUDIxy09AP8SRI6QM2/maYbfhw
         K6qjpeN6iy4I43Y/jM1q+lJj+7El14+T8/awHmBXPs/7GBYAId1NVypG+us8uEzOPH7u
         ifmKw5FbdF7VmvNNTfOBPh8QgJslFU601TPt9arsTozIVJ38bOpv5xCCP0B38MSIcPNj
         wgzFuDibwdgtEo/SgqLFKTy6X9XchUhU058WMXPIAU6NKh/3bXUa3Xc0vNKGz1LB2207
         ITsPjbw53IgjsQLYxfHG4shObfcLpHaPxyVQopoNlB0KXuuTTcId3Zuksuz79PlKSdEe
         qHPw==
X-Gm-Message-State: ACgBeo03Ghp850gs36qKnbgAh85p/bCKkZzRBSv+wiklyzUp9z/C5+AP
        4+AvS+AMnPfDiJdC6FdSX59cfcwryfTxbukHUTVWhA==
X-Google-Smtp-Source: AA6agR7E9USo3A7W363RTfEtsuKc9Ih/fB2kLQbYUh5dN8ffgVHAAe2WXv05PgXnEXXyCtTVgo+IYdgg0sL3IKHTc0c=
X-Received: by 2002:a67:d483:0:b0:38f:4981:c4f3 with SMTP id
 g3-20020a67d483000000b0038f4981c4f3mr7388765vsj.59.1661194979729; Mon, 22 Aug
 2022 12:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220818143118.17733-1-laoar.shao@gmail.com> <Yv67MRQLPreR9GU5@slm.duckdns.org>
 <Yv6+HlEzpNy8y5kT@slm.duckdns.org> <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA@mail.gmail.com>
 <Yv/DK+AGlMeBGkF1@slm.duckdns.org> <CALOAHbCvUxQn5Zkp2FJ+eL1VgjeRSq1xQhzdiY87C1Cbib-nig@mail.gmail.com>
 <YwNold0GMOappUxc@slm.duckdns.org>
In-Reply-To: <YwNold0GMOappUxc@slm.duckdns.org>
From:   Mina Almasry <almasrymina@google.com>
Date:   Mon, 22 Aug 2022 12:02:48 -0700
Message-ID: <CAHS8izNvEpX3Lv7eFn-vu=4ZT96Djk2dU-VU+zOueZaZZbnWNw@mail.gmail.com>
Subject: Re: [RFD RESEND] cgroup: Persistent memory usage tracking
To:     Tejun Heo <tj@kernel.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
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

On Mon, Aug 22, 2022 at 4:29 AM Tejun Heo <tj@kernel.org> wrote:
>
> (Sorry, this is a resend. I messed up the header in the first posting.)
>
> Hello,
>
> This thread started on a bpf-specific memory tracking change proposal and
> went south, but a lot of people who would be interested are already cc'd, so
> I'm hijacking it to discuss what to do w/ persistent memory usage tracking.
>
> Cc'ing Mina and Yosry who were involved in the discussions on the similar
> problem re. tmpfs, Dan Schatzberg who has a lot more prod knowledge and
> experience than me, and Lennart for his thoughts from systemd side.
>
> The root problem is that there are resources (almost solely memory
> currently) that outlive a given instance of a, to use systemd-lingo,
> service. Page cache is the most common case.
>
> Let's say there's system.slice/hello.service. When it runs for the first
> time, page cache backing its binary will be charged to hello.service.
> However, when it restarts after e.g. a config change, when the initial
> hello.service cgroup gets destroyed, we reparent the page cache charges to
> the parent system.slice and when the second instance starts, its binary will
> stay charged to system.slice. Over time, some may get reclaimed and
> refaulted into the new hello.service but that's not guaranteed and most hot
> pages likely won't.
>
> The same problem exists for any memory which is not freed synchronously when
> the current instance exits. While this isn't a problem for many cases, it's
> not difficult to imagine situations where the amount of memory which ends up
> getting pushed to the parent is significant, even clear majority, with big
> page cache footprint, persistent tmpfs instances and so on, creating issues
> with accounting accuracy and thus control.
>
> I think there are two broad issues to discuss here:
>
> [1] Can this be solved by layering the instance cgroups under persistent
>     entity cgroup?
>
> So, instead of systemd.slice/hello.service, the application runs inside
> something like systemd.slice/hello.service/hello.service.instance and the
> service-level cgroup hello.service is not destroyed as long as it is
> something worth tracking on the system.
>
> The benefits are
>
> a. While requiring changing how userland organizes cgroup hiearchy, it is a
>    straight-forward extension of the current architecture and doesn't
>    require any conceptual or structural changes. All the accounting and
>    control schemes work exactly the same as before. The only difference is
>    that we now have a persistent entity representing each service as we want
>    to track their persistent resource usages.
>
> b. Per-instance tracking and control is optional. To me, it seems that the
>    persistent resource usages would be more meaningful than per-instance and
>    tracking down to the persistent usages shouldn't add noticeable runtime
>    overheads while keeping per-instance process management niceties and
>    allowing use cases to opt-in for per-instance resource tracking and
>    control as needed.
>
> The complications are:
>
> a. It requires changing cgroup hierarchy in a very visible way.
>
> b. What should be the lifetime rules for persistent cgroups? Do we keep them
>    around forever or maybe they can be created on the first use and kept
>    around until the service is removed from the system? When the persistent
>    cgroup is removed, do we need to make sure that the remaining resource
>    usages are low enough? Note that this problem exists for any approach
>    that tries to track persistent usages no matter how it's done.
>
> c. Do we need to worry about nesting overhead? Given that there's no reason
>    to enable controllers w/o persisten states for the instance level and the
>    nesting overhead is pretty low for memcg, this doesn't seem like a
>    problem to me. If this becomes a problem, we just need to fix it.
>
> A couple alternatives discussed are:
>
> a. Userspace keeps reusing the same cgroup for different instances of the
>    same service. This simplifies some aspects while making others more
>    complicated. e.g. Determining the current instance's CPU or IO usages now
>    require the monitoring software remembering what they were when this
>    instance started and calculating the deltas. Also, if some use cases want
>    to distinguish persistent vs. instance usages (more on this later), this
>    isn't gonna work. That said, this definitely is attractive in that it
>    miminizes overt user visible changes.
>
> b. Memory is disassociated rather than just reparented on cgroup destruction
>    and get re-charged to the next first user. This is attractive in that it
>    doesn't require any userspace changes; however, I'm not sure how this
>    would work for non-pageable memory usages such as bpf maps. How would we
>    detect the next first usage?
>
>
> [2] Whether and how to solve first and second+ instance charge differences.
>
> If we take the layering approach, the first instance will get charged for
> all memory that it uses while the second+ instances likely won't get charged
> for a lot of persistent usages. I don't think there is a consensus on
> whether this needs to be solved and I don't have enough context to form a
> strong opinion. memcg folks are a lot better equipped to make this decision.
>

The problem of first and second+ instance charges is something I've
ran into when dealing with tmpfs charges, and something I believe
Yosry ran into with regards to bpf as well, so AFAIU we think it's
something worth addressing, but I'd also like to hear from other memcg
folks if this is something that needs to be solved for them as well.
For us this is something we want to fix because the memory usage of
these services is hard to predict and limit since the memory usage of
the first charger may be much greater than second+.

> Assuming this needs to be solved, here's a braindump to be taken with a big
> pinch of salt:
>
> I have a bit of difficult time imagining a perfect solution given that
> whether a given page cache page is persistent or not would be really
> difficult to know (or maybe all page cache is persistent by default while
> anon is not). However, the problem still seems worthwhile to consider for
> big ticket items such as persistent tmpfs mounts and huge bpf maps as they
> can easily make the differences really big.
>
> If we want to solve this problem, here are options that I can think of:
>
> a. Let userspace put the charges where they belong using the current
>    mechanisms. ie. Create persistent entities in the persistent parent
>    cgroup while there's no current instance.
>
>    Pro: It won't require any major kernel or interface changes. There still
>    need to be some tweaking such as allowing tmpfs pages to be always
>    charged to the cgroup which created the instance (maybe as long as it's
>    an ancestor of the faulting cgroup?) but nothing too invasive.
>
>    Con: It may not be flexible enough.
>

I believe this works for us, provided memory is charged to the
persistent parent entity directly and is not charged to the child
instance. If memory is charged to the child instance first and then
reparented, I think we still have the same problem. Because the first
instance is charged for this memory but the second+ instances are not,
making predicting the memory usage of such use cases difficult.

> b. Let userspace specify which cgroup to charge for some of constructs like
>    tmpfs and bpf maps. The key problems with this approach are
>
>    1. How to grant/deny what can be charged where. We must ensure that a
>       descendant can't move charges up or across the tree without the
>       ancestors allowing it.
>
>    2. How to specify the cgroup to charge. While specifying the target
>       cgroup directly might seem like an obvious solution, it has a couple
>       rather serious problems. First, if the descendant is inside a cgroup
>       namespace, it might be able to see the target cgroup at all. Second,
>       it's an interface which is likely to cause misunderstandings on how it
>       can be used. It's too broad an interface.
>

This is pretty much the solution I sent out for review about a year
ago and yes, it suffers from the issues you've brought up:
https://lore.kernel.org/linux-mm/20211120045011.3074840-1-almasrymina@google.com/


>    One solution that I can think of is leveraging the resource domain
>    concept which is currently only used for threaded cgroups. All memory
>    usages of threaded cgroups are charged to their resource domain cgroup
>    which hosts the processes for those threads. The persistent usages have a
>    similar pattern, so maybe the service level cgroup can declare that it's
>    the encompassing resource domain and the instance cgroup can say whether
>    it's gonna charge e.g. the tmpfs instance to its own or the encompassing
>    resource domain.
>

I think this sounds excellent and addresses our use cases. Basically
the tmpfs/bpf memory would get charged to the encompassing resource
domain cgroup rather than the instance cgroup, making the memory usage
of the first and second+ instances consistent and predictable.

Would love to hear from other memcg folks what they would think of
such an approach. I would also love to hear what kind of interface you
have in mind. Perhaps a cgroup tunable that says whether it's going to
charge the tmpfs/bpf instance to itself or to the encompassing
resource domain?

>    This has the benefit that the user only needs to indicate its intention
>    without worrying about how cgroups are composed and what their IDs are.
>    It just indicates whether the given resource is persistent and if the
>    cgroup hierarchy is set up for that, it gets charged that way and if not
>    it can be just charged to itself.
>
>    This is a shower thought but, if we allow nesting such domains (and maybe
>    name them), we can use it for shared resources too so that co-services
>    are put inside a shared slice and shared resources are pushed to the
>    slice level.
>
> This became pretty long. I obviously have a pretty strong bias towards
> solving this within the current basic architecture but other than that most
> of these decisions are best made by memcg folks. We can hopefully build some
> consensus on the issue.
>
> Thanks.
>
> --
> tejun
>
