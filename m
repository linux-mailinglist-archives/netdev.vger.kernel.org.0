Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE7E39EBC6
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 04:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhFHCD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 22:03:58 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:36408 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhFHCD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 22:03:57 -0400
Received: by mail-pl1-f171.google.com with SMTP id x10so9768540plg.3;
        Mon, 07 Jun 2021 19:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AfMJN7IilsGHNuPERmHq9zf2KFhLMBNfwwsbAyT0Als=;
        b=rhdRj++26rAxE3rXyhe+qLdgvbI0vW4QDNlWXHakK+U6V8n7l5y4VOHjiv01AiLqsW
         PtCfheBoyqUb1gGVpLcNbRKmMgIxGJoOk/feUCF+SxKi6PFmTNgyBpkJg73BvcdB7eDM
         YQtGs0vme1EdMnnZcD0cQel9eCh3KnM234WWTZGTaqaeRHy/kl93p7u2wtdpmfhAvFva
         CBHPlVVMLe2Sf+dcZpBIK2//fCoqLNQYKySJJX/hchjaeyCgPHVdOA005euPJd7FFjqB
         ihTxXPU8Cmn0vvLM5vUg8nR5nqQJMT2cWo1Yqia2hmNqtT8GdI9Ps+rQEAankIafc2bL
         1FgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AfMJN7IilsGHNuPERmHq9zf2KFhLMBNfwwsbAyT0Als=;
        b=JZ7zAfA9/1tuwl+1tH39sawrLy9boPNVLAAqWqiAnypkWzAt20mdZemTPAFitvsLww
         RowhfK3nMifNB++VsMvnJ33ydEJGcm7PUV77sQ9jcEaN7gr3M/0G5+AAB7gMb7BphVGd
         GUv9CgpAWEo/hcpVURRuikmivAeDVLax6FEYK5q+JEpJXxXiAcqVTLBCOwAusbnwEZrU
         iausQuy9IOaeAvCm/lSdOE7r6FejUMUxrwuyYn4vgaMr4Z1/MH7zgqg292vOuklAmLiA
         dsoLdo1bzfl7krLrV0AjintPaYrCDl23WweqZN7AaL6i9Mxosh/KBj4etkoYjHfB77JZ
         9qqg==
X-Gm-Message-State: AOAM530bWDdyhAVOx40k3c94b2QKFMM1+SIeLBVN2+bRilzWx2310lQP
        71GCj/SnqW8n0Rqxe1rdF9qlJUq4resSaMLBQVE=
X-Google-Smtp-Source: ABdhPJxgdP+ESAfy7LsYqxsKQgxqZt8re17wkWXkn9MAUC6ixJVaqhfdA1vplxf9zbiCXQAaQTdt6q4CH0TRbYU9gg4=
X-Received: by 2002:a17:902:b288:b029:111:4a4f:9917 with SMTP id
 u8-20020a170902b288b02901114a4f9917mr11805562plr.70.1623117651923; Mon, 07
 Jun 2021 19:00:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210528195946.2375109-1-memxor@gmail.com> <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo> <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
 <20210607060724.4nidap5eywb23l3d@apollo>
In-Reply-To: <20210607060724.4nidap5eywb23l3d@apollo>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 7 Jun 2021 19:00:40 -0700
Message-ID: <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 6, 2021 at 11:08 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Mon, Jun 07, 2021 at 10:48:04AM IST, Cong Wang wrote:
> > On Sun, Jun 6, 2021 at 8:38 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > >
> > > On Mon, Jun 07, 2021 at 05:07:28AM IST, Cong Wang wrote:
> > > > On Fri, May 28, 2021 at 1:00 PM Kumar Kartikeya Dwivedi
> > > > <memxor@gmail.com> wrote:
> > > > >
> > > > > This is the first RFC version.
> > > > >
> > > > > This adds a bpf_link path to create TC filters tied to cls_bpf classifier, and
> > > > > introduces fd based ownership for such TC filters. Netlink cannot delete or
> > > > > replace such filters, but the bpf_link is severed on indirect destruction of the
> > > > > filter (backing qdisc being deleted, or chain being flushed, etc.). To ensure
> > > > > that filters remain attached beyond process lifetime, the usual bpf_link fd
> > > > > pinning approach can be used.
> > > >
> > > > I have some troubles understanding this. So... why TC filter is so special
> > > > here that it deserves such a special treatment?
> > > >
> > >
> > > So the motivation behind this was automatic cleanup of filters installed by some
> > > program. Usually from the userspace side you need a bunch of things (handle,
> > > priority, protocol, chain_index, etc.) to be able to delete a filter without
> > > stepping on others' toes. Also, there is no gurantee that filter hasn't been
> > > replaced, so you need to check some other way (either tag or prog_id, but these
> > > are also not perfect).
> > >
> > > bpf_link provides isolation from netlink and fd-based lifetime management. As
> > > for why it needs special treatment (by which I guess you mean why it _creates_
> > > an object instead of simply attaching to one, see below):
> >
> > Are you saying TC filter is not independent? IOW, it has to rely on TC qdisc
> > to exist. This is true, and is of course different with netns/cgroup.
> > This is perhaps
> > not hard to solve, because TC actions are already independent, we can perhaps
> > convert TC filters too (the biggest blocker is compatibility).
> >
>
> True, but that would mean you need some way to create a detached TC filter, correct?
> Can you give some ideas on how the setup would look like from userspace side?
>
> IIUC you mean
>
> RTM_NEWTFILTER (with kind == bpf) parent == SOME_MAGIC_DETACHED ifindex == INVALID
>
> then bpf_link comes in and creates the binding to the qdisc, parent, prio,
> chain, handle ... ?

Roughly yes, except creation is still done by netlink, not bpf_link. It is
pretty much similar to those unbound TC actions.

>
> > Or do you just need an ephemeral representation of a TC filter which only exists
> > for a process? If so, see below.
> >
> > >
> > > > The reason why I ask is that none of other bpf links actually create any
> > > > object, they merely attach bpf program to an existing object. For example,
> > > > netns bpf_link does not create an netns, cgroup bpf_link does not create
> > > > a cgroup either. So, why TC filter is so lucky to be the first one requires
> > > > creating an object?
> > > >
> > >
> > > They are created behind the scenes, but are also fairly isolated from netlink
> > > (i.e.  can only be introspected, so not hidden in that sense, but are
> > > effectively locked for replace/delete).
> > >
> > > The problem would be (of not creating a filter during attach) is that a typical
> > > 'attach point' for TC exists in form of tcf_proto. If we take priority (protocol
> > > is fixed) out of the equation, it becomes possible to attach just a single BPF
> > > prog, but that seems like a needless limitation when TC already supports list of
> > > filters at each 'attach point'.
> > >
> > > My point is that the created object (the tcf_proto under the 'chain' object) is
> > > the attach point, and since there can be so many, keeping them around at all
> > > times doesn't make sense, so the refcounted attach locations are created as
> > > needed.  Both netlink and bpf_link owned filters can be attached under the same
> > > location, with different ownership story in userspace.
> >
> > I do not understand "created behind the scenes". These are all created
> > independent of bpf_link, right? For example, we create a cgroup with
> > mkdir, then open it and pass the fd to bpf_link. Clearly, cgroup is not
> > created by bpf_link or any bpf syscall.
>
> Sorry, that must be confusing. I was only referring to what this patch does.
> Indeed, as far as implementation is concerned this has no precedence.
>
> >
> > The only thing different is fd, or more accurately, an identifier to locate
> > these objects. For example, ifindex can also be used to locate a netdev.
> > We can certainly locate a TC filter with (prio,proto,handle) but this has to
> > be passed via netlink. So if you need some locator, I think we can
> > introduce a kernel API which takes all necessary parameters to locate
> > a TC filter and return it to you. For a quick example, like this:
> >
> > struct tcf_proto *tcf_get_proto(struct net *net, int ifindex,
> >                                 int parent, char* kind, int handle...);
> >
>
> I think this already exists in some way, i.e. you can just ignore if filter
> handle from tp->ops->get doesn't exist (reusing the exsiting code) that walks
> from qdisc/block -> chain -> tcf_proto during creation.

Right, except currently it requires a few API's to reach TC filters
(first netdev,,
then qdisc, finally filters). So, I think providing one API could at
least address
your "stepping on others toes" concern?

>
> > (Note, it can grab a refcnt in case of being deleted by others.)
> >
> > With this, you can simply call it in bpf_link, and attach bpf prog to tcf_proto
> > (of course, only cls_bpf succeeds here).
> >
>
> So IIUC, you are proposing to first create a filter normally using netlink, then
> attach it using bpf_link to the proper parent? I.e. your main contention point
> is to not create filter from bpf_link, instead take a filter and attach it to a
> parent with bpf_link representing this attachment?

Yes, to me I don't see a reason we want to create it from bpf_link.

>
> But then the created filter stays with refcount of 1 until RTM_DELTFILTER, i.e.
> the lifetime of the attachment may be managed by bpf_link (in that we can detach
> the filter from parent) but the filter itself will not be cleaned up. One of the
> goals of tying TC filter to fd was to bind lifetime of filter itself, along with
> attachment. Separating both doesn't seem to buy anything here. You always create
> a filter to attach somewhere.

This is really odd, for two reasons:

1) Why netdev does not have such problem? bpf_xdp_link_attach() uses
ifindex to locate a netdev, without creating it or cleaning it either.
So, why do we
never want to bind a netdev to an fd? IOW, what makes TC filters' lifetime so
different from netdev?

2) All existing bpf_link targets, except netdev, are fs based, hence an fd makes
sense for them naturally. TC filters, or any other netlink based
things, are not even
related to fs, hence fd does not make sense here, like we never bind a netdev
to a fd.

>
> With actions, things are different, you may create one action but bind it to
> multiple filters, so actions existing as their own thing makes sense. A single
> action can serve multiple filters, and save on memory.
>
> You could argue that even with filters this is true, as you may want to attach
> the same filter to multiple qdiscs, but we already have a facility to do that
> (shared tcf_block with block->q == NULL). However that is not as flexible as
> what you are proposing.

True. I think making TC filters as standalone as TC actions is a right
direction,
if it helps you too.

>
> It may be odd from the kernel side but to userspace a parent, prio, handle (we
> don't let user choose anything else for now) is itself the attach point, how
> bpf_link manages the attachment internally isn't really that interesting. It
> does so now by way of creating an object that represents a certain hook, then
> binding the BPF prog to it. I consider this mostly an implementation detail.
> What you are really attaching to is the qdisc/block, which is the resource
> analogous to cgroup fd, netns fd, and ifindex, and 'where' is described by other
> attributes.

How do you establish the analogy here? cgroup and netns are fs based,
having an fd is natural. ifindex is not an fd, it is a locator for netdev. Plus,
current bpf_link code does not create any of them.

Thanks.
