Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45185372341
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 00:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbhECWzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 18:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhECWzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 18:55:10 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012CFC061574;
        Mon,  3 May 2021 15:54:17 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id g38so9690218ybi.12;
        Mon, 03 May 2021 15:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WUJhnxU6cwZ9hrzXgR8muBFpzaHvi5sAFLcV3wkgF3M=;
        b=TjJ4eGQzGiwcO9sJ752saSyPqLTYLms8meeqnrv5fV4QqUdOIp7MBYP/JEQx4Pz6/n
         EcttZdv/5RP+EeMcZcZYZ8aqRpUqaf3v5hC/kDtfqQyzcDN0eneLtXbrFYEvXRTM3GdC
         i1yokvUrF9coS3s0VpQonfCLbry/I5jiKT9vBGIKjoUFUkH9qkU3neu/O+4F8jrnxhx2
         EiXCp2J5ZyrwKRgSyXEPaCXpR03yoHAQluatlHXLpOMFF6Lj8rDigeFlclulYDjDEIRv
         bhiEKRhWmi7Vywb5cv1zitET6qQG9mKxGvkO9kcJGKxkTotAb8prVuPjRSXDuDvgboBe
         +00g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WUJhnxU6cwZ9hrzXgR8muBFpzaHvi5sAFLcV3wkgF3M=;
        b=a3kRaYMeTZMma+EHRD4gLn0shCKpXZrAUYWpLPdTH67Qc4EpuW7txI+Ey1FEsD3/oY
         vTnFxw4rqVfDNhhwlcanm16wXRRYq5dL6sOvH5fBt1ghpkWFPvMaz7EoW08G3MuIbW3i
         GqEXvFlEcw1hheYlT1uvF4K8wkhuCh9ocaynvxBRn6XeUIqipH/Z4oQot6h6aM7QeytV
         t+0afcM5SDSM39tGp+upWVgy2BwBRqBn+xk1YIBLAGO7w/HSSPWuiPxuaMmdHVWgjtwN
         mC/XhaMj8L5s2zXkbUojnmy5yEYbWB1YYMwXdphSgv+c+EvTj0kK6zbxuqUZT4vP/Eu6
         u5fg==
X-Gm-Message-State: AOAM532YzdVa51N03oq9Eua8FzWhdH8YGPjgMBQDcFXjpFO0xLnTB9p3
        4LbPwb/uipes9RlWATVeN5Q7DJk13Soh186SUuo=
X-Google-Smtp-Source: ABdhPJyUYveOBaseVZmAJWokM5yu5X0xqHdOUJHWQNingr8yYWjDlBRKFoNO1vx0Gx6LoUWmbqH94GAyNi4MCKah4qI=
X-Received: by 2002:a25:3357:: with SMTP id z84mr29830750ybz.260.1620082456347;
 Mon, 03 May 2021 15:54:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210428162553.719588-1-memxor@gmail.com> <20210428162553.719588-3-memxor@gmail.com>
 <CAEf4BzYhOQu1A-iK_D-gzcxfZj4BfDXoJ5=8zzHL8qO-URfRiA@mail.gmail.com> <20210501063246.iqhw5sdvx4iwllng@apollo>
In-Reply-To: <20210501063246.iqhw5sdvx4iwllng@apollo>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 3 May 2021 15:54:05 -0700
Message-ID: <CAEf4BzbGsXzT0V49FmqsaoORYpO-S1Y9yfPaR0MyoYFdCg+4wQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 2/3] libbpf: add low level TC-BPF API
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
        Shaun Crampton <shaun@tigera.io>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 11:32 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Sat, May 01, 2021 at 01:05:40AM IST, Andrii Nakryiko wrote:
> > On Wed, Apr 28, 2021 at 9:26 AM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > This adds functions that wrap the netlink API used for adding,
> > > manipulating, and removing traffic control filters.
> > >
> > > An API summary:
> > >
> > > A bpf_tc_hook represents a location where a TC-BPF filter can be
> > > attached. This means that creating a hook leads to creation of the
> > > backing qdisc, while destruction either removes all filters attached =
to
> > > a hook, or destroys qdisc if requested explicitly (as discussed below=
).
> > >
> > > The TC-BPF API functions operate on this bpf_tc_hook to attach, repla=
ce,
> > > query, and detach tc filters.
> > >
> > > All functions return 0 on success, and a negative error code on failu=
re.
> > >

[...]

> > >
> > > Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > ---
> >
> > API looks good to me (except the flags field that just stands out).
> > But I'll defer to Daniel to make the final call.
> >
> > >  tools/lib/bpf/libbpf.h   |  41 ++++
> > >  tools/lib/bpf/libbpf.map |   5 +
> > >  tools/lib/bpf/netlink.c  | 463 +++++++++++++++++++++++++++++++++++++=
+-
> > >  3 files changed, 508 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > > index bec4e6a6e31d..3de701f46a33 100644
> > > --- a/tools/lib/bpf/libbpf.h
> > > +++ b/tools/lib/bpf/libbpf.h
> > > @@ -775,6 +775,47 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_l=
inker *linker, const char *filen
> > >  LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
> > >  LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
> > >
> > > +enum bpf_tc_attach_point {
> > > +       BPF_TC_INGRESS =3D 1 << 0,
> > > +       BPF_TC_EGRESS  =3D 1 << 1,
> > > +       BPF_TC_CUSTOM  =3D 1 << 2,
> > > +};
> > > +
> > > +enum bpf_tc_attach_flags {
> > > +       BPF_TC_F_REPLACE =3D 1 << 0,
> > > +};
> > > +
> > > +struct bpf_tc_hook {
> > > +       size_t sz;
> > > +       int ifindex;
> > > +       enum bpf_tc_attach_point attach_point;
> > > +       __u32 parent;
> > > +       size_t :0;
> > > +};
> > > +
> > > +#define bpf_tc_hook__last_field parent
> > > +
> > > +struct bpf_tc_opts {
> > > +       size_t sz;
> > > +       int prog_fd;
> > > +       __u32 prog_id;
> > > +       __u32 handle;
> > > +       __u32 priority;
> > > +       size_t :0;
> > > +};
> > > +
> > > +#define bpf_tc_opts__last_field priority
> > > +
> > > +LIBBPF_API int bpf_tc_hook_create(struct bpf_tc_hook *hook, int flag=
s);
> > > +LIBBPF_API int bpf_tc_hook_destroy(struct bpf_tc_hook *hook);
> > > +LIBBPF_API int bpf_tc_attach(const struct bpf_tc_hook *hook,
> > > +                            struct bpf_tc_opts *opts,
> > > +                            int flags);
> >
> > why didn't you put flags into bpf_tc_opts? they are clearly optional
> > and fit into "opts" paradigm...
> >
>
> I can move this into opts, but during previous discussion it was kept out=
side
> opts by Daniel, so I kept that unchanged.

for bpf_tc_attach() I see no reason to keep flags separate. For
bpf_tc_hook_create()... for extensibility it would need it's own opts
for hook creation. But if flags is 99% the only thing we'll need, then
we can always add extra bpf_tc_hook_create_opts() later.

>
> > > +LIBBPF_API int bpf_tc_detach(const struct bpf_tc_hook *hook,
> > > +                            const struct bpf_tc_opts *opts);
> > > +LIBBPF_API int bpf_tc_query(const struct bpf_tc_hook *hook,
> > > +                           struct bpf_tc_opts *opts);
> > > +
> > >  #ifdef __cplusplus
> > >  } /* extern "C" */
> > >  #endif

[...]

> > > +               return -EINVAL;
> > > +
> > > +       return tc_qdisc_create_excl(hook, flags);
> > > +}
> > > +
> > > +static int tc_cls_detach(const struct bpf_tc_hook *hook,
> > > +                        const struct bpf_tc_opts *opts, bool flush);
> > > +
> > > +int bpf_tc_hook_destroy(struct bpf_tc_hook *hook)
> > > +{
> > > +       if (!hook || !OPTS_VALID(hook, bpf_tc_hook) ||
> > > +           OPTS_GET(hook, ifindex, 0) <=3D 0)
> > > +               return -EINVAL;
> > > +
> > > +       switch ((int)OPTS_GET(hook, attach_point, 0)) {
> >
> > int casting. Did the compiler complain about that or what?
> >
>
> It complains on -Wswitch, as we switch on values apart from the enum valu=
es, but
> I'll see if I can remove it.

ah, because of BPF_TC_INGRESS|BPF_TC_EGRESS? That sucks, of course. An
alternative I guess is just declaring BPF_TC_INGRESS_EGRESS =3D
BPF_TC_INGRESS | BPF_TC_EGRESS, but I don't know how awful that would
be.

>
> > > +               case BPF_TC_INGRESS:
> > > +               case BPF_TC_EGRESS:
> > > +                       return tc_cls_detach(hook, NULL, true);
> > > +               case BPF_TC_INGRESS|BPF_TC_EGRESS:
> > > +                       return tc_qdisc_delete(hook);
> > > +               case BPF_TC_CUSTOM:
> > > +                       return -EOPNOTSUPP;
> > > +               default:
> > > +                       return -EINVAL;
> > > +       }
> > > +}
> > > +

[...]
