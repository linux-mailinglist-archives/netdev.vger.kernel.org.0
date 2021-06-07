Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4B939D38E
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 05:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhFGDlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 23:41:40 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42667 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhFGDlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 23:41:39 -0400
Received: by mail-pf1-f195.google.com with SMTP id s14so11179918pfd.9;
        Sun, 06 Jun 2021 20:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kGAN3PYLqUbM+RtQsBTMjrdbX+O2e+7xT8Vv9XaVKVg=;
        b=cSsVoyJYQXg2oSUT8fTnzF+uitPv7Livb8zTZPfci4vfpnj73yGE3FRjWTJjKgp5fW
         H7fg60tedkqnh+L1th45I8aPrEnzHLOR0ZJwI7CoRFTaPKTodivn2Xkkwq4ZJN6/faWT
         VbmzNLZ076PeSxx0B0fJfcwyQRXlX2AOIFKJUy8MFS0gA3eEFUvNVXF6ACEkV6eGGSQX
         gJyOPytYsUspYvG7Tb8Iwp2IISfudkh5SbJU3yjgGoXovNb2mbCPMvTUO3fobggl+6YL
         TCwso+VISln/GIcSU2s6YagOEAWs7t0Dqm1DCZ076iGh+jAfl/tF08jWmO7EFnhS1tb4
         SRbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kGAN3PYLqUbM+RtQsBTMjrdbX+O2e+7xT8Vv9XaVKVg=;
        b=GDduXgdkQlzR8MgKF+L1y2ZUWhRuQNh1AXZKxGqz2TdXejCoD2auExT7riBGR9P6EP
         3/+fuVbAGp+gFqRYFd2SWxhC24edxHWAhxnSJ6sJt9hcZ1Nd6kZw7uc/U2SI/M/9V/3/
         cGkcA9eV6z1MvuBuDNF5nO/LDUSafk/D3pE83VWNyglWQ/DJPjBjRsn/vldMm/pThqPA
         X4B93ZuGaV652bxSzr4L4YKahF5VpL9BkzdDstwX/XTBkdwzyl7b0hH8BNcRh12dld7O
         K5Dr0cKM+vr38+0MoNa5VsJeeVwPvR8oYWwUuDHmG9Vv/3A/7nsOEH3lQw5i7AKhLjbR
         jWgw==
X-Gm-Message-State: AOAM530/dmTpBzOrhN//Jeabfg/nqIsXSwY8oYl0izoa3uwrLoi24Qvr
        S5pnAXtrKjypGo81ivNnMx4=
X-Google-Smtp-Source: ABdhPJycmSg5kzuEJwSiuiy9Z+UdfKl3YGX/vV8WArHqVoRphUJzQoQJM7S6ApQ4nnEnvJX4AwicXg==
X-Received: by 2002:a63:5743:: with SMTP id h3mr3563575pgm.362.1623037114512;
        Sun, 06 Jun 2021 20:38:34 -0700 (PDT)
Received: from localhost ([2402:3a80:11c3:8bc4:aa5:8732:af1e:76c3])
        by smtp.gmail.com with ESMTPSA id b9sm6645468pfo.107.2021.06.06.20.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 20:38:34 -0700 (PDT)
Date:   Mon, 7 Jun 2021 09:07:24 +0530
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
Message-ID: <20210607033724.wn6qn4v42dlm4j4o@apollo>
References: <20210528195946.2375109-1-memxor@gmail.com>
 <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 05:07:28AM IST, Cong Wang wrote:
> On Fri, May 28, 2021 at 1:00 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > This is the first RFC version.
> >
> > This adds a bpf_link path to create TC filters tied to cls_bpf classifier, and
> > introduces fd based ownership for such TC filters. Netlink cannot delete or
> > replace such filters, but the bpf_link is severed on indirect destruction of the
> > filter (backing qdisc being deleted, or chain being flushed, etc.). To ensure
> > that filters remain attached beyond process lifetime, the usual bpf_link fd
> > pinning approach can be used.
>
> I have some troubles understanding this. So... why TC filter is so special
> here that it deserves such a special treatment?
>

So the motivation behind this was automatic cleanup of filters installed by some
program. Usually from the userspace side you need a bunch of things (handle,
priority, protocol, chain_index, etc.) to be able to delete a filter without
stepping on others' toes. Also, there is no gurantee that filter hasn't been
replaced, so you need to check some other way (either tag or prog_id, but these
are also not perfect).

bpf_link provides isolation from netlink and fd-based lifetime management. As
for why it needs special treatment (by which I guess you mean why it _creates_
an object instead of simply attaching to one, see below):

> The reason why I ask is that none of other bpf links actually create any
> object, they merely attach bpf program to an existing object. For example,
> netns bpf_link does not create an netns, cgroup bpf_link does not create
> a cgroup either. So, why TC filter is so lucky to be the first one requires
> creating an object?
>

They are created behind the scenes, but are also fairly isolated from netlink
(i.e.  can only be introspected, so not hidden in that sense, but are
effectively locked for replace/delete).

The problem would be (of not creating a filter during attach) is that a typical
'attach point' for TC exists in form of tcf_proto. If we take priority (protocol
is fixed) out of the equation, it becomes possible to attach just a single BPF
prog, but that seems like a needless limitation when TC already supports list of
filters at each 'attach point'.

My point is that the created object (the tcf_proto under the 'chain' object) is
the attach point, and since there can be so many, keeping them around at all
times doesn't make sense, so the refcounted attach locations are created as
needed.  Both netlink and bpf_link owned filters can be attached under the same
location, with different ownership story in userspace.

> Is it because there is no fd associated with any TC object?  Or what?
> TC object, like all other netlink stuffs, is not fs based, hence does not
> have an fd. Or maybe you don't need an fd at all? Since at least xdp
> bpf_link is associated with a netdev which does not have an fd either.
>
> >
> > The individual patches contain more details and comments, but the overall kernel
> > API and libbpf helper mirrors the semantics of the netlink based TC-BPF API
> > merged recently. This means that we start by always setting direct action mode,
> > protocol to ETH_P_ALL, chain_index as 0, etc. If there is a need for more
> > options in the future, they can be easily exposed through the bpf_link API in
> > the future.
>
> As you already see, this fits really oddly into TC infrastructure, because
> TC qdisc/filter/action are a whole subsystem, here you are trying to punch
> a hole in the middle. ;) This usually indicates that we are going in a wrong
> direction, maybe your case is an exception, but I can't find anything to justify
> it in your cover letter.
>

I don't see why I'm punching a hole. The qdisc, chain, protocol, priority is the
'attach location', handle is just an ID, maybe we can skip all this and just
create a static hook for attaching single BPF program that doesn't require
creating a filter, but someday someone will have to reimplement chaining of
programs again (like libxdp does).

> Even if you really want to go down this path (I still double), you probably
> want to explore whether there is any generic way to associate a TC object
> with an fd, because we have TC bpf action and we will have TC bpf qdisc
> too, I don't see any bpf_cls is more special than them.
>

I think TC bpf actions are not relevant going forward (due to cls_bpf's direct
action mode), but I could be wrong. I say so because even a proposed API to
attach these from libbpf was dropped because arguably cls_bpf does it better,
and people shouldn't be using integrated actions going forward.

TC bpf qdisc might be, but that can be a different attach type (say BPF_SCHED),
which if exposed through bpf_link will again have its attach point to be the
target_ifindex, not some fd, and it would still be possible to use this API to
attach to a eBPF qdisc.

What do you suggest? I am open to reworking this in a different way if there are
any better ideas.

> Thanks.

--
Kartikeya
