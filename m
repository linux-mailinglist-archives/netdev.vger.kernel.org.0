Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B88B546D4E
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 21:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348059AbiFJTec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 15:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346441AbiFJTeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 15:34:31 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A0D2F007;
        Fri, 10 Jun 2022 12:34:29 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n18so57792plg.5;
        Fri, 10 Jun 2022 12:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=uMppHvYmW4hJizHMgM7CHY0Ie3GXJDXQCP8lyH550Z8=;
        b=Z6erPk3qN5zlNE+6WND2J1LT2vfMukG7a1yvCVYkRuv4XRlXUngglObyj5wNtyQ6pA
         NiqwNd4sZt2WaDHr7SWO/JUzfS6ZjFeswDwlrz8mAMZgEYg0ham3OjC/N14IalWIIu6F
         eo57LzA0q91kfTYtl6UdT0Vwym6D1I34Es4kNiDnIq4MJo0XkZWc52gdUU0a3OqucZz6
         UeITl+axX7EqST80Nqhz0refDXOCokgQSkTm+JUeeFO8VLNSk2zAIeK84Z000w1uJ9Cs
         QPgs2BquxU17zjibegQP4h6aX4idDmFNpE7g7v4eu9dRUKULNmYGTGIiRPR5u42QwyXW
         iPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uMppHvYmW4hJizHMgM7CHY0Ie3GXJDXQCP8lyH550Z8=;
        b=MIcX9cyIfZQ87tT0Q09JuixDEh/4BbqyhDhS/WE77Q+PpNAwTPtOhPy7C6C5mW36nU
         sFufB+ZVjPrI6CaP5uaRwHF4yq+CmKUzD97lZiXBr8kjUwyq+MRBQyhBr6xZTkaH9ocS
         f6UDXn21yCNRX3U8/qgvF74Ua6iyOABuLPS6VekCh7wm2JWFW16U1+W004n0lEbM8Qlk
         nj9EKrPpCqFxbC/C8fDr+iJrHsoiQyiL2xP/imoq7EjschRVFXiGPuddlJokwK6XPCoA
         Dy3wFsB5bs3KPp+T1JadJWQ/VfjO7zAnBjLFP5VY2BdSroc5SXhAYi/CU43drMVDXQc5
         UE7g==
X-Gm-Message-State: AOAM533X8Rcf745ERk9zfvIAyWKuUv6GFtrnUI6VHWOIA54wwxWQV5sI
        0fG8WGcx0KwWkcdvQuPAbNw=
X-Google-Smtp-Source: ABdhPJySSn5CxcJb4CrN+qz4AVjRlrQu6FlYgbh8XEw+fN6jIOUuqC9gKuklgaHymJWavHlh0ZIJFQ==
X-Received: by 2002:a17:903:40c9:b0:167:5fce:a5e with SMTP id t9-20020a17090340c900b001675fce0a5emr36013272pld.6.1654889669227;
        Fri, 10 Jun 2022 12:34:29 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0c0:79de:f3f4:353c:8616])
        by smtp.gmail.com with ESMTPSA id p10-20020a63950a000000b003fbfe88be17sm5702pgd.24.2022.06.10.12.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 12:34:28 -0700 (PDT)
Date:   Sat, 11 Jun 2022 01:04:18 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 0/7] Add bpf_link based TC-BPF API
Message-ID: <20220610193418.4kqpu7crwfb5efzy@apollo.legion>
References: <20210604063116.234316-1-memxor@gmail.com>
 <CAJnrk1YJe-wtXFF0U2cuZUdd-gH1Y80Ewf3ePo=vh-nbsSBZgg@mail.gmail.com>
 <20220610125830.2tx6syagl2rphl35@apollo.legion>
 <CAJnrk1YCBn2EkVK89f5f3ijFYUDhLNpjiH8buw8K3p=JMwAc1Q@mail.gmail.com>
 <CAJnrk1YCSaRjd88WCzg4ccv59h0Dn99XXsDDT4ddzz4UYiZmbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1YCSaRjd88WCzg4ccv59h0Dn99XXsDDT4ddzz4UYiZmbg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 11, 2022 at 12:37:50AM IST, Joanne Koong wrote:
> On Fri, Jun 10, 2022 at 10:23 AM Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > On Fri, Jun 10, 2022 at 5:58 AM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > On Fri, Jun 10, 2022 at 05:54:27AM IST, Joanne Koong wrote:
> > > > On Thu, Jun 3, 2021 at 11:31 PM Kumar Kartikeya Dwivedi
> > > > <memxor@gmail.com> wrote:
> > > > >
> > > > > This is the second (non-RFC) version.
> > > > >
> > > > > This adds a bpf_link path to create TC filters tied to cls_bpf classifier, and
> > > > > introduces fd based ownership for such TC filters. Netlink cannot delete or
> > > > > replace such filters, but the bpf_link is severed on indirect destruction of the
> > > > > filter (backing qdisc being deleted, or chain being flushed, etc.). To ensure
> > > > > that filters remain attached beyond process lifetime, the usual bpf_link fd
> > > > > pinning approach can be used.
> > > > >
> > > > > The individual patches contain more details and comments, but the overall kernel
> > > > > API and libbpf helper mirrors the semantics of the netlink based TC-BPF API
> > > > > merged recently. This means that we start by always setting direct action mode,
> > > > > protocol to ETH_P_ALL, chain_index as 0, etc. If there is a need for more
> > > > > options in the future, they can be easily exposed through the bpf_link API in
> > > > > the future.
> > > > >
> > > > > Patch 1 refactors cls_bpf change function to extract two helpers that will be
> > > > > reused in bpf_link creation.
> > > > >
> > > > > Patch 2 exports some bpf_link management functions to modules. This is needed
> > > > > because our bpf_link object is tied to the cls_bpf_prog object. Tying it to
> > > > > tcf_proto would be weird, because the update path has to replace offloaded bpf
> > > > > prog, which happens using internal cls_bpf helpers, and would in general be more
> > > > > code to abstract over an operation that is unlikely to be implemented for other
> > > > > filter types.
> > > > >
> > > > > Patch 3 adds the main bpf_link API. A function in cls_api takes care of
> > > > > obtaining block reference, creating the filter object, and then calls the
> > > > > bpf_link_change tcf_proto op (only supported by cls_bpf) that returns a fd after
> > > > > setting up the internal structures. An optimization is made to not keep around
> > > > > resources for extended actions, which is explained in a code comment as it wasn't
> > > > > immediately obvious.
> > > > >
> > > > > Patch 4 adds an update path for bpf_link. Since bpf_link_update only supports
> > > > > replacing the bpf_prog, we can skip tc filter's change path by reusing the
> > > > > filter object but swapping its bpf_prog. This takes care of replacing the
> > > > > offloaded prog as well (if that fails, update is aborted). So far however,
> > > > > tcf_classify could do normal load (possibly torn) as the cls_bpf_prog->filter
> > > > > would never be modified concurrently. This is no longer true, and to not
> > > > > penalize the classify hot path, we also cannot impose serialization around
> > > > > its load. Hence the load is changed to READ_ONCE, so that the pointer value is
> > > > > always consistent. Due to invocation in a RCU critical section, the lifetime of
> > > > > the prog is guaranteed for the duration of the call.
> > > > >
> > > > > Patch 5, 6 take care of updating the userspace bits and add a bpf_link returning
> > > > > function to libbpf.
> > > > >
> > > > > Patch 7 adds a selftest that exercises all possible problematic interactions
> > > > > that I could think of.
> > > > >
> > > > > Design:
> > > > >
> > > > > This is where in the object hierarchy our bpf_link object is attached.
> > > > >
> > > > >                                                                             ┌─────┐
> > > > >                                                                             │     │
> > > > >                                                                             │ BPF │
> > > > >                                                                             program
> > > > >                                                                             │     │
> > > > >                                                                             └──▲──┘
> > > > >                                                       ┌───────┐                │
> > > > >                                                       │       │         ┌──────┴───────┐
> > > > >                                                       │  mod  ├─────────► cls_bpf_prog │
> > > > > ┌────────────────┐                                    │cls_bpf│         └────┬───▲─────┘
> > > > > │    tcf_block   │                                    │       │              │   │
> > > > > └────────┬───────┘                                    └───▲───┘              │   │
> > > > >          │          ┌─────────────┐                       │                ┌─▼───┴──┐
> > > > >          └──────────►  tcf_chain  │                       │                │bpf_link│
> > > > >                     └───────┬─────┘                       │                └────────┘
> > > > >                             │          ┌─────────────┐    │
> > > > >                             └──────────►  tcf_proto  ├────┘
> > > > >                                        └─────────────┘
> > > > >
> > > > > The bpf_link is detached on destruction of the cls_bpf_prog.  Doing it this way
> > > > > allows us to implement update in a lightweight manner without having to recreate
> > > > > a new filter, where we can just replace the BPF prog attached to cls_bpf_prog.
> > > > >
> > > > > The other way to do it would be to link the bpf_link to tcf_proto, there are
> > > > > numerous downsides to this:
> > > > >
> > > > > 1. All filters have to embed the pointer even though they won't be using it when
> > > > > cls_bpf is compiled in.
> > > > > 2. This probably won't make sense to be extended to other filter types anyway.
> > > > > 3. We aren't able to optimize the update case without adding another bpf_link
> > > > > specific update operation to tcf_proto ops.
> > > > >
> > > > > The downside with tying this to the module is having to export bpf_link
> > > > > management functions and introducing a tcf_proto op. Hopefully the cost of
> > > > > another operation func pointer is not big enough (as there is only one ops
> > > > > struct per module).
> > > > >
> > > > Hi Kumar,
> > > >
> > > > Do you have any plans / bandwidth to land this feature upstream? If
> > > > so, do you have a tentative estimation for when you'll be able to work
> > > > on this? And if not, are you okay with someone else working on this to
> > > > get it merged in?
> > > >
> > >
> > > I can have a look at resurrecting it later this month, if you're ok with waiting
> > > until then, otherwise if someone else wants to pick this up before that it's
> > > fine by me, just let me know so we avoid duplicated effort. Note that the
> > > approach in v2 is dead/unlikely to get accepted by the TC maintainers, so we'd
> > > have to implement the way Daniel mentioned in [0].
> >
> > Sounds great! We'll wait and check back in with you later this month.
> >
> After reading the linked thread (which I should have done before
> submitting my previous reply :)),  if I'm understanding it correctly,
> it seems then that the work needed for tc bpf_link will be in a new
> direction that's not based on the code in this v2 patchset. I'm
> interested in learning more about bpf link and tc - I can pick this up
> to work on. But if this was something you wanted to work on though,
> please don't hesitate to let me know; I can find some other bpf link
> thing to work on instead if that's the case.
>

Feel free to take it. And yes, it's going to be much simpler than this. I think
you can just add two bpf_prog pointers in struct net_device, use rtnl_lock to
protect the updates, and invoke using bpf_prog_run in sch_handle_ingress and
sch_handle_egress. You could also split the old and new path so that there are
less branches when the ingress/egress static key is enabled only for bpf_link
mode (as clsact will become redundant after this). It should be similar to how
XDP's bpf_link works. Auto detach can be handled similarly by unlinking dev from
the link when net_device teardown occurs, same as XDP's bpf_link, to sever it.

The other thing to keep in mind is that not all return codes are permitted in
direct action mode, so you may want to lift cls_bpf_exec_opcode out into a
header as a helper and then repurpose it for the switch statement in
sch_handle_ingress/egress to handle only those. Also need to document for the
user that only direct action mode is supported for TC bpf_link mode.

You can look at the cls_bpf_classify function in net/sched/cls_bpf.c. The
branches protected by prog->exts_integrated is for direct action mode, so the
handling for bpf_link will be similar. Also need to handle mono_delivery_time
unsetting that Martin added recently.

That's all from my notes from that time. Best of luck! :)

>
> > >
> > >   [0]: https://lore.kernel.org/bpf/15cd0a9c-95a1-9766-fca1-4bf9d09e4100@iogearbox.net
> > >
> > > > The reason I'm asking is because there are a few networking teams
> > > > within Meta that have been requesting this feature :)
> > > >
> > > > Thanks,
> > > > Joanne
> > > >
> > > > > Changelog:
> > > > > ----------
> > > > > v1 (RFC) -> v2
> > > > > v1: https://lore.kernel.org/bpf/20210528195946.2375109-1-memxor@gmail.com
> > > > >
> > > > >  * Avoid overwriting other members of union in bpf_attr (Andrii)
> > > > >  * Set link to NULL after bpf_link_cleanup to avoid double free (Andrii)
> > > > >  * Use __be16 to store the result of htons (Kernel Test Robot)
> > > > >  * Make assignment of tcf_exts::net conditional on CONFIG_NET_CLS_ACT
> > > > >    (Kernel Test Robot)
> > > > >
> > > > > Kumar Kartikeya Dwivedi (7):
> > > > >   net: sched: refactor cls_bpf creation code
> > > > >   bpf: export bpf_link functions for modules
> > > > >   net: sched: add bpf_link API for bpf classifier
> > > > >   net: sched: add lightweight update path for cls_bpf
> > > > >   tools: bpf.h: sync with kernel sources
> > > > >   libbpf: add bpf_link based TC-BPF management API
> > > > >   libbpf: add selftest for bpf_link based TC-BPF management API
> > > > >
> > > > >  include/linux/bpf_types.h                     |   3 +
> > > > >  include/net/pkt_cls.h                         |  13 +
> > > > >  include/net/sch_generic.h                     |   6 +-
> > > > >  include/uapi/linux/bpf.h                      |  15 +
> > > > >  kernel/bpf/syscall.c                          |  14 +-
> > > > >  net/sched/cls_api.c                           | 139 ++++++-
> > > > >  net/sched/cls_bpf.c                           | 389 ++++++++++++++++--
> > > > >  tools/include/uapi/linux/bpf.h                |  15 +
> > > > >  tools/lib/bpf/bpf.c                           |   8 +-
> > > > >  tools/lib/bpf/bpf.h                           |   8 +-
> > > > >  tools/lib/bpf/libbpf.c                        |  59 ++-
> > > > >  tools/lib/bpf/libbpf.h                        |  17 +
> > > > >  tools/lib/bpf/libbpf.map                      |   1 +
> > > > >  tools/lib/bpf/netlink.c                       |   5 +-
> > > > >  tools/lib/bpf/netlink.h                       |   8 +
> > > > >  .../selftests/bpf/prog_tests/tc_bpf_link.c    | 285 +++++++++++++
> > > > >  16 files changed, 940 insertions(+), 45 deletions(-)
> > > > >  create mode 100644 tools/lib/bpf/netlink.h
> > > > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c
> > > > >
> > > > > --
> > > > > 2.31.1
> > > > >
> > >
> > > --
> > > Kartikeya

--
Kartikeya
