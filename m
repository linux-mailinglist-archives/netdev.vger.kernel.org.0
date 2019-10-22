Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20C7AE0B5E
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731984AbfJVSXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:23:33 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45383 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729635AbfJVSXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:23:33 -0400
Received: by mail-qt1-f194.google.com with SMTP id c21so28176802qtj.12;
        Tue, 22 Oct 2019 11:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZZA7sboU1AxCdHS2tGC5JU25NVdGFs1CRDqbNhtwfls=;
        b=W0P97ZMM7uOJnHU7ajBA26LKVRGQInB9SvCm9ovu8INvk3UDR8vqe4PnJYiE/5gQ44
         VRJRv9OI8p/v0AmrncLuui5h3Gc/QdGR0C3pQ8Yuef7pSh16//pMx0ONHNfkwG8neG6G
         q2j0heY1INg+WrAROzIHZuY9vKN1bCtrI50783fXMtlEE1RJmhnQIQgATlFV5oCjriGL
         VIpfYFWpWw3AkTuzQel+6NNl6J50xzSUe8CxjFg0LYOPznRj2zv+10u3QG/h35CNllyg
         eQARTJKWoAJSWU89YsOQuzW8+nI7j3ExVy5l0n8/cXKJUgZeiJF6i9MPmXbMg9vDG4r/
         /Ztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZZA7sboU1AxCdHS2tGC5JU25NVdGFs1CRDqbNhtwfls=;
        b=qedWArBKFkjgoXhGTnMQYOAd8d2L1GUDxyNfK6NSuEanKlVNvGJ8qqNitRBh3YTGLU
         6NvG4OXpWTtkwK6uc927xi/KuIk/hzmSwhB2OASJjVqV0GsEm28HeMEMtHWSOpz1Qw5X
         Mjd8KPxeHs7NXXOtwvhO3oY1cQmPrJz/QL3k9mduOnpax+VoBGkQ8XEhAcqwFDW5CVE7
         1zdvPnOWSu4BYbT80zk26l6KHPKLrpTptTunVsg5dAGfhYK01PXAHa7+q/ZweNxFVLrp
         a6obdJ3AhnCjfCKXGSB/nBa9p+jN6AhStXJdq0wJtaxaAJ8T0SG8t0r8VF8aDze3pMfQ
         B0BQ==
X-Gm-Message-State: APjAAAVl1bR02mvWZr1OScMKsd/cwUehyQdH8PWLAfBScwP9UJEPpUJK
        hQqt73T6TiBfdUG1wYHGW0/POR321fZTkbxPe3g=
X-Google-Smtp-Source: APXvYqxJu7nL2mRMqwZiZtSSXx/bvKn6e6vMGzoQ2LnTXEPG1X2KOyvG22cJYdtZEkTxX975sAJyDqB269mB/zGx43g=
X-Received: by 2002:ac8:108e:: with SMTP id a14mr4821407qtj.171.1571768610911;
 Tue, 22 Oct 2019 11:23:30 -0700 (PDT)
MIME-Version: 1.0
References: <157175668770.112621.17344362302386223623.stgit@toke.dk>
 <157175668879.112621.10917994557478417780.stgit@toke.dk> <CAEf4BzatAgkOiS2+EpauWsUWymmjM4YRBJcSqYj15Ywk8aP6Lw@mail.gmail.com>
 <87blu8odhf.fsf@toke.dk>
In-Reply-To: <87blu8odhf.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Oct 2019 11:23:20 -0700
Message-ID: <CAEf4BzapbVb=u_GPLSv-KEctwZz=K3FUb_B6p2HmWnqz06n4Rg@mail.gmail.com>
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

On Tue, Oct 22, 2019 at 11:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Tue, Oct 22, 2019 at 9:08 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>
> >> When pinning a map, store the pin path in struct bpf_map so it can be
> >> re-used later for un-pinning. This simplifies the later addition of pe=
r-map
> >> pin paths.
> >>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >>  tools/lib/bpf/libbpf.c |   19 ++++++++++---------
> >>  1 file changed, 10 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index cccfd9355134..b4fdd8ee3bbd 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -226,6 +226,7 @@ struct bpf_map {
> >>         void *priv;
> >>         bpf_map_clear_priv_t clear_priv;
> >>         enum libbpf_map_type libbpf_type;
> >> +       char *pin_path;
> >>  };
> >>
> >>  struct bpf_secdata {
> >> @@ -1929,6 +1930,7 @@ int bpf_map__reuse_fd(struct bpf_map *map, int f=
d)
> >>         if (err)
> >>                 goto err_close_new_fd;
> >>         free(map->name);
> >> +       zfree(&map->pin_path);
> >>
> >
> > While you are touching this function, can you please also fix error
> > handling in it? We should store -errno locally on error, before we
> > call close() which might change errno.
>
> Didn't actually look much at the surrounding function, TBH. I do expect
> that I will need to go poke into this for the follow-on "automatic reuse
> of pinned maps" series anyway. But sure, I can do a bit of cleanup in a
> standalone patch first :)
>
> >>         map->fd =3D new_fd;
> >>         map->name =3D new_name;
> >> @@ -4022,6 +4024,7 @@ int bpf_map__pin(struct bpf_map *map, const char=
 *path)
> >>                 return -errno;
> >>         }
> >>
> >> +       map->pin_path =3D strdup(path);
> >
> > if (!map->pin_path) {
> >     err =3D -errno;
> >     goto err_close_new_fd;
> > }
>
> Right.
>
> >>         pr_debug("pinned map '%s'\n", path);
> >>
> >>         return 0;
> >> @@ -4031,6 +4034,9 @@ int bpf_map__unpin(struct bpf_map *map, const ch=
ar *path)
> >>  {
> >>         int err;
> >>
> >> +       if (!path)
> >> +               path =3D map->pin_path;
> >
> > This semantics is kind of weird. Given we now remember pin_path,
> > should we instead check that user-provided path is actually correct
> > and matches what we stored? Alternatively, bpf_map__unpin() w/o path
> > argument looks like a cleaner API.
>
> Yeah, I guess the function without a path argument would make the most
> sense. However, we can't really change the API of bpf_map__unpin()
> (unless you're proposing a symbol-versioned new version?). Dunno if it's
> worth it to include a new, somewhat oddly-named, function to achieve
> this? For the internal libbpf uses at least it's easy enough for the
> caller to just go bpf_map__unpin(map, map->pin_path), so I could also
> just drop this change? WDYT?

I'd probably do strcmp(map->pin_path, path), if path is specified.
This will support existing use cases, will allow NULL if we don't want
to bother remembering pin_path, will prevent weird use case of pinning
to one path, but unpinning another one.

Ideally, all this pinning will just be done declaratively and will
happen automatically, so users won't even have to know about this API
:)

>
> -Toke
