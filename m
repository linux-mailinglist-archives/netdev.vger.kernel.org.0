Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036A164C3F6
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 07:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbiLNGpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 01:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237426AbiLNGpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 01:45:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F291427DDA
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671000257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cidRDgZqxtksywXk9uj+Gw/8qnPipFSUxmvugOEn0l8=;
        b=NegGyEUOiH9tE1vjZdj2NkCGjOx+9sQKqjyIp25/6mJZT711vp5A+RCds9fasDbOeVB1XS
        hoEE11NvkdQJbz9qPCxr2h+jjRsLj6gxv+3SdeNpb/1NvVDsBAy2prOG/GQfq3oO6YZQ1f
        ig7LC/7mk8LUxzZfvyBrk8X0Hbc/8ow=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-557-hVhV6gKBP6S9Mc0NjVmaSw-1; Wed, 14 Dec 2022 01:44:15 -0500
X-MC-Unique: hVhV6gKBP6S9Mc0NjVmaSw-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-144da30bb39so4921155fac.10
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:44:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cidRDgZqxtksywXk9uj+Gw/8qnPipFSUxmvugOEn0l8=;
        b=UIqNZvel7nncMqTTtcOv+OWC9Ctb4ST6vLpNBwGD1a+rNUCcO6lLjVXZw0f+Zn/Rrh
         p0QrrO0790esS4RrFAtQ08ue4bUwKYOvstnH7ziGmieBubQxzWCu2q97bU5uMX86oOSF
         lhF26BvC0I4mDK38crgsqMKcH+KahfOthtAF+kETVaFjiHTab7GNkdr85lB2xm5fWCqm
         QVZ3MKThbFof8knI0StEBG1U+p+xaS6XImlFSn/1KT1ski3CUMBsOvLIJ/joiMe+3ok+
         uzqRR89M8qC4HzqZ8gtjyJgcpSqo6obw9ptyj/IWDMtzqRGuAYXqMgdiI+ouIBOjX/3B
         ZbZQ==
X-Gm-Message-State: ANoB5pmjKzlEn0F1NB/Vetx3frKFXWR3hdms5Ep1pyd8H2W0N4iG7+pt
        R1PJvjRZ5UmwdIkqUlQvgo6ToySNGQoBTO5zehaok12ILduGzXY+oibN6W9ghCH2ns8YP43Rx9q
        drztNLRbLff8iK53IVe61odFXS+V+NeKx
X-Received: by 2002:a05:6830:6505:b0:66c:fb5b:4904 with SMTP id cm5-20020a056830650500b0066cfb5b4904mr48697533otb.237.1671000254533;
        Tue, 13 Dec 2022 22:44:14 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6cIN84bLCKUyI703ovNJ3DSwbXF09M/aeJaEIlOqXHXVGeeavGBqog9RlL1FZLqrhES1+o9sZ9kvHtjVHfF+A=
X-Received: by 2002:a05:6830:6505:b0:66c:fb5b:4904 with SMTP id
 cm5-20020a056830650500b0066cfb5b4904mr48697525otb.237.1671000254283; Tue, 13
 Dec 2022 22:44:14 -0800 (PST)
MIME-Version: 1.0
References: <20221207145428.31544-1-gautam.dawar@amd.com> <20221207145428.31544-6-gautam.dawar@amd.com>
In-Reply-To: <20221207145428.31544-6-gautam.dawar@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 14 Dec 2022 14:44:03 +0800
Message-ID: <CACGkMEtzWYftw75U5nTWFLPGZBXWPWqq7POqg=OsWV3htZ1QjA@mail.gmail.com>
Subject: Re: [PATCH net-next 05/11] sfc: implement vdpa device config operations
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 10:56 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>
> vDPA config operations can be broadly categorized in to either
> virtqueue operations, device operations or DMA operations.
> This patch implements most of the device level config operations.
>
> SN1022 supports VIRTIO_F_IN_ORDER which is supported by the DPDK
> virtio driver but not the kernel virtio driver. Due to a bug in
> QEMU (https://gitlab.com/qemu-project/qemu/-/issues/331#), with
> vhost-vdpa, this feature bit is returned with guest kernel virtio
> driver in set_features config operation. The fix for this bug
> (qemu_commit c33f23a419f95da16ab4faaf08be635c89b96ff0) is available
> in QEMU versions 6.1.0 and later. Hence, that's the oldest QEMU
> version required for testing with the vhost-vdpa driver.
>
> With older QEMU releases, VIRTIO_F_IN_ORDER is negotiated but
> not honored causing Firmware exception.
>
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>  drivers/net/ethernet/sfc/ef100_vdpa.h     |  14 ++
>  drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 148 ++++++++++++++++++++++
>  2 files changed, 162 insertions(+)
>
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
> index 83f6d819f6a5..be7650c3166a 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
> @@ -21,6 +21,18 @@
>  /* Max queue pairs currently supported */
>  #define EF100_VDPA_MAX_QUEUES_PAIRS 1
>
> +/* Device ID of a virtio net device */
> +#define EF100_VDPA_VIRTIO_NET_DEVICE_ID VIRTIO_ID_NET
> +
> +/* Vendor ID of Xilinx vDPA NIC */
> +#define EF100_VDPA_VENDOR_ID  PCI_VENDOR_ID_XILINX
> +
> +/* Max number of Buffers supported in the virtqueue */
> +#define EF100_VDPA_VQ_NUM_MAX_SIZE 512
> +
> +/* Alignment requirement of the Virtqueue */
> +#define EF100_VDPA_VQ_ALIGN 4096
> +
>  /**
>   * enum ef100_vdpa_nic_state - possible states for a vDPA NIC
>   *
> @@ -61,6 +73,7 @@ enum ef100_vdpa_vq_type {
>   * @net_config: virtio_net_config data
>   * @mac_address: mac address of interface associated with this vdpa device
>   * @mac_configured: true after MAC address is configured
> + * @cfg_cb: callback for config change
>   */
>  struct ef100_vdpa_nic {
>         struct vdpa_device vdpa_dev;
> @@ -76,6 +89,7 @@ struct ef100_vdpa_nic {
>         struct virtio_net_config net_config;
>         u8 *mac_address;
>         bool mac_configured;
> +       struct vdpa_callback cfg_cb;
>  };
>
>  int ef100_vdpa_init(struct efx_probe_data *probe_data);
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> index 31952931c198..87899baa1c52 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> @@ -10,12 +10,148 @@
>
>  #include <linux/vdpa.h>
>  #include "ef100_vdpa.h"
> +#include "mcdi_vdpa.h"
>
>  static struct ef100_vdpa_nic *get_vdpa_nic(struct vdpa_device *vdev)
>  {
>         return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
>  }
>
> +static u32 ef100_vdpa_get_vq_align(struct vdpa_device *vdev)
> +{
> +       return EF100_VDPA_VQ_ALIGN;
> +}
> +
> +static u64 ef100_vdpa_get_device_features(struct vdpa_device *vdev)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +       u64 features;
> +       int rc;
> +
> +       rc = efx_vdpa_get_features(vdpa_nic->efx,
> +                                  EF100_VDPA_DEVICE_TYPE_NET, &features);
> +       if (rc) {
> +               dev_err(&vdev->dev, "%s: MCDI get features error:%d\n",
> +                       __func__, rc);
> +               /* Returning 0 as value of features will lead to failure
> +                * of feature negotiation.
> +                */
> +               return 0;
> +       }
> +
> +       /* SN1022 supports VIRTIO_F_IN_ORDER which is supported by the DPDK
> +        * virtio driver but not the kernel virtio driver. Due to a bug in
> +        * QEMU (https://gitlab.com/qemu-project/qemu/-/issues/331#), with
> +        * vhost-vdpa, this feature bit is returned with guest kernel virtio
> +        * driver in set_features config operation. The fix for this bug
> +        * (commit c33f23a419f95da16ab4faaf08be635c89b96ff0) is available
> +        * in QEMU versions 6.1.0 and later. Hence, that's the oldest QEMU
> +        * version required for testing with the vhost-vdpa driver.
> +        */

I don't see why this comment is placed here?

> +       features |= BIT_ULL(VIRTIO_NET_F_MAC);
> +
> +       return features;
> +}
> +
> +static int ef100_vdpa_set_driver_features(struct vdpa_device *vdev,
> +                                         u64 features)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +       u64 verify_features;
> +       int rc;
> +
> +       mutex_lock(&vdpa_nic->lock);
> +       if (vdpa_nic->vdpa_state != EF100_VDPA_STATE_INITIALIZED) {

Under which case could we reach this condition? The
vdpa_device_register() should be called after switching the state to
EF100_VDPA_STATE_INITIALIZED.

> +               dev_err(&vdev->dev, "%s: Invalid state %u\n",
> +                       __func__, vdpa_nic->vdpa_state);
> +               rc = -EINVAL;
> +               goto err;
> +       }
> +       verify_features = features & ~BIT_ULL(VIRTIO_NET_F_MAC);
> +       rc = efx_vdpa_verify_features(vdpa_nic->efx,
> +                                     EF100_VDPA_DEVICE_TYPE_NET,
> +                                     verify_features);

It looks to me this will use MC_CMD_VIRTIO_TEST_FEATURES command, I
wonder if it's better to use

MC_CMD_VIRTIO_SET_FEATURES to align with the virtio spec and maybe
change efx_vdpa_verify_features to efx_vdpa_set_features()?

> +
> +       if (rc) {
> +               dev_err(&vdev->dev, "%s: MCDI verify features error:%d\n",
> +                       __func__, rc);
> +               goto err;
> +       }
> +
> +       vdpa_nic->features = features;
> +err:
> +       mutex_unlock(&vdpa_nic->lock);
> +       return rc;
> +}
> +
> +static u64 ef100_vdpa_get_driver_features(struct vdpa_device *vdev)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +
> +       return vdpa_nic->features;
> +}
> +
> +static void ef100_vdpa_set_config_cb(struct vdpa_device *vdev,
> +                                    struct vdpa_callback *cb)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +
> +       if (cb)
> +               vdpa_nic->cfg_cb = *cb;
> +}
> +
> +static u16 ef100_vdpa_get_vq_num_max(struct vdpa_device *vdev)
> +{
> +       return EF100_VDPA_VQ_NUM_MAX_SIZE;
> +}
> +
> +static u32 ef100_vdpa_get_device_id(struct vdpa_device *vdev)
> +{
> +       return EF100_VDPA_VIRTIO_NET_DEVICE_ID;
> +}
> +
> +static u32 ef100_vdpa_get_vendor_id(struct vdpa_device *vdev)
> +{
> +       return EF100_VDPA_VENDOR_ID;
> +}
> +
> +static size_t ef100_vdpa_get_config_size(struct vdpa_device *vdev)
> +{
> +       return sizeof(struct virtio_net_config);
> +}
> +
> +static void ef100_vdpa_get_config(struct vdpa_device *vdev,
> +                                 unsigned int offset,
> +                                 void *buf, unsigned int len)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +
> +       /* Avoid the possibility of wrap-up after the sum exceeds U32_MAX */
> +       if (WARN_ON(((u64)offset + len) > sizeof(struct virtio_net_config))) {
> +               dev_err(&vdev->dev,
> +                       "%s: Offset + len exceeds config size\n", __func__);
> +               return;

I wonder if we need similar checks in the vdpa core.

> +       }
> +       memcpy(buf, (u8 *)&vdpa_nic->net_config + offset, len);
> +}
> +
> +static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
> +                                 const void *buf, unsigned int len)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +
> +       /* Avoid the possibility of wrap-up after the sum exceeds U32_MAX */
> +       if (WARN_ON(((u64)offset + len) > sizeof(vdpa_nic->net_config))) {
> +               dev_err(&vdev->dev,
> +                       "%s: Offset + len exceeds config size\n", __func__);
> +               return;
> +       }
> +
> +       memcpy((u8 *)&vdpa_nic->net_config + offset, buf, len);
> +       if (is_valid_ether_addr(vdpa_nic->mac_address))
> +               vdpa_nic->mac_configured = true;

Do we need to update hardware filters?

Thanks

> +}
> +
>  static void ef100_vdpa_free(struct vdpa_device *vdev)
>  {
>         struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> @@ -24,5 +160,17 @@ static void ef100_vdpa_free(struct vdpa_device *vdev)
>  }
>
>  const struct vdpa_config_ops ef100_vdpa_config_ops = {
> +       .get_vq_align        = ef100_vdpa_get_vq_align,
> +       .get_device_features = ef100_vdpa_get_device_features,
> +       .set_driver_features = ef100_vdpa_set_driver_features,
> +       .get_driver_features = ef100_vdpa_get_driver_features,
> +       .set_config_cb       = ef100_vdpa_set_config_cb,
> +       .get_vq_num_max      = ef100_vdpa_get_vq_num_max,
> +       .get_device_id       = ef100_vdpa_get_device_id,
> +       .get_vendor_id       = ef100_vdpa_get_vendor_id,
> +       .get_config_size     = ef100_vdpa_get_config_size,
> +       .get_config          = ef100_vdpa_get_config,
> +       .set_config          = ef100_vdpa_set_config,
> +       .get_generation      = NULL,
>         .free                = ef100_vdpa_free,
>  };
> --
> 2.30.1
>

