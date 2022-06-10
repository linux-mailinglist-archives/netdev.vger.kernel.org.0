Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D44A546CE8
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 21:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348179AbiFJTIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 15:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347158AbiFJTIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 15:08:04 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1997338A7;
        Fri, 10 Jun 2022 12:08:02 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id d2so10914333vkg.5;
        Fri, 10 Jun 2022 12:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/wKpsUZTVZzFsn+0pB4qY49TnnBFteH3SawTEzaMwX0=;
        b=fAwFzTd3IGelw1Bn4tuJ3Cktuit62ljIqAGXnlrBhdmZR423btKpXGi/Nk+RXM5bvz
         dZnjjknk8dsvAEBOObEZBxL/OUyru7+W/BAeqMpOHfJwpCjv+kY9JBaFGcKjPAjr9exw
         0iQjl0bHCxquxhPjUOOAep/pZAnYb3UN0wouvZ8eerILqxKEiz8Eb9UXhfvo+nIz/1L/
         iLBgcwJcPj+4ts8q2YZ4ptmEBP8y7FQrhdE1zdw4uVBEH7ithChKnmi+mGEce8zXLKtc
         YjxWZvEDTFK3ZXU0JSl+WdzE5XlSESE5cGXzBc0Q6SpgpJHUQyyBZmOpP5TTQ3cNNLPc
         Z6iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/wKpsUZTVZzFsn+0pB4qY49TnnBFteH3SawTEzaMwX0=;
        b=ZBNH3XRQ3a2VZZ17AJEgq2I3bOAyeFjNgqt6i7wGpqO24Tg6eonuU2M9q2/YIC595T
         wKg4ROZHf6uJ9mRRvz+fAyyOhnT6n/k+lVQcdfAfp+JMF8GiWeLQVwEPpUKt63UKGr1d
         QNq9DEm/P5z9WnPqgEsp+YpyjwCZg4E6iHvg+lT81tCiPSWUXXNsW5yytm4+gOlYVy2B
         xvLD7lRi0hDko5kA3yi3fP6ykvxw9FL5IQzNbI9W8yphzjHj2NVpq7bxe+RtoUfQccp0
         EDIetODcLnunrVdURH7yxjUSxRMnUbIw0AGCLdVtT94/ZrjFBFxsgd2FqnPw/6c9M92h
         dMZg==
X-Gm-Message-State: AOAM533aJ+4yyd1qIbYLGAG/TbwB9PkdqsCoyn3yykncdcqUGOsDM4ZW
        6czRp78VU2JZcdc8i4ddS/AArHGFuxcYgPhWGNM=
X-Google-Smtp-Source: ABdhPJxLfXe7yOz3armlBoECQN961LlhqEjCUN1lANq0D6k5xqQh5ZYjGBM82oOaeH9b9Xa0Ehbf/luVgytb1LMjd5E=
X-Received: by 2002:ac5:c902:0:b0:35d:aee2:dc50 with SMTP id
 t2-20020ac5c902000000b0035daee2dc50mr14088600vkl.23.1654888081792; Fri, 10
 Jun 2022 12:08:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210604063116.234316-1-memxor@gmail.com> <CAJnrk1YJe-wtXFF0U2cuZUdd-gH1Y80Ewf3ePo=vh-nbsSBZgg@mail.gmail.com>
 <20220610125830.2tx6syagl2rphl35@apollo.legion> <CAJnrk1YCBn2EkVK89f5f3ijFYUDhLNpjiH8buw8K3p=JMwAc1Q@mail.gmail.com>
In-Reply-To: <CAJnrk1YCBn2EkVK89f5f3ijFYUDhLNpjiH8buw8K3p=JMwAc1Q@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Fri, 10 Jun 2022 12:07:50 -0700
Message-ID: <CAJnrk1YCSaRjd88WCzg4ccv59h0Dn99XXsDDT4ddzz4UYiZmbg@mail.gmail.com>
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

On Fri, Jun 10, 2022 at 10:23 AM Joanne Koong <joannelkoong@gmail.com> wrot=
e:
>
> On Fri, Jun 10, 2022 at 5:58 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Fri, Jun 10, 2022 at 05:54:27AM IST, Joanne Koong wrote:
> > > On Thu, Jun 3, 2021 at 11:31 PM Kumar Kartikeya Dwivedi
> > > <memxor@gmail.com> wrote:
> > > >
> > > > This is the second (non-RFC) version.
> > > >
> > > > This adds a bpf_link path to create TC filters tied to cls_bpf clas=
sifier, and
> > > > introduces fd based ownership for such TC filters. Netlink cannot d=
elete or
> > > > replace such filters, but the bpf_link is severed on indirect destr=
uction of the
> > > > filter (backing qdisc being deleted, or chain being flushed, etc.).=
 To ensure
> > > > that filters remain attached beyond process lifetime, the usual bpf=
_link fd
> > > > pinning approach can be used.
> > > >
> > > > The individual patches contain more details and comments, but the o=
verall kernel
> > > > API and libbpf helper mirrors the semantics of the netlink based TC=
-BPF API
> > > > merged recently. This means that we start by always setting direct =
action mode,
> > > > protocol to ETH_P_ALL, chain_index as 0, etc. If there is a need fo=
r more
> > > > options in the future, they can be easily exposed through the bpf_l=
ink API in
> > > > the future.
> > > >
> > > > Patch 1 refactors cls_bpf change function to extract two helpers th=
at will be
> > > > reused in bpf_link creation.
> > > >
> > > > Patch 2 exports some bpf_link management functions to modules. This=
 is needed
> > > > because our bpf_link object is tied to the cls_bpf_prog object. Tyi=
ng it to
> > > > tcf_proto would be weird, because the update path has to replace of=
floaded bpf
> > > > prog, which happens using internal cls_bpf helpers, and would in ge=
neral be more
> > > > code to abstract over an operation that is unlikely to be implement=
ed for other
> > > > filter types.
> > > >
> > > > Patch 3 adds the main bpf_link API. A function in cls_api takes car=
e of
> > > > obtaining block reference, creating the filter object, and then cal=
ls the
> > > > bpf_link_change tcf_proto op (only supported by cls_bpf) that retur=
ns a fd after
> > > > setting up the internal structures. An optimization is made to not =
keep around
> > > > resources for extended actions, which is explained in a code commen=
t as it wasn't
> > > > immediately obvious.
> > > >
> > > > Patch 4 adds an update path for bpf_link. Since bpf_link_update onl=
y supports
> > > > replacing the bpf_prog, we can skip tc filter's change path by reus=
ing the
> > > > filter object but swapping its bpf_prog. This takes care of replaci=
ng the
> > > > offloaded prog as well (if that fails, update is aborted). So far h=
owever,
> > > > tcf_classify could do normal load (possibly torn) as the cls_bpf_pr=
og->filter
> > > > would never be modified concurrently. This is no longer true, and t=
o not
> > > > penalize the classify hot path, we also cannot impose serialization=
 around
> > > > its load. Hence the load is changed to READ_ONCE, so that the point=
er value is
> > > > always consistent. Due to invocation in a RCU critical section, the=
 lifetime of
> > > > the prog is guaranteed for the duration of the call.
> > > >
> > > > Patch 5, 6 take care of updating the userspace bits and add a bpf_l=
ink returning
> > > > function to libbpf.
> > > >
> > > > Patch 7 adds a selftest that exercises all possible problematic int=
eractions
> > > > that I could think of.
> > > >
> > > > Design:
> > > >
> > > > This is where in the object hierarchy our bpf_link object is attach=
ed.
> > > >
> > > >                                                                    =
         =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
> > > >                                                                    =
         =E2=94=82     =E2=94=82
> > > >                                                                    =
         =E2=94=82 BPF =E2=94=82
> > > >                                                                    =
         program
> > > >                                                                    =
         =E2=94=82     =E2=94=82
> > > >                                                                    =
         =E2=94=94=E2=94=80=E2=94=80=E2=96=B2=E2=94=80=E2=94=80=E2=94=98
> > > >                                                       =E2=94=8C=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90      =
          =E2=94=82
> > > >                                                       =E2=94=82    =
   =E2=94=82         =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=90
> > > >                                                       =E2=94=82  mo=
d  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=96=BA cls_bpf_prog =E2=94=82
> > > > =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=90                                    =E2=94=82cls_bpf=
=E2=94=82         =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=
=94=80=E2=94=80=E2=94=80=E2=96=B2=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=98
> > > > =E2=94=82    tcf_block   =E2=94=82                                 =
   =E2=94=82       =E2=94=82              =E2=94=82   =E2=94=82
> > > > =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=98                                    =E2=94=94=E2=94=80=
=E2=94=80=E2=94=80=E2=96=B2=E2=94=80=E2=94=80=E2=94=80=E2=94=98            =
  =E2=94=82   =E2=94=82
> > > >          =E2=94=82          =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=90                       =E2=94=82                =E2=94=
=8C=E2=94=80=E2=96=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=
=E2=94=90
> > > >          =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BA  tcf_chain  =E2=94=82  =
                     =E2=94=82                =E2=94=82bpf_link=E2=94=82
> > > >                     =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=98                       =E2=94=82                =E2=94=94=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=98
> > > >                             =E2=94=82          =E2=94=8C=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90    =E2=94=82
> > > >                             =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BA  tcf_=
proto  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> > > >                                        =E2=94=94=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=98
> > > >
> > > > The bpf_link is detached on destruction of the cls_bpf_prog.  Doing=
 it this way
> > > > allows us to implement update in a lightweight manner without havin=
g to recreate
> > > > a new filter, where we can just replace the BPF prog attached to cl=
s_bpf_prog.
> > > >
> > > > The other way to do it would be to link the bpf_link to tcf_proto, =
there are
> > > > numerous downsides to this:
> > > >
> > > > 1. All filters have to embed the pointer even though they won't be =
using it when
> > > > cls_bpf is compiled in.
> > > > 2. This probably won't make sense to be extended to other filter ty=
pes anyway.
> > > > 3. We aren't able to optimize the update case without adding anothe=
r bpf_link
> > > > specific update operation to tcf_proto ops.
> > > >
> > > > The downside with tying this to the module is having to export bpf_=
link
> > > > management functions and introducing a tcf_proto op. Hopefully the =
cost of
> > > > another operation func pointer is not big enough (as there is only =
one ops
> > > > struct per module).
> > > >
> > > Hi Kumar,
> > >
> > > Do you have any plans / bandwidth to land this feature upstream? If
> > > so, do you have a tentative estimation for when you'll be able to wor=
k
> > > on this? And if not, are you okay with someone else working on this t=
o
> > > get it merged in?
> > >
> >
> > I can have a look at resurrecting it later this month, if you're ok wit=
h waiting
> > until then, otherwise if someone else wants to pick this up before that=
 it's
> > fine by me, just let me know so we avoid duplicated effort. Note that t=
he
> > approach in v2 is dead/unlikely to get accepted by the TC maintainers, =
so we'd
> > have to implement the way Daniel mentioned in [0].
>
> Sounds great! We'll wait and check back in with you later this month.
>
After reading the linked thread (which I should have done before
submitting my previous reply :)),  if I'm understanding it correctly,
it seems then that the work needed for tc bpf_link will be in a new
direction that's not based on the code in this v2 patchset. I'm
interested in learning more about bpf link and tc - I can pick this up
to work on. But if this was something you wanted to work on though,
please don't hesitate to let me know; I can find some other bpf link
thing to work on instead if that's the case.


> >
> >   [0]: https://lore.kernel.org/bpf/15cd0a9c-95a1-9766-fca1-4bf9d09e4100=
@iogearbox.net
> >
> > > The reason I'm asking is because there are a few networking teams
> > > within Meta that have been requesting this feature :)
> > >
> > > Thanks,
> > > Joanne
> > >
> > > > Changelog:
> > > > ----------
> > > > v1 (RFC) -> v2
> > > > v1: https://lore.kernel.org/bpf/20210528195946.2375109-1-memxor@gma=
il.com
> > > >
> > > >  * Avoid overwriting other members of union in bpf_attr (Andrii)
> > > >  * Set link to NULL after bpf_link_cleanup to avoid double free (An=
drii)
> > > >  * Use __be16 to store the result of htons (Kernel Test Robot)
> > > >  * Make assignment of tcf_exts::net conditional on CONFIG_NET_CLS_A=
CT
> > > >    (Kernel Test Robot)
> > > >
> > > > Kumar Kartikeya Dwivedi (7):
> > > >   net: sched: refactor cls_bpf creation code
> > > >   bpf: export bpf_link functions for modules
> > > >   net: sched: add bpf_link API for bpf classifier
> > > >   net: sched: add lightweight update path for cls_bpf
> > > >   tools: bpf.h: sync with kernel sources
> > > >   libbpf: add bpf_link based TC-BPF management API
> > > >   libbpf: add selftest for bpf_link based TC-BPF management API
> > > >
> > > >  include/linux/bpf_types.h                     |   3 +
> > > >  include/net/pkt_cls.h                         |  13 +
> > > >  include/net/sch_generic.h                     |   6 +-
> > > >  include/uapi/linux/bpf.h                      |  15 +
> > > >  kernel/bpf/syscall.c                          |  14 +-
> > > >  net/sched/cls_api.c                           | 139 ++++++-
> > > >  net/sched/cls_bpf.c                           | 389 ++++++++++++++=
++--
> > > >  tools/include/uapi/linux/bpf.h                |  15 +
> > > >  tools/lib/bpf/bpf.c                           |   8 +-
> > > >  tools/lib/bpf/bpf.h                           |   8 +-
> > > >  tools/lib/bpf/libbpf.c                        |  59 ++-
> > > >  tools/lib/bpf/libbpf.h                        |  17 +
> > > >  tools/lib/bpf/libbpf.map                      |   1 +
> > > >  tools/lib/bpf/netlink.c                       |   5 +-
> > > >  tools/lib/bpf/netlink.h                       |   8 +
> > > >  .../selftests/bpf/prog_tests/tc_bpf_link.c    | 285 +++++++++++++
> > > >  16 files changed, 940 insertions(+), 45 deletions(-)
> > > >  create mode 100644 tools/lib/bpf/netlink.h
> > > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf_l=
ink.c
> > > >
> > > > --
> > > > 2.31.1
> > > >
> >
> > --
> > Kartikeya
