Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7EC4D47F4
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 14:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242354AbiCJNWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 08:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242324AbiCJNWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 08:22:33 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279FE14CCB2;
        Thu, 10 Mar 2022 05:21:32 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id b9so2310122ila.8;
        Thu, 10 Mar 2022 05:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I6+CKfr+SxJncUJR0moNMcpn03MHRxJpJ4fbJOrzKik=;
        b=gl2KALqU4A0NPTsg6nSCvCXZhvz8zXWzbIZ2gErg5JL2JpZLStf12GFiU8oqIAOv9w
         M8F21x1mbVOnhKPyRpetyHUEsFzOUZIfHQhLdq6gjHSy5SB2F4/5Bz9xQBBMF/Fn/T5l
         t+kRTSTj1jy3RIYrgCyREotREhwpJvHu28lQc8Se7KiPOBx3RBDKVmc3zNjT4Dccjv+h
         P6YY291OZ5bf/mHp6bZVxCJp8nnJeP4hZFlY6yn3DyxqojF8d0jDg6hDkWNY+Zmgs5TY
         uxF7XOVj0mCaAVvAaNREqb6uoMHnb1CbqYPw0f1Ylmc+we3I+Q4WUrPNefpE10gCnMV+
         r62g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I6+CKfr+SxJncUJR0moNMcpn03MHRxJpJ4fbJOrzKik=;
        b=o36dEvjA6/7jznymuuZw0XZhWRaM2GBU3/x0XwUS9DlKp0P4rBzZfS1+kdiOFM7HHA
         lbqDwkCIx2X4bB9xZUT1thbt1vsKAjR5gkoW0cZkZAnY/eWkm9Q8vLXgy6jwvNwL8c4a
         4Rwjd64P9ywE9gmQApE7KlpIni+/a2WxeaupbE6z29OiUamVDPmLhfvTSprpUzbgXECx
         YNrcDtEjACVguAFQsT+MK53y0sZDUWQpVbGUU/mDzx8ZvANc/95KFroPSn+6VpxChsrK
         kNsTrDSaXMfBO7r3squUyvPu5/Tj6kcsXcP5aOsjZ2wvENVdWb5ybWHA+6Bo5SpTcaa9
         gClA==
X-Gm-Message-State: AOAM5302jyZvgi7l43Tm1RGXELa9n+VM/DUJggXJOw92HynmGHx6O3Mc
        p4T6lrmA23YZKuPBKQi11vbmJqAQV5yQDJLjOp4=
X-Google-Smtp-Source: ABdhPJxxtrUyKNkoOVHackonaUefpDoVY9xhN1LS1vmX9v4rrZZN2n0gUgRx2TP4ezW3Tme9nFwdeojUnegPwWjHW90=
X-Received: by 2002:a05:6e02:1a66:b0:2c6:6cc3:848c with SMTP id
 w6-20020a056e021a6600b002c66cc3848cmr3818590ilv.87.1646918491243; Thu, 10 Mar
 2022 05:21:31 -0800 (PST)
MIME-Version: 1.0
References: <20220308131056.6732-1-laoar.shao@gmail.com> <Yif+QZbCALQcYrFZ@carbon.dhcp.thefacebook.com>
 <CALOAHbARWARjK4cAjUfsGDy3G4sAZaHRiFQsbjNc=EfHsCfnnQ@mail.gmail.com> <Yik5qSryIPk70iVz@carbon.dhcp.thefacebook.com>
In-Reply-To: <Yik5qSryIPk70iVz@carbon.dhcp.thefacebook.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Thu, 10 Mar 2022 21:20:54 +0800
Message-ID: <CALOAHbB6ktqmsmkKM9Ge8dOVNW28RV68B_EHCV754r-YRXzk4A@mail.gmail.com>
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

On Thu, Mar 10, 2022 at 7:35 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> On Wed, Mar 09, 2022 at 09:28:58PM +0800, Yafang Shao wrote:
> > On Wed, Mar 9, 2022 at 9:09 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> > >
> > > On Tue, Mar 08, 2022 at 01:10:47PM +0000, Yafang Shao wrote:
> > > > When we use memcg to limit the containers which load bpf progs and maps,
> > > > we find there is an issue that the lifecycle of container and bpf are not
> > > > always the same, because we may pin the maps and progs while update the
> > > > container only. So once the container which has alreay pinned progs and
> > > > maps is restarted, the pinned progs and maps are no longer charged to it
> > > > any more. In other words, this kind of container can steal memory from the
> > > > host, that is not expected by us. This patchset means to resolve this
> > > > issue.
> > > >
> > > > After the container is restarted, the old memcg which is charged by the
> > > > pinned progs and maps will be offline but won't be freed until all of the
> > > > related maps and progs are freed. If we want to charge these bpf memory to
> > > > the new started memcg, we should uncharge them from the offline memcg first
> > > > and then charge it to the new one. As we have already known how the bpf
> > > > memroy is allocated and freed, we can also know how to charge and uncharge
> > > > it. This pathset implements various charge and uncharge methords for these
> > > > memory.
> > > >
> > > > Regarding how to do the recharge, we decide to implement new bpf syscalls
> > > > to do it. With the new implemented bpf syscall, the agent running in the
> > > > container can use it to do the recharge. As of now we only implement it for
> > > > the bpf hash maps. Below is a simple example how to do the recharge,
> > > >
> > > > ====
> > > > int main(int argc, char *argv[])
> > > > {
> > > >       union bpf_attr attr = {};
> > > >       int map_id;
> > > >       int pfd;
> > > >
> > > >       if (argc < 2) {
> > > >               printf("Pls. give a map id \n");
> > > >               exit(-1);
> > > >       }
> > > >
> > > >       map_id = atoi(argv[1]);
> > > >       attr.map_id = map_id;
> > > >       pfd = syscall(SYS_bpf, BPF_MAP_RECHARGE, &attr, sizeof(attr));
> > > >       if (pfd < 0)
> > > >               perror("BPF_MAP_RECHARGE");
> > > >
> > > >       return 0;
> > > > }
> > > >
> > > > ====
> > > >
> > > > Patch #1 and #2 is for the observability, with which we can easily check
> > > > whether the bpf maps is charged to a memcg and whether the memcg is offline.
> > > > Patch #3, #4 and #5 is for the charge and uncharge methord for vmalloc-ed,
> > > > kmalloc-ed and percpu memory.
> > > > Patch #6~#9 implements the recharge of bpf hash map, which is mostly used
> > > > by our bpf services. The other maps hasn't been implemented yet. The bpf progs
> > > > hasn't been implemented neither.
> > > >
> > > > This pathset is still a POC now, with limited testing. Any feedback is
> > > > welcomed.
> > >
> > > Hello Yafang!
> > >
> > > It's an interesting topic, which goes well beyond bpf. In general, on cgroup
> > > offlining we either do nothing either recharge pages to the parent cgroup
> > > (latter is preferred), which helps to release the pinned memcg structure.
> > >
> >
> > We have thought about recharging pages to the parent cgroup (the root
> > memcg in our case),
> > but it can't resolve our issue.
> > Releasing the pinned memcg struct is the benefit of recharging pages
> > to the parent,
> > but as there won't be too many memcgs pinned by bpf, so it may not be worth it.
>
> I agree, that was my thinking too.
>
> >
> >
> > > Your approach raises some questions:
> >
> > Nice questions.
> >
> > > 1) what if the new cgroup is not large enough to contain the bpf map?
> >
> > The recharge is supposed to be triggered at the container start time.
> > After the container is started, the agent which will load the bpf
> > programs will do it as follows,
> > 1. Check if the bpf program has already been loaded,
> >     if not,  goto 5.
> > 2. Check if the bpf program will pin maps or progs,
> >     if not, goto 6.
> > 3. Check if the pinned maps and progs are charged to an offline memcg,
> >     if not, goto 6.
> > 4. Recharge the pinned maps or progs to the current memcg.
> >    goto 6.
> > 5. load new bpf program, and also pinned maps and progs if desired.
> > 6. End.
> >
> > If the recharge fails, it means that the memcg limit is too low, we
> > should reconsider
> > the limit of the container.
> >
> > Regarding other cases that it may do the recharge in the runtime, I
> > think the failure is
> > a common OOM case, that means the usage in this container is out of memory, we
> > should kill something.
>
> The problem here is that even invoking the oom killer might not help here,
> if the size of the bpf map is larger than memory.max.
>

Then we should introduce a fallback.

> Also because recharging of a large object might take time and it's happening
> simultaneously with other processes in the system (e.g. memory allocations,
> cgroup limit changes, etc), potentially we might end up in the situation
> when the new cgroup is not large enough to include the transferred object,
> but also the original cgroup is not large enough (due to the limit set on one
> of it's ancestors), so we'll need to break memory.max of either cgroup,
> which is not great. We might solve this by pre-charging of target cgroup
> and keeping the double-charge during the process, but it might not work
> well for really large objects on small machines. Another approach is to transfer
> in small chunks (e.g. pages), but then we might end with a partially transferred
> object, which is also a questionable result.
>

For this case it is not difficult to do the fallback because the
original one is restricted to an offline memcg only, that means there
are no any activities  in the original memcg. So recharge these pages
to the original one back will always succeed.

> <...>
>
> > > Will reparenting work for your case? If not, can you, please, describe the
> > > problem you're trying to solve by recharging the memory?
> > >
> >
> > Reparenting doesn't work for us.
> > The problem is memory resource control: the limitation on the bpf
> > containers will be useless
> > if the lifecycle of bpf progs can containers are not the same.
> > The containers are always upgraded - IOW restarted - more frequently
> > than the bpf progs and maps,
> > that is also one of the reasons why we choose to pin them on the host.
>
> In general, I think I understand why this feature is useful for your case,
> however I do have some serious concerns about adding such feature to
> the upstream kernel:
> 1) The interface and the proposed feature is bpf-specific, however the problem
> isn't. The same issue (an under reported memory consumption) can be caused by
> other types of memory: pagecache, various kernel objects e.g. vfs cache etc.
> If we introduce such a feature, we'd better be consistent across various
> types of objects (how it's a good question).

That is really a good question, which drives me to think more and
investigate more.

Per my understanding the under reported pages can be divided into several cases,
1) The pages aren't charged correctly when they are allocated.
   In this case, we should fix it when we allocate it.
2) The pages should be recharged back to the original memcg
   The pages are charged correctly but then we lost track of it.
   In this case the kernel must introduce some way to keep track of
and recharge it back in the proper circumstance.
3) Undistributed estate
   The original owner was dead, left with some persistent memory.
   Should the new one who uses this memory take charge of it?

So case #3 is what we should discuss here.

Before answering the question, I will explain another option we have
thought about to fix our issue.
Instead of recharging the bpf memory in the bpf syscall, the other
option is to set the target memcg only in the syscall and then wake up
a kworker to do the recharge. That means separate the recharge into
two steps, 1) assign the inheritor, 2) transfer the estate.
At last we didn't choose it because we want an immediate error if the
new owner doesn't have large enough space.
But this option can partly answer your question here, one possible way
to do it more generic is to abstract
two methods to get -
1). Who is the best inheritor               =>  assigner
2). How to charge the memory to it    =>  charger

Then let consider the option we choose again, we can find that it can be
easily extended to work in that way,

       assigner                             charger

    bpf_syscall
       wakeup the charger            waken
       wait for the result                 do the recharge and give the result
       return the result

In other words, we don't have a clear idea what issues we may face in
the future, but we know we can extend it to fix the new coming issue.
I think that is the most important thing.

> 2) Moving charges is proven to be tricky and cause various problems in the past.
> If we're going back into this direction, we should come up with a really solid
> plan for how to avoid past issues.

I know the reason why we disable move_charge_at_immigrate in cgroup2,
but I don't know if I know all of the past issues.
Appreciate if you could share the past issues you know and I will
check if they apply to this case as well.

In order to avoid possible risks, I have restricted the recharge to
happen in very strict conditions,
1. The original memcg must be an offline memcg
2.  The target memcg must be the memcg of the one who calls the bpf syscall
     That means the outsider doesn't have a way to do the recharge.
3. only kmem is supported now. (The may be extend it the future for
other types of memory)

> 3) It would be great to understand who and how will use this feature in a more
> generic environment. E.g. is it useful for systemd? Is it common to use bpf maps
> over multiple cgroups? What for (given that these are not system-wide programs,
> otherwise why would we charge their memory to some specific container)?
>

It is useful for containerized environments.
The container which pinned bpf can use it.
In our case we may use it in two ways as I explained in the prev mail that,
1) The one who load the bpf who do the recharge
2) A sidecar to maintain the bpf cycle

For the systemd, it may need to do some extend that,
The bpf services should describe,
1) if the bpf service needs the recharge (the one who limited by memcg
should be forcefully do the recharge)
2) the pinned progs and maps to check
3) the service identifier (with which we can get the target memcg)

We don't have the case that the bpf map is shared by multiple cgroups,
that should be a rare case.
I think that case is similar to the sharing page caches across
multiple cgroups, which are used by many cgroups but only charged to
one specific memcg.

> Btw, aren't you able to run a new container in the same cgroup? Or associate
> the bpf map with the persistent parent cgroup?
>

We have discussed if we can keep the parent cgroup alive, but
unfortunately it can't be guaranteed.
It may be hard and not flexible  to run a new container in the same
cgroup, which requires to not rmdir cgroup and use it again in the
next time.

-- 
Thanks
Yafang
