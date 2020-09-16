Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F39026CE98
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgIPWVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:21:38 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28740 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726302AbgIPWVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:21:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600294891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uYvo0H1Rjzjv0NWBOaMQkBnxRuElNbgBtZ6nMHuKkD4=;
        b=I4AoPSUtBIglGG3NcFPMD/qNdOanjlUD2j0uSv6PTU+cG7urGFd64iid6Yq/NtrFFQ2XuQ
        OpLdaiMHgAHC+Z9+3zq3gqlbiHKpTiT/wDL/je1nPP/yhHNOrCuJLutl30YSraxA/GO0BW
        FgY1OLz85T2sWVIIoLpef4T6rkvTBzY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-zBdCnKa4NLOg3oSrNtcIXg-1; Wed, 16 Sep 2020 17:21:14 -0400
X-MC-Unique: zBdCnKa4NLOg3oSrNtcIXg-1
Received: by mail-wr1-f72.google.com with SMTP id a12so3047385wrg.13
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 14:21:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=uYvo0H1Rjzjv0NWBOaMQkBnxRuElNbgBtZ6nMHuKkD4=;
        b=qFslI5sKxuyAGjbh862EiaG6/r3SyfvUcZV4j65lwPa5RA45faexTgsgwLWY9Fch/y
         PCr0F7XAaFL/Od9cBNud72m6Hr6fmoVoiRMu7l+4p7nNSf5w9HIFRMup9r0cuLLjKApW
         SX1Kq/LkBBomkXxqFSh3YKuHeVgMbMOBZQ25i2R0YNteJeSrXUSHO1yJNkyyZtIkqV/z
         7285DhPX/lPo0WInJ2ftBZVNtxSdFMw2I+XenK4mzXoaRgg5ZHHEya+5T8VVBYqruP8l
         aJ0arjZ6EvwOpPOBrcrlRgNtFY6d6fJFqKTzvSZVjZ8DYxzc7F1yN2kbkhzsX+pUsNlN
         itGg==
X-Gm-Message-State: AOAM532QVcg9D864dw71VhuX4fJ+EjgCHZr18aIyh4mtDXlnpL+XbV4g
        eTX2sb6spTAN6LkDA9iSm/vSsgUULFAyINm0qolLRYjayysa556ii7Hoaa7v30ppMduWmiS9riB
        LRY83XwObEPx9LAA9
X-Received: by 2002:adf:8b48:: with SMTP id v8mr28748181wra.21.1600291273159;
        Wed, 16 Sep 2020 14:21:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZNSLiRlSWecdTzovI64PYyISFchtEd/S31DTdIJEc3WTOk7+iIddmrHXw3zvXJlJM6Dqwdg==
X-Received: by 2002:adf:8b48:: with SMTP id v8mr28748159wra.21.1600291272889;
        Wed, 16 Sep 2020 14:21:12 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t6sm39182304wre.30.2020.09.16.14.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 14:21:12 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 948DA183A90; Wed, 16 Sep 2020 23:21:11 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Subject: Re: [PATCH bpf-next v5 6/8] libbpf: add support for freplace
 attachment in bpf_link_create
In-Reply-To: <CAEf4Bzb5pLJaW_Rkiq+5QacH6G-FFmj6eRBiZKybYCkkBVMzLA@mail.gmail.com>
References: <160017005691.98230.13648200635390228683.stgit@toke.dk>
 <160017006352.98230.621859348254499900.stgit@toke.dk>
 <CAEf4BzZx33sqDd2WU2j+Ht_njn2qfcV1C0ginPBde+wj8rROeQ@mail.gmail.com>
 <CAEf4Bzb5pLJaW_Rkiq+5QacH6G-FFmj6eRBiZKybYCkkBVMzLA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 16 Sep 2020 23:21:11 +0200
Message-ID: <87h7rxpge0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Wed, Sep 16, 2020 at 1:37 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
>>
>> On Tue, Sep 15, 2020 at 5:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>> >
>> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >
>> > This adds support for supplying a target btf ID for the bpf_link_creat=
e()
>> > operation, and adds a new bpf_program__attach_freplace() high-level AP=
I for
>> > attaching freplace functions with a target.
>> >
>> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> > ---
>> >  tools/lib/bpf/bpf.c      |    1 +
>> >  tools/lib/bpf/bpf.h      |    3 ++-
>> >  tools/lib/bpf/libbpf.c   |   24 ++++++++++++++++++------
>> >  tools/lib/bpf/libbpf.h   |    3 +++
>> >  tools/lib/bpf/libbpf.map |    1 +
>> >  5 files changed, 25 insertions(+), 7 deletions(-)
>> >
>> > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
>> > index 82b983ff6569..e928456c0dd6 100644
>> > --- a/tools/lib/bpf/bpf.c
>> > +++ b/tools/lib/bpf/bpf.c
>> > @@ -599,6 +599,7 @@ int bpf_link_create(int prog_fd, int target_fd,
>> >         attr.link_create.iter_info =3D
>> >                 ptr_to_u64(OPTS_GET(opts, iter_info, (void *)0));
>> >         attr.link_create.iter_info_len =3D OPTS_GET(opts, iter_info_le=
n, 0);
>> > +       attr.link_create.target_btf_id =3D OPTS_GET(opts, target_btf_i=
d, 0);
>> >
>> >         return sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
>> >  }
>> > diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
>> > index 015d13f25fcc..f8dbf666b62b 100644
>> > --- a/tools/lib/bpf/bpf.h
>> > +++ b/tools/lib/bpf/bpf.h
>> > @@ -174,8 +174,9 @@ struct bpf_link_create_opts {
>> >         __u32 flags;
>> >         union bpf_iter_link_info *iter_info;
>> >         __u32 iter_info_len;
>> > +       __u32 target_btf_id;
>> >  };
>> > -#define bpf_link_create_opts__last_field iter_info_len
>> > +#define bpf_link_create_opts__last_field target_btf_id
>> >
>> >  LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
>> >                                enum bpf_attach_type attach_type,
>> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> > index 550950eb1860..165131c73f40 100644
>> > --- a/tools/lib/bpf/libbpf.c
>> > +++ b/tools/lib/bpf/libbpf.c
>> > @@ -9322,12 +9322,14 @@ static struct bpf_link *attach_iter(const stru=
ct bpf_sec_def *sec,
>> >
>> >  static struct bpf_link *
>> >  bpf_program__attach_fd(struct bpf_program *prog, int target_fd,
>> > -                      const char *target_name)
>> > +                      int target_btf_id, const char *target_name)
>> >  {
>> >         enum bpf_attach_type attach_type;
>> >         char errmsg[STRERR_BUFSIZE];
>> >         struct bpf_link *link;
>> >         int prog_fd, link_fd;
>> > +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
>> > +                           .target_btf_id =3D target_btf_id);
>> >
>> >         prog_fd =3D bpf_program__fd(prog);
>> >         if (prog_fd < 0) {
>> > @@ -9340,8 +9342,12 @@ bpf_program__attach_fd(struct bpf_program *prog=
, int target_fd,
>> >                 return ERR_PTR(-ENOMEM);
>> >         link->detach =3D &bpf_link__detach_fd;
>> >
>> > -       attach_type =3D bpf_program__get_expected_attach_type(prog);
>> > -       link_fd =3D bpf_link_create(prog_fd, target_fd, attach_type, N=
ULL);
>> > +       if (bpf_program__get_type(prog) =3D=3D BPF_PROG_TYPE_EXT)
>> > +               attach_type =3D BPF_TRACE_FREPLACE;
>>
>> doing this unconditionally will break an old-style freplace without
>> target_fd/btf_id on older kernels. Safe and simple way would be to
>> continue using raw_tracepoint_open when there is no target_fd/btf_id,
>> and use LINK_CREATE for newer stuff. Alternatively, you'd need to do
>> feature detection, but it's still would be nice to handle old-style
>> attach through raw_tracepoint_open for bpf_program__attach_freplace.
>>
>> so I suggest leaving bpf_program__attach_fd() as is and to create a
>> custom bpf_program__attach_freplace() implementation.

Sure, I'll take another pass at this. Not sure how useful feature
detection in libbpf is; if the caller passes a target, libbpf can't
really do much if the kernel doesn't support it...

>> > +       else
>> > +               attach_type =3D bpf_program__get_expected_attach_type(=
prog);
>> > +
>> > +       link_fd =3D bpf_link_create(prog_fd, target_fd, attach_type, &=
opts);
>> >         if (link_fd < 0) {
>> >                 link_fd =3D -errno;
>> >                 free(link);
>> > @@ -9357,19 +9363,25 @@ bpf_program__attach_fd(struct bpf_program *pro=
g, int target_fd,
>> >  struct bpf_link *
>> >  bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
>> >  {
>> > -       return bpf_program__attach_fd(prog, cgroup_fd, "cgroup");
>> > +       return bpf_program__attach_fd(prog, cgroup_fd, 0, "cgroup");
>> >  }
>> >
>> >  struct bpf_link *
>> >  bpf_program__attach_netns(struct bpf_program *prog, int netns_fd)
>> >  {
>> > -       return bpf_program__attach_fd(prog, netns_fd, "netns");
>> > +       return bpf_program__attach_fd(prog, netns_fd, 0, "netns");
>> >  }
>> >
>> >  struct bpf_link *bpf_program__attach_xdp(struct bpf_program *prog, in=
t ifindex)
>> >  {
>> >         /* target_fd/target_ifindex use the same field in LINK_CREATE =
*/
>> > -       return bpf_program__attach_fd(prog, ifindex, "xdp");
>> > +       return bpf_program__attach_fd(prog, ifindex, 0, "xdp");
>> > +}
>> > +
>> > +struct bpf_link *bpf_program__attach_freplace(struct bpf_program *pro=
g,
>> > +                                             int target_fd, int targe=
t_btf_id)
>> > +{
>> > +       return bpf_program__attach_fd(prog, target_fd, target_btf_id, =
"freplace");
>> >  }
>> >
>> >  struct bpf_link *
>> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
>> > index a750f67a23f6..ce5add9b9203 100644
>> > --- a/tools/lib/bpf/libbpf.h
>> > +++ b/tools/lib/bpf/libbpf.h
>> > @@ -261,6 +261,9 @@ LIBBPF_API struct bpf_link *
>> >  bpf_program__attach_netns(struct bpf_program *prog, int netns_fd);
>> >  LIBBPF_API struct bpf_link *
>> >  bpf_program__attach_xdp(struct bpf_program *prog, int ifindex);
>> > +LIBBPF_API struct bpf_link *
>> > +bpf_program__attach_freplace(struct bpf_program *prog,
>> > +                            int target_fd, int target_btf_id);
>>
>> maybe a const char * function name instead of target_btf_id would be a
>> nicer API? Users won't have to deal with fetching target prog's BTF,
>> searching it, etc. That's all pretty straightforward for libbpf to do,
>> leaving users with more natural and simpler API.
>>
>
> bpf_program__set_attach_target() uses string name for target
> functions, we should definitely be consistent here

All right, fair enough :)

-Toke

