Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8F939D448
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 07:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhFGFUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 01:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhFGFUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 01:20:22 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E20C061766;
        Sun,  6 Jun 2021 22:18:15 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id l1so12952952pgm.1;
        Sun, 06 Jun 2021 22:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B0kpbwlLEKHffTb9r0y58pRuUyIlCbeO2oTPDW9l57g=;
        b=s8X0WucaKQsIlDWYUBvEpgZZ49HcKRQJjSMgds1BeX75oTXQZzHFaDTccTbsKie4fT
         r/ROR//NNybAI3wtjbO1qoal9HuNEyreAUVJkQ/doyW8+sWxuXSU3DYEQtSIPMmmTsMU
         2kJgiK24JXVu+bSYofJJ8mTUsYY3UWYhGKw1rLRBNaoNdBtRXk/qLYGS7D84WDgvH8ri
         9AvJ6wMMQR+lDgA0OH1dOxEXdH2qQm9Q5zfIT5JMSB8gTKsJ8jNF56IAB+SJ3YMlNKnH
         +eltmuxN1T6NocpijSeMUELA6lq44mLxNSC4y1uRI9gfxhHZrjuU0lqzH46+Po7ca6Oh
         svNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B0kpbwlLEKHffTb9r0y58pRuUyIlCbeO2oTPDW9l57g=;
        b=mEQAl1F+522V323BTZ2UfK3ws0uUVyvyyr4hFHr3bC58MSQfpQlw2kDytNzPxKAPIw
         fI8h8LNC9LUaoho2iGHZgajz5bTB33F0ghzHNq5fEAgyixm+r6DU6SRUCN1XHsOoPNVr
         LVO1Iun7OTPyKYmyxJALtW91OAcCxogdeBl7WflVcnW0CpeoH6l51bvzxQsemSxwruOI
         uci33KDoZbfWriDgJieEV3zgCW/GOKapJW+q9A7FMTiGqPVfiOPOXjqWxVW2HvfvTR7i
         z3NxEY66tyHU5dm/hKGttjmfCV/HygCdXD4dx/kHauv9PEFmkcoIORH9KZWVReb/JmJM
         UrDw==
X-Gm-Message-State: AOAM530dmu6+QeqlkLD2GhnovkCRcgPsfdA1p06+io49F7DWITSBsJva
        zgo5M4ZlXTvEeSLXMupH8oJF1v4D1NuDPJf0eiU=
X-Google-Smtp-Source: ABdhPJz3S99YhwWL0SmLfjaCB6WpYXOWwIfjbb4sHdWse1F4jkYEK+gi/v/LU+XFNPS1LuRc8bk38T2I935zQVjqGcA=
X-Received: by 2002:a63:e709:: with SMTP id b9mr16334126pgi.18.1623043095039;
 Sun, 06 Jun 2021 22:18:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210528195946.2375109-1-memxor@gmail.com> <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo>
In-Reply-To: <20210607033724.wn6qn4v42dlm4j4o@apollo>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 6 Jun 2021 22:18:04 -0700
Message-ID: <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
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

On Sun, Jun 6, 2021 at 8:38 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> On Mon, Jun 07, 2021 at 05:07:28AM IST, Cong Wang wrote:
> > On Fri, May 28, 2021 at 1:00 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > This is the first RFC version.
> > >
> > > This adds a bpf_link path to create TC filters tied to cls_bpf classifier, and
> > > introduces fd based ownership for such TC filters. Netlink cannot delete or
> > > replace such filters, but the bpf_link is severed on indirect destruction of the
> > > filter (backing qdisc being deleted, or chain being flushed, etc.). To ensure
> > > that filters remain attached beyond process lifetime, the usual bpf_link fd
> > > pinning approach can be used.
> >
> > I have some troubles understanding this. So... why TC filter is so special
> > here that it deserves such a special treatment?
> >
>
> So the motivation behind this was automatic cleanup of filters installed by some
> program. Usually from the userspace side you need a bunch of things (handle,
> priority, protocol, chain_index, etc.) to be able to delete a filter without
> stepping on others' toes. Also, there is no gurantee that filter hasn't been
> replaced, so you need to check some other way (either tag or prog_id, but these
> are also not perfect).
>
> bpf_link provides isolation from netlink and fd-based lifetime management. As
> for why it needs special treatment (by which I guess you mean why it _creates_
> an object instead of simply attaching to one, see below):

Are you saying TC filter is not independent? IOW, it has to rely on TC qdisc
to exist. This is true, and is of course different with netns/cgroup.
This is perhaps
not hard to solve, because TC actions are already independent, we can perhaps
convert TC filters too (the biggest blocker is compatibility).

Or do you just need an ephemeral representation of a TC filter which only exists
for a process? If so, see below.

>
> > The reason why I ask is that none of other bpf links actually create any
> > object, they merely attach bpf program to an existing object. For example,
> > netns bpf_link does not create an netns, cgroup bpf_link does not create
> > a cgroup either. So, why TC filter is so lucky to be the first one requires
> > creating an object?
> >
>
> They are created behind the scenes, but are also fairly isolated from netlink
> (i.e.  can only be introspected, so not hidden in that sense, but are
> effectively locked for replace/delete).
>
> The problem would be (of not creating a filter during attach) is that a typical
> 'attach point' for TC exists in form of tcf_proto. If we take priority (protocol
> is fixed) out of the equation, it becomes possible to attach just a single BPF
> prog, but that seems like a needless limitation when TC already supports list of
> filters at each 'attach point'.
>
> My point is that the created object (the tcf_proto under the 'chain' object) is
> the attach point, and since there can be so many, keeping them around at all
> times doesn't make sense, so the refcounted attach locations are created as
> needed.  Both netlink and bpf_link owned filters can be attached under the same
> location, with different ownership story in userspace.

I do not understand "created behind the scenes". These are all created
independent of bpf_link, right? For example, we create a cgroup with
mkdir, then open it and pass the fd to bpf_link. Clearly, cgroup is not
created by bpf_link or any bpf syscall.

The only thing different is fd, or more accurately, an identifier to locate
these objects. For example, ifindex can also be used to locate a netdev.
We can certainly locate a TC filter with (prio,proto,handle) but this has to
be passed via netlink. So if you need some locator, I think we can
introduce a kernel API which takes all necessary parameters to locate
a TC filter and return it to you. For a quick example, like this:

struct tcf_proto *tcf_get_proto(struct net *net, int ifindex,
                                int parent, char* kind, int handle...);

(Note, it can grab a refcnt in case of being deleted by others.)

With this, you can simply call it in bpf_link, and attach bpf prog to tcf_proto
(of course, only cls_bpf succeeds here).

Thanks.
