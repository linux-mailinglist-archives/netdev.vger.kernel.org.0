Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761F7399539
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 23:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhFBVLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 17:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhFBVLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 17:11:11 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B530BC06174A;
        Wed,  2 Jun 2021 14:09:27 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id q21so5737726ybg.8;
        Wed, 02 Jun 2021 14:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZvLptDjLf0XciKgqe9WIKRV3De07QFK7HThwv/f5jJ8=;
        b=LidDn4E+Orrt8Sie/DCluEM+33VSWaG2x7DiVUPxK8PjT+dzkWuhoHDMS+i3tlL5Ti
         wk3LopG5ZlX5slEZmztqM8V0+LfBpGMyX0T2uJdzynjNfFgtSd7HmJM/F9w9jiovznwN
         AfT1W40kFlOY2E8aY2TjG5SdyCI01waEVmwH4QuNBVxC4a+XnlbO0NhGJB1Zleq5Jjwp
         0Biz3IIUthunX8a/Z+u10vo0ad6k/GGB3DVqMj1dzJtkIR/zWMd/9qixDdyOpMisjIQC
         0FOL+BMwswGoMGXSpLpqiqm+9rKwa4idu2r9XUnNJNsTzh3bBdlbzlSMqq/NLX5iWDxD
         0q1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZvLptDjLf0XciKgqe9WIKRV3De07QFK7HThwv/f5jJ8=;
        b=TRWjdtZtw+DI4kxWt37tEbte21uCfAgE2oAAumAWUh1jtEil7xWWYqfDD+9I9S+8CO
         YOe3Q4JRBWhyBseel0Pv4gbDrPtOH1DmWoT4Xenn2lv6RllNMvv9d4jppoNGMIHDJQEb
         laASI1kVtSl2ScJ+kAYT4NcdeeuHJ9V5qZkVPdp9j1++HkfrV0TwaxLPyfXeA6gM28RX
         SFKNRp7EFodsYmu5lIQJUHnrAXyEqZkLcYzxL0g0shnyg+WuybaUdIgWfWUjz8ruilf5
         KEZ+RCMp2WvJy7oaDqKhMPtO+AtZFbW5Bua7BxDm+lFr3kGo5Loi02TPfkoAHH1WFEMm
         VBcQ==
X-Gm-Message-State: AOAM531wBUUdBdf4JPW6hzlyY57ThAx/gPdknkYSCxmkfhCmgLcPPpgW
        OSpD81yXCox+Zlf0UqL5aSLhb6CSSRNnZpKObXQ=
X-Google-Smtp-Source: ABdhPJw0EMv54Bm2FN7rvLD6acmg9cyp3pqFYCj47kbtZG1KvpDXwHnG5Lfov63DW8ZJOj5TUoXtW8cbriEMImTROnQ=
X-Received: by 2002:a25:6612:: with SMTP id a18mr15093133ybc.347.1622668166960;
 Wed, 02 Jun 2021 14:09:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210528195946.2375109-1-memxor@gmail.com>
In-Reply-To: <20210528195946.2375109-1-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Jun 2021 14:09:15 -0700
Message-ID: <CAEf4BzZt5nRsfCiqGkJxW2b-==AYEVCiz6jHC-FrXKkPF=Qj7w@mail.gmail.com>
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
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 1:00 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This is the first RFC version.
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
> This first version is to collect feedback on the approach and get ideas i=
f there
> is a better way to do this.

Bpf_link-based TC API is a long time coming, so it's great to see
someone finally working on this. Thanks!

I briefly skimmed through the patch set, noticed a few generic
bpf_link problems. But I think main feedback will come from Cilium
folks and others that heavily rely on TC APIs. I wonder if there is an
opportunity to simplify the API further given we have a new
opportunity here. I don't think we are constrained to follow legacy TC
API exactly.

The problem is that your patch set was marked as spam by Google, so I
suspect a bunch of folks haven't gotten it. I suggest re-sending it
again but trimming down the CC list, leaving only bpf@vger,
netdev@vger, and BPF maintainers CC'ed directly.

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
>  net/sched/cls_api.c                           | 138 ++++++-
>  net/sched/cls_bpf.c                           | 386 ++++++++++++++++--
>  tools/include/uapi/linux/bpf.h                |  15 +
>  tools/lib/bpf/bpf.c                           |   5 +
>  tools/lib/bpf/bpf.h                           |   8 +-
>  tools/lib/bpf/libbpf.c                        |  59 ++-
>  tools/lib/bpf/libbpf.h                        |  17 +
>  tools/lib/bpf/libbpf.map                      |   1 +
>  tools/lib/bpf/netlink.c                       |   5 +-
>  tools/lib/bpf/netlink.h                       |   8 +
>  .../selftests/bpf/prog_tests/tc_bpf_link.c    | 285 +++++++++++++
>  16 files changed, 934 insertions(+), 44 deletions(-)
>  create mode 100644 tools/lib/bpf/netlink.h
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c
>
> --
> 2.31.1
>
