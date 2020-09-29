Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EF127DC69
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 01:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgI2XD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 19:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbgI2XD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 19:03:57 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4EAC061755;
        Tue, 29 Sep 2020 16:03:57 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id b142so4894556ybg.9;
        Tue, 29 Sep 2020 16:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bUKTvRdh5l2QbwjKLrs/UoSnMvF+g14rYywkue1e77M=;
        b=fL1G2dUCdqCTnQ2Z4ESlTU3xml0qakbYdreGDIYR9Yiab1yScww7DzY25n6OHEcEBc
         cOsZZgMCwkPLxiBHzSSiaJGMKyoN06XP5kYVa2QSQN/OnQpIGo+2dk6cUOO6ryIPK6my
         SGccf9Pl/+xZFn8hV0auR6i5mvHz2c5Kdjp2h7YywWY6jfuuKPQqgJZfeItO69MFxJla
         pdOzOxIUsIwcpt9Ydw1gJG/nt5Zt7+xoMHGaiRC2pt/JKDBT9sEGn/2e10RlEpSFe2So
         CzmX0WBzABNgo+UVkhGSbYfjvLYR4cXUIKHBC08eiP3ie2T/uvEIFE1lf9YdtmMPH8nP
         T2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bUKTvRdh5l2QbwjKLrs/UoSnMvF+g14rYywkue1e77M=;
        b=khN4+T8ah/aqd30xiexrA8pHD5WCFBP5Wo3GWD2HXAysEOmgJp9JqZOjEXxmLV0Dvk
         /A6hRg3DRtOf9Oh8tdunPblMvKz+hy9w0N3mVCs6ozv6YzzsUDlr5Dg07/rNStDy0Io/
         IYAnCi8QjulgYRZeGQ2QcbD2UV9vE2o8eCUrEToKJTT5CD5RNlv204CSLC0GpvfcSgQC
         xB0m2V5qfvBIXVwMqh6fULdmUB8sNcyEHRmf460Ym0MGbl+GMbzr53xa38FJO7W21y0X
         B0wo4BAqvme7gjJXuJy6SESp9KYPAuSjUjxx13xqBBAHiFfIq/TRzTp+qPSVy4cvGwHC
         mWMg==
X-Gm-Message-State: AOAM533GiqpWpY9BUgK9CrKAOyC84DyjI2kXkQfYhtNM0i+oW+0v780H
        JQZB5vyhdAivYX6M3qIkxvqdgqBCbM8znCFktjtd/IkelNF7aQ==
X-Google-Smtp-Source: ABdhPJz/EoOlc+fROg9LqVTnNQtQszyttbUFp5D+2j3AIvHK7Sxo6TxdZagbgt1jFm4VNEDPMLEEcOJedKgeLSu/S5s=
X-Received: by 2002:a25:2596:: with SMTP id l144mr9307587ybl.510.1601420636903;
 Tue, 29 Sep 2020 16:03:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200929031845.751054-1-liuhangbin@gmail.com> <CAEf4BzYKtPgSxKqduax1mW1WfVXKuCEpbGKRFvXv7yNUmUm_=A@mail.gmail.com>
 <20200929094232.GG2531@dhcp-12-153.nay.redhat.com>
In-Reply-To: <20200929094232.GG2531@dhcp-12-153.nay.redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 29 Sep 2020 16:03:45 -0700
Message-ID: <CAEf4BzZy9=x0neCOdat-CWO4nM3QYgWOKaZpN31Ce5Uz9m_qfg@mail.gmail.com>
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

On Tue, Sep 29, 2020 at 2:42 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Mon, Sep 28, 2020 at 08:30:42PM -0700, Andrii Nakryiko wrote:
> > > @@ -431,6 +431,7 @@ bpf_map__prev(const struct bpf_map *map, const struct bpf_object *obj);
> > >  /* get/set map FD */
> > >  LIBBPF_API int bpf_map__fd(const struct bpf_map *map);
> > >  LIBBPF_API int bpf_map__reuse_fd(struct bpf_map *map, int fd);
> > > +LIBBPF_API int bpf_object__reuse_map(struct bpf_map *map);
> >
> > It's internal function, which doesn't check that map->pin_path is set,
>
> How about add a path check in bpf_object__reuse_map()?
>
> And off course users who use it should call bpf_map__set_pin_path() first.
>
> > for one thing. It shouldn't be exposed. libbpf exposes
> > bpf_map__set_pin_path() to set pin_path for any map, and then during
> > load time libbpf with "reuse map", if pin_path is not NULL. Doesn't
> > that work for you?
>
> Long story...
>
> When trying to add iproute2 libbpf support that I'm working on. We need to
> create iproute2 legacy map-in-map manually before libbpf load objects, because
> libbpf only support BTF type map-in-map(unless I missed something.).
>
> After creating legacy map-in-map and reuse the fd, if the map has legacy
> pining defined, only set the pin path would not enough as libbpf will skip
> pinning map if map->fd > 0 in bpf_object__create_maps(). See the following
> code bellow.
>
> bpf_map__set_pin_path()
> bpf_create_map_in_map()    <- create inner or outer map
> bpf_map__reuse_fd(map, inner/outer_fd)
> bpf_object__load(obj)
>   - bpf_object__load_xattr()
>     - bpf_object__create_maps()
>       - if (map->fd >= 0)
>           continue      <- this will skip pinning map

so maybe that's the part that needs to be fixed?..

>
> So when handle legacy map-in-map + pin map, we need to create the map
> and pin maps manually at the same time. The code would looks like
> (err handler skipped).
>
> map_fd = bpf_obj_get(pathname);
> if (map_fd > 0) {
>         bpf_map__set_pin_path(map, pathname);
>         return bpf_object__reuse_map(map);   <- here we need the reuse_map
> }
> bpf_create_map_in_map()
> bpf_map__reuse_fd(map, map_fd);
> bpf_map__pin(map, pathname);
>
> So I think this function is needed, what do you think?

I'm still not sure. And to be honest your examples are still a bit too
succinct for me to follow where the problem is exactly. Can you please
elaborate a bit more?

It might very well be that map pinning and FD reuse have buggy and
convoluted logic, but let's try to fix that first, before we expose
new APIs.

>
> Thanks
> Hangbin
