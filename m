Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5DF3FCEE4
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 22:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241375AbhHaU7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 16:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241439AbhHaU7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 16:59:21 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5A6C061575;
        Tue, 31 Aug 2021 13:58:26 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id j17-20020a05600c1c1100b002e754875260so407895wms.4;
        Tue, 31 Aug 2021 13:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oXxQWaZsMEHoVTJrqgYITySMx2uaDRQ5kh4mc39F7og=;
        b=bDjRoBDikj7dNGY3hpaPTIcNEuOOL5xJfQc+9ebmJn4glM74YrA6Kj4OD2vIwMXzPN
         XvrOtgVU7JfEDQolHddLzYd4DyZAo3dH3vhzPtMgg2z9828CKGFHhc8kl5FpJlCceovk
         eqvzkWx9vnSj+0Nm4GucuCbw3SECzynHX3oDy3eQ1SVjI79SNk5d0HqJnTz884lsqQJx
         cMQ8CsIYfgnJm/vkoGnhS266lpWotZSGhwyPU+WRfnp1iKgD3Ux/Ia45AhooMTKmmLke
         w085tbgaWKsYtmoWZewPFv6hJ5PqlJ6kCUva6hDUm41JJisDW4L6WgitISPax6kKWcfT
         LU0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oXxQWaZsMEHoVTJrqgYITySMx2uaDRQ5kh4mc39F7og=;
        b=j8RF+Fr3IU7tbTzKv764NOw1+QRg72g1ufvLLJDYHZQD3FZTjFOeGETJ73gbVflacj
         8HYF8x3D7fCD3q3zu+CizIIin2p76YlM4nFnfIprj6ie06BJPSKuhUGAWjFBe9ilQzi/
         5DCiy0/lvIsUvcnQEeRTuDZYFLYldTPKPypPiEAzyIi+uKW26artbwnMpSD2+5148UON
         kJ2bUMUU/NgSn+t1FtWO5OY21IhD1HG/97oNtfis+zsjTceN5L27NshTVFI6KBdFdJmg
         xILf8ciHD4LirwPZuKaXrOznWv8u2tO9AW3RMD5uxtD4X+tvB1AGi6Lw/OMbE+GBaLVF
         CL7w==
X-Gm-Message-State: AOAM532fXXDxEf2Sj9iQg7WtkzEhjyeqOms02zAQmeT2H7eCWJ/VvwDE
        YzEa6NgnbbmGj3REL8O+Oz1d47jzgiCp/+otPFogbdnQ
X-Google-Smtp-Source: ABdhPJyopGXcJ++6NauieQFKVd0DyK4q88qcf+FcgKGHXOep3/JVdObMskUhyxX9lfmt1S4g/bZy0YhKOIkuuASIxZ0=
X-Received: by 2002:a1c:4e11:: with SMTP id g17mr6269680wmh.2.1630443504774;
 Tue, 31 Aug 2021 13:58:24 -0700 (PDT)
MIME-Version: 1.0
References: <1619660934-30910-1-git-send-email-si-wei.liu@oracle.com>
 <1619660934-30910-2-git-send-email-si-wei.liu@oracle.com> <CAPWQSg1LLgxJYciTF1OatnFS-y058A94CsAg-67t94-2Dz7TKA@mail.gmail.com>
In-Reply-To: <CAPWQSg1LLgxJYciTF1OatnFS-y058A94CsAg-67t94-2Dz7TKA@mail.gmail.com>
From:   Si-Wei Liu <siwliu.kernel@gmail.com>
Date:   Tue, 31 Aug 2021 13:58:13 -0700
Message-ID: <CAPWQSg0_WgYhWfDGQres8pK_ujpv8arfKkReqZ-A3PJA0aG_iw@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] vdpa/mlx5: fix feature negotiation across device reset
To:     mst@redhat.com
Cc:     Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Si-Wei Liu <si-wei.liu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gentle ping.

-Siwei

On Wed, Aug 25, 2021 at 5:00 PM Si-Wei Liu <siwliu.kernel@gmail.com> wrote:
>
> Hi Michael,
>
> This patch already got reviewed, though not sure why it was not picked
> yet. We've been running into this issue quite a lot recently, the
> typical symptom of which is that invalid checksum on TCP or UDP header
> sent by vdpa is causing silent packet drops on the peer host. Only
> ICMP traffic can get through. Would you please merge it at your
> earliest convenience?
>
> Thanks,
> -Siwei
>
> On Wed, Apr 28, 2021 at 6:51 PM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
> >
> > The mlx_features denotes the capability for which
> > set of virtio features is supported by device. In
> > principle, this field needs not be cleared during
> > virtio device reset, as this capability is static
> > and does not change across reset.
> >
> > In fact, the current code seems to wrongly assume
> > that mlx_features can be reloaded or updated on
> > device reset thru the .get_features op. However,
> > the userspace VMM may save a copy of previously
> > advertised backend feature capability and won't
> > need to get it again on reset. In that event, all
> > virtio features reset to zero thus getting disabled
> > upon device reset. This ends up with guest holding
> > a mismatched view of available features with the
> > VMM/host's. For instance, the guest may assume
> > the presence of tx checksum offload feature across
> > reboot, however, since the feature is left disabled
> > on reset, frames with bogus partial checksum are
> > transmitted on the wire.
> >
> > The fix is to retain the features capability on
> > reset, and get it only once from firmware on the
> > vdpa_dev_add path.
> >
> > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> > Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> > Acked-by: Eli Cohen <elic@nvidia.com>
> > Acked-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 25 +++++++++++++++----------
> >  1 file changed, 15 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > index 25533db..624f521 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -1492,16 +1492,8 @@ static u64 mlx_to_vritio_features(u16 dev_features)
> >  static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
> >  {
> >         struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
> > -       struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> > -       u16 dev_features;
> >
> > -       dev_features = MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, device_features_bits_mask);
> > -       ndev->mvdev.mlx_features = mlx_to_vritio_features(dev_features);
> > -       if (MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, virtio_version_1_0))
> > -               ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_F_VERSION_1);
> > -       ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_F_ACCESS_PLATFORM);
> > -       print_features(mvdev, ndev->mvdev.mlx_features, false);
> > -       return ndev->mvdev.mlx_features;
> > +       return mvdev->mlx_features;
> >  }
> >
> >  static int verify_min_features(struct mlx5_vdpa_dev *mvdev, u64 features)
> > @@ -1783,7 +1775,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
> >                 teardown_driver(ndev);
> >                 mlx5_vdpa_destroy_mr(&ndev->mvdev);
> >                 ndev->mvdev.status = 0;
> > -               ndev->mvdev.mlx_features = 0;
> >                 ++mvdev->generation;
> >                 return;
> >         }
> > @@ -1902,6 +1893,19 @@ static int mlx5_get_vq_irq(struct vdpa_device *vdv, u16 idx)
> >         .free = mlx5_vdpa_free,
> >  };
> >
> > +static void query_virtio_features(struct mlx5_vdpa_net *ndev)
> > +{
> > +       struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
> > +       u16 dev_features;
> > +
> > +       dev_features = MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, device_features_bits_mask);
> > +       mvdev->mlx_features = mlx_to_vritio_features(dev_features);
> > +       if (MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, virtio_version_1_0))
> > +               mvdev->mlx_features |= BIT_ULL(VIRTIO_F_VERSION_1);
> > +       mvdev->mlx_features |= BIT_ULL(VIRTIO_F_ACCESS_PLATFORM);
> > +       print_features(mvdev, mvdev->mlx_features, false);
> > +}
> > +
> >  static int query_mtu(struct mlx5_core_dev *mdev, u16 *mtu)
> >  {
> >         u16 hw_mtu;
> > @@ -2009,6 +2013,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
> >         init_mvqs(ndev);
> >         mutex_init(&ndev->reslock);
> >         config = &ndev->config;
> > +       query_virtio_features(ndev);
> >         err = query_mtu(mdev, &ndev->mtu);
> >         if (err)
> >                 goto err_mtu;
> > --
> > 1.8.3.1
> >
