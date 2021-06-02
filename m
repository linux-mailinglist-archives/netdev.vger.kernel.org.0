Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1129C399597
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 23:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhFBVtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 17:49:11 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34787 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhFBVtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 17:49:10 -0400
Received: by mail-pg1-f193.google.com with SMTP id l1so3429719pgm.1;
        Wed, 02 Jun 2021 14:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Fn6qw930tde+l9x/cQnHrI5s9smpcn74KQHcm44/Eo8=;
        b=QuF9wkt5ELIyxNGwE3Ck0XUlemd9hZQIg/cB6LJHx9QW2s91h9H/qB/rK84NeEeKvH
         insV2JWwtIZMmCo8YKjeDzWzauouwxU+C5Fw9F1T3nJ9QpFN5K/rQKxklMQ/sasCPPgw
         j4iGuffWcr4tA7WP1LZHFeT03Y7mwvgcb2AOYfogwKHUu0X+CjyQW8G6zKqgFoIAvezu
         yizt88flKmxRGrq1Mc8wAik4wzUXRn3Om5UfYhR4Wp2AXGkOcdPVprADMjewJNCDTUDS
         pTKYnij04s76KQXeiUGHHSZaVugqmnPVZxSusV3wqr6WoifuTJtukRuvMj1bsfz5jlqB
         vxaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Fn6qw930tde+l9x/cQnHrI5s9smpcn74KQHcm44/Eo8=;
        b=tBAsU3TVKannQqwW+L43izpuu/8R6NLjpHGzE6Vex3DlTtrLBNBT3a22/+x9sSzniD
         32c6Gx9TL5OyqzsgJi2nQpcUsGYYTxGRXQnh+jRHddV4p2wVn+WlYbinYm4L6mOi450n
         YuXzv4dZIkDLcaIkeJUq52PkWu8EAusalsc3DebCp5ZqIB3aWmNlqB1Lyjcx44zjCXCf
         fS/tE5QOk0wcMz82ygXnnmf78FbUc7hu4s9RxjQXAwgegt3Z7DpXVthocfEgwOMy3GKc
         FMWR4Cdzg1gJSEDPWoHb7u1Ug7sA4X3NjhQWVbfcyECCR5pC8tqMp1bgobc6ePIxAVRS
         +Y6g==
X-Gm-Message-State: AOAM5301xL+enzXQdBdFV4XpDkIsKzUd+IvxzPo8QhpzdS8TpJrxLQfa
        f31KWFC1wH/7nWqACM/Jo1g=
X-Google-Smtp-Source: ABdhPJz25FGBaIHlcpZnPaMN1ZB8VMiaXeye1W042i8v4JjfhzbKqF3pMfaAAj0BRSvAq/vX21YWoA==
X-Received: by 2002:a63:1450:: with SMTP id 16mr24632512pgu.392.1622670374227;
        Wed, 02 Jun 2021 14:46:14 -0700 (PDT)
Received: from localhost ([2402:3a80:11c3:4fec:2675:159a:a68d:e289])
        by smtp.gmail.com with ESMTPSA id o27sm586068pgb.70.2021.06.02.14.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 14:46:13 -0700 (PDT)
Date:   Thu, 3 Jun 2021 03:15:13 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
Message-ID: <20210602214513.eprgwxqgqruliqeu@apollo>
References: <20210528195946.2375109-1-memxor@gmail.com>
 <CAEf4BzZt5nRsfCiqGkJxW2b-==AYEVCiz6jHC-FrXKkPF=Qj7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzZt5nRsfCiqGkJxW2b-==AYEVCiz6jHC-FrXKkPF=Qj7w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 02:39:15AM IST, Andrii Nakryiko wrote:
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
> >
> > The individual patches contain more details and comments, but the overall kernel
> > API and libbpf helper mirrors the semantics of the netlink based TC-BPF API
> > merged recently. This means that we start by always setting direct action mode,
> > protocol to ETH_P_ALL, chain_index as 0, etc. If there is a need for more
> > options in the future, they can be easily exposed through the bpf_link API in
> > the future.
> >
> > Patch 1 refactors cls_bpf change function to extract two helpers that will be
> > reused in bpf_link creation.
> >
> > Patch 2 exports some bpf_link management functions to modules. This is needed
> > because our bpf_link object is tied to the cls_bpf_prog object. Tying it to
> > tcf_proto would be weird, because the update path has to replace offloaded bpf
> > prog, which happens using internal cls_bpf helpers, and would in general be more
> > code to abstract over an operation that is unlikely to be implemented for other
> > filter types.
> >
> > Patch 3 adds the main bpf_link API. A function in cls_api takes care of
> > obtaining block reference, creating the filter object, and then calls the
> > bpf_link_change tcf_proto op (only supported by cls_bpf) that returns a fd after
> > setting up the internal structures. An optimization is made to not keep around
> > resources for extended actions, which is explained in a code comment as it wasn't
> > immediately obvious.
> >
> > Patch 4 adds an update path for bpf_link. Since bpf_link_update only supports
> > replacing the bpf_prog, we can skip tc filter's change path by reusing the
> > filter object but swapping its bpf_prog. This takes care of replacing the
> > offloaded prog as well (if that fails, update is aborted). So far however,
> > tcf_classify could do normal load (possibly torn) as the cls_bpf_prog->filter
> > would never be modified concurrently. This is no longer true, and to not
> > penalize the classify hot path, we also cannot impose serialization around
> > its load. Hence the load is changed to READ_ONCE, so that the pointer value is
> > always consistent. Due to invocation in a RCU critical section, the lifetime of
> > the prog is guaranteed for the duration of the call.
> >
> > Patch 5, 6 take care of updating the userspace bits and add a bpf_link returning
> > function to libbpf.
> >
> > Patch 7 adds a selftest that exercises all possible problematic interactions
> > that I could think of.
> >
> > Design:
> >
> > This is where in the object hierarchy our bpf_link object is attached.
> >
> >                                                                             ┌─────┐
> >                                                                             │     │
> >                                                                             │ BPF │
> >                                                                             program
> >                                                                             │     │
> >                                                                             └──▲──┘
> >                                                       ┌───────┐                │
> >                                                       │       │         ┌──────┴───────┐
> >                                                       │  mod  ├─────────► cls_bpf_prog │
> > ┌────────────────┐                                    │cls_bpf│         └────┬───▲─────┘
> > │    tcf_block   │                                    │       │              │   │
> > └────────┬───────┘                                    └───▲───┘              │   │
> >          │          ┌─────────────┐                       │                ┌─▼───┴──┐
> >          └──────────►  tcf_chain  │                       │                │bpf_link│
> >                     └───────┬─────┘                       │                └────────┘
> >                             │          ┌─────────────┐    │
> >                             └──────────►  tcf_proto  ├────┘
> >                                        └─────────────┘
> >
> > The bpf_link is detached on destruction of the cls_bpf_prog.  Doing it this way
> > allows us to implement update in a lightweight manner without having to recreate
> > a new filter, where we can just replace the BPF prog attached to cls_bpf_prog.
> >
> > The other way to do it would be to link the bpf_link to tcf_proto, there are
> > numerous downsides to this:
> >
> > 1. All filters have to embed the pointer even though they won't be using it when
> > cls_bpf is compiled in.
> > 2. This probably won't make sense to be extended to other filter types anyway.
> > 3. We aren't able to optimize the update case without adding another bpf_link
> > specific update operation to tcf_proto ops.
> >
> > The downside with tying this to the module is having to export bpf_link
> > management functions and introducing a tcf_proto op. Hopefully the cost of
> > another operation func pointer is not big enough (as there is only one ops
> > struct per module).
> >
> > This first version is to collect feedback on the approach and get ideas if there
> > is a better way to do this.
>
> Bpf_link-based TC API is a long time coming, so it's great to see
> someone finally working on this. Thanks!
>
> I briefly skimmed through the patch set, noticed a few generic
> bpf_link problems. But I think main feedback will come from Cilium

Thanks for the review. I'll fix both of these in the resend (also have a couple
of private reports from the kernel test robot).

> folks and others that heavily rely on TC APIs. I wonder if there is an
> opportunity to simplify the API further given we have a new
> opportunity here. I don't think we are constrained to follow legacy TC
> API exactly.
>

I tried to keep it simple by going for the defaults we agreed upon for the new
netlink based libbpf API, and always setting direct action mode, and it's still
in a position to be extended in the future to allow full TC filter setup like
netlink does, if someone ever happens to need that.

As for the implementation, I did notice that there has been discussion around
this (though I could only find [0]) but I think doing it the way this patch does
is more flexible as you can attach the bpf filter to an aribitrary parent/class,
not just ingress and egress, and it can coexist with a conventional TC setup.

[0]: https://facebookmicrosites.github.io/bpf/blog/2018/08/31/object-lifetime.html
     ("Note that there is ongoing work ...")

> The problem is that your patch set was marked as spam by Google, so I
> suspect a bunch of folks haven't gotten it. I suggest re-sending it
> again but trimming down the CC list, leaving only bpf@vger,
> netdev@vger, and BPF maintainers CC'ed directly.
>

Thanks for the heads up, I'll resend tomorrow.

--
Kartikeya
