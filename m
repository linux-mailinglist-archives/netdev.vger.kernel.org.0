Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F22159E4E1
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 16:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240771AbiHWOFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 10:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242455AbiHWOE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 10:04:59 -0400
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6002B6B15D;
        Tue, 23 Aug 2022 04:15:04 -0700 (PDT)
Received: by mail-ua1-f41.google.com with SMTP id j10so3065145uaq.12;
        Tue, 23 Aug 2022 04:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=0V83ClKygRI6RPQNXMACz/OH2BKvkSJzRaFhLN3Zp+A=;
        b=peGiddtL48LY1uQt2ecwvHiprqWMUaD4L8suqoWa8a6HtZmbPAqvb4ox8YEaUkx41q
         H1VxiEdfjriVTGf6OFjgdUqKouBBF1REtOLDrSsSx1wsT27H1Lb/RUVSWPfpcsue4eEz
         g/wYn4DjL/JSmFu07YRSH20X6uH5aALHY4mErT5bC0dEvrxEyZ/9evIrHpMOHnQA1E6O
         7WcefxGPNey6/bEFJqmHDlKXCU9AxzMzmr0hBbZGr/ke/IG+ivT6bVaLHikorttDobeI
         IuAtTIw7lXjy3N0dFUfp27j1/VSojTUDlSEiwymN4p+dEL/YAv2f6k8UOIBaTBCgFLTy
         Ss3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=0V83ClKygRI6RPQNXMACz/OH2BKvkSJzRaFhLN3Zp+A=;
        b=768XeyHdQV02BbyFfv9sqaoQOCEiJNBky3HS3LJyoZbMXk1/ZgqSvM2Xjyu6n1PmHc
         gcuuM+fShNggsn9oUusSUPx17Eu+CwRI1bVyTISWW8uq143dEsAT/z9t3Ro/0Z1aDnvG
         qCwGrg8aUPrk1S7wHlcOorPlbW9J/Okw1b42g9ol4BUN3/vNHPNkAEKa7QKSQymWpqnQ
         pRf5pqbNcl36A05fwBF5X3EZdD98DNt055qOZPe9vhntFRKTXBS+VrdhpBjNMA8aB9Ww
         5r1k9eNr8lm7g/l4Aj/WSrIgG4Ub6lysS0ZrDOGhinnMY8Wy2Opkr9WfznRvwhXKpw0u
         1MoA==
X-Gm-Message-State: ACgBeo2N/KVmnleUd6+kecNcgHigrkzu1FcD4ZwjQxvbw4XQ64aQ4l1G
        FBR8F4TXxbNcvFjRgvFBtyNatzBThkbLEUIGfao=
X-Google-Smtp-Source: AA6agR7d/QtNBlmB412v0jegTrKGCDK/ETenFjZIYdAnF+ESjm77V6zKf6XqHP0cxNGbxp+ICTwy2bP6eJdmEmIxs/A=
X-Received: by 2002:ab0:7706:0:b0:399:17f3:fef1 with SMTP id
 z6-20020ab07706000000b0039917f3fef1mr8770289uaq.72.1661252934272; Tue, 23 Aug
 2022 04:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220818143118.17733-1-laoar.shao@gmail.com> <Yv67MRQLPreR9GU5@slm.duckdns.org>
 <Yv6+HlEzpNy8y5kT@slm.duckdns.org> <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA@mail.gmail.com>
 <Yv/DK+AGlMeBGkF1@slm.duckdns.org> <CALOAHbCvUxQn5Zkp2FJ+eL1VgjeRSq1xQhzdiY87C1Cbib-nig@mail.gmail.com>
 <YwNold0GMOappUxc@slm.duckdns.org>
In-Reply-To: <YwNold0GMOappUxc@slm.duckdns.org>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 23 Aug 2022 19:08:17 +0800
Message-ID: <CALOAHbBTR-07La=-KPehFab0WDY4V6LovXbrhLXOqKDurHD-9g@mail.gmail.com>
Subject: Re: [RFD RESEND] cgroup: Persistent memory usage tracking
To:     Tejun Heo <tj@kernel.org>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 7:29 PM Tejun Heo <tj@kernel.org> wrote:
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

Hi,

Below is some background of kubernetes.
In kubernetes, a pod is organized as follows,

               pod
               |- Container
               |- Container

IOW, it is a two-layer unit, or a two-layer instance.
The cgroup dir of the pod is named with a UUID assigned by kubernetes-apiserver.
Once the old pod is destroyed (that can happen when the user wants to
update their service), the new pod will have a different UUID.
That said, different instances will have different cgroup dir.

If we want to introduce a  persistent entity cgroup, we have to make
it a three-layer unit.

           persistent-entity
           |- pod
                 |- Container
                 |- Container

There will be some issues,
1.  The kuber-apiserver must maintain the persistent-entity on each host.
     It needs a great refactor and the compatibility is also a problem
per my discussion with kubernetes experts.
2.  How to do the monitor?
     If there's only one pod under this persistent-entity, we can
easily get the memory size of  shared resources by:
         Sizeof(shared-resources) = Sizeof(persistent-entity) - Sizeof(pod)
    But what if it has N pods and N is dynamically changed ?
3.  What if it has more than one shared resource?
     For example, pod-foo has two shared resources A and B, pod-bar
has two shared resources A and C, and another pod has two shared
resources B and C.
     How to deploy them?
     Pls, note that we can introduce multiple-layer persistent-entity,
but which one should be the parent ?

So from my perspective, it is almost impossible.

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

JFYI, There is a reuse path for the bpf map, see my previous RFC[1].
[1] https://lore.kernel.org/bpf/20220619155032.32515-1-laoar.shao@gmail.com/

>
> [2] Whether and how to solve first and second+ instance charge differences.
>
> If we take the layering approach, the first instance will get charged for
> all memory that it uses while the second+ instances likely won't get charged
> for a lot of persistent usages. I don't think there is a consensus on
> whether this needs to be solved and I don't have enough context to form a
> strong opinion. memcg folks are a lot better equipped to make this decision.
>

Just sharing our practice.
For many of our users, it means the memcg is unreliable (at least for
the observability) when the memory usage is inconsistent.
So they prefer to drop the page cache (by echoing memory.force_empty)
when the container (pod) is destroyed, at the cost of taking time to
reload these page caches next time.  Reliability is more important
than performance.

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
> b. Let userspace specify which cgroup to charge for some of constructs like
>    tmpfs and bpf maps. The key problems with this approach are
>
>    1. How to grant/deny what can be charged where. We must ensure that a
>       descendant can't move charges up or across the tree without the
>       ancestors allowing it.
>

We can add restrictions to check which memcg can be selected
(regarding the selectable memcg).
But I think it may be too early to do the restrictions, as only the
privileged user can set it.
It is the sys admin's responsbility to select a proper memcg.
That said, the selectable memcg is not going south.

>    2. How to specify the cgroup to charge. While specifying the target
>       cgroup directly might seem like an obvious solution, it has a couple
>       rather serious problems. First, if the descendant is inside a cgroup
>       namespace, it might be able to see the target cgroup at all.

It is not a problem. Just sharing our practice below.
$ docker run -tid --privileged    \
                      --mount
type=bind,source=/sys/fs/bpf,target=/sys/fs/bpf    \
                      --mount
type=bind,source=/sys/fs/cgroup/memory/bpf,target=/bpf-memcg    \
                      docker-image

The bind-mount can make it work.

>  Second,
>       it's an interface which is likely to cause misunderstandings on how it
>       can be used. It's too broad an interface.
>

As I said above, we just need some restrictions or guidance if that is
desired now.

>    One solution that I can think of is leveraging the resource domain
>    concept which is currently only used for threaded cgroups. All memory
>    usages of threaded cgroups are charged to their resource domain cgroup
>    which hosts the processes for those threads. The persistent usages have a
>    similar pattern, so maybe the service level cgroup can declare that it's
>    the encompassing resource domain and the instance cgroup can say whether
>    it's gonna charge e.g. the tmpfs instance to its own or the encompassing
>    resource domain.
>
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

JFYI.
Apologize in advance if my words offend you again.

-- 
Regards
Yafang
