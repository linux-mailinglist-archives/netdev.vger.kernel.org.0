Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26875466F8
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 14:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbiFJM6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 08:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348547AbiFJM6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 08:58:36 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7A2183142;
        Fri, 10 Jun 2022 05:58:33 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t3-20020a17090a510300b001ea87ef9a3dso378200pjh.4;
        Fri, 10 Jun 2022 05:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=WmXfkduD9Oup6fZ4HH529ls5n+lk4ZC7zc8XhY4/rpU=;
        b=faRfjhEUgbso+i9MdPHDP/V9uHrTiQ22s18XESaDPNUys59eEbkBhp5WScYloMkFx/
         vVqHgWRew88sH86rsM3JAdze39RPihyaAV4QHeEth8/8DBPX52Wbpqj+sj7AFOhI0Bl4
         oco/UU0OaYm3ifDerCI09NAJnnmDvfOq8WcnhpdeOEUUYKapS4G9ekfWjpiVsZZz6oWP
         hmaLgo5M4Xk6p3M7IvLw54JV1UZ1hLV5Y9r1A0LNzFs9VnjBdTnvocxayIzM4l4CrYeK
         90lbW18sjT3Pv+bw8Et+Rj/15t7/bqoNQAfyvch6yT3MLaPw8Q7UOwhvpY3j2NKmUygr
         kXCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WmXfkduD9Oup6fZ4HH529ls5n+lk4ZC7zc8XhY4/rpU=;
        b=7aXYlD8k0CvnIhjJ52FduxwIRXAGhdApOD4j9hqs9iXQxVTlAdSzlS/YbCBkOunbBO
         JpEFzlKSk/8hg2o/ttiXJjmiAgIJX+QXv88VvY7Df56Kv43NbUGimb3akhZSrd824s+y
         hBBWFPdEZolyIq59l/ISUZS9VTS4Yfn+47q6QFxyl5NMwiMKM+TfAET0DywfgLK/dlj9
         0JCVrvXMFKhrqVVx31+8gLNetQFMyUdAUHM5XV2sKRKV624B/tnJZWiz/t3v1qjPRtsi
         8Pjo301IOmh2Hyb4sNRgTx28d1erSXc7f5FZ3lJrid2kjHIjxcO44HYxMQwVIqji3Y1i
         TNMA==
X-Gm-Message-State: AOAM5305RIOC22VJbL5L6ri4VFC5hGFsGvXVimK1WO2mODlPqq0G+fc3
        qwBdD8hNhvRUMSl6WlaNMWw=
X-Google-Smtp-Source: ABdhPJzdHlgVT8BCAvSSqD2iB10oY9JMm3YMmNu5Jz0qA3gn3B7DUuh4LeqrGF2cBisVaU9P9qDekw==
X-Received: by 2002:a17:902:788b:b0:168:bffe:4049 with SMTP id q11-20020a170902788b00b00168bffe4049mr1995633pll.75.1654865913311;
        Fri, 10 Jun 2022 05:58:33 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0c0:79de:f3f4:353c:8616])
        by smtp.gmail.com with ESMTPSA id 69-20020a621648000000b0050dc76281e3sm16607333pfw.189.2022.06.10.05.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 05:58:33 -0700 (PDT)
Date:   Fri, 10 Jun 2022 18:28:30 +0530
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
Message-ID: <20220610125830.2tx6syagl2rphl35@apollo.legion>
References: <20210604063116.234316-1-memxor@gmail.com>
 <CAJnrk1YJe-wtXFF0U2cuZUdd-gH1Y80Ewf3ePo=vh-nbsSBZgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1YJe-wtXFF0U2cuZUdd-gH1Y80Ewf3ePo=vh-nbsSBZgg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 05:54:27AM IST, Joanne Koong wrote:
> On Thu, Jun 3, 2021 at 11:31 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > This is the second (non-RFC) version.
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
> Hi Kumar,
>
> Do you have any plans / bandwidth to land this feature upstream? If
> so, do you have a tentative estimation for when you'll be able to work
> on this? And if not, are you okay with someone else working on this to
> get it merged in?
>

I can have a look at resurrecting it later this month, if you're ok with waiting
until then, otherwise if someone else wants to pick this up before that it's
fine by me, just let me know so we avoid duplicated effort. Note that the
approach in v2 is dead/unlikely to get accepted by the TC maintainers, so we'd
have to implement the way Daniel mentioned in [0].

  [0]: https://lore.kernel.org/bpf/15cd0a9c-95a1-9766-fca1-4bf9d09e4100@iogearbox.net

> The reason I'm asking is because there are a few networking teams
> within Meta that have been requesting this feature :)
>
> Thanks,
> Joanne
>
> > Changelog:
> > ----------
> > v1 (RFC) -> v2
> > v1: https://lore.kernel.org/bpf/20210528195946.2375109-1-memxor@gmail.com
> >
> >  * Avoid overwriting other members of union in bpf_attr (Andrii)
> >  * Set link to NULL after bpf_link_cleanup to avoid double free (Andrii)
> >  * Use __be16 to store the result of htons (Kernel Test Robot)
> >  * Make assignment of tcf_exts::net conditional on CONFIG_NET_CLS_ACT
> >    (Kernel Test Robot)
> >
> > Kumar Kartikeya Dwivedi (7):
> >   net: sched: refactor cls_bpf creation code
> >   bpf: export bpf_link functions for modules
> >   net: sched: add bpf_link API for bpf classifier
> >   net: sched: add lightweight update path for cls_bpf
> >   tools: bpf.h: sync with kernel sources
> >   libbpf: add bpf_link based TC-BPF management API
> >   libbpf: add selftest for bpf_link based TC-BPF management API
> >
> >  include/linux/bpf_types.h                     |   3 +
> >  include/net/pkt_cls.h                         |  13 +
> >  include/net/sch_generic.h                     |   6 +-
> >  include/uapi/linux/bpf.h                      |  15 +
> >  kernel/bpf/syscall.c                          |  14 +-
> >  net/sched/cls_api.c                           | 139 ++++++-
> >  net/sched/cls_bpf.c                           | 389 ++++++++++++++++--
> >  tools/include/uapi/linux/bpf.h                |  15 +
> >  tools/lib/bpf/bpf.c                           |   8 +-
> >  tools/lib/bpf/bpf.h                           |   8 +-
> >  tools/lib/bpf/libbpf.c                        |  59 ++-
> >  tools/lib/bpf/libbpf.h                        |  17 +
> >  tools/lib/bpf/libbpf.map                      |   1 +
> >  tools/lib/bpf/netlink.c                       |   5 +-
> >  tools/lib/bpf/netlink.h                       |   8 +
> >  .../selftests/bpf/prog_tests/tc_bpf_link.c    | 285 +++++++++++++
> >  16 files changed, 940 insertions(+), 45 deletions(-)
> >  create mode 100644 tools/lib/bpf/netlink.h
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c
> >
> > --
> > 2.31.1
> >

--
Kartikeya
