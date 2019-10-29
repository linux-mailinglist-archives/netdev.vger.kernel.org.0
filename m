Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4012E8EEB
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730575AbfJ2SC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:02:56 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42933 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbfJ2SC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 14:02:56 -0400
Received: by mail-qt1-f196.google.com with SMTP id z17so14895205qts.9;
        Tue, 29 Oct 2019 11:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nqN7/d5c7fE9UI7071ueTALra9tllnzGEEUiWvS/Suw=;
        b=qmYPDDjoi+3dI3oIZvuvEnoeifWa2k/gihY1KX030hS8Ib6DlabrN0Ct0PVQ+dafrZ
         burgm+WaY7gMlFqOiBQwqphBF9uzcfjIt6bKeoknX86xdmc5F+5xy0aW0AzR75LlMKQa
         ic+PWhLYsuuud666rOG3t+O28dEnu58l1JZunxngOL1+x4zSJFnPCopBue8gYrEKerM0
         aS99RDUNaqDhyrntuM2cRJm9zYkHN7GASnLNNjN+fjjiwSR9SD6PYWaKWRzNgUfSvSY6
         ycQtmG/DSlGy8yaN8k45rONClA/BrtfgkQfbevnmocxtK60zdx7u2t4jEqLaD4l0KIS9
         /fGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nqN7/d5c7fE9UI7071ueTALra9tllnzGEEUiWvS/Suw=;
        b=cV5W2ocn8T2R7cZTtOti2n6ZH0bwlxR2+1QVC3kFCYxc7xeJxRPv6M3GXpwtJ8lKRI
         sSbR+k0jUdLaear93yXsQ/EaIvxbAe1qENwn643ux22ERtbY5nf51Pa10e/6e6x+0G29
         Qu7iGi7j+yVDQ2JuIe4JkpdGsFMh1Hd/eFzt+Grmk+xv3YW+ZW8y4dROvfDnO7KcpcX6
         4PwMbLNI2JWPaPUz8pobMjA3OTg35hdZib3bP1Kqfe47TYLQsBiIvnUNUElZPZW1OLAi
         wi5QDCUzksqU+uFwNA+u/JDejKIPoerH6zqdBV9AVzHUqJpzi9TbWTrJdDBSTlzKmgnS
         wvxQ==
X-Gm-Message-State: APjAAAV4Tb7d+DVCa1uvzaSCpvzpmUpIYymhoxb0YKQ6Dfr78ZpqLA3w
        KLDS7+ae/xKEKNHQUQjpP0vmdIvS304Xxh2+Cec=
X-Google-Smtp-Source: APXvYqw4UetD7eur+XvGP+ltnkiZfdV3+Y7tycUSGtEQrqpAT94gkbdxHMrityKo0YlsPFqD7FaaSYhSBPS7IQFWLNI=
X-Received: by 2002:ac8:199d:: with SMTP id u29mr254494qtj.93.1572372173461;
 Tue, 29 Oct 2019 11:02:53 -0700 (PDT)
MIME-Version: 1.0
References: <157220959547.48922.6623938299823744715.stgit@toke.dk>
 <157220959765.48922.14916417301812812065.stgit@toke.dk> <CAEf4Bzb-CewiZhsGEmSNSCGHLKQiXFO3gS+cJgD1Tx_L_gpiMg@mail.gmail.com>
 <87a79krkma.fsf@toke.dk>
In-Reply-To: <87a79krkma.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 29 Oct 2019 11:02:42 -0700
Message-ID: <CAEf4Bzb_FdXRo-LcgpjDqPe78hZoUkQsKZZET3HM-vZWc5SYZg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/4] libbpf: Store map pin path and status in
 struct bpf_map
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

On Tue, Oct 29, 2019 at 2:01 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Sun, Oct 27, 2019 at 1:53 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>
> >> Support storing and setting a pin path in struct bpf_map, which can be=
 used
> >> for automatic pinning. Also store the pin status so we can avoid attem=
pts
> >> to re-pin a map that has already been pinned (or reused from a previou=
s
> >> pinning).
> >>
> >> Acked-by: Andrii Nakryiko <andriin@fb.com>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >>  tools/lib/bpf/libbpf.c   |  115 ++++++++++++++++++++++++++++++++++++-=
---------
> >>  tools/lib/bpf/libbpf.h   |    3 +
> >>  tools/lib/bpf/libbpf.map |    3 +
> >>  3 files changed, 97 insertions(+), 24 deletions(-)
> >>
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index ce5ef3ddd263..eb1c5e6ad4a3 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -226,6 +226,8 @@ struct bpf_map {
> >>         void *priv;
> >>         bpf_map_clear_priv_t clear_priv;
> >>         enum libbpf_map_type libbpf_type;
> >> +       char *pin_path;
> >> +       bool pinned;
> >>  };
> >>
> >>  struct bpf_secdata {
> >> @@ -4025,47 +4027,118 @@ int bpf_map__pin(struct bpf_map *map, const c=
har *path)
> >>         char *cp, errmsg[STRERR_BUFSIZE];
> >>         int err;
> >>
> >> -       err =3D check_path(path);
> >> -       if (err)
> >> -               return err;
> >> -
> >>         if (map =3D=3D NULL) {
> >>                 pr_warn("invalid map pointer\n");
> >>                 return -EINVAL;
> >>         }
> >>
> >> -       if (bpf_obj_pin(map->fd, path)) {
> >> -               cp =3D libbpf_strerror_r(errno, errmsg, sizeof(errmsg)=
);
> >> -               pr_warn("failed to pin map: %s\n", cp);
> >> -               return -errno;
> >> +       if (map->pinned) {
> >> +               pr_warn("map already pinned\n");
> >
> > it would be helpful to print the name of the map, otherwise user will
> > have to guess
>
> Well, the existing error message didn't include the map name, so I was
> just being consistent. But sure I can change it (and the old message as
> well).
>
> >> +               return -EEXIST;
> >> +       }
> >> +
> >> +       if (path && map->pin_path && strcmp(path, map->pin_path)) {
> >> +               pr_warn("map already has pin path '%s' different from =
'%s'\n",
> >> +                       map->pin_path, path);
> >
> > here pin_path probably would be unique enough, but for consistency we
> > might want to print map name as well
> >
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       if (!map->pin_path && !path) {
> >> +               pr_warn("missing pin path\n");
> >
> > and here?
> >
> >> +               return -EINVAL;
> >>         }
> >>
> >> -       pr_debug("pinned map '%s'\n", path);
> >> +       if (!map->pin_path) {
> >> +               map->pin_path =3D strdup(path);
> >> +               if (!map->pin_path) {
> >> +                       err =3D -errno;
> >> +                       goto out_err;
> >> +               }
> >> +       }
> >
> > There is a bit of repetition of if conditions, based on whether we
> > have map->pin_path set (which is the most critical piece we care
> > about), so that makes it a bit harder to follow what's going on. How
> > about this structure, would it make a bit clearer what the error
> > conditions are? Not insisting, though.
> >
> > if (map->pin_path) {
> >   if (path && strcmp(...))
> >     bad, exit
> > else { /* no pin_path */
> >   if (!path)
> >     very bad, exit
> >   map->pin_path =3D strdup(..)
> >   if (!map->pin_path)
> >     also bad, exit
> > }
>
> Hmm, yeah, this may be better...
>
> >> +
> >> +       err =3D check_path(map->pin_path);
> >> +       if (err)
> >> +               return err;
> >> +
> >
> > [...]
> >
> >>
> >> +int bpf_map__set_pin_path(struct bpf_map *map, const char *path)
> >> +{
> >> +       char *old =3D map->pin_path, *new;
> >> +
> >> +       if (path) {
> >> +               new =3D strdup(path);
> >> +               if (!new)
> >> +                       return -errno;
> >> +       } else {
> >> +               new =3D NULL;
> >> +       }
> >> +
> >> +       map->pin_path =3D new;
> >> +       if (old)
> >> +               free(old);
> >
> > you don't really need old, just free map->pin_path before setting it
> > to new. Also assigning new =3D NULL will simplify if above.
>
> Right, will fix.
>
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +const char *bpf_map__get_pin_path(struct bpf_map *map)
> >> +{
> >> +       return map->pin_path;
> >> +}
> >> +
> >> +bool bpf_map__is_pinned(struct bpf_map *map)
> >> +{
> >> +       return map->pinned;
> >> +}
> >> +
> >>  int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
> >>  {
> >>         struct bpf_map *map;
> >> @@ -4106,17 +4179,10 @@ int bpf_object__pin_maps(struct bpf_object *ob=
j, const char *path)
> >
> > I might have missed something the change in some other patch, but
> > shouldn't pin_maps ignore already pinned maps? Otherwise we'll be
> > generating unnecessary warnings?
>
> Well, in the previous version this was in one of the options you didn't
> like. If I just change pin_maps() unconditionally, that will be a change
> in behaviour in an existing API. So I figured it would be better to
> leave this as-is. I don't think this function is really useful along
> with the auto-pinning anyway. If you're pinning all maps, why use
> auto-pinning? And if you want to do something custom to all the
> non-pinned maps you'd probably iterate through them yourself anyway and
> can react appropriately?

Auto-pinned maps didn't exist before, so interaction between
auto-pinned and explicitly pinned maps is a new behavior.

With current code using explicit pin_maps and auto-pinned maps is
impossible, or am I missing something? While admittedly scenarios in
which you'll have to use explicit bpf_object__pin_maps() while you
have auto-pinned maps and bpf_map__set_pin_path() are quite exotic
(e.g., auto-pin some maps at default path and pin all the rest at some
other custom root), I think we should still try to make existing APIs
combinable in some sane way.

The only downside of ignoring already pinned maps is that while
previously calling pin_maps() twice in a row would fail fails second
time, now the second pin_maps() will be a noop. I think that's benign
and acceptable change in behavior? WDYT?

>
> >>
> >>  err_unpin_maps:
> >>         while ((map =3D bpf_map__prev(map, obj))) {
> >> -               char buf[PATH_MAX];
> >> -               int len;
> >> -
> >> -               len =3D snprintf(buf, PATH_MAX, "%s/%s", path,
> >> -                              bpf_map__name(map));
> >> -               if (len < 0)
> >> -                       continue;
> >> -               else if (len >=3D PATH_MAX)
> >> +               if (!map->pin_path)
> >>                         continue;
> >>
> >> -               bpf_map__unpin(map, buf);
> >> +               bpf_map__unpin(map, NULL);
> >
> > so this will unpin auto-pinned maps (from BTF-defined maps). Is that
> > the desired behavior? I guess it might be ok (if you can't pin all of
> > your maps, you should probably clean all of them up?), but just
> > bringing it up.
>
> Yeah, I realise that. Not entirely sure it's the right thing to do, but
> there not really any way to disambiguate how the map was pinned; unless
> we want to add another state field just for that? So I guess it's either
> "don't do any cleanup" or just "unpin everything". And since I don't
> think it'll be terribly useful to combine the use of this function with
> auto-pinning anyway, I think it's probably fine to just unpin everything
> here?

Yeah, I think all-or-nothing regarding pinning is ok behavior. It
would be strange to have BPF application which is fine with only some
of maps to be pinned.

>
> -Toke
