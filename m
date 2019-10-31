Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB72DEB624
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 18:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbfJaR3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 13:29:03 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45750 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728561AbfJaR3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 13:29:03 -0400
Received: by mail-qk1-f193.google.com with SMTP id q70so7787095qke.12;
        Thu, 31 Oct 2019 10:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2vE6Q8hoiCpttbZaXImFZHeepGGXxgTTCqCZEsY5FGM=;
        b=UZrAgaQNZLM5TRhr13vPs8ZFaVl/07bFQKCUhvyAoRZgyYwUsDHNuuMe3fSLr0Lbgh
         WXDjD2FFeQRQCkFIW4zY/8AndyzUZrHZ0gvOO3431HlKLYThWYTg+T09zNwmCliPS5EQ
         zKu+AbW2aIcpi+iHStPncy7Lz9n5OuAL7qOVkEOdB4jF1qo4BJN3s80oGWa8gJ1uNBlH
         leWRVAKQehauwnrPUi/aRPipDNZG4dYJjm8v8Jt4sVs/GRGMUMVIP1hBMC+A+Ve+BHEU
         6V9Z5GQYVehta4p59N+QYPOaJ+qQtxHlDU/YyBewexU/y1ow6t/M03sIqH0svM5YoE51
         MLQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2vE6Q8hoiCpttbZaXImFZHeepGGXxgTTCqCZEsY5FGM=;
        b=oZRSZ0oySlrnyoqdYvKU8Eh5anyoodpfdPU5JV024mhuH0zxWUSvsuVcDR+3ooQiCa
         IQhkVFarXN2duZY9mk2eqGKqGtANy4ROsU4dfEUg6Re9RC/ox+BRQWMERTSs8rGgMLVy
         NzweazwTLCKbxSyytcpUhhTlwr4vGn+bK/c3/cC9IFb7KCujef9aNVL48kvqhJeuQb+h
         D5KUvlUU4vSANIHyCOqbwEoZys7GkWZv9BmcpIaA0/w5ZAWvmlnI+Tn7UqstuB4EwYl2
         4znE5BPUXEW4kygt3aLOE8Ddbgwmc/VXUexaW7cjGUUUIcRuEoFU0/6fNyWwRzUr9TWV
         zzzw==
X-Gm-Message-State: APjAAAWxaHXu7HKiZwFekz8TWWUK7mFm9QfW2NzxofEYD197i/SG/Aqr
        Jtc1aEQQ6NXeALdkHCkolz76fU2Y5W4zwO5LXRc=
X-Google-Smtp-Source: APXvYqznNkhgT9xTaURmAfSvjtGXJbnV71+D9aGNAK+MKUCZuSbSejCUPWOYr5N20glLnP4QPd4QndcMkl7TaD/ocCQ=
X-Received: by 2002:a37:9a8a:: with SMTP id c132mr6282442qke.92.1572542941683;
 Thu, 31 Oct 2019 10:29:01 -0700 (PDT)
MIME-Version: 1.0
References: <157237796219.169521.2129132883251452764.stgit@toke.dk>
 <157237796448.169521.1399805620810530569.stgit@toke.dk> <CAEf4BzZ4pRLhwX+5Hh1jKsEhBAkrZbC14rBgAVgUt1gf3qJ+KQ@mail.gmail.com>
 <875zk4omg7.fsf@toke.dk>
In-Reply-To: <875zk4omg7.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 31 Oct 2019 10:28:50 -0700
Message-ID: <CAEf4BzaA+XWrmLZGV-G30Uhi4ipFKN5wUgbBYPzPkS2FR5WZBA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/5] libbpf: Store map pin path and status in
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

On Thu, Oct 31, 2019 at 10:26 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Tue, Oct 29, 2019 at 12:39 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
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
> >> The behaviour of bpf_object__{un,}pin_maps() is changed so that if it =
is
> >> called with a NULL path argument (which was previously illegal), it wi=
ll
> >> (un)pin only those maps that have a pin_path set.
> >>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >
> > Looks good, thanks! Just some minor things to fix up below.
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> >
> >>  tools/lib/bpf/libbpf.c   |  164 +++++++++++++++++++++++++++++++++++--=
---------
> >>  tools/lib/bpf/libbpf.h   |    8 ++
> >>  tools/lib/bpf/libbpf.map |    3 +
> >>  3 files changed, 134 insertions(+), 41 deletions(-)
> >>
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index ce5ef3ddd263..fd11f6aeb32c 100644
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
> >> @@ -4025,47 +4027,119 @@ int bpf_map__pin(struct bpf_map *map, const c=
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
> >> +       if (map->pin_path) {
> >> +               if (path && strcmp(path, map->pin_path)) {
> >> +                       pr_warn("map '%s' already has pin path '%s' di=
fferent from '%s'\n",
> >> +                               bpf_map__name(map), map->pin_path, pat=
h);
> >> +                       return -EINVAL;
> >> +               } else if (map->pinned) {
> >> +                       pr_debug("map '%s' already pinned at '%s'; not=
 re-pinning\n",
> >> +                                bpf_map__name(map), map->pin_path);
> >> +                       return 0;
> >> +               }
> >
> > `if (map->pinned)` check is the same in both branches, so I'd do it
> > first, before this map->pin_path if/else.
>
> But it's not. It's debug & return if pin_path is set, and an error
> otherwise.

Ah, right, it did feel weird to duplicate like that :) Ok, never mind then.

>
> Will fix the rest of your nits :)
>
> -Toke
