Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD2630E41B
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 21:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbhBCUeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 15:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbhBCUeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 15:34:21 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E5FC0613D6;
        Wed,  3 Feb 2021 12:33:40 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id f16so1015286wmq.5;
        Wed, 03 Feb 2021 12:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rvq4Dfhyh4fJ1W4POXfEh5I1ofblW0n5lluj9P5Qnpg=;
        b=Qm1a8vVLrO82aGS+yaiU1uw7P6h6BFsfSKT2A/1aw69fzNzo0tbdaj4ZCf88s100K/
         MiOHFeRIeNCh0T8obUKlb1dLyKUy38dAHhP4glrM8LKOdkYBpfTLRsLx6ZeBmMhVncEW
         eB7fCmFnYTh+he6Z4i/vREHEH0ZXpyHttFE5Zq9oFfYJesiPYbT93sYp7+MAyrkyiBF9
         U/rMpkDoAcVvYum4fOGwoWT2ciQAxJnwjdaa8Q+7RnEgBOKZ7h8sEstyWlWQeCEnW4n5
         mTgxwY/oiaMmjzzwewPCH9E1tGIQjB/hkgAaw5ptsmX1m3A1P+UCXd24DL87KcxXYbxn
         iRog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rvq4Dfhyh4fJ1W4POXfEh5I1ofblW0n5lluj9P5Qnpg=;
        b=KzU9s4mKB3+w9uYYOQg/wpfEOzf86hta8gFZUa2fWo5gS0cgf7U+XUiSg+OqPcucuw
         D8QNLD2e1xYTmYpvkU7nGmG3sXtAmRJNfF/INj/eC51EYrpKwaOYCBT1mHTLyEwsvzqa
         327PUKopmQ3MIV0wnxiYHoPwmb+NoS653C1evJ/60KXBej9qZoYeLBwv/xDF9TkoheK4
         GZ8hAq6szW7Pah/VrAjPi9BwBKUi2P3ecm40YkSkwQv1Vk0wlb/1sWAxICqOktzXwVry
         qOR65D6ujI286/N2snD4H9tva0bG1Urrr0Ni2mIEEmOaut0t+GhYeHdt2b1FuUwTlUP3
         LC7A==
X-Gm-Message-State: AOAM530bhAxEP+s+xPlvXEq2rLyIGWv5+9zoF021JuFQk8ZG57D9Mie4
        TBcBC+ezHci1Fh3Z/X7dm4at4FKXu/D51FMqkCE=
X-Google-Smtp-Source: ABdhPJzvnzLNoMuGQazQHTjr5w3Z3Xm/BTCzCJ2nKSclRo2HNLzgS4VzauF7TmpVIdxvZ/sA19S1pBE9Az/PL944Eew=
X-Received: by 2002:a05:600c:354c:: with SMTP id i12mr4455953wmq.51.1612384419667;
 Wed, 03 Feb 2021 12:33:39 -0800 (PST)
MIME-Version: 1.0
References: <20210202142901.7131-1-elic@nvidia.com> <CAPWQSg3Z1aCZc7kX2x_4NLtAzkrZ+eO5ABBF0bAQfaLc=++Y2Q@mail.gmail.com>
 <20210203064812.GA33072@mtl-vdi-166.wap.labs.mlnx>
In-Reply-To: <20210203064812.GA33072@mtl-vdi-166.wap.labs.mlnx>
From:   Si-Wei Liu <siwliu.kernel@gmail.com>
Date:   Wed, 3 Feb 2021 12:33:26 -0800
Message-ID: <CAPWQSg0OptdAstG10e+zMvD2ZHbHdS+o2ppUxZyM0kJsd34FdA@mail.gmail.com>
Subject: Re: [PATCH] vdpa/mlx5: Restore the hardware used index after change map
To:     Eli Cohen <elic@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lulu@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 10:48 PM Eli Cohen <elic@nvidia.com> wrote:
>
> On Tue, Feb 02, 2021 at 09:14:02AM -0800, Si-Wei Liu wrote:
> > On Tue, Feb 2, 2021 at 6:34 AM Eli Cohen <elic@nvidia.com> wrote:
> > >
> > > When a change of memory map occurs, the hardware resources are destroyed
> > > and then re-created again with the new memory map. In such case, we need
> > > to restore the hardware available and used indices. The driver failed to
> > > restore the used index which is added here.
> > >
> > > Fixes 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > ---
> > > This patch is being sent again a single patch the fixes hot memory
> > > addtion to a qemy process.
> > >
> > >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >
> > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > index 88dde3455bfd..839f57c64a6f 100644
> > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > @@ -87,6 +87,7 @@ struct mlx5_vq_restore_info {
> > >         u64 device_addr;
> > >         u64 driver_addr;
> > >         u16 avail_index;
> > > +       u16 used_index;
> > >         bool ready;
> > >         struct vdpa_callback cb;
> > >         bool restore;
> > > @@ -121,6 +122,7 @@ struct mlx5_vdpa_virtqueue {
> > >         u32 virtq_id;
> > >         struct mlx5_vdpa_net *ndev;
> > >         u16 avail_idx;
> > > +       u16 used_idx;
> > >         int fw_state;
> > >
> > >         /* keep last in the struct */
> > > @@ -804,6 +806,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
> > >
> > >         obj_context = MLX5_ADDR_OF(create_virtio_net_q_in, in, obj_context);
> > >         MLX5_SET(virtio_net_q_object, obj_context, hw_available_index, mvq->avail_idx);
> > > +       MLX5_SET(virtio_net_q_object, obj_context, hw_used_index, mvq->used_idx);
> >
> > The saved indexes will apply to the new virtqueue object whenever it
> > is created. In virtio spec, these indexes will reset back to zero when
> > the virtio device is reset. But I don't see how it's done today. IOW,
> > I don't see where avail_idx and used_idx get cleared from the mvq for
> > device reset via set_status().
> >
>
> Right, but this is not strictly related to this patch. I will post
> another patch to fix this.

Better to post these two patches in a series.Or else it may cause VM
reboot problem as that is where the device gets reset. The avail_index
did not as the correct value will be written to by driver right after,
but used_idx introduced by this patch is supplied by device hence this
patch alone would introduce regression.

>
> BTW, can you describe a secnario that would cause a reset (through
> calling set_status()) that happens after the VQ has been used?

You can try reboot the guest, that'll be the easy way to test.

-Siwei

>
> > -Siwei
> >
> >
> > >         MLX5_SET(virtio_net_q_object, obj_context, queue_feature_bit_mask_12_3,
> > >                  get_features_12_3(ndev->mvdev.actual_features));
> > >         vq_ctx = MLX5_ADDR_OF(virtio_net_q_object, obj_context, virtio_q_context);
> > > @@ -1022,6 +1025,7 @@ static int connect_qps(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
> > >  struct mlx5_virtq_attr {
> > >         u8 state;
> > >         u16 available_index;
> > > +       u16 used_index;
> > >  };
> > >
> > >  static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq,
> > > @@ -1052,6 +1056,7 @@ static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueu
> > >         memset(attr, 0, sizeof(*attr));
> > >         attr->state = MLX5_GET(virtio_net_q_object, obj_context, state);
> > >         attr->available_index = MLX5_GET(virtio_net_q_object, obj_context, hw_available_index);
> > > +       attr->used_index = MLX5_GET(virtio_net_q_object, obj_context, hw_used_index);
> > >         kfree(out);
> > >         return 0;
> > >
> > > @@ -1610,6 +1615,7 @@ static int save_channel_info(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
> > >                 return err;
> > >
> > >         ri->avail_index = attr.available_index;
> > > +       ri->used_index = attr.used_index;
> > >         ri->ready = mvq->ready;
> > >         ri->num_ent = mvq->num_ent;
> > >         ri->desc_addr = mvq->desc_addr;
> > > @@ -1654,6 +1660,7 @@ static void restore_channels_info(struct mlx5_vdpa_net *ndev)
> > >                         continue;
> > >
> > >                 mvq->avail_idx = ri->avail_index;
> > > +               mvq->used_idx = ri->used_index;
> > >                 mvq->ready = ri->ready;
> > >                 mvq->num_ent = ri->num_ent;
> > >                 mvq->desc_addr = ri->desc_addr;
> > > --
> > > 2.29.2
> > >
