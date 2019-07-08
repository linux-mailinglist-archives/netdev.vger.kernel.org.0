Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3C262131
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbfGHPLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 11:11:37 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:44342 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfGHPLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:11:36 -0400
Received: by mail-vs1-f68.google.com with SMTP id v129so8427569vsb.11;
        Mon, 08 Jul 2019 08:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qSkBAdk5oddBWH4Q77bK0k0/VBqaR/5vSGHDXEvy3Mg=;
        b=Yg1gpVNhkSvcLwybUOoLKF2S1WwFjaI6l060S2PdgedWdRlwmh9jgvrggY7u7mrqeo
         Wx8+0gjT0IhrC2qM1HkVy7Ma7fdnAUbqNJeyizySg3SETmjiPK30ZiC9bMUkMD3URzE7
         oiICrfiI1SL+ZbLKh7MVUV8asbLVPQKCHnDHmXTgV0da458kGp+26T843jIJ4vKCv6JO
         F7ASYTSgPSUPVYBlk4w9f8lX2ooXvwcbcE9q8HWgflyS81NZDzjWGdhW8cyNGdl5XPJl
         mjK4UDRbc2ZKzyBva7WSvAhDs3ZEvDQb3PUeJ0XwuBfUnWt4rj815FTI9lMIUC6162kh
         rh7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qSkBAdk5oddBWH4Q77bK0k0/VBqaR/5vSGHDXEvy3Mg=;
        b=RDaCqm0J+R5V5G7br8Vl4ghq8y3OX115J039bHb8kkDPQKMLgYJ0lk3R0ELDjmLY0w
         PuKNp5NSvQi4G4fbyMTNQdVFXZO3wQ+D4UUVIsxQERuzHWn6cN9uwWvbIb2Oi+gpcQdv
         MC0+S82USK8wPk+pDlhxa+ppPpa4xijXVXMS+aj3S8ugtUzTgGT1Ky0WBrgRRWV5Nisn
         8xUTCEMYujiV5H4NagjcmWoERjyG8Q29WnUq35ifd3SHN6wV3BeSv51T3UqKpLueX29X
         VyEb2YqwOlORAeHk/OyqxmkGYwWcC8Frw5yRlt6Dea7Fp5vdR7iBXMSTqZhKgREGByYH
         VeQA==
X-Gm-Message-State: APjAAAWAygnbaOcazXQhgKHKqHcPknImc5gbSEhqCUNZI8bAJ3eg8U1L
        DJnhNbAwN1VQNkBk8+kv729A22zKPlxCGgvejeKgpodxhU4=
X-Google-Smtp-Source: APXvYqwPepGr97TYpU7TehuCAXGqVyYS9jfuD56GdqWIPRKMWtFRb+MQrh6kmqt0fCsCpeDiPaMSdk/Dr8YGUwvNJZI=
X-Received: by 2002:a67:f7c6:: with SMTP id a6mr10651087vsp.120.1562598695231;
 Mon, 08 Jul 2019 08:11:35 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1562359091.git.a.s.protopopov@gmail.com>
 <e183c0af99056f8ea4de06acb358ace7f3a3d6ae.1562359091.git.a.s.protopopov@gmail.com>
 <734dd45a-95b0-a7fd-9e1d-0535ef4d3e12@iogearbox.net>
In-Reply-To: <734dd45a-95b0-a7fd-9e1d-0535ef4d3e12@iogearbox.net>
From:   Anton Protopopov <a.s.protopopov@gmail.com>
Date:   Mon, 8 Jul 2019 11:11:24 -0400
Message-ID: <CAGn_itzJkW8uR-y92oU+jKKLRsAfsHcqJ+Cm0+KRZxJ-zaqMNA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf, libbpf: add a new API bpf_object__reuse_maps()
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, andriin@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=D0=BF=D1=82, 5 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 17:44, Daniel Borkm=
ann <daniel@iogearbox.net>:
>
> On 07/05/2019 10:44 PM, Anton Protopopov wrote:
> > Add a new API bpf_object__reuse_maps() which can be used to replace all=
 maps in
> > an object by maps pinned to a directory provided in the path argument. =
 Namely,
> > each map M in the object will be replaced by a map pinned to path/M.nam=
e.
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
> > @@ -3144,6 +3144,40 @@ int bpf_object__unpin_maps(struct bpf_object *ob=
j, const char *path)
> >       return 0;
> >  }
> >
> > +int bpf_object__reuse_maps(struct bpf_object *obj, const char *path)
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
> We'd need to skip the case of bpf_map__is_internal(map) since they are al=
ways
> recreated for the given object.
>
> > +             len =3D snprintf(buf, PATH_MAX, "%s/%s", path, bpf_map__n=
ame(map));
> > +             if (len < 0) {
> > +                     return -EINVAL;
> > +             } else if (len >=3D PATH_MAX) {
> > +                     return -ENAMETOOLONG;
> > +             }
> > +
> > +             pinned_map_fd =3D bpf_obj_get(buf);
> > +             if (pinned_map_fd < 0)
> > +                     return pinned_map_fd;
>
> Should we rather have a new map definition attribute that tells to reuse
> the map if it's pinned in bpf fs, and if not, we create it and later on
> pin it? This is what iproute2 is doing and which we're making use of heav=
ily.

What do you think about adding a new generic field, say load_flags,
to the bpf_map_def structure and a particular flag, say LOAD_F_STICKY
for this purpose? And it will be cleared for internal maps, so we will skip
them as well.

> In bpf_object__reuse_maps() bailing out if bpf_obj_get() fails is perhaps
> too limiting for a generic API as new version of an object file may conta=
in
> new maps which are not yet present in bpf fs at that point.

How permissive should it be? Is it ok to just print a warning on any
bpf_obj_get()
failure? Or does it make sense to skip some specific error (ENOENT) and rej=
ect
on other errors?

>
> > +             err =3D bpf_map__reuse_fd(map, pinned_map_fd);
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
> > @@ -82,6 +82,8 @@ int bpf_object__variable_offset(const struct bpf_obje=
ct *obj, const char *name,
> >  LIBBPF_API int bpf_object__pin_maps(struct bpf_object *obj, const char=
 *path);
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
