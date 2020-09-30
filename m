Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A966627F14E
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 20:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgI3Sah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 14:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3Sah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 14:30:37 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35160C061755;
        Wed, 30 Sep 2020 11:30:37 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id b142so2006793ybg.9;
        Wed, 30 Sep 2020 11:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2OiY48v5fupX3OLmM/AQ2RxdhAtrUz7JvwXHvaAkGCE=;
        b=dHPwsxT2vG8Jr1e93nNF1wFKJkBQ5rGgaqzWhn2YHJCNKCbz7VbnkcKFqX20jk/mCT
         hg5t0EpyfIo6pfvLwDYpZsTF/UzWhCRSPhFW87Khixo+5PCGIffW6jCUi3ZuxXQacljV
         7A/EunvnOXAWTxCkR6AF2B3aETa2ff6KBt12dUj0PENpI1EFAhifj+XAPFBJZWeaASkK
         PhcKjacGXvsoMRne3PKLmc5nREROg08BXj9lvq+3EQ3mXREQnm/yRyTjHntA922jJiqQ
         muW0ZdWmppPhw/efQB/9ZkKBWjlaqOHHt4neOKina01U5dwysZgerVobp8gHEOsgFFIQ
         YcCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2OiY48v5fupX3OLmM/AQ2RxdhAtrUz7JvwXHvaAkGCE=;
        b=DE419lR60SHpI+bnZlpl+PGPZvQgvg1X5cCJc8fXusRd68m1Tbd0LcY7A9qG5DLYYL
         bipQxfSymRA4B1YuNB7LVQ/RY4tqbyMPC9aq7YZc8FU5kNxRHDF5QhXQaXwVwttVjOph
         jikhxhvJl2C7RLwpNBkSIXpXqqCVDxSgkFZ9Fm8PX8KpScKrPv/GtqH/mAFO0p1jLlim
         tH3mkme3jwv0X9NhSphKI9OOXaK7Vq0Yet+4BqeHrZ3C+J3WrnQRA3+QP0s3JnZYYzr8
         W59lBBb36wWjW4yQBUp8Ug62pGii1t3HFshQY5jse8hjySmHDycKKzYiekaJftNaZvxE
         47FA==
X-Gm-Message-State: AOAM533Z5myyemfcfJNOXnoNltLHskr3dAe5/rPgt51hQ74qUWHZ7cUy
        Nty6tNxihZYunQ7U72W18+Y2ZN7O3JUjY9tA5X7edNbITJc=
X-Google-Smtp-Source: ABdhPJwvWrr1EpSTIlgxCIwZTY5EuqRhQ0MNvn7CHiSqQ1hsrr4ux8KuzlxGNQFPyP8noyzC5BZFiYNSze8nruswALA=
X-Received: by 2002:a25:2d41:: with SMTP id s1mr5018629ybe.459.1601490636277;
 Wed, 30 Sep 2020 11:30:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200929031845.751054-1-liuhangbin@gmail.com> <CAEf4BzYKtPgSxKqduax1mW1WfVXKuCEpbGKRFvXv7yNUmUm_=A@mail.gmail.com>
 <20200929094232.GG2531@dhcp-12-153.nay.redhat.com> <CAEf4BzZy9=x0neCOdat-CWO4nM3QYgWOKaZpN31Ce5Uz9m_qfg@mail.gmail.com>
 <20200930023405.GH2531@dhcp-12-153.nay.redhat.com>
In-Reply-To: <20200930023405.GH2531@dhcp-12-153.nay.redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 30 Sep 2020 11:30:25 -0700
Message-ID: <CAEf4BzYVVUq=eNwb4Z1JkVmRc4i+nxC4zWxbv2qGQAs-2cxkhw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: export bpf_object__reuse_map() to libbpf api
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 7:34 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Tue, Sep 29, 2020 at 04:03:45PM -0700, Andrii Nakryiko wrote:
> > > bpf_map__set_pin_path()
> > > bpf_create_map_in_map()    <- create inner or outer map
> > > bpf_map__reuse_fd(map, inner/outer_fd)
> > > bpf_object__load(obj)
> > >   - bpf_object__load_xattr()
> > >     - bpf_object__create_maps()
> > >       - if (map->fd >= 0)
> > >           continue      <- this will skip pinning map
> >
> > so maybe that's the part that needs to be fixed?..
>
> Hmm...maybe, let me see
>
> >
> > I'm still not sure. And to be honest your examples are still a bit too
> > succinct for me to follow where the problem is exactly. Can you please
> > elaborate a bit more?
>
> Let's take iproute2 legacy map for example, if it's a map-in-map type with
> pin path defined. In user space we could do like:
>
> if (bpf_obj_get(pathname) < 0) {
>         bpf_create_map_in_map();
>         bpf_map__reuse_fd(map, map_fd);
> }
> bpf_map__set_pin_path(map, pathname);
> bpf_object__load(obj)
>
> So in libbpf we need
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 32dc444224d8..5412aa7169db 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4215,7 +4215,7 @@ bpf_object__create_maps(struct bpf_object *obj)
>                 if (map->fd >= 0) {
>                         pr_debug("map '%s': skipping creation (preset fd=%d)\n",
>                                  map->name, map->fd);
> -                       continue;
> +                       goto check_pin_path;
>                 }
>
>                 err = bpf_object__create_map(obj, map);
> @@ -4258,6 +4258,7 @@ bpf_object__create_maps(struct bpf_object *obj)
>                         map->init_slots_sz = 0;
>                 }
>
> +check_pin_path:
>                 if (map->pin_path && !map->pinned) {
>                         err = bpf_map__pin(map, NULL);
>                         if (err) {
>
>
> Do you think if this change be better?

Yes, of course. Just don't do it through use of goto. Guard map
creation with that if instead.

>
> Thanks
> Hangbin
