Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93C98E4299
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 06:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389917AbfJYElO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 00:41:14 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34498 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389552AbfJYElO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 00:41:14 -0400
Received: by mail-qk1-f195.google.com with SMTP id f18so621440qkm.1;
        Thu, 24 Oct 2019 21:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4IlgRRdhxvysYLi3567WKxNUvBCKZGwQIjwVueqjWj8=;
        b=Ge9Ye3r6xgSUFfMDfyTBqtcH7FYb66bfQ2v3b1Tn+Kzj0na5FwH0L0qild4kmE9Eu3
         XcMTiHqI6c+Xlx/l2/pjNOU2hSU9lR4pIpoGyqAWF8llUTsyXLkaRWTeD4S4ST2/IdvS
         r8PQoV9XWUXaNrADLKYpm25BTo1IxKWfB8MYVFGla8xnMuZU3wIP+/VX4KRW2J6gDpId
         KoS246p1DuOK64Et4MRwDZ6+R0kVa1tefXTGkgeQK2a2HUDWe0ATno6TGlMEn/L2rdFr
         Sm491jKzfZEVY8Gc77wgV6JdgIIPXnLH3o+2q7fxMH22a06/1B9cPQSsaOh40yuhyeKC
         ME9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4IlgRRdhxvysYLi3567WKxNUvBCKZGwQIjwVueqjWj8=;
        b=I5IpOL9KpakHZn6piaQLB9PwsM/+wClodaai2tLLjwI1snr6uYpCtj6sFZtYCcmjWj
         1WtncPFv1uVD75d/X4d3ZkEc2WZe4g4I+0r3a45neADHQx2+WmEhzwJ1pKRBNeFK8cTq
         Um9iun2qQsyjGx5i9eY2muhx5zHNqC2X4RGXih0rlrod32FTV3aPqrg/0XuSMDAMzNdN
         fbg2shiPgWt7WQlFGubeR8oCX9rx5d5LhTB6if3jJe+LDB0j/NBLTvcSGpvOFWzurjlE
         ADY3uSREwV7rUiiXCQA+PQLaP0ebn2OHz+b+QAIwCepEFC+nmwYroHl/KCZvD6G8wytV
         1xeg==
X-Gm-Message-State: APjAAAWqlNMuzYiu97Qzc//qzC0lrsp6pLaG1lM+XCsrF1qpvB3DTgpi
        95ycMNUVRxSOiknHhrSvS88pLQVtjWUayJCN9gI=
X-Google-Smtp-Source: APXvYqzMKfBIBpKXNzVzdqJ7VGm6xH/wFwhnL05hDVBQCxbmAmkPn/1eG78F5HWOg7SSK+YKtxd5BovTUhJac4Y9fe4=
X-Received: by 2002:a37:4c13:: with SMTP id z19mr1134979qka.449.1571978472271;
 Thu, 24 Oct 2019 21:41:12 -0700 (PDT)
MIME-Version: 1.0
References: <157192269744.234778.11792009511322809519.stgit@toke.dk> <157192270189.234778.14607584397750494265.stgit@toke.dk>
In-Reply-To: <157192270189.234778.14607584397750494265.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 24 Oct 2019 21:41:01 -0700
Message-ID: <CAEf4BzbBmm3GfytbEtHwoD71p2XfuxuSYjhbb7rqPwUaYqvk7g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/4] libbpf: Add option to auto-pin maps when
 opening BPF object
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 6:11 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> With the functions added in previous commits that can automatically pin
> maps based on their 'pinning' setting, we can support auto-pinning of map=
s
> by the simple setting of an option to bpf_object__open.
>
> Since auto-pinning only does something if any maps actually have a
> 'pinning' BTF attribute set, we default the new option to enabled, on the
> assumption that seamless pinning is what most callers want.
>
> When a map has a pin_path set at load time, libbpf will compare the map
> pinned at that location (if any), and if the attributes match, will re-us=
e
> that map instead of creating a new one. If no existing map is found, the
> newly created map will instead be pinned at the location.
>
> Programs wanting to customise the pinning can override the pinning paths
> using bpf_map__set_pin_path() before calling bpf_object__load().
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

How have you tested this? From reading the code, all the maps will be
pinned irregardless of their .pinning setting?

Please add proper tests to test_progs, testing various modes and overrides.

You keep trying to add more and more knobs :) Please stop doing that,
even if we have a good mechanism for extensibility, it doesn't mean we
need to increase a proliferation of options. Each option has to be
tested. In current version of your patches, you have something like 4
or 5 different knobs, do you really want to write tests testing each
of them? ;)

Another high-level feedback. I think having separate passes over all
maps (build_map_pin_paths, reuse, then we already have create_maps) is
actually making everything more verbose and harder to extend. I'm
thinking about all these as sub-steps of map creation. Can you please
try refactoring so all these steps are happening per each map in one
place: if map needs to be pinned, check if it can be reused, if not -
create it. This actually will allow to handle races better, because
you will be able to retry easily, while if it's all spread in
independent passes, it becomes much harder. Please consider that.


>  tools/lib/bpf/libbpf.c |  120 ++++++++++++++++++++++++++++++++++++++++++=
++++--
>  tools/lib/bpf/libbpf.h |    4 +-
>  2 files changed, 119 insertions(+), 5 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 179c9911458d..e911760cd7ff 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1378,7 +1378,29 @@ static int build_pin_path(char *buf, size_t buf_le=
n,
>         return len;
>  }
>
> -static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed_ma=
ps)
> +static int bpf_object__build_map_pin_paths(struct bpf_object *obj)

shouldn't this whole thing take into account pinning attribute and not
do anything for maps that didn't request pinning?

> +{
> +       struct bpf_map *map;
> +       int err, len;
> +
> +       bpf_object__for_each_map(map, obj) {
> +               char buf[PATH_MAX];
> +               len =3D build_pin_path(buf, sizeof(buf), map,
> +                                    "/sys/fs/bpf", false);

"/sys/fs/bpf" should be overridable, this is why I'm insisting on
putting this pin_root_path override into open_opts, instead of
separate pin_opts. How all this was supposed to work, your approach
looks quite incoherent...

> +               if (len =3D=3D 0)
> +                       continue;
> +               else if (len < 0)
> +                       return len;
> +
> +               err =3D bpf_map__set_pin_path(map, buf);
> +               if (err)
> +                       return err;
> +       }
> +       return 0;
> +}
> +
> +static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed_ma=
ps,
> +                                bool auto_pin_maps)
>  {
>         bool strict =3D !relaxed_maps;
>         int err;
> @@ -1395,6 +1417,12 @@ static int bpf_object__init_maps(struct bpf_object=
 *obj, bool relaxed_maps)
>         if (err)
>                 return err;
>
> +       if (auto_pin_maps) {

I don't think we need this option, unless proven otherwise. Let's do
this always. If application doesn't want auto-pinning, it shouldn't
specify .pinning =3D BY_NAME, or should bpf_map__set_pin_path(NULL)

> +               err =3D bpf_object__build_map_pin_paths(obj);
> +               if (err)
> +                       return err;
> +       }
> +
>         if (obj->nr_maps) {
>                 qsort(obj->maps, obj->nr_maps, sizeof(obj->maps[0]),
>                       compare_bpf_map);
> @@ -1577,7 +1605,8 @@ static int bpf_object__sanitize_and_load_btf(struct=
 bpf_object *obj)
>         return 0;
>  }
>
> -static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_=
maps)
> +static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_=
maps,
> +                                  bool auto_pin_maps)
>  {
>         Elf *elf =3D obj->efile.elf;
>         GElf_Ehdr *ep =3D &obj->efile.ehdr;
> @@ -1712,7 +1741,7 @@ static int bpf_object__elf_collect(struct bpf_objec=
t *obj, bool relaxed_maps)
>         }
>         err =3D bpf_object__init_btf(obj, btf_data, btf_ext_data);
>         if (!err)
> -               err =3D bpf_object__init_maps(obj, relaxed_maps);
> +               err =3D bpf_object__init_maps(obj, relaxed_maps, auto_pin=
_maps);
>         if (!err)
>                 err =3D bpf_object__sanitize_and_load_btf(obj);
>         if (!err)
> @@ -2288,12 +2317,91 @@ bpf_object__create_maps(struct bpf_object *obj)
>                         }
>                 }
>
> +               if (map->pin_path) {
> +                       err =3D bpf_map__pin(map, NULL);
> +                       if (err)
> +                               pr_warning("failed to auto-pin map name '=
%s' at '%s'\n",
> +                                          map->name, map->pin_path);

this should be hard error

> +               }
> +
>                 pr_debug("created map %s: fd=3D%d\n", map->name, *pfd);
>         }
>
>         return 0;
>  }
>
> +static int check_map_compat(const struct bpf_map *map,
> +                           int map_fd)

super confusing set of return values, plus name doesn't really clarify
what's expected. Let's call it something like
is_pinned_map_compatible(), then we follow typical boolean-returning
convention: <0 - error, 0 - false, 1 - true. No confusion, no
guessing.

> +{
> +       struct bpf_map_info map_info =3D {};
> +       char msg[STRERR_BUFSIZE];
> +       __u32 map_info_len;
> +       int err;
> +
> +       map_info_len =3D sizeof(map_info);
> +       err =3D bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len);
> +       if (err) {
> +               err =3D -errno;
> +               pr_warning("failed to get map info for map FD %d: %s\n",
> +                          map_fd, libbpf_strerror_r(err, msg, sizeof(msg=
)));
> +               return err;
> +       }
> +
> +       if (map_info.type !=3D map->def.type ||
> +           map_info.key_size !=3D map->def.key_size ||
> +           map_info.value_size !=3D map->def.value_size ||
> +           map_info.max_entries !=3D map->def.max_entries ||
> +           map_info.map_flags !=3D map->def.map_flags ||
> +           map_info.btf_key_type_id !=3D map->btf_key_type_id ||
> +           map_info.btf_value_type_id !=3D map->btf_value_type_id)
> +               return 1;
> +
> +       return 0;
> +}
> +
> +static int
> +bpf_object__check_map_reuse(struct bpf_object *obj)


This is not a check, it is an attempt to reuse, so just bpf_object__reuse_m=
aps?

> +{
> +       char *cp, errmsg[STRERR_BUFSIZE];
> +       struct bpf_map *map;
> +       int err;
> +
> +       bpf_object__for_each_map(map, obj) {
> +               int pin_fd;
> +
> +               if (!map->pin_path)
> +                       continue;
> +
> +               pin_fd =3D bpf_obj_get(map->pin_path);
> +               if (pin_fd < 0) {
> +                       if (errno =3D=3D ENOENT)
> +                               continue;
> +
> +                       cp =3D libbpf_strerror_r(errno, errmsg, sizeof(er=
rmsg));
> +                       pr_warning("Couldn't retrieve pinned map '%s': %s=
\n",
> +                                  map->pin_path, cp);
> +                       return pin_fd;
> +               }
> +
> +               if (check_map_compat(map, pin_fd)) {
> +                       pr_warning("Couldn't reuse pinned map at '%s': "
> +                                  "parameter mismatch\n", map->pin_path)=
;

Please don't split strings.

Also, prevalent form of log messages is to start them with lower-cased
words, please keep consistency.




> +                       close(pin_fd);
> +                       return -EINVAL;
> +               }
> +
> +               err =3D bpf_map__reuse_fd(map, pin_fd);
> +               if (err) {
> +                       close(pin_fd);
> +                       return err;
> +               }
> +               map->pinned =3D true;
> +               pr_debug("Reused pinned map at '%s'\n", map->pin_path);
> +       }
> +
> +       return 0;
> +}
> +
>  static int
>  check_btf_ext_reloc_err(struct bpf_program *prog, int err,
>                         void *btf_prog_info, const char *info_name)
> @@ -3664,6 +3772,7 @@ __bpf_object__open(const char *path, const void *ob=
j_buf, size_t obj_buf_sz,
>  {
>         struct bpf_object *obj;
>         const char *obj_name;
> +       bool auto_pin_maps;
>         char tmp_name[64];
>         bool relaxed_maps;
>         int err;
> @@ -3695,11 +3804,13 @@ __bpf_object__open(const char *path, const void *=
obj_buf, size_t obj_buf_sz,
>
>         obj->relaxed_core_relocs =3D OPTS_GET(opts, relaxed_core_relocs, =
false);
>         relaxed_maps =3D OPTS_GET(opts, relaxed_maps, false);
> +       auto_pin_maps =3D OPTS_GET(opts, auto_pin_maps, true);
>
>         CHECK_ERR(bpf_object__elf_init(obj), err, out);
>         CHECK_ERR(bpf_object__check_endianness(obj), err, out);
>         CHECK_ERR(bpf_object__probe_caps(obj), err, out);
> -       CHECK_ERR(bpf_object__elf_collect(obj, relaxed_maps), err, out);
> +       CHECK_ERR(bpf_object__elf_collect(obj, relaxed_maps, auto_pin_map=
s),
> +                 err, out);
>         CHECK_ERR(bpf_object__collect_reloc(obj), err, out);
>
>         bpf_object__elf_finish(obj);
> @@ -3811,6 +3922,7 @@ int bpf_object__load_xattr(struct bpf_object_load_a=
ttr *attr)
>
>         obj->loaded =3D true;
>
> +       CHECK_ERR(bpf_object__check_map_reuse(obj), err, out);
>         CHECK_ERR(bpf_object__create_maps(obj), err, out);
>         CHECK_ERR(bpf_object__relocate(obj, attr->target_btf_path), err, =
out);
>         CHECK_ERR(bpf_object__load_progs(obj, attr->log_level), err, out)=
;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 26a4ed3856e7..d492920fedb3 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -98,8 +98,10 @@ struct bpf_object_open_opts {
>         bool relaxed_maps;
>         /* process CO-RE relocations non-strictly, allowing them to fail =
*/
>         bool relaxed_core_relocs;
> +       /* auto-pin maps with 'pinning' attribute set? */
> +       bool auto_pin_maps;
>  };
> -#define bpf_object_open_opts__last_field relaxed_core_relocs
> +#define bpf_object_open_opts__last_field auto_pin_maps
>
>  LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
>  LIBBPF_API struct bpf_object *
>
