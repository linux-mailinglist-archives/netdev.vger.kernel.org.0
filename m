Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE72ED06D
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 20:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfKBThw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 15:37:52 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40804 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfKBThv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 15:37:51 -0400
Received: by mail-lf1-f68.google.com with SMTP id f4so9476970lfk.7;
        Sat, 02 Nov 2019 12:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PI1pz1Mj8qVxeQOjA2I9QCG36K5gXfimkl2vr/rf+nM=;
        b=V09FG3XScxezECesi4NRouuEYT0f+ckqz56GbiFjULHcc56/2CJ6xnZsRILR5H6ovD
         p+tac9HHf1qJA17cKf2SxX+PzR6Dxuz3mcLIO46JUjoTEJEii/BQJh0Uh6CNumqLS+dR
         9Q1mhtW6tl942vsvdbp/F1hyhkk14l5cLkGVf7ejs1PCL7nPtxLxkDx1UHGG0jY3a9Vu
         bytG7EhYN4D0CnznPOXSqtWSAGa/bDThCMi/8ucqzcO4b1V5KJFvEIcTBnNyfiLbxV0n
         uD+RGq/KJj3el4nSZcFJk/3uPCWnqLASldCeXmcwF6/Nh6ZKPN90FcURk782u42pBYTC
         7RRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PI1pz1Mj8qVxeQOjA2I9QCG36K5gXfimkl2vr/rf+nM=;
        b=Ps0K08jNQ7nm9Yxgl0FFJvrV/vZs2Kj3EE1rvznjqyj5p1Wd2UZ6H9r3CySizREQlI
         POJMNn6Ls2RV8TX/aI9Rt8tLoZh4XkpUPHZz3jQKfuqySgGsVuhaMCMA4MJy1ZePFhKQ
         qSgDypxxaHQrW414xBePXZ1ZJWLR7GJcDbN1AXad0orsCjnW3doE//g2vFgcdpxtF7Hv
         Ta55BdVRp/QCY9cd8jidCvo9t/SaI2WV8NUHZsXzDUaeDCx8OUCEK5nyg5duXJjFdmX2
         LgTSncZ6XTFpgwVxWOsSHAr7EjwCh6X32iUgM4nHDZlQem3gb8RYsvcC0tCWR34C1MW0
         ngGA==
X-Gm-Message-State: APjAAAWmEG3hxoIFKyc9OEXxeFy6POJ1VxEI6i0ikfr0FKKlvCLHCy26
        xE1g7HsORe3sknXt3+9+XFU2dXb8B4uEXeIHorU=
X-Google-Smtp-Source: APXvYqzyN+fZcRaQ+4DmXwiB0/IffT2uGiu2YHKUFW2S16+3dtUmqqEBHI1UQFGvU0l9JaBegwIFRL4503Rh0SgxNKc=
X-Received: by 2002:a19:7511:: with SMTP id y17mr11948597lfe.19.1572723469300;
 Sat, 02 Nov 2019 12:37:49 -0700 (PDT)
MIME-Version: 1.0
References: <157269297658.394725.10672376245672095901.stgit@toke.dk> <CAEf4BzYXhoaiH5x9YZ99ABUMngsjBVRAYJBm+oMbnAHnpn-18g@mail.gmail.com>
In-Reply-To: <CAEf4BzYXhoaiH5x9YZ99ABUMngsjBVRAYJBm+oMbnAHnpn-18g@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 2 Nov 2019 12:37:37 -0700
Message-ID: <CAADnVQKcG8a39Ai-h2vbWieZiMNLUVE6L_meUv7NeJPCMw2Eig@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 0/5] libbpf: Support automatic pinning of maps
 using 'pinning' BTF attribute
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
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

On Sat, Nov 2, 2019 at 12:09 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Nov 2, 2019 at 4:09 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
> >
> > This series adds support to libbpf for reading 'pinning' settings from =
BTF-based
> > map definitions. It introduces a new open option which can set the pinn=
ing path;
> > if no path is set, /sys/fs/bpf is used as the default. Callers can cust=
omise the
> > pinning between open and load by setting the pin path per map, and stil=
l get the
> > automatic reuse feature.
> >
> > The semantics of the pinning is similar to the iproute2 "PIN_GLOBAL" se=
tting,
> > and the eventual goal is to move the iproute2 implementation to be base=
d on
> > libbpf and the functions introduced in this series.
> >
> > Changelog:
> >
> > v6:
> >   - Fix leak of struct bpf_object in selftest
> >   - Make struct bpf_map arg const in bpf_map__is_pinned() and bpf_map__=
get_pin_path()
> >
> > v5:
> >   - Don't pin maps with pinning set, but with a value of LIBBPF_PIN_NON=
E
> >   - Add a few more selftests:
> >     - Should not pin map with pinning set, but value LIBBPF_PIN_NONE
> >     - Should fail to load a map with an invalid pinning value
> >     - Should fail to re-use maps with parameter mismatch
> >   - Alphabetise libbpf.map
> >   - Whitespace and typo fixes
> >
> > v4:
> >   - Don't check key_type_id and value_type_id when checking for map reu=
se
> >     compatibility.
> >   - Move building of map->pin_path into init_user_btf_map()
> >   - Get rid of 'pinning' attribute in struct bpf_map
> >   - Make sure we also create parent directory on auto-pin (new patch 3)=
.
> >   - Abort the selftest on error instead of attempting to continue.
> >   - Support unpinning all pinned maps with bpf_object__unpin_maps(obj, =
NULL)
> >   - Support pinning at map->pin_path with bpf_object__pin_maps(obj, NUL=
L)
> >   - Make re-pinning a map at the same path a noop
> >   - Rename the open option to pin_root_path
> >   - Add a bunch more self-tests for pin_maps(NULL) and unpin_maps(NULL)
> >   - Fix a couple of smaller nits
> >
> > v3:
> >   - Drop bpf_object__pin_maps_opts() and just use an open option to cus=
tomise
> >     the pin path; also don't touch bpf_object__{un,}pin_maps()
> >   - Integrate pinning and reuse into bpf_object__create_maps() instead =
of having
> >     multiple loops though the map structure
> >   - Make errors in map reuse and pinning fatal to the load procedure
> >   - Add selftest to exercise pinning feature
> >   - Rebase series to latest bpf-next
> >
> > v2:
> >   - Drop patch that adds mounting of bpffs
> >   - Only support a single value of the pinning attribute
> >   - Add patch to fixup error handling in reuse_fd()
> >   - Implement the full automatic pinning and map reuse logic on load
> >
> > ---
> >
> > Toke H=C3=B8iland-J=C3=B8rgensen (5):
> >       libbpf: Fix error handling in bpf_map__reuse_fd()
> >       libbpf: Store map pin path and status in struct bpf_map
> >       libbpf: Move directory creation into _pin() functions
> >       libbpf: Add auto-pinning of maps when loading BPF objects
> >       selftests: Add tests for automatic map pinning
> >
> >
>
> For the series:
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks!
