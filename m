Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 037C346C9C
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbfFNXHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:07:21 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44106 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbfFNXHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:07:21 -0400
Received: by mail-qt1-f195.google.com with SMTP id x47so4379693qtk.11
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 16:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MYCIQVv3qYOxsnI90tP6w1wYQt5KkdY0QPuDwSqvIIA=;
        b=FGtb93s7+NOcX67MKMLgtCoBBTKuDngdBn9GxjKiaW0kSraHIMCkdkN8Hj5EpdNjKG
         U11hyDemKbiIB2iKYxxvFrF43ELBFBP4Bvm8xfbQ9o16NdkWGNMpyLVM1U6CamCapIue
         lFucAUrRhNKM3r2cGZnixLNMzkOoDKDJfvuBz0O3Qj/6tMRtIG2IVsDkXpFoOdAltsZ+
         kpq9PiegXjqDEOa4OZlGKPKUzad6YNHqluqeyB3QderBsAvJKrkkzw1goE2YWlc63Nx2
         eTLWYhUXCN7o59O7H56wUIJmSz4Um10NangvYsl3uREUEM31QXB3yaHiT80KMAAhDCO0
         D7YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MYCIQVv3qYOxsnI90tP6w1wYQt5KkdY0QPuDwSqvIIA=;
        b=TD6xdUQh6JOsqVlOWyZpKavfL4cR7GkuoxoMpmnF2b/By+DUZ/szlyW2b91sCl23Y2
         en7yuL+x8yTBAcKsVBaT8WavZ+mtJ9gEVIRlbWLFmCRGUzjV6eJi7Gx4GsGXPhHcAfBA
         OtezV9ngFi+0D6rHkiNq+z6++tjStTS7iNK/ijy6eX0MtvWRfvIFdRvDAhlyR9EvtsT7
         KUXvEmcYMQQBHGD9UB6JdGR+kjEmIXOFRX6RVTtNsPNy8ycztf3zIQO/qEZb8eXaKiiR
         ueDjc3IeshYNSPbWCyw1Tozc0dkE/oFLSKDQjjuCh06j+dS9elQxUhupZNinT0gLxAjC
         aVpw==
X-Gm-Message-State: APjAAAWVClyBLRiahpN+pK9YxceItsyW23y5wXUGqaFW60hFJm8i1In9
        dVAeFuLVSz9FR64ZMGSahCLg1i/wVzXYoxSYmCg=
X-Google-Smtp-Source: APXvYqw4F1aJ1XomvkPwJb2ul/BwawD/xPlwXKaQO7VSdJnCJgDsCPWMMhAZV2gwmG2Bf46wiug7mUCs3l8qkzXfZDM=
X-Received: by 2002:ac8:21b7:: with SMTP id 52mr64191092qty.59.1560553639512;
 Fri, 14 Jun 2019 16:07:19 -0700 (PDT)
MIME-Version: 1.0
References: <156042464138.25684.15061870566905680617.stgit@alrua-x1> <156042464155.25684.9001494922674130772.stgit@alrua-x1>
In-Reply-To: <156042464155.25684.9001494922674130772.stgit@alrua-x1>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jun 2019 16:07:08 -0700
Message-ID: <CAEf4BzZq4FBoFaaUCDnA8p=gRkUtzrDHOuYGibq1_98sPqaRUQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf_xdp_redirect_map: Perform map lookup
 in eBPF helper
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

On Thu, Jun 13, 2019 at 8:31 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> The bpf_redirect_map() helper used by XDP programs doesn't return any
> indication of whether it can successfully redirect to the map index it wa=
s
> given. Instead, BPF programs have to track this themselves, leading to
> programs using duplicate maps to track which entries are populated in the
> devmap.
>
> This patch fixes this by moving the map lookup into the bpf_redirect_map(=
)
> helper, which makes it possible to return failure to the eBPF program. Th=
e
> lower bits of the flags argument is used as the return code, which means
> that existing users who pass a '0' flag argument will get XDP_ABORTED.

I see that we have absolutely no documentation for
bpf_xdp_redirect_map. Can you please add it to
include/uapi/linux/bpf.h? Don't forget to mention this handling of
lower bits of flags. Thanks!

>
> With this, a BPF program can check the return code from the helper call a=
nd
> react by, for instance, substituting a different redirect. This works for
> any type of map used for redirect.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  include/linux/filter.h |    1 +
>  net/core/filter.c      |   27 +++++++++++++--------------
>  2 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 43b45d6db36d..f31ae8b9035a 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -580,6 +580,7 @@ struct bpf_skb_data_end {
>  struct bpf_redirect_info {
>         u32 ifindex;
>         u32 flags;
> +       void *item;

This is so generic name that some short comment describing what that
item is would help a lot.

>         struct bpf_map *map;
>         struct bpf_map *map_to_flush;
>         u32 kern_flags;
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 7a996887c500..7d742ea61e2d 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3608,17 +3608,13 @@ static int xdp_do_redirect_map(struct net_device =
*dev, struct xdp_buff *xdp,
>                                struct bpf_redirect_info *ri)
>  {
>         u32 index =3D ri->ifindex;
> -       void *fwd =3D NULL;
> +       void *fwd =3D ri->item;
>         int err;
>
>         ri->ifindex =3D 0;
> +       ri->item =3D NULL;
>         WRITE_ONCE(ri->map, NULL);
>
> -       fwd =3D __xdp_map_lookup_elem(map, index);
> -       if (unlikely(!fwd)) {
> -               err =3D -EINVAL;
> -               goto err;
> -       }
>         if (ri->map_to_flush && unlikely(ri->map_to_flush !=3D map))
>                 xdp_do_flush_map();
>
> @@ -3655,18 +3651,13 @@ static int xdp_do_generic_redirect_map(struct net=
_device *dev,
>  {
>         struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info)=
;
>         u32 index =3D ri->ifindex;
> -       void *fwd =3D NULL;
> +       void *fwd =3D ri->item;
>         int err =3D 0;
>
>         ri->ifindex =3D 0;
> +       ri->item =3D NULL;
>         WRITE_ONCE(ri->map, NULL);
>
> -       fwd =3D __xdp_map_lookup_elem(map, index);
> -       if (unlikely(!fwd)) {
> -               err =3D -EINVAL;
> -               goto err;
> -       }
> -
>         if (map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP) {
>                 struct bpf_dtab_netdev *dst =3D fwd;
>
> @@ -3735,6 +3726,7 @@ BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, fla=
gs)
>
>         ri->ifindex =3D ifindex;
>         ri->flags =3D flags;
> +       ri->item =3D NULL;
>         WRITE_ONCE(ri->map, NULL);
>
>         return XDP_REDIRECT;
> @@ -3753,9 +3745,16 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *,=
 map, u32, ifindex,
>  {
>         struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info)=
;
>
> -       if (unlikely(flags))
> +       /* Lower bits of the flags are used as return code on lookup fail=
ure */
> +       if (unlikely(flags > XDP_TX))
>                 return XDP_ABORTED;
>
> +       ri->item =3D __xdp_map_lookup_elem(map, ifindex);
> +       if (unlikely(!ri->item)) {
> +               WRITE_ONCE(ri->map, NULL);
> +               return flags;
> +       }
> +
>         ri->ifindex =3D ifindex;
>         ri->flags =3D flags;
>         WRITE_ONCE(ri->map, map);
>
