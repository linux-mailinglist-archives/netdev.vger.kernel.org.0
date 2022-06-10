Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1028545927
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 02:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238374AbiFJAYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 20:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbiFJAYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 20:24:49 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3409F42A01;
        Thu,  9 Jun 2022 17:24:39 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id z20so1676017ual.3;
        Thu, 09 Jun 2022 17:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=n1pHArJx3OaCc9LWiRnAZYn+ldDpFaEituhirBQxMKE=;
        b=Sd+0LnZWGLppLgWsHqEBJAjf7ra3qoWN5zjiKSwY+I1XUBbv/xsFQVLMUwS9SkgQpB
         9GnUiRsEb27H1wyQb7nshGE1FooiiWm3HXV0gAEEE+JFpnBv3HEI+4damkZeerplvazJ
         iEi3dnJvXDXr/hNpIV3EYDRXx5Y7yoaL6qVT7USKBmMrdstWKoMntG17CXe+GwrfOeN8
         XIpOC6vh/UTlQ93hh4CcyHfx/RZm0i9SmuSf2QoSO1iyv0Qy4cB/a4CZn1TXdac7gKew
         +5YuRmq6+55Q4rvMcVRRJ0pNriI1l3AWhqKF6C38zIRk6YO1YPTUBdTqnkl0RM3vNzY9
         YNEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=n1pHArJx3OaCc9LWiRnAZYn+ldDpFaEituhirBQxMKE=;
        b=wFvbH+KFdITAHcJrdtpf9ypQXkRs+N/m2ZD3Tah2auEvzhZPI2qrBdLVPZ9TkliqLk
         bGzQopqS55HRhbfdz4DXJ/AvlvhLI280ypNYn/rvzJkKvaQ+pe09BSsaZQhBTZOVC001
         azkHmlhERk8QaMXr+8xbKAffVPoZJa1AGi7SrnLx3qvaDDLl7noSt9gW8dI5efeD33qn
         KIseNPPEyY8JSiNfXCPf5jjKqsVYkVAHf37ghbU7gOfBhrW3u+EwiYR6H/iDcrteOB08
         NcAo97u9lawWZbaDMTG98wKqgdseKvlMidkhRxJSqgjz488bDiOzF3tJrxIj3xkzeswh
         MNQg==
X-Gm-Message-State: AOAM532ljZZXbKwQZjUPlGpXMhRlPbOYtlNolKFi6YModk6U3sv9WuR3
        ZISNg9IZDHLUfHVpoCyyV1dok0oTcQSRwg3l40M=
X-Google-Smtp-Source: ABdhPJxhxwBOzYZLMjFV0C5h+6Ev3SKpN9qUJdU5zR4tSvPuI2uk/hLycx3l10cY+5JRsWHUiHAkLaKkqaKiuU6IZXU=
X-Received: by 2002:ab0:1343:0:b0:362:9e6c:74f5 with SMTP id
 h3-20020ab01343000000b003629e6c74f5mr39082622uae.15.1654820678727; Thu, 09
 Jun 2022 17:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210604063116.234316-1-memxor@gmail.com>
In-Reply-To: <20210604063116.234316-1-memxor@gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Thu, 9 Jun 2022 17:24:27 -0700
Message-ID: <CAJnrk1YJe-wtXFF0U2cuZUdd-gH1Y80Ewf3ePo=vh-nbsSBZgg@mail.gmail.com>
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

On Thu, Jun 3, 2021 at 11:31 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This is the second (non-RFC) version.
>
> This adds a bpf_link path to create TC filters tied to cls_bpf classifier=
, and
> introduces fd based ownership for such TC filters. Netlink cannot delete =
or
> replace such filters, but the bpf_link is severed on indirect destruction=
 of the
> filter (backing qdisc being deleted, or chain being flushed, etc.). To en=
sure
> that filters remain attached beyond process lifetime, the usual bpf_link =
fd
> pinning approach can be used.
>
> The individual patches contain more details and comments, but the overall=
 kernel
> API and libbpf helper mirrors the semantics of the netlink based TC-BPF A=
PI
> merged recently. This means that we start by always setting direct action=
 mode,
> protocol to ETH_P_ALL, chain_index as 0, etc. If there is a need for more
> options in the future, they can be easily exposed through the bpf_link AP=
I in
> the future.
>
> Patch 1 refactors cls_bpf change function to extract two helpers that wil=
l be
> reused in bpf_link creation.
>
> Patch 2 exports some bpf_link management functions to modules. This is ne=
eded
> because our bpf_link object is tied to the cls_bpf_prog object. Tying it =
to
> tcf_proto would be weird, because the update path has to replace offloade=
d bpf
> prog, which happens using internal cls_bpf helpers, and would in general =
be more
> code to abstract over an operation that is unlikely to be implemented for=
 other
> filter types.
>
> Patch 3 adds the main bpf_link API. A function in cls_api takes care of
> obtaining block reference, creating the filter object, and then calls the
> bpf_link_change tcf_proto op (only supported by cls_bpf) that returns a f=
d after
> setting up the internal structures. An optimization is made to not keep a=
round
> resources for extended actions, which is explained in a code comment as i=
t wasn't
> immediately obvious.
>
> Patch 4 adds an update path for bpf_link. Since bpf_link_update only supp=
orts
> replacing the bpf_prog, we can skip tc filter's change path by reusing th=
e
> filter object but swapping its bpf_prog. This takes care of replacing the
> offloaded prog as well (if that fails, update is aborted). So far however=
,
> tcf_classify could do normal load (possibly torn) as the cls_bpf_prog->fi=
lter
> would never be modified concurrently. This is no longer true, and to not
> penalize the classify hot path, we also cannot impose serialization aroun=
d
> its load. Hence the load is changed to READ_ONCE, so that the pointer val=
ue is
> always consistent. Due to invocation in a RCU critical section, the lifet=
ime of
> the prog is guaranteed for the duration of the call.
>
> Patch 5, 6 take care of updating the userspace bits and add a bpf_link re=
turning
> function to libbpf.
>
> Patch 7 adds a selftest that exercises all possible problematic interacti=
ons
> that I could think of.
>
> Design:
>
> This is where in the object hierarchy our bpf_link object is attached.
>
>                                                                          =
   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
>                                                                          =
   =E2=94=82     =E2=94=82
>                                                                          =
   =E2=94=82 BPF =E2=94=82
>                                                                          =
   program
>                                                                          =
   =E2=94=82     =E2=94=82
>                                                                          =
   =E2=94=94=E2=94=80=E2=94=80=E2=96=B2=E2=94=80=E2=94=80=E2=94=98
>                                                       =E2=94=8C=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90            =
    =E2=94=82
>                                                       =E2=94=82       =E2=
=94=82         =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=90
>                                                       =E2=94=82  mod  =E2=
=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=96=BA cls_bpf_prog =E2=94=82
> =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=90                                    =E2=94=82cls_bpf=E2=94=
=82         =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=
=E2=94=80=E2=94=80=E2=96=B2=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=98
> =E2=94=82    tcf_block   =E2=94=82                                    =E2=
=94=82       =E2=94=82              =E2=94=82   =E2=94=82
> =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=98                                    =E2=94=94=E2=94=80=E2=94=
=80=E2=94=80=E2=96=B2=E2=94=80=E2=94=80=E2=94=80=E2=94=98              =E2=
=94=82   =E2=94=82
>          =E2=94=82          =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=90                       =E2=94=82                =E2=94=8C=E2=
=94=80=E2=96=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=
=90
>          =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BA  tcf_chain  =E2=94=82        =
               =E2=94=82                =E2=94=82bpf_link=E2=94=82
>                     =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=98                       =E2=94=82                =E2=94=94=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
>                             =E2=94=82          =E2=94=8C=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=90    =E2=94=82
>                             =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BA  tcf_proto =
 =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
>                                        =E2=94=94=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=98
>
> The bpf_link is detached on destruction of the cls_bpf_prog.  Doing it th=
is way
> allows us to implement update in a lightweight manner without having to r=
ecreate
> a new filter, where we can just replace the BPF prog attached to cls_bpf_=
prog.
>
> The other way to do it would be to link the bpf_link to tcf_proto, there =
are
> numerous downsides to this:
>
> 1. All filters have to embed the pointer even though they won't be using =
it when
> cls_bpf is compiled in.
> 2. This probably won't make sense to be extended to other filter types an=
yway.
> 3. We aren't able to optimize the update case without adding another bpf_=
link
> specific update operation to tcf_proto ops.
>
> The downside with tying this to the module is having to export bpf_link
> management functions and introducing a tcf_proto op. Hopefully the cost o=
f
> another operation func pointer is not big enough (as there is only one op=
s
> struct per module).
>
Hi Kumar,

Do you have any plans / bandwidth to land this feature upstream? If
so, do you have a tentative estimation for when you'll be able to work
on this? And if not, are you okay with someone else working on this to
get it merged in?

The reason I'm asking is because there are a few networking teams
within Meta that have been requesting this feature :)

Thanks,
Joanne

> Changelog:
> ----------
> v1 (RFC) -> v2
> v1: https://lore.kernel.org/bpf/20210528195946.2375109-1-memxor@gmail.com
>
>  * Avoid overwriting other members of union in bpf_attr (Andrii)
>  * Set link to NULL after bpf_link_cleanup to avoid double free (Andrii)
>  * Use __be16 to store the result of htons (Kernel Test Robot)
>  * Make assignment of tcf_exts::net conditional on CONFIG_NET_CLS_ACT
>    (Kernel Test Robot)
>
> Kumar Kartikeya Dwivedi (7):
>   net: sched: refactor cls_bpf creation code
>   bpf: export bpf_link functions for modules
>   net: sched: add bpf_link API for bpf classifier
>   net: sched: add lightweight update path for cls_bpf
>   tools: bpf.h: sync with kernel sources
>   libbpf: add bpf_link based TC-BPF management API
>   libbpf: add selftest for bpf_link based TC-BPF management API
>
>  include/linux/bpf_types.h                     |   3 +
>  include/net/pkt_cls.h                         |  13 +
>  include/net/sch_generic.h                     |   6 +-
>  include/uapi/linux/bpf.h                      |  15 +
>  kernel/bpf/syscall.c                          |  14 +-
>  net/sched/cls_api.c                           | 139 ++++++-
>  net/sched/cls_bpf.c                           | 389 ++++++++++++++++--
>  tools/include/uapi/linux/bpf.h                |  15 +
>  tools/lib/bpf/bpf.c                           |   8 +-
>  tools/lib/bpf/bpf.h                           |   8 +-
>  tools/lib/bpf/libbpf.c                        |  59 ++-
>  tools/lib/bpf/libbpf.h                        |  17 +
>  tools/lib/bpf/libbpf.map                      |   1 +
>  tools/lib/bpf/netlink.c                       |   5 +-
>  tools/lib/bpf/netlink.h                       |   8 +
>  .../selftests/bpf/prog_tests/tc_bpf_link.c    | 285 +++++++++++++
>  16 files changed, 940 insertions(+), 45 deletions(-)
>  create mode 100644 tools/lib/bpf/netlink.h
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c
>
> --
> 2.31.1
>
