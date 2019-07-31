Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797997B9F8
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 08:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387630AbfGaGwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 02:52:46 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33700 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387623AbfGaGwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 02:52:45 -0400
Received: by mail-qk1-f194.google.com with SMTP id r6so48474111qkc.0;
        Tue, 30 Jul 2019 23:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AyqD19CU3qCrLhy/A3KHIHiiFH5U7sqBesHojs94Vpo=;
        b=juVgYaHDrWUwsRcd+AnWe7GXC9e+ooMOsyyB1YqSvkjrWUJBjuUZWFusyOxQTsWhjn
         otmNIS9xpRnS+QcB5u3qWVdcBOYNCZLDy2Q/tNWnF858RJTGkXqVQZX6p0ddyhp6o+fP
         ESCNUEUqMf+JYtZwiUE8Fb8xL8HyTTBBp9tuUxi9nycVDrQ6+E7qqIqU20XXtpUV0qp8
         vo19PmIbL/YboujolohXxGNz9sX/EmmTA+jPv0HYvASRcvXwYtr2VbSpjFYWqaM11Dw3
         IsPBI9CiRC4WLZ4U0QzWPqLoS0qeX8o/3iLpZ5mOU47TwkfVKADAZ3ssJzgs5TcP8RWG
         fU0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AyqD19CU3qCrLhy/A3KHIHiiFH5U7sqBesHojs94Vpo=;
        b=gG+dLPf74CtwShWup6IwRyUiCtbuXzWLgA43mPrP1wECJEGbonxhN5Zm/K8h6Bw4Yh
         M1Jcakb9zySPQIL/IZ3Liy12q7p7q6CUOE2UZxqf9dn1WL4ooh4IhW97L8y+oZjlTvnQ
         s3/ZvzUIg5Zpa7T2YU+MHVwf6zeA5R3u+vRZjR8mkLOwaIB6X8rauWB2wNhZ2k+P7TPX
         ZEAlC4R8rsGAP9OOix5Strwj/EvNkc8LLASqYQctUHZvSKVreyJDNIb35AyjiGRCWYm/
         mJDE5JzmJojGOfo2fJgxtN4rtKHTskR52xrPDz/2DN3UAnDYoFvFcSfKLvAkAwOrejo8
         Uk6g==
X-Gm-Message-State: APjAAAX0Rl8oEzVMW6/04qQZbeLCjaN5hI5Uvis//vM7FYHCGPABCIBr
        wEVd3P24hCK23HqGQAN8MkIJ6qE/Hl9Izccg3P51tvcYSts=
X-Google-Smtp-Source: APXvYqwhnSmVpZtt44CWiPzGfBmJ+FZeSTe1+UDu6v+C47C31vgLP6AF6iw/JZaf0RCXlJ7fubcETJB4Agf+o8hrrrY=
X-Received: by 2002:a37:660d:: with SMTP id a13mr52485134qkc.36.1564555964742;
 Tue, 30 Jul 2019 23:52:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190730195408.670063-1-andriin@fb.com> <20190730195408.670063-3-andriin@fb.com>
 <4AB53FC1-5390-4BC7-83B4-7DDBAFD78ABC@fb.com> <CAEf4BzYE9xnyFjmN3+-LgkkOomt383OPNXVhSCO4PncAu20wgw@mail.gmail.com>
 <AA9B5489-425E-4FAE-BE01-F0F65679DF00@fb.com>
In-Reply-To: <AA9B5489-425E-4FAE-BE01-F0F65679DF00@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Jul 2019 23:52:33 -0700
Message-ID: <CAEf4Bza3cAoZJE+24_MBiv-8yYtAaTkAez5xq1v12cLW1-RGcw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 02/12] libbpf: implement BPF CO-RE offset
 relocation algorithm
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 10:19 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 30, 2019, at 6:00 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Jul 30, 2019 at 5:39 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Jul 30, 2019, at 12:53 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >>>
> >>> This patch implements the core logic for BPF CO-RE offsets relocations.
> >>> Every instruction that needs to be relocated has corresponding
> >>> bpf_offset_reloc as part of BTF.ext. Relocations are performed by trying
> >>> to match recorded "local" relocation spec against potentially many
> >>> compatible "target" types, creating corresponding spec. Details of the
> >>> algorithm are noted in corresponding comments in the code.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>> ---
> >>> tools/lib/bpf/libbpf.c | 915 ++++++++++++++++++++++++++++++++++++++++-
> >>> tools/lib/bpf/libbpf.h |   1 +
> >>> 2 files changed, 909 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >
> > [...]
> >
> > Please trim irrelevant parts. It doesn't matter with desktop Gmail,
> > but pretty much everywhere else is very hard to work with.
>
> This won't be a problem if the patch is shorter. ;)
>
> >
> >>> +
> >>> +     for (i = 1; i < spec->raw_len; i++) {
> >>> +             t = skip_mods_and_typedefs(btf, id, &id);
> >>> +             if (!t)
> >>> +                     return -EINVAL;
> >>> +
> >>> +             access_idx = spec->raw_spec[i];
> >>> +
> >>> +             if (btf_is_composite(t)) {
> >>> +                     const struct btf_member *m = (void *)(t + 1);
> >>
> >> Why (void *) instead of (const struct btf_member *)? There are a few more
> >> in the rest of the patch.
> >>
> >
> > I just picked the most succinct and non-repetitive form. It's
> > immediately apparent which type it's implicitly converted to, so I
> > felt there is no need to repeat it. Also, just (void *) is much
> > shorter. :)
>
> _All_ other code in btf.c converts the pointer to the target type.

Most in libbpf.c doesn't, though. Also, I try to preserve pointer
constness for uses that don't modify BTF types (pretty much all of
them in libbpf), so it becomes really verbose, despite extremely short
variable names:

const struct btf_member *m = (const struct btf_member *)(t + 1);

Add one or two levels of nestedness and you are wrapping this line.

> In some cases, it is not apparent which type it is converted to,
> for example:
>
> +       m = (void *)(targ_type + 1);
>
> I would suggest we do implicit conversion whenever possible.

Implicit conversion (`m = targ_type + 1;`) is a compilation error,
that won't work.

>
> Thanks,
> Song
