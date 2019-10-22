Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6247E0BD0
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732728AbfJVStW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:49:22 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35429 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732615AbfJVStW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:49:22 -0400
Received: by mail-qk1-f196.google.com with SMTP id w2so17277162qkf.2;
        Tue, 22 Oct 2019 11:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aAl67v506EAn6eOjEoUc8UhObXGSiWkv9o7O+CZplcU=;
        b=vPRG/4VHYu0FTZ6I57SnB4hUVffvcLL8ftAechkICkkkq1ihw8dTZLJSQGiiPE/6Ot
         nec6OQKQx6oqEhSCcONVnng7Cl47TsXRBPSgC5XnmxFJBbQFC/pNqcF4KBKR/dhTxvt+
         3M8MyMIwXfHUSgw8QDILhEEjsI2NufPc30GQKZfLAIrOAFQd6BW9CFO9Y5LPvvcUju9B
         VRwXPyf0iAK9hA67POrVqLt+BZqh6llYM6TOiaa0EhZgfsGJCEsaMSvAlRM5ViRq4MKX
         WPuilTk0qQ3rv9N4rmHdlj+cI0tz7hGDlNdGO4ZO4wtdgv/39B5JT7AyFfPL+V6PMSnf
         bfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aAl67v506EAn6eOjEoUc8UhObXGSiWkv9o7O+CZplcU=;
        b=ocu+Knp5lss7EstAoaayI3bAwk5MTvDyJ0OfjrRRKksIU+L+QNxnSA1Dhzhb6nq9lc
         XML5DwuN6o3oRXZTY47TntxPBH2K0JdrrkQX7Hh/r9WOOdGuX5aNf4zYFFrhGw79wy1E
         yiuB+Snghjuxh8kRC1c7yhGE45JJMG9RL7QDwMz0j7Nbnr5LcsjM1tusxzJNN0vwjHJm
         Caw50OKmy0HPjlOZINU2BvuQjdaya70K9waU6LrWoqEZJpbgnq1oIMJiK5rX8PTBIove
         q41uVCZ4cdeIbGLGxWRntvwNWHeXDimsNt5aTMfWD2gOmmmi8EEjc6ihU+MFTTqOEyy2
         ikpw==
X-Gm-Message-State: APjAAAWN8moDi2r9eK8Fwv8z4ycvM6ThrOIo0TpzluU8MBJjLgrLjHr+
        bRFI1FAvdrWbxzHq/YG6BYE0hkdCEVXNlykO4xI=
X-Google-Smtp-Source: APXvYqzzLWEPb1aaim09mruCdy+QU4HjDa2BK4rdeGI7p68EOyOF4aduiI/BiNOb8Mva4XFvn+ev7hX8tdc/zPwdntY=
X-Received: by 2002:a37:4c13:: with SMTP id z19mr4703665qka.449.1571770161198;
 Tue, 22 Oct 2019 11:49:21 -0700 (PDT)
MIME-Version: 1.0
References: <157175668770.112621.17344362302386223623.stgit@toke.dk>
 <157175668879.112621.10917994557478417780.stgit@toke.dk> <CAEf4BzatAgkOiS2+EpauWsUWymmjM4YRBJcSqYj15Ywk8aP6Lw@mail.gmail.com>
 <87blu8odhf.fsf@toke.dk> <CAEf4BzapbVb=u_GPLSv-KEctwZz=K3FUb_B6p2HmWnqz06n4Rg@mail.gmail.com>
 <878spcoc0i.fsf@toke.dk>
In-Reply-To: <878spcoc0i.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Oct 2019 11:49:10 -0700
Message-ID: <CAEf4BzboV_84iZNf8HnAOOU=jDnC8+5pYaPDsQUAfV-oGc_4fg@mail.gmail.com>
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

On Tue, Oct 22, 2019 at 11:45 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Tue, Oct 22, 2019 at 11:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Tue, Oct 22, 2019 at 9:08 AM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >> >>
> >> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >>
> >> >> When pinning a map, store the pin path in struct bpf_map so it can =
be
> >> >> re-used later for un-pinning. This simplifies the later addition of=
 per-map
> >> >> pin paths.
> >> >>
> >> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >> ---
> >> >>  tools/lib/bpf/libbpf.c |   19 ++++++++++---------
> >> >>  1 file changed, 10 insertions(+), 9 deletions(-)
> >> >>
> >> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> >> index cccfd9355134..b4fdd8ee3bbd 100644
> >> >> --- a/tools/lib/bpf/libbpf.c
> >> >> +++ b/tools/lib/bpf/libbpf.c
> >> >> @@ -226,6 +226,7 @@ struct bpf_map {
> >> >>         void *priv;
> >> >>         bpf_map_clear_priv_t clear_priv;
> >> >>         enum libbpf_map_type libbpf_type;
> >> >> +       char *pin_path;
> >> >>  };
> >> >>
> >> >>  struct bpf_secdata {
> >> >> @@ -1929,6 +1930,7 @@ int bpf_map__reuse_fd(struct bpf_map *map, in=
t fd)
> >> >>         if (err)
> >> >>                 goto err_close_new_fd;
> >> >>         free(map->name);
> >> >> +       zfree(&map->pin_path);
> >> >>
> >> >
> >> > While you are touching this function, can you please also fix error
> >> > handling in it? We should store -errno locally on error, before we
> >> > call close() which might change errno.
> >>
> >> Didn't actually look much at the surrounding function, TBH. I do expec=
t
> >> that I will need to go poke into this for the follow-on "automatic reu=
se
> >> of pinned maps" series anyway. But sure, I can do a bit of cleanup in =
a
> >> standalone patch first :)
> >>
> >> >>         map->fd =3D new_fd;
> >> >>         map->name =3D new_name;
> >> >> @@ -4022,6 +4024,7 @@ int bpf_map__pin(struct bpf_map *map, const c=
har *path)
> >> >>                 return -errno;
> >> >>         }
> >> >>
> >> >> +       map->pin_path =3D strdup(path);
> >> >
> >> > if (!map->pin_path) {
> >> >     err =3D -errno;
> >> >     goto err_close_new_fd;
> >> > }
> >>
> >> Right.
> >>
> >> >>         pr_debug("pinned map '%s'\n", path);
> >> >>
> >> >>         return 0;
> >> >> @@ -4031,6 +4034,9 @@ int bpf_map__unpin(struct bpf_map *map, const=
 char *path)
> >> >>  {
> >> >>         int err;
> >> >>
> >> >> +       if (!path)
> >> >> +               path =3D map->pin_path;
> >> >
> >> > This semantics is kind of weird. Given we now remember pin_path,
> >> > should we instead check that user-provided path is actually correct
> >> > and matches what we stored? Alternatively, bpf_map__unpin() w/o path
> >> > argument looks like a cleaner API.
> >>
> >> Yeah, I guess the function without a path argument would make the most
> >> sense. However, we can't really change the API of bpf_map__unpin()
> >> (unless you're proposing a symbol-versioned new version?). Dunno if it=
's
> >> worth it to include a new, somewhat oddly-named, function to achieve
> >> this? For the internal libbpf uses at least it's easy enough for the
> >> caller to just go bpf_map__unpin(map, map->pin_path), so I could also
> >> just drop this change? WDYT?
> >
> > I'd probably do strcmp(map->pin_path, path), if path is specified.
> > This will support existing use cases, will allow NULL if we don't want
> > to bother remembering pin_path, will prevent weird use case of pinning
> > to one path, but unpinning another one.
>
> So something like
>
> if (path && map->pin_path && strcmp(path, map->pin_path))

can we unpin not pinned map? sounds like an error condition?

so:

if (!map->pin_path)
    return -EWHATAREYOUDOING;
if (path && strcmp(path, map->pin_path))
    return -EHUH;
path =3D map->pin_path; /* or just use map->ping_path explicitly */

... proceed ...

>  return -EINVAL
> else if (!path)
>  path =3D map->pin_path;
>
> ?
>
> > Ideally, all this pinning will just be done declaratively and will
> > happen automatically, so users won't even have to know about this API
> > :)
>
> Yeah, that's where I'm hoping to get to. But, well, the pin/unpin
> functions already exist so we do need to keep them working...
>
> -Toke
