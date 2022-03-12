Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0004D6D0E
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 07:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiCLGrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 01:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiCLGrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 01:47:06 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA63522B3F;
        Fri, 11 Mar 2022 22:46:00 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id k25so12445099iok.8;
        Fri, 11 Mar 2022 22:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o80gr5I+o09IDVNFlBm6Ency0uIbmXRRbioZcsoLxSo=;
        b=X7lSnyn4JvEa9RpeRVOubsvZARruXm7ZvggdnCa2hQt0zEYFPjzeYtElhqat36aNZE
         izKDloAeQcpzRq4o3hqmQsa1ad9EOgNW+Cs5JUWoVC57ZlFT3tC9I0hyAwSC9M8T9i0I
         RF7WrKphi7Gsfl3Plc3YWEi1KNlDDQ/AGHutsjSt/6mqqQfA6omoyq5Jr1JmwIsmyO2C
         9uGk5xEwdiXx7K2I2KjoaXoBbQ1Qj5pf9XKSmbaSe0yfQdD4Cc1JGwjglQlRB1iEbVSs
         JZZpJdC+SFJyA2jUe2CG1ZFaBT76Sf+uFaDF9WOND1/NgarlIZu+dq+1eYkqO2YlEALf
         l3iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o80gr5I+o09IDVNFlBm6Ency0uIbmXRRbioZcsoLxSo=;
        b=4rmTpNVBwTkUh78qCUG9Gvfb1PoPx3hJjmxQ4iVOZKtTBAXn6aqzmLzBiCq0a06ixa
         rTijVV8aNW+MK75d3A03cnVQNP+jLnCpJopQKD73EWxqD8gtwaoT/l/ABDQoSvyuL6Qa
         WuKZExgibK32WXZhicmjlUOduIqJ7m5ED6BU25fw+e9NX1H25vUqFBt9bKsUvZSXG6YR
         wAV9ebwnDEBG/F5EEr4W+d98xPEUPeURQzXqyPry337Gb3fzSIrU274R7+DMXPgKK7MO
         ATWNoyXdCtx/XmdznsQNh7Qb1VMEHfPqysJjqESazVjlX1cvQTtdH30n36ENkhkDClmw
         CiBQ==
X-Gm-Message-State: AOAM530eOlUZdveRRjyBOdnX+k8LryujTZgOWfGXHVbPBMa58OrSrgvO
        lXg+iNMIebcVZzRsRvSuQkm+qnx9MdmnD1uZoWQ=
X-Google-Smtp-Source: ABdhPJxC45RFfomJh7A+ZmPRTZlH8gvZW9Ib+u7XjtVyDGFh1syBFN6jf2oyseGApzY8MTdNfKwjZebHiVY6zJ1D81U=
X-Received: by 2002:a05:6602:2dc1:b0:645:d8f2:a8c1 with SMTP id
 l1-20020a0566022dc100b00645d8f2a8c1mr10995385iow.17.1647067559844; Fri, 11
 Mar 2022 22:45:59 -0800 (PST)
MIME-Version: 1.0
References: <20220308131056.6732-1-laoar.shao@gmail.com> <Yif+QZbCALQcYrFZ@carbon.dhcp.thefacebook.com>
 <CALOAHbARWARjK4cAjUfsGDy3G4sAZaHRiFQsbjNc=EfHsCfnnQ@mail.gmail.com>
 <Yik5qSryIPk70iVz@carbon.dhcp.thefacebook.com> <CALOAHbB6ktqmsmkKM9Ge8dOVNW28RV68B_EHCV754r-YRXzk4A@mail.gmail.com>
 <Yio8qIWTjAXaC23P@carbon.DHCP.thefacebook.com> <CALOAHbC1GQdwSheqcwT2yKKac16pC4qKRFydQA47MHHDk98gcA@mail.gmail.com>
 <YiuLoWvbbxYZVZLE@carbon.DHCP.thefacebook.com>
In-Reply-To: <YiuLoWvbbxYZVZLE@carbon.DHCP.thefacebook.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 12 Mar 2022 14:45:23 +0800
Message-ID: <CALOAHbCU_8cO5POET8A56aNkR4MC_Up93PLzx=8dU7ki4UfgEA@mail.gmail.com>
Subject: Re: [PATCH RFC 0/9] bpf, mm: recharge bpf memory from offline memcg
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, penberg@kernel.org,
        David Rientjes <rientjes@google.com>, iamjoonsoo.kim@lge.com,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Sat, Mar 12, 2022 at 1:49 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> On Fri, Mar 11, 2022 at 08:48:27PM +0800, Yafang Shao wrote:
> > On Fri, Mar 11, 2022 at 2:00 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> > >
> > > On Thu, Mar 10, 2022 at 09:20:54PM +0800, Yafang Shao wrote:
> > > > On Thu, Mar 10, 2022 at 7:35 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> > > > >
> > > > > On Wed, Mar 09, 2022 at 09:28:58PM +0800, Yafang Shao wrote:
> > > > > > On Wed, Mar 9, 2022 at 9:09 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> > > > > > >
> > > > > > > On Tue, Mar 08, 2022 at 01:10:47PM +0000, Yafang Shao wrote:
> > > > > > > > When we use memcg to limit the containers which load bpf progs and maps,
> > > > > > > > we find there is an issue that the lifecycle of container and bpf are not
> > > > > > > > always the same, because we may pin the maps and progs while update the
> > > > > > > > container only. So once the container which has alreay pinned progs and
> > > > > > > > maps is restarted, the pinned progs and maps are no longer charged to it
> > > > > > > > any more. In other words, this kind of container can steal memory from the
> > > > > > > > host, that is not expected by us. This patchset means to resolve this
> > > > > > > > issue.
> > > > > > > >
> > > > > > > > After the container is restarted, the old memcg which is charged by the
> > > > > > > > pinned progs and maps will be offline but won't be freed until all of the
> > > > > > > > related maps and progs are freed. If we want to charge these bpf memory to
> > > > > > > > the new started memcg, we should uncharge them from the offline memcg first
> > > > > > > > and then charge it to the new one. As we have already known how the bpf
> > > > > > > > memroy is allocated and freed, we can also know how to charge and uncharge
> > > > > > > > it. This pathset implements various charge and uncharge methords for these
> > > > > > > > memory.
> > > > > > > >
> > > > > > > > Regarding how to do the recharge, we decide to implement new bpf syscalls
> > > > > > > > to do it. With the new implemented bpf syscall, the agent running in the
> > > > > > > > container can use it to do the recharge. As of now we only implement it for
> > > > > > > > the bpf hash maps. Below is a simple example how to do the recharge,
> > > > > > > >
> > > > > > > > ====
> > > > > > > > int main(int argc, char *argv[])
> > > > > > > > {
> > > > > > > >       union bpf_attr attr = {};
> > > > > > > >       int map_id;
> > > > > > > >       int pfd;
> > > > > > > >
> > > > > > > >       if (argc < 2) {
> > > > > > > >               printf("Pls. give a map id \n");
> > > > > > > >               exit(-1);
> > > > > > > >       }
> > > > > > > >
> > > > > > > >       map_id = atoi(argv[1]);
> > > > > > > >       attr.map_id = map_id;
> > > > > > > >       pfd = syscall(SYS_bpf, BPF_MAP_RECHARGE, &attr, sizeof(attr));
> > > > > > > >       if (pfd < 0)
> > > > > > > >               perror("BPF_MAP_RECHARGE");
> > > > > > > >
> > > > > > > >       return 0;
> > > > > > > > }
> > > > > > > >
> > > > > > > > ====
> > > > > > > >
> > > > > > > > Patch #1 and #2 is for the observability, with which we can easily check
> > > > > > > > whether the bpf maps is charged to a memcg and whether the memcg is offline.
> > > > > > > > Patch #3, #4 and #5 is for the charge and uncharge methord for vmalloc-ed,
> > > > > > > > kmalloc-ed and percpu memory.
> > > > > > > > Patch #6~#9 implements the recharge of bpf hash map, which is mostly used
> > > > > > > > by our bpf services. The other maps hasn't been implemented yet. The bpf progs
> > > > > > > > hasn't been implemented neither.
> > > > > > > >
> > > > > > > > This pathset is still a POC now, with limited testing. Any feedback is
> > > > > > > > welcomed.
> > > > > > >
> > > > > > > Hello Yafang!
> > > > > > >
> > > > > > > It's an interesting topic, which goes well beyond bpf. In general, on cgroup
> > > > > > > offlining we either do nothing either recharge pages to the parent cgroup
> > > > > > > (latter is preferred), which helps to release the pinned memcg structure.
> > > > > > >
> > > > > >
> > > > > > We have thought about recharging pages to the parent cgroup (the root
> > > > > > memcg in our case),
> > > > > > but it can't resolve our issue.
> > > > > > Releasing the pinned memcg struct is the benefit of recharging pages
> > > > > > to the parent,
> > > > > > but as there won't be too many memcgs pinned by bpf, so it may not be worth it.
> > > > >
> > > > > I agree, that was my thinking too.
> > > > >
> > > > > >
> > > > > >
> > > > > > > Your approach raises some questions:
> > > > > >
> > > > > > Nice questions.
> > > > > >
> > > > > > > 1) what if the new cgroup is not large enough to contain the bpf map?
> > > > > >
> > > > > > The recharge is supposed to be triggered at the container start time.
> > > > > > After the container is started, the agent which will load the bpf
> > > > > > programs will do it as follows,
> > > > > > 1. Check if the bpf program has already been loaded,
> > > > > >     if not,  goto 5.
> > > > > > 2. Check if the bpf program will pin maps or progs,
> > > > > >     if not, goto 6.
> > > > > > 3. Check if the pinned maps and progs are charged to an offline memcg,
> > > > > >     if not, goto 6.
> > > > > > 4. Recharge the pinned maps or progs to the current memcg.
> > > > > >    goto 6.
> > > > > > 5. load new bpf program, and also pinned maps and progs if desired.
> > > > > > 6. End.
> > > > > >
> > > > > > If the recharge fails, it means that the memcg limit is too low, we
> > > > > > should reconsider
> > > > > > the limit of the container.
> > > > > >
> > > > > > Regarding other cases that it may do the recharge in the runtime, I
> > > > > > think the failure is
> > > > > > a common OOM case, that means the usage in this container is out of memory, we
> > > > > > should kill something.
> > > > >
> > > > > The problem here is that even invoking the oom killer might not help here,
> > > > > if the size of the bpf map is larger than memory.max.
> > > > >
> > > >
> > > > Then we should introduce a fallback.
> > >
> > > Can you, please, elaborate a bit more?
> > >
> > > >
> > > > > Also because recharging of a large object might take time and it's happening
> > > > > simultaneously with other processes in the system (e.g. memory allocations,
> > > > > cgroup limit changes, etc), potentially we might end up in the situation
> > > > > when the new cgroup is not large enough to include the transferred object,
> > > > > but also the original cgroup is not large enough (due to the limit set on one
> > > > > of it's ancestors), so we'll need to break memory.max of either cgroup,
> > > > > which is not great. We might solve this by pre-charging of target cgroup
> > > > > and keeping the double-charge during the process, but it might not work
> > > > > well for really large objects on small machines. Another approach is to transfer
> > > > > in small chunks (e.g. pages), but then we might end with a partially transferred
> > > > > object, which is also a questionable result.
> > > > >
> > > >
> > > > For this case it is not difficult to do the fallback because the
> > > > original one is restricted to an offline memcg only, that means there
> > > > are no any activities  in the original memcg. So recharge these pages
> > > > to the original one back will always succeed.
> > >
> > > The problem is that the original cgroup might be not a top-level cgroup.
> > > So even if it's offline, it doesn't really change anything: it's parent cgroup
> > > can be online and experience concurrent limits changes, allocations etc.
> > >
> > > >
> > > > > <...>
> > > > >
> > > > > > > Will reparenting work for your case? If not, can you, please, describe the
> > > > > > > problem you're trying to solve by recharging the memory?
> > > > > > >
> > > > > >
> > > > > > Reparenting doesn't work for us.
> > > > > > The problem is memory resource control: the limitation on the bpf
> > > > > > containers will be useless
> > > > > > if the lifecycle of bpf progs can containers are not the same.
> > > > > > The containers are always upgraded - IOW restarted - more frequently
> > > > > > than the bpf progs and maps,
> > > > > > that is also one of the reasons why we choose to pin them on the host.
> > > > >
> > > > > In general, I think I understand why this feature is useful for your case,
> > > > > however I do have some serious concerns about adding such feature to
> > > > > the upstream kernel:
> > > > > 1) The interface and the proposed feature is bpf-specific, however the problem
> > > > > isn't. The same issue (an under reported memory consumption) can be caused by
> > > > > other types of memory: pagecache, various kernel objects e.g. vfs cache etc.
> > > > > If we introduce such a feature, we'd better be consistent across various
> > > > > types of objects (how it's a good question).
> > > >
> > > > That is really a good question, which drives me to think more and
> > > > investigate more.
> > > >
> > > > Per my understanding the under reported pages can be divided into several cases,
> > > > 1) The pages aren't charged correctly when they are allocated.
> > > >    In this case, we should fix it when we allocate it.
> > > > 2) The pages should be recharged back to the original memcg
> > > >    The pages are charged correctly but then we lost track of it.
> > > >    In this case the kernel must introduce some way to keep track of
> > > > and recharge it back in the proper circumstance.
> > > > 3) Undistributed estate
> > > >    The original owner was dead, left with some persistent memory.
> > > >    Should the new one who uses this memory take charge of it?
> > > >
> > > > So case #3 is what we should discuss here.
> > >
> > > Right, this is the case I'm focused on too.
> > >
> > > A particular case is when there are multiple generations of the "same"
> > > workload each running in a new cgroup. Likely there is a lot of pagecache
> > > and vfs cache (and maybe bpf programs etc) is re-used by the second and
> > > newer generations, however they are accounted towards the first dead cgroup.
> > > So the memory consumption of the second and newer generations is systematically
> > > under-reported.
> > >
> >
> > Right, the sharing pagecache pages and vfs cache are more complicated.
> > The trouble is that we don't have a clear rule on what they should
> > belong to. If we want to handle them, we must make the rule first that
> > 1) Should we charge these pages to a specific memcg in the first place ?
> >     If not, things will be very easy. If yes, things will be very complicated.
> >     Unfortunately we selected the complicated way.
> > 2) Now that we selected the complicated way, can we have a clear rule
> > to manage them ?
> >     Our current status is that let it be, and it doesn't matter what
> > they belong to as long as they have a memcg.
> >
> > > >
> > > > Before answering the question, I will explain another option we have
> > > > thought about to fix our issue.
> > > > Instead of recharging the bpf memory in the bpf syscall, the other
> > > > option is to set the target memcg only in the syscall and then wake up
> > > > a kworker to do the recharge. That means separate the recharge into
> > > > two steps, 1) assign the inheritor, 2) transfer the estate.
> > > > At last we didn't choose it because we want an immediate error if the
> > > > new owner doesn't have large enough space.
> > >
> > > The problem is that we often don't know this in advance. Imagine a cgroup
> > > with memory.max set to 1Gb and current usage 0.8Gb. Can it fit a 0.5Gb bpf map?
> > > The true answer is it depends on whether we can reclaim extra 0.3Gb. And there
> > > is no way to say it for sure without making a real attempt to reclaim.
> > >
> > > > But this option can partly answer your question here, one possible way
> > > > to do it more generic is to abstract
> > > > two methods to get -
> > > > 1). Who is the best inheritor               =>  assigner
> > > > 2). How to charge the memory to it    =>  charger
> > > >
> > > > Then let consider the option we choose again, we can find that it can be
> > > > easily extended to work in that way,
> > > >
> > > >        assigner                             charger
> > > >
> > > >     bpf_syscall
> > > >        wakeup the charger            waken
> > > >        wait for the result                 do the recharge and give the result
> > > >        return the result
> > > >
> > > > In other words, we don't have a clear idea what issues we may face in
> > > > the future, but we know we can extend it to fix the new coming issue.
> > > > I think that is the most important thing.
> > > >
> > > > > 2) Moving charges is proven to be tricky and cause various problems in the past.
> > > > > If we're going back into this direction, we should come up with a really solid
> > > > > plan for how to avoid past issues.
> > > >
> > > > I know the reason why we disable move_charge_at_immigrate in cgroup2,
> > > > but I don't know if I know all of the past issues.
> > > > Appreciate if you could share the past issues you know and I will
> > > > check if they apply to this case as well.
> > >
> > > As I mentioned above, recharging is a complex and potentially long process,
> > > which can unexpectedly fail. And rolling it back is also tricky and not always
> > > possible without breaking other things.
> > > So there are difficulties with:
> > > 1) providing a reasonable interface,
> > > 2) implementing it in way which doesn't bring significant performance overhead.
> > >
> > > That said, I'm not saying it's not possible at all, but it's a serious open
> > > problem.
> > >
> > > > In order to avoid possible risks, I have restricted the recharge to
> > > > happen in very strict conditions,
> > > > 1. The original memcg must be an offline memcg
> > > > 2.  The target memcg must be the memcg of the one who calls the bpf syscall
> > > >      That means the outsider doesn't have a way to do the recharge.
> > > > 3. only kmem is supported now. (The may be extend it the future for
> > > > other types of memory)
> > > >
> > > > > 3) It would be great to understand who and how will use this feature in a more
> > > > > generic environment. E.g. is it useful for systemd? Is it common to use bpf maps
> > > > > over multiple cgroups? What for (given that these are not system-wide programs,
> > > > > otherwise why would we charge their memory to some specific container)?
> > > > >
> > > >
> > > > It is useful for containerized environments.
> > > > The container which pinned bpf can use it.
> > > > In our case we may use it in two ways as I explained in the prev mail that,
> > > > 1) The one who load the bpf who do the recharge
> > > > 2) A sidecar to maintain the bpf cycle
> > > >
> > > > For the systemd, it may need to do some extend that,
> > > > The bpf services should describe,
> > > > 1) if the bpf service needs the recharge (the one who limited by memcg
> > > > should be forcefully do the recharge)
> > > > 2) the pinned progs and maps to check
> > > > 3) the service identifier (with which we can get the target memcg)
> > > >
> > > > We don't have the case that the bpf map is shared by multiple cgroups,
> > > > that should be a rare case.
> > > > I think that case is similar to the sharing page caches across
> > > > multiple cgroups, which are used by many cgroups but only charged to
> > > > one specific memcg.
> > >
> > > I understand the case with the pagecache. E.g. we're running essentially the
> > > same workload in a new cgroup and it likely uses the same or similar set of
> > > files, it will actively use the pagecache created by the previous generation.
> > > And this can be a memcg-specific pagecache, which nobody except these cgroups is
> > > using.
> > >
> > > But what kind of bpf data has the same property? Why it has to be persistent
> > > across multiple generations of the same workload?
> > >
> >
> > Ah, it can be considered as shared, between the bpf memcg and the root
> > memcg. While it can only be written by bpf memcg. For example, in the
> > root memcg, some networking facilities like clsact qdisc also read
> > these maps.
> >
> > The key point is that the charging behavior must be consistent, either
> > always charged or always uncharged. That will be good for memory
> > resource management. It is bad that sometimes it gets charged while
> > sometimes not.
>
> I agree, consistency is very important. That is why I don't quite like the idea
> of a voluntary recharging performed by userspace. It might work in your case,
> but in general it's hard to expect that everybody will consistently recharge
> their maps.
>
> >
> > Another possible solution is to introduce a way to allow not to charge
> > pages, IOW these pages will be accounted to root only. If we go that
> > direction, things will get simpler. What do you think?
>
> Is your map pre-allocated or not? Pre-allocated maps can be created by a process
> (temporarily) placed into the root memcg to disable accounting.

It is not pre-allocated. It may be updated dynamically - removes the
old one and then adds a new one.

> We can also
> think of a flag to do it explicitly (e.g. on creating a map).

That is a workable solution.

> But we must be careful here to not introduce security issues: e.g. a non-root
> memcg shouldn't be able to allocate (unaccounted) memory by writing into a
> bpf map belonging to the root memcg.
>

Thanks for your suggestion.

In the end, many thanks for the enlightening discussion with you.

-- 
Thanks
Yafang
