Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053D1546BA0
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349675AbiFJRXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345113AbiFJRXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:23:34 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F07A1E3C4;
        Fri, 10 Jun 2022 10:23:33 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id 63so9286695uaw.10;
        Fri, 10 Jun 2022 10:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nxBQBA6CQOYGFMBNy7mcHqPxyN/WXLUYIJXVoH9tg/0=;
        b=dujhs0I/zYt+aVy6wTrDIN1U5TUgEZrdD3stP2kIH8GP4gkiYqKONyUJl8Uac/7IaA
         PxgN9aBoRVHAJBJ0D6LCKoNTMuH6UyUiFmMOHcXU07cfCOpVSor5JH0bLcd4xFjlYd94
         RzOTntcv/YofO1NZskmdzeGd/AOWHEFl8Xs3McxDR+f3P4KJumebL0oVr1H/7fgqtJRW
         WX0T19c1rmfQuKAnZnq54OLCBOcNPmPm1+wvB3OSRQiQWxlhmd7BPxvbcz9ZIC0s+PIm
         eVE+Ti02ZXt/JjKNMjJcDhZQgbOZJ72OSfXm6g5KrqkL2OXMAWWtz51Bm5lTVP1SqPhv
         V+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nxBQBA6CQOYGFMBNy7mcHqPxyN/WXLUYIJXVoH9tg/0=;
        b=nl/MJKrDxzmfv+/1pEluY3ste4sE7+Pu7EOoyIaDW/tMvknjhSDgm9AgmjM9HRx75Y
         36mTP57AnU67gTaJecAJlIQ/0KU258B4onTVGZG5zzgJIwONZcwxOjENi0DYZQWaAqBu
         36dT2G3YVPIazj4RqEXpybf6Vxs3I2ybwpIRpSxv5fl+8b6JKjhK5MT0SO+BM3hIXECG
         arKyGZ436FPU2ue9PB9URuuwHIQWGLICr+EGuuMoEh89CMwDkpAlyjFPvx/X50KxyP5z
         H3WKuLpBwzCgJsz33hqh91QUMKZNqYTwDGhpxsePYQmO6ZRcR4cfFW13FRREAmIEJK1u
         6JZg==
X-Gm-Message-State: AOAM5305/y8pdtHsMYQKLxA2uT9k/yEaUobLF9PPSUXjN+C/6oTHoxC+
        peIEBkFV+44hLc16JtACKWlMUXjyZ9YNEqvcBBA=
X-Google-Smtp-Source: ABdhPJy+vCrI7mrh+JOS1wOZP9fsQW5dp++7qmgMVY3dJVbg6McZVjJnj1l7Xgd1nDGkcTquYkx3bHwMcTbaZ6V6XpI=
X-Received: by 2002:ab0:1343:0:b0:362:9e6c:74f5 with SMTP id
 h3-20020ab01343000000b003629e6c74f5mr40353498uae.15.1654881812679; Fri, 10
 Jun 2022 10:23:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210604063116.234316-1-memxor@gmail.com> <CAJnrk1YJe-wtXFF0U2cuZUdd-gH1Y80Ewf3ePo=vh-nbsSBZgg@mail.gmail.com>
 <20220610125830.2tx6syagl2rphl35@apollo.legion>
In-Reply-To: <20220610125830.2tx6syagl2rphl35@apollo.legion>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Fri, 10 Jun 2022 10:23:21 -0700
Message-ID: <CAJnrk1YCBn2EkVK89f5f3ijFYUDhLNpjiH8buw8K3p=JMwAc1Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/7] Add bpf_link based TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 5:58 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Fri, Jun 10, 2022 at 05:54:27AM IST, Joanne Koong wrote:
> > On Thu, Jun 3, 2021 at 11:31 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > This is the second (non-RFC) version.
> > >
> > > This adds a bpf_link path to create TC filters tied to cls_bpf classi=
fier, and
> > > introduces fd based ownership for such TC filters. Netlink cannot del=
ete or
> > > replace such filters, but the bpf_link is severed on indirect destruc=
tion of the
> > > filter (backing qdisc being deleted, or chain being flushed, etc.). T=
o ensure
> > > that filters remain attached beyond process lifetime, the usual bpf_l=
ink fd
> > > pinning approach can be used.
> > >
> > > The individual patches contain more details and comments, but the ove=
rall kernel
> > > API and libbpf helper mirrors the semantics of the netlink based TC-B=
PF API
> > > merged recently. This means that we start by always setting direct ac=
tion mode,
> > > protocol to ETH_P_ALL, chain_index as 0, etc. If there is a need for =
more
> > > options in the future, they can be easily exposed through the bpf_lin=
k API in
> > > the future.
> > >
> > > Patch 1 refactors cls_bpf change function to extract two helpers that=
 will be
> > > reused in bpf_link creation.
> > >
> > > Patch 2 exports some bpf_link management functions to modules. This i=
s needed
> > > because our bpf_link object is tied to the cls_bpf_prog object. Tying=
 it to
> > > tcf_proto would be weird, because the update path has to replace offl=
oaded bpf
> > > prog, which happens using internal cls_bpf helpers, and would in gene=
ral be more
> > > code to abstract over an operation that is unlikely to be implemented=
 for other
> > > filter types.
> > >
> > > Patch 3 adds the main bpf_link API. A function in cls_api takes care =
of
> > > obtaining block reference, creating the filter object, and then calls=
 the
> > > bpf_link_change tcf_proto op (only supported by cls_bpf) that returns=
 a fd after
> > > setting up the internal structures. An optimization is made to not ke=
ep around
> > > resources for extended actions, which is explained in a code comment =
as it wasn't
> > > immediately obvious.
> > >
> > > Patch 4 adds an update path for bpf_link. Since bpf_link_update only =
supports
> > > replacing the bpf_prog, we can skip tc filter's change path by reusin=
g the
> > > filter object but swapping its bpf_prog. This takes care of replacing=
 the
> > > offloaded prog as well (if that fails, update is aborted). So far how=
ever,
> > > tcf_classify could do normal load (possibly torn) as the cls_bpf_prog=
->filter
> > > would never be modified concurrently. This is no longer true, and to =
not
> > > penalize the classify hot path, we also cannot impose serialization a=
round
> > > its load. Hence the load is changed to READ_ONCE, so that the pointer=
 value is
> > > always consistent. Due to invocation in a RCU critical section, the l=
ifetime of
> > > the prog is guaranteed for the duration of the call.
> > >
> > > Patch 5, 6 take care of updating the userspace bits and add a bpf_lin=
k returning
> > > function to libbpf.
> > >
> > > Patch 7 adds a selftest that exercises all possible problematic inter=
actions
> > > that I could think of.
> > >
> > > Design:
> > >
> > > This is where in the object hierarchy our bpf_link object is attached=
.
> > >
> > >                                                                      =
       =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
> > >                                                                      =
       =E2=94=82     =E2=94=82
> > >                                                                      =
       =E2=94=82 BPF =E2=94=82
> > >                                                                      =
       program
> > >                                                                      =
       =E2=94=82     =E2=94=82
> > >                                                                      =
       =E2=94=94=E2=94=80=E2=94=80=E2=96=B2=E2=94=80=E2=94=80=E2=94=98
> > >                                                       =E2=94=8C=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90         =
       =E2=94=82
> > >                                                       =E2=94=82      =
 =E2=94=82         =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=90
> > >                                                       =E2=94=82  mod =
 =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=96=BA cls_bpf_prog =E2=94=82
> > > =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=90                                    =E2=94=82cls_bpf=E2=
=94=82         =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=
=80=E2=94=80=E2=94=80=E2=96=B2=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=98
> > > =E2=94=82    tcf_block   =E2=94=82                                   =
 =E2=94=82       =E2=94=82              =E2=94=82   =E2=94=82
> > > =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=98                                    =E2=94=94=E2=94=80=E2=
=94=80=E2=94=80=E2=96=B2=E2=94=80=E2=94=80=E2=94=80=E2=94=98              =
=E2=94=82   =E2=94=82
> > >          =E2=94=82          =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=90                       =E2=94=82                =E2=94=
=8C=E2=94=80=E2=96=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=
=E2=94=90
> > >          =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BA  tcf_chain  =E2=94=82     =
                  =E2=94=82                =E2=94=82bpf_link=E2=94=82
> > >                     =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=98                       =E2=94=82                =E2=94=94=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> > >                             =E2=94=82          =E2=94=8C=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90    =E2=94=82
> > >                             =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BA  tcf_=
proto  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> > >                                        =E2=94=94=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=98
> > >
> > > The bpf_link is detached on destruction of the cls_bpf_prog.  Doing i=
t this way
> > > allows us to implement update in a lightweight manner without having =
to recreate
> > > a new filter, where we can just replace the BPF prog attached to cls_=
bpf_prog.
> > >
> > > The other way to do it would be to link the bpf_link to tcf_proto, th=
ere are
> > > numerous downsides to this:
> > >
> > > 1. All filters have to embed the pointer even though they won't be us=
ing it when
> > > cls_bpf is compiled in.
> > > 2. This probably won't make sense to be extended to other filter type=
s anyway.
> > > 3. We aren't able to optimize the update case without adding another =
bpf_link
> > > specific update operation to tcf_proto ops.
> > >
> > > The downside with tying this to the module is having to export bpf_li=
nk
> > > management functions and introducing a tcf_proto op. Hopefully the co=
st of
> > > another operation func pointer is not big enough (as there is only on=
e ops
> > > struct per module).
> > >
> > Hi Kumar,
> >
> > Do you have any plans / bandwidth to land this feature upstream? If
> > so, do you have a tentative estimation for when you'll be able to work
> > on this? And if not, are you okay with someone else working on this to
> > get it merged in?
> >
>
> I can have a look at resurrecting it later this month, if you're ok with =
waiting
> until then, otherwise if someone else wants to pick this up before that i=
t's
> fine by me, just let me know so we avoid duplicated effort. Note that the
> approach in v2 is dead/unlikely to get accepted by the TC maintainers, so=
 we'd
> have to implement the way Daniel mentioned in [0].

Sounds great! We'll wait and check back in with you later this month.

>
>   [0]: https://lore.kernel.org/bpf/15cd0a9c-95a1-9766-fca1-4bf9d09e4100@i=
ogearbox.net
>
> > The reason I'm asking is because there are a few networking teams
> > within Meta that have been requesting this feature :)
> >
> > Thanks,
> > Joanne
> >
> > > Changelog:
> > > ----------
> > > v1 (RFC) -> v2
> > > v1: https://lore.kernel.org/bpf/20210528195946.2375109-1-memxor@gmail=
.com
> > >
> > >  * Avoid overwriting other members of union in bpf_attr (Andrii)
> > >  * Set link to NULL after bpf_link_cleanup to avoid double free (Andr=
ii)
> > >  * Use __be16 to store the result of htons (Kernel Test Robot)
> > >  * Make assignment of tcf_exts::net conditional on CONFIG_NET_CLS_ACT
> > >    (Kernel Test Robot)
> > >
> > > Kumar Kartikeya Dwivedi (7):
> > >   net: sched: refactor cls_bpf creation code
> > >   bpf: export bpf_link functions for modules
> > >   net: sched: add bpf_link API for bpf classifier
> > >   net: sched: add lightweight update path for cls_bpf
> > >   tools: bpf.h: sync with kernel sources
> > >   libbpf: add bpf_link based TC-BPF management API
> > >   libbpf: add selftest for bpf_link based TC-BPF management API
> > >
> > >  include/linux/bpf_types.h                     |   3 +
> > >  include/net/pkt_cls.h                         |  13 +
> > >  include/net/sch_generic.h                     |   6 +-
> > >  include/uapi/linux/bpf.h                      |  15 +
> > >  kernel/bpf/syscall.c                          |  14 +-
> > >  net/sched/cls_api.c                           | 139 ++++++-
> > >  net/sched/cls_bpf.c                           | 389 ++++++++++++++++=
--
> > >  tools/include/uapi/linux/bpf.h                |  15 +
> > >  tools/lib/bpf/bpf.c                           |   8 +-
> > >  tools/lib/bpf/bpf.h                           |   8 +-
> > >  tools/lib/bpf/libbpf.c                        |  59 ++-
> > >  tools/lib/bpf/libbpf.h                        |  17 +
> > >  tools/lib/bpf/libbpf.map                      |   1 +
> > >  tools/lib/bpf/netlink.c                       |   5 +-
> > >  tools/lib/bpf/netlink.h                       |   8 +
> > >  .../selftests/bpf/prog_tests/tc_bpf_link.c    | 285 +++++++++++++
> > >  16 files changed, 940 insertions(+), 45 deletions(-)
> > >  create mode 100644 tools/lib/bpf/netlink.h
> > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf_lin=
k.c
> > >
> > > --
> > > 2.31.1
> > >
>
> --
> Kartikeya
