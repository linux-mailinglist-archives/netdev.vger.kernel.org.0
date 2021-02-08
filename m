Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370C8312D4B
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 10:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhBHJaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 04:30:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231666AbhBHJ1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 04:27:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612776387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hYNmLVWjlxT+k3aE7QT+IAQgIjwsIKvrF+0CAZ8krTw=;
        b=MYg2BY+4qJXF388ilL5YLzk0TFEgG/3BkN20zPIFHnwFYrm+Ngj7HQRj6dghoPsLKy6S9Y
        nxaouX7yRUm/bcE9b6p7vcf0sOJQn1qOExPgstyx2f0mLMLX5BxMdocClRQRE5wlrRNj8x
        W7CEOsF+5yxUS9WT05G3pImIdhkjsfs=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-C79AO-vBO_iekZiMEZmVAg-1; Mon, 08 Feb 2021 04:26:26 -0500
X-MC-Unique: C79AO-vBO_iekZiMEZmVAg-1
Received: by mail-ej1-f72.google.com with SMTP id n25so11378303ejd.5
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 01:26:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hYNmLVWjlxT+k3aE7QT+IAQgIjwsIKvrF+0CAZ8krTw=;
        b=M4H+gcuTXeCLACHvcm4E61PGlhU5r3qxSuWfRUWlMrImzaqBS6+jKo4k1WXLwE978+
         1TIaj0deE1vu4W95dGcudwgiIag6W032AnhYV2Bj8NiiJVpG1HZwTHvm+pJpiIh2cKbj
         FC4rWu0XpxxhZuhO+2UaSrvTDkA3Dy/JGQ+9PwyN8a+XEfiMl6TioF9Rq9IdtyWQQKQK
         DZueDW9fwEp0+xD0TcTbb9M2nZ081JsGFD6tuomURedm1mbf1Q/JYfus4a1WtojXGhjv
         ips57xMh2YesLclrkIovG/636Dkut4M9w4cnNrUgTbnQ252znsHq7FLj0NaHU2VJVC/n
         Mnzg==
X-Gm-Message-State: AOAM531kMI/Nqkcl4BilMtDBjXXnxYPIfVZGTN6JifQ9ZOB5sSmXbcLE
        KuBAhdiNORzL+CY8hJqSivNbCf4Uciwwt5YgJj9x7QYz/zzdaz12TDhlFbU+BS6Szs4udbhicDt
        84XOITyAbHghKgbNh
X-Received: by 2002:a17:906:eca5:: with SMTP id qh5mr15724842ejb.161.1612776385083;
        Mon, 08 Feb 2021 01:26:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyibNH61CwO8ms8feBlBM9dIeJY33HJUrYrlTUUoVvEXAxh6h+ELKUu+dYdQYCPdzKvo2AxkQ==
X-Received: by 2002:a17:906:eca5:: with SMTP id qh5mr15724824ejb.161.1612776384845;
        Mon, 08 Feb 2021 01:26:24 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id y13sm4822537eds.25.2021.02.08.01.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 01:26:23 -0800 (PST)
Date:   Mon, 8 Feb 2021 04:26:20 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Eli Cohen <elic@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com
Subject: Re: [PATCH v1] vdpa/mlx5: Restore the hardware used index after
 change map
Message-ID: <20210208042512-mutt-send-email-mst@kernel.org>
References: <20210204073618.36336-1-elic@nvidia.com>
 <81f5ce4f-cdb0-26cd-0dce-7ada824b1b86@oracle.com>
 <f2206fa2-0ddc-1858-54e7-71614b142e46@redhat.com>
 <20210208063736.GA166546@mtl-vdi-166.wap.labs.mlnx>
 <0d592ed0-3cea-cfb0-9b7b-9d2755da3f12@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0d592ed0-3cea-cfb0-9b7b-9d2755da3f12@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 05:04:27PM +0800, Jason Wang wrote:
> 
> On 2021/2/8 下午2:37, Eli Cohen wrote:
> > On Mon, Feb 08, 2021 at 12:27:18PM +0800, Jason Wang wrote:
> > > On 2021/2/6 上午7:07, Si-Wei Liu wrote:
> > > > 
> > > > On 2/3/2021 11:36 PM, Eli Cohen wrote:
> > > > > When a change of memory map occurs, the hardware resources are destroyed
> > > > > and then re-created again with the new memory map. In such case, we need
> > > > > to restore the hardware available and used indices. The driver failed to
> > > > > restore the used index which is added here.
> > > > > 
> > > > > Also, since the driver also fails to reset the available and used
> > > > > indices upon device reset, fix this here to avoid regression caused by
> > > > > the fact that used index may not be zero upon device reset.
> > > > > 
> > > > > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5
> > > > > devices")
> > > > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > > > ---
> > > > > v0 -> v1:
> > > > > Clear indices upon device reset
> > > > > 
> > > > >    drivers/vdpa/mlx5/net/mlx5_vnet.c | 18 ++++++++++++++++++
> > > > >    1 file changed, 18 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > index 88dde3455bfd..b5fe6d2ad22f 100644
> > > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > @@ -87,6 +87,7 @@ struct mlx5_vq_restore_info {
> > > > >        u64 device_addr;
> > > > >        u64 driver_addr;
> > > > >        u16 avail_index;
> > > > > +    u16 used_index;
> > > > >        bool ready;
> > > > >        struct vdpa_callback cb;
> > > > >        bool restore;
> > > > > @@ -121,6 +122,7 @@ struct mlx5_vdpa_virtqueue {
> > > > >        u32 virtq_id;
> > > > >        struct mlx5_vdpa_net *ndev;
> > > > >        u16 avail_idx;
> > > > > +    u16 used_idx;
> > > > >        int fw_state;
> > > > >          /* keep last in the struct */
> > > > > @@ -804,6 +806,7 @@ static int create_virtqueue(struct mlx5_vdpa_net
> > > > > *ndev, struct mlx5_vdpa_virtque
> > > > >          obj_context = MLX5_ADDR_OF(create_virtio_net_q_in, in,
> > > > > obj_context);
> > > > >        MLX5_SET(virtio_net_q_object, obj_context, hw_available_index,
> > > > > mvq->avail_idx);
> > > > > +    MLX5_SET(virtio_net_q_object, obj_context, hw_used_index,
> > > > > mvq->used_idx);
> > > > >        MLX5_SET(virtio_net_q_object, obj_context,
> > > > > queue_feature_bit_mask_12_3,
> > > > >             get_features_12_3(ndev->mvdev.actual_features));
> > > > >        vq_ctx = MLX5_ADDR_OF(virtio_net_q_object, obj_context,
> > > > > virtio_q_context);
> > > > > @@ -1022,6 +1025,7 @@ static int connect_qps(struct mlx5_vdpa_net
> > > > > *ndev, struct mlx5_vdpa_virtqueue *m
> > > > >    struct mlx5_virtq_attr {
> > > > >        u8 state;
> > > > >        u16 available_index;
> > > > > +    u16 used_index;
> > > > >    };
> > > > >      static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct
> > > > > mlx5_vdpa_virtqueue *mvq,
> > > > > @@ -1052,6 +1056,7 @@ static int query_virtqueue(struct
> > > > > mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueu
> > > > >        memset(attr, 0, sizeof(*attr));
> > > > >        attr->state = MLX5_GET(virtio_net_q_object, obj_context, state);
> > > > >        attr->available_index = MLX5_GET(virtio_net_q_object,
> > > > > obj_context, hw_available_index);
> > > > > +    attr->used_index = MLX5_GET(virtio_net_q_object, obj_context,
> > > > > hw_used_index);
> > > > >        kfree(out);
> > > > >        return 0;
> > > > >    @@ -1535,6 +1540,16 @@ static void teardown_virtqueues(struct
> > > > > mlx5_vdpa_net *ndev)
> > > > >        }
> > > > >    }
> > > > >    +static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
> > > > > +{
> > > > > +    int i;
> > > > > +
> > > > > +    for (i = ndev->mvdev.max_vqs - 1; i >= 0; i--) {
> > > > > +        ndev->vqs[i].avail_idx = 0;
> > > > > +        ndev->vqs[i].used_idx = 0;
> > > > > +    }
> > > > > +}
> > > > > +
> > > > >    /* TODO: cross-endian support */
> > > > >    static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev
> > > > > *mvdev)
> > > > >    {
> > > > > @@ -1610,6 +1625,7 @@ static int save_channel_info(struct
> > > > > mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
> > > > >            return err;
> > > > >          ri->avail_index = attr.available_index;
> > > > > +    ri->used_index = attr.used_index;
> > > > >        ri->ready = mvq->ready;
> > > > >        ri->num_ent = mvq->num_ent;
> > > > >        ri->desc_addr = mvq->desc_addr;
> > > > > @@ -1654,6 +1670,7 @@ static void restore_channels_info(struct
> > > > > mlx5_vdpa_net *ndev)
> > > > >                continue;
> > > > >              mvq->avail_idx = ri->avail_index;
> > > > > +        mvq->used_idx = ri->used_index;
> > > > >            mvq->ready = ri->ready;
> > > > >            mvq->num_ent = ri->num_ent;
> > > > >            mvq->desc_addr = ri->desc_addr;
> > > > > @@ -1768,6 +1785,7 @@ static void mlx5_vdpa_set_status(struct
> > > > > vdpa_device *vdev, u8 status)
> > > > >        if (!status) {
> > > > >            mlx5_vdpa_info(mvdev, "performing device reset\n");
> > > > >            teardown_driver(ndev);
> > > > > +        clear_virtqueues(ndev);
> > > > The clearing looks fine at the first glance, as it aligns with the other
> > > > state cleanups floating around at the same place. However, the thing is
> > > > get_vq_state() is supposed to be called right after to get sync'ed with
> > > > the latest internal avail_index from device while vq is stopped. The
> > > > index was saved in the driver software at vq suspension, but before the
> > > > virtq object is destroyed. We shouldn't clear the avail_index too early.
> > > 
> > > Good point.
> > > 
> > > There's a limitation on the virtio spec and vDPA framework that we can not
> > > simply differ device suspending from device reset.
> > > 
> > Are you talking about live migration where you reset the device but
> > still want to know how far it progressed in order to continue from the
> > same place in the new VM?
> 
> 
> Yes. So if we want to support live migration at we need:
> 
> in src node:
> 1) suspend the device
> 2) get last_avail_idx via get_vq_state()
> 
> in the dst node:
> 3) set last_avail_idx via set_vq_state()
> 4) resume the device
> 
> So you can see, step 2 requires the device/driver not to forget the
> last_avail_idx.
> 
> The annoying thing is that, in the virtio spec there's no definition of
> device suspending. So we reuse set_status(0) right now for vq suspending.
> Then if we forget last_avail_idx in set_status(0), it will break the
> assumption of step 2).
> 
> 
> > 
> > > Need to think about that. I suggest a new state in [1], the issue is that
> > > people doesn't like the asynchronous API that it introduces.
> > > 
> > > 
> > > > Possibly it can be postponed to where VIRTIO_CONFIG_S_DRIVER_OK gets set
> > > > again, i.e. right before the setup_driver() in mlx5_vdpa_set_status()?
> > > 
> > > Looks like a good workaround.
> 
> 
> Rethink of this, this won't work for the step 4), if we reuse the S_DRING_OK
> for resuming.
> 
> The most clean way is to invent the feature in virtio spec and implement
> that in the driver.
> 
> Thanks

Given it's between parts of device (between qemu and host kernel)
I don't think we need it in the spec even. Just add a new ioctl.


> 
> 
> > > 
> > > Thanks
> > > 
> > > 
> > > > -Siwei
> > > 
> > > [1]
> > > https://lists.oasis-open.org/archives/virtio-comment/202012/msg00029.html
> > > 
> > > 
> > > > > mlx5_vdpa_destroy_mr(&ndev->mvdev);
> > > > >            ndev->mvdev.status = 0;
> > > > >            ndev->mvdev.mlx_features = 0;

