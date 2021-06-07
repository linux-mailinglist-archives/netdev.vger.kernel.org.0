Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3A539D4A9
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 08:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhFGGKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 02:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhFGGKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 02:10:37 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23F0C061787;
        Sun,  6 Jun 2021 23:08:33 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id v13so8041027ple.9;
        Sun, 06 Jun 2021 23:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XX/Cz/jPDNz70lBll3Fz6hXSYN53/2SVvORBvn52j8w=;
        b=Ok01GTXNXChMjjWwhILN0OzaB1n0MrOoA6DbgesNwxDIjJh2y3dbudNy++f190NYvv
         GXmPO6Jz6Ei9my2Mb6g+/X71w1aVSkh6YCm9ELcfzuZsDGoCG+dpHJpcBShAwwHmQHPR
         u5Eii06UzApu0VrDkYhE/nXF1D7AFVKQCjzZNwp5AI7C4x948R2hWW7M2laoaZeByq/+
         nUe5DL6K9lM5bgJwhW5dg+5Y7FXz8q1Pe4Ly3vE2KJwpki9ZPDvbmasa9Mx4BmFzmZr8
         HSz1RdU8Edb309FaX4FqXyzoHCzwLraO0gtLVnysA31iHGWN6mNqcHk5JcmjlnSoZACD
         vpDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XX/Cz/jPDNz70lBll3Fz6hXSYN53/2SVvORBvn52j8w=;
        b=ky7j7kAyItn3VPJWiQCeThqisjWUGXdCLFKNCg1UA07pDtcQYnIXzjquYmBH41LKJS
         vbdry5Qu3m2Ht6KRQ9iGOgjW5ePmC8PblFAHpVn46trCHOCkfWfXAtl0L611Y9ix4+X8
         qWXKs2tIGtear4rZuAT8uu/FCFVr9+8fWJQK4kWrApyhe5ZSmjkjSu/g+s/f9vVd47ko
         H0GJNHaWKVjI65vazD+lFnDYi0G8DB8eLAvmInBAQ5PSEtfnTMiZ5C3apeYSIBcFMp5n
         HrVGtKcMhxme0g8OAR8VfC6F/SIiQyd1IEnFMIxg3C0+lJYSdOQCAOy2NrB/k4R+npNf
         JxQw==
X-Gm-Message-State: AOAM530NZVZ6iVJ3iuLGCOFRccr/A9pD559m9M+RbR348B/QPJPO2Jb7
        TclrEvr7MkoRkLVxyfUyXPE=
X-Google-Smtp-Source: ABdhPJz1busZjVB3pJZ2+lpCj29b2eeKI5qFJ2YSYy+/c+x9mNzAdCGyjCuP7fEiGjV1O3VIk7j9sg==
X-Received: by 2002:a17:902:9f83:b029:f6:5c3c:db03 with SMTP id g3-20020a1709029f83b02900f65c3cdb03mr16632393plq.2.1623046113059;
        Sun, 06 Jun 2021 23:08:33 -0700 (PDT)
Received: from localhost ([2402:3a80:11c3:8bc4:aa5:8732:af1e:76c3])
        by smtp.gmail.com with ESMTPSA id o17sm10980510pjp.33.2021.06.06.23.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 23:08:32 -0700 (PDT)
Date:   Mon, 7 Jun 2021 11:37:24 +0530
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
Message-ID: <20210607060724.4nidap5eywb23l3d@apollo>
References: <20210528195946.2375109-1-memxor@gmail.com>
 <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo>
 <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 10:48:04AM IST, Cong Wang wrote:
> On Sun, Jun 6, 2021 at 8:38 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> >
> > On Mon, Jun 07, 2021 at 05:07:28AM IST, Cong Wang wrote:
> > > On Fri, May 28, 2021 at 1:00 PM Kumar Kartikeya Dwivedi
> > > <memxor@gmail.com> wrote:
> > > >
> > > > This is the first RFC version.
> > > >
> > > > This adds a bpf_link path to create TC filters tied to cls_bpf classifier, and
> > > > introduces fd based ownership for such TC filters. Netlink cannot delete or
> > > > replace such filters, but the bpf_link is severed on indirect destruction of the
> > > > filter (backing qdisc being deleted, or chain being flushed, etc.). To ensure
> > > > that filters remain attached beyond process lifetime, the usual bpf_link fd
> > > > pinning approach can be used.
> > >
> > > I have some troubles understanding this. So... why TC filter is so special
> > > here that it deserves such a special treatment?
> > >
> >
> > So the motivation behind this was automatic cleanup of filters installed by some
> > program. Usually from the userspace side you need a bunch of things (handle,
> > priority, protocol, chain_index, etc.) to be able to delete a filter without
> > stepping on others' toes. Also, there is no gurantee that filter hasn't been
> > replaced, so you need to check some other way (either tag or prog_id, but these
> > are also not perfect).
> >
> > bpf_link provides isolation from netlink and fd-based lifetime management. As
> > for why it needs special treatment (by which I guess you mean why it _creates_
> > an object instead of simply attaching to one, see below):
>
> Are you saying TC filter is not independent? IOW, it has to rely on TC qdisc
> to exist. This is true, and is of course different with netns/cgroup.
> This is perhaps
> not hard to solve, because TC actions are already independent, we can perhaps
> convert TC filters too (the biggest blocker is compatibility).
>

True, but that would mean you need some way to create a detached TC filter, correct?
Can you give some ideas on how the setup would look like from userspace side?

IIUC you mean

RTM_NEWTFILTER (with kind == bpf) parent == SOME_MAGIC_DETACHED ifindex == INVALID

then bpf_link comes in and creates the binding to the qdisc, parent, prio,
chain, handle ... ?

> Or do you just need an ephemeral representation of a TC filter which only exists
> for a process? If so, see below.
>
> >
> > > The reason why I ask is that none of other bpf links actually create any
> > > object, they merely attach bpf program to an existing object. For example,
> > > netns bpf_link does not create an netns, cgroup bpf_link does not create
> > > a cgroup either. So, why TC filter is so lucky to be the first one requires
> > > creating an object?
> > >
> >
> > They are created behind the scenes, but are also fairly isolated from netlink
> > (i.e.  can only be introspected, so not hidden in that sense, but are
> > effectively locked for replace/delete).
> >
> > The problem would be (of not creating a filter during attach) is that a typical
> > 'attach point' for TC exists in form of tcf_proto. If we take priority (protocol
> > is fixed) out of the equation, it becomes possible to attach just a single BPF
> > prog, but that seems like a needless limitation when TC already supports list of
> > filters at each 'attach point'.
> >
> > My point is that the created object (the tcf_proto under the 'chain' object) is
> > the attach point, and since there can be so many, keeping them around at all
> > times doesn't make sense, so the refcounted attach locations are created as
> > needed.  Both netlink and bpf_link owned filters can be attached under the same
> > location, with different ownership story in userspace.
>
> I do not understand "created behind the scenes". These are all created
> independent of bpf_link, right? For example, we create a cgroup with
> mkdir, then open it and pass the fd to bpf_link. Clearly, cgroup is not
> created by bpf_link or any bpf syscall.

Sorry, that must be confusing. I was only referring to what this patch does.
Indeed, as far as implementation is concerned this has no precedence.

>
> The only thing different is fd, or more accurately, an identifier to locate
> these objects. For example, ifindex can also be used to locate a netdev.
> We can certainly locate a TC filter with (prio,proto,handle) but this has to
> be passed via netlink. So if you need some locator, I think we can
> introduce a kernel API which takes all necessary parameters to locate
> a TC filter and return it to you. For a quick example, like this:
>
> struct tcf_proto *tcf_get_proto(struct net *net, int ifindex,
>                                 int parent, char* kind, int handle...);
>

I think this already exists in some way, i.e. you can just ignore if filter
handle from tp->ops->get doesn't exist (reusing the exsiting code) that walks
from qdisc/block -> chain -> tcf_proto during creation.

> (Note, it can grab a refcnt in case of being deleted by others.)
>
> With this, you can simply call it in bpf_link, and attach bpf prog to tcf_proto
> (of course, only cls_bpf succeeds here).
>

So IIUC, you are proposing to first create a filter normally using netlink, then
attach it using bpf_link to the proper parent? I.e. your main contention point
is to not create filter from bpf_link, instead take a filter and attach it to a
parent with bpf_link representing this attachment?

But then the created filter stays with refcount of 1 until RTM_DELTFILTER, i.e.
the lifetime of the attachment may be managed by bpf_link (in that we can detach
the filter from parent) but the filter itself will not be cleaned up. One of the
goals of tying TC filter to fd was to bind lifetime of filter itself, along with
attachment. Separating both doesn't seem to buy anything here. You always create
a filter to attach somewhere.

With actions, things are different, you may create one action but bind it to
multiple filters, so actions existing as their own thing makes sense. A single
action can serve multiple filters, and save on memory.

You could argue that even with filters this is true, as you may want to attach
the same filter to multiple qdiscs, but we already have a facility to do that
(shared tcf_block with block->q == NULL). However that is not as flexible as
what you are proposing.

It may be odd from the kernel side but to userspace a parent, prio, handle (we
don't let user choose anything else for now) is itself the attach point, how
bpf_link manages the attachment internally isn't really that interesting. It
does so now by way of creating an object that represents a certain hook, then
binding the BPF prog to it. I consider this mostly an implementation detail.
What you are really attaching to is the qdisc/block, which is the resource
analogous to cgroup fd, netns fd, and ifindex, and 'where' is described by other
attributes.

> Thanks.

--
Kartikeya
