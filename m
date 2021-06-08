Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9178F39EF6F
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 09:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhFHHXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 03:23:12 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:53031 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFHHXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 03:23:11 -0400
Received: by mail-pj1-f68.google.com with SMTP id h16so11380594pjv.2;
        Tue, 08 Jun 2021 00:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uwPmcgsErKGsRSEvUd47heWn3nqbIZNjUXH9S0Z9yQY=;
        b=K8RqIoaoqyTFVrEJodbh2hK5+9dNmKBhtIGrOmQjJiWw2HlTcZdWIpjtuj384jf/qA
         +ih17l8jMBBlmZnarcoMtufLvuU5kyvgubwRnuqlt2yYFIT5y/PMmaYTOQ1qyQEVCqpF
         2YojQ/SUvmeqvoVqXPMFz42P9oNQHF3MaBRqbsrs76LHhib6ArZdmaFeQ4wQsNdGpVcI
         0Obov49zOQikhcKJ6ekfsQEV4B+Ve/Q8hV37Q7rg4mBMlpciApi5UMXPCY9E/dQ+HBGd
         kFT8ILlX/U2RvD/2eRcDZljPfd7LQpOf4+l3SAp/QBFwmyFoNZYse2ukeWkxDtXht8oF
         qtxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uwPmcgsErKGsRSEvUd47heWn3nqbIZNjUXH9S0Z9yQY=;
        b=jDzE71vV4MzTSvGlJhW+b2dUjAzMcM3LgKnYy5ObdJm9XhRqZTrnfMRwgli46D5F6A
         l3D78g1lyMmIP+OnXFPnLh5OjmNljD3KTc5zvXhU0fgRbrAxufEZgk7/BAdWu2h1eAYv
         AkxYnnU23AWnzLGOXM9PRNcIrHdWNHKWfkao/lH8s8gM0KSPlLWDo0UMwYhtU0QVQSPO
         UZOlvyOW/hXADsRejMTmyUdFm9pPjSEhlE8TkCDUlat+dHrN9feTpIrvBUndiWJZjPBz
         VsaZgVo1UZBLWB4SbknW0CoOqVo51XuwhAsJKK3gfNEMOQWZ6OyRWHbMSyS9QdvKt5mB
         9keQ==
X-Gm-Message-State: AOAM533FzX+MpLrgYt/wFHmjEV98YsQctMc9Cj3x0+SUdsjeFO9AE6Vx
        yf7yPKNOAiwdzZ9P88aZuM8=
X-Google-Smtp-Source: ABdhPJw29EYyo4OjDNe7ywynr0fFT4Qmc71M+W6YDjE2wI2VhjQ7pq2zJUbxejubPxoKFsJqIPCNUw==
X-Received: by 2002:a17:903:152:b029:10f:f6f7:ede5 with SMTP id r18-20020a1709030152b029010ff6f7ede5mr18285994plc.20.1623136819022;
        Tue, 08 Jun 2021 00:20:19 -0700 (PDT)
Received: from localhost ([2409:4063:4d88:2509:73dd:f13e:e799:d790])
        by smtp.gmail.com with ESMTPSA id n6sm10612766pgm.79.2021.06.08.00.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 00:20:18 -0700 (PDT)
Date:   Tue, 8 Jun 2021 12:49:08 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
Message-ID: <20210608071908.sos275adj3gunewo@apollo>
References: <20210528195946.2375109-1-memxor@gmail.com>
 <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo>
 <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
 <20210607060724.4nidap5eywb23l3d@apollo>
 <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 07:30:40AM IST, Cong Wang wrote:
> On Sun, Jun 6, 2021 at 11:08 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Mon, Jun 07, 2021 at 10:48:04AM IST, Cong Wang wrote:
> > > On Sun, Jun 6, 2021 at 8:38 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > > >
> > > > On Mon, Jun 07, 2021 at 05:07:28AM IST, Cong Wang wrote:
> > > > > On Fri, May 28, 2021 at 1:00 PM Kumar Kartikeya Dwivedi
> > > > > <memxor@gmail.com> wrote:
> > > > > >
> > > > > > This is the first RFC version.
> > > > > >
> > > > > > This adds a bpf_link path to create TC filters tied to cls_bpf classifier, and
> > > > > > introduces fd based ownership for such TC filters. Netlink cannot delete or
> > > > > > replace such filters, but the bpf_link is severed on indirect destruction of the
> > > > > > filter (backing qdisc being deleted, or chain being flushed, etc.). To ensure
> > > > > > that filters remain attached beyond process lifetime, the usual bpf_link fd
> > > > > > pinning approach can be used.
> > > > >
> > > > > I have some troubles understanding this. So... why TC filter is so special
> > > > > here that it deserves such a special treatment?
> > > > >
> > > >
> > > > So the motivation behind this was automatic cleanup of filters installed by some
> > > > program. Usually from the userspace side you need a bunch of things (handle,
> > > > priority, protocol, chain_index, etc.) to be able to delete a filter without
> > > > stepping on others' toes. Also, there is no gurantee that filter hasn't been
> > > > replaced, so you need to check some other way (either tag or prog_id, but these
> > > > are also not perfect).
> > > >
> > > > bpf_link provides isolation from netlink and fd-based lifetime management. As
> > > > for why it needs special treatment (by which I guess you mean why it _creates_
> > > > an object instead of simply attaching to one, see below):
> > >
> > > Are you saying TC filter is not independent? IOW, it has to rely on TC qdisc
> > > to exist. This is true, and is of course different with netns/cgroup.
> > > This is perhaps
> > > not hard to solve, because TC actions are already independent, we can perhaps
> > > convert TC filters too (the biggest blocker is compatibility).
> > >
> >
> > True, but that would mean you need some way to create a detached TC filter, correct?
> > Can you give some ideas on how the setup would look like from userspace side?
> >
> > IIUC you mean
> >
> > RTM_NEWTFILTER (with kind == bpf) parent == SOME_MAGIC_DETACHED ifindex == INVALID
> >
> > then bpf_link comes in and creates the binding to the qdisc, parent, prio,
> > chain, handle ... ?
>
> Roughly yes, except creation is still done by netlink, not bpf_link. It is
> pretty much similar to those unbound TC actions.
>

Right, thanks for explaining. I will try to work on this and see if it works out.

> >
> > > Or do you just need an ephemeral representation of a TC filter which only exists
> > > for a process? If so, see below.
> > >
> > > >
> > > > > The reason why I ask is that none of other bpf links actually create any
> > > > > object, they merely attach bpf program to an existing object. For example,
> > > > > netns bpf_link does not create an netns, cgroup bpf_link does not create
> > > > > a cgroup either. So, why TC filter is so lucky to be the first one requires
> > > > > creating an object?
> > > > >
> > > >
> > > > They are created behind the scenes, but are also fairly isolated from netlink
> > > > (i.e.  can only be introspected, so not hidden in that sense, but are
> > > > effectively locked for replace/delete).
> > > >
> > > > The problem would be (of not creating a filter during attach) is that a typical
> > > > 'attach point' for TC exists in form of tcf_proto. If we take priority (protocol
> > > > is fixed) out of the equation, it becomes possible to attach just a single BPF
> > > > prog, but that seems like a needless limitation when TC already supports list of
> > > > filters at each 'attach point'.
> > > >
> > > > My point is that the created object (the tcf_proto under the 'chain' object) is
> > > > the attach point, and since there can be so many, keeping them around at all
> > > > times doesn't make sense, so the refcounted attach locations are created as
> > > > needed.  Both netlink and bpf_link owned filters can be attached under the same
> > > > location, with different ownership story in userspace.
> > >
> > > I do not understand "created behind the scenes". These are all created
> > > independent of bpf_link, right? For example, we create a cgroup with
> > > mkdir, then open it and pass the fd to bpf_link. Clearly, cgroup is not
> > > created by bpf_link or any bpf syscall.
> >
> > Sorry, that must be confusing. I was only referring to what this patch does.
> > Indeed, as far as implementation is concerned this has no precedence.
> >
> > >
> > > The only thing different is fd, or more accurately, an identifier to locate
> > > these objects. For example, ifindex can also be used to locate a netdev.
> > > We can certainly locate a TC filter with (prio,proto,handle) but this has to
> > > be passed via netlink. So if you need some locator, I think we can
> > > introduce a kernel API which takes all necessary parameters to locate
> > > a TC filter and return it to you. For a quick example, like this:
> > >
> > > struct tcf_proto *tcf_get_proto(struct net *net, int ifindex,
> > >                                 int parent, char* kind, int handle...);
> > >
> >
> > I think this already exists in some way, i.e. you can just ignore if filter
> > handle from tp->ops->get doesn't exist (reusing the exsiting code) that walks
> > from qdisc/block -> chain -> tcf_proto during creation.
>
> Right, except currently it requires a few API's to reach TC filters
> (first netdev,,
> then qdisc, finally filters). So, I think providing one API could at
> least address
> your "stepping on others toes" concern?
>
> >
> > > (Note, it can grab a refcnt in case of being deleted by others.)
> > >
> > > With this, you can simply call it in bpf_link, and attach bpf prog to tcf_proto
> > > (of course, only cls_bpf succeeds here).
> > >
> >
> > So IIUC, you are proposing to first create a filter normally using netlink, then
> > attach it using bpf_link to the proper parent? I.e. your main contention point
> > is to not create filter from bpf_link, instead take a filter and attach it to a
> > parent with bpf_link representing this attachment?
>
> Yes, to me I don't see a reason we want to create it from bpf_link.
>
> >
> > But then the created filter stays with refcount of 1 until RTM_DELTFILTER, i.e.
> > the lifetime of the attachment may be managed by bpf_link (in that we can detach
> > the filter from parent) but the filter itself will not be cleaned up. One of the
> > goals of tying TC filter to fd was to bind lifetime of filter itself, along with
> > attachment. Separating both doesn't seem to buy anything here. You always create
> > a filter to attach somewhere.
>
> This is really odd, for two reasons:
>
> 1) Why netdev does not have such problem? bpf_xdp_link_attach() uses
> ifindex to locate a netdev, without creating it or cleaning it either.
> So, why do we
> never want to bind a netdev to an fd? IOW, what makes TC filters' lifetime so
> different from netdev?
>

I think I tried to explain the difference, but I may have failed.

netdev does not have this problem because netdev is to XDP prog what qdisc is to
a SCHED_CLS prog. The filter is merely a way to hook into the qdisc. So we bind
the attachment's lifetime to the filter's lifetime, which in turn is controlled
by the bpf_link fd. When the filter is gone, the attachment to the qdisc is gone.

So we're not really creating a qdisc here, we're just tying the filter (which in
the current semantics exists only while attached) to the bpf_link. The filter is
the attachment, so tying its lifetime to bpf_link makes sense. When you destroy
the bpf_link, the filter goes away too, which means classification at that
hook (parent/class) in the qdisc stops working. This is why creating the filter
from the bpf_link made sense to me.

I hope you can see where I was going with this now.  Introducing a new kind of
method to attach to qdisc didn't seem wise to me, given all the infrastructure
already exists.

> 2) All existing bpf_link targets, except netdev, are fs based, hence an fd makes
> sense for them naturally. TC filters, or any other netlink based
> things, are not even
> related to fs, hence fd does not make sense here, like we never bind a netdev
> to a fd.
>

Yes, none of them create any objects. It is only a side effect of current
semantics that you are able to control the filter's lifetime using the bpf_link
as filter creation is also accompanied with its attachment to the qdisc.

Your unbound filter idea just separates the two. One will still end up creating
a cls_bpf_prog object internally in the kernel, just that it will now be
refcounted and be linked into multiple tcf_proto (based on how many bpf_link's
are attached).

Another additional responsibility of the user space is to now clean up these
unbound filters when it is done using them (either right after making a bpf_link
attachment so that it is removed on bpf_link destruction, or later), because
they don't sit under any chain etc. so a full flush of filters won't remove
them.

> >
> > With actions, things are different, you may create one action but bind it to
> > multiple filters, so actions existing as their own thing makes sense. A single
> > action can serve multiple filters, and save on memory.
> >
> > You could argue that even with filters this is true, as you may want to attach
> > the same filter to multiple qdiscs, but we already have a facility to do that
> > (shared tcf_block with block->q == NULL). However that is not as flexible as
> > what you are proposing.
>
> True. I think making TC filters as standalone as TC actions is a right
> direction,
> if it helps you too.
>
> >
> > It may be odd from the kernel side but to userspace a parent, prio, handle (we
> > don't let user choose anything else for now) is itself the attach point, how
> > bpf_link manages the attachment internally isn't really that interesting. It
> > does so now by way of creating an object that represents a certain hook, then
> > binding the BPF prog to it. I consider this mostly an implementation detail.
> > What you are really attaching to is the qdisc/block, which is the resource
> > analogous to cgroup fd, netns fd, and ifindex, and 'where' is described by other
> > attributes.
>
> How do you establish the analogy here? cgroup and netns are fs based,
> having an fd is natural. ifindex is not an fd, it is a locator for netdev. Plus,
> current bpf_link code does not create any of them.
>
> Thanks.

--
Kartikeya
