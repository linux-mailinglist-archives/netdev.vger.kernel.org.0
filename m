Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAF7322369
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 02:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhBWBQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 20:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhBWBPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 20:15:55 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AD7C061574;
        Mon, 22 Feb 2021 17:15:15 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id m9so14850552ybk.8;
        Mon, 22 Feb 2021 17:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Zm/OrNc3ivuCSoHbJLxz/xKZKnnzjvqT3PEqqQIt8oE=;
        b=YHp8pMa1OCN09Z5XVL0dtUIU3mnPJ8hGpAKz7omPANuQ14tJ6NC8LM0yiEI4QcGU8c
         SE5k8UM9VAlU4Mgqs3bE4bNoZA00ChCKL7sieGTHGzn9qUQwpZA1uakLdFKMdG8wOI5P
         yXg10gLxdmpgaA2wwxpKkzb5UpULOrnxsp3zcQiBkG324wPuSCygCsCgzZROGlkMy0uu
         0UUWcQTdvnjBiQHV0Tn+1208rHeLC4Xi/VlyWo5uWBRMsh4l1gzS0bBfioHlZpZ0NgEn
         27hfpp3TBrdxUBCzEXMSwJ+M6Ly+UrKrhVBejGsWDwNK3F2vv/zUJN/yZ3AQLNgSKPES
         Pf4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Zm/OrNc3ivuCSoHbJLxz/xKZKnnzjvqT3PEqqQIt8oE=;
        b=RyCXeT9y/yIbthzJXgqt+Nn3g3TYu6uYZAa04LVACoqM9kDjOEuHHRNYQ64+e3b0kT
         nATCojPsdaMKpojcrry+2NSjr6dNKO6qaGRkbOBYnUJUfaZJwuquK/HN/DZKmYtMNnMP
         8mpul5QMs0RhtVaO2Q/hmIWtv+VTYNkcCRTCsQAE0FYjJEjzA2Vzd4bmDjVLIpsjkbMU
         hdff8yZr/Qha0AwFJJ+ebg1Dr59pl5TD6zSssgUvXhOw6AVhH9ppcobBwp+CL0txF3tF
         yWPMeP/e4mCQy/+M3uRTEXQayAJulNnDF9obd8n2D73zvmfyZ6qWEgp8vAZebSwfDLRn
         3j/Q==
X-Gm-Message-State: AOAM532l/mSSnM+BWFXIOywL3ss5Sbz9DCZdmPYmhU/toP5mj3VlNqOi
        c3r3wWaDnRTB2jX4hl1uFp7NDIgx8jq1l6CF5oQ=
X-Google-Smtp-Source: ABdhPJwj+U+f+cwUg9MgLcmJ2vaZcyByJw1ZHCFA+XmcdzIVvmYG2KdVwONx4jb3h1grMwsprHRR6ny2nHD7Txl1/mU=
X-Received: by 2002:a25:3d46:: with SMTP id k67mr5338403yba.510.1614042914758;
 Mon, 22 Feb 2021 17:15:14 -0800 (PST)
MIME-Version: 1.0
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com> <87eehhcl9x.fsf@toke.dk>
 <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com> <602ad80c566ea_3ed4120871@john-XPS-13-9370.notmuch>
 <8735xxc8pf.fsf@toke.dk> <602b0f54c05a6_3ed41208dc@john-XPS-13-9370.notmuch> <87pn10b8om.fsf@toke.dk>
In-Reply-To: <87pn10b8om.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Feb 2021 17:15:03 -0800
Message-ID: <CAEf4BzZEfzPNYcD5ZK=ipzbE4G7Obz31_t-jK-NdVbDwpgq4AA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        ciara.loftus@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 2:37 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> John Fastabend <john.fastabend@gmail.com> writes:
>
> > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> John Fastabend <john.fastabend@gmail.com> writes:
> >>
> >> >> > However, in libxdp we can solve the original problem in a differe=
nt way,
> >> >> > and in fact I already suggested to Magnus that we should do this =
(see
> >> >> > [1]); so one way forward could be to address it during the merge =
in
> >> >> > libxdp? It should be possible to address the original issue (two
> >> >> > instances of xdpsock breaking each other when they exit), but
> >> >> > applications will still need to do an explicit unload operation b=
efore
> >> >> > exiting (i.e., the automatic detach on bpf_link fd closure will t=
ake
> >> >> > more work, and likely require extending the bpf_link kernel suppo=
rt)...
> >> >> >
> >> >>
> >> >> I'd say it's depending on the libbpf 1.0/libxdp merge timeframe. If
> >> >> we're months ahead, then I'd really like to see this in libbpf unti=
l the
> >> >> merge. However, I'll leave that for Magnus/you to decide!
> >> >
> >> > Did I miss some thread? What does this mean libbpf 1.0/libxdp merge?
> >>
> >> The idea is to keep libbpf focused on bpf, and move the AF_XDP stuff t=
o
> >> libxdp (so the socket stuff in xsk.h). We're adding the existing code
> >> wholesale, and keeping API compatibility during the move, so all that'=
s
> >> needed is adding -lxdp when compiling. And obviously the existing libb=
pf
> >> code isn't going anywhere until such a time as there's a general
> >> backwards compatibility-breaking deprecation in libbpf (which I believ=
e
> >> Andrii is planning to do in an upcoming and as-of-yet unannounced v1.0
> >> release).
> >
> > OK, I would like to keep the basic XDP pieces in libbpf though. For exa=
mple
> > bpf_program__attach_xdp(). This way we don't have one lib to attach
> > everything, but XDP.
>
> The details are still TDB; for now, we're just merging in the XSK code
> to the libxdp repo. I expect Andrii to announce his plans for the rest
> soonish. I wouldn't expect basic things like that to go away, though :)

Yeah, I'll probably post more details this week. Just catching up on
stuff after vacation.

As mentioned already, all the basic APIs (i.e., APIs like
bpf_program__attach_xdp and bpf_set_link_xdp_fd, though I hope we can
give the latter a better name) will stay intact. Stay tuned!

>
> >>
> >> While integrating the XSK code into libxdp we're trying to make it
> >> compatible with the rest of the library (i.e., multi-prog). Hence my
> >> preference to avoid introducing something that makes this harder :)
> >>
> >> -Toke
> >>
> >
> > OK that makes sense to me thanks. But, I'm missing something (maybe its
> > obvious to everyone else?).
> >
> > When you load an XDP program you should get a reference to it. And then
> > XDP program should never be unloaded until that id is removed right? It
> > may or may not have an xsk map. Why does adding/removing programs from
> > an associated map have any impact on the XDP program? That seems like
> > the buggy part to me. No other map behaves this way as far as I can
> > tell. Now if the program with the XDP reference closes without pinning
> > the map or otherwise doing something with it, sure the map gets destroy=
ed
> > and any xsk sockets are lost.
>
> The original bug comes from the XSK code abstracting away the fact that
> an AF_XDP socket needs an XDP program on the interface to work; so if
> none exists, the library will just load a program that redirects into
> the socket. Which breaks since the xdpsock example application is trying
> to be nice and clean up after itself, by removing the XDP program when
> it's done with the socket, thus breaking any other programs using that
> XDP program. So this patch introduces proper synchronisation on both add
> and remove of the XDP program...
>
> -Toke
>
