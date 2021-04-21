Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6FB367264
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245184AbhDUSUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245166AbhDUSUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 14:20:21 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C51DC06174A;
        Wed, 21 Apr 2021 11:19:48 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id g38so48257200ybi.12;
        Wed, 21 Apr 2021 11:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VDTpQq4DYalAWYAmoJh/WG5jsFOAeqh0h/08+IFYUkY=;
        b=kyTbeppIgZnRavcNSY5hqpSCJGtsUaL+TTBRiQYZa23iMV5f6HWrmeLtOkWFFnA+UG
         s4xyJ4gsEVaq91xg/mc1YiZR0QZsFPNpLL3rewDm50awWS+/iNOY7uiuGOQxwskGSHvr
         r/nm6mxHOliiRNyXBpiLdBHMHlkFFLUbJghFK2+Dxt5kIr44/6jFTGrI32xyiFmX4vmb
         FsnE8gZ/y1OXBD/YntS3TuN4C5hsdamPumUF7+i3C4CrQ9V5+kEU8Cp2RAAqmbQdwkPJ
         eFVinbxFCcjCB5rSzJmsJEio3lsZDoH+j5tvsCo4IrV+f4104wcVJ7OB9oz/VTtsPIAi
         bhXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VDTpQq4DYalAWYAmoJh/WG5jsFOAeqh0h/08+IFYUkY=;
        b=bD794BqFbZPPGso6syfiEEZ/ETPCXJCZN5wL2xD1ZSEJZLsVC/oCQu3upsNTuaIb7n
         LmPOiDnwQu7etrV11rKZAnmsuNnchMA34Hadoa6YtJIWu12YS4Whklri0yYg3x7gwcaz
         RLOgR609aK58qoJLPiMFL6vU9+TMEvlBvj+MWY9bc8deXdPu6tTBMUoQvqFD0z81Y6a8
         4cURrn2ws0FKhkhJZKuf2L7hdRiQxAOmat9JAMG1ZXWDxAhBfXi2RBXjrORZtvQI+Gox
         2MBIeEVHwEiPd75hcGYFlsmeXi6FTazLUrAELRbfcl+09u+ON7r/Thx1NslqmnvEYaNY
         fYJw==
X-Gm-Message-State: AOAM533LIGjraw+mCSF74hRkVqc7F8NEc1LNI/3zl6MIdnEHuCBgkjws
        kLBzFygXdRc9275MAL3JnMvHR2mfTyzFXaxRNps=
X-Google-Smtp-Source: ABdhPJxelyTekVzZKr8Oj45hesrW0KZDNUha04rJUBStnrb0318tt2M8NvvjXvy+SFn/ITMwS+xH3WtMfY0/G7G9RrA=
X-Received: by 2002:a25:c4c5:: with SMTP id u188mr33302759ybf.425.1619029187457;
 Wed, 21 Apr 2021 11:19:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210420193740.124285-1-memxor@gmail.com> <20210420193740.124285-3-memxor@gmail.com>
In-Reply-To: <20210420193740.124285-3-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 21 Apr 2021 11:19:36 -0700
Message-ID: <CAEf4BzYj_pODiQ_Xkdz_czAj3iaBcRhudeb_kJ4M2SczA_jDjA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add low level TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 12:37 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This adds functions that wrap the netlink API used for adding,
> manipulating, and removing traffic control filters. These functions
> operate directly on the loaded prog's fd, and return a handle to the
> filter using an out parameter named id.
>
> The basic featureset is covered to allow for attaching and removal of
> filters. Some additional features like TCA_BPF_POLICE and TCA_RATE for
> the API have been omitted. These can added on top later by extending the
> bpf_tc_opts struct.
>
> Support for binding actions directly to a classifier by passing them in
> during filter creation has also been omitted for now. These actions have
> an auto clean up property because their lifetime is bound to the filter
> they are attached to. This can be added later, but was omitted for now
> as direct action mode is a better alternative to it, which is enabled by
> default.
>
> An API summary:
>
> bpf_tc_attach may be used to attach, and replace SCHED_CLS bpf
> classifier. The protocol is always set as ETH_P_ALL. The replace option
> in bpf_tc_opts is used to control replacement behavior.  Attachment
> fails if filter with existing attributes already exists.
>
> bpf_tc_detach may be used to detach existing SCHED_CLS filter. The
> bpf_tc_attach_id object filled in during attach must be passed in to the
> detach functions for them to remove the filter and its attached
> classififer correctly.
>
> bpf_tc_get_info is a helper that can be used to obtain attributes
> for the filter and classififer.
>
> Examples:
>
>         struct bpf_tc_attach_id id =3D {};
>         struct bpf_object *obj;
>         struct bpf_program *p;
>         int fd, r;
>
>         obj =3D bpf_object_open("foo.o");
>         if (IS_ERR_OR_NULL(obj))
>                 return PTR_ERR(obj);
>
>         p =3D bpf_object__find_program_by_title(obj, "classifier");
>         if (IS_ERR_OR_NULL(p))
>                 return PTR_ERR(p);
>
>         if (bpf_object__load(obj) < 0)
>                 return -1;
>
>         fd =3D bpf_program__fd(p);
>
>         r =3D bpf_tc_attach(fd, if_nametoindex("lo"),
>                           BPF_TC_CLSACT_INGRESS,
>                           NULL, &id);
>         if (r < 0)
>                 return r;
>
> ... which is roughly equivalent to:
>   # tc qdisc add dev lo clsact
>   # tc filter add dev lo ingress bpf obj foo.o sec classifier da
>
> ... as direct action mode is always enabled.
>
> To replace an existing filter:
>
>         DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle =3D id.handle,
>                             .priority =3D id.priority, .replace =3D true)=
;
>         r =3D bpf_tc_attach(fd, if_nametoindex("lo"),
>                           BPF_TC_CLSACT_INGRESS,
>                           &opts, &id);
>         if (r < 0)
>                 return r;
>
> To obtain info of a particular filter, the example above can be extended
> as follows:
>
>         struct bpf_tc_info info =3D {};
>
>         r =3D bpf_tc_get_info(if_nametoindex("lo"),
>                             BPF_TC_CLSACT_INGRESS,
>                             &id, &info);
>         if (r < 0)
>                 return r;
>
> ... where id corresponds to the bpf_tc_attach_id filled in during an
> attach operation.
>
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/lib/bpf/libbpf.h   |  44 ++++++
>  tools/lib/bpf/libbpf.map |   3 +
>  tools/lib/bpf/netlink.c  | 319 ++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 360 insertions(+), 6 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index bec4e6a6e31d..b4ed6a41ea70 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -16,6 +16,8 @@
>  #include <stdbool.h>
>  #include <sys/types.h>  // for size_t
>  #include <linux/bpf.h>
> +#include <linux/pkt_sched.h>
> +#include <linux/tc_act/tc_bpf.h>

apart from those unused macros below, are these needed in public API header=
?

>
>  #include "libbpf_common.h"
>
> @@ -775,6 +777,48 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linke=
r *linker, const char *filen
>  LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
>  LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
>
> +/* Convenience macros for the clsact attach hooks */
> +#define BPF_TC_CLSACT_INGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS)
> +#define BPF_TC_CLSACT_EGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)

these seem to be used only internally, why exposing them in public API?

> +
> +struct bpf_tc_opts {
> +       size_t sz;
> +       __u32 handle;
> +       __u32 class_id;
> +       __u16 priority;
> +       bool replace;
> +       size_t :0;
> +};
> +
> +#define bpf_tc_opts__last_field replace
> +
> +/* Acts as a handle for an attached filter */
> +struct bpf_tc_attach_id {
> +       __u32 handle;
> +       __u16 priority;
> +};

what are the chances that we'll need to grow this id struct? If that
happens, how do we do that in a backward/forward compatible manner?

if handle/prio are the only two ever necessary, we can actually use
bpf_tc_opts to return them back to user (we do that with
bpf_test_run_opts API). And then adjust detach/get_info methods to let
pass those values.

The whole idea of a struct for id just screams "compatibility problems
down the road" at me. Does anyone else has any other opinion on this?

> +
> +struct bpf_tc_info {
> +       struct bpf_tc_attach_id id;
> +       __u16 protocol;
> +       __u32 chain_index;
> +       __u32 prog_id;
> +       __u8 tag[BPF_TAG_SIZE];
> +       __u32 class_id;
> +       __u32 bpf_flags;
> +       __u32 bpf_flags_gen;
> +};
> +
> +/* id is out parameter that will be written to, it must not be NULL */
> +LIBBPF_API int bpf_tc_attach(int fd, __u32 ifindex, __u32 parent_id,

so parent_id is INGRESS|EGRESS, right? Is that an obvious name for
this parameter? I had to look at the code to understand what's
expected. Is it possible that it will be anything other than INGRESS
or EGRESS? If not `bool ingress` might be an option. Or perhaps enum
bpf_tc_direction { BPF_TC_INGRESS, BPF_TC_EGRESS } is better still.

> +                            const struct bpf_tc_opts *opts,
> +                            struct bpf_tc_attach_id *id);
> +LIBBPF_API int bpf_tc_detach(__u32 ifindex, __u32 parent_id,
> +                            const struct bpf_tc_attach_id *id);
> +LIBBPF_API int bpf_tc_get_info(__u32 ifindex, __u32 parent_id,

bpf_tc_query() to be more in line with attach/detach single-word verbs?

> +                              const struct bpf_tc_attach_id *id,
> +                              struct bpf_tc_info *info);
> +
>  #ifdef __cplusplus
>  } /* extern "C" */
>  #endif
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index b9b29baf1df8..686444fbb838 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -361,4 +361,7 @@ LIBBPF_0.4.0 {
>                 bpf_linker__new;
>                 bpf_map__inner_map;
>                 bpf_object__set_kversion;
> +               bpf_tc_attach;
> +               bpf_tc_detach;
> +               bpf_tc_get_info;
>  } LIBBPF_0.3.0;

[...]
