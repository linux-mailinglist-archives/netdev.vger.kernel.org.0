Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8EA26CF00
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgIPWnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbgIPWm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:42:57 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6706C061356;
        Wed, 16 Sep 2020 14:24:32 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id g96so56274ybi.12;
        Wed, 16 Sep 2020 14:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FpS/+5JyfGrVbJJkvaQpYEm4wHItEk98fBuyol9kQdQ=;
        b=XRjFNZH7+gk68Hi6zcPmIfGBU+vtr2vCkYT44DHu9qBHYrdyjIXH4R6louzi+4x0Je
         1Vy9FbwfouMZxkoUDk+fvB+27EikmvJARB7GyjUlx/yvyw/JaHtugPASiJpeoUbHKJkC
         +5QxRJmRuPhRJQt/DInPReNpLt/v7gXf5s972KIVdDxRva7dPYYxCi8WHJjJD6cMcbf+
         q+ImQO8cATtyzGf6Zb3A9GLKG+NXQm8CZx9hsxLTFt/5BoeAjnNpOSd91gfQ/r6t3NFC
         UeU+hll8d3FtbaWyTOjmYIhcQwM1M0yiRy6D2TvuVY+jtcnM+HTMzP2OmJwJdgj9HzGe
         4ykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FpS/+5JyfGrVbJJkvaQpYEm4wHItEk98fBuyol9kQdQ=;
        b=k3MIM4vbq1XXQE8phs02ojaeTqcyW5Sag7pv9g8fQPT8aU/BIHMJVXd0QfStiWx27B
         MLChoYLHZQkjKyO8fnnvQNiBgm4rUEb++qplY/6e/aWOc47xq+7nRhWQTMCoCtqh8Pmp
         6JMtFg/yAjc+3TN5mwMYxOlLTbOFKkUH0C1OvwlTQEyGOVGj1Ll8s3zczctFbxIOcdGj
         kfMhjeq4/P5rNJeFjW93g7LhpSSoyxATJS3nNoeb53nPdSWVamSut8oMDdwHjNqvvkQl
         CoddPYy23VHUi+ojMo8RNqnFmINBecs4P4IKn17T0B2CYMRCG4FSZ8wNb66ifMZ+ek4Z
         n1VA==
X-Gm-Message-State: AOAM530HCujFnt1aX7axVaBHSMQPMI7oo1gZMsSjcizy8qiWk9WZthyL
        1Dndn6GklvcZRfcqcPRG3KbYJkpnH3dUGb/f3UI=
X-Google-Smtp-Source: ABdhPJyYqX6pLjQvnTVna+tuIUYamTmBUY+5eHjOWHDCAwJ8MFIQNKUcKLUXakPF6LKh2C7Iz5ywYKNgnXmmJ8nFafs=
X-Received: by 2002:a25:d70e:: with SMTP id o14mr28429023ybg.425.1600291472000;
 Wed, 16 Sep 2020 14:24:32 -0700 (PDT)
MIME-Version: 1.0
References: <160017005691.98230.13648200635390228683.stgit@toke.dk>
 <160017006352.98230.621859348254499900.stgit@toke.dk> <CAEf4BzZx33sqDd2WU2j+Ht_njn2qfcV1C0ginPBde+wj8rROeQ@mail.gmail.com>
 <CAEf4Bzb5pLJaW_Rkiq+5QacH6G-FFmj6eRBiZKybYCkkBVMzLA@mail.gmail.com> <87h7rxpge0.fsf@toke.dk>
In-Reply-To: <87h7rxpge0.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Sep 2020 14:24:20 -0700
Message-ID: <CAEf4BzZcp+ZCegpQRgo+gEp7y+XekajyfN=DE15X3hNb7XVksQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 6/8] libbpf: add support for freplace
 attachment in bpf_link_create
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 2:21 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Wed, Sep 16, 2020 at 1:37 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> >>
> >> On Tue, Sep 15, 2020 at 5:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
> >> >
> >> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >
> >> > This adds support for supplying a target btf ID for the bpf_link_cre=
ate()
> >> > operation, and adds a new bpf_program__attach_freplace() high-level =
API for
> >> > attaching freplace functions with a target.
> >> >
> >> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> > ---
> >> >  tools/lib/bpf/bpf.c      |    1 +
> >> >  tools/lib/bpf/bpf.h      |    3 ++-
> >> >  tools/lib/bpf/libbpf.c   |   24 ++++++++++++++++++------
> >> >  tools/lib/bpf/libbpf.h   |    3 +++
> >> >  tools/lib/bpf/libbpf.map |    1 +
> >> >  5 files changed, 25 insertions(+), 7 deletions(-)
> >> >
> >> > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> >> > index 82b983ff6569..e928456c0dd6 100644
> >> > --- a/tools/lib/bpf/bpf.c
> >> > +++ b/tools/lib/bpf/bpf.c
> >> > @@ -599,6 +599,7 @@ int bpf_link_create(int prog_fd, int target_fd,
> >> >         attr.link_create.iter_info =3D
> >> >                 ptr_to_u64(OPTS_GET(opts, iter_info, (void *)0));
> >> >         attr.link_create.iter_info_len =3D OPTS_GET(opts, iter_info_=
len, 0);
> >> > +       attr.link_create.target_btf_id =3D OPTS_GET(opts, target_btf=
_id, 0);
> >> >
> >> >         return sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
> >> >  }
> >> > diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> >> > index 015d13f25fcc..f8dbf666b62b 100644
> >> > --- a/tools/lib/bpf/bpf.h
> >> > +++ b/tools/lib/bpf/bpf.h
> >> > @@ -174,8 +174,9 @@ struct bpf_link_create_opts {
> >> >         __u32 flags;
> >> >         union bpf_iter_link_info *iter_info;
> >> >         __u32 iter_info_len;
> >> > +       __u32 target_btf_id;
> >> >  };
> >> > -#define bpf_link_create_opts__last_field iter_info_len
> >> > +#define bpf_link_create_opts__last_field target_btf_id
> >> >
> >> >  LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
> >> >                                enum bpf_attach_type attach_type,
> >> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> > index 550950eb1860..165131c73f40 100644
> >> > --- a/tools/lib/bpf/libbpf.c
> >> > +++ b/tools/lib/bpf/libbpf.c
> >> > @@ -9322,12 +9322,14 @@ static struct bpf_link *attach_iter(const st=
ruct bpf_sec_def *sec,
> >> >
> >> >  static struct bpf_link *
> >> >  bpf_program__attach_fd(struct bpf_program *prog, int target_fd,
> >> > -                      const char *target_name)
> >> > +                      int target_btf_id, const char *target_name)
> >> >  {
> >> >         enum bpf_attach_type attach_type;
> >> >         char errmsg[STRERR_BUFSIZE];
> >> >         struct bpf_link *link;
> >> >         int prog_fd, link_fd;
> >> > +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
> >> > +                           .target_btf_id =3D target_btf_id);
> >> >
> >> >         prog_fd =3D bpf_program__fd(prog);
> >> >         if (prog_fd < 0) {
> >> > @@ -9340,8 +9342,12 @@ bpf_program__attach_fd(struct bpf_program *pr=
og, int target_fd,
> >> >                 return ERR_PTR(-ENOMEM);
> >> >         link->detach =3D &bpf_link__detach_fd;
> >> >
> >> > -       attach_type =3D bpf_program__get_expected_attach_type(prog);
> >> > -       link_fd =3D bpf_link_create(prog_fd, target_fd, attach_type,=
 NULL);
> >> > +       if (bpf_program__get_type(prog) =3D=3D BPF_PROG_TYPE_EXT)
> >> > +               attach_type =3D BPF_TRACE_FREPLACE;
> >>
> >> doing this unconditionally will break an old-style freplace without
> >> target_fd/btf_id on older kernels. Safe and simple way would be to
> >> continue using raw_tracepoint_open when there is no target_fd/btf_id,
> >> and use LINK_CREATE for newer stuff. Alternatively, you'd need to do
> >> feature detection, but it's still would be nice to handle old-style
> >> attach through raw_tracepoint_open for bpf_program__attach_freplace.
> >>
> >> so I suggest leaving bpf_program__attach_fd() as is and to create a
> >> custom bpf_program__attach_freplace() implementation.
>
> Sure, I'll take another pass at this. Not sure how useful feature
> detection in libbpf is; if the caller passes a target, libbpf can't
> really do much if the kernel doesn't support it...

I was thinking about bpf_program__attach_freplace(prog, 0, NULL) doing
bpf_raw_tracepoint_open(). It would be nice to support this, for API
uniformity, no?

>
> >> > +       else
> >> > +               attach_type =3D bpf_program__get_expected_attach_typ=
e(prog);
> >> > +
> >> > +       link_fd =3D bpf_link_create(prog_fd, target_fd, attach_type,=
 &opts);
> >> >         if (link_fd < 0) {
> >> >                 link_fd =3D -errno;
> >> >                 free(link);
> >> > @@ -9357,19 +9363,25 @@ bpf_program__attach_fd(struct bpf_program *p=
rog, int target_fd,
> >> >  struct bpf_link *
> >> >  bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
> >> >  {
> >> > -       return bpf_program__attach_fd(prog, cgroup_fd, "cgroup");
> >> > +       return bpf_program__attach_fd(prog, cgroup_fd, 0, "cgroup");
> >> >  }
> >> >
> >> >  struct bpf_link *
> >> >  bpf_program__attach_netns(struct bpf_program *prog, int netns_fd)
> >> >  {
> >> > -       return bpf_program__attach_fd(prog, netns_fd, "netns");
> >> > +       return bpf_program__attach_fd(prog, netns_fd, 0, "netns");
> >> >  }
> >> >
> >> >  struct bpf_link *bpf_program__attach_xdp(struct bpf_program *prog, =
int ifindex)
> >> >  {
> >> >         /* target_fd/target_ifindex use the same field in LINK_CREAT=
E */
> >> > -       return bpf_program__attach_fd(prog, ifindex, "xdp");
> >> > +       return bpf_program__attach_fd(prog, ifindex, 0, "xdp");
> >> > +}
> >> > +
> >> > +struct bpf_link *bpf_program__attach_freplace(struct bpf_program *p=
rog,
> >> > +                                             int target_fd, int tar=
get_btf_id)
> >> > +{
> >> > +       return bpf_program__attach_fd(prog, target_fd, target_btf_id=
, "freplace");
> >> >  }
> >> >
> >> >  struct bpf_link *
> >> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> >> > index a750f67a23f6..ce5add9b9203 100644
> >> > --- a/tools/lib/bpf/libbpf.h
> >> > +++ b/tools/lib/bpf/libbpf.h
> >> > @@ -261,6 +261,9 @@ LIBBPF_API struct bpf_link *
> >> >  bpf_program__attach_netns(struct bpf_program *prog, int netns_fd);
> >> >  LIBBPF_API struct bpf_link *
> >> >  bpf_program__attach_xdp(struct bpf_program *prog, int ifindex);
> >> > +LIBBPF_API struct bpf_link *
> >> > +bpf_program__attach_freplace(struct bpf_program *prog,
> >> > +                            int target_fd, int target_btf_id);
> >>
> >> maybe a const char * function name instead of target_btf_id would be a
> >> nicer API? Users won't have to deal with fetching target prog's BTF,
> >> searching it, etc. That's all pretty straightforward for libbpf to do,
> >> leaving users with more natural and simpler API.
> >>
> >
> > bpf_program__set_attach_target() uses string name for target
> > functions, we should definitely be consistent here
>
> All right, fair enough :)
>
> -Toke
>
