Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D2664C405
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 07:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237497AbiLNGrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 01:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237442AbiLNGrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 01:47:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6D42872B
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671000371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4/uGgWeyPpUkK7Ij8q3Mfl77hPjQRLagdr15VkXWvMU=;
        b=eTFCMDCMtEBsPRpENfxWAXrCo8uOXxJ0E6JQH0nH/zNEzIQu7RwafqYmEPHLoJx0uUB9x+
        gaSMYX07lWGBYBg9Ar5YeVxjlkj8jANCC7/Duyl77rkFtw1PtASD7rzpBVM/9nKTb+u7rJ
        3+HQBj4UMosOI2DFy3s+al7r4lQV5B4=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-599-DX2mgKD-NMu12pXmIQkYSg-1; Wed, 14 Dec 2022 01:46:07 -0500
X-MC-Unique: DX2mgKD-NMu12pXmIQkYSg-1
Received: by mail-oo1-f69.google.com with SMTP id u22-20020a4a6c56000000b004a38aa46a1fso6206064oof.22
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:46:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4/uGgWeyPpUkK7Ij8q3Mfl77hPjQRLagdr15VkXWvMU=;
        b=uebLdZ6txMjGDgPF1DC+LEAJ/Ubl4gEN1r7stfANpaR2f498Q3wFiLOpJFaXprPHbU
         tOJhbKWRvvkJHZ6yCwzmIXVtKf9kHATa1zbpeS/4W3YydlyZmmWKwLQQIvtS6DfwuORq
         FwWplICqugadtqMpHedG49NZvwhxMAt9v9+hk/jTMCnMn7BSkW0Ef2wGjiT9Idtu5xWc
         /+ePiFY2+COtIPZ25byxfGsc8Ebz0Lf1Z8Y0YBk8qsXLc/yQbyoNyDtQRls0M0+fOOQG
         KU1TjEYsleOYzMtGuEe1brUKHPR092B5ijnw61XJODaESNirsa5YtN17OG7yPo9BYnYN
         CP5w==
X-Gm-Message-State: AFqh2kq63J7Jv8VTJhbvr2XOSc9wVq+y0KeFHCgAA6orTe32XT1kgJVi
        ducd+1Cjuq8sX5ZGoe0H0gy9zD5vibOw67z+UuGBa8dBWeysTccF8LEzZ7UPP1Lg3aLycCunAVd
        xy7jmA1Nz/FCZKUvQuL4B09rhbOM9BkuD
X-Received: by 2002:a05:6870:41c7:b0:144:a97b:1ae2 with SMTP id z7-20020a05687041c700b00144a97b1ae2mr107913oac.35.1671000366430;
        Tue, 13 Dec 2022 22:46:06 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtcRZ22jl8YXWE+Ou5mo3nHgzRE0JO54AgFrrqC8Ly52HjwSUKGCden9upEeqPXBdroLUSLQS6K+mq6Or1SYYA=
X-Received: by 2002:a05:6870:41c7:b0:144:a97b:1ae2 with SMTP id
 z7-20020a05687041c700b00144a97b1ae2mr107900oac.35.1671000366177; Tue, 13 Dec
 2022 22:46:06 -0800 (PST)
MIME-Version: 1.0
References: <20221207145428.31544-1-gautam.dawar@amd.com> <20221207145428.31544-9-gautam.dawar@amd.com>
In-Reply-To: <20221207145428.31544-9-gautam.dawar@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 14 Dec 2022 14:45:55 +0800
Message-ID: <CACGkMEtGCbUBZRFh7EUJyymuWZ9uxiAOeJHA6h-dGa9Y3pDZGw@mail.gmail.com>
Subject: Re: [PATCH net-next 08/11] sfc: implement device status related vdpa
 config operations
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, netdev@vger.kernel.org,
        eperezma@redhat.com, tanuj.kamde@amd.com, Koushik.Dutta@amd.com,
        harpreet.anand@amd.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 10:57 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>
> vDPA config opertions to handle get/set device status and device
> reset have been implemented.
>
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>  drivers/net/ethernet/sfc/ef100_vdpa.c     |   7 +-
>  drivers/net/ethernet/sfc/ef100_vdpa.h     |   1 +
>  drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 133 ++++++++++++++++++++++
>  3 files changed, 140 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
> index 04d64bfe3c93..80bca281a748 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
> @@ -225,9 +225,14 @@ static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int *allocated_vis)
>
>  static void ef100_vdpa_delete(struct efx_nic *efx)
>  {
> +       struct vdpa_device *vdpa_dev;
> +
>         if (efx->vdpa_nic) {
> +               vdpa_dev = &efx->vdpa_nic->vdpa_dev;
> +               ef100_vdpa_reset(vdpa_dev);

Any reason we need to reset during delete?

> +
>                 /* replace with _vdpa_unregister_device later */
> -               put_device(&efx->vdpa_nic->vdpa_dev.dev);
> +               put_device(&vdpa_dev->dev);
>                 efx->vdpa_nic = NULL;
>         }
>         efx_mcdi_free_vis(efx);
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
> index a33edd6dda12..1b0bbba88154 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
> @@ -186,6 +186,7 @@ int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
>                           enum ef100_vdpa_mac_filter_type type);
>  int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev, u16 nvqs);
>  void ef100_vdpa_irq_vectors_free(void *data);
> +int ef100_vdpa_reset(struct vdpa_device *vdev);
>
>  static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
>  {
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> index 132ddb4a647b..718b67f6da90 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> @@ -251,6 +251,62 @@ static bool is_qid_invalid(struct ef100_vdpa_nic *vdpa_nic, u16 idx,
>         return false;
>  }
>
> +static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
> +{
> +       int i;
> +
> +       WARN_ON(!mutex_is_locked(&vdpa_nic->lock));
> +
> +       if (!vdpa_nic->status)
> +               return;
> +
> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
> +       vdpa_nic->status = 0;
> +       vdpa_nic->features = 0;
> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
> +               reset_vring(vdpa_nic, i);
> +}
> +
> +/* May be called under the rtnl lock */
> +int ef100_vdpa_reset(struct vdpa_device *vdev)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +
> +       /* vdpa device can be deleted anytime but the bar_config
> +        * could still be vdpa and hence efx->state would be STATE_VDPA.
> +        * Accordingly, ensure vdpa device exists before reset handling
> +        */
> +       if (!vdpa_nic)
> +               return -ENODEV;
> +
> +       mutex_lock(&vdpa_nic->lock);
> +       ef100_reset_vdpa_device(vdpa_nic);
> +       mutex_unlock(&vdpa_nic->lock);
> +       return 0;
> +}
> +
> +static int start_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
> +{
> +       int rc = 0;
> +       int i, j;
> +
> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
> +               if (can_create_vring(vdpa_nic, i)) {
> +                       rc = create_vring(vdpa_nic, i);

So I think we can safely remove the create_vring() in set_vq_ready()
since it's undefined behaviour if set_vq_ready() is called after
DRIVER_OK.

> +                       if (rc)
> +                               goto clear_vring;
> +               }
> +       }
> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_STARTED;
> +       return rc;
> +
> +clear_vring:
> +       for (j = 0; j < i; j++)
> +               if (vdpa_nic->vring[j].vring_created)
> +                       delete_vring(vdpa_nic, j);
> +       return rc;
> +}
> +
>  static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
>                                      u16 idx, u64 desc_area, u64 driver_area,
>                                      u64 device_area)
> @@ -568,6 +624,80 @@ static u32 ef100_vdpa_get_vendor_id(struct vdpa_device *vdev)
>         return EF100_VDPA_VENDOR_ID;
>  }
>
> +static u8 ef100_vdpa_get_status(struct vdpa_device *vdev)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +       u8 status;
> +
> +       mutex_lock(&vdpa_nic->lock);
> +       status = vdpa_nic->status;
> +       mutex_unlock(&vdpa_nic->lock);
> +       return status;
> +}
> +
> +static void ef100_vdpa_set_status(struct vdpa_device *vdev, u8 status)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +       u8 new_status;
> +       int rc;
> +
> +       mutex_lock(&vdpa_nic->lock);
> +       if (!status) {
> +               dev_info(&vdev->dev,
> +                        "%s: Status received is 0. Device reset being done\n",
> +                        __func__);
> +               ef100_reset_vdpa_device(vdpa_nic);
> +               goto unlock_return;
> +       }
> +       new_status = status & ~vdpa_nic->status;
> +       if (new_status == 0) {
> +               dev_info(&vdev->dev,
> +                        "%s: New status same as current status\n", __func__);
> +               goto unlock_return;
> +       }
> +       if (new_status & VIRTIO_CONFIG_S_FAILED) {
> +               ef100_reset_vdpa_device(vdpa_nic);
> +               goto unlock_return;
> +       }
> +
> +       if (new_status & VIRTIO_CONFIG_S_ACKNOWLEDGE &&
> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {

As replied before, I think there's no need to check
EF100_VDPA_STATE_INITIALIZED, otherwise it could be a bug somewhere.

> +               vdpa_nic->status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
> +               new_status &= ~VIRTIO_CONFIG_S_ACKNOWLEDGE;
> +       }
> +       if (new_status & VIRTIO_CONFIG_S_DRIVER &&
> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {
> +               vdpa_nic->status |= VIRTIO_CONFIG_S_DRIVER;
> +               new_status &= ~VIRTIO_CONFIG_S_DRIVER;
> +       }
> +       if (new_status & VIRTIO_CONFIG_S_FEATURES_OK &&
> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {
> +               vdpa_nic->status |= VIRTIO_CONFIG_S_FEATURES_OK;
> +               vdpa_nic->vdpa_state = EF100_VDPA_STATE_NEGOTIATED;

I think we can simply map EF100_VDPA_STATE_NEGOTIATED to
VIRTIO_CONFIG_S_FEATURES_OK.

E.g the code doesn't fail the feature negotiation by clearing the
VIRTIO_CONFIG_S_FEATURES_OK when ef100_vdpa_set_driver_feature fails?

Thanks

