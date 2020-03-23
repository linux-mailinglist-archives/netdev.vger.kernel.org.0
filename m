Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0754818FDAA
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 20:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgCWTbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 15:31:10 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:59515 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727817AbgCWTbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 15:31:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584991868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8J/sefHASA9V+sP+1bG/vBh/qalImtWf9jNGx5zbS14=;
        b=iBYdmljyFKsJwdFZLNTKci+CP0vVI+zenr9JrhfL2xXy+6HxAb2UJoAsQ1Zz/m/e4E29hF
        WNhDuO5pteqwLGB7yZ69Jyb+FgqeveqqTx/nAAyFyvgGSCexZYGWNY/M64qH2dn0FJV4LL
        7PsTOp/hwuiEg5hO30DgSTgRxzS8lw8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-RnuTqm7nNmWFodEWiUCeDQ-1; Mon, 23 Mar 2020 15:31:06 -0400
X-MC-Unique: RnuTqm7nNmWFodEWiUCeDQ-1
Received: by mail-wr1-f72.google.com with SMTP id d17so7802596wrs.7
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 12:31:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=8J/sefHASA9V+sP+1bG/vBh/qalImtWf9jNGx5zbS14=;
        b=Ua/uZQiqoR2rEhdkslSd1xZUB359mNf2ImRYrEA2WerJgEidNUnBHguzpfP/+Oqf5B
         SmDJe6dI/R0FpplONclvxHd8ASylETlrbEZqP4icjuExKs61gBOWKE3mfYa8Gi9ffi7J
         CHBY0mwTi3eDASThg0qjIgGpXtvtT6++y6Pyyf7o8rLzYqWbG4v+NBLXyqstaPPa6Pc4
         ngQf0Yy+1tmrZ/X/Rx7BPLwMuGG3+Lzatco0uvkJlQ5Ts/mSUVpdLoIQijW6gKzQIq08
         eojtTqjv/i2Y/0+Ri0QVWQ/po3G3hVxyBDDC0ResxTTN3HHJgFHVNsc44PAUCBRWbgPI
         POVA==
X-Gm-Message-State: ANhLgQ3fjcr8pW1cm9jKPsoeOf9Sh9RQOQrmDTEDCZyDTNeoBqZsD6zM
        1DHcD1RMuoeBWYqeUq8p0hn0l9S0gqJ61z2Sd9tYq0I9O5U2pVkaHM2edN2wekUrNET8cVCTdov
        H/7VLrdXa6+k0+BoW
X-Received: by 2002:adf:c651:: with SMTP id u17mr33246346wrg.40.1584991865000;
        Mon, 23 Mar 2020 12:31:05 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuyrD4NlEQ+o0cDOgVZ+vEUtEwXni4mQU+vwbmBqhMyHCMQLko1SLA/YBkZI3xV2aCLy32dtw==
X-Received: by 2002:adf:c651:: with SMTP id u17mr33246313wrg.40.1584991864738;
        Mon, 23 Mar 2020 12:31:04 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id s15sm24463602wrt.16.2020.03.23.12.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 12:31:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B2F3C180371; Mon, 23 Mar 2020 20:31:03 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 5/6] libbpf: add support for bpf_link-based cgroup attachment
In-Reply-To: <CAEf4Bzbt7-A+2dH0kSAM11mjwX+ZDV8JBhJZDArAU=Q9+y79mw@mail.gmail.com>
References: <20200320203615.1519013-1-andriin@fb.com> <20200320203615.1519013-6-andriin@fb.com> <87wo7b49mn.fsf@toke.dk> <CAEf4Bzbt7-A+2dH0kSAM11mjwX+ZDV8JBhJZDArAU=Q9+y79mw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 23 Mar 2020 20:31:03 +0100
Message-ID: <87blom3m2w.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, Mar 23, 2020 at 4:02 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andriin@fb.com> writes:
>>
>> > Add bpf_program__attach_cgroup(), which uses BPF_LINK_CREATE subcomman=
d to
>> > create an FD-based kernel bpf_link. Also add low-level bpf_link_create=
() API.
>> >
>> > If expected_attach_type is not specified explicitly with
>> > bpf_program__set_expected_attach_type(), libbpf will try to determine =
proper
>> > attach type from BPF program's section definition.
>> >
>> > Also add support for bpf_link's underlying BPF program replacement:
>> >   - unconditional through high-level bpf_link__update_program() API;
>> >   - cmpxchg-like with specifying expected current BPF program through
>> >     low-level bpf_link_update() API.
>> >
>> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>> > ---
>> >  tools/include/uapi/linux/bpf.h | 12 +++++++++
>> >  tools/lib/bpf/bpf.c            | 34 +++++++++++++++++++++++++
>> >  tools/lib/bpf/bpf.h            | 19 ++++++++++++++
>> >  tools/lib/bpf/libbpf.c         | 46 ++++++++++++++++++++++++++++++++++
>> >  tools/lib/bpf/libbpf.h         |  8 +++++-
>> >  tools/lib/bpf/libbpf.map       |  4 +++
>> >  6 files changed, 122 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux=
/bpf.h
>> > index fad9f79bb8f1..fa944093f9fc 100644
>> > --- a/tools/include/uapi/linux/bpf.h
>> > +++ b/tools/include/uapi/linux/bpf.h
>> > @@ -112,6 +112,7 @@ enum bpf_cmd {
>> >       BPF_MAP_UPDATE_BATCH,
>> >       BPF_MAP_DELETE_BATCH,
>> >       BPF_LINK_CREATE,
>> > +     BPF_LINK_UPDATE,
>> >  };
>> >
>> >  enum bpf_map_type {
>> > @@ -574,6 +575,17 @@ union bpf_attr {
>> >               __u32           target_fd;      /* object to attach to */
>> >               __u32           attach_type;    /* attach type */
>> >       } link_create;
>> > +
>> > +     struct { /* struct used by BPF_LINK_UPDATE command */
>> > +             __u32           link_fd;        /* link fd */
>> > +             /* new program fd to update link with */
>> > +             __u32           new_prog_fd;
>> > +             __u32           flags;          /* extra flags */
>> > +             /* expected link's program fd; is specified only if
>> > +              * BPF_F_REPLACE flag is set in flags */
>> > +             __u32           old_prog_fd;
>> > +     } link_update;
>> > +
>> >  } __attribute__((aligned(8)));
>> >
>> >  /* The description below is an attempt at providing documentation to =
eBPF
>> > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
>> > index c6dafe563176..35c34fc81bd0 100644
>> > --- a/tools/lib/bpf/bpf.c
>> > +++ b/tools/lib/bpf/bpf.c
>> > @@ -584,6 +584,40 @@ int bpf_prog_detach2(int prog_fd, int target_fd, =
enum bpf_attach_type type)
>> >       return sys_bpf(BPF_PROG_DETACH, &attr, sizeof(attr));
>> >  }
>> >
>> > +int bpf_link_create(int prog_fd, int target_fd,
>> > +                 enum bpf_attach_type attach_type,
>> > +                 const struct bpf_link_create_opts *opts)
>> > +{
>> > +     union bpf_attr attr;
>> > +
>> > +     if (!OPTS_VALID(opts, bpf_link_create_opts))
>> > +             return -EINVAL;
>> > +
>> > +     memset(&attr, 0, sizeof(attr));
>> > +     attr.link_create.prog_fd =3D prog_fd;
>> > +     attr.link_create.target_fd =3D target_fd;
>> > +     attr.link_create.attach_type =3D attach_type;
>> > +
>> > +     return sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
>> > +}
>> > +
>> > +int bpf_link_update(int link_fd, int new_prog_fd,
>> > +                 const struct bpf_link_update_opts *opts)
>> > +{
>> > +     union bpf_attr attr;
>> > +
>> > +     if (!OPTS_VALID(opts, bpf_link_update_opts))
>> > +             return -EINVAL;
>> > +
>> > +     memset(&attr, 0, sizeof(attr));
>> > +     attr.link_update.link_fd =3D link_fd;
>> > +     attr.link_update.new_prog_fd =3D new_prog_fd;
>> > +     attr.link_update.flags =3D OPTS_GET(opts, flags, 0);
>> > +     attr.link_update.old_prog_fd =3D OPTS_GET(opts, old_prog_fd, 0);
>> > +
>> > +     return sys_bpf(BPF_LINK_UPDATE, &attr, sizeof(attr));
>> > +}
>> > +
>> >  int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 qu=
ery_flags,
>> >                  __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt)
>> >  {
>> > diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
>> > index b976e77316cc..46d47afdd887 100644
>> > --- a/tools/lib/bpf/bpf.h
>> > +++ b/tools/lib/bpf/bpf.h
>> > @@ -168,6 +168,25 @@ LIBBPF_API int bpf_prog_detach(int attachable_fd,=
 enum bpf_attach_type type);
>> >  LIBBPF_API int bpf_prog_detach2(int prog_fd, int attachable_fd,
>> >                               enum bpf_attach_type type);
>> >
>> > +struct bpf_link_create_opts {
>> > +     size_t sz; /* size of this struct for forward/backward compatibi=
lity */
>> > +};
>> > +#define bpf_link_create_opts__last_field sz
>> > +
>> > +LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
>> > +                            enum bpf_attach_type attach_type,
>> > +                            const struct bpf_link_create_opts *opts);
>> > +
>> > +struct bpf_link_update_opts {
>> > +     size_t sz; /* size of this struct for forward/backward compatibi=
lity */
>> > +     __u32 flags;       /* extra flags */
>> > +     __u32 old_prog_fd; /* expected old program FD */
>> > +};
>> > +#define bpf_link_update_opts__last_field old_prog_fd
>> > +
>> > +LIBBPF_API int bpf_link_update(int link_fd, int new_prog_fd,
>> > +                            const struct bpf_link_update_opts *opts);
>> > +
>> >  struct bpf_prog_test_run_attr {
>> >       int prog_fd;
>> >       int repeat;
>> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> > index 085e41f9b68e..8b23c70033d3 100644
>> > --- a/tools/lib/bpf/libbpf.c
>> > +++ b/tools/lib/bpf/libbpf.c
>> > @@ -6951,6 +6951,12 @@ struct bpf_link {
>> >       bool disconnected;
>> >  };
>> >
>> > +/* Replace link's underlying BPF program with the new one */
>> > +int bpf_link__update_program(struct bpf_link *link, struct bpf_progra=
m *prog)
>> > +{
>> > +     return bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog)=
, NULL);
>> > +}
>>
>> I would expect bpf_link to keep track of the previous program and
>> automatically fill it in with this operation. I.e., it should be
>> possible to do something like:
>>
>> link =3D bpf_link__open("/sys/fs/bpf/my_link");
>> prog =3D bpf_link__get_prog(link);
>
> I don't think libbpf is able to construct struct bpf_program from link
> info. It can get program FD, of course, but struct bpf_program is much
> more than that and not sure kernel has all the necessary info. Some
> parts of bpf_program is coming from ELF file, which is gone by this
> time.

Hmm, sure, maybe, but it could still get enough information (such as the
prog fd, and everything returned by GET_PROG_INFO) for userspace could
do something meaningful with the result. So that would turn the above
into bpf_link__get_prog_fd(), and struct bpf_link would contain the fd
of the currently-attached program so it can be supplied in any future
replacement calls.

-Toke

