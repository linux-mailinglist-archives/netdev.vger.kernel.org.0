Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB0E195D23
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 18:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgC0Rtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 13:49:45 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43603 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgC0Rtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 13:49:45 -0400
Received: by mail-qk1-f195.google.com with SMTP id o10so11681385qki.10;
        Fri, 27 Mar 2020 10:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZZDcK75sJ+QKnRKKCmA36T77YwqPu4mBJqtUYUH0mUI=;
        b=d/g9JrVv8yhsJa7ZClAX0DYoC1XKGwNqDDk/sSmcVxbOWCrFPPV3VecAgE2JVnrKM8
         XnCiuvYjmWCD/VTLJ1GPIo+FZZI64Csh+RD8Pm2p+4XVfaRvUbCO4z3+s8nnhye8JYA3
         0I6Kwm49MQ70+eD26XtMXs/z/LAmD6lx55UWw3Y54liDpYoOdQ+oVk8chaVWp0JmIk9Q
         wnvsAwxz23PYedxCI8TEMi2tWDZzzkkt0Q2Bq6w9bUXGBuiEbEPykdyJQcD5zEhaa8cJ
         mN17WlQzv+K+9eEqQIruyJhIPyJljKIAkwvQPIjnvtzxEK3uHGlJtwdlghmjYmQV+a9e
         d1mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZZDcK75sJ+QKnRKKCmA36T77YwqPu4mBJqtUYUH0mUI=;
        b=Vnerh3HJ3H8pjH2sryqVuBYl9/srd0qPbfWAeTRnQZKPeEr5zVzR59xndo50qehrfu
         5l0kQLzV1CLlO+3NWbv7nn/oZJVpi1CYRxJOpw+95sGGCIH7EekcROREZsGZRbubNoww
         pBHuCtzGHBOjE1r7Aje8U7xfskU2eIbOnMIQYqjEgSUV3xaPK3OKe/jPA5bps6tx96R/
         Mwwm2C3KVTecY+4+vOL37NWZsj5XAmluJL72lBegVeTUuvBEoILuJvdh+IczxwdCjcMC
         8Xa3rfZGcsrCz8MF6hTiLbik7wYYAoJKvDAax4R49YfLMimZZYSG+dmdFzeNqk/xOh02
         mCqA==
X-Gm-Message-State: ANhLgQ1LHN9NOX4YW3Fs+t993AzFOxRFLMxZCh2zDLRgugU56yNGMosj
        YLjBL2FULsHCwEdSvToknT9cofLrdinxICVzKVo=
X-Google-Smtp-Source: ADFU+vsfFSR/+yVYFF8n9a9R/5R8cxgNEa/I2mS6VlVan8b6jprYFDY6jf72vEdyLQ6KIKzRSXjmN92OfCXSidFq6zA=
X-Received: by 2002:a05:620a:88e:: with SMTP id b14mr478698qka.449.1585331383616;
 Fri, 27 Mar 2020 10:49:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200326151741.125427-1-toke@redhat.com> <CAEf4BzYxJjJygu_ZqJJB03n=ZetxhuUE7eLD9dsbkbvzQ5M08w@mail.gmail.com>
 <87eetem1dm.fsf@toke.dk>
In-Reply-To: <87eetem1dm.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 27 Mar 2020 10:49:32 -0700
Message-ID: <CAEf4BzbRpJsoXb3Bvx0_jKGj4gLk-dhXRqryfO23qMreG2B+Kg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Add bpf_object__rodata getter function
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 5:24 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Thu, Mar 26, 2020 at 8:18 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> This adds a new getter function to libbpf to get the rodata area of a =
bpf
> >> object. This is useful if a program wants to modify the rodata before
> >> loading the object. Any such modification needs to be done before load=
ing,
> >> since libbpf freezes the backing map after populating it (to allow the
> >> kernel to do dead code elimination based on its contents).
> >>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >>  tools/lib/bpf/libbpf.c   | 13 +++++++++++++
> >>  tools/lib/bpf/libbpf.h   |  1 +
> >>  tools/lib/bpf/libbpf.map |  1 +
> >>  3 files changed, 15 insertions(+)
> >>
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index 085e41f9b68e..d3e3bbe12f78 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -1352,6 +1352,19 @@ bpf_object__init_internal_map(struct bpf_object=
 *obj, enum libbpf_map_type type,
> >>         return 0;
> >>  }
> >>
> >> +void *bpf_object__rodata(const struct bpf_object *obj, size_t *size)
> >
> > We probably don't want to expose this API. It just doesn't scale,
> > especially if/when we add support for custom sections names for global
> > variables.
>
> Right. I was not aware of any such plans, but OK.

There are no concrete plans, but compilers do create more than one
.rodata in some circumstances (I remember seeing something like
.rodata.align16, etc). So just don't want to have accessor for .rodata
but not for all other places. Let me take a closer look at v2, but I
think that one is a better approach.

>
> > Also checking for map->mmaped is too restrictive. See how BPF skeleton
> > solves this problem and still allows .rodata initialization even on
> > kernels that don't support memory-mapping global variables.
>
> Not sure what you mean here? As far as I can tell, the map->mmaped
> pointer has nothing to do with the kernel support for mmaping the map

Right, I forgot details by now and I just briefly looked at code and
saw mmap() call. But it's actually an anonymous mmap() call, which
gets remapped later, so yeah, it's a double-purpose memory area.

> contents. It's just what libbpf does to store the data of any
> internal_maps?
>
> I mean, bpf_object__open_skeleton() just does this:
>
>                 if (mmaped && (*map)->libbpf_type !=3D LIBBPF_MAP_KCONFIG=
)
>                         *mmaped =3D (*map)->mmaped;
>
> which amounts to the same as I'm doing in this patch?
>
> > But basically, why can't you use BPF skeleton?
>
> Couple of reasons:
>
> - I don't need any of the other features of the skeleton
> - I don't want to depend on bpftool in the build process
> - I don't want to embed the BPF bytecode into the C object

Just curious, how are you intending to use global variables. Are you
restricting to a single global var (a struct probably), so it's easier
to work with it? Or are you resolving all the variables' offsets
manually? It's really inconvenient to work with global variables
without skeleton, which is why I'm curious.

>
> > Also, application can already find that map by looking at name.
>
> Yes, it can find the map, but it can't access the data. But I guess I
> could just add a getter for that. Just figured this was easier to
> consume; but I can see why it might impose restrictions on future
> changes, so I'll send a v2 with such a map-level getter instead.

Sounds good, I'll go review v2 now.
>
> -Toke
>
