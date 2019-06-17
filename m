Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB3048B32
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfFQSCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:02:09 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35196 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbfFQSCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:02:08 -0400
Received: by mail-qt1-f194.google.com with SMTP id d23so11862148qto.2;
        Mon, 17 Jun 2019 11:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JNPNSnX/nZLYbeGrmzMgRn9YqTSI5FtDFBTl4Ci0/h0=;
        b=qe/mDa0RpT/lvCERAtXPrli5vv2TYyDyCHmVvSaFlK+aYwBP3e+nwCDW7dJPzK3DGM
         COSG8lv5oEr8tb/LhqiNge0UjTOelVcGlkaY9gScm+v72ZewZ6gKE4AWqH4wChNXJrgr
         stEBvowe/a7FrtwwJvQJGh2E3QomQVTQKtFL++5T1TZEsR5QGzdTLgA4ibKRtBZ/nlbe
         fKhiujKdCsQ7El6+F+NmWcOSkuqQ+eC6LN9BgjaHZ9W/5tMebnsWlMEBaZfrWGMawSRD
         FPWLyZA9pMRiMEWVPBz4jQUvlUKMlhdlMs1A3Bi1RdBvk6ug6L/dGkERm1lUKaPfVzYZ
         ePaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JNPNSnX/nZLYbeGrmzMgRn9YqTSI5FtDFBTl4Ci0/h0=;
        b=Kvt7JTu6Z1TbLDqZfxTPP5pXmCdBXzqF4qK2UmthIsO4UiMtgy7JwanqAadAnKD+KR
         x05Yaf53g/yeO/rgArGdM5gHSixntoYOjszQHD198waPKsO2oodG1HWzRPDvTJJbU5Sb
         vfg1V/vbx3QMfyxLS6dTgNwREI8tIKh8pwcxcx4E7T3sqm8kutAfHLKSWEiEAIxGhmbl
         Jrtk9j3ddcx/Ost3vZXs0zfIzU2itlD7/Q3mi2iEpgJIS77r6gT/HpFZGIMlHy1y/hiB
         ZRf8k3xA7UMI7eKQdt4fZmuDz0Z839ZkFRNtfsaWzqZFlTsF4KLNztGWKkM7LC7pjbH4
         5wLw==
X-Gm-Message-State: APjAAAVA/btMqw4euuOaC8dc62Kx9J1XFwn0lrX4Ehfy1LrPKnbQcs2X
        LrCNV49AcFheDD0brZ82CZIPHvBCSE8WI5VAWFk=
X-Google-Smtp-Source: APXvYqy6O+86H1ro/1Q5OY3wtqwX9Bs8lcEA6dFidoKqtF/RBV4Kk035945bnOueL/ukxTWLBupYyY+L1hNj1cUqy8A=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr6842499qty.141.1560794527066;
 Mon, 17 Jun 2019 11:02:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190611043505.14664-1-andriin@fb.com> <20190611043505.14664-4-andriin@fb.com>
 <CAPhsuW7bowxNMr22UkCvTkq8VHYrNiEJtQSdZjausj_8d4oYUQ@mail.gmail.com>
In-Reply-To: <CAPhsuW7bowxNMr22UkCvTkq8VHYrNiEJtQSdZjausj_8d4oYUQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 17 Jun 2019 11:01:55 -0700
Message-ID: <CAEf4BzbTf6o9yqij7M1rwAOx_hq2Yc=qvNX_o1Trooesxja2ig@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 3/8] libbpf: refactor map initialization
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 15, 2019 at 2:03 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Mon, Jun 10, 2019 at 9:35 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > User and global data maps initialization has gotten pretty complicated
> > and unnecessarily convoluted. This patch splits out the logic for global
> > data map and user-defined map initialization. It also removes the
> > restriction of pre-calculating how many maps will be initialized,
> > instead allowing to keep adding new maps as they are discovered, which
> > will be used later for BTF-defined map definitions.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 244 ++++++++++++++++++++++-------------------
> >  1 file changed, 134 insertions(+), 110 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 9e39a0a33aeb..c931ee7e1fd2 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -234,6 +234,7 @@ struct bpf_object {
> >         size_t nr_programs;
> >         struct bpf_map *maps;
> >         size_t nr_maps;
> > +       size_t maps_cap;
> >         struct bpf_secdata sections;
> >
> >         bool loaded;
> > @@ -763,12 +764,38 @@ int bpf_object__variable_offset(const struct bpf_object *obj, const char *name,
> >         return -ENOENT;
> >  }
> >
> > -static bool bpf_object__has_maps(const struct bpf_object *obj)
> > +static struct bpf_map *bpf_object__add_map(struct bpf_object *obj)
> >  {
> > -       return obj->efile.maps_shndx >= 0 ||
> > -              obj->efile.data_shndx >= 0 ||
> > -              obj->efile.rodata_shndx >= 0 ||
> > -              obj->efile.bss_shndx >= 0;
> > +       struct bpf_map *new_maps;
> > +       size_t new_cap;
> > +       int i;
> > +
> > +       if (obj->nr_maps + 1 <= obj->maps_cap)
> nit:   how about     if (obj->nr_maps < obj->maps_cap)

yep, will do

>
> > +               return &obj->maps[obj->nr_maps++];
> > +
> > +       new_cap = max(4ul, obj->maps_cap * 3 / 2);
> > +       new_maps = realloc(obj->maps, new_cap * sizeof(*obj->maps));
> > +       if (!new_maps) {
> > +               pr_warning("alloc maps for object failed\n");
> > +               return ERR_PTR(-ENOMEM);
> > +       }
> > +
> > +       obj->maps_cap = new_cap;
> > +       obj->maps = new_maps;
> > +
> > +       /* zero out new maps */
> > +       memset(obj->maps + obj->nr_maps, 0,
> > +              (obj->maps_cap - obj->nr_maps) * sizeof(*obj->maps));
> > +       /*
> > +        * fill all fd with -1 so won't close incorrect fd (fd=0 is stdin)
> > +        * when failure (zclose won't close negative fd)).
> > +        */
> > +       for (i = obj->nr_maps; i < obj->maps_cap; i++) {
> > +               obj->maps[i].fd = -1;
> > +               obj->maps[i].inner_map_fd = -1;
> > +       }
> > +
> > +       return &obj->maps[obj->nr_maps++];
> >  }
> >
> >  static int
> > @@ -808,29 +835,68 @@ bpf_object__init_internal_map(struct bpf_object *obj, struct bpf_map *map,
> >         return 0;
> >  }
> >
> > -static int bpf_object__init_maps(struct bpf_object *obj, int flags)
> > +static int bpf_object__init_global_data_maps(struct bpf_object *obj)
> > +{
> > +       struct bpf_map *map;
> > +       int err;
> > +
> > +       if (!obj->caps.global_data)
> > +               return 0;
> > +       /*
> > +        * Populate obj->maps with libbpf internal maps.
> > +        */
> > +       if (obj->efile.data_shndx >= 0) {
> > +               map = bpf_object__add_map(obj);
> > +               if (IS_ERR(map))
> > +                       return PTR_ERR(map);
> > +               err = bpf_object__init_internal_map(obj, map, LIBBPF_MAP_DATA,
> > +                                                   obj->efile.data,
> > +                                                   &obj->sections.data);
> > +               if (err)
> > +                       return err;
> > +       }
> > +       if (obj->efile.rodata_shndx >= 0) {
> > +               map = bpf_object__add_map(obj);
> > +               if (IS_ERR(map))
> > +                       return PTR_ERR(map);
> > +               err = bpf_object__init_internal_map(obj, map, LIBBPF_MAP_RODATA,
> > +                                                   obj->efile.rodata,
> > +                                                   &obj->sections.rodata);
> > +               if (err)
> > +                       return err;
> > +       }
> > +       if (obj->efile.bss_shndx >= 0) {
> > +               map = bpf_object__add_map(obj);
> > +               if (IS_ERR(map))
> > +                       return PTR_ERR(map);
> > +               err = bpf_object__init_internal_map(obj, map, LIBBPF_MAP_BSS,
> > +                                                   obj->efile.bss, NULL);
> > +               if (err)
> > +                       return err;
> > +       }
>
> These 3 if clause are a little too complicated. How about we call
> bpf_obj_add_map(obj) within bpf_object__init_internal_map()?

Yeah, totally, not sure why I did it this way :)

>
> > +       return 0;
> > +}
> > +
> > +static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
> >  {

<snip>
