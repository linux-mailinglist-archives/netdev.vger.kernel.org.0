Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122A626CE66
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgIPWMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:12:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53336 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725858AbgIPWMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:12:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600294351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tHX2H89DwEBKv7bBZaUMpxuRXSn3YpdOumxvTYDBBiQ=;
        b=Av+3N5oX4+AU7t98g6H+qMsgjq2wENexKUiWbq8H6kiPU1KWca51tBj9vNiTEcpwlsuv1V
        4w5jGb+hs04E2tjNQ9WsUlWHdlIarTNJBk3Dlew8sQx2CH5gWW+NWPkfksDS+Ay1aa4ELo
        vH4BZoVVAJ8cxJX7ti8c/AmWFqYoFZQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-kwhC4620PZOqlIGD7jui9g-1; Wed, 16 Sep 2020 17:41:31 -0400
X-MC-Unique: kwhC4620PZOqlIGD7jui9g-1
Received: by mail-ed1-f70.google.com with SMTP id c3so63378edm.7
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 14:41:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=tHX2H89DwEBKv7bBZaUMpxuRXSn3YpdOumxvTYDBBiQ=;
        b=XQ5yopbnilwmY0vNualkGCKGF4kQcTzGDvJBmrLzppSxaow1XXNIB6pr5qh63D/+ya
         C97aloDaR/GiBurcWmOXBiCIuzDU6xMWgpdWIMKkcJXmX/R3OS/Azf2jhMejxzENm3mE
         6VjxJ+EKLL9IjH4NHS5pyDEICz9crJlbt5aWnyyCX/UfieaIueICpegYREc6q0kAAX1j
         EL3EZw2uBPqgL0UOc/lADWPCHwHGJ5jCykB2mVapIym+BP+eff9CI+NqapoWk+xG5aPp
         4BKapRRHKbYHMKeKx3E1vvGntXvtvbTt0TfMY4ImudVMu0ZafZ9XMLE9pgQcOKcqC/xC
         4BJw==
X-Gm-Message-State: AOAM530Tszkse/m9ol7OcSTGdH5QO8izJG8/koKel7xeAHEhtLYWTQzd
        LOkLWBKyICnbHQMIBXxQ6z+VHdFhq3QU9My+5Z/KluN9G3b8VVE50XGXhaEvAiyyfEzbQSK88ND
        TYnTal3H8xy/ha60m
X-Received: by 2002:a17:906:8543:: with SMTP id h3mr26956720ejy.258.1600292490084;
        Wed, 16 Sep 2020 14:41:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMn+5a44Cxv4gCrW1kmIoz7X1247OQ589YpTjThQJ0Qtd/x9E2/+C7y7TZBeih8hUoFFr1rA==
X-Received: by 2002:a17:906:8543:: with SMTP id h3mr26956701ejy.258.1600292489839;
        Wed, 16 Sep 2020 14:41:29 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id dc22sm14049647ejb.112.2020.09.16.14.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 14:41:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F3421183A90; Wed, 16 Sep 2020 23:41:27 +0200 (CEST)
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
In-Reply-To: <CAEf4BzZcp+ZCegpQRgo+gEp7y+XekajyfN=DE15X3hNb7XVksQ@mail.gmail.com>
References: <160017005691.98230.13648200635390228683.stgit@toke.dk>
 <160017006352.98230.621859348254499900.stgit@toke.dk>
 <CAEf4BzZx33sqDd2WU2j+Ht_njn2qfcV1C0ginPBde+wj8rROeQ@mail.gmail.com>
 <CAEf4Bzb5pLJaW_Rkiq+5QacH6G-FFmj6eRBiZKybYCkkBVMzLA@mail.gmail.com>
 <87h7rxpge0.fsf@toke.dk>
 <CAEf4BzZcp+ZCegpQRgo+gEp7y+XekajyfN=DE15X3hNb7XVksQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 16 Sep 2020 23:41:27 +0200
Message-ID: <87363hpfg8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Wed, Sep 16, 2020 at 2:21 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Wed, Sep 16, 2020 at 1:37 PM Andrii Nakryiko
>> > <andrii.nakryiko@gmail.com> wrote:
>> >>
>> >> On Tue, Sep 15, 2020 at 5:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
>> >> >
>> >> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >> >
>> >> > This adds support for supplying a target btf ID for the bpf_link_cr=
eate()
>> >> > operation, and adds a new bpf_program__attach_freplace() high-level=
 API for
>> >> > attaching freplace functions with a target.
>> >> >
>> >> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >> > ---
>> >> >  tools/lib/bpf/bpf.c      |    1 +
>> >> >  tools/lib/bpf/bpf.h      |    3 ++-
>> >> >  tools/lib/bpf/libbpf.c   |   24 ++++++++++++++++++------
>> >> >  tools/lib/bpf/libbpf.h   |    3 +++
>> >> >  tools/lib/bpf/libbpf.map |    1 +
>> >> >  5 files changed, 25 insertions(+), 7 deletions(-)
>> >> >
>> >> > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
>> >> > index 82b983ff6569..e928456c0dd6 100644
>> >> > --- a/tools/lib/bpf/bpf.c
>> >> > +++ b/tools/lib/bpf/bpf.c
>> >> > @@ -599,6 +599,7 @@ int bpf_link_create(int prog_fd, int target_fd,
>> >> >         attr.link_create.iter_info =3D
>> >> >                 ptr_to_u64(OPTS_GET(opts, iter_info, (void *)0));
>> >> >         attr.link_create.iter_info_len =3D OPTS_GET(opts, iter_info=
_len, 0);
>> >> > +       attr.link_create.target_btf_id =3D OPTS_GET(opts, target_bt=
f_id, 0);
>> >> >
>> >> >         return sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
>> >> >  }
>> >> > diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
>> >> > index 015d13f25fcc..f8dbf666b62b 100644
>> >> > --- a/tools/lib/bpf/bpf.h
>> >> > +++ b/tools/lib/bpf/bpf.h
>> >> > @@ -174,8 +174,9 @@ struct bpf_link_create_opts {
>> >> >         __u32 flags;
>> >> >         union bpf_iter_link_info *iter_info;
>> >> >         __u32 iter_info_len;
>> >> > +       __u32 target_btf_id;
>> >> >  };
>> >> > -#define bpf_link_create_opts__last_field iter_info_len
>> >> > +#define bpf_link_create_opts__last_field target_btf_id
>> >> >
>> >> >  LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
>> >> >                                enum bpf_attach_type attach_type,
>> >> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> >> > index 550950eb1860..165131c73f40 100644
>> >> > --- a/tools/lib/bpf/libbpf.c
>> >> > +++ b/tools/lib/bpf/libbpf.c
>> >> > @@ -9322,12 +9322,14 @@ static struct bpf_link *attach_iter(const s=
truct bpf_sec_def *sec,
>> >> >
>> >> >  static struct bpf_link *
>> >> >  bpf_program__attach_fd(struct bpf_program *prog, int target_fd,
>> >> > -                      const char *target_name)
>> >> > +                      int target_btf_id, const char *target_name)
>> >> >  {
>> >> >         enum bpf_attach_type attach_type;
>> >> >         char errmsg[STRERR_BUFSIZE];
>> >> >         struct bpf_link *link;
>> >> >         int prog_fd, link_fd;
>> >> > +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
>> >> > +                           .target_btf_id =3D target_btf_id);
>> >> >
>> >> >         prog_fd =3D bpf_program__fd(prog);
>> >> >         if (prog_fd < 0) {
>> >> > @@ -9340,8 +9342,12 @@ bpf_program__attach_fd(struct bpf_program *p=
rog, int target_fd,
>> >> >                 return ERR_PTR(-ENOMEM);
>> >> >         link->detach =3D &bpf_link__detach_fd;
>> >> >
>> >> > -       attach_type =3D bpf_program__get_expected_attach_type(prog);
>> >> > -       link_fd =3D bpf_link_create(prog_fd, target_fd, attach_type=
, NULL);
>> >> > +       if (bpf_program__get_type(prog) =3D=3D BPF_PROG_TYPE_EXT)
>> >> > +               attach_type =3D BPF_TRACE_FREPLACE;
>> >>
>> >> doing this unconditionally will break an old-style freplace without
>> >> target_fd/btf_id on older kernels. Safe and simple way would be to
>> >> continue using raw_tracepoint_open when there is no target_fd/btf_id,
>> >> and use LINK_CREATE for newer stuff. Alternatively, you'd need to do
>> >> feature detection, but it's still would be nice to handle old-style
>> >> attach through raw_tracepoint_open for bpf_program__attach_freplace.
>> >>
>> >> so I suggest leaving bpf_program__attach_fd() as is and to create a
>> >> custom bpf_program__attach_freplace() implementation.
>>
>> Sure, I'll take another pass at this. Not sure how useful feature
>> detection in libbpf is; if the caller passes a target, libbpf can't
>> really do much if the kernel doesn't support it...
>
> I was thinking about bpf_program__attach_freplace(prog, 0, NULL) doing
> bpf_raw_tracepoint_open(). It would be nice to support this, for API
> uniformity, no?

Yeah, sure, that we can do :)

-Toke

