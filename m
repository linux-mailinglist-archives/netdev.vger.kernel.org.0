Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADB0013B9D3
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 07:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgAOGj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 01:39:58 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43981 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgAOGj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 01:39:58 -0500
Received: by mail-qt1-f194.google.com with SMTP id d18so14861660qtj.10;
        Tue, 14 Jan 2020 22:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OkABScBdRODOxQvYQ7uBZR9KdTUTCfP+0qd3dGJcuQ0=;
        b=ZDdmJOzVrfW9XmyJVJXMWlWTeMnx3FSlN+3/H5hQoXWywFuTfJ6QheXlP95lDlCK2q
         0ZxdvUU+q340XF10bx9qL3I2Uu+WOUaeLQc8kyabqZR/MNvKYmTX3Cgbq+Li+x3nlnAY
         FD+8k2b30A0NCfT3/8+hn+fdoeX9b1BAwH0yLsC+fBweWdcTiuBZfZOU6ZX/ZiG5vIIG
         Z/GTwUkEEJq+t7j049sJxPBZiUjbVx1Bi3bpR8QbV8ADkNrQzwcvljAnGIaMDAEgxUpf
         M+ZIFWK2g+Qa9foiCrmcheCRGa8AVR1ZCp40VFKUBgsCOrcUwcqRxtJ/OJFdjJU8pD2K
         8t8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OkABScBdRODOxQvYQ7uBZR9KdTUTCfP+0qd3dGJcuQ0=;
        b=HPQsJEuVrdk84eYSaHFTlqXQmLkjKM6BUodC5qAAWcKk3tk8qYCepia5jbPFN2Ja9u
         qg6gqHyuxtHYM50TrKSOqGm0re7wmcIJmMsu9roVi2f13FVfulhumKztCBhxpIHHECuc
         J3kj5ypL+T2VdlhLrl8SgT6jg8Z3dp0Ye2Rk3gpY0Br7sfF30+gpS/cNPES6U2jhSyuY
         K/rsNZsWs6hBdDxgafHLWwn+zT54b5FCRxd+ekHVFrD9IPznZtp7euJd7VzQ0GbS937L
         A7JPQ8aFRHkA20BU070Md1U9+fdYpL15nECHNNCWVQVtASvlvcDpHdiJ+u+cvwVwRFCH
         UdAA==
X-Gm-Message-State: APjAAAXONhNqc8Jv4UbMx83LIYyqyH/iLDGZ0rM5lrDWuprAMruYb5jt
        en+zYzdsVb9Qvqm7jsscA5tGTQHcK7pZ1yKn3LMCRA==
X-Google-Smtp-Source: APXvYqwkQNFhnDHj+aNqRxoFHKL4OM3PqX76Va2rbh+1vzIrSaB5WNyLfagtI9zxPxUxNZ1st+sz6+m9lU/pdZW4VyA=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr2122360qtl.171.1579070396752;
 Tue, 14 Jan 2020 22:39:56 -0800 (PST)
MIME-Version: 1.0
References: <20200114224358.3027079-1-kafai@fb.com> <20200114224426.3028966-1-kafai@fb.com>
 <CAEf4BzYgvq+s09d7eKhf_dd-Goh-V3DRHWmMM+=k0=Ce=zQ2ug@mail.gmail.com> <20200115060406.ze7kwkljkytmodq7@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200115060406.ze7kwkljkytmodq7@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jan 2020 22:39:45 -0800
Message-ID: <CAEf4BzaBw93YEU7CktQp8FkphsBYRGRHpsF-D-BjWHG1UXoakA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] bpftool: Support dumping a map with btf_vmlinux_value_type_id
To:     Martin Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 10:04 PM Martin Lau <kafai@fb.com> wrote:
>
> On Tue, Jan 14, 2020 at 05:49:00PM -0800, Andrii Nakryiko wrote:
> > On Tue, Jan 14, 2020 at 2:46 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > This patch makes bpftool support dumping a map's value properly
> > > when the map's value type is a type of the running kernel's btf.
> > > (i.e. map_info.btf_vmlinux_value_type_id is set instead of
> > > map_info.btf_value_type_id).  The first usecase is for the
> > > BPF_MAP_TYPE_STRUCT_OPS.
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >  tools/bpf/bpftool/map.c | 43 +++++++++++++++++++++++++++++++----------
> > >  1 file changed, 33 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> > > index 4c5b15d736b6..d25f3b2355ad 100644
> > > --- a/tools/bpf/bpftool/map.c
> > > +++ b/tools/bpf/bpftool/map.c
> > > @@ -20,6 +20,7 @@
> > >  #include "btf.h"
> > >  #include "json_writer.h"
> > >  #include "main.h"
> > > +#include "libbpf_internal.h"
> > >
> > >  const char * const map_type_name[] = {
> > >         [BPF_MAP_TYPE_UNSPEC]                   = "unspec",
> > > @@ -252,6 +253,7 @@ static int do_dump_btf(const struct btf_dumper *d,
> > >                        struct bpf_map_info *map_info, void *key,
> > >                        void *value)
> > >  {
> > > +       __u32 value_id;
> > >         int ret;
> > >
> > >         /* start of key-value pair */
> > > @@ -265,9 +267,12 @@ static int do_dump_btf(const struct btf_dumper *d,
> > >                         goto err_end_obj;
> > >         }
> > >
> > > +       value_id = map_info->btf_vmlinux_value_type_id ?
> > > +               : map_info->btf_value_type_id;
> > > +
> > >         if (!map_is_per_cpu(map_info->type)) {
> > >                 jsonw_name(d->jw, "value");
> > > -               ret = btf_dumper_type(d, map_info->btf_value_type_id, value);
> > > +               ret = btf_dumper_type(d, value_id, value);
> > >         } else {
> > >                 unsigned int i, n, step;
> > >
> > > @@ -279,8 +284,7 @@ static int do_dump_btf(const struct btf_dumper *d,
> > >                         jsonw_start_object(d->jw);
> > >                         jsonw_int_field(d->jw, "cpu", i);
> > >                         jsonw_name(d->jw, "value");
> > > -                       ret = btf_dumper_type(d, map_info->btf_value_type_id,
> > > -                                             value + i * step);
> > > +                       ret = btf_dumper_type(d, value_id, value + i * step);
> > >                         jsonw_end_object(d->jw);
> > >                         if (ret)
> > >                                 break;
> > > @@ -932,6 +936,27 @@ static int maps_have_btf(int *fds, int nb_fds)
> > >         return 1;
> > >  }
> > >
> > > +static struct btf *get_map_kv_btf(const struct bpf_map_info *info)
> > > +{
> > > +       struct btf *btf = NULL;
> > > +
> > > +       if (info->btf_vmlinux_value_type_id) {
> > > +               btf = bpf_find_kernel_btf();
> >
> > If there are multiple maps we are dumping, it might become quite
> > costly to re-read and re-parse kernel BTF all the time. Can we lazily
> > load it, when required,
> It is loaded lazily.
>

yeah, it was meant as "lazy load and cache" vs "pre-load always"
(which makes caching simpler).

> > and cache instead?
> Cache it in bpftool/map.c? Sure.

yeah, for the duration of dumping

>
> >
> > > +               if (IS_ERR(btf))
> > > +                       p_err("failed to get kernel btf");
> > > +       } else if (info->btf_value_type_id) {
> > > +               int err;
> > > +
> > > +               err = btf__get_from_id(info->btf_id, &btf);
> > > +               if (err || !btf) {
> > > +                       p_err("failed to get btf");
> > > +                       btf = err ? ERR_PTR(err) : ERR_PTR(-ESRCH);
> > > +               }
> > > +       }
> > > +
> > > +       return btf;
> > > +}
> > > +
> > >  static int
> > >  map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
> > >          bool show_header)
> > > @@ -952,13 +977,11 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
> > >         prev_key = NULL;
> > >
> > >         if (wtr) {
> > > -               if (info->btf_id) {
> > > -                       err = btf__get_from_id(info->btf_id, &btf);
> > > -                       if (err || !btf) {
> > > -                               err = err ? : -ESRCH;
> > > -                               p_err("failed to get btf");
> > > -                               goto exit_free;
> > > -                       }
> > > +               btf = get_map_kv_btf(info);
> > > +               if (IS_ERR(btf)) {
> > > +                       err = PTR_ERR(btf);
> > > +                       btf = NULL;
> > > +                       goto exit_free;
> > >                 }
> > >
> > >                 if (show_header) {
> > > --
> > > 2.17.1
> > >
