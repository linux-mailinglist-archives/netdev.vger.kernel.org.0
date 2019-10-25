Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3EBBE5249
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 19:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505866AbfJYR2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 13:28:48 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44242 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388862AbfJYR2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 13:28:48 -0400
Received: by mail-qt1-f195.google.com with SMTP id z22so4347906qtq.11;
        Fri, 25 Oct 2019 10:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p7h6fsMVzWmEPbOxKVS4V3YoKJBe4ip66W1L8W/KVsQ=;
        b=Ak7eVEnVOrwg9oLJM6tbIVtJINTLyJ5kbPHL3Q3SFIFXLs2lkI0Hk7teya9Mf851oc
         POecwTRu8ExLo9cLJJ6qxmYzb0Tf5q0d+V26r/Ww+bJQlLwCjRSKRNEkccgLrq+7GcFH
         57bbMsk2IUT6dyFedtaok7dpq86tgNJnlJlMp1/8NvwCWvM8C3xfUcZu0bI2MImDGCYb
         3wO8ubcsxI4y0IWqSbe9yw0zGiRp7PR+ALlcnSdr7Qjp36Fv6IWIosS6MEwU2nWP3pTu
         SgwlN5zt6bycWu6bQdrLtCKcbE/tuplw1JERJsun6CZssPBnsHTw80F2Ajoio8MOHdx+
         gL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p7h6fsMVzWmEPbOxKVS4V3YoKJBe4ip66W1L8W/KVsQ=;
        b=iOgfamCC/t0vOCu7vD5bfenxh0em6VuZ1njgycHWF1rOLQwwQF1f+LZz3e31khgnrY
         a8SSH8leLC6dFd+C6cMdglPbLgI32+KZH9JkzhAan2EPFtIVYmYYvi71TexWhH+CDE6D
         rh0suowLPsH0JV7jWH/Ey47tYpedGHAkxQVIkue9HvxMsBgdcWkyzqoIA9ok7Ym0SkHi
         OosOapu9xskPoF5dvL8E1KlJMt//UlDKUGEu/wPhiLGDqa0m76M7CgYWU734VHKbe75M
         XX8kll5j9N1loVnghsVgmDNgDfXEbJmEzHZQNhQeLO9z2PGMrwUhvQ2MeoS48YjJJdWp
         SWfQ==
X-Gm-Message-State: APjAAAU58ENNFlusc/myeCjRze/puH10snlHzJVAhLSb+qcppXh6d8/7
        jeft37NGpN3xx18MyMQqJZ/ROVCvsiITxgWDDEI=
X-Google-Smtp-Source: APXvYqy3/Ljb8PhO+YvgHRZpqKxpysU3KjMZ1jzYlnhthXMyco7czuWJE9uZ2QKBCOSB+45LkVbf6gFfpHs1E2bCwGA=
X-Received: by 2002:ac8:108e:: with SMTP id a14mr4155376qtj.171.1572024526609;
 Fri, 25 Oct 2019 10:28:46 -0700 (PDT)
MIME-Version: 1.0
References: <157192269744.234778.11792009511322809519.stgit@toke.dk>
 <157192270077.234778.5965993521171571751.stgit@toke.dk> <20191025143203.7e8fd0b4@carbon>
In-Reply-To: <20191025143203.7e8fd0b4@carbon>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Oct 2019 10:28:35 -0700
Message-ID: <CAEf4BzYeRSSr0Vqjjter6RF_QKvex8P6ctbToOud7vW+p1c28A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/4] libbpf: Support configurable pinning of
 maps from BTF annotations
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 5:32 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Thu, 24 Oct 2019 15:11:40 +0200
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>
> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >
> > This adds support to libbpf for setting map pinning information as part=
 of
> > the BTF map declaration. We introduce a version new
> > bpf_object__map_pin_opts() function to pin maps based on this setting, =
as
> > well as a getter and setter function for the pin information that calle=
rs
> > can use after map load.
> >
> > The pinning type currently only supports a single PIN_BY_NAME mode, whe=
re
> > each map will be pinned by its name in a path that can be overridden, b=
ut
> > defaults to /sys/fs/bpf.
> >
> > The pinning options supports a 'pin_all' setting, which corresponds to =
the
> > old bpf_object__map_pin() function with an explicit path. In addition, =
the
> > function now defaults to just skipping over maps that are already
> > pinned (since the previous commit started recording this in struct
> > bpf_map). This behaviour can be turned off with the 'no_skip_pinned' op=
tion.
> >
> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > ---
> >  tools/lib/bpf/bpf_helpers.h |    6 ++
> >  tools/lib/bpf/libbpf.c      |  134 ++++++++++++++++++++++++++++++++++-=
--------
> >  tools/lib/bpf/libbpf.h      |   26 ++++++++
> >  tools/lib/bpf/libbpf.map    |    3 +
> >  4 files changed, 142 insertions(+), 27 deletions(-)
> >
> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > index 2203595f38c3..0c7d28292898 100644
> > --- a/tools/lib/bpf/bpf_helpers.h
> > +++ b/tools/lib/bpf/bpf_helpers.h
> > @@ -38,4 +38,10 @@ struct bpf_map_def {
> >       unsigned int map_flags;
> >  };
> >
> > +enum libbpf_pin_type {
> > +     LIBBPF_PIN_NONE,
> > +     /* PIN_BY_NAME: pin maps by name (in /sys/fs/bpf by default) */
> > +     LIBBPF_PIN_BY_NAME,
> > +};
> > +
> >  #endif
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 848e6710b8e6..179c9911458d 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -226,6 +226,7 @@ struct bpf_map {
> >       void *priv;
> >       bpf_map_clear_priv_t clear_priv;
> >       enum libbpf_map_type libbpf_type;
> > +     enum libbpf_pin_type pinning;
> >       char *pin_path;
> >       bool pinned;
> >  };
> > @@ -1271,6 +1272,22 @@ static int bpf_object__init_user_btf_map(struct =
bpf_object *obj,
> >                       }
> >                       map->def.value_size =3D sz;
> >                       map->btf_value_type_id =3D t->type;
> > +             } else if (strcmp(name, "pinning") =3D=3D 0) {
> > +                     __u32 val;
> > +
> > +                     if (!get_map_field_int(map_name, obj->btf, def, m=
,
> > +                                            &val))
> > +                             return -EINVAL;
> > +                     pr_debug("map '%s': found pinning =3D %u.\n",
> > +                              map_name, val);
> > +
> > +                     if (val !=3D LIBBPF_PIN_NONE &&
> > +                         val !=3D LIBBPF_PIN_BY_NAME) {
> > +                             pr_warning("map '%s': invalid pinning val=
ue %u.\n",
> > +                                        map_name, val);
> > +                             return -EINVAL;
> > +                     }
> > +                     map->pinning =3D val;
> >               } else {
> >                       if (strict) {
> >                               pr_warning("map '%s': unknown field '%s'.=
\n",
> [...]
>
> How does this prepare for being compatible with iproute2 pinning?
>
> iproute2 have these defines (in include/bpf_elf.h):
>
>  /* Object pinning settings */
>  #define PIN_NONE                0
>  #define PIN_OBJECT_NS           1
>  #define PIN_GLOBAL_NS           2
>
> I do know above strcmp(name, "pinning") look at BTF info 'name' and not
> directly at the ELF struct for maps.  I don't know enough about BTF
> (yet), but won't BTF automatically create a "pinning" info 'name' ???
> (with above defines as content/values)

We are not supporting iproute2's BTF map definitions as is, we are
trying to support all the functionality needed to support iproute2's
ways of doing things, but it will require iproute2 to do some gluing,
of course. We don't intend to support any conceivable legacy format
out there in libbpf, rather make libbpf powerful, flexible, and
expressive enough to support those use case, but with the help of
tools like iprout2 to do "translations" necessary.

For "modern" iprout2 BPF programs that are using BTF-defined maps and
stuff - yes, that will work as is without iproute2 having to do much.

>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
> From above enum:
>  LIBBPF_PIN_BY_NAME =3D 1
>
> iproute2 ELF map struct:
>
> /* ELF map definition */
> struct bpf_elf_map {
>         __u32 type;
>         __u32 size_key;
>         __u32 size_value;
>         __u32 max_elem;
>         __u32 flags;
>         __u32 id;
>         __u32 pinning;
>         __u32 inner_id;
>         __u32 inner_idx;
> };
>
