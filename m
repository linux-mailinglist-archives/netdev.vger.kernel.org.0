Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9C7E1128
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 06:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732161AbfJWEny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 00:43:54 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34684 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731061AbfJWEny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 00:43:54 -0400
Received: by mail-qt1-f196.google.com with SMTP id e14so10662352qto.1;
        Tue, 22 Oct 2019 21:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RHycZiEaHcuFesktKBObsZI+gqKiji2X2wOUb3oHi78=;
        b=C/1hpcy6VAVCyYoAsEZnYyCe5GuLQaV4ziYk5hXqqbFOflbSUxx+0ZpDHtdNwbHh1L
         WP0kOS2mnYvP6m7cAWLCDFbzm0Z3VGOU/tgVtz2g9UILQx0B7+KeuXM/NL/MghayNzNf
         ziRp/uJb94FWtYSWprkZeIlHAO0qrYaCEszkPnon9dlttRZy2CFoQsbK0B6J6vS+c5Um
         nhE6BQaMhFT1lOGkUMSHgHtk45tK1Trgu18GBeUw0B2i4g1946OH3xybVATeMJXA7HZC
         M53EjpEFzX6V0rju+2yNpwLj0hHCCTDp7xh3uPEPqLaXn8LTHA8gICD4HK9NAqt1Ha/f
         yDGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RHycZiEaHcuFesktKBObsZI+gqKiji2X2wOUb3oHi78=;
        b=qHXB6wuvjurMUnqU6s9Ai/ci3KB8QPpwfwojyGif74RLo4fRhYUkTVEDhYg/5y20sO
         RVsnT5Dy6RvcW9hWBfZTTszSxwnmAC6dAJUKj8u1YHXql/MJceqhM77ut4PGfiukeyXQ
         1zWVrcS4PsA3EpL+qB/zJaM6J3aE/aGUrLvyH8XO+L46W7SBuMQ2Y5eWo2OtIrKug12E
         dHSS2ejXufV7rIdsEenM/spzSYubiGgcPxnpnFWba7fFHLRhB9d/OSqlzITmtCOzUnbv
         usTf3IftDtd47NPKdJ/SS08z/x+2bZlIqaSEeHNh1azsfuFJQDy6WK3bfKpV0eh9Lkqj
         mPQw==
X-Gm-Message-State: APjAAAV+jAmCHAIWR1HluvyM6BRJYxth2PF9YqnFEY/c7RVnpaBuH/Ow
        xjnb3oYp5fIGYdgUugGd/PXWzRq5BUzrC6UYAwgVS+EtoIQ=
X-Google-Smtp-Source: APXvYqzILeJals3LZXxE3Zv8mn8wBl+QK9Q8DZ2MYikbIeG2ij0jV9p/UdpBMVOmW+GiIVCUbHZYtNaIqdVZ+uknOqs=
X-Received: by 2002:ac8:4a03:: with SMTP id x3mr1597877qtq.117.1571805833201;
 Tue, 22 Oct 2019 21:43:53 -0700 (PDT)
MIME-Version: 1.0
References: <157175668770.112621.17344362302386223623.stgit@toke.dk>
 <157175668879.112621.10917994557478417780.stgit@toke.dk> <CAEf4BzatAgkOiS2+EpauWsUWymmjM4YRBJcSqYj15Ywk8aP6Lw@mail.gmail.com>
 <87blu8odhf.fsf@toke.dk> <CAEf4BzapbVb=u_GPLSv-KEctwZz=K3FUb_B6p2HmWnqz06n4Rg@mail.gmail.com>
 <878spcoc0i.fsf@toke.dk> <CAEf4BzboV_84iZNf8HnAOOU=jDnC8+5pYaPDsQUAfV-oGc_4fg@mail.gmail.com>
 <87zhhsmwg7.fsf@toke.dk>
In-Reply-To: <87zhhsmwg7.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Oct 2019 21:43:42 -0700
Message-ID: <CAEf4BzYyo8+xkVwWHZP66fsU2Ve8XrMFFHFzbNE6LGFQxPaEOw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: Store map pin path in struct bpf_map
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

On Tue, Oct 22, 2019 at 12:06 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Tue, Oct 22, 2019 at 11:45 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Tue, Oct 22, 2019 at 11:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
> >> >>
> >> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >> >>
> >> >> > On Tue, Oct 22, 2019 at 9:08 AM Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@redhat.com> wrote:
> >> >> >>
> >> >> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >> >>
> >> >> >> When pinning a map, store the pin path in struct bpf_map so it c=
an be
> >> >> >> re-used later for un-pinning. This simplifies the later addition=
 of per-map
> >> >> >> pin paths.
> >> >> >>
> >> >> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com=
>
> >> >> >> ---
> >> >> >>  tools/lib/bpf/libbpf.c |   19 ++++++++++---------
> >> >> >>  1 file changed, 10 insertions(+), 9 deletions(-)
> >> >> >>
> >> >> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> >> >> index cccfd9355134..b4fdd8ee3bbd 100644
> >> >> >> --- a/tools/lib/bpf/libbpf.c
> >> >> >> +++ b/tools/lib/bpf/libbpf.c
> >> >> >> @@ -226,6 +226,7 @@ struct bpf_map {
> >> >> >>         void *priv;
> >> >> >>         bpf_map_clear_priv_t clear_priv;
> >> >> >>         enum libbpf_map_type libbpf_type;
> >> >> >> +       char *pin_path;
> >> >> >>  };
> >> >> >>
> >> >> >>  struct bpf_secdata {
> >> >> >> @@ -1929,6 +1930,7 @@ int bpf_map__reuse_fd(struct bpf_map *map,=
 int fd)
> >> >> >>         if (err)
> >> >> >>                 goto err_close_new_fd;
> >> >> >>         free(map->name);
> >> >> >> +       zfree(&map->pin_path);
> >> >> >>
> >> >> >
> >> >> > While you are touching this function, can you please also fix err=
or
> >> >> > handling in it? We should store -errno locally on error, before w=
e
> >> >> > call close() which might change errno.
> >> >>
> >> >> Didn't actually look much at the surrounding function, TBH. I do ex=
pect
> >> >> that I will need to go poke into this for the follow-on "automatic =
reuse
> >> >> of pinned maps" series anyway. But sure, I can do a bit of cleanup =
in a
> >> >> standalone patch first :)
> >> >>
> >> >> >>         map->fd =3D new_fd;
> >> >> >>         map->name =3D new_name;
> >> >> >> @@ -4022,6 +4024,7 @@ int bpf_map__pin(struct bpf_map *map, cons=
t char *path)
> >> >> >>                 return -errno;
> >> >> >>         }
> >> >> >>
> >> >> >> +       map->pin_path =3D strdup(path);
> >> >> >
> >> >> > if (!map->pin_path) {
> >> >> >     err =3D -errno;
> >> >> >     goto err_close_new_fd;
> >> >> > }
> >> >>
> >> >> Right.
> >> >>
> >> >> >>         pr_debug("pinned map '%s'\n", path);
> >> >> >>
> >> >> >>         return 0;
> >> >> >> @@ -4031,6 +4034,9 @@ int bpf_map__unpin(struct bpf_map *map, co=
nst char *path)
> >> >> >>  {
> >> >> >>         int err;
> >> >> >>
> >> >> >> +       if (!path)
> >> >> >> +               path =3D map->pin_path;
> >> >> >
> >> >> > This semantics is kind of weird. Given we now remember pin_path,
> >> >> > should we instead check that user-provided path is actually corre=
ct
> >> >> > and matches what we stored? Alternatively, bpf_map__unpin() w/o p=
ath
> >> >> > argument looks like a cleaner API.
> >> >>
> >> >> Yeah, I guess the function without a path argument would make the m=
ost
> >> >> sense. However, we can't really change the API of bpf_map__unpin()
> >> >> (unless you're proposing a symbol-versioned new version?). Dunno if=
 it's
> >> >> worth it to include a new, somewhat oddly-named, function to achiev=
e
> >> >> this? For the internal libbpf uses at least it's easy enough for th=
e
> >> >> caller to just go bpf_map__unpin(map, map->pin_path), so I could al=
so
> >> >> just drop this change? WDYT?
> >> >
> >> > I'd probably do strcmp(map->pin_path, path), if path is specified.
> >> > This will support existing use cases, will allow NULL if we don't wa=
nt
> >> > to bother remembering pin_path, will prevent weird use case of pinni=
ng
> >> > to one path, but unpinning another one.
> >>
> >> So something like
> >>
> >> if (path && map->pin_path && strcmp(path, map->pin_path))
> >
> > can we unpin not pinned map? sounds like an error condition?
>
> See my other comment about programs exiting. For an example, see the XDP
> tutorial (just pretend for a moment that that TODO comment was actually
> there :)):

replied about re-pinning/sharing, that should come from map definition
anyways and should be handled by map sharing/reuse code, so I think we
should be good there.

>
> https://github.com/xdp-project/xdp-tutorial/blob/master/basic04-pinning-m=
aps/xdp_loader.c#L135

For the clean up use case, if we pinned map, we have its pin_path
stored, and can unpin. For rare case where we want unconditionally
"unpin" map, why app can't just delete the file, if app is so smart as
to know pin path of some other app's map ;)

>
> -Toke
