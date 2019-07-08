Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA24627BB
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 19:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731133AbfGHRy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 13:54:26 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41846 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbfGHRy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 13:54:26 -0400
Received: by mail-qk1-f193.google.com with SMTP id v22so13986429qkj.8;
        Mon, 08 Jul 2019 10:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u4F7C/sV/odeCH+W9PMSNpHsM7J09hRexHDNA3lJNWc=;
        b=XgYD1/u95qUNmWA4XvhmxxBgEdAaBIVnMwRm4+DSEOBZbmdJamzoE+0YkZ4RW20plL
         l7mPfcanv4k/hXnC06/cfo8GKSsDhVNjdD9fljXFsYvHpI/HHRQVbs6PkHdsF7K4j/x0
         eVn/7mH0T012NU+0Cb0MBG93yGNWGgZ9kQ18nfmqPjn5krdmEDRaS527yF/TldrWN698
         FdXOuMY7H32piU8YTMitD+LnlA1CGSvKguzFkJu4Hs3ATX4Oa3IrYOpWe+i1xQz3KWa4
         CU13m0knRWeDbwy6I1fqYTZh22Lk1K+HoicaItk97fcf3LeERFT/j/W7gHiov2P8zgNt
         QSmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u4F7C/sV/odeCH+W9PMSNpHsM7J09hRexHDNA3lJNWc=;
        b=tnUih2wTsCXloQosXGNvLpWNqPtAtItRgiSfuaPJErfzJt0nw5dB3pP35noXxT6NC5
         tF4qn38LI4dEsbsJnV1g2whES4TTDasGGdPdDpToTQZ1WDDvSk1yjLZ2NaT6gS20iWBC
         s90fF98MPP3+whlolysTeuN/ehLRCzyxTDcao8ARGgetruXglBKnfq8Zd3TjkVbgBL7r
         lV90KFH8UEX8XDrYdal2L6XqCqrsHPn91oWlPSON6OSvQc579DS5wjtQrV7S0y7uxMoH
         9hqlUjkB0XbjFVrZOYKQi+HX/Z0ZlTLKqtUFsSyOWtOKBJ2AanfwPJ/2YDXUFwuoxpma
         R9eQ==
X-Gm-Message-State: APjAAAXr4OPT2X3YKjTssMidsyeLhZanWhPc4A9+8qmA70nUGNc9TPbG
        ++0SyELZ3crioiyvT1u6x09ZYQJfwj5unGWxV6M=
X-Google-Smtp-Source: APXvYqyQ45p40cTwBps+eik6OzNyUlDBNZXh1tfc4f5IiVk6V7Vmbj9v0jH5hkQF+F9w/LQgGBst9wOgU7+dlp1u0vA=
X-Received: by 2002:a37:9b48:: with SMTP id d69mr13551030qke.449.1562608464860;
 Mon, 08 Jul 2019 10:54:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1562359091.git.a.s.protopopov@gmail.com>
 <e183c0af99056f8ea4de06acb358ace7f3a3d6ae.1562359091.git.a.s.protopopov@gmail.com>
 <734dd45a-95b0-a7fd-9e1d-0535ef4d3e12@iogearbox.net>
In-Reply-To: <734dd45a-95b0-a7fd-9e1d-0535ef4d3e12@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Jul 2019 10:54:13 -0700
Message-ID: <CAEf4BzaGGVv2z8jB8MnT7=gnn4nG0cp7DGYxfnnnpohOT=ujCA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf, libbpf: add a new API bpf_object__reuse_maps()
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Anton Protopopov <a.s.protopopov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 5, 2019 at 2:53 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 07/05/2019 10:44 PM, Anton Protopopov wrote:
> > Add a new API bpf_object__reuse_maps() which can be used to replace all maps in
> > an object by maps pinned to a directory provided in the path argument.  Namely,
> > each map M in the object will be replaced by a map pinned to path/M.name.
> >
> > Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
> > ---
> >  tools/lib/bpf/libbpf.c   | 34 ++++++++++++++++++++++++++++++++++
> >  tools/lib/bpf/libbpf.h   |  2 ++
> >  tools/lib/bpf/libbpf.map |  1 +
> >  3 files changed, 37 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 4907997289e9..84c9e8f7bfd3 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -3144,6 +3144,40 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
> >       return 0;
> >  }
> >
> > +int bpf_object__reuse_maps(struct bpf_object *obj, const char *path)

As is, bpf_object__reuse_maps() can be easily implemented by user
applications, as it's only using public libbpf APIs, so I'm not 100%
sure we need to add method like that to libbpf.

> > +{
> > +     struct bpf_map *map;
> > +
> > +     if (!obj)
> > +             return -ENOENT;
> > +
> > +     if (!path)
> > +             return -EINVAL;
> > +
> > +     bpf_object__for_each_map(map, obj) {
> > +             int len, err;
> > +             int pinned_map_fd;
> > +             char buf[PATH_MAX];
>
> We'd need to skip the case of bpf_map__is_internal(map) since they are always
> recreated for the given object.
>
> > +             len = snprintf(buf, PATH_MAX, "%s/%s", path, bpf_map__name(map));
> > +             if (len < 0) {
> > +                     return -EINVAL;
> > +             } else if (len >= PATH_MAX) {
> > +                     return -ENAMETOOLONG;
> > +             }
> > +
> > +             pinned_map_fd = bpf_obj_get(buf);
> > +             if (pinned_map_fd < 0)
> > +                     return pinned_map_fd;
>
> Should we rather have a new map definition attribute that tells to reuse
> the map if it's pinned in bpf fs, and if not, we create it and later on
> pin it? This is what iproute2 is doing and which we're making use of heavily.

I'd like something like that as well. This would play nicely with
recently added BTF-defined maps as well.

I think it should be not just pin/don't pin flag, but rather pinning
strategy, to accommodate various typical strategies of handling maps
that are already pinned. So something like this:

1. BPF_PIN_NOTHING - default, don't pin;
2. BPF_PIN_EXCLUSIVE - pin, but if map is already pinned - fail;
3. BPF_PIN_SET - pin; if existing map exists, reset its state to be
exact state of object's map;
4. BPF_PIN_MERGE - pin, if map exists, fill in NULL entries only (this
is how Cilium is pinning PROG_ARRAY maps, if I understand correctly);
5. BPF_PIN_MERGE_OVERWRITE - pin, if map exists, overwrite non-NULL values.

This list is only for illustrative purposes, ideally people that have
a lot of experience using pinning for real-world use cases would chime
in on what strategies are useful and make sense.

> In bpf_object__reuse_maps() bailing out if bpf_obj_get() fails is perhaps
> too limiting for a generic API as new version of an object file may contain
> new maps which are not yet present in bpf fs at that point.
>
> > +             err = bpf_map__reuse_fd(map, pinned_map_fd);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> >  int bpf_object__pin_programs(struct bpf_object *obj, const char *path)
> >  {
> >       struct bpf_program *prog;
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index d639f47e3110..7fe465a1be76 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -82,6 +82,8 @@ int bpf_object__variable_offset(const struct bpf_object *obj, const char *name,
> >  LIBBPF_API int bpf_object__pin_maps(struct bpf_object *obj, const char *path);
> >  LIBBPF_API int bpf_object__unpin_maps(struct bpf_object *obj,
> >                                     const char *path);
> > +LIBBPF_API int bpf_object__reuse_maps(struct bpf_object *obj,
> > +                                   const char *path);
> >  LIBBPF_API int bpf_object__pin_programs(struct bpf_object *obj,
> >                                       const char *path);
> >  LIBBPF_API int bpf_object__unpin_programs(struct bpf_object *obj,
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index 2c6d835620d2..66a30be6696c 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -172,5 +172,6 @@ LIBBPF_0.0.4 {
> >               btf_dump__new;
> >               btf__parse_elf;
> >               bpf_object__load_xattr;
> > +             bpf_object__reuse_maps;
> >               libbpf_num_possible_cpus;
> >  } LIBBPF_0.0.3;
> >
>
