Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB2C6B35EE
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 06:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjCJFH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 00:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjCJFHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 00:07:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9FF101F29
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 21:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678424750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FAlsLYnrN0th/0vWa2mOM33oIBHWgS3fLMgonOPj3XQ=;
        b=NpD4BxhOUgANmCmlsN+rOyY0igG33HUMVMSDArPGpvSZyjAiiSe/WotdQmHIGjSwCPgbO2
        5mr7UJg9si4zMhHjd+Dd5+G1FpTTmBU1mdB4K0XCzDmLEUqB+QFA7Pj5S5itcjJQkiLQz/
        3JVrt2DzmwCG7qEzIfT9NrKTFm7y05M=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-GlDLlAd1Oi21WPvjhW-9Cg-1; Fri, 10 Mar 2023 00:05:48 -0500
X-MC-Unique: GlDLlAd1Oi21WPvjhW-9Cg-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-176e6682ee8so2223093fac.8
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 21:05:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678424748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FAlsLYnrN0th/0vWa2mOM33oIBHWgS3fLMgonOPj3XQ=;
        b=xQWdoU8hNPuuJ2UlRYMqC98EUgwG8+uL/wkYNxX9EwuTSrePPQQXu5D5JdDZJkgIRK
         +07JYG1qfc1htRSq3K+bdWbA1p6pE/GRqe13EkDFq5lMy38OjlC/7tTNF9Ec/NayO1yE
         vLQ4GSdVua0ZBz01JoLDSH6Gd29+s3ecKy2P85+K+beJAdBTYidDsWj2O/z+jPd1QQho
         nDJiZORNLRZEttP1UBjGawY7Juerp5ZCC2EIYqP7QcMdUhNcThL6zszAeqhoJoqkP93S
         CxZ6G6Ib+RyKktsL/FlTW+e6SW16SxOF7cTZpvJzPNAUcT7l9vCuz4+0YVrcZ/J62fC2
         PuiA==
X-Gm-Message-State: AO0yUKX+kQP5psFtmTCiizu3VjD1jg5IgKdNmiXZevAQVhzkr5TjPoMu
        OXqi4kOQEC6D1JMdncqZ7Wjeij0P3dlUfq5B7tdwtyUFhQOLP1S+mqWJxFkwOx0s+YWAulTNMuF
        tbd/zZLUZs5jqcpYxTD5bdtB0ANOHXu1O
X-Received: by 2002:a54:4612:0:b0:383:fad3:d19 with SMTP id p18-20020a544612000000b00383fad30d19mr8189937oip.9.1678424747819;
        Thu, 09 Mar 2023 21:05:47 -0800 (PST)
X-Google-Smtp-Source: AK7set/fkmRwwdsDTdSF7Vl4jkopjsUKma/sFTLMm2F1JXV6gtuWi6+7/FrtFSE+Oyl3xVKvQHI1QeSMrez3jOfkRzo=
X-Received: by 2002:a54:4612:0:b0:383:fad3:d19 with SMTP id
 p18-20020a544612000000b00383fad30d19mr8189920oip.9.1678424747483; Thu, 09 Mar
 2023 21:05:47 -0800 (PST)
MIME-Version: 1.0
References: <20230307113621.64153-1-gautam.dawar@amd.com> <20230307113621.64153-13-gautam.dawar@amd.com>
In-Reply-To: <20230307113621.64153-13-gautam.dawar@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 10 Mar 2023 13:05:36 +0800
Message-ID: <CACGkMEuvJF9WXu0N+d-54hB=kGgjU=zNk=620d7chinRWz=j5Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 12/14] sfc: unmap VF's MCDI buffer when
 switching to vDPA mode
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 7, 2023 at 7:38=E2=80=AFPM Gautam Dawar <gautam.dawar@amd.com> =
wrote:
>
> To avoid clash of IOVA range of VF's MCDI DMA buffer with the guest
> buffer IOVAs, unmap the MCDI buffer when switching to vDPA mode
> and use PF's IOMMU domain for running VF's MCDI commands.
>
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>  drivers/net/ethernet/sfc/ef100_nic.c      |  1 -
>  drivers/net/ethernet/sfc/ef100_vdpa.c     | 25 ++++++++++++++++
>  drivers/net/ethernet/sfc/ef100_vdpa.h     |  3 ++
>  drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 35 +++++++++++++++++++++++
>  drivers/net/ethernet/sfc/mcdi.h           |  3 ++
>  drivers/net/ethernet/sfc/net_driver.h     | 12 ++++++++
>  6 files changed, 78 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/=
sfc/ef100_nic.c
> index cd9f724a9e64..1bffc1994ed8 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> @@ -33,7 +33,6 @@
>
>  #define EF100_MAX_VIS 4096
>  #define EF100_NUM_MCDI_BUFFERS 1
> -#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
>
>  #define EF100_RESET_PORT ((ETH_RESET_MAC | ETH_RESET_PHY) << ETH_RESET_S=
HARED_SHIFT)
>
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet=
/sfc/ef100_vdpa.c
> index 5c9f29f881a6..30ca4ab00175 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
> @@ -223,10 +223,19 @@ static int vdpa_allocate_vis(struct efx_nic *efx, u=
nsigned int *allocated_vis)
>  static void ef100_vdpa_delete(struct efx_nic *efx)
>  {
>         struct vdpa_device *vdpa_dev;
> +       int rc;
>
>         if (efx->vdpa_nic) {
>                 vdpa_dev =3D &efx->vdpa_nic->vdpa_dev;
>                 ef100_vdpa_reset(vdpa_dev);
> +               if (efx->mcdi_buf_mode =3D=3D EFX_BUF_MODE_VDPA) {
> +                       rc =3D ef100_vdpa_map_mcdi_buffer(efx);
> +                       if (rc) {
> +                               pci_err(efx->pci_dev,
> +                                       "map_mcdi_buffer failed, err: %d\=
n",
> +                                       rc);
> +                       }
> +               }
>
>                 /* replace with _vdpa_unregister_device later */
>                 put_device(&vdpa_dev->dev);
> @@ -276,6 +285,21 @@ static int get_net_config(struct ef100_vdpa_nic *vdp=
a_nic)
>         return 0;
>  }
>
> +static void unmap_mcdi_buffer(struct efx_nic *efx)
> +{
> +       struct ef100_nic_data *nic_data =3D efx->nic_data;
> +       struct efx_mcdi_iface *mcdi;
> +
> +       mcdi =3D efx_mcdi(efx);
> +       spin_lock_bh(&mcdi->iface_lock);
> +       /* Save current MCDI mode to be restored later */
> +       efx->vdpa_nic->mcdi_mode =3D mcdi->mode;
> +       efx->mcdi_buf_mode =3D EFX_BUF_MODE_VDPA;
> +       mcdi->mode =3D MCDI_MODE_FAIL;
> +       spin_unlock_bh(&mcdi->iface_lock);
> +       efx_nic_free_buffer(efx, &nic_data->mcdi_buf);
> +}
> +
>  static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>                                                 const char *dev_name,
>                                                 enum ef100_vdpa_class dev=
_type,
> @@ -342,6 +366,7 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struc=
t efx_nic *efx,
>         for (i =3D 0; i < EF100_VDPA_MAC_FILTER_NTYPES; i++)
>                 vdpa_nic->filters[i].filter_id =3D EFX_INVALID_FILTER_ID;
>
> +       unmap_mcdi_buffer(efx);
>         rc =3D get_net_config(vdpa_nic);
>         if (rc)
>                 goto err_put_device;
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet=
/sfc/ef100_vdpa.h
> index 49fb6be04eb3..0913ac2519cb 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
> @@ -147,6 +147,7 @@ struct ef100_vdpa_filter {
>   * @status: device status as per VIRTIO spec
>   * @features: negotiated feature bits
>   * @max_queue_pairs: maximum number of queue pairs supported
> + * @mcdi_mode: MCDI mode at the time of unmapping VF mcdi buffer
>   * @net_config: virtio_net_config data
>   * @vring: vring information of the vDPA device.
>   * @mac_address: mac address of interface associated with this vdpa devi=
ce
> @@ -166,6 +167,7 @@ struct ef100_vdpa_nic {
>         u8 status;
>         u64 features;
>         u32 max_queue_pairs;
> +       enum efx_mcdi_mode mcdi_mode;
>         struct virtio_net_config net_config;
>         struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * =
2];
>         u8 *mac_address;
> @@ -185,6 +187,7 @@ int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa=
_nic,
>  int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
>  void ef100_vdpa_irq_vectors_free(void *data);
>  int ef100_vdpa_reset(struct vdpa_device *vdev);
> +int ef100_vdpa_map_mcdi_buffer(struct efx_nic *efx);
>
>  static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa=
_nic)
>  {
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethe=
rnet/sfc/ef100_vdpa_ops.c
> index db86c2693950..c6c9458f0e6f 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> @@ -711,12 +711,47 @@ static int ef100_vdpa_suspend(struct vdpa_device *v=
dev)
>         mutex_unlock(&vdpa_nic->lock);
>         return rc;
>  }
> +
> +int ef100_vdpa_map_mcdi_buffer(struct efx_nic *efx)
> +{

The name of this function is confusing, it's actually map buffer for
ef100 netdev mode.

Actually, I wonder why not moving this to init/fini of bar config ops
or if we use aux bus, it should be done during aux driver
probe/remove.

Thanks


> +       struct ef100_nic_data *nic_data =3D efx->nic_data;
> +       struct efx_mcdi_iface *mcdi;
> +       int rc;
> +
> +       /* Update VF's MCDI buffer when switching out of vdpa mode */
> +       rc =3D efx_nic_alloc_buffer(efx, &nic_data->mcdi_buf,
> +                                 MCDI_BUF_LEN, GFP_KERNEL);
> +       if (rc)
> +               return rc;
> +
> +       mcdi =3D efx_mcdi(efx);
> +       spin_lock_bh(&mcdi->iface_lock);
> +       mcdi->mode =3D efx->vdpa_nic->mcdi_mode;
> +       efx->mcdi_buf_mode =3D EFX_BUF_MODE_EF100;
> +       spin_unlock_bh(&mcdi->iface_lock);
> +
> +       return 0;
> +}
> +
>  static void ef100_vdpa_free(struct vdpa_device *vdev)
>  {
>         struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +       int rc;
>         int i;
>
>         if (vdpa_nic) {
> +               if (vdpa_nic->efx->mcdi_buf_mode =3D=3D EFX_BUF_MODE_VDPA=
) {
> +                       /* This will only be called via call to put_devic=
e()
> +                        * on vdpa device creation failure
> +                        */
> +                       rc =3D ef100_vdpa_map_mcdi_buffer(vdpa_nic->efx);
> +                       if (rc) {
> +                               dev_err(&vdev->dev,
> +                                       "map_mcdi_buffer failed, err: %d\=
n",
> +                                       rc);
> +                       }
> +               }
> +
>                 for (i =3D 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
>                         reset_vring(vdpa_nic, i);
>                         if (vdpa_nic->vring[i].vring_ctx)
> diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/m=
cdi.h
> index 2c526d2edeb6..bc4de3b4e6f3 100644
> --- a/drivers/net/ethernet/sfc/mcdi.h
> +++ b/drivers/net/ethernet/sfc/mcdi.h
> @@ -6,6 +6,9 @@
>
>  #ifndef EFX_MCDI_H
>  #define EFX_MCDI_H
> +#include "mcdi_pcol.h"
> +
> +#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
>
>  /**
>   * enum efx_mcdi_state - MCDI request handling state
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet=
/sfc/net_driver.h
> index 948c7a06403a..9cdfeb6ad05a 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -848,6 +848,16 @@ enum efx_xdp_tx_queues_mode {
>
>  struct efx_mae;
>
> +/**
> + * enum efx_buf_alloc_mode - buffer allocation mode
> + * @EFX_BUF_MODE_EF100: buffer setup in ef100 mode
> + * @EFX_BUF_MODE_VDPA: buffer setup in vdpa mode
> + */
> +enum efx_buf_alloc_mode {
> +       EFX_BUF_MODE_EF100,
> +       EFX_BUF_MODE_VDPA
> +};
> +
>  /**
>   * struct efx_nic - an Efx NIC
>   * @name: Device name (net device name or bus id before net device regis=
tered)
> @@ -877,6 +887,7 @@ struct efx_mae;
>   * @irq_rx_mod_step_us: Step size for IRQ moderation for RX event queues
>   * @irq_rx_moderation_us: IRQ moderation time for RX event queues
>   * @msg_enable: Log message enable flags
> + * @mcdi_buf_mode: mcdi buffer allocation mode
>   * @state: Device state number (%STATE_*). Serialised by the rtnl_lock.
>   * @reset_pending: Bitmask for pending resets
>   * @tx_queue: TX DMA queues
> @@ -1045,6 +1056,7 @@ struct efx_nic {
>         u32 msg_enable;
>
>         enum nic_state state;
> +       enum efx_buf_alloc_mode mcdi_buf_mode;
>         unsigned long reset_pending;
>
>         struct efx_channel *channel[EFX_MAX_CHANNELS];
> --
> 2.30.1
>

