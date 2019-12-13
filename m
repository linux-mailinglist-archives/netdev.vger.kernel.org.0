Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A9011DDF2
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 06:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfLMFvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 00:51:45 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46552 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfLMFvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 00:51:45 -0500
Received: by mail-qt1-f194.google.com with SMTP id 38so1315049qtb.13;
        Thu, 12 Dec 2019 21:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MRNn09Kk8vGyY6TgLXPdgcxeg2cs7PodyWiOgJd6De4=;
        b=oJDi6s5bDKW/KG8olDHD7Tn/VRhJvxyeD6WOvMnILr4AK0VyiULc2mT9meLEjbcdK9
         Anc/Y3oZonkh0ftD4rtdd/qmnPldmdgHYm9Eh+HCvQB7BMVUquBQT7psdJaNV3QuRYZt
         STB38Ok7ktWWbrkXR+rKaYawpio+BRy37ChoK/orqz4YZcSFa+tRCZ0ttX6S0kchZuK1
         RTAJ3PB/yjm8k2lCBJ89GWK0oj9tHEH3frHSiEkPe57UwwmqkNO9tOlpMyczIWyy4jvh
         7+bi6pGaWcFDCDIWae2/95OJdDzNplVXvE3c9huXoaIG6RNpUXwRvHjV5uy9rdP1uXge
         k6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MRNn09Kk8vGyY6TgLXPdgcxeg2cs7PodyWiOgJd6De4=;
        b=nlJxqfAi332/UzlhPPmqsMQ/LZ06RndSyDRBzPFBO4RT8y1Wmal3564whao/rs0C2o
         UcsuOQqcjhkBCtTGf2nAz+SoKTktW1Lh2sp7PTA5t368MyeOldMtudDidn4fLzV2Yq/L
         EIFz+oifw6GECE006T6ylC+kVF6h2h+0BGC96dKaDOIzITuaUumg77OCpOLPAqbLWCdo
         ydERf2X60zNARRoQio3eWiG714ydmt7yqf7KlZ+6avQL1/ohjIITdrQzrNqqJWTG0gNI
         1ZZkJsLPTjfa6avVJOPjihJNOP9gsCLFZyK+XoMh7zM6Zyy/SF4CEncFWCcEDx5yncM2
         bUtg==
X-Gm-Message-State: APjAAAWSMe2FwrL7QxCoRnT68OtF/YtxywnPL88nkgemNUxj0W3QOkUx
        WlLz+tsxVwB2JVnXe/0fDZ/1tYfHz8yl0B8tdAk=
X-Google-Smtp-Source: APXvYqwdM8rNTcK8cCcNHqyOeXvl4Cg55URb17jlrH/jbFR9qNZlbU3UQD1WeWuZuyvyMI/PfvoDkbMXZ5EAitAkRqY=
X-Received: by 2002:ac8:5457:: with SMTP id d23mr10406981qtq.93.1576216303593;
 Thu, 12 Dec 2019 21:51:43 -0800 (PST)
MIME-Version: 1.0
References: <20191211065002.2074074-1-andriin@fb.com> <20191211065002.2074074-2-andriin@fb.com>
 <20191213050739.xt4wnofdwf66gcrw@ast-mbp>
In-Reply-To: <20191213050739.xt4wnofdwf66gcrw@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 12 Dec 2019 21:51:32 -0800
Message-ID: <CAEf4BzYpcEWpCvxuv9Jyi2svNN9vezrzystkp8+DSCqywL_YMA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] libbpf: support libbpf-provided extern variables
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 9:11 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Dec 10, 2019 at 10:50:00PM -0800, Andrii Nakryiko wrote:
> > +static int set_ext_value_tri(struct extern_desc *ext, void *ext_val,
> > +                          char value)
> > +{
> > +     switch (ext->type) {
> > +     case EXT_BOOL:
> > +             if (value =3D=3D 'm') {
> > +                     pr_warn("extern %s=3D%c should be tristate or cha=
r\n",
> > +                             ext->name, value);
> > +                     return -EINVAL;
> > +             }
> > +             *(bool *)ext_val =3D value =3D=3D 'y' ? true : false;
>
> may be check for strict y/n ?

Can't be anything else due to `case 'y': case 'n': case 'm':` check in
the caller.


>
> > +             break;
> > +     case EXT_TRISTATE:
> > +             if (value =3D=3D 'y')
> > +                     *(enum libbpf_tristate *)ext_val =3D TRI_YES;
> > +             else if (value =3D=3D 'm')
> > +                     *(enum libbpf_tristate *)ext_val =3D TRI_MODULE;
> > +             else /* value =3D=3D 'n' */
> > +                     *(enum libbpf_tristate *)ext_val =3D TRI_NO;
>
> same here ?
>
> > +             break;
> > +     case EXT_CHAR:
> > +             *(char *)ext_val =3D value;
> > +             break;
> > +     case EXT_UNKNOWN:
> > +     case EXT_INT:
> > +     case EXT_CHAR_ARR:
>
> why enumerate them when there is a default ?

Because compiler is too smart and strict. Otherwise getting:

libbpf.c: In function =E2=80=98set_ext_value_tri=E2=80=99:
libbpf.c:982:2: error: enumeration value =E2=80=98EXT_UNKNOWN=E2=80=99 not =
handled in
switch [-Werror=3Dswitch-enum]
  switch (ext->type) {
  ^~~~~~
libbpf.c:982:2: error: enumeration value =E2=80=98EXT_INT=E2=80=99 not hand=
led in
switch [-Werror=3Dswitch-enum]
libbpf.c:982:2: error: enumeration value =E2=80=98EXT_CHAR_ARR=E2=80=99 not=
 handled in
switch [-Werror=3Dswitch-enum]

>
> > +static int set_ext_value_str(struct extern_desc *ext, void *ext_val,
> > +                          const char *value)
> > +{
> > +     size_t len;
> > +
> > +     if (ext->type !=3D EXT_CHAR_ARR) {
> > +             pr_warn("extern %s=3D%s should char array\n", ext->name, =
value);
> > +             return -EINVAL;
> > +     }
> > +
> > +     len =3D strlen(value);
> > +     if (value[len - 1] !=3D '"') {
> > +             pr_warn("extern '%s': invalid string config '%s'\n",
> > +                     ext->name, value);
> > +             return -EINVAL;
> > +     }
> > +
> > +     /* strip quotes */
> > +     len -=3D 2;
> > +     if (len + 1 > ext->sz) {
> > +             pr_warn("extern '%s': too long string config %s (%zu byte=
s), up to %d expected\n",
> > +                     ext->name, value, len + 1, ext->sz);
> > +             return -EINVAL;
>
> may be print warning and truncate instead of hard error?

Could do. I erred on the side of being strict. I don't mind relaxing
this, though.

>
> > +static bool is_ext_value_in_range(const struct extern_desc *ext, __u64=
 v)
> > +{
> > +     int bit_sz =3D ext->sz * 8;
> > +
> > +     if (ext->sz =3D=3D 8)
> > +             return true;
> > +
> > +     if (ext->is_signed)
> > +             return v + (1ULL << (bit_sz - 1)) < (1ULL << bit_sz);
> > +     else
> > +             return (v >> bit_sz) =3D=3D 0;
>
> a comment would be helpful.

will add

>
> > +             ext_val =3D data + ext->data_off;
> > +             value =3D sep + 1;
> > +
> > +             switch (*value) {
> > +             case 'y': case 'n': case 'm':
>
> I don't think config.gz has 'n', but it's good to have it here.
>
> > -                     } else if (strcmp(name, ".data") =3D=3D 0) {
> > +                     } else if (strcmp(name, DATA_SEC) =3D=3D 0) {
> >                               obj->efile.data =3D data;
> >                               obj->efile.data_shndx =3D idx;
> > -                     } else if (strcmp(name, ".rodata") =3D=3D 0) {
> > +                     } else if (strcmp(name, RODATA_SEC) =3D=3D 0) {
>
> such cleanup changes should be in separate patch.

Ok, will split out. Needed that for .extern, decided to complete for
others in the same go.

>
> > +             if (strcmp(ext->name, "LINUX_KERNEL_VERSION") =3D=3D 0) {
> > +                     void *ext_val =3D data + ext->data_off;
> > +                     __u32 kver =3D get_kernel_version();
> > +
> > +                     if (!kver) {
> > +                             pr_warn("failed to get kernel version\n")=
;
> > +                             return -EINVAL;
> > +                     }
> > +                     err =3D set_ext_value_num(ext, ext_val, kver);
>
> I think it should work when kern_ver is not 'int'.
> Could you add a test for u64 ?
> Or it will fail on big endian?
>

Yeah, it is handled inside set_ext_value_num just the same as any
CONFIG_xxx integers. I will make sure that test_core_extern and
test_skeleton use both u32 and u64.
