Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A2151C96
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 22:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732108AbfFXUtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 16:49:14 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33146 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732071AbfFXUtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 16:49:13 -0400
Received: by mail-qk1-f195.google.com with SMTP id r6so10897702qkc.0
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 13:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cKzyVq6V1dNvrt8VqDCFVxL1rIWaANuaVVs2wiwaJAU=;
        b=rXfOImYVQylwNrAMlCdeFQtDiEcD1GZIvtXtv3Ys/FXO6h3hPDNAlLXjQyN60KeWMU
         1H8dRSRryVhobNmV6Vb/IuNwsPFiIBpbKHjvub8BvPPiU1Ok1CfjuHmDjs1NMJHFvLaY
         v/XL9aIX/SZjBWd67egCP+zY69bAVZwXP2rtwEbbRTJibw37JhMpXdpQebeChLgEWk/Q
         bT6QdOnVkPe4ExU96zYtfSoyAtaBZrm2rw819yYp9SoZd9ussv8E7o7Gcm0wABmJCEkJ
         rnFVlcddhSJLQQkNJCxWKJK8ANoWAotBM1fE/3LTKoBPobFujgghsqfQf+F0IOwwVHZd
         +Ciw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cKzyVq6V1dNvrt8VqDCFVxL1rIWaANuaVVs2wiwaJAU=;
        b=n3BtXkT9VJ/lDE6dVNyuLM3IopHFZ6m3SCmBxb0zzNIZ02KFCd6Pwx+kBqgOuRjheb
         B+iCUJ2XX0aoSqwCqEp3DpzxFrSWgrmNfm6xM+W+jKMsRUaIuKL5WClopVwxBeBqBkNC
         QQzKIjDBAk51feyt6WOdzVmQieNOFvGv7/X8CStcfFkG6SOqA3zC6GJI9DwxeerB1Uez
         KrSdOIiDbzXPZHF+qWAv0mdshTLrds5je7xtk0tw3fxda4VezMHTqn1QB3XYxCZUwOhm
         2n2wCMitmMvP1NWG1k+R2ZxANvMLGtpPdgdWP62PKZcvwrEOOb/Lz4CSSh+A84mWHrup
         6y+Q==
X-Gm-Message-State: APjAAAVpNjbYN4EupUulVhndI4+tvvsXkgKb+DxBGAnhMRwySMh77ZSp
        SOAmwnHFge41rY31T6NXCB+iPpFQbWvPiCGIDKY=
X-Google-Smtp-Source: APXvYqxo9x7gzphzQ33jsp1RIniiMnAj1DqcU0A+TUM6zMhCTsgCJ/lTkqZDN6tiYoI4zvA4nUtMN/g4xBzjguvUa3Q=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr17350470qkj.39.1561409352593;
 Mon, 24 Jun 2019 13:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <156125626076.5209.13424524054109901554.stgit@alrua-x1>
 <CAEf4BzYFCAp7yUU80ia=C5ywDBgepeaMmVPJW8VG4gLUT=ht=A@mail.gmail.com> <87y31qepu6.fsf@toke.dk>
In-Reply-To: <87y31qepu6.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 Jun 2019 13:49:01 -0700
Message-ID: <CAEf4BzZPb2YsrvOfshJAboY9KE3dCa_FZsTkxvQyPquzDChz+w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 0/3] xdp: Allow lookup into devmaps before redirect
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 12:38 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Sat, Jun 22, 2019 at 7:19 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> When using the bpf_redirect_map() helper to redirect packets from XDP,=
 the eBPF
> >> program cannot currently know whether the redirect will succeed, which=
 makes it
> >> impossible to gracefully handle errors. To properly fix this will prob=
ably
> >> require deeper changes to the way TX resources are allocated, but one =
thing that
> >> is fairly straight forward to fix is to allow lookups into devmaps, so=
 programs
> >> can at least know when a redirect is *guaranteed* to fail because ther=
e is no
> >> entry in the map. Currently, programs work around this by keeping a sh=
adow map
> >> of another type which indicates whether a map index is valid.
> >>
> >> This series contains two changes that are complementary ways to fix th=
is issue:
> >>
> >> - Moving the map lookup into the bpf_redirect_map() helper (and cachin=
g the
> >>   result), so the helper can return an error if no value is found in t=
he map.
> >>   This includes a refactoring of the devmap and cpumap code to not car=
e about
> >>   the index on enqueue.
> >>
> >> - Allowing regular lookups into devmaps from eBPF programs, using the =
read-only
> >>   flag to make sure they don't change the values.
> >>
> >> The performance impact of the series is negligible, in the sense that =
I cannot
> >> measure it because the variance between test runs is higher than the d=
ifference
> >> pre/post series.
> >>
> >> Changelog:
> >>
> >> v5:
> >>   - Rebase on latest bpf-next.
> >>   - Update documentation for bpf_redirect_map() with the new meaning o=
f flags.
> >>
> >> v4:
> >>   - Fix a few nits from Andrii
> >>   - Lose the #defines in bpf.h and just compare the flags argument dir=
ectly to
> >>     XDP_TX in bpf_xdp_redirect_map().
> >>
> >> v3:
> >>   - Adopt Jonathan's idea of using the lower two bits of the flag valu=
e as the
> >>     return code.
> >>   - Always do the lookup, and cache the result for use in xdp_do_redir=
ect(); to
> >>     achieve this, refactor the devmap and cpumap code to get rid the b=
itmap for
> >>     selecting which devices to flush.
> >>
> >> v2:
> >>   - For patch 1, make it clear that the change works for any map type.
> >>   - For patch 2, just use the new BPF_F_RDONLY_PROG flag to make the r=
eturn
> >>     value read-only.
> >>
> >> ---
> >>
> >> Toke H=C3=B8iland-J=C3=B8rgensen (3):
> >>       devmap/cpumap: Use flush list instead of bitmap
> >>       bpf_xdp_redirect_map: Perform map lookup in eBPF helper
> >>       devmap: Allow map lookups from eBPF
> >>
> >>
> >>  include/linux/filter.h   |    1
> >>  include/uapi/linux/bpf.h |    7 ++-
> >>  kernel/bpf/cpumap.c      |  106 ++++++++++++++++++++-----------------=
------
> >>  kernel/bpf/devmap.c      |  113 ++++++++++++++++++++++---------------=
---------
> >>  kernel/bpf/verifier.c    |    7 +--
> >>  net/core/filter.c        |   29 +++++-------
> >>  6 files changed, 123 insertions(+), 140 deletions(-)
> >>
> >
> >
> > Looks like you forgot to add my Acked-by's for your patches?
>
> Ah yes, did not carry those forward for the individual patches, my
> apologies. Could you perhaps be persuaded to send a new one (I believe a
> response to the cover letter acking the whole series would suffice)?
> I'll make sure to add the carrying forward of acks into my workflow in
> the future :)

I don't think patchworks captures ack's from cover letter, but let's
give it a go:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
> -Toke
