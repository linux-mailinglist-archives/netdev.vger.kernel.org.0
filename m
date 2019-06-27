Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18E7E5854B
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfF0PLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:11:42 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34517 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfF0PLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:11:41 -0400
Received: by mail-lj1-f194.google.com with SMTP id p17so2762838ljg.1
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 08:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FSOoHYUvxt4I1XslgXKup7VwR4yrIhCg86MG2VkV5gk=;
        b=ezyFdxUXeuUJn2v+h+QDCWIQWEYbAZj+km2FinCdaBRKo6tfZtCwY4CV2SBKJn7U8K
         qKFSXnN8teAx+8fNEAaaW2mQ5xqhmogPgwIZ9wLKdqN5SkufaxpKkHuoYdJ7OiFbp26X
         tFGxwNvg5k3Yj9Nw8ZOuy1gEPF9KymCAyd6WxPyb8e40jKMVNcOzu0Bf169V1omaAUMX
         H/HN5LvLhET4OzLCkXnxsRF5x6kJJ4RPtMng0ZdBoylX5HjPfP0NWFQP3AOMfR5IDRFZ
         +HLDKgU0H4yfb9FQSFu20+zc+RITyx1YsHBSTc2KBFm6fdOhtnUNCR73SdYspQ5JkOnz
         I1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FSOoHYUvxt4I1XslgXKup7VwR4yrIhCg86MG2VkV5gk=;
        b=HdFABV/lTm8pdjyaQZD8HtMmN6ezRfpEqjjcK5DkhhGCfMr0lEQrNTsJEYiLFogK8a
         MgmlT4D7W1VROlq+ZmyG9FuEaiiRdJ4WpKOXghwqn0jpz2aUIcbmv5eVtVeXpjBg72sb
         jDY/Tacg1ZDDsDzrIHsp89On48JIwShHCRdS6Woop6JLX5U+kIS9Mcna/mgLS0c9CLzQ
         S6EscUqmgrsvaBZMp2/c4TCCSRwHjFMuWDR6QL6fsaAkVcxbceKYi30DdseOraD45e+5
         tKAaNlUM0vNVldB24To9HgFG2bJIi2UyKDyS8wyjXOyOqsPTeipUiuSxfGaarq+hKowG
         kMgQ==
X-Gm-Message-State: APjAAAUP+AbBolI+R1kRSktBzgT+umA9YJpWmgXXsu2y2Dp+S98DEWe6
        YwjGTNYmt3+Qcx1CaTWMfLuU7Y+RtBkFysfxhmRKlw==
X-Google-Smtp-Source: APXvYqz/QxWSwpvvHWX/i4Xmg5OUyfiT9+Y4z1mXeWJsqHgFhp2lQfIlL3rT/AIW8T6sg1WLAKc0Dz8OaZBT3ffbGGM=
X-Received: by 2002:a2e:7d03:: with SMTP id y3mr3005061ljc.240.1561648298079;
 Thu, 27 Jun 2019 08:11:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190617192700.2313445-1-andriin@fb.com> <20190617192700.2313445-5-andriin@fb.com>
 <CAH+k93H5ddp7cMBGtyn9DNPvv1MymGCsShJ1-3tezLPUnxt6vw@mail.gmail.com> <CAEf4BzY8wMtq9EmUcsqeLrNOkduKwzuYrweKhhVWKdAb57ax+Q@mail.gmail.com>
In-Reply-To: <CAEf4BzY8wMtq9EmUcsqeLrNOkduKwzuYrweKhhVWKdAb57ax+Q@mail.gmail.com>
From:   Matt Hart <matthew.hart@linaro.org>
Date:   Thu, 27 Jun 2019 16:11:27 +0100
Message-ID: <CAH+k93E1rjWKaR8p2LpPjn5VE7E9h7P_CvvA1S-KxT8TK=5FJw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 04/11] libbpf: refactor map initialization
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, linux-perf-users@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jun 2019 at 19:29, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>
> On Wed, Jun 26, 2019 at 7:48 AM Matt Hart <matthew.hart@linaro.org> wrote=
:
> >
> > Hi all,
> >
> > I noticed perf fails to build for armv7 on linux next, due to this
> > compile error:
> > $ make -C tools/perf ARCH=3Darm CROSS_COMPILE=3Darm-linux-gnueabihf-
> >
> >   CC       libbpf_probes.o
> > In file included from libbpf.c:27:
> > libbpf.c: In function =E2=80=98bpf_object__add_map=E2=80=99:
> > /home/matt/git/linux-next/tools/include/linux/kernel.h:45:17: error:
> > comparison of distinct pointer types lacks a cast [-Werror]
> >   (void) (&_max1 =3D=3D &_max2);  \
> >                  ^~
> > libbpf.c:776:12: note: in expansion of macro =E2=80=98max=E2=80=99
> >   new_cap =3D max(4ul, obj->maps_cap * 3 / 2);
> >             ^~~
> >
> > So I bisected it and came down to this patch.
> > Commit bf82927125dd25003d76ed5541da704df21de57a
> >
> > Full verbose bisect script https://hastebin.com/odoyujofav.coffeescript
> >
> > Is this a case that perf code needs updating to match the change, or
> > is the change broken?
>
> Hi Matt,
>
> Thanks for reporting. This issue was already fixed in
> https://patchwork.ozlabs.org/patch/1122673/, so just pull latest
> bpf-next.

Thanks, I see that patch has hit linux-next so perf is building again.

> >
> >
> >
> > On Tue, 25 Jun 2019 at 16:53, Andrii Nakryiko <andriin@fb.com> wrote:
> > >
> > > User and global data maps initialization has gotten pretty complicate=
d
> > > and unnecessarily convoluted. This patch splits out the logic for glo=
bal
> > > data map and user-defined map initialization. It also removes the
> > > restriction of pre-calculating how many maps will be initialized,
> > > instead allowing to keep adding new maps as they are discovered, whic=
h
> > > will be used later for BTF-defined map definitions.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  tools/lib/bpf/libbpf.c | 247 ++++++++++++++++++++++-----------------=
--
> > >  1 file changed, 133 insertions(+), 114 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index 7ee44d8877c5..88609dca4f7d 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -234,6 +234,7 @@ struct bpf_object {
> > >         size_t nr_programs;
> > >         struct bpf_map *maps;
> > >         size_t nr_maps;
> > > +       size_t maps_cap;
> > >         struct bpf_secdata sections;
> > >
> > >         bool loaded;
> > > @@ -763,21 +764,51 @@ int bpf_object__variable_offset(const struct bp=
f_object *obj, const char *name,
> > >         return -ENOENT;
> > >  }
> > >
> > > -static bool bpf_object__has_maps(const struct bpf_object *obj)
> > > +static struct bpf_map *bpf_object__add_map(struct bpf_object *obj)
> > >  {
> > > -       return obj->efile.maps_shndx >=3D 0 ||
> > > -              obj->efile.data_shndx >=3D 0 ||
> > > -              obj->efile.rodata_shndx >=3D 0 ||
> > > -              obj->efile.bss_shndx >=3D 0;
> > > +       struct bpf_map *new_maps;
> > > +       size_t new_cap;
> > > +       int i;
> > > +
> > > +       if (obj->nr_maps < obj->maps_cap)
> > > +               return &obj->maps[obj->nr_maps++];
> > > +
> > > +       new_cap =3D max(4ul, obj->maps_cap * 3 / 2);
> > > +       new_maps =3D realloc(obj->maps, new_cap * sizeof(*obj->maps))=
;
> > > +       if (!new_maps) {
> > > +               pr_warning("alloc maps for object failed\n");
> > > +               return ERR_PTR(-ENOMEM);
> > > +       }
> > > +
> > > +       obj->maps_cap =3D new_cap;
> > > +       obj->maps =3D new_maps;
> > > +
> > > +       /* zero out new maps */
> > > +       memset(obj->maps + obj->nr_maps, 0,
> > > +              (obj->maps_cap - obj->nr_maps) * sizeof(*obj->maps));
> > > +       /*
> > > +        * fill all fd with -1 so won't close incorrect fd (fd=3D0 is=
 stdin)
> > > +        * when failure (zclose won't close negative fd)).
> > > +        */
> > > +       for (i =3D obj->nr_maps; i < obj->maps_cap; i++) {
> > > +               obj->maps[i].fd =3D -1;
> > > +               obj->maps[i].inner_map_fd =3D -1;
> > > +       }
> > > +
> > > +       return &obj->maps[obj->nr_maps++];
> > >  }
> > >
> > >  static int
> > > -bpf_object__init_internal_map(struct bpf_object *obj, struct bpf_map=
 *map,
> > > -                             enum libbpf_map_type type, Elf_Data *da=
ta,
> > > -                             void **data_buff)
> > > +bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_ma=
p_type type,
> > > +                             Elf_Data *data, void **data_buff)
> > >  {
> > > -       struct bpf_map_def *def =3D &map->def;
> > >         char map_name[BPF_OBJ_NAME_LEN];
> > > +       struct bpf_map_def *def;
> > > +       struct bpf_map *map;
> > > +
> > > +       map =3D bpf_object__add_map(obj);
> > > +       if (IS_ERR(map))
> > > +               return PTR_ERR(map);
> > >
> > >         map->libbpf_type =3D type;
> > >         map->offset =3D ~(typeof(map->offset))0;
> > > @@ -789,6 +820,7 @@ bpf_object__init_internal_map(struct bpf_object *=
obj, struct bpf_map *map,
> > >                 return -ENOMEM;
> > >         }
> > >
> > > +       def =3D &map->def;
> > >         def->type =3D BPF_MAP_TYPE_ARRAY;
> > >         def->key_size =3D sizeof(int);
> > >         def->value_size =3D data->d_size;
> > > @@ -808,29 +840,58 @@ bpf_object__init_internal_map(struct bpf_object=
 *obj, struct bpf_map *map,
> > >         return 0;
> > >  }
> > >
> > > -static int bpf_object__init_maps(struct bpf_object *obj, int flags)
> > > +static int bpf_object__init_global_data_maps(struct bpf_object *obj)
> > > +{
> > > +       int err;
> > > +
> > > +       if (!obj->caps.global_data)
> > > +               return 0;
> > > +       /*
> > > +        * Populate obj->maps with libbpf internal maps.
> > > +        */
> > > +       if (obj->efile.data_shndx >=3D 0) {
> > > +               err =3D bpf_object__init_internal_map(obj, LIBBPF_MAP=
_DATA,
> > > +                                                   obj->efile.data,
> > > +                                                   &obj->sections.da=
ta);
> > > +               if (err)
> > > +                       return err;
> > > +       }
> > > +       if (obj->efile.rodata_shndx >=3D 0) {
> > > +               err =3D bpf_object__init_internal_map(obj, LIBBPF_MAP=
_RODATA,
> > > +                                                   obj->efile.rodata=
,
> > > +                                                   &obj->sections.ro=
data);
> > > +               if (err)
> > > +                       return err;
> > > +       }
> > > +       if (obj->efile.bss_shndx >=3D 0) {
> > > +               err =3D bpf_object__init_internal_map(obj, LIBBPF_MAP=
_BSS,
> > > +                                                   obj->efile.bss, N=
ULL);
> > > +               if (err)
> > > +                       return err;
> > > +       }
> > > +       return 0;
> > > +}
> > > +
> > > +static int bpf_object__init_user_maps(struct bpf_object *obj, bool s=
trict)
> > >  {
> > > -       int i, map_idx, map_def_sz =3D 0, nr_syms, nr_maps =3D 0, nr_=
maps_glob =3D 0;
> > > -       bool strict =3D !(flags & MAPS_RELAX_COMPAT);
> > >         Elf_Data *symbols =3D obj->efile.symbols;
> > > +       int i, map_def_sz =3D 0, nr_maps =3D 0, nr_syms;
> > >         Elf_Data *data =3D NULL;
> > > -       int ret =3D 0;
> > > +       Elf_Scn *scn;
> > > +
> > > +       if (obj->efile.maps_shndx < 0)
> > > +               return 0;
> > >
> > >         if (!symbols)
> > >                 return -EINVAL;
> > > -       nr_syms =3D symbols->d_size / sizeof(GElf_Sym);
> > > -
> > > -       if (obj->efile.maps_shndx >=3D 0) {
> > > -               Elf_Scn *scn =3D elf_getscn(obj->efile.elf,
> > > -                                         obj->efile.maps_shndx);
> > >
> > > -               if (scn)
> > > -                       data =3D elf_getdata(scn, NULL);
> > > -               if (!scn || !data) {
> > > -                       pr_warning("failed to get Elf_Data from map s=
ection %d\n",
> > > -                                  obj->efile.maps_shndx);
> > > -                       return -EINVAL;
> > > -               }
> > > +       scn =3D elf_getscn(obj->efile.elf, obj->efile.maps_shndx);
> > > +       if (scn)
> > > +               data =3D elf_getdata(scn, NULL);
> > > +       if (!scn || !data) {
> > > +               pr_warning("failed to get Elf_Data from map section %=
d\n",
> > > +                          obj->efile.maps_shndx);
> > > +               return -EINVAL;
> > >         }
> > >
> > >         /*
> > > @@ -840,16 +901,8 @@ static int bpf_object__init_maps(struct bpf_obje=
ct *obj, int flags)
> > >          *
> > >          * TODO: Detect array of map and report error.
> > >          */
> > > -       if (obj->caps.global_data) {
> > > -               if (obj->efile.data_shndx >=3D 0)
> > > -                       nr_maps_glob++;
> > > -               if (obj->efile.rodata_shndx >=3D 0)
> > > -                       nr_maps_glob++;
> > > -               if (obj->efile.bss_shndx >=3D 0)
> > > -                       nr_maps_glob++;
> > > -       }
> > > -
> > > -       for (i =3D 0; data && i < nr_syms; i++) {
> > > +       nr_syms =3D symbols->d_size / sizeof(GElf_Sym);
> > > +       for (i =3D 0; i < nr_syms; i++) {
> > >                 GElf_Sym sym;
> > >
> > >                 if (!gelf_getsym(symbols, i, &sym))
> > > @@ -858,79 +911,56 @@ static int bpf_object__init_maps(struct bpf_obj=
ect *obj, int flags)
> > >                         continue;
> > >                 nr_maps++;
> > >         }
> > > -
> > > -       if (!nr_maps && !nr_maps_glob)
> > > -               return 0;
> > > -
> > >         /* Assume equally sized map definitions */
> > > -       if (data) {
> > > -               pr_debug("maps in %s: %d maps in %zd bytes\n", obj->p=
ath,
> > > -                        nr_maps, data->d_size);
> > > -
> > > -               map_def_sz =3D data->d_size / nr_maps;
> > > -               if (!data->d_size || (data->d_size % nr_maps) !=3D 0)=
 {
> > > -                       pr_warning("unable to determine map definitio=
n size "
> > > -                                  "section %s, %d maps in %zd bytes\=
n",
> > > -                                  obj->path, nr_maps, data->d_size);
> > > -                       return -EINVAL;
> > > -               }
> > > -       }
> > > -
> > > -       nr_maps +=3D nr_maps_glob;
> > > -       obj->maps =3D calloc(nr_maps, sizeof(obj->maps[0]));
> > > -       if (!obj->maps) {
> > > -               pr_warning("alloc maps for object failed\n");
> > > -               return -ENOMEM;
> > > -       }
> > > -       obj->nr_maps =3D nr_maps;
> > > -
> > > -       for (i =3D 0; i < nr_maps; i++) {
> > > -               /*
> > > -                * fill all fd with -1 so won't close incorrect
> > > -                * fd (fd=3D0 is stdin) when failure (zclose won't cl=
ose
> > > -                * negative fd)).
> > > -                */
> > > -               obj->maps[i].fd =3D -1;
> > > -               obj->maps[i].inner_map_fd =3D -1;
> > > +       pr_debug("maps in %s: %d maps in %zd bytes\n",
> > > +                obj->path, nr_maps, data->d_size);
> > > +
> > > +       map_def_sz =3D data->d_size / nr_maps;
> > > +       if (!data->d_size || (data->d_size % nr_maps) !=3D 0) {
> > > +               pr_warning("unable to determine map definition size "
> > > +                          "section %s, %d maps in %zd bytes\n",
> > > +                          obj->path, nr_maps, data->d_size);
> > > +               return -EINVAL;
> > >         }
> > >
> > > -       /*
> > > -        * Fill obj->maps using data in "maps" section.
> > > -        */
> > > -       for (i =3D 0, map_idx =3D 0; data && i < nr_syms; i++) {
> > > +       /* Fill obj->maps using data in "maps" section.  */
> > > +       for (i =3D 0; i < nr_syms; i++) {
> > >                 GElf_Sym sym;
> > >                 const char *map_name;
> > >                 struct bpf_map_def *def;
> > > +               struct bpf_map *map;
> > >
> > >                 if (!gelf_getsym(symbols, i, &sym))
> > >                         continue;
> > >                 if (sym.st_shndx !=3D obj->efile.maps_shndx)
> > >                         continue;
> > >
> > > -               map_name =3D elf_strptr(obj->efile.elf,
> > > -                                     obj->efile.strtabidx,
> > > +               map =3D bpf_object__add_map(obj);
> > > +               if (IS_ERR(map))
> > > +                       return PTR_ERR(map);
> > > +
> > > +               map_name =3D elf_strptr(obj->efile.elf, obj->efile.st=
rtabidx,
> > >                                       sym.st_name);
> > >                 if (!map_name) {
> > >                         pr_warning("failed to get map #%d name sym st=
ring for obj %s\n",
> > > -                                  map_idx, obj->path);
> > > +                                  i, obj->path);
> > >                         return -LIBBPF_ERRNO__FORMAT;
> > >                 }
> > >
> > > -               obj->maps[map_idx].libbpf_type =3D LIBBPF_MAP_UNSPEC;
> > > -               obj->maps[map_idx].offset =3D sym.st_value;
> > > +               map->libbpf_type =3D LIBBPF_MAP_UNSPEC;
> > > +               map->offset =3D sym.st_value;
> > >                 if (sym.st_value + map_def_sz > data->d_size) {
> > >                         pr_warning("corrupted maps section in %s: las=
t map \"%s\" too small\n",
> > >                                    obj->path, map_name);
> > >                         return -EINVAL;
> > >                 }
> > >
> > > -               obj->maps[map_idx].name =3D strdup(map_name);
> > > -               if (!obj->maps[map_idx].name) {
> > > +               map->name =3D strdup(map_name);
> > > +               if (!map->name) {
> > >                         pr_warning("failed to alloc map name\n");
> > >                         return -ENOMEM;
> > >                 }
> > > -               pr_debug("map %d is \"%s\"\n", map_idx,
> > > -                        obj->maps[map_idx].name);
> > > +               pr_debug("map %d is \"%s\"\n", i, map->name);
> > >                 def =3D (struct bpf_map_def *)(data->d_buf + sym.st_v=
alue);
> > >                 /*
> > >                  * If the definition of the map in the object file fi=
ts in
> > > @@ -939,7 +969,7 @@ static int bpf_object__init_maps(struct bpf_objec=
t *obj, int flags)
> > >                  * calloc above.
> > >                  */
> > >                 if (map_def_sz <=3D sizeof(struct bpf_map_def)) {
> > > -                       memcpy(&obj->maps[map_idx].def, def, map_def_=
sz);
> > > +                       memcpy(&map->def, def, map_def_sz);
> > >                 } else {
> > >                         /*
> > >                          * Here the map structure being read is bigge=
r than what
> > > @@ -959,37 +989,30 @@ static int bpf_object__init_maps(struct bpf_obj=
ect *obj, int flags)
> > >                                                 return -EINVAL;
> > >                                 }
> > >                         }
> > > -                       memcpy(&obj->maps[map_idx].def, def,
> > > -                              sizeof(struct bpf_map_def));
> > > +                       memcpy(&map->def, def, sizeof(struct bpf_map_=
def));
> > >                 }
> > > -               map_idx++;
> > >         }
> > > +       return 0;
> > > +}
> > >
> > > -       if (!obj->caps.global_data)
> > > -               goto finalize;
> > > +static int bpf_object__init_maps(struct bpf_object *obj, int flags)
> > > +{
> > > +       bool strict =3D !(flags & MAPS_RELAX_COMPAT);
> > > +       int err;
> > >
> > > -       /*
> > > -        * Populate rest of obj->maps with libbpf internal maps.
> > > -        */
> > > -       if (obj->efile.data_shndx >=3D 0)
> > > -               ret =3D bpf_object__init_internal_map(obj, &obj->maps=
[map_idx++],
> > > -                                                   LIBBPF_MAP_DATA,
> > > -                                                   obj->efile.data,
> > > -                                                   &obj->sections.da=
ta);
> > > -       if (!ret && obj->efile.rodata_shndx >=3D 0)
> > > -               ret =3D bpf_object__init_internal_map(obj, &obj->maps=
[map_idx++],
> > > -                                                   LIBBPF_MAP_RODATA=
,
> > > -                                                   obj->efile.rodata=
,
> > > -                                                   &obj->sections.ro=
data);
> > > -       if (!ret && obj->efile.bss_shndx >=3D 0)
> > > -               ret =3D bpf_object__init_internal_map(obj, &obj->maps=
[map_idx++],
> > > -                                                   LIBBPF_MAP_BSS,
> > > -                                                   obj->efile.bss, N=
ULL);
> > > -finalize:
> > > -       if (!ret)
> > > +       err =3D bpf_object__init_user_maps(obj, strict);
> > > +       if (err)
> > > +               return err;
> > > +
> > > +       err =3D bpf_object__init_global_data_maps(obj);
> > > +       if (err)
> > > +               return err;
> > > +
> > > +       if (obj->nr_maps) {
> > >                 qsort(obj->maps, obj->nr_maps, sizeof(obj->maps[0]),
> > >                       compare_bpf_map);
> > > -       return ret;
> > > +       }
> > > +       return 0;
> > >  }
> > >
> > >  static bool section_have_execinstr(struct bpf_object *obj, int idx)
> > > @@ -1262,14 +1285,10 @@ static int bpf_object__elf_collect(struct bpf=
_object *obj, int flags)
> > >                 return -LIBBPF_ERRNO__FORMAT;
> > >         }
> > >         err =3D bpf_object__load_btf(obj, btf_data, btf_ext_data);
> > > -       if (err)
> > > -               return err;
> > > -       if (bpf_object__has_maps(obj)) {
> > > +       if (!err)
> > >                 err =3D bpf_object__init_maps(obj, flags);
> > > -               if (err)
> > > -                       return err;
> > > -       }
> > > -       err =3D bpf_object__init_prog_names(obj);
> > > +       if (!err)
> > > +               err =3D bpf_object__init_prog_names(obj);
> > >         return err;
> > >  }
> > >
> > > --
> > > 2.17.1
> > >
